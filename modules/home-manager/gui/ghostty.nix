{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      theme = "Catppuccin Macchiato";
      font-size = 11;
      font-family = "JetBrainsMono Nerd Font";
      background-blur = false;

      cursor-style = "bar";
      # cursor-color = "#FFFFFF";
      cursor-style-blink = true;
      cursor-opacity = 0.90;
      adjust-cursor-thickness = 1;
      adjust-cursor-height = "50%";
      cursor-text = "cell-foreground";
      shell-integration-features = "no-cursor";

      window-vsync = false;
      window-decoration = "none";
      window-padding-x = 10;
      window-padding-y = 10;
      window-height = 25;
      window-width = 95;

      focus-follows-mouse = true;
      click-repeat-interval = 0;

      confirm-close-surface = false;

      keybind = [
        "ctrl+c=copy_to_clipboard"
        "ctrl+v=paste_from_clipboard"
        "ctrl+a=select_all"
        "ctrl+shift+c=text:\\x03"
      ];
    };
  };
}
