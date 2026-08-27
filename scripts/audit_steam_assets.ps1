<# Validates Steam asset filenames, formats, dimensions, screenshots, and logo alpha. #>
param(
    [string]$AssetDir = "store_assets\steam",
    [string]$Spec = "docs\PC_DEMO_STEAM_ASSET_SPEC.json",
    [string]$Output = "dist\steam_assets\audit.json"
)

$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot

function Resolve-GamePath([string]$Path) {
    if ([IO.Path]::IsPathRooted($Path)) { return [IO.Path]::GetFullPath($Path) }
    return [IO.Path]::GetFullPath((Join-Path $gameDir $Path))
}

function Image-HasVisibleTransparency([string]$Path) {
    $bitmap = [Drawing.Bitmap]::new($Path)
    try {
        $transparent = $false
        $visible = $false
        for ($y = 0; $y -lt $bitmap.Height -and (-not $transparent -or -not $visible); $y++) {
            for ($x = 0; $x -lt $bitmap.Width -and (-not $transparent -or -not $visible); $x++) {
                $alpha = $bitmap.GetPixel($x, $y).A
                if ($alpha -lt 255) { $transparent = $true }
                if ($alpha -gt 0) { $visible = $true }
            }
        }
        return $transparent -and $visible
    }
    finally { $bitmap.Dispose() }
}

$assetPath = Resolve-GamePath $AssetDir
$specPath = Resolve-GamePath $Spec
$outputPath = Resolve-GamePath $Output
if (-not (Test-Path -LiteralPath $specPath -PathType Leaf)) { throw "Steam asset spec not found: $specPath" }
$specData = Get-Content -Raw -LiteralPath $specPath | ConvertFrom-Json
if ($specData.schema_version -ne 1) { throw "Unsupported Steam asset spec schema '$($specData.schema_version)'." }
Add-Type -AssemblyName System.Drawing

$findings = @()
$records = @()
foreach ($asset in $specData.assets) {
    $matches = @()
    if (Test-Path -LiteralPath $assetPath -PathType Container) {
        $matches = @(Get-ChildItem -LiteralPath $assetPath -File | Where-Object {
            $_.BaseName -eq $asset.id -and $_.Extension.TrimStart('.').ToLowerInvariant() -in @($asset.formats)
        })
    }
    if ($matches.Count -eq 0) {
        if ($asset.required) { $findings += "$($asset.id): missing required asset" }
        continue
    }
    if ($matches.Count -gt 1) {
        $findings += "$($asset.id): multiple supported files found"
        continue
    }
    $file = $matches[0]
    try { $image = [Drawing.Image]::FromFile($file.FullName) }
    catch { $findings += "$($asset.id): unreadable image"; continue }
    try {
        $dimensionsPass = if ($asset.mode -eq "either_axis") {
            $image.Width -eq $asset.width -or $image.Height -eq $asset.height
        } else {
            $image.Width -eq $asset.width -and $image.Height -eq $asset.height
        }
        if (-not $dimensionsPass) {
            $expectation = if ($asset.mode -eq "either_axis") {
                "width $($asset.width) or height $($asset.height)"
            } else { "$($asset.width)x$($asset.height)" }
            $findings += "$($asset.id): expected $expectation, got $($image.Width)x$($image.Height)"
        }
        $records += [pscustomobject][ordered]@{
            id = $asset.id
            file = $file.Name
            required = [bool]$asset.required
            width = $image.Width
            height = $image.Height
            sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $file.FullName).Hash.ToLowerInvariant()
        }
    }
    finally { $image.Dispose() }
    if ($asset.alpha -and -not (Image-HasVisibleTransparency $file.FullName)) {
        $findings += "$($asset.id): PNG must contain both transparent and visible pixels"
    }
}

$screenshotSpec = $specData.screenshots
$screenshotDir = Join-Path $assetPath $screenshotSpec.directory
$screenshots = @()
if (Test-Path -LiteralPath $screenshotDir -PathType Container) {
    $screenshots = @(Get-ChildItem -LiteralPath $screenshotDir -File | Where-Object {
        $_.Extension.TrimStart('.').ToLowerInvariant() -in @($screenshotSpec.formats)
    } | Sort-Object Name)
}
if ($screenshots.Count -lt $screenshotSpec.minimum_count) {
    $findings += "screenshots: need at least $($screenshotSpec.minimum_count), found $($screenshots.Count)"
}
$screenshotRecords = @()
$targetRatio = [double]$screenshotSpec.aspect_width / [double]$screenshotSpec.aspect_height
foreach ($file in $screenshots) {
    try { $image = [Drawing.Image]::FromFile($file.FullName) }
    catch { $findings += "screenshots/$($file.Name): unreadable image"; continue }
    try {
        $ratio = [double]$image.Width / [double]$image.Height
        if ($image.Width -lt $screenshotSpec.minimum_width -or $image.Height -lt $screenshotSpec.minimum_height) {
            $findings += "screenshots/$($file.Name): below $($screenshotSpec.minimum_width)x$($screenshotSpec.minimum_height) minimum"
        }
        if ([Math]::Abs($ratio - $targetRatio) -gt 0.001) {
            $findings += "screenshots/$($file.Name): expected 16:9, got $($image.Width)x$($image.Height)"
        }
        $screenshotRecords += [pscustomobject][ordered]@{
            file = $file.Name
            width = $image.Width
            height = $image.Height
            sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $file.FullName).Hash.ToLowerInvariant()
        }
    }
    finally { $image.Dispose() }
}

$record = [ordered]@{
    schema_version = 1
    audited_at_utc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    specification_verified_date = $specData.verified_date
    asset_directory = $assetPath
    result = if ($findings.Count -eq 0) { "passed" } else { "failed" }
    assets = $records
    screenshots = $screenshotRecords
    findings = $findings
    manual_review_required = @(
        "capsule and library logo legibility at displayed sizes",
        "DEMO identity is clear without prohibited promotional text",
        "library hero contains artwork only and no words",
        "capsules contain only product artwork, name, and approved subtitle",
        "screenshots show truthful gameplay from the exact demo candidate",
        "PG-13 suitability, localization, safe areas, cropping, and creative approval"
    )
}
$parent = Split-Path -Parent $outputPath
if ($parent) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
$utf8NoBom = [Text.UTF8Encoding]::new($false)
[IO.File]::WriteAllText($outputPath, ($record | ConvertTo-Json -Depth 8) + [Environment]::NewLine, $utf8NoBom)
if ($findings.Count -gt 0) { throw "Steam asset audit failed: $($findings -join '; ')" }
Write-Host "Steam asset audit passed: $($records.Count) assets and $($screenshots.Count) screenshots."
Write-Host "Evidence: $outputPath"
