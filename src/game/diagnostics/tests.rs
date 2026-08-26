use super::*;

#[test]
fn debug_builds_show_startup_diagnostics_during_normal_play() {
    assert!(should_show_startup_diagnostics(false, true, false));
}

#[test]
fn release_builds_require_an_explicit_diagnostics_opt_in() {
    assert!(!should_show_startup_diagnostics(false, false, false));
    assert!(should_show_startup_diagnostics(false, false, true));
}

#[test]
fn deterministic_captures_stay_clean_even_when_diagnostics_are_requested() {
    assert!(!should_show_startup_diagnostics(true, true, true));
}
