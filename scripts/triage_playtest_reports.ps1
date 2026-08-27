<#
.SYNOPSIS
    Validate and aggregate privacy-conscious PC demo playtest reports.

.DESCRIPTION
    Reads observer-authored JSON reports, validates candidate identity and issue
    fields, groups only explicitly linked duplicates, and writes ranked JSON and
    Markdown summaries. It never infers duplicates from similar prose.
#>
param(
    [string]$InputDir = "dist\playtest_reports\inbox",
    [string]$OutputJson = "dist\playtest_reports\triage_summary.json",
    [string]$OutputMarkdown = "dist\playtest_reports\triage_summary.md"
)

$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot

function Resolve-GamePath([string]$Path) {
    if ([IO.Path]::IsPathRooted($Path)) { return [IO.Path]::GetFullPath($Path) }
    return [IO.Path]::GetFullPath((Join-Path $gameDir $Path))
}

function Require-Text($Value, [string]$Field, [string]$File) {
    if ([string]::IsNullOrWhiteSpace([string]$Value)) { throw "$File has an empty $Field." }
}

function Require-Choice($Value, [string[]]$Allowed, [string]$Field, [string]$File) {
    if ([string]$Value -notin $Allowed) {
        throw "$File has invalid $Field '$Value'; expected $($Allowed -join ', ')."
    }
}

function Escape-Markdown([string]$Value) {
    return ($Value -replace '\|', '\|') -replace "`r?`n", " "
}

$inputPath = Resolve-GamePath $InputDir
$outputJsonPath = Resolve-GamePath $OutputJson
$outputMarkdownPath = Resolve-GamePath $OutputMarkdown
if (-not (Test-Path -LiteralPath $inputPath -PathType Container)) {
    throw "Playtest report directory not found: $inputPath"
}
$reportFiles = @(Get-ChildItem -LiteralPath $inputPath -Filter *.json -File | Sort-Object Name)
if ($reportFiles.Count -eq 0) { throw "No JSON playtest reports found in $inputPath" }

$severityOrder = @("blocker", "critical", "high", "medium", "low")
$reproOrder = @("always", "frequent", "intermittent", "once", "unknown")
$categories = @("software", "comprehension", "compatibility", "accessibility", "performance", "content")
$statuses = @("new", "investigate", "fix_planned", "fixed_pending_retest", "verified", "deferred", "cannot_reproduce")
$sessionIds = New-Object System.Collections.Generic.HashSet[string]
$issueIds = New-Object System.Collections.Generic.HashSet[string]
$candidateKeys = New-Object System.Collections.Generic.HashSet[string]
$validated = @()

foreach ($file in $reportFiles) {
    try { $report = Get-Content -Raw -LiteralPath $file.FullName | ConvertFrom-Json }
    catch { throw "$($file.Name) is not valid JSON: $($_.Exception.Message)" }
    if ($report.schema_version -ne 1) { throw "$($file.Name) has unsupported schema_version '$($report.schema_version)'." }
    $session = $report.session
    Require-Text $session.session_id "session.session_id" $file.Name
    Require-Text $session.tester_code "session.tester_code" $file.Name
    Require-Text $session.candidate_version "session.candidate_version" $file.Name
    if ([string]$session.candidate_commit -notmatch '^[0-9a-fA-F]{40}$') {
        throw "$($file.Name) candidate_commit must be a full 40-character hexadecimal revision."
    }
    if ([string]$session.package_sha256 -notmatch '^[0-9a-fA-F]{64}$') {
        throw "$($file.Name) package_sha256 must be a 64-character hexadecimal hash."
    }
    if ([double]$session.active_minutes -lt 0) { throw "$($file.Name) active_minutes cannot be negative." }
    if (-not $sessionIds.Add([string]$session.session_id)) {
        throw "Duplicate session_id '$($session.session_id)'."
    }
    $candidateKey = "$($session.candidate_commit.ToLowerInvariant())|$($session.package_sha256.ToLowerInvariant())"
    $null = $candidateKeys.Add($candidateKey)

    foreach ($issue in @($report.issues)) {
        Require-Text $issue.issue_id "issues.issue_id" $file.Name
        Require-Text $issue.title "issues.title" $file.Name
        Require-Text $issue.expected "issues.expected" $file.Name
        Require-Text $issue.actual "issues.actual" $file.Name
        Require-Choice $issue.category $categories "issues.category" $file.Name
        Require-Choice $issue.severity $severityOrder "issues.severity" $file.Name
        Require-Choice $issue.reproducibility $reproOrder "issues.reproducibility" $file.Name
        Require-Choice $issue.status $statuses "issues.status" $file.Name
        if (-not $issueIds.Add([string]$issue.issue_id)) { throw "Duplicate issue_id '$($issue.issue_id)'." }
        if ($issue.critical_path_id -and [string]$issue.critical_path_id -notmatch '^CR-(0[1-9]|1[0-4])$') {
            throw "$($file.Name) issue '$($issue.issue_id)' has invalid critical_path_id '$($issue.critical_path_id)'."
        }
        if (@($issue.reproduction_steps).Count -eq 0) {
            throw "$($file.Name) issue '$($issue.issue_id)' needs at least one reproduction step."
        }
        if ($issue.status -eq "deferred" -and $issue.severity -in @("blocker", "critical", "high")) {
            Require-Text $issue.acceptance_owner "issues.acceptance_owner for deferred high-severity issue" $file.Name
            Require-Text $issue.acceptance_rationale "issues.acceptance_rationale for deferred high-severity issue" $file.Name
        }
        if ($issue.status -eq "verified") {
            Require-Text $issue.verification_result "issues.verification_result for verified issue" $file.Name
        }
        $groupId = if ([string]::IsNullOrWhiteSpace([string]$issue.duplicate_group)) {
            "issue:$($issue.issue_id)"
        } else {
            [string]$issue.duplicate_group
        }
        $validated += [pscustomobject]@{
            group_id = $groupId
            session_id = [string]$session.session_id
            tester_code = [string]$session.tester_code
            issue = $issue
        }
    }
}

$groups = @($validated | Group-Object group_id | ForEach-Object {
    $rows = @($_.Group)
    $severity = $severityOrder | Where-Object { $_ -in @($rows.issue.severity) } | Select-Object -First 1
    $repro = $reproOrder | Where-Object { $_ -in @($rows.issue.reproducibility) } | Select-Object -First 1
    $testers = @($rows.tester_code | Sort-Object -Unique)
    $sessions = @($rows.session_id | Sort-Object -Unique)
    [pscustomobject][ordered]@{
        group_id = $_.Name
        title = [string]$rows[0].issue.title
        severity = $severity
        reproducibility = $repro
        affected_testers = $testers.Count
        affected_sessions = $sessions.Count
        tester_codes = $testers
        session_ids = $sessions
        issue_ids = @($rows.issue.issue_id | Sort-Object -Unique)
        categories = @($rows.issue.category | Sort-Object -Unique)
        critical_path_ids = @($rows.issue.critical_path_id | Where-Object { $_ } | Sort-Object -Unique)
        statuses = @($rows.issue.status | Sort-Object -Unique)
        severity_rank = [array]::IndexOf($severityOrder, $severity)
        reproducibility_rank = [array]::IndexOf($reproOrder, $repro)
    }
} | Sort-Object severity_rank, @{ Expression = { -$_.affected_testers } }, reproducibility_rank, group_id)

$summary = [ordered]@{
    schema_version = 1
    generated_at_utc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    source_reports = $reportFiles.Count
    sessions = $sessionIds.Count
    candidate_identities = $candidateKeys.Count
    distinct_issue_groups = $groups.Count
    duplicate_policy = "Only a non-empty observer-supplied duplicate_group joins issues; prose similarity is never inferred"
    ranking_policy = "Severity, then independent tester count, then reproducibility"
    groups = @($groups | Select-Object * -ExcludeProperty severity_rank, reproducibility_rank)
}

foreach ($path in @($outputJsonPath, $outputMarkdownPath)) {
    $parent = Split-Path -Parent $path
    if ($parent) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
}
$utf8NoBom = [Text.UTF8Encoding]::new($false)
[IO.File]::WriteAllText($outputJsonPath, ($summary | ConvertTo-Json -Depth 8) + [Environment]::NewLine, $utf8NoBom)

$lines = @(
    "# Carriage Run playtest triage summary",
    "",
    "Generated: $($summary.generated_at_utc)",
    "",
    "Reports: $($summary.source_reports) · Sessions: $($summary.sessions) · Candidate identities: $($summary.candidate_identities) · Issue groups: $($summary.distinct_issue_groups)",
    "",
    "> Duplicate policy: $($summary.duplicate_policy).",
    "",
    "| Rank | Group | Severity | Reproducibility | Testers | Sessions | Critical path | Status | Title |",
    "| ---: | --- | --- | --- | ---: | ---: | --- | --- | --- |"
)
for ($index = 0; $index -lt $groups.Count; $index++) {
    $group = $groups[$index]
    $lines += "| $($index + 1) | $(Escape-Markdown $group.group_id) | $($group.severity) | $($group.reproducibility) | $($group.affected_testers) | $($group.affected_sessions) | $($group.critical_path_ids -join ', ') | $($group.statuses -join ', ') | $(Escape-Markdown $group.title) |"
}
$lines += ""
$lines += "This ranking is triage assistance, not authority to accept, defer, or close an issue. Review source reports and exact candidate evidence before acting."
[IO.File]::WriteAllText($outputMarkdownPath, ($lines -join [Environment]::NewLine) + [Environment]::NewLine, $utf8NoBom)

Write-Host "Validated $($reportFiles.Count) report(s) into $($groups.Count) ranked issue group(s)."
Write-Host "JSON: $outputJsonPath"
Write-Host "Markdown: $outputMarkdownPath"
