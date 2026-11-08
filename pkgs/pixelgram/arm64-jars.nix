{ fetchurl }:
let
  maven =
    path: hash:
    fetchurl {
      url = "https://repo.maven.apache.org/maven2/${path}";
      inherit hash;
    };
in
[
  (maven "org/jetbrains/skiko/skiko-awt-runtime-linux-arm64/0.150.2/skiko-awt-runtime-linux-arm64-0.150.2.jar" "sha256-qhJAV8blC96p4N606FZJ8MPXjs1m47G1dRvL4lHfulk=")
  (maven "org/bytedeco/ffmpeg/7.1-1.5.11/ffmpeg-7.1-1.5.11-linux-arm64.jar" "sha256-vGYce2hcivXMtmdz9gYxcjUqwIjDAe5hJtcWVgTXnIg=")
  (maven "org/bytedeco/javacpp/1.5.11/javacpp-1.5.11-linux-arm64.jar" "sha256-2IX1JZSS3Q+XSrwKnVlfxTELldb+6Y2qS9s0wK9QwQ4=")
  (maven "org/openjfx/javafx-base/23.0.2/javafx-base-23.0.2-linux-aarch64.jar" "sha256-eVz2XdetBfrJ57OBL7ISuay495HXqUyIk+zYKNKcHys=")
  (maven "org/openjfx/javafx-graphics/23.0.2/javafx-graphics-23.0.2-linux-aarch64.jar" "sha256-s3kBCykzpXo6J3+HER3/+pmvN6QyUAKZFtyNMxWZrpY=")
  (maven "org/openjfx/javafx-controls/23.0.2/javafx-controls-23.0.2-linux-aarch64.jar" "sha256-Wou+MWq6073gFzugp8pactkRd4ZpbCHogJv5WMrUgjg=")
  (maven "org/openjfx/javafx-media/23.0.2/javafx-media-23.0.2-linux-aarch64.jar" "sha256-fcAfaSxmxo4AXoyg434Fgd9dsquzx/C6sEGxO/Pmm/Y=")
  (maven "org/openjfx/javafx-web/23.0.2/javafx-web-23.0.2-linux-aarch64.jar" "sha256-VUZTJiMjmkzVpfRQU/eMrxn6OSIFXhS3fz9y3fCJkwk=")
  (maven "org/openjfx/javafx-swing/23.0.2/javafx-swing-23.0.2-linux-aarch64.jar" "sha256-bq/HGo2zvXyky64l3GnNNPqOkSCO1GgfiddYXu1eS9w=")
  (fetchurl {
    url = "https://mvn.mchv.eu/repository/mchv/it/tdlight/tdlight-natives/4.0.597/tdlight-natives-4.0.597-linux_arm64_gnu_ssl3.jar";
    hash = "sha256-op0dqg0W3Z7IGJbi64t7LPG/4WHWFvq092zFIY2q5ys=";
  })
]
