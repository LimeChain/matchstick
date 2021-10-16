use graph::blockchain::Blockchain;

use super::{instance::MatchstickInstance, logging::Log};

pub struct Test {
    name: String,
    fails: bool,
    pub func: wasmtime::Func,
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
