{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
}:
let
  pname = "materialfy";
  version = "0.5.1";
  arch =
    {
      aarch64-linux = {
        name = "aarch64";
        hash = "sha256-1yuIy/n2dYIPB0i0lmg8H4sKFwCrzQrCyj02vSYBP60=";
      };
      x86_64-linux = {
        name = "x86_64";
        hash = "sha256-4SHtpns0yrSWyHXk4NNTLGNDm721OoxTRcvRxaceI0Q=";
      };
    }
    .${stdenv.hostPlatform.system};
  src = fetchurl {
    url = "https://github.com/fatyzzz/materialfy/releases/download/v${version}/Materialfy-${version}-${arch.name}.AppImage";
    hash = arch.hash;
  };
  contents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;
  # Native Wayland: Qt applies each output's fractional scale and uses the
  # compositor cursor. XWayland uses one global scale for all monitors.
  runScript = "env QT_QPA_PLATFORM=wayland QT_PLUGIN_PATH=${contents}/usr/plugins appimage-exec.sh -w ${contents} --";

  extraInstallCommands = ''
    install -Dm644 ${contents}/usr/share/applications/materialfy.desktop \
      $out/share/applications/materialfy.desktop
    cp -r ${contents}/usr/share/icons $out/share/icons
  '';

  meta = {
    description = "Spotify client with a Material 3 Expressive interface";
    homepage = "https://github.com/fatyzzz/materialfy";
    license = lib.licenses.gpl3Plus;
    mainProgram = "materialfy";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
