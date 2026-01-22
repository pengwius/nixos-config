{ pkgs, lib, ... }:
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

  programs.hyprlock = {
    enable = true;
    settings = lib.mkForce {
      general = {
        no_fade_in = true;
        grace = 0;
        disable_loading_bar = true;
      };

      background = [
        {
          path = "${../../../../home-manager/assets/wallpapers/lockscreen.png}";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "250, 60";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "<i>Password...</i>";
          shadow_passes = 2;
        }
      ];

      label = [
        {
          text = "$TIME";
          color = "rgb(202, 211, 245)";
          font_size = 100;
          font_family = "FiraCode Nerd Font";
          position = "0, 100";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
        }
      ];
    };
  };

  # Use native Niri config file instead of NixOS settings
  home.file.".config/niri/config.kdl".source = ../../../../dotfiles/niri/config.kdl;

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
