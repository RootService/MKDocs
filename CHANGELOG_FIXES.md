Date: 2025-09-07

Fix-Summary:
- mkdocs.yml: minimale Default-Keys ergänzt (keine Ergänzungen nötig; Datei war bereits vollständig).
- .lighthouserc.json: hinzugefügt (Lighthouse CI).
- LICENSE.md: Platzhalter hinzugefügt.
- tools/fix-tabs.sh: Tabs→Spaces Helper hinzugefügt.
- PATCH_NOTES.txt: Hinweise zu den Ergänzungen.

Wende den Patch so an:
  patch -p0 < repo_fixes.diff

Hinweis: Prüfe mkdocs.yml inhaltlich und passe site_name, nav und Plugins an dein Projekt an.
