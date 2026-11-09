{
  config,
  lib,
  pkgs,
  ...
}:
let
  palette = config.programs.noctalia.customPalettes.material-expressive.dark;
  materialCss = ''
    @define-color accent_bg_color ${palette.mPrimary};
    @define-color accent_fg_color ${palette.mOnPrimary};
    @define-color accent_color ${palette.mSecondary};
    @define-color window_bg_color ${palette.mSurface};
    @define-color window_fg_color ${palette.mOnSurface};
    @define-color view_bg_color ${palette.mSurface};
    @define-color view_fg_color ${palette.mOnSurface};
    @define-color headerbar_bg_color ${palette.mSurface};
    @define-color headerbar_fg_color ${palette.mOnSurface};
    @define-color headerbar_backdrop_color ${palette.mSurface};
    @define-color sidebar_bg_color ${palette.mSurfaceVariant};
    @define-color sidebar_fg_color ${palette.mOnSurfaceVariant};
    @define-color sidebar_backdrop_color ${palette.mSurfaceVariant};
    @define-color card_bg_color ${palette.mSurfaceVariant};
    @define-color card_fg_color ${palette.mOnSurface};
    @define-color popover_bg_color ${palette.mSurfaceVariant};
    @define-color popover_fg_color ${palette.mOnSurface};
    @define-color dialog_bg_color ${palette.mSurfaceVariant};
    @define-color dialog_fg_color ${palette.mOnSurface};
    @define-color destructive_bg_color ${palette.mError};
    @define-color destructive_fg_color ${palette.mOnError};
    @define-color destructive_color ${palette.mError};
    @define-color theme_selected_bg_color ${palette.mPrimary};
    @define-color theme_selected_fg_color ${palette.mOnPrimary};

    button { border-radius: 999px; }
    entry, searchentry, spinbutton { border-radius: 20px; }
    popover > contents { border-radius: 24px; }
    list.boxed-list { border-radius: 20px; }
    .navigation-sidebar > row { border-radius: 16px; }
  '';
in
{
  stylix.targets.gtk.enable = false;
  stylix.targets.gnome.enable = false;

  gtk = {
    enable = true;
    colorScheme = "dark";
    cursorTheme = {
      inherit (config.home.pointerCursor) package name size;
    };
    font = {
      inherit (config.stylix.fonts.sansSerif) name package;
      size = 11;
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    gtk3.extraCss = materialCss;
    # Keep libadwaita's layout and accessibility; override its supported color variables.
    gtk4 = {
      theme = null;
      colorScheme = null;
      extraCss = materialCss + ''
        :root {
          --accent-bg-color: ${palette.mPrimary};
          --accent-fg-color: ${palette.mOnPrimary};
          --accent-color: ${palette.mSecondary};
          --window-bg-color: ${palette.mSurface};
          --window-fg-color: ${palette.mOnSurface};
          --view-bg-color: ${palette.mSurface};
          --view-fg-color: ${palette.mOnSurface};
          --headerbar-bg-color: ${palette.mSurface};
          --headerbar-fg-color: ${palette.mOnSurface};
          --headerbar-backdrop-color: ${palette.mSurface};
          --sidebar-bg-color: ${palette.mSurfaceVariant};
          --sidebar-fg-color: ${palette.mOnSurfaceVariant};
          --sidebar-backdrop-color: ${palette.mSurfaceVariant};
          --card-bg-color: ${palette.mSurfaceVariant};
          --card-fg-color: ${palette.mOnSurface};
          --popover-bg-color: ${palette.mSurfaceVariant};
          --popover-fg-color: ${palette.mOnSurface};
          --dialog-bg-color: ${palette.mSurfaceVariant};
          --dialog-fg-color: ${palette.mOnSurface};
          --destructive-bg-color: ${palette.mError};
          --destructive-fg-color: ${palette.mOnError};
          --destructive-color: ${palette.mError};
        }
      '';
    };
  };

  xdg.configFile."gtk-3.0/gtk.css".force = true;
  xdg.configFile."gtk-4.0/gtk.css".force = true;

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    accent-color = "purple";
    gtk-theme = "adw-gtk3-dark";
    icon-theme = "Papirus-Dark";
    cursor-theme = config.home.pointerCursor.name;
    cursor-size = config.home.pointerCursor.size;
    font-name = "${config.gtk.font.name} 11";
    document-font-name = "${config.stylix.fonts.serif.name} 11";
    monospace-font-name = "${config.stylix.fonts.monospace.name} 11";
  };

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
    "application/pdf" = [ "org.gnome.Papers.desktop" ];
    "text/plain" = [ "org.gnome.TextEditor.desktop" ];
    "text/markdown" = [ "org.gnome.TextEditor.desktop" ];
  }
  // lib.genAttrs [
    "image/png"
    "image/jpeg"
    "image/webp"
    "image/gif"
    "image/avif"
    "image/svg+xml"
  ] (_: [ "org.gnome.Loupe.desktop" ])
  // lib.genAttrs [ "video/mp4" "video/webm" "video/x-matroska" "video/quicktime" ] (_: [
    "org.gnome.Showtime.desktop"
  ])
  // lib.genAttrs [ "audio/mpeg" "audio/flac" "audio/ogg" "audio/x-wav" ] (_: [
    "org.gnome.Decibels.desktop"
  ])
  // lib.genAttrs [
    "application/zip"
    "application/x-7z-compressed"
    "application/x-tar"
    "application/gzip"
  ] (_: [ "org.gnome.FileRoller.desktop" ]);
}
