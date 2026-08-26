use super::*;

#[test]
fn localized_capture_scene_preserves_base_scene_and_language() {
    assert_eq!(
        localized_scene("title_de"),
        ("title", Some(Language::German))
    );
    assert_eq!(
        localized_scene("results_fr"),
        ("results", Some(Language::French))
    );
    assert_eq!(localized_scene("settings"), ("settings", None));
}
