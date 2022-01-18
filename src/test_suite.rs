use colored::Colorize;
use graph::blockchain::Blockchain;
use std::time::Instant;
use wasmtime::Func;
use twiggy_parser;
use twiggy_analyze;
use twiggy_opt;
use twiggy_traits;
use serde_json::{Value};
use std::collections::BTreeMap;
use regex::Regex;

use crate::{
    instance::MatchstickInstance,
    logging::{self, Log},
};

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
                    Log::Error("Expected test to fail but it passed successfully!").println();
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
                    Log::Debug(err).println();
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
            Log::Success(msg).println();
        } else {
            Log::Error(msg).println();
        }

        // Print the logs after the test result.
        if passed && !logs.is_empty() {
            println!("{}", logs);
        }

        self.after();
        TestResult { passed, logs }
    }
}

#[derive(Debug)]
pub struct TestSuite {
    pub groups: BTreeMap<i32, TestGroup>,
    pub before_all: Vec<Func>,
    pub after_all: Vec<Func>,
}

#[derive(Debug)]
pub struct TestGroup {
    pub name: String,
    pub before_all: Vec<Func>,
    pub after_all: Vec<Func>,
    pub tests: Vec<Test>
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

        let test_groups = test_groups(&matchstick.wasm);

        let mut suite_new = TestSuite {
            groups: BTreeMap::new(),
            before_all: vec![],
            after_all: vec![],
        };

        for (k, _v) in test_groups.iter() {
            let test_group = TestGroup {
                name: "".to_string(),
                tests: vec![],
                before_all: vec![],
                after_all: vec![],
            };
            suite_new.groups.insert(*k, test_group);
        }

        let mut before_each: BTreeMap<i32, Vec<Func>> = BTreeMap::new();
        let mut after_each: BTreeMap<i32, Vec<Func>> = BTreeMap::new();

        for (name, should_fail, func_idx, role) in &matchstick
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
            let func = table
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
                .to_owned();

            let id = *func_idx as i32;

            match role.as_str() {
                "beforeAll" => {
                    let parent_id = get_parent_id(id.clone(), test_groups.clone());

                    if parent_id == id {
                        suite_new.before_all.push(func.clone());
                    } else {
                        suite_new.groups.get_mut(&parent_id).unwrap().before_all.push(func.clone());
                    }
                },
                "afterAll" => {
                    let parent_id = get_parent_id(id.clone(), test_groups.clone());

                    if parent_id == id {
                        suite_new.after_all.push(func.clone());
                    } else {
                        suite_new.groups.get_mut(&parent_id).unwrap().after_all.push(func.clone());
                    }
                },
                "beforeEach" => {
                    let parent_id = get_parent_id(id.clone(), test_groups.clone());

                    if parent_id == id {
                        for (_, group) in suite_new.groups.iter_mut() {
                            group.before_all.push(func.clone());
                        }
                    } else {
                        before_each.entry(parent_id).or_insert_with_key(|_| vec![func.clone()]);
                    }
                },
                "afterEach" => {
                    let parent_id = get_parent_id(id.clone(), test_groups.clone());

                    if parent_id == id {
                        for (_, group) in suite_new.groups.iter_mut() {
                            group.after_all.push(func.clone());
                        }
                    } else {
                        after_each.entry(parent_id).or_insert_with_key(|_| vec![func.clone()]);
                    }
                },
                "describe" => {
                    suite_new.groups.get_mut(&id).unwrap().name = name.clone();
                },
                _ => {
                    let parent_id = get_parent_id(id.clone(), test_groups.clone());
                    suite_new.groups.get_mut(&parent_id).unwrap().tests.push(Test::new(name.to_string(), *should_fail, func.clone()));
                },
            };
        }

        for (id, funcs) in before_each {
            for test in suite_new.groups.get_mut(&id).unwrap().tests.iter_mut() {
                test.before_hooks = funcs.clone();
            }
        }

        for (id, funcs) in after_each {
            for test in suite_new.groups.get_mut(&id).unwrap().tests.iter_mut() {
                test.after_hooks = funcs.clone();
            }
        }

        suite_new
    }
}

fn get_parent_id(id: i32, test_groups: BTreeMap<i32, Vec<i32>>) -> i32 {
    let mut parent_id = 0;

    for (parent, children) in test_groups.iter() {
        if *parent == id {
            parent_id = id;
            break;
        } else {
            if children.contains(&id) {
                parent_id = *parent;
                break;
            }
        }
    }

    parent_id
}

fn test_groups(path: &str) -> BTreeMap<i32, Vec<i32>> {
    let mut wasm = twiggy_parser::read_and_parse(path, twiggy_traits::ParseMode::Auto).unwrap();

    let mut opts = twiggy_opt::Paths::new();
    opts.add_function("anonymous".to_string());
    opts.set_using_regexps(true);
    opts.set_descending(true);
    opts.set_max_paths(0);
    let paths = twiggy_analyze::paths(&mut wasm, &opts).unwrap();
    let mut buf = Vec::new();
    paths.emit_json(&mut wasm, &mut buf).unwrap();
    let result = String::from_utf8(buf).unwrap();
    let values: Value = serde_json::from_str(&result).unwrap();

    let mut prev_parent_id = 0;

    values
        .as_array()
        .unwrap()
        .iter()
        .enumerate()
        .filter_map(|(i, obj)| {
            let regex = Regex::new(r#"test~anonymous.{1}\d+$"#).expect("Incorrect regex");
            let name = obj["name"].as_str().unwrap().to_string();
            if regex.is_match(&name) {
                let p_id = i as i32 + 1;
                let children: Vec<i32> = (prev_parent_id+1..p_id).collect();
                prev_parent_id = p_id;

                Some((p_id, children))
            } else {
                None
            }
        }).collect()

}
