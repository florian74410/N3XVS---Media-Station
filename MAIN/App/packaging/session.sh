#!/usr/bin/env bash
set -eu
root=$(cd "$(dirname "$0")/../../.." && pwd)
export NEXUS_FULLSCREEN=1
cfg=$(mktemp)
printf '"%s/MAIN/App/packaging/restore.sh"\n Control+n\n' "$root" > "$cfg"
openbox & wm=$!
xbindkeys -n -f "$cfg" & keys=$!
trap 'kill "$keys" "$wm" 2>/dev/null || true; rm -f "$cfg"' EXIT
while kill -0 "$wm" 2>/dev/null; do
  "$root/start.sh" && break
  sleep 2
done
