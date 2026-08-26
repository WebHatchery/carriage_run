# Changelog

This file records player-visible and release-operational changes to Carriage
Run. Dates describe repository milestones, not public availability. No public
PC demo has been released yet.

## Unreleased — first Windows PC demo

### Product gate

- Demo mission boundary, storefront, save-transfer policy, public links, and
  release date still require publisher approval.

### Added

- Release provenance showing version, channel, source commit, UTC build time,
  and pinned toolkit revision in Credits, local diagnostics, and crash logs.
- Machine-readable publisher build records, per-file release manifests, and
  SHA-256 archive sidecars. Dirty working-tree builds are labelled and refused
  by the release-manifest gate.
- PC demo release-candidate checklist and independent-playtest packet.
- Repeatable local-only privacy audit and draft privacy statement.
- Complete locked Windows dependency/asset license inventory and the bundled
  Rajdhani SIL Open Font License notice.
- Product brief with three proposed demo slices and explicit human gates.

### Changed

- Startup asset/localization diagnostics are opt-in for release builds and are
  always suppressed during deterministic media capture.
- Gameplay touch controls sit above the dashboard, use readable text labels,
  and match tutorial wording and hit targets across desktop and touch layouts.
- Hosted CI checks out Carriage Run and `macroquad-toolkit` as sibling projects,
  matching the locked local dependency layout.

### Fixed

- Gameplay HUD camera setup no longer leaves the virtual-resolution interface
  rendered in the wrong coordinate system.
- Font provenance and transitive dependency licensing records now agree with
  the files shipped in the Windows archive.

### Release status

- Local publishing, warnings-denied linting, all automated tests, privacy
  auditing, package-content validation, and exact-commit provenance pass.
- Hosted CI requires an authorized push/run before it can be claimed green for
  a release candidate.
- Clean-machine compatibility, storefront installation, human language review,
  and at least five independent target-player sessions remain required.

## 0.1.0 — development baseline

- Thirty-mission three-act campaign with route branches, bosses, progression,
  guard commands, upgrades, multiple save slots, rolling backups, recovery,
  accessibility/display settings, and English, German, and French data.
- Eight-leg expedition mode with seeded runs, events, relics, stakes, records,
  persistent unlocks, and a finale.
- Windows and WebGL development packaging through the shared WebHatchery
  publisher.

This version is a repository baseline, not evidence of a prior public release.
