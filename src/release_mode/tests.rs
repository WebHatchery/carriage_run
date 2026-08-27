use super::*;

#[test]
fn approved_demo_contracts_are_stable_and_ordered() {
    assert_eq!(DEMO_MISSION_IDS.len(), 4);
    assert_eq!(DEMO_MISSION_IDS[0], "muddy_road");
    assert_eq!(DEMO_FINAL_MISSION_ID, "bonebridge_pass");
}

#[test]
fn release_identity_matches_the_compiled_mode() {
    let mut config = GameConfig {
        game_name: "carriage_run".to_owned(),
        display_name: "Carriage Run".to_owned(),
        save_slot: "campaign".to_owned(),
        version: "0.1.0".to_owned(),
        toolkit_revision: String::new(),
        starting_gold: 125,
    };
    apply_identity(&mut config);

    if cfg!(feature = "demo") {
        assert_eq!(channel(), "demo");
        assert_eq!(config.game_name, "carriage_run_demo");
        assert_eq!(config.save_slot, "demo_campaign");
        assert!(config.display_name.contains("PC Demo"));
        assert!(config.version.ends_with("-demo1"));
    } else {
        assert_eq!(config.game_name, "carriage_run");
        assert_eq!(config.save_slot, "campaign");
        assert_eq!(config.version, "0.1.0");
    }
}

#[test]
fn mission_gate_opens_only_the_approved_slice_in_demo() {
    for id in DEMO_MISSION_IDS {
        assert!(allows_mission(id));
    }
    assert_eq!(allows_mission("kings_end"), !cfg!(feature = "demo"));
}

#[test]
fn demo_fork_closes_after_one_middle_contract() {
    assert!(allows_demo_branch("bandit_bend", false, false));
    assert!(allows_demo_branch("courier_deadline", false, false));
    assert_eq!(
        allows_demo_branch("courier_deadline", true, false),
        !cfg!(feature = "demo")
    );
    assert_eq!(
        allows_demo_branch("bandit_bend", false, true),
        !cfg!(feature = "demo")
    );
}

#[test]
fn only_a_successful_demo_finale_reaches_the_ending() {
    assert_eq!(
        reaches_demo_end(DEMO_FINAL_MISSION_ID, true),
        cfg!(feature = "demo")
    );
    assert!(!reaches_demo_end(DEMO_FINAL_MISSION_ID, false));
    assert!(!reaches_demo_end("muddy_road", true));
}
