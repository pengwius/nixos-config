{
  description = "Pengwius NixOS configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # MNW
    mnw.url = "github:Gerg-L/mnw";

    # Stylix
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NUR
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Textfox
    textfox = {
      url = "github:adriankarlen/textfox";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-unstable,
      home-manager,
      nixos-wsl,
      stylix,
      nur,
      silentSDDM,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoints
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # Asahi Linux
        asahi = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            pkgs-stable = import nixpkgs-stable {
              system = "aarch64-linux";
              config.allowUnfree = true;
            };
            pkgs-unstable = import nixpkgs-unstable {
              system = "aarch64-linux";
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/asahi/configuration.nix
            stylix.nixosModules.stylix
            nur.modules.nixos.default
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs outputs;
                  # Desktop computer, so we need GUI stuff.
                  enableGui = true;

                  pkgs-stable = import nixpkgs-stable {
                    system = "aarch64-linux";
                    config.allowUnfree = true;
                  };
                  pkgs-unstable = import nixpkgs-unstable {
                    system = "aarch64-linux";
                    config.allowUnfree = true;
                  };
                };
                backupFileExtension = "backup";
              };

              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.users.pengwius = import ./home-manager/home.nix;
            }
          ];
        };

        # WSL
        wsl = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            pkgs-unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/wsl/configuration.nix
            home-manager.nixosModules.home-manager
            nixos-wsl.nixosModules.default
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs outputs;
                  enableGui = false;
                  pkgs-unstable = import nixpkgs-unstable {
                    system = "x86_64-linux";
                    config.allowUnfree = true;
                  };
                };
                backupFileExtension = ".backn";
              };

              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.users.nixos = import ./home-manager/home.nix;
            }
          ];
        };
      };
    };
}
