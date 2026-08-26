# Carriage Run — human-required work for the first PC demo

Audit date: 2026-08-26  
Scope: a public **Windows PC demo**, with Steam as the planning baseline and
itch.io as an optional alternative or secondary PC channel.

This file intentionally contains only work that requires human identity,
authority, money, ownership, subjective judgment, physical-world testing, or
personal accountability. An AI agent can prepare evidence, drafts, builds, and
forms, but it must not impersonate the publisher or silently make these choices.

## Estimate in human terms

Reserve **three months** for a polished Steam demo. Six months is reasonable
only if this is part-time, the store page is intended to gather wishlists for a
long runway, tester access is slow, or the game needs a meaningful creative
revision after playtests. For an itch.io-only Windows demo, 2–4 weeks is likely
enough if the current game is accepted creatively.

The hard lower bound for a first Steam product is not coding speed: Steam has a
30-day wait after the app fee, identity/tax verification may take 2–7 business
days, store/build reviews need scheduling margin, and the base game must have a
public Coming Soon page for at least two weeks. Start onboarding immediately if
Steam is the intended destination.

## Human decisions required before agent work can converge

Record each answer in the release issue or release record.

- [ ] Confirm the storefront: **Steam**, **itch.io**, or both. “PC only” is a
  platform scope, not a storefront decision.
- [ ] Confirm that the first public product is a **free demo**, not Early Access,
  a paid full release, a public beta, or a full game labeled as a demo.
- [ ] Choose the intended player and the demo's one-sentence promise.
- [ ] Choose the demo slice after reviewing the agent's proposals: target
  session length, included missions/systems, ending, replayability, and whether
  progress later transfers to the full game.
- [ ] Decide whether English, German, and French are all promised for the demo;
  remove any language that will not receive human linguistic review.
- [ ] Choose the public release date/window and whether it is tied to an event
  such as Steam Next Fest. Do not announce a day before review and testing
  contingency exists.
- [ ] Choose the public publisher/developer names and verify who legally owns the
  game, code, title art, sprites, fonts, audio, translations, and trademarks.
- [ ] Decide the feedback channel, support email/account, community policy, and
  who will respond during launch week.
- [ ] Decide whether crash reports remain local only, whether any analytics are
  added, and what privacy promise will be made. New telemetry materially expands
  legal, consent, security, and engineering work.

## Identity, legal, money, and account actions

### Steam, if selected

- [ ] Create or select the Steamworks partner account using the real publishing
  individual/entity.
- [ ] Read and electronically sign the NDA and Steam Distribution Agreement.
- [ ] Supply accurate legal identity/entity, address, beneficial-owner, bank,
  payout, and tax information. The bank account name must match the onboarded
  legal name.
- [ ] Complete any identity or tax verification follow-up sent by Valve.
- [ ] Pay the USD 100 Steam Direct fee using an authorized payment method.
- [ ] Secure the account with strong unique credentials and multi-factor
  authentication; never place credentials, recovery codes, cookies, or API
  secrets in the repository or an agent prompt.
- [ ] Grant the agent/tooling only the minimum Steamworks permissions needed for
  technical configuration. Retain “Actual Authority,” pricing/discount, and
  final publishing control with a human unless deliberately delegated.
- [ ] Provide the base-game and demo App IDs through a secure channel/config, not
  by committing secrets. Verify the demo is associated with the correct base app.
- [ ] Truthfully complete and attest to the content survey, generative-AI
  disclosure if required by the current form, mature-content answers, copyright
  representations, supported-language claims, and any controller/accessibility
  claims.
- [ ] Choose demo/base-game release visibility and public date.
- [ ] Personally approve submission of the store page and build for Valve review.
- [ ] Read Valve feedback and approve any response that changes claims, content,
  ownership, ratings, pricing, or the product's positioning.
- [ ] Use the human-controlled release action after the final go/no-go decision.

Steam references:

- Onboarding and legal/bank/tax requirements:
  <https://partner.steamgames.com/doc/gettingstarted/onboarding>
- Fee and timing constraints: <https://partner.steamgames.com/steamdirect/>
- Review process: <https://partner.steamgames.com/doc/store/review_process>
- Demo configuration: <https://partner.steamgames.com/doc/store/application/demos>

### itch.io, if selected

- [ ] Create/select the owner account and project, then provide the exact public
  `owner/game-slug` for `itch.json`.
- [ ] Securely authenticate Butler or authorize the agent to use an existing
  authenticated session. Credentials must stay outside version control.
- [ ] Choose the access model: free, donate, paid, restricted, or draft during
  testing. A demo should not create ambiguous payment expectations.
- [ ] Review the page classification, Windows platform flag, executable flag,
  pricing, visibility, community settings, and download labels.
- [ ] Approve the exact public page, uploaded build, and visibility change.
- [ ] Verify the public page while logged out and accept responsibility for its
  claims and availability.

itch.io publishing reference:
<https://itch.io/docs/itch/integrating/quickstart.html>

## Creative and product approvals

- [ ] Play the proposed demo from a clean start without developer shortcuts.
- [ ] Decide whether its first ten minutes communicate the fantasy of steering a
  vulnerable caravan while directing guards. Automated tests cannot decide this.
- [ ] Approve the difficulty curve, tutorial density, demo length, stopping
  point, end-screen call to action, and amount of content withheld.
- [ ] Approve final title treatment, capsule/key art, screenshots, trailer,
  descriptions, tags, and tone. Confirm they represent the shipped demo rather
  than planned full-game features.
- [ ] Decide whether the current contrast between cinematic title art and the
  simpler in-game visual style is an honest and desirable first impression.
- [ ] Approve every public feature, system requirement, accessibility, language,
  and controller claim after seeing evidence.
- [ ] Approve the final credits and ensure contributors are named according to
  agreements and personal preferences.
- [ ] Approve legal/privacy/support text, preferably with qualified legal advice
  where the business risk warrants it. AI drafts are not legal advice.

## Human playtesting that cannot be replaced by automation

The agent can organize and analyze these tests, but humans must perform them.

- [ ] Recruit at least **five target players who did not build the game**. Ten to
  fifteen is better before a high-visibility event.
- [ ] Observe at least three first-time sessions without coaching. Record where
  players hesitate, misclick, ignore information, fail, or become engaged.
- [ ] Ask testers to explain the objective and controls in their own words;
  compare understanding with what the tutorial intended.
- [ ] Include players with different strategy-game familiarity and at least one
  keyboard-only and one controller-preferring player.
- [ ] If accessibility is publicly claimed, involve people who actually use the
  relevant accommodations; do not infer lived experience from automated checks.
- [ ] Have fluent humans review every shipped language for meaning, tone,
  truncation, idiom, and accidental offensiveness. Machine checks cover keys and
  layout, not translation quality.
- [ ] Test the packaged build on at least three real Windows systems spanning
  integrated and discrete graphics, common display scaling, and different audio
  devices. Include a clean machine that has not run a Rust development build.
- [ ] Test at least one Xbox-style controller and any other controller type the
  store page promises.
- [ ] Check antivirus/SmartScreen presentation and decide whether unsigned-build
  friction is acceptable. If code signing is desired, a human must purchase and
  control the certificate/identity process.
- [ ] Review tester recordings/reports and decide which repeated experience
  problems are release blockers versus accepted scope.

## Final human go/no-go checklist

Do not release solely because a date was announced.

- [ ] Personally run the exact uploaded release candidate from install to the end
  of the demo, including settings, pause, failure/retry, save/reload, and exit.
- [ ] Confirm the uploaded build ID/hash matches the approved candidate.
- [ ] Confirm hosted CI and all local release gates are green on that commit.
- [ ] Review every open blocker, critical, and high-severity issue. Explicitly
  document any accepted high-severity risk and its player workaround.
- [ ] Confirm the page's screenshots/video/copy contain only features present in
  the demo and that any full-game references are clearly labeled.
- [ ] Confirm license notices, asset provenance, credits, privacy statement, and
  content survey match the shipped files.
- [ ] Confirm backups, rollback package, support access, announcement copy, and
  launch-week availability are ready.
- [ ] Confirm no credential, personal document, tax record, private tester data,
  or secret build is inside the public package/repository.
- [ ] Give explicit written go/no-go approval for the named build and date.
- [ ] Perform or explicitly authorize the final release/publish action.

## Human work during the first week

- [ ] Verify the public download and launch as a normal customer, not only through
  a privileged developer account.
- [ ] Monitor storefront discussions, reviews, support, crash reports supplied by
  players, and social channels at scheduled intervals.
- [ ] Respond empathetically to players and avoid promising fixes/dates that have
  not been assessed.
- [ ] Approve emergency hotfix scope and each replacement build; preserve the
  previous known-good build for rollback.
- [ ] Decide whether serious issues require disabling the demo, rolling back,
  changing store claims, or posting a public notice.
- [ ] After one week, review completion rate, common confusion, hardware issues,
  sentiment, wishlists/follows if available, and qualitative feedback. Decide
  whether the demo is good enough to market further or needs another iteration.

## What the human should not spend time doing

Unless personally desired, the human does not need to hand-edit build scripts,
resize every store asset, write repetitive test cases, compile packages, prepare
release notes, deduplicate bug reports, or manually copy upload commands. Those
are agent-owned tasks. Human time is best spent on product judgment, ownership,
accountability, firsthand play, relationships with testers/players, and the few
store controls that legally or commercially bind the publisher.

