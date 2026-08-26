<#
.SYNOPSIS
    Validate and describe a packaged Windows release candidate.

.DESCRIPTION
    Rejects non-runtime material, hashes the archive and every contained file,
    then writes a machine-readable manifest and SHA-256 sidecar. This script
    records provenance; it does not replace product or release approval.
#>
param(
    [string]$Artifact = "dist\carriage_run_windows.zip",
    [ValidateSet("full", "demo")]
    [string]$Channel = "full",
    [string]$Output,
    [string]$BuildInfo = "dist\carriage_run_build_info.json"
)

$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot

function Resolve-GamePath([string]$Path) {
    if ([IO.Path]::IsPathRooted($Path)) { return [IO.Path]::GetFullPath($Path) }
    return [IO.Path]::GetFullPath((Join-Path $gameDir $Path))
}

function Get-StreamSha256([IO.Stream]$Stream) {
    $sha256 = [Security.Cryptography.SHA256]::Create()
    try {
        return ([BitConverter]::ToString($sha256.ComputeHash($Stream))).Replace("-", "").ToLowerInvariant()
    }
    finally {
        $sha256.Dispose()
    }
}

$artifactPath = Resolve-GamePath $Artifact
if (-not (Test-Path -LiteralPath $artifactPath -PathType Leaf)) {
    throw "Missing release artifact: $artifactPath. Run .\publish.ps1 first."
}
if ([IO.Path]::GetExtension($artifactPath) -ne ".zip") {
    throw "Release manifest input must be a ZIP archive: $artifactPath"
}
if ($Channel -eq "demo" -and [IO.Path]::GetFileName($artifactPath) -notmatch '(?i)demo') {
    throw "A demo-channel archive must include 'demo' in its filename so it cannot be confused with the full build."
}

$artifactDirectory = Split-Path -Parent $artifactPath
$artifactBaseName = [IO.Path]::GetFileNameWithoutExtension($artifactPath)
$outputPath = if ($Output) {
    Resolve-GamePath $Output
} else {
    Join-Path $artifactDirectory "${artifactBaseName}_manifest.json"
}
$checksumPath = "${artifactPath}.sha256"
$buildInfoPath = Resolve-GamePath $BuildInfo
if (-not (Test-Path -LiteralPath $buildInfoPath -PathType Leaf)) {
    throw "Missing publisher build record: $buildInfoPath. Run .\publish.ps1 first."
}

Push-Location $gameDir
try {
    $metadata = cargo metadata --manifest-path (Join-Path $gameDir "Cargo.toml") --locked --no-deps --format-version 1 | ConvertFrom-Json
    if ($LASTEXITCODE -ne 0) { throw "Could not read locked Cargo metadata." }
    $package = @($metadata.packages | Where-Object { $_.name -eq "carriage_run" })
    if ($package.Count -ne 1) { throw "Expected exactly one carriage_run package in Cargo metadata." }

    $commit = (& git rev-parse HEAD).Trim()
    if ($LASTEXITCODE -ne 0) { throw "Could not read the release commit." }
    $toolkitRevision = (Get-Content -Raw -LiteralPath (Join-Path $gameDir "toolkit.lock")).Trim()
    if ($toolkitRevision -notmatch '^[0-9a-f]{40}$') { throw "toolkit.lock does not contain a full Git revision." }
    $buildInfoRecord = Get-Content -Raw -LiteralPath $buildInfoPath | ConvertFrom-Json
    $expectedBuildInfo = [ordered]@{
        schema_version = 1
        game = "carriage_run"
        version = $package[0].version
        channel = $Channel
        target = "x86_64-pc-windows-msvc"
        commit = $commit
        toolkit_revision = $toolkitRevision
    }
    foreach ($field in $expectedBuildInfo.Keys) {
        if ($buildInfoRecord.$field -ne $expectedBuildInfo[$field]) {
            throw "Publisher build record $field mismatch: expected '$($expectedBuildInfo[$field])', found '$($buildInfoRecord.$field)'."
        }
    }
    $builtAtUtc = if ($buildInfoRecord.built_at_utc -is [DateTime]) {
        $buildInfoRecord.built_at_utc.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    } else {
        [string]$buildInfoRecord.built_at_utc
    }
    if ($builtAtUtc -notmatch '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$') {
        throw "Publisher build record has an invalid UTC timestamp: $builtAtUtc"
    }

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [IO.Compression.ZipFile]::OpenRead($artifactPath)
    try {
        $entries = @($archive.Entries | Where-Object { -not $_.FullName.EndsWith("/") })
        $executables = @($entries | Where-Object { [IO.Path]::GetExtension($_.FullName) -ieq ".exe" })
        if ($executables.Count -ne 1) {
            throw "Windows release must contain exactly one executable; found $($executables.Count)."
        }

        $forbiddenPatterns = @(
            '(?i)(^|/)(cargo\.toml|cargo\.lock)$',
            '(?i)\.(pdb|rs|rlib|rmeta|wasm|html?|js|map)$',
            '(?i)(^|/)(crash[^/]*\.log|save_[^/]*\.json)$',
            '(?i)(^|/)(tests?|benches?|examples?)(/|$)',
            '(?i)(^|/)(\.env[^/]*|credentials?[^/]*|secrets?[^/]*|id_rsa[^/]*)$'
        )
        foreach ($entry in $entries) {
            $normalized = $entry.FullName.Replace('\', '/')
            if ($normalized.StartsWith("/") -or $normalized -match '(^|/)\.\.(/|$)') {
                throw "Unsafe archive path: $normalized"
            }
            foreach ($pattern in $forbiddenPatterns) {
                if ($normalized -match $pattern) { throw "Forbidden release archive entry: $normalized" }
            }
        }

        $files = @($entries | Sort-Object FullName | ForEach-Object {
            $stream = $_.Open()
            try {
                [ordered]@{
                    path = $_.FullName.Replace('\', '/')
                    size_bytes = $_.Length
                    sha256 = Get-StreamSha256 $stream
                }
            }
            finally {
                $stream.Dispose()
            }
        })
    }
    finally {
        $archive.Dispose()
    }

    $artifactInfo = Get-Item -LiteralPath $artifactPath
    $artifactHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $artifactPath).Hash.ToLowerInvariant()
    $manifest = [ordered]@{
        schema_version = 1
        game = "carriage_run"
        version = $package[0].version
        channel = $Channel
        target = "x86_64-pc-windows-msvc"
        commit = $commit
        built_at_utc = $builtAtUtc
        toolkit_revision = $toolkitRevision
        artifact = [ordered]@{
            filename = $artifactInfo.Name
            size_bytes = $artifactInfo.Length
            sha256 = $artifactHash
        }
        files = $files
    }

    $outputDirectory = Split-Path -Parent $outputPath
    if ($outputDirectory -and -not (Test-Path -LiteralPath $outputDirectory)) {
        New-Item -ItemType Directory -Path $outputDirectory | Out-Null
    }
    $utf8NoBom = [Text.UTF8Encoding]::new($false)
    [IO.File]::WriteAllText($outputPath, ($manifest | ConvertTo-Json -Depth 6) + [Environment]::NewLine, $utf8NoBom)
    [IO.File]::WriteAllText($checksumPath, "$artifactHash  $($artifactInfo.Name)$([Environment]::NewLine)", $utf8NoBom)

    Write-Host "Release package validation passed: $($files.Count) runtime files, one executable."
    Write-Host "Manifest: $outputPath"
    Write-Host "Checksum: $checksumPath"
    Write-Host "SHA-256: $artifactHash"
}
finally {
    Pop-Location
}
