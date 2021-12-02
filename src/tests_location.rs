use regex::Regex;
use std::collections::HashMap;
use std::fs::File;
use std::io::{BufRead, BufReader};

// Iterates over all files and folders in the test folder and
// accumulates the file path for each .test.ts file.
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

// Reads each test file line by line and looks if the line starts with "test("
// and counts the lines.
// If the line contains "test(", gets the name of the test using a regex to determine
// the start and end position of the test name
// Maps the test path/to/file:line to the test name
// Also groups the test by the test suite name in case there are
// duplicated test names in different test suites
pub fn get_tests_paths(root: &str) -> HashMap<String, HashMap<String, String>> {
    let file_paths = collect_files(root);
    let suite_tests: HashMap<String, HashMap<String, String>> = file_paths
        .into_iter()
        .filter_map(|path| {
            let mut line_number = 0;
            let tests = File::open(path.clone()).unwrap();
            let reader = BufReader::new(tests);
            let v: Vec<&str> = path.to_str().unwrap().split('/').collect();
            let test_suite = v.get(2).unwrap().replace(".test.ts", "");

            let test_paths: HashMap<String, String> = reader
                .lines()
                .into_iter()
                .filter_map(|line| {
                    line_number += 1;
                    let line_as_string = line.as_ref().unwrap();

                    if line.as_ref().unwrap().starts_with("test(") {
                        // This regex finds the beginning of the test name
                        // It looks for (", but also handles situations if there are
                        // white spaces between the opening ( and "
                        let start = Regex::new(r#"\(\s*""#)
                            .unwrap()
                            .find(line_as_string)
                            .unwrap()
                            .end();
                        // This one looks for ", after the test name
                        // Also handles if there are whitespaces between the " and ,
                        let end = Regex::new(r#""\s*,"#)
                            .unwrap()
                            .find(line_as_string)
                            .unwrap()
                            .start();

                        let name = &line.unwrap()[start..end];

                        Some((
                            name.to_string(),
                            format!("{}:{}", path.to_str().unwrap(), line_number),
                        ))
                    } else {
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
