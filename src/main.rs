use std::str::FromStr;
use std::sync::Arc;
use std::time::Instant;

use clap::{App, Arg};
use colored::*;
use ethabi::Contract;
use graph::components::store::DeploymentId;
use graph::data::subgraph::*;
use graph::{
    blockchain::BlockPtr,
    components::store::DeploymentLocator,
    data::subgraph::{Mapping, Source, TemplateSource},
    ipfs_client::IpfsClient,
    prelude::{
        o, slog, BlockState, DeploymentHash, HostMetrics, Link, Logger, StopwatchMetrics,
        SubgraphStore,
    },
    semver::Version,
};
use graph_chain_ethereum::{Chain, DataSource, DataSourceTemplate};
use graph_mock::MockMetricsRegistry;
use graph_runtime_wasm::mapping::ValidModule;
use graph_runtime_wasm::{
    host_exports::HostExports, mapping::MappingContext, module::ExperimentalFeatures,
};
use serde_yaml::{Sequence, Value};
use web3::types::Address;

use crate::wasm_instance::WasmInstance;
use subgraph_store::MockSubgraphStore;
use wasm_instance::{
    fail_test, flush_logs, get_failed_tests, get_successful_tests, WasmInstanceExtension,
};

mod subgraph_store;
mod wasm_instance;
mod writable_store;

fn mock_host_exports(
    subgraph_id: DeploymentHash,
    data_source: DataSource,
    store: Arc<impl SubgraphStore>,
    api_version: Version,
) -> HostExports<Chain> {
    let templates = vec![DataSourceTemplate {
        kind: String::from("ethereum/contract"),
        name: String::from("example template"),
        network: Some(String::from("mainnet")),
        source: TemplateSource {
            abi: String::from("foo"),
        },
        mapping: Mapping {
            kind: String::from("ethereum/events"),
            api_version,
            language: String::from("wasm/assemblyscript"),
            entities: vec![],
            abis: vec![],
            event_handlers: vec![],
            call_handlers: vec![],
            block_handlers: vec![],
            link: Link {
                link: "link".to_owned(),
            },
            runtime: Arc::new(vec![]),
        },
    }];

    let network = data_source.network.clone().unwrap();
    HostExports::new(
        subgraph_id,
        &data_source,
        network,
        Arc::new(templates),
        Arc::new(graph_core::LinkResolver::from(IpfsClient::localhost())),
        store,
    )
}

fn mock_context(
    deployment: DeploymentLocator,
    data_source: DataSource,
    store: Arc<impl SubgraphStore>,
    api_version: Version,
) -> MappingContext<Chain> {
    MappingContext {
        logger: test_store::LOGGER.clone(),
        block_ptr: BlockPtr {
            hash: Default::default(),
            number: 0,
        },
        host_exports: Arc::new(mock_host_exports(
            deployment.hash.clone(),
            data_source,
            store.clone(),
            api_version,
        )),
        state: BlockState::new(store.writable(&deployment).unwrap(), Default::default()),
        proof_of_indexing: None,
        host_fns: Arc::new(Vec::new()),
    }
}

fn mock_abi() -> MappingABI {
    MappingABI {
        name: "mock_abi".to_string(),
        contract: Contract::load(
            r#"[
            {
                "inputs": [
                    {
                        "name": "a",
                        "type": "address"
                    }
                ],
                "type": "constructor"
            }
        ]"#
            .as_bytes(),
        )
        .expect("Could not load contract."),
    }
}

fn mock_data_source(path_to_wasm: &str, api_version: Version) -> DataSource {
    let runtime = std::fs::read(path_to_wasm).unwrap();

    DataSource {
        kind: String::from("ethereum/contract"),
        name: String::from("example data source"),
        network: Some(String::from("mainnet")),
        source: Source {
            address: Some(Address::from_str("0123123123012312312301231231230123123123").unwrap()),
            abi: String::from("123123"),
            start_block: 0,
        },
        mapping: Mapping {
            kind: String::from("ethereum/events"),
            api_version,
            language: String::from("wasm/assemblyscript"),
            entities: vec![],
            abis: vec![],
            event_handlers: vec![],
            call_handlers: vec![],
            block_handlers: vec![],
            link: Link {
                link: "link".to_owned(),
            },
            runtime: Arc::new(runtime),
        },
        context: Default::default(),
        creation_block: None,
        contract_abi: Arc::new(mock_abi()),
    }
}

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

pub fn main() {
    let matches = App::new("Subtest")
        .version("0.0.10")
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
        ("     _____       _     _            _
    / ____|     | |   | |          | |
   | (___  _   _| |__ | |_ ___  ___| |_
    \\___ \\| | | | '_ \\| __/ _ \\/ __| __|
    ____) | |_| | |_) | ||  __/\\__ \\ |_
   |_____/ \\__,_|_.__/ \\__\\___||___/\\__|\n")
            .to_string()
            .purple()
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

    let subgraph_id = "ipfsMap";
    let deployment_id =
        &DeploymentHash::new(subgraph_id).expect("Could not create DeploymentHash.");

    let deployment = DeploymentLocator::new(DeploymentId::new(42), deployment_id.clone());

    // This is where it breaks
    let data_source = mock_data_source(&path_to_wasm, Version::new(0, 0, 4));

    let metrics_registry = Arc::new(MockMetricsRegistry::new());

    let stopwatch_metrics = StopwatchMetrics::new(
        Logger::root(slog::Discard, o!()),
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

    let valid_module = Arc::new(
        ValidModule::new(data_source.mapping.runtime.as_ref())
            .expect("Could not create ValidModule."),
    );

    let mock_subgraph_store = MockSubgraphStore {};

    let module = <WasmInstance<Chain> as WasmInstanceExtension<Chain>>::from_valid_module_with_ctx(
        valid_module,
        mock_context(
            deployment,
            data_source,
            Arc::from(mock_subgraph_store),
            Version::new(0, 0, 4),
        ),
        host_metrics,
        None,
        experimental_features,
    )
    .expect("Could not create WasmInstance from valid module with context.");

    let run_tests = module
        .instance
        .get_func("runTests")
        .expect(r#"
        ❌ ❌ ❌  Couldn't get wasm function 'runTests'.
        Please ensure that you have imported your runTests() function, defined in the test file, into the main mappings file.
        "#);

    println!("{}", ("Starting tests 🧪🚀\n").to_string().purple());

    #[allow(non_fmt_panic)]
        run_tests.call(&[]).unwrap_or_else(|_| {
        fail_test("".to_string());
        flush_logs();

        let msg = String::from(r#"
        ❌ ❌ ❌  Unexpected error occured while running tests.
        Please double check the syntax in your test file.
        This usually happens if you pass a 'null' value to one of our functions - assert.fieldEquals(), store.get(), store.set().
        Please ensure that you have proper null checks in your tests.
        You can debug your test file using the 'log()' function, provided in subtest-as (import { log } from "subtest-as/assembly/log").
        "#).red();

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
