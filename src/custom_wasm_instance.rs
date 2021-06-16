use anyhow::anyhow;
use graph::{
    blockchain::Blockchain,
    prelude::{
        anyhow::{self},
        serde_yaml::Index,
        HostMetrics,
    },
    runtime::{self, asc_get, AscPtr},
    semver::Version,
};
use graph_runtime_wasm::{
    asc_abi::{self, class::AscString},
    error::DeterminismLevel,
    mapping::{MappingContext, ValidModule},
    module::IntoWasmRet,
    module::{ExperimentalFeatures, IntoTrap, WasmInstanceContext},
};
use graph_runtime_wasm::{host_exports::HostExportError, module::stopwatch::TimeoutStopwatch};
use indexmap::IndexMap;
use serde_json::json;
use slog::{info, Drain};
use slog_term;
use state::LocalStorage;
use std::{
    cell::RefCell,
    sync::{Arc, Mutex},
    time::Instant,
};
use std::{rc::Rc, time::Duration};

pub static mut MOCK_STORE_GLOBAL: LocalStorage<String> = LocalStorage::new();

lazy_static::lazy_static! {
    static ref MOCK_STORE_LOCAL: Mutex<IndexMap<String, IndexMap<String, String>>> = Mutex::from(IndexMap::new());
}

fn get_inner_json(s: String) -> String {
    let i = s.find(':').unwrap();
    let f = s.rfind("}").unwrap();
    String::from(&s[i + 1..f + 1])
}

fn get_type(s: String) -> String {
    let v: Vec<&str> = s.split(':').collect();
    String::from(*v.get(0).unwrap())
}

trait WICExtension {
    fn mock_store_set(
        &mut self,
        entity_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        data_ptr: AscPtr<asc_abi::class::AscEntity>,
    ) -> Result<(), HostExportError>;

    fn mock_store_set_initial_value(
        &mut self,
        json_ptr: AscPtr<AscString>,
    ) -> Result<(), HostExportError>;

    fn mock_store_assert_field_eq(
        &mut self,
        type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        name_ptr: AscPtr<AscString>,
        val_ptr: AscPtr<AscString>,
    ) -> Result<(), HostExportError>;
}

impl<C: Blockchain> WICExtension for WasmInstanceContext<C> {
    fn mock_store_assert_field_eq(
        &mut self,
        type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        name_ptr: AscPtr<AscString>,
        val_ptr: AscPtr<AscString>,
    ) -> Result<(), HostExportError> {
        let plain = slog_term::PlainSyncDecorator::new(std::io::stdout());
        let logger =
            slog::Logger::root(slog_term::FullFormat::new(plain).build().fuse(), slog::o!());

        let e_type: String = asc_get(self, type_ptr)?;
        let id: String = asc_get(self, id_ptr)?;
        let name: String = asc_get(self, name_ptr)?;
        let expected_val: String = asc_get(self, val_ptr)?;

        let map = MOCK_STORE_LOCAL.lock().unwrap().clone();

        let entity_json = json!(map);

        let entity_inner_json = entity_json.get(format!("\"{}\"", e_type)).unwrap();

        let value = entity_inner_json
            .get(&id)
            .unwrap()
            .to_string()
            .replace("\\", "");

        let value = get_inner_json(value);

        let value: serde_json::Value = serde_json::from_str(&value).unwrap();

        let value: &str = value.get(&name).and_then(|value| value.as_str()).unwrap();

        if &value == &expected_val {
            info!(
                logger,
                "Test passed! Field '{}' on Entity with id '{}' equals '{}'.",
                &name,
                &id,
                &expected_val
            );
        } else {
            info!(
                logger,
                "Test failed! Field '{}' on Entity with id '{}' equals '{}', instead of expected '{}'.", &name, &id, &value, &expected_val
            );
        }
        Ok(())
    }

    fn mock_store_set(
        &mut self,
        entity_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        _data_ptr: AscPtr<asc_abi::class::AscEntity>,
    ) -> Result<(), HostExportError> {
        let entity: String = asc_get(self, entity_ptr)?;
        let id: String = asc_get(self, id_ptr)?;

        let entity_type = get_type(entity.clone());

        let mut current: IndexMap<String, String> = IndexMap::new();

        if MOCK_STORE_LOCAL.lock().unwrap().contains_key(&entity_type) {
            current = MOCK_STORE_LOCAL
                .lock()
                .unwrap()
                .get(&entity_type)
                .unwrap()
                .clone();
        }

        current.insert(id, entity);
        MOCK_STORE_LOCAL
            .lock()
            .unwrap()
            .insert(entity_type, current);

        let mock_store_clone: IndexMap<String, IndexMap<String, String>> =
            IndexMap::from(MOCK_STORE_LOCAL.lock().unwrap().clone());

        unsafe { MOCK_STORE_GLOBAL = LocalStorage::new() };
        unsafe { MOCK_STORE_GLOBAL.set(move || serde_json::to_string(&mock_store_clone).unwrap()) };
        Ok(())
    }

    fn mock_store_set_initial_value(
        &mut self,
        json_ptr: AscPtr<AscString>,
    ) -> Result<(), HostExportError> {
        let json: String = asc_get(self, json_ptr)?;
        let mut map: IndexMap<String, String> = IndexMap::new();
        map.insert("test_value".to_string(), json);

        MOCK_STORE_LOCAL
            .lock()
            .unwrap()
            .insert("InitialValue".to_string(), map);

        let mock_store_clone: IndexMap<String, IndexMap<String, String>> =
            IndexMap::from(MOCK_STORE_LOCAL.lock().unwrap().clone());

        unsafe { MOCK_STORE_GLOBAL = LocalStorage::new() };
        unsafe { MOCK_STORE_GLOBAL.set(move || serde_json::to_string(&mock_store_clone).unwrap()) };
        Ok(())
    }
}

#[allow(dead_code)]
pub struct WasmInstance<C: Blockchain> {
    pub instance: wasmtime::Instance,
    instance_ctx: Rc<RefCell<Option<WasmInstanceContext<C>>>>,
}

impl<C: Blockchain> WasmInstance<C> {
    pub fn from_valid_module_with_ctx(
        valid_module: Arc<ValidModule>,
        ctx: MappingContext<C>,
        host_metrics: Arc<HostMetrics>,
        timeout: Option<Duration>,
        experimental_features: ExperimentalFeatures,
    ) -> Result<WasmInstance<C>, anyhow::Error> {
        let mut linker = wasmtime::Linker::new(&wasmtime::Store::new(valid_module.module.engine()));

        let shared_ctx: Rc<RefCell<Option<WasmInstanceContext<C>>>> = Rc::new(RefCell::new(None));
        let ctx: Rc<RefCell<Option<MappingContext<C>>>> = Rc::new(RefCell::new(Some(ctx)));
        let timeout_stopwatch = Arc::new(std::sync::Mutex::new(TimeoutStopwatch::start_new()));
        if let Some(timeout) = timeout {
            let interrupt_handle = linker.store().interrupt_handle().unwrap();
            let timeout_stopwatch = timeout_stopwatch.clone();
            graph::spawn_allow_panic(async move {
                let minimum_wait = Duration::from_secs(1);
                loop {
                    let time_left =
                        timeout.checked_sub(timeout_stopwatch.lock().unwrap().elapsed());
                    match time_left {
                        None => break interrupt_handle.interrupt(), // Timed out.

                        Some(time) if time < minimum_wait => break interrupt_handle.interrupt(),
                        Some(time) => tokio::time::delay_for(time).await,
                    }
                }
            });
        }

        macro_rules! link {
            ($wasm_name:expr, $rust_name:ident, $($param:ident),*) => {
                link!($wasm_name, $rust_name, "host_export_other", $($param),*)
            };

            ($wasm_name:expr, $rust_name:ident, $section:expr, $($param:ident),*) => {
                let modules = valid_module
                    .import_name_to_modules
                    .get($wasm_name)
                    .into_iter()
                    .flatten();

                for module in modules {
                    let func_shared_ctx = Rc::downgrade(&shared_ctx);
                    let valid_module = valid_module.clone();
                    let host_metrics = host_metrics.clone();
                    let timeout_stopwatch = timeout_stopwatch.clone();
                    let ctx = ctx.clone();
                    linker.func(
                        module,
                        $wasm_name,
                        move |caller: wasmtime::Caller, $($param: u32),*| {
                            let instance = func_shared_ctx.upgrade().unwrap();
                            let mut instance = instance.borrow_mut();

                            if instance.is_none() {
                                *instance = Some(WasmInstanceContext::from_caller(
                                    caller,
                                    ctx.borrow_mut().take().unwrap(),
                                    valid_module.clone(),
                                    host_metrics.clone(),
                                    timeout,
                                    timeout_stopwatch.clone(),
                                    experimental_features.clone()
                                ).unwrap())
                            }

                            let instance = instance.as_mut().unwrap();
                            let _section = instance.host_metrics.stopwatch.start_section($section);

                            let result = instance.$rust_name(
                                $($param.into()),*
                            );
                            match result {
                                Ok(result) => Ok(result.into_wasm_ret()),
                                Err(e) => {
                                    match IntoTrap::determinism_level(&e) {
                                        DeterminismLevel::Deterministic => {
                                            instance.deterministic_host_trap = true;
                                        },
                                        _ => {},
                                    }
                                    Err(IntoTrap::into_trap(e))
                                }
                            }
                        }
                    )?;
                }
            };
        }

        let modules = valid_module
            .import_name_to_modules
            .get("ethereum.call")
            .into_iter()
            .flatten();

        for module in modules {
            let func_shared_ctx = Rc::downgrade(&shared_ctx);
            linker.func(module, "ethereum.call", move |call_ptr: u32| {
                let start = Instant::now();
                let instance = func_shared_ctx.upgrade().unwrap();
                let mut instance = instance.borrow_mut();

                let instance = match &mut *instance {
                    Some(instance) => instance,

                    None => {
                        return Err(
                            anyhow!("ethereum.call is not allowed in global variables").into()
                        )
                    }
                };

                let stopwatch = &instance.host_metrics.stopwatch;
                let _section = stopwatch.start_section("host_export_ethereum_call");

                let arg = if instance.ctx.host_exports.api_version >= Version::new(0, 0, 4) {
                    runtime::asc_get::<_, asc_abi::class::AscUnresolvedContractCall_0_0_4, _>(
                        instance,
                        call_ptr.into(),
                    )
                } else {
                    runtime::asc_get::<_, asc_abi::class::AscUnresolvedContractCall, _>(
                        instance,
                        call_ptr.into(),
                    )
                }
                .map_err(|e| {
                    instance.deterministic_host_trap = true;
                    e.0
                })?;

                let ret = instance
                    .ethereum_call(arg)
                    .map_err(|e| match e {
                        HostExportError::Deterministic(e) => {
                            instance.deterministic_host_trap = true;
                            e
                        }
                        HostExportError::Unknown(e) => e,
                    })?
                    .wasm_ptr();
                instance
                    .host_metrics
                    .observe_host_fn_execution_time(start.elapsed().as_secs_f64(), "ethereum_call");
                Ok(ret)
            })?;
        }

        link!("ethereum.encode", ethereum_encode, params_ptr);
        link!("ethereum.decode", ethereum_decode, params_ptr, data_ptr);

        link!("abort", abort, message_ptr, file_name_ptr, line, column);

        link!("store.get", store_get, "host_export_store_get", entity, id);
        link!(
            "store.set",
            mock_store_set,
            "host_export_store_set",
            entity,
            id,
            data
        );

        link!(
            "store.assertFieldEq",
            mock_store_assert_field_eq,
            "host_export_store_assert_field_eq",
            e_type,
            id,
            name,
            value
        );

        link!(
            "store.setInitialValue",
            mock_store_set_initial_value,
            "host_export_store_set_initial_value",
            json
        );

        link!("ipfs.cat", ipfs_cat, "host_export_ipfs_cat", hash_ptr);
        link!(
            "ipfs.map",
            ipfs_map,
            "host_export_ipfs_map",
            link_ptr,
            callback,
            user_data,
            flags
        );

        link!("store.remove", store_remove, entity_ptr, id_ptr);

        link!("typeConversion.bytesToString", bytes_to_string, ptr);
        link!("typeConversion.bytesToHex", bytes_to_hex, ptr);
        link!("typeConversion.bigIntToString", big_int_to_string, ptr);
        link!("typeConversion.bigIntToHex", big_int_to_hex, ptr);
        link!("typeConversion.stringToH160", string_to_h160, ptr);
        link!("typeConversion.bytesToBase58", bytes_to_base58, ptr);

        link!("json.fromBytes", json_from_bytes, ptr);
        link!("json.try_fromBytes", json_try_from_bytes, ptr);
        link!("json.toI64", json_to_i64, ptr);
        link!("json.toU64", json_to_u64, ptr);
        link!("json.toF64", json_to_f64, ptr);
        link!("json.toBigInt", json_to_big_int, ptr);

        link!("crypto.keccak256", crypto_keccak_256, ptr);

        link!("bigInt.plus", big_int_plus, x_ptr, y_ptr);
        link!("bigInt.minus", big_int_minus, x_ptr, y_ptr);
        link!("bigInt.times", big_int_times, x_ptr, y_ptr);
        link!("bigInt.dividedBy", big_int_divided_by, x_ptr, y_ptr);
        link!("bigInt.dividedByDecimal", big_int_divided_by_decimal, x, y);
        link!("bigInt.mod", big_int_mod, x_ptr, y_ptr);
        link!("bigInt.pow", big_int_pow, x_ptr, exp);
        link!("bigInt.fromString", big_int_from_string, ptr);
        link!("bigInt.bitOr", big_int_bit_or, x_ptr, y_ptr);
        link!("bigInt.bitAnd", big_int_bit_and, x_ptr, y_ptr);
        link!("bigInt.leftShift", big_int_left_shift, x_ptr, bits);
        link!("bigInt.rightShift", big_int_right_shift, x_ptr, bits);

        link!("bigDecimal.toString", big_decimal_to_string, ptr);
        link!("bigDecimal.fromString", big_decimal_from_string, ptr);
        link!("bigDecimal.plus", big_decimal_plus, x_ptr, y_ptr);
        link!("bigDecimal.minus", big_decimal_minus, x_ptr, y_ptr);
        link!("bigDecimal.times", big_decimal_times, x_ptr, y_ptr);
        link!("bigDecimal.dividedBy", big_decimal_divided_by, x, y);
        link!("bigDecimal.equals", big_decimal_equals, x_ptr, y_ptr);

        link!("dataSource.create", data_source_create, name, params);
        link!(
            "dataSource.createWithContext",
            data_source_create_with_context,
            name,
            params,
            context
        );
        link!("dataSource.address", data_source_address,);
        link!("dataSource.network", data_source_network,);
        link!("dataSource.context", data_source_context,);

        link!("ens.nameByHash", ens_name_by_hash, ptr);

        link!("log.log", log_log, level, msg_ptr);

        link!("arweave.transactionData", arweave_transaction_data, ptr);

        link!("box.profile", box_profile, ptr);

        let instance = linker.instantiate(&valid_module.module)?;

        if shared_ctx.borrow().is_none() {
            *shared_ctx.borrow_mut() = Some(WasmInstanceContext::from_instance(
                &instance,
                ctx.borrow_mut().take().unwrap(),
                valid_module,
                host_metrics,
                timeout,
                timeout_stopwatch,
                experimental_features,
            )?);
        }

        Ok(WasmInstance {
            instance,
            instance_ctx: shared_ctx,
        })
    }
}
