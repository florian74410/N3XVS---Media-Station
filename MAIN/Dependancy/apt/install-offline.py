#!/usr/bin/env python3
"""Install a verified bundle from a trusted preparation machine."""
import hashlib
import json
import os
import platform
import subprocess
import sys
from pathlib import Path

def verify(root):
    manifest = json.loads((root / "manifest.json").read_text())
    arch = subprocess.check_output(["dpkg", "--print-architecture"], text=True).strip()
    osinfo = platform.freedesktop_os_release()
    if (osinfo["ID"], osinfo.get("VERSION_CODENAME"), arch) != ("debian", "trixie", "arm64"):
        raise ValueError("Bundle réservé à Debian trixie arm64")
    files = sorted((root / "pool").glob("*.deb"))
    actual = {hashlib.sha256(f.read_bytes()).hexdigest() for f in files}
    expected = {r["sha256"] for r in manifest["packages"]}
    if not files or actual != expected or len(files) != len(expected):
        raise ValueError("Inventaire incomplet ou fichier supplémentaire")
    for f in files:
        if f.is_symlink() or f.resolve().parent != root / "pool":
            raise ValueError("Chemin de paquet invalide")
    subprocess.run(["sha256sum", "--check", "--strict", "SHA256SUMS"], cwd=root, check=True)
    return files

if __name__ == "__main__":
    root = Path(sys.argv[1] if len(sys.argv) > 1 else __file__).resolve()
    files = verify(root if root.is_dir() else root.parent)
    cmd = ["apt-get", "--no-download", "--no-install-recommends", "-o", "Dir::Etc::sourcelist=/dev/null", "-o", "Dir::Etc::sourceparts=-", "install", *map(str, files)]
    subprocess.run([*cmd[:1], "--simulate", *cmd[1:]], check=True)
    subprocess.run((["sudo"] if os.getuid() else []) + cmd, check=True)
