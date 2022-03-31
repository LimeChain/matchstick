#[cfg(test)]
mod integration_tests {
    use graph_chain_ethereum::Chain;
    use serial_test::serial;
    use std::path::PathBuf;

    use crate::test_suite::{TestGroup, TestSuite, Testable};
    use crate::{MatchstickInstance, SCHEMA_LOCATION};

    #[test]
    #[serial]
    fn run_all_gravity_demo_subgraph_tests() {
        SCHEMA_LOCATION.with(|path| *path.borrow_mut() = PathBuf::from("./mocks/schema.graphql"));
        let module = <MatchstickInstance<Chain>>::new("mocks/wasm/gravity.wasm");
        let test_suite = TestSuite::from(&module);

        let mut failed_tests = Box::new(0);

        for group in &test_suite.groups {
            run_test_group(&group, &mut failed_tests);
        }

        assert_eq!(failed_tests, Box::new(0));
    }

    #[test]
    #[serial]
    fn run_all_token_lock_wallet_demo_subgraph_tests() {
        SCHEMA_LOCATION.with(|path| *path.borrow_mut() = PathBuf::from("./mocks/schema.graphql"));
        let module = <MatchstickInstance<Chain>>::new("mocks/wasm/token-lock-wallet.wasm");
        let test_suite = TestSuite::from(&module);

        let mut failed_tests = Box::new(0);
        for group in &test_suite.groups {
            run_test_group(&group, &mut failed_tests);
        }

        assert_eq!(failed_tests, Box::new(0));
    }

    fn run_test_group(group: &TestGroup, num_failed: &mut Box<i32>) {
        for test in &group.tests {
            match test {
                Testable::Test(test) => {
                    let result = test.run();
                    if !result.passed {
                        let num = &mut (**num_failed);
                        *num += 1;
                    }
                }
                Testable::Group(group) => {
                    run_test_group(group, num_failed);
                }
            }
        }
    }
}
