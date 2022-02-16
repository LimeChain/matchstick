use colored::Colorize;
use graph::prelude::serde_yaml;
use graph::prelude::serde_yaml::{Sequence, Value};
use regex::Regex;
use run_script::{run_or_exit, ScriptOptions};
use std::collections::HashMap;
use std::fs;
use std::path::PathBuf;

#[derive(Debug)]
struct Mapping {
    event_handlers: Vec<String>,
    call_handlers: Vec<String>,
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
struct Datasource {
    name: String,
    mapping: Mapping,
}

impl Datasource {
    pub fn new(name: String) -> Self {
        Datasource {
            name,
            mapping: Mapping::new(),
        }
    }
}

/// Performs a check if a handler is called in a test suite
fn is_called(wat_contents: &str, handler: &str) -> bool {
    let pattern = format!(r#"call.+{}"#, handler);
    let regex = Regex::new(&pattern).expect("Not a valid regex pattern.");
    let captures = regex.captures(wat_contents);

    captures.is_some()
}

/// Extracts the handler name
fn parse(v: &Value) -> String {
    serde_yaml::to_string(v)
        .expect("Could not convert serde_yaml value to string.")
        .split('\n')
        .collect::<String>()
        .split("---")
        .collect::<String>()
}

pub fn generate_coverage_report() {
    let mut tests_location = "".to_owned();

    crate::TESTS_LOCATION.with(|path| {
        tests_location = (&*path.borrow()).to_owned();
    });

    let subgraph_yaml_contents = fs::read_to_string("subgraph.yaml")
        .expect("Something went wrong reading the 'subgraph.yaml' file");
    let subgraph_yaml: Value = serde_yaml::from_str(&subgraph_yaml_contents)
        .expect("Something went wrong when parsing 'subgraph.yaml'. Please ensure that the file exists and is valid.");
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

    let mut datasources = vec![];

    for d in sources_yml {
        let name = d.get("name").expect("No field 'name' in datasource.");

        let mapping = d.get("mapping").expect("No field 'mapping' in datasource.");

        let mut datasource = Datasource::new(
            serde_yaml::to_string(name).expect("Could not convert serde yaml value to string."),
        );

        let events = mapping.get("eventHandlers");
        let functions = mapping.get("callHandlers");

        if let Some(events) = events {
            for e in events
                .as_sequence()
                .expect("Could not convert events to sequence.")
            {
                let handler = parse(e.get("handler").expect("No field 'handler' on event."));
                datasource.mapping.event_handlers.push(handler);
            }
        }

        if let Some(functions) = functions {
            for f in functions
                .as_sequence()
                .expect("Could not convert to sequence.")
            {
                let handler = parse(f.get("handler").expect("No field 'handler' on call."));
                datasource.mapping.call_handlers.push(handler);
            }
        }
        datasources.push(datasource);
    }

    let msg = format!("Couldn't find folder '{}/.bin'.", &tests_location);
    let paths = fs::read_dir(format!("{}/.bin", &tests_location)).expect(&msg);

    let mut files: Vec<String> = Vec::new();

    for path in paths {
        let file_name = path
            .expect("Couldn't find generated test wasm binary.")
            .path()
            .display()
            .to_string();
        if file_name.ends_with(".wasm") {
            files.push(file_name);
        }
    }

    println!(
        "{}",
        ("Reading generated test modules... 🔎️").to_owned().cyan()
    );

    println!("{}", ("Generating coverage report 📝\n").to_owned().cyan());

    let mut global_handlers_count: i32 = 0;
    let mut global_handlers_called: i32 = 0;

    // Converts each wasm file to wat
    // Returns a collection of all .wat files paths
    let wat_files: Vec<String> = files
        .iter()
        .map(|file| {
            let mut destination = PathBuf::from(&file);
            destination.set_extension("wat");

            let mut convert_command = "".to_owned();

            crate::LIBS_LOCATION.with(|path| {
                convert_command = format!(
                    "{}/{} {} {} {:?}",
                    &*path.borrow(),
                    "wabt/bin/wasm2wat",
                    file,
                    "-o",
                    destination
                );
            });

            let options = ScriptOptions::new();
            let args = vec![];

            run_or_exit(&convert_command, &args, &options);

            destination.to_str().unwrap().to_owned()
        })
        .collect();

    // Maps every source name ot its handlers
    let source_handlers: HashMap<String, Vec<String>> = datasources
        .iter()
        .map(|datasource| {
            let d_name = datasource
                .name
                .split('\n')
                .collect::<String>()
                .split("---")
                .collect::<String>();

            let mut handlers = vec![];

            for handler in &datasource.mapping.event_handlers {
                handlers.push(handler.clone());
            }

            for handler in &datasource.mapping.call_handlers {
                handlers.push(handler.clone());
            }

            (d_name, handlers)
        })
        .collect();

    for (name, handlers) in source_handlers.into_iter() {
        println!("Handlers for source '{}':", name);

        let mut called: i32 = 0;
        let all_handlers: i32 = handlers.len().try_into().unwrap();

        // Iterates over every handler and checks if the handler has been called in any test suite
        // If called, it'll set `is_tested` to true and break out of the loop
        // called will be incremented by 1
        for handler in handlers {
            let mut is_tested = false;

            for wat_file in &wat_files {
                let wat_contents = fs::read_to_string(&wat_file).expect("Couldn't read wat file.");

                if is_called(&wat_contents, &handler) {
                    is_tested = true;
                    break;
                }
            }

            if is_tested {
                called += 1;
                let msg = format!("Handler '{}' is tested.", handler);
                println!("{}", msg.green());
            } else {
                let msg = format!("Handler '{}' is not tested.", handler);
                println!("{}", msg.red());
            }
        }

        let mut percentage: f32 = 0.0;

        if all_handlers > 0 {
            percentage = (called as f32 * 100.0) / all_handlers as f32;
        }

        println!(
            "Test coverage: {:.1}% ({}/{} handlers).\n",
            percentage, called, all_handlers
        );

        global_handlers_count += all_handlers;
        global_handlers_called += called;
    }

    let mut percentage: f32 = 0.0;

    if global_handlers_count > 0 {
        percentage = (global_handlers_called as f32 * 100.0) / global_handlers_count as f32;
    }

    println!(
        "Global test coverage: {:.1}% ({}/{} handlers).\n",
        percentage, global_handlers_called, global_handlers_count
    );
}
