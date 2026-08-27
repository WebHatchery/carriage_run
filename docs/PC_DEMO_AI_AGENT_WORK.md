# Carriage Run — AI-agent work for the first PC demo

> This file preserves the 2026-08-26 audit and work definition. Several findings
> have since been repaired or prepared. Use `PC_DEMO_AGENT_PROGRESS.md` for the
> reconciled current status and evidence; do not treat the historical blocker
> wording below as the live release decision.

Audit date: 2026-08-26  
Scope: a public **Windows PC demo**, not the full commercial release, and no
Linux, macOS, console, or browser release. Steam is the planning baseline;
itch.io is an optional alternative or secondary PC channel.

## Estimate verdict

**“Start 3–6 months before the demo” is a safe planning window, but it is not
an accurate estimate of the remaining engineering work in this repository.**

Carriage Run already has substantially more than a normal demo: 30 campaign
missions, an eight-leg expedition, Windows packaging, 110 test functions,
localization, controller/touch input, saves, accessibility settings, licensed
assets, release-size budgets, and deterministic screenshot tooling. The local
publisher currently succeeds and produces a roughly 10 MiB Windows ZIP.

The remaining work is release hardening, demo scoping, storefront material,
external playtesting, and launch operations. A realistic schedule is:

| Release standard | Calendar estimate | Why |
| --- | ---: | --- |
| Private Windows demo for known testers | 1–2 weeks | Fix the known blockers, define the demo slice, and run a short compatibility pass. |
| Public itch.io Windows demo | 2–4 weeks | Add page/configuration, independent playtesting, packaging QA, and launch support. |
| Polished public Steam Windows demo | 8–12 weeks | Store assets, onboarding/review lead time, diverse hardware testing, feedback iteration, and marketing preparation dominate. |
| Conservative part-time Steam plan | 3–6 months | Sensible if work is intermittent, the demo is used to build an audience, or feedback causes substantial art/UI/balance changes. |

Therefore, use **three months as the recommended target**, with six months as
contingency and audience-building runway. Do not spend six months adding more
content before testing the current game. The game is content-rich; its largest
unknown is whether new players understand and enjoy the first 20–40 minutes.

## Evidence from the repository

### Strong foundations already present

- `README.md` and `TODO.md` describe a complete 30-mission campaign plus an
  expedition mode and mark the original release backlog complete.
- The project has about 20,000 lines across 80 Rust files and 110 test
  functions. No Rust file exceeds the workspace's 800-line maximum, although
  `src/ui/gameplay_hud.rs` is close at 798 lines.
- `publish.ps1` completed successfully on 2026-08-26, building, packaging, and
  deploying both targets. The Windows archive contains one executable and four
  registered image assets.
- The packaged Windows ZIP is about 10 MiB, below the documented 16 MiB budget.
- The application has a Windows icon/version resource, crash logging, rolling
  save backups, recovery, multiple slots, input rebinding, controller support,
  three languages, and accessibility options.
- Thirty-six verification captures cover desktop, fullscreen, touch-sized, and
  authored UI states.

### Known blockers and risks

These findings make an immediate public release inadvisable even though local
packaging passes.

1. **Hosted CI is red.** The latest three GitHub Actions runs failed. The
   workflow checks out `macroquad-toolkit` inside the game repository while
   `Cargo.toml` expects it as the sibling path `../macroquad-toolkit`; both the
   Linux and Windows jobs consequently fail before completing their gates.
2. **The existing itch publisher is incomplete for this game.**
   `publish-itch.ps1` requires `itch.json`, but the file is absent. There is no
   recorded owner/project slug, channel configuration, or verified public build.
3. **There is no Steam release setup in the repository.** No app/depot
   configuration, Steam upload scripts, Steam App ID handling, demo build
   profile, store-asset set, or release record exists.
4. **The demo is not actually scoped.** The current Windows package appears to
   contain the full game. A public demo needs a deliberate stopping point,
   demo-specific messaging, and protection against accidentally shipping the
   whole campaign.
5. **Visual QA found a credible HUD defect.** The checked-in fullscreen gameplay
   capture shows the objective/status block colliding with the touch controls,
   and some control glyphs are hard to read. Startup diagnostic notifications
   also appear in promotional-looking captures. This needs hands-on validation,
   not just screenshot generation.
6. **Store screenshots are not ready.** The current fullscreen captures are
   1904×1022, while Steam asks for at least 1920×1080, 16:9 gameplay screenshots.
   Current captures also include diagnostic notifications.
7. **Licensing evidence needs correction.** `ASSET_LICENSES.md` calls all fonts
   original/no external files, while `assets/fonts/README.md` says the fonts are
   copies of the toolkit's Rajdhani SemiBold font. The generated dependency
   inventory also lists only two packages rather than the complete transitive
   Rust dependency set. Rights may be fine, but the record is internally
   inconsistent.
8. **Version/release identity is still prototype-level.** Cargo, embedded game
   data, and Windows resources say `0.1.0`; there is no changelog, release tag,
   build provenance file, supported-PC specification, or rollback record.
9. **External compatibility is unproven.** Existing captures demonstrate layout
   states, not installs on clean Windows machines, integrated/discrete GPUs,
   unusual DPI settings, antivirus/SmartScreen behavior, controller families,
   sleep/resume, or long-session save integrity.

## Work the AI agent can perform

The agent can own the following work end to end, stopping only at the human
approval gates listed in `PC_DEMO_HUMAN_REQUIRED_WORK.md`.

### 1. Freeze and define the demo product

- Draft a one-page demo brief: target player, promise, intended 20–40 minute
  session, included missions/systems, end condition, and excluded content.
- Propose two or three viable slices from the current campaign, with the
  recommended slice showcasing steering, guard commands, one upgrade choice,
  one meaningful route decision, and one memorable boss/hazard.
- Turn the approved slice into acceptance tests and a release checklist.
- Add a Cargo `demo` feature or equivalent explicit build mode. The normal build
  must remain full and the demo build must be impossible to confuse with it.
- Give demo saves a separate namespace/version, decide whether progress can
  transfer later, and test upgrades/migration if transfer is promised.
- Add a clear “End of Demo” screen with replay, wishlist/store, feedback, and
  exit actions appropriate to the selected storefront.
- Remove or clearly lock full-only menus/content without teasing unavailable
  features in a misleading way.

### 2. Repair release engineering

- Fix the CI toolkit checkout/path mismatch and make both hosted jobs green.
- Add a PC-demo build/package command that emits a uniquely named artifact such
  as `carriage_run_demo_windows_x86_64_<version>.zip`.
- Ensure the package contains only runtime files—no source, credentials, debug
  symbols, test saves, crash logs, or unrelated WebGL material.
- Add build metadata (version, commit, build date/channel) visible in a quiet
  credits/support panel and in logs, not as startup toast noise.
- Add checks that fail if a demo package exposes full-release content or uses
  the wrong save namespace.
- Generate checksums and a machine-readable release manifest.
- Exercise install/run from paths containing spaces and non-ASCII characters,
  and from a standard non-administrator account where available.
- Create a rollback procedure and retain the last known-good package.
- Keep every Rust file under 800 lines; split `gameplay_hud.rs` before any
  meaningful addition pushes it over the limit.

### 3. Fix release-facing game issues

- Reproduce and repair the fullscreen HUD overlap, then recapture desktop and
  fullscreen verification images.
- Audit all visible controls at 100%, 125%, 150%, and 200% Windows scaling and
  common 16:9, 16:10, ultrawide, and small-window layouts.
- Make diagnostics opt-in for release builds and keep player-facing errors
  actionable.
- Run a keyboard-only and controller-only path from launch through demo end,
  including pause, settings, failure, retry, and exit.
- Verify focus loss, audio mute/restore, fullscreen transitions, alt-tab,
  controller disconnect/reconnect, and clean shutdown.
- Test save creation, reload, corruption recovery, deletion, and demo-version
  migration against packaged builds.
- Review tutorial wording against actual visible PC controls and remove any
  browser/touch-specific prompt from the PC demo unless it remains relevant.
- Perform automated localization key, glyph, clipping, and overflow checks for
  English, German, and French, then create a human review packet.
- Run deterministic balance simulations for only the selected demo slice and
  report completion, failure, damage, reward, and session-length distributions.

### 4. Strengthen automated and manual QA support

- Run formatting, linting with warnings denied, all tests, release builds, the
  publisher, asset checks, and the code-size tests from a clean checkout.
- Add a release-candidate checklist that records exact commit, toolchain,
  toolkit pin, test results, package hash, and known issues.
- Build a manual test matrix and result form for external testers.
- Prepare scripted test saves that reach every demo state without requiring a
  tester to replay the opening repeatedly.
- Triage tester reports, deduplicate issues, rank severity/reproducibility, and
  implement approved fixes.
- Compare performance captures and tune obvious CPU/GPU/frame-pacing issues.
- Check the package with available malware scanners and record results; treat
  scanner reputation as evidence, not proof of safety.
- Produce a final known-issues list and player support troubleshooting guide.

### 5. Correct legal and policy documentation

- Generate a complete transitive dependency/license inventory from the locked
  build, including Macroquad and all shipped fonts/assets.
- Resolve the contradictory font provenance statements and bundle every
  required license notice in the downloadable package.
- Draft an asset provenance ledger covering source, creator/tool, date, edits,
  rights basis, and whether generative AI was used.
- Audit the binary/source for telemetry, network calls, personal-data handling,
  and third-party SDKs; draft a plain-language privacy statement reflecting the
  actual build.
- Draft EULA/support/refund-facing copy if the chosen storefront or business
  model needs it. A human/legal adviser must approve all legal representations.

### 6. Produce storefront and marketing materials

- Draft the short description, long description, feature bullets, system
  requirements, accessibility notes, language table, content description,
  support text, FAQ, and announcement copy.
- Capture at least five clean 1920×1080 or larger 16:9 gameplay screenshots
  from the actual demo build, with no debug/diagnostic overlays.
- Generate and iterate required capsule/library artwork from approved source art
  and current official templates; validate dimensions and legibility.
- Storyboard, capture, edit, caption, and export a short gameplay-first trailer,
  subject to human creative approval and music/asset rights confirmation.
- Create a press kit with logo, key art, screenshots, GIFs/video, description,
  contact details supplied by the human, and disclosure/provenance notes.
- Draft a launch announcement, tester invitation, feedback survey, social posts,
  creator pitch, patch notes, and first-week support responses.

### 7. Configure the chosen PC storefront after authorization

For Steam:

- Prepare SteamPipe depot/build scripts, a local redacted config template, and
  secret-handling instructions.
- Configure the demo as a separate App ID associated with the base game once the
  human supplies the App IDs and grants access.
- Upload candidate builds, verify branches, and document the live build IDs.
- Fill non-legal store fields and upload approved assets/copy through authorized
  tooling or browser control.
- Run the Steam client install/launch/uninstall/update path and verify the demo
  appears correctly on the base game's store page.

For itch.io, if selected:

- Add `itch.json` after the human provides the public `owner/game-slug`.
- Restrict the project wrapper to the Windows channel for this PC-only release.
- Stage and dry-run the exact Windows package, upload with Butler after explicit
  authorization, check processing status, and verify install/update via the
  itch app.
- Record project URL, stable channel, Butler build number, version, visibility,
  price/access model, and public-page verification.

### 8. Release-candidate and launch support

- Cut reproducible RC builds from a frozen commit and maintain a change log.
- Verify that only approved fixes enter the freeze branch.
- Prepare a go/no-go report with pass/fail evidence, residual risks, rollback
  steps, and a recommendation; the human makes the decision.
- After the human releases, independently download the public build, verify its
  hash/build ID, perform the critical path, and monitor technical feedback.
- Triage and prepare hotfixes. Upload or publish only within the authorization
  explicitly granted for that release.

## Recommended three-month execution plan

| Time before demo | Agent-owned outcome | Human gate |
| --- | --- | --- |
| 12–10 weeks | Demo brief options, CI repair, demo build separation, licensing audit | Choose storefront, demo slice, audience, date, and legal publisher. |
| 10–8 weeks | First demo build, end screen, save isolation, layout fixes | Play and approve the creative/product direction. |
| 8–6 weeks | Store copy/assets, clean screenshots, trailer draft, QA matrix | Approve public claims, artwork, trailer, ratings/content answers. |
| 6–4 weeks | Closed external test builds, issue triage, compatibility fixes | Recruit testers and personally assess feel/accessibility. |
| 4–2 weeks | Near-final RC, store/depot configuration, review submissions | Complete onboarding, pay/sign, submit truthful forms, approve review submission. |
| 2–1 weeks | Review feedback fixes, final regression, launch/support material | Final creative, legal, date, and go/no-go approval. |
| Launch week | Upload verification, public-build smoke test, issue monitoring | Press the release control and own public communications/account actions. |

## Release gate the agent should enforce

The agent should recommend **no-go** until all of these are true:

- the demo boundary and target storefront are written and human-approved;
- local validation and hosted CI are green on the exact release commit;
- the packaged build passes a clean-machine install and critical-path test;
- no open blocker/critical defects remain, and high-severity exceptions are
  explicitly accepted by the human;
- at least five independent target-player playtests have been completed, with
  no repeated inability to understand or finish the demo;
- store media is captured from the real demo build and accurately represents it;
- license/provenance and privacy records match the shipped files;
- the newest uploaded storefront build—not a local or cached build—passes;
- support, rollback, backups, and first-week availability are assigned; and
- the human has approved the final build, representations, date, and release.

## Current official platform constraints used in this plan

- Steam onboarding requires legal identity, bank and tax information, agreement
  signatures, and a USD 100 product fee. Tax verification can take 2–7 business
  days: <https://partner.steamgames.com/doc/gettingstarted/onboarding>
- A first Steam product has a 30-day wait after paying the fee, and the base
  game's Coming Soon page must be public for at least two weeks:
  <https://partner.steamgames.com/steamdirect/>
- Valve asks for at least seven business days of review allowance for store
  presence and for a near-final build:
  <https://partner.steamgames.com/doc/store/review_process>
- A Steam demo is a separate App ID/build with its own release checklist and
  must be associated with the base game:
  <https://partner.steamgames.com/doc/store/application/demos>
- Current Steam asset requirements include at least five real gameplay
  screenshots at 1920×1080 or larger, 16:9, plus multiple required store and
  library images: <https://partner.steamgames.com/doc/store/assets>
- itch.io recommends Butler for versioned platform uploads and updates:
  <https://itch.io/docs/itch/integrating/quickstart.html>
