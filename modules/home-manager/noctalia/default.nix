{
  inputs,
  ...
}:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      bar = {
        order = [
          "margin"
          "widgets"
        ];
        margin = {
          enabled = true;
          background_opacity = 0.4999999888241291;
          center = [
            "clock"
            "cat"
          ];
          contact_shadow = true;
          end = [
            "media"
            "tray"
            "notifications"
            "session"
          ];
          margin_ends = 144;
          start = [
            "control-center"
            "launcher"
            "workspaces"
          ];
        };
        widgets = {
          enabled = true;
          auto_hide = true;
          background_opacity = 0.5;
          center = [
            "bluetooth"
            "clipboard"
            "network"
            "volume"
            "brightness"
            "battery"
          ];
          end = [ ];
          margin_ends = 320;
          position = "right";
          reserve_space = false;
          start = [ ];
          widget_spacing = 10;
        };
      };

      location = {
        address = "Warszawa, Poland";
      };

      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = [
          "lockscreen-login-box@DP-1"
          "lockscreen-login-box@eDP-1"
          "lockscreen-widget-0000000000000001"
          "lockscreen-widget-0000000000000002"
        ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = {
          "lockscreen-login-box@DP-1" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 1720.0;
            cy = 1317.0;
            output = "DP-1";
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              input_opacity = 1.0;
              input_radius = 6.0;
              show_login_button = true;
            };
          };
          "lockscreen-login-box@eDP-1" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 732.0;
            cy = 791.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              input_opacity = 1.0;
              input_radius = 6.0;
              show_login_button = true;
            };
          };
          "lockscreen-widget-0000000000000001" = {
            box_height = 144.0;
            box_width = 320.0;
            cx = 1720.0;
            cy = 704.0;
            output = "DP-1";
            rotation = 0.0;
            type = "clock";
            settings = {
              background = false;
              clock_style = "digital";
              shadow = false;
            };
          };
          "lockscreen-widget-0000000000000002" = {
            box_height = 96.0;
            box_width = 240.0;
            cx = 731.5;
            cy = 441.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "clock";
            settings = {
              background = false;
              shadow = false;
            };
          };
        };
      };

      notification = {
        background_opacity = 0.4999999888241291;
      };

      osd = {
        background_opacity = 0.5;
      };

      plugins = {
        enabled = [
          "noctalia/bongocat"
          "noctalia/translator"
          "noctalia/example"
          "noctalia/timer"
        ];
      };

      shell = {
        password_style = "random";
        screen_time_enabled = true;
        settings_show_advanced = true;
        panel = {
          launcher_placement = "attached";
          launcher_session_search = true;
        };
        screen_corners = {
          enabled = true;
          size = 40;
        };
      };

      theme = {
        builtin = "Dracula";
        community_palette = "Shien";
        mode = "dark";
        source = "builtin";
        wallpaper_scheme = "m3-content";
      };

      wallpaper = {
        enabled = true;
        default = {
          path = "/home/pengwius/Pictures/wallpapers/purple2.jpg";
        };
        last = {
          path = "/home/pengwius/Pictures/wallpapers/purple2.jpg";
        };
      };

      widget = {
        cat = {
          audio_spectrum = true;
          tappy_mode = true;
          type = "noctalia/bongocat:cat";
        };
        clock = {
          format = "%H:%M:%S, %d.%m";
        };
        control-center = {
          anchor = true;
          custom_image_colorize = true;
          use_distro_logo = true;
        };
        network = {
          show_label = false;
        };
        tray = {
          drawer = true;
        };
      };
    };
  };
}
