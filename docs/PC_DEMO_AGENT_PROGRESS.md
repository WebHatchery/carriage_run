# Carriage Run PC demo agent progress

Reconciled: 2026-08-27  
Scope: current repository evidence against `PC_DEMO_AI_AGENT_WORK.md`

Status meanings:

- **Complete locally** — implementation and proportionate local evidence exist.
- **Prepared / gated** — the agent-owned draft or tooling exists, but truthful
  completion depends on an approval, exact demo candidate, or external result.
- **External / human** — cannot be established from this repository or host.
- **Not started** — required work has no adequate current evidence.

The release recommendation remains **NO-GO**. The current artifact is still a
`full`-channel package, not a contained public demo.

## 1. Demo product

| Requirement | Status | Evidence / next gate |
| --- | --- | --- |
| One-page brief and viable slices | Prepared / gated | `PC_DEMO_PRODUCT_BRIEF.md` recommends Option A and contains the approval block. |
| Storefront, audience, promise, length, slice, ending, transfer policy | External / human | Publisher approval is absent. |
| Explicit demo build, isolated identity/save, containment tests | Not started | Implementation must follow the approved product decision. |
| End-of-demo replay/store/feedback/exit screen | Not started | Destinations and boundary are unapproved. |
| Full-only menu/content treatment | Not started | Depends on the approved contained slice. |

## 2. Release engineering

| Requirement | Status | Evidence / next gate |
| --- | --- | --- |
| Correct hosted toolkit layout and exact pin | Complete locally | Workflow uses the sibling layout and `toolkit.lock`; local native/WebAssembly gates pass. Hosted runs remain unobserved until pushed. |
| Full-channel Windows/WebGL publisher | Complete locally | `publish.ps1` produces provenance-labelled packages and local preview deployment. |
| Demo-specific artifact name and containment | Not started | Requires the approved demo boundary. |
| Runtime-only package, manifest, checksum, provenance | Complete locally | Package validator and manifest scripts cover the current full channel. |
| Absolute build-path removal | Complete locally | `scripts/audit_release_paths.ps1`. |
| Space/non-ASCII and non-elevated launch smoke | Complete locally | `scripts/smoke_windows_package.ps1`. |
| Rollback and last-known-good procedure | Prepared / gated | `PC_DEMO_ROLLBACK_PROCEDURE.md`; exact store build IDs/owners remain absent. |

## 3. Release-facing game behavior

| Requirement | Status | Evidence / next gate |
| --- | --- | --- |
| Fullscreen HUD and release diagnostics | Complete locally | Exact 1920×1080 captures and `PC_DEMO_VISUAL_CAPTURE_EVIDENCE.md`. |
| 16:9, 16:10, wide, and small-window layouts | Complete locally | Eight-scene `PC_DEMO_WINDOW_LAYOUT_AUDIT.md`. |
| Windows 100/125/150/200% DPI and multi-monitor behavior | External / human | Physical Windows matrix required. |
| Keyboard/controller complete paths and reconnect | Prepared / gated | Native polling/lifecycle logic and tests exist; named real hardware paths remain untested. |
| Focus, audio, Alt-Tab, fullscreen transitions, shutdown | Prepared / gated | Deterministic lifecycle tests and manual packet exist; physical packaged-session evidence remains required. |
| Save lifecycle and corruption recovery | Prepared / gated | Unit coverage, backups, recovery UI, and fixtures exist; exact contained-demo migration/package path awaits the demo build. |
| PC-visible tutorial wording | Complete locally | `PC_DEMO_CONTROL_INSTRUCTION_AUDIT.md` and PC-neutral road controls. |
| Localization automation and fluent review | Prepared / gated | Key/glyph/overflow automation and review packet exist; public claim remains English-only until fluent review. |
| Selected-slice balance/session distribution | Not started | The slice and length target require approval; full-game simulation is not a substitute. |

## 4. QA and evidence support

| Requirement | Status | Evidence / next gate |
| --- | --- | --- |
| Format, warnings-denied lint, tests, build, publisher, file-size gates | Complete locally | Repeated clean local validation passes; hosted CI still needs a pushed green run. |
| RC checklist and exact evidence fields | Prepared / gated | `PC_DEMO_RELEASE_CANDIDATE_CHECKLIST.md`; no demo RC exists. |
| External tester packet and scripted saves | Prepared / gated | `PC_DEMO_PLAYTEST_PACKET.md`, five Option A fixtures, and safe installer. Fixtures are contingent on Option A. |
| Report validation, explicit deduplication, ranking | Complete locally | Template, `scripts/triage_playtest_reports.ps1`, synthetic verifier, and Windows CI step. No real reports exist. |
| CPU and short-run process-memory regression baseline | Complete locally | `PC_DEMO_PERFORMANCE_CAPTURE.md`; excludes GPU/frame pacing, heap, leaks, thermals, and minimum-PC claims. |
| Malware scan evidence | Complete locally | Exact-package Defender script and `PC_DEMO_MALWARE_SCAN_EVIDENCE.md`; SmartScreen reputation remains external. |
| Known issues and support guide | Prepared / gated | Drafts exist; exact uploaded candidate and staffed public contact are absent. |

## 5. Legal and policy records

| Requirement | Status | Evidence / next gate |
| --- | --- | --- |
| Locked transitive dependency/license inventory | Complete locally | `THIRD_PARTY_LICENSES.md` and generator. |
| Font and asset provenance | Complete locally | Corrected license records and `ASSET_PROVENANCE.md`. |
| Telemetry/network/privacy audit | Complete locally | Current build is local-only; audit and plain-language draft exist. |
| Final rights, credits, privacy, EULA/refund representations | External / human | Publisher/legal approval and identity are absent. |

## 6. Storefront and marketing

| Requirement | Status | Evidence / next gate |
| --- | --- | --- |
| Store copy, FAQ, language/accessibility/content boundaries | Prepared / gated | Steam-focused `PC_DEMO_STOREFRONT_COPY_DRAFT.md`; claims remain contingent. |
| Five exact-demo 1920×1080 screenshots | Not started | Full-game engineering captures cannot become demo media before containment. |
| Current Steam dimensions and export audit | Complete locally | Dated spec, `PC_DEMO_STEAM_ASSET_PLAN.md`, audit, and synthetic CI verifier. |
| Approved capsule/library artwork | Not started | Requires approved source art, title treatment, current templates, and creative review. |
| Gameplay trailer | Prepared / gated | `PC_DEMO_TRAILER_STORYBOARD_DRAFT.md`; no approved demo footage/music/export exists. |
| Press kit | Not started | Approved logo, key art, demo screenshots/video, contact identity, and destination are absent. |
| Launch/tester/survey/social/creator/patch/support copy | Prepared / gated | `PC_DEMO_COMMUNICATIONS_DRAFT.md`; all public fields remain gated. |

## 7. Store configuration

| Requirement | Status | Evidence / next gate |
| --- | --- | --- |
| Steam App IDs, depot config, upload, branch/build verification | Not started | Storefront selection, account access, base/demo IDs, and upload authorization are absent. |
| itch project/channel/upload path | Not started | No approved itch choice or `owner/game-slug`. |

## 8. Release candidate and launch

| Requirement | Status | Evidence / next gate |
| --- | --- | --- |
| Frozen reproducible demo RC and change log | Not started | No demo build exists. |
| Go/no-go report and rollback recommendation | Prepared / gated | `PC_DEMO_GO_NO_GO_DRAFT.md` correctly recommends NO-GO on a historical full-channel baseline. |
| Uploaded/public build verification | Not started | Requires authorized store configuration and release candidate. |
| Launch monitoring and hotfix operation | Prepared / gated | Procedures and response drafts exist; owners, accounts, schedule, and public build are absent. |

## Next executable decision

The highest-leverage next implementation is the contained demo mode. It must not
begin until the publisher approves or amends the product brief's storefront,
Option A slice, 25–40 minute target, and no-transfer policy. Once approved, the
agent can implement the demo feature/build identity, save namespace, mission
containment, end screen, package tests, selected-slice simulations, and exact
demo media capture in that order.
