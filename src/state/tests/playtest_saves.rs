//! Deterministic, test-only save fixtures for the proposed Option A demo path.

use super::*;
use serde_json::json;
use std::fs;
use std::path::Path;

const FIXTURE_SAVED_AT: &str = "2026-08-27T00:00:00Z";

fn successful_report(mission_id: &str, mission_name: &str, reward: i64) -> MissionReport {
    let mut report = test_report(true, Vec::new());
    report.mission_id = mission_id.to_owned();
    report.mission_name = mission_name.to_owned();
    report.reward = reward;
    report.stars = 2;
    report.score = 1_000;
    report
}

fn complete(session: &mut GameSession, mission_id: &str, name: &str, reward: i64) {
    session.apply_report(successful_report(mission_id, name, reward));
}

fn choose_route(session: &mut GameSession, data: &GameData, mission_id: &str, route_id: &str) {
    let mission = data
        .missions
        .get(mission_id)
        .unwrap_or_else(|| panic!("fixture mission missing: {mission_id}"));
    assert!(session.campaign.select_route_choice(mission, route_id));
}

fn fixture_sessions() -> Vec<(&'static str, GameSession)> {
    let data = GameData::load().expect("embedded game data should load");
    let first = data.first_mission_id();

    let mut start = GameSession::new(&data.config, first);
    start.campaign.active_save_slot = "demoqa_start".to_owned();

    let mut fork_bandit = GameSession::new(&data.config, first);
    complete(&mut fork_bandit, "muddy_road", "The Muddy Road", 120);
    fork_bandit.campaign.selected_mission_id = "bandit_bend".to_owned();
    fork_bandit.campaign.active_save_slot = "demoqa_fork_bandit".to_owned();
    choose_route(&mut fork_bandit, &data, "bandit_bend", "guarded_crossing");

    let mut fork_courier = GameSession::new(&data.config, first);
    complete(&mut fork_courier, "muddy_road", "The Muddy Road", 120);
    fork_courier.campaign.selected_mission_id = "courier_deadline".to_owned();
    fork_courier.campaign.active_save_slot = "demoqa_fork_courier".to_owned();
    choose_route(&mut fork_courier, &data, "courier_deadline", "main_road");

    let mut final_bandit = fork_bandit.clone();
    complete(&mut final_bandit, "bandit_bend", "Bandit Bend", 140);
    let guard_training = data
        .upgrades
        .get("guard_training")
        .expect("guard upgrade should exist");
    assert!(final_bandit.buy_upgrade(guard_training));
    final_bandit.campaign.selected_mission_id = "bonebridge_pass".to_owned();
    final_bandit.campaign.active_save_slot = "demoqa_final_bandit".to_owned();
    choose_route(&mut final_bandit, &data, "bonebridge_pass", "chapel_road");

    let mut final_courier = fork_courier.clone();
    complete(
        &mut final_courier,
        "courier_deadline",
        "Courier Deadline",
        150,
    );
    let wheels = data
        .upgrades
        .get("reinforced_wheels")
        .expect("wheel upgrade should exist");
    assert!(final_courier.buy_upgrade(wheels));
    final_courier.campaign.selected_mission_id = "bonebridge_pass".to_owned();
    final_courier.campaign.active_save_slot = "demoqa_final_courier".to_owned();
    choose_route(&mut final_courier, &data, "bonebridge_pass", "crypt_bridge");

    vec![
        ("demoqa_start", start),
        ("demoqa_fork_bandit", fork_bandit),
        ("demoqa_fork_courier", fork_courier),
        ("demoqa_final_bandit", final_bandit),
        ("demoqa_final_courier", final_courier),
    ]
}

#[test]
fn playtest_save_fixtures_match_option_a_progression() {
    let data = GameData::load().expect("embedded game data should load");
    let fixtures = fixture_sessions();
    assert_eq!(fixtures.len(), 5);

    for (slot, session) in fixtures {
        assert_eq!(session.campaign.active_save_slot, slot);
        let selected = data
            .missions
            .get(&session.campaign.selected_mission_id)
            .expect("selected fixture mission should exist");
        assert!(session.campaign.is_mission_unlocked(selected));
    }
}

#[test]
#[ignore = "writes requested QA fixtures outside the source tree"]
fn export_playtest_save_fixtures() {
    let output = std::env::var("CARRIAGE_TEST_SAVE_DIR")
        .expect("CARRIAGE_TEST_SAVE_DIR must name the requested output directory");
    let output = Path::new(&output);
    fs::create_dir_all(output).expect("fixture output directory should be creatable");
    let data = GameData::load().expect("embedded game data should load");

    for (slot, session) in fixture_sessions() {
        let mut save = session.to_save(&data.config.version);
        save.saved_at = FIXTURE_SAVED_AT.to_owned();
        let wrapper = json!({
            "slot": {
                "name": slot,
                "save_date": "Generated for QA",
                "version": data.config.version,
            },
            "data": save,
        });
        let path = output.join(format!("save_{slot}.json"));
        let bytes = serde_json::to_vec_pretty(&wrapper).expect("fixture should serialize");
        fs::write(path, bytes).expect("fixture should be writable");
    }
}
