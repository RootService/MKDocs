# MkDocs Documentation Project

![CI](https://github.com/OWNER/REPO/actions/workflows/ci.yml/badge.svg)
![Docs](https://github.com/OWNER/REPO/actions/workflows/deploy-docs.yml/badge.svg)
![Lint](https://github.com/OWNER/REPO/actions/workflows/lint.yml/badge.svg)
![Security](https://github.com/OWNER/REPO/actions/workflows/security-scan.yml/badge.svg)
![CodeQL](https://github.com/OWNER/REPO/actions/workflows/codeql-analysis.yml/badge.svg)
![License](https://img.shields.io/github/license/OWNER/REPO)
![Release](https://github.com/OWNER/REPO/actions/workflows/release-please.yml/badge.svg)

Dieses Repository enthält eine Dokumentationsseite, die mit [MkDocs](https://www.mkdocs.org/) gebaut wird.

## Installation

```bash
pip install -r requirements.txt
npm install
```

## Lokale Entwicklung

```bash
mkdocs serve
```

## Deployment

Das Deployment erfolgt automatisch über GitHub Actions auf **GitHub Pages**.

## Mitwirken

Siehe [CONTRIBUTING.md](CONTRIBUTING.md).

## Repository Setup (Labels, Milestones, Projektboard)

Dieses Repository enthält ein Skript, um GitHub-Labels, Milestones und ein Projektboard automatisch einzurichten.

### Voraussetzungen
- Installiertes [GitHub CLI (gh)](https://cli.github.com/)
- Authentifizierung mit `gh auth login`

### Nutzung
```bash
./setup_github_config.sh <owner>/<repo>
```

**Beispiel:**
```bash
./setup_github_config.sh meinuser/meinrepo
```

Das Skript erstellt automatisch:
- Labels (`bug`, `enhancement`, `documentation`, `question`, `security`, `chore`)
- Milestones (`v1.0.0`, `v1.1.0`)
- Projektboard ("Projekt Board")
