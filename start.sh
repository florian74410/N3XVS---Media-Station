#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")" && pwd)
PY="$ROOT/MAIN/App/nexus_media/main.py"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/n3xvs-media"
umask 077
mkdir -p "$STATE"
python=${NEXUS_PYTHON:-python3}
[[ ! -x "$ROOT/.venv/bin/python" || -n "${NEXUS_PYTHON:-}" ]] || python="$ROOT/.venv/bin/python"
running() {
  local p
  read -r p < "$STATE/nexus.pid" || [[ -n "${p:-}" ]] || return 1
  [[ "$p" =~ ^[1-9][0-9]*$ && -r "/proc/$p/cmdline" ]] && grep -Fzxq -- "$PY" "/proc/$p/cmdline"
}
case "${1:-start}" in
  --status) if [[ -s "$STATE/nexus.pid" ]] && running; then echo 'NEXUS actif'; else echo 'NEXUS arrêté'; fi; exit;;
  --diagnose) "$python" -c 'import platform,PySide6;print(platform.platform(), PySide6.__version__)'; command -v ffprobe vlc firefox || true; exit;;
  --restart) "$ROOT/stop.sh"; exec "$0" --daemon;;
  --daemon|run|start) ;;
  *) exit 2;;
esac
[[ ! -s "$STATE/nexus.pid" ]] || ! running || { echo "NEXUS déjà actif"; exit 0; }
if command -v ip >/dev/null && ip route show default | grep -q default; then echo 'Route réseau présente'; else echo 'Mode local disponible'; fi
if [[ "${1:-}" == --daemon ]]; then
  nohup "$python" "$PY" >>"$STATE/nexus.log" 2>&1 </dev/null &
  for ((i=0;i<80;i++)); do
    if [[ -s "$STATE/nexus.pid" ]] && running; then echo 'NEXUS actif'; exit 0; fi
    sleep .1
  done
  echo "Démarrage en échec, consulter $STATE/nexus.log" >&2
  exit 1
fi
exec "$python" "$PY"
