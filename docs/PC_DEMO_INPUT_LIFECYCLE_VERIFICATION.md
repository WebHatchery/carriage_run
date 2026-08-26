# Carriage Run PC demo input and lifecycle verification

Status: engineering evidence and exact-build manual procedure. This does not
replace testing with real controllers, audio devices, displays, or sleep states.

## Implemented release protections

- Desktop builds poll the first connected controller through the shared native
  `gamepads`/`gilrs` backend; WebGL keeps its existing Gamepad API path.
- Menu directions remain edge-triggered while steering, braking, and boosting
  use held D-pad or left-stick state.
- Losing window focus immediately mutes already-playing music, rejects stale
  UI/gameplay input, and pauses an active mission.
- Restored focus does not accept input until mouse, bound keys, direction keys,
  and controller controls have returned to neutral. This prevents a focus click
  or a key released in another application from steering the carriage.
- Controller disconnect/reconnect changes the visible controller state. A
  disconnect during play pauses the mission and names the remaining visible
  control path.
- The title and recovery EXIT GAME controls and the Windows close button share
  one shutdown route. Pending autosave-enabled campaign changes receive a final
  save attempt before the process exits; failures are written to diagnostics.
- Live master/music changes and focus state adjust the current music loop rather
  than affecting only sounds started later.

Unit tests prove the deterministic focus state machine disarms on loss and
waits for neutral input after restoration. Shared-toolkit tests pin controller
deadzone direction mapping and distinguish edge directions from held gameplay
state. These tests cannot prove a physical device, driver, audio endpoint, or
Windows shell transition works.

## Exact-candidate manual procedure

Use the packaged executable extracted by `smoke_windows_package.ps1`, not a
development run. Start with a disposable save slot and record the archive hash,
build commit, Windows build, GPU/driver, display scale, audio device, controller
model/connection type, and tester.

1. Start a route with keyboard/mouse. Hold a steering key, Alt-Tab away, and
   release it outside the game. Confirm audio becomes silent and the route is
   paused. Return, release every control, tap RESUME, and confirm steering is
   neutral until deliberately pressed.
2. Repeat using a held controller stick and D-pad direction. Confirm neither
   produces a stuck direction after returning.
3. While music is audible, cycle master and music volume through every value.
   Confirm the current loop changes immediately and zero is silent. Restore the
   prior value and confirm playback returns without overlapping loops.
4. Complete the critical path with the controller only: launch, new campaign,
   tutorial, route choice, loadout, driving and guard commands, upgrade, pause,
   settings, failure, retry, demo end, replay, and exit. Record every action
   that still requires a pointer or keyboard as a blocker rather than coaching
   around it.
5. Disconnect the controller during driving. Confirm the game pauses, the
   message is actionable, visible mouse/touch controls remain available, and a
   reconnected controller is recognized without restarting.
6. Toggle windowed/fullscreen repeatedly, move the window between available
   monitors, and repeat Alt-Tab at each supported display scale. Check rendering,
   pointer mapping, input, audio, and frame pacing after every transition.
7. Make a campaign change that triggers autosave, then immediately use EXIT
   GAME. Relaunch and verify it persisted. Repeat using the window close button.
   Confirm the process exits without a lingering child process or new crash log.
8. With a disposable slot, repeat suspend/resume and audio-device removal where
   the machine supports them. Verify saves remain parseable and document any
   device-specific audio recovery limitation.

## Result record

| Field | Result |
| --- | --- |
| Artifact filename / SHA-256 / commit | |
| Windows build / account privilege | |
| GPU / driver / monitors / DPI | |
| Audio device(s) | |
| Controller model / connection | |
| Keyboard focus-loss and neutral re-arm | Pass / Fail / Not run |
| Controller focus-loss and neutral re-arm | Pass / Fail / Not run |
| Live volume and mute/restore | Pass / Fail / Not run |
| Disconnect/reconnect recovery | Pass / Fail / Not run |
| Window/fullscreen/monitor transitions | Pass / Fail / Not run |
| EXIT GAME final save and clean process exit | Pass / Fail / Not run |
| Window-close final save and clean process exit | Pass / Fail / Not run |
| Sleep/resume and audio-device change | Pass / Fail / Not available |
| Crash logs or save-integrity findings | |
| Issue IDs / evidence paths | |
| Tester / UTC timestamp | |

Attach this record to the RC checklist. Do not mark controller-only, focus,
audio recovery, or clean shutdown complete based solely on compilation or unit
tests.
