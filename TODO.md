# TODO — Carriage Run (release backlog complete)

All release-backlog items below are implemented and verified by the project
publisher, automated tests, release checks, and browser viewport captures.
The standards follow-ups at the end are maintainability work identified during
the September 2026 guidance review.

## Campaign depth

- [x] Add a cosmetic progression system: livery and guard-color unlocks, gold
  purchases, save data, and previews using the existing sprite pipeline.
- [x] Replace the prisoner's passive security meter with periodic breakout
  attempts, including escape state, counterplay, failure/recovery feedback, and tests.
- [x] Add 3-star specialization branches for Swordsman and Mage, including data,
  purchase flow, combat effects, roster text, save migration, and tests.
- [x] Add a reusable multi-phase boss state machine with telegraphs, phase changes,
  damage handling, and victory/failure hooks.
- [x] Add three to four standard enemy types with data, behavior, sprites, codex
  entries, and balance coverage.
- [x] Author one campaign finale boss and one expedition finale boss using the boss
  framework.

## Campaign content

- [x] Add act and biome metadata to mission data and show the current journey,
  act, and biome on the route map.
- [x] Add six Act II missions with a distinct enemy mix, hazard mix, route choices,
  rewards, and unlock graph.
- [x] Add six Act III missions with a distinct enemy mix, hazard mix, route choices,
  rewards, and unlock graph.
- [x] Add up to six optional side missions after the core acts are complete, taking
  the campaign from 24 to the 30-mission content target.
- [x] Implement a rockslide hazard, including collision rules, rendering, codex
  text, mission placement, and tests.
- [x] Implement a cursed-fog hazard, including gameplay effect, rendering, codex
  text, mission placement, and tests.
- [x] Implement a night-stretch hazard, including gameplay effect, rendering,
  codex text, mission placement, and tests.
- [x] Populate each act with at least two of the authored hazards and validate that
  every biome has a distinct hazard palette.
- [x] Add a designed campaign ending screen connected to the final mission report.
- [x] Add a stylized region/act map background and connect it to the authored map
  metadata.
- [x] Add guard hire quotes, combat barks, and per-class roster flavor text.

## Art and game feel

- [x] Add carriage damage-state sprites and select the correct state from current
  hull health.
- [x] Add frame-based guard and enemy animation playback with idle, attack, hit,
  and defeat states.
- [x] Add biome-specific tile and prop art for the new acts and wire it into the
  route renderer.
- [x] Replace remaining procedural/provisional UI symbols with a consistent icon
  set and add any missing screen art.
- [x] Add screen shake and hit-stop driven by carriage, guard, hazard, and boss
  impacts.
- [x] Add event-specific particle effects for mud, embers, arrows, summons, and
  boss attacks using the toolkit particle system.
- [x] Add shared easing helpers and use them for menu transitions and wave-spawn
  telegraph effects.
- [x] Animate carriage bob, wheel rotation, and horse movement during routes.

## Audio integration

- [x] Integrate the toolkit `SoundManager` into `Game`, with event-driven combat/UI
  hooks, per-screen music state, and pause ducking.
- [x] Add SFX, music, and master volume sliders to Settings and mute audio when the
  web page loses focus.

## Onboarding and UX

- [x] Add a first-campaign guided mission with explicit visible controls for
  steering, wave telegraphs, drag orders, Roam, ranged mounting, brake, and boost.
- [x] Integrate the toolkit `HoverTooltip` and add tooltip content for shop items,
  upgrades, equipment, guard cards, meters, and HUD controls.
- [x] Add confirmation before chassis purchases and before abandoning an active
  expedition; keep banking an expedition as a separate safe action.
- [x] Expand the results screen with explanations for stars, bonuses, penalties,
  and the final reward calculation.
- [x] Add an early-campaign shop nudge that recommends a useful next purchase.
- [x] Add menu transition effects and audit every button's hover, disabled, and
  pressed states.
- [x] Add controller focus states and a credits screen.
- [x] Add an in-mission threat indicator and off-screen enemy direction pips.
- [x] Improve guard stance-ring legibility in the mission HUD.

## Settings, accessibility, and input

- [x] Add fullscreen, resolution, vsync/FPS-cap, and UI-scale settings using the
  toolkit's text-scaling support.
- [x] Add a colorblind-safe palette, independent text-size control, reduced-motion
  behavior, and hold-vs-toggle preferences for drag interactions.
- [x] Integrate the toolkit `GamepadInput` with semantic menu/gameplay actions,
  including a non-mouse scheme for drag orders and native/Deck coverage.
- [x] Add key rebinding for gameplay and save/load actions instead of hardcoded
  key literals.
- [x] Add touch/pointer controls for steering, brake, boost, repair, and every
  tutorial/recovery action advertised by the web page.

## Localization infrastructure

- [x] Externalize source literals and data text into a keyed localization table,
  with a fallback language and missing-key diagnostics.
- [x] Add per-language font fallbacks and layout/overflow checks for longer German
  and French strings.

## Technical robustness

- [x] Add rolling save backups and quarantine/recovery behavior when the primary
  save is corrupt.
- [x] Store real save timestamps instead of `"Unknown"`.
- [x] Add multiple save slots with create, rename, delete, and active-slot UI.
- [x] Replace per-action autosave writes with the toolkit `AutoSaveManager` timer.
- [x] Add save/load round-trip and corruption-path tests, then extend compatibility
  fixtures for every supported save version.
- [x] Replace startup data-load hard panics with a user-facing recovery screen;
  retain the existing native crash-log hook for unrecoverable panics.
- [x] Measure native and WebGL release sizes and enforce a documented WASM budget;
  compress the title image and atlas assets where quality permits.
- [x] Make the `macroquad-toolkit` dependency reproducible and keep its version in
  one source of truth across `Cargo.toml`, game configuration, tags, and builds.
- [x] Repair the CI workflow's project paths and add formatting, lint, test,
  Windows, WebGL, and publisher checks for the repository layout.

## Packaging and release QA

- [x] Add an application icon and Windows version resource to the native build.
- [x] Generate a third-party dependency and asset license inventory from the
  current repository contents.
- [x] Add automated browser viewport smoke captures for supported desktop,
  touch-sized, and fullscreen layouts.

## Standards follow-ups

- [ ] Split the seven Rust files already in the 650–784 line range —
  `src/state.rs`, `src/ui.rs`, `src/ui/gameplay_hud.rs`,
  `src/ui/management.rs`, `src/ui/mission_map.rs`,
  `src/ui/mission_map_art.rs`, and `src/ui/upgrade_visuals.rs` — along
  cohesive responsibilities before adding more screen features; keep the
  resulting modules near the 200–400 line target and below the 600-line
  planning threshold.
- [ ] Refactor functions that exceed the 100-line maximum, starting with
  `Game::new`, `Game::begin_capture_scene`, `draw_title`, `draw_codex`,
  `draw_hub`, `draw_roster_guard_card`, `draw_runtime_preferences`, and
  `CampaignState::normalize`.
- [ ] Migrate every test and test helper out of `src/**/tests.rs` and inline
  `#[cfg(test)]` modules into the crate-level `tests/` directory; add
  `src/lib.rs` as the public test seam and have `main.rs` use the library.
  Preserve useful coverage while consolidating suites toward five cases per
  major feature, and update the stale source-gate comment that still says
  tests are excluded from the 800-line count.
- [ ] Move the remaining authored gameplay data out of Rust match tables into
  typed JSON registries loaded through the toolkit, including guard and enemy
  stats, unlock and cost tables, hazard dimensions/effects, boss definitions,
  and their project-owned semantic validation.
- [ ] Complete localization of player-facing literals that remain in Rust:
  screen labels, buttons, tooltips, tutorials, codex entries, guard/enemy/
  hazard descriptions, status text, and notifications. Add the keys to the
  existing English, German, and French tables and keep dynamic formatting in
  code around localized templates.
- [ ] Resolve the unused `assets/data/actions.json` template asset by either
  wiring it through a typed loader and validation or removing it; audit every
  shipped data JSON file so it has one intentional runtime or verification
  consumer.
- [ ] Audit keyboard and controller shortcut copy against the touch-first
  rule. Replace text such as `CONTROLLER A: confirm B: back X: guard stance`
  with wording that also names the visible tap/click control or gesture, and
  add coverage for shortcut notices and recovery/tutorial prompts.
- [ ] Make the CI-mandated `cargo test --all-features` path pass as well as the
  default suite: keep full-campaign fixtures independent from the demo-only
  mission registry and refresh the balance and progression assertions that
  currently fail under the `demo` feature.
