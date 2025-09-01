# INSTALL.md

## Übersicht: Pakete pro Betriebssystem

| Betriebssystem | Basis-Pakete | Grafik-/Dev-Pakete | uv / MkDocs Plugins (per `requirements-dev.txt`) |
|---|---|---|---|
| **Windows 11** | `CondaForge.Miniforge3` (winget), `astral-sh.uv` (winget) | `MSYS2.MSYS2` + `mingw-w64-ucrt-x86_64-{cairo,pango,gdk-pixbuf2,librsvg}` | `mkdocs`, `mkdocs-material`, `mkdocs-material[imaging]`, `mkdocs-minify-plugin`, `mkdocs-git-revision-date-localized-plugin`, `mkdocs-redirects`, `cairosvg`, `pillow`, `black`, `flake8`, `pytest` |
| **Debian/Ubuntu** | `python3`, `python3-pip`, `python3-venv`, `git`, `unzip` | `libcairo2-dev`, `libpango1.0-dev`, `libgdk-pixbuf-2.0-dev`, `librsvg2-dev` | via `uv pip install -r requirements-dev.txt` |
| **Fedora/RHEL** | `python3`, `python3-pip`, `python3-virtualenv`, `git`, `unzip` | `cairo-devel`, `pango-devel`, `gdk-pixbuf2-devel`, `librsvg2` | via `uv pip install -r requirements-dev.txt` |
| **Arch Linux** | `python`, `python-pip`, `git`, `unzip` | `cairo`, `pango`, `gdk-pixbuf2`, `librsvg` | via `uv pip install -r requirements-dev.txt` |
| **Alpine Linux** | `python3`, `py3-pip`, `py3-virtualenv`, `git`, `unzip` | `cairo-dev`, `pango-dev`, `gdk-pixbuf-dev`, `librsvg-dev` | via `uv pip install -r requirements-dev.txt` |
| **FreeBSD 14+** | `python`, `py311-pip`, `py311-virtualenv`, `git`, `unzip` | `cairo`, `pango`, `gdk-pixbuf2`, `librsvg2` | via `uv pip install -r requirements-dev.txt` |
| **macOS (Homebrew)** | `python`, `uv`, `git` | `cairo`, `pango`, `gdk-pixbuf`, `librsvg` | via `uv pip install -r requirements-dev.txt` |

---

## Windows 11
Unverändert wie oben beschrieben. Verwendung von `requirements-dev.txt` ist bereits im Setup-Script integriert.

---

## Linux

### Paketinstallation
- **Debian/Ubuntu**
```shell
sudo apt update
sudo apt install -y python3 python3-pip python3-venv git unzip \
  libcairo2-dev libpango1.0-dev libgdk-pixbuf-2.0-dev librsvg2-dev
````

* **Fedora/RHEL**

```shell
sudo dnf install -y python3 python3-pip python3-virtualenv git unzip \
  cairo-devel pango-devel gdk-pixbuf2-devel librsvg2
```

* **Arch**

```shell
sudo pacman -Syu --noconfirm python python-pip git unzip \
  cairo pango gdk-pixbuf2 librsvg
```

* **Alpine**

```shell
sudo apk add --no-cache python3 py3-pip py3-virtualenv git unzip \
  cairo-dev pango-dev gdk-pixbuf-dev librsvg-dev
```

### Setup mit `requirements-dev.txt`

```shell
cd ~ && mkdir -p .mkdocs/data && cd .mkdocs
uv venv --python 3.11 .
. ./bin/activate

unzip ~/Downloads/mkdocs.zip -d data
cd data

# requirements-dev.txt sicherstellen
[ -f requirements-dev.txt ] || cat > requirements-dev.txt <<'REQ'
# Core
mkdocs
mkdocs-material
mkdocs-material-extensions
mkdocs-material[imaging]
mkdocs-minify-plugin
mkdocs-document-dates
mkdocs-git-revision-date-localized-plugin
mkdocs-redirects
mkdocs-htmlproofer-plugin
mkdocs-static-i18n

# Rendering / Imaging
cairosvg
cairocffi
cffi
tinycss2
cssselect2
pillow

# Tools
beautifulsoup4

# Dev-Tools
black
flake8
pytest
REQ

uv pip install -r requirements-dev.txt

export CSP_ENV=preview
mkdocs build --strict
[ -f tools/update_server_headers.py ] && python tools/update_server_headers.py
mkdocs serve -a 127.0.0.1:8000
```

---

## FreeBSD 14+

### Paketinstallation

```sh
sudo pkg install -y python py311-pip py311-virtualenv git unzip \
  cairo pango gdk-pixbuf2 librsvg2
```

### Setup mit `requirements-dev.txt`

```sh
cd ~ && mkdir -p .mkdocs/data && cd .mkdocs
uv venv --python 3.11 .
. ./bin/activate

unzip ~/Downloads/mkdocs.zip -d data
cd data

[ -f requirements-dev.txt ] || cat > requirements-dev.txt <<'REQ'
# Core
mkdocs
mkdocs-material
mkdocs-material-extensions
mkdocs-material[imaging]
mkdocs-minify-plugin
mkdocs-document-dates
mkdocs-git-revision-date-localized-plugin
mkdocs-redirects
mkdocs-htmlproofer-plugin
mkdocs-static-i18n

# Rendering / Imaging
cairosvg
cairocffi
cffi
tinycss2
cssselect2
pillow

# Tools
beautifulsoup4

# Dev-Tools
black
flake8
pytest
REQ

uv pip install -r requirements-dev.txt

export CSP_ENV=preview
mkdocs build --strict
[ -f tools/update_server_headers.py ] && python tools/update_server_headers.py
mkdocs serve -a 127.0.0.1:8000
```

---

## macOS (Homebrew)

### Paketinstallation

```shell
brew install python uv git cairo pango gdk-pixbuf librsvg
```

### Setup mit `requirements-dev.txt`

```shell
cd ~ && mkdir -p .mkdocs/data && cd .mkdocs
uv venv --python 3.11 .
. ./bin/activate

unzip ~/Downloads/mkdocs.zip -d data
cd data

[ -f requirements-dev.txt ] || cat > requirements-dev.txt <<'REQ'
# Core
mkdocs
mkdocs-material
mkdocs-material-extensions
mkdocs-material[imaging]
mkdocs-minify-plugin
mkdocs-document-dates
mkdocs-git-revision-date-localized-plugin
mkdocs-redirects
mkdocs-htmlproofer-plugin
mkdocs-static-i18n

# Rendering / Imaging
cairosvg
cairocffi
cffi
tinycss2
cssselect2
pillow

# Tools
beautifulsoup4

# Dev-Tools
black
flake8
pytest
REQ

uv pip install -r requirements-dev.txt

export CSP_ENV=preview
mkdocs build --strict
[ -f tools/update_server_headers.py ] && python tools/update_server_headers.py
mkdocs serve -a 127.0.0.1:8000
```

---

## Troubleshooting

* `mkdocs.yml` fehlt → in `data/` ablegen.
* `uv` fehlt → Paketinstallation prüfen (Homebrew/Winget) und PATH neu laden.
* CairoSVG-Fehler → Grafikpakete installieren.
* macOS SSL → ggf. Apple-Zertifikatsskript ausführen.

````

Zusatz: Ein kompaktes POSIX-Setup-Script (`setup-posix.sh`) für Linux/FreeBSD/macOS.

```shell
#!/usr/bin/env bash
set -euo pipefail

cd "${HOME}"
mkdir -p .mkdocs/data
cd .mkdocs

# venv
uv venv --python 3.11 .
. ./bin/activate

# Projekt
unzip -o "${HOME}/Downloads/mkdocs.zip" -d ./data
cd ./data

# requirements-dev.txt erzeugen falls fehlend
if [ ! -f requirements-dev.txt ]; then
  cat > requirements-dev.txt <<'REQ'
# Core
mkdocs
mkdocs-material
mkdocs-material-extensions
mkdocs-material[imaging]
mkdocs-minify-plugin
mkdocs-document-dates
mkdocs-git-revision-date-localized-plugin
mkdocs-redirects
mkdocs-htmlproofer-plugin
mkdocs-static-i18n

# Rendering / Imaging
cairosvg
cairocffi
cffi
tinycss2
cssselect2
pillow

# Tools
beautifulsoup4

# Dev-Tools
black
flake8
pytest
REQ
fi

uv pip install -r requirements-dev.txt

export CSP_ENV=preview
mkdocs build --strict
[ -f tools/update_server_headers.py ] && python tools/update_server_headers.py
mkdocs serve -a 127.0.0.1:8000
````






# INSTALL · MkDocs + Material

Diese Anleitung spiegelt die Logik von `tools/setup-mkdocs.sh` wider und liefert äquivalente Schritte für FreeBSD, Windows, Linux und macOS. Ziel: reproduzierbare Builds, saubere Trennung von System‑Paketen und Python‑Venv unter `~/.mkdocs`, plus klare Preview/Production‑Profile.

> Kurzfassung:
> - **FreeBSD** nutzt `tools/setup-mkdocs.sh` direkt.
> - **Windows/Linux/macOS** folgen den „Manuell (äquivalent)“-Schritten unten.
>
> Python‑Pakete kommen aus `requirements-dev.txt` (falls vorhanden) oder fallback `requirements.txt`.

---

## 1) Voraussetzungen je Betriebssystem

### FreeBSD 14+
System‑Pakete via **pkg** oder Ports. Das Script unterstützt systemweite Schritte per `root`‑Subcommand.

**Minimal:**
```sh
sudo pkg install -y git python3 npm graphviz cairo pango gdk-pixbuf2 libffi pkgconf rsync
```
Optional: Ports‑Workflow inkl. `portmaster` (vom Script unterstützt):
```sh
sudo sh tools/setup-mkdocs.sh root -y
```
Das `root`‑Subcommand kümmert sich um Ports‑Baum, `ports-mgmt/portmaster` und benötigte Libs.

### Windows 11
Empfohlen: Python 3.11+, Git, Node.js, Graphviz. Für CairoSVG Laufzeitbibliotheken via **MSYS2** (UCRT64) bereitstellen.

```powershell
# per winget
winget install -e --id Python.Python.3.11
winget install -e --id Git.Git
winget install -e --id OpenJS.NodeJS
winget install -e --id Graphviz.Graphviz
winget install -e --id MSYS2.MSYS2

# MSYS2: Cairo/Pango/GDK-Pixbuf (UCRT64)
C:\msys64\usr\bin\bash -lc "pacman -S --noconfirm --needed \
  mingw-w64-ucrt-x86_64-cairo \
  mingw-w64-ucrt-x86_64-pango \
  mingw-w64-ucrt-x86_64-gdk-pixbuf2 \
  mingw-w64-ucrt-x86_64-libffi \
  mingw-w64-ucrt-x86_64-pkgconf"

# PATH-Erweiterung (PowerShell, Benutzer-Kontext)
$ucrt="C:\\msys64\\ucrt64\\bin"
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$ucrt", "User")
```

### Linux
Installiere Python, Git, Node.js, Graphviz, Cairo‑Stack.

**Debian/Ubuntu:**
```sh
sudo apt update
sudo apt install -y python3 python3-venv python3-pip git rsync \
  libcairo2 libcairo2-dev libpango-1.0-0 libpango1.0-dev \
  libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-dev libffi-dev pkg-config \
  nodejs npm graphviz
```

**Fedora/RHEL/CentOS/Alma/Rocky:**
```sh
sudo dnf install -y python3 python3-venv python3-pip git rsync \
  cairo cairo-devel pango pango-devel gdk-pixbuf2 gdk-pixbuf2-devel \
  libffi-devel pkgconf-pkg-config nodejs npm graphviz
```

**Arch/Manjaro:**
```sh
sudo pacman -S --needed python python-virtualenv python-pip git rsync \
  cairo pango gdk-pixbuf2 libffi pkgconf nodejs npm graphviz
```

**Alpine:**
```sh
sudo apk add python3 py3-virtualenv py3-pip git rsync \
  cairo cairo-dev pango pango-dev gdk-pixbuf gdk-pixbuf-dev \
  libffi-dev pkgconf nodejs npm graphviz
```

### macOS (Homebrew)
```sh
xcode-select --install || true
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || true
brew install python@3.11 git node graphviz cairo pango gdk-pixbuf libffi pkg-config rsync
```

---

## 2) Repository beziehen
```sh
git clone https://github.com/RootService/mkdocs.git
cd mkdocs
```

---

## 3) FreeBSD: Script‑Nutzung (empfohlen)
Das Script arbeitet mit Subcommands. Ausführung als **nicht‑root** führt standardmäßig `user` und danach `build production` aus.

### Übersicht Subcommands
```text
setup-mkdocs.sh                 # default: user + build production
setup-mkdocs.sh root  [-y]
setup-mkdocs.sh user  [--upgrade] [--no-sync]
setup-mkdocs.sh build [preview|production] [--strict]
setup-mkdocs.sh serve [preview|production] [--addr HOST:PORT]
setup-mkdocs.sh clean [--npm]
```

### Typische Abläufe
**Erstinstallation (systemweite Abhängigkeiten + Benutzer‑Venv):**
```sh
sudo sh tools/setup-mkdocs.sh root -y
sh tools/setup-mkdocs.sh           # führt user → build production aus
```

**Nur Benutzer‑Umgebung aktualisieren:**
```sh
sh tools/setup-mkdocs.sh user --upgrade
```

**Preview‑Build:**
```sh
sh tools/setup-mkdocs.sh build preview
```

**Production‑Build (strict):**
```sh
sh tools/setup-mkdocs.sh build production --strict
```

**Entwicklungsserver:**
```sh
sh tools/setup-mkdocs.sh serve preview --addr 127.0.0.1:8000
```

**Aufräumen:**
```sh
sh tools/setup-mkdocs.sh clean            # entfernt .cache, __pycache__
sh tools/setup-mkdocs.sh clean --npm      # plus npm cache clean
```

**Was macht `user`?**
- Erstellt/prüft Venv unter `~/.mkdocs` mit System‑`python3`.
- Wählt `requirements-dev.txt` oder `requirements.txt`.
- Installiert Python‑Pakete in die Venv.
- Synchronisiert Repo nach `~/.mkdocs/data`.

---

## 4) Windows/Linux/macOS: Manuell (äquivalent zum Script)

### 4.1 Venv in `~/.mkdocs` anlegen bzw. wiederverwenden
```sh
python3 -m venv "$HOME/.mkdocs"
"$HOME/.mkdocs/bin/python" -m pip install --upgrade pip
```
> Windows PowerShell: `~/.mkdocs/Scripts/python.exe -m pip ...`

### 4.2 Abhängigkeiten installieren
```sh
REQ="requirements-dev.txt"; [ -f "$REQ" ] || REQ="requirements.txt"
"$HOME/.mkdocs/bin/python" -m pip install -r "$REQ"
```

### 4.3 Datenverzeichnis anlegen und Repo synchronisieren
```sh
mkdir -p "$HOME/.mkdocs/data"
rsync -a --delete --exclude ".git" ./ "$HOME/.mkdocs/data/"
```
> Windows Alternative ohne `rsync`:
> ```powershell
> robocopy . $HOME\.mkdocs\data /MIR /XD .git .venv .mypy_cache .pytest_cache .cache
> ```

### 4.4 Bauen
**Preview:**
```sh
"$HOME/.mkdocs/bin/mkdocs" build
```
**Production (empfohlen für CI/Deploy):**
```sh
"$HOME/.mkdocs/bin/mkdocs" build --clean --strict
```

### 4.5 Lokaler Server
```sh
"$HOME/.mkdocs/bin/mkdocs" serve -a 127.0.0.1:8000
```

### 4.6 Clean
```sh
rm -rf ./.cache
find . -type d -name '__pycache__' -depth -exec rm -rf {} + 2>/dev/null || true
```
Optional, falls `npm` vorhanden:
```sh
npm cache clean --force || true
```

---

## 5) NPM „user“‑Setup (optional, Linting/Tools)
Das Script sieht ein User‑Prefix `~/.local` vor. Analog:
```sh
mkdir -p "$HOME/.local"
npm config set prefix "$HOME/.local"
# Beispiele: Markdown‑Linting u.ä.
npm install -g markdownlint-cli prettier
```
> Stelle sicher, dass `~/.local/bin` im `PATH` liegt.

---

## 6) Bekannte Python‑Pakete (Ausschnitt aus requirements)
- mkdocs, mkdocs-material, mkdocs-material-extensions, mkdocs-minify-plugin
- mkdocs-document-dates, mkdocs-git-revision-date-localized-plugin, mkdocs-redirects
- mkdocs-htmlproofer-plugin, mkdocs-static-i18n
- cairosvg, cairocffi, cffi, tinycss2, cssselect2, pillow
- beautifulsoup4, black, flake8, pytest

> Die **Cairo/Pango/GDK-Pixbuf** Bibliotheken müssen als System‑Libraries vorhanden sein, damit `cairosvg` funktioniert.

---

## 7) Troubleshooting
**CairoSVG Fehler wie „cannot load library cairo“**
- Prüfe, ob `cairo`/`pango`/`gdk-pixbuf` installiert und im `PATH`/`LD_LIBRARY_PATH` verfügbar sind.
- Windows: `C:\msys64\ucrt64\bin` muss im Benutzer‑`PATH` stehen.

**`mkdocs` nicht gefunden**
- Verwende das Venv‑Binary: `~/.mkdocs/bin/mkdocs` (Linux/macOS/FreeBSD) oder `~/.mkdocs/Scripts/mkdocs.exe` (Windows).

**`serve` bindet falsche Adresse**
- Explizit setzen: `mkdocs serve -a 127.0.0.1:8000`.

---

## 8) CI‑Hinweis
Für Production‑Builds empfiehlt sich `mkdocs build --clean --strict`. Nutze die Venv unter `~/.mkdocs` im CI‑Runner oder eine Projekt‑lokale Venv nach demselben Schema.

---

## 9) Deinstallation / Aufräumen
```sh
rm -rf "$HOME/.mkdocs"
rm -rf "$HOME/.mkdocs/data"
```

---

## 10) Lizenz
Siehe `LICENSE` im Repository.






# INSTALL.md

## Übersicht: Pakete pro Betriebssystem

| Betriebssystem | Basis-Pakete | Grafik-/Dev-Pakete | uv / MkDocs Plugins (per `requirements-dev.txt`) |
|---|---|---|---|
| **Windows 11** | `CondaForge.Miniforge3` (winget), `astral-sh.uv` (winget) | `MSYS2.MSYS2` + `mingw-w64-ucrt-x86_64-{cairo,pango,gdk-pixbuf2,librsvg}` | `mkdocs`, `mkdocs-material`, `mkdocs-material[imaging]`, `mkdocs-minify-plugin`, `mkdocs-git-revision-date-localized-plugin`, `mkdocs-redirects`, `cairosvg`, `pillow`, `black`, `flake8`, `pytest` |
| **Debian/Ubuntu** | `python3`, `python3-pip`, `python3-venv`, `git`, `unzip` | `libcairo2-dev`, `libpango1.0-dev`, `libgdk-pixbuf-2.0-dev`, `librsvg2-dev` | via `uv pip install -r requirements-dev.txt` |
| **Fedora/RHEL** | `python3`, `python3-pip`, `python3-virtualenv`, `git`, `unzip` | `cairo-devel`, `pango-devel`, `gdk-pixbuf2-devel`, `librsvg2` | via `uv pip install -r requirements-dev.txt` |
| **Arch Linux** | `python`, `python-pip`, `git`, `unzip` | `cairo`, `pango`, `gdk-pixbuf2`, `librsvg` | via `uv pip install -r requirements-dev.txt` |
| **Alpine Linux** | `python3`, `py3-pip`, `py3-virtualenv`, `git`, `unzip` | `cairo-dev`, `pango-dev`, `gdk-pixbuf-dev`, `librsvg-dev` | via `uv pip install -r requirements-dev.txt` |
| **FreeBSD 14+** | `python`, `py311-pip`, `py311-virtualenv`, `git`, `unzip` | `cairo`, `pango`, `gdk-pixbuf2`, `librsvg2` | via `uv pip install -r requirements-dev.txt` |
| **macOS (Homebrew)** | `python`, `uv`, `git` | `cairo`, `pango`, `gdk-pixbuf`, `librsvg` | via `uv pip install -r requirements-dev.txt` |

---

## Windows 11
Unverändert wie oben beschrieben. Verwendung von `requirements-dev.txt` ist bereits im Setup-Script integriert.

---

## Linux

### Paketinstallation
- **Debian/Ubuntu**
```shell
sudo apt update
sudo apt install -y python3 python3-pip python3-venv git unzip \
  libcairo2-dev libpango1.0-dev libgdk-pixbuf-2.0-dev librsvg2-dev
````

* **Fedora/RHEL**

```shell
sudo dnf install -y python3 python3-pip python3-virtualenv git unzip \
  cairo-devel pango-devel gdk-pixbuf2-devel librsvg2
```

* **Arch**

```shell
sudo pacman -Syu --noconfirm python python-pip git unzip \
  cairo pango gdk-pixbuf2 librsvg
```

* **Alpine**

```shell
sudo apk add --no-cache python3 py3-pip py3-virtualenv git unzip \
  cairo-dev pango-dev gdk-pixbuf-dev librsvg-dev
```

### Setup mit `requirements-dev.txt`

```shell
cd ~ && mkdir -p .mkdocs/data && cd .mkdocs
uv venv --python 3.11 .
. ./bin/activate

unzip ~/Downloads/mkdocs.zip -d data
cd data

# requirements-dev.txt sicherstellen
[ -f requirements-dev.txt ] || cat > requirements-dev.txt <<'REQ'
# Core
mkdocs
mkdocs-material
mkdocs-material-extensions
mkdocs-material[imaging]
mkdocs-minify-plugin
mkdocs-document-dates
mkdocs-git-revision-date-localized-plugin
mkdocs-redirects
mkdocs-htmlproofer-plugin
mkdocs-static-i18n

# Rendering / Imaging
cairosvg
cairocffi
cffi
tinycss2
cssselect2
pillow

# Tools
beautifulsoup4

# Dev-Tools
black
flake8
pytest
REQ

uv pip install -r requirements-dev.txt

export CSP_ENV=preview
mkdocs build --strict
[ -f tools/update_server_headers.py ] && python tools/update_server_headers.py
mkdocs serve -a 127.0.0.1:8000
```

---

## FreeBSD 14+

### Paketinstallation

```sh
sudo pkg install -y python py311-pip py311-virtualenv git unzip \
  cairo pango gdk-pixbuf2 librsvg2
```

### Setup mit `requirements-dev.txt`

```sh
cd ~ && mkdir -p .mkdocs/data && cd .mkdocs
uv venv --python 3.11 .
. ./bin/activate

unzip ~/Downloads/mkdocs.zip -d data
cd data

[ -f requirements-dev.txt ] || cat > requirements-dev.txt <<'REQ'
# Core
mkdocs
mkdocs-material
mkdocs-material-extensions
mkdocs-material[imaging]
mkdocs-minify-plugin
mkdocs-document-dates
mkdocs-git-revision-date-localized-plugin
mkdocs-redirects
mkdocs-htmlproofer-plugin
mkdocs-static-i18n

# Rendering / Imaging
cairosvg
cairocffi
cffi
tinycss2
cssselect2
pillow

# Tools
beautifulsoup4

# Dev-Tools
black
flake8
pytest
REQ

uv pip install -r requirements-dev.txt

export CSP_ENV=preview
mkdocs build --strict
[ -f tools/update_server_headers.py ] && python tools/update_server_headers.py
mkdocs serve -a 127.0.0.1:8000
```

---

## macOS (Homebrew)

### Paketinstallation

```shell
brew install python uv git cairo pango gdk-pixbuf librsvg
```

### Setup mit `requirements-dev.txt`

```shell
cd ~ && mkdir -p .mkdocs/data && cd .mkdocs
uv venv --python 3.11 .
. ./bin/activate

unzip ~/Downloads/mkdocs.zip -d data
cd data

[ -f requirements-dev.txt ] || cat > requirements-dev.txt <<'REQ'
# Core
mkdocs
mkdocs-material
mkdocs-material-extensions
mkdocs-material[imaging]
mkdocs-minify-plugin
mkdocs-document-dates
mkdocs-git-revision-date-localized-plugin
mkdocs-redirects
mkdocs-htmlproofer-plugin
mkdocs-static-i18n

# Rendering / Imaging
cairosvg
cairocffi
cffi
tinycss2
cssselect2
pillow

# Tools
beautifulsoup4

# Dev-Tools
black
flake8
pytest
REQ

uv pip install -r requirements-dev.txt

export CSP_ENV=preview
mkdocs build --strict
[ -f tools/update_server_headers.py ] && python tools/update_server_headers.py
mkdocs serve -a 127.0.0.1:8000
```

---

## Troubleshooting

* `mkdocs.yml` fehlt → in `data/` ablegen.
* `uv` fehlt → Paketinstallation prüfen (Homebrew/Winget) und PATH neu laden.
* CairoSVG-Fehler → Grafikpakete installieren.
* macOS SSL → ggf. Apple-Zertifikatsskript ausführen.

````

Zusatz: Ein kompaktes POSIX-Setup-Script (`setup-posix.sh`) für Linux/FreeBSD/macOS.

```shell
#!/usr/bin/env bash
set -euo pipefail

cd "${HOME}"
mkdir -p .mkdocs/data
cd .mkdocs

# venv
uv venv --python 3.11 .
. ./bin/activate

# Projekt
unzip -o "${HOME}/Downloads/mkdocs.zip" -d ./data
cd ./data

# requirements-dev.txt erzeugen falls fehlend
if [ ! -f requirements-dev.txt ]; then
  cat > requirements-dev.txt <<'REQ'
# Core
mkdocs
mkdocs-material
mkdocs-material-extensions
mkdocs-material[imaging]
mkdocs-minify-plugin
mkdocs-document-dates
mkdocs-git-revision-date-localized-plugin
mkdocs-redirects
mkdocs-htmlproofer-plugin
mkdocs-static-i18n

# Rendering / Imaging
cairosvg
cairocffi
cffi
tinycss2
cssselect2
pillow

# Tools
beautifulsoup4

# Dev-Tools
black
flake8
pytest
REQ
fi

uv pip install -r requirements-dev.txt

export CSP_ENV=preview
mkdocs build --strict
[ -f tools/update_server_headers.py ] && python tools/update_server_headers.py
mkdocs serve -a 127.0.0.1:8000
````






# INSTALL.md

## Übersicht: Pakete pro Betriebssystem

| Betriebssystem | Basis-Pakete | Grafik-/Dev-Pakete | uv / MkDocs Plugins (per `requirements-dev.txt`) |
|---|---|---|---|
| **Windows 11** | `CondaForge.Miniforge3` (winget), `astral-sh.uv` (winget) | `MSYS2.MSYS2` + `mingw-w64-ucrt-x86_64-{cairo,pango,gdk-pixbuf2,librsvg}` | `mkdocs`, `mkdocs-material`, `mkdocs-material[imaging]`, `mkdocs-minify-plugin`, `mkdocs-git-revision-date-localized-plugin`, `mkdocs-redirects`, `cairosvg`, `pillow`, `black`, `flake8`, `pytest` |
| **Debian/Ubuntu** | `python3`, `python3-pip`, `python3-venv`, `git`, `unzip` | `libcairo2-dev`, `libpango1.0-dev`, `libgdk-pixbuf-2.0-dev`, `librsvg2-dev` | via `uv pip install -r requirements-dev.txt` |
| **Fedora/RHEL** | `python3`, `python3-pip`, `python3-virtualenv`, `git`, `unzip` | `cairo-devel`, `pango-devel`, `gdk-pixbuf2-devel`, `librsvg2` | via `uv pip install -r requirements-dev.txt` |
| **Arch Linux** | `python`, `python-pip`, `git`, `unzip` | `cairo`, `pango`, `gdk-pixbuf2`, `librsvg` | via `uv pip install -r requirements-dev.txt` |
| **Alpine Linux** | `python3`, `py3-pip`, `py3-virtualenv`, `git`, `unzip` | `cairo-dev`, `pango-dev`, `gdk-pixbuf-dev`, `librsvg-dev` | via `uv pip install -r requirements-dev.txt` |
| **FreeBSD 14+** | `python`, `py311-pip`, `py311-virtualenv`, `git`, `unzip` | `cairo`, `pango`, `gdk-pixbuf2`, `librsvg2` | via `uv pip install -r requirements-dev.txt` |
| **macOS (Homebrew)** | `python`, `uv`, `git` | `cairo`, `pango`, `gdk-pixbuf`, `librsvg` | via `uv pip install -r requirements-dev.txt` |

---

## Windows 11
Unverändert wie oben beschrieben. Verwendung von `requirements-dev.txt` ist bereits im Setup-Script integriert.

---

## Linux

### Paketinstallation
- **Debian/Ubuntu**
```shell
sudo apt update
sudo apt install -y python3 python3-pip python3-venv git unzip \
  libcairo2-dev libpango1.0-dev libgdk-pixbuf-2.0-dev librsvg2-dev
````

* **Fedora/RHEL**

```shell
sudo dnf install -y python3 python3-pip python3-virtualenv git unzip \
  cairo-devel pango-devel gdk-pixbuf2-devel librsvg2
```

* **Arch**

```shell
sudo pacman -Syu --noconfirm python python-pip git unzip \
  cairo pango gdk-pixbuf2 librsvg
```

* **Alpine**

```shell
sudo apk add --no-cache python3 py3-pip py3-virtualenv git unzip \
  cairo-dev pango-dev gdk-pixbuf-dev librsvg-dev
```

### Setup mit `requirements-dev.txt`

```shell
cd ~ && mkdir -p .mkdocs/data && cd .mkdocs
uv venv --python 3.11 .
. ./bin/activate

unzip ~/Downloads/mkdocs.zip -d data
cd data

# requirements-dev.txt sicherstellen
[ -f requirements-dev.txt ] || cat > requirements-dev.txt <<'REQ'
# Core
mkdocs
mkdocs-material
mkdocs-material-extensions
mkdocs-material[imaging]
mkdocs-minify-plugin
mkdocs-document-dates
mkdocs-git-revision-date-localized-plugin
mkdocs-redirects
mkdocs-htmlproofer-plugin
mkdocs-static-i18n

# Rendering / Imaging
cairosvg
cairocffi
cffi
tinycss2
cssselect2
pillow

# Tools
beautifulsoup4

# Dev-Tools
black
flake8
pytest
REQ

uv pip install -r requirements-dev.txt

export CSP_ENV=preview
mkdocs build --strict
[ -f tools/update_server_headers.py ] && python tools/update_server_headers.py
mkdocs serve -a 127.0.0.1:8000
```

---

## FreeBSD 14+

### Paketinstallation

```sh
sudo pkg install -y python py311-pip py311-virtualenv git unzip \
  cairo pango gdk-pixbuf2 librsvg2
```

### Setup mit `requirements-dev.txt`

```sh
cd ~ && mkdir -p .mkdocs/data && cd .mkdocs
uv venv --python 3.11 .
. ./bin/activate

unzip ~/Downloads/mkdocs.zip -d data
cd data

[ -f requirements-dev.txt ] || cat > requirements-dev.txt <<'REQ'
# Core
mkdocs
mkdocs-material
mkdocs-material-extensions
mkdocs-material[imaging]
mkdocs-minify-plugin
mkdocs-document-dates
mkdocs-git-revision-date-localized-plugin
mkdocs-redirects
mkdocs-htmlproofer-plugin
mkdocs-static-i18n

# Rendering / Imaging
cairosvg
cairocffi
cffi
tinycss2
cssselect2
pillow

# Tools
beautifulsoup4

# Dev-Tools
black
flake8
pytest
REQ

uv pip install -r requirements-dev.txt

export CSP_ENV=preview
mkdocs build --strict
[ -f tools/update_server_headers.py ] && python tools/update_server_headers.py
mkdocs serve -a 127.0.0.1:8000
```

---

## macOS (Homebrew)

### Paketinstallation

```shell
brew install python uv git cairo pango gdk-pixbuf librsvg
```

### Setup mit `requirements-dev.txt`

```shell
cd ~ && mkdir -p .mkdocs/data && cd .mkdocs
uv venv --python 3.11 .
. ./bin/activate

unzip ~/Downloads/mkdocs.zip -d data
cd data

[ -f requirements-dev.txt ] || cat > requirements-dev.txt <<'REQ'
# Core
mkdocs
mkdocs-material
mkdocs-material-extensions
mkdocs-material[imaging]
mkdocs-minify-plugin
mkdocs-document-dates
mkdocs-git-revision-date-localized-plugin
mkdocs-redirects
mkdocs-htmlproofer-plugin
mkdocs-static-i18n

# Rendering / Imaging
cairosvg
cairocffi
cffi
tinycss2
cssselect2
pillow

# Tools
beautifulsoup4

# Dev-Tools
black
flake8
pytest
REQ

uv pip install -r requirements-dev.txt

export CSP_ENV=preview
mkdocs build --strict
[ -f tools/update_server_headers.py ] && python tools/update_server_headers.py
mkdocs serve -a 127.0.0.1:8000
```

---

## Troubleshooting

* `mkdocs.yml` fehlt → in `data/` ablegen.
* `uv` fehlt → Paketinstallation prüfen (Homebrew/Winget) und PATH neu laden.
* CairoSVG-Fehler → Grafikpakete installieren.
* macOS SSL → ggf. Apple-Zertifikatsskript ausführen.

````

Zusatz: Ein kompaktes POSIX-Setup-Script (`setup-posix.sh`) für Linux/FreeBSD/macOS.

```shell
#!/usr/bin/env bash
set -euo pipefail

cd "${HOME}"
mkdir -p .mkdocs/data
cd .mkdocs

# venv
uv venv --python 3.11 .
. ./bin/activate

# Projekt
unzip -o "${HOME}/Downloads/mkdocs.zip" -d ./data
cd ./data

# requirements-dev.txt erzeugen falls fehlend
if [ ! -f requirements-dev.txt ]; then
  cat > requirements-dev.txt <<'REQ'
# Core
mkdocs
mkdocs-material
mkdocs-material-extensions
mkdocs-material[imaging]
mkdocs-minify-plugin
mkdocs-document-dates
mkdocs-git-revision-date-localized-plugin
mkdocs-redirects
mkdocs-htmlproofer-plugin
mkdocs-static-i18n

# Rendering / Imaging
cairosvg
cairocffi
cffi
tinycss2
cssselect2
pillow

# Tools
beautifulsoup4

# Dev-Tools
black
flake8
pytest
REQ
fi

uv pip install -r requirements-dev.txt

export CSP_ENV=preview
mkdocs build --strict
[ -f tools/update_server_headers.py ] && python tools/update_server_headers.py
mkdocs serve -a 127.0.0.1:8000
````
