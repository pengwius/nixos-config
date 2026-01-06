{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
    ./rofi.nix
    ./spotify-player.nix
    ./ghostty.nix
    # ./vscode.nix vscode replace with zed
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
    vesktop
    wl-clipboard
    cliphist
    spotify-qt
    librespot
  ];

  gtk = {
    enable = true;
  };
}
