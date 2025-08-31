#Requires -Version 7
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Write-Host "=== RootService MkDocs Cleanup Script ==="

# ---- 1) Zu entfernende Verzeichnisse ----
$paths = @(
    "..\.venv",
    "..\.mkdocs",
    "..\site",
    "..\.pytest_cache",
    "..\.mypy_cache",
    "..\.ruff_cache"
)

foreach ($p in $paths) {
    if (Test-Path $p) {
        Write-Host ">> Entferne $p"
        Remove-Item -Recurse -Force -LiteralPath $p
    }
}

# ---- 2) Python Cache-Dateien löschen ----
Write-Host ">> Entferne __pycache__ Verzeichnisse"
Get-ChildItem .. -Recurse -Force -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -eq "__pycache__" } |
    ForEach-Object { Remove-Item -Recurse -Force -LiteralPath $_.FullName }

# ---- 3) NPM Cache optional leeren ----
if ($args -contains "--npm") {
    Write-Host ">> Leere npm Cache"
    try { npm cache clean --force } catch { Write-Warning "npm nicht verfügbar" }
}

Write-Host ">> Cleanup abgeschlossen."
