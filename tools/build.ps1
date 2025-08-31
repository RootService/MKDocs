#Requires -Version 7
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Write-Host "=== RootService MkDocs Build Script ==="

# ---- 1) Virtuelle Umgebung sicherstellen ----
if (-not (Test-Path "..\.venv")) {
    Write-Host ">> Erstelle venv (.venv)"
    uv venv --python 3.11 ..\.venv
}

$activate = "..\.venv\Scripts\Activate.ps1"
if (-not (Test-Path $activate)) {
    throw "Fehler: Aktivierungsskript nicht gefunden: $activate"
}
. $activate

# ---- 2) Dependencies installieren/aktualisieren ----
Write-Host ">> Installiere Python-Abhängigkeiten"
uv pip install -r ..\requirements-dev.txt

# ---- 3) Markdownlint prüfen ----
Write-Host ">> Starte Markdownlint"
try {
    npm install -g markdownlint-cli2 markdownlint-cli2-config-standard | Out-Null
    markdownlint-cli2 "docs/**/*.md"
} catch {
    Write-Warning "Markdownlint nicht erfolgreich. Bitte Installation prüfen."
}

# ---- 4) MkDocs Build ----
Write-Host ">> Baue statische Seite"
mkdocs build

# ---- 5) Lokaler Server (optional) ----
if ($args -contains "--serve") {
    Write-Host ">> Starte lokalen Server auf http://127.0.0.1:8000"
    mkdocs serve -a 127.0.0.1:8000
} else {
    Write-Host ">> Build abgeschlossen. Seite liegt im ./site Ordner"
}
