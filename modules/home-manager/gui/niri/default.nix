{ pkgs, ... }:
{
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps.enable = true;
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.gnome-keyring
      ];
      configPackages = [ pkgs.niri ];
    };
  };

  home.packages = with pkgs; [
    swww
    wev
  ];

  stylix.targets.swaylock.enable = false;

  programs.swaylock = {
    enable = true;
    settings = {
      color = "1e1e2e";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      show-failed-attempts = true;

      line-color = "1e1e2e";
      inside-color = "1e1e2e";
      ring-color = "313244"; # Surface0
      
      key-hl-color = "cba6f7"; # Mauve
      bs-hl-color = "f38ba8"; # Red
      separator-color = "1e1e2e";
      
      inside-ver-color = "1e1e2e";
      ring-ver-color = "cba6f7"; # Mauve (Purple)
      text-ver-color = "cdd6f4";
      
      inside-wrong-color = "1e1e2e";
      ring-wrong-color = "f38ba8"; # Red
      text-wrong-color = "cdd6f4";
      
      inside-clear-color = "1e1e2e";
      ring-clear-color = "f5c2e7"; # Pink
      text-clear-color = "cdd6f4";
      
      text-color = "cdd6f4";
      layout-text-color = "cdd6f4";
    };
  };

  # Use native Niri config file instead of NixOS settings
  home.file.".config/niri/config.kdl".source = ../../../../dotfiles/niri/config.kdl;

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
    ];
  };
}
