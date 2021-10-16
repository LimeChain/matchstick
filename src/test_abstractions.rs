use graph::blockchain::Blockchain;

use crate::{instance::MatchstickInstance, logging::Log};

pub struct Test {
    name: String,
    should_fail: bool,
    func: wasmtime::Func,
    before_hooks: Vec<wasmtime::Func>,
    after_hooks: Vec<wasmtime::Func>,
}

pub struct TestResult {
    pub is_successful: bool,
}

impl Test {
    fn new(name: String, should_fail: bool, func: wasmtime::Func) -> Self {
        Test {
            name,
            should_fail,
            func,
            before_hooks: vec![],
            after_hooks: vec![],
        }
    }

    fn call_hooks(hooks: &[wasmtime::Func]) {
        // TODO: Handle possible errors better.
        hooks.iter().for_each(|h| {
            h.call(&[]).unwrap();
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

        let mut is_successful = true;
        Log::Info(format!("-> Running {}", self.name)).print();
        // NOTE: Calling a test func should not fail for any other reason than:
        // - `should_fail` has been set to `true`
        // - the behaviour tested does not hold
        self.func.call(&[]).unwrap_or_else(|_err| {
            if !self.should_fail {
                is_successful = false;
            }
            Box::new([wasmtime::Val::I32(0)])
        });

        if is_successful {
            Log::Success("Test has passed!".to_string()).print();
        } else {
            Log::Error("Test has failed!".to_string()).print();
        }

        self.after();
        TestResult { is_successful }
    }
}

pub struct TestCollection {
    pub tests: Vec<Test>,
}

impl<C: Blockchain> From<&MatchstickInstance<C>> for TestCollection {
    fn from(matchstick: &MatchstickInstance<C>) -> Self {
        let table = matchstick.instance.get_table("table").unwrap_or_else(|| {
            panic!(
                "{}",
                Log::Critical(
                    "WebAssembly.Table was not exported from the AssemblyScript sources.
                (Please compile with the `--exportTable` option.)"
                        .to_string(),
                )
                .to_string()
            )
        });

        let mut collection = TestCollection { tests: vec![] };
        for (name, should_fail, func_idx) in &matchstick
            .instance_ctx
            .borrow()
            .as_ref()
            .unwrap()
            .meta_tests
        {
            collection.tests.push(Test::new(
                name.to_string(),
                *should_fail,
                table
                    .get(*func_idx)
                    .unwrap_or_else(|| {
                        panic!(
                            "{}",
                            Log::Critical(format!(
                                "Could not get WebAssembly.Table entry with index: {}.",
                                func_idx
                            ))
                            .to_string()
                        )
                    })
                    .unwrap_funcref()
                    .unwrap()
                    .to_owned(),
            ))
        }

        collection
    }
}
