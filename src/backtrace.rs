use regex::Regex;
use std::fs::File;
use std::io::{BufRead, BufReader};

pub fn parse_backtrace(logs: &str) -> (String, i32) {
    let test_path_regex = Regex::new(r#"<unknown>!start:(.*)~anonymous\|(\d)"#).unwrap();
    let matches = test_path_regex.captures(logs).unwrap();
    let test_id = matches[2].parse::<i32>().unwrap();
    let path = format!("{}.ts", &matches[1]);

    (path, test_id)
}

pub fn get_test_line(file_path: &str, test_id: i32) -> i32 {
    let mut line_number = 1;
    let mut id = 0;

    let tests = File::open(file_path).unwrap();
    let reader = BufReader::new(tests);

    for line in reader.lines() {
        let line_as_string = line.as_ref().unwrap();
        if line_as_string.contains("test(") {
            if id == test_id {
                break;
            }
            id += 1;
        }
        line_number += 1;
    }

    line_number
}

#[cfg(test)]
mod backtrace_tests {
    use super::*;

    #[test]
    fn it_returns_the_path_and_function_id() {
        let backtrace = r#"🛠 Mapping aborted at ~lib/matchstick-as/assembly/assert.ts, line 13, column 7, with message: Assertion Error
                        wasm backtrace:
                        0: 0x2469 - <unknown>!~lib/matchstick-as/assembly/assert/assert.fieldEquals
                        1: 0x2806 - <unknown>!start:mocks/as/mock-includes.test~anonymous|5"#;

        println!("{}", backtrace);

        let (file_path, test_id) = parse_backtrace(backtrace);

        assert_eq!(file_path, "mocks/as/mock-includes.test.ts");
        assert_eq!(test_id, 5);
    }

    #[test]
    fn it_returns_the_test_line() {
        let file_path = "mocks/as/mock-includes.test.ts";
        let test_id = 5;

        let line_number = get_test_line(&file_path, test_id);

        assert_eq!(line_number, 16);
    }
}
