<#
.SYNOPSIS
    Capture every release scene across distinct window aspect ratios.

.DESCRIPTION
    Records requested outer-window and measured drawable sizes for 16:9,
    16:10, wide, and small-window stress cases. This is local layout evidence,
    not Windows DPI or multi-monitor compatibility evidence.
#>
param(
    [int]$Frames = 90,
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot
$outputRoot = Join-Path $gameDir "dist\window_layout_audit"
$scenes = @("title", "map", "loadout", "shop", "guards", "upgrades", "settings", "gameplay")
$cases = @(
    [pscustomobject]@{ Name = "16x9"; Width = 1280; Height = 720 },
    [pscustomobject]@{ Name = "16x10"; Width = 1280; Height = 800 },
    [pscustomobject]@{ Name = "wide"; Width = 1920; Height = 800 },
    [pscustomobject]@{ Name = "small"; Width = 800; Height = 600 }
)

$head = (& git -C $gameDir rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0) { throw "Could not determine source commit." }
$changes = @(& git -C $gameDir status --porcelain --untracked-files=normal)
if ($LASTEXITCODE -ne 0) { throw "Could not inspect the source working tree." }
$expectedCommit = if ($changes.Count -gt 0) { "$head-dirty" } else { $head }

if (-not $SkipBuild) {
    & (Join-Path $gameDir "publish.ps1") -WindowsOnly
    if ($LASTEXITCODE -ne 0) { throw "Windows release publisher failed." }
}
$buildInfoPath = Join-Path $gameDir "dist\carriage_run_build_info.json"
if (-not (Test-Path -LiteralPath $buildInfoPath -PathType Leaf)) {
    throw "Build provenance is missing: $buildInfoPath"
}
$buildInfo = Get-Content -Raw -LiteralPath $buildInfoPath | ConvertFrom-Json
if ($buildInfo.commit -ne $expectedCommit) {
    throw "Release binary provenance '$($buildInfo.commit)' does not match source '$expectedCommit'."
}

Add-Type -AssemblyName System.Drawing
$surfaceKeys = New-Object System.Collections.Generic.HashSet[string]
$results = @()
foreach ($case in $cases) {
    $captureDir = "dist\window_layout_audit\$($case.Name)"
    $processPath = "dist\window_layout_audit\$($case.Name)_process.json"
    & (Join-Path $gameDir "scripts\capture_ui.ps1") -Scenes $scenes -Frames $Frames `
        -WindowWidth $case.Width -WindowHeight $case.Height -OutputDir $captureDir `
        -ProcessReportPath $processPath -SkipBuild -Release
    if ($LASTEXITCODE -ne 0) { throw "Window-layout capture failed for $($case.Name)." }

    $files = @()
    $sizes = New-Object System.Collections.Generic.HashSet[string]
    foreach ($scene in $scenes) {
        $path = Join-Path $gameDir "$captureDir\ui_$scene.png"
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Missing capture: $path" }
        $image = [Drawing.Image]::FromFile($path)
        try {
            $size = "$($image.Width)x$($image.Height)"
            $null = $sizes.Add($size)
            $files += [pscustomobject][ordered]@{
                scene = $scene
                file = "$captureDir/ui_$scene.png".Replace("\", "/")
                size_bytes = (Get-Item -LiteralPath $path).Length
                sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash.ToLowerInvariant()
            }
        }
        finally { $image.Dispose() }
    }
    if ($sizes.Count -ne 1) {
        throw "$($case.Name) scenes used inconsistent drawable sizes: $(@($sizes) -join ', ')."
    }
    $surface = @($sizes)[0]
    if (-not $surfaceKeys.Add($surface)) {
        throw "$($case.Name) duplicated drawable surface $surface; the matrix is not testing distinct layouts."
    }
    $parts = $surface.Split('x')
    $process = Get-Content -Raw -LiteralPath (Join-Path $gameDir $processPath) | ConvertFrom-Json
    if ($process.scenes -ne $scenes.Count -or $process.frames_per_scene -ne $Frames) {
        throw "$($case.Name) process report does not match the requested scene batch."
    }
    $results += [pscustomobject][ordered]@{
        label = $case.Name
        requested_outer_width = $case.Width
        requested_outer_height = $case.Height
        drawable_width = [int]$parts[0]
        drawable_height = [int]$parts[1]
        files = $files
    }
}

$record = [ordered]@{
    schema_version = 1
    captured_at_utc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    source_commit = $expectedCommit
    toolkit_revision = $buildInfo.toolkit_revision
    frames_per_scene = $Frames
    interpretation = "Local drawable/layout evidence only; not Windows DPI, multi-monitor, GPU, or input compatibility evidence"
    cases = @($results)
}
New-Item -ItemType Directory -Path $outputRoot -Force | Out-Null
$outputPath = Join-Path $outputRoot "carriage_run_window_layout_audit.json"
$utf8NoBom = [Text.UTF8Encoding]::new($false)
[IO.File]::WriteAllText($outputPath, ($record | ConvertTo-Json -Depth 8) + [Environment]::NewLine, $utf8NoBom)
Write-Host "Window-layout audit passed: $outputPath"
