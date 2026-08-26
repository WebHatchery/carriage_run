<#
.SYNOPSIS
    Capture repeatable CPU timing evidence for representative game scenes.

.DESCRIPTION
    Profiles deterministic release-mode update and draw-command submission at
    three window shapes. This is a regression aid, not physical-GPU, minimum-PC,
    frame-pacing, or long-session evidence.
#>
param(
    [int]$Frames = 300,
    [string[]]$Scenes = @("gameplay", "map", "settings"),
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot
$outputRoot = [IO.Path]::GetFullPath((Join-Path $gameDir "dist\performance"))

if (-not $SkipBuild) {
    & (Join-Path $gameDir "publish.ps1") -WindowsOnly
    if ($LASTEXITCODE -ne 0) { throw "Windows release publisher failed." }
}

$cases = @(
    [pscustomobject]@{ Name = "720p"; Width = 1280; Height = 720 },
    [pscustomobject]@{ Name = "1080p"; Width = 1920; Height = 1080 },
    [pscustomobject]@{ Name = "ultrawide"; Width = 2560; Height = 1080 }
)
$previousOutput = [Environment]::GetEnvironmentVariable("CARRIAGE_PERFORMANCE_OUTPUT", "Process")
try {
    foreach ($case in $cases) {
        $caseOutput = Join-Path $outputRoot "$($case.Name).json"
        $captureDir = "dist\performance\captures_$($case.Name)"
        $env:CARRIAGE_PERFORMANCE_OUTPUT = $caseOutput
        & (Join-Path $gameDir "scripts\capture_ui.ps1") -Scenes $Scenes -Frames $Frames `
            -WindowWidth $case.Width -WindowHeight $case.Height `
            -OutputDir $captureDir -SkipBuild -Release
        if ($LASTEXITCODE -ne 0) { throw "Performance capture failed for $($case.Name)." }
        if (-not (Test-Path -LiteralPath $caseOutput -PathType Leaf)) {
            throw "Performance report missing for $($case.Name): $caseOutput"
        }
    }
}
finally {
    $env:CARRIAGE_PERFORMANCE_OUTPUT = $previousOutput
}

$reports = @($cases | ForEach-Object {
    Get-Content -Raw -LiteralPath (Join-Path $outputRoot "$($_.Name).json") | ConvertFrom-Json
})
$head = (& git -C $gameDir rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0) { throw "Could not determine source commit." }
$expectedCommit = $head
$workingTreeChanges = @(& git -C $gameDir status --porcelain --untracked-files=normal)
if ($LASTEXITCODE -ne 0) { throw "Could not inspect the source working tree." }
if ($workingTreeChanges.Count -gt 0) { $expectedCommit = "$head-dirty" }
foreach ($report in $reports) {
    if ($report.commit -ne $expectedCommit) {
        throw "Performance capture commit '$($report.commit)' does not match expected source '$expectedCommit'."
    }
    foreach ($scene in $report.scenes) {
        $expectedSteady = [Math]::Max(0, $Frames - 1)
        if ($scene.update_cpu.samples -ne $expectedSteady -or $scene.draw_cpu_submission.samples -ne $expectedSteady) {
            throw "Incomplete timing sample for $($scene.scene) at $($scene.width)x$($scene.height)."
        }
    }
}

$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$gpus = @(Get-CimInstance Win32_VideoController | ForEach-Object {
    [ordered]@{ name = $_.Name; driver_version = $_.DriverVersion }
})
$combined = [ordered]@{
    schema_version = 1
    captured_at_utc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    source_commit = $expectedCommit
    frames_per_scene = $Frames
    scenes = @($Scenes)
    machine = [ordered]@{
        os = $os.Caption
        os_version = $os.Version
        cpu = $cpu.Name
        memory_bytes = [int64]$os.TotalVisibleMemorySize * 1024
        graphics = $gpus
    }
    interpretation = "CPU update and draw-command submission only; not GPU presentation or frame pacing"
    cases = $reports
}
$combinedPath = Join-Path $outputRoot "carriage_run_performance_capture.json"
$utf8NoBom = [Text.UTF8Encoding]::new($false)
[IO.File]::WriteAllText($combinedPath, ($combined | ConvertTo-Json -Depth 12) + [Environment]::NewLine, $utf8NoBom)

Write-Host "Performance capture complete: $combinedPath"
