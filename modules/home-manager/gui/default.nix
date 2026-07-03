{ pkgs, lib, ... }:
{
  imports = [
    ./firefox.nix
    ./rofi.nix
    ./spotify-player.nix
    ./ghostty.nix
    ./vscode.nix
    ./zed.nix
    #./gram.nix
    # ./sparrow.nix

    ./niri
  ];

  home.packages = with pkgs; [
    signal-desktop
    (symlinkJoin {
      name = "vesktop";
      paths = [ vesktop ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/vesktop \
          --add-flags "--ozone-platform-hint=auto --enable-features=UseOzonePlatform --ozone-platform=wayland"
      '';
    })
    wl-clipboard
    spotify-qt
    librespot
    easyeffects
  ];

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  home.sessionVariables = {
    QS_ICON_THEME = "Papirus-Dark";
    QT_QPA_PLATFORMTHEME = lib.mkForce "gtk3";
    #QT_QPA_PLATFORMTHEME = "kde";
  };

  xdg.configFile."gtk-3.0/gtk.css".force = true;
}
