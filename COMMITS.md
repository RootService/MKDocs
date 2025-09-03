# Conventional Commits Guide

Dieses Projekt verwendet [Conventional Commits](https://www.conventionalcommits.org/).  
Bitte halte dich an die folgenden Regeln für Commit-Messages, damit **Release-Please** korrekt Versionen & Changelog erzeugt.

## Struktur
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Erlaubte Types und ihre Bedeutung

- `feat`: ✨ Neues Feature
- `fix`: 🐛 Bugfix
- `docs`: 📝 Nur Dokumentationsänderungen
- `chore`: 📦 Wartung, Dependencies, Build-Tasks
- `refactor`: ♻️ Code-Refactoring ohne neue Features oder Fixes
- `test`: ✅ Tests hinzugefügt oder angepasst
- `ci`: ⚙️ Änderungen an CI/CD Workflows

## Beispiele

### Features
```
feat: füge Suchfunktion in der Doku hinzu
```

### Bugfixes
```
fix: korrigiere kaputten Link auf der Kontaktseite
```

### Dokumentation
```
docs: ergänze Anleitung für SSL-Zertifikate
```

### Wartung
```
chore: update npm dependencies
```

### Refactoring
```
refactor: vereinfachte mkdocs.yml Navigation
```

### Tests
```
test: füge Dummy-Test für mkdocs build hinzu
```

### CI/CD
```
ci: aktiviere Security-Scan-Workflow
```
