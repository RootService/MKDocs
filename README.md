# RootService MkDocs Portal

Dies ist das Dokumentations-Portal von **RootService**. Es basiert auf [MkDocs](https://www.mkdocs.org/) mit dem [Material-Theme](https://squidfunk.github.io/mkdocs-material/), erweitert durch eigene Plugins, Theme-Anpassungen und ein eigenes **Glossy Magenta Theme**.

## ✨ Features

- 🎨 **Glossy Magenta Design**: modernes, kontrastreiches Farbschema
- ♿ **Barrierefrei**: WCAG 2.2 konform, WAI-ARIA Best Practices
- 📊 **SEO & Metadaten**: schema.org Integration, automatische Lesezeit, Autor, Lizenz
- 🚀 **Performance**: Minifizierung, Lazy Loading, strikte Builds
- 📱 **Responsiv**: optimiert für Desktop, Tablet, Mobile
- 🌙 **Dark/Light Mode** mit automatischer Erkennung
- ⚡ **Moderne Technologien**: HTML5+, CSS3+, SVG, WebP
- 🔍 **Erweiterte Suche** mit Highlighting

## 📁 Repository Struktur

```
mkdocs.yml            # Hauptkonfiguration
site/                 # Generierter Output (nicht einchecken)
docs/                 # Markdown-Dokumentation
  ├── howtos/         # HowTos (FreeBSD, Linux, Windows, macOS)
  ├── guides/         # Schritt-für-Schritt Anleitungen
  └── ...
theme_overrides/      # Jinja2 Overrides für Material
plugins/              # Eigene / gepatchte MkDocs-Plugins
tools/                # Hilfsskripte (setup-mkdocs.sh, Setup-MKDocs.ps1)
```

## 🚀 Installation & Setup

Siehe [INSTALL.md](INSTALL.md) für detaillierte Anweisungen auf **FreeBSD, Linux, macOS und Windows**. 

- **FreeBSD**: `tools/setup-mkdocs.sh`
- **Windows**: `tools/Setup-MKDocs.ps1`
- **Linux/macOS**: manuelles Setup oder analoges Skript

## 🔧 Nutzung

- **Lokaler Build (Preview):**
  ```sh
  mkdocs build
  ```
- **Production-Build:**
  ```sh
  mkdocs build --clean --strict
  ```
- **Server:**
  ```sh
  mkdocs serve -a 127.0.0.1:8000
  ```

## 📜 Lizenz

Dieses Repository steht unter **CC BY-NC-SA 4.0**. Siehe [LICENSE](LICENSE).

## 🤝 Beitragen

Beiträge sind willkommen. Bitte siehe [CONTRIBUTING.md](CONTRIBUTING.md).

## 🔐 Sicherheit

Sicherheitsrelevante Hinweise bitte **nicht öffentlich** melden. Siehe [SECURITY.md](SECURITY.md).

## 📋 Verhaltenskodex

Siehe [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
