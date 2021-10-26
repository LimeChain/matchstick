use std::fmt;

use colored::Colorize;

static MARGIN: usize = 2;
static mut INDENT: usize = 0;
pub fn add_indent() {
    unsafe {
        INDENT += MARGIN;
    }
}
pub fn sub_indent() {
    unsafe {
        INDENT -= MARGIN;
    }
}
pub fn clear_indent() {
    unsafe {
        INDENT = 0;
    }
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
        println!("{}", self);
    }
}

impl<T: fmt::Display> fmt::Display for Log<T> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let s = match self {
            Log::Critical(s) => format!("🆘 Critical: {}", s).bold().red(),
            Log::Error(s) => format!("❌ {}", s).bold().red(),
            Log::Warning(s) => format!("🚧 Warning: {}", s).yellow(),
            Log::Info(s) => format!("💬 Info: {}", s).italic(),
            Log::Debug(s) => format!("🛠  Debug: {}", s).italic().cyan(),
            Log::Success(s) => format!("✅ {}", s).bold().green(),
        };
        unsafe { write!(f, "{}{}", " ".repeat(INDENT), s) }
    }
}
