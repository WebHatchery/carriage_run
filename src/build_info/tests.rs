use super::*;

#[test]
fn support_lines_name_the_release_and_source_revisions() {
    let version = credits_version_line();
    let build = credits_build_line();
    assert!(version.contains(BUILD_INFO.version));
    assert!(version.contains(BUILD_INFO.channel));
    assert!(version.contains(short_revision(BUILD_INFO.commit)));
    assert!(build.contains(BUILD_INFO.built_at_utc));
    assert!(build.contains(short_revision(BUILD_INFO.toolkit_revision)));
}

#[test]
fn diagnostic_line_keeps_full_provenance() {
    let line = diagnostic_line();
    assert!(line.contains(BUILD_INFO.commit));
    assert!(line.contains(BUILD_INFO.toolkit_revision));
}

#[test]
fn short_revision_tolerates_non_git_fallbacks() {
    assert_eq!(short_revision("unknown"), "unknown");
    assert_eq!(short_revision("1234567890"), "1234567");
}
