use graph::blockchain::Blockchain;

use super::{instance::MatchstickInstance, logging::Log};

pub struct Test {
    name: String,
    fails: bool,
    func: wasmtime::Func,
    pub before_hooks: Vec<wasmtime::Func>,
    pub after_hooks: Vec<wasmtime::Func>,
}

impl Test {
    fn new(name: String, fails: bool, func: wasmtime::Func) -> Self {
        Test {
            name,
            fails,
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

    pub fn run(&self) {
        self.before();

        Log::Info(format!("-> Running {}", self.name)).print();
        self.func.call(&[]).unwrap_or_else(|err| {
                if self.fails {
                    Box::new([wasmtime::Val::I32(0)])
                } else {
                    let msg = String::from(r#"
                    Unexpected error occurred while running tests.
                    See error stack trace above and double check the syntax in your test file.

                    This usually happens for three reasons:
                    1. You passed a 'null' value to one of our functions - assert.fieldEquals(), store.get(), store.set().
                    2. A mocked function call reverted. Consider using 'try_functionName' to handle this in the mapping.
                    3. The test was supposed to throw an error but the 'shouldThrow' parameter was not set to true.

                    Please ensure that you have proper null checks in your tests.
                    You can debug your test file using the 'debug()' function, provided by matchstick-as (import { debug } from "matchstick-as/assembly/log").
                    "#);

                    self.after();
                    Log::Critical(format!("{}\n {}", err, msg)).print();
                    Box::new([wasmtime::Val::I32(0)])
                }
            });

        Log::Success("Test has passed!".to_string()).print();
        self.after();
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
