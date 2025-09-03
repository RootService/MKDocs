# MkDocs Documentation Project

![CI](https://github.com/RootService/MKDocs/actions/workflows/ci.yml/badge.svg)
![Lighthouse](https://github.com/RootService/MKDocs/actions/workflows/ci.yml/badge.svg?event=push)
![Release](https://github.com/RootService/MKDocs/actions/workflows/release.yml/badge.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)



![Release]

(https://github.com/RootService/MKDocs/actions/workflows/release.yml/badge.svg)

## Überblick
Dieses Projekt nutzt [MkDocs](https://www.mkdocs.org/), um Dokumentationen zu erstellen und automatisch über GitHub Pages bereitzustellen.

## Quickstart
```bash
# Projekt klonen
git clone https://github.com/RootService/MKDocs.git
cd REPO

# Abhängigkeiten installieren
pip install -r requirements.txt

# Dokumentation lokal starten
mkdocs serve

```

## Dokumentation
Die vollständige Dokumentation findest du unter:  

## Lizenz
Dieses Projekt steht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE).

## Performance Report (Lighthouse)

Automatisierte Qualitätsprüfung der Dokumentation:

- Dark/Light Mode Screenshots
- Accessibility Audit
- SEO Audit
- Performance Audit


## Workflows

Dieses Projekt nutzt GitHub Actions für Automatisierung.

### CI (`.github/workflows/ci.yml`)
Wird bei Push und Pull Requests auf `main` ausgeführt sowie wöchentlich per Schedule.

- **Build**  
  - Python & Node einrichten (mit Cache)
  - Dependencies installieren (`pip`, `npm`)
  - Tests (`npm test`)
  - MkDocs Build (`mkdocs build`)
  - Artefakt `site/` erzeugen

- **Security**  
  - Dependency Review mit GitHub Action
  - Blockiert Merge bei kritischen Findings

- **Lighthouse**  
  - Nutzt `site/`-Artefakt aus Build
  - Startet lokalen Server
  - Führt Lighthouse Audits (Performance, SEO, Accessibility) durch
  - Lädt Report als Artefakt hoch

### Release (`.github/workflows/release.yml`)
Automatisierte Releases mit `release-please`.

---

## Badges

Dieses Projekt nutzt folgende Badges als Best-Practice:

- **CI** → Status der Continuous Integration (`ci.yml`)
- **Release** → Status des Release-Prozesses (`release.yml`)
- **License** → Hinweis auf die Projektlizenz




## Lighthouse Results

Bei jedem Run werden Ergebnisse im Verzeichnis `.lighthouse/` erzeugt und als Artefakt **lighthouse-results** hochgeladen.  
Darin enthalten:
- **Reports** (HTML + JSON) → `.lighthouse/reports`
- **Screenshots** (Dark-/Light-Mode Ansichten) → `.lighthouse/screenshots`
