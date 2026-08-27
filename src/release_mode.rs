//! Compile-time separation between the complete game and the public demo.

use crate::data::GameConfig;

#[cfg(test)]
mod tests;

pub const DEMO_MISSION_IDS: [&str; 4] = [
    "muddy_road",
    "bandit_bend",
    "courier_deadline",
    "bonebridge_pass",
];
pub const DEMO_FINAL_MISSION_ID: &str = "bonebridge_pass";

pub const fn is_demo() -> bool {
    cfg!(feature = "demo")
}

pub const fn channel() -> &'static str {
    if is_demo() {
        "demo"
    } else {
        env!("CARRIAGE_BUILD_CHANNEL")
    }
}

pub const fn app_id() -> &'static str {
    if is_demo() {
        "carriage_run_demo"
    } else {
        "carriage_run"
    }
}

pub fn allows_mission(id: &str) -> bool {
    !is_demo() || DEMO_MISSION_IDS.contains(&id)
}

pub fn allows_demo_branch(
    mission_id: &str,
    bandit_completed: bool,
    courier_completed: bool,
) -> bool {
    if !is_demo() {
        return true;
    }
    match mission_id {
        "bandit_bend" => !courier_completed,
        "courier_deadline" => !bandit_completed,
        _ => true,
    }
}

pub fn reaches_demo_end(mission_id: &str, success: bool) -> bool {
    is_demo() && success && mission_id == DEMO_FINAL_MISSION_ID
}

pub fn apply_identity(config: &mut GameConfig) {
    if is_demo() {
        config.game_name = app_id().to_owned();
        config.display_name = "Carriage Run — PC Demo".to_owned();
        config.save_slot = "demo_campaign".to_owned();
        config.version = format!("{}-demo1", config.version);
    }
}
