# Installation

## FreeBSD 14+ (empfohlen)
```sh
sudo pkg update
sudo pkg install -y python3 py3-pip cairo pango pkgconf libxslt
# optional: node npm (nur für CI/Screenshots)
sudo pkg install -y node npm || true

# Benutzer-Setup + Build
tools/setup-mkdocs.sh user --upgrade
tools/setup-mkdocs.sh build
tools/setup-mkdocs.sh serve --addr 0.0.0.0:8000
```

## Linux (Debian/Ubuntu)
```sh
sudo apt-get update
sudo apt-get install -y python3 python3-venv python3-pip
tools/setup-mkdocs.sh user --upgrade
tools/setup-mkdocs.sh build
```

## Windows 11
PowerShell als Administrator:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.	ools\Setup-MKDocs.ps1
```
Danach Terminal neu öffnen und `mkdocs build` bzw. `mkdocs serve` ausführen.


### FreeBSD mit portmaster
```sh
sudo pkg install -y portmaster portsnap || true
sudo portsnap fetch update || true
sudo sh tools/setup-mkdocs.sh root --portmaster --portsnap -y
sh tools/setup-mkdocs.sh user --upgrade
```
