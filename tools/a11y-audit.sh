#!/bin/sh
set -eu
ROOT="${1:-.}"
OUT="${2:-a11y-findings}"
mkdir -p "$OUT"

# 1) Bilder ohne ALT (Markdown und HTML)
grep -RIn --include='*.md' -E '!\[\s*\]\([^)]+\)' "$ROOT" > "$OUT/missing-alt-md.txt" || true
grep -RIn --include='*.md' --include='*.html' -P '<img(?![^>]*\balt=)' "$ROOT" > "$OUT/missing-alt-html.txt" || true

# 2) ARIA/Roles-Stellen (Review-Liste)
grep -RIn --include='*.html' --include='*.md' -E 'aria-|role=' "$ROOT" > "$OUT/aria-role-lines.txt" || true

# 3) Heading-Order via markdownlint
if command -v npx >/dev/null 2>&1; then
  npx --yes markdownlint-cli '**/*.md' --config .markdownlint.json --ignore node_modules > "$OUT/markdownlint.txt" || true
else
  echo "markdownlint not run (npx missing)" > "$OUT/markdownlint.txt"
fi

echo "Wrote findings to $OUT/"
