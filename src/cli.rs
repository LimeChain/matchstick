use clap::{App, Arg};
use colored::Colorize;

use crate::logging::Log;

pub fn initialize() -> App<'static, 'static> {
    App::new("Matchstick 🔥")
        .version("0.3.0")
        .author("Limechain <https://limechain.tech>")
        .about("Unit testing framework for Subgraph development on The Graph protocol.")
        .arg(
            Arg::with_name("coverage")
                .help("Generate code coverage report.")
                .long("coverage")
                .short("c")
                .takes_value(false)
                .required(false),
        )
        .arg(
            Arg::with_name("recompile")
                .help("Force-recompiles the tests.")
                .long("recompile")
                .short("r")
                .takes_value(false)
                .required(false),
        )
        .arg(
            Arg::with_name("test_suites")
                .help("Please specify the names of the test suites you would like to run.")
                .index(1)
                .multiple(true),
        )
}

pub fn print_logo() {
    Log::Default(
        r#"
___  ___      _       _         _   _      _
|  \/  |     | |     | |       | | (_)    | |
| .  . | __ _| |_ ___| |__  ___| |_ _  ___| | __
| |\/| |/ _` | __/ __| '_ \/ __| __| |/ __| |/ /
| |  | | (_| | || (__| | | \__ \ |_| | (__|   <
\_|  |_/\__,_|\__\___|_| |_|___/\__|_|\___|_|\_\
    "#
        .bright_red(),
    ).println()
}
