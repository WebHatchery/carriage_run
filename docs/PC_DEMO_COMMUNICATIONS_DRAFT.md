# Carriage Run PC demo communications draft

Prepared: 2026-08-27  
Status: **internal draft—do not publish or send**  
Planning assumptions: Steam-first Option A, 25–40 minute target, English-only,
no save transfer

Every assumption above still requires publisher approval. Replace bracketed
fields with approved facts, delete instructions before sending, and recheck all
feature language against the exact uploaded demo. Do not add a date, download
link, wishlist link, support address, publisher identity, controller claim, or
system requirement until its owner and evidence are recorded.

## Closed-test invitation

### Subject

Help us test the first Carriage Run PC demo

### Message

We are preparing a Windows demo of Carriage Run, an escort-strategy game about
steering a vulnerable carriage while directing its guards through dangerous
roads.

We are looking for players who can try one uncoached session of up to 45
minutes. We want to learn whether the goal, controls, route choices, upgrades,
failure recovery, and ending make sense without explanation. Confusion and
failure are useful findings—the game is being tested, not the player.

Testing involves installing the supplied candidate, playing naturally, and
completing a short feedback form. Some sessions may be observed with the
player's explicit consent. Please do not send passwords, account information,
personal documents, unrelated files, or screenshots containing private
material.

[Add the approved eligibility, session dates, candidate-delivery method,
consent/recording terms, feedback destination, contact identity, and any
compensation. Do not call the build public or shareable unless it is.]

## Feedback survey

Collect a tester code rather than a real name unless identity is genuinely
needed and covered by an approved privacy process.

1. Tester code and date of session.
2. Had you played Carriage Run before? If yes, in what context?
3. How familiar are you with strategy, escort, or action games?
4. What did you think your main goal was during the first five minutes?
5. Which controls or actions were unclear, missing, or difficult to perform?
6. Where did you first hesitate, become stuck, or need a hint?
7. Which route did you choose, and what did you expect that choice to change?
8. Which upgrade or loadout choice did you make, and why?
9. Did you fail or retry? What did you think caused the failure, and was the
   recovery path clear?
10. Did you reach the ending? If not, where and why did you stop?
11. Approximately how many active minutes did you play?
12. What was the most satisfying moment? What was the most frustrating?
13. Did text, colour, motion, audio, or control behavior create a comfort or
    accessibility problem?
14. Did you notice stalls, frame-pacing problems, excessive heat/fan activity,
    crashes, or save/load problems? Include only game and hardware details you
    are comfortable sharing.
15. Would you replay the other route or follow the full game? Why or why not?
16. What is the single change that would most improve this demo?
17. May the team contact you about this report? [Use an approved contact and
    retention process; otherwise remove this question.]

Pair these answers with the environment and critical-path fields in
`PC_DEMO_PLAYTEST_PACKET.md`. Directional interest answers are research input,
not public conversion claims.

## Public launch announcement

### Headline

Carriage Run opens the road with a free PC demo

### Body

Take the reins of a vulnerable supply carriage and direct its guards through a
compact escort-strategy journey in the Carriage Run demo.

Steer through hazards, brake when control matters, boost when time is short,
and issue guard orders as wolves, bandits, and the restless dead close in.
Between contracts, choose a route, adjust your loadout, and spend your earnings
before the road reaches Bonebridge Pass.

[If approved and supported by playtests: A first journey takes approximately
25–40 minutes, and replaying lets you try the other middle route.]

[Add approved release date/window, Windows availability, store destination,
supported languages, full-game call to action, feedback destination, and
publisher identity. Confirm the final post matches the uploaded build.]

## Short social posts

### Launch

The carriage is rolling. The Carriage Run PC demo is available now: steer the
road, direct your guards, choose a route, and survive what waits at Bonebridge
Pass. [Approved destination and tags]

### Gameplay focus

Brake for control or boost through danger? Carriage Run combines active wagon
driving with real-time guard orders and route decisions. Try the PC demo:
[approved destination]

### Feedback request

Played the Carriage Run demo? Tell us where the road was clear—and where it
wasn't. We especially want feedback on the opening controls, route choice,
failure recovery, and ending: [approved feedback destination]

### Route replay

One fork, two very different contracts. If you finished the Carriage Run demo,
replay it and take the road you left behind. [Use only if both branches ship and
the replay path passes.]

## Creator outreach draft

### Subject

Carriage Run demo — a compact carriage-escort strategy game for PC

### Message

Hello [creator name],

Carriage Run is a single-player escort-strategy game where the player steers a
moving carriage, directs guards in real time, and chooses between safer and
riskier roads. We are preparing a compact Windows demo built around an opening
contract, a replayable route fork, an upgrade/loadout decision, and a haunted
final road.

I thought it might suit your coverage of [specific, truthful reason based on the
creator's work]. If you are interested, the approved press materials and demo
are available here: [press-kit destination] and [store/key destination].

[Add the approved developer/publisher identity, release timing, contact,
embargo/key terms, disclosure requirements, and a factual personalization.
Never imply prior familiarity, payment, exclusivity, or endorsement unless it
is true and documented.]

## Patch notes template

### Carriage Run demo [version] — [plain-language title]

Released: [approved date]  
Build ID / package hash: [public identifier appropriate to the storefront]

#### What changed

- [Player-visible fix or improvement.]
- [Player-visible fix or improvement.]

#### Save and compatibility notes

- [State whether existing demo saves remain compatible, migrate, reset, or need
  a documented action. Never omit a known destructive consequence.]

#### Known issues

- [Symptom, affected environment, safe workaround, and planned disposition.]

#### Support

[Approved support destination and the minimum useful diagnostic information.]

Do not pad notes with internal refactors, promise an unverified fix, expose
private paths or security-sensitive detail, or describe full-game content as
part of the demo.

## First-week support responses

### Acknowledging a reproducible issue

Thanks for the clear report. We reproduced this in Carriage Run demo build
[build ID] under [verified conditions]. We are investigating [brief symptom].
For now, [tested safe workaround / “we do not yet have a safe workaround”]. We
will update the known-issues post when the status changes.

### Requesting useful diagnostics

Sorry the demo did not run correctly. Please send the demo version/build ID,
Windows version, GPU and driver, display resolution/scaling, input device, and
the steps immediately before the problem. If useful, you may also attach the
named Carriage Run log after reviewing it for anything you do not wish to
share. Please do not send your whole user-data folder or unrelated files.

### Save or progress concern

Please stop retrying actions that may overwrite the affected slot. Keep the
current save and its `.bak` files unchanged while we identify the correct
recovery path. Tell us the build ID, slot name, last successful screen, and
whether the game or PC closed unexpectedly. We will not ask you to delete the
folder as a first troubleshooting step.

### Controller report

Thanks for identifying the controller model and connection type. Please also
tell us whether it was connected before launch, whether reconnecting changed
the behavior, and which screen/action failed. Controller support must not be
promised publicly for hardware that has not completed the full demo path.

### Performance report

Please send the build ID, CPU, GPU/driver, memory, display resolution and
scaling, window/fullscreen mode, frame cap/VSync setting, and where the slowdown
occurred. A short game-only capture is helpful if you are comfortable sharing
it. We will compare reports by hardware and scene before changing public system
requirements.

### Security-software warning

Do not disable your security software. Tell us the product, detection name,
demo build/hash, and where you obtained the file. We will verify the published
artifact and investigate. A clean result from another scanner does not prove a
warning is false.

### Feature or balance feedback

Thank you—we have recorded this as feedback rather than a confirmed defect. We
are comparing it with completion data and other player reports. We cannot
promise a particular change or date, but the detail about [specific point] is
useful.

## Release-week ownership fields

- Public announcement owner and approval timestamp:
- Support destination and account owner:
- Monitoring windows and timezone:
- Store discussion/community owner:
- Issue triage owner and escalation backup:
- Build/rollback operator:
- High-severity acceptance authority:
- Privacy/security incident contact:
- Response-time expectation that can actually be staffed:

No message above should be scheduled until these fields, the final go/no-go,
and the exact uploaded build are approved.
