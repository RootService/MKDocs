# OS: Windows 11 Pro 64bit (latest)
# IDE: Visual Studio 2022
# Python 3.11 (Miniforge3, uv)
# MSYS2 + Grafik-Stack für CairoSVG
# Node.js + markdownlint

#Requires -Version 7
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---- Helpers ---------------------------------------------------------------
function Add-PathOnce([string]$PathToAdd) {
  if ([string]::IsNullOrWhiteSpace($PathToAdd)) { return }
  try { $full = [IO.Path]::GetFullPath($PathToAdd) } catch { return }
  if (-not (Test-Path -LiteralPath $full)) { return }

  $cur = ($env:PATH -split ';') | Where-Object { $_ } | ForEach-Object { $_.Trim() }
  if ($cur -notcontains $full) { $env:PATH = ($cur + $full) -join ';' }

  $userPath  = [Environment]::GetEnvironmentVariable('PATH','User')
  $userParts = ($userPath -split ';') | Where-Object { $_ } | ForEach-Object { $_.Trim() }
  if ($userParts -notcontains $full) {
    $new = ($userParts + $full) -join ';'
    [Environment]::SetEnvironmentVariable('PATH', $new, 'User')
  }
}

function Ensure-WingetPkg([string]$Id) {
  winget install --id=$Id -e --accept-package-agreements --accept-source-agreements | Out-Null
}

function Get-MsysRoot {
  $candidates = @('C:\msys64', "$env:ProgramFiles\msys64", "$env:ProgramFiles(x86)\msys64")
  foreach ($c in $candidates) { if (Test-Path $c) { return $c } }
  return $null
}

# ---- 1) Miniforge3 --------------------------------------------------------
Ensure-WingetPkg 'CondaForge.Miniforge3'
Add-PathOnce "$env:USERPROFILE\miniforge3"
Add-PathOnce "$env:USERPROFILE\miniforge3\condabin"
Add-PathOnce "$env:USERPROFILE\miniforge3\Scripts"
Add-PathOnce "$env:USERPROFILE\.local\bin"

# ---- 2) MSYS2 + Grafikstack ----------------------------------------------
Ensure-WingetPkg 'MSYS2.MSYS2'
$msysRoot = Get-MsysRoot
if (-not $msysRoot) { throw "MSYS2 Pfad nicht gefunden." }
$bashExe = Join-Path $msysRoot 'usr\bin\bash.exe'
if (-not (Test-Path $bashExe)) { throw "bash.exe nicht gefunden unter $bashExe" }
& $bashExe -lc 'pacman -Syu --noconfirm'
& $bashExe -lc 'pacman -Syu --noconfirm'
& $bashExe -lc 'pacman -Sy --noconfirm mingw-w64-ucrt-x86_64-cairo mingw-w64-ucrt-x86_64-pango mingw-w64-ucrt-x86_64-gdk-pixbuf2 mingw-w64-ucrt-x86_64-librsvg'

# ---- 3) uv ----------------------------------------------------------------
Ensure-WingetPkg 'astral-sh.uv'
$uvBin = "$env:USERPROFILE\AppData\Local\Programs\uv\bin"
if (Test-Path $uvBin) { Add-PathOnce $uvBin }

# ---- 4) Venv --------------------------------------------------------------
$env:DATA_DIR = ".mkdocs\data"
uv venv --python 3.11 .mkdocs
$activate = ".\.mkdocs\Scripts\Activate.ps1"
if (-not (Test-Path $activate)) { throw "Venv-Aktivierungsskript fehlt: $activate" }
. $activate
uv python pin 3.11
python -V | Write-Output
(Get-Command python).Path | Write-Output

# ---- 5) Projekt entpacken -------------------------------------------------
$zip  = Join-Path $env:USERPROFILE 'Downloads\mkdocs.zip'
$dest = '.\.mkdocs\data'
New-Item -ItemType Directory -Force -Path $dest | Out-Null
if (-not (Test-Path $zip)) { throw "ZIP nicht gefunden: $zip" }
Expand-Archive -Force -Path $zip -DestinationPath $dest -ErrorAction Stop

# ---- 6) requirements-dev.txt sicherstellen -------------------------------
Set-Location $dest
$req = Join-Path (Get-Location) 'requirements-dev.txt'
if (-not (Test-Path $req)) {
  @"
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
"@ | Set-Content -Encoding UTF8 $req
}

# ---- 7) Abhängigkeiten installieren --------------------------------------
uv pip install -r $req

# ---- 8) NodeJS + markdownlint --------------------------------------------
Ensure-WingetPkg 'OpenJS.NodeJS.LTS'

# global npm bin in PATH
try {
  $npmBin = (& npm bin -g) 2>$null
  if ($npmBin) { Add-PathOnce $npmBin }
} catch { Write-Warning "npm nicht verfügbar. Prüfe NodeJS-Installation." }

# markdownlint installieren
try {
  npm i -g markdownlint-cli2 markdownlint-cli2-config-standard | Out-Null
} catch {
  Write-Warning "markdownlint-Installation fehlgeschlagen."
}

# Config sicherstellen
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$lintConfig = Join-Path $repoRoot '.markdownlint.jsonc'
if (-not (Test-Path $lintConfig)) {
  @"
{
  "config": {
    "extends": "markdownlint-cli2-config-standard",
    "MD013": { "line_length": 120, "tables": false, "code_blocks": false },
    "MD033": { "allowed_elements": ["abbr","details","summary","sup","sub","kbd","mark"] },
    "MD041": false,
    "MD025": { "front_matter_title": "" },
    "MD046": { "style": "fenced" },
    "MD024": { "siblings_only": true }
  }
}
"@ | Set-Content -Encoding UTF8 $lintConfig
}

# Ignore-Datei sicherstellen
$lintIgnore = Join-Path $repoRoot '.markdownlintignore'
if (-not (Test-Path $lintIgnore)) {
  @"
site/
.mkdocs/
overrides/assets/
node_modules/
"@ | Set-Content -Encoding UTF8 $lintIgnore
}

function Invoke-MarkdownLint {
  param([string]$Pattern = 'docs/**/*.md')
  Write-Output "Running markdownlint on $Pattern"
  try {
    Push-Location $repoRoot
    markdownlint-cli2 $Pattern
  } catch {
    Write-Warning "markdownlint meldet Verstöße (nur Report)."
  } finally {
    Pop-Location
  }
}

# ---- 9) Markdown Lint Run (Report only) -----------------------------------
Invoke-MarkdownLint

# ---- 10) Build + optionale Server-Header ----------------------------------
$env:CSP_ENV = "preview"
if (-not (Test-Path '.\mkdocs.yml')) { throw "mkdocs.yml fehlt in $dest" }
mkdocs build # --strict
$hdr = '.\tools\update_server_headers.py'
if (Test-Path $hdr) { python $hdr }

# ---- 11) Serve -------------------------------------------------------------
mkdocs serve -a 127.0.0.1:8000
