<# Verifies the source and package guardrails for the approved Option A slice. #>
param([string]$Artifact)

$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot
$missions = @(Get-Content -Raw -LiteralPath (Join-Path $gameDir "assets\data\missions_demo.json") | ConvertFrom-Json)
$expected = @("muddy_road", "bandit_bend", "courier_deadline", "bonebridge_pass")
if ((@($missions.id) -join "|") -ne ($expected -join "|")) {
    throw "Demo content differs from the approved Option A contract list."
}
$bonebridge = $missions | Where-Object id -eq "bonebridge_pass"
if ((@($bonebridge.unlock_any_missions) -join "|") -ne "bandit_bend|courier_deadline") {
    throw "Bonebridge must reunite either approved middle branch."
}
$source = Get-Content -Raw -LiteralPath (Join-Path $gameDir "src\data.rs")
if ($source -notmatch 'cfg\(feature = "demo"\)' -or $source -notmatch 'missions_demo\.json') {
    throw "The demo mission payload is not selected by an explicit compile-time feature."
}

if ($Artifact) {
    $artifactPath = if ([IO.Path]::IsPathRooted($Artifact)) {
        [IO.Path]::GetFullPath($Artifact)
    } else {
        [IO.Path]::GetFullPath((Join-Path $gameDir $Artifact))
    }
    if ([IO.Path]::GetFileName($artifactPath) -notmatch '(?i)^carriage_run_demo_.+_x86_64-pc-windows-msvc\.zip$') {
        throw "Demo archive identity is ambiguous: $artifactPath"
    }
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [IO.Compression.ZipFile]::OpenRead($artifactPath)
    try {
        $entries = @($archive.Entries | Where-Object { -not $_.FullName.EndsWith("/") })
        if (@($entries | Where-Object { $_.FullName -match '(?i)missions.*\.json$' }).Count -ne 0) {
            throw "Demo archive exposes mission source data outside the executable."
        }
        if (@($entries | Where-Object { $_.FullName -ieq "carriage_run.exe" }).Count -ne 1) {
            throw "Demo archive must contain exactly one carriage_run.exe."
        }
    }
    finally { $archive.Dispose() }
}

Write-Host "Option A demo contract verification passed."
