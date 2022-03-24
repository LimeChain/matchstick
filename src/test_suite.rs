use colored::Colorize;
use graph::blockchain::Blockchain;
use std::time::Instant;
use wasmtime::Func;

use crate::{instance::MatchstickInstance, logging};

#[derive(Debug)]
pub struct Test {
    pub name: String,
    should_fail: bool,
    func: Func,
    before_hooks: Vec<Func>,
    after_hooks: Vec<Func>,
}

#[derive(Debug)]
pub struct TestResult {
    pub passed: bool,
    pub logs: String,
}

impl Test {
    fn new(name: String, should_fail: bool, func: Func) -> Self {
        Test {
            name,
            should_fail,
            func,
            before_hooks: vec![],
            after_hooks: vec![],
        }
    }

    pub fn call_hooks(hooks: &[Func]) {
        hooks.iter().for_each(|h| {
            h.call(&[]).unwrap_or_else(|err| {
                logging::critical!("Unexpected error upon calling hook: {}", err)
            });
        });
    }

    fn before(&self) {
        Test::call_hooks(&self.before_hooks);
    }

    fn after(&self) {
        Test::call_hooks(&self.after_hooks);
    }

    pub fn run(&self) -> TestResult {
        self.before();

        // NOTE: Calling a test func should not fail for any other reason than:
        // - `should_fail` has been set to `true`
        // - the behaviour tested does not hold
        logging::accum();
        logging::add_indent();
        let now = Instant::now();

        let passed: bool = match self.func.call(&[]) {
            Ok(_) => {
                // Log error and mark test as failed if should_fail is `true`, but test passes
                // Otherwise mark test as passed
                if self.should_fail {
                    logging::error!("Expected test to fail but it passed successfully!");
                    false
                } else {
                    true
                }
            }
            Err(err) => {
                // Mark test as passed if should_fail is `true`
                // Log error and mark test as failed if should_fail is `false`
                if self.should_fail {
                    true
                } else {
                    logging::add_indent();
                    logging::debug!(err);
                    logging::sub_indent();
                    false
                }
            }
        };

        // Convert the elapsed time to milliseconds
        // Seems hacky, might need refactoring
        let elapsed_in_ms = now.elapsed().as_secs_f32() * 1000.0;

        logging::sub_indent();
        let logs = logging::flush();

        let msg = format!(
            "{} - {}",
            self.name.clone(),
            format!("{:.3?}ms", elapsed_in_ms).bright_blue()
        );
        if passed {
            logging::success!(msg);
        } else {
            logging::error!(msg);
        }

        // Print the logs after the test result.
        if passed && !logs.is_empty() {
            logging::default!(&logs);
        }

        self.after();

        TestResult { passed, logs }
    }
}

#[derive(Debug)]
pub struct TestSuite {
    pub groups: Vec<TestGroup>,
    pub before_all: Vec<Func>,
    pub after_all: Vec<Func>,
}

#[derive(Debug)]
pub struct TestGroup {
    pub name: String,
    pub before_all: Vec<Func>,
    pub after_all: Vec<Func>,
    pub tests: Vec<Testable>,
}

#[derive(Debug)]
pub enum Testable {
    Test(Test),
    Group(TestGroup),
}

impl<C: Blockchain> From<&MatchstickInstance<C>> for TestSuite {
    fn from(matchstick: &MatchstickInstance<C>) -> Self {
        let table = matchstick.instance.get_table("table").unwrap_or_else(|| {
            logging::critical!(
                "WebAssembly.Table was not exported from the AssemblyScript sources.
                    (Please compile with the `--exportTable` option.)"
            )
        });

        let mut suite = TestSuite {
            groups: vec![],
            before_all: vec![],
            after_all: vec![],
        };

        let mut before_each = vec![];
        let mut after_each = vec![];

        for (name, should_fail, func_idx, role) in &matchstick
            .instance_ctx
            .borrow()
            .as_ref()
            .unwrap_or_else(|| {
                logging::critical!("Unexpected: MatchstickInstanceContext is 'None'.")
            })
            .meta_tests
        {
            let func = table
                .get(*func_idx)
                .unwrap_or_else(|| {
                    logging::critical!(
                        "Could not get WebAssembly.Table entry with index '{}'.",
                        func_idx,
                    )
                })
                .unwrap_funcref()
                .unwrap()
                .to_owned();

            match role.as_str() {
                "beforeAll" => {
                    suite.before_all.push(func.clone());
                }
                "afterAll" => {
                    suite.after_all.push(func.clone());
                }
                "beforeEach" => {
                    before_each.push(func.clone());
                }
                "afterEach" => {
                    after_each.push(func.clone());
                }
                "describe" => {
                    let difference = get_nested_tests(matchstick, *func_idx);
                    let test_group = handle_describe(matchstick, name, difference, &table);

                    suite.groups.push(test_group);
                }
                "test" => {
                    let test_group = TestGroup {
                        name: "".to_owned(),
                        tests: vec![Testable::Test(Test::new(name.to_string(), *should_fail, func.clone()))],
                        before_all: vec![],
                        after_all: vec![],
                    };

                    suite.groups.push(test_group);
                }
                _ => { logging::critical!("Unrecognized function type `{}`", role) }
            };
        }

        // Add the accumulated before and after functions to every test()
        // in the corresponding describe group
        for group in suite.groups.iter_mut() {
            let mut inner_ba = group.before_all.clone();
            let mut inner_aa = group.after_all.clone();
            group.before_all = before_each.clone();
            group.before_all.append(&mut inner_ba);

            group.after_all = after_each.clone();
            group.after_all.append(&mut inner_aa);
            group.after_all.reverse();
        }

        // Return the generates suite
        suite
    }
}

fn handle_describe<C: graph::blockchain::Blockchain> (
    matchstick: &MatchstickInstance<C>,
    name: &str,
    difference: Vec<(String, bool, u32, String)>,
    table: &wasmtime::Table,
) -> TestGroup {
    let mut desc_b_e = vec![];
    let mut desc_a_e = vec![];
    let mut test_group = TestGroup {
        name: name.to_owned(),
        tests: vec![],
        before_all: vec![],
        after_all: vec![],
    };

    for (t_name, should_fail, t_idx, role) in difference {
        let test = table
            .get(t_idx)
            .unwrap_or_else(|| {
                logging::critical!(
                    "Could not get WebAssembly.Table entry with index '{}'.",
                    t_idx,
                )
            })
            .unwrap_funcref()
            .unwrap()
            .to_owned();

        match role.as_str() {
            "beforeAll" => {
                test_group.before_all.push(test.clone());
            }
            "afterAll" => {
                test_group.after_all.push(test.clone());
            }
            "beforeEach" => {
                desc_b_e.push(test.clone());
            }
            "afterEach" => {
                desc_a_e.push(test.clone());
            }
            "test" => {
                test_group
                    .tests
                    .push(Testable::Test(Test::new(t_name.to_string(), should_fail, test.clone())))
            }
            "describe" => {
                let diff = get_nested_tests(matchstick, t_idx);
                let nested_test_group = handle_describe(matchstick, &t_name, diff, &table);
                test_group
                    .tests
                    .push(Testable::Group(nested_test_group))
            }
            _ => { logging::critical!("Unrecognized function type `{}`", role) }
        }
    }

    for test in test_group.tests.iter_mut() {
        match test {
            Testable::Test(test) => {
                test.before_hooks = desc_b_e.clone();
                test.after_hooks = desc_a_e.clone();
            }
            Testable::Group(group) => {
                let mut inner_ba = group.before_all.clone();
                let mut inner_aa = group.after_all.clone();
                group.before_all =  desc_b_e.clone();
                group.before_all.append(&mut inner_ba);

                group.after_all = desc_a_e.clone();
                group.after_all.append(&mut inner_aa);
                group.after_all.reverse();
            }
        }
    }

    test_group
}

fn get_nested_tests<C: graph::blockchain::Blockchain>(
    matchstick: &MatchstickInstance<C>,
    func_idx: u32,
) -> Vec<(String, bool, u32, String)> {
    let host_metrics = matchstick.instance_ctx().wasm_ctx.host_metrics.clone();
    let valid_module = matchstick.instance_ctx().wasm_ctx.valid_module.clone();
    let ctx = matchstick
        .instance_ctx()
        .wasm_ctx
        .ctx
        .derive_with_empty_block_state();
    let experimental_features = graph_runtime_wasm::ExperimentalFeatures {
        allow_non_deterministic_ipfs: true,
    };

    let inst = crate::MatchstickInstance::<_>::from_valid_module_with_ctx(
        valid_module.clone(),
        ctx.derive_with_empty_block_state(),
        host_metrics.clone(),
        None,
        experimental_features,
    )
    .unwrap();

    let tb = inst.instance.get_table("table").unwrap_or_else(|| {
        logging::critical!(
            "WebAssembly.Table was not exported from the AssemblyScript sources.
                (Please compile with the `--exportTable` option.)"
        )
    });

    let before_meta_tests = inst.instance_ctx().meta_tests.clone();

    let fun = tb
        .get(func_idx)
        .unwrap_or_else(|| {
            logging::critical!(
                "Could not get WebAssembly.Table entry with index '{}'.",
                func_idx,
            )
        })
        .unwrap_funcref()
        .unwrap()
        .to_owned();

    fun.call(&[]).expect("Failed to execute function");

    let after_meta_tests = inst.instance_ctx().meta_tests.clone();

    after_meta_tests
        .into_iter()
        .filter(|item| !before_meta_tests.contains(item))
        .collect()
}
