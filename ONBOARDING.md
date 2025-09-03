# Contributor Onboarding Guide

Willkommen im Projekt! Dieses Dokument erklärt, wie du als neuer Contributor schnell starten kannst.

---

## 1. Voraussetzungen

- **Git** installiert
- **Python 3.x** und `pip`
- **Node.js** (>= 18)
- **MkDocs** installiert: `pip install mkdocs`
- **GitHub CLI (gh)** für Setup und Automatisierung

---

## 2. Repository Setup

1. Forke das Repository auf GitHub
2. Klone dein Fork:
   ```bash
   git clone https://github.com/<dein-user>/<repo>.git
   cd <repo>
   ```
3. Installiere Abhängigkeiten:
   ```bash
   pip install -r requirements.txt
   npm install
   ```

---

## 3. Lokale Entwicklung

Starte einen lokalen Docs-Server:
```bash
mkdocs serve
```

---

## 4. Commit-Regeln

Wir nutzen [Conventional Commits](COMMITS.md).  
Beispiele:
- `feat: füge Suchfunktion hinzu`
- `fix: korrigiere kaputten Link`
- `docs: aktualisiere SSL-Anleitung`

Siehe die [Commit Cheat Sheet](COMMITS.md).

---

## 5. Pull Requests

Bevor du einen PR erstellst:
- Linter und Formatter laufen lassen:
  ```bash
  pre-commit run --all-files
  ```
- Tests ausführen:
  ```bash
  pytest
  npm test
  mkdocs build --strict
  ```

PRs müssen den [Pull Request Template](.github/PULL_REQUEST_TEMPLATE.md) erfüllen.

---

## 6. GitHub Workflows

Das Repo nutzt automatisierte GitHub Actions:

- **CI**: Baut und testet Projekt (Python, Node, MkDocs)
- **Lint**: Führt Linter aus (Python & JS)
- **Docs Deploy**: Automatischer Upload zu GitHub Pages
- **Security Scan**: Bandit & Safety Check
- **CodeQL**: Code-Analyse
- **Release-Please**: Automatisches Changelog & Releases

---

## 7. Repository Setup (Labels, Milestones, Boards)

Falls du das Repo neu aufsetzt:  
```bash
./setup_github_config.sh <owner>/<repo>
```

Das erstellt Labels, Milestones und ein Projektboard.  
Details siehe [README](README.md).

---

## 8. Kommunikation & Support

- Issues nutzen für Bugs und Feature Requests
- Diskussionen oder PRs für Fragen & Feedback
- Siehe [SUPPORT.md](SUPPORT.md)

---

🎉 Viel Erfolg beim Mitwirken!
