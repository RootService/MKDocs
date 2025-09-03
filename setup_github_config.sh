#!/bin/bash
# GitHub Repository Setup Script
# Nutzung: ./setup_github_config.sh <owner>/<repo>

REPO=$1

if [ -z "$REPO" ]; then
  echo "Usage: $0 <owner>/<repo>"
  exit 1
fi

echo "Setup für Repository: $REPO"

# Labels
gh label create bug --repo $REPO --color d73a4a --description "Fehler im Projekt" || true
gh label create enhancement --repo $REPO --color a2eeef --description "Neue Features oder Verbesserungen" || true
gh label create documentation --repo $REPO --color 0075ca --description "Änderungen an der Dokumentation" || true
gh label create question --repo $REPO --color d876e3 --description "Fragen oder Diskussionen" || true
gh label create security --repo $REPO --color e99695 --description "Sicherheitsrelevantes Thema" || true
gh label create chore --repo $REPO --color cfd3d7 --description "Wartungsarbeiten, Dependencies, CI/CD" || true

# Milestones
gh milestone create --repo $REPO --title "v1.0.0" --description "Erste stabile Version" --due-date "2025-12-31" || true
gh milestone create --repo $REPO --title "v1.1.0" --description "Geplante Feature-Erweiterungen" --due-date "2026-03-31" || true

# Projektboard
gh project create --repo $REPO --title "Projekt Board" --description "Automatisiertes Kanban Board für Issues & PRs" || true

echo "Setup abgeschlossen."
