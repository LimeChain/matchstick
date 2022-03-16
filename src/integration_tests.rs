#[cfg(test)]
mod integration_tests {
    use graph_chain_ethereum::Chain;
    use serial_test::serial;
    use std::path::PathBuf;

    use crate::test_suite::TestSuite;
    use crate::{MatchstickInstance, SCHEMA_LOCATION};

    #[test]
    #[serial]
    fn run_all_gravity_demo_subgraph_tests() {
        SCHEMA_LOCATION.with(|path| *path.borrow_mut() = PathBuf::from("./mocks/schema.graphql"));
        let module = <MatchstickInstance<Chain>>::new("mocks/wasm/gravity.wasm");
        let test_suite = TestSuite::from(&module);

        let mut failed_tests = 0;

        for group in &test_suite.groups {
            for test in &group.tests {
                if !test.run().passed {
                    failed_tests += 1;
                }
            }
        }

        assert_eq!(failed_tests, 0);
    }

    #[test]
    #[serial]
    fn run_all_token_lock_wallet_demo_subgraph_tests() {
        SCHEMA_LOCATION.with(|path| *path.borrow_mut() = PathBuf::from("./mocks/schema.graphql"));
        let module = <MatchstickInstance<Chain>>::new("mocks/wasm/token-lock-wallet.wasm");
        let test_suite = TestSuite::from(&module);

        let mut failed_tests = 0;
        for group in &test_suite.groups {
            for test in &group.tests {
                if !test.run().passed {
                    failed_tests += 1;
                }
            }
        }

        assert_eq!(failed_tests, 0);
    }
}
