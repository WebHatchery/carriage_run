# Carriage Run — PC demo product brief

Status: **Option A slice approved; remaining publisher decisions pending**
Prepared: 2026-08-27  
Platform: public Windows PC demo  
Planning baseline: Steam, with itch.io still available as an alternative

No demo boundary should be implemented or published until the publisher records
the decisions in the approval block at the end of this document.

## Product promise

Carriage Run's demo is a compact escort-strategy journey for players who enjoy
arcade driving, active defence, and light campaign decisions. In one 20–40
minute session, the player should feel the difference between steering the
carriage and commanding its guards, make a route and upgrade decision, and
survive a final road that combines the skills the opening teaches.

The demo should end while the player is curious about the wider campaign, not
after the opening has exhausted them. It is a sample of the campaign rather
than a separate mode, score attack, or content-rich vertical slice.

## Slice options

### Option A — The first fork (recommended)

Include four authored missions, of which a normal first session completes
three:

1. `muddy_road` teaches steering, braking/boosting, hazards, route selection,
   and basic guard commands.
2. The player chooses either `bandit_bend`, which emphasizes cargo defence, or
   `courier_deadline`, which introduces time pressure.
3. `bonebridge_pass` reunites the fork and ends the demo with a haunted-road
   escalation, skeletons, a necromancer, denser hazards, and a meaningful final
   route choice.

The player visits the upgrade/loadout flow between contracts and can afford at
least one meaningful purchase from the opening reward. The unchosen branch
supports replay without lengthening the first session.

Why this is recommended: it preserves the real campaign's opening, progression,
economy, and teaching order. It needs the least demo-only balancing and gives
playtest feedback that is directly useful to the full game. Its climax is a
memorable hazard/enemy encounter rather than a formal boss, avoiding a late-game
spoiler and a large tutorial jump.

Expected first-session length: 25–40 minutes.

### Option B — Three-contract mechanics sampler

Include `muddy_road`, `courier_deadline`, and `monster_egg`, with demo-specific
unlocking and rewards. This moves quickly from fundamentals to time pressure
and the distinctive unstable-egg system.

Advantages: stronger novelty in a shorter package and a memorable final hazard.
Costs: it breaks the authored campaign graph, requires more bespoke onboarding
and balance work, and produces less representative progression feedback.

Expected first-session length: 20–30 minutes.

### Option C — Boss-forward showcase

Include `muddy_road`, one accelerated mid-campaign contract, and `ashen_gate`
against the Ash Colossus. Supply a curated demo loadout and compressed upgrade
path so the boss is understandable and fair.

Advantages: the strongest spectacle and an explicit boss finale.
Costs: the largest amount of demo-only logic, greater spoiler risk, a steep
mechanical jump, and feedback that transfers poorly to the normal opening.

Expected first-session length: 30–45 minutes.

## Recommended demo rules

These rules apply to Option A unless the publisher chooses otherwise.

- The demo build contains only the four approved mission definitions. Full-only
  mission data must not be embedded in or copied beside the demo executable.
- The normal build remains the complete game and never inherits demo limits.
- The title and credits/support panel visibly say `PC DEMO`; package names and
  release metadata also carry a demo channel identifier.
- Campaign saves use a separate application namespace and save version. The
  proposed policy is **no automatic progress transfer** to the full game. This
  is the safer promise while the save schema and storefront identity are still
  pre-release; the end screen should say so plainly.
- Expedition, records, cosmetics, extra carriages, save-slot management, and
  missions beyond the boundary are absent rather than shown as enticing but
  unusable menu items. Settings, field guide entries relevant to the slice,
  pause, failure/retry, credits/support, and exit remain available.
- Completing `bonebridge_pass` successfully opens an `End of Demo` screen.
  Failure still opens normal results with retry and return-to-map actions.
- The end screen offers `Replay Demo`, `Wishlist Full Game`, `Send Feedback`,
  and `Exit`. Store and feedback destinations remain unset until the publisher
  supplies and approves them; release packaging must reject placeholders.

## Provisional acceptance tests

These become binding after the slice and storefront are approved.

### Build identity and containment

- A normal release build reports the full channel, retains all 30 missions, and
  uses the existing full-game save namespace.
- A demo release build requires an explicit build mode, reports the demo
  channel, and contains exactly the approved mission IDs.
- Automated tests fail if a full-only mission can be selected, unlocked, loaded
  from a save, or found in the demo's embedded data.
- Demo and full saves can coexist. Neither build lists, overwrites, migrates, or
  quarantines the other build's saves.
- The demo Windows ZIP has a unique name containing `demo`, architecture, and
  version. It cannot overwrite or be mistaken for the full-game archive.

### Player path

- A new player can start, finish the tutorial prompts, complete every required
  interaction, recover from failure, and reach the demo ending with visible
  mouse/touch controls alone; keyboard and controller paths also pass.
- After `muddy_road`, both branch missions are presented as an understandable
  choice. Completing either unlocks `bonebridge_pass`.
- At least one affordable upgrade choice is available before the final mission,
  and its gameplay effect is visible during that mission.
- Winning `bonebridge_pass` always opens `End of Demo`; replay resets campaign
  progress only after explicit confirmation.
- Wishlist and feedback actions open the publisher-approved destinations. Exit
  closes the native game cleanly.

### Release protection

- The demo package contains only the executable and registered runtime assets:
  no source, credentials, debug symbols, test saves, crash logs, WebGL files, or
  full-release mission data.
- Packaging fails for a full save namespace, a missing demo marker, an invalid
  end mission, placeholder external links, or any unapproved mission ID.
- A machine-readable manifest records version, channel, commit, build time,
  toolkit revision, files, sizes, and SHA-256 hashes.
- The packaged build passes new campaign, save/reload, failure/retry, branch
  selection, upgrade, final victory, replay, and clean-exit checks.

## Release checklist for the approved slice

- [ ] Publisher approval block below is complete.
- [ ] Demo build mode and content boundary are covered by automated tests.
- [ ] Demo saves are isolated and the transfer policy is stated in player copy.
- [ ] Full-only menus and data are absent from the demo.
- [ ] End screen links use approved public destinations.
- [ ] Keyboard-only, controller-only, and visible-control-only paths pass.
- [ ] English, German, and French demo strings pass key/glyph/overflow checks.
- [ ] Demo-only balance report covers completion, failure, damage, reward, and
      session-length estimates for every included route.
- [ ] Windows package identity, contents, manifest, and checksums pass.
- [ ] `publish.ps1`, local release gates, and hosted CI pass on the exact commit.
- [ ] Clean-machine and external playtest gates in
      `PC_DEMO_AI_AGENT_WORK.md` are satisfied before public release.

## Publisher approval block

The publisher should edit this block or provide the answers to the agent. A
checked choice is authorization to implement that product direction, not to
upload, publish, spend money, accept agreements, or make legal attestations.

- Demo slice: [x] Option A  [ ] Option B  [ ] Option C
- Storefront baseline: [ ] Steam  [ ] itch.io  [ ] both
- Save policy: [ ] no transfer  [ ] transfer promised
- Target audience wording approved: [ ] yes
- Product promise and 20–40 minute target approved: [ ] yes
- Full-game store/wishlist URL supplied: ______________________________
- Feedback destination supplied: _____________________________________
- Target public date or window: ______________________________________
- Publisher name and approval date: User approval recorded in Codex, 2026-08-27

Approval scope note: this authorizes implementation and validation of the
Option A content boundary only. Storefront selection, public links, save
transfer promises, audience copy, timing promise, upload, and publication
remain unapproved.
