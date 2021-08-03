#[cfg(test)]
mod integration_tests {
    use crate::module_from_path;

    #[test]
    fn tests() {
        let _module = module_from_path("mocks/Gravity.wasm");
    }
}