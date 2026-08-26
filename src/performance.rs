//! Opt-in CPU timing evidence for deterministic capture scenes.

use serde::Serialize;
use std::path::{Path, PathBuf};
use std::time::Duration;

#[cfg(test)]
mod tests;

#[derive(Debug, Serialize)]
pub struct TimingSummary {
    samples: usize,
    mean_ms: f64,
    min_ms: f64,
    p50_ms: f64,
    p95_ms: f64,
    p99_ms: f64,
    max_ms: f64,
}

#[derive(Debug, Serialize)]
pub struct ScenePerformance {
    scene: String,
    width: u32,
    height: u32,
    simulated_frames: u32,
    steady_frames: usize,
    capture_transition_cpu_ms: f64,
    update_cpu: TimingSummary,
    draw_cpu_submission: TimingSummary,
    combined_cpu_submission: TimingSummary,
}

#[cfg(not(target_arch = "wasm32"))]
#[derive(Debug, Serialize)]
struct PerformanceReport {
    schema_version: u32,
    version: &'static str,
    channel: &'static str,
    commit: &'static str,
    toolkit_revision: &'static str,
    measurement: &'static str,
    exclusions: [&'static str; 4],
    scenes: Vec<ScenePerformance>,
}

pub struct SceneProfiler {
    scene: String,
    frames: u32,
    width: u32,
    height: u32,
    update: Vec<Duration>,
    draw: Vec<Duration>,
}

impl SceneProfiler {
    pub fn new(scene: &str, frames: u32, width: u32, height: u32) -> Self {
        Self {
            scene: scene.to_owned(),
            frames,
            width,
            height,
            update: Vec::with_capacity(frames as usize),
            draw: Vec::with_capacity(frames as usize),
        }
    }

    pub fn record(&mut self, update: Duration, draw: Duration, width: u32, height: u32) {
        self.width = width;
        self.height = height;
        self.update.push(update);
        self.draw.push(draw);
    }

    pub fn finish(self) -> ScenePerformance {
        let combined_all = self
            .update
            .iter()
            .zip(&self.draw)
            .map(|(update, draw)| *update + *draw)
            .collect::<Vec<_>>();
        // The first profiled draw follows the capture harness's scene switch
        // and framebuffer boundary. Keep it visible as transition evidence but
        // do not let that harness-specific synchronization dominate steady p95.
        let update = self.update.get(1..).unwrap_or_default();
        let draw = self.draw.get(1..).unwrap_or_default();
        let combined = combined_all.get(1..).unwrap_or_default();
        ScenePerformance {
            scene: self.scene,
            width: self.width,
            height: self.height,
            simulated_frames: self.frames,
            steady_frames: combined.len(),
            capture_transition_cpu_ms: combined_all
                .first()
                .map(|duration| duration.as_secs_f64() * 1_000.0)
                .unwrap_or(0.0),
            update_cpu: summarize(update),
            draw_cpu_submission: summarize(draw),
            combined_cpu_submission: summarize(combined),
        }
    }
}

pub fn output_path() -> Option<PathBuf> {
    #[cfg(not(target_arch = "wasm32"))]
    {
        std::env::var_os("CARRIAGE_PERFORMANCE_OUTPUT")
            .filter(|value| !value.is_empty())
            .map(PathBuf::from)
    }
    #[cfg(target_arch = "wasm32")]
    {
        None
    }
}

pub fn write_report(path: &Path, scenes: Vec<ScenePerformance>) -> Result<(), String> {
    #[cfg(not(target_arch = "wasm32"))]
    {
        if scenes.is_empty() {
            return Err("no profiled scenes were recorded".to_owned());
        }
        if let Some(parent) = path.parent() {
            std::fs::create_dir_all(parent)
                .map_err(|error| format!("could not create {}: {error}", parent.display()))?;
        }
        let report = PerformanceReport {
            schema_version: 1,
            version: crate::build_info::BUILD_INFO.version,
            channel: crate::build_info::BUILD_INFO.channel,
            commit: crate::build_info::BUILD_INFO.commit,
            toolkit_revision: crate::build_info::BUILD_INFO.toolkit_revision,
            measurement: "CPU time spent in deterministic game update and draw-command submission",
            exclusions: [
                "GPU execution and presentation",
                "display synchronization and frame pacing",
                "interactive input and operating-system scheduling under normal play",
                "thermal, battery, and long-session behavior",
            ],
            scenes,
        };
        let json = serde_json::to_string_pretty(&report)
            .map_err(|error| format!("could not serialize report: {error}"))?;
        std::fs::write(path, format!("{json}\n"))
            .map_err(|error| format!("could not write {}: {error}", path.display()))
    }
    #[cfg(target_arch = "wasm32")]
    {
        let _ = (path, scenes);
        Err("performance report output is native-only".to_owned())
    }
}

fn summarize(samples: &[Duration]) -> TimingSummary {
    if samples.is_empty() {
        return TimingSummary {
            samples: 0,
            mean_ms: 0.0,
            min_ms: 0.0,
            p50_ms: 0.0,
            p95_ms: 0.0,
            p99_ms: 0.0,
            max_ms: 0.0,
        };
    }
    let mut values = samples
        .iter()
        .map(|sample| sample.as_secs_f64() * 1_000.0)
        .collect::<Vec<_>>();
    values.sort_by(f64::total_cmp);
    TimingSummary {
        samples: values.len(),
        mean_ms: values.iter().sum::<f64>() / values.len() as f64,
        min_ms: values[0],
        p50_ms: percentile(&values, 0.50),
        p95_ms: percentile(&values, 0.95),
        p99_ms: percentile(&values, 0.99),
        max_ms: *values.last().expect("non-empty timing values"),
    }
}

fn percentile(sorted: &[f64], fraction: f64) -> f64 {
    let index = ((sorted.len() - 1) as f64 * fraction).ceil() as usize;
    sorted[index.min(sorted.len() - 1)]
}
