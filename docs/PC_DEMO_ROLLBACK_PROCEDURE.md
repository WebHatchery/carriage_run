# Carriage Run PC demo rollback procedure

Status: operational draft; storefront account owners and final destinations
must be supplied before release. This procedure changes which already-approved
build is offered to players. It does not authorize an upload, visibility
change, public announcement, or deletion.

## Required records before launch

Keep one immutable evidence folder per candidate outside the public download
directory. Its name should include RC number, version, channel, and short
commit. Retain at least the live candidate and the last known-good candidate.
Each folder must contain:

- the original Windows ZIP, `.sha256` sidecar, JSON release manifest, and
  `carriage_run_build_info.json`;
- publisher output, automated-gate output, hosted-CI link, and clean-machine
  critical-path result;
- storefront build/depot ID and branch/channel name;
- completed release-candidate checklist, known-issues record, human approval,
  and any public release notes;
- the save namespace/version and the tested forward/backward compatibility
  result between this candidate and the retained predecessor.

Record the storage owner, access method, retention period, and restore test in
the release issue. A local `dist` directory is build output, not durable backup.

## Roles and authority

- Incident lead: assesses severity and recommends continue, disable, or roll
  back.
- Build custodian: verifies hashes and supplies the retained package/build ID.
- Store operator: has minimum permission to change the live build or branch.
- Publisher approver: authorizes the user-visible change and public wording.
- Support owner: records affected players and publishes approved guidance.

One person may hold several roles, but names and a backup contact must be
recorded. Never place credentials, recovery codes, cookies, or private player
reports in the evidence folder or repository.

## Rollback triggers

Immediately assess rollback for any of these conditions in the uploaded build:

- launch/install failure affecting a material share of supported PCs;
- save loss, save corruption, wrong demo/full save namespace, or inability to
  finish the advertised critical path;
- a credential, private file, unlicensed asset, source/debug material, or full
  paid content shipped accidentally;
- a critical security/privacy discrepancy or unexpected network behavior;
- repeated blocker/critical crashes without a safe player workaround;
- incorrect executable/store association, demo boundary, or public build ID.

High-severity but recoverable defects require an explicit human decision using
player impact, affected population, workaround quality, save compatibility,
time to verified hotfix, and reputational/legal risk. A deadline alone is not a
reason to keep a harmful build live.

## Decision and preparation

1. Stop new release changes and open an incident record with UTC detection
   time, live store build ID, manifest hash, symptom, scope, and reporter.
2. Preserve the live package and evidence. Do not overwrite or delete it while
   investigating.
3. Reproduce where safe and classify the issue. For privacy/security exposure,
   restrict evidence access and do not ask players to post sensitive logs.
4. Select the last known-good build from the release record. Independently
   verify its ZIP against the retained SHA-256 and manifest.
5. Confirm its product identity, demo boundary, public links, supported
   languages, and store association still match the public page.
6. Test save behavior from the affected live build back to the proposed
   rollback build using copied profiles. If downgrade is unsafe, prepare clear
   data-preservation guidance and consider disabling downloads instead.
7. Run install, launch, new-game, resume, failure/retry, demo-end, and exit smoke
   tests on the retained build. Record tester, machine, UTC time, and result.
8. The incident lead writes a recommendation; the publisher approver records
   GO/NO-GO for the exact predecessor hash/build ID.

## Storefront execution

Use the storefront's supported build-history/branch controls to point the
public demo at the retained known-good build. Prefer changing the live mapping
to an already uploaded, verified build over creating a new package during the
incident.

For Steam, record the demo App ID, depot IDs, branch, previous live build ID,
replacement build ID, operator, and Steamworks UTC timestamp. Verify the demo
remains associated with the correct base game. For itch.io, record the project,
Windows channel, previous Butler build number, replacement build number,
operator, and UTC timestamp. Do not invent commands or identifiers; use the
account's current documented rollback control and supplied IDs.

If no safe retained build exists, the publisher decides whether to disable or
unlist the demo temporarily. That is safer than relabelling an unverified local
archive as known-good.

## Post-switch verification

1. Install from the public storefront as a normal customer on a clean profile;
   do not rely on a developer cache.
2. Record the downloaded executable/package identity from Credits and confirm
   the storefront build ID and retained manifest SHA-256.
3. Run the critical path and the issue-specific reproduction. Verify update and
   uninstall behavior and inspect existing saves without mutating the only copy.
4. Check the public page, download platform, executable flag, demo/base-game
   relationship, and version notes.
5. Publish only human-approved status/support wording. Never promise recovery or
   a hotfix date until verified.
6. Monitor reports on an assigned cadence and record whether impact stops.

## Closeout

Keep the incident open until the public download is independently verified and
support ownership is active. Record root cause, affected versions/build IDs,
timeline, player/save impact, decision reasoning, recovery steps, public
messages, and preventive action. A later hotfix is a new release candidate and
must pass the full checklist; it is not part of the rollback authorization.
