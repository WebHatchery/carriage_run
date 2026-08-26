<#
.SYNOPSIS
    Install one generated QA save into a distinct local Carriage Run slot.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet(
        "demoqa_start",
        "demoqa_fork_bandit",
        "demoqa_fork_courier",
        "demoqa_final_bandit",
        "demoqa_final_courier"
    )]
    [string]$Fixture,
    [switch]$ReplaceExisting
)

$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot
$source = [IO.Path]::GetFullPath((Join-Path $gameDir "dist\playtest_saves\save_$Fixture.json"))
if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
    throw "Fixture not found. Run scripts\generate_playtest_saves.ps1 first."
}

$localData = [Environment]::GetFolderPath("LocalApplicationData")
if ([string]::IsNullOrWhiteSpace($localData)) { throw "Local application-data path is unavailable." }
$saveRoot = [IO.Path]::GetFullPath((Join-Path $localData "carriage_run"))
$destination = [IO.Path]::GetFullPath((Join-Path $saveRoot "save_$Fixture.json"))
if (-not $destination.StartsWith($saveRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing a save destination outside the Carriage Run data directory."
}

if (Test-Path -LiteralPath $destination) {
    if (-not $ReplaceExisting) {
        throw "The $Fixture slot already exists. Re-run with -ReplaceExisting to preserve and replace it."
    }
    $stamp = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
    $backupRoot = Join-Path $saveRoot "_qa_fixture_backups"
    $backup = Join-Path $backupRoot "save_${Fixture}_before_fixture_$stamp.json"
    if ($PSCmdlet.ShouldProcess($destination, "Preserve existing slot as $backup")) {
        if (-not (Test-Path -LiteralPath $backupRoot)) {
            New-Item -ItemType Directory -Path $backupRoot | Out-Null
        }
        Copy-Item -LiteralPath $destination -Destination $backup
        Write-Host "Existing slot preserved as: $backup"
    }
}

if ($PSCmdlet.ShouldProcess($destination, "Install generated playtest save")) {
    if (-not (Test-Path -LiteralPath $saveRoot)) {
        New-Item -ItemType Directory -Path $saveRoot | Out-Null
    }
    Copy-Item -LiteralPath $source -Destination $destination
    Write-Host "Installed playtest slot '$Fixture': $destination"
    Write-Host "Open SETTINGS, select the slot, then choose LOAD."
}
