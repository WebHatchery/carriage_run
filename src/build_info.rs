//! Compile-time provenance shown quietly in support surfaces and crash logs.

#[cfg(test)]
mod tests;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct BuildInfo {
    pub version: &'static str,
    pub channel: &'static str,
    pub commit: &'static str,
    pub built_at_utc: &'static str,
    pub toolkit_revision: &'static str,
}

pub const BUILD_INFO: BuildInfo = BuildInfo {
    version: env!("CARGO_PKG_VERSION"),
    channel: env!("CARRIAGE_BUILD_CHANNEL"),
    commit: env!("CARRIAGE_BUILD_COMMIT"),
    built_at_utc: env!("CARRIAGE_BUILD_UTC"),
    toolkit_revision: env!("CARRIAGE_TOOLKIT_REVISION"),
};

pub fn credits_version_line() -> String {
    format!(
        "Version {} · {} · commit {}",
        BUILD_INFO.version,
        BUILD_INFO.channel,
        short_revision(BUILD_INFO.commit)
    )
}

pub fn credits_build_line() -> String {
    format!(
        "Built {} · toolkit {}",
        BUILD_INFO.built_at_utc,
        short_revision(BUILD_INFO.toolkit_revision)
    )
}

pub fn diagnostic_line() -> String {
    format!(
        "version={} channel={} commit={} built_at_utc={} toolkit={}",
        BUILD_INFO.version,
        BUILD_INFO.channel,
        BUILD_INFO.commit,
        BUILD_INFO.built_at_utc,
        BUILD_INFO.toolkit_revision
    )
}

fn short_revision(revision: &str) -> String {
    if let Some(clean_revision) = revision.strip_suffix("-dirty") {
        return format!(
            "{}-dirty",
            clean_revision.get(..7).unwrap_or(clean_revision)
        );
    }
    revision.get(..7).unwrap_or(revision).to_owned()
}
