#[cfg(test)]
mod integration_tests {
    use serial_test::serial;
    use graph_chain_ethereum::Chain;

    use crate::MatchstickInstance;
    use crate::test_suite::TestSuite;

    #[test]
    #[serial]
    fn run_all_gravity_demo_subgraph_tests() {
        let module = <MatchstickInstance<Chain>>::new("mocks/wasm/gravity.wasm");
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
