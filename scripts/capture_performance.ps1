<#
.SYNOPSIS
    Capture repeatable CPU timing evidence for representative game scenes.

.DESCRIPTION
    Profiles deterministic release-mode update and draw-command submission at
    three window shapes and records the capture process's peak working set. This
    is a regression aid, not physical-GPU, minimum-PC, frame-pacing, heap,
    leak-detection, or long-session evidence.
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
    [pscustomobject]@{ Name = "wide"; Width = 1920; Height = 800 }
)
$previousOutput = [Environment]::GetEnvironmentVariable("CARRIAGE_PERFORMANCE_OUTPUT", "Process")
try {
    foreach ($case in $cases) {
        $caseOutput = Join-Path $outputRoot "$($case.Name).json"
        $processOutput = Join-Path $outputRoot "$($case.Name)_process.json"
        $captureDir = "dist\performance\captures_$($case.Name)"
        $env:CARRIAGE_PERFORMANCE_OUTPUT = $caseOutput
        & (Join-Path $gameDir "scripts\capture_ui.ps1") -Scenes $Scenes -Frames $Frames `
            -WindowWidth $case.Width -WindowHeight $case.Height `
            -OutputDir $captureDir -ProcessReportPath $processOutput -SkipBuild -Release
        if ($LASTEXITCODE -ne 0) { throw "Performance capture failed for $($case.Name)." }
        if (-not (Test-Path -LiteralPath $caseOutput -PathType Leaf)) {
            throw "Performance report missing for $($case.Name): $caseOutput"
        }
        if (-not (Test-Path -LiteralPath $processOutput -PathType Leaf)) {
            throw "Process-memory report missing for $($case.Name): $processOutput"
        }
    }
}
finally {
    $env:CARRIAGE_PERFORMANCE_OUTPUT = $previousOutput
}

$reports = @($cases | ForEach-Object {
    Get-Content -Raw -LiteralPath (Join-Path $outputRoot "$($_.Name).json") | ConvertFrom-Json
})
$processReports = @($cases | ForEach-Object {
    Get-Content -Raw -LiteralPath (Join-Path $outputRoot "$($_.Name)_process.json") | ConvertFrom-Json
})
$head = (& git -C $gameDir rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0) { throw "Could not determine source commit." }
$expectedCommit = $head
$workingTreeChanges = @(& git -C $gameDir status --porcelain --untracked-files=normal)
if ($LASTEXITCODE -ne 0) { throw "Could not inspect the source working tree." }
if ($workingTreeChanges.Count -gt 0) { $expectedCommit = "$head-dirty" }
$drawableSurfaces = New-Object System.Collections.Generic.HashSet[string]
for ($index = 0; $index -lt $reports.Count; $index++) {
    $report = $reports[$index]
    $processReport = $processReports[$index]
    $case = $cases[$index]
    if ($report.commit -ne $expectedCommit) {
        throw "Performance capture commit '$($report.commit)' does not match expected source '$expectedCommit'."
    }
    foreach ($scene in $report.scenes) {
        $expectedSteady = [Math]::Max(0, $Frames - 1)
        if ($scene.update_cpu.samples -ne $expectedSteady -or $scene.draw_cpu_submission.samples -ne $expectedSteady) {
            throw "Incomplete timing sample for $($scene.scene) at $($scene.width)x$($scene.height)."
        }
    }
    $surfaceSizes = @($report.scenes | ForEach-Object { "$($_.width)x$($_.height)" } | Sort-Object -Unique)
    if ($surfaceSizes.Count -ne 1) {
        throw "Scenes in the $($case.Name) batch used inconsistent drawable surfaces: $($surfaceSizes -join ', ')."
    }
    if (-not $drawableSurfaces.Add($surfaceSizes[0])) {
        throw "The $($case.Name) request was clamped to duplicate drawable surface $($surfaceSizes[0]); choose a monitor-fitting shape."
    }
    $drawableParts = $surfaceSizes[0].Split('x')
    $report | Add-Member -NotePropertyName label -NotePropertyValue $case.Name
    $report | Add-Member -NotePropertyName requested_width -NotePropertyValue $case.Width
    $report | Add-Member -NotePropertyName requested_height -NotePropertyValue $case.Height
    $report | Add-Member -NotePropertyName drawable_width -NotePropertyValue ([int]$drawableParts[0])
    $report | Add-Member -NotePropertyName drawable_height -NotePropertyValue ([int]$drawableParts[1])
    if ($processReport.scenes -ne $Scenes.Count -or
        $processReport.frames_per_scene -ne $Frames -or
        $processReport.requested_width -ne $case.Width -or
        $processReport.requested_height -ne $case.Height -or
        $processReport.fullscreen) {
        throw "Process-memory report does not match the $($case.Name) capture request."
    }
    if ($processReport.max_sampled_working_set_bytes -le 0 -or
        $processReport.os_peak_working_set_bytes -le 0) {
        throw "Process-memory report contains no usable peak for $($case.Name)."
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
    process_memory_interpretation = "Whole capture-process working set; not Rust heap, leak detection, or long-session evidence"
    window_interpretation = "Requested outer-window sizes and measured drawable surfaces are both recorded; Windows decorations can make them differ"
    cases = $reports
    process_memory_cases = $processReports
}
$combinedPath = Join-Path $outputRoot "carriage_run_performance_capture.json"
$utf8NoBom = [Text.UTF8Encoding]::new($false)
[IO.File]::WriteAllText($combinedPath, ($combined | ConvertTo-Json -Depth 12) + [Environment]::NewLine, $utf8NoBom)

Write-Host "Performance capture complete: $combinedPath"
