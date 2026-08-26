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
