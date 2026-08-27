//! Settings-side panels for save-slot management and display preferences.

use super::upgrade_visuals::{draw_panel, draw_section_label, GOLD, INK};
use super::widgets::virtual_button;
use super::{UiAction, UiContext};
use macroquad::prelude::*;
use macroquad_toolkit::prelude::*;
use macroquad_toolkit::ui::draw_ui_text_ex;

#[cfg(test)]
mod tests;

pub(super) const STEERING_BINDING_LABEL: &str = "Steer (LEFT / RIGHT)";
pub(super) const RECOVERY_BINDING_LABEL: &str = "Actions (REPAIR / Save / Load)";

pub(super) fn draw_settings_aux(ctx: &UiContext<'_>, mouse: Vec2, actions: &mut Vec<UiAction>) {
    if crate::release_mode::is_demo() {
        draw_demo_save_notice();
    } else {
        draw_save_slots(ctx, mouse, actions);
    }
    draw_runtime_preferences(ctx, mouse, actions);
}

fn draw_demo_save_notice() {
    let panel = Rect::new(640.0, 122.0, 600.0, 248.0);
    draw_panel(panel, true);
    draw_section_label("Demo Save", panel.x + 18.0, panel.y + 22.0, panel.w - 36.0);
    draw_text_block(
        "This demo autosaves to its own isolated campaign. It never lists, overwrites, migrates, or quarantines saves from the full game.",
        panel.x + 24.0,
        panel.y + 72.0,
        panel.w - 48.0,
        96.0,
        17.0,
        4.0,
        INK,
    );
    draw_ui_text_ex(
        "Progress transfer remains unpromised.",
        panel.x + 24.0,
        panel.bottom() - 38.0,
        TextStyle::new(15.0, GOLD).params(),
    );
}

fn draw_save_slots(ctx: &UiContext<'_>, mouse: Vec2, actions: &mut Vec<UiAction>) {
    let panel = Rect::new(640.0, 122.0, 600.0, 248.0);
    draw_panel(panel, true);
    draw_section_label("Save Slots", panel.x + 18.0, panel.y + 22.0, panel.w - 36.0);
    draw_ui_text_ex(
        &format!("Active: {}", ctx.active_save_slot),
        panel.x + 20.0,
        panel.y + 55.0,
        TextStyle::new(15.0, GOLD).params(),
    );
    let slot_width = (panel.w - 44.0) / 3.0;
    for (index, slot) in ctx.save_slots.iter().take(3).enumerate() {
        let active = slot == ctx.active_save_slot;
        if virtual_button(
            Rect::new(
                panel.x + 18.0 + index as f32 * (slot_width + 4.0),
                panel.y + 76.0,
                slot_width,
                38.0,
            ),
            slot,
            !active,
            if active {
                ButtonTone::Positive
            } else {
                ButtonTone::Secondary
            },
            mouse,
        ) {
            actions.push(UiAction::SelectSaveSlot(slot.clone()));
        }
    }
    let next = if ctx.save_slots.iter().any(|slot| slot == "slot_2") {
        "slot_3"
    } else {
        "slot_2"
    };
    if virtual_button(
        Rect::new(panel.x + 64.0, panel.bottom() - 66.0, 136.0, 38.0),
        "Create",
        true,
        ButtonTone::Positive,
        mouse,
    ) {
        actions.push(UiAction::CreateSaveSlot(next.to_owned()));
    }
    if virtual_button(
        Rect::new(panel.x + 232.0, panel.bottom() - 66.0, 136.0, 38.0),
        "Rename",
        true,
        ButtonTone::Secondary,
        mouse,
    ) {
        actions.push(UiAction::RenameSaveSlot("archive".to_owned()));
    }
    if virtual_button(
        Rect::new(panel.x + 400.0, panel.bottom() - 66.0, 136.0, 38.0),
        "Delete",
        ctx.save_slots.len() > 1,
        ButtonTone::Danger,
        mouse,
    ) {
        actions.push(UiAction::DeleteSaveSlot);
    }
}

fn draw_runtime_preferences(ctx: &UiContext<'_>, mouse: Vec2, actions: &mut Vec<UiAction>) {
    let panel = Rect::new(640.0, 386.0, 600.0, 298.0);
    draw_panel(panel, true);
    draw_section_label(
        "Display & Audio",
        panel.x + 18.0,
        panel.y + 22.0,
        panel.w - 36.0,
    );
    let settings = ctx.settings;
    let columns = runtime_columns(panel);
    let mut y = panel.y + 54.0;
    let mut column = columns[0];
    toggle_row(
        "fullscreen",
        &ctx.localization.display("settings.fullscreen"),
        settings.display.fullscreen,
        column,
        y,
        mouse,
        actions,
    );
    y += 32.0;
    toggle_row(
        "vsync",
        &ctx.localization.display("settings.vsync"),
        settings.vsync,
        column,
        y,
        mouse,
        actions,
    );
    y += 32.0;
    toggle_row(
        "colorblind_safe",
        &ctx.localization.display("settings.colorblind"),
        settings.colorblind_safe,
        column,
        y,
        mouse,
        actions,
    );
    y += 32.0;
    toggle_row(
        "reduced_motion",
        &ctx.localization.display("settings.reduced_motion"),
        settings.reduced_motion,
        column,
        y,
        mouse,
        actions,
    );
    y += 32.0;
    toggle_row(
        "drag_toggle",
        &ctx.localization.display("settings.drag_mode"),
        matches!(
            settings.drag_preference,
            crate::settings::DragPreference::Toggle
        ),
        column,
        y,
        mouse,
        actions,
    );
    y += 32.0;
    cycle_row(
        "resolution",
        &ctx.localization.display("settings.resolution"),
        &settings.resolution,
        column,
        y,
        mouse,
        actions,
    );
    y += 32.0;
    cycle_row(
        "fps",
        &ctx.localization.display("settings.fps_cap"),
        &settings.fps_cap.to_string(),
        column,
        y,
        mouse,
        actions,
    );
    column = columns[1];
    y = panel.y + 54.0;
    cycle_row(
        "text_size",
        &ctx.localization.display("settings.text_size"),
        &format!("{:.1}x", settings.text_size),
        column,
        y,
        mouse,
        actions,
    );
    y += 32.0;
    cycle_row(
        "master_volume",
        "Master volume",
        &percent(settings.display.master_volume),
        column,
        y,
        mouse,
        actions,
    );
    y += 32.0;
    cycle_row(
        "sfx_volume",
        "SFX volume",
        &percent(settings.display.sfx_volume),
        column,
        y,
        mouse,
        actions,
    );
    y += 32.0;
    cycle_row(
        "music_volume",
        "Music volume",
        &percent(settings.display.music_volume),
        column,
        y,
        mouse,
        actions,
    );
    y += 32.0;
    cycle_row(
        "steering",
        STEERING_BINDING_LABEL,
        &format!(
            "{} / {}",
            settings.bindings.steer_left, settings.bindings.steer_right
        ),
        column,
        y,
        mouse,
        actions,
    );
    y += 32.0;
    cycle_row(
        "recovery",
        RECOVERY_BINDING_LABEL,
        &format!(
            "{} / {} / {}",
            settings.bindings.repair, settings.bindings.save, settings.bindings.load
        ),
        column,
        y,
        mouse,
        actions,
    );
    y += 32.0;
    cycle_row(
        "language",
        "Language",
        crate::localization::Language::from_id(&settings.language).id(),
        column,
        y,
        mouse,
        actions,
    );
}

fn runtime_columns(panel: Rect) -> [Rect; 2] {
    let gap = 16.0;
    let width = (panel.w - 36.0 - gap) * 0.5;
    [
        Rect::new(panel.x + 18.0, panel.y, width, panel.h),
        Rect::new(panel.x + 18.0 + width + gap, panel.y, width, panel.h),
    ]
}

fn toggle_row(
    id: &str,
    label: &str,
    enabled: bool,
    panel: Rect,
    y: f32,
    mouse: Vec2,
    actions: &mut Vec<UiAction>,
) {
    draw_ui_text_ex(label, panel.x, y + 16.0, TextStyle::new(13.0, INK).params());
    if virtual_button(
        Rect::new(panel.right() - 76.0, y, 76.0, 28.0),
        if enabled { "On" } else { "Off" },
        true,
        if enabled {
            ButtonTone::Positive
        } else {
            ButtonTone::Secondary
        },
        mouse,
    ) {
        actions.push(UiAction::ToggleRuntimeSetting(id.to_owned()));
    }
}

fn cycle_row(
    id: &str,
    label: &str,
    value: &str,
    panel: Rect,
    y: f32,
    mouse: Vec2,
    actions: &mut Vec<UiAction>,
) {
    draw_ui_text_ex(label, panel.x, y + 16.0, TextStyle::new(13.0, INK).params());
    if virtual_button(
        Rect::new(panel.right() - 104.0, y, 104.0, 28.0),
        value,
        true,
        ButtonTone::Secondary,
        mouse,
    ) {
        actions.push(UiAction::CycleRuntimeSetting(id.to_owned()));
    }
}

fn percent(value: f32) -> String {
    format!("{}%", (value * 100.0).round() as i32)
}
