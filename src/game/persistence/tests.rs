use super::*;

#[test]
fn shutdown_flushes_only_dirty_autosave_campaigns() {
    assert!(should_flush_on_shutdown(true, true));
    assert!(!should_flush_on_shutdown(false, true));
    assert!(!should_flush_on_shutdown(true, false));
    assert!(!should_flush_on_shutdown(false, false));
}

#[test]
fn backup_versions_reject_future_and_unknown_formats() {
    assert!(check_supported_version("0.0.9", "0.1.0").is_ok());
    assert!(check_supported_version("0.1.0", "0.1.0").is_ok());
    for future in ["0.1.1", "1.0.0", "0.10.0", "unknown"] {
        assert!(check_supported_version(future, "0.1.0").is_err());
    }
}

#[derive(Default)]
struct Store {
    copies: std::collections::HashMap<String, String>,
    fail: Option<String>,
}

impl macroquad_toolkit::persistence::RawSaveStore for Store {
    fn read(&self, key: &str) -> Result<Option<String>, String> {
        Ok(self.copies.get(key).cloned())
    }
    fn write(&mut self, key: &str, raw: &str) -> Result<(), String> {
        if self.fail.as_deref() == Some(key) {
            return Err("disk full".into());
        }
        self.copies.insert(key.to_owned(), raw.to_owned());
        Ok(())
    }
}

#[test]
fn existing_backup_names_recover_and_failed_rotation_preserves_primary() {
    let mut store = Store::default();
    let chain = backup_chain("campaign");
    let validate = |raw: &str| raw.parse::<u32>().map(|_| ()).map_err(|e| e.to_string());
    for value in ["1", "2", "3", "4"] {
        chain.save(&mut store, value, validate).unwrap();
    }
    assert_eq!(store.copies["campaign_backup_1"], "3");
    assert_eq!(store.copies["campaign_backup_2"], "2");
    assert_eq!(store.copies["campaign_backup_3"], "1");
    store.fail = Some("campaign_backup_1".into());
    assert!(chain.save(&mut store, "5", validate).is_err());
    assert_eq!(store.copies["campaign"], "4");
    store.copies.insert("campaign".into(), "corrupt".into());
    assert!(chain.save(&mut store, "6", validate).is_err());
    let recovered = chain
        .recover(&store, |raw| raw.parse::<u32>().map_err(|e| e.to_string()))
        .unwrap();
    assert_eq!(recovered.value, 3);
    assert_eq!(
        recovered.source,
        macroquad_toolkit::persistence::SaveSource::Backup(1)
    );
}
