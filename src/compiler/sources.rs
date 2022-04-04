use clap::ArgMatches;
use regex::Regex;
use std::collections::{HashMap, HashSet};
use std::fs;
use std::path::{Path, PathBuf};
use std::time::SystemTime;

use crate::logging;

/// Collects all tests sources from the current TESTS_LOCATION
/// Filters the sources if suite name[s] are passed to the `matchstick` command
pub fn get_test_sources(matches: &ArgMatches) -> HashMap<String, Vec<PathBuf>> {
    let mut testable: HashMap<String, Vec<PathBuf>> = HashMap::new();

    crate::TESTS_LOCATION.with(|path| {
        testable = collect_files(&*path.borrow());
    });

    if testable.is_empty() {
        logging::critical!("No tests have been written yet.");
    }

    if let Some(vals) = matches.values_of("test_suites") {
        let sources: HashSet<String> = vals
            .collect::<Vec<&str>>()
            .iter()
            .map(|&s| String::from(s).to_ascii_lowercase())
            .collect();

        let unrecog_sources: Vec<String> = sources
            .difference(&testable.keys().cloned().collect())
            .map(String::from)
            .collect();

        if !unrecog_sources.is_empty() {
            logging::critical!(
                "The following tests could not be found: {}",
                unrecog_sources.join(", ")
            );
        }

        testable
            .into_iter()
            .filter(|(name, _)| sources.contains(name))
            .collect()
    } else {
        testable
    }
}

/// Collects all tests sources from the current TESTS_LOCATION
fn collect_files(path: &Path) -> HashMap<String, Vec<PathBuf>> {
    let mut files: HashMap<String, Vec<PathBuf>> = HashMap::new();

    let entries = path
        .read_dir()
        .unwrap_or_else(|err| logging::critical!("Could not get tests from {:?}: {}", path, err));

    for entry in entries {
        let entry = entry.unwrap_or_else(|err| logging::critical!(err));
        let name = entry.file_name().to_str().unwrap().to_ascii_lowercase();

        if name.ends_with(".test.ts") {
            files.insert(name.replace(".test.ts", ""), vec![entry.path()]);
        } else if entry.path().is_dir() {
            let mut sub_files = collect_files(&entry.path());

            if !sub_files.is_empty() {
                files.insert(name.clone(), vec![]);
                for val in sub_files.values_mut() {
                    files.get_mut(&name).unwrap().append(val);
                }
            }
        }
    }

    files
}

/// Checks if any test files or imported files (except node_modules) have been modified
/// since the last time the wasm files have been compiled
pub fn is_source_modified(in_files: &[PathBuf], out_file: &Path) -> bool {
    let mut is_modified = false;

    let wasm_modified = fs::metadata(out_file)
        .unwrap_or_else(|err| {
            logging::critical!(
                "Failed to extract metadata from {:?} with error: {}",
                out_file,
                err
            )
        })
        .modified()
        .unwrap();

    for file in in_files {
        let in_file_modified = fs::metadata(file)
            .unwrap_or_else(|err| {
                logging::critical!(
                    "Failed to extract metadata from {:?} with error: {}",
                    file,
                    err
                )
            })
            .modified()
            .unwrap();

        if in_file_modified > wasm_modified {
            is_modified = true;
            break;
        }

        is_modified = are_imports_modified(file, wasm_modified);
    }

    is_modified
}

/// Checks if any imported files (except node_modules) have been modified
/// since the last time the wasm files have been compiled
fn are_imports_modified(in_file: &Path, wasm_modified: SystemTime) -> bool {
    let mut is_modified = false;
    let matches: HashSet<PathBuf> = get_imports_from_file(in_file);

    for m in matches {
        let import_modified = fs::metadata(&m)
            .unwrap_or_else(|err| {
                logging::critical!(
                    "Failed to extract metadata from {:?} with error: {}",
                    m,
                    err
                )
            })
            .modified()
            .unwrap();

        if import_modified > wasm_modified {
            is_modified = true;
            break;
        }
    }

    is_modified
}

/// Collects all imported file paths froma test.ts file an returns their absolute path
fn get_import_absolute_path(in_file: &Path, imported_file: &Path) -> PathBuf {
    let mut combined_path = PathBuf::from(in_file);
    combined_path.pop();
    combined_path.push(imported_file);
    if let Ok(abs_path) = combined_path.canonicalize() {
        abs_path
    } else {
        combined_path.set_extension("ts");
        combined_path.canonicalize().unwrap()
    }
}

/// Collects all imported file paths (except node_modules) from a test.ts file using regex
fn get_imports_from_file(in_file: &Path) -> HashSet<PathBuf> {
    // Regex should match the file path of each import statement except for node_modules
    // e.g. should return `../generated/schema` from `import { Gravatar } from '../generated/schema'`
    // but it will ignore `import { test, log } from 'matchstick-as/assembly/index'`
    // Handles single and double quotes
    let imports_regex = Regex::new(r#"[import.*from]\s*["|']\s*([../+|./].*)\s*["|']"#).unwrap();
    let file_as_str = fs::read_to_string(in_file).unwrap_or_else(|err| {
        logging::critical!("Failed to read {:?} with error: {}", in_file, err)
    });

    let mut imports: HashSet<PathBuf> = HashSet::new();

    for import in imports_regex.captures_iter(&file_as_str) {
        let path = get_import_absolute_path(in_file, &PathBuf::from(import[1].to_owned()));
        if path.is_dir() {
            for entry in path.read_dir().unwrap_or_else(|_| panic!("Could not read dir: {:?}", path)) {
                let entry_path = get_import_absolute_path(in_file, &entry.unwrap().path());
                imports.extend(get_imports_from_file(&entry_path));
            }
        } else {
            imports.extend(get_imports_from_file(&path));
        }
    }

    imports
}

#[cfg(test)]
mod compiler_tests {
    use super::*;
    use std::fs;
    use std::path::PathBuf;

    #[test]
    fn it_gets_project_imports_test() {
        let in_file = PathBuf::from("mocks/as/mock-includes.test.ts");
        let includes = get_imports_from_file(&in_file);

        assert_eq!(
            includes,
            ["./utils", "../generated/schema", "../../src/gravity"]
        )
    }

    #[test]
    fn it_get_absolute_path_of_imports_test() {
        let in_file = PathBuf::from("mocks/as/mock-includes.test.ts");
        let root_path = fs::canonicalize("./").expect("Something went wrong!");

        let result = get_import_absolute_path(&in_file, "./utils");
        let abs_path = PathBuf::from(format!("{}/mocks/as/utils.ts", root_path.to_str().unwrap()));

        assert_eq!(result, abs_path);
    }

    #[test]
    fn it_should_panic_if_imports_does_not_exist_test() {
        let in_file = PathBuf::from("mocks/as/mock-includes.test.ts");
        let result =
            std::panic::catch_unwind(|| get_import_absolute_path(&in_file, "../generated/schema"));

        assert!(result.is_err());

        let err = *(result.unwrap_err().downcast::<String>().unwrap());

        assert!(err.contains("../generated/schema does not exists!"));
    }
}
