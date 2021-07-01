use anyhow::anyhow;
use graph::{
    blockchain::{Blockchain, HostFnCtx},
    cheap_clone::CheapClone,
    prelude::{
        anyhow::{self},
        HostMetrics,
    },
};
use graph_runtime_wasm::{
    error::DeterminismLevel,
    mapping::{MappingContext, ValidModule},
    module::IntoWasmRet,
    module::{ExperimentalFeatures, IntoTrap, WasmInstanceContext},
};
use graph_runtime_wasm::{host_exports::HostExportError, module::stopwatch::TimeoutStopwatch};

use graph::runtime::{asc_get, AscPtr};
use graph_runtime_wasm::asc_abi::class::AscString;
use slog::{info, debug, error, warn, Drain};
use slog_term;
use std::marker::PhantomData;
use std::{cell::RefCell, sync::Arc, time::Instant};
use std::{rc::Rc, time::Duration};

trait WICExtension {
    fn log(&mut self, level: u32, msg: AscPtr<AscString>) -> Result<(), HostExportError>;
}

impl<C: Blockchain> WICExtension for WasmInstanceContext<C> {
    fn log(&mut self, level: u32, msg: AscPtr<AscString>) -> Result<(), HostExportError> {
        let plain = slog_term::PlainSyncDecorator::new(std::io::stdout());
        let logger =
            slog::Logger::root(slog_term::FullFormat::new(plain).build().fuse(), slog::o!());

        let msg: String = asc_get(self, msg)?;

        match level {
            // CRITICAL (for expected logic errors)
            0 => {
                panic!("{}", msg);
            }
            // ERROR (for test failure)
            1 => {
                error!(logger, "{}", msg);
            }
            // WARNING
            2 => {
                warn!(logger, "{}", msg);
            }
            // INFO
            3 => {
                info!(logger, "{}", msg);
            }
            // DEBUG
            4 => {
                debug!(logger, "{}", msg);
            }
            _ => unreachable!(),
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
            let interrupt_handle = linker.store().interrupt_handle().unwrap();
            let timeout_stopwatch = timeout_stopwatch.clone();
            graph::spawn_allow_panic(async move {
                let minimum_wait = Duration::from_secs(1);
                loop {
                    let duration = *timeout_stopwatch.lock().unwrap();
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
                    let instance = func_shared_ctx.upgrade().unwrap();
                    let mut instance = instance.borrow_mut();

                    let instance = match &mut *instance {
                        Some(instance) => instance,

                        // Happens when calling a host fn in Wasm start.
                        None => {
                            return Err(anyhow!(
                                "{} is not allowed in global variables",
                                host_fn.name
                            )
                            .into())
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

        link!("store.get", store_get, "host_export_store_get", entity, id);
        link!(
            "store.set",
            store_set,
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
            __phantom: PhantomData::default(),
        })
    }
}
