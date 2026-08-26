use std::process::Command;

fn main() {
    println!("cargo:rerun-if-changed=assets/packaging/carriage_run.ico");
    println!("cargo:rerun-if-changed=toolkit.lock");
    println!("cargo:rerun-if-env-changed=CARRIAGE_BUILD_CHANNEL");
    println!("cargo:rerun-if-env-changed=CARRIAGE_BUILD_COMMIT");
    println!("cargo:rerun-if-env-changed=CARRIAGE_BUILD_UTC");

    let channel =
        std::env::var("CARRIAGE_BUILD_CHANNEL").unwrap_or_else(|_| "development".to_owned());
    let commit = std::env::var("CARRIAGE_BUILD_COMMIT")
        .ok()
        .filter(|value| !value.trim().is_empty())
        .unwrap_or_else(git_commit);
    let build_utc =
        std::env::var("CARRIAGE_BUILD_UTC").unwrap_or_else(|_| "local-unrecorded".to_owned());
    let toolkit_revision = std::fs::read_to_string("toolkit.lock")
        .map(|value| value.trim().to_owned())
        .unwrap_or_else(|_| "unknown".to_owned());
    println!("cargo:rustc-env=CARRIAGE_BUILD_CHANNEL={channel}");
    println!("cargo:rustc-env=CARRIAGE_BUILD_COMMIT={commit}");
    println!("cargo:rustc-env=CARRIAGE_BUILD_UTC={build_utc}");
    println!("cargo:rustc-env=CARRIAGE_TOOLKIT_REVISION={toolkit_revision}");

    let is_windows_target = std::env::var("TARGET")
        .map(|target| target.contains("windows"))
        .unwrap_or(false);
    if cfg!(windows) && is_windows_target {
        let mut resource = winres::WindowsResource::new();
        resource
            .set_icon("assets/packaging/carriage_run.ico")
            .set_language(0x0409)
            .set_version_info(winres::VersionInfo::FILEVERSION, 0x0001_0000_0000_0000)
            .set_version_info(winres::VersionInfo::PRODUCTVERSION, 0x0001_0000_0000_0000)
            .set("FileDescription", "Carriage Run")
            .set("ProductName", "Carriage Run")
            .set("LegalCopyright", "WebHatchery");
        resource
            .compile()
            .expect("Windows application resource compilation failed");
    }
}

fn git_commit() -> String {
    Command::new("git")
        .args(["rev-parse", "HEAD"])
        .output()
        .ok()
        .filter(|output| output.status.success())
        .and_then(|output| String::from_utf8(output.stdout).ok())
        .map(|value| value.trim().to_owned())
        .filter(|value| !value.is_empty())
        .unwrap_or_else(|| "unknown".to_owned())
}
