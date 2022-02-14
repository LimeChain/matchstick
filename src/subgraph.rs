use serde_yaml::{Sequence, Value};
use std::collections::HashMap;
use std::fs;

use crate::Log;

/// fn parse_yaml(path: &str) -> Value
/// Parses the yaml file from the passed path
/// Will panic if the file does not exist or can't be parsed
fn parse_yaml(path: &str) -> Value {
    let subgraph_yaml_contents = fs::read_to_string(path).unwrap_or_else(|err| {
        panic!(
            "{}",
            Log::Critical(format!(
                "Something went wrong while trying to read `{}`: {}",
                path, err,
            )),
        )
    });

    let subgraph_yaml: Value =
        serde_yaml::from_str(&subgraph_yaml_contents).unwrap_or_else(|err| {
            panic!(
                "{}",
                Log::Critical(format!(
                    "Something went wrong when parsing `{}`: {}",
                    path, err,
                )),
            )
        });

    subgraph_yaml
}

/// fn extract_string(value: &Value, key: &str) -> String
/// Extracts the String value of the passed key
/// Panics if the key is missing or can't convert the value to string
fn extract_string(value: &Value, key: &str) -> String {
    value
        .get(key)
        .unwrap_or_else(|| panic!("Couldn't find key `{}` in subgraph.yaml", key))
        .as_str()
        .unwrap_or_else(|| panic!("Couldn't parse `{}` as str", key))
        .to_string()
}

/// fn extract_vec(value &Value, key: &str) -> Sequence
/// Extracts the value of the passed key as Sequence
/// Will return an empty Vec if the key is missing
/// Will panic if the value can't be parsed as Sequence
fn extract_vec(value: &Value, key: &str) -> Sequence {
    value
        .get(key)
        .unwrap_or(&Value::Sequence(vec![]))
        .as_sequence()
        .unwrap_or_else(|| panic!("Couldn't parse `{}` as Sequence", key))
        .to_vec()
}

/// fn parse_sources(path: &str) -> Sequence
/// Extracts the sources declared under dataSources or templates in the subraph.yaml
fn parse_sources(path: &str) -> Sequence {
    let subgraph_yaml = parse_yaml(path);

    let mut sources = vec![];
    sources.append(&mut extract_vec(&subgraph_yaml, "dataSources"));
    sources.append(&mut extract_vec(&subgraph_yaml, "templates"));

    sources
}

/// fn collect_handlers(path: &str) -> HashMap<String, Vec<String>>
/// collects the event and call handlers for each source
/// declared under dataSources or templates
pub fn collect_handlers(path: &str) -> HashMap<String, Vec<String>> {
    parse_sources(path)
        .iter()
        .map(|source| {
            let name = extract_string(source, "name");

            let mapping = source
                .get("mapping")
                .expect("No key 'mapping' in datasource.");

            let mut functions = vec![];

            functions.append(&mut extract_vec(mapping, "eventHandlers"));
            functions.append(&mut extract_vec(mapping, "callHandlers"));

            let handlers = functions
                .iter()
                .map(|function| extract_string(function, "handler"))
                .collect();

            (name, handlers)
        })
        .collect()
}

/// fn get_schema_location(path: &str) -> String
/// Extracts the schema location from subraph.yaml
/// Will panic if the `schema` or `file` key is missing
pub fn get_schema_location(path: &str) -> String {
    let subgraph_yaml = parse_yaml(path);

    let schema = subgraph_yaml
        .get("schema")
        .expect("Couldn't get schema from yaml file.");

    extract_string(schema, "file")
}

#[cfg(test)]
mod schema_tests {
    use super::*;
    use std::collections::HashMap;

    #[test]
    #[should_panic(
        expected = "🆘 Something went wrong while trying to read `mocks/subgraphs/no_subgraph.yaml`: No such file or directory (os error 2)"
    )]
    fn parse_yaml_should_panic_when_file_is_missing() {
        parse_yaml("mocks/subgraphs/no_subgraph.yaml");
    }

    #[test]
    #[should_panic(
        expected = "🆘 Something went wrong when parsing `mocks/subgraphs/subgraph_invalid.yaml`: while parsing a block mapping, did not find expected key at line 6 column 1"
    )]
    fn parse_yaml_should_panic_when_file_is_invalid() {
        parse_yaml("mocks/subgraphs/subgraph_invalid.yaml");
    }

    #[test]
    fn get_schema_location_returns_schema_location() {
        let schema_location = get_schema_location("mocks/subgraphs/subgraph.yaml");

        assert_eq!(schema_location, "./schema.graphql".to_string())
    }

    #[test]
    #[should_panic(expected = "Couldn't find key `name` in subgraph.yaml")]
    fn parse_string_should_panic_if_key_missing() {
        let yaml = parse_yaml("mocks/subgraphs/subgraph_no_name.yaml");
        extract_string(&yaml, "name");
    }

    #[test]
    fn collect_handlers_returns_all_handlers() {
        let handlers = collect_handlers("mocks/subgraphs/subgraph.yaml");
        let mut expected: HashMap<String, Vec<String>> = HashMap::new();
        expected.insert(
            "Gravity".to_string(),
            vec![
                "handleNewGravatar".to_string(),
                "handleCreateGravatar".to_string(),
            ],
        );
        expected.insert(
            "GraphTokenLockWallet".to_string(),
            vec!["handleTokensReleased".to_string()],
        );

        assert_eq!(handlers, expected)
    }

    #[test]
    fn collect_handlers_returns_empty_vec_if_no_handlers() {
        let handlers = collect_handlers("mocks/subgraphs/subgraph_no_handlers.yaml");
        let mut expected: HashMap<String, Vec<String>> = HashMap::new();
        expected.insert("Gravity".to_string(), vec![]);

        assert_eq!(handlers, expected)
    }
}
