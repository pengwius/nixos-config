# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
args:
let
  pkgs = args.pkgs or args;
in
{
  # example = pkgs.callPackage ./example { };
  nokia-fonts = pkgs.callPackage ./nokia-fonts { };
  materialfy = pkgs.callPackage ./materialfy { };
  pixelgram = pkgs.callPackage ./pixelgram { };
}
