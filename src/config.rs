use serde_yaml::Value;
use std::path::PathBuf;

use crate::logging::Log;

const CONFIG: &str = "matchstick.yaml";

pub struct MatchstickConfig {
    pub libs_path: String,
    pub tests_path: String,
}

impl MatchstickConfig {
    fn default() -> MatchstickConfig {
        MatchstickConfig {
            libs_path: "./node_modules".to_string(),
            tests_path: "./tests".to_string(),
        }
    }
    /// Reads and checks if libFolder and/or testsFolder are defined.
    /// Otherwise returns the default values.
    pub fn new() -> MatchstickConfig {
        let mut config = MatchstickConfig::default();

            let matchstick_yaml = parse_yaml();
            // Tries to get the tests or libs folder value from the config file.
            // If the attribute doesn't exist returns the default value.
            let mut tests_path = matchstick_yaml
                .get("testsFolder")
                .unwrap_or(&Value::String(config.tests_path.clone()))
                .as_str()
                .unwrap_or(&config.tests_path)
                .to_string();

            let mut libs_path = matchstick_yaml
                .get("libsFolder")
                .unwrap_or(&Value::String(config.libs_path.clone()))
                .as_str()
                .unwrap_or(&config.libs_path)
                .to_string();

            // For consistency checks if the paths are defined with a trailng slash and removes it
            if tests_path.ends_with('/') {
                tests_path.pop();
            }

            if libs_path.ends_with('/') {
                libs_path.pop();
            }

            // Updates the struct attributes
            config.tests_path = tests_path;
            config.libs_path = libs_path;

        config
    }
}

fn parse_yaml() -> Value {
    if PathBuf::from(CONFIG).exists() {
        let matchstick_config = std::fs::read_to_string(CONFIG).unwrap_or_else(|err| {
            panic!(
                "{}",
                Log::Critical(format!(
                    "Something went wrong while trying to read `{}`: {}",
                    CONFIG, err,
                )),
            )
        });

        // If matchstick.yaml exists but is empty from_str will panic with `EndOfStream`
        serde_yaml::from_str(&matchstick_config).unwrap_or_else(|_| {
            Log::Warning(format!(
                "{} is empty or contains invalid values! Using default configuration.",
                CONFIG
            ))
            .println();
            Value::String("".to_string())
        })
    } else {
        Value::String("".to_string())
    }
}
