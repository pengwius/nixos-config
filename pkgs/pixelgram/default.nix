{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  buildFHSEnv,
  writeShellScript,
  makeDesktopItem,
  python3,
  jdk21,
  jetbrains,
}:
let
  version = "0.54.1";
  arm64 = stdenv.hostPlatform.isAarch64;
  # shortcut: upstream has no Linux ARM64 release, drop jar replacement when it does.
  arm64Jars = import ./arm64-jars.nix { inherit fetchurl; };
  kotlinJar =
    name:
    fetchurl {
      url = "https://repo.maven.apache.org/maven2/org/jetbrains/kotlin/${name}/2.4.21/${name}-2.4.21.jar";
      hash =
        {
          kotlin-compiler-embeddable = "sha256-7xlBnHZeeshARGX6Amyo/E27ioIt4Px5qlPI3OKfHQI=";
          kotlin-compose-compiler-plugin-embeddable = "sha256-Y09cF77VhUVIII8pAQcfLq1Zk/+tJbNP6hZo7p4xS1M=";
          kotlin-script-runtime = "sha256-pljPWQKhUloGwmSl5CtDfpemZ53e74ymQSRvJwz2oBM=";
        }
        .${name};
    };
  chatView = fetchurl {
    url = "https://raw.githubusercontent.com/JettaXP/pixelGram/v${version}/src/main/kotlin/com/pixelgram/desktop/ui/main/ChatView.kt";
    hash = "sha256-SjW59Rj4RP+pCwi5jDY2TtiznDCEfKRyw33T8Yf5TL4=";
  };
  composeSources = fetchurl {
    url = "https://repo.maven.apache.org/maven2/org/jetbrains/compose/ui/ui-desktop/1.12.2/ui-desktop-1.12.2-sources.jar";
    hash = "sha256-rhzLmNbXM1x+LQ7FAk5s2oANFze6s0d/gcRZFOJ7eG4=";
  };
  app = stdenvNoCC.mkDerivation {
    pname = "pixelgram-unwrapped";
    inherit version;
    src = fetchurl {
      url = "https://github.com/JettaXP/pixelGram/releases/download/v${version}/pixelGram-${version}-linux-x86_64.tar.gz";
      hash = "sha256-HwwCqpSBAhv4sTOd2AE37LbgycdB8PmZ6CQ0mQ3XPBo=";
    };
    nativeBuildInputs = [ jdk21 ];
    postUnpack = ''
      cp ${chatView} "$sourceRoot/ChatView.kt"
      chmod u+w "$sourceRoot/ChatView.kt"
      (cd "$sourceRoot"
        jar xf ${composeSources} desktopMain/androidx/compose/ui/awt/ComposeWindowPanel.desktop.kt
        mv desktopMain/androidx/compose/ui/awt/ComposeWindowPanel.desktop.kt .
      )
    '';
    patches = [
      ./composer-focus.patch
      ./compose-wayland.patch
    ];
    # Recompile only the patched files against the release's existing dependencies.
    buildPhase = ''
      runHook preBuild
      classpath=""
      for jar in $(sed -n 's|^app.classpath=$APPDIR/||p' lib/app/pixelGram.cfg); do
        classpath="$classpath$PWD/lib/app/$jar:"
      done
      java -Xmx2g \
        -cp "${kotlinJar "kotlin-compiler-embeddable"}:${kotlinJar "kotlin-script-runtime"}:$classpath" \
        org.jetbrains.kotlin.cli.jvm.K2JVMCompiler \
        -no-stdlib -no-reflect -jvm-target 21 -module-name com.pixelgram.desktop_pixelgram \
        -Xplugin=${kotlinJar "kotlin-compose-compiler-plugin-embeddable"} \
        -classpath "$classpath" -Xfriend-paths="''${classpath%%:*}" \
        -opt-in=androidx.compose.material3.ExperimentalMaterial3Api \
        -opt-in=androidx.compose.material3.ExperimentalMaterial3ExpressiveApi \
        -opt-in=androidx.compose.foundation.layout.ExperimentalLayoutApi \
        -d patched ChatView.kt
      uiJar=$(printf '%s' "$PWD"/lib/app/ui-desktop-1.12.2-*.jar)
      java -Xmx2g \
        -cp "${kotlinJar "kotlin-compiler-embeddable"}:${kotlinJar "kotlin-script-runtime"}:$classpath" \
        org.jetbrains.kotlin.cli.jvm.K2JVMCompiler \
        -no-stdlib -no-reflect -jvm-target 21 -module-name ui \
        -Xplugin=${kotlinJar "kotlin-compose-compiler-plugin-embeddable"} \
        -classpath "$classpath" -Xfriend-paths="$uiJar" \
        -opt-in=androidx.compose.ui.ExperimentalComposeUiApi \
        -opt-in=androidx.compose.ui.InternalComposeUiApi \
        -d patched-ui ComposeWindowPanel.desktop.kt
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib $out/share/icons/hicolor/128x128/apps
      cp -r lib/app $out/lib/app
      jar uf $out/lib/app/pixelgram-*.jar -C patched com
      jar uf $out/lib/app/ui-desktop-1.12.2-*.jar -C patched-ui androidx
      cp lib/pixelGram.png $out/share/icons/hicolor/128x128/apps/pixelgram.png
      ${lib.optionalString arm64 ''
        # The JVM bytecode is portable; replace every architecture-specific dependency.
        rm $out/lib/app/{tdlight-natives-*,skiko-awt-runtime-*,javafx-*,javacpp-*-linux-*,ffmpeg-*-linux-*}.jar
        rm $out/lib/app/libskiko-linux-x64.so*
        cp ${lib.escapeShellArgs arm64Jars} $out/lib/app/
      ''}
      # Keep upstream's classpath order where multiple library versions coexist.
      for jar in $(sed -n 's|^app.classpath=$APPDIR/||p' lib/app/pixelGram.cfg); do
        if [ -f "$out/lib/app/$jar" ]; then
          printf '%s:' "$out/lib/app/$jar" >> $out/lib/classpath
        fi
      done
      ${lib.optionalString arm64 ''
        for jar in ${lib.escapeShellArgs arm64Jars}; do
          printf '%s:' "$out/lib/app/$(basename "$jar")" >> $out/lib/classpath
        done
      ''}
      sed -i 's/:$//' $out/lib/classpath
      rm $out/lib/app/pixelGram.cfg
      runHook postInstall
    '';
    doInstallCheck = true;
    nativeInstallCheckInputs = [ python3 ];
    installCheckPhase = ''
      ${python3}/bin/python3 ${./check.py} $out/lib/app ${if arm64 then "aarch64" else "x86_64"}
    '';
  };
  desktopItem = makeDesktopItem {
    name = "pixelgram";
    desktopName = "pixelGram";
    comment = "Telegram client with Material 3 Expressive design";
    exec = "pixelgram %u";
    icon = "pixelgram";
    categories = [
      "Network"
      "InstantMessaging"
    ];
    mimeTypes = [ "x-scheme-handler/tg" ];
    startupWMClass = "com.pixelgram.desktop.MainKt";
  };
in
buildFHSEnv (
  appimageTools.defaultFhsEnvArgs
  // {
    pname = "pixelgram";
    inherit version;
    targetPkgs =
      pkgs:
      appimageTools.defaultFhsEnvArgs.targetPkgs pkgs ++ [ pkgs.bibata-cursors ];
    runScript = writeShellScript "pixelgram" ''
      # shortcut: Skiko's GPU surface requires X11; use Swing software rendering
      # until upstream supports accelerated WLToolkit windows.
      export SKIKO_RENDER_API=SOFTWARE_COMPAT
      exec ${jetbrains.jdk-no-jcef}/bin/java -Dawt.toolkit.name=WLToolkit \
        -Dsun.awt.wl.WindowDecorationStyle=server \
        -Xmx1g -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=30 \
        -XX:G1PeriodicGCInterval=30000 -Djava.library.path=${app}/lib/app \
        -cp "$(cat ${app}/lib/classpath)" com.pixelgram.desktop.MainKt "$@"
    '';
    extraInstallCommands = ''
      mkdir -p $out/share
      cp -r ${app}/share/icons $out/share/icons
      cp -r ${desktopItem}/share/applications $out/share/applications
    '';
    passthru.unwrapped = app;
    meta = {
      description = "Telegram client with a Material 3 Expressive interface";
      homepage = "https://github.com/JettaXP/pixelGram";
      license = lib.licenses.gpl3Only;
      sourceProvenance = [
        lib.sourceTypes.binaryBytecode
        lib.sourceTypes.binaryNativeCode
      ];
      mainProgram = "pixelgram";
      platforms = [
        "aarch64-linux"
        "x86_64-linux"
      ];
    };
  }
)
