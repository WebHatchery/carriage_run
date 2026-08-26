<#
.SYNOPSIS
    Verify repository evidence behind the Carriage Run asset provenance ledger.

.DESCRIPTION
    This is a coverage and integrity gate, not an ownership determination. It
    intentionally leaves creator, assignment, tool-term, translation, and
    storefront-disclosure attestations to the responsible human publisher.
#>

$ErrorActionPreference = "Stop"
$gameDir = Split-Path -Parent $PSScriptRoot
Push-Location $gameDir
try {
    $ledgerPath = Join-Path $gameDir "docs\ASSET_PROVENANCE.md"
    if (-not (Test-Path -LiteralPath $ledgerPath -PathType Leaf)) {
        throw "Missing asset provenance ledger: $ledgerPath"
    }

    $assetFiles = @(Get-ChildItem (Join-Path $gameDir "assets") -Recurse -File)
    $categories = [ordered]@{
        data = 0
        fonts = 0
        images = 0
        licenses = 0
        packaging = 0
    }
    foreach ($file in $assetFiles) {
        $relative = $file.FullName.Substring($gameDir.Length + 1).Replace('\', '/')
        if ($relative -notmatch '^assets/(?<category>data|fonts|images|licenses|packaging)/') {
            throw "Asset is outside a documented provenance category: $relative"
        }
        $categories[$Matches.category]++
        & git ls-files --error-unmatch -- $relative | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "Asset is not tracked by Git: $relative" }
        $introduction = @(& git log --diff-filter=A --follow --format='%H|%aI' -- $relative)
        if ($LASTEXITCODE -ne 0 -or $introduction.Count -eq 0) {
            throw "Asset has no Git introduction record: $relative"
        }
    }

    $expectedHashes = [ordered]@{
        "assets/images/carriage_run_title.png" = "d7f0f0bdc0920de11178875b11a8ba252e3b0f3cd5749b31fb95870efc9390ea"
        "assets/images/characters_atlas.png" = "5dd9fb0749a48544eabfcfec7921518da56912ffa0d27bfcb26a4c3277cd4757"
        "assets/images/world_atlas.png" = "9ce6d36bfc1e9bb555b7b05f0a3d76a0e8e97a584138299ac9f8e192e24d02e1"
        "assets/images/missions_atlas.png" = "4ebb33edf23354e91d8969c26217d73d53cf54e132a0f806f63a9e162db90553"
        "assets/fonts/english.ttf" = "94bbd25a18ca665999feb05a537de9fd2b860dcfb78bbe9ca00270825bf235da"
        "assets/fonts/latin_extended.ttf" = "94bbd25a18ca665999feb05a537de9fd2b860dcfb78bbe9ca00270825bf235da"
        "assets/licenses/OFL-Rajdhani.txt" = "46d7f96ac9e4200d3c4e2617a7acebb795a969492948d61f22ec697342e52b82"
        "assets/packaging/carriage_run.ico" = "74cc38ecd876f209a1ed7d809b14bc2c0544cc86c8cc92249af0d2dd00db3027"
    }
    foreach ($entry in $expectedHashes.GetEnumerator()) {
        $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $entry.Key).Hash.ToLowerInvariant()
        if ($actual -ne $entry.Value) { throw "Provenance hash changed for $($entry.Key): $actual" }
    }

    $titleHash = $expectedHashes["assets/images/carriage_run_title.png"]
    foreach ($copy in @("carriage_run_title.png", "catalog_thumbnail.png")) {
        $copyHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $copy).Hash.ToLowerInvariant()
        if ($copyHash -ne $titleHash) { throw "Title deployment copy diverged: $copy" }
    }

    $expectedIntroductions = [ordered]@{
        "assets/images/carriage_run_title.png" = "2085f65793a497caa304cc7db126abd353e0120a"
        "assets/images/characters_atlas.png" = "210611645de135d0505b0bfc08c338f34c6f582a"
        "assets/images/world_atlas.png" = "210611645de135d0505b0bfc08c338f34c6f582a"
        "assets/images/missions_atlas.png" = "210611645de135d0505b0bfc08c338f34c6f582a"
        "assets/fonts/english.ttf" = "c3fb585db015758f2cf71aea7d570f4d70074754"
        "assets/fonts/latin_extended.ttf" = "c3fb585db015758f2cf71aea7d570f4d70074754"
        "assets/packaging/carriage_run.ico" = "c3fb585db015758f2cf71aea7d570f4d70074754"
        "assets/licenses/OFL-Rajdhani.txt" = "ebff3401b1479992e4b82f0be9839c93a6f2d386"
    }
    foreach ($entry in $expectedIntroductions.GetEnumerator()) {
        $actual = @(& git log --diff-filter=A --follow --format='%H' -- $entry.Key) | Select-Object -Last 1
        if ($actual -ne $entry.Value) {
            throw "Unexpected introduction commit for $($entry.Key): $actual"
        }
    }

    $registry = Get-Content -Raw -LiteralPath "asset_registry.json" | ConvertFrom-Json
    $requiredRuntimeAssets = @(
        "assets/images/carriage_run_title.png",
        "assets/images/characters_atlas.png",
        "assets/images/world_atlas.png",
        "assets/images/missions_atlas.png",
        "assets/licenses/OFL-Rajdhani.txt"
    )
    foreach ($required in $requiredRuntimeAssets) {
        if ($registry.assets -notcontains $required) {
            throw "Runtime asset registry is missing provenance-covered file: $required"
        }
    }

    $ledger = Get-Content -Raw -LiteralPath $ledgerPath
    foreach ($marker in @(
        "human attestation required",
        "AI-assisted/generated media indicated",
        "SIL Open Font License 1.1",
        "translator identity",
        "ownership conclusion"
    )) {
        if ($ledger -notlike "*$marker*") { throw "Provenance ledger lost required gate: $marker" }
    }

    Write-Host "Asset provenance engineering audit passed: $($assetFiles.Count) tracked asset files covered."
    $categorySummary = @($categories.Keys | ForEach-Object { "$_=$($categories[$_])" }) -join ', '
    Write-Host "Categories: $categorySummary"
    Write-Warning "Human creator/rights/tool/translation/storefront attestations remain required before release."
}
finally {
    Pop-Location
}
