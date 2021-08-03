#[cfg(test)]
mod integration_tests {
    use crate::module_from_path;
    use crate::wasm_instance::{get_failed_tests, clear_test_results};

    #[test]
    fn assert_field_equals_fails_non_existent_id() {
        let module = module_from_path("mocks/wasm/01_assert_field_equals_fail_non_existent_id.wasm");
        let run_tests = module.instance.get_func("runTests").unwrap();
        run_tests.call(&[]).unwrap();

        let failed_tests = get_failed_tests();
        assert_eq!(failed_tests, 1);
        clear_test_results();
    }

    #[test]
    fn assert_field_equals_fails_no_such_field_name() {
        let module = module_from_path("mocks/wasm/02_assert_field_equals_fail_no_such_field_name.wasm");
        let run_tests = module.instance.get_func("runTests").unwrap();
        run_tests.call(&[]).unwrap();

        let failed_tests = get_failed_tests();
        assert_eq!(failed_tests, 1);
        clear_test_results();
    }

    #[test]
    fn assert_field_equals_fails_field_not_equal_to_expected() {
        let module = module_from_path("mocks/wasm/03_assert_field_equals_fail_field_not_equal_to_expected.wasm");
        let run_tests = module.instance.get_func("runTests").unwrap();
        run_tests.call(&[]).unwrap();

        let failed_tests = get_failed_tests();
        assert_eq!(failed_tests, 1);
        clear_test_results();
    }
}
