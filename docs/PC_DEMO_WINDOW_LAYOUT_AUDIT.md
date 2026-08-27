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
