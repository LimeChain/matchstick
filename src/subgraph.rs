use serde_yaml::{Sequence, Value};
use std::collections::HashMap;
use std::fs;

/// Extracts the handler name
fn extract_string(value: &Value, key: &str) -> String {
    value
        .get(key)
        .unwrap_or_else(|| panic!("Couldn't find key `{}` in subgraph.yaml", key))
        .as_str()
        .unwrap_or_else(|| panic!("Couldn't parse `{}` as str", key))
        .to_string()
}

fn extract_vec(value: &Value, key: &str) -> Sequence {
    value
        .get(key)
        .unwrap_or(&Value::Sequence(vec![]))
        .as_sequence()
        .unwrap_or_else(|| panic!("Couldn't parse `{}` as Sequence", key))
        .to_vec()
}

fn parse_yaml() -> Value {
    let subgraph_yaml_contents = fs::read_to_string("subgraph.yaml")
        .expect("Something went wrong reading the 'subgraph.yaml' file");
    let subgraph_yaml: Value = serde_yaml::from_str(&subgraph_yaml_contents)
        .expect("Something went wrong when parsing 'subgraph.yaml'. Please ensure that the file exists and is valid.");

    subgraph_yaml
}

fn parse_sources() -> Sequence {
    let subgraph_yaml = parse_yaml();

    let mut sources = vec![];
    sources.append(&mut extract_vec(&subgraph_yaml, "dataSources"));
    sources.append(&mut extract_vec(&subgraph_yaml, "templates"));

    sources
}

pub fn collect_handlers() -> HashMap<String, Vec<String>> {
    parse_sources()
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

pub fn get_schema_location() -> String {
    let subgraph_yaml = parse_yaml();

    let schema = subgraph_yaml
        .get("schema")
        .expect("Couldn't get schema from yaml file.");

    extract_string(schema, "file")
}
