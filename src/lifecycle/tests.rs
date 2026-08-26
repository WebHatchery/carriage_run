use super::*;

#[test]
fn losing_focus_disarms_input_immediately() {
    let mut state = ActivityState::new();
    let frame = state.observe(false, true);

    assert!(frame.focus_lost);
    assert!(!frame.focused);
    assert!(!frame.input_enabled);
}

#[test]
fn focus_restore_waits_for_every_control_to_be_released() {
    let mut state = ActivityState::new();
    state.observe(false, false);

    let held = state.observe(true, false);
    assert!(held.focused);
    assert!(!held.input_enabled);
    assert!(!held.focus_lost);

    let neutral = state.observe(true, true);
    assert!(neutral.input_enabled);
}

#[test]
fn an_active_neutral_window_stays_armed() {
    let mut state = ActivityState::new();
    let frame = state.observe(true, true);

    assert!(frame.focused);
    assert!(frame.input_enabled);
    assert!(!frame.focus_lost);
}
