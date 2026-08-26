<#
.SYNOPSIS
    Refresh the dependency and asset evidence used by release review.
#>
param(
    [string]$Output = "docs\THIRD_PARTY_LICENSES.md",
    [string]$Target = "x86_64-pc-windows-msvc"
)

$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot
Push-Location $gameDir
try {
    $metadata = cargo metadata --manifest-path (Join-Path $gameDir "Cargo.toml") --locked --format-version 1 | ConvertFrom-Json
    # The parent workspace's unified metadata graph enables optional toolkit
    # features used by unrelated games. `cargo tree -p` supplies the exact
    # normal/build closure for this Windows release target instead.
    $treeLines = @(& cargo tree -p carriage_run --locked --target $Target --edges normal,build --prefix none --format '{p}|{l}')
    if ($LASTEXITCODE -ne 0) { throw "cargo tree failed for target $Target" }
    $resolvedPackages = @($treeLines | ForEach-Object {
        $clean = $_ -replace ' \(\*\)$', ''
        $parts = $clean.Split('|', 2)
        $identity = $parts[0] -replace ' \(proc-macro\)$', ''
        if ($identity -notmatch '^(?<name>.+) v(?<version>\S+)(?: \(.+\))?$') {
            throw "Could not parse cargo tree package identity: $identity"
        }
        $packageName = $Matches.name
        $packageVersion = $Matches.version
        $metadataMatches = @($metadata.packages | Where-Object {
            $_.name -eq $packageName -and $_.version -eq $packageVersion
        })
        if ($metadataMatches.Count -eq 0) {
            throw "Cargo metadata is missing $packageName $packageVersion"
        }
        [pscustomobject]@{
            name = $packageName
            version = $packageVersion
            license = $parts[1]
            source = $metadataMatches[0].source
            license_file = $metadataMatches[0].license_file
        }
    } | Sort-Object name, version, source -Unique)

    $firstParty = @($resolvedPackages | Where-Object { $null -eq $_.source } | ForEach-Object {
        $license = if ($_.license) { $_.license } else { "Not declared in Cargo.toml" }
        "| $($_.name) | $($_.version) | $license | Local source dependency |"
    })
    $thirdParty = @($resolvedPackages | Where-Object { $null -ne $_.source } | ForEach-Object {
        $license = if ($_.license) { $_.license.Replace('|', '\|') } elseif ($_.license_file) { "License file: $($_.license_file)" } else { "MISSING LICENSE METADATA" }
        $source = if ($_.source -like 'registry+*') { "crates.io via Cargo.lock" } else { $_.source.Replace('|', '\|') }
        "| $($_.name) | $($_.version) | $license | $source |"
    })
    $missingLicenses = @($resolvedPackages | Where-Object { $null -ne $_.source -and -not $_.license -and -not $_.license_file })
    if ($missingLicenses.Count -gt 0) {
        throw "Resolved third-party packages missing license metadata: $($missingLicenses.name -join ', ')"
    }

    $assets = @(Get-ChildItem assets -Recurse -File | ForEach-Object {
        $relative = $_.FullName.Substring($gameDir.Length + 1).Replace('\', '/')
        $basis = if ($relative -like 'assets/fonts/*.ttf') {
            $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash.ToLowerInvariant()
            "Rajdhani SemiBold; SIL OFL-1.1; SHA-256 $hash"
        } elseif ($relative -eq 'assets/licenses/OFL-Rajdhani.txt') {
            "Bundled SIL OFL-1.1 notice for the embedded Rajdhani font"
        } elseif ($relative -eq 'assets/fonts/README.md') {
            "Project documentation; records Rajdhani provenance"
        } else {
            "Original Carriage Run project asset; see docs/ASSET_LICENSES.md"
        }
        "| $relative | checked-in | $basis |"
    })
    $lines = @(
        "# Third-party dependency and asset license inventory"
        ""
        "Generated $(Get-Date -Format 'yyyy-MM-dd') from the locked carriage_run dependency closure for $Target and the checked-in asset tree."
        "The closure contains $($resolvedPackages.Count) packages: $($firstParty.Count) local project packages and $($thirdParty.Count) third-party packages."
        ""
        "## Local project packages"
        ""
        "| Package | Version | License declaration | Source |"
        "| --- | --- | --- | --- |"
        $firstParty
        ""
        "## Third-party Cargo packages"
        ""
        "| Package | Version | License expression | Evidence |"
        "| --- | --- | --- | --- |"
        $thirdParty
        ""
        "## Assets"
        ""
        "| Path | Status | Evidence |"
        "| --- | --- | --- |"
        $assets
        ""
        "## Method and limitations"
        ""
        "The package list is the normal/build dependency graph reported by cargo tree for carriage_run and target $Target with Cargo.lock enforced. This matches the public Windows PC scope, includes Windows-specific and build dependencies, excludes optional toolkit features enabled only by unrelated workspace members, and intentionally does not claim to inventory Linux, macOS, mobile, or browser-only packages. License expressions are package metadata, not a legal conclusion; release approval still requires human review of applicable license texts and obligations."
    )
    Set-Content -LiteralPath $Output -Value $lines -Encoding utf8
    Write-Host "Wrote $Output"
}
finally {
    Pop-Location
}
