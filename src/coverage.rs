use colored::Colorize;
use regex::Regex;
use run_script::{run_or_exit, ScriptOptions};
use std::fs;
use std::path::PathBuf;

use crate::parser;

pub fn generate_coverage_report() {
    println!(
        "{}",
        ("Running in coverage report mode.\n️").to_string().cyan()
    );

    let source_handlers = parser::collect_handlers("subgraph.yaml");

    println!(
        "{}",
        ("Reading generated test modules... 🔎️").to_string().cyan()
    );

    let wat_files = generate_wat_files();

    println!("{}", ("Generating coverage report 📝\n").to_string().cyan());

    let mut global_handlers_count: i32 = 0;
    let mut global_handlers_called: i32 = 0;

    for (name, handlers) in source_handlers.into_iter() {
        println!("Handlers for source '{}':", name);

        let mut called: i32 = 0;
        let all_handlers: i32 = handlers.len().try_into().unwrap();

        // Iterates over every handler and checks if the handler has been called in any test suite
        // If called, it'll set `is_tested` to true and break out of the loop
        // called will be incremented by 1
        for handler in handlers {
            let mut is_tested = false;

            for wat_file in &wat_files {
                let wat_content = fs::read_to_string(&wat_file).expect("Couldn't read wat file.");

                if is_called(&wat_content, &handler) {
                    is_tested = true;
                    break;
                }
            }

            if is_tested {
                called += 1;
                let msg = format!("Handler '{}' is tested.", handler);
                println!("{}", msg.green());
            } else {
                let msg = format!("Handler '{}' is not tested.", handler);
                println!("{}", msg.red());
            }
        }

        let mut percentage: f32 = 0.0;

        if all_handlers > 0 {
            percentage = (called as f32 * 100.0) / all_handlers as f32;
        }

        println!(
            "Test coverage: {:.1}% ({}/{} handlers).\n",
            percentage, called, all_handlers
        );

        global_handlers_count += all_handlers;
        global_handlers_called += called;
    }

    let mut percentage: f32 = 0.0;

    if global_handlers_count > 0 {
        percentage = (global_handlers_called as f32 * 100.0) / global_handlers_count as f32;
    }

    println!(
        "Global test coverage: {:.1}% ({}/{} handlers).\n",
        percentage, global_handlers_called, global_handlers_count
    );
}

/// Performs a check if a handler is called in a test suite
fn is_called(wat_content: &str, handler: &str) -> bool {
    let pattern = format!(r#"call.+{}"#, handler);
    let regex = Regex::new(&pattern).expect("Not a valid regex pattern.");

    regex.is_match(wat_content)
}

/// Collects the generated wasm files
fn collect_wasm_files() -> Vec<PathBuf> {
    let mut files: Vec<PathBuf> = Vec::new();

    crate::TESTS_LOCATION.with(|path| {
        let bin_location = path.borrow().join(".bin");

        let msg = format!("Couldn't find folder '{:?}.", &bin_location);
        let entries = fs::read_dir(bin_location).expect(&msg);

        for entry in entries {
            let file_name = entry.unwrap().path();

            if let Some(ext) = file_name.extension() {
                if ext == "wasm" {
                    files.push(file_name)
                }
            }
        }
    });

    files
}

/// Converts each wasm file to wat
/// Returns a collection of all .wat files paths
fn generate_wat_files() -> Vec<String> {
    collect_wasm_files()
        .iter()
        .map(|file| {
            let destination = file.with_extension("wat");

            crate::LIBS_LOCATION.with(|path| {
                let convert_command = format!(
                    "{:?} {:?} {} {:?}",
                    path.borrow().join("wabt/bin/wasm2wat"),
                    file,
                    "-o",
                    destination
                );

                let options = ScriptOptions::new();
                let args = vec![];

                run_or_exit(&convert_command, &args, &options);
            });

            destination.to_str().unwrap().to_string()
        })
        .collect()
}
