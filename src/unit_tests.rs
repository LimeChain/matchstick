//graph_runtime_wasm::asc_abi::class::AscTypedMap.entries NEEDS TO BE MADE PUBLIC FOR MEANINGFUL/POSSIBLE UNIT TESTS
//graph_runtime_wasm::asc_abi::class::TypedArray::new() NEEDS TO BE MADE PUBLIC FOR ADDRESS CREATION
#[cfg(test)]
mod unit_tests {
    use crate::module_from_path;
    use crate::wasm_instance::{clear_pub_static_refs, WICExtension, LOGS, STORE, TEST_RESULTS};
    use graph::data::store::Value;
    use graph::runtime::AscPtr;
    use graph::runtime::AscType;
    use graph::semver::{BuildMetadata, Prerelease, Version};
    use graph_chain_ethereum::Chain;
    use graph_runtime_wasm::asc_abi::class::AscEnum;
    use graph_runtime_wasm::asc_abi::class::AscString;
    use graph_runtime_wasm::asc_abi::class::{EnumPayload, EthereumValueKind};
    use graph_runtime_wasm::module::WasmInstanceContext;
    use indexmap::IndexMap;
    use serial_test::serial;
    use std::collections::HashMap;

    fn get_context() -> WasmInstanceContext<Chain> {
        let module = module_from_path("mocks/wasm/Gravity.wasm");
        let context = module
            .instance_ctx
            .take()
            .take()
            .expect("Couldn't get context from module.");
        return context;
    }

    fn asc_string_from_str(initial_string: &str) -> AscString {
        let utf_16_iterator = initial_string.encode_utf16();
        let mut u16_vector = vec![];
        utf_16_iterator.for_each(|element| u16_vector.push(element));
        let version = get_version();
        return AscString::new(&u16_vector, version.clone()).expect("Couldn't create AscString.");
    }

    fn get_version() -> Version {
        Version {
            major: 0,
            minor: 0,
            patch: 4,
            build: BuildMetadata::EMPTY,
            pre: Prerelease::new("").expect("Couldn't create new Prerelease."),
        }
    }

    #[test]
    #[serial]
    fn log_basic_test() {
        let mut context = get_context();
        clear_pub_static_refs();
        let message = asc_string_from_str("log message");
        let pointer = AscPtr::alloc_obj(message, &mut context).expect("Couldn't create pointer.");

        context.log(3, pointer).expect("Couldn't call log.");

        let mut logs = LOGS.lock().expect("Cannot access LOGS.");
        assert_eq!(logs.len(), 1);
        assert_eq!(logs.pop().unwrap().0, "log message");
    }

    #[test]
    #[serial]
    fn log_error_test() {
        let mut context = get_context();
        clear_pub_static_refs();
        let mut test_results = TEST_RESULTS.lock().expect("Couldn't get TEST_RESULTS.");
        test_results.insert("test name".to_string(), true);
        drop(test_results);
        let message = asc_string_from_str("log message");
        let pointer = AscPtr::alloc_obj(message, &mut context).expect("Couldn't create pointer.");

        context.log(1, pointer).expect("Couldn't call log.");

        let mut logs = LOGS.lock().expect("Cannot get LOGS.");
        let test_results = TEST_RESULTS.lock().expect("Couldn't get TEST_RESULTS.");
        assert_eq!(logs.len(), 1);
        assert_eq!(logs.pop().unwrap().0, "log message");
        assert_eq!(test_results.len(), 1);
        assert_eq!(*test_results.get("test name").unwrap(), false);
    }

    #[test]
    #[serial]
    #[should_panic(expected = "❌ ❌ ❌ ")]
    fn log_panic_test() {
        let mut context = get_context();
        clear_pub_static_refs();
        let message = asc_string_from_str("log message");
        let pointer = AscPtr::alloc_obj(message, &mut context).expect("Couldn't create pointer.");

        context.log(0, pointer).expect("Couldn't call log.");
    }

    #[test]
    #[serial]
    fn clear_store_basic_test() {
        let mut context = get_context();
        clear_pub_static_refs();
        let mut store = STORE.lock().expect("Couldn't get STORE.");
        store.insert("type".to_string(), IndexMap::new());
        drop(store);

        context.clear_store().expect("Couldn't clear store");

        let store = STORE.lock().expect("Couldn't get store.");
        assert_eq!(store.len(), 0);
    }

    #[test]
    #[serial]
    fn register_test_basic_test() {
        let mut context = get_context();
        clear_pub_static_refs();

        let initial_asc_string = asc_string_from_str("test");
        let pointer = AscPtr::alloc_obj(initial_asc_string, &mut context);

        context
            .register_test(pointer.expect("Couldn't unwrap pointer."))
            .expect("Couldn't call register_test.");

        let test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        assert_eq!(test_results.len(), 1);
    }

    #[test]
    #[serial]
    #[should_panic(expected = "Test with name 'duplicate test' already exists.")]
    fn register_test_duplicate_should_panic() {
        let mut context = get_context();
        clear_pub_static_refs();
        let mut test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        test_results.insert("duplicate test".to_string(), true);
        drop(test_results);

        let initial_asc_string = asc_string_from_str("duplicate test");
        let pointer = AscPtr::alloc_obj(initial_asc_string, &mut context);

        context
            .register_test(pointer.expect("Couldn't unwrap pointer."))
            .expect("Couldn't call register_test.");
    }

    #[test]
    #[serial]
    fn assert_field_equals_basic_test() {
        let mut context = get_context();
        clear_pub_static_refs();
        let entity_string = asc_string_from_str("entity");
        let id_string = asc_string_from_str("id");
        let field_name_string = asc_string_from_str("field_name");
        let expected_val_string = asc_string_from_str("val");
        let entity_ptr =
            AscPtr::alloc_obj(entity_string, &mut context).expect("Couldn't create pointer.");
        let id_ptr = AscPtr::alloc_obj(id_string, &mut context).expect("Couldn't create pointer.");
        let field_name_ptr =
            AscPtr::alloc_obj(field_name_string, &mut context).expect("Couldn't create pointer.");
        let expected_val_ptr =
            AscPtr::alloc_obj(expected_val_string, &mut context).expect("Couldn't create pointer.");

        let mut map = STORE.lock().expect("Cannot access STORE.");
        map.insert("entity".to_string(), IndexMap::new());
        let mut inner_map = map.get("entity").expect("Couldn't get inner map.").clone();
        inner_map.insert("id".to_string(), HashMap::new());
        let mut entity = inner_map
            .get("id")
            .expect("Couldn't get value from inner map.")
            .clone();
        entity.insert("field_name".to_string(), Value::String("val".to_string()));
        inner_map.insert("id".to_string(), entity);
        map.insert("entity".to_string(), inner_map);
        let mut test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        test_results.insert("testName".to_string(), true);
        drop(map);
        drop(test_results);

        context
            .assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr)
            .expect("Couldn't call assert_field_equals.");

        let test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        assert_eq!(test_results.len(), 1);
        assert_eq!(
            *test_results
                .get(test_results.keys().last().unwrap())
                .unwrap(),
            true
        );
    }

    #[test]
    #[serial]
    fn assert_field_equals_failing_variants() {
        let mut context = get_context();
        clear_pub_static_refs();
        let entity_string = asc_string_from_str("entity");
        let id_string = asc_string_from_str("id");
        let field_name_string = asc_string_from_str("field_name");
        let expected_val_string = asc_string_from_str("val");
        let entity_ptr =
            AscPtr::alloc_obj(entity_string, &mut context).expect("Couldn't create pointer.");
        let id_ptr = AscPtr::alloc_obj(id_string, &mut context).expect("Couldn't create pointer.");
        let field_name_ptr =
            AscPtr::alloc_obj(field_name_string, &mut context).expect("Couldn't create pointer.");
        let expected_val_ptr =
            AscPtr::alloc_obj(expected_val_string, &mut context).expect("Couldn't create pointer.");

        let mut test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        test_results.insert("testName".to_string(), true);
        drop(test_results);

        context
            .assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr)
            .expect("Couldn't call assert_field_equals.");

        assert_failed_test_and_clear();

        let mut map = STORE.lock().expect("Cannot access STORE.");
        map.insert("entity".to_string(), IndexMap::new());
        drop(map);

        context
            .assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr)
            .expect("Couldn't call assert_field_equals.");

        assert_failed_test_and_clear();

        let mut map = STORE.lock().expect("Cannot access STORE.");
        let mut inner_map = map.get("entity").expect("Couldn't get inner map.").clone();
        inner_map.insert("id".to_string(), HashMap::new());
        map.insert("entity".to_string(), inner_map);
        drop(map);

        context
            .assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr)
            .expect("Couldn't call assert_field_equals.");

        assert_failed_test_and_clear();

        let mut map = STORE.lock().expect("Cannot access STORE.");
        let mut inner_map = map.get("entity").expect("Couldn't get inner map.").clone();
        let mut entity = inner_map
            .get("id")
            .expect("Couldn't get value from inner map.")
            .clone();
        entity.insert("field_name".to_string(), Value::Null);
        inner_map.insert("id".to_string(), entity);
        map.insert("entity".to_string(), inner_map);
        drop(map);

        context
            .assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr)
            .expect("Couldn't call assert_field_equals.");

        let test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        assert_eq!(test_results.len(), 1);
        assert_eq!(
            *test_results
                .get(test_results.keys().last().unwrap())
                .unwrap(),
            false
        );
    }

    fn assert_failed_test_and_clear() {
        let mut test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        assert_eq!(test_results.len(), 1);
        assert_eq!(
            *test_results
                .get(test_results.keys().last().unwrap())
                .unwrap(),
            false
        );
        test_results.clear();
        test_results.insert("testName".to_string(), true);
        drop(test_results);
    }

    #[test]
    #[serial]
    fn assert_equals_basic_test() {
        let mut context = get_context();
        clear_pub_static_refs();
        let val = asc_string_from_str("val");
        let val_ptr = AscPtr::alloc_obj(val, &mut context).expect("Couldn't create pointer.");

        let asc_enum = AscEnum::<EthereumValueKind> {
            kind: EthereumValueKind::String,
            _padding: 0,
            payload: EnumPayload::from(val_ptr),
        };
        let pointer = AscPtr::alloc_obj(asc_enum, &mut context).expect("Couldn't create pointer.");

        context
            .assert_equals(pointer.wasm_ptr(), pointer.wasm_ptr())
            .expect("Couldn't call assert_equals.");
    }

    #[test]
    #[serial]
    fn assert_equals_inequality() {
        let mut context = get_context();
        clear_pub_static_refs();
        let mut test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        test_results.insert("test name".to_string(), true);
        drop(test_results);
        let val = asc_string_from_str("val");
        let val1 = asc_string_from_str("val1");

        let val_ptr = AscPtr::alloc_obj(val, &mut context).expect("Couldn't create pointer.");
        let val1_ptr = AscPtr::alloc_obj(val1, &mut context).expect("Couldn't create pointer.");

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

        let pointer = AscPtr::alloc_obj(asc_enum, &mut context).expect("Couldn't create pointer.");
        let pointer1 =
            AscPtr::alloc_obj(asc_enum1, &mut context).expect("Couldn't create pointer.");

        context
            .assert_equals(pointer.wasm_ptr(), pointer1.wasm_ptr())
            .expect("Couldn't call assert_equals.");

        let test_results = TEST_RESULTS.lock().expect("Couldn't get TEST_RESULTS.");
        assert_eq!(test_results.len(), 1);
        assert_eq!(*test_results.get("test name").unwrap(), false);
    }

    #[test]
    #[serial]
    fn assert_not_in_store_basic_test() {
        let mut context = get_context();
        clear_pub_static_refs();

        let mut test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        test_results.insert("test name".to_string(), true);
        drop(test_results);

        let entity_type = asc_string_from_str("entity_type");
        let id = asc_string_from_str("id");

        let entity_type_ptr =
            AscPtr::alloc_obj(entity_type, &mut context).expect("Couldn't create pointer.");
        let id_ptr = AscPtr::alloc_obj(id, &mut context).expect("Couldn't create pointer.");

        context
            .assert_not_in_store(entity_type_ptr, id_ptr)
            .expect("Couldn't call assert_not_in_store.");

        let test_results = TEST_RESULTS.lock().expect("Couldn't get TEST_RESULTS.");
        assert_eq!(test_results.len(), 1);
        assert_eq!(*test_results.get("test name").unwrap(), true);
    }

    #[test]
    #[serial]
    fn assert_not_in_store_when_in_store() {
        let mut context = get_context();
        clear_pub_static_refs();

        let mut test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        test_results.insert("test name".to_string(), true);
        drop(test_results);
        let mut map = STORE.lock().expect("Cannot access STORE.");
        map.insert("entity_type".to_string(), IndexMap::new());
        let mut inner_map = map
            .get("entity_type")
            .expect("Couldn't get inner map.")
            .clone();
        inner_map.insert("id".to_string(), HashMap::new());
        map.insert("entity_type".to_string(), inner_map);
        drop(map);

        let entity_type = asc_string_from_str("entity_type");
        let id = asc_string_from_str("id");

        let entity_type_ptr =
            AscPtr::alloc_obj(entity_type, &mut context).expect("Couldn't create pointer.");
        let id_ptr = AscPtr::alloc_obj(id, &mut context).expect("Couldn't create pointer.");

        context
            .assert_not_in_store(entity_type_ptr, id_ptr)
            .expect("Couldn't call assert_not_in_store.");

        let test_results = TEST_RESULTS.lock().expect("Couldn't get TEST_RESULTS.");
        assert_eq!(test_results.len(), 1);
        assert_eq!(*test_results.get("test name").unwrap(), false);
    }

    #[test]
    #[serial]
    fn mock_store_get_basic_test() {
        let mut context = get_context();
        clear_pub_static_refs();

        let mut map = STORE.lock().expect("Cannot access STORE.");
        map.insert("entity".to_string(), IndexMap::new());
        let mut inner_map = map.get("entity").expect("Couldn't get inner map.").clone();
        inner_map.insert("id".to_string(), HashMap::new());
        let mut entity = inner_map
            .get("id")
            .expect("Couldn't get value from inner map.")
            .clone();
        entity.insert("field_name".to_string(), Value::String("val".to_string()));
        inner_map.insert("id".to_string(), entity);
        map.insert("entity".to_string(), inner_map);
        drop(map);

        let entity = asc_string_from_str("entity");
        let id = asc_string_from_str("id");
        let entity_pointer =
            AscPtr::alloc_obj(entity, &mut context).expect("Couldn't create pointer.");
        let id_pointer = AscPtr::alloc_obj(id, &mut context).expect("Couldn't create pointer.");

        let value = context
            .mock_store_get(entity_pointer, id_pointer)
            .expect("Couldn't call mock_store_get.");

        assert_eq!(
            value.read_ptr(&context).unwrap().content_len(
                &value
                    .read_ptr(&context)
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
        clear_pub_static_refs();

        let entity = asc_string_from_str("entity");
        let id = asc_string_from_str("id");
        let entity_pointer =
            AscPtr::alloc_obj(entity, &mut context).expect("Couldn't create pointer.");
        let id_pointer = AscPtr::alloc_obj(id, &mut context).expect("Couldn't create pointer.");

        let value = context
            .mock_store_get(entity_pointer, id_pointer)
            .expect("Couldn't call mock_store_get.");

        assert!(value.is_null());
    }

    // #[test]
    // #[serial]
    // fn mock_store_set_basic_test() {
    //     let mut context = get_context();
    //     clear_pub_static_refs();

    //     let entity = asc_string_from_str("entity");
    //     let id = asc_string_from_str("id");
    //     let key = asc_string_from_str("key");
    //     let data = asc_string_from_str("data");
    //     let entity_pointer = AscPtr::alloc_obj(entity, &mut context).expect("Couldn't create pointer.");
    //     let id_pointer = AscPtr::alloc_obj(id, &mut context).expect("Couldn't create pointer.");
    //     let key_pointer = AscPtr::alloc_obj(key, &mut context).expect("Couldn't create pointer.");
    //     let data_pointer = AscPtr::alloc_obj(data, &mut context).expect("Couldn't create pointer.");
    //     let payload = AscEnum::<StoreValueKind> {
    //         kind: StoreValueKind::String,
    //         _padding: 0,
    //         payload: EnumPayload::from(data_pointer)
    //     };
    //     let payload_pointer = AscPtr::alloc_obj(payload, &mut context).expect("Couldn't create pointer.");
    //     let map_entry = AscTypedMapEntry {
    //         key: key_pointer,
    //         value: payload_pointer
    //     };
    //     let map_entry_pointer = AscPtr::alloc_obj(map_entry, &mut context).expect("Couldn't create pointer.");
    //     let asc_map = AscTypedMap {
    //         entries: AscPtr::alloc_obj(Array::new(&[map_entry_pointer], &mut context).expect("Couldn't create Array."), &mut context).expect("Couldn't create pointer.")
    //     };
    //     let asc_map_pointer = AscPtr::alloc_obj(asc_map, &mut context).expect("Couldn't create pointer.");

    //     context.mock_store_set(entity_pointer, id_pointer, asc_map_pointer).expect("Couldn't call mock_store_get.");
    // }

    #[test]
    #[serial]
    fn mock_store_remove_basic_test() {
        let mut context = get_context();
        clear_pub_static_refs();

        let mut store = STORE.lock().expect("Couldn't get STORE.");
        store.insert("entity".to_string(), IndexMap::new());
        let mut inner_map = store
            .get("entity")
            .expect("Couldn't get inner map.")
            .clone();
        inner_map.insert("id".to_string(), HashMap::new());
        store.insert("entity".to_string(), inner_map);
        drop(store);

        let entity = asc_string_from_str("entity");
        let id = asc_string_from_str("id");
        let entity_pointer =
            AscPtr::alloc_obj(entity, &mut context).expect("Couldn't create pointer.");
        let id_pointer = AscPtr::alloc_obj(id, &mut context).expect("Couldn't create pointer.");

        context
            .mock_store_remove(entity_pointer, id_pointer)
            .expect("Couldn't call mock_store_remove.");

        let store = STORE.lock().expect("Couldn't get STORE.");
        assert!(!store.get("entity").unwrap().contains_key("id"));
    }

    #[test]
    #[serial]
    fn mock_store_remove_not_successful() {
        let mut context = get_context();
        clear_pub_static_refs();

        let mut test_results = TEST_RESULTS.lock().expect("Couldn't get TEST_RESULTS.");
        test_results.insert("test name".to_string(), true);
        drop(test_results);

        let entity = asc_string_from_str("entity");
        let id = asc_string_from_str("id");
        let entity_pointer =
            AscPtr::alloc_obj(entity, &mut context).expect("Couldn't create pointer.");
        let id_pointer = AscPtr::alloc_obj(id, &mut context).expect("Couldn't create pointer.");

        context
            .mock_store_remove(entity_pointer, id_pointer)
            .expect("Couldn't call mock_store_remove.");

        let test_results = TEST_RESULTS.lock().expect("Couldn't get TEST_RESULTS.");
        assert_eq!(test_results.len(), 1);
        assert_eq!(*test_results.get("test name").unwrap(), false);
    }

    // #[test]
    // #[serial]
    // fn ethereum_call_basic_test() {
    //     let mut context = get_context();
    //     clear_pub_static_refs();

    //     // let contract_name = asc_string_from_str("contractName");
    //     // let address = TypedArray::<u8>::from_asc_bytes("0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7".as_bytes(), get_version()).expect("Coudln't create address.");
    //     // let func_name = asc_string_from_str("funcName");
    //     // let func_signature = asc_string_from_str("funcName(address):(string,string)");
    //     // let val = asc_string_from_str("val");

    //     // let contract_name_pointer = AscPtr::alloc_obj(contract_name, &mut context).expect("Couldn't create pointer.");
    //     // let address_pointer = AscPtr::alloc_obj(address, &mut context).expect("Couldn't create pointer.");
    //     // let func_name_pointer = AscPtr::alloc_obj(func_name, &mut context).expect("Couldn't create pointer.");
    //     // let func_signature_pointer = AscPtr::alloc_obj(func_signature, &mut context).expect("Couldn't create pointer.");
    //     // let val_ptr = AscPtr::alloc_obj(val, &mut context).expect("Couldn't create pointer.");

    //     // let asc_enum = AscEnum::<EthereumValueKind> {
    //     //     kind: EthereumValueKind::String,
    //     //     _padding: 0,
    //     //     payload: EnumPayload::from(val_ptr)
    //     // };
    //     // let func_args_pointer = AscPtr::alloc_obj(asc_enum, &mut context).expect("Couldn't create pointer.");
    //     // let func_args_array_pointer = AscPtr::alloc_obj(Array::new(&[func_args_pointer], &mut context).expect("Couldn't create array."), &mut context).expect("Couldn't create pointer.");

    //     // let unresolved_call = AscUnresolvedContractCall_0_0_4 {
    //     //     contract_name: contract_name_pointer,
    //     //     contract_address: address_pointer,
    //     //     function_name: func_name_pointer,
    //     //     function_signature: func_signature_pointer,
    //     //     function_args: func_args_array_pointer
    //     // };

    // // pub contract_name: String,
    // // pub contract_address: Address,
    // // pub function_name: String,
    // // pub function_signature: Option<String>,
    // // pub function_args: Vec<ethabi::Token>,
    //     let test = Test {
    //         call: UnresolvedContractCall {
    //             contract_name: "contractName".to_string(),
    //             // contract_address: H160(["0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7".as_bytes()[0]; 20]),
    //             contract_address: H160("0x892123451234512345".as_bytes().try_into().expect("tyy")),
    //             function_name: "funcName".to_string(),
    //             function_signature: Some("funcName(address):(string,string)".to_string()),
    //             function_args: vec!()
    //         }
    //     };
    //     // let call_pointer = AscPtr::alloc_obj(unresolved_call, &mut context).expect("Couldn't create pointer.");
    //     let call_pointer = asc_new(&mut context, &test).expect("Couldn't create pointer.");

    //     let call: UnresolvedContractCall =
    //         asc_get::<_, AscUnresolvedContractCall_0_0_4, _>(&context, call_pointer).unwrap();
    //     panic!("{:?}", call);

    //     context.ethereum_call(call_pointer.wasm_ptr()).expect("Couldn't call ethereum_call.");

    //     // let test_results = TEST_RESULTS.lock().expect("Couldn't get TEST_RESULTS.");
    //     // assert_eq!(test_results.len(), 1);
    //     // assert_eq!(*test_results.get("test name").unwrap(), false);
    // }

    // struct Test {
    //     call: UnresolvedContractCall
    // }

    // impl ToAscObj<AscUnresolvedContractCall_0_0_4> for Test {
    //     fn to_asc_obj<H: AscHeap + ?Sized>(
    //         &self,
    //         heap: &mut H,
    //     ) -> Result<AscUnresolvedContractCall_0_0_4, DeterministicHostError> {
    //         let contract_name = asc_string_from_str(&self.call.function_name);
    //         let address = TypedArray::<u8>::from_asc_bytes(self.call.contract_address.as_bytes(), get_version()).expect("Coudln't create address.");
    //         let func_name = asc_string_from_str(&self.call.function_name);
    //         let func_signature = asc_string_from_str(&self.call.function_signature.as_ref().expect("Couldn't get func signature."));
    //         let val = asc_string_from_str("val");

    //         let contract_name_pointer = AscPtr::alloc_obj(contract_name, heap).expect("Couldn't create pointer.");
    //         let address_pointer = AscPtr::alloc_obj(address, heap).expect("Couldn't create pointer.");
    //         let func_name_pointer = AscPtr::alloc_obj(func_name, heap).expect("Couldn't create pointer.");
    //         let func_signature_pointer = AscPtr::alloc_obj(func_signature, heap).expect("Couldn't create pointer.");
    //         let val_pointer = AscPtr::alloc_obj(val, heap).expect("Couldn't create pointer.");

    //         let asc_enum = AscEnum::<EthereumValueKind> {
    //             kind: EthereumValueKind::String,
    //             _padding: 0,
    //             payload: EnumPayload::from(val_pointer)
    //         };
    //         let func_args_pointer = AscPtr::alloc_obj(asc_enum, heap).expect("Couldn't create pointer.");
    //         let func_args_array_pointer = AscPtr::alloc_obj(Array::new(&[func_args_pointer], heap).expect("Couldn't create array."), heap).expect("Couldn't create pointer.");

    //         Ok(AscUnresolvedContractCall_0_0_4 {
    //             contract_name: contract_name_pointer,
    //             contract_address: address_pointer,
    //             function_name: func_name_pointer,
    //             function_signature: func_signature_pointer,
    //             function_args: func_args_array_pointer,
    //         })
    //     }
    // }

    // #[test]
    // #[serial]
    // fn mock_function_basic_test() {
    //     let mut context = get_context();
    //     clear_pub_static_refs();

    //     let address_test = address_generator("0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7".as_bytes(), &mut context).expect("Couldn't generate address.");
    //     // let address_test_ptr = AscPtr::alloc_obj(address_test, &mut context).expect("Couldn't create pointer.");
    //     // let address = TypedArray::<u8>::from_asc_bytes(&address_test.to_asc_bytes().unwrap(), get_version()).expect("Coudln't create address.");
    //     // let address = Token::Address;
    //     let func_name = asc_string_from_str("funcName");
    //     let func_signature = asc_string_from_str("funcName(address):(string,string)");
    //     let val = asc_string_from_str("val");

    //     let address_pointer = AscPtr::alloc_obj(TypedArrayWrapper { typed_array: address_test }, &mut context).expect("Couldn't create pointer.");
    //     let func_name_pointer = AscPtr::alloc_obj(func_name, &mut context).expect("Couldn't create pointer.");
    //     let func_signature_pointer = AscPtr::alloc_obj(func_signature, &mut context).expect("Couldn't create pointer.");
    //     let val_pointer = AscPtr::alloc_obj(val, &mut context).expect("Couldn't create pointer.");

    //     let asc_enum = AscEnum::<EthereumValueKind> {
    //         kind: EthereumValueKind::String,
    //         _padding: 0,
    //         payload: EnumPayload::from(val_pointer)
    //     };
    //     let func_args_pointer = AscPtr::alloc_obj(asc_enum, &mut context).expect("Couldn't create pointer.");
    //     let func_args_array_pointer = AscPtr::alloc_obj(Array::new(&[func_args_pointer], &mut context).expect("Couldn't create array."), &mut context).expect("Couldn't create pointer.");

    //     let fn_name: String = asc_get(&mut context, func_name_pointer).expect("ASdf2");
    //     let fn_signature: String = asc_get(&mut context, func_signature_pointer).expect("ASdf3");
    //     let fn_args: Vec<Token> =
    //         asc_get::<_, Array<AscPtr<AscEnum<EthereumValueKind>>>, _>(&mut context, func_args_array_pointer).expect("ASdf4");
    //     let return_value: Vec<Token> = asc_get::<_, Array<AscPtr<AscEnum<EthereumValueKind>>>, _>(
    //         &mut context,
    //         func_args_array_pointer,
    //     ).expect("ASdf5");
    //     let contract_address: Address = asc_get(&mut context, address_pointer).expect("ASdf1");

    //     panic!("{:?}{:?}{:?}{:?}{:?}", contract_address, fn_name, fn_signature, fn_args, return_value);

    //     context.mock_function(address_pointer.wasm_ptr(), func_name_pointer, func_signature_pointer, func_args_array_pointer.wasm_ptr(), func_args_array_pointer.wasm_ptr(), 0).expect("Couldn't call mock_function.");

    //     let mut map = FUNCTIONS_MAP.lock().expect("Couldn't get FUNCTIONS_MAP.");
    //     let token = map.get("0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7funcNamefuncName(address):(string,string)val").unwrap()[0].clone();
    //     assert_eq!(&token.to_string().unwrap(), "val");
    // }
}
