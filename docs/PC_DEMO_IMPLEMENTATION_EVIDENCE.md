# Carriage Run Option A demo implementation evidence

Recorded: 2026-08-27

## Implemented boundary

- Explicit build mode: Cargo feature `demo`.
- Embedded missions, in authored order: `muddy_road`, `bandit_bend`,
  `courier_deadline`, and `bonebridge_pass`.
- Journey rule: both middle contracts open after The Muddy Road; clearing one
  closes the other for that campaign and unlocks Bonebridge Pass.
- Finale: a successful Bonebridge Pass opens `End of Demo`; failure keeps the
  normal retry/results route.
- Ending actions: `Replay Demo` with destructive confirmation, `Title`, and
  `Exit Game`, all visible mouse/touch targets. Wishlist and feedback buttons
  are deliberately absent while their destinations and storefront are not
  approved.
- Isolated persistence identity: application `carriage_run_demo`, default slot
  `demo_campaign`, save version suffix `-demo1`, and separate settings/crash
  storage through the same application namespace.
- Full-only surfaces blocked in demo mode: expedition, records, cosmetics,
  extra carriage collection, and multi-slot save management.

## Build and package identity

`publish.ps1 -Channel demo` invokes a local-only Windows demo packager. It
rejects deployment/WebGL switches, builds with `--features demo`, copies only
the registered runtime assets, and emits:

`carriage_run_demo_<version>_x86_64-pc-windows-msvc.zip`

The package verifier checks the exact four-contract data, explicit compile-time
selection, unique archive identity, one executable, and absence of exposed
mission JSON. The existing release-manifest tooling records commit, build time,
channel, target, toolkit pin, file sizes, and SHA-256 values once the tree is
clean.

## Local verification

- Full-mode unit/integration suite: passed (142 passed, one intentionally
  ignored fixture exporter, plus asset-registry and Rust file-size tests).
- Full and demo warnings-denied lint: passed.
- Demo identity/containment/fork/finale unit tests: passed.
- Demo embedded-data test: passed with exactly four missions.
- Option A balance matrix: 480 deterministic route runs passed the standard
  completion/duration regression corridor; raw CSV and interpretation are in
  `docs/verification/demo_balance_report.csv` and
  `PC_DEMO_BALANCE_REPORT.md`.
- Standard `publish.ps1` full Windows/WebGL validation: passed, preserving the
  full build behavior.
- Demo package contract verifier: passed on the generated local archive.
- Eight exact 1920×1080 screens were captured from a demo-feature release
  binary and visually reviewed; see `PC_DEMO_SCREENSHOT_EVIDENCE.md`.

## Deliberately unresolved

No storefront, URL, feedback destination, save-transfer promise, public timing
claim, upload, or publication authority is inferred from Option A approval.
Those surfaces remain inactive until individually approved.
