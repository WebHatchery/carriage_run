# Carriage Run PC demo storefront copy draft

Prepared: 2026-08-27  
Status: **internal draft—do not publish**  
Planning baseline: Steam, separate demo store page  
Assumed product direction: Option A in `PC_DEMO_PRODUCT_BRIEF.md`

This packet is contingent on publisher approval of the storefront, demo slice,
promise, save policy, public identity, and release window. It deliberately
contains no external links, publisher name, support address, release date,
rating, price, or unverified hardware claim. Text in square brackets is an
approval or evidence gate, not player-facing copy.

Steam's current guidance says a separate demo page must describe only the demo,
list only features and languages present in it, use demo-specific media, and
visibly distinguish its art from the full game. Steam also links an associated
demo page back to the full game automatically. The written description must not
contain external links. Official references:

- <https://partner.steamgames.com/doc/store/application/demos>
- <https://partner.steamgames.com/doc/store/page/description>
- <https://partner.steamgames.com/doc/store/assets/standard>
- <https://partner.steamgames.com/doc/store/localization/languages>

## Proposed short description

Steer a vulnerable supply carriage through dangerous roads while directing
guards against wolves, bandits, and the restless dead. Choose your route,
improve your crew, and survive a compact escort-strategy journey.

Character count: 214 including spaces. The field is plain text and contains no
date, link, full-game feature, or unsupported platform claim.

## Proposed About This Demo copy

### Keep the carriage moving

The road does not wait for a perfect plan. Steer around mud, rocks, and fallen
trees while your hired guards fight beside the wheels. Brake to control danger,
boost when time is short, and change guard orders as threats close in.

### Choose the safer road—or the richer one

Every contract offers a route decision. Take a longer, steadier road or risk a
more dangerous shortcut for a better reward. Damage, cargo losses, and the time
left on the clock all shape the result.

### Prepare between contracts

Spend your earnings on a meaningful upgrade, arrange your guard loadout, and
decide which contract to tackle at the opening fork. The choice changes the
middle of the journey and gives the demo a second route to replay.

### Survive Bonebridge Pass

The demo contains four authored contracts, with three completed in a typical
first journey. The final road brings together driving, defence, hazards, and
route choice as skeletons and necromancers close on a carriage of temple
relics.

### Demo features

- Active carriage steering, braking, and boosting
- Direct guard orders during real-time road combat
- Four authored contracts with a replayable campaign fork
- Route choices that trade distance, danger, and reward
- A loadout and upgrade decision before the final contract
- Relaxed, Standard, and Hard difficulty settings
- Rebindable keyboard controls and visible mouse controls
- Adjustable text size, reduced motion, and a colorblind-safe palette
- Local saves with rolling backups and corruption recovery

This proposed copy must be rechecked against the contained demo build. Remove
any bullet whose complete player path is absent or fails the exact release
candidate.

## Demo-specific facts for store fields

| Field | Proposed entry | Release condition |
| --- | --- | --- |
| Product type | Free demo | Publisher confirms the product is a free demo. |
| Platform | Windows | Exact Windows depot passes install, launch, update, and uninstall. |
| Player mode | Single-player | Demo remains entirely local and has no network mode. |
| Typical first journey | 25–40 minutes | Human playtest distribution supports the range. |
| Included contracts | The Muddy Road; Bandit Bend; Courier Deadline; Bonebridge Pass | Option A approved and package-containment gate passes. |
| Ending | End of Demo after Bonebridge Pass | End screen and replay path pass. |
| Save transfer | No automatic transfer to the full game | Publisher approves the proposed no-transfer policy and player copy states it. |
| Achievements | None promised | Keep demo achievements disabled unless separately approved and implemented. |
| Online features | None | Re-audit exact candidate for network/third-party SDK additions. |

## Language table

Publish only the following claim for the current content boundary:

| Language | Interface | Full audio | Subtitles |
| --- | :---: | :---: | :---: |
| English | Yes | No | No |

Do **not** list German or French yet. Only 18 keyed strings are translated;
mission, tutorial, settings, loadout, results, and demo-ending surfaces still
contain English. They may be added only after the approved slice is completely
externalized, translated, captured, and approved by fluent reviewers. There is
no spoken dialogue, so “Full Audio” and “Subtitles” should remain unchecked
unless the shipped content changes.

## Accessibility and input claims

The following settings exist in the current build and may be described after
human testing of the exact demo candidate:

- three difficulty presets that alter enemy pressure and strength;
- text scaling from 0.8× to 2.0×;
- a colorblind-safe gameplay palette;
- reduced route motion;
- separate master, music, and effects volume controls;
- windowed/fullscreen modes, resolution choices, VSync, and frame cap;
- rebindable steering, boost, brake, repair, save, and load keys; and
- hold/toggle preference for drag orders.

Do not select Steam's controller-support or accessibility feature flags solely
from code inspection. First complete the advertised path on real hardware and
retain the result with the release candidate. In particular, an Xbox-style
controller is a candidate input method, not yet an approved public claim.

## Content-description draft

Use this as factual input for the publisher-controlled content survey, not as a
rating prediction or legal attestation:

> Stylized fantasy combat occurs throughout the demo. Guards use melee attacks
> and magical or physical projectiles against wolves, human bandits, skeletons,
> and necromancers around a moving carriage. Defeated enemies disappear in
> brief colored particle bursts. The demo includes haunted-road themes, undead
> enemies, carriage damage, and environmental fire hazards. Repository review
> found no blood, gore, sexual content, drugs, gambling, or strong language in
> the proposed four-contract slice; the exact build and all media still require
> human survey review.

## System requirements—internal placeholders only

Do not paste these into a public store page yet. They are the compatibility
test floor from `PC_DEMO_WINDOWS_COMPATIBILITY_BASELINE.md`, not proven minimum
requirements.

### Minimum candidate

- Requires a 64-bit processor and operating system
- OS: 64-bit Windows 10 or Windows 11
- Processor: x86-64 desktop or laptop processor [name the lowest passing model]
- Memory: 4 GB RAM [confirm measured peak on constrained hardware]
- Graphics: [name the lowest passing integrated GPU and driver]
- Storage: 50 MB available space [remeasure final depot/update overhead]
- Display: 1280×720
- Input: keyboard and mouse

### Recommended candidate

Leave blank until representative hardware has completed the exact uploaded
build with acceptable frame pacing. Do not infer a graphics API or GPU floor
from Macroquad's dependencies.

## FAQ draft

### Is this the full game?

No. This proposed demo is a compact sample of the campaign containing four
contracts and one replayable branch. Features and missions outside that slice
belong to the planned full game and are not included in the demo.

### How long is the demo?

The target is 25–40 minutes for a first journey. [Replace this with the observed
range after uncoached target-player tests.]

### Can I play both routes?

Yes. After the opening contract, choose Bandit Bend or Courier Deadline. Replay
the demo to take the other road before both routes meet at Bonebridge Pass.

### Does progress carry into the full game?

No automatic save transfer is planned. Demo and full-game saves are intended to
remain separate. [Publish only after the no-transfer policy is approved and
implemented.]

### Which languages are supported?

English interface text is proposed for the first public demo. German and French
must not be promised until every reachable demo string is translated and
reviewed by fluent speakers.

### Can I use a controller?

Controller input is implemented but remains outside the public claim until the
complete demo path passes on the controller hardware named on the store page.
[Replace this answer with an approved yes/no statement before publication.]

### Does the demo send analytics or crash reports?

The current build has no telemetry, network client, or automatic crash upload.
Saves, backups, settings, and crash logs stay on the PC. A player may choose to
send a log when asking for support. Re-audit this answer if any online service
or SDK is added.

### Where can I report a problem?

[Insert the publisher-approved support or feedback destination in Steam's
dedicated link/contact fields. Do not put an external URL in the written store
description.]

## Demo announcement draft

### Headline

Carriage Run is opening the road for its first PC demo

### Body

Take the reins of a vulnerable supply carriage and direct its guards through a
compact escort-strategy journey. The proposed Carriage Run demo opens with The
Muddy Road, branches toward a cargo-defence or timed-delivery contract, and
reunites at the haunted Bonebridge Pass.

Choose routes, manage damage and cargo, improve your crew between contracts,
and decide when to brake for control or boost through danger. A first journey
is designed to take about 25–40 minutes, with the unchosen branch offering a
reason to return.

[Add the approved release window, supported-language statement, feedback
destination, and full-game call to action only after their gates pass. Remove
“25–40 minutes” if playtest evidence does not support it.]

## Approval and evidence checklist

- [ ] Storefront and separate-demo-page approach approved.
- [ ] Option A, audience, promise, length, and no-transfer policy approved.
- [ ] Exact demo package contains only the four named contracts.
- [ ] Every feature bullet is reachable and passes in the exact package.
- [ ] Five uncoached target-player sessions support the comprehension and
      session-length claims.
- [ ] English critical path and every public-facing string are reviewed.
- [ ] Any additional advertised language has complete fluent-human approval.
- [ ] Controller and accessibility flags have real-user/device evidence.
- [ ] Minimum and recommended hardware are replaced with tested named systems.
- [ ] Content survey, developer/publisher identity, support contact, privacy
      text, and all legal representations receive human approval.
- [ ] At least five 1920×1080 or larger 16:9 screenshots and the trailer show
      only the exact demo, with no diagnostic overlay.
- [ ] Demo capsule and library art visibly say `DEMO`.
- [ ] Final copy contains no placeholders, external links, unsupported claims,
      full-only features, dates likely to go stale, or unapproved calls to
      action.
