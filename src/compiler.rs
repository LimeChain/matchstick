use std::fs;
use std::path::PathBuf;
use std::process::{Command, ExitStatus};

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
    pub file: String,
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

    fn get_paths_for(name: String, entry: fs::DirEntry) -> (Vec<String>, String) {
        let in_files = if entry
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

        fs::create_dir_all("./tests/.bin/").unwrap_or_else(|err| {
            panic!(
                "{}",
                Log::Critical(format!(
                    "Something went wrong when trying to create `./tests/.bin/`: {}",
                    err,
                )),
            );
        });

        return (in_files, format!("./tests/.bin/{}.wasm", name));
    }

    pub fn compile(&self, name: String, entry: fs::DirEntry) -> CompileOutput {
        let (in_files, out_file) = Compiler::get_paths_for(name, entry);
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
}
