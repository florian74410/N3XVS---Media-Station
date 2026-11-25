#!/usr/bin/env bash
# Signed Debian metadata, isolated solver, empty installed-package database.
set -euo pipefail
base=$(cd "$(dirname "$0")" && pwd)
out=$(realpath -m "${1:?Usage: build-offline.sh NEW_DIRECTORY [core media network ...]}")
shift
profiles=("${@:-core}")
[[ ! -e "$out" ]] || { echo "Destination déjà présente" >&2; exit 2; }
mkdir -p "$(dirname "$out")"
work=$(mktemp -d "$(dirname "$out")/.nexus-build.XXXXXX")
trap 'rm -rf "$work"' EXIT
mkdir -p "$work"/{lists/partial,bundle/pool/partial,licenses}
touch "$work/status"
key=/usr/share/keyrings/debian-archive-keyring.gpg
for suite in trixie trixie-updates; do
  echo "deb [arch=arm64 signed-by=$key] https://deb.debian.org/debian $suite main"
done > "$work/sources.list"
echo "deb [arch=arm64 signed-by=$key] https://deb.debian.org/debian-security trixie-security main" >> "$work/sources.list"
opts=(-o APT::Architecture=arm64 -o APT::Architectures=arm64 -o Dir::Etc::sourcelist="$work/sources.list" -o Dir::Etc::sourceparts=- -o Dir::Etc::preferences=/dev/null -o Dir::Etc::preferencesparts=- -o Dir::State::status="$work/status" -o Dir::State::lists="$work/lists" -o Dir::Cache::archives="$work/bundle/pool" -o Debug::NoLocking=1 -o Acquire::Languages=none)
packages=()
for profile in "${profiles[@]}"; do
  case "$profile" in core|media|network|optional|dev|diagnostic|session|storage) ;; *) exit 2;; esac
  mapfile -t part < <(grep -vE '^(#|$)' "$base/packages-$profile.txt")
  packages+=("${part[@]}")
done
apt-get "${opts[@]}" -o APT::Update::Error-Mode=any update
apt-get "${opts[@]}" --download-only --yes --no-install-recommends install "${packages[@]}"
cd "$work/bundle"
rmdir pool/partial
dpkg-scanpackages pool /dev/null | gzip -n > Packages.gz
cp "$base/install-offline.py" .
printf '%s\n' "${profiles[@]}" > profiles.txt
python3 "$base/inventory.py" .
sha256sum pool/*.deb Packages.gz manifest.json DEPENDENCIES-RESOLVED.txt profiles.txt install-offline.py licenses/* > SHA256SUMS
mv "$work/bundle" "$out"
