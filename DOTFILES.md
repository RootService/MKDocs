# Dotfiles Übersicht

Dieses Repository enthält verschiedene Konfigurationsdateien ("Dotfiles"), die für Qualität, Style und Automatisierung sorgen.

## Vorhandene Dotfiles

### `.editorconfig`
- Erzwingt einheitliche Editor-Einstellungen (UTF-8, LF, Indentation, etc.)
- Wichtig für Kollaboration über verschiedene IDEs hinweg

### `.gitattributes`
- Normalisiert Zeilenenden (LF)
- Definiert Diff-Strategien für bestimmte Dateitypen
- Markiert Binärdateien korrekt

### `.gitignore`
- Ignoriert Build-Artefakte, virtuelle Umgebungen, IDE-Dateien
- Enthält Python-, Node- und MkDocs-spezifische Regeln

### `.github/dependabot.yml`
- Automatische Abhängigkeits-Updates (pip, npm, GitHub Actions)
- Läuft wöchentlich

### `.github/FUNDING.yml`
- Definiert Sponsoring-Links (GitHub Sponsors, Patreon, etc.)

---

## Neue Dotfiles

### `.prettierrc.json`
- Konfiguration für Prettier (JavaScript, JSON, Markdown, YAML)
- Erzwingt konsistentes Code-Format

### `.flake8`
- Konfiguration für Python-Linter Flake8
- Setzt max. Zeilenlänge und Ignorierregeln

### `pyproject.toml`
- Konfiguration für Black, isort und pytest
- Einheitliche Python Code-Formatierung und Tests

### `.markdownlint.json`
- Regeln für Markdown-Linter
- Schaltet bestimmte Regeln ab (z. B. MD013, MD033)

### `.yamllint.yml`
- Regeln für YAML-Linter
- Max. Zeilenlänge 120 Zeichen, verbietet unsaubere Wahrheitswerte

---

## Empfehlung

Vor jedem Commit:
```bash
pre-commit run --all-files
```

Damit werden alle Linter und Formatter automatisch geprüft.
