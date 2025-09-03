# Lint Workflows Dashboard

Dieses Projekt nutzt mehrere Lint-Workflows, um Codequalität und Konsistenz sicherzustellen.

## Übersicht der Workflows

| Workflow         | Badge |
|------------------|-------|
| **Markdown Lint** | ![Markdown Lint](https://github.com/OWNER/REPO/actions/workflows/markdown-lint-report.yml/badge.svg) |
| **YAML & JSON Lint** | ![YAML & JSON Lint](https://github.com/OWNER/REPO/actions/workflows/yaml-json-lint-report.yml/badge.svg) |
| **Python Lint** | ![Python Lint](https://github.com/OWNER/REPO/actions/workflows/python-lint-report.yml/badge.svg) |
| **Lint Aggregate** | ![Lint Aggregate](https://github.com/OWNER/REPO/actions/workflows/lint-aggregate.yml/badge.svg) |

## Beschreibung

- **Markdown Lint**: Prüft alle `.md` Dateien mit markdownlint.  
- **YAML & JSON Lint**: Validiert `.yml/.yaml` und `.json` Dateien mit yamllint und jsonlint.  
- **Python Lint**: Führt `flake8`, `black` und `mypy` Prüfungen aus.  
- **Lint Aggregate**: Kombiniert alle Ergebnisse und postet sie als Kommentar im Pull Request sowie im GitHub Actions Summary.

---

## Nutzung für Entwickler

Vor dem Commiten sollten Linter lokal ausgeführt werden, um Fehler frühzeitig zu erkennen:

```bash
pre-commit run --all-files
```

Dadurch werden die gleichen Checks wie in den GitHub Actions lokal angewendet.
