# Carriage Run PC demo visual-capture evidence

Capture date: 2026-08-27  
Status: local engineering evidence; not approved storefront media

## Result

The deterministic scene harness captured the eight authored release screens at
requested desktop (1280×720 outer window), requested touch-sized (960×540 outer
window), and native fullscreen (1920×1080 framebuffer) viewports. On this host,
the windowed drawable images are 1264×681 and 944×501 respectively because the
requested dimensions include Windows decoration. Every fullscreen file was read
back from disk and verified as exactly 1920×1080 before it replaced the matching
image in `docs/verification/`.

The refreshed evidence verifies that:

- the gameplay HUD and visible road controls no longer collide;
- the gameplay overlay uses PC-neutral “Road controls” wording;
- the mission-detail panel stays inside the fixed 1280×720 logical canvas when
  the physical framebuffer is 1920×1080;
- the Settings screen keeps its save, display, audio, binding, language, and
  navigation controls visible without clipped or vertically wrapped headings;
- release captures contain no startup diagnostic notification; and
- one release build is reused across all three viewport passes.

## Reproduction

From the project root:

```powershell
.\scripts\browser_smoke.ps1 -Frames 90
```

The wrapper uses the toolkit capture harness pinned in `toolkit.lock`. Its
fullscreen pass requests and reasserts fullscreen after runtime preferences
load, then rejects any output that is not exactly 1920×1080.

## Evidence set

The flat `docs/verification/` directory contains the following scene names for
each `smoke_desktop_*`, `smoke_touch_*`, and `smoke_fullscreen_*` prefix:

- `title`
- `map`
- `loadout`
- `shop`
- `guards`
- `upgrades`
- `settings`
- `gameplay`

## Limits

These deterministic captures prove framebuffer dimensions and the seeded UI
layouts on the local NVIDIA desktop host. They do not prove Windows DPI behavior,
ultrawide layout, integrated-GPU presentation, frame pacing, or store-media
approval. They are from the current full game because the product owner has not
yet approved a demo boundary. Final storefront screenshots must be recaptured
from the exact approved demo candidate and reviewed by the creative owner.
