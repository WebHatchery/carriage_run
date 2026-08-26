use super::*;

fn overlaps(left: Rect, right: Rect) -> bool {
    left.x < right.right()
        && left.right() > right.x
        && left.y < right.bottom()
        && left.bottom() > right.y
}

#[test]
fn touch_controls_stay_inside_the_playfield_and_above_the_bottom_hud() {
    for rect in [
        touch_steer_left_rect(),
        touch_steer_right_rect(),
        touch_brake_rect(),
        touch_boost_rect(),
    ] {
        assert!(rect.y >= PLAY_TOP);
        assert!(rect.bottom() <= PLAY_BOTTOM);
    }
}

#[test]
fn touch_controls_do_not_overlap_each_other() {
    let controls = [
        touch_steer_left_rect(),
        touch_steer_right_rect(),
        touch_brake_rect(),
        touch_boost_rect(),
    ];
    for (index, left) in controls.iter().enumerate() {
        for right in controls.iter().skip(index + 1) {
            assert!(!overlaps(*left, *right));
        }
    }
}

#[test]
fn touch_control_hit_testing_matches_the_visible_targets() {
    assert!(touch_controls_contain(touch_steer_left_rect().center()));
    assert!(touch_controls_contain(touch_boost_rect().center()));
    assert!(!touch_controls_contain(vec2(640.0, 360.0)));
}

#[test]
fn keyboard_binding_labels_also_name_visible_controls() {
    assert!(settings_aux::STEERING_BINDING_LABEL.contains("LEFT / RIGHT"));
    assert!(settings_aux::RECOVERY_BINDING_LABEL.contains("REPAIR / Save / Load"));
}

#[test]
fn recovery_instruction_names_its_visible_exit_button() {
    assert!(RECOVERY_INSTRUCTION.contains(&RECOVERY_EXIT_LABEL.to_uppercase()));
    let panel = Rect::new(210.0, 100.0, 860.0, 520.0);
    let button = recovery_exit_rect(panel);
    assert!(button.x >= panel.x && button.right() <= panel.right());
    assert!(button.y >= panel.y && button.bottom() <= panel.bottom());
}
