use serde_yaml::Value;
use std::path::PathBuf;

use crate::logging::Log;

pub struct MatchstickConfig {
    pub libs_path: String,
    pub tests_path: String,
}

impl Default for MatchstickConfig {
    fn default() -> MatchstickConfig {
        MatchstickConfig {
            libs_path: "./node_modules".to_string(),
            tests_path: "./tests".to_string(),
        }
    }
}

pub fn parse_matchstick_config() -> MatchstickConfig {
    let mut config = MatchstickConfig::default();

    if PathBuf::from("matchstick.yaml").exists() {
        let matchstick_config = std::fs::read_to_string("matchstick.yaml").unwrap();

        // If matchstick.yaml exists but is empty from_str will panic with `EndOfStream`
        let matchstick_yaml: Value =
            serde_yaml::from_str(&matchstick_config).unwrap_or_else(|_| {
                Log::Warning(
                    "matchstick.yaml is empty or contains invalid values! Using default configuration.",
                )
                .println();
                Value::String("".to_string())
            });

        let mut tests_path = matchstick_yaml
            .get("testsFolder")
            .unwrap_or(&Value::String(config.tests_path))
            .as_str()
            .unwrap()
            .to_string();

        let mut libs_path = matchstick_yaml
            .get("libsFolder")
            .unwrap_or(&Value::String(config.libs_path))
            .as_str()
            .unwrap()
            .to_string();

        if tests_path.ends_with('/') {
            tests_path.pop();
        }

        if libs_path.ends_with('/') {
            libs_path.pop();
        }

        config.tests_path = tests_path;
        config.libs_path = libs_path;
    }

    config
}
