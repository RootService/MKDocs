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
