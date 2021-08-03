#[cfg(test)]
mod integration_tests {
    use crate::module_from_path;
    use crate::wasm_instance::WICExtension;
    use indexmap::IndexMap;
    use crate::wasm_instance::STORE;

    #[test]
    fn tests() {
        let module = module_from_path("mocks/Gravity.wasm");
        let mut context = module.instance_ctx.take().take().expect("Couldn't get context from module.");
        let mut store = STORE.lock().expect("Couldn't get store.");
        store.insert("type".to_string(), IndexMap::new());

        assert_eq!(store.len(), 1);

        drop(store);

        context.clear_store().expect("Couldn't clear store");
        let store = STORE.lock().expect("Couldn't get store.");
        assert_eq!(store.len(), 0);
    }
}