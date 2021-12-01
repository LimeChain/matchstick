use graph::blockchain::Blockchain;
use std::time::Instant;
use wasmtime::Func;

use crate::{
    instance::MatchstickInstance,
    logging::{self, Log},
};

pub struct Test {
    pub name: String,
    should_fail: bool,
    func: Func,
    before_hooks: Vec<Func>,
    after_hooks: Vec<Func>,
}

pub struct TestResult {
    pub passed: bool,
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

    fn call_hooks(hooks: &[Func]) {
        hooks.iter().for_each(|h| {
            h.call(&[]).unwrap_or_else(|err| {
                panic!(
                    "{}",
                    Log::Critical(format!("Unexpected error upon calling hook: {}", err)),
                );
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

        let mut passed = true;
        // NOTE: Calling a test func should not fail for any other reason than:
        // - `should_fail` has been set to `true`
        // - the behaviour tested does not hold
        logging::accum();
        logging::add_indent();
        let now = Instant::now();
        self.func.call(&[]).unwrap_or_else(|err| {
            if !self.should_fail {
                passed = false;
                // Log WASM backtrace
                logging::add_indent();
                Log::Debug(err).println();
                logging::sub_indent();
            }
            Box::new([wasmtime::Val::I32(0)])
        });
        let elapsed = now.elapsed();
        // Convert the elapsed time to milliseconds
        // Seems hacky, might need refactoring
        let elapsed_in_ms = elapsed.as_secs_f32() * 1000.0;

        logging::sub_indent();
        let logs = logging::flush();

        let msg = format!("{} - {:.3?}ms", self.name.clone(), elapsed_in_ms);
        if passed {
            Log::Success(msg).println();
        } else {
            Log::Error(msg).println();
        }

        // Print the logs after the test result.
        if !logs.is_empty() {
            println!("{}", logs);
        }

        self.after();
        TestResult { passed }
    }
}

pub struct TestSuite {
    pub tests: Vec<Test>,
}

impl<C: Blockchain> From<&MatchstickInstance<C>> for TestSuite {
    fn from(matchstick: &MatchstickInstance<C>) -> Self {
        let table = matchstick.instance.get_table("table").unwrap_or_else(|| {
            panic!(
                "{}",
                Log::Critical(
                    "WebAssembly.Table was not exported from the AssemblyScript sources.
                    (Please compile with the `--exportTable` option.)"
                ),
            );
        });

        let mut suite = TestSuite { tests: vec![] };
        for (name, should_fail, func_idx) in &matchstick
            .instance_ctx
            .borrow()
            .as_ref()
            .unwrap_or_else(|| {
                panic!(
                    "{}",
                    Log::Critical("Unexpected: MatchstickInstanceContext is 'None'."),
                );
            })
            .meta_tests
        {
            suite.tests.push(Test::new(
                name.to_string(),
                *should_fail,
                table
                    .get(*func_idx)
                    .unwrap_or_else(|| {
                        panic!(
                            "{}",
                            Log::Critical(format!(
                                "Could not get WebAssembly.Table entry with index '{}'.",
                                func_idx,
                            )),
                        );
                    })
                    .unwrap_funcref()
                    .unwrap()
                    .to_owned(),
            ))
        }

        suite
    }
}
