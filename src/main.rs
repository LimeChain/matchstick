use std::collections::HashSet;
use std::io::{self, Write};
use std::sync::Arc;
use std::time::Instant;

use clap::{App, Arg};
use colored::*;
use graph::components::store::DeploymentId;
use graph::{
    components::store::DeploymentLocator,
    prelude::{slog, DeploymentHash, HostMetrics, Logger, StopwatchMetrics},
    semver::Version,
};
use graph_chain_ethereum::Chain;
use graph_mock::MockMetricsRegistry;
use graph_runtime_test::common::{mock_context, mock_data_source};
use graph_runtime_wasm::mapping::ValidModule;
use graph_runtime_wasm::module::ExperimentalFeatures;

use subgraph_store::MockSubgraphStore;
use wasm_instance::{
    flush_logs, get_failed_tests, get_successful_tests, process_test_and_verify,
    WasmInstanceExtension,
};

use crate::compiler::{CompileOutput, Compiler};
use crate::wasm_instance::WasmInstance;

mod compiler;
mod integration_tests;
mod subgraph_store;
mod unit_tests;
mod wasm_instance;
mod writable_store;

fn instance_from_wasm(path_to_wasm: &str) -> WasmInstance<Chain> {
    let subgraph_id = "ipfsMap";
    let deployment_id =
        &DeploymentHash::new(subgraph_id).expect("Could not create DeploymentHash.");
    let deployment = DeploymentLocator::new(DeploymentId::new(42), deployment_id.clone());
    let data_source = mock_data_source(path_to_wasm, Version::new(0, 0, 5));

    let metrics_registry = Arc::new(MockMetricsRegistry::new());

    let stopwatch_metrics = StopwatchMetrics::new(
        Logger::root(slog::Discard, graph::prelude::o!()),
        deployment_id.clone(),
        metrics_registry.clone(),
    );

    let host_metrics = Arc::new(HostMetrics::new(
        metrics_registry,
        deployment_id.as_str(),
        stopwatch_metrics,
    ));

    let experimental_features = ExperimentalFeatures {
        allow_non_deterministic_ipfs: true,
    };

    let mock_subgraph_store = MockSubgraphStore {};
    let valid_module = Arc::new(
        ValidModule::new(Arc::new(std::fs::read(path_to_wasm).expect(r#"❌  Could not resolve path to wasm file. Please ensure that the datasource name you're providing is valid.
        It should be the same as the 'name' field in the subgraph.yaml file, corresponding to the datasource you want to test."#)).as_ref())
            .expect("Could not create ValidModule."),
    );

    <WasmInstance<Chain> as WasmInstanceExtension<Chain>>::from_valid_module_with_ctx(
        valid_module,
        mock_context(
            deployment,
            data_source,
            Arc::from(mock_subgraph_store),
            Version::new(0, 0, 5),
        ),
        host_metrics,
        None,
        experimental_features,
    )
    .expect("Could not create WasmInstance from valid module with context.")
}

fn call_run_tests(run_tests: wasmtime::Func) {
    #[allow(non_fmt_panics)]
    run_tests.call(&[]).unwrap_or_else(|err| {
        if process_test_and_verify() {
            call_run_tests(run_tests);
           Box::new([wasmtime::Val::I32(0)])
        } else {
            flush_logs();

            let msg = String::from(r#"
            ❌ ❌ ❌  Unexpected error occurred while running tests.
            See error stack trace above and double check the syntax in your test file.

            This usually happens for three reasons:
            1. You passed a 'null' value to one of our functions - assert.fieldEquals(), store.get(), store.set().
            2. A mocked function call reverted. Consider using 'try_functionName' to handle this in the mapping.
            3. The test was supposed to throw an error but the 'shouldThrow' parameter was not set to true.

            Please ensure that you have proper null checks in your tests.
            You can debug your test file using the 'debug()' function, provided by matchstick-as (import { debug } from "matchstick-as/assembly/log").
            "#);

            let msg = format!("{}\n {}", err, msg).red();
            panic!("{}", msg);
        }
    });
}

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
        .export_runtime()
        .runtime("stub")
        .optimize()
        .debug();
    let outputs: Vec<CompileOutput> = datasources.iter().map(|s| compiler.compile(s)).collect();

    if outputs.iter().any(|output| !output.status.success()) {
        // Print any output on `stderr`.
        outputs
            .iter()
            .for_each(|output| io::stderr().write_all(&output.stderr).unwrap());

        panic!("Please attend to the compilation errors above!");
    }

    // NOTE: Is it actually too expensive to create a WASM Instance per datasource?
    // Will there be a huge boost in performace if we were to creat just one, shared?
    let wasm_instances: Vec<WasmInstance<Chain>> = outputs
        .iter()
        .map(|output| instance_from_wasm(&output.file))
        .collect();

    println!("{}", ("Igniting tests 🔥\n").to_string().bright_red());
    wasm_instances
        .iter()
        .map(|instance| {
            instance
                .instance
                .get_func("runTests")
                .expect(
                    r#"❌ ❌ ❌  Couldn't get wasm function 'runTests'.
                    Please ensure that you have named the function (that is defined in the test file) exactly 'runTests' and have imported it into the main mappings file."#
                )
        })
        .for_each(call_run_tests);
    flush_logs();

    let successful_tests = get_successful_tests();
    let failed_tests = get_failed_tests();

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
