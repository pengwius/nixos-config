{
  pkgs,
  pkgs-stable,
  lib,
  ...
}:

let
  zed-custom =
    let
      system = pkgs.stdenv.hostPlatform.system;
      arch = if system == "aarch64-linux" then "aarch64" else "x86_64";
      sha256 =
        if system == "aarch64-linux" then
          "1gldmfmp3nnwj9wzzax70wbbyhc90whvcsygwk1972by6xas0rnb"
        else
          "0g72mmrd4z0va50s0winji2172gr8glvvm1knj4qx75a0z9bkff3";
      version = "0.226.4";
    in
    pkgs.stdenv.mkDerivation rec {
      pname = "zed-editor";
      inherit version;

      src = pkgs.fetchurl {
        url = "https://github.com/zed-industries/zed/releases/download/v${version}/zed-linux-${arch}.tar.gz";
        inherit sha256;
      };

      nativeBuildInputs = [
        pkgs.autoPatchelfHook
        pkgs.makeWrapper
      ];

      buildInputs = with pkgs; [
        curl
        fontconfig
        freetype
        libGL
        libxkbcommon
        openssl
        stdenv.cc.cc
        wayland
        xorg.libxcb
        zlib
        alsa-lib
        vulkan-loader
        libz
      ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin $out/libexec

        cp -r ./* $out/libexec/

        if [ -f "$out/libexec/bin/zed" ]; then
          ln -s $out/libexec/bin/zed $out/bin/zed
          ln -s $out/libexec/bin/zed $out/bin/zeditor
        elif [ -f "$out/libexec/zed" ]; then
          ln -s $out/libexec/zed $out/bin/zed
          ln -s $out/libexec/zed $out/bin/zeditor
        fi

        if [ -d "share" ]; then
          mkdir -p $out/share
          cp -r share/* $out/share/
        fi

        if [ -f "$out/share/applications/zed.desktop" ]; then
          substituteInPlace $out/share/applications/zed.desktop \
            --replace "Exec=zed" "Exec=$out/bin/zeditor"
        fi

        runHook postInstall
      '';

      postFixup = ''
        wrapProgram $out/bin/zeditor \
          --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath buildInputs}

        wrapProgram $out/bin/zed \
          --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath buildInputs}
      '';
    };
in
{
  home.packages = [ zed-custom ];

  programs.zed-editor = {
    enable = true;
    package = zed-custom;
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
