# Carriage Run PC demo control-instruction audit

Audit date: 2026-08-27

Status: current full-build engineering evidence. Repeat against every state in
the approved demo, exact language set, and packaged RC. This audit verifies
control wording and visible escape/recovery paths; it does not replace first-time
human observation.

## Findings and corrections

- The first-route lessons now use only direct gestures or visible labels:
  **Tap LEFT/RIGHT**, **Drag a guard**, **Tap a guard**, **Drag a ranged guard to
  a gold slot**, **Tap BRAKE**, and **Hold BOOST**.
- The breakout alert previously said `BRAKE / GUARD` without telling the player
  how to act. It now says **Tap BRAKE or a guard**.
- The timed loadout advisory previously stated `ACTIVE BOOST REQUIRED` without
  the needed gesture. It now says **HOLD BOOST TO MAKE THE DEADLINE**.
- A dead `tutorial.continue` translation told players to tap a control that no
  gameplay tutorial displayed. It was removed rather than retained as a latent
  keyboard/touch mismatch.
- The unrecoverable installed-data screen previously asked the player to
  “Close” but had no tappable target and ignored input. It now provides an
  **Exit Game** button and says **Tap EXIT GAME**, while preserving the promise
  that the save was not changed.
- Settings still shows optional keyboard bindings, but its labels also name the
  corresponding visible controls: **LEFT/RIGHT**, **REPAIR**, **Save**, and
  **Load**.
- Controller hints appear only while a controller is connected. They supplement
  visible buttons and do not remove mouse/touch paths.

## Current instruction-to-control map

| Player-facing instruction/status | Required visible target or gesture | Evidence |
| --- | --- | --- |
| Tap LEFT or RIGHT | LEFT and RIGHT gameplay buttons | Shared layout/hit rectangles and UI tests |
| Drag a guard on the road | Direct drag gesture on visible guard | Gameplay drag state and tutorial test |
| Tap a guard | Direct tap gesture on visible guard | Guard-order toggle and tutorial test |
| Drag ranged guard to gold wagon slot | Direct drag gesture and visible gold slot | Gameplay mount interaction and tutorial test |
| Tap BRAKE | BRAKE gameplay button | Shared layout/hit rectangle and UI test |
| Hold BOOST | BOOST gameplay button with held input | Shared layout/hit rectangle and tutorial test |
| Tap BRAKE or a guard during breakout | BRAKE button or visible guard | Breakout instruction test |
| Tap EXIT GAME on recovery | Exit Game recovery button | Recovery copy/layout tests and deterministic capture |
| Retry after failure | Retry results button | Results screen visible action |
| Confirm/cancel destructive choice | Named confirm action and Keep Save buttons | Modal swallows background actions |

## Automated boundary

Tests keep first-route instructions in one audited constant set, reject common
keyboard-only command wording there, assert exact touch labels/gestures, verify
the breakout alternatives, require binding labels to name visible controls, and
keep the recovery button inside its panel with copy that names it.

The automated checks do not prove that a player notices, understands, or can
comfortably use a target. External testers must complete new game, tutorial,
route/loadout, play, pause/settings, failure/retry, recovery, and exit without
coaching using visible controls only. Record hesitation and attempted actions in
`PC_DEMO_PLAYTEST_PACKET.md`.
