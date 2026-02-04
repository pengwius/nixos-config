{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "install-custom-android-sdk" ''
      set -e

      SDK_DIR="$HOME/Android/Sdk"
      NDK_DIR="$SDK_DIR/ndk"

      echo "Creating Android SDK directory at $SDK_DIR..."
      mkdir -p "$SDK_DIR"

      echo "Downloading and extracting Android SDK 35.0.2..."
      ${pkgs.wget}/bin/wget -q -O - \
          https://github.com/HomuHomu833/android-sdk-custom/releases/download/35.0.2/android-sdk-aarch64-linux-musl.tar.xz \
          | ${pkgs.gnutar}/bin/tar -C "$SDK_DIR" \
            -xJf - \
            --strip-components=1

      echo "Downloading and extracting Android SDK 36.0.0..."
      ${pkgs.wget}/bin/wget -q -O - \
          https://github.com/HomuHomu833/android-sdk-custom/releases/download/36.0.0/android-sdk-aarch64-linux-musl.tar.xz \
          | ${pkgs.gnutar}/bin/tar -C "$SDK_DIR" \
            -xJf - \
            --strip-components=1

      echo "Creating NDK directory at $NDK_DIR..."
      mkdir -p "$NDK_DIR"

      echo "Downloading and extracting Android NDK r29..."
      ${pkgs.wget}/bin/wget -q -O - \
          https://github.com/HomuHomu833/android-ndk-custom/releases/download/r29/android-ndk-r29-aarch64-linux-android.tar.xz \
          | ${pkgs.gnutar}/bin/tar -C "$NDK_DIR" \
            -xJf -

      echo "Renaming NDK..."
      if [ -d "$NDK_DIR/android-ndk-r29" ]; then
          # Remove destination if it exists to allow move
          rm -rf "$NDK_DIR/29.0.14033849"
          mv "$NDK_DIR/android-ndk-r29" "$NDK_DIR/29.0.14033849"
      fi

      echo "Android SDK custom installation complete."
    '')
  ];
}
