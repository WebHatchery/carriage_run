# Carriage Run PC demo go/no-go report — engineering baseline

Prepared: 2026-08-27  
Decision owner: [publisher name required]  
Candidate public date: [not supplied]  
Storefront: [Steam / itch.io / both not approved]

## Recommendation

**NO-GO for public demo release.**

The current engineering baseline is healthy, but it is deliberately a
`full`-channel package, not an approved or contained demo. Product scope,
storefront, save-transfer policy, public identity and destinations, languages,
legal claims, external compatibility, independent playtests, storefront media,
and uploaded-build verification remain open gates. Passing local automation is
not authority to label or release the full game as a demo.

## Exact baseline reviewed

| Item | Value |
| --- | --- |
| Source commit | `375ce1397b78dbf9f5bf2fe1655fcee3d938ba8c` |
| Version | `0.1.0` |
| Build channel | `full` |
| Toolkit revision | `ae5eaf4d793001230e785bd4f2dfd52c7b2fd060` |
| Windows archive | `dist/carriage_run_windows.zip` |
| Archive SHA-256 | `fec77c6f2f5715f2f28bf6fe77003f58d544863785baa8777ead99d821f35fc3` |
| Package shape | Six runtime files; one executable; no test-save output |
| Local account | Non-elevated token on the existing development host |
| Public upload/build ID | None |

This archive is a local engineering baseline only. It is not the future demo
candidate because it contains the full campaign channel and predates an
approved demo boundary.

## Passed evidence on this baseline

| Gate | Result | Scope and limitation |
| --- | --- | --- |
| Formatting | PASS | Rust formatting check. |
| Native lint | PASS | Clippy with warnings denied, all targets/features. |
| WebAssembly lint | PASS | Release target Clippy with warnings denied. |
| Automated tests | PASS | 135 unit tests and two integration tests; one intentionally ignored on-demand fixture exporter. |
| Rust file-size standard | PASS | 95 Rust files checked; none exceeds 800 lines. |
| Full publisher | PASS | Windows and WebGL build/package plus local preview deployment. WebGL is validation evidence, not public-demo platform scope. |
| Release package shape | PASS | One executable and registered runtime assets/notices only. |
| Build provenance | PASS | Package record reports the exact clean source and pinned toolkit revisions. |
| Absolute build-path audit | PASS | No checkout, Cargo-home, or build-account path in packaged runtime files. |
| Packaged path smoke | PASS | Launch/capture succeeds after extraction to space and non-ASCII paths. |
| Privilege observation | PASS with limit | Smoke ran under a non-elevated token on the development machine; not a clean standard-user install. |
| Privacy engineering audit | PASS | No telemetry/network markers in the current local-only build. |
| Microsoft Defender custom scan | PASS with limit | Zero detections for the exact hash; not SmartScreen reputation or proof of safety. |
| CPU regression baseline | PASS with limit | Clean 300-frame deterministic capture at three window shapes. Worst steady p95 update + draw submission was 0.96 ms on a Ryzen 7 5800X/RTX 4080 SUPER host; GPU presentation and frame pacing are excluded. |

Generated evidence beneath `dist/` is machine-local and ignored by version
control. Preserve the exact release records with any real RC rather than
assuming they can be reconstructed later.

## Engineering work completed

- Hosted workflow layout now matches the sibling toolkit dependency, pins the
  exact toolkit revision, requires the standalone lockfile, and uses locked
  builds. The workflow changes are local until pushed and observed on GitHub.
- The Windows package has manifest/checksum generation, quiet build provenance,
  privacy and build-path audits, packaged-path smoke, Defender evidence, and a
  rollback/support procedure.
- Release diagnostics are opt-in; the fullscreen HUD collision was repaired;
  visible-control wording and recovery paths were audited.
- Native controller polling, focus-loss pause/mute/input disarm, controller
  disconnect recovery, audio-loop ownership, and clean final-save shutdown are
  implemented and covered by deterministic tests.
- License and font provenance records, full locked dependency inventory, asset
  provenance, privacy draft, localization review packet, compatibility matrix,
  playtest packet, known-issues draft, and RC checklist exist.
- Five typed, isolated Option A playtest save fixtures can be generated and
  installed without overwriting the normal campaign slot.
- A contingent Steam-focused copy packet exists and withholds unsupported
  language, controller, hardware, identity, date, and external-link claims.

## Release blockers

| ID | Blocker | Required closure evidence | Owner |
| --- | --- | --- | --- |
| GO-01 | Demo product is not approved. | Completed approval block in `PC_DEMO_PRODUCT_BRIEF.md`. | Publisher |
| GO-02 | No demo boundary exists. | Explicit demo build with approved mission containment, separate identity/save namespace, full-only content exclusion, end screen, replay, and package-failure tests. | Agent after GO-01 |
| GO-03 | Storefront and public destinations are unknown. | Approved storefront, base/demo IDs or itch slug, full-game destination, feedback/support destination, and secret-safe configuration. | Publisher |
| GO-04 | Hosted CI has not been observed green on these commits. | Push both repositories as needed and retain successful Linux/WebGL and Windows run URLs for the exact RC. | Repository owner |
| GO-05 | External Windows compatibility is unproven. | Exact uploaded build passes the required clean-machine, standard-user, GPU, DPI, audio, controller, sleep/resume, update, and uninstall matrix. | Human testers |
| GO-06 | First-time experience is unproven. | At least five independent target-player sessions, including uncoached keyboard/mouse and approved controller paths, with no repeated inability to understand or finish. | Test coordinator |
| GO-07 | Public languages are not approved. | Complete reachable-string externalization plus fluent review for every advertised language; otherwise advertise English only. | Publisher/reviewers |
| GO-08 | Store claims and media are not approved. | Demo-specific copy and at least five clean 1920×1080+ 16:9 gameplay screenshots, trailer/capsules as chosen, content survey, accessibility/controller flags, and human creative approval. | Publisher/creative owner |
| GO-09 | Legal and operational ownership is incomplete. | Approved developer/publisher identity, rights/credits, privacy/support/legal text, release window, support rota, rollback owner, and final go/no-go authority. | Publisher/legal/support |
| GO-10 | No storefront candidate has been uploaded or tested. | Store build ID, independently downloaded hash, install-to-demo-end critical path, page association, and final human approval of that exact build. | Authorized account owner |

No blocker above may be converted to “pass” from absence of evidence. Any
accepted high-severity exception requires a named human owner, rationale,
player workaround, affected build, and expiry/review point.

## Residual risks after blocker closure

- Unsigned Windows binaries may still trigger SmartScreen or reputation
  friction despite a zero-detection malware scan.
- Local deterministic captures do not establish physical-GPU frame pacing,
  unusual DPI behavior, long-session stability, or thermals.
- German and French currently have only partial keyed coverage; silently
  advertising them would misrepresent the product.
- Steam review, onboarding, association, and timing requirements are external
  state and can delay the intended window.
- A free demo can still generate support and privacy obligations even without
  analytics, accounts, or payment.

## Recommended next decision

Approve or revise the product brief. The engineering recommendation remains:

- Option A: The Muddy Road, either Bandit Bend or Courier Deadline, then
  Bonebridge Pass;
- Steam as the planning baseline;
- a free 25–40 minute first journey; and
- no automatic save transfer to the full game.

That approval authorizes implementation of the product boundary only. It does
not authorize upload, publication, spending, account actions, legal
attestations, public claims, or release.

## Final decision record

- Decision: [ ] GO  [ ] NO-GO
- Exact uploaded build ID and SHA-256:
- Accepted exceptions and named owners:
- Rollback package/build ID and operator:
- Support lead and launch-week coverage:
- Publisher name, signature/approval record, and UTC date:

Until every release blocker is closed or explicitly accepted by the authorized
human, this record remains **NO-GO**.
