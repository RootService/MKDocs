# Beitragende – Contributing

Vielen Dank für dein Interesse an RootService-Docs. Wir freuen uns über Pull Requests, Bugreports und Feature-Vorschläge.

## Regeln
1. **Branching:**
   - `main` ist stabil und deployfähig.
   - Feature-Branches nach Schema `feature/<kurzbeschreibung>`.
   - Bugfixes nach Schema `fix/<issue-nummer>`.

2. **Commits:**
   - Aussagekräftige Commit-Messages.
   - Kleine, klar abgegrenzte Änderungen.

3. **Code Style:**
   - Python: [PEP 8](https://peps.python.org/pep-0008/), Black für Formatierung.
   - Markdown: 120 Zeichen pro Zeile, Lint via `markdownlint`.
   - Shell: POSIX-konform.

4. **Tests:**
   - Python-Code mit `pytest` testen.
   - MkDocs-Build darf keine Warnungen im `--strict` Modus erzeugen.

5. **Docs:**
   - Jede Funktionalität dokumentieren.
   - Beispiele und Screenshots, falls sinnvoll.

## Setup für Beitragende
Siehe [INSTALL.md](INSTALL.md) für Setup-Anweisungen.

## Pull Request Workflow
1. Fork erstellen, Branch anlegen, Änderungen implementieren.
2. Tests und Builds lokal durchführen.
3. Pull Request gegen `main` eröffnen.
4. Review abwarten.

## Lizenz
Beiträge werden unter CC BY-NC-SA 4.0 eingebracht.
