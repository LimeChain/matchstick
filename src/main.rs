use std::str::FromStr;
use std::sync::Arc;
use std::time::Instant;

use ethabi::Contract;
use graph::components::store::{DeploymentId, WritableStore};
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
use slog::*;
use std::result::Result;
use web3::types::Address;

use async_trait::async_trait;
use custom_wasm_instance::WasmInstance;

mod custom_wasm_instance;

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

struct MockWritableStore {}

#[async_trait]
impl WritableStore for MockWritableStore {
    fn block_ptr(&self) -> Result<Option<BlockPtr>, anyhow::Error> {
        unreachable!()
    }

    fn start_subgraph_deployment(
        &self,
        _logger: &Logger,
    ) -> Result<(), graph::prelude::StoreError> {
        unreachable!()
    }

    fn revert_block_operations(
        &self,
        _block_ptr_to: BlockPtr,
    ) -> Result<(), graph::prelude::StoreError> {
        unreachable!()
    }

    fn unfail(&self) -> Result<(), graph::prelude::StoreError> {
        unreachable!()
    }

    async fn fail_subgraph(
        &self,
        _error: schema::SubgraphError,
    ) -> Result<(), graph::prelude::StoreError> {
        unreachable!()
    }

    fn supports_proof_of_indexing<'a>(self: Arc<Self>) -> graph::prelude::DynTryFuture<'a, bool> {
        unreachable!()
    }

    fn get(
        &self,
        _key: graph::prelude::EntityKey,
    ) -> Result<Option<graph::prelude::Entity>, graph::prelude::QueryExecutionError> {
        unreachable!()
    }

    fn transact_block_operations(
        &self,
        _block_ptr_to: BlockPtr,
        _mods: Vec<graph::prelude::EntityModification>,
        _stopwatch: StopwatchMetrics,
        _data_sources: Vec<graph::components::store::StoredDynamicDataSource>,
        _deterministic_errors: Vec<schema::SubgraphError>,
    ) -> Result<(), graph::prelude::StoreError> {
        unreachable!()
    }

    fn get_many(
        &self,
        _ids_for_type: std::collections::BTreeMap<&graph::components::store::EntityType, Vec<&str>>,
    ) -> Result<
        std::collections::BTreeMap<
            graph::components::store::EntityType,
            Vec<graph::prelude::Entity>,
        >,
        graph::prelude::StoreError,
    > {
        unreachable!()
    }

    fn deployment_synced(&self) -> Result<(), anyhow::Error> {
        unreachable!()
    }

    async fn is_deployment_synced(&self) -> Result<bool, anyhow::Error> {
        unreachable!()
    }

    fn unassign_subgraph(&self) -> Result<(), graph::prelude::StoreError> {
        unreachable!()
    }

    async fn load_dynamic_data_sources(
        &self,
    ) -> Result<Vec<graph::components::store::StoredDynamicDataSource>, graph::prelude::StoreError>
    {
        unreachable!()
    }
}

struct MockSubgraphStore {}
impl SubgraphStore for MockSubgraphStore {
    fn find_ens_name(
        &self,
        _hash: &str,
    ) -> std::result::Result<Option<String>, graph::prelude::QueryExecutionError> {
        Ok(Some(String::from("ds")))
    }

    fn is_deployed(&self, _id: &DeploymentHash) -> Result<bool, anyhow::Error> {
        unreachable!()
    }

    fn create_subgraph_deployment(
        &self,
        _name: SubgraphName,
        _schema: &graph::prelude::Schema,
        _deployment: graph::prelude::SubgraphDeploymentEntity,
        _node_id: graph::prelude::NodeId,
        _network: String,
        _mode: graph::prelude::SubgraphVersionSwitchingMode,
    ) -> Result<DeploymentLocator, graph::prelude::StoreError> {
        unreachable!()
    }

    fn create_subgraph(&self, _name: SubgraphName) -> Result<String, graph::prelude::StoreError> {
        unreachable!()
    }

    fn remove_subgraph(&self, _name: SubgraphName) -> Result<(), graph::prelude::StoreError> {
        unreachable!()
    }

    fn reassign_subgraph(
        &self,
        _deployment: &DeploymentLocator,
        _node_id: &graph::prelude::NodeId,
    ) -> Result<(), graph::prelude::StoreError> {
        unreachable!()
    }

    fn assigned_node(
        &self,
        _deployment: &DeploymentLocator,
    ) -> Result<Option<graph::prelude::NodeId>, graph::prelude::StoreError> {
        unreachable!()
    }

    fn assignments(
        &self,
        _node: &graph::prelude::NodeId,
    ) -> Result<Vec<DeploymentLocator>, graph::prelude::StoreError> {
        unreachable!()
    }

    fn subgraph_exists(&self, _name: &SubgraphName) -> Result<bool, graph::prelude::StoreError> {
        unreachable!()
    }

    fn input_schema(
        &self,
        _subgraph_id: &DeploymentHash,
    ) -> Result<Arc<graph::prelude::Schema>, graph::prelude::StoreError> {
        unreachable!()
    }

    fn api_schema(
        &self,
        _subgraph_id: &DeploymentHash,
    ) -> Result<Arc<graph::prelude::ApiSchema>, graph::prelude::StoreError> {
        unreachable!()
    }

    fn writable(
        &self,
        _deployment: &DeploymentLocator,
    ) -> Result<Arc<dyn graph::components::store::WritableStore>, graph::prelude::StoreError> {
        let mock_writable_store = MockWritableStore {};
        Ok(Arc::from(mock_writable_store))
    }

    fn writable_for_network_indexer(
        &self,
        _id: &DeploymentHash,
    ) -> Result<Arc<dyn graph::components::store::WritableStore>, graph::prelude::StoreError> {
        unreachable!()
    }

    fn least_block_ptr(&self, _id: &DeploymentHash) -> Result<Option<BlockPtr>, anyhow::Error> {
        unreachable!()
    }

    fn locators(&self, _hash: &str) -> Result<Vec<DeploymentLocator>, graph::prelude::StoreError> {
        unreachable!()
    }
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
    let runtime = std::fs::read(path).expect("Could not resolve path to wasm file.");

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
    let plain = slog_term::PlainSyncDecorator::new(std::io::stdout());
    let logger = Logger::root(slog_term::FullFormat::new(plain).build().fuse(), o!());
    let now = Instant::now();
    let args: Vec<String> = std::env::args().collect();

    if args.len() == 1 {
        panic!("Must provide path to wasm file.")
    }

    let path_to_wasm = &args[1];

    let subgraph_id = "ipfsMap";
    let deployment_id =
        &DeploymentHash::new(subgraph_id).expect("Could not create DeploymentHash.");

    let deployment = DeploymentLocator::new(DeploymentId::new(42), deployment_id.clone());

    let data_source = mock_data_source(path_to_wasm);

    // let store = STORE.clone();

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

    let mock_subgraph_store: MockSubgraphStore = MockSubgraphStore {};

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
        .expect("Couldn't get wasm function 'runTests'.");
    run_tests
        .call(&[])
        .expect("Couldn't call wasm function 'runTests'.");

    info!(logger, "Program execution time: {:?}", now.elapsed());
}
