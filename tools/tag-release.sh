#!/bin/sh
###############################################################################
# tag-release.sh
# Hilfsskript zum Erstellen und Pushen eines neuen Release-Tags
###############################################################################

set -eu

if [ $# -ne 1 ]; then
  echo "Usage: $0 <version>"
  echo "Example: $0 1.2.3"
  exit 1
fi

VERSION=$1

# Prüfen auf SemVer-Format
case "$VERSION" in
  [0-9]*.[0-9]*.[0-9]*)
    echo "[INFO] Creating release tag v$VERSION"
    ;;
  *)
    echo "[ERROR] Version must be in format X.Y.Z (e.g., 1.2.3)"
    exit 1
    ;;
esac

# Changelog-Eintrag prüfen
if ! grep -q "\[$VERSION\]" CHANGELOG.md; then
  echo "[WARNING] Kein Eintrag für Version $VERSION in CHANGELOG.md gefunden."
fi

# Git Tag erstellen und pushen
git tag -a "v$VERSION" -m "Release v$VERSION"
git push origin "v$VERSION"

echo "[INFO] Release v$VERSION getaggt und gepusht."
