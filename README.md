# MkDocs Documentation Project

![CI](https://github.com/RootService/MKDocs/actions/workflows/ci.yml/badge.svg)
![Docs](https://github.com/RootService/MKDocs/actions/workflows/deploy-docs.yml/badge.svg)
![Security](https://github.com/RootService/MKDocs/actions/workflows/security-scan.yml/badge.svg)
![Release]
![Lighthouse](https://github.com/RootService/MKDocs/actions/workflows/lighthouse.yml/badge.svg)
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

# Deployment zu GitHub Pages
mkdocs gh-deploy --force
```

## Dokumentation
Die vollständige Dokumentation findest du unter:  
👉 [Projekt-Doku](https://rootservice.github.io/MKDocs)

## Lizenz
Dieses Projekt steht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE).

## Performance Report (Lighthouse)

Automatisierte Qualitätsprüfung der Dokumentation:

- Dark/Light Mode Screenshots
- Accessibility Audit
- SEO Audit
- Performance Audit

👉 Die aktuellen Berichte findest du im GitHub Actions Tab unter "Lighthouse Audit".
