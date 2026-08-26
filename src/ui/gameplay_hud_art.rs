//! Ornamental frames and pictograms shared by the active mission HUD.

use super::upgrade_visuals::{GOLD, GOLD_SOFT, MUTED};
use macroquad::prelude::*;

const ICON_DARK: Color = Color::new(0.045, 0.035, 0.025, 0.98);

pub(super) fn draw_ornate_frame(rect: Rect) {
    draw_rectangle_lines(rect.x, rect.y, rect.w, rect.h, 2.0, GOLD_SOFT);
    for (x, y, sx, sy) in [
        (rect.x, rect.y, 1.0, 1.0),
        (rect.right(), rect.y, -1.0, 1.0),
        (rect.x, rect.bottom(), 1.0, -1.0),
        (rect.right(), rect.bottom(), -1.0, -1.0),
    ] {
        draw_line(x, y, x + sx * 22.0, y, 3.0, GOLD);
        draw_line(x, y, x, y + sy * 22.0, 3.0, GOLD);
        draw_line(
            x + sx * 6.0,
            y + sy * 6.0,
            x + sx * 22.0,
            y + sy * 22.0,
            2.0,
            GOLD_SOFT,
        );
    }
}

pub(super) fn draw_round_icon(pos: Vec2, icon: &str) {
    draw_circle(pos.x, pos.y, 26.0, Color::new(0.12, 0.10, 0.07, 1.0));
    draw_circle_lines(pos.x, pos.y, 26.0, 2.0, GOLD_SOFT);
    match icon {
        "cargo" => {
            draw_rectangle(
                pos.x - 12.0,
                pos.y - 8.0,
                24.0,
                18.0,
                Color::new(0.55, 0.34, 0.14, 1.0),
            );
            draw_line(pos.x - 12.0, pos.y - 8.0, pos.x, pos.y - 16.0, 2.0, GOLD);
            draw_line(pos.x + 12.0, pos.y - 8.0, pos.x, pos.y - 16.0, 2.0, GOLD);
        }
        _ => {
            draw_rectangle(
                pos.x - 14.0,
                pos.y - 9.0,
                28.0,
                18.0,
                Color::new(0.48, 0.29, 0.12, 1.0),
            );
            draw_circle(pos.x - 10.0, pos.y + 12.0, 5.0, ICON_DARK);
            draw_circle(pos.x + 10.0, pos.y + 12.0, 5.0, ICON_DARK);
        }
    }
}

pub(super) fn draw_button_icon(icon: &str, pos: Vec2, enabled: bool) {
    let color = if enabled { GOLD } else { MUTED };
    if icon == "pause" {
        draw_rectangle(pos.x - 8.0, pos.y - 13.0, 6.0, 26.0, color);
        draw_rectangle(pos.x + 4.0, pos.y - 13.0, 6.0, 26.0, color);
    } else {
        draw_line(
            pos.x - 12.0,
            pos.y + 11.0,
            pos.x + 11.0,
            pos.y - 12.0,
            5.0,
            color,
        );
        draw_circle(pos.x - 12.0, pos.y + 11.0, 5.0, color);
        draw_rectangle(pos.x + 7.0, pos.y - 15.0, 8.0, 8.0, color);
    }
}
