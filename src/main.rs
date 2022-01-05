use std::cell::RefCell;
use std::collections::{HashMap, HashSet};
use std::fs;
use std::io::{self, Write};
use std::path::PathBuf;
use std::time::Instant;

use clap::{App, Arg};
use colored::Colorize;
use graph::prelude::chrono::prelude::*;
use graph_chain_ethereum::Chain;
use serde_yaml::Value;

use crate::compiler::{CompileOutput, Compiler};
use crate::instance::MatchstickInstance;
use crate::logging::Log;
use crate::test_suite::{TestResult, TestSuite};

use crate::coverage::generate_coverage_report;

mod compiler;
mod context;
mod coverage;
mod instance;
mod integration_tests;
mod logging;
mod subgraph_store;
mod test_suite;
mod unit_tests;
mod writable_store;

thread_local!(pub(crate) static SCHEMA_LOCATION: RefCell<String> = RefCell::new("".to_string()));
thread_local!(pub(crate) static TESTS_LOCATION: RefCell<String> = RefCell::new("".to_string()));
thread_local!(pub(crate) static LIBS_LOCATION: RefCell<String> = RefCell::new("".to_string()));

/// Returns the names and `fs::DirEntry`'s of the testable sources under the selected tests directory.
fn get_testable() -> HashMap<String, fs::DirEntry> {
    let mut testable: HashMap<String, fs::DirEntry> = HashMap::new();
    TESTS_LOCATION.with(|path| {
        testable = fs::read_dir(&*path.borrow())
            .unwrap_or_else(|err| {
                panic!(
                    "{}",
                    Log::Critical(format!(
                        "Something went wrong while trying to read `{}`: {}",
                        &*path.borrow(),
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
    });

    if testable.is_empty() {
        panic!("{}", Log::Critical("No tests have been written yet."));
    }

    testable
}

fn main() {
    let matches = App::new("Matchstick 🔥")
        .version("0.2.2")
        .author("Limechain <https://limechain.tech>")
        .about("Unit testing framework for Subgraph development on The Graph protocol.")
        .arg(
            Arg::with_name("lib")
                .help("Path to `node_modules`.")
                .long("lib")
                .short("l")
                .takes_value(true)
                .default_value("./node_modules/"),
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
            Arg::with_name("recompile")
                .help("Force-recompiles the tests.")
                .long("recompile")
                .short("r")
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

    let subgraph_yaml_contents = std::fs::read_to_string("subgraph.yaml")
        .expect("❌ ❌ ❌  Something went wrong reading the 'subgraph.yaml' file.");
    let subgraph_yaml: Value = serde_yaml::from_str(&subgraph_yaml_contents).expect(
        r#"
        ❌ ❌ ❌  Something went wrong when parsing 'subgraph.yaml'.
        Please ensure that the file exists and that the yaml is valid."#,
    );
    let schema = subgraph_yaml
        .get("schema")
        .expect("Couldn't get schema from yaml file.");
    let file_location = schema
        .get("file")
        .expect("Couldn't get schema file location");
    SCHEMA_LOCATION.with(|path| *path.borrow_mut() = file_location.as_str().unwrap().to_string());
    let default_tests_folder = &Value::String(String::from("./tests/"));
    let tests_folder = subgraph_yaml.get("testsFolder").unwrap_or_else(|| {
        println!("{}", ("If you want to change the default tests folder location (./tests) you can add 'testsFolder: ./example/path' to the outermost level of your subgraph.yaml").cyan());
        default_tests_folder
    });
    TESTS_LOCATION.with(|path| {
        let mut tests_path = tests_folder.as_str().unwrap().to_string();
        if tests_path.ends_with('/') {
            tests_path.pop();
        }

        *path.borrow_mut() = tests_path;
    });

    let libs_path = matches
        .value_of("lib")
        .expect("unexpected: lib should always have a value");
    LIBS_LOCATION.with(|path| *path.borrow_mut() = libs_path.to_string());

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
    let compiler = Compiler::new(PathBuf::from(libs_path))
        .export_table()
        .runtime("stub")
        .optimize()
        .debug();

    let outputs: HashMap<String, CompileOutput> = test_sources
        .into_iter()
        .map(|(name, entry)| {
            (
                name.clone(),
                compiler.execute(name, entry, matches.is_present("recompile")),
            )
        })
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

    println!("{}", ("\nIgniting tests 🔥\n").to_string().bright_red());

    let (mut num_passed, mut num_failed) = (0, 0);
    let failed_suites: HashMap<String, HashMap<String, TestResult>> = test_suites
        .into_iter()
        .filter_map(|(name, suite)| {
            println!("🧪 Running Test Suite: {}", name.bright_blue());
            println!("{}\n", "=".repeat(50));
            logging::add_indent();
            let failed: HashMap<String, TestResult> = suite
                .tests
                .into_iter()
                .filter_map(|test| {
                    let result = test.run();
                    if result.passed {
                        num_passed += 1;
                        None
                    } else {
                        num_failed += 1;
                        Some((test.name, result))
                    }
                })
                .collect();
            logging::clear_indent();
            println!();

            if failed.is_empty() {
                None
            } else {
                Some((name, failed))
            }
        })
        .collect();

    if num_failed > 0 {
        let failed = format!("{} failed", num_failed).red();
        let passed = format!("{} passed", num_passed).green();
        let all = format!("{} total", num_failed + num_passed);

        println!("Failed tests: \n");
        for (suite, tests) in failed_suites {
            for (name, result) in tests {
                println!("{} {}", suite.bright_blue(), name.red(),);

                if !result.logs.is_empty() {
                    println!("{}", result.logs);
                }
            }
        }

        println!("\n{}, {}, {}", failed, passed, all);
    } else {
        println!(
            "\n{}",
            format!("All {} tests passed! 😎", num_passed).green()
        );
    }

    println!(
        "\n[{}] Program executed in: {:.3?}.",
        Local::now().to_rfc2822(),
        now.elapsed()
    );
}
