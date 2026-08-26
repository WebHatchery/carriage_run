<#
.SYNOPSIS
    Generate deterministic, test-only saves for the proposed PC demo path.

.DESCRIPTION
    Runs an ignored Rust fixture exporter so the saves are built from the
    current typed schema and embedded mission data. Output stays in dist and is
    never included in a release archive.
#>
param(
    [string]$Output = "dist\playtest_saves"
)

$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot

function Resolve-GamePath([string]$Path) {
    if ([IO.Path]::IsPathRooted($Path)) { return [IO.Path]::GetFullPath($Path) }
    return [IO.Path]::GetFullPath((Join-Path $gameDir $Path))
}

$outputPath = Resolve-GamePath $Output
$distRoot = [IO.Path]::GetFullPath((Join-Path $gameDir "dist"))
if (-not $outputPath.StartsWith($distRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
    throw "Playtest saves must be generated beneath the project dist directory."
}

$previousOutput = [Environment]::GetEnvironmentVariable("CARRIAGE_TEST_SAVE_DIR", "Process")
try {
    $env:CARRIAGE_TEST_SAVE_DIR = $outputPath
    cargo test --manifest-path (Join-Path $gameDir "Cargo.toml") --locked `
        state::tests::playtest_saves::export_playtest_save_fixtures -- `
        --exact --ignored --nocapture
    if ($LASTEXITCODE -ne 0) { throw "Playtest save exporter failed." }
}
finally {
    $env:CARRIAGE_TEST_SAVE_DIR = $previousOutput
}

$expectedSlots = @(
    "demoqa_start",
    "demoqa_fork_bandit",
    "demoqa_fork_courier",
    "demoqa_final_bandit",
    "demoqa_final_courier"
)
$records = foreach ($slot in $expectedSlots) {
    $path = Join-Path $outputPath "save_$slot.json"
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Expected fixture was not generated: $path"
    }
    $payload = Get-Content -Raw -LiteralPath $path | ConvertFrom-Json
    if ($payload.slot.name -ne $slot -or $payload.data.campaign.active_save_slot -ne $slot) {
        throw "Fixture identity mismatch: $path"
    }
    [ordered]@{
        slot = $slot
        file = [IO.Path]::GetFileName($path)
        selected_mission = $payload.data.campaign.selected_mission_id
        completed_missions = @($payload.data.campaign.records.PSObject.Properties |
            Where-Object { $_.Value.completions -gt 0 } |
            ForEach-Object { $_.Name } |
            Sort-Object)
        sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash.ToLowerInvariant()
    }
}

$sourceCommit = (& git -C $gameDir rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0) { throw "Could not determine the source commit." }
$workingTreeChanges = @(& git -C $gameDir status --porcelain --untracked-files=normal)
if ($LASTEXITCODE -ne 0) { throw "Could not inspect the source working tree." }
if ($workingTreeChanges.Count -gt 0) { $sourceCommit = "$sourceCommit-dirty" }

$manifest = [ordered]@{
    schema_version = 1
    generated_at_utc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    source_commit = $sourceCommit
    status = "test_only_option_a_proposal"
    fixtures = @($records)
}
$manifestPath = Join-Path $outputPath "playtest_save_manifest.json"
$utf8NoBom = [Text.UTF8Encoding]::new($false)
[IO.File]::WriteAllText($manifestPath, ($manifest | ConvertTo-Json -Depth 8) + [Environment]::NewLine, $utf8NoBom)

Write-Host "Generated $($records.Count) playtest saves: $outputPath"
Write-Host "Manifest: $manifestPath"
