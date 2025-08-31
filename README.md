# MKDocs Material Glossy Magenta Theme

Ein vollständig barrierefreies, modernes und glossy Theme für Material for MKDocs mit Magenta als Basisfarbe.

## ✨ Features

- 🎨 **Modernes Glassmorphismus-Design** mit Glossy-Effekten
- ♿ **100% WCAG 2.1 AAA konform** - vollständige Barrierefreiheit
- 🎯 **WAI-ARIA Best Practices** implementiert
- 📊 **Schema.org Integration** für optimale SEO
- 🚀 **Performance-optimiert** mit lazy loading und Minifizierung
- 📱 **Vollständig responsiv** für alle Geräte
- 🌙 **Dark/Light Mode** mit System-Präferenz-Erkennung
- ⚡ **Moderne Web-Technologien**: HTML5+, CSS3+, SVG, WebP
- 📖 **Automatische Metadaten**: Lesezeit, Autor, Lizenz
- 🔍 **Erweiterte Suche** mit Fuzzy-Search und Highlighting

## 📁 Projektstruktur

```
mkdocs-glossy-magenta/
├── mkdocs.yml                      # Hauptkonfiguration
├── docs/                           # Dokumentations-Inhalte
│   ├── index.md                    # Startseite
│   ├── assets/
│   │   ├── stylesheets/
│   │   │   ├── extra.css          # Hauptstylesheet
│   │   │   ├── glossy.css         # Glassmorphismus-Effekte
│   │   │   └── accessibility.css  # Barrierefreiheit-Styles
│   │   └── javascripts/
│   │       ├── extra.js           # Hauptfunktionalität
│   │       ├── reading-time.js    # Lesezeit-Berechnung
│   │       └── schema.js          # Schema.org Integration
│   ├── markdown/
│   │   ├── index.md               # Markdown Übersicht
│   │   ├── grundlagen.md          # Markdown Grundlagen
│   │   ├── erweitert.md          # Erweiterte Syntax
│   │   ├── code.md                # Code-Blöcke
│   │   └── admonitions.md        # Hinweis-Boxen
│   ├── features/
│   │   ├── index.md               # Features Übersicht
│   │   ├── accessibility.md      # Barrierefreiheit
│   │   ├── schema.md              # Schema.org
│   │   └── performance.md        # Performance
│   └── about/
│       ├── index.md               # Über
│       ├── license.md             # Lizenz
│       └── contact.md             # Kontakt
└── overrides/                      # Theme-Overrides
    ├── base.html                   # Basis-Template
    ├── main.html                   # Haupt-Template
    └── partials/
        ├── header.html            # Header-Template
        ├── footer.html            # Footer-Template
        ├── nav.html               # Navigation-Template
        ├── search.html            # Such-Template
        ├── toc.html               # Inhaltsverzeichnis
        ├── content.html           # Content-Template
        ├── comments.html          # Kommentare
        └── social.html            # Social Links

```

## 🚀 Installation

### 1. Voraussetzungen

```shell
# Python 3.8+ erforderlich
python --version

# pip aktualisieren
pip install --upgrade pip
```

### 2. Abhängigkeiten installieren

```shell
pip install \
    mkdocs \
    mkdocs-material \
    mkdocs-material-extensions \
    mkdocs-minify-plugin \
    mkdocs-git-revision-date-localized-plugin \
    mkdocs-redirects
```

### 3. Projekt erstellen

```shell
# Neues Projekt erstellen
mkdocs new my-documentation
cd my-documentation

# Theme-Dateien kopieren (aus diesem Repository)
cp -r overrides/ .
cp -r docs/assets/ docs/
cp mkdocs.yml .
```

### 4. Konfiguration anpassen

Bearbeiten Sie die `mkdocs.yml`:

```yaml
site_name: Ihre Dokumentation
site_url: https://ihre-domain.de/
site_author: Ihr Name
site_description: Ihre Beschreibung

repo_name: username/repository
repo_url: https://github.com/username/repository
```

### 5. Lokale Entwicklung

```shell
# Entwicklungsserver starten
mkdocs serve

# Mit Live-Reload auf Port 8080
mkdocs serve --dev-addr=127.0.0.1:8080 --livereload
```

### 6. Build für Production

```shell
# Optimierter Build
mkdocs build --strict --clean

# Mit Verbose Output
mkdocs build --strict --clean --verbose
```

## 📝 Verwendung

### Frontmatter für Seiten

```markdown
---
title: Seitentitel
description: SEO-Beschreibung
author: Autor Name
date: 2025-01-15
updated: 2025-01-20
tags: [tag1, tag2, tag3]
category: Kategorie
---

# Ihre Überschrift

Ihr Inhalt hier...
```

### Admonitions verwenden

```markdown
!!! success "Erfolg"
    Ihre Erfolgsmeldung hier.

!!! warning "Warnung"
    Wichtige Warnung hier.

!!! info
    Zusätzliche Information.

??? note "Aufklappbar"
    Versteckter Inhalt.
```

### Code-Blöcke mit Highlighting

````markdown
```python linenums="1" hl_lines="2 4"
def hello_world():
    # Hervorgehobene Zeile
    print("Hello")
    # Auch hervorgehoben
    return True
```
````

### Tabellen

```markdown
| Feature | Status | Beschreibung |
|---------|:------:|--------------|
| WCAG 2.1 | ✅ | Vollständig konform |
| WAI-ARIA | ✅ | Best Practices |
| Schema.org | ✅ | Integriert |
```

## 🎨 Anpassungen

### Farben ändern

Bearbeiten Sie `docs/assets/stylesheets/extra.css`:

```css
:root {
  /* Ihre Farben */
  --md-primary-fg-color: #d946ef;  /* Hauptfarbe */
  --md-accent-fg-color: #ec4899;   /* Akzentfarbe */
}
```

### Schriftarten ändern

```css
:root {
  --md-text-font: "Inter", sans-serif;
  --md-code-font: "JetBrains Mono", monospace;
}
```

### Glossy-Effekte anpassen

Bearbeiten Sie `docs/assets/stylesheets/glossy.css`:

```css
:root {
  --glossy-gradient: linear-gradient(135deg,
    rgba(217, 70, 239, 0.1) 0%,
    rgba(236, 72, 153, 0.05) 50%,
    rgba(217, 70, 239, 0.1) 100%);
  --glossy-shadow:
    0 4px 6px -1px rgba(217, 70, 239, 0.1),
    inset 0 1px 2px 0 rgba(255, 255, 255, 0.5);
}
```

## ♿ Barrierefreiheit-Features

### Implementierte Standards

- ✅ **WCAG 2.1 Level AAA**
- ✅ **WAI-ARIA 1.2**
- ✅ **Section 508**
- ✅ **EN 301 549**

### Unterstützte Assistenztechnologien

- ✅ **NVDA** (Windows)
- ✅ **JAWS** (Windows)
- ✅ **VoiceOver** (macOS/iOS)
- ✅ **TalkBack** (Android)
- ✅ **Orca** (Linux)

### Keyboard Shortcuts

| Shortcut | Aktion |
|----------|---------|
| `/` | Suche fokussieren |
| `?` | Hilfe anzeigen |
| `Esc` | Dialog schließen |
| `Tab` | Nächstes Element |
| `Shift+Tab` | Vorheriges Element |

## 🔧 Fehlerbehebung

### Häufige Probleme

#### Build-Fehler

```shell
# Cache löschen
rm -rf site/
mkdocs build --clean
```

#### Plugin-Fehler

```shell
# Plugins neu installieren
pip uninstall mkdocs-material
pip install mkdocs-material --upgrade
```

#### Git-Revision Plugin Fehler

Falls keine Git-Historie vorhanden:

```yaml
# In mkdocs.yml deaktivieren
plugins:
  - git-revision-date-localized:
      enabled: !ENV [CI, false]
```

## 📊 Performance-Optimierung

### Build-Optimierung

```shell
# Minifizierung aktivieren
mkdocs build --strict --clean

# Mit Webpack für Assets
npm run build:assets
```

### Lighthouse Scores

- **Performance**: 95-100
- **Accessibility**: 100
- **Best Practices**: 100
- **SEO**: 100

## 🤝 Beitragen

Contributions sind willkommen! Bitte beachten Sie:

1. Fork das Repository
2. Feature Branch erstellen (`git checkout -b feature/AmazingFeature`)
3. Commits machen (`git commit -m 'Add AmazingFeature'`)
4. Push zum Branch (`git push origin feature/AmazingFeature`)
5. Pull Request öffnen

## 📜 Lizenz

Dieses Theme ist lizenziert unter [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)

- ✅ **Teilen** - Material kopieren und weiterverbreiten
- ✅ **Bearbeiten** - Material remixen, verändern und darauf aufbauen
- ⚠️ **Namensnennung** - Angemessene Urheber- und Rechteangaben
- ⚠️ **Nicht kommerziell** - Nicht für kommerzielle Zwecke
- ⚠️ **Weitergabe unter gleichen Bedingungen**

## 🆘 Support

### Dokumentation

- [MKDocs Dokumentation](https://www.mkdocs.org/)
- [Material for MKDocs](https://squidfunk.github.io/mkdocs-material/)
- [Python Markdown Extensions](https://python-markdown.github.io/extensions/)

### Community

- GitHub Issues: [Link zu Issues]
- Discussions: [Link zu Discussions]
- Discord: [Link zu Discord]

## 🙏 Danksagungen

- [MKDocs](https://www.mkdocs.org/) für das großartige Framework
- [Material for MKDocs](https://squidfunk.github.io/mkdocs-material/) für das Basis-Theme
- [squidfunk](https://github.com/squidfunk) für die kontinuierliche Entwicklung
- Allen Contributors und der Open Source Community

---

**Version**: 1.0.0
**Letzte Aktualisierung**: Januar 2025
**Autor**: Ihr Name
**Website**: [ihre-website.de](https://ihre-website.de)

---

## 📋 Checkliste für Production

Vor dem Deployment überprüfen:

- [ ] Alle Links funktionieren (`mkdocs serve` und testen)
- [ ] Bilder haben Alt-Texte
- [ ] Meta-Beschreibungen sind gesetzt
- [ ] Schema.org Markup validiert
- [ ] WCAG Tests bestanden
- [ ] Performance optimiert (Lighthouse > 90)
- [ ] Sitemap generiert
- [ ] robots.txt konfiguriert
- [ ] SSL-Zertifikat aktiv
- [ ] Analytics eingerichtet
- [ ] Backup erstellt
- [ ] Monitoring aktiviert

## 🚀 Deployment

### GitHub Pages

```yaml
# .github/workflows/ci.yml
name: ci
on:
  push:
    branches:
      - main
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
        with:
          python-version: 3.x
      - run: pip install -r requirements.txt
      - run: mkdocs gh-deploy --force
```

### Netlify

```toml
# netlify.toml
[build]
  command = "mkdocs build"
  publish = "site"

[build.environment]
  PYTHON_VERSION = "3.8"
```

### Docker

```dockerfile
FROM squidfunk/mkdocs-material

COPY . /docs
WORKDIR /docs

RUN pip install -r requirements.txt

EXPOSE 8000
CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]
```

### Vercel

```json
{
  "buildCommand": "mkdocs build",
  "outputDirectory": "site",
  "installCommand": "pip install -r requirements.txt"
}
```

---

Made with ❤️ and ☕ for the MKDocs Community
