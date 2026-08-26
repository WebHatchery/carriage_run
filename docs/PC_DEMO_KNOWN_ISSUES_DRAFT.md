# Carriage Run PC demo known-issues draft

Status: internal release input, not player-facing copy. Replace this document
with exact release-candidate findings after external testing. “No report” is not
evidence that an environment works.

## Open release blockers and unverified risks

| ID | Status | Scope | Player impact / required evidence |
| --- | --- | --- | --- |
| DEMO-001 | Blocked on publisher decision | Product boundary | No demo build exists yet; current Windows package contains the full campaign. Approve the slice, storefront, and save-transfer policy before implementation. |
| DEMO-002 | External verification required | Hosted CI | Local CI-equivalent gates pass, but the fixed workflow must be pushed and green on the exact RC commit. |
| DEMO-003 | External verification required | Windows compatibility | Clean installs, standard-user execution, DPI range, integrated/discrete GPUs, SmartScreen/antivirus, controller families, sleep/resume, and long-session save integrity are not yet evidenced. |
| DEMO-004 | Human testing required | Onboarding and feel | Five independent target-player sessions, including uncoached keyboard and controller paths, have not been completed. |
| DEMO-005 | Human review required | Languages | Automated English/German/French data checks pass, but fluent human meaning, tone, idiom, clipping, and offensiveness review remains outstanding. |
| DEMO-006 | Publisher/legal review required | Public claims | Support contact, privacy URL, credits, asset provenance, store copy/media, content answers, and legal representations are not approved. |
| DEMO-007 | Open engineering risk | Build disclosure | The native release binary contains compiler source paths, including build-account path fragments. No runtime collection occurs, but path remapping must be addressed or explicitly accepted before public release. |

The release recommendation remains **NO-GO** while any row above is unresolved.

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
