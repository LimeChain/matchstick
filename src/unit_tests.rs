#[cfg(test)]
mod unit_tests {
    use crate::module_from_path;
    use indexmap::IndexMap;
    use crate::wasm_instance::{STORE, WICExtension, TEST_RESULTS, LOGS, clear_pub_static_refs, POINTERS_MAP};
    use graph_runtime_wasm::module::WasmInstanceContext;
    use graph_runtime_wasm::asc_abi::class::AscString;
    use graph_chain_ethereum::Chain;
    use graph::runtime::AscPtr;
    use graph::semver::{Version, BuildMetadata, Prerelease};
    use std::collections::HashMap;
    use graph::data::store::Value;
    use serial_test::serial;
    use graph::runtime::AscType;
    use graph_runtime_wasm::asc_abi::class::{Array, AscEntity, AscEnum};
    use graph_runtime_wasm::asc_abi::class::{AscEnumArray, EthereumValueKind};
    use ethabi::{Address, Token};
    use graph::runtime::{asc_get};

    fn get_context() -> WasmInstanceContext<Chain> {
        let module = module_from_path("mocks/wasm/Unit-test.wasm");
        if POINTERS_MAP.lock().expect("Couldn't get POINTERS_MAP.").is_empty() {
            let create_pointers = module.instance.get_func("createPointers").unwrap();
            create_pointers.call(&[]).unwrap();
        }
        let context = module.instance_ctx.take().take().expect("Couldn't get context from module.");
        return context;
    }

    fn asc_string_from_str(initial_string: &str) -> AscString {
        let utf_16_iterator = initial_string.encode_utf16();
        let mut u16_vector = vec!();
        utf_16_iterator.for_each(|element| u16_vector.push(element));
        let version = Version{
            major: 0,
            minor: 0,
            patch: 4,
            build: BuildMetadata::EMPTY,
            pre: Prerelease::new("").expect("Couldn't create new Prerelease.")
        };
        return AscString::new(&u16_vector, version.clone()).expect("Couldn't create AscString.");
    }

    #[test]
    #[serial]
    fn log_basic_test() {
        let mut context = get_context();
        clear_pub_static_refs();
        let message = asc_string_from_str("log message");
        let pointer = AscPtr::alloc_obj(message, &mut context).expect("Couldn't create pointer.");

        context.log(3, pointer).expect("Couldn't call log function.");

        let logs = LOGS.lock().expect("Cannot access LOGS.");
        assert_eq!(logs.len(), 1);
        assert!(logs.contains_key("log message"));
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

        context.log(1, pointer).expect("Couldn't call log function.");

        let logs = LOGS.lock().expect("Cannot get LOGS.");
        let test_results = TEST_RESULTS.lock().expect("Couldn't get TEST_RESULTS.");
        assert_eq!(logs.len(), 1);
        assert!(logs.contains_key("log message"));
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

        context.log(0, pointer).expect("Couldn't call log function.");
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

        context.register_test(pointer.expect("Couldn't unwrap pointer.")).expect("Couldn't call register_test.");

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

        context.register_test(pointer.expect("Couldn't unwrap pointer.")).expect("Couldn't call register_test.");
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
        let entity_ptr = AscPtr::alloc_obj(entity_string, &mut context).expect("Couldn't create pointer.");
        let id_ptr = AscPtr::alloc_obj(id_string, &mut context).expect("Couldn't create pointer.");
        let field_name_ptr = AscPtr::alloc_obj(field_name_string, &mut context).expect("Couldn't create pointer.");
        let expected_val_ptr = AscPtr::alloc_obj(expected_val_string, &mut context).expect("Couldn't create pointer.");

        let mut map = STORE.lock().expect("Cannot access STORE.");
        map.insert("entity".to_string(), IndexMap::new());
        let mut inner_map = map.get("entity").expect("Couldn't get inner map.").clone();
        inner_map.insert("id".to_string(), HashMap::new());
        let mut entity = inner_map.get("id").expect("Couldn't get value from inner map.").clone();
        entity.insert("field_name".to_string(), Value::String("val".to_string()));
        inner_map.insert("id".to_string(), entity);
        map.insert("entity".to_string(), inner_map);
        let mut test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        test_results.insert("testName".to_string(), true);
        drop(map);
        drop(test_results);

        context.assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr).expect("Couldn't call assert_field_equals function.");

        let test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        assert_eq!(test_results.len(), 1);
        assert_eq!(*test_results.get(test_results.keys().last().unwrap()).unwrap(), true);
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
        let entity_ptr = AscPtr::alloc_obj(entity_string, &mut context).expect("Couldn't create pointer.");
        let id_ptr = AscPtr::alloc_obj(id_string, &mut context).expect("Couldn't create pointer.");
        let field_name_ptr = AscPtr::alloc_obj(field_name_string, &mut context).expect("Couldn't create pointer.");
        let expected_val_ptr = AscPtr::alloc_obj(expected_val_string, &mut context).expect("Couldn't create pointer.");

        let mut test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        test_results.clear();
        test_results.insert("testName".to_string(), true);
        drop(test_results);

        context.assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr).expect("Couldn't call assert_field_equals function.");

        assert_failed_test_and_clear();
        
        let mut map = STORE.lock().expect("Cannot access STORE.");
        map.insert("entity".to_string(), IndexMap::new());
        drop(map);

        context.assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr).expect("Couldn't call assert_field_equals function.");

        assert_failed_test_and_clear();

        let mut map = STORE.lock().expect("Cannot access STORE.");
        let mut inner_map = map.get("entity").expect("Couldn't get inner map.").clone();
        inner_map.insert("id".to_string(), HashMap::new());
        map.insert("entity".to_string(), inner_map);
        drop(map);

        context.assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr).expect("Couldn't call assert_field_equals function.");

        assert_failed_test_and_clear();

        let mut map = STORE.lock().expect("Cannot access STORE.");
        let mut inner_map = map.get("entity").expect("Couldn't get inner map.").clone();
        let mut entity = inner_map.get("id").expect("Couldn't get value from inner map.").clone();
        entity.insert("field_name".to_string(), Value::Null);
        inner_map.insert("id".to_string(), entity);
        map.insert("entity".to_string(), inner_map);
        drop(map);

        context.assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr).expect("Couldn't call assert_field_equals function.");

        let test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        assert_eq!(test_results.len(), 1);
        assert_eq!(*test_results.get(test_results.keys().last().unwrap()).unwrap(), false);
    }

    fn assert_failed_test_and_clear() {
        let mut test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        assert_eq!(test_results.len(), 1);
        assert_eq!(*test_results.get(test_results.keys().last().unwrap()).unwrap(), false);
        test_results.clear();
        test_results.insert("testName".to_string(), true);
        drop(test_results);
    }

    #[test]
    #[serial]
    fn assert_equals_basic_test() {
        let mut context = get_context();
        clear_pub_static_refs();
        let pointers_map = POINTERS_MAP.lock().expect("Couldn't get POINTERS_MAP.");
        let pointer = pointers_map.get("firstString").unwrap();
        // let pointer = *pointer_ref;
        // let expected: Token = asc_get::<_, AscEnum<EthereumValueKind>, _>(&context, pointer.into()).unwrap();
        // panic!("{:?}", expected);
        // let second_pointer = asc_new(&mut context, "value").expect("Couldn't create pointer");
        // panic!("{:?}", asc_get::<Token, AscEnum<EthereumValueKind>, _>(&context, EnumPayload::from(first_pointer).into()));

        context.assert_equals(pointer.wasm_ptr(), pointer.wasm_ptr()).expect("Couldn't call assert_equals function.");
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
        let mut entity = inner_map.get("id").expect("Couldn't get value from inner map.").clone();
        entity.insert("field_name".to_string(), Value::String("val".to_string()));
        inner_map.insert("id".to_string(), entity);
        map.insert("entity".to_string(), inner_map);
        drop(map);
        
        let entity = asc_string_from_str("entity");
        let id = asc_string_from_str("id");
        let entity_pointer = AscPtr::alloc_obj(entity, &mut context).expect("Couldn't create pointer.");
        let id_pointer = AscPtr::alloc_obj(id, &mut context).expect("Couldn't create pointer.");

        let value = context.mock_store_get(entity_pointer, id_pointer).expect("Couldn't call mock_store_get result.");

        assert_eq!(value.read_ptr(&context).unwrap().content_len(&value.read_ptr(&context).unwrap().to_asc_bytes().expect("Couldn't get entity bytes.")), 4);
    }

    #[test]
    #[serial]
    fn mock_store_get_no_such_entity() {
        let mut context = get_context();
        clear_pub_static_refs();
        
        let entity = asc_string_from_str("entity");
        let id = asc_string_from_str("id");
        let entity_pointer = AscPtr::alloc_obj(entity, &mut context).expect("Couldn't create pointer.");
        let id_pointer = AscPtr::alloc_obj(id, &mut context).expect("Couldn't create pointer.");

        let value = context.mock_store_get(entity_pointer, id_pointer).expect("Couldn't call mock_store_get result.");

        assert!(value.is_null());
    }

    //graph_runtime_wasm::asc_abi::class::AscTypedMap.entries NEEDS TO BE MADE PUBLIC FOR MEANINGFUL/POSSIBLE UNIT TESTS

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

    //     context.mock_store_set(entity_pointer, id_pointer, asc_map_pointer).expect("Couldn't call mock_store_get result.");
    // }

    #[test]
    #[serial]
    fn mock_store_remove_basic_test() {
        let mut context = get_context();
        clear_pub_static_refs();
        
        let mut store = STORE.lock().expect("Couldn't get STORE.");
        store.insert("entity".to_string(), IndexMap::new());
        let mut inner_map = store.get("entity").expect("Couldn't get inner map.").clone();
        inner_map.insert("id".to_string(), HashMap::new());
        store.insert("entity".to_string(), inner_map);
        drop(store);

        let entity = asc_string_from_str("entity");
        let id = asc_string_from_str("id");
        let entity_pointer = AscPtr::alloc_obj(entity, &mut context).expect("Couldn't create pointer.");
        let id_pointer = AscPtr::alloc_obj(id, &mut context).expect("Couldn't create pointer.");

        context.mock_store_remove(entity_pointer, id_pointer).expect("Couldn't call mock_store_remove result.");

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
        let entity_pointer = AscPtr::alloc_obj(entity, &mut context).expect("Couldn't create pointer.");
        let id_pointer = AscPtr::alloc_obj(id, &mut context).expect("Couldn't create pointer.");

        context.mock_store_remove(entity_pointer, id_pointer).expect("Couldn't call mock_store_remove result.");

        let test_results = TEST_RESULTS.lock().expect("Couldn't get TEST_RESULTS.");
        assert_eq!(test_results.len(), 1);
        assert_eq!(*test_results.get("test name").unwrap(), false);
    }
}