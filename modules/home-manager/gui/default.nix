{
  pkgs,
  pkgs-unstable,
  lib,
  osConfig,
  ...
}:
{
  imports = [
    ./firefox.nix
    ./gnome.nix
    ./rofi.nix
    ./spotify-player.nix
    ./ghostty.nix
    # ./vscode.nix
    ./zed.nix
    ./vesktop.nix
    #./gram.nix
    # ./sparrow.nix

    ./niri
  ];

  home.packages =
    with pkgs;
    [
      signal-desktop
      # (symlinkJoin {
      #   name = "vesktop";
      #   paths = [ vesktop ];
      #   buildInputs = [ makeWrapper ];
      #   postBuild = ''
      #     wrapProgram $out/bin/vesktop \
      #       --add-flags "--ozone-platform-hint=auto --enable-features=UseOzonePlatform --ozone-platform=wayland"
      #   '';
      # })
      wl-clipboard
      pkgs-unstable.spotify-qt
      librespot
      easyeffects
    ]
    ++
      lib.optionals
        (
          !(builtins.elem osConfig.networking.hostName [
            "kosiarka"
            "gruchot"
          ])
        )
        [
          materialfy
          pixelgram
        ];

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  home.sessionVariables = {
    QS_ICON_THEME = "Papirus-Dark";
    QT_QPA_PLATFORMTHEME = lib.mkForce "gtk3";
  };
}
