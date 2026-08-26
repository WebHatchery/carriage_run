# Carriage Run PC demo Windows compatibility baseline

Audit date: 2026-08-27

Status: engineering baseline for test planning, **not final public system
requirements**. The approved demo and clean external-machine evidence do not
exist yet. Store copy must use only the minimum/recommended specification that
the exact uploaded candidate actually passes.

## Current build facts

- Native target: `x86_64-pc-windows-msvc`.
- Package form: ZIP containing one executable, four PNG textures, and the
  Rajdhani OFL notice; current archive is roughly 10 MiB.
- Runtime: Rust, Macroquad, and pinned `macroquad-toolkit`; no installer,
  administrator-only service, network client, telemetry, or storefront SDK.
- Virtual UI: 1280×720 with responsive scaling. Existing deterministic captures
  cover desktop, fullscreen, and touch-sized windows, but they are not evidence
  for Windows DPI modes or distinct physical GPUs.
- Persistence: ordinary files under `%LOCALAPPDATA%\carriage_run\`; install path
  and save path are separate.

## Proposed testing floor—not yet a public promise

Use this as the first compatibility matrix, then raise the requirement wherever
real evidence fails:

| Area | Planning floor | Evidence required before claim |
| --- | --- | --- |
| OS | Supported 64-bit Windows 10 and Windows 11 builds | Clean installs on each claimed OS/build, including update/uninstall. |
| CPU | x86-64 desktop/laptop processor | Lowest tested model, sustained demo completion, frame pacing, and thermal behavior. |
| Memory | 4 GiB system RAM planning case | Peak process/system memory captured through the complete demo on a constrained machine. |
| Graphics | Integrated GPU planning case plus a discrete GPU | Exact GPU/driver/API behavior, launch, fullscreen, effects, and frame pacing. Do not invent an API/version minimum from dependency names. |
| Display | 1280×720 planning minimum | 100/125/150/200% Windows scaling, minimum window, 16:9, 16:10, ultrawide, and multi-monitor transitions. |
| Storage | 50 MiB free planning allowance | Download, extraction/install, update staging, saves/backups/log growth, and storefront overhead measured. |
| Input | Keyboard/mouse; Xbox-style controller candidate | Complete uncoached path per advertised device; other controller families only if separately tested. Visible click/tap targets remain available. |
| Audio | Standard Windows output device | Multiple devices, mute/restore, Alt-Tab, disconnect, and sleep/resume. |
| Privilege | Standard non-administrator user | Install/extract, launch, save/reload, update, and uninstall under an actual standard account. |

## Repeatable local package-path evidence

Run after a clean exact-commit publish and release manifest:

```powershell
.\scripts\smoke_windows_package.ps1 -Artifact dist\carriage_run_windows.zip -Channel full
```

The harness revalidates the release manifest, extracts the actual ZIP into two
temporary locations—one containing spaces and one containing non-ASCII
characters—launches the packaged executable from each working directory, makes
a deterministic title capture, and verifies the embedded source commit from
stderr. It writes ignored machine evidence to
`dist/carriage_run_windows_smoke.json` and safely removes only its unique
temporary root.

The harness reports whether its current Windows token is elevated. An elevated
pass is **not** evidence for standard-user compatibility, and neither case is a
clean-machine, antivirus, SmartScreen, storefront-client, GPU, DPI, controller,
sleep/resume, or long-session test.

### Observed local baseline

On 2026-08-27, the clean full-channel package from commit
`b05b9fe1721e78f1105a21ff88b160c67da22c58` (SHA-256
`0d42a23b463f7d9266ce8d0fb4fffa160f7ba023c8294653cb8fe32adf82743c`)
passed both path cases on Microsoft Windows `10.0.26220`, x64. The process token
was non-elevated. Each packaged run exited successfully, produced a 1,359,373
byte title capture, and reported the expected embedded commit. The harness
removed its temporary extraction roots afterward.

This was the existing development host, not a clean Windows installation or a
separate known-standard account. It proves only packaged relative-asset loading,
headless startup/capture, Unicode/space path handling, and build identity on
that host.

## External machine result record

Create one record per physical/virtual system and attach it to the RC:

- RC commit, package SHA-256, storefront build ID, install source:
- Tester, UTC start/end, clean/prior-install state:
- Windows edition/version/build and update state:
- Standard/elevated account and install permissions:
- CPU, RAM, GPU(s), driver, display(s), resolution/scaling/refresh/HDR:
- Audio device and input devices/connection types:
- Install path and whether it covers spaces/non-ASCII:
- Antivirus/SmartScreen product, definitions/date, exact presentation/result:
- Install, launch, new game, tutorial, pause/settings, failure/retry, save/reload,
  demo end, exit, update, uninstall results:
- Alt-Tab, fullscreen/window, monitor move, controller reconnect, audio-device
  change, sleep/resume, and clean shutdown results:
- Session duration, peak memory, frame pacing/performance observations:
- Residual files after uninstall and whether documented behavior matches:
- Issue IDs, evidence, workaround, retest, and reviewer approval:

## Release gate

Do not publish minimum/recommended requirements until the supported floor and
representative recommended hardware both pass the uploaded build. At least one
test must use a clean standard-user machine with no Rust toolchain. Record
failures as known issues or raise the requirement; absence of a report is not a
pass.
