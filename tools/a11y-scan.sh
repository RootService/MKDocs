#!/bin/sh
set -eu
echo "Scanning for potential A11Y issues..."
grep -RIn '<img ' "${1:-.}" | grep -v 'alt=' || true
grep -RInE 'role=|aria-' "${1:-.}" || true
echo "Done."
