//! Option A-only deterministic route outcomes and optional CSV export.

use super::balance::{simulate_with_campaign, DriverPolicy, SimCase};
use super::*;
use std::fmt::Write;

#[derive(Default)]
struct Summary {
    runs: usize,
    wins: usize,
    health: f32,
    cargo: f32,
    reward: i64,
    elapsed: f32,
    enemies: u32,
    hazards: u32,
}

#[test]
fn option_a_balance_matrix_covers_every_route_and_difficulty() {
    let data = GameData::load().unwrap();
    let policies = [
        DriverPolicy::Boost,
        DriverPolicy::Cruise,
        DriverPolicy::Brake,
        DriverPolicy::Mixed,
    ];
    let difficulties = [
        DifficultyPreset::Relaxed,
        DifficultyPreset::Standard,
        DifficultyPreset::Hard,
    ];
    let mut csv = String::from(
        "mission,route,difficulty,runs,wins,success_rate,avg_health_pct,avg_cargo_pct,avg_reward,avg_route_seconds,avg_enemies,avg_hazards\n",
    );
    let mut rows = 0;

    for mission_id in crate::release_mode::DEMO_MISSION_IDS {
        let mission = data.missions.get(mission_id).unwrap();
        for route_index in 0..mission.route_choices.len() {
            for difficulty in difficulties {
                let mut summary = Summary::default();
                for policy in policies {
                    for seed in 0..5 {
                        let campaign = representative_demo_campaign(&data, mission_id);
                        let result = simulate_with_campaign(
                            &data,
                            SimCase {
                                mission: mission_id,
                                route: route_index,
                                difficulty,
                                chassis: "standard_wagon",
                                frame: "standard",
                                policy,
                                seed,
                            },
                            campaign,
                        );
                        summary.runs += 1;
                        summary.wins += usize::from(result.success);
                        summary.health += result.health;
                        summary.cargo += result.cargo;
                        summary.reward += result.reward;
                        summary.elapsed += result.elapsed;
                        summary.enemies += result.enemies;
                        summary.hazards += result.hazards;
                    }
                }
                let count = summary.runs as f32;
                if difficulty == DifficultyPreset::Standard {
                    assert!(
                        summary.wins >= 7,
                        "standard demo route {} / {} fell below the deterministic completion corridor",
                        mission_id,
                        mission.route_choices[route_index].id
                    );
                    assert!(
                        summary.elapsed / count >= 30.0,
                        "standard demo route {} / {} became too short to showcase its mechanics",
                        mission_id,
                        mission.route_choices[route_index].id
                    );
                }
                writeln!(
                    csv,
                    "{},{},{},{},{},{:.3},{:.1},{:.1},{:.1},{:.1},{:.1},{:.1}",
                    mission_id,
                    mission.route_choices[route_index].id,
                    difficulty.id(),
                    summary.runs,
                    summary.wins,
                    summary.wins as f32 / count,
                    summary.health / count * 100.0,
                    summary.cargo / count * 100.0,
                    summary.reward as f32 / count,
                    summary.elapsed / count,
                    summary.enemies as f32 / count,
                    summary.hazards as f32 / count,
                )
                .unwrap();
                rows += 1;
            }
        }
    }

    assert_eq!(rows, 24, "four missions × two routes × three presets");
    assert!(csv
        .lines()
        .skip(1)
        .all(|line| line.split(',').count() == 12));
    if let Ok(path) = std::env::var("CARRIAGE_DEMO_BALANCE_OUTPUT") {
        std::fs::write(path, csv).unwrap();
    }
}

fn representative_demo_campaign(data: &GameData, mission_id: &str) -> CampaignState {
    let mut campaign = CampaignState::new(&data.config, Some("muddy_road"));
    campaign.carriage_frame_id = "standard".to_owned();

    if mission_id != "muddy_road" {
        campaign.chassis_id = "standard_wagon".to_owned();
        campaign.owned_chassis_ids = vec!["scout_cart".to_owned(), "standard_wagon".to_owned()];
        campaign.records.insert(
            "muddy_road".to_owned(),
            MissionRecord {
                best_stars: 2,
                best_score: 500,
                best_reward: 120,
                completions: 1,
            },
        );
        campaign.campaign_rank = 2;
        campaign.armor_level = 1;
    }
    if mission_id == "bonebridge_pass" {
        campaign.hired_guard_ids.push("shield_guard".to_owned());
        campaign.selected_guard_ids = vec!["shield_guard".to_owned(), "swordsman".to_owned()];
        campaign.repair_level = 1;
        campaign.selected_equipment_ids =
            vec!["carriage_armor".to_owned(), "repair_kit".to_owned()];
    }
    campaign.refresh_chassis_stats(data);
    campaign.refresh_frame_stats(data);
    campaign
}
