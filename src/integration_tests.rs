#[cfg(test)]
mod integration_tests {
    use graph_chain_ethereum::Chain;
    use serial_test::serial;

    use crate::test_suite::TestSuite;
    use crate::{MatchstickInstance, SCHEMA_LOCATION};

    #[test]
    #[serial]
    fn run_all_gravity_demo_subgraph_tests() {
        SCHEMA_LOCATION.with(|path| *path.borrow_mut() = "./mocks/schema.graphql".to_string());
        let module = <MatchstickInstance<Chain>>::new("mocks/wasm/Gravity.wasm");
        let test_suite = TestSuite::from(&module);

        let mut failed_tests = 0;
        for test in &test_suite.tests {
            if !test.run(false).passed {
                failed_tests += 1;
            }
        }

        assert_eq!(failed_tests, 0);
    }
}
