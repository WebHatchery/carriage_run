use super::*;

#[test]
fn timing_summary_reports_ordered_percentiles() {
    let samples = (1..=100).map(Duration::from_micros).collect::<Vec<_>>();
    let summary = summarize(&samples);

    assert_eq!(summary.samples, 100);
    assert!((summary.min_ms - 0.001).abs() < 0.000_001);
    assert!((summary.p50_ms - 0.051).abs() < 0.000_001);
    assert!((summary.p95_ms - 0.096).abs() < 0.000_001);
    assert!((summary.p99_ms - 0.100).abs() < 0.000_001);
    assert!((summary.max_ms - 0.100).abs() < 0.000_001);
}

#[test]
fn scene_profiler_combines_matching_update_and_draw_samples() {
    let mut profiler = SceneProfiler::new("gameplay", 2, 1280, 720);
    profiler.record(
        Duration::from_millis(1),
        Duration::from_millis(2),
        1264,
        681,
    );
    profiler.record(
        Duration::from_millis(2),
        Duration::from_millis(3),
        1264,
        681,
    );
    let scene = profiler.finish();

    assert_eq!(scene.scene, "gameplay");
    assert_eq!(scene.width, 1264);
    assert_eq!(scene.steady_frames, 1);
    assert!((scene.capture_transition_cpu_ms - 3.0).abs() < 0.000_001);
    assert_eq!(scene.combined_cpu_submission.samples, 1);
    assert!((scene.combined_cpu_submission.max_ms - 5.0).abs() < 0.000_001);
}
