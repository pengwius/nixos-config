{ outputs, pkgs, mainUser, ... }:
{
  imports = [
    ./boot.nix
    ./users.nix
    ./locale.nix
    ./kmscon-shim.nix
    ./nixos-rebuild.nix
  ];

  nix.package = pkgs.lixPackageSets.latest.lix;

  nix = {
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      warn-dirty = false;
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        mainUser
      ];
      # Automate `nix store --optimise`
      auto-optimise-store = true;
      extra-substituters = [ 
        "https://cache.jel.gay?priority=2"
        "https://noctalia.cachix.org?priority=1"
        "https://zed.cachix.org"
      ];
      extra-trusted-public-keys = [ 
        "cache.jel.gay:B8uhW2bYk/NlZRVagGpPiYO5HzSAe7GoXJVEESf+9cU="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
      ];
    };
  };

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    config.allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    tmux
    fastfetch
    hyfetch
    neovim
    unzip
    wget
    direnv
    btop
    home-manager
    lucida-downloader
    podman-compose
    zerotierone
    # Diagnostyka sieci (hotspot / ZeroTier / Minecraft / Discord):
    mtr
    nmap
    tcpdump
    traceroute
    dnsutils
    iperf3
    # openjdk17
    # gradle
    # android-tools
    # android-studio-tools
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  services.zerotierone = {
    enable = true;
  };

  environment.variables = {
    JAVA_HOME = "${pkgs.openjdk17}/lib/openjdk";
    JDK_HOME = "${pkgs.openjdk17}/lib/openjdk";
    GRADLE_HOME = "${pkgs.gradle}";

    ANDROID_HOME = "/home/${mainUser}/Android/Sdk";
    ANDROID_SDK_ROOT = "/home/${mainUser}/Android/Sdk";
    ANDROID_NDK_ROOT = "/home/${mainUser}/Android/Sdk/ndk/29.0.14033849";
  };

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  # networking.hosts = {
  #   "127.0.0.1" = [
  #     "x.com"
  #     "www.x.com"
  #   ];
  #   "::1" = [
  #     "x.com"
  #     "www.x.com"
  #   ];
  # };

  networking.firewall.allowedUDPPorts = [ 9993 ];

  services.logind.settings.Login.HandlePowerKey = "suspend";

  services.tailscale.enable = true;
}
