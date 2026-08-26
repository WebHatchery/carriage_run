<#
.SYNOPSIS
    Reject absolute build-machine paths in packaged release binaries.

.DESCRIPTION
    Extracts the exact Windows archive, scans executable runtime files as raw
    bytes, and records a machine-readable result. Rust's virtual `/rustc/<hash>`
    standard-library paths and source-relative project paths are intentionally
    allowed; local checkout, account-profile, and Cargo-home paths are not.
#>
param(
    [string]$Artifact = "dist\carriage_run_windows.zip",
    [string]$Output = "dist\carriage_run_windows_path_audit.json"
)

$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot

function Resolve-GamePath([string]$Path) {
    if ([IO.Path]::IsPathRooted($Path)) { return [IO.Path]::GetFullPath($Path) }
    return [IO.Path]::GetFullPath((Join-Path $gameDir $Path))
}

$artifactPath = Resolve-GamePath $Artifact
$outputPath = Resolve-GamePath $Output
if (-not (Test-Path -LiteralPath $artifactPath -PathType Leaf)) {
    throw "Release archive not found: $artifactPath"
}

$tempBase = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$tempRoot = [IO.Path]::GetFullPath((Join-Path $tempBase "carriage_run_path_audit_$([Guid]::NewGuid().ToString('N'))"))
if (-not $tempRoot.StartsWith($tempBase, [StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing unsafe temporary root outside $tempBase"
}

try {
    Expand-Archive -LiteralPath $artifactPath -DestinationPath $tempRoot
    $runtimeFiles = @(Get-ChildItem -LiteralPath $tempRoot -Recurse -File | Where-Object {
        $_.Extension -in @(".exe", ".dll", ".wasm", ".pdb")
    })
    if ($runtimeFiles.Count -eq 0) {
        throw "Release archive contains no executable runtime files to audit."
    }

    $workspaceRoot = [IO.Path]::GetFullPath((Split-Path $gameDir -Parent))
    $buildProfile = [Environment]::GetFolderPath("UserProfile")
    $cargoHome = [Environment]::GetEnvironmentVariable("CARGO_HOME", "Process")
    $literalFragments = @($workspaceRoot, $gameDir, $buildProfile, $cargoHome) |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        ForEach-Object { $_, ($_.Replace("\", "/")) } |
        Sort-Object -Unique
    $genericPatterns = @(
        '(?i)[a-z]:[\\/]users[\\/][^\\/]+[\\/]',
        '(?i)/home/[^/]+/',
        '(?i)users[\\/][^\\/]+[\\/]\.cargo[\\/]'
    )

    $findings = New-Object System.Collections.Generic.List[object]
    foreach ($file in $runtimeFiles) {
        $text = [Text.Encoding]::Latin1.GetString([IO.File]::ReadAllBytes($file.FullName))
        foreach ($fragment in $literalFragments) {
            if ($text.IndexOf($fragment, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
                $findings.Add([pscustomobject]@{ file = $file.Name; rule = "known_build_root" })
            }
        }
        foreach ($pattern in $genericPatterns) {
            if ([regex]::IsMatch($text, $pattern)) {
                $findings.Add([pscustomobject]@{ file = $file.Name; rule = "absolute_user_profile" })
            }
        }
    }

    $findings = @($findings | Sort-Object file, rule -Unique)
    if ($findings.Count -gt 0) {
        $summary = $findings | ForEach-Object { "$($_.file):$($_.rule)" }
        throw "Release path audit found build-machine disclosure: $($summary -join ', ')"
    }

    $record = [ordered]@{
        schema_version = 1
        audited_at_utc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        artifact = [IO.Path]::GetFileName($artifactPath)
        artifact_sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $artifactPath).Hash.ToLowerInvariant()
        scanned_files = @($runtimeFiles | ForEach-Object { $_.Name } | Sort-Object -Unique)
        result = "passed_no_absolute_build_paths"
        allowed = @("source-relative project paths", "/rustc/<toolchain-hash> standard-library paths")
    }
    $outputDirectory = Split-Path -Parent $outputPath
    if ($outputDirectory -and -not (Test-Path -LiteralPath $outputDirectory)) {
        New-Item -ItemType Directory -Path $outputDirectory | Out-Null
    }
    $utf8NoBom = [Text.UTF8Encoding]::new($false)
    [IO.File]::WriteAllText($outputPath, ($record | ConvertTo-Json -Depth 5) + [Environment]::NewLine, $utf8NoBom)

    Write-Host "Release path audit passed: no absolute build-machine paths in $($runtimeFiles.Count) runtime file(s)."
    Write-Host "Evidence: $outputPath"
}
finally {
    if (Test-Path -LiteralPath $tempRoot) {
        $resolvedTempRoot = [IO.Path]::GetFullPath($tempRoot)
        $safeLeaf = [IO.Path]::GetFileName($resolvedTempRoot) -like "carriage_run_path_audit_*"
        if (-not $safeLeaf -or -not $resolvedTempRoot.StartsWith($tempBase, [StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing unsafe temporary cleanup: $resolvedTempRoot"
        }
        Remove-Item -LiteralPath $resolvedTempRoot -Recurse -Force
    }
}
