#!/bin/sh
###############################################################################
# update-badges.sh
# Script to refresh dynamic badges in README.md and commit changes automatically
###############################################################################

set -eu

README="README.md"

echo "[INFO] Updating dynamic badges..."

# Example: update version badge from VERSION file
VERSION=$(cat VERSION)
sed -i "s/https:\/\/img.shields.io\/badge\/version-[0-9]\+\.[0-9]\+\.[0-9]\+-magenta/https:\/\/img.shields.io\/badge\/version-${VERSION}-magenta/" $README

echo "[INFO] Badges updated for version $VERSION"

# Git commit (optional)
if [ "${1:-}" = "--commit" ]; then
  git add $README
  git commit -m "chore: update badges (version $VERSION)"
  echo "[INFO] Changes committed."
fi
