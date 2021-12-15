use std::collections::BTreeMap;

use async_trait::async_trait;
use graph::{
    blockchain::BlockPtr,
    components::store::{EntityType, StoredDynamicDataSource, WritableStore},
    data::subgraph::schema::{SubgraphError, SubgraphHealth},
    prelude::*,
};

pub struct MockWritableStore {}

#[async_trait]
impl WritableStore for MockWritableStore {
    fn block_ptr(&self) -> Result<Option<BlockPtr>, StoreError> {
        unreachable!()
    }

    fn block_cursor(&self) -> Result<Option<String>, StoreError> {
        unreachable!()
    }

    fn start_subgraph_deployment(&self, _logger: &Logger) -> Result<(), StoreError> {
        unreachable!()
    }

    fn revert_block_operations(&self, _block_ptr_to: BlockPtr) -> Result<(), StoreError> {
        unreachable!()
    }

    fn unfail_deterministic_error(
        &self,
        _current_ptr: &BlockPtr,
        _parent_ptr: &BlockPtr,
    ) -> Result<(), StoreError> {
        unreachable!()
    }

    fn unfail_non_deterministic_error(&self, _current_ptr: &BlockPtr) -> Result<(), StoreError> {
        unreachable!()
    }

    async fn fail_subgraph(&self, _error: SubgraphError) -> Result<(), StoreError> {
        unreachable!()
    }

    async fn supports_proof_of_indexing(&self) -> Result<bool, StoreError> {
        unreachable!()
    }

    fn get(&self, _key: &EntityKey) -> Result<Option<Entity>, StoreError> {
        unreachable!()
    }

    fn transact_block_operations(
        &self,
        _block_ptr_to: BlockPtr,
        _firehose_cursor: Option<String>,
        _mods: Vec<EntityModification>,
        _stopwatch: StopwatchMetrics,
        _data_sources: Vec<StoredDynamicDataSource>,
        _deterministic_errors: Vec<SubgraphError>,
    ) -> Result<(), StoreError> {
        unreachable!()
    }

    fn get_many(
        &self,
        _ids_for_type: BTreeMap<&EntityType, Vec<&str>>,
    ) -> Result<BTreeMap<EntityType, Vec<Entity>>, StoreError> {
        unreachable!()
    }

    fn deployment_synced(&self) -> Result<(), StoreError> {
        unreachable!()
    }

    async fn is_deployment_synced(&self) -> Result<bool, StoreError> {
        unreachable!()
    }

    fn unassign_subgraph(&self) -> Result<(), StoreError> {
        unreachable!()
    }

    async fn load_dynamic_data_sources(&self) -> Result<Vec<StoredDynamicDataSource>, StoreError> {
        unreachable!()
    }

    fn shard(&self) -> &str {
        unreachable!()
    }

    async fn health(&self, _id: &DeploymentHash) -> Result<SubgraphHealth, StoreError> {
        unreachable!()
    }
}
