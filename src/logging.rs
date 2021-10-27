use std::fmt::{self, Write};

use colored::Colorize;

/// Controls the amount of indentation added and substracted.
static MARGIN: usize = 2;
/// Current indentation when logging.
static mut INDENT: usize = 0;
pub fn add_indent() {
    unsafe { INDENT += MARGIN };
}
pub fn sub_indent() {
    unsafe { INDENT -= MARGIN };
}
pub fn clear_indent() {
    unsafe { INDENT = 0 };
}

/// Whether to accumulate the logs or print them as they come.
static mut ACCUM: bool = false;
static mut LOGS: Vec<String> = vec![];
/// Start accumulating the logs instead of printing them directly.
pub fn accum() {
    unsafe { ACCUM = true };
}
/// Flush the accumulated logs by producing a resulting string
/// and exit the accumulation mode of logging.
pub fn flush() -> String {
    let mut buf = String::new();
    unsafe {
        ACCUM = false;
        LOGS.iter().for_each(|s| {
            writeln!(&mut buf, "{}", s).unwrap_or_else(|err| panic!("{}", Log::Critical(err)))
        });
        LOGS.clear();
    };
    buf
}

pub enum Log<T: fmt::Display> {
    Critical(T),
    Error(T),
    Warning(T),
    Info(T),
    Debug(T),
    Success(T),
}

impl<T: fmt::Display> Log<T> {
    pub fn new(level: u32, s: T) -> Self {
        match level {
            0 => Log::Critical(s),
            1 => Log::Error(s),
            2 => Log::Warning(s),
            3 => Log::Info(s),
            4 => Log::Debug(s),
            5 => Log::Success(s),

            _ => panic!("Level is not supported!"),
        }
    }

    pub fn println(&self) {
        let s = self.to_string();
        unsafe {
            if ACCUM {
                LOGS.push(s);
                return;
            }
        }
        println!("{}", s);
    }
}

impl<T: fmt::Display> fmt::Display for Log<T> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let s = match self {
            Log::Critical(s) => format!("🆘 {}", s).bold().red(),
            Log::Error(s) => format!("❌ {}", s).bold().red(),
            Log::Warning(s) => format!("🚧 {}", s).yellow(),
            Log::Info(s) => format!("💬 {}", s).italic(),
            Log::Debug(s) => format!("🛠  {}", s).italic().cyan(),
            Log::Success(s) => format!("✅ {}", s).bold().green(),
        };
        unsafe { write!(f, "{}{}", " ".repeat(INDENT), s) }
    }
}
