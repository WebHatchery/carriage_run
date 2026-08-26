<#
.SYNOPSIS
    Fail when the Windows release gains an undeclared network or telemetry path.

.DESCRIPTION
    This is an engineering gate, not legal approval. It checks the resolved
    Windows dependency closure, game source, release binary markers, and PE
    imports against the local-only behavior documented for the PC demo.
#>

$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot
Push-Location $gameDir
try {
    $metadata = cargo metadata --manifest-path (Join-Path $gameDir "Cargo.toml") --no-deps --format-version 1 | ConvertFrom-Json
    $exe = Join-Path $metadata.target_directory "release\carriage_run.exe"
    if (-not (Test-Path -LiteralPath $exe -PathType Leaf)) {
        throw "Missing release executable: $exe. Run .\publish.ps1 first."
    }

    $tree = @(& cargo tree -p carriage_run --locked --target x86_64-pc-windows-msvc --edges normal,build --prefix none --format '{p}')
    if ($LASTEXITCODE -ne 0) { throw "Could not resolve the locked Windows dependency tree." }
    $forbiddenPackages = @("quad-net", "reqwest", "ureq", "sqlx", "async-std", "hyper")
    foreach ($package in $forbiddenPackages) {
        if ($tree -match "^$([regex]::Escape($package)) v") {
            throw "Network-capable package entered the Windows release closure: $package"
        }
    }

    $sourcePatterns = @(
        "macroquad_toolkit::analytics",
        "macroquad_toolkit::net",
        "AnalyticsClient",
        "TcpStream",
        "UdpSocket"
    )
    foreach ($pattern in $sourcePatterns) {
        & rg -n --glob "*.rs" --fixed-strings $pattern src | Out-Null
        if ($LASTEXITCODE -eq 0) { throw "Network/telemetry source marker found: $pattern" }
        if ($LASTEXITCODE -gt 1) { throw "Source audit failed while searching for: $pattern" }
    }

    $binaryPatterns = @(
        "X-WebHatchery-Analytics-Key",
        "analytics_installation_id",
        "quad_net",
        "reqwest",
        "ureq"
    )
    foreach ($pattern in $binaryPatterns) {
        & rg -a -m 1 --fixed-strings $pattern $exe | Out-Null
        if ($LASTEXITCODE -eq 0) { throw "Network/telemetry marker found in release binary: $pattern" }
        if ($LASTEXITCODE -gt 1) { throw "Binary audit failed while searching for: $pattern" }
    }

    $objdump = Get-Command objdump -ErrorAction SilentlyContinue
    if ($objdump) {
        $imports = @(& $objdump.Source -p $exe | Select-String "DLL Name" | ForEach-Object { $_.Line })
        if ($imports -match "ws2_32|winhttp|wininet|urlmon") {
            throw "Network-capable Windows DLL import found: $($Matches[0])"
        }
    } else {
        Write-Warning "objdump is unavailable; PE import inspection was skipped."
    }

    Write-Host "Privacy engineering audit passed: local-only Windows build, no telemetry/network markers."
}
finally {
    Pop-Location
}
