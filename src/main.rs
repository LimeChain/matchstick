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
use serde_yaml::{Sequence, Value};

use subgraph_store::MockSubgraphStore;
use wasm_instance::{
    fail_test, flush_logs, get_failed_tests, get_successful_tests, WasmInstanceExtension,
};

use crate::wasm_instance::WasmInstance;

mod integration_tests;
mod subgraph_store;
mod unit_tests;
mod wasm_instance;
mod writable_store;

fn get_build_path(sequence: Sequence, datasource_name: String) -> String {
    for mapping in sequence {
        if mapping
            .get("name")
            .unwrap()
            .as_str()
            .expect("Could not convert yaml field 'name' to &str.")
            .to_string()
            .to_lowercase()
            == datasource_name.to_string().to_lowercase()
        {
            return mapping
                .get("mapping")
                .expect("Could not parse field 'mapping' from subgraph.yaml")
                .get("file")
                .expect("Could not parse field 'mapping/file' from subgraph.yaml")
                .as_str()
                .expect("Could not convert mapping/file to &str.")
                .to_owned();
        }
    }
    String::from("")
}

pub fn module_from_path(path_to_wasm: &str) -> WasmInstance<Chain> {
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

pub fn main() {
    let matches = App::new("Matchstick 🔥")
        .version("0.1.2")
        .author("Limechain <https://limechain.tech>")
        .about("Unit testing framework for Subgraph development on The Graph protocol.")
        .arg(
            Arg::with_name("DATASOURCE")
                .help("Sets the name of the datasource to use.")
                .required(true)
                .index(1),
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

    let datasource_name = matches
        .value_of("DATASOURCE")
        .expect("Couldn't get datasource name.");

    let subgraph_yaml_contents = std::fs::read_to_string("build/subgraph.yaml")
        .expect(r#"
        ❌ ❌ ❌  Something went wrong reading the 'build/subgraph.yaml' file.
        Please ensure that you have run 'graph build' and a 'build' directory exists in the root of your project.
        "#);

    let subgraph_yaml: Value = serde_yaml::from_str(&subgraph_yaml_contents).expect(
        r#"
        ❌ ❌ ❌  Something went wrong when parsing 'build/subgraph.yaml'.
        Please ensure that the file exists and that the yaml is valid."#,
    );

    let sequence: Sequence = subgraph_yaml["dataSources"]
        .as_sequence()
        .expect("Could not get data sources from yaml file.")
        .to_vec();

    let mut path = get_build_path(sequence, datasource_name.to_owned());

    // This means datasource is a template datasource
    if path.is_empty() {
        let sequence: Sequence = subgraph_yaml["templates"]
            .as_sequence()
            .expect("Could not get data sources from yaml file.")
            .to_vec();

        path = get_build_path(sequence, datasource_name.to_owned());
    }

    let path_to_wasm = format!("build/{}", path);
    let module = module_from_path(&path_to_wasm);

    let run_tests = module
        .instance
        .get_func("runTests")
        .expect(r#"
        ❌ ❌ ❌  Couldn't get wasm function 'runTests'.
        Please ensure that you have named the function (that is defined in the test file) exactly 'runTests' and have imported it into the main mappings file.
        "#);

    println!("{}", ("Igniting tests 🔥\n").to_string().bright_red());

    #[allow(non_fmt_panic)]
        run_tests.call(&[]).unwrap_or_else(|err| {

        fail_test("".to_string());
        flush_logs();

        let msg = String::from(r#"
        ❌ ❌ ❌  Unexpected error occurred while running tests.
        See error stack trace above and double check the syntax in your test file.

        This usually happens for two reasons:
        1. You passed a 'null' value to one of our functions - assert.fieldEquals(), store.get(), store.set().
        2. A mocked function call reverted. Consider using 'try_functionName' to handle this in the mapping.

        Please ensure that you have proper null checks in your tests.
        You can debug your test file using the 'debug()' function, provided by matchstick-as (import { debug } from "matchstick-as/assembly/log").
        "#);

        let msg = format!("{}\n {}", err, msg).red();
        panic!("{}", msg);
    });

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
