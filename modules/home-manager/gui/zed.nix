{
  pkgs,
  lib,
  ...
}:

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
      lsp = {
        rust-analyzer = {
          binary = {
            path = "/run/current-system/sw/bin/false";
            arguments = [ ];
          };
        };
        vtsls = {
          binary = {
            path = "/run/current-system/sw/bin/false";
            arguments = [ ];
          };
        };
        tailwindcss-language-server = {
          binary = {
            path = "/run/current-system/sw/bin/false";
            arguments = [ ];
          };
        };
        package-version-server = {
          binary = {
            path = "/run/current-system/sw/bin/false";
            arguments = [ ];
          };
        };
        eslint = {
          binary = {
            path = "/run/current-system/sw/bin/false";
            arguments = [ ];
          };
        };
        json-language-server = {
          binary = {
            path = "/run/current-system/sw/bin/false";
            arguments = [ ];
          };
        };
        vscode-css-language-server = {
          binary = {
            path = "/run/current-system/sw/bin/false";
            arguments = [ ];
          };
        };
      };
      languages = {
        Rust = {
          language_servers = [ ];
        };
        TypeScript = {
          language_servers = [ ];
        };
        JavaScript = {
          language_servers = [ ];
        };
        Vite = {
          language_servers = [ ];
        };
        React = {
          language_servers = [ ];
        };
        Tauri = {
          language_servers = [ ];
        };
      };
    };

    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "ctrl-c" = "editor::Copy";
          "ctrl-v" = "editor::Paste";
          "ctrl-x" = "editor::Cut";
          "ctrl-z" = "editor::Undo";
          "ctrl-y" = "editor::Redo";
          "ctrl-a" = "editor::SelectAll";
          "super-[" = "editor::Outdent";
          "super-]" = "editor::Indent";
          "ctrl-." = "terminal_panel::ToggleFocus";
        };
      }
      {
        context = "Terminal";
        bindings = {
          "ctrl-c" = "terminal::Copy";
          "ctrl-shift-c" = [
            "terminal::SendKeystroke"
            "ctrl-c"
          ];
          "ctrl-v" = "terminal::Paste";
          "ctrl-a" = "terminal::SelectAll";
          "ctrl-." = "terminal_panel::ToggleFocus";
        };
      }
    ];
  };
}
