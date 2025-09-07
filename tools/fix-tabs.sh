#!/bin/sh
# Replace tabs with 2 spaces in text-like files.
# Usage: sh tools/fix-tabs.sh [PATH...]
set -eu
paths="${*:-.}"
fail=0
for p in $paths; do
    if [ -d "$p" ]; then
        # shellcheck disable=SC2039
        find "$p" -type f \
            -iname "*.yml" -o -iname "*.yaml" -o -iname "*.conf" -o -iname "*.cfg" -o -iname "*.ini" -o -iname "*.md" -o -iname "*.txt" | while read -r f; do
            # Skip binaries by size heuristic
            if file "$f" | grep -qi "text"; then
                # Backup then convert
                cp "$f" "$f.bak"
                # POSIX sed portable tab: use printf to inject real tab
                tab="$(printf '\t')"
                # Replace tabs with two spaces
                # macOS/BSD sed compatible
                sed "s/${tab}/  /g" "$f.bak" > "$f"
            fi
        done
    elif [ -f "$p" ]; then
        cp "$p" "$p.bak"
        tab="$(printf '\t')"
        sed "s/${tab}/  /g" "$p.bak" > "$p"
    fi
done
echo "Done."
