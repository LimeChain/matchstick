use std::fs;
use std::process::{Command, ExitStatus};

pub struct Compiler {
    exec: String,
    global: String,
    lib: String,
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
    pub fn default() -> Compiler {
        // TODO: add an option allowing the user to specify a path to exec, global and lib.
        Compiler {
            exec: String::from("./node_modules/assemblyscript/bin/asc"),
            global: String::from("./node_modules/@graphprotocol/graph-ts/global/global.ts"),
            lib: String::from("./node_modules/"),
            options: vec![String::from("--explicitStart")],
        }
    }

    pub fn export_table(mut self) -> Compiler {
        self.options.push("--exportTable".to_string());
        self
    }

    pub fn optimize(mut self) -> Compiler {
        self.options.push("--optimize".to_string());
        self
    }

    pub fn debug(mut self) -> Compiler {
        self.options.push("--debug".to_string());
        self
    }

    pub fn export_runtime(mut self) -> Compiler {
        self.options.push("--exportRuntime".to_string());
        self
    }

    pub fn runtime(mut self, s: &str) -> Compiler {
        self.options.push("--runtime".to_string());
        self.options.push(s.to_string());
        self
    }

    fn get_paths_for(datasource: &str) -> (Vec<String>, String) {
        let entry = fs::read_dir("./tests/")
            .expect(
                "No tests were found: The `./tests/` directory does not exist or it could not be read.",
            )
            .find_map(|entry| {
                let entry = entry.unwrap();
                if entry
                    .file_name()
                    .to_str()
                    .unwrap()
                    .to_ascii_lowercase()
                    .starts_with(datasource)
                {
                    Some(entry)
                } else {
                    None
                }
            })
            .unwrap_or_else(|| {
                panic!(
                    "No tests for {} datasource were found during compilation.",
                    datasource
                )
            });

        let in_files = if entry.file_type().unwrap().is_dir() {
            entry
                .path()
                .read_dir()
                .unwrap()
                .map(|file| file.unwrap().path().to_str().unwrap().to_string())
                .filter(|path| path.ends_with(".test.ts"))
                .collect()
        } else {
            vec![entry.path().to_str().unwrap().to_string()]
        };

        fs::create_dir_all("./tests/.bin/")
            .expect("Something went wrong when creating `./tests/.bin/`.");

        return (in_files, format!("./tests/.bin/{}.wasm", datasource));
    }

    pub fn compile(&self, datasource: &str) -> CompileOutput {
        let (in_files, out_file) = Compiler::get_paths_for(datasource);
        let output = Command::new(&self.exec)
            .args(in_files)
            .arg(&self.global)
            .arg("--lib")
            .arg(&self.lib)
            .args(&self.options)
            .arg("--outFile")
            .arg(out_file.clone())
            .output()
            .expect("Internal error during compilation.");

        CompileOutput {
            status: output.status,
            stdout: output.stdout,
            stderr: output.stderr,
            file: out_file,
        }
    }
}
