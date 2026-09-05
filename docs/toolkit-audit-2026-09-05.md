# Toolkit migration — 5 September 2026

C1 now uses BackupChain with SlotSaveStore and the existing campaign,
campaign_backup_1, campaign_backup_2 and campaign_backup_3 slot identities.
The adapter retains native save paths and browser qualified/legacy reads.
Rotation preserves raw envelopes and version metadata, writes primary last,
and propagates backup failure instead of silently discarding it. Invalid or
future-version primaries block replacement. Recovery selects the newest
decodable copy without rewriting the primary; schema migrations remain local.

Tests cover three-generation ordering, fallback recovery, failed writes,
corrupt-primary protection and future-version rejection. Shared adapter tests
verify compatibility with ordinary slot reads and exact old envelope bytes.

Also labeled the remaining texture-manifest parse. Content, audio, input,
settings, localization and other existing toolkit integration remain in place.

Validation: 146 game checks pass with one existing ignored; 401 toolkit checks;
formatting, strict Clippy and source-size limits pass. Default Windows/WebGL
Preview publishing passed. A clean-commit publish is recorded in the progress
ledger to resolve the publisher's uncommitted-provenance warning.
