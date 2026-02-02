{ pkgs, lib, ... }:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "make"
      "catppuccin"
      "material-icon-theme"
      "wakatime"
      "kdl"
      "xml"
      "kotlin"
    ];

    userSettings = lib.mkForce {
      base_keymap = "VSCode";
      theme = "Catppuccin Mocha";
      icon_theme = "Material Icon Theme";
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      vim_mode = true;
      ui_font_size = 16;
      buffer_font_size = 14;
      project_panel = {
        dock = "left";
      };
      assistant = {
        dock = "left";
        version = "2";
        enabled = true;
      };
      git = {
        inline_blame = {
          enabled = true;
        };
      };
    };

    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "super-[" = "editor::Outdent";
          "super-]" = "editor::Indent";
          "ctrl-." = "terminal_panel::ToggleFocus";
        };
      }
      {
        context = "Terminal";
        bindings = {
          "ctrl-." = "terminal_panel::ToggleFocus";
        };
      }
    ];
  };
}
