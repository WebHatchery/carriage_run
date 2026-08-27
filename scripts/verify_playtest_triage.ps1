<# Verifies successful explicit grouping and guarded high-severity deferral. #>
$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot
$templatePath = Join-Path $gameDir "docs\PC_DEMO_PLAYTEST_REPORT_TEMPLATE.json"
$triageScript = Join-Path $PSScriptRoot "triage_playtest_reports.ps1"
$tempBase = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$tempRoot = [IO.Path]::GetFullPath((Join-Path $tempBase "carriage_run_triage_$([Guid]::NewGuid().ToString('N'))"))
$safePrefix = $tempBase.TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
if (-not $tempRoot.StartsWith($safePrefix, [StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing unsafe triage test root outside $tempBase"
}

function Copy-Template {
    return (Get-Content -Raw -LiteralPath $templatePath | ConvertFrom-Json | ConvertTo-Json -Depth 8 | ConvertFrom-Json)
}

function Set-Candidate($Report, [string]$SessionId, [string]$TesterCode) {
    $Report.session.session_id = $SessionId
    $Report.session.tester_code = $TesterCode
    $Report.session.candidate_commit = "1111111111111111111111111111111111111111"
    $Report.session.package_sha256 = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    $Report.session.active_minutes = 20
    $Report.session.environment_summary = "Synthetic Windows CI fixture"
    $Report.session.observer_notes = "No person or private data"
}

function Set-Issue($Issue, [string]$Id, [string]$Title) {
    $Issue.issue_id = $Id
    $Issue.title = $Title
    $Issue.expected = "Tester identifies the visible steering action."
    $Issue.actual = "Tester does not identify the steering action."
    $Issue.reproduction_steps = @("Start the synthetic candidate.")
    $Issue.critical_path_id = "CR-02"
    $Issue.severity = "high"
    $Issue.reproducibility = "always"
    $Issue.status = "investigate"
    $Issue.duplicate_group = "OPENING-STEERING"
}

try {
    $validDir = Join-Path $tempRoot "valid"
    $invalidDir = Join-Path $tempRoot "invalid"
    New-Item -ItemType Directory -Path $validDir, $invalidDir -Force | Out-Null

    $first = Copy-Template
    Set-Candidate $first "S-A" "T-A"
    Set-Issue $first.issues[0] "S-A-01" "Opening steering instruction was missed"

    $second = Copy-Template
    Set-Candidate $second "S-B" "T-B"
    Set-Issue $second.issues[0] "S-B-01" "Steering prompt was not understood"
    $second.issues[0].reproducibility = "frequent"
    $unique = Copy-Template
    $uniqueIssue = $unique.issues[0]
    $uniqueIssue.issue_id = "S-B-02"
    $uniqueIssue.title = "Verified cosmetic typo"
    $uniqueIssue.category = "content"
    $uniqueIssue.severity = "low"
    $uniqueIssue.reproducibility = "once"
    $uniqueIssue.critical_path_id = ""
    $uniqueIssue.expected = "Label is spelled correctly."
    $uniqueIssue.actual = "Label was misspelled."
    $uniqueIssue.reproduction_steps = @("Open the synthetic screen.")
    $uniqueIssue.duplicate_group = ""
    $uniqueIssue.status = "verified"
    $uniqueIssue.verification_result = "Corrected label confirmed in the synthetic candidate."
    $second.issues = @($second.issues[0], $uniqueIssue)

    $first | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $validDir "a.json") -Encoding utf8
    $second | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $validDir "b.json") -Encoding utf8
    $summaryPath = Join-Path $tempRoot "summary.json"
    & $triageScript -InputDir $validDir -OutputJson $summaryPath -OutputMarkdown (Join-Path $tempRoot "summary.md")
    $summary = Get-Content -Raw -LiteralPath $summaryPath | ConvertFrom-Json
    if ($summary.source_reports -ne 2 -or $summary.sessions -ne 2 -or
        $summary.candidate_identities -ne 1 -or $summary.distinct_issue_groups -ne 2) {
        throw "Valid triage summary counts are incorrect."
    }
    $opening = $summary.groups | Where-Object group_id -eq "OPENING-STEERING"
    if ($opening.affected_testers -ne 2 -or $opening.severity -ne "high" -or
        $opening.reproducibility -ne "always") {
        throw "Explicit duplicate aggregation is incorrect."
    }

    $invalid = Copy-Template
    Set-Candidate $invalid "S-X" "T-X"
    Set-Issue $invalid.issues[0] "S-X-01" "High issue cannot be silently deferred"
    $invalid.issues[0].status = "deferred"
    $invalid | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $invalidDir "invalid.json") -Encoding utf8
    try {
        & $triageScript -InputDir $invalidDir -OutputJson (Join-Path $tempRoot "invalid-summary.json") `
            -OutputMarkdown (Join-Path $tempRoot "invalid-summary.md")
        throw "Invalid high-severity deferral was accepted."
    }
    catch {
        if ($_.Exception.Message -notlike "*empty issues.acceptance_owner*") { throw }
    }
    Write-Host "Playtest triage verification passed."
}
finally {
    $resolved = [IO.Path]::GetFullPath($tempRoot)
    if ($resolved.StartsWith($safePrefix, [StringComparison]::OrdinalIgnoreCase) -and
        [IO.Path]::GetFileName($resolved) -like "carriage_run_triage_*") {
        Remove-Item -LiteralPath $resolved -Recurse -Force -ErrorAction SilentlyContinue
    }
}
