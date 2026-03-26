{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  noctaliaSettings = {
    controlCenter = {
      position = "close_to_bar_button";
      diskPath = "/";
      shortcuts = {
        left = [
          { id = "Network"; }
          { id = "Bluetooth"; }
          { id = "WallpaperSelector"; }
          { id = "NoctaliaPerformance"; }
        ];
        right = [
          { id = "Notifications"; }
          { id = "PowerProfile"; }
          { id = "KeepAwake"; }
          { id = "NightLight"; }
        ];
      };
      cards = [
        { enabled = true; id = "profile-card"; }
        { enabled = true; id = "shortcuts-card"; }
        { enabled = true; id = "audio-card"; }
        { enabled = false; id = "brightness-card"; }
        { enabled = false; id = "weather-card"; }
        { enabled = true; id = "media-sysmon-card"; }
        { enabled = true; id = "clipboard-card"; }
      ];
    };
    bar = {
      density = "default";
      showCapsule = true;
      outerCorners = true;
      marginVertical = 8;
      marginHorizontal = 8;

      widgets = {
        left = [
          {
            id = "ControlCenter";
            colorizeDistroLogo = false;
            colorizeSystemIcon = "primary";
            enableColorization = true;
            icon = "noctalia";
            iconScale = 1.0;
            useDistroLogo = true;
          }
          {
            id = "Workspace";
            characterCount = 2;
            colorizeIcons = true;
            emptyColor = "none";
            enableScrollWheel = true;
            focusedColor = "primary";
            followFocusedScreen = false;
            fontWeight = "bold";
            groupedBorderOpacity = 1;
            hideUnoccupied = false;
            iconScale = 0.8;
            labelMode = "index";
            occupiedColor = "none";
            pillSize = 0.7;
            showApplications = false;
            showApplicationsHover = false;
            showBadge = true;
            showLabelsOnlyWhenOccupied = false;
            unfocusedIconsOpacity = 1;
          }
        ];
        center = [
          { id = "plugin:catwalk"; }
          {
            id = "Clock";
            clockColor = "primary";
            customFont = "";
            formatHorizontal = "HH:mm ddd, MMM dd";
            formatVertical = "HH mm - dd MM";
            tooltipFormat = "HH:mm ddd, MMM dd";
            useCustomFont = false;
          }
        ];
        right = [
          {
            id = "Tray";
            drawerEnabled = true;
            blacklist = [];
            chevronColor = "primary";
            colorizeIcons = false;
            hidePassive = false;
            pinned = [];
          }
          {
            id = "Clipboard";
            iconColor = "primary";
          }
          {
            id = "MediaMini";
            compactMode = false;
            hideMode = "hidden";
            hideWhenIdle = false;
            maxWidth = 160;
            panelShowAlbumArt = true;
            scrollingMode = "hover";
            showAlbumArt = true;
            showArtistFirst = true;
            showProgressRing = true;
            showVisualizer = false;
            textColor = "primary";
            useFixedWidth = false;
            visualizerType = "linear";
          }
          {
            id = "Brightness";
            iconColor = "primary";
            textColor = "primary";
          }
          {
            id = "Volume";
            displayMode = "onhover";
            iconColor = "primary";
            middleClickCommand = "pwvucontrol || pavucontrol";
            textColor = "primary";
          }
          {
            id = "NotificationHistory";
            hideWhenZero = false;
            hideWhenZeroUnread = false;
            iconColor = "primary";
            showUnreadBadge = true;
            unreadBadgeColor = "primary";
          }
          {
            id = "Battery";
            deviceNativePath = "__default__";
            displayMode = "icon";
            iconColor = "primary";
            textColor = "primary";
            hideIfIdle = false;
            hideIfNotDetected = true;
            showNoctaliaPerformance = false;
            showPowerProfiles = false;
          }
          { id = "plugin:tailscale"; }
          { id = "plugin:privacy-indicator"; }
        ];
      };
    };

    general = {
      avatarImage = "${config.home.homeDirectory}/Pictures/profiles/avatar.jpg";
      showScreenCorners = true;
    };

    location = {
      name = "Nowy Sącz, Poland";
    };

    notifications = {
      density = "compact";
    };

    wallpaper = {
      directory = "${config.home.homeDirectory}/Pictures/wallpapers";
    };

    lockscreen = {
      randomizePasswordIcons = true;
      showMedia = false;
    };

    dock = {
      enabled = false;
    };
  };

  jsonSettingsFile = pkgs.writeText "noctalia-initial-settings.json" (builtins.toJSON noctaliaSettings);

  purpleDreamScheme = {
    dark = {
      mPrimary = "#d8b4fe"; # Soft Purple
      mOnPrimary = "#3f1d63";
      mSecondary = "#c084fc"; # Medium Purple
      mOnSecondary = "#1a0517";
      mTertiary = "#f472b6"; # Soft Pink
      mOnTertiary = "#4d0033";
      mError = "#ffb3c6";
      mOnError = "#4d0033";
      mSurface = "#19002e"; # Deep Purple Base
      mOnSurface = "#eadcf5";
      mSurfaceVariant = "#351a4d";
      mOnSurfaceVariant = "#d8b4fe";
      mOutline = "#c084fc";
      mShadow = "#0f001a";
      mHover = "#7e22ce";
      mOnHover = "#eadcf5";
      terminal = {
        foreground = "#eadcf5";
        background = "#19002e";
        normal = {
          black = "#19002e";
          red = "#ffb3c6";
          green = "#c084fc";
          yellow = "#f472b6";
          blue = "#7e22ce";
          magenta = "#d8b4fe";
          cyan = "#eadcf5";
          white = "#eadcf5";
        };
        bright = {
          black = "#351a4d";
          red = "#ffc6d9";
          green = "#d8b4fe";
          yellow = "#f9a8d4";
          blue = "#9333ea";
          magenta = "#e9d5ff";
          cyan = "#f3e8ff";
          white = "#ffffff";
        };
        cursor = "#d8b4fe";
        cursorText = "#19002e";
        selectionFg = "#d8b4fe";
        selectionBg = "#351a4d";
      };
    };
    light = {
      mPrimary = "#d8b4fe";
      mOnPrimary = "#3f1d63";
      mSecondary = "#c084fc";
      mOnSecondary = "#1a0517";
      mTertiary = "#f472b6";
      mOnTertiary = "#4d0033";
      mError = "#ffb3c6";
      mOnError = "#4d0033";
      mSurface = "#19002e";
      mOnSurface = "#eadcf5";
      mSurfaceVariant = "#351a4d";
      mOnSurfaceVariant = "#d8b4fe";
      mOutline = "#c084fc";
      mShadow = "#0f001a";
      mHover = "#7e22ce";
      mOnHover = "#eadcf5";
      terminal = {
        foreground = "#eadcf5";
        background = "#19002e";
        normal = {
          black = "#19002e";
          red = "#ffb3c6";
          green = "#c084fc";
          yellow = "#f472b6";
          blue = "#7e22ce";
          magenta = "#d8b4fe";
          cyan = "#eadcf5";
          white = "#eadcf5";
        };
        bright = {
          black = "#351a4d";
          red = "#ffc6d9";
          green = "#d8b4fe";
          yellow = "#f9a8d4";
          blue = "#9333ea";
          magenta = "#e9d5ff";
          cyan = "#f3e8ff";
          white = "#ffffff";
        };
        cursor = "#d8b4fe";
        cursorText = "#19002e";
        selectionFg = "#d8b4fe";
        selectionBg = "#351a4d";
      };
    };
  };

  jsonSchemeFile = pkgs.writeText "purple-dream.json" (builtins.toJSON purpleDreamScheme);
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;
  };

  home.activation.createNoctaliaConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    configDir="${config.xdg.configHome}/noctalia"
    configFile="$configDir/settings.json"
    schemeDir="$configDir/colorschemes/Purple Dream"
    schemeFile="$schemeDir/Purple Dream.json"

    if [ ! -f "$configFile" ]; then
      echo "Creating initial Noctalia configuration..."
      mkdir -p "$configDir"
      cat "${jsonSettingsFile}" > "$configFile"
      chmod 644 "$configFile"
    else
      echo "Noctalia configuration already exists, skipping initialization."
    fi

    echo "Creating/Updating 'Purple Dream' color scheme..."
    mkdir -p "$schemeDir"
    cat "${jsonSchemeFile}" > "$schemeFile"
    chmod 644 "$schemeFile"
  '';
}
