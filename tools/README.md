# 🛠 Tools für RootService MkDocs

In diesem Verzeichnis liegen Hilfsskripte zur lokalen Entwicklung, zum Testen und für das Bereinigen der Build-Umgebung.

---

## 📌 Übersicht

- **build.ps1**  
  Baut die MkDocs-Dokumentation lokal.  
  Erstellt bei Bedarf automatisch eine virtuelle Umgebung (`.venv`), installiert Abhängigkeiten, führt Markdown-Linting aus und erstellt die statische Seite im Ordner `site/`.  
  Optional kann ein lokaler Entwicklungsserver gestartet werden.

- **clean.ps1**  
  Entfernt `.venv`, `site/` und Cache-Verzeichnisse (`__pycache__`, `.pytest_cache`, `.mypy_cache`, `.ruff_cache`).  
  Optional kann auch der npm-Cache geleert werden.

---

## 🚀 Nutzung

### 1. Dokumentation bauen
```powershell
.	oolsuild.ps1
```
→ Baut die Seite und legt die generierten Dateien im Ordner `site/` ab.

### 2. Dokumentation lokal testen
```powershell
.	oolsuild.ps1 --serve
```
→ Startet zusätzlich einen lokalen Server unter [http://127.0.0.1:8000](http://127.0.0.1:8000).

### 3. Umgebung bereinigen
```powershell
.	ools\clean.ps1
```
→ Entfernt virtuelle Umgebung, Build-Artefakte und Python-Caches.

### 4. Umgebung + npm-Cache bereinigen
```powershell
.	ools\clean.ps1 --npm
```
→ Entfernt zusätzlich den npm-Cache.

---

## 💡 Hinweise

- Beide Skripte setzen **PowerShell 7+** voraus (`pwsh`).  
- Dependencies werden mit [uv](https://github.com/astral-sh/uv) verwaltet.  
- Vor jedem Commit empfiehlt es sich, `build.ps1` auszuführen, um sicherzustellen, dass die Seite fehlerfrei baut.  
- Bei Problemen kann `clean.ps1` genutzt werden, um die Umgebung zurückzusetzen.
