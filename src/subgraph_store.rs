use std::result::Result;
use std::sync::Arc;

use async_trait::async_trait;
use graph::{
    blockchain::BlockPtr,
    components::store::{DeploymentId, DeploymentLocator, EnsLookup, SubgraphFork},
    data::subgraph::*,
    prelude::{DeploymentHash, EntityOperation, StoreError, SubgraphStore},
    slog::Logger,
};

use crate::writable_store::MockWritableStore;

pub struct MockSubgraphStore {}

struct DummyStruct {}

impl EnsLookup for DummyStruct {
    fn find_name(&self, _hash: &str) -> Result<Option<String>, StoreError> {
        Ok(Option::from("default".to_owned()))
    }
}

#[async_trait]
impl SubgraphStore for MockSubgraphStore {
    fn ens_lookup(&self) -> Arc<(dyn EnsLookup + 'static)> {
        Arc::new(DummyStruct {})
    }

    fn is_deployed(&self, _id: &DeploymentHash) -> Result<bool, StoreError> {
        unreachable!()
    }

    fn create_subgraph_deployment(
        &self,
        _name: SubgraphName,
        _schema: &graph::prelude::Schema,
        _deployment: graph::data::subgraph::schema::DeploymentCreate,
        _node_id: graph::prelude::NodeId,
        _network: String,
        _mode: graph::prelude::SubgraphVersionSwitchingMode,
    ) -> Result<DeploymentLocator, graph::prelude::StoreError> {
        unreachable!()
    }

    fn create_subgraph(&self, _name: SubgraphName) -> Result<String, graph::prelude::StoreError> {
        unreachable!()
    }

    fn debug_fork(
        &self,
        _subgraph_id: &DeploymentHash,
        _logger: Logger,
    ) -> Result<Option<Arc<dyn SubgraphFork>>, StoreError> {
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

    async fn writable(
        self: Arc<Self>,
        _logger: Logger,
        _deployment: DeploymentId,
    ) -> Result<
        Arc<dyn graph::components::store::WritableStore>,
        graph::components::store::StoreError,
    > {
        let mock_writable_store = MockWritableStore {};
        Ok(Arc::from(mock_writable_store))
    }

    async fn least_block_ptr(
        &self,
        _id: &DeploymentHash,
    ) -> Result<Option<BlockPtr>, graph::prelude::StoreError> {
        unreachable!()
    }

    fn locators(&self, _hash: &str) -> Result<Vec<DeploymentLocator>, graph::prelude::StoreError> {
        unreachable!()
    }

    fn entity_changes_in_block(
        &self,
        _id: &graph::prelude::DeploymentHash,
        _block: i32,
    ) -> Result<Vec<EntityOperation>, graph::prelude::StoreError> {
        unreachable!()
    }

    async fn is_healthy(&self, _id: &graph::prelude::DeploymentHash) -> Result<bool, StoreError> {
        unreachable!()
    }
}
