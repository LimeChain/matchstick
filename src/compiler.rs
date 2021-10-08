use std::fs;
use std::io;
use std::process::{Command, Output};

pub struct Compiler {
    exec: String,
    global: String,
    lib: String,
    options: Vec<String>,
}

impl Compiler {
    pub fn default() -> Compiler {
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
        self.options.push(format!("--runtime {}", s));
        self
    }

    fn get_paths_for(datasource: &str) -> (Vec<String>, String) {
        fs::create_dir_all("./tests/.bin/")
            .expect("Something went wrong when creating `./tests/.bin/`.");

        let entry = fs::read_dir("./tests/")
            .unwrap()
            .map(|entry| entry.unwrap())
            .find_map(|entry| {
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
            .expect("No tests for {} datasource were found during compilation.");

        let in_files = if entry.file_type().unwrap().is_dir() {
            entry
                .path()
                .read_dir()
                .unwrap()
                .map(|file| file.unwrap())
                .map(|file| file.path().to_str().unwrap().to_string())
                .collect()
        } else {
            vec![entry.path().to_str().unwrap().to_string()]
        };

        return (in_files, format!("./tests/.bin/{}.wasm", datasource));
    }

    pub fn compile(&self, datasource: &str) -> io::Result<Output> {
        let (in_files, out_file) = Compiler::get_paths_for(datasource);
        println!("{:?}", self.lib);

        Command::new(&self.exec)
            .args(in_files)
            .arg(&self.global)
            .arg("--lib")
            .arg(&self.lib)
            .args(&self.options)
            .arg("--outFile")
            .arg(out_file)
            .output()
    }
}
