#!/bin/sh
set -eu
ROOT="${1:-.}"
OUT="${2:-a11y-findings}"
mkdir -p "$OUT"
rg -n '!\[\s*\]\([^)]+\)' "$ROOT"/docs || true > "$OUT/missing-alt-md.txt"
rg -n -i '<img(?![^>]*\balt=)' "$ROOT"/docs "$ROOT"/overrides || true > "$OUT/missing-alt-html.txt"
rg -n 'role="dialog"|role="progressbar"|aria-' "$ROOT"/docs "$ROOT"/overrides || true > "$OUT/aria-role-lines.txt"
if command -v npx >/dev/null 2>&1; then
  npx --yes markdownlint-cli '**/*.md' --config .markdownlint.json --ignore node_modules > "$OUT/markdownlint.txt" || true
else
  echo "markdownlint not run (npx missing)" > "$OUT/markdownlint.txt"
fi
echo "Wrote findings to $OUT/"
