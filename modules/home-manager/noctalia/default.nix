{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [ inputs.noctalia.homeModules.default ];

  stylix.targets.noctalia.enable = false;
  fonts.fontconfig.enable = true;

  home.file."${config.xdg.stateHome}/noctalia/settings.toml".text = "";

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    customPalettes.material-expressive.dark = {
      mPrimary = "#ac8bf9";
      mOnPrimary = "#1e1630";
      mSecondary = "#d8bdf5";
      mOnSecondary = "#322343";
      mTertiary = "#9ddacb";
      mOnTertiary = "#10382f";
      mError = "#ffb4ab";
      mOnError = "#690005";
      mSurface = "#30283e";
      mOnSurface = "#eee5f5";
      mSurfaceVariant = "#463b58";
      mOnSurfaceVariant = "#cec2da";
      mOutline = "#b3a1c9";
      mShadow = "#000000";
      mHover = "#5a4a70";
      mOnHover = "#f2e8ff";
      # Noctalia requires terminal colors even for shell-only custom palettes.
      terminal = {
        foreground = "#eee5f5";
        background = "#30283e";
        cursor = "#ac8bf9";
        cursorText = "#1e1630";
        selectionFg = "#f2e8ff";
        selectionBg = "#4d3b65";
        normal = {
          black = "#38303f";
          red = "#ffb4ab";
          green = "#afd3a7";
          yellow = "#e8cf9b";
          blue = "#b8c4ff";
          magenta = "#d8bdf5";
          cyan = "#9ddacb";
          white = "#eee5f5";
        };
        bright = {
          black = "#b3a1c9";
          red = "#ffd2cb";
          green = "#c8edbf";
          yellow = "#ffe4b2";
          blue = "#d4dcff";
          magenta = "#ecd6ff";
          cyan = "#b8f4e5";
          white = "#fff7ff";
        };
      };
    };

    settings = {
      bar = {
        order = [ "main" ];
        main = {
          position = "left";
          thickness = 48;
          background_opacity = 1.0;
          radius = 0;
          radius_top_right = 28;
          radius_bottom_right = 28;
          margin_ends = 0;
          margin_edge = 0;
          padding = 12;
          widget_spacing = 6;
          concave_edge_corners = true;
          shadow = false;
          auto_hide = false;
          reserve_space = true;
          capsule = true;
          capsule_fill = "surface_variant";
          capsule_foreground = "on_surface_variant";
          capsule_padding = 10;
          capsule_thickness = 0.75;
          start = [
            "control-center"
            "launcher"
            "workspaces"
          ];
          center = [
            "cat"
            "cat-gap"
            "clock"
            "date-gap"
            "date"
          ];
          end = [
            "media"
            "network"
            "volume"
            "clipboard"
            "tray"
            "notifications"
            "battery"
            "session"
          ];
        };
      };

      calendar = {
        enabled = true;
        account.home_nextcloud.type = "google";
      };

      desktop_widgets = {
        schema_version = 2;
        widget_order = [ ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = { };
      };

      dock.background_opacity = 1.0;
      location.address = "Nowy Sącz, Poland";

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
            box_height = 103.0;
            box_width = 400.0;
            cx = 1720.0;
            cy = 1317.0;
            output = "DP-1";
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface";
              background_opacity = 1.0;
              background_radius = 0.0;
              center_password_text = true;
              input_opacity = 1.0;
              input_radius = 0.0;
              layout = "compact";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_session_buttons = true;
              show_weather = true;
            };
          };
          "lockscreen-login-box@eDP-1" = {
            box_height = 103.0;
            box_width = 400.0;
            cx = 731.5;
            cy = 789.5;
            output = "eDP-1";
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface";
              background_opacity = 1.0;
              background_radius = 0.0;
              center_password_text = true;
              input_opacity = 1.0;
              input_radius = 0.0;
              layout = "compact";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = false;
              show_session_buttons = true;
              show_weather = true;
            };
          };
          lockscreen-widget-0000000000000001 = {
            box_height = 144.0;
            box_width = 480.0;
            cx = 1720.0;
            cy = 704.0;
            output = "DP-1";
            rotation = 0.0;
            type = "clock";
            settings = {
              background = false;
              clock_style = "digital";
              format = "%H:%M";
              center_text = true;
              shadow = false;
            };
          };
          lockscreen-widget-0000000000000002 = {
            box_height = 96.0;
            box_width = 512.0;
            cx = 731.5;
            cy = 457.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "clock";
            settings = {
              background = false;
              clock_style = "digital";
              format = "%H:%M";
              center_text = true;
              font_family = "FiraCode Nerd Font Mono";
              shadow = false;
            };
          };
        };
      };

      notification = {
        background_opacity = 1.0;
        border = false;
        offset_x = 24;
        offset_y = 16;
      };
      osd = {
        background_opacity = 1.0;
        border = false;
        position = "bottom_center";
        offset_y = 32;
      };

      plugins.enabled = [
        "noctalia/bongocat"
        "noctalia/translator"
        "noctalia/example"
        "noctalia/timer"
      ];

      shell = {
        app_icon_color = "primary";
        font_family = config.stylix.fonts.sansSerif.name;
        corner_radius_scale = 2.0;
        button_borders = false;
        input_borders = false;
        popup_borders = false;
        card_borders = false;
        animation = {
          enabled = true;
          speed = 0.9;
        };
        shadow.alpha = 0.25;
        password_style = "random";
        time_format = "%H:%M:%S";
        screen_time_enabled = true;
        settings_show_advanced = true;
        launcher.providers = {
          emoji.global = false;
          session.global = true;
          wallpaper.global = false;
          windows.global = false;
        };
        panel = {
          transparency_mode = "solid";
          borders = false;
          shadow = true;
          floating_offset = 0;
          launcher_placement = "floating";
          launcher_position = "center";
          clipboard_placement = "attached";
          control_center_placement = "attached";
          wallpaper_placement = "attached";
          session_placement = "attached";
          open_near_click_launcher = false;
          open_near_click_clipboard = true;
          open_near_click_control_center = true;
          open_near_click_wallpaper = true;
          open_near_click_session = true;
        };
        session = {
          grid = true;
          grid_columns = 1;
        };
        screen_corners = {
          enabled = true;
          size = 28;
        };
      };

      theme = {
        custom_palette = "material-expressive";
        mode = "dark";
        source = "custom";
      };

      wallpaper = {
        transition_on_startup = true;
        default.path = "${config.home.homeDirectory}/Pictures/wallpapers/purple2.jpg";
        last.path = "${config.home.homeDirectory}/Pictures/wallpapers/purple2.jpg";
      };

      widget = {
        cat = {
          capsule = false;
          color = "primary";
          audio_spectrum = true;
          tappy_mode = true;
          type = "noctalia/bongocat:cat";
        };
        cat-gap = {
          type = "spacer";
          length = 12;
          capsule = false;
          interactive = false;
        };
        date-gap = {
          type = "spacer";
          length = 12;
          capsule = false;
          interactive = false;
        };
        clock = {
          format = "%H:%M";
          vertical_format = "%H\n%M";
          tooltip_format = "%A, %d.%m.%Y";
          font_weight = 700;
          capsule_fill = "primary";
          capsule_foreground = "on_primary";
          capsule_padding = 10;
        };
        date = {
          type = "clock";
          format = "%a, %d.%m";
          vertical_format = "%a\n%d.%m";
          tooltip_format = "%A, %d.%m.%Y";
          font_weight = 600;
          scale = 0.9;
          capsule = false;
          color = "on_surface";
        };
        control-center = {
          anchor = true;
          capsule_fill = "primary";
          capsule_foreground = "on_primary";
          scale = 1.1;
          capsule_padding = 8;
          custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          custom_image_colorize = true;
        };
        workspaces = {
          capsule = true;
          capsule_padding = 8;
          style = "regular";
          display = "none";
          pill_scale = 1.0;
          active_pill_size = 2.0;
          inactive_pill_size = 1.0;
          font_weight = 600;
          focused_color = "primary";
          occupied_color = "surface";
          empty_color = "surface";
        };
        launcher = {
          capsule_fill = "secondary";
          capsule_foreground = "on_secondary";
        };
        media = {
          art_size = 28;
          capsule_padding = 6;
          hide_when_no_media = true;
        };
        network = {
          show_label = false;
        };
        volume.capsule_padding = 8;
        battery = {
          display_mode = "glyph";
          show_label = true;
          label_content = "percent";
          scale = 0.9;
          capsule_padding = 8;
          capsule_foreground = "tertiary";
        };
        session = {
          capsule_fill = "secondary";
          capsule_foreground = "on_secondary";
        };
        tray = {
          drawer = true;
        };
      };
    };
  };
}
