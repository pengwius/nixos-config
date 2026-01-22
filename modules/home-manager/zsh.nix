{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "direnv"
      ];
      theme = "robbyrussell";
    };
    shellAliases = {
      ff = "fastfetch";
      cd = "z";
      ls = "eza";
      lg = "lazygit";
      vi = "nvim";
      zed = "zeditor";
    };

    initExtra = ''
      open() {
        nautilus "$@" > /dev/null 2>&1 &!
      }
    '';
    history = {
      expireDuplicatesFirst = true;
      save = 1000;
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
