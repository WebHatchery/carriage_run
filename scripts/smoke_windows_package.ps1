<#
.SYNOPSIS
    Launch the packaged Windows build from hostile-but-valid extraction paths.

.DESCRIPTION
    Validates the release ledger, extracts the ZIP into paths containing spaces
    and non-ASCII characters, runs a deterministic title capture from each,
    verifies the embedded commit in stderr, and writes a machine-readable result.
    It detects elevation but cannot create or impersonate another Windows user.
#>
param(
    [string]$Artifact = "dist\carriage_run_windows.zip",
    [ValidateSet("full", "demo")]
    [string]$Channel = "full",
    [string]$Output = "dist\carriage_run_windows_smoke.json",
    [int]$TimeoutSeconds = 60
)

$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot

function Resolve-GamePath([string]$Path) {
    if ([IO.Path]::IsPathRooted($Path)) { return [IO.Path]::GetFullPath($Path) }
    return [IO.Path]::GetFullPath((Join-Path $gameDir $Path))
}

function Invoke-PackageCapture(
    [string]$ExtractedPath,
    [string]$ExpectedCommit,
    [string]$Label
) {
    $exe = Join-Path $ExtractedPath "carriage_run.exe"
    if (-not (Test-Path -LiteralPath $exe -PathType Leaf)) {
        throw "Package test '$Label' has no carriage_run.exe."
    }
    $capturePath = Join-Path $ExtractedPath "package_smoke.png"
    $manifestPath = Join-Path $ExtractedPath "capture_manifest.tsv"
    $stdoutPath = Join-Path $ExtractedPath "capture_stdout.log"
    $stderrPath = Join-Path $ExtractedPath "capture_stderr.log"
    Set-Content -LiteralPath $manifestPath -Value "title`t$capturePath" -Encoding utf8

    $previousManifest = [Environment]::GetEnvironmentVariable("CARRIAGE_CAPTURE_MANIFEST", "Process")
    $previousFrames = [Environment]::GetEnvironmentVariable("CARRIAGE_CAPTURE_FRAMES", "Process")
    $previousHeadless = [Environment]::GetEnvironmentVariable("CARRIAGE_HEADLESS", "Process")
    try {
        $env:CARRIAGE_CAPTURE_MANIFEST = $manifestPath
        $env:CARRIAGE_CAPTURE_FRAMES = "5"
        $env:CARRIAGE_HEADLESS = "1"
        $process = Start-Process `
            -FilePath $exe `
            -WorkingDirectory $ExtractedPath `
            -WindowStyle Hidden `
            -RedirectStandardOutput $stdoutPath `
            -RedirectStandardError $stderrPath `
            -PassThru
        if (-not $process.WaitForExit($TimeoutSeconds * 1000)) {
            $process.Kill()
            throw "Package test '$Label' exceeded $TimeoutSeconds seconds."
        }
        if ($process.ExitCode -ne 0) {
            $details = if (Test-Path -LiteralPath $stderrPath) {
                Get-Content -Raw -LiteralPath $stderrPath
            } else {
                "No stderr log was created."
            }
            throw "Package test '$Label' exited $($process.ExitCode): $details"
        }
    }
    finally {
        $env:CARRIAGE_CAPTURE_MANIFEST = $previousManifest
        $env:CARRIAGE_CAPTURE_FRAMES = $previousFrames
        $env:CARRIAGE_HEADLESS = $previousHeadless
    }

    if (-not (Test-Path -LiteralPath $capturePath -PathType Leaf)) {
        throw "Package test '$Label' did not produce its title capture."
    }
    $captureBytes = (Get-Item -LiteralPath $capturePath).Length
    if ($captureBytes -lt 40000) {
        throw "Package test '$Label' produced a suspiciously small capture ($captureBytes bytes)."
    }
    $stderr = Get-Content -Raw -LiteralPath $stderrPath
    if ($stderr -notlike "*commit=$ExpectedCommit*") {
        throw "Package test '$Label' did not report expected commit $ExpectedCommit."
    }

    [ordered]@{
        label = $Label
        exit_code = 0
        capture_bytes = $captureBytes
        embedded_commit_verified = $true
    }
}

$artifactPath = Resolve-GamePath $Artifact
$outputPath = Resolve-GamePath $Output
$tempBase = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$tempRoot = [IO.Path]::GetFullPath((Join-Path $tempBase "carriage_run_package_smoke_$([Guid]::NewGuid().ToString('N'))"))
if (-not $tempRoot.StartsWith($tempBase, [StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing unsafe temporary root outside $tempBase"
}

Push-Location $gameDir
try {
    & (Join-Path $PSScriptRoot "write_release_manifest.ps1") -Artifact $artifactPath -Channel $Channel
    $manifestPath = Join-Path (Split-Path -Parent $artifactPath) "$([IO.Path]::GetFileNameWithoutExtension($artifactPath))_manifest.json"
    $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json

    New-Item -ItemType Directory -Path $tempRoot | Out-Null
    $cases = @(
        [ordered]@{ label = "spaces"; directory = "Carriage Run Package QA" },
        [ordered]@{ label = "non_ascii"; directory = "Frachtprüfung Élan" }
    )
    $results = foreach ($case in $cases) {
        $extractPath = Join-Path $tempRoot $case.directory
        Expand-Archive -LiteralPath $artifactPath -DestinationPath $extractPath
        Invoke-PackageCapture $extractPath $manifest.commit $case.label
    }

    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    $elevated = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $record = [ordered]@{
        schema_version = 1
        tested_at_utc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        artifact = $manifest.artifact.filename
        artifact_sha256 = $manifest.artifact.sha256
        version = $manifest.version
        channel = $manifest.channel
        commit = $manifest.commit
        target = $manifest.target
        host = [ordered]@{
            os_description = [Runtime.InteropServices.RuntimeInformation]::OSDescription
            os_architecture = [Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()
            process_architecture = [Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture.ToString()
            elevated_token = $elevated
        }
        cases = @($results)
    }
    $outputDirectory = Split-Path -Parent $outputPath
    if ($outputDirectory -and -not (Test-Path -LiteralPath $outputDirectory)) {
        New-Item -ItemType Directory -Path $outputDirectory | Out-Null
    }
    $utf8NoBom = [Text.UTF8Encoding]::new($false)
    [IO.File]::WriteAllText($outputPath, ($record | ConvertTo-Json -Depth 6) + [Environment]::NewLine, $utf8NoBom)

    Write-Host "Packaged Windows path smoke passed: spaces and non-ASCII extraction paths."
    Write-Host "Result: $outputPath"
    if ($elevated) {
        Write-Warning "This process is elevated; a separate standard-user test remains required."
    } else {
        Write-Host "Current process uses a non-elevated token."
    }
}
finally {
    Pop-Location
    if (Test-Path -LiteralPath $tempRoot) {
        $resolvedTempRoot = [IO.Path]::GetFullPath($tempRoot)
        $safeLeaf = [IO.Path]::GetFileName($resolvedTempRoot) -like "carriage_run_package_smoke_*"
        if (-not $safeLeaf -or -not $resolvedTempRoot.StartsWith($tempBase, [StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing unsafe temporary cleanup: $resolvedTempRoot"
        }
        Remove-Item -LiteralPath $resolvedTempRoot -Recurse -Force
    }
}
