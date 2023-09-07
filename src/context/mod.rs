use std::collections::HashMap;
use std::str::FromStr;

use anyhow::{anyhow, Context};
use graph::{
    blockchain::Blockchain,
    data::{
        graphql::ext::DirectiveFinder,
        store::{Attribute, Value},
        value::Word,
    },
    prelude::ethabi::{Address, Token},
    runtime::{asc_get, asc_new, gas::GasCounter, AscPtr, HostExportError},
    semver::Version,
};
use graph_chain_ethereum::runtime::{
    abi::AscUnresolvedContractCall_0_0_4, runtime_adapter::UnresolvedContractCall,
};
use graph_graphql::graphql_parser::schema;
use graph_runtime_wasm::{
    asc_abi::class::{
        Array, AscEntity, AscEnum, AscEnumArray, AscString, EnumPayload, EthereumValueKind,
        StoreValueKind, Uint8Array,
    },
    module::WasmInstanceContext,
    ExperimentalFeatures,
};
use lazy_static::lazy_static;
use serde::Serialize;
use serde_json::to_string_pretty;

use crate::logging;
use crate::SCHEMA_LOCATION;

mod conversion;
mod derived_schema;
use conversion::{collect_types, get_kind, get_token_value};

use derived_schema::derive_schema;

lazy_static! {
    /// Special tokens...
    pub(crate) static ref REVERTS_IDENTIFIER: Vec<Token> =
        vec![Token::Bytes(vec![255, 255, 255, 255, 255, 255, 255])];

    /// The global GraphQL Schema from `schema.graphql`.
    static ref SCHEMA: schema::Document<'static, String> = {
        let mut s = "".to_owned();
        SCHEMA_LOCATION.with(|path| {
            s = std::fs::read_to_string(&*path.borrow()).unwrap_or_else(|err| {
                logging::critical!(
                    "Something went wrong when trying to read `{:?}`: {}",
                    &*path.borrow(),
                    err,
                )
            });
        });

        schema::parse_schema::<String>(&s).unwrap_or_else(|err| {
            logging::critical!(
                "Something went wrong when trying to parse `schema.graphql`: {}",
                err
            )
        }).into_static()
    };
}

type Store = HashMap<String, HashMap<String, HashMap<String, Value>>>;

/// Type of the store that needs to be accessed
pub enum StoreScope {
    Global,
    Cache,
}

#[derive(Serialize)]
#[serde(untagged)]
enum LogEntityValue {
    Native(Value),
    Derived(Vec<HashMap<String, Value>>),
}

type Entity = Vec<(Word, graph::prelude::Value)>;

trait Sortable {
    fn sorted(&mut self) -> &Entity;
}

impl Sortable for Entity {
    fn sorted(&mut self) -> &Entity {
        self.sort_by(|(k1, _), (k2, _)| k1.cmp(k2));
        self
    }
}

/// The Matchstick Instance Context wraps WASM Instance Context and
/// implements the external functions.
pub struct MatchstickInstanceContext<C: Blockchain> {
    /// Handle to WASM Instance Context.
    pub wasm_ctx: WasmInstanceContext<C>,
    /// global store
    /// Store<EntityType, EntityTypeStore<EntityId, Entity<Field, Value>>>.
    pub(crate) store: Store,
    /// store for the current block
    /// Store<EntityType, EntityTypeStore<EntityId, Entity<Field, Value>>>.
    pub(crate) cache_store: Store,
    /// Function-Return map storing mocked Smart Contracts' functions' return values.
    pub(crate) fn_ret_map: HashMap<String, Vec<Token>>,
    /// Registered tests metadata.
    pub meta_tests: Vec<(String, bool, u32, String)>,
    /// Holding the parent entity type, parent virtual field and a tuple of the derived entity type and derived entity field it points to
    /// The example below is taken from a schema.graphql file and will fill the map in the following way:
    /// {"GraphAccount": {"nameSignalTransactions", ("NameSignalTransaction", "signer")}}
    /// ```
    /// type GraphAccount @entity {
    ///     id: ID!
    ///     nameSignalTransactions: [NameSignalTransaction!]! @derivedFrom(field: "signer")
    /// }
    /// type NameSignalTransaction @entity {
    ///     id: ID!
    ///     signer: GraphAccount!
    /// }
    /// ```
    pub(crate) derived: HashMap<String, HashMap<String, (String, String)>>,
    /// Gives guarantee that all derived relations are in order when true
    store_updated: bool,
    /// Holds the mocked return values of `dataSource.address()`, `dataSource.network()` and `dataSource.context()` in that order
    data_source_return_value: (
        Option<String>,
        Option<String>,
        Option<HashMap<Attribute, Value>>,
    ),
    /// Holds the mocked ipfs files in a HashMap, where key is the file hash, and the value is the
    /// path to the file that matchstick should read and parse
    pub(crate) ipfs: HashMap<String, String>,
}

/// Implementation of non-external functions.
impl<C: Blockchain> MatchstickInstanceContext<C> {
    pub fn new(wasm_ctx: WasmInstanceContext<C>) -> Self {
        let mut context = MatchstickInstanceContext {
            wasm_ctx,
            store: HashMap::new(),
            cache_store: HashMap::new(),
            fn_ret_map: HashMap::new(),
            meta_tests: Vec::new(),
            derived: HashMap::new(),
            store_updated: true,
            data_source_return_value: (None, None, None),
            ipfs: HashMap::new(),
        };
        derive_schema(&mut context);
        context
    }

    /// Constructs a unique ID for a given contract function.
    fn fn_id(
        contract_address: &str,
        fn_name: &str,
        fn_signature: &str,
        fn_args: &[Token],
    ) -> String {
        let mut unique_fn_string = String::from(contract_address) + fn_name + fn_signature;
        for element in fn_args.iter() {
            unique_fn_string += &element.to_string();
        }
        unique_fn_string
    }
}

/// Implementation of external functions (used in AssemblyScript sources).
impl<C: Blockchain> MatchstickInstanceContext<C> {
    /// function log(level: enum Level (u32), msg: string): void
    pub fn log(
        &mut self,
        _gas: &GasCounter,
        level: u32,
        msg: AscPtr<AscString>,
    ) -> Result<(), HostExportError> {
        let msg: String = asc_get(&self.wasm_ctx, msg, &GasCounter::new(), 0)?;

        match level {
            0 => logging::critical!(msg),
            _ => logging::log!(level, msg),
        }

        Ok(())
    }

    /// function logStore(): void
    pub fn log_store(&mut self, _gas: &GasCounter) -> Result<(), HostExportError> {
        logging::debug!(
            "{}",
            to_string_pretty(&self.store).unwrap_or_else(|err| logging::critical!(err)),
        );
        Ok(())
    }

    /// function logEntity(entity: string, id: string, showRelated: bool): void
    pub fn log_entity(
        &mut self,
        _gas: &GasCounter,
        entity_type_ptr: AscPtr<AscString>,
        entity_id_ptr: AscPtr<AscString>,
        show_related_ptr: AscPtr<bool>,
    ) -> Result<(), HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr, &GasCounter::new(), 0)?;
        let entity_id: String = asc_get(&self.wasm_ctx, entity_id_ptr, &GasCounter::new(), 0)?;
        let show_related: bool = bool::from(EnumPayload(show_related_ptr.to_payload()));

        let mut log: HashMap<String, LogEntityValue> = HashMap::new();

        if self.store.contains_key(&entity_type)
            && self
                .store
                .get(&entity_type)
                .unwrap()
                .contains_key(&entity_id)
        {
            let entity = self
                .store
                .get(&entity_type)
                .unwrap()
                .get(&entity_id)
                .unwrap()
                .clone();

            let mut virtual_fields: Vec<String> = Vec::new();
            let has_virtual_fields = self.derived.contains_key(&entity_type);

            // prepare entity's native fields
            for (field, value) in entity.iter() {
                log.insert(field.clone(), LogEntityValue::Native(value.clone()));
            }

            // prepare entity's dervied fields
            if show_related && has_virtual_fields {
                virtual_fields = self
                    .derived
                    .get(&entity_type)
                    .unwrap()
                    .clone()
                    .into_keys()
                    .collect();
            }

            for virtual_field in virtual_fields.iter() {
                // convert from graph entity(vec) to store entity(hashmap) for better print result
                let related_entities: Vec<HashMap<String, Value>> = self
                    .load_related_entities(&entity_type, &entity_id, virtual_field)
                    .into_iter()
                    .map(|entity: Entity| {
                        let mut related_entity: HashMap<String, Value> = HashMap::new();

                        entity.into_iter().for_each(|(word, value)| {
                            related_entity.insert(word.to_string(), value);
                        });

                        related_entity
                    })
                    .collect();

                log.insert(
                    virtual_field.clone(),
                    LogEntityValue::Derived(related_entities),
                );
            }
        }

        logging::debug!(
            "{}",
            to_string_pretty(&log).unwrap_or_else(|err| logging::critical!(err)),
        );

        Ok(())
    }

    /// function clearStore(): void
    pub fn clear_store(&mut self, _gas: &GasCounter) -> Result<(), HostExportError> {
        self.store.clear();
        self.store_updated = true;
        Ok(())
    }

    /// function clearInBlockStore(): void
    pub fn clear_cache_store(&mut self, _gas: &GasCounter) -> Result<(), HostExportError> {
        self.cache_store.clear();
        Ok(())
    }

    /// function _registerTest(name: string, shouldFail: bool, funcIdx: u32): void
    pub fn register_test(
        &mut self,
        _gas: &GasCounter,
        name: AscPtr<AscString>,
        should_fail: AscPtr<bool>,
        func_idx: u32,
    ) -> Result<(), HostExportError> {
        let name: String = asc_get(&self.wasm_ctx, name, &GasCounter::new(), 0)?;
        let should_fail = bool::from(EnumPayload(should_fail.to_payload()));
        self.meta_tests
            .push((name, should_fail, func_idx, "test".to_owned()));
        Ok(())
    }

    /// function _registerDescribe(name: string, funcIdx: u32): void
    pub fn register_describe(
        &mut self,
        _gas: &GasCounter,
        name: AscPtr<AscString>,
        func_idx: u32,
    ) -> Result<(), HostExportError> {
        let name: String = asc_get(&self.wasm_ctx, name, &GasCounter::new(), 0)?;
        self.meta_tests
            .push((name, false, func_idx, "describe".to_owned()));

        Ok(())
    }

    /// function _registerHook(funcIdx: u32, role: string): void
    pub fn register_hook(
        &mut self,
        _gas: &GasCounter,
        func_idx: u32,
        role: AscPtr<AscString>,
    ) -> Result<(), HostExportError> {
        let role: String = asc_get(&self.wasm_ctx, role, &GasCounter::new(), 0)?;
        self.meta_tests
            .push((String::from(""), false, func_idx, role));
        Ok(())
    }

    /// function _assert.fieldEquals(
    ///     entityType: string, id: string,
    ///     fieldName: string, expectedVal: string,
    /// ): bool
    pub fn assert_field_equals(
        &mut self,
        _gas: &GasCounter,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        field_name_ptr: AscPtr<AscString>,
        expected_val_ptr: AscPtr<AscString>,
    ) -> Result<bool, HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr, &GasCounter::new(), 0)?;
        let id: String = asc_get(&self.wasm_ctx, id_ptr, &GasCounter::new(), 0)?;
        let field_name: String = asc_get(&self.wasm_ctx, field_name_ptr, &GasCounter::new(), 0)?;
        let expected_val: String =
            asc_get(&self.wasm_ctx, expected_val_ptr, &GasCounter::new(), 0)?;

        if !self.store.contains_key(&entity_type) {
            logging::error!(
                "(assert.fieldEquals) No entities with type '{}' found.",
                &entity_type
            );

            return Ok(false);
        }

        let entities = self.store.get(&entity_type).unwrap();
        if !entities.contains_key(&id) {
            logging::error!(
                "(assert.fieldEquals) No entity with type '{}' and id '{}' found.",
                &entity_type,
                &id
            );

            return Ok(false);
        }

        let entity = entities.get(&id).unwrap();
        if !entity.contains_key(&field_name) {
            logging::error!(
                "(assert.fieldEquals) No field named '{}' on entity with type '{}' and id '{}' found.",
                &field_name,
                &entity_type,
                &id
            );

            return Ok(false);
        }

        let val = entity.get(&field_name).unwrap();
        if val.to_string() != expected_val {
            logging::error!(
                "(assert.fieldEquals) Expected field '{}' to equal '{}', but was '{}' instead.",
                &field_name,
                &expected_val,
                val
            );
            return Ok(false);
        };

        Ok(true)
    }

    /// function _assert.equals(expected: ethereum.Value, actual: ethereum.Value): bool
    pub fn assert_equals(
        &mut self,
        _gas: &GasCounter,
        expected_ptr: u32,
        actual_ptr: u32,
    ) -> Result<bool, HostExportError> {
        let expected: Token = asc_get::<_, AscEnum<EthereumValueKind>, _>(
            &self.wasm_ctx,
            expected_ptr.into(),
            &GasCounter::new(),
            0,
        )?;
        let actual: Token = asc_get::<_, AscEnum<EthereumValueKind>, _>(
            &self.wasm_ctx,
            actual_ptr.into(),
            &GasCounter::new(),
            0,
        )?;

        let exp_val = get_token_value(expected);
        let act_val = get_token_value(actual);

        if exp_val != act_val {
            logging::error!(
                "(assert.equals) Expected value was '{}' but actual value was '{}'",
                exp_val,
                act_val
            );
            return Ok(false);
        }

        Ok(true)
    }

    /// function _assert.notInStore(entityType: string, id: string): bool
    pub fn assert_not_in_store(
        &mut self,
        _gas: &GasCounter,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
    ) -> Result<bool, HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr, &GasCounter::new(), 0)?;
        let id: String = asc_get(&self.wasm_ctx, id_ptr, &GasCounter::new(), 0)?;

        if self.store.contains_key(&entity_type)
            && self.store.get(&entity_type).unwrap().contains_key(&id)
        {
            logging::error!(
                "(assert.notInStore) Value for entity type: '{}' and id: '{}' was found in store.",
                entity_type,
                id
            );
            return Ok(false);
        }

        Ok(true)
    }

    fn get_store_entity(
        &mut self,
        scope: StoreScope,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        _gas: &GasCounter,
    ) -> Result<AscPtr<AscEntity>, HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr, &GasCounter::new(), 0)?;
        let id: String = asc_get(&self.wasm_ctx, id_ptr, &GasCounter::new(), 0)?;

        let store = match scope {
            StoreScope::Global => &self.store,
            StoreScope::Cache => &self.cache_store,
        };

        if store.contains_key(&entity_type) && store.get(&entity_type).unwrap().contains_key(&id) {
            let entities = store.get(&entity_type).unwrap();
            let mut entity: Entity = entities
                .get(&id)
                .unwrap()
                .clone()
                .into_iter()
                .map(|(k, v)| (Word::from(k), v))
                .collect();

            let res = asc_new(&mut self.wasm_ctx, &entity.sorted(), &GasCounter::new())?;
            return Ok(res);
        }

        Ok(AscPtr::null())
    }

    fn load_related_entities(
        &mut self,
        entity_type: &String,
        entity_id: &String,
        entity_virtual_field: &String,
    ) -> Vec<Entity> {
        let mut related_entities: Vec<Entity> = Vec::new();

        if self.derived.contains_key(entity_type)
            && self
                .derived
                .get(entity_type)
                .unwrap()
                .contains_key(entity_virtual_field)
        {
            let (derived_from_entity_type, derived_from_entity_field) = self
                .derived
                .get(entity_type)
                .unwrap()
                .get(entity_virtual_field)
                .unwrap();

            if self.store.contains_key(&derived_from_entity_type.clone()) {
                for (derived_entity_id, derived_entity_fields) in self
                    .store
                    .get(&derived_from_entity_type.clone())
                    .unwrap()
                    .iter()
                {
                    if !derived_entity_fields.contains_key(&derived_from_entity_field.clone()) {
                        continue;
                    }

                    let derived_field_value = derived_entity_fields
                        .get(&derived_from_entity_field.clone())
                        .unwrap()
                        .clone();

                    // field value could be a single ID or list of IDs
                    let derived_entity_ids: Vec<Value> = match derived_field_value {
                        Value::Bytes(id) => vec![Value::from(id)],
                        Value::String(id) => vec![Value::from(id)],
                        Value::List(ids) => ids,
                        _ => vec![],
                    };

                    let no_relation_found: bool = derived_entity_ids
                        .iter()
                        .filter(|&derived_id| derived_id.to_string().eq(entity_id))
                        .count()
                        == 0;

                    if no_relation_found {
                        continue;
                    }

                    related_entities.push(
                        self.store
                            .get(&derived_from_entity_type.clone())
                            .unwrap()
                            .get(&derived_entity_id.clone())
                            .unwrap()
                            .clone()
                            // convert to Entity
                            .into_iter()
                            .map(|(k, v)| (Word::from(k), v))
                            .collect(),
                    );
                }
            }
        }

        related_entities
            .into_iter()
            .map(|mut v| v.sorted().clone())
            .collect()
    }

    /// function store.loadRelated(entity: string, id: string, field: string): Array<Entity>;
    pub fn mock_store_load_related(
        &mut self,
        _gas: &GasCounter,
        entity_type_ptr: AscPtr<AscString>,
        entity_id_ptr: AscPtr<AscString>,
        entity_virtual_field_ptr: AscPtr<AscString>,
    ) -> Result<AscPtr<Array<AscPtr<AscEntity>>>, HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr, &GasCounter::new(), 0)?;
        let entity_id: String = asc_get(&self.wasm_ctx, entity_id_ptr, &GasCounter::new(), 0)?;
        let entity_virtual_field: String = asc_get(
            &self.wasm_ctx,
            entity_virtual_field_ptr,
            &GasCounter::new(),
            0,
        )?;

        let related_entities: Vec<Entity> =
            self.load_related_entities(&entity_type, &entity_id, &entity_virtual_field);

        let related_entities_ptr: AscPtr<Array<AscPtr<AscEntity>>> =
            asc_new(&mut self.wasm_ctx, &related_entities, &GasCounter::new())?;

        Ok(related_entities_ptr)
    }

    /// function store.get(entityType: string, id: string): Entity
    pub fn mock_store_get(
        &mut self,
        _gas: &GasCounter,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
    ) -> Result<AscPtr<AscEntity>, HostExportError> {
        self.get_store_entity(StoreScope::Global, entity_type_ptr, id_ptr, _gas)
    }

    /// function store.getInBlock(entityType: string, id: string): Entity
    pub fn mock_store_get_in_block(
        &mut self,
        _gas: &GasCounter,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
    ) -> Result<AscPtr<AscEntity>, HostExportError> {
        self.get_store_entity(StoreScope::Cache, entity_type_ptr, id_ptr, _gas)
    }

    fn update_store(
        &mut self,
        scope: StoreScope,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        data_ptr: AscPtr<AscEntity>,
        _gas: &GasCounter,
    ) -> Result<(), HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr, &GasCounter::new(), 0)?;
        let id: String = asc_get(&self.wasm_ctx, id_ptr, &GasCounter::new(), 0)?;
        let data: HashMap<String, Value> =
            asc_get(&self.wasm_ctx, data_ptr, &GasCounter::new(), 0)?;

        let required_fields = SCHEMA
        .definitions
        .iter()
        .find_map(|def| {
            if let schema::Definition::TypeDefinition(schema::TypeDefinition::Object(o)) = def {
                if o.name == entity_type {
                    Some(o)
                } else {
                    None
                }
            } else {
                None
            }
        })
        .unwrap_or_else(|| {
            logging::critical!("Something went wrong! Could not find the entity defined in the GraphQL schema.")
        })
        .fields
        .iter()
        .clone()
        .filter(|&f| matches!(f.field_type, schema::Type::NonNullType(..)) && !f.is_derived());

        for f in required_fields {
            if !data.contains_key(&f.name) {
                return Err(anyhow!(
                    "Missing value for non-nullable field '{}' for an entity of type '{}'.",
                    f.name,
                    entity_type,
                )
                .into());
            } else if let Value::Null = data.get(&f.name).unwrap() {
                return Err(anyhow!(
                    "The required field '{}' for an entity of type '{}' is null.",
                    f.name,
                    entity_type,
                )
                .into());
            }
        }

        let store = match scope {
            StoreScope::Global => &mut self.store,
            StoreScope::Cache => &mut self.cache_store,
        };

        let mut entity_type_store = if store.contains_key(&entity_type) {
            store.get(&entity_type).unwrap().clone()
        } else {
            HashMap::new()
        };

        entity_type_store.insert(id, data);

        store.insert(entity_type, entity_type_store);

        Ok(())
    }

    /// function store.set(entityType: string, id: string, data: map): void
    pub fn mock_store_set(
        &mut self,
        _gas: &GasCounter,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        data_ptr: AscPtr<AscEntity>,
    ) -> Result<(), HostExportError> {
        let result = self.update_store(StoreScope::Global, entity_type_ptr, id_ptr, data_ptr, _gas);

        if result.is_ok() {
            self.store_updated = false;
        }

        result
    }

    /// function mockInBlockStore(entityType: string, id: string, data: map): void
    pub fn cache_store_set(
        &mut self,
        _gas: &GasCounter,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        data_ptr: AscPtr<AscEntity>,
    ) -> Result<(), HostExportError> {
        self.update_store(StoreScope::Cache, entity_type_ptr, id_ptr, data_ptr, _gas)
    }

    /// function store.remove(entityType: string, id: string): void
    pub fn mock_store_remove(
        &mut self,
        _gas: &GasCounter,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
    ) -> Result<(), HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr, &GasCounter::new(), 0)?;
        let id: String = asc_get(&self.wasm_ctx, id_ptr, &GasCounter::new(), 0)?;

        if self.store.contains_key(&entity_type)
            && self.store.get(&entity_type).unwrap().contains_key(&id)
        {
            let mut entity_type_store = self.store.get(&entity_type).unwrap().clone();
            entity_type_store.remove(&id);

            self.store.insert(entity_type, entity_type_store);
            self.store_updated = false;
        } else {
            return Err(anyhow!(
                "(store.remove) Entity with type '{}' and id '{}' does not exist.",
                &entity_type,
                &id
            )
            .into());
        }

        Ok(())
    }

    /// function ethereum.call(call: SmartContractCall): Array<Value> | null
    pub fn ethereum_call(
        &mut self,
        _gas: &GasCounter,
        contract_call_ptr: u32,
    ) -> Result<AscEnumArray<EthereumValueKind>, HostExportError> {
        let call: UnresolvedContractCall = asc_get::<_, AscUnresolvedContractCall_0_0_4, _>(
            &self.wasm_ctx,
            contract_call_ptr.into(),
            &GasCounter::new(),
            0,
        )?;

        let contract_address = call.contract_address.to_string();
        let fn_name = call.function_name.to_string();
        let fn_signature = call
            .function_signature
            .unwrap_or_else(|| logging::critical!("Could not get function signature."));
        let fn_args = call.function_args;

        let fn_id = MatchstickInstanceContext::<C>::fn_id(
            &contract_address,
            &fn_name,
            &fn_signature,
            &fn_args,
        );

        let return_val;
        if self.fn_ret_map.contains_key(&fn_id) {
            if *self.fn_ret_map.get(&fn_id).unwrap() == REVERTS_IDENTIFIER.clone() {
                return Ok(AscPtr::null());
            }

            return_val = asc_new(
                &mut self.wasm_ctx,
                self.fn_ret_map
                    .get(&fn_id)
                    .unwrap_or_else(|| logging::critical!("Could not get value from function map."))
                    .as_slice(),
                &GasCounter::new(),
            )?;

            Ok(return_val)
        } else {
            Err(anyhow!(
                "Could not find a mocked function with the following parameters, address: {}, name: {}, signature {}, params: {:?}.",
                &contract_address,
                &fn_name,
                &fn_signature,
                &fn_args
            ).into())
        }
    }

    /// function mockFunction(
    ///     contractAddress: Address, fnName: string, fnSignature: string,
    ///     fnArgs: ethereum.Value[], returnValue: ethereum.Value[], reverts: bool,
    /// ): void
    #[allow(clippy::too_many_arguments)]
    pub fn mock_function(
        &mut self,
        _gas: &GasCounter,
        contract_address_ptr: u32,
        fn_name_ptr: AscPtr<AscString>,
        fn_signature_ptr: AscPtr<AscString>,
        fn_args_ptr: u32,
        return_value_ptr: u32,
        reverts_ptr: AscPtr<bool>,
    ) -> Result<(), HostExportError> {
        let contract_address: Address = asc_get(
            &self.wasm_ctx,
            contract_address_ptr.into(),
            &GasCounter::new(),
            0,
        )?;
        let fn_name: String = asc_get(&self.wasm_ctx, fn_name_ptr, &GasCounter::new(), 0)?;
        let fn_signature: String =
            asc_get(&self.wasm_ctx, fn_signature_ptr, &GasCounter::new(), 0)?;
        let fn_args: Vec<Token> = asc_get::<_, Array<AscPtr<AscEnum<EthereumValueKind>>>, _>(
            &self.wasm_ctx,
            fn_args_ptr.into(),
            &GasCounter::new(),
            0,
        )?;
        let return_value: Vec<Token> = asc_get::<_, Array<AscPtr<AscEnum<EthereumValueKind>>>, _>(
            &self.wasm_ctx,
            return_value_ptr.into(),
            &GasCounter::new(),
            0,
        )?;
        let reverts = bool::from(EnumPayload(reverts_ptr.to_payload()));

        // Extracts the arguments part from the function signature
        // e.g "fnName(int32, string, address)" -> "int32, string, address"
        // and then calls `collect_types` to split the result into a Vec
        let tmp_str = fn_signature.replace(&(fn_name.clone() + "("), "");
        let components: Vec<&str> = tmp_str.split("):").collect();
        let tmp_args_str = components[0];
        let arg_types: Vec<String> = collect_types(tmp_args_str);

        let fn_signature_split: Vec<&str> = fn_signature.split('(').collect();
        if fn_name != fn_signature_split[0] {
            return Err(anyhow!(
                "createMockedFunction: function name `{}` should match the name in the function signature `{}`",
                fn_name,
                fn_signature
            ).into());
        }

        // Checks if the count of the passed arguments matches the count of expected arguments
        if arg_types.len() != fn_args.len() {
            return Err(anyhow!(
                "{} expected {} arguments, but received {}",
                fn_name,
                arg_types.len(),
                fn_args.len()
            )
            .into());
        }

        // Validates that every passed argument matches the type of the expected argument
        // from the function signature. Panics if there is a mismatch and informs the user
        // of the position and the expected and recieved type
        for (index, (arg_type, fn_arg)) in arg_types.iter().zip(fn_args.iter()).enumerate() {
            let param_type = get_kind(arg_type.to_owned());

            if !fn_arg.type_check(&param_type) {
                return Err(anyhow!(
                    "createMockedFunction `{}` parameters mismatch at position {}:\nExpected: {:?}\nRecieved: {:?}\n",
                    fn_name,
                    index + 1,
                    param_type,
                    fn_arg
                ).into());
            }
        }

        let fn_id = MatchstickInstanceContext::<C>::fn_id(
            &contract_address.to_string(),
            &fn_name,
            &fn_signature,
            &fn_args,
        );

        if reverts {
            self.fn_ret_map.insert(fn_id, REVERTS_IDENTIFIER.clone());
        } else {
            self.fn_ret_map.insert(fn_id, return_value);
        }

        Ok(())
    }

    /// function dataSource.create(name: string, params: Array<string>): void
    pub fn mock_data_source_create(
        &mut self,
        _gas: &GasCounter,
        _name_ptr: AscPtr<AscString>,
        _params_ptr: AscPtr<Array<AscPtr<AscString>>>,
    ) -> Result<(), HostExportError> {
        Ok(())
    }

    /// function dataSource.createWithContext(
    ///     name: string, params: Array<string>,
    ///     context: DataSourceContext,
    /// ): void
    pub fn mock_data_source_create_with_context(
        &mut self,
        _gas: &GasCounter,
        _name_ptr: AscPtr<AscString>,
        _params_ptr: AscPtr<Array<AscPtr<AscString>>>,
        _context_ptr: AscPtr<AscEntity>,
    ) -> Result<(), HostExportError> {
        Ok(())
    }

    /// function dataSource.address(): Address
    pub fn mock_data_source_address(
        &mut self,
        _gas: &GasCounter,
    ) -> Result<AscPtr<Uint8Array>, HostExportError> {
        let default_address_val = "0x0000000000000000000000000000000000000000";
        let result = match &self.data_source_return_value.0 {
            Some(value) => asc_new(
                &mut self.wasm_ctx,
                &Address::from_str(value).expect("Couldn't create Address."),
                &GasCounter::new(),
            )
            .expect("Couldn't create pointer."),
            None => asc_new(
                &mut self.wasm_ctx,
                &Address::from_str(default_address_val).expect("Couldn't create Address."),
                &GasCounter::new(),
            )
            .expect("Couldn't create pointer."),
        };

        Ok(result)
    }

    /// function dataSource.network(): String
    pub fn mock_data_source_network(
        &mut self,
        _gas: &GasCounter,
    ) -> Result<AscPtr<AscString>, HostExportError> {
        let default_network_val = "mainnet";
        let result = match &self.data_source_return_value.1 {
            Some(value) => AscPtr::alloc_obj(
                asc_string_from_str(&value.clone()),
                &mut self.wasm_ctx,
                &GasCounter::new(),
            )
            .expect("Couldn't create pointer."),
            None => AscPtr::alloc_obj(
                asc_string_from_str(default_network_val),
                &mut self.wasm_ctx,
                &GasCounter::new(),
            )
            .expect("Couldn't create pointer."),
        };

        Ok(result)
    }

    /// function dataSource.context(): DataSourceContext
    pub fn mock_data_source_context(
        &mut self,
        _gas: &GasCounter,
    ) -> Result<AscPtr<AscEntity>, HostExportError> {
        let default_context_val: Entity = Vec::new();
        let result = match &self.data_source_return_value.2 {
            Some(value) => {
                let mut entity: Entity = value
                    .clone()
                    .into_iter()
                    .map(|(k, v)| (Word::from(k), v))
                    .collect();

                asc_new(&mut self.wasm_ctx, &entity.sorted(), &GasCounter::new()).unwrap()
            }
            None => asc_new(&mut self.wasm_ctx, &default_context_val, &GasCounter::new()).unwrap(),
        };

        Ok(result)
    }

    /// function dataSourceMock.setReturnValues(address: String, network: String, context: DataSourceContext): void
    pub fn set_data_source_return_values(
        &mut self,
        _gas: &GasCounter,
        address_ptr: AscPtr<AscString>,
        network_ptr: AscPtr<AscString>,
        context_ptr: AscPtr<AscEntity>,
    ) -> Result<(), HostExportError> {
        let address: String = asc_get(&self.wasm_ctx, address_ptr, &GasCounter::new(), 0)?;
        let network: String = asc_get(&self.wasm_ctx, network_ptr, &GasCounter::new(), 0)?;
        let context: HashMap<String, Value> =
            asc_get(&self.wasm_ctx, context_ptr, &GasCounter::new(), 0)?;

        self.data_source_return_value = (Some(address), Some(network), Some(context));
        Ok(())
    }

    /// function countEntities(entityType: string): i32
    pub fn count_entities(
        &mut self,
        _gas: &GasCounter,
        entity_type_ptr: AscPtr<AscString>,
    ) -> Result<i32, HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr, &GasCounter::new(), 0)?;

        match self.store.get(&entity_type) {
            Some(inner_map) => Ok(inner_map.len().try_into().unwrap_or_else(|err| {
                panic!(
                    "Couldn't cast usize value: {} into i32.\n{}",
                    inner_map.len(),
                    err
                )
            })),
            None => Ok(0),
        }
    }

    /// function mockIpfsFile(hash: string, file_path: string): void
    pub fn mock_ipfs_file(
        &mut self,
        _gas: &GasCounter,
        hash_ptr: AscPtr<AscString>,
        file_path_ptr: AscPtr<AscString>,
    ) -> Result<(), HostExportError> {
        let hash: String = asc_get(&self.wasm_ctx, hash_ptr, &GasCounter::new(), 0)?;
        let file_path: String = asc_get(&self.wasm_ctx, file_path_ptr, &GasCounter::new(), 0)?;

        self.ipfs.insert(hash, file_path);
        Ok(())
    }

    /// function ipfs.cat(hash: string): Bytes | null
    pub fn mock_ipfs_cat(
        &mut self,
        _gas: &GasCounter,
        hash_ptr: AscPtr<AscString>,
    ) -> Result<AscPtr<Uint8Array>, HostExportError> {
        let hash: String = asc_get(&self.wasm_ctx, hash_ptr, &GasCounter::new(), 0)?;
        let file_path = &self
            .ipfs
            .get(&hash)
            .unwrap_or_else(|| logging::critical!("IPFS file `{}` not found", hash));
        let string = std::fs::read_to_string(file_path).unwrap_or_else(|err| {
            logging::critical!("Failed to read file `{}` with error: {}", &file_path, err)
        });
        let result = asc_new(&mut self.wasm_ctx, string.as_bytes(), &GasCounter::new())?;

        Ok(result)
    }

    /// function ipfs.map(link: string, callback: string, user_data: Value, flags: Array<string>): void
    pub fn mock_ipfs_map(
        &mut self,
        _gas: &GasCounter,
        link_ptr: AscPtr<AscString>,
        callback_ptr: AscPtr<AscString>,
        user_data_ptr: AscPtr<AscEnum<StoreValueKind>>,
        _flags_ptr: AscPtr<Array<AscPtr<AscString>>>,
    ) -> Result<(), HostExportError> {
        let link: String = asc_get(&self.wasm_ctx, link_ptr, &GasCounter::new(), 0)?;
        let callback: String = asc_get(&self.wasm_ctx, callback_ptr, &GasCounter::new(), 0)?;
        let user_data: Value = asc_get(&self.wasm_ctx, user_data_ptr, &GasCounter::new(), 0)?;

        let file_path = &self
            .ipfs
            .get(&link)
            .unwrap_or_else(|| logging::critical!("IPFS file `{}` not found", link));
        let data = std::fs::read_to_string(file_path).unwrap_or_else(|err| {
            logging::critical!("Failed to read file `{}` with error: {}", file_path, err)
        });
        let json_values: Vec<serde_json::Value> = serde_json::from_str(&data).unwrap();

        let host_metrics = &self.wasm_ctx.host_metrics.clone();
        let valid_module = &self.wasm_ctx.valid_module.clone();
        let ctx = &self.wasm_ctx.ctx.derive_with_empty_block_state();
        let experimental_features = ExperimentalFeatures {
            allow_non_deterministic_ipfs: true,
        };

        let instance = crate::MatchstickInstance::<C>::from_valid_module_with_ctx(
            valid_module.clone(),
            ctx.derive_with_empty_block_state(),
            host_metrics.clone(),
            None,
            experimental_features,
        )
        .unwrap();

        let data_ptr = asc_new(
            &mut instance.instance_ctx_mut().wasm_ctx,
            &user_data,
            &GasCounter::new(),
        )?;

        for value in json_values {
            let value_ptr = asc_new(
                &mut instance.instance_ctx_mut().wasm_ctx,
                &value,
                &GasCounter::new(),
            )?;

            instance.instance_ctx_mut().store = self.store.clone();
            instance.instance_ctx_mut().fn_ret_map = self.fn_ret_map.clone();
            instance.instance_ctx_mut().data_source_return_value =
                self.data_source_return_value.clone();

            instance
                .instance
                .get_func(&callback)
                .with_context(|| format!("function {} not found", &callback))?
                .typed()?
                .call((value_ptr.wasm_ptr(), data_ptr.wasm_ptr()))
                .with_context(|| format!("Failed to handle callback '{}'", &callback))?;

            self.store = instance.instance_ctx().store.clone();
            self.fn_ret_map = instance.instance_ctx().fn_ret_map.clone();
            self.data_source_return_value =
                instance.instance_ctx().data_source_return_value.clone();
        }

        Ok(())
    }
}

pub fn asc_string_from_str(initial_string: &str) -> AscString {
    let utf_16_iterator = initial_string.encode_utf16();
    let mut u16_vector = vec![];
    utf_16_iterator.for_each(|element| u16_vector.push(element));
    let version = Version::new(0, 0, 6);
    AscString::new(&u16_vector, version).expect("Couldn't create AscString.")
}
