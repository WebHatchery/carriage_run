# Carriage Run PC demo external-playtest packet

This packet is for independent target players testing a packaged release
candidate. Give the tester the game and the short setup below, then observe
without coaching. A test of a development build or a tester who already knows
the game should be labelled separately and must not replace the five-player
release gate.

## Tester setup

Tell the tester only:

> This is an unfinished Windows demo of Carriage Run. Please play naturally
> until the game clearly ends, you choose to stop, or 45 minutes pass. Think
> aloud when you can. The game—not you—is being tested, so confusion and failure
> are useful findings. Please do not share personal or sensitive information.

Do not explain controls, goals, upgrades, routes, failure recovery, or the demo
boundary unless a technical fault makes progress impossible. Record every hint
given, including its time and reason.

## Environment matrix

Assign sessions to cover the release candidate's supported range. Record actual
values rather than checking a generic box.

| Field | Session value |
| --- | --- |
| RC name, version, commit, package SHA-256 | |
| Install source and storefront build ID | |
| Windows version and build | |
| Standard/admin account | |
| CPU and memory | |
| GPU and driver | |
| Display resolution, refresh rate, HDR | |
| Windows scaling: 100/125/150/200% | |
| Window mode and aspect: 16:9/16:10/ultrawide/small | |
| Input: keyboard/mouse/controller family/touch | |
| Audio device | |
| Install path, including spaces/non-ASCII case | |
| Antivirus or endpoint protection | |
| Prior Carriage Run save present: yes/no | |

Across the full test round, include clean supported Windows installs, standard
non-administrator accounts, integrated and discrete GPUs, common Xbox and
PlayStation-style controllers where supported, unusual DPI, and install paths
with spaces and non-ASCII characters.

## Session result form

- Tester code and relevant genre familiarity:
- Observer and date/time/timezone:
- Start/end times and active minutes:
- Finished demo: yes/no; stopping point and reason:
- Missions/legs reached and route selected:
- First moment the goal became clear:
- Tutorial/control misunderstandings, with timestamps:
- First failure, cause as understood by tester, and recovery behavior:
- Damage taken and rewards/upgrades chosen:
- Approximate completion/failure/retry counts:
- Keyboard/controller/mouse actions that felt missing or unreliable:
- Readability, audio, motion, accessibility, or comfort concerns:
- Frame pacing, stalls, heat/fan, or other performance observations:
- End-of-demo understanding and next action attempted:
- Hints given by observer, with timestamp and reason:
- Tester enjoyment/frustration summary in their own words:
- Would they replay or wishlist, and why? Treat this as directional feedback,
  not a promise or marketing claim.

## Critical-path test cases

Record PASS, FAIL, BLOCKED, or NOT RUN plus timestamp and evidence.

| ID | Test |
| --- | --- |
| CR-01 | Install/extract and launch from the assigned path without development tools. |
| CR-02 | Start a new game and complete the tutorial without coaching. |
| CR-03 | Steer and use guard commands with the assigned primary input. |
| CR-04 | Make an upgrade choice and understand its immediate consequence. |
| CR-05 | Make a route decision and recognize the selected route. |
| CR-06 | Fail, understand the failure, and retry using visible controls. |
| CR-07 | Pause, change a setting, resume, and exit using the assigned input only. |
| CR-08 | Save, close normally, relaunch, and resume the expected demo state. |
| CR-09 | Alt-Tab/focus loss restores appropriate audio and input behavior. |
| CR-10 | Toggle window/fullscreen mode without clipping or losing interaction. |
| CR-11 | Disconnect/reconnect the controller and recover without restarting. |
| CR-12 | Reach the demo end and use replay, store/wishlist, feedback, and exit actions as applicable. |
| CR-13 | Update or reinstall through the chosen client without corrupting saves. |
| CR-14 | Uninstall and verify the documented local-data behavior. |

Only run destructive save-corruption/recovery cases on a copied test profile.
Never request credentials, real names, email addresses, screenshots containing
private material, or a tester's entire local-data directory. Share only the
minimum named game log/save file needed for an approved investigation, and let
the tester inspect it first.

## Bug and feedback record

Create one record per distinct issue:

- Issue ID and concise title:
- RC/package SHA-256:
- Severity: blocker / critical / high / medium / low:
- Reproducibility: always / frequent / intermittent / once / unknown:
- First timestamp and critical-path ID:
- Expected and actual behavior:
- Minimal reproduction steps:
- Environment/input/display details:
- Screenshot, short capture, or game-only log reference:
- Workaround and whether the tester recovered unaided:
- Duplicate/group ID:
- Triage owner and decision: fix / investigate / accept / cannot reproduce:
- Target RC and verification result:

At round end, group duplicates by root symptom, count affected independent
players, separate comprehension problems from software defects, and rank by
severity, frequency, player recovery, and critical-path impact. Record the
reason and human acceptance owner for every deferred high-severity issue.

For structured intake and conservative aggregation, copy
`PC_DEMO_PLAYTEST_REPORT_TEMPLATE.json` per session and follow
`PC_DEMO_PLAYTEST_TRIAGE.md`. The triage script groups only explicit observer
links; it does not guess that similar prose has the same cause.
