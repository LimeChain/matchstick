use async_trait::async_trait;
use graph::components::store::WritableStore;
use graph::data::subgraph::*;
use graph::{
    blockchain::BlockPtr,
    prelude::{Logger, StopwatchMetrics},
};
use std::result::Result;
use std::sync::Arc;

pub struct MockWritableStore {}

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
