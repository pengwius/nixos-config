{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../common
    ../features/desktop.nix
  ];

  _module.args.mainUser = "pengwius";
  networking.hostName = "kosiarka";
  networking.networkmanager.enable = true;

  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = lib.mkForce 5;
    # Broadcom STA does not support the cfg80211 API changes in Linux 7.1.
    kernelPackages = pkgs.linuxPackages_6_18;
    kernelModules = [ "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    blacklistedKernelModules = [
      "b43"
      "brcmsmac"
      "bcma"
    ];
  };

  # Preserve the existing Wi-Fi driver; it has known remote-code-execution vulnerabilities.
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-${config.boot.kernelPackages.kernel.version}"
  ];

  hardware = {
    enableAllFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      # The Y50-70's GTX 860M/960M needs the proprietary 580 branch, not 590+.
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      open = false;
      modesetting.enable = true;
      powerManagement.enable = true;
      nvidiaSettings = true;
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    xpadneo.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy.AutoEnable = true;
      };
    };
  };

  users.users.pengwius = {
    description = "pengwius";
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "render"
      "input"
      "networkmanager"
    ];
  };

  environment.systemPackages = with pkgs; [
    heroic
    sl
    hunspell
    hunspellDicts.pl_PL
    vulkan-loader
    vulkan-validation-layers
    gcc
  ];

  programs = {
    # Plasma and GNOME's Seahorse both define SSH askpass.
    ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
    niri.enable = true;
    xwayland.enable = true;
    appimage.enable = true;
    gamemode.enable = true;
    steam.enable = true;
  };

  security.rtkit.enable = true;
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.defaultSession = lib.mkForce "plasma";
    # Keep automatic DPI detection instead of the shared MacBook's forced 2x scale.
    displayManager.sddm.settings.General.GreeterEnvironment =
      lib.mkOverride 40 "QML2_IMPORT_PATH=${config.programs.silentSDDM.package'}/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard";
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    printing.enable = true;
    blueman.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    fstrim.enable = true;
    udisks2.enable = true;
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  home-manager.users.pengwius = {
    # Noctalia must follow Niri, not every graphical session (including Plasma).
    wayland.systemd.target = "niri.service";
    systemd.user.services.niri-window-memory = {
      Unit.PartOf = lib.mkForce [ "niri.service" ];
      Install.WantedBy = lib.mkForce [ "niri.service" ];
    };
    # Let Plasma control its Qt apps; GNOME apps keep the shared GTK theme.
    stylix.targets.kde.enable = false;
    stylix.targets.qt.enable = false;
    home.sessionVariables.QT_QPA_PLATFORMTHEME = lib.mkOverride 40 "kde";

    xdg.configFile."niri/outputs.kdl".text = ''
      output "eDP-1" {
          scale 1.0
      }
    '';
  };

  system.stateVersion = "25.05";
}
