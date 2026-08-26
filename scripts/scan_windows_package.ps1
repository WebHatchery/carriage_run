<#
.SYNOPSIS
    Scan an exact Windows release archive with Microsoft Defender Antivirus.

.DESCRIPTION
    Revalidates the release manifest, checks Defender health/signature state,
    requests an on-demand custom scan, correlates Defender start/finish events,
    checks artifact-related detections, and writes a machine-readable record.
    A zero-detection result is supporting evidence, never proof of safety.
#>
param(
    [string]$Artifact = "dist\carriage_run_windows.zip",
    [ValidateSet("full", "demo")]
    [string]$Channel = "full",
    [string]$Output = "dist\carriage_run_windows_defender_scan.json",
    [int]$EventTimeoutSeconds = 20
)

$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot

function Resolve-GamePath([string]$Path) {
    if ([IO.Path]::IsPathRooted($Path)) { return [IO.Path]::GetFullPath($Path) }
    return [IO.Path]::GetFullPath((Join-Path $gameDir $Path))
}

$artifactPath = Resolve-GamePath $Artifact
$outputPath = Resolve-GamePath $Output

Push-Location $gameDir
try {
    & (Join-Path $PSScriptRoot "write_release_manifest.ps1") -Artifact $artifactPath -Channel $Channel
    $manifestPath = Join-Path (Split-Path -Parent $artifactPath) "$([IO.Path]::GetFileNameWithoutExtension($artifactPath))_manifest.json"
    $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json

    foreach ($command in @("Get-MpComputerStatus", "Start-MpScan", "Get-MpThreatDetection")) {
        if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
            throw "Microsoft Defender command is unavailable: $command"
        }
    }
    $status = Get-MpComputerStatus -ErrorAction Stop
    if (-not $status.AMServiceEnabled -or -not $status.AntivirusEnabled) {
        throw "Microsoft Defender Antivirus is not enabled."
    }
    if ($status.DefenderSignaturesOutOfDate) {
        throw "Microsoft Defender security intelligence is out of date."
    }

    $scanRequestedAt = Get-Date
    Start-MpScan -ScanType CustomScan -ScanPath $artifactPath -ErrorAction Stop

    $deadline = (Get-Date).AddSeconds($EventTimeoutSeconds)
    $scanStarted = $null
    $scanFinished = $null
    do {
        $events = @(Get-WinEvent -FilterHashtable @{
            LogName = "Microsoft-Windows-Windows Defender/Operational"
            StartTime = $scanRequestedAt.AddSeconds(-2)
            Id = 1000, 1001
        } -ErrorAction Stop)
        $scanStarted = $events | Where-Object {
            $_.Id -eq 1000 -and $_.Message -like "*Custom Scan*" -and $_.Message -like "*$([IO.Path]::GetFileName($artifactPath))*"
        } | Sort-Object TimeCreated -Descending | Select-Object -First 1
        if ($scanStarted -and $scanStarted.Message -match 'Scan ID:\s*(\{[0-9A-Fa-f-]+\})') {
            $scanId = $Matches[1]
            $scanFinished = $events | Where-Object {
                $_.Id -eq 1001 -and $_.Message -like "*$scanId*"
            } | Sort-Object TimeCreated -Descending | Select-Object -First 1
        }
        if (-not $scanFinished) { Start-Sleep -Milliseconds 250 }
    } while (-not $scanFinished -and (Get-Date) -lt $deadline)

    if (-not $scanStarted -or -not $scanFinished) {
        throw "Could not correlate Defender custom-scan start and completion events."
    }

    $artifactName = [IO.Path]::GetFileName($artifactPath)
    $detections = @(Get-MpThreatDetection -ErrorAction Stop | Where-Object {
        ($_.Resources -join "`n") -like "*$artifactName*"
    })
    if ($detections.Count -gt 0) {
        throw "Microsoft Defender reported $($detections.Count) detection(s) for $artifactName. Preserve the evidence and stop release review."
    }
    if (-not (Test-Path -LiteralPath $artifactPath -PathType Leaf)) {
        throw "The scanned artifact is no longer present after the Defender scan."
    }
    $postScanHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $artifactPath).Hash.ToLowerInvariant()
    if ($postScanHash -ne $manifest.artifact.sha256) {
        throw "Artifact hash changed during Defender scan."
    }

    $signatureUpdatedUtc = if ($status.AntivirusSignatureLastUpdated -is [DateTime]) {
        $status.AntivirusSignatureLastUpdated.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    } else {
        [string]$status.AntivirusSignatureLastUpdated
    }
    $record = [ordered]@{
        schema_version = 1
        scanner = "Microsoft Defender Antivirus"
        result = "completed_no_detections"
        scan_type = "custom_on_demand"
        scan_id = $scanId
        requested_at_utc = $scanRequestedAt.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        completed_at_utc = $scanFinished.TimeCreated.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        artifact = $manifest.artifact.filename
        artifact_sha256 = $manifest.artifact.sha256
        version = $manifest.version
        channel = $manifest.channel
        commit = $manifest.commit
        target = $manifest.target
        detections = 0
        defender = [ordered]@{
            platform_version = $status.AMProductVersion
            engine_version = $status.AMEngineVersion
            signature_version = $status.AntivirusSignatureVersion
            signature_updated_utc = $signatureUpdatedUtc
            signatures_out_of_date = [bool]$status.DefenderSignaturesOutOfDate
            real_time_protection_enabled = [bool]$status.RealTimeProtectionEnabled
            tamper_protected = [bool]$status.IsTamperProtected
        }
        limitation = "A zero-detection result from one scanner/version is supporting evidence, not proof that the package is safe or trusted by SmartScreen."
    }
    $outputDirectory = Split-Path -Parent $outputPath
    if ($outputDirectory -and -not (Test-Path -LiteralPath $outputDirectory)) {
        New-Item -ItemType Directory -Path $outputDirectory | Out-Null
    }
    $utf8NoBom = [Text.UTF8Encoding]::new($false)
    [IO.File]::WriteAllText($outputPath, ($record | ConvertTo-Json -Depth 6) + [Environment]::NewLine, $utf8NoBom)

    Write-Host "Microsoft Defender custom scan completed with zero detections."
    Write-Host "Artifact SHA-256: $postScanHash"
    Write-Host "Evidence: $outputPath"
    Write-Warning $record.limitation
}
finally {
    Pop-Location
}
