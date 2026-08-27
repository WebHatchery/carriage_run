<#
.SYNOPSIS
    Build and package the contained Option A Windows demo.

.DESCRIPTION
    Uses the explicit Cargo demo feature, copies only registered runtime assets,
    gives the archive an unmistakable demo identity, and runs the existing
    machine-readable manifest validator. It never uploads or deploys.
#>
param([switch]$SkipBuild = $false)

$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot
$distDir = [IO.Path]::GetFullPath((Join-Path $gameDir "dist"))
$stageDir = [IO.Path]::GetFullPath((Join-Path $distDir "demo_windows"))

if (-not $stageDir.StartsWith($distDir, [StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing unsafe demo staging path: $stageDir"
}

$metadata = cargo metadata --manifest-path (Join-Path $gameDir "Cargo.toml") --locked --no-deps --format-version 1 | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw "Could not read locked Cargo metadata." }
$package = @($metadata.packages | Where-Object { $_.name -eq "carriage_run" })
if ($package.Count -ne 1) { throw "Expected one carriage_run package." }
$targetDir = [IO.Path]::GetFullPath([string]$metadata.target_directory)
if (-not ($package[0].features.PSObject.Properties.Name -contains "demo")) {
    throw "Cargo.toml does not expose the required explicit demo feature."
}

$demoMissionPath = Join-Path $gameDir "assets\data\missions_demo.json"
$demoMissions = @(Get-Content -Raw -LiteralPath $demoMissionPath | ConvertFrom-Json)
$expectedIds = @("muddy_road", "bandit_bend", "courier_deadline", "bonebridge_pass")
$actualIds = @($demoMissions | ForEach-Object { $_.id })
if (($actualIds -join "|") -ne ($expectedIds -join "|")) {
    throw "Demo mission data must contain exactly the approved Option A contracts in order."
}

$commit = (& git -C $gameDir rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0) { throw "Could not determine the build commit." }
$changes = @(& git -C $gameDir status --porcelain --untracked-files=normal)
if ($LASTEXITCODE -ne 0) { throw "Could not inspect the build working tree." }
$recordedCommit = if ($changes.Count -gt 0) { "$commit-dirty" } else { $commit }
$builtAtUtc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

$priorChannel = $env:CARRIAGE_BUILD_CHANNEL
$priorCommit = $env:CARRIAGE_BUILD_COMMIT
$priorUtc = $env:CARRIAGE_BUILD_UTC
$priorRustflags = $env:CARGO_BUILD_RUSTFLAGS
try {
    $env:CARRIAGE_BUILD_CHANNEL = "demo"
    $env:CARRIAGE_BUILD_COMMIT = $recordedCommit
    $env:CARRIAGE_BUILD_UTC = $builtAtUtc
    $workspaceRoot = [IO.Path]::GetFullPath((Split-Path $gameDir -Parent))
    $buildProfile = [Environment]::GetFolderPath("UserProfile")
    $remapFlags = @("--remap-path-prefix=$workspaceRoot=source")
    if (-not [string]::IsNullOrWhiteSpace($buildProfile)) {
        $remapFlags += "--remap-path-prefix=$buildProfile=build-user"
    }
    $nativeFlags = @()
    if (-not [string]::IsNullOrWhiteSpace($priorRustflags)) {
        $nativeFlags += $priorRustflags
    }
    $nativeFlags += $remapFlags
    $env:CARGO_BUILD_RUSTFLAGS = $nativeFlags -join " "
    if (-not $SkipBuild) {
        Push-Location $gameDir
        try {
            cargo build --locked --release --features demo --bin carriage_run
            if ($LASTEXITCODE -ne 0) { throw "Demo release build failed." }
        }
        finally { Pop-Location }
    }
}
finally {
    $env:CARRIAGE_BUILD_CHANNEL = $priorChannel
    $env:CARRIAGE_BUILD_COMMIT = $priorCommit
    $env:CARRIAGE_BUILD_UTC = $priorUtc
    $env:CARGO_BUILD_RUSTFLAGS = $priorRustflags
}

$exePath = Join-Path $targetDir "release\carriage_run.exe"
if (-not (Test-Path -LiteralPath $exePath -PathType Leaf)) {
    throw "Demo executable not found: $exePath"
}
if (Test-Path -LiteralPath $stageDir) {
    Remove-Item -LiteralPath $stageDir -Recurse -Force
}
New-Item -ItemType Directory -Path $stageDir -Force | Out-Null
Copy-Item -LiteralPath $exePath -Destination (Join-Path $stageDir "carriage_run.exe")

$assetRegistry = Get-Content -Raw -LiteralPath (Join-Path $gameDir "asset_registry.json") | ConvertFrom-Json
foreach ($relativeAsset in $assetRegistry.assets) {
    $source = [IO.Path]::GetFullPath((Join-Path $gameDir $relativeAsset))
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw "Registered demo runtime asset is missing: $relativeAsset"
    }
    $destination = Join-Path $stageDir $relativeAsset
    New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
    Copy-Item -LiteralPath $source -Destination $destination
}

$archiveName = "carriage_run_demo_$($package[0].version)_x86_64-pc-windows-msvc.zip"
$archivePath = Join-Path $distDir $archiveName
if (Test-Path -LiteralPath $archivePath) { Remove-Item -LiteralPath $archivePath -Force }
Compress-Archive -Path (Join-Path $stageDir "*") -DestinationPath $archivePath -CompressionLevel Optimal
Remove-Item -LiteralPath $stageDir -Recurse -Force

$buildInfo = [ordered]@{
    schema_version = 1
    game = "carriage_run"
    version = $package[0].version
    channel = "demo"
    target = "x86_64-pc-windows-msvc"
    commit = $recordedCommit
    built_at_utc = $builtAtUtc
    toolkit_revision = (Get-Content -Raw -LiteralPath (Join-Path $gameDir "toolkit.lock")).Trim()
}
$buildInfoPath = Join-Path $distDir "carriage_run_demo_build_info.json"
$utf8NoBom = [Text.UTF8Encoding]::new($false)
[IO.File]::WriteAllText($buildInfoPath, ($buildInfo | ConvertTo-Json) + [Environment]::NewLine, $utf8NoBom)

if ($recordedCommit.EndsWith("-dirty")) {
    Write-Warning "Demo candidate is marked dirty; manifest validation requires a committed tree."
} else {
    & (Join-Path $PSScriptRoot "write_release_manifest.ps1") -Artifact $archivePath -Channel demo -BuildInfo $buildInfoPath
    if ($LASTEXITCODE -ne 0) { throw "Demo manifest validation failed." }
}

Write-Host "Contained Windows demo candidate: $archivePath"
