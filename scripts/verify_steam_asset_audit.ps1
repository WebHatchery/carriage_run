<# Builds synthetic images to verify Steam asset acceptance and rejection paths. #>
$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot
$auditScript = Join-Path $PSScriptRoot "audit_steam_assets.ps1"
$specPath = Join-Path $gameDir "docs\PC_DEMO_STEAM_ASSET_SPEC.json"
$tempBase = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$tempRoot = [IO.Path]::GetFullPath((Join-Path $tempBase "carriage_run_steam_assets_$([Guid]::NewGuid().ToString('N'))"))
$safePrefix = $tempBase.TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
if (-not $tempRoot.StartsWith($safePrefix, [StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing unsafe Steam asset test root outside $tempBase"
}

Add-Type -AssemblyName System.Drawing

function New-TestImage([string]$Path, [int]$Width, [int]$Height, [switch]$Transparent) {
    if (Test-Path -LiteralPath $Path) { Remove-Item -LiteralPath $Path -Force }
    $format = if ([IO.Path]::GetExtension($Path).ToLowerInvariant() -in @(".jpg", ".jpeg")) {
        [Drawing.Imaging.ImageFormat]::Jpeg
    } else { [Drawing.Imaging.ImageFormat]::Png }
    $pixelFormat = if ($Transparent) {
        [Drawing.Imaging.PixelFormat]::Format32bppArgb
    } else { [Drawing.Imaging.PixelFormat]::Format24bppRgb }
    $bitmap = [Drawing.Bitmap]::new($Width, $Height, $pixelFormat)
    $graphics = [Drawing.Graphics]::FromImage($bitmap)
    try {
        if ($Transparent) {
            $graphics.Clear([Drawing.Color]::Transparent)
            $brush = [Drawing.SolidBrush]::new([Drawing.Color]::FromArgb(255, 226, 155, 48))
            try { $graphics.FillRectangle($brush, 20, 20, [Math]::Max(1, $Width - 40), [Math]::Max(1, $Height - 40)) }
            finally { $brush.Dispose() }
        } else {
            $graphics.Clear([Drawing.Color]::FromArgb(18, 36, 29))
        }
        $bitmap.Save($Path, $format)
    }
    finally {
        $graphics.Dispose()
        $bitmap.Dispose()
    }
}

try {
    $assetDir = Join-Path $tempRoot "steam"
    $screenshotDir = Join-Path $assetDir "screenshots"
    New-Item -ItemType Directory -Path $screenshotDir -Force | Out-Null
    foreach ($asset in @(
        @{ Name = "header_capsule.png"; Width = 920; Height = 430 },
        @{ Name = "small_capsule.png"; Width = 462; Height = 174 },
        @{ Name = "main_capsule.png"; Width = 1232; Height = 706 },
        @{ Name = "vertical_capsule.png"; Width = 748; Height = 896 },
        @{ Name = "shortcut_icon.png"; Width = 256; Height = 256 },
        @{ Name = "app_icon.jpg"; Width = 184; Height = 184 },
        @{ Name = "library_capsule.png"; Width = 600; Height = 900 },
        @{ Name = "library_hero.png"; Width = 3840; Height = 1240 },
        @{ Name = "library_header.png"; Width = 920; Height = 430 }
    )) {
        New-TestImage (Join-Path $assetDir $asset.Name) $asset.Width $asset.Height
    }
    New-TestImage (Join-Path $assetDir "library_logo.png") 1280 300 -Transparent
    for ($index = 1; $index -le 5; $index++) {
        New-TestImage (Join-Path $screenshotDir "gameplay_$index.png") 1920 1080
    }

    $validOutput = Join-Path $tempRoot "valid.json"
    & $auditScript -AssetDir $assetDir -Spec $specPath -Output $validOutput
    $valid = Get-Content -Raw -LiteralPath $validOutput | ConvertFrom-Json
    if ($valid.result -ne "passed" -or $valid.assets.Count -ne 10 -or $valid.screenshots.Count -ne 5) {
        throw "Synthetic valid Steam asset set did not produce the expected audit summary."
    }

    New-TestImage (Join-Path $assetDir "small_capsule.png") 461 174
    try {
        & $auditScript -AssetDir $assetDir -Spec $specPath -Output (Join-Path $tempRoot "invalid.json")
        throw "Wrong-sized Steam capsule was accepted."
    }
    catch {
        if ($_.Exception.Message -notlike "*small_capsule: expected 462x174, got 461x174*") { throw }
    }
    Write-Host "Steam asset audit verification passed."
}
finally {
    $resolved = [IO.Path]::GetFullPath($tempRoot)
    if ($resolved.StartsWith($safePrefix, [StringComparison]::OrdinalIgnoreCase) -and
        [IO.Path]::GetFileName($resolved) -like "carriage_run_steam_assets_*") {
        Remove-Item -LiteralPath $resolved -Recurse -Force -ErrorAction SilentlyContinue
    }
}
