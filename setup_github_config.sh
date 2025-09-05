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
gh label create bug --repo $REPO --color d73a4a --description "Fehler im Projekt" 2>/dev/null || gh label edit bug --repo $REPO --color d73a4a --description "Fehler im Projekt"
gh label create enhancement --repo $REPO --color a2eeef --description "Neue Features oder Verbesserungen" 2>/dev/null || gh label edit enhancement --repo $REPO --color a2eeef --description "Neue Features oder Verbesserungen"
gh label create documentation --repo $REPO --color 0075ca --description "Änderungen an der Dokumentation" 2>/dev/null || gh label edit documentation --repo $REPO --color 0075ca --description "Änderungen an der Dokumentation"
gh label create question --repo $REPO --color d876e3 --description "Fragen oder Diskussionen" 2>/dev/null || gh label edit question --repo $REPO --color d876e3 --description "Fragen oder Diskussionen"
gh label create security --repo $REPO --color e99695 --description "Sicherheitsrelevantes Thema" 2>/dev/null || gh label edit security --repo $REPO --color e99695 --description "Sicherheitsrelevantes Thema"
gh label create chore --repo $REPO --color cfd3d7 --description "Wartungsarbeiten, Dependencies, CI/CD" 2>/dev/null || gh label edit chore --repo $REPO --color cfd3d7 --description "Wartungsarbeiten, Dependencies, CI/CD"

# Milestones
gh milestone create --repo $REPO --title "v1.0.0" --description "Erste stabile Version" --due-date "2025-12-31" 2>/dev/null || echo "Milestone v1.0.0 existiert bereits"
gh milestone create --repo $REPO --title "v1.1.0" --description "Geplante Feature-Erweiterungen" --due-date "2026-03-31" 2>/dev/null || echo "Milestone v1.1.0 existiert bereits"

# Projekte: Auto-Detection ob klassisch (--repo) oder Projects v2 (--owner)
if gh project create --help 2>&1 | grep -q -- "--repo"; then
  echo "Erstelle klassisches Repository-Projektboard..."
  gh project create --repo $REPO --title "Projekt Board" --description "Automatisiertes Kanban Board für Issues & PRs" 2>/dev/null || echo "Project Board existiert möglicherweise bereits"
else
  OWNER=$(echo $REPO | cut -d"/" -f1)
  echo "Erstelle Projects v2 Board für Owner=$OWNER..."
  gh project create --owner $OWNER --title "Projekt Board" --description "Automatisiertes Kanban Board für Issues & PRs" 2>/dev/null || echo "Projects v2 Board existiert möglicherweise bereits"
fi

echo "Setup abgeschlossen."
