use super::*;

#[test]
fn runtime_columns_stay_inside_the_settings_panel() {
    let panel = Rect::new(640.0, 386.0, 600.0, 298.0);
    let columns = runtime_columns(panel);

    assert!(columns[0].x >= panel.x);
    assert!(columns[0].right() < columns[1].x);
    assert!(columns[1].right() <= panel.right());
    assert!(panel.bottom() <= super::super::LOGICAL_HEIGHT);

    let final_row = panel.y + 54.0 + 6.0 * 32.0;
    assert!(final_row + 28.0 <= panel.bottom());
}
