use clap::ArgMatches;
use colored::Colorize;
use std::collections::HashMap;
use std::io::{self, Write};
use std::path::{Path, PathBuf};
use std::process::{Command, ExitStatus};

#[cfg(unix)]
use std::os::unix::process::ExitStatusExt;

#[cfg(windows)]
use std::os::windows::process::ExitStatusExt;

mod sources;

use crate::logging::Log;
use sources::*;

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

    pub fn execute(&self, matches: &ArgMatches) -> HashMap<String, CompileOutput> {
        let outputs = get_test_sources(matches)
            .into_iter()
            .map(|(name, in_files)| {
                let mut out_file = PathBuf::new();

                crate::TESTS_LOCATION.with(|path| {
                    let bin_location = path.borrow().join(".bin");
                    out_file = bin_location.join(&name).with_extension("wasm");
                });

                let output = if matches.is_present("recompile")
                    || !Path::new(&out_file).exists()
                    || is_source_modified(&in_files, &out_file)
                {
                    Log::Info(format!("Compiling {}...", name.bright_blue())).println();

                    self.compile(in_files, out_file)
                } else {
                    Log::Info(format!("{} skipped!", name.bright_blue())).println();

                    self.skip_compile(out_file)
                };

                (name, output)
            })
            .collect();

        verify_outputs(&outputs);

        outputs
    }

    fn compile(&self, in_files: Vec<PathBuf>, out_file: PathBuf) -> CompileOutput {
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
}

fn verify_outputs(outputs: &HashMap<String, CompileOutput>) {
    if outputs.values().any(|output| !output.status.success()) {
        outputs.values().for_each(|output| {
            io::stderr()
                .write_all(&output.stderr)
                .unwrap_or_else(|err| {
                    panic!(
                        "{}",
                        Log::Critical(format!("Could not write to `stderr`: {}", err)),
                    );
                });
        });

        panic!(
            "{}",
            Log::Critical("Please attend to the compilation errors above!"),
        );
    }
}
