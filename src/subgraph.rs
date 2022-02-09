use serde_yaml::{Sequence, Value};
use std::fs;

#[derive(Debug)]
pub struct Mapping {
    pub event_handlers: Vec<String>,
    pub call_handlers: Vec<String>,
}

impl Mapping {
    pub fn new() -> Self {
        Mapping {
            event_handlers: vec![],
            call_handlers: vec![],
        }
    }
}

#[derive(Debug)]
pub struct Datasource {
    pub name: String,
    pub mapping: Mapping,
}

impl Datasource {
    pub fn new(name: String) -> Self {
        Datasource {
            name,
            mapping: Mapping::new(),
        }
    }
}

/// Extracts the handler name
fn extract_handler(v: &Value) -> String {
    serde_yaml::to_string(v)
        .expect("Could not convert serde_yaml value to string.")
        .split('\n')
        .collect::<String>()
        .split("---")
        .collect::<String>()
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

pub fn get_datasources() -> Vec<Datasource> {
    let sources_yml = parse_sources();

    let mut datasources = vec![];

    for source in sources_yml {
        let name = source.get("name").expect("No field 'name' in datasource.");

        let mapping = source
            .get("mapping")
            .expect("No field 'mapping' in datasource.");

        let mut datasource = Datasource::new(
            serde_yaml::to_string(name).expect("Could not convert serde yaml value to string."),
        );

        let events = mapping.get("eventHandlers");
        let functions = mapping.get("callHandlers");

        if let Some(events) = events {
            for event in events
                .as_sequence()
                .expect("Could not convert events to sequence.")
            {
                let handler =
                    extract_handler(event.get("handler").expect("No field 'handler' on event."));
                datasource.mapping.event_handlers.push(handler);
            }
        }

        if let Some(functions) = functions {
            for f in functions
                .as_sequence()
                .expect("Could not convert to sequence.")
            {
                let handler =
                    extract_handler(f.get("handler").expect("No field 'handler' on call."));
                datasource.mapping.call_handlers.push(handler);
            }
        }
        datasources.push(datasource);
    }

    datasources
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
