# Carriage Run PC demo performance capture

Prepared: 2026-08-27  
Status: repeatable developer-host regression evidence; not a system-requirement
or clean-machine compatibility result

## Run

From the project directory:

```powershell
.\scripts\capture_performance.ps1
```

The script builds the Windows release through the project publisher, then runs
deterministic `gameplay`, `map`, and `settings` scenes for 300 frames each at
1280×720, 1920×1080, and 2560×1080. It writes captures and raw per-case timing
and process-memory records beneath `dist/performance/`, plus a combined
machine-labelled record at
`dist/performance/carriage_run_performance_capture.json`.

Use `-SkipBuild` only after publishing the same source state. The script accepts
an explicitly labelled `<HEAD>-dirty` development capture, rejects any other
provenance mismatch, and rejects incomplete sample counts. Only a clean commit
is valid release-candidate evidence.

## What the numbers mean

Each frame records CPU time spent in the deterministic game update and in
submitting draw commands. The first sample follows a capture-only scene and
framebuffer transition, so it is reported separately as
`capture_transition_cpu_ms`; it is not mixed into steady-state percentiles. The
remaining samples provide mean, minimum, median, p95, p99, and maximum values
for update, draw submission, and their sum. Comparing the same scene and
resolution between commits can expose obvious CPU regressions.

The process reports add the largest 25 ms sampled working set and Windows'
lifetime peak working set for each whole three-scene capture process. Those
figures include loaded assets, renderer/runtime overhead, and the capture
framebuffers; they are useful only as same-host regression markers. They are not
Rust heap measurements and a short deterministic batch cannot establish that a
full play session is leak-free.

The measurements intentionally exclude:

- GPU execution and presentation;
- VSync waits and end-to-end frame pacing;
- interactive input and normal operating-system scheduling;
- thermal throttling, battery behavior, and long-session memory growth; and
- storefront overlays, capture software, unusual DPI, multi-monitor changes,
  sleep/resume, or background workloads.

Consequently, a low CPU p95 does not prove 60 FPS, a minimum GPU, or a supported
PC specification. Those claims still require the external-machine matrix in
`PC_DEMO_WINDOWS_COMPATIBILITY_BASELINE.md`.

## Review procedure

1. Retain the combined JSON with the exact RC commit and package hash.
2. Compare each scene/resolution against the previous known-good capture on the
   same machine, power mode, driver, and display configuration.
3. Investigate a repeatable material increase in p95/p99 or a new maximum spike;
   recapture before attributing it to code.
4. Inspect the generated screenshots to ensure the benchmark scene is the
   intended state rather than a recovery screen or missing-asset fallback.
5. Record actual frame pacing, GPU utilization, memory, temperatures, and full
   demo behavior separately on the physical compatibility machines.

No fixed pass threshold is declared yet. Establish one only after an approved
demo slice and representative low/recommended systems have complete-session
evidence.
