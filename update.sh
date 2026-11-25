#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
MODE="${1:---status}"
case "$MODE" in
  --status)
    git -C "$ROOT" status --short
    echo "[INFO] Mise à jour non automatique ; voir ROADMAP.md.";;
  --check)
    echo "[INFO] Vérification distante en lecture seule"
    ref=$(git -C "$ROOT" ls-remote --exit-code origin refs/heads/main | cut -f1)
    git -C "$ROOT" fetch --quiet --no-tags --no-write-fetch-head origin "$ref"
    printf 'Local %s\nMain distante %s\n' "$(git -C "$ROOT" rev-parse HEAD)" "$ref"
    git -C "$ROOT" diff --raw --no-abbrev HEAD "$ref"
    git -C "$ROOT" status --short;;
  --apply)
    echo "[BLOQUÉ] L'application de mise à jour devra être transactionnelle, vérifiée et approuvée." >&2
    exit 4;;
  *)
    echo "Usage: $0 [--status|--check|--apply]" >&2; exit 2;;
esac
