//! Policy for developer-only startup notices.

use macroquad_toolkit::capture;

pub(super) fn startup_diagnostics_enabled() -> bool {
    should_show_startup_diagnostics(
        capture::capture_requested("CARRIAGE"),
        cfg!(debug_assertions),
        capture::env_bool("CARRIAGE_DIAGNOSTICS", false),
    )
}

fn should_show_startup_diagnostics(
    capture_requested: bool,
    debug_build: bool,
    explicitly_enabled: bool,
) -> bool {
    !capture_requested && (debug_build || explicitly_enabled)
}

#[cfg(test)]
mod tests;
