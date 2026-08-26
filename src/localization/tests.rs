use super::*;

#[test]
fn missing_keys_fall_back_to_english_and_are_reported() {
    let mut localizer = Localizer::english();
    assert_eq!(localizer.text("menu.new_campaign"), "New Campaign");
    assert_eq!(localizer.text("missing.key"), "missing.key");
    assert!(localizer.missing_keys().any(|key| key == "missing.key"));
}

#[test]
fn longer_language_fallbacks_are_declared() {
    assert!(font_fallbacks(Language::German).len() >= 2);
    assert!(font_fallbacks(Language::French).len() >= 2);
}

#[test]
fn translated_layout_has_no_unbounded_strings() {
    for language in Language::ALL {
        let localizer = Localizer::load(language).unwrap();
        assert!(localizer.layout_warnings().is_empty());
    }
}

#[test]
fn every_locale_has_exactly_the_english_key_set() {
    let localizer = Localizer::english();
    let english = localizer.table_for(Language::English);
    assert_eq!(
        english.len(),
        19,
        "update the review packet when keyed scope changes"
    );
    for language in [Language::German, Language::French] {
        let translated = localizer.table_for(language);
        let missing: Vec<_> = english
            .keys()
            .filter(|key| !translated.contains_key(*key))
            .collect();
        let extra: Vec<_> = translated
            .keys()
            .filter(|key| !english.contains_key(*key))
            .collect();
        assert!(
            missing.is_empty(),
            "{} missing keys: {missing:?}",
            language.id()
        );
        assert!(extra.is_empty(), "{} extra keys: {extra:?}", language.id());
    }
}

#[test]
fn translated_values_are_nonempty_control_free_and_within_ui_budgets() {
    let localizer = Localizer::english();
    for language in Language::ALL {
        for (key, value) in localizer.table_for(language) {
            assert!(
                !value.trim().is_empty(),
                "{} has empty {key}",
                language.id()
            );
            assert!(
                value.chars().all(|character| !character.is_control()),
                "{} {key} contains a control character",
                language.id()
            );
            let budget = if key.starts_with("menu.") {
                24
            } else if key.starts_with("settings.") {
                32
            } else if key.starts_with("tutorial.") {
                60
            } else {
                72
            };
            assert!(
                value.chars().count() <= budget,
                "{} {key} is {} characters (budget {budget})",
                language.id(),
                value.chars().count()
            );
        }
    }
}

#[test]
fn shipped_font_contains_every_localized_glyph() {
    let font = fontdue::Font::from_bytes(
        include_bytes!("../../assets/fonts/latin_extended.ttf") as &[u8],
        fontdue::FontSettings::default(),
    )
    .unwrap();
    let localizer = Localizer::english();
    for language in Language::ALL {
        for (key, value) in localizer.table_for(language) {
            let missing: Vec<_> = value
                .chars()
                .filter(|character| !character.is_whitespace() && !font.has_glyph(*character))
                .collect();
            assert!(
                missing.is_empty(),
                "{} {key} missing glyphs: {missing:?}",
                language.id()
            );
        }
    }
}

#[test]
fn tutorial_names_the_exact_visible_continue_control() {
    let localizer = Localizer::english();
    for language in Language::ALL {
        let table = localizer.table_for(language);
        let button = table["menu.continue"].to_uppercase();
        assert!(
            table["tutorial.continue"].contains(&button),
            "{} tutorial must name visible control {button}",
            language.id()
        );
    }
}
