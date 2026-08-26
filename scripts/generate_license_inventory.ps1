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

function Get-StandaloneDependencyEvidence([string]$Target) {
    $tempBase = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
    $tempRoot = [IO.Path]::GetFullPath((Join-Path $tempBase ("carriage-license-" + [Guid]::NewGuid().ToString("N"))))
    if (-not $tempRoot.StartsWith($tempBase, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing unsafe temporary dependency layout: $tempRoot"
    }
    $gameCopy = Join-Path $tempRoot "carriage_run"
    $toolkitCopy = Join-Path $tempRoot "macroquad-toolkit"
    $gameSource = Join-Path $gameCopy "src"
    $toolkitSource = Join-Path $toolkitCopy "src"
    try {
        New-Item -ItemType Directory -Path $gameSource -Force | Out-Null
        New-Item -ItemType Directory -Path $toolkitSource -Force | Out-Null
        Copy-Item -LiteralPath (Join-Path $gameDir "Cargo.toml") -Destination (Join-Path $gameCopy "Cargo.toml")
        Copy-Item -LiteralPath (Join-Path $gameDir "Cargo.lock") -Destination (Join-Path $gameCopy "Cargo.lock")
        Copy-Item -LiteralPath (Join-Path (Split-Path $gameDir -Parent) "macroquad-toolkit\Cargo.toml") -Destination (Join-Path $toolkitCopy "Cargo.toml")
        [IO.File]::WriteAllText((Join-Path $gameSource "main.rs"), "fn main() {}`n")
        [IO.File]::WriteAllText((Join-Path $toolkitSource "lib.rs"), "")

        $manifest = Join-Path $gameCopy "Cargo.toml"
        $metadata = cargo metadata --manifest-path $manifest --locked --format-version 1 | ConvertFrom-Json
        if ($LASTEXITCODE -ne 0) { throw "cargo metadata failed for the standalone lockfile" }
        $treeLines = @(& cargo tree --manifest-path $manifest --locked --target $Target --edges normal,build --prefix none --format '{p}|{l}')
        if ($LASTEXITCODE -ne 0) { throw "cargo tree failed for target $Target" }
        [pscustomobject]@{ metadata = $metadata; tree_lines = $treeLines }
    }
    finally {
        foreach ($path in @(
            (Join-Path $gameCopy "Cargo.lock"),
            (Join-Path $gameCopy "Cargo.toml"),
            (Join-Path $gameSource "main.rs"),
            (Join-Path $toolkitCopy "Cargo.toml"),
            (Join-Path $toolkitSource "lib.rs")
        )) {
            if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path -Force }
        }
        foreach ($path in @($gameSource, $toolkitSource, $gameCopy, $toolkitCopy, $tempRoot)) {
            if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path -Force }
        }
    }
}

Push-Location $gameDir
try {
    # This project is normally a member of the RustGames workspace, whose root
    # lockfile can drift independently. Recreate CI's sibling checkout layout so
    # the inventory is proven against the tracked standalone Cargo.lock.
    $evidence = Get-StandaloneDependencyEvidence $Target
    $metadata = $evidence.metadata
    $treeLines = $evidence.tree_lines
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
