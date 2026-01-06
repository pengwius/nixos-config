# Module including all shared stuff for desktop GUI system compatible.
{ pkgs, ... }:
{

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
    sparrow
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    opacity = {
      popups = 0.9;
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

  services = {
    trezord.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${pkgs.niri}/bin/niri-session";
          user = "greeter";
        };
      };
    };
  };

  security.pam.services.swaylock = {};
}
