use serde_yaml::{Sequence, Value};
use std::fs;

fn parse_yaml() -> Value {
    let subgraph_yaml_contents = fs::read_to_string("subgraph.yaml")
        .expect("Something went wrong reading the 'subgraph.yaml' file");
    let subgraph_yaml: Value = serde_yaml::from_str(&subgraph_yaml_contents)
        .expect("Something went wrong when parsing 'subgraph.yaml'. Please ensure that the file exists and is valid.");

    subgraph_yaml
}

pub fn get_sources() -> Sequence {
    let subgraph_yaml = parse_yaml();

    let mut sources_yml: Sequence = subgraph_yaml
        .get("dataSources")
        .expect("No DataSources in subgraph_yaml.")
        .as_sequence()
        .expect("An unexpected error occurred when converting datasources to sequence.")
        .to_vec();

    let mut templates_yml = match subgraph_yaml.get("templates") {
        Some(templates) => templates
            .as_sequence()
            .expect("An unexpected error occurred when converting datasources to sequence.")
            .to_vec(),
        None => Vec::new(),
    };

    sources_yml.append(&mut templates_yml);

    sources_yml
}

pub fn get_schema_location() -> String {
    let subgraph_yaml = parse_yaml();

    let schema = subgraph_yaml
        .get("schema")
        .expect("Couldn't get schema from yaml file.");

    schema
        .get("file")
        .expect("Couldn't get schema file location")
        .as_str()
        .unwrap()
        .to_string()
}
