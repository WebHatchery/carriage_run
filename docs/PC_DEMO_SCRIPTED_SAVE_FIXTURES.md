# Carriage Run PC demo scripted save fixtures

Prepared: 2026-08-27  
Status: test-only support for proposed product-brief Option A

These deterministic saves let a tester revisit campaign decision points without
replaying the opening. They do not implement or approve the demo boundary, are
not copied into release packages, and must be regenerated after save-schema or
demo-scope changes.

## Generate and install

From the project directory:

```powershell
.\scripts\generate_playtest_saves.ps1
.\scripts\install_playtest_save.ps1 -Fixture demoqa_final_bandit
```

The generator uses the compiled Rust state model and embedded data rather than
hand-authoring JSON. It writes five saves plus a hash manifest beneath
`dist/playtest_saves/`. The installer copies only the named fixture into its own
slot beneath `%LOCALAPPDATA%\carriage_run`; it does not overwrite the normal
`campaign` slot. In the game, open **SETTINGS**, select the `demoqa_*` slot, and
choose **LOAD**.

If that QA slot already exists, installation stops. Passing
`-ReplaceExisting` first preserves the prior file with a UTC-stamped name in
the non-slot `_qa_fixture_backups` directory and then replaces the slot. This is
intended for internal testers, not players.

## Fixture map

| Slot | Starting point | Purpose |
| --- | --- | --- |
| `demoqa_start` | Fresh campaign at The Muddy Road | New-player/tutorial baseline. |
| `demoqa_fork_bandit` | The Muddy Road complete; Bandit Bend selected | Test the cargo-defence branch and first between-contract spending choice. |
| `demoqa_fork_courier` | The Muddy Road complete; Courier Deadline selected | Test the timed branch and its visible boost guidance. |
| `demoqa_final_bandit` | Muddy Road and Bandit Bend complete; Guard Training purchased; Bonebridge Pass selected | Reach the proposed finale through the defence branch with a visible upgrade effect. |
| `demoqa_final_courier` | Muddy Road and Courier Deadline complete; Reinforced Wheels purchased; Bonebridge Pass selected | Reach the proposed finale through the timed branch with a different upgrade and route. |

Every generated fixture has a distinct active slot, deterministic timestamp,
valid selected mission, explicit route choice where applicable, and a SHA-256
entry in `playtest_save_manifest.json`. Automated tests verify that each
selected mission is unlocked by its recorded progress.

## Boundaries

- Active mission, pause, failure, results, and end-of-demo screens are
  session-only states; they cannot truthfully be represented by campaign saves.
  Use the nearest fixture, then follow the short manual step in the test case.
- No post-finale fixture exists until the approved End of Demo screen and replay
  semantics exist.
- The current files use the full build's existing save schema and application
  directory. When an approved demo namespace is implemented, the generator and
  installer must move to that namespace and tests must prove cross-visibility is
  impossible.
- Never attach real player saves to a public issue. These fixtures contain only
  synthetic state.

## Release and privacy gate

The Windows release ZIP must contain none of these files or scripts' generated
output. Regenerate fixtures from the exact test commit, record the manifest with
the test session, and remove installed `demoqa_*` slots when the test cycle
ends. Do not treat a fixture-assisted run as an uncoached first-time playtest or
as session-length evidence.
