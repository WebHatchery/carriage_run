# Carriage Run PC demo — privacy engineering audit

Audit date: 2026-08-27  
Status: engineering evidence; **publisher/legal review still required**  
Scope: the native Windows build and its locked `x86_64-pc-windows-msvc`
dependency closure

The approved demo build does not exist yet, so this audit uses the current
native game as its baseline. Run `scripts/audit_privacy.ps1` again against the
exact release candidate after demo separation and storefront integration.

## Findings

The current Windows executable is local-only:

- Carriage Run does not initialize telemetry, analytics, advertising, accounts,
  cloud saves, crash uploading, or multiplayer/network features.
- `macroquad-toolkit` contains optional `analytics`, `net`, and `db` source
  modules, but Carriage Run enables none of those features. Their dependencies
  and identifying strings are absent from the resolved Windows build.
- The executable imports no Winsock, WinHTTP, WinINet, or URLMon DLL. It has no
  WebHatchery analytics key/header or installation-ID marker.
- Macroquad has an internal module named `telemetry` for local frame profiling.
  Its name may appear in compiler source strings, but it does not send player
  or device data.
- The game has no Steamworks or other storefront SDK integration at this stage.

This supports a privacy promise of **no collection or transmission by the game
itself**, provided the release candidate keeps these results.

## Data stored on the player's PC

Native persistence uses this directory:

`%LOCALAPPDATA%\carriage_run\`

The game may create:

| Files | Contents | Creation and retention |
| --- | --- | --- |
| `save_<slot>.json` | Campaign progress, inventory, difficulty/accessibility toggles, selected save-slot name, records, and a UTC save timestamp | Created by save/autosave; retained until that slot or the app-data folder is deleted |
| `save_<slot>_backup_1.json` through `_backup_3.json` | Rolling copies of the same campaign data | Replaced as saves rotate; deleted with the active slot through the in-game delete action |
| `save_<slot>_corrupt.json` | A quarantined unreadable save | Created only during corruption recovery; retained for possible repair until manually deleted |
| `carriage_run_settings.json` | Display, audio, language, accessibility, drag, and key-binding preferences | Created when settings are saved; retained until manually deleted |
| `crash_log.txt` | Build identity, panic message, and source-code location | Appended only after a native crash; never uploaded; retained until manually deleted |

These files are ordinary local JSON/text rather than encrypted personal-data
storage. The game does not ask for a name, email address, account, precise
location, contacts, payment details, or advertising identifier. A save
timestamp is the only ordinary time record. Save-slot labels accept only a
short ASCII-safe identifier.

Deleting an active save slot removes that save and its three rolling backups.
It does not remove settings, crash logs, or previously quarantined corrupt
saves. A player can remove all Carriage Run data by deleting the app-data
directory above. Storefront uninstallers may leave app-data behind, so public
support text must not promise that uninstalling alone erases it.

## Data leaving the PC

No game data leaves the PC in the audited build. Crash logs remain local unless
the player independently chooses to send one to a future support channel.
Release diagnostics enabled with `CARRIAGE_DIAGNOSTICS=1` add local on-screen
notices only; they do not transmit anything.

Future wishlist, store, or feedback buttons may open a third-party web page.
The destination service can then process data under its own privacy policy,
but that behavior and the approved destinations do not yet exist in this
build. They must be reviewed when implemented.

## Third-party code

The locked Windows closure is recorded in `THIRD_PARTY_LICENSES.md`. It contains
Macroquad and supporting rendering, image, serialization, filesystem, and
Windows integration crates. No network client, analytics client, advertising
SDK, storefront SDK, or remote crash reporter is present.

## Residual risks and release gates

- The release binary contains compiler source paths, including the local build
  account path. This is build-environment disclosure, not runtime collection,
  but release packaging should remap those paths before a public candidate.
- The current crash log grows until manually removed and can contain a panic
  message. Support instructions should ask players to review it before sharing.
- A demo-specific application/save namespace has not been implemented; the
  audit must verify that namespace once the publisher approves the demo slice.
- Any analytics, cloud save, crash upload, account, Steam SDK, online feedback
  submission, or embedded browser addition invalidates the local-only finding
  and requires a new engineering and legal review before release.
- The publisher must supply a public support/privacy contact and approve the
  final notice. This document is factual engineering input, not legal advice.

## Repeatable evidence

`scripts/audit_privacy.ps1` fails if a known network-capable package enters the
Windows closure, game source starts using toolkit networking/analytics APIs,
the release binary gains telemetry markers, or its PE imports gain common
Windows networking libraries. The audit complements—rather than replaces—a
human review of the exact release candidate and any storefront behavior.
