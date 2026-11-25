#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
APT_LIST="$ROOT/MAIN/Dependancy/apt/packages-core.txt"
MODE="check"; OFFLINE_DIR=""
usage() { echo "Usage: $0 [--check|--install|--offline /chemin/vers/deb|--dry-run]"; }
while (($#)); do
  case "$1" in
    --profile) case "${2:-}" in core|media|network|dev|session|storage|optional|diagnostic) APT_LIST="$ROOT/MAIN/Dependancy/apt/packages-$2.txt";; *) exit 2;; esac; shift 2;;
    --install-session) exec "$ROOT/MAIN/App/packaging/install-session.sh";;
    --check) MODE=check; shift;;
    --install) MODE=install; shift;;
    --dry-run) MODE=dry; shift;;
    --offline) MODE=offline; OFFLINE_DIR="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) usage >&2; exit 2;;
  esac
done
[[ "$(uname -s)" == Linux ]] || { echo "Linux requis" >&2; exit 1; }
# shellcheck source=/dev/null
. /etc/os-release
if [[ "$ID" == linuxmint && "${VERSION_ID%%.*}" == 22 && "$(dpkg --print-architecture)" == amd64 && "$APT_LIST" == */packages-core.txt && "$MODE" != offline ]]; then
  lock="$ROOT/MAIN/Dependancy/qt-pyside6/mint22-amd64.txt"
  case "$MODE" in
    check) [[ -x "$ROOT/.venv/bin/python" ]] && "$ROOT/.venv/bin/python" -c 'from PySide6.QtQuick import QQuickWindow' && exit 0
      echo "Installer le profil core Mint dans .venv"; exit 3;;
    dry) echo "Mint amd64 · python3-venv puis deux wheels Qt vérifiées dans .venv"; exit;;
    install) sudo apt-get install --no-install-recommends python3-venv libxcb-cursor0 libxkbcommon-x11-0 libegl1
      /usr/bin/python3 -m venv "$ROOT/.venv"
      exec "$ROOT/.venv/bin/python" -m pip install --require-hashes --only-binary=:all: -r "$lock";;
  esac
fi
mapfile -t PACKAGES < <(grep -Ev '^[[:space:]]*(#|$)' "$APT_LIST")
echo "[INFO] Architecture: $(dpkg --print-architecture 2>/dev/null || uname -m)"
if [[ "$MODE" == check ]]; then
  missing=0
  for pkg in "${PACKAGES[@]}"; do
    if dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -qx 'install ok installed'; then
      printf '[OK] %s\n' "$pkg"
    else
      printf '[MANQUANT] %s\n' "$pkg"
      missing=$((missing+1))
    fi
  done
  echo "[INFO] $missing paquet(s) à installer ; aucune modification effectuée."
  ((missing == 0)) || exit 3
  exit 0
fi
[[ -f /etc/debian_version ]] || { echo "Système non Debian: installation automatique refusée" >&2; exit 1; }
if [[ "$MODE" == dry ]]; then
  printf '[DRY RUN] apt-get install --no-install-recommends'; printf ' %q' "${PACKAGES[@]}"; echo
  exit 0
fi
if [[ "$MODE" == offline ]]; then
  exec python3 "$ROOT/MAIN/Dependancy/apt/install-offline.py" "$OFFLINE_DIR"
fi
echo "[INFO] Installation depuis les dépôts APT configurés (confirmation sudo)"
exec sudo apt-get install --no-install-recommends "${PACKAGES[@]}"
