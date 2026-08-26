# Carriage Run PC demo release-candidate checklist

Use a fresh copy of this checklist for every candidate. Attach command output,
screenshots, manifests, tester results, and storefront records rather than
marking a gate complete from memory. A technically passing build is not public
release authorization.

## Candidate identity

- RC name:
- Commit:
- Version and channel:
- Rust and Cargo versions:
- `macroquad-toolkit` revision from `toolkit.lock`:
- Build UTC:
- Package filename:
- Package SHA-256:
- Release-manifest filename:
- Store build/depot ID, if uploaded:
- Number of independent target-player sessions:
- Last known-good RC and storage location:

## Product and authority gate

- [ ] The publisher approved the demo slice, session promise, stopping point,
  storefront, save-transfer policy, target audience, and intended release date.
- [ ] The publisher supplied or approved the public store, wishlist, feedback,
  support, privacy, and contact links used by the build.
- [ ] Legal publisher identity and required storefront onboarding are complete.
- [ ] The final build, public claims, media, release timing, and go/no-go decision
  have named human owners. Record names and approval timestamps in the RC log.

## Frozen source and build inputs

- [ ] The candidate comes from the recorded commit and the project tree is clean.
  A publisher run from a changed tree is visibly marked `-dirty`, and the
  release-manifest gate must reject it.
- [ ] `Cargo.lock` is committed and `toolkit.lock` names the reviewed toolkit
  revision.
- [ ] Only approved fixes entered the release branch after content freeze.
- [ ] Version, demo channel, save namespace, and visible build metadata agree.
- [ ] Build-machine toolchain versions and relevant environment are recorded.

## Automated gates

Run every command from the project directory on the exact candidate commit.

```powershell
cargo fmt -- --check
cargo clippy --all-targets --all-features -- -D warnings
cargo test --all-features
.\scripts\generate_license_inventory.ps1
.\scripts\audit_asset_provenance.ps1
.\publish.ps1
.\scripts\audit_privacy.ps1
.\scripts\write_release_manifest.ps1 -Artifact dist\carriage_run_demo_windows_x86_64_<version>.zip -Channel demo
```

- [ ] Formatting passes.
- [ ] Clippy passes with warnings denied.
- [ ] All tests pass and the test count is recorded.
- [ ] License inventory regeneration produces no unexplained change.
- [ ] Asset provenance audit passes, and every human creator/ownership/tool,
  translation, and storefront AI-disclosure attestation is attached.
- [ ] The publisher completes and produces the uniquely named demo archive.
- [ ] Privacy engineering audit passes.
- [ ] Release-manifest validation passes; archive and per-file hashes are saved.
- [ ] Hosted CI is green for the exact commit. Link the run:

## Package inspection and retention

- [ ] The archive contains exactly one executable plus approved runtime assets
  and notices—no source, credentials, debug symbols, test saves, crash logs,
  unrelated WebGL files, or full-release content.
- [ ] Required third-party notices, including the Rajdhani OFL notice, ship.
- [ ] The `.sha256` sidecar independently verifies against the retained ZIP.
- [ ] The JSON manifest records the expected version, commit, channel, toolkit
  revision, publisher build time, package hash, and every contained file; its
  identity agrees with `carriage_run_build_info.json`.
- [ ] The RC archive, manifest, checksum, logs, and test evidence are retained
  together in access-controlled storage.
- [ ] The last known-good build remains available and its rollback destination,
  owner, and expected recovery time are recorded.

## Packaged-build critical path

Complete each path without development tools or pre-existing saves.

- [ ] Keyboard-only: launch, new game, tutorial, route choice, upgrade, failure,
  retry, pause/settings, demo end, replay, and exit.
- [ ] Controller-only: the same path, including disconnect and reconnect.
- [ ] Mouse/touch targets provide every required action and visible instructions
  name the actual control or gesture.
- [ ] Save creation, reload, backup recovery, deletion, version handling, and the
  approved transfer/non-transfer policy work in the demo namespace.
- [ ] Focus loss, audio mute/restore, window/fullscreen transitions, Alt-Tab,
  sleep/resume where available, and clean shutdown preserve valid state.
- [ ] The end-of-demo store, feedback, replay, and exit actions are correct for
  the chosen storefront and never expose unavailable full-release content.

## Compatibility and safety evidence

- [ ] Test on a clean supported Windows installation using a standard
  non-administrator account.
- [ ] Test paths containing spaces and non-ASCII characters.
- [ ] Cover the approved minimum and recommended hardware, integrated and
  discrete graphics where available, and common controller families.
- [ ] Cover 100%, 125%, 150%, and 200% display scaling plus 16:9, 16:10,
  ultrawide, and minimum-window layouts.
- [ ] Record install, launch, update, and uninstall behavior through the chosen
  storefront client.
- [ ] Scan the exact archive with available malware scanners and record scanner,
  definition/date, result, and any investigated false positive. A clean result
  is supporting evidence, not proof of safety.

## Player, language, media, and policy review

- [ ] At least five independent target players completed uncoached sessions
  using `PC_DEMO_PLAYTEST_PACKET.md`; repeated comprehension failures are fixed
  or explicitly accepted.
- [ ] English, German, and French pass automated key/glyph/overflow checks and
  fluent human review of the actual demo screens using
  `PC_DEMO_LOCALIZATION_REVIEW_PACKET.md`. Advertise only the languages whose
  complete approved demo slice passes.
- [ ] Store screenshots and trailer footage come from this demo build, meet the
  selected storefront's current requirements, and contain no diagnostics.
- [ ] Store copy, system requirements, accessibility/language claims, content
  descriptions, asset provenance, license record, privacy statement, and any
  EULA/support/refund copy match the shipped build and have human approval.

## Defects, decision, and rollback

- Open blocker/critical defects:
- Open high-severity defects and explicit acceptance owner/time:
- Other known issues and player-facing workarounds:
- Changed evidence since the last RC:
- Rollback trigger, procedure, owner, and last known-good build:
- Support and first-week monitoring owner/coverage:
- Engineering recommendation: GO / NO-GO
- Human final decision: GO / NO-GO
- Human approver and timestamp:

Use `PC_DEMO_KNOWN_ISSUES_DRAFT.md` for issue closeout and
`PC_DEMO_ROLLBACK_PROCEDURE.md` for the retained-build decision and switch
record. Player-facing troubleshooting must be reviewed from
`PC_DEMO_SUPPORT_GUIDE_DRAFT.md` against the exact uploaded candidate.

No-go remains the default while any product/authority item, blocker, exact-build
CI gate, clean-machine critical path, five-player gate, policy/licensing gate,
uploaded-build verification, rollback assignment, or final human approval is
missing.
