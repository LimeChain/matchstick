use std::collections::{HashMap, HashSet};
use std::io::{self, Write};
use std::time::Instant;

use clap::{App, Arg};
use colored::Colorize;
use graph_chain_ethereum::Chain;

use crate::compiler::{CompileOutput, Compiler};
use crate::instance::MatchstickInstance;
use crate::logging::Log;
use crate::test_abstractions::TestCollection;

mod compiler;
mod context;
mod instance;
mod logging;
mod subgraph_store;
mod test_abstractions;
mod writable_store;

// TODO: WRONG! It should return only the data sources that have tests written for in `tests/`.
/// Returns the names of the sources specified in the subgraph.yaml file.
fn get_available_datasources() -> HashSet<String> {
    let subgraph_yaml = std::fs::read_to_string("subgraph.yaml").expect(
        r#"❌ ❌ ❌  Something went wrong when reading the 'subgraph.yaml' file.
        Please ensure that the file exists"#,
    );

    let subgraph_yaml: serde_yaml::Value = serde_yaml::from_str(&subgraph_yaml).expect(
        r#"❌ ❌ ❌  Something went wrong when parsing 'subgraph.yaml'.
        Please ensure that the yaml format is valid."#,
    );

    let datasources: serde_yaml::Sequence = subgraph_yaml["dataSources"]
        .as_sequence()
        .expect("Could not get the data sources from the yaml file.")
        .to_vec();

    datasources
        .iter()
        .map(|src| src.get("name").unwrap().as_str().unwrap().to_lowercase())
        .collect()
}

fn main() {
    let matches = App::new("Matchstick 🔥")
        .version("0.1.3")
        .author("Limechain <https://limechain.tech>")
        .about("Unit testing framework for Subgraph development on The Graph protocol.")
        .arg(
            Arg::with_name("datasources")
                .help("Please specify the names of the data sources you would like to test.")
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

    let datasources = {
        let available_sources = get_available_datasources();
        if let Some(vals) = matches.values_of("datasources") {
            let sources: HashSet<String> = vals
                .collect::<Vec<&str>>()
                .iter()
                .map(|&s| String::from(s).to_lowercase())
                .collect();

            let unrecog_sources: Vec<String> = sources
                .difference(&available_sources)
                .map(String::from)
                .collect();

            if !unrecog_sources.is_empty() {
                panic!(
                    "The following datasources could not be recognized: {}.",
                    unrecog_sources.join(", ")
                );
            }

            sources
        } else {
            available_sources
        }
    };

    println!("{}", ("Compiling...\n").to_string().bright_green());
    let compiler = Compiler::default()
        .export_table()
        .runtime("stub")
        .optimize()
        .debug();

    let outputs: HashMap<String, CompileOutput> = datasources
        .iter()
        .map(|s| (s.clone(), compiler.compile(s)))
        .collect();

    if outputs.values().any(|output| !output.status.success()) {
        // Print any output on `stderr`.
        outputs
            .values()
            .for_each(|output| io::stderr().write_all(&output.stderr).unwrap());

        panic!("Please attend to the compilation errors above!");
    }

    // A matchstick instance for each data source.
    let ms_instances: HashMap<String, MatchstickInstance<Chain>> = outputs
        .iter()
        .map(|(key, val)| (key.clone(), MatchstickInstance::<Chain>::new(&val.file)))
        .collect();

    // A test collection abstraction for each data source.
    let test_collectins: HashMap<String, TestCollection> = ms_instances
        .iter()
        .map(|(key, val)| (key.clone(), TestCollection::from(val)))
        .collect();

    let mut successful_tests = 0;
    let mut failed_tests = 0;
    println!("{}", ("Igniting tests 🔥\n").to_string().bright_red());
    test_collectins.iter().for_each(|(key, val)| {
        Log::Info(format!("---> Data Source: {}", key)).print();
        for test in &val.tests {
            let res = test.run();
            if res.is_successful {
                successful_tests += 1;
            } else {
                failed_tests += 1;
            }
        }
    });

    if failed_tests > 0 {
        let failed = format!("{} failed", failed_tests).red();
        let passed = format!("{} passed", successful_tests).green();
        let all = format!("{} total", failed_tests + successful_tests);

        println!("\n{}, {}, {}", failed, passed, all);
        println!("Program execution time: {:?}", now.elapsed());
        std::process::exit(1);
    } else {
        println!("\n{}", ("All tests passed! 😎").to_string().green());
    }

    println!(
        "{} tests executed in {:?}.",
        failed_tests + successful_tests,
        now.elapsed()
    );
}
