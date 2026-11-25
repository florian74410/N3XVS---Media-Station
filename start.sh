#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
PY="$ROOT/MAIN/App/nexus_media/main.py"
STATE="$HOME/.local/state/n3xvs-media"
PIDFILE="$STATE/nexus.pid"
LOG="$STATE/nexus.log"
MODE="${1:-run}"
mkdir -p "$STATE"
check_network() {
  if command -v ip >/dev/null && ip route show default 2>/dev/null | grep -q default; then
    echo "[INFO] Route réseau par défaut détectée"
  else
    echo "[INFO] Pas de route réseau par défaut, bibliothèque locale disponible"
  fi
}
running() {
  [[ -f "$PIDFILE" ]] || return 1
  local p
  p="$(cat "$PIDFILE")"
  [[ "$p" =~ ^[0-9]+$ ]] || return 1
  kill -0 "$p" 2>/dev/null || return 1
  [[ -r "/proc/$p/cmdline" ]] || return 1
  tr '\0' ' ' < "/proc/$p/cmdline" | grep -Fq "$PY"
}
case "$MODE" in
  --status)
    if running; then echo "[OK] NEXUS en cours (PID $(cat "$PIDFILE"))"; else echo "[INFO] NEXUS arrêté"; fi
    exit 0;;
  --restart)
    "$ROOT/stop.sh"
    MODE=run;;
  --daemon)
    running && { echo "[INFO] Déjà en cours"; exit 0; }
    check_network
    command -v python3 >/dev/null || { echo "python3 absent" >&2; exit 1; }
    nohup python3 "$PY" >> "$LOG" 2>&1 < /dev/null &
    echo "$!" > "$PIDFILE"
    echo "[OK] Démarré en arrière-plan (PID $!)"
    exit 0;;
  run|"") ;;
  *) echo "Usage: $0 [run|--daemon|--restart|--status]" >&2; exit 2;;
esac
running && { echo "[INFO] Déjà en cours"; exit 0; }
check_network
python3 "$PY" &
CHILD=$!
echo "$CHILD" > "$PIDFILE"
cleanup() {
  if kill -0 "$CHILD" 2>/dev/null; then kill "$CHILD" 2>/dev/null || true; fi
  [[ -f "$PIDFILE" ]] && [[ "$(cat "$PIDFILE")" == "$CHILD" ]] && rm -f "$PIDFILE"
}
trap cleanup EXIT INT TERM
wait "$CHILD"
