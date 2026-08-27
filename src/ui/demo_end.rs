//! The contained demo finale shown after a successful Bonebridge crossing.

use super::upgrade_visuals::{draw_panel, GOLD as UI_GOLD, INK, MUTED};
use super::widgets::{draw_menu_backdrop, virtual_button};
use super::{UiAction, UiContext};
use macroquad::prelude::*;
use macroquad_toolkit::prelude::*;

pub(super) fn draw_demo_end(_ctx: &UiContext<'_>, mouse: Vec2, actions: &mut Vec<UiAction>) {
    draw_menu_backdrop(118.0);
    let panel = Rect::new(292.0, 76.0, 696.0, 568.0);
    draw_panel(panel, true);

    draw_text_centered_in_box(
        "End of Demo",
        panel.x + 48.0,
        panel.y + 38.0,
        panel.w - 96.0,
        58.0,
        42.0,
        INK,
    );
    draw_text_centered_in_box(
        "Bonebridge Pass is clear",
        panel.x + 48.0,
        panel.y + 108.0,
        panel.w - 96.0,
        34.0,
        23.0,
        UI_GOLD,
    );
    draw_text_centered_in_box(
        "You kept the lantern lit through the first fork of Carriage Run.",
        panel.x + 56.0,
        panel.y + 166.0,
        panel.w - 112.0,
        34.0,
        18.0,
        MUTED,
    );
    draw_text_centered_in_box(
        "Replay to take the other contract, try a new route, or test another upgrade.",
        panel.x + 56.0,
        panel.y + 208.0,
        panel.w - 112.0,
        48.0,
        17.0,
        MUTED,
    );
    draw_text_centered_in_box(
        "Demo progress is stored separately. No full-game transfer promise has been made.",
        panel.x + 56.0,
        panel.y + 280.0,
        panel.w - 112.0,
        48.0,
        16.0,
        MUTED,
    );
    draw_text_centered_in_box(
        "Wishlist and feedback links will appear after the storefront is approved.",
        panel.x + 56.0,
        panel.y + 338.0,
        panel.w - 112.0,
        42.0,
        15.0,
        UI_GOLD,
    );

    let y = panel.bottom() - 82.0;
    if virtual_button(
        Rect::new(panel.x + 52.0, y, 180.0, 46.0),
        "Replay Demo",
        true,
        ButtonTone::Primary,
        mouse,
    ) {
        actions.push(UiAction::RequestDemoReplay);
    }
    if virtual_button(
        Rect::new(panel.x + 258.0, y, 180.0, 46.0),
        "Title",
        true,
        ButtonTone::Secondary,
        mouse,
    ) {
        actions.push(UiAction::ReturnTitle);
    }
    if virtual_button(
        Rect::new(panel.x + 464.0, y, 180.0, 46.0),
        "Exit Game",
        true,
        ButtonTone::Muted,
        mouse,
    ) {
        actions.push(UiAction::ExitGame);
    }
}
