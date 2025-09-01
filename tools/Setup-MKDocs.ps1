<#!
.SYNOPSIS
  Setup-MKDocs.ps1 – Windows-PowerShell-Port von tools/setup-mkdocs.sh

.DESCRIPTION
  Erstellt/aktualisiert eine Windows-User-Umgebung für MkDocs + Material.
  Subcommands:
    root   – Systemvoraussetzungen via winget + MSYS2 (Cairo/Pango/GDK-Pixbuf)
    user   – Python-Venv (~/.mkdocs), Requirements, Repo-Sync nach ~/.mkdocs/data
    build  – mkdocs build (preview|production [--strict])
    serve  – mkdocs serve [HOST:PORT] (Standard 127.0.0.1:8000)
    clean  – Cache-/Artefaktbereinigung [--npm]

.PARAMETER Command
  root|user|build|serve|clean. Standard: user

.PARAMETER Arg1
  build: preview|production oder --strict
  serve: HOST:PORT (optional)

.PARAMETER Arg2
  build: --strict
  serve: HOST:PORT (falls Arg1 nicht gesetzt ist)

.EXAMPLE
  ./tools/Setup-MKDocs.ps1 root
  ./tools/Setup-MKDocs.ps1 user
  ./tools/Setup-MKDocs.ps1 build production --strict
  ./tools/Setup-MKDocs.ps1 serve 127.0.0.1:8000
  ./tools/Setup-MKDocs.ps1 clean --npm

.NOTES
  Lizenz: CC BY-NC-SA 4.0
!#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

[CmdletBinding()]
param(
  [Parameter(Position=0)]
  [ValidateSet('root','user','build','serve','clean')]
  [string]$Command = 'user',

  [Parameter(Position=1)]
  [string]$Arg1,

  [Parameter(Position=2)]
  [string]$Arg2,

  [Alias('h','?','help')]
  [switch]$Help
)

function Show-Usage {
  Write-Host @'
Setup-MKDocs.ps1 – Usage

  ./tools/Setup-MKDocs.ps1 [command] [arg1] [arg2]

Commands:
  root                      Installiert Systemvoraussetzungen über winget + MSYS2.
  user                      Legt Venv in ~/.mkdocs an, installiert Pip-Requirements und synchronisiert Repo → ~/.mkdocs/data.
  build [preview|production] [--strict]
                           Baut die Site. "production" nutzt --clean, optional --strict.
  serve [HOST:PORT]        Startet mkdocs serve. Standardadresse: 127.0.0.1:8000.
  clean [--npm]            Entfernt .cache und __pycache__. Mit --npm leert zusätzlich den npm-Cache.
'@
}

if ($Help) { Show-Usage; exit 0 }

# Pfade
$UserProfile = if ($env:USERPROFILE) { $env:USERPROFILE } elseif ($HOME) { $HOME } else { [Environment]::GetFolderPath('UserProfile') }
$MkdocsHome = Join-Path $UserProfile '.mkdocs'
$VenvPython = Join-Path $MkdocsHome 'Scripts/python.exe'
$MkdocsExe  = Join-Path $MkdocsHome 'Scripts/mkdocs.exe'
$DataDir    = Join-Path $MkdocsHome 'data'

function Test-Command {
  param([Parameter(Mandatory)][string]$Name)
  try { Get-Command $Name -ErrorAction Stop | Out-Null; return $true } catch { return $false }
}

function Ensure-WingetPkg {
  param([Parameter(Mandatory)][string]$Id)
  Write-Host "Checking $Id..."
  $out = winget list --id $Id 2>$null
  if (-not ($out -match [regex]::Escape($Id))) {
    Write-Host "Installing $Id..."
    winget install -e --id $Id -h
  }
}

function Invoke-Root {
  if (-not (Test-Command 'winget')) { throw 'winget nicht gefunden. Windows 11 oder manuelle Installation nötig.' }
  Ensure-WingetPkg 'Python.Python.3.11'
  Ensure-WingetPkg 'Git.Git'
  Ensure-WingetPkg 'OpenJS.NodeJS'
  Ensure-WingetPkg 'Graphviz.Graphviz'
  Ensure-WingetPkg 'MSYS2.MSYS2'

  $msys = 'C:/msys64/usr/bin/bash.exe'
  if (Test-Path $msys) {
    & $msys -lc "pacman -S --noconfirm --needed mingw-w64-ucrt-x86_64-cairo mingw-w64-ucrt-x86_64-pango mingw-w64-ucrt-x86_64-gdk-pixbuf2 mingw-w64-ucrt-x86_64-libffi mingw-w64-ucrt-x86_64-pkgconf"
  } else {
    Write-Warning 'MSYS2 nicht gefunden. Starte MSYS2 einmal, damit das Grundsystem initialisiert ist.'
  }
  $ucrt = 'C:/msys64/ucrt64/bin'
  if (-not ($env:Path -like "*$ucrt*")) {
    [Environment]::SetEnvironmentVariable('Path', $env:Path + ";$ucrt", 'User')
    $env:Path = $env:Path + ";$ucrt"
    Write-Host "Added to PATH (User): $ucrt"
  }
}

function New-Or-EnsureVenv {
  if (-not (Test-Path $VenvPython)) {
    Write-Host "Creating venv in $MkdocsHome"
    if (Test-Command 'py') { py -3.11 -m venv $MkdocsHome } else { python -m venv $MkdocsHome }
  }
  & $VenvPython -m pip install --upgrade pip
}

function Sync-Repo {
  if (-not (Test-Path $DataDir)) { New-Item -ItemType Directory -Path $DataDir | Out-Null }
  Write-Host "Sync repo → $DataDir"
  $null = robocopy . $DataDir /MIR /XD .git .venv .mypy_cache .pytest_cache .cache site /R:1 /W:1 /NFL /NDL /NJH /NJS
}

function Invoke-User {
  New-Or-EnsureVenv
  $req = if (Test-Path 'requirements-dev.txt') { 'requirements-dev.txt' } elseif (Test-Path 'requirements.txt') { 'requirements.txt' } else { $null }
  if ($null -ne $req) { & $VenvPython -m pip install -r $req } else { Write-Warning 'Keine requirements-Datei gefunden.' }
  Sync-Repo
}

function Invoke-Build {
  if (-not (Test-Path $MkdocsExe)) { throw 'mkdocs.exe nicht gefunden. Bitte erst "user" ausführen.' }
  $strict  = ($Arg1 -eq '--strict') -or ($Arg2 -eq '--strict')
  $profile = if ($Arg1 -in @('preview','production')) { $Arg1 } elseif ($Arg2 -in @('preview','production')) { $Arg2 } else { 'preview' }
  $args = @('build')
  if ($profile -eq 'production') { $args += '--clean' }
  if ($strict) { $args += '--strict' }
  & $MkdocsExe @args
}

function Parse-ServeAddr {
  if ($Arg1 -and ($Arg1 -like '*:*')) { return $Arg1 }
  if ($Arg2 -and ($Arg2 -like '*:*')) { return $Arg2 }
  return '127.0.0.1:8000'
}

function Invoke-Serve {
  if (-not (Test-Path $MkdocsExe)) { throw 'mkdocs.exe nicht gefunden. Bitte erst "user" ausführen.' }
  $addr = Parse-ServeAddr
  & $MkdocsExe serve -a $addr
}

function Invoke-Clean {
  Remove-Item -Recurse -Force .\.cache -ErrorAction SilentlyContinue
  Get-ChildItem -Recurse -Force -Directory -Filter '__pycache__' -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item -Recurse -Force $_.FullName -ErrorAction SilentlyContinue }
  if ($Arg1 -eq '--npm' -or $Arg2 -eq '--npm') { try { npm cache clean --force } catch { Write-Warning 'npm nicht gefunden oder Fehler beim Leeren des Caches.' } }
}

try {
  switch ($Command) {
    'root'  { Invoke-Root }
    'user'  { Invoke-User }
    'build' { Invoke-Build }
    'serve' { Invoke-Serve }
    'clean' { Invoke-Clean }
    default { Invoke-User; $script:Arg1 = 'production'; $script:Arg2 = '--strict'; Invoke-Build }
  }
}
catch {
  Write-Error $_.Exception.Message
  exit 1
}
