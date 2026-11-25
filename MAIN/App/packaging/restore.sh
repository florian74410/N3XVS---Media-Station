#!/usr/bin/env bash
set -eu
root=$(cd "$(dirname "$0")/../../.." && pwd)
"$root/start.sh" --daemon
wmctrl -a "NEXUS Multimedia" || true
state="${XDG_STATE_HOME:-$HOME/.local/state}/n3xvs-media"
pid=$(cat "$state/nexus.pid")
if [[ "$pid" =~ ^[1-9][0-9]*$ ]] && grep -Fzxq "$root/MAIN/App/nexus_media/main.py" "/proc/$pid/cmdline"; then kill -USR1 "$pid"; fi
