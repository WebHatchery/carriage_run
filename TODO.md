# TODO — Carriage Run

The checked release-backlog items below preserve the project's completion
history; they are not a new verification claim. Open standards follow-ups and
the UI_STYLE review record work identified during the September 2026 review.

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
- Touch-first shortcut-copy follow-up is consolidated into UI-07 below,
  including controller notices and recovery/tutorial instructions.
- [ ] Make the CI-mandated `cargo test --all-features` path pass as well as the
  default suite: keep full-campaign fixtures independent from the demo-only
  mission registry and refresh the balance and progression assertions that
  currently fail under the `demo` feature.

## UI_STYLE review — 2026-09-20

### Evidence, scope, and implementation order

This is an audit, not implementation or a fresh gameplay test. Reviewed
`AGENTS.md`, `UI_STYLE.md`, `CODE_STANDARDS.md`, `GAME_DEVELOPMENT_GUIDE.md`,
`README.md`, and `docs/PC_DEMO_PRODUCT_BRIEF.md`. No project GDD or
`PROJECT_AGENTS.md` was found. Inspected the screen dispatcher, navigation,
mission input, world camera, HUD, planning screens, and capture setup.

Visually inspected existing `docs/verification/` images:
`smoke_desktop_{title,gameplay,map,loadout,upgrades,guards,settings}.png`,
`smoke_touch_gameplay.png`, `demo_bonebridge_gameplay.png`, and
`ui_{princess,journey,outfitter,results}.png`. Desktop smoke images are
1264x681; the touch gameplay image is 944x501; the demo combat image is
1920x1080; the four older `ui_` images are 1280x720. These are historical
captures, not proof of current rendering or exercised touch interactions.
For example, old images show startup diagnostics that current release code
already suppresses; do not reintroduce a task for that resolved behavior.

`scripts/browser_smoke.ps1` requests 1280x720, 960x540, and 1920x1080 through
the native capture harness. Its name and the checked historical browser task
do not establish WebGL or touch verification. The README has no declared
minimum canvas size; the 800x600 case in the window audit is explicitly stress
evidence. No game run, fresh capture, publish, or live browser/touch test was
performed for this documentation-only pass.

Implement UI-01's screen briefs first, then the progression/recovery blockers
UI-02 and UI-03, followed by combat composition and shared layout work. Apply
UI-05's target sizing throughout the remaining screen tasks. Preserve existing
completed functionality and the standards follow-ups above; split large modules
before expanding them, use toolkit layout/input facilities, and return UI intents
to the existing dispatcher. The game already has bespoke road art, title art,
mission and expedition flows: no wholesale template replacement is justified.
Repeated framed facts and permanent help still need the subtraction pass in
UI_STYLE sections 3–5 and 8.

### Confirmed findings — code and/or existing captures

- [ ] **UI-01 — Define the screen decisions and supported canvas sizes.**
  **Scope:** `README.md`; screen flow in `src/ui.rs`,
  `src/game/action_navigation.rs`, and `src/state/session.rs`.
  **Problem:** The README describes features but lacks the seven-part screen
  briefs and viewport contract required by UI_STYLE sections 1 and 7. Its
  statement that the backlog is complete also conceals open review work.
  **Change:** Record decision, focus, primary action with constraints,
  supporting/deferred information, layout/camera, and touch feedback for road
  play, route selection, loadout, purchases/roster, expedition phases, results,
  and utility/recovery screens. Specify 1280x720 as the normal logical baseline
  and validate a proposed 960x540 drawable minimum before promising it; distinguish
  actual canvas size from native outer-window size. Link the open review backlog.
  **Acceptance:** Each phase has one explicit purpose and a 2–3-region attention
  plan, with utilities separate from gameplay decisions and a documented minimum.
  **Verify:** Walk title → route → loadout → play → pause → results → route,
  and the full-build expedition branch. Use those paths to drive UI-11's visual
  and interaction matrix, including embedded browser sizing.

- [ ] **UI-02 — Keep the full campaign route collection reachable.**
  **Scope:** `src/ui/mission_map.rs::draw_mission_map`, `selected_route_layout`,
  `draw_selected_route`, `draw_route_choices`, and `compact_mix`.
  **Problem (code):** Every unlocked/near-unlock mission is placed in an
  unbounded four-column grid at y=124 + row*106. Row four begins at y=442,
  under the selected-route panel starting at y=452; later rows leave the
  canvas. No scrolling/paging contains this 30-mission collection. Existing
  early-game captures only show seven cards and do not verify the dense case.
  **Change:** Use an act-filtered, bounded scrollable or paged route region
  with visible tap navigation and selection retention. Give the selected route
  one coherent comparison area; remove repeated type/availability framing and
  redundant hazard entries when they carry no distinct meaning. Replace inert
  truncated threat/hazard summaries with a visible expandable detail control.
  Keep reward, route costs, deadline, bonus conditions, and unlock reasons readable.
  **Acceptance:** Every unlocked mission can be selected and prepared without
  an obscured card receiving input. Selected-route choices and Prepare Loadout
  are clear; secondary badges do not rival them.
  **Verify:** At normal/minimum canvas sizes, exercise new-campaign, 13+ visible
  missions, and all-30-unlocked states; tap paging/scroll, select the last route,
  inspect all threats, switch route choice, and prepare that exact mission.

- [ ] **UI-03 — Separate expedition continuation, banking, and abandonment.**
  **Scope:** `src/ui/journey.rs::draw_hub`, `draw_stat_line`,
  `src/game/action_expedition.rs`, and existing abandonment confirmation.
  **Problem (code):** With three pending legs, Repair occupies y=614–654,
  Bank y=660–700, and Abandon y=652–684 at the same x range. Bank and Abandon
  therefore overlap visually and share release hit areas. The historical
  `ui_journey.png` predates the displayed Abandon control and is not visual
  verification of this collision. Long relic names also share one fixed line.
  **Change:** Allocate a dominant road-choice area and compact health/gold
  support area; reserve non-overlapping space for repair and the safe banking
  decision. Put Abandon in a visibly separate utility area with its existing
  confirmation. Move the full relic list to tap-open details and last-leg reward
  prose to a compact recap/disclosure; retain current banked gold and carry-over
  damage, route risks/rewards, repair price, and affordability beside decisions.
  **Acceptance:** One tap yields one intended action. Banking cannot also request
  abandonment; both remain discoverable. Three roads fit without shrinking
  their consequences into unreadable text.
  **Verify:** Normal/minimum canvases with three roads, many relics, daily seed,
  low health, insufficient repair gold, and final leg. Tap repair, bank, cancel
  abandonment, and confirm abandonment separately using disposable test saves.

- [ ] **UI-04 — Recompose the combat HUD around the road and essential state.**
  **Scope:** `src/ui/gameplay_hud.rs::{draw_top_hud,draw_bottom_hud,
  draw_speed_gauge,draw_command_panel,draw_mission_panel}` and
  `src/ui/gameplay_feedback.rs::{draw_boss_and_breakout,draw_touch_controls}`.
  **Problem (captures + code):** Framed meters, a full bottom deck, speed box,
  bright separated controls, generic delivery prose, and repeated objective
  labels compete with road actors. Only two guards get detailed bottom cards.
  Repair and Pause share one action group. Special cargo state uses x=912–994,
  y=26–76, then the timer draws over x=912–1016, y=26–76, concealing that state.
  Boss and wave banners both occupy y=150–192; generic alerts can repeat the
  wave message (visible in the older princess capture).
  **Change:** Establish the road as dominant, a compact essential-state strip,
  and a coherent driving/guard control area. Remove the permanent compass/help
  panel, ordinary kill count, and repeated objective headings; show detailed
  guard status on selection with a discoverable roster view for all guards.
  Integrate speed state near driving controls and Repair near hull status,
  with an unavailable/used reason. Isolate a quiet Pause control. Reserve
  distinct space for timed objectives and special cargo. Use one prioritized
  temporary-event area; keep boss health and actionable security state persistent
  while relevant, without duplicating event text.
  **Acceptance:** Normal combat has at most three strongly emphasized regions;
  players can find carriage, guards, hazards, steering, brake, boost, and repair
  immediately. Critical mission state and warnings remain legible simultaneously.
  **Verify:** Normal/minimum canvases, calm and dense combat, more than two guards,
  low hull/cargo, courier deadline, princess/medicine/prisoner states, and boss
  plus wave warning when naturally co-occurring. Check feedback after it expires,
  reduced motion, and repair → pause → resume using touch alone. Coordinate
  road framing with UI-10 instead of blindly increasing zoom.

- [ ] **UI-05 — Reflow controls at small sizes and isolate shared utilities.**
  **Scope:** `src/ui.rs`, `src/ui/widgets.rs::{draw_top_nav,virtual_button}`,
  `src/ui/upgrade_visuals.rs`, `src/ui/loadout.rs`, `src/ui/upgrades.rs`,
  `src/ui/management.rs`, `src/ui/settings_aux.rs`, and `src/game/input.rs`.
  **Problem (code + captures):** A fixed 1280x720 layout scales all controls
  down together. Slot assignment is 28x26 logical pixels, Clear is 52x24, and
  equipment removal is 20x20, already too small for dependable finger use and
  smaller still in the touch capture. Shared navigation combines large Settings
  tiles with tiny Save/Load/Title controls and repeats gold labels; Settings
  retains irrelevant gold/rank and compresses display/audio/input preferences.
  **Change:** Add shared layouts that reflow/collapse secondary content before
  shrinking text. Use a minimum 44x44 CSS-pixel effective touch target as this
  implementation's acceptance target, with spacing and readable text at the
  declared minimum. Move Save/Load/Title/Settings into a separate visible utility
  entry; keep preparation destinations together. In Settings, use readable
  category views with save recovery and Return/Resume always reachable. Replace
  label/value/Toggle boxes with one understandable control where practical.
  **Acceptance:** Touch can assign/clear guards, equip/remove gear, change
  settings, and recover saves without precise aiming. Gameplay actions and
  utilities never appear as one button group; primary actions stay in reach.
  **Verify:** Normal/minimum actual canvases, 1920x1080, browser embedding,
  resize, and enlarged text in English/German/French. Measure post-scaling
  hit areas and test adjacent controls, dismissal, and save recovery by touch.

- [ ] **UI-06 — Make loadout a readable preparation decision.**
  **Scope:** `src/ui/loadout.rs::{draw_loadout,draw_mission_summary,
  draw_slot_row,draw_pool,compact_mix}` and `src/ui/widgets.rs::draw_mix_list`.
  **Problem (capture + code):** The Siege Supply Run title collides with its
  objective in `smoke_desktop_loadout.png`; threat lists spill below the short
  brief. Large empty space contrasts with dense prose, tiny numbered assignment
  buttons, and competing Back/Expedition/Start controls. A disabled Start has
  no adjacent unlock explanation. `compact_mix` hides names behind inert
  "N more" text, preventing full inspection here.
  **Change:** Make selected guard slots and the carriage the dominant preparation
  area. Give title/objective distinct bounds, retain a short mission requirement
  summary, and reveal narrative and complete threats/hazards on tap. Put one
  prominent Start Route action beside deadline/consumable warnings and any
  unmet prerequisite. Move Expedition to a distinct mode choice outside this
  campaign-start group and Back to quiet navigation. Use UI-05's assignment
  targets with meaningful labels rather than unexplained tiny numbers.
  **Acceptance:** Players know whom they assigned, what the route requires,
  and why they can or cannot start; available space supports this comparison.
  **Verify:** Normal/minimum canvases; Siege Supply Run, long localized names,
  full melee/ranged roster, recovering guards, all slots, and locked mission.
  Tap inspect, assign, clear, return, and start; confirm selected loadout persists.

- [ ] **UI-07 — Teach through completed actions and provide tap-accessible help.**
  **Scope:** `src/ui/gameplay_feedback.rs::draw_guided_first_route`,
  `src/ui/widgets.rs::hover_tooltip`, `src/ui.rs::draw_game_ui`,
  `src/ui/management.rs::draw_pause`, and session/tutorial state.
  **Problem (code):** The first-road lesson changes every 3.2 seconds and
  repeats on every muddy-road run for 24 seconds, regardless of successful
  actions. It has no skip/reopen control. Shared detailed help only calls
  `HoverTooltip::hover`; no explicit tap-open/dismiss inspection path is
  supplied. The persistent controller notice names shortcuts without matching
  visible controls. Historical completed onboarding tasks do not resolve this.
  **Change:** Track meaningful lesson completion, show only the relevant next
  prompt, and add visible Next/Skip/Help controls with replay from pause/help.
  Supply explicit tap-open detail and Close affordances for guard abilities,
  upgrades, equipment, and meter explanations without purchasing or issuing an
  order. Merge the former shortcut-copy follow-up here: name the exact visible
  control/gesture alongside keyboard/controller alternatives, including recovery.
  **Acceptance:** Learners control pacing; completed instructions disappear;
  repeat runs remain quiet; essential explanations are available without hover.
  **Verify:** Fresh/repeat campaigns and skipped/reopened tutorial at both sizes;
  finish steering, drag, stance, mount, brake, and boost lessons touch-only.
  Open/dismiss item help and confirm no unintended purchase or guard command.

- [ ] **UI-08 — Replace purchase-card density with useful comparisons.**
  **Scope:** `src/ui/upgrades.rs::{draw_available_upgrades,draw_upgrade_card,
  draw_loadout_and_owned,draw_footer}`, `src/ui/management.rs::{draw_shop,
  draw_guards,draw_roster_guard_card}`, and shared visual helpers.
  **Problem (captures + code):** Eight equally emphasized narrow upgrade cards
  show small description text over the Buy area. Guard stats repeat in the
  selected banner and roster cards. Owned/equipped upgrades repeat the purchase
  display; the footer adds permanent promotional prose. Numerous gold borders,
  icon rings, headings, and badges flatten the hierarchy.
  **Change:** Use a readable bounded comparison list/grid plus one selected
  item's details and purchase/equip action; retain current level, next effect,
  price, available gold, and slot constraints beside that action. Summarize
  nonselected guards by role/readiness and disclose advanced stats and
  specializations on selection or when available. Consolidate owned/equipped
  status, remove the promotional footer and redundant frames, and use the
  separate utility area from UI-05. Preserve relevant locked-item prerequisites.
  **Acceptance:** Players can compare an affordable improvement with their
  current setup without reading tiny text or mistaking ownership for equipment.
  **Verify:** Both sizes, early/late roster, full slots, maxed upgrades,
  insufficient gold, recovering guards, and long translations. Touch-select,
  inspect, buy, equip, remove, and treat; resulting state remains clear after
  purchase feedback fades. Do not invent an undiscovered-system gate absent
  from existing progression rules.

- [ ] **UI-09 — Make results prioritize the outcome and next decision.**
  **Scope:** `src/ui/results.rs::draw_results` and results navigation actions.
  **Problem (historical capture + current code):** Outcome, rewards, condition,
  threat counts, time, and flavor text receive similar weight; Map, Retry, and
  Upgrades share a row, with Upgrades always using Positive emphasis regardless
  of outcome. This weakens both the success continuation and failure recovery.
  **Change:** Lead with success/failure, reason, earned reward and important
  damage/recovery consequences. Make the next-route action prominent after
  success and retry prominent after failure, with preparation available when
  needed. Separate navigation from retry; disclose scoring arithmetic, encounter
  totals, and optional flavor under a visible report control.
  **Acceptance:** The player understands the result and next action immediately;
  star/bonus/reward explanations remain retrievable rather than being removed.
  **Verify:** Success, cargo/hull failure, timeout, and bonus met/missed at both
  sizes. Touch-expand the report, retry, visit upgrades, and return to the map;
  preserve the existing demo-end transition.

### Further inspection required — do not treat these as verified visual defects

- [ ] **UI-10 — Verify world framing and input alignment before adjusting zoom.**
  **Scope:** `src/ui/gameplay.rs::draw_gameplay`, `src/ui/gameplay_road.rs`,
  `src/ui/gameplay_feedback.rs::draw_offscreen_threat_pips`,
  `src/state/entities.rs`, `src/game/input.rs::capture_mission_input`, and
  toolkit virtual viewport helpers.
  **Evidence/question:** The world installs a full-display `Camera2D` with no
  explicit viewport, then restores the letterboxed UI; input uses virtual
  pointer coordinates. The play band is y=96–596; controls occupy y=520–584.
  Threat pips use fixed x=250/1030 boundaries and always upward triangles.
  Historical captures establish the layout, not whether aspect changes, shake,
  edge enemies, or target occlusion make picking/framing misleading in play.
  **Action:** Reproduce at 1280x720, the declared minimum, 1280x800 and 1920x800
  actual canvases, including embedded WebGL and display scaling. Compare world,
  HUD, pointer and letterbox transforms during drag/mount and shake. If they
  diverge, share toolkit viewport conversion and a safe visible play rectangle.
  After UI-04 frees space, tune actor scale/look-ahead only from dense combat
  evidence; derive threat indicators from actual visible bounds and direction
  if the fixed thresholds mislead. Record a pass if a suspected defect is absent.
  **Acceptance/verify:** Touch selects the visible guard/carriage after resize;
  hazards and incoming threats remain perceivable at useful scale, without HUD
  occlusion or sacrificing warning time. Capture calm/dense/boss states and
  exercise edge dragging, ranged mounting, pause/resume, and reduced motion.

- [ ] **UI-11 — Close the current-build visual and touch evidence gaps.**
  **Scope:** `src/game/capture.rs`, `scripts/browser_smoke.ps1`, existing
  verification scripts, `docs/verification/`, and all revised screens.
  **Problem (verified coverage gap):** Existing authored captures do not prove
  current-build browser behavior, true minimum-size readability, or dense
  interaction paths; older images omit newer controls. This is not a claim
  that every untested screen is broken.
  **Action:** Run the revised screens on native and actual embedded/fullscreen
  WebGL. Use normal 1280x720 and the declared minimum actual canvas (candidate
  960x540), plus 1920x1080, recording measured sizes. Capture fresh/late campaign,
  selection/expanded help, maximum relevant values, urgent/failure, settings,
  confirmations, recovery, and full-build expedition reward/event/finale states.
  Inspect long labels, enlarged text, notifications over bottom-right actions,
  and relic/collection overflow; fix only reproduced issues. Review title,
  codex, carriages and cosmetics for the same hierarchy before claiming a
  whole-game pass; their complete interaction paths were not audited here.
  **Acceptance:** Apply every UI_STYLE section 9 criterion, including 2–3
  attention regions and touch-only inspection/dismissal. Preserve essential
  costs, warnings and recovery. Replace equivalent screenshots directly in
  `docs/verification/`; record build identity, scenes, actual sizes, exercised
  touch paths and limitations. Run `./publish.ps1` without parameters after
  meaningful game changes and report its result separately from visual review.
  Use focused behavior regressions for collection reachability, one-action
  hit handling and tutorial progression after the existing test-placement
  follow-up; compilation or geometry checks alone do not close this task.
