# Carriage Run PC demo known-issues draft

Status: internal release input, not player-facing copy. Replace this document
with exact release-candidate findings after external testing. “No report” is not
evidence that an environment works.

## Open release blockers and unverified risks

| ID | Status | Scope | Player impact / required evidence |
| --- | --- | --- | --- |
| DEMO-001 | Blocked on publisher decision | Product boundary | No demo build exists yet; current Windows package contains the full campaign. Approve the slice, storefront, and save-transfer policy before implementation. |
| DEMO-002 | External verification required | Hosted CI | Local CI-equivalent gates pass, but the fixed workflow must be pushed and green on the exact RC commit. |
| DEMO-003 | External verification required | Windows compatibility | Automated standard-user path extraction and Defender evidence pass. Native gamepad polling, held movement, focus-loss pause/mute, input re-arming, disconnect recovery, and final-save shutdown protections are implemented, but real controller families, DPI range, integrated/discrete GPUs, SmartScreen, audio devices, sleep/resume, and long-session save integrity still require physical-system evidence. |
| DEMO-004 | Human testing required | Onboarding and feel | Five independent target-player sessions, including uncoached keyboard and controller paths, have not been completed. |
| DEMO-005 | Human review required | Languages | Automated English/German/French data checks pass, but fluent human meaning, tone, idiom, clipping, and offensiveness review remains outstanding. |
| DEMO-006 | Publisher/legal review required | Public claims | Support contact, privacy URL, credits, asset provenance, store copy/media, content answers, and legal representations are not approved. |

The release recommendation remains **NO-GO** while any row above is unresolved.

## Resolved engineering risks

| ID | Resolution | Regression evidence |
| --- | --- | --- |
| DEMO-007 | Release publishing remaps workspace and build-profile roots while retaining source-relative panic locations. | Run `scripts/audit_release_paths.ps1` against every exact candidate; it rejects known checkout roots and generic Windows/Linux user-profile paths in packaged executables. |

## Candidate issue format

Add one row per player-visible issue confirmed in the exact candidate:

| ID | Affected build(s) | Severity/frequency | Symptom | Workaround | Status/owner |
| --- | --- | --- | --- | --- | --- |
| _None recorded yet_ | | | External RC testing has not started. | | |

Every accepted issue must identify the exact build, affected supported
environment, player-visible wording, safe workaround, fix/defer decision,
approval owner, and retest result. Do not publish internal paths, exploit detail,
private tester data, unsupported speculation, or a workaround that asks players
to disable security software.

## Candidate closeout

Before publication:

- remove fixed items and move their verification evidence to the RC record;
- distinguish limitations by design from defects;
- verify every workaround on the uploaded storefront build;
- link the final player-facing list from support copy and release notes;
- record zero known issues only after the full test matrix, not because the
  table is empty; and
- obtain human approval for every accepted high-severity issue.
