use colored::Colorize;
use regex::Regex;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::{Command, ExitStatus};
use std::time::SystemTime;

#[cfg(unix)]
use std::os::unix::process::ExitStatusExt;

#[cfg(windows)]
use std::os::windows::process::ExitStatusExt;

use crate::logging::Log;

pub struct Compiler {
    lib: PathBuf,
    exec: PathBuf,
    global: PathBuf,
    options: Vec<String>,
}

pub struct CompileOutput {
    pub status: ExitStatus,
    pub stdout: Vec<u8>,
    pub stderr: Vec<u8>,
    pub file: PathBuf,
}

#[allow(dead_code)]
impl Compiler {
    pub fn new(lib: PathBuf) -> Self {
        if !lib.exists() {
            panic!(
                "{}",
                Log::Critical(format!(
                    "Path to lib `{}` does not exist!",
                    lib.to_str()
                        .expect("unexpected: lib should always have a value"),
                )),
            );
        }
        Compiler {
            exec: lib.join("assemblyscript/bin/asc"),
            global: lib.join("@graphprotocol/graph-ts/global/global.ts"),
            lib,
            options: vec![String::from("--explicitStart")],
        }
    }

    pub fn export_table(mut self) -> Self {
        self.options.push("--exportTable".to_string());
        self
    }

    pub fn optimize(mut self) -> Self {
        self.options.push("--optimize".to_string());
        self
    }

    pub fn debug(mut self) -> Self {
        self.options.push("--debug".to_string());
        self
    }

    pub fn export_runtime(mut self) -> Self {
        self.options.push("--exportRuntime".to_string());
        self
    }

    pub fn runtime(mut self, s: &str) -> Self {
        self.options.push("--runtime".to_string());
        self.options.push(s.to_string());
        self
    }

    pub fn enable(mut self, s: &str) -> Self {
        self.options.push("--enable".to_string());
        self.options.push(s.to_string());
        self
    }

    fn get_paths_for(name: String, entry: fs::DirEntry) -> (Vec<String>, PathBuf) {
        let mut out_file = PathBuf::new();
        let mut in_files: Vec<String> = Vec::new();

        crate::TESTS_LOCATION.with(|path| {
            let bin_location = path.borrow().join(".bin");
            out_file = bin_location.join(name).with_extension("wasm");

            in_files = if entry
                .file_type()
                .unwrap_or_else(|err| panic!("{}", Log::Critical(err)))
                .is_dir()
            {
                entry
                    .path()
                    .read_dir()
                    .unwrap_or_else(|err| panic!("{}", Log::Critical(err)))
                    .map(|file| {
                        file.unwrap_or_else(|err| panic!("{}", Log::Critical(err)))
                            .path()
                            .to_str()
                            .unwrap()
                            .to_string()
                    })
                    .filter(|path| path.ends_with(".test.ts"))
                    .collect()
            } else {
                vec![entry.path().to_str().unwrap().to_string()]
            };

            fs::create_dir_all(&bin_location).unwrap_or_else(|err| {
                panic!(
                    "{}",
                    Log::Critical(format!(
                        "Something went wrong when trying to create `{:?}`: {}",
                        bin_location, err,
                    )),
                );
            });
        });

        (in_files, out_file)
    }

    pub fn execute(
        &self,
        name: String,
        entry: fs::DirEntry,
        should_recompile: bool,
    ) -> CompileOutput {
        let (in_files, out_file) = Compiler::get_paths_for(name.clone(), entry);

        if should_recompile
            || !Path::new(&out_file).exists()
            || Compiler::is_source_modified(&in_files, &out_file)
        {
            Log::Info(format!("Compiling {}...", name.bright_blue())).println();

            self.compile(in_files, out_file)
        } else {
            Log::Info(format!("{} skipped!", name.bright_blue())).println();

            self.skip_compile(out_file)
        }
    }

    fn compile(&self, in_files: Vec<String>, out_file: PathBuf) -> CompileOutput {
        let output = Command::new(&self.exec)
            .args(in_files)
            .arg(&self.global)
            .arg("--lib")
            .arg(&self.lib)
            .args(&self.options)
            .arg("--outFile")
            .arg(out_file.clone())
            .output()
            .unwrap_or_else(|err| {
                panic!(
                    "{}",
                    Log::Critical(format!("Internal error during compilation: {}", err)),
                );
            });

        CompileOutput {
            status: output.status,
            stdout: output.stdout,
            stderr: output.stderr,
            file: out_file,
        }
    }

    fn skip_compile(&self, out_file: PathBuf) -> CompileOutput {
        CompileOutput {
            status: ExitStatusExt::from_raw(0),
            stdout: vec![],
            stderr: vec![],
            file: out_file,
        }
    }

    fn is_source_modified(in_files: &[String], out_file: &Path) -> bool {
        let mut is_modified = false;

        let wasm_modified = fs::metadata(out_file)
            .unwrap_or_else(|err| panic!("{}", Log::Critical(err)))
            .modified()
            .unwrap();

        for file in in_files {
            let in_file_modified = fs::metadata(file)
                .unwrap_or_else(|err| panic!("{}", Log::Critical(err)))
                .modified()
                .unwrap();

            if in_file_modified > wasm_modified {
                is_modified = true;
                break;
            }

            is_modified = Compiler::are_imports_modified(file, wasm_modified);
        }

        is_modified
    }

    fn are_imports_modified(in_file: &str, wasm_modified: SystemTime) -> bool {
        let mut is_modified = false;
        let matches: Vec<String> = Compiler::get_imports_from_file(in_file);

        for m in matches {
            let absolute_path = Compiler::get_import_absolute_path(in_file, &m);

            let import_modified = fs::metadata(absolute_path)
                .unwrap_or_else(|err| panic!("{}", Log::Critical(err)))
                .modified()
                .unwrap();

            if import_modified > wasm_modified {
                is_modified = true;
                break;
            }
        }

        is_modified
    }

    fn get_imports_from_file(in_file: &str) -> Vec<String> {
        // Regex should match the file path of each import statement except for node_modules
        // e.g. should return `../generated/schema` from `import { Gravatar } from '../generated/schema'`
        // but it will ignore `import { test, log } from 'matchstick-as/assembly/index'`
        // Handles single and double quotes
        let imports_regex =
            Regex::new(r#"[import.*from]\s*["|']\s*([../+|./].*)\s*["|']"#).unwrap();
        let file_as_str =
            fs::read_to_string(in_file).unwrap_or_else(|err| panic!("{}", Log::Critical(err)));

        imports_regex
            .captures_iter(&file_as_str)
            .map(|m| m[1].to_string())
            .collect()
    }

    fn get_import_absolute_path(in_file: &str, imported_file: &str) -> PathBuf {
        let mut combined_path = PathBuf::from(in_file);
        combined_path.pop();
        combined_path.push(format!("{}.ts", imported_file));
        combined_path
            .canonicalize()
            .unwrap_or_else(|_| panic!("{} does not exists!", &imported_file))
    }
}

#[cfg(test)]
mod compiler_tests {
    use crate::compiler::Compiler;
    use std::fs;
    use std::path::PathBuf;

    #[test]
    fn it_gets_project_imports_test() {
        let in_file = "mocks/as/mock-includes.test.ts";
        let includes = Compiler::get_imports_from_file(&in_file);

        assert_eq!(
            includes,
            ["./utils", "../generated/schema", "../../src/gravity"]
        )
    }

    #[test]
    fn it_get_absolute_path_of_imports_test() {
        let in_file = "mocks/as/mock-includes.test.ts";
        let root_path = fs::canonicalize("./").expect("Something went wrong!");

        let result = Compiler::get_import_absolute_path(&in_file, "./utils");
        let abs_path = PathBuf::from(format!("{}/mocks/as/utils.ts", root_path.to_str().unwrap()));

        assert_eq!(result, abs_path);
    }

    #[test]
    fn it_should_panic_if_imports_does_not_exist_test() {
        let in_file = "mocks/as/mock-includes.test.ts";
        let result = std::panic::catch_unwind(|| {
            Compiler::get_import_absolute_path(&in_file, "../generated/schema")
        });

        assert!(result.is_err());

        let err = *(result.unwrap_err().downcast::<String>().unwrap());

        assert!(err.contains("../generated/schema does not exists!"));
    }
}
