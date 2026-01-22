{
  config,
  pkgs,
  ...
}:
let
  rofi-clipboard = pkgs.writeShellScriptBin "rofi-clipboard" ''
    if [ -z "$@" ]; then
      ${pkgs.cliphist}/bin/cliphist list
    else
      echo "$@" | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy
    fi
  '';
in
{
  stylix.targets.rofi.enable = false;

  home.packages = [ rofi-clipboard ];

  programs.rofi = {
    enable = true;
    plugins = with pkgs; [
      rofi-calc
      rofi-emoji
    ];
    extraConfig = {
      modi = "drun,calc,emoji,clipboard:rofi-clipboard";
      show-icons = true;
    };
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          background-color = mkLiteral "#191724";
          text-color = mkLiteral "#e0def4";
          border-color = mkLiteral "#c4a7e7";
          border-radius = 10;
          width = 600;
          spacing = 8;
        };

        "window" = {
          border = 2;
          padding = mkLiteral "16px";
        };

        "#mainbox" = {
          children = map mkLiteral [
            "inputbar"
            "message"
            "listview"
          ];
          spacing = 12;
        };

        "#inputbar" = {
          children = map mkLiteral [
            "prompt"
            "entry"
          ];
          padding = mkLiteral "6px 10px";
          border-radius = 6;
        };

        "#textbox-prompt-colon" = {
          expand = false;
          str = ":";
          margin = mkLiteral "0px 0.3em 0em 0em";
        };

        "entry" = {
          padding = mkLiteral "5px 8px";
        };

        "#listview" = {
          layout = mkLiteral "vertical";
          dynamic = true;
          scrollbar = false;
          fixed-height = true;
          lines = 6;
          spacing = 8;
        };

        "element" = {
          padding = mkLiteral "8px 10px";
          border-radius = 6;
        };

        "element selected" = {
          background-color = mkLiteral "#c4a7e7";
          text-color = mkLiteral "#191724";
        };

        "element-text, element-icon" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };
      };
  };
}
