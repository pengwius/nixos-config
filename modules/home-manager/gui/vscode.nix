{ pkgs, ... }:
{
  stylix.targets.vscode.enable = false;

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      catppuccin.catppuccin-vsc
      pkief.material-icon-theme
      github.copilot-chat
      github.copilot
      jnoortheen.nix-ide
    ];
    userSettings = {
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "material-icon-theme";
      "catppuccin.accentColor" = "mauve";
    };
    keybindings = [
      {
        key = "meta+]";
        command = "editor.action.indentLines";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "meta+[";
        command = "editor.action.outdentLines";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "ctrl+.";
        command = "workbench.action.focusActiveEditorGroup";
        when = "terminalFocus";
      }
      {
        key = "ctrl+.";
        command = "workbench.action.terminal.toggleTerminal";
        when = "!terminalFocus";
      }
    ];
  };
}
