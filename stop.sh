#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
PY="$ROOT/MAIN/App/nexus_media/main.py"
PIDFILE="${XDG_STATE_HOME:-$HOME/.local/state}/n3xvs-media/nexus.pid"
[[ -f "$PIDFILE" ]] || { echo "[INFO] NEXUS déjà arrêté"; exit 0; }
PID="$(cat "$PIDFILE")"
if ! [[ "$PID" =~ ^[0-9]+$ ]] || ! kill -0 "$PID" 2>/dev/null; then
  rm -f "$PIDFILE"
  echo "[INFO] PID expiré"; exit 0
fi
if [[ ! -r "/proc/$PID/cmdline" ]] || ! grep -Fzxq -- "$PY" "/proc/$PID/cmdline"; then
  echo "[ERREUR] PID non attribué à NEXUS : refus de tuer un autre processus" >&2
  exit 1
fi
kill -TERM "$PID"
for ((i=0;i<30;i++)); do
  [[ -e "$PIDFILE" ]] || break
  kill -0 "$PID" 2>/dev/null || break
  sleep 0.2
done
if [[ -e "$PIDFILE" ]] && kill -0 "$PID" 2>/dev/null; then echo "[AVERTISSEMENT] Processus toujours vivant, aucun SIGKILL envoyé" >&2; exit 1; fi
rm -f "$PIDFILE"
echo "[OK] NEXUS arrêté"
