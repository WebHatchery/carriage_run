use super::*;

#[test]
fn active_route_screens_request_music() {
    for screen in [
        Screen::Title,
        Screen::MissionMap,
        Screen::Playing,
        Screen::Journey,
    ] {
        assert!(screen_wants_music(screen), "{screen:?}");
    }
}

#[test]
fn pause_and_management_screens_stop_music() {
    for screen in [
        Screen::Paused,
        Screen::Settings,
        Screen::Loadout,
        Screen::Results,
        Screen::Credits,
    ] {
        assert!(!screen_wants_music(screen), "{screen:?}");
    }
}
