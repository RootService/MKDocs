# RootService MkDocs Material Magenta Theme

Produktionsreifes MkDocs-Setup mit Material‑Theme und magenta Farbpalette, optimierten Workflows und harten Lintern.

## Quickstart

```bash
# Benutzer-Installation in isolierter venv
tools/setup-mkdocs.sh user --upgrade --requirements requirements-dev.txt

# Entwicklung
. ~/.mkdocs/venv/bin/activate
mkdocs serve -a 0.0.0.0:8000

# Build (CI oder lokal)
tools/setup-mkdocs.sh build
```

## GitHub Actions

- **CI**: Lint, Test, Build, optional Deploy auf GitHub Pages.
- **README TOC**: Aktualisiert das Inhaltsverzeichnis im README.
- **Stale**: Markiert verwaiste Issues/PRs.
- **Release**: Tag‑basierter Release‑Flow inkl. Badge‑Update.

## Verzeichnisse

- `docs/` Inhalte
- `overrides/` Theme‑Overrides, Assets, Templates
- `tools/` Skripte
- `.github/workflows/` CI/CD

## Lizenz

Siehe `LICENSE`.
