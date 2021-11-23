use regex::Regex;
use std::collections::{HashMap, HashSet};
use std::fs;
use std::io::{self, Write};
use std::time::Instant;

use clap::{App, Arg};
use colored::Colorize;
use graph_chain_ethereum::Chain;

use crate::compiler::{CompileOutput, Compiler};
use crate::instance::MatchstickInstance;
use crate::logging::Log;
use crate::test_suite::TestSuite;
use graph::prelude::serde_yaml;
use graph::prelude::serde_yaml::{Sequence, Value};
use run_script::ScriptOptions;

mod compiler;
mod context;
mod instance;
mod integration_tests;
mod logging;
mod subgraph_store;
mod test_suite;
mod unit_tests;
mod writable_store;

/// Returns the names and `fs::DirEntry`'s of the testable sources under the `tests/` directory.
fn get_testable() -> HashMap<String, fs::DirEntry> {
    let testable: HashMap<String, fs::DirEntry> = fs::read_dir("./tests/")
        .unwrap_or_else(|err| {
            panic!(
                "{}",
                Log::Critical(format!(
                    "Something went wrong while trying to read `tests/`: {}",
                    err,
                )),
            );
        })
        .filter_map(|entry| {
            let entry = entry.unwrap_or_else(|err| panic!("{}", Log::Critical(err)));
            let name = entry.file_name().to_str().unwrap().to_ascii_lowercase();

            if name.ends_with(".test.ts") {
                Some((name.replace(".test.ts", ""), entry))
            } else if entry
                .file_type()
                .unwrap_or_else(|err| panic!("{}", Log::Critical(err)))
                .is_dir()
                && entry
                    .path()
                    .read_dir()
                    .unwrap_or_else(|err| panic!("{}", Log::Critical(err)))
                    .any(|entry| {
                        entry
                            .unwrap_or_else(|err| panic!("{}", Log::Critical(err)))
                            .file_name()
                            .to_str()
                            .unwrap()
                            .ends_with(".test.ts")
                    })
            {
                Some((name, entry))
            } else {
                None
            }
        })
        .collect();

    if testable.is_empty() {
        panic!("{}", Log::Critical("No tests have been written yet."));
    }

    testable
}

// TODO: Move this into coverage file
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

// TODO: Move this into coverage file
#[derive(Debug)]
struct Datasource {
    name: String,
    mapping: Mapping,
}

// TODO: Move this into coverage file
impl Datasource {
    pub fn new(name: String, mapping: String) -> Self {
        Datasource {
            name,
            mapping: Mapping::new(mapping),
        }
    }
}

// TODO: Extract getting wabt tool in separate function
fn generate_coverage_report() {
    // TODO: Handle failure
    //  1. Clone repo
    let options = ScriptOptions::new();
    let args = vec![];

    println!(
        "{}",
        ("Downloading necessary tools... 🛠️").to_string().cyan()
    );

    let (_code, _output, _error) = run_script::run(
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
    )
    .unwrap();

    // 2. Build wabt
    let options = ScriptOptions::new();
    let args = vec![];

    println!(
        "{}",
        ("Building. This might take a while... ⌛️")
            .to_string()
            .cyan()
    );

    // TODO: Handle failure
    let (_code, _output, _error) = run_script::run(
        r#"
         cd tests/.tools/wabt &&
         mkdir build &&
         cd build &&
         cmake .. &&
         cmake --build . &&
         cd ../../..
         "#,
        &args,
        &options,
    )
    .unwrap();

    // We can now assume that everything is already built

    let subgraph_yaml_contents = fs::read_to_string("subgraph.yaml")
        .expect("Something went wrong reading the 'subgraph.yaml' file");
    let subgraph_yaml: Value = serde_yaml::from_str(&subgraph_yaml_contents)
        .expect("Something went wrong when parsing 'subgraph.yaml'. Please ensure that the file exists and is valid.");
    let datasources_yml: Sequence = subgraph_yaml
        .get("dataSources")
        .unwrap()
        .as_sequence()
        .unwrap()
        .to_vec();

    let mut datasources = vec![];

    for d in datasources_yml {
        let name = d.get("name").unwrap();

        let mapping = d.get("mapping").unwrap();
        let file_path = serde_yaml::to_string(mapping.get("file").unwrap()).unwrap();

        let parts = file_path.split('/').collect::<Vec<&str>>();
        let file = parts.last().unwrap().split('.').collect::<Vec<&str>>();
        let mapping_name = *file.first().unwrap();

        let mut datasource = Datasource::new(
            serde_yaml::to_string(name).unwrap(),
            mapping_name.to_string(),
        );

        // TODO: handle case where there are no event handlers
        let events = mapping.get("eventHandlers").unwrap().as_sequence().unwrap();

        let functions = mapping.get("callHandlers");

        // TODO: this can be generic
        for e in events {
            let handler = serde_yaml::to_string(e.get("handler").unwrap())
                .unwrap()
                .split('\n')
                .collect::<String>()
                .split("---")
                .collect::<String>();

            datasource.mapping.event_handlers.push(handler);
        }

        // TODO: this can be generic
        if let Some(functions) = functions {
            for f in functions.as_sequence().unwrap() {
                let handler = serde_yaml::to_string(f.get("handler").unwrap())
                    .unwrap()
                    .split('\n')
                    .collect::<String>()
                    .split("---")
                    .collect::<String>();

                datasource.mapping.call_handlers.push(handler);
            }
        }
        datasources.push(datasource);
    }

    // TODO: get all .wasm files in .bin (there should be only .wasm files there, so we can safely just get all files)
    let paths = fs::read_dir("tests/.bin").unwrap();
    let mut files: Vec<String> = Vec::new();

    for path in paths {
        let file_name = path.unwrap().path().display().to_string();
        if file_name.ends_with(".wasm") {
            files.push(file_name);
        }
    }

    println!(
        "{}",
        ("Reading generated test modules... 🔎️").to_string().cyan()
    );

    println!("{}", ("Generating coverage report 📝\n").to_string().cyan());

    for f in files {
        let destination: String = f.chars().take(f.len() - 2).collect::<String>().to_string() + "t";
        let temp1 = f.chars().take(f.len() - 5).collect::<String>().to_string();
        let temp2 = temp1.split('/').collect::<Vec<&str>>();
        let f_name = temp2.last().unwrap();

        let convert_command = format!(
            "{} {} {} {}",
            "tests/.tools/wabt/build/wasm2wat", f, "-o", destination
        );

        // TODO: convert to wat file (with command again)
        // TODO: Handle failure
        let (_code, _output, _error) = run_script::run(&convert_command, &args, &options).unwrap();

        // TODO: handle failure
        let wat_contents = fs::read_to_string(&destination).unwrap();

        // TODO: handle error
        // TODO: Loop through handlers
        for d in &datasources {
            if *f_name != d.mapping.name {
                continue;
            }

            let d_name = d
                .name
                .split('\n')
                .collect::<String>()
                .split("---")
                .collect::<String>();

            println!("Handlers for source '{}':", d_name);
            let mut called = 0;
            let mut all_handlers = 0;

            all_handlers += d.mapping.event_handlers.len();

            // TODO: Make generic
            for handler in &d.mapping.event_handlers {
                let pattern = format!(r#"call.+{}"#, handler);

                let regex = Regex::new(&pattern).unwrap();

                let captures = regex.captures(&wat_contents);
                if captures.is_some() {
                    called += 1;
                    let msg = format!("Handler '{}' is tested.", handler);
                    println!("{}", msg.green());
                } else {
                    let msg = format!("Handler '{}' is not tested.", handler);
                    println!("{}", msg.red());
                }
            }

            all_handlers += d.mapping.call_handlers.len();

            // TODO: Make generic
            for handler in &d.mapping.call_handlers {
                let pattern = format!(r#"call.+{}"#, handler);

                let regex = Regex::new(&pattern).unwrap();

                let captures = regex.captures(&wat_contents);
                if captures.is_some() {
                    called += 1;
                    let msg = format!("Handler '{}' is tested.", handler);
                    println!("{}", msg.green());
                } else {
                    let msg = format!("Handler '{}' is not tested.", handler);
                    println!("{}", msg.red());
                }
            }

            let percentage = (called * 100) / all_handlers;
            println!(
                "Test coverage: {}% ({}/{} handlers).\n",
                (percentage as f32).ceil(),
                called,
                all_handlers
            );
        }
    }
}

fn main() {
    let matches = App::new("Matchstick 🔥")
        .version("0.2.0")
        .author("Limechain <https://limechain.tech>")
        .about("Unit testing framework for Subgraph development on The Graph protocol.")
        .arg(
            Arg::with_name("verbose")
                .help("Print the WASM backtrace on test failure.")
                .long("verbose")
                .short("v"),
        )
        .arg(
            Arg::with_name("coverage")
                .help("Generate code coverage report.")
                .long("coverage")
                .short("c")
                .takes_value(false)
                .required(false),
        )
        .arg(
            Arg::with_name("test_suites")
                .help("Please specify the names of the test suites you would like to run.")
                .index(1)
                .multiple(true),
        )
        .get_matches();

    println!(
        "{}",
        (r#"
___  ___      _       _         _   _      _
|  \/  |     | |     | |       | | (_)    | |
| .  . | __ _| |_ ___| |__  ___| |_ _  ___| | __
| |\/| |/ _` | __/ __| '_ \/ __| __| |/ __| |/ /
| |  | | (_| | || (__| | | \__ \ |_| | (__|   <
\_|  |_/\__,_|\__\___|_| |_|___/\__|_|\___|_|\_\
                                                "#)
        .to_string()
        .bright_red()
    );

    let now = Instant::now();

    let test_sources = {
        let testable = get_testable();
        if let Some(vals) = matches.values_of("test_suites") {
            let sources: HashSet<String> = vals
                .collect::<Vec<&str>>()
                .iter()
                .map(|&s| String::from(s).to_ascii_lowercase())
                .collect();

            let unrecog_sources: Vec<String> = sources
                .difference(&testable.keys().cloned().collect())
                .map(String::from)
                .collect();

            if !unrecog_sources.is_empty() {
                panic!(
                    "{}",
                    Log::Critical(format!(
                        "The following tests could not be found: {}",
                        unrecog_sources.join(", "),
                    )),
                );
            }

            testable
                .into_iter()
                .filter(|(name, _)| sources.contains(name))
                .collect()
        } else {
            testable
        }
    };

    println!("{}", ("Compiling...\n").to_string().bright_green());
    let compiler = Compiler::default()
        .export_table()
        .runtime("stub")
        .optimize()
        .debug();

    let outputs: HashMap<String, CompileOutput> = test_sources
        .into_iter()
        .map(|(name, entry)| (name.clone(), compiler.compile(name, entry)))
        .collect();

    if outputs.values().any(|output| !output.status.success()) {
        outputs.values().for_each(|output| {
            io::stderr()
                .write_all(&output.stderr)
                .unwrap_or_else(|err| {
                    panic!(
                        "{}",
                        Log::Critical(format!("Could not write to `stderr`: {}", err)),
                    );
                });
        });

        panic!(
            "{}",
            Log::Critical("Please attend to the compilation errors above!"),
        );
    }

    let coverage = matches.is_present("coverage");
    if coverage {
        println!(
            "{}",
            ("Running in coverage report mode.\n️").to_string().cyan()
        );
        generate_coverage_report();
        return;
    }

    // A matchstick instance for each test suite wasm (the compiled source).
    let ms_instances: HashMap<String, MatchstickInstance<Chain>> = outputs
        .into_iter()
        .map(|(key, val)| (key, MatchstickInstance::<Chain>::new(&val.file)))
        .collect();

    // A test suite abstraction for each instance.
    let test_suites: HashMap<String, TestSuite> = ms_instances
        .iter()
        .map(|(key, val)| (key.clone(), TestSuite::from(val)))
        .collect();

    let mut passed_tests = 0;
    let mut failed_tests = 0;
    println!("{}", ("Igniting tests 🔥\n").to_string().bright_red());
    test_suites.iter().for_each(|(key, val)| {
        println!("🧪 Running Test Suite: {}", key.blue());
        println!("{}\n", "=".repeat(50));
        logging::add_indent();
        for test in &val.tests {
            if test.run(matches.is_present("verbose")).passed {
                passed_tests += 1;
            } else {
                failed_tests += 1;
            }
        }
        logging::clear_indent();
        println!();
    });

    if failed_tests > 0 {
        let failed = format!("{} failed", failed_tests).red();
        let passed = format!("{} passed", passed_tests).green();
        let all = format!("{} total", failed_tests + passed_tests);

        println!("\n{}, {}, {}", failed, passed, all);
        println!("Program execution time: {:?}", now.elapsed());
        std::process::exit(1);
    } else {
        println!("\n{}", ("All tests passed! 😎").to_string().green());
    }

    println!(
        "{} tests executed in {:?}.",
        failed_tests + passed_tests,
        now.elapsed(),
    );
}
