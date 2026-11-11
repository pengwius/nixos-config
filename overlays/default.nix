# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions =
    final: _prev:
    import ../pkgs {
      pkgs = final.pkgs;
      inputs = inputs;
    };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    nix-output-monitor = prev.nix-output-monitor.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ../pkgs/nix-output-monitor/progress-bars.patch ];
    });

    vimPlugins = prev.vimPlugins.extend (
      _: plugins: {
        # shortcut: pin 2.0.4 until Nixpkgs fixes its source hash.
        copilot-lua = plugins.copilot-lua.overrideAttrs {
          version = "2.0.4";
          src = final.fetchFromGitHub {
            owner = "zbirenbaum";
            repo = "copilot.lua";
            rev = "b1482409cefe8b201f89122c682189fabf0436da";
            hash = "sha256-05f76OeWBlFmlUh90tH4XMMKfNI1jnhuIJDqYPPQokA=";
          };
        };
      }
    );
  };
}
