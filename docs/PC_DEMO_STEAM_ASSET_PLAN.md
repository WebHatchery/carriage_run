# Carriage Run PC demo Steam asset plan

Prepared: 2026-08-27  
Status: current specification and validation plan; approved creative assets do
not exist yet

Valve changed most capsule dimensions in August 2024 and states that the older
sizes are no longer accepted. Recheck the official templates immediately before
final export and upload:

- <https://partner.steamgames.com/doc/store/assets>
- <https://partner.steamgames.com/doc/store/assets/standard>
- <https://partner.steamgames.com/doc/store/assets/libraryassets>
- <https://partner.steamgames.com/doc/store/assets/rules>
- <https://partner.steamgames.com/doc/store/application/demos>

## Required local filenames

Place approved exports in `store_assets/steam/` and gameplay images in
`store_assets/steam/screenshots/`.

| File basename | Current dimensions | Key automated rule |
| --- | ---: | --- |
| `header_capsule` | 920×430 | Exact dimensions |
| `small_capsule` | 462×174 | Exact dimensions |
| `main_capsule` | 1232×706 | Exact dimensions |
| `vertical_capsule` | 748×896 | Exact dimensions |
| `shortcut_icon` | 256×256 | PNG or ICO |
| `app_icon` | 184×184 | JPEG |
| `library_capsule` | 600×900 | Exact dimensions |
| `library_hero` | 3840×1240 | PNG; exact dimensions |
| `library_logo` | 1280 wide and/or 720 tall | PNG with visible and transparent pixels |
| `library_header` | 920×430 | Exact dimensions |

The optional `page_background` is 1438×810. If an approved Steam event is used,
the event cover is 800×450 and the optional event header is 1920×622.

The project release gate requires at least five 16:9 gameplay screenshots at
1920×1080 or larger from the exact demo candidate. The current full-game
verification captures are engineering source material, not approved demo media.

## Automated audit

Run:

```powershell
.\scripts\audit_steam_assets.ps1
```

The machine-readable rules live in `PC_DEMO_STEAM_ASSET_SPEC.json`. The audit
rejects missing or duplicate exports, unsupported extensions, wrong dimensions,
undersized/non-16:9 screenshots, and a library logo without both transparent
and visible pixels. It writes a hash inventory to `dist/steam_assets/audit.json`.

## Human creative and policy review

Automation cannot determine whether:

- `DEMO` is unmistakable while remaining consistent with Valve's permitted
  product-name/subtitle rules;
- the logo remains readable in Steam's smallest generated capsule;
- art truthfully represents the contained demo rather than full-only content;
- the library hero contains no text and keeps critical art in its safe area;
- the image set is PG-13 appropriate and correctly localized;
- screenshots contain only gameplay, no diagnostic overlays or marketing copy;
- at least four screenshots can truthfully be marked suitable for all ages; or
- the publisher approves the title treatment and contrast with in-game art.

Use the current official templates, preview every placement in Steamworks, and
retain human approval against hashes from the exact exported files.
