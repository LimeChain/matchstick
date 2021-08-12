use std::cell::RefCell;
use std::collections::HashMap;
use std::rc::Rc;
use std::sync::Mutex;
use std::time::Instant;

use colored::*;
use ethabi::{Address, Token};
use graph::data::store::Value;
use graph::prelude::{Entity, Arc, Duration, anyhow, HostMetrics, anyhow::Context};
use graph::runtime::{asc_get, asc_new, try_asc_get, AscPtr};
use graph::semver::Version;
use graph::{
    blockchain::{Blockchain, HostFnCtx},
    cheap_clone::CheapClone
};
use graph_chain_ethereum::runtime::abi::AscUnresolvedContractCall_0_0_4;
use graph_chain_ethereum::runtime::runtime_adapter::UnresolvedContractCall;
use graph_runtime_wasm::asc_abi::class::{Array, AscEntity, AscEnum, AscString};
use graph_runtime_wasm::asc_abi::class::{AscEnumArray, EthereumValueKind};
pub use graph_runtime_wasm::WasmInstance;
use graph_runtime_wasm::{
    error::DeterminismLevel,
    mapping::{MappingContext, ValidModule},
    module::{ExperimentalFeatures, IntoTrap, WasmInstanceContext, IntoWasmRet},
};
use graph_runtime_wasm::{host_exports::HostExportError, module::stopwatch::TimeoutStopwatch};
use indexmap::IndexMap;
use lazy_static::lazy_static;

type Store = Mutex<IndexMap<String, IndexMap<String, HashMap<String, Value>>>>;

lazy_static! {
    pub(crate) static ref FUNCTIONS_MAP: Mutex<IndexMap<String, Vec<Token>>> =
        Mutex::new(IndexMap::new());
    pub(crate) static ref STORE: Store = Mutex::from(IndexMap::new());
    pub(crate) static ref LOGS: Mutex<IndexMap<String, Level>> = Mutex::new(IndexMap::new());
    pub(crate) static ref TEST_RESULTS: Mutex<IndexMap<String, bool>> = Mutex::new(IndexMap::new());
    static ref REVERTS_IDENTIFIER: Vec<Token> =
        vec!(Token::Bytes(vec!(255, 255, 255, 255, 255, 255, 255)));
}

pub enum Level {
    Error,
    Warning,
    Info,
    Debug,
    Success,
    Unknown,
}

fn level_from_u32(n: u32) -> Level {
    match n {
        1 => Level::Error,
        2 => Level::Warning,
        3 => Level::Info,
        4 => Level::Debug,
        5 => Level::Success,
        _ => Level::Unknown,
    }
}

pub fn get_successful_tests() -> usize {
    let map = TEST_RESULTS.lock().expect("Cannot access TEST_RESULTS.");
    map.iter().filter(|(_, &v)| v).count()
}

pub fn get_failed_tests() -> usize {
    let map = TEST_RESULTS.lock().expect("Cannot access TEST_RESULTS.");
    map.iter().filter(|(_, &v)| !v).count()
}

#[cfg(test)]
pub fn clear_pub_static_refs() {
    STORE.lock().expect("Couldn't get STORE.").clear();
    LOGS.lock().expect("Couldn't get LOGS.").clear();
    TEST_RESULTS
        .lock()
        .expect("Couldn't get TEST_RESULTS.")
        .clear();
    FUNCTIONS_MAP
        .lock()
        .expect("Couldn't get FUNCTIONS_MAP.")
        .clear();
}

fn styled(s: &str, n: &Level) -> ColoredString {
    match n {
        Level::Error => format!("ERROR {}", s).red(),
        Level::Warning => format!("WARNING {}", s).yellow(),
        Level::Info => format!("INFO {}", s).normal(),
        Level::Debug => format!("DEBUG {}", s).cyan(),
        Level::Success => format!("SUCCESS {}", s).green(),
        _ => s.normal(),
    }
}

pub fn fail_test(msg: String) {
    let test_name = TEST_RESULTS
        .lock()
        .expect("Cannot access TEST_RESULTS.")
        .keys()
        .last()
        .unwrap()
        .clone();
    TEST_RESULTS
        .lock()
        .expect("Cannot access TEST_RESULTS.")
        .insert(test_name, false);
    LOGS.lock()
        .expect("Cannot access LOGS.")
        .insert(msg, Level::Error);
}

pub fn flush_logs() {
    let test_results = TEST_RESULTS.lock().expect("Cannot access TEST_RESULTS.");
    let logs = LOGS.lock().expect("Cannot access LOGS.");

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

pub trait WasmInstanceExtension<C: graph::blockchain::Blockchain> {
    fn from_valid_module_with_ctx(
        valid_module: Arc<ValidModule>,
        ctx: MappingContext<C>,
        host_metrics: Arc<HostMetrics>,
        timeout: Option<Duration>,
        experimental_features: ExperimentalFeatures,
    ) -> Result<WasmInstance<C>, anyhow::Error>;
}

pub trait WICExtension {
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
    fn assert_equals(&mut self, expected_ptr: u32, actual_ptr: u32) -> Result<(), HostExportError>;
    fn assert_not_in_store(
        &mut self,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
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
    fn ethereum_call(
        &mut self,
        contract_call_ptr: u32,
    ) -> Result<AscEnumArray<EthereumValueKind>, HostExportError>;
    fn mock_function(
        &mut self,
        contract_address_ptr: u32,
        fn_name_ptr: AscPtr<AscString>,
        fn_signature_ptr: AscPtr<AscString>,
        fn_args_ptr: u32,
        return_value_ptr: u32,
        reverts: u32,
    ) -> Result<(), HostExportError>;
}

impl<C: Blockchain> WICExtension for WasmInstanceContext<C> {
    fn log(&mut self, level: u32, msg: AscPtr<AscString>) -> Result<(), HostExportError> {
        let msg: String = asc_get(self, msg)?;

        match level {
            // CRITICAL (for expected logic errors)
            0 => {
                panic!("❌ ❌ ❌ {}", msg.red());
            }
            1 => {
                fail_test(msg);
            }
            _ => {
                LOGS.lock()
                    .expect("Cannot access LOGS.")
                    .insert(msg, level_from_u32(level));
            }
        }

        Ok(())
    }

    fn clear_store(&mut self) -> Result<(), HostExportError> {
        STORE.lock().expect("Cannot access STORE.").clear();
        Ok(())
    }

    fn register_test(&mut self, name_ptr: AscPtr<AscString>) -> Result<(), HostExportError> {
        let name: String = asc_get(self, name_ptr)?;

        if TEST_RESULTS
            .lock()
            .expect("Cannot access TEST_RESULTS.")
            .contains_key(&name)
        {
            let msg = format!("❌ ❌ ❌  Test with name '{}' already exists.", name).red();
            panic!("{}", msg);
        }

        TEST_RESULTS
            .lock()
            .expect("Cannot access TEST_RESULTS.")
            .insert(name.clone(), true);
        LOGS.lock()
            .expect("Cannot access LOGS.")
            .insert(name, Level::Info);

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

        let map = STORE.lock().expect("Cannot access STORE.");
        if !map.contains_key(&entity_type) {
            let msg = format!(
                "(assert.fieldEquals) No entities with type '{}' found.",
                &entity_type
            );
            fail_test(msg);
            return Ok(());
        }

        let entities = map.get(&entity_type).unwrap();
        if !entities.contains_key(&id) {
            let msg = format!(
                "(assert.fieldEquals) No entity with type '{}' and id '{}' found.",
                &entity_type, &id
            );
            fail_test(msg);
            return Ok(());
        }

        let entity = entities.get(&id).unwrap();
        if !entity.contains_key(&field_name) {
            let msg = format!(
                "(assert.fieldEquals) No field named '{}' on entity with type '{}' and id '{}' found.",
                &field_name, &entity_type, &id
            );
            fail_test(msg);
            return Ok(());
        }

        let val = entity.get(&field_name).unwrap();
        if val.to_string() != expected_val {
            let msg = format!(
                "(assert.fieldEquals) Expected field '{}' to equal '{}', but was '{}' instead.",
                &field_name, &expected_val, val
            );
            fail_test(msg);
            return Ok(());
        };

        Ok(())
    }

    fn assert_equals(&mut self, expected_ptr: u32, actual_ptr: u32) -> Result<(), HostExportError> {
        let expected: Token =
            asc_get::<_, AscEnum<EthereumValueKind>, _>(self, expected_ptr.into())?;
        let actual: Token = asc_get::<_, AscEnum<EthereumValueKind>, _>(self, actual_ptr.into())?;
        if expected != actual {
            let msg = format!(
                "Expected value was '{:?}' but actual value was '{:?}'",
                expected, actual
            );
            fail_test(msg);
        }
        Ok(())
    }

    fn assert_not_in_store(
        &mut self,
        entity_type_ptr: AscPtr<AscString>,
        id_ptr: AscPtr<AscString>,
    ) -> Result<(), HostExportError> {
        let entity_type: String = asc_get(self, entity_type_ptr)?;
        let id: String = asc_get(self, id_ptr)?;

        let map = STORE.lock().expect("Cannot access STORE.");

        if map.contains_key(&entity_type) && map.get(&entity_type).unwrap().contains_key(&id) {
            let msg = format!(
                "Value for entity type: '{}' and id: '{}' was found in store.",
                entity_type, id
            );
            fail_test(msg);
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

        let map = STORE.lock().expect("Cannot access STORE.");

        if map.contains_key(&entity_type) && map.get(&entity_type).unwrap().contains_key(&id) {
            let entities = map.get(&entity_type).unwrap();
            let entity = entities.get(&id).unwrap().clone();
            let entity = Entity::from(entity);

            let res = asc_new(self, &entity.sorted())?;
            return Ok(res);
        }

        Ok(AscPtr::null())
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

        let mut map = STORE.lock().expect("Cannot get STORE.");
        let mut inner_map = if map.contains_key(&entity_type) {
            map.get(&entity_type).unwrap().clone()
        } else {
            IndexMap::new()
        };

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
            let msg = format!(
                "(store.remove) Entity with type '{}' and id '{}' does not exist. Problem originated from store.remove()",
                &entity_type, &id
            );
            fail_test(msg);
            return Ok(());
        }
        Ok(())
    }

    fn ethereum_call(
        &mut self,
        contract_call_ptr: u32,
    ) -> Result<AscEnumArray<EthereumValueKind>, HostExportError> {
        let call: UnresolvedContractCall =
            asc_get::<_, AscUnresolvedContractCall_0_0_4, _>(self, contract_call_ptr.into())?;

        let unique_fn_string = create_unique_fn_string(
            &call.contract_address.to_string(),
            &call.function_name,
            &call
                .function_signature
                .expect("Couldn't get function signature."),
            call.function_args,
        );
        let map = FUNCTIONS_MAP.lock().expect("Couldn't get map.");
        let return_val;
        if map.contains_key(&unique_fn_string) {
            if *map.get(&unique_fn_string).unwrap() == REVERTS_IDENTIFIER.clone() {
                return Ok(AscPtr::null());
            }

            return_val = asc_new(
                self,
                map.get(&unique_fn_string)
                    .expect("Couldn't get value from map.")
                    .as_slice(),
            )?;

            Ok(return_val)
        } else {
            panic!(
                "Key: '{}' not found in map. Please mock the function before calling it.",
                &unique_fn_string
            );
        }
    }

    fn mock_function(
        &mut self,
        contract_address_ptr: u32,
        fn_name_ptr: AscPtr<AscString>,
        fn_signature_ptr: AscPtr<AscString>,
        fn_args_ptr: u32,
        return_value_ptr: u32,
        reverts: u32,
    ) -> Result<(), HostExportError> {
        let contract_address: Address = asc_get(self, contract_address_ptr.into())?;
        let fn_name: String = asc_get(self, fn_name_ptr)?;
        let fn_signature: String = asc_get(self, fn_signature_ptr)?;
        let fn_args: Vec<Token> =
            asc_get::<_, Array<AscPtr<AscEnum<EthereumValueKind>>>, _>(self, fn_args_ptr.into())?;
        let return_value: Vec<Token> = asc_get::<_, Array<AscPtr<AscEnum<EthereumValueKind>>>, _>(
            self,
            return_value_ptr.into(),
        )?;

        let unique_fn_string = create_unique_fn_string(
            &contract_address.to_string(),
            &fn_name,
            &fn_signature,
            fn_args,
        );
        let mut map = FUNCTIONS_MAP.lock().expect("Couldn't get map.");

        if reverts == 1 {
            map.insert(unique_fn_string, REVERTS_IDENTIFIER.clone());
        } else {
            map.insert(unique_fn_string, return_value);
        }

        Ok(())
    }
}

fn create_unique_fn_string(
    contract_address: &str,
    fn_name: &str,
    fn_signature: &str,
    fn_args: Vec<Token>,
) -> String {
    let mut unique_fn_string = String::from(contract_address) + fn_name + fn_signature;
    for element in fn_args.iter() {
        unique_fn_string += &element.to_string();
    }
    unique_fn_string
}

impl<C: Blockchain> WasmInstanceExtension<C> for WasmInstance<C> {
    fn from_valid_module_with_ctx(
        valid_module: Arc<ValidModule>,
        ctx: MappingContext<C>,
        host_metrics: Arc<HostMetrics>,
        timeout: Option<Duration>,
        experimental_features: ExperimentalFeatures,
    ) -> Result<WasmInstance<C>, anyhow::Error> {
        let mut linker = wasmtime::Linker::new(&wasmtime::Store::new(valid_module.module.engine()));
        let host_fns = ctx.host_fns.cheap_clone();
        let api_version = ctx.host_exports.api_version.clone();

        let shared_ctx: Rc<RefCell<Option<WasmInstanceContext<C>>>> = Rc::new(RefCell::new(None));
        let ctx: Rc<RefCell<Option<MappingContext<C>>>> = Rc::new(RefCell::new(Some(ctx)));

        let timeout_stopwatch = Arc::new(std::sync::Mutex::new(TimeoutStopwatch::start_new()));
        if let Some(timeout) = timeout {
            let interrupt_handle = linker
                .store()
                .interrupt_handle()
                .expect("Could not get interrupt_handle.");
            let timeout_stopwatch = timeout_stopwatch.clone();
            graph::spawn_allow_panic(async move {
                let minimum_wait = Duration::from_secs(1);
                loop {
                    let time_left = timeout.checked_sub(
                        timeout_stopwatch
                            .lock()
                            .expect("Could not get timeout.checked_sub")
                            .elapsed(),
                    );
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
                    let valid_module = valid_module.cheap_clone();
                    let host_metrics = host_metrics.cheap_clone();
                    let timeout_stopwatch = timeout_stopwatch.cheap_clone();
                    let ctx = ctx.cheap_clone();
                    linker.func(
                        module,
                        $wasm_name,
                        move |caller: wasmtime::Caller, $($param: u32),*| {
                            let instance = func_shared_ctx.upgrade().expect("Could not upgrade instance.");
                            let mut instance = instance.borrow_mut();

                            if instance.is_none() {
                                *instance = Some(WasmInstanceContext::from_caller(
                                    caller,
                                    ctx.borrow_mut().take().expect("Could not take ctx as a mutable borrow."),
                                    valid_module.cheap_clone(),
                                    host_metrics.cheap_clone(),
                                    timeout,
                                    timeout_stopwatch.cheap_clone(),
                                    experimental_features.clone()
                                ).expect("Could not get instance."))
                            }

                            let instance = instance.as_mut().expect("Could not get instance.");
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
                                        DeterminismLevel::PossibleReorg => {
                                            instance.possible_reorg = true;
                                        },
                                        DeterminismLevel::Unimplemented | DeterminismLevel::NonDeterministic => {},
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
                    let instance = func_shared_ctx.upgrade().expect("Could not get instance.");
                    let mut instance = instance.borrow_mut();

                    let instance = match &mut *instance {
                        Some(instance) => instance,

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

        link!("ethereum.call", ethereum_call, contract_call_ptr);
        link!("ethereum.encode", ethereum_encode, params_ptr);
        link!("ethereum.decode", ethereum_decode, params_ptr, data_ptr);

        link!("abort", abort, message_ptr, file_name_ptr, line, column);

        link!(
            "mockFunction",
            mock_function,
            contract_address_ptr,
            fn_name_ptr,
            fn_signature_ptr,
            fn_args_ptr,
            return_value_ptr,
            reverts
        );

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

        link!("store.remove", mock_store_remove, entity_ptr, id_ptr);

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

        link!(
            "assert.fieldEquals",
            assert_field_equals,
            entity_type_ptr,
            id_ptr,
            field_name_ptr,
            expected_val_ptr
        );

        if api_version <= Version::new(0, 0, 4) {
            link!("arweave.transactionData", arweave_transaction_data, ptr);
            link!("box.profile", box_profile, ptr);
        }
        link!("assert.equals", assert_equals, expected_ptr, actual_ptr);
        link!(
            "assert.notInStore",
            assert_not_in_store,
            entity_type_ptr,
            id_ptr
        );

        let instance = linker.instantiate(&valid_module.module)?;

        if shared_ctx.borrow().is_none() {
            *shared_ctx.borrow_mut() = Some(WasmInstanceContext::from_instance(
                &instance,
                ctx.borrow_mut()
                    .take()
                    .expect("Could not take ctx as a mutable borrow."),
                valid_module,
                host_metrics,
                timeout,
                timeout_stopwatch,
                experimental_features,
            )?);
        }

        match api_version {
            version if version <= Version::new(0, 0, 4) => {}
            _ => {
                instance
                    .get_func("_start")
                    .context("`_start` function not found")?
                    .typed::<(), ()>()?
                    .call(())
                    .expect("Could not call instance.");
            }
        }

        Ok(WasmInstance {
            instance,
            instance_ctx: shared_ctx,
        })
    }
}
