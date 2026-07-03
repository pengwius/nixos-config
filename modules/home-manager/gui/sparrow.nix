{ pkgs, lib, ... }:

let
  sparrow-upstream = pkgs.stdenv.mkDerivation rec {
    pname = "sparrow-upstream";
    version = "2.4.2";

    src = pkgs.fetchurl {
      url = "https://github.com/sparrowwallet/sparrow/releases/download/${version}/sparrowwallet-${version}-aarch64.tar.gz";
      sha256 = "sha256-SMVO07kuTo1Yfj+8QfPOvkLR4551tQadJPoIMdT9GFE=";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];
    buildInputs = with pkgs; [ xorg.libX11 libGL xorg.libxcb xorg.libXrandr xorg.libXcursor xorg.libXinerama xorg.libXxf86vm xorg.libXext xorg.libXi xorg.libXss gtk3 ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/sparrow $out/bin $out/share/applications $out/share/icons/hicolor/256x256/apps

      cp -r ./* $out/lib/sparrow/

      launcher="$out/lib/sparrow/Sparrow/bin/Sparrow"
      if [ ! -f "$launcher" ]; then
        echo "Brak launchera: $launcher"
        find "$out/lib/sparrow" -maxdepth 4 -type f | head -200
        exit 1
      fi
      chmod +x "$launcher"

      makeWrapper "$launcher" "$out/bin/sparrow-upstream" \
        --set _JAVA_AWT_WM_NONREPARENTING 1 \
        --set GDK_BACKEND x11 \
        --set JDK_JAVA_OPTIONS "-Dglass.platform=gtk -Djava.awt.headless=false -Dprism.order=sw" \
        --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath (with pkgs; [ xorg.libX11 libGL xorg.libXrandr xorg.libXcursor xorg.libXinerama xorg.libXxf86vm xorg.libXext xorg.libXi xorg.libXss gtk3 ])}:$out/lib/sparrow/Sparrow/lib/app:$LD_LIBRARY_PATH"

      if [ -f "$out/lib/sparrow/Sparrow/lib/Sparrow.png" ]; then
        cp "$out/lib/sparrow/Sparrow/lib/Sparrow.png" \
          "$out/share/icons/hicolor/256x256/apps/sparrow-upstream.png"
        iconLine="Icon=sparrow-upstream"
      else
        iconLine=""
      fi

      cat > $out/share/applications/sparrow-upstream.desktop <<EOF
      [Desktop Entry]
      Name=Sparrow Wallet (Upstream)
      Exec=$out/bin/sparrow-upstream
      Terminal=false
      Type=Application
      Categories=Finance;
      $iconLine
      EOF
      runHook postInstall
    '';

    meta = with lib; {
      description = "Sparrow Wallet upstream tarball";
      platforms = [ "aarch64-linux" ];
    };
  };
in
{
  home.packages = [ sparrow-upstream ];
}
