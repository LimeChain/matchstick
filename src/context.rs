use regex::Regex;
use std::boxed::Box;
use std::collections::HashMap;
use std::str::FromStr;

use anyhow::Context;
use graph::{
    blockchain::Blockchain,
    data::{
        graphql::ext::DirectiveFinder,
        store::{scalar::Bytes, Attribute, Value},
    },
    prelude::{
        ethabi::{Address, ParamType, Token},
        BigInt, Entity,
    },
    runtime::{asc_get, asc_new, gas::GasCounter, try_asc_get, AscPtr, HostExportError},
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
use serde_json::to_string_pretty;

use crate::logging;
use crate::SCHEMA_LOCATION;

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

/// The Matchstick Instance Context wraps WASM Instance Context and
/// implements the external functions.
pub struct MatchstickInstanceContext<C: Blockchain> {
    /// Handle to WASM Instance Context.
    pub wasm_ctx: WasmInstanceContext<C>,
    /// Store<EntityType, EntityTypeStore<EntityId, Entity<Field, Value>>>.
    pub(crate) store: HashMap<String, HashMap<String, HashMap<String, Value>>>,
    /// Function-Return map storing mocked Smart Contracts' functions' return values.
    pub(crate) fn_ret_map: HashMap<String, Vec<Token>>,
    /// Registered tests metadata.
    pub meta_tests: Vec<(String, bool, u32)>,
    /// Holding the derived field type and a tuple of the entity it points to
    /// with a vector of all the field names and the corresponding derived field names.
    /// The example below is taken from a schema.graphql file and will fill the map in the following way:
    /// {"NameSignalTransaction": [("nameSignalTransactions", "signer", "GraphAccount")])}
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
    pub(crate) derived: HashMap<String, Vec<(String, String, String)>>,
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
            fn_ret_map: HashMap::new(),
            meta_tests: Vec::new(),
            derived: HashMap::new(),
            store_updated: true,
            data_source_return_value: (None, None, None),
            ipfs: HashMap::new(),
        };
        context.derive_schema();
        context
    }

    /// Constructs a unique ID for a given contract function.
    fn fn_id(
        contract_address: &str,
        fn_name: &str,
        fn_signature: &str,
        fn_args: Vec<Token>,
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
        let msg: String = asc_get(&self.wasm_ctx, msg, &GasCounter::new())?;

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

    /// function clearStore(): void
    pub fn clear_store(&mut self, _gas: &GasCounter) -> Result<(), HostExportError> {
        self.store.clear();
        self.store_updated = true;
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
        let name: String = asc_get(&self.wasm_ctx, name, &GasCounter::new())?;
        let should_fail = bool::from(EnumPayload(should_fail.to_payload()));
        self.meta_tests.push((name, should_fail, func_idx));
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
        self.update_derived_relations_in_store();
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr, &GasCounter::new())?;
        let id: String = asc_get(&self.wasm_ctx, id_ptr, &GasCounter::new())?;
        let field_name: String = asc_get(&self.wasm_ctx, field_name_ptr, &GasCounter::new())?;
        let expected_val: String = asc_get(&self.wasm_ctx, expected_val_ptr, &GasCounter::new())?;

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
        self.update_derived_relations_in_store();
        let expected: Token = asc_get::<_, AscEnum<EthereumValueKind>, _>(
            &self.wasm_ctx,
            expected_ptr.into(),
            &GasCounter::new(),
        )?;
        let actual: Token = asc_get::<_, AscEnum<EthereumValueKind>, _>(
            &self.wasm_ctx,
            actual_ptr.into(),
            &GasCounter::new(),
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
        self.update_derived_relations_in_store();
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr, &GasCounter::new())?;
        let id: String = asc_get(&self.wasm_ctx, id_ptr, &GasCounter::new())?;

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

    /// function store.get(entityType: string, id: string): Entity
    pub fn mock_store_get(
        &mut self,
        _gas: &GasCounter,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
    ) -> Result<AscPtr<AscEntity>, HostExportError> {
        self.update_derived_relations_in_store();
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr, &GasCounter::new())?;
        let id: String = asc_get(&self.wasm_ctx, id_ptr, &GasCounter::new())?;

        if self.store.contains_key(&entity_type)
            && self.store.get(&entity_type).unwrap().contains_key(&id)
        {
            let entities = self.store.get(&entity_type).unwrap();
            let entity = entities.get(&id).unwrap().clone();
            let entity = Entity::from(entity);

            let res = asc_new(&mut self.wasm_ctx, &entity.sorted(), &GasCounter::new())?;
            return Ok(res);
        }

        Ok(AscPtr::null())
    }

    /// function store.set(entityType: string, id: string, data: map): void
    pub fn mock_store_set(
        &mut self,
        _gas: &GasCounter,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        data_ptr: AscPtr<AscEntity>,
    ) -> Result<(), HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr, &GasCounter::new())?;
        let id: String = asc_get(&self.wasm_ctx, id_ptr, &GasCounter::new())?;
        let data: HashMap<String, Value> =
            try_asc_get(&self.wasm_ctx, data_ptr, &GasCounter::new())?;

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
                logging::warning!(
                    "Missing a required field '{}' for an entity of type '{}'.",
                    f.name,
                    entity_type,
                );
            } else if let Value::Null = data.get(&f.name).unwrap() {
                logging::warning!(
                    "The required field '{}' for an entity of type '{}' is null.",
                    f.name,
                    entity_type,
                );
            }
        }

        if self.derived.contains_key(&entity_type) {
            let linking_fields = self
                .derived
                .get(&entity_type)
                .unwrap_or_else(|| {
                    logging::critical!("Couldn't find value for key {} in derived map", entity_type)
                })
                .clone();
            for linking_field in linking_fields {
                if data.contains_key(&linking_field.1) && self.store.contains_key(&linking_field.2)
                {
                    let original_entity_type = linking_field.2.clone();
                    let derived_field_value = data
                        .get(&linking_field.1)
                        .unwrap_or_else(|| {
                            logging::critical!(
                                "Couldn't find value for {} in submitted data",
                                linking_field.1
                            )
                        })
                        .clone();
                    if matches!(derived_field_value, Value::List(_)) {
                        for derived_field_value in derived_field_value.as_list().unwrap().clone() {
                            self.insert_derived_field_in_store(
                                derived_field_value,
                                original_entity_type.clone(),
                                linking_field.clone(),
                                id.clone(),
                            );
                        }
                    } else {
                        self.insert_derived_field_in_store(
                            derived_field_value,
                            original_entity_type.clone(),
                            linking_field.clone(),
                            id.clone(),
                        );
                    }
                }
            }
        }

        let mut entity_type_store = if self.store.contains_key(&entity_type) {
            self.store.get(&entity_type).unwrap().clone()
        } else {
            HashMap::new()
        };

        entity_type_store.insert(id, data);
        self.store.insert(entity_type.clone(), entity_type_store);
        self.store_updated = false;
        Ok(())
    }

    /// This function checks whether all the necessary data is present in the store to avoid linking
    /// entities to other non existent entities which may cause serious collision problems later
    fn insert_derived_field_in_store(
        &mut self,
        derived_field_value: Value,
        original_entity: String,
        linking_field: (String, String, String),
        id: String,
    ) {
        if derived_field_value.is_string() {
            let derived_field_string_value = derived_field_value.as_string().unwrap();
            if self.store.contains_key(&original_entity) {
                let mut inner_store = self
                    .store
                    .get(&original_entity)
                    .unwrap_or_else(|| {
                        logging::critical!("Couldn't find value for {} in store", original_entity)
                    })
                    .clone();
                if inner_store.contains_key(&derived_field_string_value) {
                    let mut innermost_store = inner_store
                        .get(&derived_field_string_value)
                        .unwrap_or_else(|| {
                            logging::critical!(
                                "Couldn't find value for {} in inner store",
                                derived_field_string_value
                            )
                        })
                        .clone();
                    if innermost_store.contains_key(&linking_field.0) {
                        let innermost_value = innermost_store
                            .get(&linking_field.0)
                            .unwrap_or_else(|| {
                                logging::critical!(
                                    "Couldn't find value for {} in innermost store",
                                    linking_field.0
                                )
                            })
                            .clone();
                        if !innermost_value
                            .clone()
                            .as_list()
                            .unwrap()
                            .contains(&Value::from(id.clone()))
                        {
                            let mut innermost_value_list = innermost_value.as_list().unwrap();
                            innermost_value_list.push(Value::from(id));
                            innermost_store
                                .insert(linking_field.0, Value::List(innermost_value_list));
                        }
                    } else {
                        innermost_store.insert(linking_field.0, Value::List(vec![Value::from(id)]));
                    }
                    inner_store.insert(derived_field_string_value, innermost_store);
                }
                self.store.insert(original_entity, inner_store);
            }
        }
    }

    /// Checks for and removes faulty store relations.
    /// This function is called on every assert/store.get to make sure assertions and entity loading is done with an updated store
    fn update_derived_relations_in_store(&mut self) {
        if !self.store_updated {
            for entity in self.store.clone() {
                for inner_entity in entity.1 {
                    let entity_type = entity.0.clone();
                    let id = inner_entity.0;
                    let data = inner_entity.1;
                    if self.derived.contains_key(&entity_type) {
                        let mut entity_deleted = true;
                        let linking_fields = self
                            .derived
                            .get(&entity_type)
                            .unwrap_or_else(|| {
                                logging::critical!(
                                    "Couldn't find value for key {} in derived map",
                                    entity_type
                                )
                            })
                            .clone();
                        for linking_field in &linking_fields {
                            if self.store.contains_key(&linking_field.2) {
                                let inner_store = self.store.get(&linking_field.2).unwrap().clone();
                                let relation_id = data.get(&linking_field.1).unwrap();
                                if relation_id.is_string()
                                    && inner_store.contains_key(relation_id.as_str().unwrap())
                                {
                                    entity_deleted = false;
                                    let original_entity_data =
                                        inner_store.get(relation_id.as_str().unwrap()).unwrap();
                                    for field in original_entity_data {
                                        if &linking_field.0 == field.0
                                            && matches!(field.1, Value::List(_))
                                        {
                                            let value_list =
                                                field.1.clone().as_list().unwrap().clone();
                                            if !value_list.contains(&Value::String(id.clone()))
                                                && data.contains_key(&linking_field.1)
                                            {
                                                self.handle_different_value_types(
                                                    data.clone(),
                                                    linking_field,
                                                    relation_id,
                                                    field,
                                                    id.clone(),
                                                    entity_deleted,
                                                );
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Removes the entity with no relations from every list it may be in
                        if entity_deleted {
                            for linking_field in &linking_fields {
                                if self.store.contains_key(&linking_field.2) {
                                    let inner_store =
                                        self.store.get(&linking_field.2).unwrap().clone();
                                    let relation_id = data.get(&linking_field.1).unwrap();
                                    if relation_id.is_string() {
                                        for original_entity_id_and_data in &inner_store {
                                            let innermost_store = inner_store
                                                .get(original_entity_id_and_data.0)
                                                .unwrap()
                                                .clone();
                                            for field in &innermost_store {
                                                if &linking_field.0 == field.0
                                                    && matches!(field.1, Value::List(_))
                                                {
                                                    let value_list =
                                                        field.1.clone().as_list().unwrap().clone();
                                                    if value_list
                                                        .contains(&Value::String(id.clone()))
                                                        && data.contains_key(&linking_field.1)
                                                    {
                                                        self.handle_different_value_types(
                                                            data.clone(),
                                                            linking_field,
                                                            relation_id,
                                                            field,
                                                            id.clone(),
                                                            entity_deleted,
                                                        );
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.store_updated = true;
        }
    }

    fn handle_different_value_types(
        &mut self,
        data: HashMap<String, Value>,
        linking_field: &(String, String, String),
        relation_id: &Value,
        field: (&String, &Value),
        id: String,
        entity_deleted: bool,
    ) {
        if data.get(&linking_field.1).unwrap().is_string() {
            self.remove_dead_relations(
                data.get(&linking_field.1).unwrap().to_owned(),
                relation_id.as_str().unwrap(),
                field,
                Value::String(id),
                linking_field.2.clone(),
                entity_deleted,
            );
        } else if matches!(data.get(&linking_field.1).unwrap(), Value::List(_)) {
            let linking_field_values = data
                .get(&linking_field.1)
                .unwrap()
                .clone()
                .as_list()
                .unwrap();
            for linking_field_value in linking_field_values {
                self.remove_dead_relations(
                    linking_field_value,
                    relation_id.as_str().unwrap(),
                    field,
                    Value::String(id.clone()),
                    linking_field.2.clone(),
                    entity_deleted,
                );
            }
        }
    }

    fn remove_dead_relations(
        &mut self,
        current_value: Value,
        entity: &str,
        field: (&String, &Value),
        value: Value,
        original_entity: String,
        entity_deleted: bool,
    ) {
        if current_value.is_string()
            && (current_value.as_str().unwrap() != entity && !entity_deleted)
            || (current_value.as_str().unwrap() == entity && entity_deleted)
        {
            let mut inner_store = self.store.get(&original_entity).unwrap().clone();
            if !entity_deleted {
                let mut innermost_store = inner_store.get(entity).unwrap().clone();
                let mut value_list = field.1.clone().as_list().unwrap();

                if value_list.contains(&value) {
                    value_list.remove(value_list.iter().position(|x| *x == value).unwrap());
                    innermost_store.insert(field.0.to_owned(), Value::List(value_list));
                    inner_store.insert(entity.to_owned(), innermost_store);

                    self.store.insert(original_entity, inner_store);
                }
            } else {
                for mut entity in inner_store.clone() {
                    let mut value_list = field.1.clone().as_list().unwrap();

                    if value_list.contains(&value) {
                        value_list.remove(value_list.iter().position(|x| *x == value).unwrap());
                        entity.1.insert(field.0.to_owned(), Value::List(value_list));
                        inner_store.insert(entity.0, entity.1);

                        self.store
                            .insert(original_entity.clone(), inner_store.clone());
                    }
                }
            }
        }
    }

    /// function store.remove(entityType: string, id: string): void
    pub fn mock_store_remove(
        &mut self,
        _gas: &GasCounter,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
    ) -> Result<(), HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr, &GasCounter::new())?;
        let id: String = asc_get(&self.wasm_ctx, id_ptr, &GasCounter::new())?;

        if self.store.contains_key(&entity_type)
            && self.store.get(&entity_type).unwrap().contains_key(&id)
        {
            if self.derived.contains_key(&entity_type) {
                self.cascade_remove(entity_type.clone(), id.clone());
            }
            let mut entity_type_store = self.store.get(&entity_type).unwrap().clone();
            entity_type_store.remove(&id);

            self.store.insert(entity_type, entity_type_store);
            self.store_updated = false;
        } else {
            logging::error!(
                "(store.remove) Entity with type '{}' and id '{}' does not exist.",
                &entity_type,
                &id
            );
        }

        Ok(())
    }

    /// Removes the deleted entity from the other end of any relations it may have
    fn cascade_remove(&mut self, entity_type: String, id: String) {
        let store = self.store.clone();
        let deleted_entity_data = store.get(&entity_type).unwrap().get(&id).unwrap();
        let linking_fields = self
            .derived
            .get(&entity_type)
            .unwrap_or_else(|| {
                logging::critical!("Couldn't find value for key {} in derived map", entity_type)
            })
            .clone();

        for linking_field in linking_fields {
            if self.store.contains_key(&linking_field.2) {
                let original_entity_type = linking_field.2.clone();
                let mut original_entity = store.get(&original_entity_type).unwrap().clone();
                if deleted_entity_data.contains_key(&linking_field.1) {
                    let relation_id = deleted_entity_data.get(&linking_field.1).unwrap();
                    if relation_id.is_string()
                        && original_entity.contains_key(relation_id.as_str().unwrap())
                    {
                        let mut inner_store = original_entity
                            .get(relation_id.as_str().unwrap())
                            .unwrap()
                            .clone();
                        if inner_store.contains_key(&linking_field.0) {
                            let mut value_list = inner_store
                                .get(&linking_field.0)
                                .unwrap()
                                .clone()
                                .as_list()
                                .unwrap();
                            if value_list.contains(&Value::String(id.clone())) {
                                value_list.remove(
                                    value_list
                                        .iter()
                                        .position(|x| *x == Value::String(id.clone()))
                                        .unwrap(),
                                );
                                inner_store.insert(linking_field.0, Value::List(value_list));
                                original_entity
                                    .insert(relation_id.clone().as_string().unwrap(), inner_store);
                                self.store
                                    .insert(original_entity_type.clone(), original_entity.clone());
                            }
                        }
                    }
                }
            }
        }
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
        )?;

        let fn_id = MatchstickInstanceContext::<C>::fn_id(
            &call.contract_address.to_string(),
            &call.function_name,
            &call
                .function_signature
                .unwrap_or_else(|| logging::critical!("Could not get function signature.")),
            call.function_args,
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
            logging::critical!(
                "Key: '{}' not found in map. Please mock the function before calling it.",
                &fn_id,
            );
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
        )?;
        let fn_name: String = asc_get(&self.wasm_ctx, fn_name_ptr, &GasCounter::new())?;
        let fn_signature: String = asc_get(&self.wasm_ctx, fn_signature_ptr, &GasCounter::new())?;
        let fn_args: Vec<Token> = asc_get::<_, Array<AscPtr<AscEnum<EthereumValueKind>>>, _>(
            &self.wasm_ctx,
            fn_args_ptr.into(),
            &GasCounter::new(),
        )?;
        let return_value: Vec<Token> = asc_get::<_, Array<AscPtr<AscEnum<EthereumValueKind>>>, _>(
            &self.wasm_ctx,
            return_value_ptr.into(),
            &GasCounter::new(),
        )?;
        let reverts = bool::from(EnumPayload(reverts_ptr.to_payload()));

        let tmp_str = fn_signature.replace(&(fn_name.clone() + "("), "");
        let components: Vec<&str> = tmp_str.split("):").collect();
        let tmp_args_str = components[0];
        let arg_types: Vec<String> = collect_types(tmp_args_str);

        if arg_types.len() != fn_args.len() {
            logging::critical!(
                "{} expected {} arguments, but received {}",
                fn_name,
                arg_types.len(),
                fn_args.len()
            )
        }

        for (index, (arg_type, fn_arg)) in arg_types.iter().zip(fn_args.iter()).enumerate() {
            let param_type = get_kind(arg_type.to_owned());

            if !fn_arg.type_check(&param_type) {
                logging::critical!(
                    "createMockedFunction `{}` parameters mismatch at position {}:\nExpected: {:?}\nRecieved: {:?}\n",
                    fn_name,
                    index + 1,
                    param_type,
                    fn_arg
                );
            }
        }

        let fn_id = MatchstickInstanceContext::<C>::fn_id(
            &contract_address.to_string(),
            &fn_name,
            &fn_signature,
            fn_args,
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
        let default_context_val = Entity::new();
        let result = match &self.data_source_return_value.2 {
            Some(value) => asc_new(
                &mut self.wasm_ctx,
                &Entity::from(value.clone()).sorted(),
                &GasCounter::new(),
            )
            .unwrap(),
            None => asc_new(
                &mut self.wasm_ctx,
                &default_context_val.sorted(),
                &GasCounter::new(),
            )
            .unwrap(),
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
        let address: String = asc_get(&self.wasm_ctx, address_ptr, &GasCounter::new())?;
        let network: String = asc_get(&self.wasm_ctx, network_ptr, &GasCounter::new())?;
        let context: HashMap<String, Value> =
            try_asc_get(&self.wasm_ctx, context_ptr, &GasCounter::new())?;

        self.data_source_return_value = (Some(address), Some(network), Some(context));
        Ok(())
    }

    /// function countEntities(entityType: string): i32
    pub fn count_entities(
        &mut self,
        _gas: &GasCounter,
        entity_type_ptr: AscPtr<AscString>,
    ) -> Result<i32, HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr, &GasCounter::new())?;

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
        let hash: String = asc_get(&self.wasm_ctx, hash_ptr, &GasCounter::new())?;
        let file_path: String = asc_get(&self.wasm_ctx, file_path_ptr, &GasCounter::new())?;

        self.ipfs.insert(hash, file_path);
        Ok(())
    }

    /// function ipfs.cat(hash: string): Bytes | null
    pub fn mock_ipfs_cat(
        &mut self,
        _gas: &GasCounter,
        hash_ptr: AscPtr<AscString>,
    ) -> Result<AscPtr<Uint8Array>, HostExportError> {
        let hash: String = asc_get(&self.wasm_ctx, hash_ptr, &GasCounter::new())?;
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
        let link: String = asc_get(&self.wasm_ctx, link_ptr, &GasCounter::new())?;
        let callback: String = asc_get(&self.wasm_ctx, callback_ptr, &GasCounter::new())?;
        let user_data: Value = try_asc_get(&self.wasm_ctx, user_data_ptr, &GasCounter::new())?;

        let file_path = &self
            .ipfs
            .get(&link)
            .unwrap_or_else(|| logging::critical!("IPFS file `{}` not found", link));
        let data = std::fs::read_to_string(&file_path).unwrap_or_else(|err| {
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
            instance.instance_ctx_mut().derived = self.derived.clone();
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
            self.derived = instance.instance_ctx().derived.clone();
            self.data_source_return_value =
                instance.instance_ctx().data_source_return_value.clone();
        }

        Ok(())
    }

    /// This function reads the schema.graphql file and writes all the relations
    /// between the entities to the derived data structure
    fn derive_schema(&mut self) {
        SCHEMA.definitions.iter().for_each(|def| {
            if let schema::Definition::TypeDefinition(schema::TypeDefinition::Object(o)) = def {
                let entity_type = &o.name;
                let derived_fields = o.fields.iter().filter(|&f| {
                    matches!(f.field_type, schema::Type::NonNullType(..)) && f.is_derived()
                });
                for f in derived_fields {
                    // field type is received as: '[ExampleClass!]!' and needs to be reduced to a class string
                    let clean_field_type = f
                        .field_type
                        .to_string()
                        .replace('!', "")
                        .replace('[', "")
                        .replace(']', "");
                    let mut directive = f.find_directive("derivedFrom").unwrap().clone();

                    let field = directive
                        .arguments
                        .pop()
                        .unwrap()
                        .1
                        .to_string()
                        .replace('\"', "");

                    if self.derived.contains_key(&clean_field_type) {
                        let mut field_names_vec = self
                            .derived
                            .get(&clean_field_type)
                            .unwrap_or_else(|| {
                                logging::critical!(
                                    "Failed to get field names vector for type {}",
                                    clean_field_type
                                )
                            })
                            .clone();

                        let field_names_tuple = (f.name.clone(), field, String::from(entity_type));
                        if !field_names_vec.contains(&field_names_tuple) {
                            field_names_vec.push(field_names_tuple);
                            self.derived.insert(clean_field_type, field_names_vec);
                        }
                    } else {
                        self.derived.insert(
                            clean_field_type,
                            vec![(f.name.clone(), field, String::from(entity_type))],
                        );
                    }
                }
            }
        });
    }
}

pub fn asc_string_from_str(initial_string: &str) -> AscString {
    let utf_16_iterator = initial_string.encode_utf16();
    let mut u16_vector = vec![];
    utf_16_iterator.for_each(|element| u16_vector.push(element));
    let version = Version::new(0, 0, 6);
    AscString::new(&u16_vector, version).expect("Couldn't create AscString.")
}

fn collect_types(arg_str: &str) -> Vec<String> {
    let mut arg_types: Vec<String> = vec![];

    if !arg_str.is_empty() {
        let mut parenthesis = 0;
        let mut arg_type = "".to_owned();

        for char in arg_str.chars() {
            if char == '(' {
                arg_type = arg_type.to_owned() + "(";
                parenthesis += 1;
            } else if char == ')' {
                arg_type = arg_type.to_owned() + ")";
                parenthesis -= 1;
            } else if char == ',' && parenthesis == 0 {
                arg_types.push(arg_type);
                arg_type = "".to_owned();
            } else {
                arg_type = arg_type.to_owned() + &char.to_string();
            }
        }

        if !arg_type.is_empty() {
            arg_types.push(arg_type)
        }
    }

    arg_types
}

fn get_kind(kind: String) -> ParamType {
    let kind_str = kind.trim();
    let int_r = Regex::new(r#"^int\d+$"#).expect("Invalid uint/int regex");
    let uint_r = Regex::new(r#"^uint\d+$"#).expect("Invalid uint/int regex");
    let array_r = Regex::new(r#"\w*\d*\[\]$"#).expect("Invalid array regex");
    let fixed_bytes_r = Regex::new(r#"bytes\d+$"#).expect("Invalid fixedBytes regex");
    let fixed_array_r = Regex::new(r#"\w*\d*\[\d+\]$"#).expect("Invalid fixedArray regex");
    let tuple_r = Regex::new(r#"\((.+?)(?:,|$)*\)$"#).expect("Invalid tuple regex");

    match kind_str {
        "address" => ParamType::Address,
        "bool" => ParamType::Bool,
        "bytes" => ParamType::Bytes,
        "string" => ParamType::String,
        kind_str if int_r.is_match(kind_str) => {
            let size = kind_str.replace("int", "").parse::<usize>().unwrap();
            ParamType::Int(size)
        }
        kind_str if uint_r.is_match(kind_str) => {
            let size = kind_str.replace("uint", "").parse::<usize>().unwrap();
            ParamType::Uint(size)
        }
        kind_str if array_r.is_match(kind_str) => {
            let p_type = Box::new(get_kind(kind_str.replace("[]", "")));
            ParamType::Array(p_type)
        }
        kind_str if fixed_bytes_r.is_match(kind_str) => {
            let size = kind_str.replace("bytes", "").parse::<usize>().unwrap();
            ParamType::FixedBytes(size)
        }
        kind_str if fixed_array_r.is_match(kind_str) => {
            let tmp_str = kind.replace(']', "");
            let components: Vec<&str> = tmp_str.split('[').collect();
            let p_type = Box::new(get_kind(components[0].to_owned()));
            let size = components[1].parse::<usize>().unwrap();
            ParamType::FixedArray(p_type, size)
        }
        kind_str if tuple_r.is_match(kind_str) => {
            let tmp_str = &kind_str[1..kind_str.len() - 1];
            let str_components: Vec<String> = collect_types(tmp_str);
            let components: Vec<ParamType> = str_components.into_iter().map(get_kind).collect();
            ParamType::Tuple(components)
        }
        _ => logging::critical!("Unrecognized argument type `{}`", kind_str),
    }
}

fn get_token_value(token: Token) -> Value {
    match token {
        Token::Address(address) => Value::Bytes(Bytes::from(address)),
        Token::FixedBytes(bytes) | Token::Bytes(bytes) => {
            Value::Bytes(Bytes::from(bytes.as_slice()))
        }
        Token::Int(uint) => Value::BigInt(BigInt::from_signed_u256(&uint)),
        Token::Uint(uint) => Value::BigInt(BigInt::from_unsigned_u256(&uint)),
        Token::Bool(bool) => Value::Bool(bool),
        Token::String(string) => Value::String(string),
        Token::FixedArray(tokens) | Token::Array(tokens) | Token::Tuple(tokens) => {
            Value::List(tokens.into_iter().map(get_token_value).collect())
        }
    }
}
