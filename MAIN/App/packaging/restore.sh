#!/usr/bin/env bash
set -eu
root=$(cd "$(dirname "$0")/../../.." && pwd)
touch "${NEXUS_RESTORE_MARKER:?Raccourci réservé à la session Multimedia}"
state="${XDG_STATE_HOME:-$HOME/.local/state}/n3xvs-media"
[[ -s "$state/nexus.pid" ]] || exit 0
pid=$(cat "$state/nexus.pid")
if [[ "$pid" =~ ^[1-9][0-9]*$ ]] && grep -Fzxq "$root/MAIN/App/nexus_media/main.py" "/proc/$pid/cmdline"; then kill -USR1 "$pid"; fi
