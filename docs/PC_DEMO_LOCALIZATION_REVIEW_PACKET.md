# Carriage Run PC demo localization review packet

Audit date: 2026-08-27

Status: engineering handoff for fluent human review. Carriage Run currently has
complete English/German/French parity for the **18 keyed strings** in
`assets/data/localization.json`, not for the whole game. Many mission names,
descriptions, buttons, statistics, tutorials, codex entries, and expedition
screens remain authored directly in English. Do not advertise full German or
French support unless the approved demo slice is fully externalized,
translated, captured, and reviewed.

## Automated evidence

The Rust localization tests verify:

- English, German, and French have exactly the same non-empty key set;
- values contain no control characters and stay within per-surface character
  budgets (menu 24, settings 32, tutorial 60, explanatory text 72);
- every character used by all three tables exists in the shipped Rajdhani
  Latin-extended font bytes;
- on-road touch instructions are separately tested against their visible
  controls and direct gestures; and
- the existing runtime fallback and broad layout-warning behavior still works.

Deterministic captures are stored directly in `docs/verification/` as
`ui_title_<language>.png`, `ui_settings_<language>.png`, and
`ui_results_<language>.png`. These prove rendering for the keyed surfaces, not
translation quality or complete game coverage.

## Known localization boundary

Currently keyed and translated:

- main-menu heading and New Campaign, Continue, Load Game, Settings, Field
  Guide, Credits, and Exit Game controls;
- fullscreen, resolution, VSync, FPS cap, text size, colorblind palette,
  reduced motion, and drag-order labels;
- two results explanations.

Still English and therefore outside any truthful German/French support claim:

- title subtitle/fallback art text and overwrite confirmation;
- save-slot, audio, binding, difficulty, assist, pause/resume, and many settings
  labels/values;
- mission/route names, briefings, objectives, bonuses, results labels/reasons,
  campaign rank, rewards, and progression text;
- loadout, guards, upgrades, carriages, shop, cosmetics, and field-guide copy;
- gameplay alerts, threats, hazards, guard barks, commands, failure/retry, and
  recovery notices;
- expedition outfitter, events, branches, relics, records, victory/failure, and
  seeded-run text; and
- credits/support and the future end-of-demo/store/feedback screen.

After the publisher chooses the demo slice and promised languages, extract
every player-visible string reachable in that slice. Key names, fallback
behavior, and layout budgets should be added before translation begins.

## Reviewer setup

Assign separate fluent reviewers for German and French where possible. Give
each reviewer the exact RC build, build identity/hash, screenshots, English
source intent, glossary, character limits, and issue form. Review in the game,
not only in JSON. The reviewer should use the language professionally or as a
native/fluent speaker and should not be the sole author of the translation.

For each language, test at minimum:

- 1280×720 and 1920×1080, plus the smallest supported window;
- Windows scaling 100%, 125%, 150%, and 200%;
- text-size settings 1.0× through the maximum;
- keyboard-only, controller-only, and visible click/tap controls; and
- new game, tutorial, route/upgrade choice, failure/retry, settings, save/reload,
  pause, demo end, replay, support/store action, and exit.

## Glossary and control consistency

The visible control label must be repeated exactly in instructions, including
capitalization where the UI presents all caps. Current keyed terms for review:

| Intent | English | German | French | Reviewer decision/notes |
| --- | --- | --- | --- | --- |
| Continue control | Continue | Fortsetzen | Continuer | |
| New campaign | New Campaign | Neue Kampagne | Nouvelle campagne | |
| Load game | Load Game | Spiel laden | Charger la partie | |
| Settings | Settings | Einstellungen | Paramètres | |
| Field guide | Field Guide | Feldhandbuch | Guide de terrain | |
| Credits | Credits | Mitwirkende | Crédits | |
| Exit game | Exit Game | Spiel beenden | Quitter le jeu | |
| Drag orders | Drag Orders | Zugbefehle | Ordres par glisser | Confirm intended interaction, not railway “train orders.” |
| Colorblind-safe palette | Colorblind-safe Palette | Farbblindesicheres Farbschema | Palette adaptée au daltonisme | Review respectful, idiomatic accessibility wording. |

The reviewer must define consistent demo-slice terms for carriage, cargo,
guard, route, hazard, threat, repair, reward, upgrade, mission, campaign, and
wishlist/store action before the remaining text is translated.

## Per-string review form

Record one row per key. Add an issue ID for any change or layout failure.

| Key | Source intent understood | Accurate | Idiomatic/tone | Terminology | Fits all tested layouts | Control matches | Approved translation / issue ID |
| --- | --- | --- | --- | --- | --- | --- | --- |
| | PASS/FAIL | PASS/FAIL | PASS/FAIL | PASS/FAIL | PASS/FAIL | PASS/FAIL/N/A | |

Review punctuation, accents, capitalization, formal/informal address,
inclusive language, ambiguity, unintended humor, cultural sensitivity, and
whether a shortened label preserves the action. Machine length budgets are
screening heuristics; a string can pass them and still clip or read badly.

## Screen review record

- Language/reviewer and qualification:
- RC commit/package SHA-256:
- Windows/display/input matrix:
- Screenshot or capture IDs:
- First clipped/overlapping/missing-glyph frame:
- Incorrect fallback or untranslated text:
- Instruction/control mismatch:
- Meaning, tone, terminology, or cultural issue:
- Proposed text and rationale:
- Retest build/result:
- Reviewer approval scope and UTC timestamp:

## Release decision

For each advertised language, attach complete per-string and critical-path
records, zero unresolved missing-glyph/control-mismatch defects, evidence for
all promised layouts, and a fluent human approval for the exact uploaded build.
If the approved demo cannot meet that bar, ship only the reviewed language(s)
and make the storefront language table truthful.
