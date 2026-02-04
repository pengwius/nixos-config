{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
    ./rofi.nix
    ./spotify-player.nix
    ./ghostty.nix
    # ./vscode.nix
    ./zed.nix

    ./niri
  ];

  home.file = {
    "Pictures/wallpapers" = {
      source = ../../../home-manager/assets/wallpapers;
    };
  };

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
  };

  xdg.configFile."gtk-3.0/gtk.css".force = true;
}
