use std::{cell::RefCell, sync::Arc, sync::Mutex, time::Instant};
use std::{rc::Rc, time::Duration};
use std::collections::HashMap;
use std::marker::PhantomData;

use anyhow::anyhow;
use colored::*;
use graph::{
    blockchain::{Blockchain, HostFnCtx},
    cheap_clone::CheapClone,
    prelude::{
        anyhow::{self},
        HostMetrics,
    },
};
use graph::data::store::Value;
use graph::prelude::Entity;
use graph::runtime::{asc_get, asc_new, AscPtr, try_asc_get};
use graph_runtime_wasm::{
    error::DeterminismLevel,
    mapping::{MappingContext, ValidModule},
    module::{ExperimentalFeatures, IntoTrap, WasmInstanceContext},
    module::IntoWasmRet,
};
use graph_runtime_wasm::{host_exports::HostExportError, module::stopwatch::TimeoutStopwatch};
use graph_runtime_wasm::asc_abi::class::AscEntity;
use graph_runtime_wasm::asc_abi::class::AscString;
use indexmap::IndexMap;
use lazy_static::lazy_static;

pub enum Level {
    ERROR,
    WARNING,
    INFO,
    DEBUG,
    SUCCESS,
    UNKNOWN,
}

fn level_from_u32(n: u32) -> Level {
    match n {
        1 => Level::ERROR,
        2 => Level::WARNING,
        3 => Level::INFO,
        4 => Level::DEBUG,
        5 => Level::SUCCESS,
        _ => Level::UNKNOWN
    }
}

pub fn get_successful_tests() -> usize {
    let map = TEST_RESULTS.lock().unwrap();
    map.iter().filter(|(_, &v)| v).count()
}

pub fn get_failed_tests() -> usize {
    let map = TEST_RESULTS.lock().unwrap();
    map.iter().filter(|(_, &v)| !v).count()
}

fn styled(s: &str, n: &Level) -> ColoredString {
    match n {
        Level::ERROR => format!("ERROR {}", s).red(),
        Level::WARNING => format!("WARNING {}", s).yellow(),
        Level::INFO => format!("INFO {}", s).normal(),
        Level::DEBUG => format!("DEBUG {}", s).cyan(),
        Level::SUCCESS => format!("SUCCESS {}", s).green(),
        _ => s.normal(),
    }
}

fn fail_test(msg: String) {
    let test_name = TEST_RESULTS.lock().unwrap().keys().last().unwrap().clone();
    TEST_RESULTS.lock().unwrap().insert(test_name, false);
    LOGS.lock().unwrap().insert(msg, Level::ERROR);
}

pub fn flush_logs() -> () {
    let test_results = TEST_RESULTS.lock().unwrap();
    let logs = LOGS.lock().unwrap();

    for (k, v) in logs.iter() {
        // Test name
        if test_results.contains_key(k) {
            let passed = *test_results.get(k).unwrap();
            if passed {
                println!("✅ {}", k.green());
            } else {
                println!("❌ {}", k.red());
            }
        }
        // Normal log
        else {
            println!("{}", styled(k, v));
        }
    }
}

lazy_static! {
    static ref STORE: Mutex<IndexMap<String, IndexMap<String, HashMap<String, Value>>>> =
        Mutex::from(IndexMap::new());
    pub static ref LOGS: Mutex<IndexMap<String, Level>> = Mutex::new(IndexMap::new());
    pub static ref TEST_RESULTS: Mutex<IndexMap<String, bool>> = Mutex::new(IndexMap::new());
}

trait WICExtension {
    fn log(&mut self, level: u32, msg: AscPtr<AscString>) -> Result<(), HostExportError>;
    fn clear_store(&mut self) -> Result<(), HostExportError>;
    fn register_test(&mut self, name: AscPtr<AscString>) -> Result<(), HostExportError>;
    fn assert_field_equals(
        &mut self,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        field_name_ptr: AscPtr<AscString>,
        expected_val_ptr: AscPtr<AscString>,
    ) -> Result<(), HostExportError>;
    fn mock_store_get(
        &mut self,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
    ) -> Result<AscPtr<AscEntity>, HostExportError>;
    fn mock_store_set(
        &mut self,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        data_ptr: AscPtr<AscEntity>,
    ) -> Result<(), HostExportError>;
    fn mock_store_remove(
        &mut self,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
    ) -> Result<(), HostExportError>;
}

impl<C: Blockchain> WICExtension for WasmInstanceContext<C> {
    fn log(&mut self, level: u32, msg: AscPtr<AscString>) -> Result<(), HostExportError> {
        let msg: String = asc_get(self, msg)?;

        match level {
            // CRITICAL (for expected logic errors)
            0 => {
                panic!("{}", msg.red());
            }
            1 => {
                fail_test(msg);
            }
            _ => {
                LOGS.lock().unwrap().insert(msg, level_from_u32(level));
            }
        }

        Ok(())
    }

    fn clear_store(&mut self) -> Result<(), HostExportError> {
        STORE.lock().unwrap().clear();
        Ok(())
    }

    fn register_test(&mut self, name_ptr: AscPtr<AscString>) -> Result<(), HostExportError> {
        let name: String = asc_get(self, name_ptr)?;

        if TEST_RESULTS.lock().unwrap().contains_key(&name) {
            panic!("Test with name '{}' already exists.", name)
        }

        TEST_RESULTS.lock().unwrap().insert(name.clone(), true);
        LOGS.lock().unwrap().insert(name, Level::INFO);

        Ok(())
    }

    fn assert_field_equals(
        &mut self,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        field_name_ptr: AscPtr<AscString>,
        expected_val_ptr: AscPtr<AscString>,
    ) -> Result<(), HostExportError> {
        let entity_type: String = asc_get(self, entity_type_ptr)?;
        let id: String = asc_get(self, id_ptr)?;
        let field_name: String = asc_get(self, field_name_ptr)?;
        let expected_val: String = asc_get(self, expected_val_ptr)?;

        let map = STORE.lock().unwrap();
        if map.contains_key(&entity_type) &&
            map.get(&entity_type).unwrap().contains_key(&id) &&
            map.get(&entity_type).unwrap().get(&id).unwrap().contains_key(&field_name) {
            let val = map.get(&entity_type).unwrap().get(&id).unwrap().get(&field_name).unwrap().to_string();
            if val != expected_val {
                let msg = format!("Expected field '{}' to equal '{}', but was '{}' instead.", &field_name, &expected_val, val);
                fail_test(msg);
            };
            return Ok(());
        }

        Ok(())
    }

    fn mock_store_get(
        &mut self,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
    ) -> Result<AscPtr<AscEntity>, HostExportError> {
        let entity_type: String = asc_get(self, entity_type_ptr)?;
        let id: String = asc_get(self, id_ptr)?;

        let map = STORE.lock().unwrap();

        if !map.contains_key(&entity_type) || !map.get(&entity_type).unwrap().contains_key(&id) {
            let msg = format!("Entity with type '{}' and id '{}' does not exist.", &entity_type, &id);
            fail_test(msg);
        }

        let entity = map.get(&entity_type).unwrap().get(&id).unwrap().clone();
        let entity = Entity::from(entity);

        let res = asc_new(self, &entity.sorted())?;

        Ok(res)
    }

    fn mock_store_set(
        &mut self,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
        data_ptr: AscPtr<AscEntity>,
    ) -> Result<(), HostExportError> {
        let entity_type: String = asc_get(self, entity_type_ptr)?;
        let id: String = asc_get(self, id_ptr)?;
        let data: HashMap<String, Value> = try_asc_get(self, data_ptr)?;

        let mut map = STORE.lock().unwrap();
        let mut inner_map = IndexMap::new();

        // Check if there's already a collection with entities of this type
        if map.contains_key(&entity_type) {
            inner_map = map.get(&entity_type).unwrap().clone();

            if inner_map.contains_key(&id) {
                let msg = format!("Entity with id '{}' already exists.", &id);
                fail_test(msg);
            }
        }

        inner_map.insert(id, data);
        map.insert(entity_type, inner_map);
        Ok(())
    }

    fn mock_store_remove(
        &mut self,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
    ) -> Result<(), HostExportError> {
        let entity_type: String = asc_get(self, entity_type_ptr)?;
        let id: String = asc_get(self, id_ptr)?;

        let mut map = STORE.lock().unwrap();

        if map.contains_key(&entity_type) && map.get(&entity_type).unwrap().contains_key(&id) {
            let mut inner_map = map.get(&entity_type).unwrap().clone();
            inner_map.remove(&id);

            map.insert(entity_type, inner_map);
        } else {
            let msg = format!("Entity with type '{}' and id '{}' does not exist.", &entity_type, &id);
            fail_test(msg);
        }
        Ok(())
    }
}

#[allow(unused)]
pub struct WasmInstance<C: Blockchain> {
    pub instance: wasmtime::Instance,
    instance_ctx: Rc<RefCell<Option<WasmInstanceContext<C>>>>,
    __phantom: PhantomData<C>,
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
        let host_fns = ctx.host_fns.cheap_clone();

        let ctx: Rc<RefCell<Option<MappingContext<C>>>> = Rc::new(RefCell::new(Some(ctx)));

        let timeout_stopwatch = Arc::new(std::sync::Mutex::new(TimeoutStopwatch::start_new()));
        if let Some(timeout) = timeout {
            let interrupt_handle = linker
                .store()
                .interrupt_handle()
                .expect("Could not interrupt handle.");
            let timeout_stopwatch = timeout_stopwatch.clone();
            graph::spawn_allow_panic(async move {
                let minimum_wait = Duration::from_secs(1);
                loop {
                    let duration = *timeout_stopwatch
                        .lock()
                        .expect("Could not unlock timeout stopwatch.");
                    let time_left = timeout.checked_sub(duration.elapsed());
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
                    let ctx = ctx.cheap_clone();
                    linker.func(
                        module,
                        $wasm_name,
                        move |caller: wasmtime::Caller, $($param: u32),*| {
                            let instance = func_shared_ctx.upgrade().expect("Could not get instance.");
                            let mut instance = instance.borrow_mut();

                            if instance.is_none() {
                                *instance = Some(WasmInstanceContext::from_caller(
                                    caller,
                                    ctx.borrow_mut().take().expect("Could not borrow ctx as mutable."),
                                    valid_module.clone(),
                                    host_metrics.clone(),
                                    timeout,
                                    timeout_stopwatch.clone(),
                                    experimental_features.clone()
                                ).expect("Could not generate instance."))
                            }

                            let instance = instance.as_mut().expect("Could not borrow instance as mutable.");
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

        for host_fn in host_fns.iter() {
            let modules = valid_module
                .import_name_to_modules
                .get(host_fn.name)
                .into_iter()
                .flatten();

            for module in modules {
                let func_shared_ctx = Rc::downgrade(&shared_ctx);
                let host_fn = host_fn.cheap_clone();
                linker.func(module, host_fn.name, move |call_ptr: u32| {
                    let start = Instant::now();
                    let instance = func_shared_ctx
                        .upgrade()
                        .expect("Could not upgrade shared context.");
                    let mut instance = instance.borrow_mut();

                    let instance = match &mut *instance {
                        Some(instance) => instance,

                        // Happens when calling a host fn in Wasm start.
                        None => {
                            return Err(anyhow!(
                                "{} is not allowed in global variables",
                                host_fn.name
                            )
                                .into());
                        }
                    };

                    let name_for_metrics = host_fn.name.replace('.', "_");
                    let stopwatch = &instance.host_metrics.stopwatch;
                    let _section =
                        stopwatch.start_section(&format!("host_export_{}", name_for_metrics));

                    let ctx = HostFnCtx {
                        logger: instance.ctx.logger.cheap_clone(),
                        block_ptr: instance.ctx.block_ptr.cheap_clone(),
                        heap: instance,
                    };
                    let ret = (host_fn.func)(ctx, call_ptr).map_err(|e| match e {
                        HostExportError::Deterministic(e) => {
                            instance.deterministic_host_trap = true;
                            e
                        }
                        HostExportError::PossibleReorg(e) => {
                            instance.possible_reorg = true;
                            e
                        }
                        HostExportError::Unknown(e) => e,
                    })?;
                    instance.host_metrics.observe_host_fn_execution_time(
                        start.elapsed().as_secs_f64(),
                        &name_for_metrics,
                    );
                    Ok(ret)
                })?;
            }
        }

        link!("ethereum.encode", ethereum_encode, params_ptr);
        link!("ethereum.decode", ethereum_decode, params_ptr, data_ptr);

        link!("abort", abort, message_ptr, file_name_ptr, line, column);

        link!("clearStore", clear_store,);

        link!(
            "store.get",
            mock_store_get,
            "host_export_store_get",
            entity,
            id
        );
        link!(
            "store.set",
            mock_store_set,
            "host_export_store_set",
            entity,
            id,
            data
        );
        link!(
            "store.remove",
            mock_store_remove,
            "host_export_store_remove",
            entity,
            id
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

        link!("log.log", log, level, msg_ptr);

        link!("registerTest", register_test, name_ptr);

        link!("assert.fieldEquals", assert_field_equals, entity_type_ptr, id_ptr, field_name_ptr, expected_val_ptr);

        link!("arweave.transactionData", arweave_transaction_data, ptr);

        link!("box.profile", box_profile, ptr);

        let instance = linker.instantiate(&valid_module.module)?;

        if shared_ctx.borrow().is_none() {
            *shared_ctx.borrow_mut() = Some(WasmInstanceContext::from_instance(
                &instance,
                ctx.borrow_mut()
                    .take()
                    .expect("Could not borrow context as mutable."),
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
            __phantom: PhantomData::default(),
        })
    }
}
