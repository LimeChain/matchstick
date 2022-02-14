use std::cell::RefCell;
use std::collections::{HashMap, HashSet};
use std::io::{self, Write};
use std::path::PathBuf;
use std::time::Instant;

use clap::ArgMatches;
use colored::Colorize;
use graph::prelude::chrono::prelude::*;
use graph_chain_ethereum::Chain;

use crate::compiler::{CompileOutput, Compiler};
use crate::config::MatchstickConfig;
use crate::instance::MatchstickInstance;
use crate::logging::Log;
use crate::test_suite::{TestResult, TestSuite};

use crate::coverage::generate_coverage_report;

mod cli;
mod compiler;
mod config;
mod context;
mod coverage;
mod instance;
mod integration_tests;
mod logging;
mod subgraph;
mod subgraph_store;
mod test_suite;
mod unit_tests;
mod writable_store;

thread_local! {
    pub(crate) static SCHEMA_LOCATION: RefCell<PathBuf> = RefCell::new(PathBuf::new());
    pub(crate) static TESTS_LOCATION: RefCell<PathBuf> = RefCell::new(PathBuf::new());
    pub(crate) static LIBS_LOCATION: RefCell<PathBuf> = RefCell::new(PathBuf::new());
}

fn main() {
    let matches = cli::initialize().get_matches();
    let now = Instant::now();

    print_logo();

    let schema_location = subgraph::get_schema_location("subgraph.yaml");
    let config = MatchstickConfig::from("matchstick.yaml");

    SCHEMA_LOCATION.with(|path| *path.borrow_mut() = PathBuf::from(&schema_location));
    TESTS_LOCATION.with(|path| *path.borrow_mut() = PathBuf::from(&config.tests_path));
    LIBS_LOCATION.with(|path| *path.borrow_mut() = PathBuf::from(&config.libs_path));

    let test_sources = get_test_sources(&matches);

    println!("{}", ("Compiling...\n").to_string().bright_green());

    let compiler = Compiler::new(PathBuf::from(config.libs_path))
        .export_table()
        .runtime("stub")
        .optimize()
        .debug();

    let outputs: HashMap<String, CompileOutput> = test_sources
        .into_iter()
        .map(|(name, in_files)| {
            (
                name.clone(),
                compiler.execute(name, in_files, matches.is_present("recompile")),
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

    // Run in coverage mode if coverage flag is present
    if matches.is_present("coverage") {
        generate_coverage_report();
        return;
    }

    // A matchstick instance for each test suite wasm (the compiled source).
    let ms_instances: HashMap<String, MatchstickInstance<Chain>> = outputs
        .into_iter()
        .map(|(key, val)| {
            (
                key,
                MatchstickInstance::<Chain>::new(val.file.to_str().unwrap()),
            )
        })
        .collect();

    // A test suite abstraction for each instance.
    let test_suites: HashMap<String, TestSuite> = ms_instances
        .iter()
        .map(|(key, val)| (key.clone(), TestSuite::from(val)))
        .collect();

    let exit_code = run_test_suites(test_suites);

    println!(
        "\n[{}] Program executed in: {:.3?}.",
        Local::now().to_rfc2822(),
        now.elapsed()
    );

    std::process::exit(exit_code);
}

fn print_logo() {
    Log::Default(
        r#"
___  ___      _       _         _   _      _
|  \/  |     | |     | |       | | (_)    | |
| .  . | __ _| |_ ___| |__  ___| |_ _  ___| | __
| |\/| |/ _` | __/ __| '_ \/ __| __| |/ __| |/ /
| |  | | (_| | || (__| | | \__ \ |_| | (__|   <
\_|  |_/\__,_|\__\___|_| |_|___/\__|_|\___|_|\_\
    "#
        .bright_red(),
    )
    .println()
}

fn collect_files(path: PathBuf) -> HashMap<String, Vec<PathBuf>> {
    let mut files: HashMap<String, Vec<PathBuf>> = HashMap::new();
    let entries = path.read_dir().unwrap_or_else(|err| {
        panic!(
            "{}",
            Log::Critical(format!(
                "Something went wrong while trying to read {:?}: {}",
                path, err,
            ))
        );
    });

    for entry in entries {
        let entry = entry.unwrap_or_else(|err| panic!("{}", Log::Critical(err)));
        let name = entry.file_name().to_str().unwrap().to_ascii_lowercase();

        if name.ends_with(".test.ts") {
            files.insert(name.replace(".test.ts", ""), vec![entry.path()]);
        } else if entry.path().is_dir() {
            let mut sub_files = collect_files(entry.path());

            if !sub_files.is_empty() {
                files.insert(name.clone(), vec![]);
                for val in sub_files.values_mut() {
                    files.get_mut(&name).unwrap().append(val);
                }
            }
        }
    }

    files
}

fn get_test_sources(matches: &ArgMatches) -> HashMap<String, Vec<PathBuf>> {
    let testable = collect_files(PathBuf::from("./tests"));

    if testable.is_empty() {
        panic!("{}", Log::Critical("No tests have been written yet."));
    }

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
}

fn run_test_suites(test_suites: HashMap<String, TestSuite>) -> i32 {
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
                println!("{} {}", suite.bright_blue(), name.red());

                if !result.logs.is_empty() {
                    println!("{}", result.logs);
                }
            }
        }

        println!("\n{}, {}, {}", failed, passed, all);
        1
    } else {
        println!(
            "\n{}",
            format!("All {} tests passed! 😎", num_passed).green()
        );
        0
    }
}
