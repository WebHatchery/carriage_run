# Carriage Run PC demo window-layout audit

Prepared: 2026-08-27  
Status: repeatable local layout evidence; physical DPI testing remains required

## Run

From the project directory:

```powershell
.\scripts\audit_window_layouts.ps1
```

The audit publishes a Windows release, then captures all eight deterministic
release scenes in 16:9, 16:10, wide, and small-window stress cases. It records
the requested outer-window dimensions, actual drawable dimensions, image sizes,
and SHA-256 hashes beneath `dist/window_layout_audit/`.

The runner fails if build provenance does not match the source tree, scenes in
one batch disagree about their drawable size, or two nominal cases collapse to
the same surface because the active monitor capped a request.

## Current clean baseline

The 2026-08-27 run used source
`c295af92c8300cdb6f1395b8879f912be805b8ee`, toolkit
`1ea59565e144d8da4deffd187bcd6d2bb657b504`, and Windows archive SHA-256
`5f30a09293c1d92b157d59cd9084cd78e1c2fd95e992f3c682cd9aa20e666de4`.

| Case | Requested outer window | Measured drawable | Authored scenes |
| --- | ---: | ---: | ---: |
| 16:9 | 1280×720 | 1264×681 | 8 |
| 16:10 | 1280×800 | 1264×761 | 8 |
| Wide | 1920×800 | 1904×761 | 8 |
| Small stress | 800×600 | 784×561 | 8 |

Visual review of the map, Settings, and gameplay captures at the non-baseline
shapes found no clipped panels or controls. The fixed 1280×720 canvas was
letterboxed as intended. The small-window output remains visually dense and is
retained only as stress evidence.

## Scope boundary

This audit can expose clipping, overlap, unintended wrapping, and aspect-ratio
mistakes in deterministic authored states. It does not simulate Windows display
scaling at 100%, 125%, 150%, or 200%; moving between monitors; a changed desktop
resolution; GPU/driver presentation; or interactive hit-target behavior. Those
remain physical checks in `PC_DEMO_WINDOWS_COMPATIBILITY_BASELINE.md` and the
release-candidate checklist.

The small-window case is a stress test, not a promise that its resolution is a
supported minimum. Public minimum-resolution claims still require the approved
demo and external-machine evidence.
