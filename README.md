# Carriage Run

Carriage Run is a Rust + Macroquad escort strategy game. Steer a supply
carriage across dangerous roads while hired guards protect the cargo, rescue
prisoners, and carry the campaign into its final acts.

## What's built

- A 30-mission campaign spanning three acts, three authored biomes, route
  branches, six side missions, two campaign bosses, and a designed finale.
- An 8-leg expedition mode with branching legs, modifiers, relics, events,
  entry stakes, seeded/daily runs, persistent tokens, records, and a finale
  boss.
- Carriage chassis, frame tunings, equipment, damage states, bobbing wheels,
  guard and enemy animation, biome road art, particles, hit-stop, and screen
  shake.
- Swordsman and Mage 3-star specializations, guard barks and hire quotes,
  cosmetic livery and guard-color unlocks, and roster flavor text.
- Breakout attempts, Rockslide, Cursed Fog, and Night Stretch hazards with
  authored balance coverage and counterplay feedback.
- Touch-first route controls, visible tutorial guidance, controller actions,
  keyboard rebinding, threat/off-screen indicators, tooltips, confirmations,
  results explanations, credits, and screen transitions.
- Settings for display, audio, text size, colorblind palette, reduced motion,
  drag behavior, language, and recovery-safe multi-slot saves with rolling
  backups and corruption quarantine.
- English, German, and French localization with fallback diagnostics, bundled
  font fallbacks, layout checks, generated audio, and page-focus mute support.

## Run

```powershell
cargo run
```

## Validate and package

```powershell
.\publish.ps1
```

The publisher is the project validation path. It builds and packages the
Windows and WebGL targets, checks release budgets, and deploys the result to
the local WebHatchery game directory. It also embeds the package version,
channel, commit, UTC build time, and pinned toolkit revision. These details are
available quietly on the Credits screen, in console diagnostics, and in crash
logs. The same identity is written to `dist/carriage_run_build_info.json` for
the release-manifest gate. Use `-Channel demo` only for an approved demo build;
normal publishing defaults to `full`.

```powershell
.\scripts\browser_smoke.ps1
```

Release budgets, dependency/version policy, license inventories, and the
latest verification captures live under `docs/`.

PC-demo operations are staged in the release-candidate checklist, external
playtest packet, rollback procedure, known-issues draft, and support guide in
`docs/`. `CHANGELOG.md` records repository milestones without implying that a
public demo has already shipped.

After a clean publish, `scripts/smoke_windows_package.ps1` exercises the actual
Windows ZIP from extraction paths containing spaces and non-ASCII characters.
The supported-PC planning floor and external machine evidence form are in
`docs/PC_DEMO_WINDOWS_COMPATIBILITY_BASELINE.md`.

## Release diagnostics

Release builds keep asset and localization startup notices out of the
player-facing UI by default. To include those notices during a support session,
launch the native executable from PowerShell with diagnostics enabled:

```powershell
$env:CARRIAGE_DIAGNOSTICS = "1"
.\carriage_run.exe
```

Save recovery, load failures, and invalid installed-data errors remain visible
without this switch because they require action from the player. Deterministic
screenshot captures always suppress startup diagnostics.

## Project status

The release backlog in [TODO.md](TODO.md) is complete. Remaining work should
be tracked as new issues or milestones rather than carried as unfinished
prototype scope.
