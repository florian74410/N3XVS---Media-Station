#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
APT_LIST="$ROOT/MAIN/Dependancy/apt/packages-core.txt"
MODE="check"; OFFLINE_DIR=""
usage() { echo "Usage: $0 [--check|--install|--offline /chemin/vers/deb|--dry-run]"; }
while (($#)); do
  case "$1" in
    --check) MODE=check; shift;;
    --install) MODE=install; shift;;
    --dry-run) MODE=dry; shift;;
    --offline) MODE=offline; OFFLINE_DIR="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) usage >&2; exit 2;;
  esac
done
[[ "$(uname -s)" == Linux ]] || { echo "Linux requis" >&2; exit 1; }
mapfile -t PACKAGES < <(grep -Ev '^[[:space:]]*(#|$)' "$APT_LIST")
echo "[INFO] Architecture: $(dpkg --print-architecture 2>/dev/null || uname -m)"
if [[ "$MODE" == check ]]; then
  missing=0
  for pkg in "${PACKAGES[@]}"; do
    if dpkg-query -W -f='$(Status)' "$pkg" 2>/dev/null | grep -qx 'install ok installed'; then
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
  [[ -d "$OFFLINE_DIR" ]] || { echo "Répertoire .deb introuvable" >&2; exit 1; }
  [[ -f "$OFFLINE_DIR/SHA256SUMS" ]] || { echo "SHA256SUMS manquant: installation refusée" >&2; exit 1; }
  (cd "$OFFLINE_DIR" && sha256sum -c SHA256SUMS)
  shopt -s nullglob
  DEBS=("$OFFLINE_DIR"/*.deb)
  (("${#DEBS[@]}" > 0)) || { echo "Aucun .deb" >&2; exit 1; }
  echo "[INFO] Installation locale de ${#DEBS[@]} paquets (aucun téléchargement autorisé)"
  exec sudo apt-get --no-download install --no-install-recommends "${DEBS[@]}"
fi
echo "[INFO] Installation depuis les dépôts APT configurés (confirmation sudo)"
exec sudo apt-get install --no-install-recommends "${PACKAGES[@]}"
