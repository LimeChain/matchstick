use serde_yaml::Value;
use std::path::PathBuf;

use crate::logging::Log;

pub struct MatchstickConfig {
    pub libs_path: String,
    pub tests_path: String,
}

impl MatchstickConfig {
    /// fn new() - > MatchstickConfig
    /// Creates a MatchstickConfig with default values
    fn new() -> MatchstickConfig {
        MatchstickConfig {
            libs_path: "./node_modules".to_string(),
            tests_path: "./tests".to_string(),
        }
    }

    /// pub fn from(path: &str) -> MatchstickConfig
    /// Creates a new MatchstickConfig from the passed matchstcik config.
    /// If the config does not exist or keys are missing, returns the default values
    pub fn from(path: &str) -> MatchstickConfig {
        let mut config = MatchstickConfig::new();

        if PathBuf::from(path).exists() {
            let matchstick_yaml = parse_yaml(path);
            // Tries to get the tests or libs folder value from the config file.
            // If the attribute doesn't exist returns the default value.
            config.tests_path = extract_string(&matchstick_yaml, "testsFolder", config.tests_path);
            config.libs_path = extract_string(&matchstick_yaml, "libsFolder", config.libs_path);
        }

        config
    }
}

/// fn extract_string(value: &Value, key: &str, default: String) -> String
/// Extracts the string value of the passed key from the parsed config
/// Fallbacks to the default value if it fails to extract the string for some reason
fn extract_string(value: &Value, key: &str, default: String) -> String {
    value
        .get(key)
        .unwrap_or({
            Log::Warning(format!(
                "Failed to get `{}` from matchstick.config! Using default config value.",
                key
            ))
            .println();
            &Value::String(default.clone())
        })
        .as_str()
        .unwrap_or({
            Log::Warning(format!(
                "Failed to parse `{}` as str! Using default config value.",
                key
            ))
            .println();
            &default
        })
        .to_string()
}

/// fn parse_yaml(path: &str) -> Value
/// Parses the matchstick.yaml file
/// If the parsing fails returns an empty Value::String()
fn parse_yaml(path: &str) -> Value {
    let matchstick_config = std::fs::read_to_string(path).unwrap_or_else(|err| {
        panic!(
            "{}",
            Log::Critical(format!(
                "Something went wrong while trying to read `{}`: {}",
                path, err,
            )),
        )
    });

    // If matchstick.yaml exists but is empty from_str will panic with `EndOfStream`
    serde_yaml::from_str(&matchstick_config).unwrap_or_else(|_| {
        Log::Warning(format!(
            "{} is empty or contains invalid values! Using default configuration.",
            path
        ))
        .println();
        Value::String("".to_string())
    })
}

#[cfg(test)]
mod config_tests {
    use super::*;
    use crate::config::MatchstickConfig;
    use serde_yaml::Value;

    #[test]
    #[should_panic(
        expected = "🆘 Something went wrong while trying to read `mocks/configs/no_config.yaml`: No such file or directory (os error 2)"
    )]
    fn parse_yaml_should_panic_when_file_is_missing() {
        parse_yaml("mocks/configs/no_config.yaml");
    }

    #[test]

    fn parse_yaml_returns_empty_string_value_if_config_is_empty() {
        let yaml = parse_yaml("mocks/configs/matchstick_empty.yaml");

        assert_eq!(yaml, Value::String("".to_string()))
    }

    #[test]
    fn extract_string_returns_value_as_string() {
        let config_yaml = parse_yaml("mocks/configs/matchstick.yaml");
        let test_folder = extract_string(&config_yaml, "testsFolder", "./tests".to_string());

        assert_eq!(test_folder, "./specs".to_string())
    }

    #[test]
    fn extract_string_returns_default_when_key_is_missing() {
        let config_yaml = parse_yaml("mocks/configs/matchstick.yaml");
        let test_folder = extract_string(&config_yaml, "libsFolder", "./node_modules".to_string());

        assert_eq!(test_folder, "./node_modules".to_string())
    }

    #[test]
    fn config_from_returns_default_values_if_no_config() {
        let config = MatchstickConfig::from("mocks/configs/no_config.yaml");

        assert_eq!(config.libs_path, "./node_modules".to_string());
        assert_eq!(config.tests_path, "./tests".to_string());
    }

    #[test]
    fn config_from_returns_custom_folder_from_config() {
        let config = MatchstickConfig::from("mocks/configs/matchstick.yaml");

        assert_eq!(config.tests_path, "./specs".to_string());
    }
}
