"""Check the repacked classpath without opening Telegram or using an account."""

import re
import sys
import zipfile
from pathlib import Path

root = Path(sys.argv[1])
arm64 = sys.argv[2] == "aarch64"
machine = 183 if arm64 else 62
jars = list(root.glob("*.jar"))
assert jars, "Missing JVM classpath"
classpath = [Path(entry) for entry in (root.parent / "classpath").read_text().strip().split(":")]
assert set(classpath) == set(jars), "Classpath must include every installed jar"
assert classpath[0].name.startswith("pixelgram-"), "Application jar must come first"
classes = set()
native_count = 0
wayland_panel = False
for jar in jars:
    with zipfile.ZipFile(jar) as archive:
        classes.update(archive.namelist())
        panel = "androidx/compose/ui/awt/ComposeWindowPanel.class"
        if panel in archive.namelist():
            bytecode = archive.read(panel)
            assert b"RenderSettings$SwingGraphics" in bytecode
            assert b"RenderSettings$SkiaSurface" not in bytecode
            wayland_panel = True
        for entry in archive.namelist():
            # JNA is a multi-platform jar; check only this system's variant.
            if "com/sun/jna/" in entry and ("linux-aarch64/" if arm64 else "linux-x86-64/") not in entry:
                continue
            if re.search(r"\.so(?:\.\d+)*$", entry):
                header = archive.read(entry)[:20]
                assert header[:4] == b"\x7fELF", (jar, entry)
                assert int.from_bytes(header[18:20], "little") == machine, (jar, entry)
                native_count += 1
assert "com/pixelgram/desktop/MainKt.class" in classes
assert "org/jetbrains/skiko/SkiaLayer.class" in classes
assert wayland_panel, "Missing native Wayland rendering patch"
assert native_count >= 10, "Missing native dependencies"
if arm64:
    assert not list(root.glob("*x86_64*")) and not list(root.glob("*linux-x64*"))
    assert any("linux_arm64_gnu_ssl3" in jar.name for jar in jars)
    assert any("skiko-awt-runtime-linux-arm64" in jar.name for jar in jars)
print("PASS: pixelGram classpath and native-library architecture")
