# Carriage Run PC demo gameplay trailer storyboard

Prepared: 2026-08-27  
Status: **contingent plan—do not capture or publish as final media yet**  
Assumption: approved product-brief Option A and an English-only first demo

The first Steam trailer should be categorized as **Gameplay** and show what the
player does from the player's actual perspective. Steam notes that viewers may
give it less than ten seconds and may watch without audio; it also creates the
store's six-second microtrailer from the first visible video. The plan therefore
opens on clear gameplay, keeps the real HUD visible, and reserves the logo for
the end rather than beginning with a cinematic card.

Current official references:

- <https://partner.steamgames.com/doc/store/trailer>
- <https://partner.steamgames.com/doc/store/application/demos>
- <https://partner.steamgames.com/doc/store/assets/standard>

## Creative brief

- **Target length:** 50–55 seconds.
- **Promise:** steer a vulnerable carriage while actively directing guards,
  then make route and upgrade decisions that matter on the road.
- **Tone:** urgent road adventure with readable strategy, not grim horror.
- **Structure:** mechanic, consequence, choice, escalation, demo identity.
- **Footage rule:** every image comes from the exact approved demo build. No
  full-only mission, expedition, boss, carriage, guard, cosmetic, or menu.
- **Audio-off rule:** the sequence remains understandable with the player
  muted; action and concise captions carry the meaning.
- **Honesty rule:** retain representative HUD and ordinary play. Do not use
  debug tools, impossible camera moves, staged enemy counts outside shipped
  balance, diagnostic notifications, or footage from a development-only scene.

## Primary 53-second cut

| Time | Picture and player action | Optional on-screen text | Audio intent | Capture/evidence gate |
| ---: | --- | --- | --- | --- |
| 0:00–0:04 | Cold open on The Muddy Road: the carriage swerves around mud as wolves close from both sides. LEFT/RIGHT, BRAKE, and BOOST remain visible. | `STEER THE CARRIAGE` | Begin on wheel/road motion and the in-game music bed; one clean wolf threat cue. | Actual new-campaign loadout and default difficulty; no seeded impossible encounter. |
| 0:04–0:09 | Drag the swordsman toward a wolf, then tap the guard to change stance while the carriage keeps moving. | `DIRECT THE GUARDS` | Guard order cue and restrained combat effects. | Cursor/action must match the visible control instruction and produce the shown response. |
| 0:09–0:13 | A fallen tree fills the lane; brake, steer clear, then boost out as the cargo/health indicators hold. | None | Brake/boost cues make the cause and effect readable without narration. | One continuous take preferred; do not splice failure and success into a false reaction. |
| 0:13–0:17 | Mission map/loadout shows the real Bandit Bend versus Courier Deadline fork. Select one route. | `CHOOSE YOUR ROAD` | Music briefly opens up; selection sound. | Both branches must be available under approved demo progression. |
| 0:17–0:23 | Bandit Bend: bandits reach for cargo while a guard intercepts; show one risk/reward route hazard. | None | Cargo threat and combat cues. | Demo-contained branch footage only; no excessive particle stack or hidden assist. |
| 0:23–0:29 | Courier Deadline: timer visible, mud ahead, sustained boost closes the distance. | None | Faster rhythmic section without obscuring warning cues. | Timer and boost behavior must be achievable on the shown difficulty/loadout. |
| 0:29–0:34 | Between contracts, purchase one affordable upgrade; hard cut to its visible gameplay consequence. | `PREPARE BETWEEN RUNS` | Purchase cue into matching road effect. | Use the actual first-session economy. Name/effect must match the shipped upgrade. |
| 0:34–0:39 | Bonebridge Pass reveal: haunted crossing, skeleton pressure, carriage of temple relics. | None | Shift to the darker Bonebridge music/cue palette. | Capture the approved finale's ordinary opening, not full-game later content. |
| 0:39–0:46 | Rapid but legible escalation: guard holds skeletons, necromancer remains visible, fire patch/rocks force steering, then select Chapel Road or Crypt Bridge. | `SURVIVE BONEBRIDGE PASS` | Two or three gameplay cuts on musical beats; preserve gameplay cue audibility. | No cut shorter than roughly 1.5 seconds; viewers must be able to parse the HUD and threat. |
| 0:46–0:50 | Cross the finish with damaged but surviving carriage; show the genuine successful result transition. | None | Victory cue, then music resolves. | Do not imply a perfect result if footage shows damage/cargo loss. |
| 0:50–0:53 | Approved title treatment: `CARRIAGE RUN` with a clearly integrated `PC DEMO` identifier. | No date or URL. | Short resolved sting; clean tail for transcode. | Use approved demo logo treatment. Steam supplies the associated full-game link; no fake store UI. |

The recommended poster/custom thumbnail is a text-free frame from 0:39–0:46
showing the carriage, guards, and Bonebridge threats with the HUD naturally
visible. Steam requires a custom poster to be a 1920×1080 frame from the video
itself; do not substitute key art.

## Six-second microtrailer resilience

Steam automatically samples six one-second clips from the first visible
trailer, so the full timeline should contain visually distinct, gameplay-led
beats throughout rather than a long intro or end card. Before upload, make a
rough six-sample contact sheet from evenly spaced points and verify it shows:

- carriage steering;
- a guard action;
- a hazard or cargo threat;
- route/loadout choice;
- the Bonebridge escalation; and
- the demo's actual visual style.

If automatic samples are likely to land on fades, black frames, or static
menus, adjust edit timing rather than relying on a custom microtrailer; Steam
does not provide one.

## Capture list

Record longer clean handles than the edit needs. Each take should include at
least two seconds before and after the planned action.

| Take ID | Required state | Minimum handle | Inputs/evidence |
| --- | --- | ---: | --- |
| TR-01 | Muddy Road steering/wolves | 12 s | Default new campaign; visible controls; no coaching overlay beyond shipped tutorial. |
| TR-02 | Guard drag and stance | 10 s | Pointer visible only if it helps explain the direct action; retain matching HUD response. |
| TR-03 | Fallen tree brake/boost | 10 s | One continuous successful recovery. |
| TR-04 | Campaign fork selection | 8 s | Real post-Muddy save; both approved branches visible. |
| TR-05 | Bandit Bend cargo defence | 12 s | Record cargo before/after and chosen route. |
| TR-06 | Courier Deadline boost | 12 s | Timer, route, difficulty, and loadout recorded. |
| TR-07 | Upgrade purchase/effect pair | 8 s + 8 s | Actual gold balance and matching before/after gameplay effect. |
| TR-08 | Bonebridge entrance | 10 s | Approved final mission, ordinary balance. |
| TR-09 | Bonebridge combat/hazards/route | 20 s | Skeleton, necromancer, hazard, and route-choice beats; no full-only content. |
| TR-10 | Successful finish/result | 10 s | Same build and plausible progression as the preceding finale footage. |
| TR-11 | Approved demo title/end card | 5 s | Demo identifier, no placeholder URL/date/feedback address. |

For every take, retain RC commit, build channel, package SHA-256, save-fixture
and manual steps, resolution/frame rate, settings/difficulty, input method,
capture tool/version, source filename, UTC capture time, and editor notes. The
scripted saves in `PC_DEMO_SCRIPTED_SAVE_FIXTURES.md` may shorten setup, but the
record must disclose their use and the footage must remain achievable in normal
play.

## Edit and accessibility rules

- Use 16:9 gameplay at a true 1920×1080 canvas or higher. Do not stretch the
  existing 1904×1022 window captures.
- Keep the HUD inside title/action-safe margins after any crop. Do not enlarge
  only select UI elements in post.
- Prefer cuts of 1.5 seconds or longer. Avoid rapid flashes, strobing, artificial
  screen shake, speed ramps, or motion effects not present in the demo.
- Use at most the four short English captions in the storyboard. Burned-in text
  requires a localized trailer for every additional advertised language; an
  English-only demo avoids implying unsupported localization.
- Captions should use the approved type treatment, high contrast, and enough
  dwell time to read without pausing. They must not cover the HUD or threats.
- Mix gameplay cues beneath music rather than replacing them. Check stereo,
  mono fold-down, headphones, speakers, and an audio-off viewing pass.
- Do not add narration unless script, voice, performance rights, captions, and
  localization are separately approved.
- Use only audio whose provenance and rights match the shipped asset ledger.
  Reconfirm the final music/edit license even if the source is generated or
  project-owned.

## Technical master and Steam delivery

- Edit and archive a high-quality 1920×1080 or higher 16:9 master.
- Deliver H.264 video with AAC stereo audio in MP4 unless the current upload
  form indicates a better supported choice.
- Use 30/29.97 or 60/59.94 fps matching captured gameplay; do not synthesize
  frames to claim smoother play.
- Use a high bitrate of at least 5,000 Kbps; retain a higher-quality mezzanine
  master for future transcodes.
- Use 44 kHz or 48 kHz audio and allow clean head/tail frames for processing.
- Upload early enough for transcoding and review; a trailer still processing
  can prevent release.

## Review gates

- [ ] Option A, target player, promise, title treatment, and demo identity are approved.
- [ ] Every take comes from the exact contained demo RC; full-only content is absent.
- [ ] The first ten seconds communicate steering plus guard command without audio.
- [ ] At least three first-time target players can describe what the player does after one viewing.
- [ ] Captions, contrast, motion, and audio passes receive human accessibility review.
- [ ] Music, effects, fonts, logo, footage, and any editor assets have approved provenance/rights.
- [ ] Human reviewer confirms no diagnostic overlay, private data, account name, placeholder, or unsupported claim is visible/audible.
- [ ] Export dimensions, frame rate, codec, bitrate, audio, duration, and file playback are verified.
- [ ] Poster frame is an actual representative frame from the uploaded video.
- [ ] Steam's processed trailer is watched start-to-finish with audio on and off, and its generated microtrailer is reviewed.
- [ ] Publisher gives final creative and public-upload approval.

