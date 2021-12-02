use std::collections::HashMap;
use std::fs::File;
use std::io::{BufRead, BufReader};

// Accumulates the paths of all test files
fn collect_files(root: &str) -> Vec<std::path::PathBuf> {
    let mut files: Vec<std::path::PathBuf> = Vec::new();

    for element in std::path::Path::new(&root).read_dir().unwrap() {
        let path = element.unwrap().path();
        let as_string = path.to_str().unwrap();

        if as_string.ends_with(".test.ts") {
            files.push(path);
        } else if path.is_dir() {
            let mut sub_files: Vec<std::path::PathBuf> =
                collect_files(&path.to_str().unwrap().to_string());
            files.append(&mut sub_files);
        }
    }

    files
}

// Map the test name to the test file path and line
pub fn get_tests_paths(root: &str) -> HashMap<String, HashMap<String, String>> {
    let file_paths = collect_files(root);
    let suite_tests: HashMap<String, HashMap<String, String>> = file_paths
        .into_iter()
        .filter_map(|path| {
            let mut line_number = 1;
            let tests = File::open(path.clone()).unwrap();
            let reader = BufReader::new(tests);
            let v: Vec<&str> = path.to_str().unwrap().split('/').collect();
            let test_suite = v.get(2).unwrap().replace(".test.ts", "");

            let test_paths: HashMap<String, String> = reader
                .lines()
                .into_iter()
                .filter_map(|line| {
                    if line.as_ref().unwrap().starts_with("test(") {
                        let start = line.as_ref().unwrap().find("(\"").unwrap();
                        let end = line.as_ref().unwrap().find("\",").unwrap();
                        let name = &line.unwrap()[(start + 2)..end];

                        line_number += 1;
                        Some((name.to_string(), format!("{:?}:{}", path, line_number)))
                    } else {
                        line_number += 1;
                        None
                    }
                })
                .collect();

            if test_paths.is_empty() {
                None
            } else {
                Some((test_suite, test_paths))
            }
        })
        .collect();

    suite_tests
}
