# RustGames project publisher wrapper.
# Build/deploy behavior lives in the workspace root publish.ps1.

param(
    [switch]$SkipBuild = $false,
    [switch]$WindowsOnly = $false,
    [switch]$WebGLOnly = $false,
    [switch]$DeployOnly = $false,
    [Alias('p')] [switch]$Production = $false,
    [switch]$FTP = $false,
    [switch]$DryRun = $false,
    [ValidateSet("full", "demo")]
    [string]$Channel = "full"
)

$ErrorActionPreference = "Stop"
$rootPublisher = Join-Path (Split-Path $PSScriptRoot -Parent) "publish.ps1"

if (-not (Test-Path $rootPublisher)) {
    Write-Error "RustGames root publisher not found: $rootPublisher"
    exit 1
}

$previousChannel = [Environment]::GetEnvironmentVariable("CARRIAGE_BUILD_CHANNEL", "Process")
$previousBuildUtc = [Environment]::GetEnvironmentVariable("CARRIAGE_BUILD_UTC", "Process")
$previousCommit = [Environment]::GetEnvironmentVariable("CARRIAGE_BUILD_COMMIT", "Process")
$previousBuildRustflags = [Environment]::GetEnvironmentVariable("CARGO_BUILD_RUSTFLAGS", "Process")
$previousWasmRustflags = [Environment]::GetEnvironmentVariable("CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_RUSTFLAGS", "Process")
try {
    $env:CARRIAGE_BUILD_CHANNEL = $Channel
    $env:CARRIAGE_BUILD_UTC = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $env:CARRIAGE_BUILD_COMMIT = (& git -C $PSScriptRoot rev-parse HEAD).Trim()
    if ($LASTEXITCODE -ne 0) { throw "Could not determine the build commit." }
    $workingTreeChanges = @(& git -C $PSScriptRoot status --porcelain --untracked-files=normal)
    if ($LASTEXITCODE -ne 0) { throw "Could not inspect the build working tree." }
    if ($workingTreeChanges.Count -gt 0) {
        $env:CARRIAGE_BUILD_COMMIT = "$($env:CARRIAGE_BUILD_COMMIT)-dirty"
        Write-Warning "Build provenance is marked dirty because the project has uncommitted files."
    }

    # Panic locations are useful, but absolute build roots disclose local account
    # and checkout names. Keep source-relative diagnostics while making release
    # artifacts reproducible across developer and CI machines.
    $workspaceRoot = [IO.Path]::GetFullPath((Split-Path $PSScriptRoot -Parent))
    $buildProfile = [Environment]::GetFolderPath("UserProfile")
    $remapFlags = @("--remap-path-prefix=$workspaceRoot=source")
    if (-not [string]::IsNullOrWhiteSpace($buildProfile)) {
        $remapFlags += "--remap-path-prefix=$buildProfile=build-user"
    }
    $nativeFlags = @()
    if (-not [string]::IsNullOrWhiteSpace($previousBuildRustflags)) {
        $nativeFlags += $previousBuildRustflags
    }
    $nativeFlags += $remapFlags
    $wasmFlags = @()
    if (-not [string]::IsNullOrWhiteSpace($previousWasmRustflags)) {
        $wasmFlags += $previousWasmRustflags
    }
    $wasmFlags += $remapFlags
    $wasmFlags += @("-C", "link-arg=--import-undefined", "-C", "link-arg=--allow-undefined")
    $env:CARGO_BUILD_RUSTFLAGS = $nativeFlags -join " "
    $env:CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_RUSTFLAGS = $wasmFlags -join " "

    & $rootPublisher -RustGamePublish -ProjectDir $PSScriptRoot `
        -SkipBuild:$SkipBuild `
        -WindowsOnly:$WindowsOnly `
        -WebGLOnly:$WebGLOnly `
        -DeployOnly:$DeployOnly `
        -Production:$Production `
        -FTP:$FTP `
        -DryRun:$DryRun

    if (-not $?) { exit 1 }
    if (-not $SkipBuild -and -not $DeployOnly -and -not $DryRun) {
        $metadata = cargo metadata --manifest-path (Join-Path $PSScriptRoot "Cargo.toml") --locked --no-deps --format-version 1 | ConvertFrom-Json
        if ($LASTEXITCODE -ne 0) { throw "Could not read package metadata for the build record." }
        $package = @($metadata.packages | Where-Object { $_.name -eq "carriage_run" })
        if ($package.Count -ne 1) { throw "Expected one carriage_run package in Cargo metadata." }
        $buildRecord = [ordered]@{
            schema_version = 1
            game = "carriage_run"
            version = $package[0].version
            channel = $env:CARRIAGE_BUILD_CHANNEL
            target = "x86_64-pc-windows-msvc"
            commit = $env:CARRIAGE_BUILD_COMMIT
            built_at_utc = $env:CARRIAGE_BUILD_UTC
            toolkit_revision = (Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot "toolkit.lock")).Trim()
        }
        $buildRecordPath = Join-Path $PSScriptRoot "dist\carriage_run_build_info.json"
        $utf8NoBom = [Text.UTF8Encoding]::new($false)
        [IO.File]::WriteAllText($buildRecordPath, ($buildRecord | ConvertTo-Json) + [Environment]::NewLine, $utf8NoBom)
        Write-Host "Build record: $buildRecordPath"
    }
}
finally {
    $env:CARRIAGE_BUILD_CHANNEL = $previousChannel
    $env:CARRIAGE_BUILD_UTC = $previousBuildUtc
    $env:CARRIAGE_BUILD_COMMIT = $previousCommit
    $env:CARGO_BUILD_RUSTFLAGS = $previousBuildRustflags
    $env:CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_RUSTFLAGS = $previousWasmRustflags
}
