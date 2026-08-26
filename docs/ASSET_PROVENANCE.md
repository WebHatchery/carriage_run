# Carriage Run asset provenance ledger

Audit date: 2026-08-27

Status: repository evidence plus unresolved human attestations; **not a legal
ownership conclusion**

This ledger covers runtime assets, packaging art, generated audio, and current
verification media that may become storefront inputs. Git proves when a file
entered this repository and who committed it; it does not by itself prove who
created the underlying work, which tool terms applied, or who owns every right.
Those distinctions are preserved below.

## Evidence scale

- **Verified**: current bytes and an authoritative bundled license/source are
  available in the repository.
- **Repository-recorded**: Git or source code records the event, but creator,
  upstream working files, or tool terms are incomplete.
- **Human attestation required**: no repository evidence can truthfully answer
  the field; the publisher/rights holder must supply it before public release.

## Binary visual and packaging assets

| Asset | Current identity | Source/date and edits | Creator/tool and generative-AI record | Rights basis and release state |
| --- | --- | --- | --- | --- |
| `assets/images/carriage_run_title.png` | 1672×941 RGB PNG; SHA-256 `d7f0f0bdc0920de11178875b11a8ba252e3b0f3cd5749b31fb95870efc9390ea` | First checked in unchanged in `2085f65793a497caa304cc7db126abd353e0120a` on 2026-06-16. `carriage_run_title.png` and `catalog_thumbnail.png` are byte-identical deployment/catalog copies. No layered source, prompt, edit log, or earlier source record exists in Git. | Committer: Kalaith. That is not proof of creator. Creation tool/model and whether generative AI was used are **unrecorded; human attestation required**. | `ASSET_LICENSES.md` records it as an original WebHatchery project asset. Publisher must verify creator, ownership/assignment, source/tool terms, and any required AI disclosure before approving title/capsule use. |
| `assets/images/characters_atlas.png` | 1254×1254 RGBA PNG; SHA-256 `5dd9fb0749a48544eabfcfec7921518da56912ffa0d27bfcb26a4c3277cd4757` | Added in `210611645de135d0505b0bfc08c338f34c6f582a` on 2026-08-14. Replaced procedural guard/enemy art with cropped atlas cells; runtime tinting supplies hit/down variants. No prompt or editable source is retained. | Commit says “generated 2D sprite asset conversion,” is co-authored by OpenAI Codex, and source comments discuss image-generation bleed. Record as **AI-assisted/generated media indicated; exact service, model, prompt, and human edits unrecorded**. | Project records it as original Carriage Run art. Human must confirm generation account/tool terms, source inputs, absence of unlicensed references, material edits, and the storefront's current AI disclosure answer. |
| `assets/images/world_atlas.png` | 1536×1024 RGBA PNG; SHA-256 `9ce6d36bfc1e9bb555b7b05f0a3d76a0e8e97a584138299ac9f8e192e24d02e1` | Same introduction commit/date. Replaced procedural carriage equipment, hazards, scenery, and related UI art with cropped atlas cells; some extended content still uses authored fallback geometry. No prompt/editable source retained. | Same recorded AI-generation evidence and unresolved tool/model/prompt/human-edit fields as the character atlas. | Same project-rights assertion and required human/tool-terms/AI-disclosure review as the character atlas. |
| `assets/images/missions_atlas.png` | 1448×1086 RGB PNG; SHA-256 `4ebb33edf23354e91d8969c26217d73d53cf54e132a0f806f63a9e162db90553` | Same introduction commit/date. Replaced procedural mission thumbnails with cropped atlas cells. No prompt/editable source retained. | Same recorded AI-generation evidence and unresolved tool/model/prompt/human-edit fields as the character atlas. | Same project-rights assertion and required human/tool-terms/AI-disclosure review as the character atlas. |
| `assets/packaging/carriage_run.ico` | Windows ICO; 205,086 bytes; SHA-256 `74cc38ecd876f209a1ed7d809b14bc2c0544cc86c8cc92249af0d2dd00db3027` | Added in release-completion commit `c3fb585db015758f2cf71aea7d570f4d70074754` on 2026-08-19 and embedded by `build.rs`. Git does not record its source image or conversion steps. | Committer: Kalaith with GPT-5 co-authorship on the broad release commit. Exact icon creator, source, conversion tool, and AI involvement are **unrecorded; human attestation required**. | Recorded as an original project asset, but derivation and rights must be confirmed before release. If derived from another ledger item, record that relationship and tool before approval. |

The three root/title copies are intentionally identical. They are not three
independent rights claims. Verification screenshots are deterministic captures
of the running game and therefore derivative evidence of all visible art,
fonts, and UI; their capture scene, build identity, date, crop, and any later
editing must be recorded when a screenshot is selected for a storefront.

## Font and license assets

| Asset | Source/date and edits | Creator/tool and AI record | Rights basis and release state |
| --- | --- | --- | --- |
| `assets/fonts/english.ttf` and `assets/fonts/latin_extended.ttf` | Byte-identical copies of Rajdhani SemiBold embedded by `macroquad-toolkit`; added in `c3fb585db015758f2cf71aea7d570f4d70074754` on 2026-08-19. Both hash to `94bbd25a18ca665999feb05a537de9fd2b860dcfb78bbe9ca00270825bf235da`. Runtime uses the toolkit copy; project copies are audit evidence. | Rajdhani by Indian Type Foundry, copyright 2014. No project modification or generative-AI use recorded. | Verified SIL Open Font License 1.1. The notice at `assets/licenses/OFL-Rajdhani.txt` ships in the Windows package. |
| `assets/licenses/OFL-Rajdhani.txt` | Bundled verbatim license notice added in `ebff3401b1479992e4b82f0be9839c93a6f2d386` on 2026-08-27; SHA-256 `46d7f96ac9e4200d3c4e2617a7acebb795a969492948d61f22ec697342e52b82`. | Upstream license text, not generated project content. | Verified notice for the Rajdhani font; must remain in every package that ships the font. |

## Authored data and text

All files under `assets/data/` are typed game configuration/content consumed by
Carriage Run: actions, chassis, cosmetics, game configuration, guard
specializations, expedition modifiers/events/relics/stakes, localization,
missions, texture mappings, and upgrades. They entered Git between the initial
commit on 2026-06-16 and the release-completion commit on 2026-08-19, with later
balance edits recorded individually.

- Source: repository-authored JSON tied to Rust schemas and validation tests;
  Git is the available edit history. There is no separate imported dataset.
- Recorded authorship/tooling: commits name Kalaith and frequently record
  OpenAI Codex/GPT-5 co-authorship. This supports an **AI-assisted text/code
  development** disclosure, not a claim that a particular model originated
  every string.
- Translations: English, German, and French strings exist in
  `localization.json`; translator identity, translation method, and fluent
  human approval are not recorded. These are human-attestation gates before
  claiming each language publicly.
- Rights basis: `ASSET_LICENSES.md` records the data as original project work.
  The publisher must confirm contributor authority/assignment and truthful
  storefront AI disclosures. Game-data facts are not a third-party dataset
  license claim.

## Runtime-generated audio

No music or sound file ships. `src/audio.rs` deterministically synthesizes the
runtime bed/effects through `macroquad-toolkit` from project code.

- Source/edit record: source control for `src/audio.rs` and the pinned toolkit;
  introduced in `c3fb585db015758f2cf71aea7d570f4d70074754` on 2026-08-19.
- Tool/AI record: procedural waveform generation at runtime, not a trained
  generative-audio model and not a third-party recording.
- Rights basis: original project code plus toolkit/dependency licenses recorded
  in `THIRD_PARTY_LICENSES.md`.

## Required human attestation before public release

The publisher/rights holder must date and sign a release record that answers:

- Who created the title image and icon, using which applications/services,
  accounts, dates, source inputs, and material edits?
- Was generative AI used for the title or icon? For every generated/assisted
  visual, which provider/model and terms applied, and are prompts/source images
  retained privately for audit?
- Did any source input contain stock, commissioned, trademarked, copyrighted,
  personal-likeness, or third-party reference material? If so, where is the
  license/consent/assignment evidence?
- Does WebHatchery own or hold sufficient distribution and marketing rights for
  every contributor's work and every selected storefront image/video?
- Who authored/reviewed the German and French text, and which languages can be
  truthfully promised after fluent human review?
- What generative-AI disclosure does the selected storefront currently require,
  and does the final answer match both repository evidence and the creator's
  private records?

Until those questions are resolved, asset provenance is materially incomplete
even though the current file coverage and font license are verified.

## Repeatable engineering evidence

Run `scripts/audit_asset_provenance.ps1`. It verifies that every tracked file
under `assets/` falls into a documented ledger category, title/catalog copies
and font copies remain identical, known binary hashes and introduction commits
match, required runtime registry entries and the OFL notice remain present, and
the provenance document retains its explicit human/AI gates. Run the license
inventory generator separately after any asset or dependency change.
