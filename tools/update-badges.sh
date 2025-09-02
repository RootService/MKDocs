#!/bin/sh
###############################################################################
# update-badges.sh
# Script to refresh dynamic badges in README.md and commit changes automatically
###############################################################################

set -eu

# Portable in-place sed
SED="sed"
OS_UNAME=$(uname -s 2>/dev/null || echo unknown)
if command -v gsed >/dev/null 2>&1; then SED="gsed"; fi
SED_INPLACE() {
  case "$OS_UNAME" in FreeBSD|Darwin) $SED -i '' "$@" ;; *) $SED -i "$@" ;; esac
}


README="README.md"

echo "[INFO] Updating dynamic badges..."

# Example: update version badge from VERSION file
VERSION=$(cat VERSION)
SED_INPLACE "s/https:\/\/img.shields.io\/badge\/version-[0-9]\+\.[0-9]\+\.[0-9]\+-magenta/https:\/\/img.shields.io\/badge\/version-${VERSION}-magenta/" $README

echo "[INFO] Badges updated for version $VERSION"

# Git commit (optional)
if [ "${1:-}" = "--commit" ]; then
  git add $README
  git commit -m "chore: update badges (version $VERSION)"
  echo "[INFO] Changes committed."
fi
