{
  inputs,
  outputs,
  pkgs,
  lib,
  config,
  enableGui,
  ...
}:

{
  # You can import other home-manager modules here
  imports = [
    inputs.textfox.homeManagerModules.default

    outputs.homeManagerModules.zsh
    outputs.homeManagerModules.neovim
    outputs.homeManagerModules.fastfetch
    outputs.homeManagerModules.yazi
    outputs.homeManagerModules.btop
    outputs.homeManagerModules.android-sdk
  ]
  ++ lib.optionals enableGui [
    outputs.homeManagerModules.gui
  ];

  home.packages = with pkgs; [
    cava
    cowsay
    cargo
    talosctl
    talhelper
    kubectl
    kubernetes-helm
    hcloud
    k9s
    kind
    ncdu
    sops
    age
    devenv
    lazydocker
    telegram-desktop
    obs-studio
    bitwarden-desktop
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
    #wl-screenrec
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
  ];

  home.file.".config/JetBrains/IdeaIC2025.2/idea64.vmoptions".text = ''
    -Dawt.toolkit.name=WLToolkit
    -Xms128m
    -Xmx2000m
  '';

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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
