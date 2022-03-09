use std::cell::RefCell;
use std::collections::HashMap;
use std::path::PathBuf;
use std::time::Instant;

use colored::Colorize;
use graph::prelude::chrono::prelude::*;
use graph_chain_ethereum::Chain;

use crate::compiler::Compiler;
use crate::config::MatchstickConfig;
use crate::instance::MatchstickInstance;
use crate::test_suite::{Test, TestResult, TestSuite};

use crate::coverage::generate_coverage_report;

mod cli;
mod compiler;
mod config;
mod context;
mod coverage;
mod instance;
mod integration_tests;
mod logging;
mod parser;
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

    let schema_location = parser::get_schema_location("subgraph.yaml");
    let config = MatchstickConfig::from("matchstick.yaml");

    SCHEMA_LOCATION.with(|path| *path.borrow_mut() = PathBuf::from(&schema_location));
    TESTS_LOCATION.with(|path| *path.borrow_mut() = PathBuf::from(&config.tests_path));
    LIBS_LOCATION.with(|path| *path.borrow_mut() = PathBuf::from(&config.libs_path));

    logging::log_with_style!(bright_green, "Compiling...\n");

    let compiler = Compiler::new(PathBuf::from(config.libs_path))
        .export_table()
        .runtime("stub")
        .optimize()
        .debug();

    let outputs = compiler.execute(&matches);

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

    logging::default!(
        "\n[{}] Program executed in: {:.3?}.",
        Local::now().to_rfc2822(),
        now.elapsed()
    );

    std::process::exit(exit_code);
}

fn print_logo() {
    logging::log_with_style!(
        bright_red,
        r#"
___  ___      _       _         _   _      _
|  \/  |     | |     | |       | | (_)    | |
| .  . | __ _| |_ ___| |__  ___| |_ _  ___| | __
| |\/| |/ _` | __/ __| '_ \/ __| __| |/ __| |/ /
| |  | | (_| | || (__| | | \__ \ |_| | (__|   <
\_|  |_/\__,_|\__\___|_| |_|___/\__|_|\___|_|\_\
    "#
    )
}

fn run_test_suites(test_suites: HashMap<String, TestSuite>) -> i32 {
    logging::log_with_style!(bright_red, "\nIgniting tests 🔥");

    let (mut num_passed, mut num_failed) = (0, 0);
    let failed_suites: HashMap<String, Vec<HashMap<String, TestResult>>> = test_suites
        .into_iter()
        .filter_map(|(name, suite)| {
            logging::log_with_style!(bright_blue, "\n{}", name);
            logging::default!("-".repeat(50));

            logging::add_indent();

            Test::call_hooks(&suite.before_all);

            let failed_tests: Vec<HashMap<String, TestResult>> = suite
                .groups
                .into_iter()
                .filter_map(|(_, group)| {
                    if group.tests.is_empty() {
                        None
                    } else {
                        if !group.name.is_empty() {
                            Log::Default(format!("{}", group.name.cyan().bold())).println();
                        }

                        logging::add_indent();

                        Test::call_hooks(&group.before_all);

                        let failed_test: HashMap<String, TestResult> = group
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

                        Test::call_hooks(&group.after_all);
                        logging::sub_indent();

                        if failed_test.is_empty() {
                            None
                        } else {
                            Some(failed_test)
                        }
                    }
                })
                .collect();

            Test::call_hooks(&suite.after_all);
            logging::clear_indent();

            if failed_tests.is_empty() {
                None
            } else {
                Some((name, failed_tests))
            }
        })
        .collect();

    if num_failed > 0 {
        let failed = format!("{} failed", num_failed).red();
        let passed = format!("{} passed", num_passed).green();
        let total = format!("{} total", num_failed + num_passed);

        logging::log_with_style!(red, "\nFailed tests:\n");

        for (suite, group) in failed_suites {
            logging::log_with_style!(bright_blue, bold, suite);
            logging::add_indent();

            for tests in group {
                for (name, result) in tests {
                    logging::log_with_style!(red, bold, name);

                    if !result.logs.is_empty() {
                        logging::default!(result.logs);
                    }
                }
            }

            logging::sub_indent();
        }

        logging::default!("{}, {}, {}", failed, passed, total);
        1
    } else {
        logging::log_with_style!(green, "\nAll {} tests passed! 😎", num_passed);
        0
    }
}
