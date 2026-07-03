{
  inputs,
  outputs,
  pkgs,
  pkgs-unstable,
  lib,
  enableGui,
  ...
}:

{
  # You can import other home-manager modules here
  imports = [
    inputs.textfox.homeManagerModules.default

    outputs.homeManagerModules.zsh
    outputs.homeManagerModules.neovim
    outputs.homeManagerModules.helix
    outputs.homeManagerModules.fastfetch
    outputs.homeManagerModules.yazi
    outputs.homeManagerModules.btop
    outputs.homeManagerModules.android-sdk
    outputs.homeManagerModules.noctalia
  ]
  ++ lib.optionals enableGui [
    outputs.homeManagerModules.gui
  ];

  home.packages = with pkgs; [
    cava
    cowsay
    cargo
    ncdu
    devenv
    lazydocker
    telegram-desktop
    obs-studio
    # bitwarden-desktop
    file
    wlr-randr
    unzip
    qbittorrent
    gh
    # (symlinkJoin {
    #   name = "moonlight-qt";
    #   paths = [ moonlight-qt ];
    #   buildInputs = [ makeWrapper ];
    #   postBuild = ''
    #     wrapProgram $out/bin/moonlight \
    #       --set QT_QPA_PLATFORM wayland \
    #       --set SDL_VIDEODRIVER wayland
    #   '';
    # })
    python313
    wf-recorder
    thunderbird
    vlc
    ffmpeg
    audacity
    android-studio-tools
    kotlin
    android-tools
    xwayland
    scrcpy
    jetbrains.idea
    nautilus
    parted
    slurp
    showtime
    cups
    libreoffice-qt-fresh
    opencode
    pkgs-unstable.antigravity-cli
    (symlinkJoin {
      name = "sparrow-desktop-wrapped";
      paths = [ sparrow ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        rm $out/bin/sparrow-desktop
        makeWrapper ${sparrow}/bin/sparrow-desktop $out/bin/sparrow-desktop \
          --prefix PATH : ${lib.makeBinPath [ pkgs.xorg.xrandr ]} \
          --set _JAVA_AWT_WM_NONREPARENTING 1 \
          --add-flags "-Djdk.gtk.version=3"

        ln -s $out/bin/sparrow-desktop $out/bin/sparrow
      '';
    })
  ];

  home.file.".config/JetBrains/IdeaIC2025.2/idea64.vmoptions".text = ''
    -Dawt.toolkit.name=WLToolkit
    -Xms128m
    -Xmx2000m
  '';

  home.file = {
    "Pictures/profiles" = {
      source = assets/profiles;
      recursive = true;
    };
    "Pictures/wallpapers" = {
      source = assets/wallpapers;
      recursive = true;
      force = true;
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.git = {
    enable = true;
    settings.user = {
      name = "pengwius";
      email = "pengwius@protonmail.ch";
    };
  };
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.lazygit.enable = true;
  programs.ghostty.enable = true;
  programs.zed-editor.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
