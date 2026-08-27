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
requested 1280×720, 1920×1080, and wide 1920×800 outer-window sizes. It writes
captures and raw per-case timing and process-memory records beneath
`dist/performance/`, plus a combined machine-labelled record at
`dist/performance/carriage_run_performance_capture.json`.

Use `-SkipBuild` only after publishing the same source state. The script accepts
an explicitly labelled `<HEAD>-dirty` development capture, rejects any other
provenance mismatch, and rejects incomplete sample counts. Only a clean commit
is valid release-candidate evidence.

Windows decorations can make the drawable surface smaller than the requested
outer window, so each case records both sizes. The runner also rejects duplicate
drawable surfaces; this prevents an oversized request capped by the active
monitor from masquerading as a distinct ultrawide benchmark. Exact native
1920×1080 framebuffer evidence is handled separately by
`PC_DEMO_VISUAL_CAPTURE_EVIDENCE.md`.

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

## Current clean regression baseline

Captured on 2026-08-27 from source
`62d332bdafcd0e102d28ebec2d9795a47d6baeed`, toolkit
`1ea59565e144d8da4deffd187bcd6d2bb657b504`, and Windows archive SHA-256
`4f530265afb7ebd2c5ddaa632b7e25b1994e565be5b11316b75d5d444a5bb2c1`.
The host was a Ryzen 7 5800X with an RTX 4080 SUPER on Windows 11 Pro Insider
Preview. Values are not transferable to a minimum-PC claim.

| Case | Requested outer window | Measured drawable | Worst scene steady combined CPU p95 | Sampled / OS peak working set |
| --- | ---: | ---: | ---: | ---: |
| 720p | 1280×720 | 1264×681 | 0.796 ms | 311.7 / 313.9 MiB |
| 1080p | 1920×1080 | 1904×1022 | 0.697 ms | 597.3 / 597.3 MiB |
| Wide | 1920×800 | 1904×761 | 0.806 ms | 644.7 / 644.7 MiB |

The wide batch had the largest recorded working set and CPU p95 in this run.
That is an observation for later same-host comparisons, not evidence of a leak
or a failure threshold.

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
