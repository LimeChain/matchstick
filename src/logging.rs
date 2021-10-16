use std::fmt;

use colored::Colorize;

pub enum Log {
    Critical(String),
    Error(String),
    Warning(String),
    Info(String),
    Debug(String),
    Success(String),
}

impl Log {
    pub fn new(level: u32, s: String) -> Self {
        match level {
            0 => Log::Critical(s),
            1 => Log::Error(s),
            2 => Log::Warning(s),
            3 => Log::Info(s),
            4 => Log::Debug(s),
            5 => Log::Success(s),

            _ => panic!("Level above 5 is not supported!"),
        }
    }

    pub fn print(&self) {
        match self {
            Log::Critical(_) => panic!("{}", self),
            _ => println!("{}", self),
        }
    }
}

impl fmt::Display for Log {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let s = match self {
            Log::Critical(s) => format!("❌ ❌ ❌ {}", s).red(),
            Log::Error(s) => format!("ERROR {}", s).red(),
            Log::Warning(s) => format!("WARNING {}", s).yellow(),
            Log::Info(s) => format!("INFO {}", s).normal(),
            Log::Debug(s) => format!("DEBUG {}", s).cyan(),
            Log::Success(s) => format!("SUCCESS {}", s).green(),
        };
        write!(f, "{}", s)
    }
}
