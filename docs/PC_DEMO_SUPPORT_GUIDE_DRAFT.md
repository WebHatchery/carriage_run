# Carriage Run PC demo support and troubleshooting draft

Status: factual draft for the future Windows demo. Replace every bracketed
publisher field, retest against the exact uploaded build, and obtain human
approval before publishing. Current engineering evidence indicates the game is
local-only and does not automatically send logs or player data.

## Information shown to every player

When requesting help, ask for:

- the two build lines on the in-game **Credits** screen;
- Windows version, display resolution/scaling, GPU, and input device;
- the exact step where the problem occurred and whether relaunching helped;
- a screenshot limited to the game window, if useful.

- Support contact: **[publisher must supply]**
- Privacy notice: **[publisher must supply approved URL]**
- Known issues: `PC_DEMO_KNOWN_ISSUES_DRAFT.md` until a public URL exists

Do not ask for passwords, storefront cookies, payment information, Windows
account names, an entire `%LOCALAPPDATA%` directory, or unrelated screenshots.

## The game will not install or launch

1. Confirm the download came from **[approved storefront/page]** and that its
   build/version matches the release notice.
2. If using a ZIP build, extract the entire archive before starting it. Keep the
   executable and `assets` folder together; do not run from inside the ZIP.
3. Try a normal writable folder whose path may contain spaces; administrator
   privileges should not be required.
4. If antivirus or SmartScreen displays a warning, record the product name,
   scanner, timestamp, and exact message. Do not disable security software on
   support's instruction. Use the storefront's verify/redownload function or
   compare the published SHA-256 where available.
5. If the executable opens and immediately closes, check `crash_log.txt` as
   described below. Preserve the original download until support confirms what
   evidence is needed.

## Display, clipping, or fullscreen problems

- Open **Settings** and switch fullscreen off, select another resolution, or
  lower the text-size setting. Apply one change at a time and note the result.
- Record Windows scaling (100%, 125%, 150%, or 200%), monitor resolution,
  aspect ratio, refresh rate, and whether the window moved between monitors.
- If settings prevent usable display, close the game, make a backup of
  `%LOCALAPPDATA%\carriage_run\carriage_run_settings.json`, then remove only
  that settings file. The game recreates defaults next launch; campaign saves
  remain untouched.

## Keyboard, mouse, or controller problems

- Use the visible controls on screen; keyboard shortcuts supplement those
  buttons and gestures rather than replacing them.
- Open **Settings** to review bindings. Reconnect a controller, then return to
  the title or pause screen before retrying the action.
- Record controller make/model, wired or wireless connection, any remapping
  software, and whether Windows sees duplicate controllers.
- Never delete save files to troubleshoot an input problem.

## Missing progress or a damaged save

Native game data is stored under:

`%LOCALAPPDATA%\carriage_run\`

The game keeps up to three rolling backups for each save slot. On startup, it
moves an unreadable primary save aside with a `_corrupt` name and attempts to
restore the newest readable backup. Read the on-screen recovery notice before
starting a new campaign.

If progress still appears missing:

1. Close the game and storefront client.
2. Copy the entire `carriage_run` directory to a separate safe folder. Work only
   on a copy during investigation.
3. Record the active slot name and the filenames present; do not rename or edit
   JSON files unless support supplies a case-specific reviewed procedure.
4. Confirm whether the build is full, demo, or development from Credits. The
   public demo is required to use its own namespace once implemented.
5. Send only the minimum named save file requested through **[approved private
   support channel]**, after reviewing it. Saves contain game progress,
   settings, and timestamps but are not encrypted.

Deleting a slot in game removes its active save and three rolling backups. It
does not remove quarantined saves, settings, or crash logs.

## Crash logs and diagnostics

Native crashes may append to:

`%LOCALAPPDATA%\carriage_run\crash_log.txt`

The log includes build identity, panic text, and a source location. It stays on
the PC unless the player chooses to share it and may include local compiler
path fragments. Ask the player to review the file and send only the relevant
latest block through the approved private channel.

For a guided support session, native startup notices can be enabled from
PowerShell without sending data anywhere:

```powershell
$env:CARRIAGE_DIAGNOSTICS = "1"
.\carriage_run.exe
```

These notices are local and disappear when the game is launched normally.

## Audio, focus, and performance

- Check master, effects, and music levels in **Settings**, then confirm the
  intended Windows output device is active.
- Record whether the issue begins after Alt-Tab, changing fullscreen, moving
  monitors, sleep/resume, or connecting/disconnecting a device.
- For stutter, record resolution, scaling, GPU/driver, refresh rate, VSync/FPS
  cap, reduced-motion setting, and a short game-only capture if practical.
- Do not request third-party system inventories or background-process dumps as
  a default troubleshooting step.

## Uninstalling and removing local data

Storefront uninstall may leave saves and settings so reinstalling does not
erase progress. To remove all Carriage Run local data, close the game, back up
anything wanted, then delete `%LOCALAPPDATA%\carriage_run\`. This removes saves,
backups, quarantined saves, settings, and crash logs and cannot be undone
without the player's backup.

## Support-response record

For each case, record a non-identifying case ID, UTC times, exact build identity,
environment, symptom, minimal reproduction, recovery/workaround, files the
player voluntarily supplied, retention/deletion date, linked known issue, and
resolution. Escalate suspected save loss, privacy/security discrepancies,
package contamination, and repeatable blocker/critical crashes immediately.
