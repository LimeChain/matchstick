use colored::Colorize;
use graph::blockchain::Blockchain;
use regex::Regex;
use serde_json::Value;
use std::collections::BTreeMap;
use std::time::Instant;
use wasmtime::Func;

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

        // Map parent to descendent functions
        let test_groups = test_groups(&matchstick.wasm);

        let mut suite = TestSuite {
            groups: BTreeMap::new(),
            before_all: vec![],
            after_all: vec![],
        };

        // Pre-initialises all test groups
        for (id, _descendents) in test_groups.iter() {
            let test_group = TestGroup {
                name: "".to_string(),
                tests: vec![],
                before_all: vec![],
                after_all: vec![],
            };
            suite.groups.insert(*id, test_group);
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
            let parent_id = get_parent_id(id, test_groups.clone());

            match role.as_str() {
                "beforeAll" => {
                    if parent_id == id {
                        suite.before_all.push(func.clone());
                    } else {
                        suite
                            .groups
                            .get_mut(&parent_id)
                            .unwrap()
                            .before_all
                            .push(func.clone());
                    }
                }
                "afterAll" => {
                    if parent_id == id {
                        suite.after_all.push(func.clone());
                    } else {
                        suite
                            .groups
                            .get_mut(&parent_id)
                            .unwrap()
                            .after_all
                            .push(func.clone());
                    }
                }
                "beforeEach" => {
                    if parent_id == id {
                        for (_, group) in suite.groups.iter_mut() {
                            group.before_all.push(func.clone());
                        }
                    } else {
                        before_each
                            .entry(parent_id)
                            .or_insert_with_key(|_| vec![func.clone()]);
                    }
                }
                "afterEach" => {
                    if parent_id == id {
                        for (_, group) in suite.groups.iter_mut() {
                            group.after_all.push(func.clone());
                        }
                    } else {
                        after_each
                            .entry(parent_id)
                            .or_insert_with_key(|_| vec![func.clone()]);
                    }
                }
                "describe" => {
                    suite.groups.get_mut(&id).unwrap().name = name.clone();
                }
                _ => {
                    suite
                        .groups
                        .get_mut(&parent_id)
                        .unwrap_or_else(|| panic!("Expected parent_id: {}", parent_id))
                        .tests
                        .push(Test::new(name.to_string(), *should_fail, func.clone()));
                }
            };
        }

        for (id, funcs) in before_each {
            for test in suite.groups.get_mut(&id).unwrap().tests.iter_mut() {
                test.before_hooks = funcs.clone();
            }
        }

        for (id, funcs) in after_each {
            for test in suite.groups.get_mut(&id).unwrap().tests.iter_mut() {
                test.after_hooks = funcs.clone();
            }
        }

        suite
    }
}

/// Determines if the current function is a parent or a descendent
/// Returns the parent ID if descendent
fn get_parent_id(id: i32, test_groups: BTreeMap<i32, Vec<i32>>) -> i32 {
    let mut parent_id = 0;

    for (parent, children) in test_groups.iter() {
        if *parent == id {
            parent_id = id;
            break;
        } else if children.contains(&id) {
            parent_id = *parent;
            break;
        }
    }

    parent_id
}

/// Calculates the ID of each describe function
/// and which functions are its children
/// Also handles before/after hooks and test functions
/// that are not part of a group
fn test_groups(path: &str) -> BTreeMap<i32, Vec<i32>> {
    // A collection of all anonymous functions in the wasm file
    let paths: Value = parse_wasm(path);

    let mut prev_parent_id = 0;
    let mut nested_children = 0;

    paths
        .as_array()
        .unwrap()
        .iter()
        .filter_map(|path| {
            // Will match `start:tests/gravity/gravity.test~anonymous|0`
            let parent_regex = Regex::new(r#"test~anonymous\|\d+$"#).expect("Incorrect regex");

            // Will match `start:tests/gravity/gravity.test~anonymous|0~anonymous|0`
            let child_regex =
                Regex::new(r#"test(~anonymous\|\d+~anonymous\|\d+\z)"#).expect("Incorrect regex");

            let name = path["name"].as_str().unwrap().to_string();

            // Looks for any anonymous functions that are not direct descendents
            // `tests/gravity/utils/handleNewGravatars~anonymous|0`
            // ` start:tests/gravity/gravity.test~anonymous|0~anonymous|0~anonymous|0`
            if !parent_regex.is_match(&name) && !child_regex.is_match(&name) {
                nested_children += 1
            }

            // If parent function is detected e.g `start:tests/gravity/gravity.test~anonymous|0`
            // calculates the ID and the ID of its descendents
            if parent_regex.is_match(&name) {
                let parent_id = calculate_parent_id(path, prev_parent_id, nested_children);

                let children: Vec<i32> = (prev_parent_id + 1..parent_id).collect();

                prev_parent_id = parent_id;
                nested_children = 0;

                Some((parent_id, children))
            } else {
                None
            }
        })
        .collect()
}

/// Reads and parses the wasm file to serde_json Value
fn parse_wasm(path: &str) -> Value {
    // Reads and parses the wasm file
    let mut wasm = twiggy_parser::read_and_parse(path, twiggy_traits::ParseMode::Auto).unwrap();

    // Build the options for the paths parsing
    let mut opts = twiggy_opt::Paths::new();
    opts.add_function("anonymous".to_string());
    opts.set_using_regexps(true);
    opts.set_descending(true);
    opts.set_max_paths(100);

    // Fetches all anonymous functions and which functions have been called from it
    let json_paths = twiggy_analyze::paths(&mut wasm, &opts).unwrap();
    let mut buf = Vec::new();
    json_paths.emit_json(&wasm, &mut buf).unwrap();
    let result = String::from_utf8(buf).unwrap();

    serde_json::from_str(&result).unwrap()
}

fn calculate_parent_id(path: &Value, prev_parent_id: i32, nested_children: i32) -> i32 {
    // All anonymous functions that are invoked from inside another
    // function are displayed as data[<integer>]
    let child_regex = Regex::new(r#"data\[\d+\]"#).expect("Incorrect regex");

    let mut children_num = 0;

    for caller in path["callers"].as_array().unwrap().iter() {
        let name = caller["name"].as_str().unwrap().to_string();

        if child_regex.is_match(&name) {
            children_num += 1
        }
    }

    prev_parent_id + children_num + nested_children + 1
}
