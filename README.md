# MkDocs RootService Theme & Plugins

Dieses Repository enthält ein erweitertes **Material for MkDocs**-Setup mit
angepasstem Theme, Plugins und Best-Practice-Integration für
Dokumentationsprojekte.

## Features

- **Theme-Anpassungen**
  - Magenta-Farbpalette, kontrastreiche Codeblöcke
  - WCAG 2.2- und WAI-ARIA-konform
  - Schema.org-Metadaten (TechArticle, HowTo)
- **Plugins & Erweiterungen**
  - Lesedauer- und Lizenzanzeige (CC BY-NC-SA 4.0)
  - GitHub-Avatare für Autoren
  - Git-Revision-Daten, Dokument-Daten
- **Security & Compliance**
  - Automatische CSP-Header-Generierung
  - robots.txt, ai-robots.txt, `.well-known/`
  - CSP-Report-Script (PHP, optional)
- **Repository-Standards**
  - Vollständige Dotfiles (.editorconfig, .gitattributes, .gitignore)
  - CI-Workflows für Linting, Build, Deployment
  - INSTALL.md mit OS-spezifischen Anleitungen

## Installation

Siehe [INSTALL.md](INSTALL.md) für detaillierte Anleitungen auf
Windows, Linux, FreeBSD und macOS.

## Nutzung

```bash
uv run mkdocs serve
```

Erzeugt ein lokales Preview unter `http://127.0.0.1:8000`.

## Lizenz

[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)
