# Carriage Run demo screenshot evidence

Recorded: 2026-08-27

All images below were produced by the native screenshot harness from a release
binary compiled with Cargo feature `demo`. They were read back from disk,
verified as exact 1920×1080 PNGs, and visually inspected for clipping,
diagnostic overlays, accidental full-only content, and duplicate states.

| File | State | Size | SHA-256 |
| --- | --- | ---: | --- |
| `docs/verification/demo_title.png` | Demo-labelled title | 1920×1080 | `7ebf8a02a9693bd9b136b1cbab953096c55ef48195fe0128e0326ddd7b01877e` |
| `docs/verification/demo_map.png` | First fork route map | 1920×1080 | `6b1b1b82ddb96c5e67580530b727c62d38f0abebe96bb5b5d87286f0425bd18d` |
| `docs/verification/demo_loadout.png` | Muddy Road loadout | 1920×1080 | `527b4e0fd5c51eca596520c18f4d623606b2fc928d279c21ba6ecec5a9654df8` |
| `docs/verification/demo_gameplay.png` | Visible-control tutorial | 1920×1080 | `a1c44174cd9d13fd2d612f0817a7c95d2fa5eb7779a7993b331df56b671151e3` |
| `docs/verification/demo_bandit_gameplay.png` | Bandit Bend live encounter | 1920×1080 | `ba59ffa0170ea0a13dad1806591f8193abf26896a837aec131979993a969a8be` |
| `docs/verification/demo_courier_gameplay.png` | Courier Deadline live encounter | 1920×1080 | `c62277793502298652d218d883ae8320f8c9211780da8801554df78fd78fd653` |
| `docs/verification/demo_bonebridge_gameplay.png` | Bonebridge undead encounter | 1920×1080 | `fe426e46ca1f4a20f76a75d3a8081c19160848b72bc6d9b58b0418206e81592c` |
| `docs/verification/demo_end.png` | End of Demo | 1920×1080 | `683ee7eab08fed1363aea95711a4d4120d34236113912c6249dca1a6ea01d6f3` |

The capture path deliberately ignores synthetic focus-loss events while a
capture manifest is active. Normal play still pauses on real focus loss. This
prevents a hidden fullscreen capture from adding a pause modal or focus warning
to otherwise valid media.

These are engineering/source captures, not approved storefront media. Selection,
cropping, captions, and creative approval remain human/storefront gates. No
upload or public-use authorization is implied.
