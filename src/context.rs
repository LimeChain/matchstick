use std::collections::HashMap;

use super::logging::Log;

use ethabi::{Address, Token};
use graph::{
    blockchain::Blockchain,
    data::store::Value,
    prelude::Entity,
    runtime::{asc_get, asc_new, try_asc_get, AscPtr, HostExportError},
};
use graph_chain_ethereum::runtime::{
    abi::AscUnresolvedContractCall_0_0_4, runtime_adapter::UnresolvedContractCall,
};
use graph_graphql::graphql_parser::schema;
use graph_runtime_wasm::{
    asc_abi::class::{
        Array, AscEntity, AscEnum, AscEnumArray, AscString, EnumPayload, EthereumValueKind,
    },
    module::WasmInstanceContext,
};
use lazy_static::lazy_static;
use serde_json::to_string_pretty;

lazy_static! {
    /// Special tokens...
    static ref REVERTS_IDENTIFIER: Vec<Token> =
        vec![Token::Bytes(vec![255, 255, 255, 255, 255, 255, 255])];
}

/// The Matchstick Instance Context wraps WASM Instance Context and
/// implements the external functions.
#[allow(dead_code)]
pub struct MatchstickInstanceContext<C: Blockchain> {
    /// Handle to WASM Instance Context.
    pub wasm_ctx: WasmInstanceContext<C>,

    /// Store<EntityType, EntityTypeStore<EntityId, Entity<Field, Value>>>.
    store: HashMap<String, HashMap<String, HashMap<String, Value>>>,
    /// Function-Return map storing mocked Smart Contracts' functions' return values.
    fn_ret_map: HashMap<String, Vec<Token>>,
    /// A reference to the global GraphQL Schema read from `subgraph/schema.graphql`.
    schema: Option<schema::Document<'static, String>>,
    /// Registered tests metadata.
    pub meta_tests: Vec<(String, bool, u32)>,
}

/// Implementation of non-external functions.
#[allow(dead_code)]
impl<C: Blockchain> MatchstickInstanceContext<C> {
    pub fn new(wasm_ctx: WasmInstanceContext<C>) -> Self {
        MatchstickInstanceContext {
            wasm_ctx,
            store: HashMap::new(),
            fn_ret_map: HashMap::new(),
            schema: None,
            meta_tests: Vec::new(),
        }
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
#[allow(dead_code)]
impl<C: Blockchain> MatchstickInstanceContext<C> {
    /// function log(level: enum Level (u32), msg: string): void
    pub fn log(&mut self, level: u32, msg: AscPtr<AscString>) -> Result<(), HostExportError> {
        let msg: String = asc_get(&self.wasm_ctx, msg)?;
        let log = Log::new(level, msg);

        if let Log::Critical(_) = log {
            panic!("{}", log);
        } else {
            println!("{}", log);
        }

        Ok(())
    }

    /// function logStore(): void
    pub fn log_store(&mut self) -> Result<(), HostExportError> {
        println!(
            "{}",
            Log::Debug(to_string_pretty(&self.store).expect("`store` can't be converted to JSON."))
        );
        Ok(())
    }

    /// function clearStore(): void
    pub fn clear_store(&mut self) -> Result<(), HostExportError> {
        self.store.clear();
        Ok(())
    }

    // function registerTest(name: string, shouldFail: bool, func_idx: i32): void
    pub fn register_test(
        &mut self,
        name: AscPtr<AscString>,
        should_fail: AscPtr<bool>,
        func_idx: u32,
    ) -> Result<(), HostExportError> {
        let name: String = asc_get(&self.wasm_ctx, name)?;
        let should_fail = bool::from(EnumPayload(should_fail.to_payload()));
        self.meta_tests.push((name, should_fail, func_idx));
        Ok(())
    }

    // function assert.
    // fieldEquals(entityType: string, id: string, fieldName: string, expectedVal: string): bool
    pub fn assert_field_equals(
        &mut self,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        field_name_ptr: AscPtr<AscString>,
        expected_val_ptr: AscPtr<AscString>,
    ) -> Result<bool, HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr)?;
        let id: String = asc_get(&self.wasm_ctx, id_ptr)?;
        let field_name: String = asc_get(&self.wasm_ctx, field_name_ptr)?;
        let expected_val: String = asc_get(&self.wasm_ctx, expected_val_ptr)?;

        if !self.store.contains_key(&entity_type) {
            let msg = format!(
                "(assert.fieldEquals) No entities with type '{}' found.",
                &entity_type
            );
            Log::Error(msg).print();
            return Ok(false);
        }

        let entities = self.store.get(&entity_type).unwrap();
        if !entities.contains_key(&id) {
            let msg = format!(
                "(assert.fieldEquals) No entity with type '{}' and id '{}' found.",
                &entity_type, &id
            );
            Log::Error(msg).print();
            return Ok(false);
        }

        let entity = entities.get(&id).unwrap();
        if !entity.contains_key(&field_name) {
            let msg = format!(
                "(assert.fieldEquals) No field named '{}' on entity with type '{}' and id '{}' found.",
                &field_name, &entity_type, &id
            );
            Log::Error(msg).print();
            return Ok(false);
        }

        let val = entity.get(&field_name).unwrap();
        if val.to_string() != expected_val {
            let msg = format!(
                "(assert.fieldEquals) Expected field '{}' to equal '{}', but was '{}' instead.",
                &field_name, &expected_val, val
            );
            Log::Error(msg).print();
            return Ok(false);
        };

        Ok(true)
    }

    // function assert.equals(expected: ethereum.Value, actual: ethereum.Value): bool
    pub fn assert_equals(
        &mut self,
        expected_ptr: u32,
        actual_ptr: u32,
    ) -> Result<bool, HostExportError> {
        let expected: Token =
            asc_get::<_, AscEnum<EthereumValueKind>, _>(&self.wasm_ctx, expected_ptr.into())?;
        let actual: Token =
            asc_get::<_, AscEnum<EthereumValueKind>, _>(&self.wasm_ctx, actual_ptr.into())?;

        if expected != actual {
            let msg = format!(
                "Expected value was '{:?}' but actual value was '{:?}'",
                expected, actual
            );
            Log::Error(msg).print();
            return Ok(false);
        }
        Ok(true)
    }

    // function assert.notInStore(entityType: string, id: string): bool
    pub fn assert_not_in_store(
        &mut self,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
    ) -> Result<bool, HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr)?;
        let id: String = asc_get(&self.wasm_ctx, id_ptr)?;

        if self.store.contains_key(&entity_type)
            && self.store.get(&entity_type).unwrap().contains_key(&id)
        {
            let msg = format!(
                "Value for entity type: '{}' and id: '{}' was found in store.",
                entity_type, id
            );
            Log::Error(msg).print();
            return Ok(false);
        }

        Ok(true)
    }

    // function store.get(entityType: string, id: string): Entity
    pub fn mock_store_get(
        &mut self,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
    ) -> Result<AscPtr<AscEntity>, HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr)?;
        let id: String = asc_get(&self.wasm_ctx, id_ptr)?;

        if self.store.contains_key(&entity_type)
            && self.store.get(&entity_type).unwrap().contains_key(&id)
        {
            let entities = self.store.get(&entity_type).unwrap();
            let entity = entities.get(&id).unwrap().clone();
            let entity = Entity::from(entity);

            let res = asc_new(&mut self.wasm_ctx, &entity.sorted())?;
            return Ok(res);
        }

        Ok(AscPtr::null())
    }

    pub fn mock_store_set(
        &mut self,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        data_ptr: AscPtr<AscEntity>,
    ) -> Result<(), HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr)?;
        let id: String = asc_get(&self.wasm_ctx, id_ptr)?;
        // Q: What does try_asc_get do?
        let data: HashMap<String, Value> = try_asc_get(&self.wasm_ctx, data_ptr)?;

        let required_fields = self
            .schema
            .as_ref()
            .unwrap()
            .definitions
            .iter()
            .find_map(|def| {
                if let schema::Definition::TypeDefinition(schema::TypeDefinition::Object(o)) = def {
                    Some(o)
                } else {
                    None
                }
            })
            .expect("Something went wrong! Couldn't find the entity defined in the GraphQL schema.")
            .fields
            .iter()
            .filter(|&f| matches!(f.field_type, schema::Type::NonNullType(..)));

        for f in required_fields {
            let warn = |s: String| Log::Warning(s).print();

            if !data.contains_key(&f.name) {
                warn(format!(
                    "Missing a required field `{}` for an entity of type `{}`.",
                    f.name, entity_type
                ));
            } else if let Value::Null = data.get(&f.name).unwrap() {
                warn(format!(
                    "The required field `{}` for an entity of type `{}` is null.",
                    f.name, entity_type
                ));
            }
        }

        let mut entity_type_store = if self.store.contains_key(&entity_type) {
            self.store.get(&entity_type).unwrap().clone()
        } else {
            HashMap::new()
        };

        entity_type_store.insert(id, data);
        self.store.insert(entity_type, entity_type_store);
        Ok(())
    }

    pub fn mock_store_remove(
        &mut self,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
    ) -> Result<(), HostExportError> {
        let entity_type: String = asc_get(&self.wasm_ctx, entity_type_ptr)?;
        let id: String = asc_get(&self.wasm_ctx, id_ptr)?;

        if self.store.contains_key(&entity_type)
            && self.store.get(&entity_type).unwrap().contains_key(&id)
        {
            let mut entity_type_store = self.store.get(&entity_type).unwrap().clone();
            entity_type_store.remove(&id);

            self.store.insert(entity_type, entity_type_store);
        } else {
            let msg = format!(
                "(store.remove) Entity with type '{}' and id '{}' does not exist. Problem originated from store.remove()",
                &entity_type, &id
            );
            Log::Error(msg).print();
            return Ok(());
        }
        Ok(())
    }

    pub fn ethereum_call(
        &mut self,
        contract_call_ptr: u32,
    ) -> Result<AscEnumArray<EthereumValueKind>, HostExportError> {
        let call: UnresolvedContractCall = asc_get::<_, AscUnresolvedContractCall_0_0_4, _>(
            &self.wasm_ctx,
            contract_call_ptr.into(),
        )?;

        let fn_id = MatchstickInstanceContext::<C>::fn_id(
            &call.contract_address.to_string(),
            &call.function_name,
            &call.function_signature.unwrap_or_else(|| {
                panic!(
                    "{}",
                    Log::Critical("Couldn't get function signature.".to_string()).to_string()
                )
            }),
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
                    .expect("Couldn't get value from map.")
                    .as_slice(),
            )?;

            Ok(return_val)
        } else {
            panic!(
                "Key: '{}' not found in map. Please mock the function before calling it.",
                &fn_id
            );
        }
    }

    pub fn mock_function(
        &mut self,
        contract_address_ptr: u32,
        fn_name_ptr: AscPtr<AscString>,
        fn_signature_ptr: AscPtr<AscString>,
        fn_args_ptr: u32,
        return_value_ptr: u32,
        reverts_ptr: AscPtr<bool>,
    ) -> Result<(), HostExportError> {
        let contract_address: Address = asc_get(&self.wasm_ctx, contract_address_ptr.into())?;
        let fn_name: String = asc_get(&self.wasm_ctx, fn_name_ptr)?;
        let fn_signature: String = asc_get(&self.wasm_ctx, fn_signature_ptr)?;
        let fn_args: Vec<Token> = asc_get::<_, Array<AscPtr<AscEnum<EthereumValueKind>>>, _>(
            &self.wasm_ctx,
            fn_args_ptr.into(),
        )?;
        let return_value: Vec<Token> = asc_get::<_, Array<AscPtr<AscEnum<EthereumValueKind>>>, _>(
            &self.wasm_ctx,
            return_value_ptr.into(),
        )?;
        let reverts = bool::from(EnumPayload(reverts_ptr.to_payload()));

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

    // Q: What are the following for?
    pub fn mock_data_source_create(
        &mut self,
        _name_ptr: AscPtr<AscString>,
        _params_ptr: AscPtr<Array<AscPtr<AscString>>>,
    ) -> Result<(), HostExportError> {
        Ok(())
    }

    pub fn mock_data_source_create_with_context(
        &mut self,
        _name_ptr: AscPtr<AscString>,
        _params_ptr: AscPtr<Array<AscPtr<AscString>>>,
        _context_ptr: AscPtr<AscEntity>,
    ) -> Result<(), HostExportError> {
        Ok(())
    }
}
