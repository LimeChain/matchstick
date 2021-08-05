#[cfg(test)]
mod unit_tests {
    use crate::module_from_path;
    use indexmap::IndexMap;
    use crate::wasm_instance::{STORE, WICExtension, TEST_RESULTS};
    use graph_runtime_wasm::module::WasmInstanceContext;
    use graph_runtime_wasm::asc_abi::class::AscString;
    use graph_chain_ethereum::Chain;
    use graph::runtime::AscPtr;
    use graph::semver::{Version, BuildMetadata, Prerelease};
    use std::collections::HashMap;
    use graph::data::store::Value;

    fn get_context() -> WasmInstanceContext<Chain> {
        let module = module_from_path("mocks/Gravity.wasm");
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
    fn clear_store_basic_test() {
        let mut context = get_context();
        let mut store = STORE.lock().expect("Couldn't get store.");
        store.insert("type".to_string(), IndexMap::new());

        assert_eq!(store.len(), 1);

        drop(store);

        context.clear_store().expect("Couldn't clear store");
        let store = STORE.lock().expect("Couldn't get store.");
        assert_eq!(store.len(), 0);
    }

    #[test]
    fn register_test_basic_test() {
        let mut context = get_context();

        let mut test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        test_results.clear();
        drop(test_results);
        
        let initial_asc_string = asc_string_from_str("test");
        let pointer = AscPtr::alloc_obj(initial_asc_string, &mut context);
        context.register_test(pointer.expect("Couldn't unwrap pointer.")).expect("Couldn't unwrap register_test result.");

        let mut test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        assert_eq!(test_results.len(), 1);
        test_results.clear();
    }

    #[test]
    #[should_panic(expected = "Test with name 'duplicate test' already exists.")]
    fn register_test_duplicate_should_panic() {
        let mut context = get_context();
        let mut test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        test_results.insert("duplicate test".to_string(), true);
        drop(test_results);
        
        let initial_asc_string = asc_string_from_str("duplicate test");
        let pointer = AscPtr::alloc_obj(initial_asc_string, &mut context);
        context.register_test(pointer.expect("Couldn't unwrap pointer.")).expect("Couldn't unwrap register_test result.");
    }

    #[test]
    fn assert_field_equals_failing_variants() {
        let mut context = get_context();
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

        let mut test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        assert_eq!(test_results.len(), 1);
        assert_eq!(*test_results.get(test_results.keys().last().unwrap()).unwrap(), false);
        test_results.clear();
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
    fn assert_field_equals_basic_test() {
        let mut context = get_context();
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
        test_results.clear();
        test_results.insert("testName".to_string(), true);
        drop(map);
        drop(test_results);

        context.assert_field_equals(entity_ptr, id_ptr, field_name_ptr, expected_val_ptr).expect("Couldn't call assert_field_equals function.");

        let mut test_results = TEST_RESULTS.lock().expect("Cannot get TEST_RESULTS.");
        assert_eq!(test_results.len(), 1);
        assert_eq!(*test_results.get(test_results.keys().last().unwrap()).unwrap(), true);
        test_results.clear();
    }
}