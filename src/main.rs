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
use graph_chain_arweave::adapter::ArweaveAdapter;
use graph_chain_ethereum::{Chain, DataSource, DataSourceTemplate};
use graph_core::three_box::ThreeBoxAdapter;
use graph_mock::MockMetricsRegistry;
use graph_runtime_wasm::mapping::ValidModule;
use graph_runtime_wasm::{
    host_exports::HostExports, mapping::MappingContext, module::ExperimentalFeatures,
};
use serde_yaml::{Sequence, Value};
use web3::types::Address;

use subgraph_store::MockSubgraphStore;
use wasm_instance::{flush_logs, get_failed_tests, get_successful_tests, WasmInstance};

mod subgraph_store;
mod wasm_instance;
mod writable_store;

fn mock_host_exports(
    subgraph_id: DeploymentHash,
    data_source: DataSource,
    store: Arc<impl SubgraphStore>,
) -> HostExports<Chain> {
    let arweave_adapter = Arc::new(ArweaveAdapter::new("https://arweave.net".to_string()));
    let three_box_adapter = Arc::new(ThreeBoxAdapter::new("https://ipfs.3box.io/".to_string()));

    let templates = vec![DataSourceTemplate {
        kind: String::from("ethereum/contract"),
        name: String::from("example template"),
        network: Some(String::from("mainnet")),
        source: TemplateSource {
            abi: String::from("foo"),
        },
        mapping: Mapping {
            kind: String::from("ethereum/events"),
            api_version: Version::parse("0.1.0").expect("Could not parse api version."),
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

    let network = data_source.network.clone().expect("Could not get network.");
    HostExports::new(
        subgraph_id,
        &data_source,
        network,
        Arc::new(templates),
        Arc::new(graph_core::LinkResolver::from(IpfsClient::localhost())),
        store,
        arweave_adapter,
        three_box_adapter,
    )
}

fn mock_context(
    deployment: DeploymentLocator,
    data_source: DataSource,
    store: Arc<impl SubgraphStore>,
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
        )),
        state: BlockState::new(
            store
                .writable(&deployment)
                .expect("Could not create BlockState."),
            Default::default(),
        ),
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

fn mock_data_source(path: &str) -> DataSource {
    let runtime = std::fs::read(path).
        expect(r#"❌  Could not resolve path to wasm file. Please ensure that the datasource name you're providing is valid.
        It should be the same as the 'name' field in the subgraph.yaml file, corresponding to the datasource you want to test.  ❌"#);

    DataSource {
        kind: String::from("ethereum/contract"),
        name: String::from("example data source"),
        network: Some(String::from("mainnet")),
        source: Source {
            address: Some(
                Address::from_str("0123123123012312312301231231230123123123")
                    .expect("Could not create address from string."),
            ),
            abi: String::from("123123"),
            start_block: 0,
        },
        mapping: Mapping {
            kind: String::from("ethereum/events"),
            api_version: Version::parse("0.1.0").expect("Could not parse api version."),
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

pub fn main() {
    let matches = App::new("Subtest")
        .version("0.0.6")
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
        .expect(r#"❌ Something went wrong reading the 'build/subgraph.yaml' file.
        Please ensure that you have run 'graph build' and a 'build' directory exists in the root of your project.  ❌"#);

    let subgraph_yaml: Value = serde_yaml::from_str(&subgraph_yaml_contents).expect(
        r#"❌  Something went wrong when parsing 'build/subgraph.yaml'.
        Please ensure that the file exists and that the yaml is valid.  ❌"#,
    );

    let sequence: Sequence = subgraph_yaml["dataSources"]
        .as_sequence()
        .expect("Could not get data sources from yaml file.")
        .to_vec();

    let mut path = "";

    for mapping in &sequence {
        if mapping.get("name").unwrap() == datasource_name {
            path = mapping
                .get("mapping")
                .expect("Could not parse field 'mapping' from subgraph.yaml")
                .get("file")
                .expect("Could not parse field 'mapping/file' from subgraph.yaml")
                .as_str()
                .expect("Could not convert mapping/file to &str.");
        }
    }

    let path_to_wasm = format!("build/{}", path);

    let subgraph_id = "ipfsMap";
    let deployment_id =
        &DeploymentHash::new(subgraph_id).expect("Could not create DeploymentHash.");

    let deployment = DeploymentLocator::new(DeploymentId::new(42), deployment_id.clone());
    let data_source = mock_data_source(&path_to_wasm);
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
        allow_non_deterministic_arweave: true,
        allow_non_deterministic_3box: true,
    };

    let valid_module = Arc::new(
        ValidModule::new(data_source.mapping.runtime.as_ref())
            .expect("Could not create ValidModule."),
    );

    let mock_subgraph_store = MockSubgraphStore {};

    let module = WasmInstance::from_valid_module_with_ctx(
        valid_module,
        mock_context(deployment, data_source, Arc::from(mock_subgraph_store)),
        host_metrics,
        None,
        experimental_features,
    )
    .expect("Could not create WasmInstance from valid module with context.");

    let run_tests = module
        .instance
        .get_func("runTests")
        .expect(r#"❌  Couldn't get wasm function 'runTests'.
        Please ensure that you have imported your runTests() function, defined in the test file, into the main mappings file.  ❌"#);
    println!("{}", ("Starting tests 🧪🚀\n").to_string().purple());
    run_tests.call(&[]).expect(
        r#"❌  Couldn't call wasm function 'runTests'.
        Please double check the syntax in your test file.  ❌"#,
    );

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
