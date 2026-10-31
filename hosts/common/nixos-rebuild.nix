{
  config,
  lib,
  pkgs,
  ...
}:

let
  real = pkgs.nixos-rebuild-ng.override { nix = config.nix.package; };

  wrapper = pkgs.writeShellScriptBin "nixos-rebuild" ''
    set -o pipefail

    for arg in "$@"; do
      case "$arg" in
        edit|repl|list-generations|--json|-h|--help|--version)
          exec ${real}/bin/nixos-rebuild "$@" ;;
      esac
    done

    if [ ! -t 1 ]; then
      exec ${real}/bin/nixos-rebuild --no-reexec "$@"
    fi

    # --no-reexec prevents the flake re-exec loop through this wrapper.
    ${real}/bin/nixos-rebuild --no-reexec --log-format internal-json "$@" 2>&1 | ${pkgs.nix-output-monitor}/bin/nom --json
  '';
in
{
  system.build.nixos-rebuild = lib.mkForce (
    pkgs.symlinkJoin {
      name = "nixos-rebuild";
      paths = [ wrapper ];
      postBuild = ''
        mkdir -p $out/share
        ln -s ${real}/share/man $out/share/man
        ln -s ${real}/share/bash-completion $out/share/bash-completion
        ln -s ${real}/share/zsh $out/share/zsh

        ln -s ${real}/bin/nixos-rebuild $out/bin/nixos-rebuild-real
      '';
    }
  );
}
