#!/bin/bash
# GitHub Repository Setup Script
# Nutzung: ./setup_github_config.sh <owner>/<repo>

REPO=$1

if [ -z "RootService/MKDocs" ]; then
  echo "Usage: $0 <owner>/<repo>"
  exit 1
fi

echo "Setup für Repository: RootService/MKDocs"

# Labels
gh label create bug --repo RootService/MKDocs --color d73a4a --description "Fehler im Projekt" --force || true

gh label create enhancement --repo RootService/MKDocs --color a2eeef --description "Neue Features oder Verbesserungen" --force || true

gh label create documentation --repo RootService/MKDocs --color 0075ca --description "Änderungen an der Dokumentation" --force || true

gh label create question --repo RootService/MKDocs --color d876e3 --description "Fragen oder Diskussionen" --force || true

gh label create security --repo RootService/MKDocs --color e99695 --description "Sicherheitsrelevantes Thema" --force || true

gh label create chore --repo RootService/MKDocs --color cfd3d7 --description "Wartungsarbeiten, Dependencies, CI/CD" --force || true

# Milestones
gh milestone create --repo RootService/MKDocs --title "v1.0.0" --description "Erste stabile Version" --due-date "2025-12-31" || true

gh milestone create --repo RootService/MKDocs --title "v1.1.0" --description "Geplante Feature-Erweiterungen" --due-date "2026-03-31" || true

# Projektboard
gh project create --repo RootService/MKDocs --title "Projekt Board" --description "Automatisiertes Kanban Board für Issues & PRs" || true

echo "Setup abgeschlossen."
