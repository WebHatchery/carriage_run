//! Carriage Run built with macroquad and macroquad-toolkit.

use macroquad::prelude::*;
use macroquad_toolkit::capture;

mod audio;
mod build_info;
mod crash;
mod data;
mod game;
mod lifecycle;
mod localization;
mod performance;
mod settings;
mod state;
mod ui;

use game::Game;

fn window_conf() -> Conf {
    capture::capture_window_conf(
        "CARRIAGE",
        "Carriage Run",
        ui::LOGICAL_WIDTH as i32,
        ui::LOGICAL_HEIGHT as i32,
    )
}

#[macroquad::main(window_conf)]
async fn main() {
    // Install early so even the startup data-load panic leaves a crash log.
    crash::install_panic_hook("carriage_run");
    eprintln!("Carriage Run build: {}", build_info::diagnostic_line());

    let mut game = Game::new().await;

    // Screenshot harness: when CARRIAGE_CAPTURE_PATH is set, seed a scene,
    // simulate deterministic frames, write a PNG, and exit.
    if let Some(configs) = capture::CaptureConfig::all_from_env("CARRIAGE") {
        let performance_output = performance::output_path();
        let mut performance_scenes = Vec::new();
        for config in configs {
            game.begin_capture_scene(&config.scene);
            let mut profiler = performance_output.as_ref().map(|_| {
                performance::SceneProfiler::new(
                    &config.scene,
                    config.frames,
                    screen_width() as u32,
                    screen_height() as u32,
                )
            });
            capture::run_capture_once(&config, |dt| {
                if let Some(profiler) = profiler.as_mut() {
                    let update_start = std::time::Instant::now();
                    game.update(dt);
                    let update_elapsed = update_start.elapsed();
                    let draw_start = std::time::Instant::now();
                    game.draw();
                    profiler.record(
                        update_elapsed,
                        draw_start.elapsed(),
                        screen_width() as u32,
                        screen_height() as u32,
                    );
                } else {
                    game.update(dt);
                    game.draw();
                }
            })
            .await;
            if let Some(profiler) = profiler {
                performance_scenes.push(profiler.finish());
            }
        }
        if let Some(path) = performance_output {
            performance::write_report(&path, performance_scenes)
                .unwrap_or_else(|error| panic!("performance report failed: {error}"));
        }
        return;
    }

    // Route both the window close button and in-game EXIT GAME controls through
    // the same final-save path.
    prevent_quit();
    loop {
        if is_quit_requested() {
            game.request_exit();
        }
        let dt = get_frame_time().min(0.1);
        game.update(dt);
        game.draw();
        if game.exit_requested() {
            if let Err(error) = game.shutdown() {
                eprintln!("Carriage Run final save failed during shutdown: {error}");
            }
            break;
        }
        next_frame().await;
    }
}
