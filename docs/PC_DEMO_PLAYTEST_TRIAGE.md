# Carriage Run PC demo playtest triage

Prepared: 2026-08-27  
Status: intake and ranking procedure; no external tester reports exist yet

## Intake

Copy `PC_DEMO_PLAYTEST_REPORT_TEMPLATE.json` once per observed session, replace
every placeholder, and save the completed files outside version control under
`dist/playtest_reports/inbox/`. Use tester codes, not names or email addresses.
Do not paste raw recordings, unrelated logs, full user-data folders, credentials,
or private contact details into a report.

Each report binds findings to a full source revision and package SHA-256. An
issue records observed expected/actual behavior, minimal reproduction steps,
critical-path association, player recovery, and evidence references. Use the
categories to distinguish software defects from comprehension, compatibility,
accessibility, performance, and content feedback.

## Aggregate

Run:

```powershell
.\scripts\triage_playtest_reports.ps1
```

The script validates every report and writes ignored JSON and Markdown summaries
under `dist/playtest_reports/`. It rejects malformed candidate identities,
duplicate IDs, invalid controlled fields, issues without reproduction steps,
unverified “verified” records, and deferred blocker/critical/high issues without
an acceptance owner and rationale.

Reports are joined only when an observer supplies the same non-empty
`duplicate_group`. Similar wording is never treated as proof of a shared root
cause. Groups are ranked by worst severity, number of independent tester codes,
then strongest reported reproducibility. The ranking helps order investigation;
it cannot accept risk, close a defect, establish prevalence, or replace review
of the source reports and evidence.

If reports cover more than one candidate identity, the summary says so. Split
the input by candidate before making a release decision rather than blending old
and new behavior into one apparent result.
