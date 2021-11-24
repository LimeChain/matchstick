use colored::Colorize;
use graph::prelude::serde_yaml;
use graph::prelude::serde_yaml::{Sequence, Value};
use regex::Regex;
use run_script::{run_or_exit, ScriptOptions};
use std::fs;

#[derive(Debug)]
struct Mapping {
    name: String,
    event_handlers: Vec<String>,
    call_handlers: Vec<String>,
}

impl Mapping {
    pub fn new(name: String) -> Self {
        Mapping {
            name,
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
    pub fn new(name: String, mapping: String) -> Self {
        Datasource {
            name,
            mapping: Mapping::new(mapping),
        }
    }
}

fn install_wabt() {
    let options = ScriptOptions::new();
    let args = vec![];

    println!(
        "{}",
        ("Downloading necessary tools... 🛠️").to_string().cyan()
    );

    run_or_exit(
        r#"
         cd tests &&
         mkdir .tools &&
         cd .tools &&
         git clone --recursive https://github.com/WebAssembly/wabt &&
         cd wabt && git submodule update --init
         cd ../..
         "#,
        &args,
        &options,
    );

    let options = ScriptOptions::new();
    let args = vec![];

    println!(
        "{}",
        ("Building. This might take a while... ⌛️")
            .to_string()
            .cyan()
    );

    run_or_exit(
        r#"
         cd tests/.tools/wabt &&
         mkdir -p build &&
         cd build &&
         cmake .. &&
         cmake --build . &&
         cd ../../..
         "#,
        &args,
        &options,
    );
}

fn inspect_handlers(wat_contents: &str, handlers: &[String]) -> i32 {
    let mut called = 0;

    for handler in handlers {
        let pattern = format!(r#"call.+{}"#, handler);

        let regex = Regex::new(&pattern).expect("Not a valid regex pattern.");

        let captures = regex.captures(wat_contents);
        if captures.is_some() {
            called += 1;
            let msg = format!("Handler '{}' is tested.", handler);
            println!("{}", msg.green());
        } else {
            let msg = format!("Handler '{}' is not tested.", handler);
            println!("{}", msg.red());
        }
    }

    called
}

fn parse(v: &Value) -> String {
    serde_yaml::to_string(v)
        .expect("Could not convert serde_yaml value to string.")
        .split('\n')
        .collect::<String>()
        .split("---")
        .collect::<String>()
}

pub fn generate_coverage_report() {
    install_wabt();

    let subgraph_yaml_contents = fs::read_to_string("subgraph.yaml")
        .expect("Something went wrong reading the 'subgraph.yaml' file");
    let subgraph_yaml: Value = serde_yaml::from_str(&subgraph_yaml_contents)
        .expect("Something went wrong when parsing 'subgraph.yaml'. Please ensure that the file exists and is valid.");
    let datasources_yml: Sequence = subgraph_yaml
        .get("dataSources")
        .expect("No DataSources in subgraph_yaml.")
        .as_sequence()
        .expect("An unexpected error occurred when converting datasources to sequence.")
        .to_vec();

    let mut datasources = vec![];

    for d in datasources_yml {
        let name = d.get("name").expect("No field 'name' in datasource.");

        let mapping = d.get("mapping").expect("No field 'mapping' in datasource.");
        let file_path =
            serde_yaml::to_string(mapping.get("file").expect("No field 'file' on mapping."))
                .expect("Could not convert serde yaml value to string.");

        let parts = file_path.split('/').collect::<Vec<&str>>();
        let file = parts
            .last()
            .expect("Could not get last element of string Vec 'file'.")
            .split('.')
            .collect::<Vec<&str>>();
        let mapping_name = *file
            .first()
            .expect("Could not get first element of string Vec 'mapping_name'.");

        let mut datasource = Datasource::new(
            serde_yaml::to_string(name).expect("Could not convert serde yaml value to string."),
            mapping_name.to_string(),
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

    let paths = fs::read_dir("tests/.bin").expect("Couldn't find folder 'tests/.bin'.");
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
        ("Reading generated test modules... 🔎️").to_string().cyan()
    );

    println!("{}", ("Generating coverage report 📝\n").to_string().cyan());

    let mut global_handlers_count: i32 = 0;
    let mut global_handlers_called: i32 = 0;

    for file in files {
        let destination: String = file
            .chars()
            .take(file.len() - 2)
            .collect::<String>()
            .to_string()
            + "t";
        let temp1 = file
            .chars()
            .take(file.len() - 5)
            .collect::<String>()
            .to_string();
        let temp2 = temp1.split('/').collect::<Vec<&str>>();
        let f_name = temp2
            .last()
            .expect("Couldn't get last element of string Vec 'f_name'.");

        let convert_command = format!(
            "{} {} {} {}",
            "tests/.tools/wabt/build/wasm2wat", file, "-o", destination
        );

        let options = ScriptOptions::new();
        let args = vec![];

        run_or_exit(&convert_command, &args, &options);

        let wat_contents = fs::read_to_string(&destination).expect("Couldn't read wat file.");

        for datasource in &datasources {
            if *f_name != datasource.mapping.name {
                continue;
            }

            let d_name = datasource
                .name
                .split('\n')
                .collect::<String>()
                .split("---")
                .collect::<String>();

            println!("Handlers for source '{}':", d_name);
            let mut called: i32 = 0;
            let mut all_handlers: i32 = 0;

            all_handlers += datasource.mapping.event_handlers.len() as i32;

            let called_event_handlers =
                inspect_handlers(&wat_contents, &datasource.mapping.event_handlers);
            called += called_event_handlers;

            all_handlers += datasource.mapping.call_handlers.len() as i32;

            let called_function_handlers =
                inspect_handlers(&wat_contents, &datasource.mapping.call_handlers);
            called += called_function_handlers;

            global_handlers_count += all_handlers;
            global_handlers_called += called;

            let percentage = (called * 100) / all_handlers;
            println!(
                "Test coverage: {}% ({}/{} handlers).\n",
                (percentage as f32).ceil(),
                called,
                all_handlers
            );
        }
    }

    let percentage = (global_handlers_called * 100) / global_handlers_count;
    println!(
        "Global test coverage: {}% ({}/{} handlers).\n",
        (percentage as f32).ceil(),
        global_handlers_called,
        global_handlers_count
    );
}
