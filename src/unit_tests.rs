#[cfg(test)]
mod unit_tests {
    use std::collections::HashMap;
    use std::str::FromStr;

    use graph::{
        data::store::Value,
        prelude::ethabi::{Address, Token},
        runtime::{asc_get, AscPtr, AscType},
    };
    use graph_chain_ethereum::{runtime::abi::AscUnresolvedContractCall_0_0_4, Chain};
    use graph_runtime_wasm::asc_abi::class::{
        Array, AscEnum, AscTypedMap, AscTypedMapEntry, EnumPayload, EthereumValueKind,
        StoreValueKind, TypedArray,
    };
    use serial_test::serial;

    use crate::context::REVERTS_IDENTIFIER;
    use crate::context::{asc_string_from_str, MatchstickInstanceContext};
    use crate::logging::{accum, flush, LOGS};
    use crate::{MatchstickInstance, SCHEMA_LOCATION};

    fn get_context() -> MatchstickInstanceContext<Chain> {
        SCHEMA_LOCATION.with(|path| *path.borrow_mut() = "./mocks/schema.graphql".to_string());
        let module = <MatchstickInstance<Chain>>::new("mocks/wasm/Gravity.wasm");

        module
            .instance_ctx
            .take()
            .take()
            .expect("Couldn't get context from module.")
    }

    #[test]
    #[serial]
    fn log_basic_test() {
        let mut context = get_context();

        let message = asc_string_from_str("log message");
        let pointer =
            AscPtr::alloc_obj(message, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        accum();
        context.log(3, pointer).expect("Couldn't call log.");

        unsafe {
            assert_eq!(LOGS.len(), 1);
            assert!(LOGS.pop().unwrap().contains("log message"));
            flush();
        }
    }

    #[test]
    #[serial]
    #[should_panic(expected = "🆘 ")]
    fn log_panic_test() {
        let mut context = get_context();

        let message = asc_string_from_str("log message");
        let pointer =
            AscPtr::alloc_obj(message, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        context.log(0, pointer).expect("Couldn't call log.");
    }

    #[test]
    #[serial]
    fn clear_store_basic_test() {
        let mut context = get_context();

        context.store.insert("type".to_string(), HashMap::new());

        context.clear_store().expect("Couldn't call clear_store");

        assert_eq!(context.store.len(), 0);
    }

    #[test]
    #[serial]
    fn register_test_basic_test() {
        let mut context = get_context();

        context.meta_tests = vec![];
        let initial_asc_string = asc_string_from_str("test");
        let name_ptr = AscPtr::alloc_obj(initial_asc_string, &mut context.wasm_ctx)
            .expect("Couldn't unwrap pointer.");
        let should_throw_ptr = AscPtr::new(0);

        context
            .register_test(name_ptr, should_throw_ptr, 0)
            .expect("Couldn't call register_test.");

        assert_eq!(context.meta_tests.len(), 1);
        assert_eq!(context.meta_tests[0].0, "test");
        assert_eq!(context.meta_tests[0].1, false);
        assert_eq!(context.meta_tests[0].2, 0);
    }

    #[test]
    #[serial]
    fn assert_field_equals_basic_test() {
        let mut context = get_context();

        let entity_string = asc_string_from_str("entity");
        let id_string = asc_string_from_str("id");
        let field_name_string = asc_string_from_str("field_name");
        let expected_val_string = asc_string_from_str("val");
        let entity_ptr = AscPtr::alloc_obj(entity_string, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");
        let id_ptr =
            AscPtr::alloc_obj(id_string, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let field_name_ptr = AscPtr::alloc_obj(field_name_string, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");
        let expected_val_ptr = AscPtr::alloc_obj(expected_val_string, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");

        context.store.insert("entity".to_string(), HashMap::new());
        let mut inner_map = context
            .store
            .get("entity")
            .expect("Couldn't get inner map.")
            .clone();
        inner_map.insert("id".to_string(), HashMap::new());
        let mut entity = inner_map
            .get("id")
            .expect("Couldn't get value from inner map.")
            .clone();
        entity.insert("field_name".to_string(), Value::String("val".to_string()));
        inner_map.insert("id".to_string(), entity);
        context.store.insert("entity".to_string(), inner_map);

        let result = context
            .assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr)
            .expect("Couldn't call assert_field_equals.");

        assert!(result);
    }

    #[test]
    #[serial]
    fn assert_field_equals_failing_variants() {
        let mut context = get_context();

        let entity_string = asc_string_from_str("entity");
        let id_string = asc_string_from_str("id");
        let field_name_string = asc_string_from_str("field_name");
        let expected_val_string = asc_string_from_str("val");
        let entity_ptr = AscPtr::alloc_obj(entity_string, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");
        let id_ptr =
            AscPtr::alloc_obj(id_string, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let field_name_ptr = AscPtr::alloc_obj(field_name_string, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");
        let expected_val_ptr = AscPtr::alloc_obj(expected_val_string, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");

        let mut result = context
            .assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr)
            .expect("Couldn't call assert_field_equals.");

        assert!(!result);

        context.store.insert("entity".to_string(), HashMap::new());

        result = context
            .assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr)
            .expect("Couldn't call assert_field_equals.");

        assert!(!result);

        let mut inner_map = context
            .store
            .get("entity")
            .expect("Couldn't get inner map.")
            .clone();
        inner_map.insert("id".to_string(), HashMap::new());
        context.store.insert("entity".to_string(), inner_map);

        result = context
            .assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr)
            .expect("Couldn't call assert_field_equals.");

        assert!(!result);

        let mut inner_map = context
            .store
            .get("entity")
            .expect("Couldn't get inner map.")
            .clone();
        let mut entity = inner_map
            .get("id")
            .expect("Couldn't get value from inner map.")
            .clone();
        entity.insert("field_name".to_string(), Value::Null);
        inner_map.insert("id".to_string(), entity);
        context.store.insert("entity".to_string(), inner_map);

        result = context
            .assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr)
            .expect("Couldn't call assert_field_equals.");

        assert!(!result);
    }

    #[test]
    #[serial]
    fn assert_equals_basic_test() {
        let mut context = get_context();

        let val = asc_string_from_str("val");
        let val_ptr =
            AscPtr::alloc_obj(val, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        let asc_enum = AscEnum::<EthereumValueKind> {
            kind: EthereumValueKind::String,
            _padding: 0,
            payload: EnumPayload::from(val_ptr),
        };
        let pointer =
            AscPtr::alloc_obj(asc_enum, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        let result = context
            .assert_equals(pointer.wasm_ptr(), pointer.wasm_ptr())
            .expect("Couldn't call assert_equals.");

        assert!(result);
    }

    #[test]
    #[serial]
    fn assert_equals_inequality() {
        let mut context = get_context();

        let val = asc_string_from_str("val");
        let val1 = asc_string_from_str("val1");

        let val_ptr =
            AscPtr::alloc_obj(val, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let val1_ptr =
            AscPtr::alloc_obj(val1, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        let asc_enum = AscEnum::<EthereumValueKind> {
            kind: EthereumValueKind::String,
            _padding: 0,
            payload: EnumPayload::from(val_ptr),
        };
        let asc_enum1 = AscEnum::<EthereumValueKind> {
            kind: EthereumValueKind::String,
            _padding: 0,
            payload: EnumPayload::from(val1_ptr),
        };

        let pointer =
            AscPtr::alloc_obj(asc_enum, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let pointer1 =
            AscPtr::alloc_obj(asc_enum1, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        let result = context
            .assert_equals(pointer.wasm_ptr(), pointer1.wasm_ptr())
            .expect("Couldn't call assert_equals.");

        assert!(!result);
    }

    #[test]
    #[serial]
    fn assert_not_in_store_basic_test() {
        let mut context = get_context();

        let entity_type = asc_string_from_str("entity_type");
        let id = asc_string_from_str("id");

        let entity_type_ptr = AscPtr::alloc_obj(entity_type, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");
        let id_ptr =
            AscPtr::alloc_obj(id, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        let result = context
            .assert_not_in_store(entity_type_ptr, id_ptr)
            .expect("Couldn't call assert_not_in_store.");

        assert!(result);
    }

    #[test]
    #[serial]
    fn assert_not_in_store_when_in_store() {
        let mut context = get_context();

        context
            .store
            .insert("entity_type".to_string(), HashMap::new());
        let mut inner_map = context
            .store
            .get("entity_type")
            .expect("Couldn't get inner map.")
            .clone();
        inner_map.insert("id".to_string(), HashMap::new());
        context.store.insert("entity_type".to_string(), inner_map);

        let entity_type = asc_string_from_str("entity_type");
        let id = asc_string_from_str("id");

        let entity_type_ptr = AscPtr::alloc_obj(entity_type, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");
        let id_ptr =
            AscPtr::alloc_obj(id, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        let result = context
            .assert_not_in_store(entity_type_ptr, id_ptr)
            .expect("Couldn't call assert_not_in_store.");

        assert!(!result);
    }

    #[test]
    #[serial]
    fn mock_store_get_basic_test() {
        let mut context = get_context();

        context.store.insert("entity".to_string(), HashMap::new());
        let mut inner_map = context
            .store
            .get("entity")
            .expect("Couldn't get inner map.")
            .clone();
        inner_map.insert("id".to_string(), HashMap::new());
        let mut entity = inner_map
            .get("id")
            .expect("Couldn't get value from inner map.")
            .clone();
        entity.insert("field_name".to_string(), Value::String("val".to_string()));
        inner_map.insert("id".to_string(), entity);
        context.store.insert("entity".to_string(), inner_map);

        let entity = asc_string_from_str("entity");
        let id = asc_string_from_str("id");
        let entity_pointer =
            AscPtr::alloc_obj(entity, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let id_pointer =
            AscPtr::alloc_obj(id, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        let value = context
            .mock_store_get(entity_pointer, id_pointer)
            .expect("Couldn't call mock_store_get.");

        assert_eq!(
            value.read_ptr(&context.wasm_ctx).unwrap().content_len(
                &value
                    .read_ptr(&context.wasm_ctx)
                    .unwrap()
                    .to_asc_bytes()
                    .expect("Couldn't get entity bytes.")
            ),
            4
        );
    }

    #[test]
    #[serial]
    fn mock_store_get_no_such_entity() {
        let mut context = get_context();

        let entity = asc_string_from_str("entity");
        let id = asc_string_from_str("id");
        let entity_pointer =
            AscPtr::alloc_obj(entity, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let id_pointer =
            AscPtr::alloc_obj(id, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        let value = context
            .mock_store_get(entity_pointer, id_pointer)
            .expect("Couldn't call mock_store_get.");

        assert!(value.is_null());
    }

    #[test]
    #[serial]
    fn mock_store_set_basic_test() {
        let mut context = get_context();

        let entity = asc_string_from_str("entity");
        let id = asc_string_from_str("id");
        let key = asc_string_from_str("key");
        let data = asc_string_from_str("data");
        let entity_pointer =
            AscPtr::alloc_obj(entity, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let id_pointer =
            AscPtr::alloc_obj(id, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let key_pointer =
            AscPtr::alloc_obj(key, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let data_pointer =
            AscPtr::alloc_obj(data, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        let payload = AscEnum::<StoreValueKind> {
            kind: StoreValueKind::String,
            _padding: 0,
            payload: EnumPayload::from(data_pointer),
        };
        let payload_pointer =
            AscPtr::alloc_obj(payload, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let map_entry = AscTypedMapEntry {
            key: key_pointer,
            value: payload_pointer,
        };
        let map_entry_pointer =
            AscPtr::alloc_obj(map_entry, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let asc_map = AscTypedMap {
            entries: AscPtr::alloc_obj(
                Array::new(&[map_entry_pointer], &mut context.wasm_ctx)
                    .expect("Couldn't create Array."),
                &mut context.wasm_ctx,
            )
            .expect("Couldn't create pointer."),
        };
        let asc_map_pointer =
            AscPtr::alloc_obj(asc_map, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        context
            .mock_store_set(entity_pointer, id_pointer, asc_map_pointer)
            .expect("Couldn't call mock_store_get.");

        let inner_map = context
            .store
            .get("entity")
            .expect("Couldn't get inner map.");
        assert_eq!(inner_map.len(), 1);
    }

    #[test]
    #[serial]
    fn mock_store_set_existing_entity_type() {
        let mut context = get_context();

        let entity = asc_string_from_str("entity");
        let id = asc_string_from_str("id");
        let key = asc_string_from_str("key");
        let data = asc_string_from_str("data");
        let entity_pointer =
            AscPtr::alloc_obj(entity, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let id_pointer =
            AscPtr::alloc_obj(id, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let key_pointer =
            AscPtr::alloc_obj(key, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let data_pointer =
            AscPtr::alloc_obj(data, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        context.store.insert("entity".to_string(), HashMap::new());
        let mut inner_map = context
            .store
            .get("entity")
            .expect("Couldn't get inner map.")
            .clone();
        inner_map.insert("another_id".to_string(), HashMap::new());
        context.store.insert("entity".to_string(), inner_map);

        let payload = AscEnum::<StoreValueKind> {
            kind: StoreValueKind::String,
            _padding: 0,
            payload: EnumPayload::from(data_pointer),
        };
        let payload_pointer =
            AscPtr::alloc_obj(payload, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let map_entry = AscTypedMapEntry {
            key: key_pointer,
            value: payload_pointer,
        };
        let map_entry_pointer =
            AscPtr::alloc_obj(map_entry, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let asc_map = AscTypedMap {
            entries: AscPtr::alloc_obj(
                Array::new(&[map_entry_pointer], &mut context.wasm_ctx)
                    .expect("Couldn't create Array."),
                &mut context.wasm_ctx,
            )
            .expect("Couldn't create pointer."),
        };
        let asc_map_pointer =
            AscPtr::alloc_obj(asc_map, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        context
            .mock_store_set(entity_pointer, id_pointer, asc_map_pointer)
            .expect("Couldn't call mock_store_get.");

        let inner_map = context
            .store
            .get("entity")
            .expect("Couldn't get inner map.");
        assert_eq!(inner_map.len(), 2);
    }

    #[test]
    #[serial]
    fn mock_store_remove_basic_test() {
        let mut context = get_context();

        context.store.insert("entity".to_string(), HashMap::new());
        let mut inner_map = context
            .store
            .get("entity")
            .expect("Couldn't get inner map.")
            .clone();
        inner_map.insert("id".to_string(), HashMap::new());
        context.store.insert("entity".to_string(), inner_map);

        let entity = asc_string_from_str("entity");
        let id = asc_string_from_str("id");
        let entity_pointer =
            AscPtr::alloc_obj(entity, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let id_pointer =
            AscPtr::alloc_obj(id, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        context
            .mock_store_remove(entity_pointer, id_pointer)
            .expect("Couldn't call mock_store_remove.");

        assert!(!context.store.get("entity").unwrap().contains_key("id"));
    }

    #[test]
    #[serial]
    fn ethereum_call_basic_test() {
        let mut context = get_context();

        context.fn_ret_map.insert(
            "0x8920…43e7funcNamefuncName(address):(string,string)val".to_string(),
            vec![Token::Bool(false)],
        );

        let contract_name = asc_string_from_str("contractName");
        // Necessary step because Address fits (hashes) the address into 20 bytes
        // whereas otherwise it will be 42 and asc_get (in ethereum_call) will crash
        let h160_address = Address::from_str("89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7")
            .expect("Couldn't create Address.");
        let address = TypedArray::new(h160_address.as_bytes(), &mut context.wasm_ctx)
            .expect("Coudln't create address.");
        let func_name = asc_string_from_str("funcName");
        let func_signature = asc_string_from_str("funcName(address):(string,string)");
        let val = asc_string_from_str("val");

        let contract_name_pointer = AscPtr::alloc_obj(contract_name, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");
        let address_pointer =
            AscPtr::alloc_obj(address, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let func_name_pointer =
            AscPtr::alloc_obj(func_name, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let func_signature_pointer = AscPtr::alloc_obj(func_signature, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");
        let val_ptr =
            AscPtr::alloc_obj(val, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        let asc_enum = AscEnum::<EthereumValueKind> {
            kind: EthereumValueKind::String,
            _padding: 0,
            payload: EnumPayload::from(val_ptr),
        };
        let func_args_pointer =
            AscPtr::alloc_obj(asc_enum, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let func_args_array_pointer = AscPtr::alloc_obj(
            Array::new(&[func_args_pointer], &mut context.wasm_ctx)
                .expect("Couldn't create array."),
            &mut context.wasm_ctx,
        )
        .expect("Couldn't create pointer.");

        let unresolved_call = AscUnresolvedContractCall_0_0_4 {
            contract_name: contract_name_pointer,
            contract_address: address_pointer,
            function_name: func_name_pointer,
            function_signature: func_signature_pointer,
            function_args: func_args_array_pointer,
        };
        let call_pointer = AscPtr::alloc_obj(unresolved_call, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");

        let result = context
            .ethereum_call(call_pointer.wasm_ptr())
            .expect("Couldn't call ethereum_call.");

        let fn_args: Vec<Token> = asc_get::<_, Array<AscPtr<AscEnum<EthereumValueKind>>>, _>(
            &mut context.wasm_ctx,
            result,
        )
        .expect("Couldn't unwrap result.");
        assert_eq!(fn_args[0], Token::Bool(false));
    }

    #[test]
    #[serial]
    fn ethereum_call_reverting_func() {
        let mut context = get_context();

        context.fn_ret_map.insert(
            "0x8920…43e7funcNamefuncName(address):(string,string)val".to_string(),
            REVERTS_IDENTIFIER.clone(),
        );

        let contract_name = asc_string_from_str("contractName");
        // Necessary step because Address fits (hashes) the address into 20 bytes
        // whereas otherwise it will be 42 and asc_get (in ethereum_call) will crash
        let h160_address = Address::from_str("89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7")
            .expect("Couldn't create Address.");
        let address = TypedArray::new(h160_address.as_bytes(), &mut context.wasm_ctx)
            .expect("Coudln't create address.");
        let func_name = asc_string_from_str("funcName");
        let func_signature = asc_string_from_str("funcName(address):(string,string)");
        let val = asc_string_from_str("val");

        let contract_name_pointer = AscPtr::alloc_obj(contract_name, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");
        let address_pointer =
            AscPtr::alloc_obj(address, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let func_name_pointer =
            AscPtr::alloc_obj(func_name, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let func_signature_pointer = AscPtr::alloc_obj(func_signature, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");
        let val_ptr =
            AscPtr::alloc_obj(val, &mut context.wasm_ctx).expect("Couldn't create pointer.");

        let asc_enum = AscEnum::<EthereumValueKind> {
            kind: EthereumValueKind::String,
            _padding: 0,
            payload: EnumPayload::from(val_ptr),
        };
        let func_args_pointer =
            AscPtr::alloc_obj(asc_enum, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let func_args_array_pointer = AscPtr::alloc_obj(
            Array::new(&[func_args_pointer], &mut context.wasm_ctx)
                .expect("Couldn't create array."),
            &mut context.wasm_ctx,
        )
        .expect("Couldn't create pointer.");

        let unresolved_call = AscUnresolvedContractCall_0_0_4 {
            contract_name: contract_name_pointer,
            contract_address: address_pointer,
            function_name: func_name_pointer,
            function_signature: func_signature_pointer,
            function_args: func_args_array_pointer,
        };
        let call_pointer = AscPtr::alloc_obj(unresolved_call, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");

        let result = context
            .ethereum_call(call_pointer.wasm_ptr())
            .expect("Couldn't call ethereum_call.");

        assert!(result.is_null());
    }

    #[test]
    #[serial]
    fn mock_function_basic_test() {
        let mut context = get_context();

        // Necessary step because Address fits (hashes) the
        // address into 20 bytes whereas otherwise it will be 42
        let h160_address = Address::from_str("89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7")
            .expect("Couldn't create Address.");
        let address = TypedArray::new(h160_address.as_bytes(), &mut context.wasm_ctx)
            .expect("Coudln't create address.");
        let func_name = asc_string_from_str("funcName");
        let func_signature = asc_string_from_str("funcName(address):(string,string)");
        let val = asc_string_from_str("val");

        let address_pointer =
            AscPtr::alloc_obj(address, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let func_name_pointer =
            AscPtr::alloc_obj(func_name, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let func_signature_pointer = AscPtr::alloc_obj(func_signature, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");
        let val_pointer =
            AscPtr::alloc_obj(val, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let reverts_pointer = AscPtr::new(0);

        let asc_enum = AscEnum::<EthereumValueKind> {
            kind: EthereumValueKind::String,
            _padding: 0,
            payload: EnumPayload::from(val_pointer),
        };
        let func_args_pointer =
            AscPtr::alloc_obj(asc_enum, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let func_args_array_pointer = AscPtr::alloc_obj(
            Array::new(&[func_args_pointer], &mut context.wasm_ctx)
                .expect("Couldn't create array."),
            &mut context.wasm_ctx,
        )
        .expect("Couldn't create pointer.");

        context
            .mock_function(
                address_pointer.wasm_ptr(),
                func_name_pointer,
                func_signature_pointer,
                func_args_array_pointer.wasm_ptr(),
                func_args_array_pointer.wasm_ptr(),
                reverts_pointer,
            )
            .expect("Couldn't call mock_function.");

        let token = context
            .fn_ret_map
            .get("0x8920…43e7funcNamefuncName(address):(string,string)val")
            .unwrap()[0]
            .clone();
        assert_eq!(&token.to_string(), "val");
    }

    #[test]
    #[serial]
    fn mock_function_reverts() {
        let mut context = get_context();

        // Necessary step because Address fits (hashes) the
        // address into 20 bytes whereas otherwise it will be 42
        let h160_address = Address::from_str("89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7")
            .expect("Couldn't create Address.");
        let address = TypedArray::new(h160_address.as_bytes(), &mut context.wasm_ctx)
            .expect("Coudln't create address.");
        let func_name = asc_string_from_str("funcName");
        let func_signature = asc_string_from_str("funcName(address):(string,string)");
        let val = asc_string_from_str("val");

        let address_pointer =
            AscPtr::alloc_obj(address, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let func_name_pointer =
            AscPtr::alloc_obj(func_name, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let func_signature_pointer = AscPtr::alloc_obj(func_signature, &mut context.wasm_ctx)
            .expect("Couldn't create pointer.");
        let val_pointer =
            AscPtr::alloc_obj(val, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let reverts_pointer = AscPtr::new(1);

        let asc_enum = AscEnum::<EthereumValueKind> {
            kind: EthereumValueKind::String,
            _padding: 0,
            payload: EnumPayload::from(val_pointer),
        };
        let func_args_pointer =
            AscPtr::alloc_obj(asc_enum, &mut context.wasm_ctx).expect("Couldn't create pointer.");
        let func_args_array_pointer = AscPtr::alloc_obj(
            Array::new(&[func_args_pointer], &mut context.wasm_ctx)
                .expect("Couldn't create array."),
            &mut context.wasm_ctx,
        )
        .expect("Couldn't create pointer.");

        context
            .mock_function(
                address_pointer.wasm_ptr(),
                func_name_pointer,
                func_signature_pointer,
                func_args_array_pointer.wasm_ptr(),
                func_args_array_pointer.wasm_ptr(),
                reverts_pointer,
            )
            .expect("Couldn't call mock_function.");

        let token = context
            .fn_ret_map
            .get("0x8920…43e7funcNamefuncName(address):(string,string)val")
            .unwrap()[0]
            .clone();
        assert_eq!(token, REVERTS_IDENTIFIER[0]);
    }
}
