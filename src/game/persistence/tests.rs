use super::*;

#[test]
fn shutdown_flushes_only_dirty_autosave_campaigns() {
    assert!(should_flush_on_shutdown(true, true));
    assert!(!should_flush_on_shutdown(false, true));
    assert!(!should_flush_on_shutdown(true, false));
    assert!(!should_flush_on_shutdown(false, false));
}
