#[cfg(test)]
mod integration_tests {
    // use crate::module_from_path;
    // use crate::wasm_instance::{clear_test_results, get_failed_tests};
    // use serial_test::serial;

    // #[test]
    // #[serial]
    // fn assert_field_equals_fails_non_existent_id() {
    //     let module =
    //         module_from_path("mocks/wasm/01_assert_field_equals_fail_non_existent_id.wasm");
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 1);
    //     clear_test_results();
    // }

    // #[test]
    // #[serial]
    // fn assert_field_equals_fails_no_such_field_name() {
    //     let module =
    //         module_from_path("mocks/wasm/02_assert_field_equals_fail_no_such_field_name.wasm");
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 1);
    //     clear_test_results();
    // }

    // #[test]
    // #[serial]
    // fn assert_field_equals_fails_field_not_equal_to_expected() {
    //     let module = module_from_path(
    //         "mocks/wasm/03_assert_field_equals_fail_field_not_equal_to_expected.wasm",
    //     );
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 1);
    //     clear_test_results();
    // }

    // #[test]
    // #[serial]
    // fn can_add_get_assert_and_remove_from_store() {
    //     let module =
    //         module_from_path("mocks/wasm/04_can_add_get_assert_and_remove_from_store.wasm");
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 0);
    //     clear_test_results();
    // }

    // #[test]
    // #[ignore]
    // #[serial]
    // fn can_mock_and_call_ethereum_function() {
    //     let module = module_from_path("mocks/wasm/05_can_mock_and_call_ethereum_function.wasm");
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 0);
    //     clear_test_results();
    // }

    // #[test]
    // #[serial]
    // #[ignore]
    // fn mocked_function_reverts() {
    //     let module = module_from_path("mocks/wasm/06_mocked_function_reverts.wasm");
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 0);
    //     clear_test_results();
    // }

    // #[test]
    // #[ignore]
    // fn mock_gravity_function() {
    //     let module = module_from_path("mocks/wasm/07_can_mock_gravity_function_correctly.wasm");
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 0);
    //     clear_test_results();
    // }

    // #[test]
    // #[serial]
    // fn init_store_with_entity_array() {
    //     let module = module_from_path("mocks/wasm/08_can_init_store_with_entity_array.wasm");
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 0);
    //     clear_test_results();
    // }

    // #[test]
    // #[serial]
    // fn call_mappings_with_custom_events() {
    //     let module = module_from_path("mocks/wasm/09_can_call_mappings_with_custom_events.wasm");
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 0);
    //     clear_test_results();
    // }

    // #[test]
    // #[serial]
    // fn entity_load() {
    //     let module = module_from_path("mocks/wasm/10_entity_load.wasm");
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 0);
    //     clear_test_results();
    // }

    // #[test]
    // #[serial]
    // fn return_null_when_calling_entity_load_and_entity_missing() {
    //     let module = module_from_path(
    //         "mocks/wasm/11_returns_null_when_calling_entity_load_and_entity_missing.wasm",
    //     );
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 0);
    //     clear_test_results();
    // }

    // #[test]
    // #[serial]
    // fn update_entity_with_save_function() {
    //     let module = module_from_path("mocks/wasm/12_update_entity_with_save_function.wasm");
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 0);
    //     clear_test_results();
    // }

    // #[test]
    // #[serial]
    // fn init_event_metadata() {
    //     let module = module_from_path("mocks/wasm/13_initialise_event_metadata.wasm");
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 0);
    //     clear_test_results();
    // }

    // #[test]
    // #[serial]
    // fn update_event_metadata() {
    //     let module = module_from_path("mocks/wasm/14_update_event_metadata.wasm");
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 0);
    //     clear_test_results();
    // }

    // #[test]
    // #[serial]
    // #[ignore]
    // fn save_gravatar_from_contract() {
    //     let module = module_from_path("mocks/wasm/15_save_gravatar_from_contract.wasm");
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 0);
    //     clear_test_results();
    // }

    // #[test]
    // #[serial]
    // #[should_panic(expected = "❌ ❌ ❌  Test with name 'duplicate key' already exists.")]
    // fn duplicate_test_name() {
    //     let module = module_from_path("mocks/wasm/16_duplicate_test_name.wasm");
    //     let run_tests = module.instance.get_func("runTests").unwrap();

    //     run_tests.call(&[]).unwrap();
    //     clear_test_results();
    // }

    // #[test]
    // #[serial]
    // fn store_remove_fails_when_no_entity_found() {
    //     let module = module_from_path("mocks/wasm/17_store_remove_fails_when_no_entity_found.wasm");
    //     let run_tests = module.instance.get_func("runTests").unwrap();
    //     run_tests.call(&[]).unwrap();

    //     let failed_tests = get_failed_tests();
    //     assert_eq!(failed_tests, 1);
    //     clear_test_results();
    // }
}
