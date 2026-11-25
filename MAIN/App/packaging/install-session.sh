#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "$0")/../../.." && pwd)
for cmd in openbox xbindkeys wmctrl; do command -v "$cmd" >/dev/null || { echo "Installer le profil session ($cmd absent)"; exit 1; }; done
[[ "$root" =~ ^/[a-zA-Z0-9/_.-]+$ ]] || { echo "Chemin de session incompatible"; exit 1; }
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
printf '[Desktop Entry]\nName=Multimedia (NEXUS)\nType=Application\nExec=%s/MAIN/App/packaging/session.sh\n' "$root" > "$tmp"
sudo install -Dm644 "$tmp" /usr/share/xsessions/n3xvs-multimedia.desktop
