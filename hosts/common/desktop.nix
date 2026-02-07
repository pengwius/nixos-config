# Module including all shared stuff for desktop GUI system compatible.
{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [ inputs.silentSDDM.nixosModules.default ];

  environment.systemPackages = with pkgs; [
    brightnessctl
    pavucontrol
    playerctl
    (symlinkJoin {
      name = "trezor-suite";
      paths = [ trezor-suite ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/trezor-suite \
          --add-flags "--ozone-platform-hint=auto --enable-features=UseOzonePlatform --ozone-platform=wayland"
      '';
    })
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 48;
    };
    opacity = {
      popups = 0.98;
    };
    fonts = {
      serif = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Ret";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono Ret";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  programs.silentSDDM = {
    enable = true;
    theme = "default";
    backgrounds = {
      lockscreen = ../../home-manager/assets/wallpapers/lockscreen.png;
    };
    settings = {
      LoginScreen = {
        background = "lockscreen.png";
      };
      LockScreen = {
        background = "lockscreen.png";
      };
    };
    profileIcons = {
      pengwius = ../../home-manager/assets/wallpapers/1.png;
    };
  };

  services = {
    upower.enable = true;
    trezord.enable = true;
    displayManager.sddm = {
      enableHidpi = true;
      extraPackages = [ pkgs.bibata-cursors ];
      settings.General.GreeterEnvironment = lib.mkForce "QT_SCALE_FACTOR=2,QML2_IMPORT_PATH=${config.programs.silentSDDM.package'}/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard";
    };
  };

  security.pam.services.swaylock = { };
}
