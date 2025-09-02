#Requires -Version 5.1
<#
.SYNOPSIS
    Manage PATH environment variable at user or machine scope.

.DESCRIPTION
    Supports add, remove, list, backup, restore, clean duplicates,
    show effective PATH (Machine+User), and search for entries by keyword.

.PARAMETER Scope
    "User" (default, no admin required) or "Machine" (admin required).

.PARAMETER AddPath
    Path to add.

.PARAMETER RemovePath
    Path to remove (all duplicates removed).

.PARAMETER List
    Show PATH entries for the given scope.

.PARAMETER Backup
    Save PATH for the given scope to a .reg file.

.PARAMETER Restore
    Restore PATH for the given scope from a .reg file.

.PARAMETER CleanDuplicates
    Remove duplicate PATH entries in the given scope.

.PARAMETER Effective
    Show effective PATH (Machine + User merged).

.PARAMETER Search
    Show PATH entries containing the given keyword.

.EXAMPLE
    .\Manage-Path.ps1 -Scope User -List

.EXAMPLE
    .\Manage-Path.ps1 -Scope Machine -AddPath "C:\Java\jdk-22.0.1\bin"

.EXAMPLE
    .\Manage-Path.ps1 -Effective

.EXAMPLE
    .\Manage-Path.ps1 -Scope User -Search "Python"
#>

param (
    [ValidateSet("User","Machine")]
    [string]$Scope = "User",

    [string]$AddPath,
    [string]$RemovePath,
    [switch]$List,
    [string]$Backup,
    [string]$Restore,
    [switch]$CleanDuplicates,
    [switch]$Effective,
    [string]$Search
)

# Helper to notify Windows of env var changes
function Update-Environment {
    $signature = @'
    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr SendMessageTimeout(
        IntPtr hWnd, uint Msg, IntPtr wParam, string lParam,
        uint fuFlags, uint uTimeout, out IntPtr lpdwResult);
'@
    $user32 = Add-Type -MemberDefinition $signature -Name 'Win32SendMessageTimeout' -Namespace Win32Functions -PassThru
    $HWND_BROADCAST = [IntPtr]0xffff
    $WM_SETTINGCHANGE = 0x1A
    $result = [IntPtr]::Zero
    [void]$user32::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [IntPtr]::Zero, "Environment", 2, 5000, [ref]$result)
    Write-Host "$Scope environment updated. Restart terminals to see changes."
}

# Ensure only one action
$setParams = @($AddPath, $RemovePath, $List, $Backup, $Restore, $CleanDuplicates, $Effective, $Search) | Where-Object { $_ }
if ($setParams.Count -eq 0) {
    Write-Error "You must specify an action (-AddPath, -RemovePath, -List, -Backup, -Restore, -CleanDuplicates, -Effective, -Search)."
    exit 1
}
if ($setParams.Count -gt 1) {
    Write-Error "Use only one action at a time."
    exit 1
}

# Registry key paths
if ($Scope -eq "Machine") {
    $regKeyPath = 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
    $root = [Microsoft.Win32.Registry]::LocalMachine
} else {
    $regKeyPath = 'Environment'
    $root = [Microsoft.Win32.Registry]::CurrentUser
}

try {
    # Handle Effective separately
    if ($Effective) {
        $machineKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment')
        $userKey    = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment')

        $machinePath = $machineKey.GetValue('Path', '', 'DoNotExpandEnvironmentNames')
        $userPath    = $userKey.GetValue('Path', '', 'DoNotExpandEnvironmentNames')

        $paths = @()
        if ($machinePath) { $paths += ($machinePath -split ';' | Where-Object { $_ -ne '' }) }
        if ($userPath)    { $paths += ($userPath    -split ';' | Where-Object { $_ -ne '' }) }

        if ($Search) {
            $filtered = $paths | Where-Object { $_ -match [Regex]::Escape($Search) }
            Write-Host "Effective PATH entries matching '$Search':`n"
            $i = 1
            foreach ($p in $filtered) { Write-Host ("{0,2}. {1}" -f $i, $p); $i++ }
        } else {
            Write-Host "Effective PATH (Machine + User):`n"
            $i = 1
            foreach ($p in $paths) { Write-Host ("{0,2}. {1}" -f $i, $p); $i++ }
        }
        return
    }

    $key = $root.OpenSubKey($regKeyPath, $true)
    if (-not $key) { throw "Unable to open registry key: $Scope\$regKeyPath" }

    $oldPath = $key.GetValue('Path', '', 'DoNotExpandEnvironmentNames')
    $paths = $oldPath -split ';' | Where-Object { $_ -ne '' }

    if ($List) {
        Write-Host "$Scope PATH entries:`n"
        $i = 1
        foreach ($p in $paths) { Write-Host ("{0,2}. {1}" -f $i, $p); $i++ }
        return
    }

    if ($Search) {
        $filtered = $paths | Where-Object { $_ -match [Regex]::Escape($Search) }
        Write-Host "$Scope PATH entries matching '$Search':`n"
        $i = 1
        foreach ($p in $filtered) { Write-Host ("{0,2}. {1}" -f $i, $p); $i++ }
        return
    }

    if ($Backup) {
        if (-not (Test-Path (Split-Path $Backup -Parent))) {
            New-Item -ItemType Directory -Path (Split-Path $Backup -Parent) -Force | Out-Null
        }
        if ($Scope -eq "Machine") {
            reg export "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "$Backup" /y | Out-Null
        } else {
            reg export "HKCU\Environment" "$Backup" /y | Out-Null
        }
        Write-Host "$Scope PATH exported to: $Backup"
        return
    }

    if ($Restore) {
        if (-not (Test-Path $Restore)) { throw "Backup file not found: $Restore" }
        reg import "$Restore" | Out-Null
        Write-Host "$Scope PATH restored from: $Restore"
        Update-Environment
        return
    }

    if ($CleanDuplicates) {
        $unique = [System.Collections.Generic.HashSet[string]]::new()
        $cleaned = @()
        foreach ($p in $paths) { if ($unique.Add($p)) { $cleaned += $p } }
        if ($cleaned.Count -eq $paths.Count) {
            Write-Host "No duplicates found in PATH."
        } else {
            $newPath = $cleaned -join ';'
            $key.SetValue('Path', $newPath, 'ExpandString')
            Write-Host "Removed duplicate entries from $Scope PATH."
            Update-Environment
        }
        return
    }

    if ($AddPath) {
        $AddPath = $AddPath.TrimEnd('\')
        if ($paths -contains $AddPath) {
            Write-Host "Path already exists. No changes."
        } else {
            $newPath = ($paths + $AddPath) -join ';'
            $key.SetValue('Path', $newPath, 'ExpandString')
            Write-Host "Added '$AddPath' to $Scope PATH."
            Update-Environment
        }
        return
    }

    if ($RemovePath) {
        $RemovePath = $RemovePath.TrimEnd('\')
        if ($paths -notcontains $RemovePath) {
            Write-Host "Path not found. No changes."
        } else {
            $newPath = ($paths | Where-Object { $_ -ne $RemovePath }) -join ';'
            $key.SetValue('Path', $newPath, 'ExpandString')
            Write-Host "Removed all occurrences of '$RemovePath' from $Scope PATH."
            Update-Environment
        }
        return
    }
}
catch { Write-Error "Error: $_" }
finally { if ($null -ne $key) { $key.Dispose() } }
