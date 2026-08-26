use super::*;

#[test]
fn first_route_actions_name_visible_controls_or_direct_gestures() {
    assert!(FIRST_ROUTE_LESSONS[0].contains("Tap LEFT or RIGHT"));
    assert!(FIRST_ROUTE_LESSONS[2].starts_with("Drag a guard"));
    assert!(FIRST_ROUTE_LESSONS[3].starts_with("Tap a guard"));
    assert!(FIRST_ROUTE_LESSONS[4].starts_with("Drag a ranged guard"));
    assert!(FIRST_ROUTE_LESSONS[5].contains("Tap BRAKE"));
    assert!(FIRST_ROUTE_LESSONS[6].contains("Hold BOOST"));
}

#[test]
fn gameplay_instructions_do_not_require_keyboard_commands() {
    for instruction in FIRST_ROUTE_LESSONS
        .iter()
        .copied()
        .chain([ACTIVE_BREAKOUT_INSTRUCTION])
    {
        for forbidden in ["Press ", " key", "WASD", "arrow key", "Escape", "Spacebar"] {
            assert!(
                !instruction.contains(forbidden),
                "player instruction contains keyboard-only wording: {instruction}"
            );
        }
    }
}

#[test]
fn breakout_instruction_names_both_visible_recovery_actions() {
    assert!(ACTIVE_BREAKOUT_INSTRUCTION.contains("Tap BRAKE"));
    assert!(ACTIVE_BREAKOUT_INSTRUCTION.contains("guard"));
}
