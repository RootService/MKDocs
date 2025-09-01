# Installation

Dieses Projekt nutzt **MkDocs** mit dem Theme **Material for MkDocs**
sowie eigene Plugins und Overrides.

## Voraussetzungen

- Python ≥ 3.11
- [uv](https://github.com/astral-sh/uv) (empfohlen für Virtualenvs)
- Git
- Optional: MSYS2 (Windows), CairoSVG + Pango für erweiterte SVG/PDF-Generierung

## Setup

### 1. Repository klonen
```bash
git clone https://github.com/RootService/mkdocs.git
cd mkdocs
```

### 2. Virtuelle Umgebung erstellen
```bash
uv venv
uv pip install -r requirements.txt
```

### 3. Entwicklungsserver starten
```bash
uv run mkdocs serve
```
Seite ist erreichbar unter `http://127.0.0.1:8000`.

## OS-spezifische Hinweise

### Windows
- Visual Studio 2022 empfohlen
- Installation zusätzlicher Pakete:
  ```powershell
  winget install msys2
  winget install miniforge3
  ```

### Linux (Debian/Ubuntu)
```bash
sudo apt install python3-dev python3-venv git libcairo2-dev libpango1.0-dev
```

### FreeBSD
```bash
pkg install py311-pip cairo pango git
```

### macOS (Homebrew)
```bash
brew install python git cairo pango
```

## Build für Deployment
```bash
uv run mkdocs build
```
Das statische Site-Verzeichnis befindet sich in `site/`.

---


Verwende `tools/setup-mkdocs.sh` für Installation.
