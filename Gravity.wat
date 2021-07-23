(module
  (type (;0;) (func))
  (type (;1;) (func (param i32) (result i32)))
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func (param i32 i32 i32 i32)))
  (type (;4;) (func (param i32 i32 i32)))
  (type (;5;) (func (param i32)))
  (type (;6;) (func (param i32 i32 i32) (result i32)))
  (type (;7;) (func (param i32 i32)))
  (type (;8;) (func (param i32 i32 i32 i32 i32)))
  (type (;9;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;10;) (func (result i32)))
  (import "index" "typeConversion.stringToH160" (func $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160 (type 1)))
  (import "env" "abort" (func $~lib/env/abort (type 3)))
  (import "index" "typeConversion.bigIntToString" (func $~lib/@graphprotocol/graph-ts/index/typeConversion.bigIntToString (type 1)))
  (import "index" "store.set" (func $~lib/@graphprotocol/graph-ts/index/store.set (type 4)))
  (import "index" "typeConversion.bigIntToHex" (func $~lib/@graphprotocol/graph-ts/index/typeConversion.bigIntToHex (type 1)))
  (import "index" "store.get" (func $~lib/@graphprotocol/graph-ts/index/store.get (type 2)))
  (import "ethereum" "ethereum.call" (func $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.call (type 1)))
  (import "log" "log.log" (func $~lib/subtest-as/assembly/log/log.log (type 7)))
  (import "index" "mockFunction" (func $~lib/subtest-as/assembly/index/mockFunction (type 8)))
  (import "index" "registerTest" (func $~lib/subtest-as/assembly/index/registerTest (type 5)))
  (import "assert" "assert.fieldEquals" (func $~lib/subtest-as/assembly/assert/assert.fieldEquals (type 3)))
  (import "store" "clearStore" (func $~lib/subtest-as/assembly/store/clearStore (type 0)))
  (import "index" "store.remove" (func $~lib/@graphprotocol/graph-ts/index/store.remove (type 7)))
  (import "index" "typeConversion.bytesToHex" (func $~lib/@graphprotocol/graph-ts/index/typeConversion.bytesToHex (type 1)))
  (func $~lib/allocator/arena/__memory_allocate (type 1) (param i32) (result i32)
    (local i32 i32 i32 i32)
    local.get 0
    i32.const 1073741824
    i32.gt_u
    if  ;; label = @1
      unreachable
    end
    local.get 0
    i32.const 1
    local.tee 1
    local.get 0
    local.get 1
    i32.gt_u
    select
    global.get 1
    local.tee 0
    i32.add
    i32.const 7
    i32.add
    i32.const -8
    i32.and
    local.tee 1
    memory.size
    local.tee 2
    i32.const 16
    i32.shl
    i32.gt_u
    if  ;; label = @1
      local.get 2
      local.get 1
      local.get 0
      i32.sub
      i32.const 65535
      i32.add
      i32.const -65536
      i32.and
      i32.const 16
      i32.shr_u
      local.tee 3
      local.tee 4
      local.get 2
      local.get 4
      i32.gt_s
      select
      memory.grow
      i32.const 0
      i32.lt_s
      if  ;; label = @2
        local.get 3
        memory.grow
        i32.const 0
        i32.lt_s
        if  ;; label = @3
          unreachable
        end
      end
    end
    local.get 1
    global.set 1
    local.get 0)
  (func $~lib/memory/memory.allocate (type 1) (param i32) (result i32)
    local.get 0
    call $~lib/allocator/arena/__memory_allocate)
  (func $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Block#constructor (type 10) (result i32)
    (local i32)
    i32.const 56
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 0
    i32.store
    local.get 0
    i32.const 0
    i32.store offset=4
    local.get 0
    i32.const 0
    i32.store offset=8
    local.get 0
    i32.const 0
    i32.store offset=12
    local.get 0
    i32.const 0
    i32.store offset=16
    local.get 0
    i32.const 0
    i32.store offset=20
    local.get 0
    i32.const 0
    i32.store offset=24
    local.get 0
    i32.const 0
    i32.store offset=28
    local.get 0
    i32.const 0
    i32.store offset=32
    local.get 0
    i32.const 0
    i32.store offset=36
    local.get 0
    i32.const 0
    i32.store offset=40
    local.get 0
    i32.const 0
    i32.store offset=44
    local.get 0
    i32.const 0
    i32.store offset=48
    local.get 0
    i32.const 0
    i32.store offset=52
    local.get 0)
  (func $~lib/internal/arraybuffer/computeSize (type 1) (param i32) (result i32)
    i32.const 1
    i32.const 32
    local.get 0
    i32.const 7
    i32.add
    i32.clz
    i32.sub
    i32.shl)
  (func $~lib/internal/arraybuffer/allocateUnsafe (type 1) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.const 1073741816
    i32.gt_u
    if  ;; label = @1
      i32.const 0
      i32.const 160
      i32.const 26
      i32.const 2
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    call $~lib/internal/arraybuffer/computeSize
    call $~lib/allocator/arena/__memory_allocate
    local.tee 1
    local.get 0
    i32.store
    local.get 1)
  (func $~lib/internal/memory/memset (type 7) (param i32 i32)
    (local i32)
    local.get 1
    i32.eqz
    if  ;; label = @1
      return
    end
    local.get 0
    i32.const 0
    i32.store8
    local.get 0
    local.get 1
    i32.add
    i32.const 1
    i32.sub
    i32.const 0
    i32.store8
    local.get 1
    i32.const 2
    i32.le_u
    if  ;; label = @1
      return
    end
    local.get 0
    i32.const 1
    i32.add
    i32.const 0
    i32.store8
    local.get 0
    i32.const 2
    i32.add
    i32.const 0
    i32.store8
    local.get 0
    local.get 1
    i32.add
    i32.const 2
    i32.sub
    i32.const 0
    i32.store8
    local.get 0
    local.get 1
    i32.add
    i32.const 3
    i32.sub
    i32.const 0
    i32.store8
    local.get 1
    i32.const 6
    i32.le_u
    if  ;; label = @1
      return
    end
    local.get 0
    i32.const 3
    i32.add
    i32.const 0
    i32.store8
    local.get 0
    local.get 1
    i32.add
    i32.const 4
    i32.sub
    i32.const 0
    i32.store8
    local.get 1
    i32.const 8
    i32.le_u
    if  ;; label = @1
      return
    end
    i32.const 0
    local.get 0
    i32.sub
    i32.const 3
    i32.and
    local.tee 2
    local.get 0
    i32.add
    local.tee 0
    i32.const 0
    i32.store
    local.get 1
    local.get 2
    i32.sub
    i32.const -4
    i32.and
    local.tee 1
    local.get 0
    i32.add
    i32.const 4
    i32.sub
    i32.const 0
    i32.store
    local.get 1
    i32.const 8
    i32.le_u
    if  ;; label = @1
      return
    end
    local.get 0
    i32.const 4
    i32.add
    i32.const 0
    i32.store
    local.get 0
    i32.const 8
    i32.add
    i32.const 0
    i32.store
    local.get 0
    local.get 1
    i32.add
    i32.const 12
    i32.sub
    i32.const 0
    i32.store
    local.get 0
    local.get 1
    i32.add
    i32.const 8
    i32.sub
    i32.const 0
    i32.store
    local.get 1
    i32.const 24
    i32.le_u
    if  ;; label = @1
      return
    end
    local.get 0
    i32.const 12
    i32.add
    i32.const 0
    i32.store
    local.get 0
    i32.const 16
    i32.add
    i32.const 0
    i32.store
    local.get 0
    i32.const 20
    i32.add
    i32.const 0
    i32.store
    local.get 0
    i32.const 24
    i32.add
    i32.const 0
    i32.store
    local.get 0
    local.get 1
    i32.add
    i32.const 28
    i32.sub
    i32.const 0
    i32.store
    local.get 0
    local.get 1
    i32.add
    i32.const 24
    i32.sub
    i32.const 0
    i32.store
    local.get 0
    local.get 1
    i32.add
    i32.const 20
    i32.sub
    i32.const 0
    i32.store
    local.get 0
    local.get 1
    i32.add
    i32.const 16
    i32.sub
    i32.const 0
    i32.store
    local.get 0
    i32.const 4
    i32.and
    i32.const 24
    i32.add
    local.tee 2
    local.get 0
    i32.add
    local.set 0
    local.get 1
    local.get 2
    i32.sub
    local.set 1
    loop  ;; label = @1
      local.get 1
      i32.const 32
      i32.ge_u
      if  ;; label = @2
        local.get 0
        i64.const 0
        i64.store
        local.get 0
        i32.const 8
        i32.add
        i64.const 0
        i64.store
        local.get 0
        i32.const 16
        i32.add
        i64.const 0
        i64.store
        local.get 0
        i32.const 24
        i32.add
        i64.const 0
        i64.store
        local.get 1
        i32.const 32
        i32.sub
        local.set 1
        local.get 0
        i32.const 32
        i32.add
        local.set 0
        br 1 (;@1;)
      end
    end)
  (func $~lib/internal/typedarray/TypedArray<u8>#constructor (type 2) (param i32 i32) (result i32)
    (local i32 i32)
    local.get 1
    i32.const 1073741816
    i32.gt_u
    if  ;; label = @1
      i32.const 0
      i32.const 96
      i32.const 23
      i32.const 34
      call $~lib/env/abort
      unreachable
    end
    local.get 1
    local.tee 2
    call $~lib/internal/arraybuffer/allocateUnsafe
    local.tee 3
    i32.const 8
    i32.add
    local.get 1
    call $~lib/internal/memory/memset
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 12
      call $~lib/allocator/arena/__memory_allocate
      local.set 0
    end
    local.get 0
    i32.const 0
    i32.store
    local.get 0
    i32.const 0
    i32.store offset=4
    local.get 0
    i32.const 0
    i32.store offset=8
    local.get 0
    local.get 3
    i32.store
    local.get 0
    i32.const 0
    i32.store offset=4
    local.get 0
    local.get 2
    i32.store offset=8
    local.get 0)
  (func $~lib/@graphprotocol/graph-ts/index/ByteArray#constructor (type 2) (param i32 i32) (result i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 12
      call $~lib/allocator/arena/__memory_allocate
      local.set 0
    end
    local.get 0
    if (result i32)  ;; label = @1
      local.get 0
    else
      i32.const 12
      call $~lib/allocator/arena/__memory_allocate
    end
    local.get 1
    call $~lib/internal/typedarray/TypedArray<u8>#constructor)
  (func $~lib/internal/typedarray/TypedArray<u8>#__set (type 4) (param i32 i32 i32)
    local.get 1
    local.get 0
    i32.load offset=8
    i32.ge_u
    if  ;; label = @1
      i32.const 0
      i32.const 96
      i32.const 50
      i32.const 63
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i32.load offset=4
    local.get 1
    local.get 0
    i32.load
    i32.add
    i32.add
    local.get 2
    i32.store8 offset=8)
  (func $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32 (type 1) (param i32) (result i32)
    (local i32)
    i32.const 0
    i32.const 4
    call $~lib/@graphprotocol/graph-ts/index/ByteArray#constructor
    local.tee 1
    i32.const 0
    local.get 0
    i32.const 255
    i32.and
    call $~lib/internal/typedarray/TypedArray<u8>#__set
    local.get 1
    i32.const 1
    local.get 0
    i32.const 8
    i32.shr_s
    i32.const 255
    i32.and
    call $~lib/internal/typedarray/TypedArray<u8>#__set
    local.get 1
    i32.const 2
    local.get 0
    i32.const 16
    i32.shr_s
    i32.const 255
    i32.and
    call $~lib/internal/typedarray/TypedArray<u8>#__set
    local.get 1
    i32.const 3
    local.get 0
    i32.const 24
    i32.shr_s
    call $~lib/internal/typedarray/TypedArray<u8>#__set
    local.get 1)
  (func $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Transaction#constructor (type 10) (result i32)
    (local i32)
    i32.const 32
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 0
    i32.store
    local.get 0
    i32.const 0
    i32.store offset=4
    local.get 0
    i32.const 0
    i32.store offset=8
    local.get 0
    i32.const 0
    i32.store offset=12
    local.get 0
    i32.const 0
    i32.store offset=16
    local.get 0
    i32.const 0
    i32.store offset=20
    local.get 0
    i32.const 0
    i32.store offset=24
    local.get 0
    i32.const 0
    i32.store offset=28
    local.get 0)
  (func $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#constructor (type 1) (param i32) (result i32)
    (local i32 i32 i32)
    local.get 0
    i32.const 268435454
    i32.gt_u
    if  ;; label = @1
      i32.const 0
      i32.const 224
      i32.const 45
      i32.const 39
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i32.const 2
    i32.shl
    local.tee 3
    call $~lib/internal/arraybuffer/allocateUnsafe
    local.set 2
    i32.const 8
    call $~lib/allocator/arena/__memory_allocate
    local.tee 1
    i32.const 0
    i32.store
    local.get 1
    i32.const 0
    i32.store offset=4
    local.get 1
    local.get 2
    i32.store
    local.get 1
    local.get 0
    i32.store offset=4
    local.get 2
    i32.const 8
    i32.add
    local.get 3
    call $~lib/internal/memory/memset
    local.get 1)
  (func $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam#constructor (type 10) (result i32)
    (local i32)
    i32.const 8
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 0
    i32.store
    local.get 0
    i32.const 0
    i32.store offset=4
    local.get 0)
  (func $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#constructor (type 10) (result i32)
    (local i32)
    i32.const 16
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 0
    i32.store
    local.get 0
    i64.const 0
    i64.store offset=8
    local.get 0)
  (func $~lib/internal/memory/memcpy (type 4) (param i32 i32 i32)
    (local i32 i32 i32)
    loop  ;; label = @1
      local.get 1
      i32.const 3
      i32.and
      local.get 2
      local.get 2
      select
      if  ;; label = @2
        local.get 0
        local.tee 3
        i32.const 1
        i32.add
        local.set 0
        local.get 3
        local.get 1
        local.tee 3
        i32.const 1
        i32.add
        local.set 1
        local.get 3
        i32.load8_u
        i32.store8
        local.get 2
        i32.const 1
        i32.sub
        local.set 2
        br 1 (;@1;)
      end
    end
    local.get 0
    i32.const 3
    i32.and
    i32.eqz
    if  ;; label = @1
      loop  ;; label = @2
        local.get 2
        i32.const 16
        i32.ge_u
        if  ;; label = @3
          local.get 0
          local.get 1
          i32.load
          i32.store
          local.get 0
          i32.const 4
          i32.add
          local.get 1
          i32.const 4
          i32.add
          i32.load
          i32.store
          local.get 0
          i32.const 8
          i32.add
          local.get 1
          i32.const 8
          i32.add
          i32.load
          i32.store
          local.get 0
          i32.const 12
          i32.add
          local.get 1
          i32.const 12
          i32.add
          i32.load
          i32.store
          local.get 1
          i32.const 16
          i32.add
          local.set 1
          local.get 0
          i32.const 16
          i32.add
          local.set 0
          local.get 2
          i32.const 16
          i32.sub
          local.set 2
          br 1 (;@2;)
        end
      end
      local.get 2
      i32.const 8
      i32.and
      if  ;; label = @2
        local.get 0
        local.get 1
        i32.load
        i32.store
        local.get 0
        i32.const 4
        i32.add
        local.get 1
        i32.const 4
        i32.add
        i32.load
        i32.store
        local.get 1
        i32.const 8
        i32.add
        local.set 1
        local.get 0
        i32.const 8
        i32.add
        local.set 0
      end
      local.get 2
      i32.const 4
      i32.and
      if  ;; label = @2
        local.get 0
        local.get 1
        i32.load
        i32.store
        local.get 1
        i32.const 4
        i32.add
        local.set 1
        local.get 0
        i32.const 4
        i32.add
        local.set 0
      end
      local.get 2
      i32.const 2
      i32.and
      if  ;; label = @2
        local.get 0
        local.get 1
        i32.load16_u
        i32.store16
        local.get 1
        i32.const 2
        i32.add
        local.set 1
        local.get 0
        i32.const 2
        i32.add
        local.set 0
      end
      local.get 2
      i32.const 1
      i32.and
      if  ;; label = @2
        local.get 0
        local.get 1
        i32.load8_u
        i32.store8
      end
      return
    end
    local.get 2
    i32.const 32
    i32.ge_u
    if  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 0
              i32.const 3
              i32.and
              i32.const 1
              i32.sub
              br_table 0 (;@5;) 1 (;@4;) 2 (;@3;) 3 (;@2;)
            end
            local.get 1
            i32.load
            local.set 4
            local.get 0
            local.get 1
            i32.load8_u
            i32.store8
            local.get 0
            i32.const 1
            i32.add
            local.tee 0
            i32.const 1
            i32.add
            local.set 3
            local.get 0
            local.get 1
            i32.const 1
            i32.add
            local.tee 0
            i32.const 1
            i32.add
            local.set 5
            local.get 0
            i32.load8_u
            i32.store8
            local.get 3
            i32.const 1
            i32.add
            local.set 0
            local.get 5
            i32.const 1
            i32.add
            local.set 1
            local.get 3
            local.get 5
            i32.load8_u
            i32.store8
            local.get 2
            i32.const 3
            i32.sub
            local.set 2
            loop  ;; label = @5
              local.get 2
              i32.const 17
              i32.ge_u
              if  ;; label = @6
                local.get 0
                local.get 1
                i32.const 1
                i32.add
                i32.load
                local.tee 3
                i32.const 8
                i32.shl
                local.get 4
                i32.const 24
                i32.shr_u
                i32.or
                i32.store
                local.get 0
                i32.const 4
                i32.add
                local.get 1
                i32.const 5
                i32.add
                i32.load
                local.tee 4
                i32.const 8
                i32.shl
                local.get 3
                i32.const 24
                i32.shr_u
                i32.or
                i32.store
                local.get 0
                i32.const 8
                i32.add
                local.get 1
                i32.const 9
                i32.add
                i32.load
                local.tee 3
                i32.const 8
                i32.shl
                local.get 4
                i32.const 24
                i32.shr_u
                i32.or
                i32.store
                local.get 0
                i32.const 12
                i32.add
                local.get 1
                i32.const 13
                i32.add
                i32.load
                local.tee 4
                i32.const 8
                i32.shl
                local.get 3
                i32.const 24
                i32.shr_u
                i32.or
                i32.store
                local.get 1
                i32.const 16
                i32.add
                local.set 1
                local.get 0
                i32.const 16
                i32.add
                local.set 0
                local.get 2
                i32.const 16
                i32.sub
                local.set 2
                br 1 (;@5;)
              end
            end
            br 2 (;@2;)
          end
          local.get 1
          i32.load
          local.set 4
          local.get 0
          local.get 1
          i32.load8_u
          i32.store8
          local.get 0
          i32.const 1
          i32.add
          local.tee 3
          i32.const 1
          i32.add
          local.set 0
          local.get 3
          local.get 1
          i32.const 1
          i32.add
          local.tee 3
          i32.const 1
          i32.add
          local.set 1
          local.get 3
          i32.load8_u
          i32.store8
          local.get 2
          i32.const 2
          i32.sub
          local.set 2
          loop  ;; label = @4
            local.get 2
            i32.const 18
            i32.ge_u
            if  ;; label = @5
              local.get 0
              local.get 1
              i32.const 2
              i32.add
              i32.load
              local.tee 3
              i32.const 16
              i32.shl
              local.get 4
              i32.const 16
              i32.shr_u
              i32.or
              i32.store
              local.get 0
              i32.const 4
              i32.add
              local.get 1
              i32.const 6
              i32.add
              i32.load
              local.tee 4
              i32.const 16
              i32.shl
              local.get 3
              i32.const 16
              i32.shr_u
              i32.or
              i32.store
              local.get 0
              i32.const 8
              i32.add
              local.get 1
              i32.const 10
              i32.add
              i32.load
              local.tee 3
              i32.const 16
              i32.shl
              local.get 4
              i32.const 16
              i32.shr_u
              i32.or
              i32.store
              local.get 0
              i32.const 12
              i32.add
              local.get 1
              i32.const 14
              i32.add
              i32.load
              local.tee 4
              i32.const 16
              i32.shl
              local.get 3
              i32.const 16
              i32.shr_u
              i32.or
              i32.store
              local.get 1
              i32.const 16
              i32.add
              local.set 1
              local.get 0
              i32.const 16
              i32.add
              local.set 0
              local.get 2
              i32.const 16
              i32.sub
              local.set 2
              br 1 (;@4;)
            end
          end
          br 1 (;@2;)
        end
        local.get 1
        i32.load
        local.set 4
        local.get 0
        local.tee 3
        i32.const 1
        i32.add
        local.set 0
        local.get 3
        local.get 1
        local.tee 3
        i32.const 1
        i32.add
        local.set 1
        local.get 3
        i32.load8_u
        i32.store8
        local.get 2
        i32.const 1
        i32.sub
        local.set 2
        loop  ;; label = @3
          local.get 2
          i32.const 19
          i32.ge_u
          if  ;; label = @4
            local.get 0
            local.get 1
            i32.const 3
            i32.add
            i32.load
            local.tee 3
            i32.const 24
            i32.shl
            local.get 4
            i32.const 8
            i32.shr_u
            i32.or
            i32.store
            local.get 0
            i32.const 4
            i32.add
            local.get 1
            i32.const 7
            i32.add
            i32.load
            local.tee 4
            i32.const 24
            i32.shl
            local.get 3
            i32.const 8
            i32.shr_u
            i32.or
            i32.store
            local.get 0
            i32.const 8
            i32.add
            local.get 1
            i32.const 11
            i32.add
            i32.load
            local.tee 3
            i32.const 24
            i32.shl
            local.get 4
            i32.const 8
            i32.shr_u
            i32.or
            i32.store
            local.get 0
            i32.const 12
            i32.add
            local.get 1
            i32.const 15
            i32.add
            i32.load
            local.tee 4
            i32.const 24
            i32.shl
            local.get 3
            i32.const 8
            i32.shr_u
            i32.or
            i32.store
            local.get 1
            i32.const 16
            i32.add
            local.set 1
            local.get 0
            i32.const 16
            i32.add
            local.set 0
            local.get 2
            i32.const 16
            i32.sub
            local.set 2
            br 1 (;@3;)
          end
        end
      end
    end
    local.get 2
    i32.const 16
    i32.and
    if  ;; label = @1
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      i32.load8_u
      i32.store8
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      i32.load8_u
      i32.store8
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      i32.load8_u
      i32.store8
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      i32.load8_u
      i32.store8
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      i32.load8_u
      i32.store8
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      i32.load8_u
      i32.store8
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      i32.load8_u
      i32.store8
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      i32.load8_u
      i32.store8
    end
    local.get 2
    i32.const 8
    i32.and
    if  ;; label = @1
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      i32.load8_u
      i32.store8
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      i32.load8_u
      i32.store8
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      i32.load8_u
      i32.store8
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      i32.load8_u
      i32.store8
    end
    local.get 2
    i32.const 4
    i32.and
    if  ;; label = @1
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      i32.load8_u
      i32.store8
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      i32.load8_u
      i32.store8
    end
    local.get 2
    i32.const 2
    i32.and
    if  ;; label = @1
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.tee 3
      i32.const 1
      i32.add
      local.set 1
      local.get 3
      i32.load8_u
      i32.store8
    end
    local.get 2
    i32.const 1
    i32.and
    if  ;; label = @1
      local.get 0
      local.get 1
      i32.load8_u
      i32.store8
    end)
  (func $~lib/internal/memory/memmove (type 4) (param i32 i32 i32)
    (local i32)
    local.get 0
    local.get 1
    i32.eq
    if  ;; label = @1
      return
    end
    local.get 1
    local.get 2
    i32.add
    local.get 0
    i32.le_u
    local.tee 3
    if (result i32)  ;; label = @1
      local.get 3
    else
      local.get 0
      local.get 2
      i32.add
      local.get 1
      i32.le_u
    end
    if  ;; label = @1
      local.get 0
      local.get 1
      local.get 2
      call $~lib/internal/memory/memcpy
      return
    end
    local.get 0
    local.get 1
    i32.lt_u
    if  ;; label = @1
      local.get 1
      i32.const 7
      i32.and
      local.get 0
      i32.const 7
      i32.and
      i32.eq
      if  ;; label = @2
        loop  ;; label = @3
          local.get 0
          i32.const 7
          i32.and
          if  ;; label = @4
            local.get 2
            i32.eqz
            if  ;; label = @5
              return
            end
            local.get 2
            i32.const 1
            i32.sub
            local.set 2
            local.get 0
            local.tee 3
            i32.const 1
            i32.add
            local.set 0
            local.get 3
            local.get 1
            local.tee 3
            i32.const 1
            i32.add
            local.set 1
            local.get 3
            i32.load8_u
            i32.store8
            br 1 (;@3;)
          end
        end
        loop  ;; label = @3
          local.get 2
          i32.const 8
          i32.ge_u
          if  ;; label = @4
            local.get 0
            local.get 1
            i64.load
            i64.store
            local.get 2
            i32.const 8
            i32.sub
            local.set 2
            local.get 0
            i32.const 8
            i32.add
            local.set 0
            local.get 1
            i32.const 8
            i32.add
            local.set 1
            br 1 (;@3;)
          end
        end
      end
      loop  ;; label = @2
        local.get 2
        if  ;; label = @3
          local.get 0
          local.tee 3
          i32.const 1
          i32.add
          local.set 0
          local.get 3
          local.get 1
          local.tee 3
          i32.const 1
          i32.add
          local.set 1
          local.get 3
          i32.load8_u
          i32.store8
          local.get 2
          i32.const 1
          i32.sub
          local.set 2
          br 1 (;@2;)
        end
      end
    else
      local.get 1
      i32.const 7
      i32.and
      local.get 0
      i32.const 7
      i32.and
      i32.eq
      if  ;; label = @2
        loop  ;; label = @3
          local.get 0
          local.get 2
          i32.add
          i32.const 7
          i32.and
          if  ;; label = @4
            local.get 2
            i32.eqz
            if  ;; label = @5
              return
            end
            local.get 0
            local.get 2
            i32.const 1
            i32.sub
            local.tee 2
            i32.add
            local.get 1
            local.get 2
            i32.add
            i32.load8_u
            i32.store8
            br 1 (;@3;)
          end
        end
        loop  ;; label = @3
          local.get 2
          i32.const 8
          i32.ge_u
          if  ;; label = @4
            local.get 2
            i32.const 8
            i32.sub
            local.tee 2
            local.get 0
            i32.add
            local.get 1
            local.get 2
            i32.add
            i64.load
            i64.store
            br 1 (;@3;)
          end
        end
      end
      loop  ;; label = @2
        local.get 2
        if  ;; label = @3
          local.get 0
          local.get 2
          i32.const 1
          i32.sub
          local.tee 2
          i32.add
          local.get 1
          local.get 2
          i32.add
          i32.load8_u
          i32.store8
          br 1 (;@2;)
        end
      end
    end)
  (func $~lib/internal/arraybuffer/reallocateUnsafe (type 2) (param i32 i32) (result i32)
    (local i32 i32)
    local.get 1
    local.get 0
    i32.load
    local.tee 2
    i32.gt_s
    if  ;; label = @1
      local.get 1
      i32.const 1073741816
      i32.gt_s
      if  ;; label = @2
        i32.const 0
        i32.const 160
        i32.const 40
        i32.const 4
        call $~lib/env/abort
        unreachable
      end
      local.get 1
      local.get 2
      call $~lib/internal/arraybuffer/computeSize
      i32.const 8
      i32.sub
      i32.le_s
      if  ;; label = @2
        local.get 0
        local.get 1
        i32.store
      else
        local.get 1
        call $~lib/internal/arraybuffer/allocateUnsafe
        local.tee 3
        i32.const 8
        i32.add
        local.get 0
        i32.const 8
        i32.add
        local.get 2
        call $~lib/internal/memory/memmove
        local.get 3
        local.set 0
      end
      local.get 0
      i32.const 8
      i32.add
      local.get 2
      i32.add
      local.get 1
      local.get 2
      i32.sub
      call $~lib/internal/memory/memset
    else
      local.get 1
      local.get 2
      i32.lt_s
      if  ;; label = @2
        local.get 1
        i32.const 0
        i32.lt_s
        if  ;; label = @3
          i32.const 0
          i32.const 160
          i32.const 62
          i32.const 4
          call $~lib/env/abort
          unreachable
        end
        local.get 0
        local.get 1
        i32.store
      end
    end
    local.get 0)
  (func $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#push (type 7) (param i32 i32)
    (local i32 i32 i32)
    local.get 0
    i32.load offset=4
    local.tee 2
    i32.const 1
    i32.add
    local.set 4
    local.get 2
    local.get 0
    i32.load
    local.tee 3
    i32.load
    i32.const 2
    i32.shr_u
    i32.ge_u
    if  ;; label = @1
      local.get 2
      i32.const 268435454
      i32.ge_u
      if  ;; label = @2
        i32.const 0
        i32.const 224
        i32.const 182
        i32.const 42
        call $~lib/env/abort
        unreachable
      end
      local.get 0
      local.get 3
      local.get 4
      i32.const 2
      i32.shl
      call $~lib/internal/arraybuffer/reallocateUnsafe
      local.tee 3
      i32.store
    end
    local.get 0
    local.get 4
    i32.store offset=4
    local.get 2
    i32.const 2
    i32.shl
    local.get 3
    i32.add
    local.get 1
    i32.store offset=8)
  (func $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Event#constructor (type 1) (param i32) (result i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 28
      call $~lib/allocator/arena/__memory_allocate
      local.set 0
    end
    local.get 0
    i32.const 0
    i32.store
    local.get 0
    i32.const 0
    i32.store offset=4
    local.get 0
    i32.const 0
    i32.store offset=8
    local.get 0
    i32.const 0
    i32.store offset=12
    local.get 0
    i32.const 0
    i32.store offset=16
    local.get 0
    i32.const 0
    i32.store offset=20
    local.get 0
    i32.const 0
    i32.store offset=24
    local.get 0)
  (func $start:~lib/subtest-as/assembly/event (type 0)
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Block#constructor
    global.set 2
    global.get 2
    i32.const 8
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store
    global.get 2
    i32.const 8
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=4
    global.get 2
    i32.const 8
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=8
    global.get 2
    i32.const 8
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=12
    global.get 2
    i32.const 8
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=16
    global.get 2
    i32.const 8
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=20
    global.get 2
    i32.const 8
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=24
    global.get 2
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=28
    global.get 2
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=32
    global.get 2
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=36
    global.get 2
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=40
    global.get 2
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=44
    global.get 2
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=48
    global.get 2
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=52
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Transaction#constructor
    global.set 3
    global.get 3
    i32.const 8
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store
    global.get 3
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=4
    global.get 3
    i32.const 8
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=8
    global.get 3
    i32.const 8
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=12
    global.get 3
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=16
    global.get 3
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=20
    global.get 3
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=24
    global.get 3
    i32.const 8
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=28
    i32.const 0
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#constructor
    global.set 4
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam#constructor
    global.set 5
    global.get 5
    i32.const 256
    i32.store
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#constructor
    global.set 6
    global.get 6
    i32.const 3
    i32.store
    global.get 6
    i64.const 1
    i64.store offset=8
    global.get 4
    global.get 5
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#push
    i32.const 0
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Event#constructor
    global.set 7
    global.get 7
    i32.const 8
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store
    global.get 7
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=4
    global.get 7
    i32.const 272
    i32.store offset=12
    global.get 7
    global.get 2
    i32.store offset=16
    global.get 7
    global.get 3
    i32.store offset=20
    global.get 7
    global.get 4
    i32.store offset=24)
  (func $~lib/@graphprotocol/graph-ts/index/Entity#constructor (type 1) (param i32) (result i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 4
      call $~lib/allocator/arena/__memory_allocate
      local.set 0
    end
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 4
      call $~lib/allocator/arena/__memory_allocate
      local.set 0
    end
    local.get 0
    i32.const 0
    i32.store
    local.get 0
    i32.const 0
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#constructor
    i32.store
    local.get 0)
  (func $~lib/@graphprotocol/graph-ts/index/Value.fromString (type 1) (param i32) (result i32)
    (local i32)
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#constructor
    local.tee 1
    i32.const 0
    i32.store
    local.get 1
    local.get 0
    i64.extend_i32_u
    i64.store offset=8
    local.get 1)
  (func $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get (type 2) (param i32 i32) (result i32)
    local.get 1
    local.get 0
    i32.load
    local.tee 0
    i32.load
    i32.const 2
    i32.shr_u
    i32.lt_u
    if (result i32)  ;; label = @1
      local.get 1
      i32.const 2
      i32.shl
      local.get 0
      i32.add
      i32.load offset=8
    else
      unreachable
    end)
  (func $~lib/internal/string/compareUnsafe (type 6) (param i32 i32 i32) (result i32)
    (local i32)
    loop  ;; label = @1
      local.get 2
      if (result i32)  ;; label = @2
        local.get 0
        i32.load16_u offset=4
        local.get 1
        i32.load16_u offset=4
        i32.sub
        local.tee 3
        i32.eqz
      else
        local.get 2
      end
      if  ;; label = @2
        local.get 2
        i32.const 1
        i32.sub
        local.set 2
        local.get 0
        i32.const 2
        i32.add
        local.set 0
        local.get 1
        i32.const 2
        i32.add
        local.set 1
        br 1 (;@1;)
      end
    end
    local.get 3)
  (func $~lib/string/String.__eq (type 2) (param i32 i32) (result i32)
    (local i32)
    local.get 0
    local.get 1
    i32.eq
    if  ;; label = @1
      i32.const 1
      return
    end
    local.get 0
    i32.eqz
    local.tee 2
    if (result i32)  ;; label = @1
      local.get 2
    else
      local.get 1
      i32.eqz
    end
    if  ;; label = @1
      i32.const 0
      return
    end
    local.get 0
    i32.load
    local.tee 2
    local.get 1
    i32.load
    i32.ne
    if  ;; label = @1
      i32.const 0
      return
    end
    local.get 0
    local.get 1
    local.get 2
    call $~lib/internal/string/compareUnsafe
    i32.eqz)
  (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#getEntry (type 2) (param i32 i32) (result i32)
    (local i32)
    loop  ;; label = @1
      block  ;; label = @2
        local.get 2
        local.get 0
        i32.load
        i32.load offset=4
        i32.ge_s
        br_if 0 (;@2;)
        local.get 0
        i32.load
        local.get 2
        call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
        i32.load
        local.get 1
        call $~lib/string/String.__eq
        if  ;; label = @3
          local.get 0
          i32.load
          local.get 2
          call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
          return
        else
          local.get 2
          i32.const 1
          i32.add
          local.set 2
          br 2 (;@1;)
        end
        unreachable
      end
    end
    i32.const 0)
  (func $~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#constructor (type 2) (param i32 i32) (result i32)
    (local i32)
    i32.const 8
    call $~lib/allocator/arena/__memory_allocate
    local.tee 2
    i32.const 0
    i32.store
    local.get 2
    i32.const 0
    i32.store offset=4
    local.get 2
    local.get 0
    i32.store
    local.get 2
    local.get 1
    i32.store offset=4
    local.get 2)
  (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set (type 4) (param i32 i32 i32)
    (local i32)
    local.get 0
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#getEntry
    local.tee 3
    if  ;; label = @1
      local.get 3
      local.get 2
      i32.store offset=4
    else
      local.get 1
      local.get 2
      call $~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#constructor
      local.set 1
      local.get 0
      i32.load
      local.get 1
      call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#push
    end)
  (func $generated/schema/Gravatar#constructor (type 1) (param i32) (result i32)
    (local i32)
    i32.const 4
    call $~lib/allocator/arena/__memory_allocate
    call $~lib/@graphprotocol/graph-ts/index/Entity#constructor
    local.tee 1
    i32.const 480
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/Value.fromString
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
    local.get 1)
  (func $generated/Gravity/Gravity/NewGravatar__Params#constructor (type 1) (param i32) (result i32)
    (local i32)
    i32.const 4
    call $~lib/allocator/arena/__memory_allocate
    local.tee 1
    i32.const 0
    i32.store
    local.get 1
    local.get 0
    i32.store
    local.get 1)
  (func $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#toBigInt (type 1) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.load
    i32.const 3
    i32.eq
    local.tee 1
    if (result i32)  ;; label = @1
      local.get 1
    else
      local.get 0
      i32.load
      i32.const 4
      i32.eq
    end
    i32.eqz
    if  ;; label = @1
      i32.const 488
      i32.const 568
      i32.const 67
      i32.const 6
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i64.load offset=8
    i32.wrap_i64)
  (func $generated/Gravity/Gravity/NewGravatar__Params#get:id (type 1) (param i32) (result i32)
    local.get 0
    i32.load
    i32.load offset=24
    i32.const 0
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
    i32.load offset=4
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#toBigInt)
  (func $generated/Gravity/Gravity/NewGravatar__Params#get:owner (type 1) (param i32) (result i32)
    local.get 0
    i32.load
    i32.load offset=24
    i32.const 1
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
    i32.load offset=4
    local.tee 0
    i32.load
    if  ;; label = @1
      i32.const 664
      i32.const 568
      i32.const 40
      i32.const 6
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i64.load offset=8
    i32.wrap_i64)
  (func $generated/schema/Gravatar#set:owner (type 7) (param i32 i32)
    local.get 0
    i32.const 736
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#constructor
    local.tee 0
    i32.const 6
    i32.store
    local.get 0
    local.get 1
    i64.extend_i32_u
    i64.store offset=8
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set)
  (func $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#toString (type 1) (param i32) (result i32)
    local.get 0
    i32.load
    i32.const 6
    i32.ne
    if  ;; label = @1
      i32.const 752
      i32.const 568
      i32.const 75
      i32.const 6
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i64.load offset=8
    i32.wrap_i64)
  (func $generated/Gravity/Gravity/NewGravatar__Params#get:displayName (type 1) (param i32) (result i32)
    local.get 0
    i32.load
    i32.load offset=24
    i32.const 2
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
    i32.load offset=4
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#toString)
  (func $generated/schema/Gravatar#set:displayName (type 7) (param i32 i32)
    local.get 0
    i32.const 824
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/Value.fromString
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set)
  (func $generated/Gravity/Gravity/NewGravatar__Params#get:imageUrl (type 1) (param i32) (result i32)
    local.get 0
    i32.load
    i32.load offset=24
    i32.const 3
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
    i32.load offset=4
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#toString)
  (func $generated/schema/Gravatar#set:imageUrl (type 7) (param i32 i32)
    local.get 0
    i32.const 856
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/Value.fromString
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set)
  (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get (type 1) (param i32) (result i32)
    (local i32)
    loop  ;; label = @1
      local.get 1
      local.get 0
      i32.load
      i32.load offset=4
      i32.lt_s
      if  ;; label = @2
        local.get 0
        i32.load
        local.get 1
        call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
        i32.load
        i32.const 480
        call $~lib/string/String.__eq
        if  ;; label = @3
          local.get 0
          i32.load
          local.get 1
          call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
          i32.load offset=4
          return
        else
          local.get 1
          i32.const 1
          i32.add
          local.set 1
          br 2 (;@1;)
        end
        unreachable
      end
    end
    i32.const 0)
  (func $~lib/internal/string/allocateUnsafe (type 1) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.const 0
    i32.gt_s
    local.tee 1
    if (result i32)  ;; label = @1
      local.get 0
      i32.const 536870910
      i32.le_s
    else
      local.get 1
    end
    i32.eqz
    if  ;; label = @1
      i32.const 0
      i32.const 1304
      i32.const 14
      i32.const 2
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i32.const 1
    i32.shl
    i32.const 4
    i32.add
    call $~lib/allocator/arena/__memory_allocate
    local.tee 1
    local.get 0
    i32.store
    local.get 1)
  (func $~lib/internal/string/copyUnsafe (type 8) (param i32 i32 i32 i32 i32)
    local.get 0
    local.get 1
    i32.const 1
    i32.shl
    i32.add
    i32.const 4
    i32.add
    local.get 2
    local.get 3
    i32.const 1
    i32.shl
    i32.add
    i32.const 4
    i32.add
    local.get 4
    i32.const 1
    i32.shl
    call $~lib/internal/memory/memmove)
  (func $~lib/string/String#concat (type 2) (param i32 i32) (result i32)
    (local i32 i32 i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 0
      i32.const 1264
      i32.const 110
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i32.load
    local.tee 3
    local.get 1
    i32.const 1248
    local.get 1
    select
    local.tee 1
    i32.load
    local.tee 4
    i32.add
    local.tee 2
    i32.eqz
    if  ;; label = @1
      i32.const 1296
      return
    end
    local.get 2
    call $~lib/internal/string/allocateUnsafe
    local.tee 2
    i32.const 0
    local.get 0
    i32.const 0
    local.get 3
    call $~lib/internal/string/copyUnsafe
    local.get 2
    local.get 3
    local.get 1
    i32.const 0
    local.get 4
    call $~lib/internal/string/copyUnsafe
    local.get 2)
  (func $~lib/string/String.__concat (type 2) (param i32 i32) (result i32)
    local.get 0
    i32.const 1248
    local.get 0
    select
    local.get 1
    call $~lib/string/String#concat)
  (func $~lib/@graphprotocol/graph-ts/index/Value#toString (type 1) (param i32) (result i32)
    local.get 0
    i32.load
    if  ;; label = @1
      i32.const 1360
      i32.const 1408
      i32.const 806
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i64.load offset=8
    i32.wrap_i64)
  (func $generated/schema/Gravatar#save (type 5) (param i32)
    (local i32)
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
    local.tee 1
    i32.eqz
    if  ;; label = @1
      i32.const 880
      i32.const 968
      i32.const 24
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 1
    i32.load
    if  ;; label = @1
      i32.const 1016
      i32.const 1120
      call $~lib/string/String.__concat
      i32.const 968
      i32.const 25
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    i32.const 456
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/Value#toString
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/store.set)
  (func $src/mapping/handleNewGravatar (type 5) (param i32)
    (local i32)
    local.get 0
    call $generated/Gravity/Gravity/NewGravatar__Params#constructor
    call $generated/Gravity/Gravity/NewGravatar__Params#get:id
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.bigIntToString
    call $generated/schema/Gravatar#constructor
    local.tee 1
    local.get 0
    call $generated/Gravity/Gravity/NewGravatar__Params#constructor
    call $generated/Gravity/Gravity/NewGravatar__Params#get:owner
    call $generated/schema/Gravatar#set:owner
    local.get 1
    local.get 0
    call $generated/Gravity/Gravity/NewGravatar__Params#constructor
    call $generated/Gravity/Gravity/NewGravatar__Params#get:displayName
    call $generated/schema/Gravatar#set:displayName
    local.get 1
    local.get 0
    call $generated/Gravity/Gravity/NewGravatar__Params#constructor
    call $generated/Gravity/Gravity/NewGravatar__Params#get:imageUrl
    call $generated/schema/Gravatar#set:imageUrl
    local.get 1
    call $generated/schema/Gravatar#save)
  (func $src/mapping/handleNewGravatars~anonymous|0 (type 4) (param i32 i32 i32)
    local.get 0
    call $src/mapping/handleNewGravatar)
  (func $~lib/array/Array<generated/Gravity/Gravity/NewGravatar>#forEach (type 7) (param i32 i32)
    (local i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.load offset=4
      local.set 3
      loop  ;; label = @2
        local.get 2
        local.get 3
        local.get 0
        i32.load offset=4
        local.tee 4
        local.get 3
        local.get 4
        i32.lt_s
        select
        i32.ge_s
        br_if 1 (;@1;)
        i32.const 3
        global.set 9
        local.get 0
        i32.load
        local.get 2
        i32.const 2
        i32.shl
        i32.add
        i32.load offset=8
        local.get 2
        local.get 0
        local.get 1
        call_indirect (type 4)
        local.get 2
        i32.const 1
        i32.add
        local.set 2
        br 0 (;@2;)
      end
      unreachable
    end)
  (func $src/mapping/handleNewGravatars (type 5) (param i32)
    local.get 0
    i32.const 1
    call $~lib/array/Array<generated/Gravity/Gravity/NewGravatar>#forEach)
  (func $src/mapping/handleUpdatedGravatar (type 5) (param i32)
    (local i32 i32)
    i32.const 456
    local.get 0
    call $generated/Gravity/Gravity/NewGravatar__Params#constructor
    call $generated/Gravity/Gravity/NewGravatar__Params#get:id
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.bigIntToHex
    local.tee 2
    call $~lib/@graphprotocol/graph-ts/index/store.get
    local.tee 1
    i32.eqz
    if  ;; label = @1
      local.get 2
      call $generated/schema/Gravatar#constructor
      local.set 1
    end
    local.get 1
    local.get 0
    call $generated/Gravity/Gravity/NewGravatar__Params#constructor
    call $generated/Gravity/Gravity/NewGravatar__Params#get:owner
    call $generated/schema/Gravatar#set:owner
    local.get 1
    local.get 0
    call $generated/Gravity/Gravity/NewGravatar__Params#constructor
    call $generated/Gravity/Gravity/NewGravatar__Params#get:displayName
    call $generated/schema/Gravatar#set:displayName
    local.get 1
    local.get 0
    call $generated/Gravity/Gravity/NewGravatar__Params#constructor
    call $generated/Gravity/Gravity/NewGravatar__Params#get:imageUrl
    call $generated/schema/Gravatar#set:imageUrl
    local.get 1
    call $generated/schema/Gravatar#save)
  (func $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.SmartContractCall#constructor (type 2) (param i32 i32) (result i32)
    (local i32)
    i32.const 20
    call $~lib/allocator/arena/__memory_allocate
    local.tee 2
    i32.const 0
    i32.store
    local.get 2
    i32.const 0
    i32.store offset=4
    local.get 2
    i32.const 0
    i32.store offset=8
    local.get 2
    i32.const 0
    i32.store offset=12
    local.get 2
    i32.const 0
    i32.store offset=16
    local.get 2
    i32.const 1488
    i32.store
    local.get 2
    local.get 0
    i32.store offset=4
    local.get 2
    i32.const 1488
    i32.store offset=8
    local.get 2
    i32.const 1552
    i32.store offset=12
    local.get 2
    local.get 1
    i32.store offset=16
    local.get 2)
  (func $src/mapping/test (type 0)
    i32.const 1504
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.const 1576
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.SmartContractCall#constructor
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.call
    drop)
  (func $generated/Gravity/Gravity/NewGravatar#constructor (type 10) (result i32)
    i32.const 28
    call $~lib/allocator/arena/__memory_allocate
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Event#constructor)
  (func $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromI32 (type 1) (param i32) (result i32)
    (local i32)
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#constructor
    local.tee 1
    i32.const 3
    i32.store
    local.get 1
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i64.extend_i32_u
    i64.store offset=8
    local.get 1)
  (func $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromAddress (type 1) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.load offset=8
    i32.const 20
    i32.ne
    if  ;; label = @1
      i32.const 1584
      i32.const 568
      i32.const 184
      i32.const 6
      call $~lib/env/abort
      unreachable
    end
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#constructor
    local.tee 1
    i32.const 0
    i32.store
    local.get 1
    local.get 0
    i64.extend_i32_u
    i64.store offset=8
    local.get 1)
  (func $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromString (type 1) (param i32) (result i32)
    (local i32)
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#constructor
    local.tee 1
    i32.const 6
    i32.store
    local.get 1
    local.get 0
    i64.extend_i32_u
    i64.store offset=8
    local.get 1)
  (func $src/mapping/createNewGravatarEvent (type 9) (param i32 i32 i32 i32) (result i32)
    (local i32 i32)
    call $generated/Gravity/Gravity/NewGravatar#constructor
    local.tee 4
    i32.const 0
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#constructor
    i32.store offset=24
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam#constructor
    local.tee 5
    local.get 0
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromI32
    i32.store offset=4
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam#constructor
    local.tee 0
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromAddress
    i32.store offset=4
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam#constructor
    local.tee 1
    local.get 2
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromString
    i32.store offset=4
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam#constructor
    local.tee 2
    local.get 3
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromString
    i32.store offset=4
    local.get 4
    i32.load offset=24
    local.get 5
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#push
    local.get 4
    i32.load offset=24
    local.get 0
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#push
    local.get 4
    i32.load offset=24
    local.get 1
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#push
    local.get 4
    i32.load offset=24
    local.get 2
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#push
    local.get 4)
  (func $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value>#__set (type 4) (param i32 i32 i32)
    (local i32)
    local.get 1
    local.get 0
    i32.load
    local.tee 3
    i32.load
    i32.const 2
    i32.shr_u
    i32.ge_u
    if  ;; label = @1
      local.get 1
      i32.const 268435454
      i32.ge_u
      if  ;; label = @2
        i32.const 0
        i32.const 224
        i32.const 107
        i32.const 41
        call $~lib/env/abort
        unreachable
      end
      local.get 0
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      i32.const 2
      i32.shl
      call $~lib/internal/arraybuffer/reallocateUnsafe
      local.tee 3
      i32.store
      local.get 0
      local.get 1
      i32.const 1
      i32.add
      i32.store offset=4
    end
    local.get 1
    i32.const 2
    i32.shl
    local.get 3
    i32.add
    local.get 2
    i32.store offset=8)
  (func $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromI32Array (type 10) (result i32)
    (local i32 i32)
    i32.const 1748
    i32.load
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#constructor
    local.set 1
    loop  ;; label = @1
      local.get 0
      i32.const 1748
      i32.load
      i32.lt_s
      if  ;; label = @2
        local.get 1
        local.get 0
        i32.const 1744
        local.get 0
        call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
        call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromI32
        call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value>#__set
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        br 1 (;@1;)
      end
    end
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#constructor
    local.tee 0
    i32.const 8
    i32.store
    local.get 0
    local.get 1
    i64.extend_i32_u
    i64.store offset=8
    local.get 0)
  (func $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value>#__unchecked_set (type 4) (param i32 i32 i32)
    local.get 0
    i32.load
    local.get 1
    i32.const 2
    i32.shl
    i32.add
    local.get 2
    i32.store offset=8)
  (func $src/tests/runTests~anonymous|0~anonymous|0 (type 4) (param i32 i32 i32)
    i32.const 4
    local.get 0
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#toString
    call $~lib/subtest-as/assembly/log/log.log)
  (func $~lib/subtest-as/assembly/index/MockedFunction#constructor (type 2) (param i32 i32) (result i32)
    (local i32)
    i32.const 16
    call $~lib/allocator/arena/__memory_allocate
    local.tee 2
    i32.const 0
    i32.store8
    local.get 2
    i32.const 0
    i32.store offset=4
    local.get 2
    i32.const 0
    i32.store offset=8
    local.get 2
    i32.const 0
    i32.store offset=12
    local.get 2
    local.get 0
    i32.store offset=4
    local.get 2
    local.get 1
    i32.store offset=8
    local.get 2)
  (func $~lib/subtest-as/assembly/index/createMockedFunction (type 2) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    call $~lib/subtest-as/assembly/index/MockedFunction#constructor)
  (func $~lib/subtest-as/assembly/log/log.critical (type 0)
    i32.const 0
    i32.const 312
    call $~lib/subtest-as/assembly/log/log.log)
  (func $~lib/subtest-as/assembly/index/MockedFunction#withArgs (type 2) (param i32 i32) (result i32)
    local.get 0
    i32.load8_u
    if  ;; label = @1
      call $~lib/subtest-as/assembly/log/log.critical
    else
      local.get 0
      local.get 1
      i32.store offset=12
    end
    local.get 0)
  (func $~lib/subtest-as/assembly/index/MockedFunction#returns (type 7) (param i32 i32)
    local.get 0
    i32.load8_u
    if  ;; label = @1
      call $~lib/subtest-as/assembly/log/log.critical
    else
      local.get 0
      i32.load offset=4
      local.get 0
      i32.load offset=8
      local.get 0
      i32.load offset=12
      local.get 1
      i32.const 0
      call $~lib/subtest-as/assembly/index/mockFunction
      local.get 0
      i32.const 1
      i32.store8
    end)
  (func $src/tests/runTests~anonymous|0 (type 0)
    (local i32 i32 i32 i32)
    i32.const 152
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromI32
    local.set 1
    i32.const 1704
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromString
    local.set 2
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromI32Array
    local.set 3
    i32.const 1752
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.const 3
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#constructor
    local.tee 0
    i32.const 0
    local.get 1
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value>#__unchecked_set
    local.get 0
    i32.const 1
    local.get 2
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value>#__unchecked_set
    local.get 0
    i32.const 2
    local.get 3
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value>#__unchecked_set
    local.get 0
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.SmartContractCall#constructor
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.call
    i32.const 2
    call $~lib/array/Array<generated/Gravity/Gravity/NewGravatar>#forEach
    i32.const 1840
    i32.const 1928
    call $~lib/subtest-as/assembly/index/createMockedFunction
    i32.const 3
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#constructor
    local.tee 0
    i32.const 0
    i32.const 1952
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromString
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value>#__unchecked_set
    local.get 0
    i32.const 1
    i32.const 1968
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromString
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value>#__unchecked_set
    local.get 0
    i32.const 2
    i32.const 1984
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromString
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value>#__unchecked_set
    local.get 0
    call $~lib/subtest-as/assembly/index/MockedFunction#withArgs
    i32.const 2000
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromString
    call $~lib/subtest-as/assembly/index/MockedFunction#returns)
  (func $~lib/subtest-as/assembly/index/test (type 7) (param i32 i32)
    local.get 0
    call $~lib/subtest-as/assembly/index/registerTest
    i32.const 0
    global.set 9
    local.get 1
    call_indirect (type 0))
  (func $src/tests/runTests~anonymous|1 (type 0)
    (local i32)
    i32.const 2128
    call $generated/schema/Gravatar#constructor
    local.set 0
    global.get 8
    i32.const 2128
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/store.set
    global.get 8
    i32.const 2128
    i32.const 480
    i32.const 2128
    call $~lib/subtest-as/assembly/assert/assert.fieldEquals
    call $~lib/subtest-as/assembly/store/clearStore)
  (func $generated/schema/Gravatar#get:id (type 1) (param i32) (result i32)
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
    call $~lib/@graphprotocol/graph-ts/index/Value#toString)
  (func $src/tests/runTests~anonymous|2 (type 0)
    (local i32 i32 i32)
    i32.const 2232
    call $generated/schema/Gravatar#constructor
    local.set 0
    global.get 8
    local.get 0
    call $generated/schema/Gravatar#get:id
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/store.set
    i32.const 12345
    i32.const 1752
    i32.const 2264
    i32.const 2280
    call $src/mapping/createNewGravatarEvent
    local.set 1
    i32.const 3546
    i32.const 1752
    i32.const 2264
    i32.const 2280
    call $src/mapping/createNewGravatarEvent
    local.set 2
    i32.const 2
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#constructor
    local.tee 0
    i32.const 0
    local.get 1
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value>#__unchecked_set
    local.get 0
    i32.const 1
    local.get 2
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value>#__unchecked_set
    local.get 0
    call $src/mapping/handleNewGravatars
    global.get 8
    i32.const 2232
    i32.const 480
    i32.const 2232
    call $~lib/subtest-as/assembly/assert/assert.fieldEquals
    global.get 8
    i32.const 2296
    i32.const 480
    i32.const 2296
    call $~lib/subtest-as/assembly/assert/assert.fieldEquals
    global.get 8
    i32.const 2312
    i32.const 480
    i32.const 2312
    call $~lib/subtest-as/assembly/assert/assert.fieldEquals
    call $~lib/subtest-as/assembly/store/clearStore)
  (func $src/tests/runTests~anonymous|3 (type 0)
    (local i32)
    i32.const 2416
    call $generated/schema/Gravatar#constructor
    local.set 0
    global.get 8
    local.get 0
    call $generated/schema/Gravatar#get:id
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/store.set
    global.get 8
    i32.const 2416
    call $~lib/@graphprotocol/graph-ts/index/store.get
    local.set 0
    global.get 8
    i32.const 2416
    i32.const 480
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
    call $~lib/@graphprotocol/graph-ts/index/Value#toString
    call $~lib/subtest-as/assembly/assert/assert.fieldEquals
    global.get 8
    i32.const 2416
    call $~lib/@graphprotocol/graph-ts/index/store.remove
    call $~lib/subtest-as/assembly/store/clearStore)
  (func $src/tests/runTests~anonymous|4 (type 0)
    (local i32)
    i32.const 2504
    i32.const 2536
    call $~lib/subtest-as/assembly/index/createMockedFunction
    i32.const 2
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#constructor
    local.tee 0
    i32.const 0
    i32.const 2576
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromString
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value>#__unchecked_set
    local.get 0
    i32.const 1
    i32.const 2592
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromString
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value>#__unchecked_set
    local.get 0
    call $~lib/subtest-as/assembly/index/MockedFunction#withArgs
    i32.const 2608
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromString
    call $~lib/subtest-as/assembly/index/MockedFunction#returns)
  (func $~lib/subtest-as/assembly/index/MockedFunction#reverts (type 5) (param i32)
    local.get 0
    i32.load8_u
    if  ;; label = @1
      call $~lib/subtest-as/assembly/log/log.critical
    else
      local.get 0
      i32.load offset=4
      local.get 0
      i32.load offset=8
      local.get 0
      i32.load offset=12
      i32.const 1296
      call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromString
      i32.const 1
      call $~lib/subtest-as/assembly/index/mockFunction
      local.get 0
      i32.const 1
      i32.store8
    end)
  (func $src/tests/runTests~anonymous|5 (type 0)
    i32.const 2720
    i32.const 2760
    call $~lib/subtest-as/assembly/index/createMockedFunction
    call $~lib/subtest-as/assembly/index/MockedFunction#reverts)
  (func $~lib/subtest-as/assembly/event/addMetadata (type 1) (param i32) (result i32)
    local.get 0
    global.get 7
    i32.load
    i32.store
    local.get 0
    global.get 7
    i32.load offset=4
    i32.store offset=4
    local.get 0
    global.get 7
    i32.load offset=12
    i32.store offset=12
    local.get 0
    global.get 7
    i32.load offset=16
    i32.store offset=16
    local.get 0
    global.get 7
    i32.load offset=20
    i32.store offset=20
    local.get 0
    global.get 7
    i32.load offset=24
    i32.store offset=24
    local.get 0)
  (func $~lib/string/String.__ne (type 2) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    call $~lib/string/String.__eq
    i32.eqz)
  (func $~lib/subtest-as/assembly/log/log.error (type 5) (param i32)
    i32.const 1
    local.get 0
    call $~lib/subtest-as/assembly/log/log.log)
  (func $~lib/internal/typedarray/TypedArray<u8>#__get (type 2) (param i32 i32) (result i32)
    local.get 1
    local.get 0
    i32.load offset=8
    i32.ge_u
    if  ;; label = @1
      i32.const 0
      i32.const 96
      i32.const 39
      i32.const 63
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i32.load offset=4
    local.get 1
    local.get 0
    i32.load
    i32.add
    i32.add
    i32.load8_u offset=8)
  (func $~lib/@graphprotocol/graph-ts/index/ByteArray#equals (type 2) (param i32 i32) (result i32)
    (local i32)
    local.get 0
    i32.load offset=8
    local.get 1
    i32.load offset=8
    i32.ne
    if  ;; label = @1
      i32.const 0
      return
    end
    loop  ;; label = @1
      block  ;; label = @2
        local.get 2
        local.get 0
        i32.load offset=8
        i32.ge_s
        br_if 0 (;@2;)
        local.get 0
        local.get 2
        call $~lib/internal/typedarray/TypedArray<u8>#__get
        i32.const 255
        i32.and
        local.get 1
        local.get 2
        call $~lib/internal/typedarray/TypedArray<u8>#__get
        i32.const 255
        i32.and
        i32.ne
        if  ;; label = @3
          i32.const 0
          return
        else
          local.get 2
          i32.const 1
          i32.add
          local.set 2
          br 2 (;@1;)
        end
        unreachable
      end
    end
    i32.const 1)
  (func $~lib/@graphprotocol/graph-ts/index/ByteArray#notEqual (type 2) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray#equals
    i32.eqz)
  (func $~lib/@graphprotocol/graph-ts/index/BigInt.compare (type 2) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32)
    local.get 0
    i32.load offset=8
    i32.const 0
    i32.gt_s
    local.tee 2
    if  ;; label = @1
      local.get 0
      local.get 0
      i32.load offset=8
      i32.const 1
      i32.sub
      call $~lib/internal/typedarray/TypedArray<u8>#__get
      i32.const 255
      i32.and
      i32.const 7
      i32.shr_u
      i32.const 1
      i32.eq
      local.set 2
    end
    local.get 1
    i32.load offset=8
    i32.const 0
    i32.gt_s
    local.tee 5
    if  ;; label = @1
      local.get 1
      local.get 1
      i32.load offset=8
      i32.const 1
      i32.sub
      call $~lib/internal/typedarray/TypedArray<u8>#__get
      i32.const 255
      i32.and
      i32.const 7
      i32.shr_u
      i32.const 1
      i32.eq
      local.set 5
    end
    local.get 2
    i32.eqz
    local.tee 3
    if (result i32)  ;; label = @1
      local.get 5
    else
      local.get 3
    end
    if  ;; label = @1
      i32.const 1
      return
    else
      local.get 5
      i32.eqz
      local.get 2
      local.get 2
      select
      if  ;; label = @2
        i32.const -1
        return
      end
    end
    local.get 0
    i32.load offset=8
    local.set 3
    loop  ;; label = @1
      local.get 3
      i32.const 0
      i32.gt_s
      local.tee 4
      if (result i32)  ;; label = @2
        local.get 2
        i32.eqz
        local.tee 4
        if  ;; label = @3
          local.get 0
          local.get 3
          i32.const 1
          i32.sub
          call $~lib/internal/typedarray/TypedArray<u8>#__get
          i32.const 255
          i32.and
          i32.eqz
          local.set 4
        end
        local.get 4
        if (result i32)  ;; label = @3
          local.get 4
        else
          local.get 2
          if (result i32)  ;; label = @4
            local.get 0
            local.get 3
            i32.const 1
            i32.sub
            call $~lib/internal/typedarray/TypedArray<u8>#__get
            i32.const 255
            i32.and
            i32.const 255
            i32.eq
          else
            local.get 2
          end
        end
      else
        local.get 4
      end
      if  ;; label = @2
        local.get 3
        i32.const 1
        i32.sub
        local.set 3
        br 1 (;@1;)
      end
    end
    local.get 1
    i32.load offset=8
    local.set 6
    loop  ;; label = @1
      local.get 6
      i32.const 0
      i32.gt_s
      local.tee 4
      if (result i32)  ;; label = @2
        local.get 5
        i32.eqz
        local.tee 4
        if  ;; label = @3
          local.get 1
          local.get 6
          i32.const 1
          i32.sub
          call $~lib/internal/typedarray/TypedArray<u8>#__get
          i32.const 255
          i32.and
          i32.eqz
          local.set 4
        end
        local.get 4
        if (result i32)  ;; label = @3
          local.get 4
        else
          local.get 5
          if (result i32)  ;; label = @4
            local.get 1
            local.get 6
            i32.const 1
            i32.sub
            call $~lib/internal/typedarray/TypedArray<u8>#__get
            i32.const 255
            i32.and
            i32.const 255
            i32.eq
          else
            local.get 5
          end
        end
      else
        local.get 4
      end
      if  ;; label = @2
        local.get 6
        i32.const 1
        i32.sub
        local.set 6
        br 1 (;@1;)
      end
    end
    local.get 3
    local.get 6
    i32.gt_s
    if  ;; label = @1
      i32.const -1
      i32.const 1
      local.get 2
      select
      return
    else
      local.get 6
      local.get 3
      i32.gt_s
      if  ;; label = @2
        i32.const 1
        i32.const -1
        local.get 2
        select
        return
      end
    end
    i32.const 1
    local.set 2
    loop  ;; label = @1
      block  ;; label = @2
        local.get 2
        local.get 3
        i32.gt_s
        br_if 0 (;@2;)
        local.get 0
        local.get 3
        local.get 2
        i32.sub
        call $~lib/internal/typedarray/TypedArray<u8>#__get
        i32.const 255
        i32.and
        local.get 1
        local.get 3
        local.get 2
        i32.sub
        call $~lib/internal/typedarray/TypedArray<u8>#__get
        i32.const 255
        i32.and
        i32.lt_u
        if  ;; label = @3
          i32.const -1
          return
        else
          local.get 0
          local.get 3
          local.get 2
          i32.sub
          call $~lib/internal/typedarray/TypedArray<u8>#__get
          i32.const 255
          i32.and
          local.get 1
          local.get 3
          local.get 2
          i32.sub
          call $~lib/internal/typedarray/TypedArray<u8>#__get
          i32.const 255
          i32.and
          i32.gt_u
          if  ;; label = @4
            i32.const 1
            return
          end
          local.get 2
          i32.const 1
          i32.add
          local.set 2
          br 2 (;@1;)
        end
        unreachable
      end
    end
    i32.const 0)
  (func $~lib/@graphprotocol/graph-ts/index/BigInt#notEqual (type 2) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/BigInt.compare
    i32.eqz
    i32.eqz)
  (func $~lib/string/String#charAt (type 2) (param i32 i32) (result i32)
    (local i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 0
      i32.const 1264
      i32.const 58
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 1
    local.get 0
    i32.load
    i32.ge_u
    if  ;; label = @1
      i32.const 1296
      return
    end
    i32.const 1
    call $~lib/internal/string/allocateUnsafe
    local.tee 2
    local.get 0
    local.get 1
    i32.const 1
    i32.shl
    i32.add
    i32.load16_u offset=4
    i32.store16 offset=4
    local.get 2)
  (func $~lib/string/String#substr (type 6) (param i32 i32 i32) (result i32)
    (local i32 i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 0
      i32.const 1264
      i32.const 241
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i32.load
    local.set 3
    local.get 1
    i32.const 0
    i32.lt_s
    if  ;; label = @1
      local.get 1
      local.get 3
      i32.add
      local.tee 1
      i32.const 0
      local.get 1
      local.get 4
      i32.gt_s
      select
      local.set 1
    end
    local.get 2
    i32.const 0
    local.get 2
    local.get 4
    i32.gt_s
    select
    local.tee 2
    local.get 3
    local.get 1
    i32.sub
    local.tee 3
    local.get 2
    local.get 3
    i32.lt_s
    select
    local.tee 2
    i32.const 0
    i32.le_s
    if  ;; label = @1
      i32.const 1296
      return
    end
    local.get 2
    call $~lib/internal/string/allocateUnsafe
    local.tee 3
    i32.const 0
    local.get 0
    local.get 1
    local.get 2
    call $~lib/internal/string/copyUnsafe
    local.get 3)
  (func $~lib/internal/string/parse<i32> (type 1) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    i32.const 16
    local.set 4
    block  ;; label = @1
      local.get 0
      i32.load
      local.tee 2
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      i32.load16_u offset=4
      local.tee 1
      i32.const 45
      i32.eq
      if (result i32)  ;; label = @2
        local.get 2
        i32.const 1
        i32.sub
        local.tee 2
        i32.eqz
        br_if 1 (;@1;)
        local.get 0
        i32.const 2
        i32.add
        local.tee 0
        i32.load16_u offset=4
        drop
        i32.const -1
      else
        local.get 1
        i32.const 43
        i32.eq
        if  ;; label = @3
          local.get 2
          i32.const 1
          i32.sub
          local.tee 2
          i32.eqz
          br_if 2 (;@1;)
          local.get 0
          i32.const 2
          i32.add
          local.tee 0
          i32.load16_u offset=4
          drop
        end
        i32.const 1
      end
      local.set 6
      loop  ;; label = @2
        local.get 2
        local.tee 1
        i32.const 1
        i32.sub
        local.set 2
        local.get 1
        if  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.load16_u offset=4
            local.tee 1
            i32.const 48
            i32.ge_s
            local.tee 3
            if (result i32)  ;; label = @5
              local.get 1
              i32.const 57
              i32.le_s
            else
              local.get 3
            end
            if (result i32)  ;; label = @5
              local.get 1
              i32.const 48
              i32.sub
            else
              local.get 1
              i32.const 65
              i32.ge_s
              local.tee 3
              if (result i32)  ;; label = @6
                local.get 1
                i32.const 90
                i32.le_s
              else
                local.get 3
              end
              if (result i32)  ;; label = @6
                local.get 1
                i32.const 55
                i32.sub
              else
                local.get 1
                i32.const 97
                i32.ge_s
                local.tee 3
                if (result i32)  ;; label = @7
                  local.get 1
                  i32.const 122
                  i32.le_s
                else
                  local.get 3
                end
                if (result i32)  ;; label = @7
                  local.get 1
                  i32.const 87
                  i32.sub
                else
                  br 3 (;@4;)
                end
              end
            end
            local.tee 1
            local.get 4
            i32.ge_s
            br_if 0 (;@4;)
            local.get 4
            local.get 5
            i32.mul
            local.get 1
            i32.add
            local.set 5
            local.get 0
            i32.const 2
            i32.add
            local.set 0
            br 2 (;@2;)
          end
        end
      end
      local.get 5
      local.get 6
      i32.mul
      return
    end
    f64.const nan (;=nan;)
    i32.trunc_f64_s)
  (func $~lib/@graphprotocol/graph-ts/index/ByteArray.fromHexString (type 1) (param i32) (result i32)
    (local i32 i32)
    local.get 0
    i32.load
    i32.const 2
    i32.rem_s
    if  ;; label = @1
      i32.const 3264
      local.get 0
      call $~lib/string/String.__concat
      i32.const 3280
      call $~lib/string/String.__concat
      i32.const 1408
      i32.const 303
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i32.load
    i32.const 2
    i32.ge_s
    local.tee 1
    if  ;; label = @1
      local.get 0
      i32.const 0
      call $~lib/string/String#charAt
      i32.const 3320
      call $~lib/string/String.__eq
      local.set 1
    end
    local.get 1
    if (result i32)  ;; label = @1
      local.get 0
      i32.const 1
      call $~lib/string/String#charAt
      i32.const 3328
      call $~lib/string/String.__eq
    else
      local.get 1
    end
    if  ;; label = @1
      i32.const 1
      global.set 9
      i32.const 0
      local.set 1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            global.get 9
            i32.const 1
            i32.sub
            br_table 1 (;@3;) 2 (;@2;) 0 (;@4;)
          end
          unreachable
        end
        i32.const 2147483647
        local.set 1
      end
      local.get 0
      i32.const 2
      local.get 1
      call $~lib/string/String#substr
      local.set 0
    end
    local.get 0
    i32.load
    i32.const 2
    i32.div_s
    local.set 1
    i32.const 12
    call $~lib/allocator/arena/__memory_allocate
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray#constructor
    local.set 2
    i32.const 0
    local.set 1
    loop  ;; label = @1
      local.get 1
      local.get 0
      i32.load
      i32.lt_s
      if  ;; label = @2
        local.get 2
        local.get 1
        i32.const 2
        i32.div_s
        local.get 0
        local.get 1
        i32.const 2
        call $~lib/string/String#substr
        call $~lib/internal/string/parse<i32>
        i32.const 24
        i32.shl
        i32.const 24
        i32.shr_s
        call $~lib/internal/typedarray/TypedArray<u8>#__set
        local.get 1
        i32.const 2
        i32.add
        local.set 1
        br 1 (;@1;)
      end
    end
    local.get 2)
  (func $src/tests/runTests~anonymous|6 (type 0)
    (local i32)
    call $generated/Gravity/Gravity/NewGravatar#constructor
    call $~lib/subtest-as/assembly/event/addMetadata
    local.tee 0
    i32.load offset=12
    i32.const 272
    call $~lib/string/String.__ne
    if  ;; label = @1
      i32.const 2872
      i32.const 272
      call $~lib/string/String.__concat
      i32.const 2960
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=12
      call $~lib/string/String.__concat
      i32.const 3008
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load
    i32.const 8
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    call $~lib/@graphprotocol/graph-ts/index/ByteArray#notEqual
    if  ;; label = @1
      i32.const 3032
      i32.const 8
      call $~lib/string/String.__concat
      i32.const 3112
      call $~lib/string/String.__concat
      local.get 0
      i32.load
      call $~lib/@graphprotocol/graph-ts/index/typeConversion.bytesToHex
      call $~lib/string/String.__concat
      i32.const 3008
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load offset=4
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    call $~lib/@graphprotocol/graph-ts/index/BigInt#notEqual
    if  ;; label = @1
      i32.const 3176
      i32.const 2864
      call $~lib/string/String.__concat
      i32.const 2960
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=4
      call $~lib/@graphprotocol/graph-ts/index/typeConversion.bigIntToString
      call $~lib/string/String.__concat
      i32.const 3008
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load offset=16
    i32.load
    i32.const 8
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromHexString
    call $~lib/@graphprotocol/graph-ts/index/ByteArray#notEqual
    if  ;; label = @1
      i32.const 3336
      i32.const 8
      call $~lib/string/String.__concat
      i32.const 3112
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=16
      i32.load
      call $~lib/@graphprotocol/graph-ts/index/typeConversion.bytesToHex
      call $~lib/string/String.__concat
      i32.const 3008
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load offset=24
    i32.const 0
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
    i32.load
    i32.const 256
    call $~lib/string/String.__ne
    if  ;; label = @1
      i32.const 3424
      i32.const 256
      call $~lib/string/String.__concat
      i32.const 3528
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=24
      i32.const 0
      call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
      i32.load
      call $~lib/string/String.__concat
      i32.const 3008
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end)
  (func $src/tests/runTests~anonymous|7 (type 0)
    (local i32)
    call $generated/Gravity/Gravity/NewGravatar#constructor
    call $~lib/subtest-as/assembly/event/addMetadata
    local.tee 0
    i32.const 3608
    i32.store offset=12
    local.get 0
    i32.const 3648
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store
    local.get 0
    i32.load offset=16
    i32.const 3736
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromHexString
    i32.store
    local.get 0
    i32.const 42
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=4
    local.get 0
    i32.load offset=24
    i32.const 0
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
    i32.const 3832
    i32.store
    local.get 0
    i32.load offset=12
    i32.const 3608
    call $~lib/string/String.__ne
    if  ;; label = @1
      i32.const 3856
      i32.const 3608
      call $~lib/string/String.__concat
      i32.const 3528
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=12
      call $~lib/string/String.__concat
      i32.const 3008
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load
    i32.const 3648
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    call $~lib/@graphprotocol/graph-ts/index/ByteArray#notEqual
    if  ;; label = @1
      i32.const 3032
      i32.const 3648
      call $~lib/string/String.__concat
      i32.const 3112
      call $~lib/string/String.__concat
      local.get 0
      i32.load
      call $~lib/@graphprotocol/graph-ts/index/typeConversion.bytesToHex
      call $~lib/string/String.__concat
      i32.const 3008
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load offset=4
    i32.const 42
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    call $~lib/@graphprotocol/graph-ts/index/BigInt#notEqual
    if  ;; label = @1
      i32.const 3176
      i32.const 3824
      call $~lib/string/String.__concat
      i32.const 2960
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=4
      call $~lib/@graphprotocol/graph-ts/index/typeConversion.bigIntToString
      call $~lib/string/String.__concat
      i32.const 3008
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load offset=16
    i32.load
    i32.const 3736
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromHexString
    call $~lib/@graphprotocol/graph-ts/index/ByteArray#notEqual
    if  ;; label = @1
      i32.const 3336
      i32.const 3736
      call $~lib/string/String.__concat
      i32.const 3112
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=16
      i32.load
      call $~lib/@graphprotocol/graph-ts/index/typeConversion.bytesToHex
      call $~lib/string/String.__concat
      i32.const 3008
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load offset=24
    i32.const 0
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
    i32.load
    i32.const 3832
    call $~lib/string/String.__ne
    if  ;; label = @1
      i32.const 3424
      i32.const 3832
      call $~lib/string/String.__concat
      i32.const 3528
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=24
      i32.const 0
      call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
      i32.load
      call $~lib/string/String.__concat
      i32.const 3008
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end)
  (func $src/tests/runTests (type 0)
    i32.const 1664
    i32.const 3
    call $~lib/subtest-as/assembly/index/test
    i32.const 2016
    i32.const 4
    call $~lib/subtest-as/assembly/index/test
    i32.const 2152
    i32.const 5
    call $~lib/subtest-as/assembly/index/test
    i32.const 2328
    i32.const 6
    call $~lib/subtest-as/assembly/index/test
    i32.const 2424
    i32.const 7
    call $~lib/subtest-as/assembly/index/test
    i32.const 2640
    i32.const 8
    call $~lib/subtest-as/assembly/index/test
    i32.const 2776
    i32.const 9
    call $~lib/subtest-as/assembly/index/test
    i32.const 3552
    i32.const 10
    call $~lib/subtest-as/assembly/index/test)
  (func $~lib/internal/memory/memcmp (type 6) (param i32 i32 i32) (result i32)
    (local i32)
    local.get 0
    local.get 1
    i32.eq
    if  ;; label = @1
      i32.const 0
      return
    end
    loop  ;; label = @1
      local.get 2
      i32.const 0
      i32.ne
      local.tee 3
      if (result i32)  ;; label = @2
        local.get 0
        i32.load8_u
        local.get 1
        i32.load8_u
        i32.eq
      else
        local.get 3
      end
      if  ;; label = @2
        local.get 2
        i32.const 1
        i32.sub
        local.set 2
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        br 1 (;@1;)
      end
    end
    local.get 2
    if (result i32)  ;; label = @1
      local.get 0
      i32.load8_u
      local.get 1
      i32.load8_u
      i32.sub
    else
      i32.const 0
    end)
  (func $~lib/memory/memory.compare (type 6) (param i32 i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 2
    call $~lib/internal/memory/memcmp)
  (func $~lib/memory/memory.free (type 5) (param i32)
    nop)
  (func $~lib/memory/memory.reset (type 0)
    global.get 0
    global.set 1)
  (func $start (type 0)
    i32.const 3936
    global.set 0
    global.get 0
    global.set 1
    call $start:~lib/subtest-as/assembly/event)
  (func $null (type 0)
    nop)
  (table (;0;) 11 funcref)
  (memory (;0;) 1)
  (global (;0;) (mut i32) (i32.const 0))
  (global (;1;) (mut i32) (i32.const 0))
  (global (;2;) (mut i32) (i32.const 0))
  (global (;3;) (mut i32) (i32.const 0))
  (global (;4;) (mut i32) (i32.const 0))
  (global (;5;) (mut i32) (i32.const 0))
  (global (;6;) (mut i32) (i32.const 0))
  (global (;7;) (mut i32) (i32.const 0))
  (global (;8;) (mut i32) (i32.const 456))
  (global (;9;) (mut i32) (i32.const 0))
  (export "memory" (memory 0))
  (export "table" (table 0))
  (export "handleNewGravatar" (func $src/mapping/handleNewGravatar))
  (export "handleNewGravatars" (func $src/mapping/handleNewGravatars))
  (export "handleUpdatedGravatar" (func $src/mapping/handleUpdatedGravatar))
  (export "test" (func $src/mapping/test))
  (export "createNewGravatarEvent" (func $src/mapping/createNewGravatarEvent))
  (export "runTests" (func $src/tests/runTests))
  (export "memory.compare" (func $~lib/memory/memory.compare))
  (export "memory.allocate" (func $~lib/memory/memory.allocate))
  (export "memory.free" (func $~lib/memory/memory.free))
  (export "memory.reset" (func $~lib/memory/memory.reset))
  (start $start)
  (elem (;0;) (i32.const 0) func $null $src/mapping/handleNewGravatars~anonymous|0 $src/tests/runTests~anonymous|0~anonymous|0 $src/tests/runTests~anonymous|0 $src/tests/runTests~anonymous|1 $src/tests/runTests~anonymous|2 $src/tests/runTests~anonymous|3 $src/tests/runTests~anonymous|4 $src/tests/runTests~anonymous|5 $src/tests/runTests~anonymous|6 $src/tests/runTests~anonymous|7)
  (data (;0;) (i32.const 8) "*\00\00\000\00x\00A\001\006\000\008\001\00F\003\006\000\00e\003\008\004\007\000\000\006\00d\00B\006\006\000\00b\00a\00e\001\00c\006\00d\001\00b\002\00e\001\007\00e\00C\002\00A")
  (data (;1;) (i32.const 96) "\1b\00\00\00~\00l\00i\00b\00/\00i\00n\00t\00e\00r\00n\00a\00l\00/\00t\00y\00p\00e\00d\00a\00r\00r\00a\00y\00.\00t\00s")
  (data (;2;) (i32.const 160) "\1c\00\00\00~\00l\00i\00b\00/\00i\00n\00t\00e\00r\00n\00a\00l\00/\00a\00r\00r\00a\00y\00b\00u\00f\00f\00e\00r\00.\00t\00s")
  (data (;3;) (i32.const 224) "\0d\00\00\00~\00l\00i\00b\00/\00a\00r\00r\00a\00y\00.\00t\00s")
  (data (;4;) (i32.const 256) "\04\00\00\00n\00a\00m\00e")
  (data (;5;) (i32.const 272) "\10\00\00\00d\00e\00f\00a\00u\00l\00t\00_\00l\00o\00g\00_\00t\00y\00p\00e")
  (data (;6;) (i32.const 312) "C\00\00\00Y\00o\00u\00 \00c\00a\00n\00'\00t\00 \00m\00o\00d\00i\00f\00y\00 \00a\00 \00M\00o\00c\00k\00e\00d\00F\00u\00n\00c\00t\00i\00o\00n\00 \00i\00n\00s\00t\00a\00n\00c\00e\00 \00a\00f\00t\00e\00r\00 \00i\00t\00 \00h\00a\00s\00 \00b\00e\00e\00n\00 \00s\00a\00v\00e\00d\00.")
  (data (;7;) (i32.const 456) "\08\00\00\00G\00r\00a\00v\00a\00t\00a\00r")
  (data (;8;) (i32.const 480) "\02\00\00\00i\00d")
  (data (;9;) (i32.const 488) "%\00\00\00E\00t\00h\00e\00r\00e\00u\00m\00 \00v\00a\00l\00u\00e\00 \00i\00s\00 \00n\00o\00t\00 \00a\00n\00 \00i\00n\00t\00 \00o\00r\00 \00u\00i\00n\00t\00.")
  (data (;10;) (i32.const 568) ".\00\00\00~\00l\00i\00b\00/\00@\00g\00r\00a\00p\00h\00p\00r\00o\00t\00o\00c\00o\00l\00/\00g\00r\00a\00p\00h\00-\00t\00s\00/\00c\00h\00a\00i\00n\00/\00e\00t\00h\00e\00r\00e\00u\00m\00.\00t\00s")
  (data (;11;) (i32.const 664) " \00\00\00E\00t\00h\00e\00r\00e\00u\00m\00 \00v\00a\00l\00u\00e\00 \00i\00s\00 \00n\00o\00t\00 \00a\00n\00 \00a\00d\00d\00r\00e\00s\00s")
  (data (;12;) (i32.const 736) "\05\00\00\00o\00w\00n\00e\00r")
  (data (;13;) (i32.const 752) "\1f\00\00\00E\00t\00h\00e\00r\00e\00u\00m\00 \00v\00a\00l\00u\00e\00 \00i\00s\00 \00n\00o\00t\00 \00a\00 \00s\00t\00r\00i\00n\00g\00.")
  (data (;14;) (i32.const 824) "\0b\00\00\00d\00i\00s\00p\00l\00a\00y\00N\00a\00m\00e")
  (data (;15;) (i32.const 856) "\08\00\00\00i\00m\00a\00g\00e\00U\00r\00l")
  (data (;16;) (i32.const 880) ")\00\00\00C\00a\00n\00n\00o\00t\00 \00s\00a\00v\00e\00 \00G\00r\00a\00v\00a\00t\00a\00r\00 \00e\00n\00t\00i\00t\00y\00 \00w\00i\00t\00h\00o\00u\00t\00 \00a\00n\00 \00I\00D")
  (data (;17;) (i32.const 968) "\13\00\00\00g\00e\00n\00e\00r\00a\00t\00e\00d\00/\00s\00c\00h\00e\00m\00a\00.\00t\00s")
  (data (;18;) (i32.const 1016) "0\00\00\00C\00a\00n\00n\00o\00t\00 \00s\00a\00v\00e\00 \00G\00r\00a\00v\00a\00t\00a\00r\00 \00e\00n\00t\00i\00t\00y\00 \00w\00i\00t\00h\00 \00n\00o\00n\00-\00s\00t\00r\00i\00n\00g\00 \00I\00D\00.\00 ")
  (data (;19;) (i32.const 1120) ";\00\00\00C\00o\00n\00s\00i\00d\00e\00r\00i\00n\00g\00 \00u\00s\00i\00n\00g\00 \00.\00t\00o\00H\00e\00x\00(\00)\00 \00t\00o\00 \00c\00o\00n\00v\00e\00r\00t\00 \00t\00h\00e\00 \00\22\00i\00d\00\22\00 \00t\00o\00 \00a\00 \00s\00t\00r\00i\00n\00g\00.")
  (data (;20;) (i32.const 1248) "\04\00\00\00n\00u\00l\00l")
  (data (;21;) (i32.const 1264) "\0e\00\00\00~\00l\00i\00b\00/\00s\00t\00r\00i\00n\00g\00.\00t\00s")
  (data (;22;) (i32.const 1304) "\17\00\00\00~\00l\00i\00b\00/\00i\00n\00t\00e\00r\00n\00a\00l\00/\00s\00t\00r\00i\00n\00g\00.\00t\00s")
  (data (;23;) (i32.const 1360) "\16\00\00\00V\00a\00l\00u\00e\00 \00i\00s\00 \00n\00o\00t\00 \00a\00 \00s\00t\00r\00i\00n\00g\00.")
  (data (;24;) (i32.const 1408) "%\00\00\00~\00l\00i\00b\00/\00@\00g\00r\00a\00p\00h\00p\00r\00o\00t\00o\00c\00o\00l\00/\00g\00r\00a\00p\00h\00-\00t\00s\00/\00i\00n\00d\00e\00x\00.\00t\00s")
  (data (;25;) (i32.const 1488) "\03\00\00\00s\00d\00f")
  (data (;26;) (i32.const 1504) "\16\00\00\000\00x\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000")
  (data (;27;) (i32.const 1552) "\03\00\00\00S\00d\00f")
  (data (;28;) (i32.const 1576) " \06")
  (data (;29;) (i32.const 1584) "%\00\00\00A\00d\00d\00r\00e\00s\00s\00 \00m\00u\00s\00t\00 \00c\00o\00n\00t\00a\00i\00n\00 \00e\00x\00a\00c\00t\00l\00y\00 \002\000\00 \00b\00y\00t\00e\00s")
  (data (;30;) (i32.const 1664) "\11\00\00\00C\00a\00n\00 \00m\00o\00c\00k\00 \00f\00u\00n\00c\00t\00i\00o\00n")
  (data (;31;) (i32.const 1704) "\08\00\00\00r\00e\00d\00u\00c\00t\00o\00!")
  (data (;32;) (i32.const 1728) "\08\00\00\00\00\00\00\00\fac\02\00\14\e2\01")
  (data (;33;) (i32.const 1744) "\c0\06\00\00\02")
  (data (;34;) (i32.const 1752) "*\00\00\000\00x\008\009\002\000\005\00A\003\00A\003\00b\002\00A\006\009\00D\00e\006\00D\00b\00f\007\00f\000\001\00E\00D\001\003\00B\002\001\000\008\00B\002\00c\004\003\00e\007")
  (data (;35;) (i32.const 1840) "*\00\00\000\00x\009\000\00c\00B\00a\002\00B\00b\00b\001\009\00e\00c\00c\002\009\001\00A\001\002\000\006\006\00F\00d\008\003\002\009\00D\006\005\00F\00A\001\00f\001\009\004\007")
  (data (;36;) (i32.const 1928) "\08\00\00\00f\00u\00n\00c\00N\00a\00m\00e")
  (data (;37;) (i32.const 1952) "\04\00\00\00a\00r\00g\001")
  (data (;38;) (i32.const 1968) "\04\00\00\00a\00r\00g\002")
  (data (;39;) (i32.const 1984) "\04\00\00\00a\00r\00g\003")
  (data (;40;) (i32.const 2000) "\06\00\00\00r\00e\00s\00u\00l\00t")
  (data (;41;) (i32.const 2016) "4\00\00\00C\00a\00n\00 \00i\00n\00i\00t\00i\00a\00l\00i\00s\00e\00 \00s\00t\00o\00r\00e\00 \00w\00i\00t\00h\00 \00a\00n\00 \00a\00r\00r\00a\00y\00 \00o\00f\00 \00E\00n\00t\00i\00t\00y\00 \00o\00b\00j\00e\00c\00t\00s")
  (data (;42;) (i32.const 2128) "\07\00\00\00e\00n\00t\00r\00y\00I\00d")
  (data (;43;) (i32.const 2152) "$\00\00\00C\00a\00n\00 \00c\00a\00l\00l\00 \00m\00a\00p\00p\00i\00n\00g\00s\00 \00w\00i\00t\00h\00 \00c\00u\00s\00t\00o\00m\00 \00e\00v\00e\00n\00t\00s")
  (data (;44;) (i32.const 2232) "\0b\00\00\00g\00r\00a\00v\00a\00t\00a\00r\00I\00d\000")
  (data (;45;) (i32.const 2264) "\03\00\00\00c\00a\00p")
  (data (;46;) (i32.const 2280) "\03\00\00\00p\00a\00c")
  (data (;47;) (i32.const 2296) "\05\00\00\001\002\003\004\005")
  (data (;48;) (i32.const 2312) "\04\00\00\003\005\004\006")
  (data (;49;) (i32.const 2328) "*\00\00\00C\00a\00n\00 \00a\00d\00d\00,\00 \00g\00e\00t\00,\00 \00a\00s\00s\00e\00r\00t\00 \00a\00n\00d\00 \00r\00e\00m\00o\00v\00e\00 \00f\00r\00o\00m\00 \00s\00t\00o\00r\00e")
  (data (;50;) (i32.const 2416) "\02\00\00\002\003")
  (data (;51;) (i32.const 2424) "$\00\00\00C\00a\00n\00 \00m\00o\00c\00k\00 \00a\00n\00d\00 \00c\00a\00l\00l\00 \00f\00u\00n\00c\00t\00i\00o\00n\00 \00c\00o\00r\00r\00e\00c\00t\00l\00y")
  (data (;52;) (i32.const 2504) "\0e\00\00\000\00x\000\000\000\000\000\001\002\003\004\001\002\003")
  (data (;53;) (i32.const 2536) "\0f\00\00\00e\00x\00a\00m\00p\00l\00e\00F\00u\00n\00c\00N\00a\00m\00e")
  (data (;54;) (i32.const 2576) "\06\00\00\00p\00a\00r\00a\00m\001")
  (data (;55;) (i32.const 2592) "\06\00\00\00p\00a\00r\00a\00m\002")
  (data (;56;) (i32.const 2608) "\0b\00\00\00r\00e\00t\00u\00r\00n\00V\00a\00l\00u\00e")
  (data (;57;) (i32.const 2640) "#\00\00\00C\00a\00n\00 \00t\00e\00s\00t\00 \00i\00f\00 \00m\00o\00c\00k\00e\00d\00 \00f\00u\00n\00c\00t\00i\00o\00n\00 \00r\00e\00v\00e\00r\00t\00s")
  (data (;58;) (i32.const 2720) "\11\00\00\000\00x\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000")
  (data (;59;) (i32.const 2760) "\06\00\00\00r\00e\00v\00e\00r\00t")
  (data (;60;) (i32.const 2776) "*\00\00\00C\00a\00n\00 \00i\00n\00i\00t\00i\00a\00l\00i\00s\00e\00 \00e\00v\00e\00n\00t\00 \00w\00i\00t\00h\00 \00d\00e\00f\00a\00u\00l\00t\00 \00m\00e\00t\00a\00d\00a\00t\00a")
  (data (;61;) (i32.const 2864) "\01\00\00\001")
  (data (;62;) (i32.const 2872) ")\00\00\00n\00e\00w\00G\00r\00a\00v\00a\00t\00a\00r\00E\00v\00e\00n\00t\00.\00l\00o\00g\00T\00y\00p\00e\00 \00e\00x\00p\00e\00c\00t\00e\00d\00 \00t\00o\00 \00b\00e\00 \00'")
  (data (;63;) (i32.const 2960) "\13\00\00\00'\00 \00b\00u\00t\00 \00a\00c\00t\00u\00a\00l\00l\00y\00 \00i\00s\00 \00'")
  (data (;64;) (i32.const 3008) "\0a\00\00\00'\00 \00i\00n\00s\00t\00e\00a\00d\00.")
  (data (;65;) (i32.const 3032) "$\00\00\00n\00e\00w\00G\00r\00a\00v\00a\00t\00a\00r\00E\00v\00e\00n\00t\00.\00a\00d\00d\00r\00e\00s\00s\00 \00s\00h\00o\00u\00l\00d\00 \00b\00e\00 \00'")
  (data (;66;) (i32.const 3112) "\1d\00\00\00'\00 \00(\00c\00a\00s\00e\00 \00i\00n\00s\00e\00n\00s\00i\00t\00i\00v\00e\00)\00 \00b\00u\00t\00 \00i\00s\00 \00'")
  (data (;67;) (i32.const 3176) "*\00\00\00n\00e\00w\00G\00r\00a\00v\00a\00t\00a\00r\00E\00v\00e\00n\00t\00.\00l\00o\00g\00I\00n\00d\00e\00x\00 \00e\00x\00p\00e\00c\00t\00e\00d\00 \00t\00o\00 \00b\00e\00 \00'")
  (data (;68;) (i32.const 3264) "\06\00\00\00i\00n\00p\00u\00t\00 ")
  (data (;69;) (i32.const 3280) "\0f\00\00\00 \00h\00a\00s\00 \00o\00d\00d\00 \00l\00e\00n\00g\00t\00h")
  (data (;70;) (i32.const 3320) "\01\00\00\000")
  (data (;71;) (i32.const 3328) "\01\00\00\00x")
  (data (;72;) (i32.const 3336) "'\00\00\00n\00e\00w\00G\00r\00a\00v\00a\00t\00a\00r\00E\00v\00e\00n\00t\00.\00b\00l\00o\00c\00k\00.\00h\00a\00s\00h\00 \00s\00h\00o\00u\00l\00d\00 \00b\00e\00 \00'")
  (data (;73;) (i32.const 3424) "/\00\00\00n\00e\00w\00G\00r\00a\00v\00a\00t\00a\00r\00E\00v\00e\00n\00t\00.\00p\00a\00r\00a\00m\00e\00t\00e\00r\00s\00[\000\00]\00.\00n\00a\00m\00e\00 \00s\00h\00o\00u\00l\00d\00 \00b\00e\00 \00'")
  (data (;74;) (i32.const 3528) "\0a\00\00\00'\00 \00b\00u\00t\00 \00i\00s\00 \00'")
  (data (;75;) (i32.const 3552) "\19\00\00\00C\00a\00n\00 \00u\00p\00d\00a\00t\00e\00 \00e\00v\00e\00n\00t\00 \00m\00e\00t\00a\00d\00a\00t\00a")
  (data (;76;) (i32.const 3608) "\10\00\00\00u\00p\00d\00a\00t\00e\00d\00_\00l\00o\00g\00_\00t\00y\00p\00e")
  (data (;77;) (i32.const 3648) "*\00\00\000\00x\00B\001\006\000\008\001\00F\003\006\000\00e\003\008\004\007\000\000\006\00d\00B\006\006\000\00b\00a\00e\001\00c\006\00d\001\00b\002\00e\001\007\00e\00C\002\00A")
  (data (;78;) (i32.const 3736) "*\00\00\000\00x\00C\001\006\000\008\001\00F\003\006\000\00e\003\008\004\007\000\000\006\00d\00B\006\006\000\00b\00a\00e\001\00c\006\00d\001\00b\002\00e\001\007\00e\00C\002\00A")
  (data (;79;) (i32.const 3824) "\02\00\00\004\002")
  (data (;80;) (i32.const 3832) "\08\00\00\00n\00e\00w\00_\00n\00a\00m\00e")
  (data (;81;) (i32.const 3856) "$\00\00\00n\00e\00w\00G\00r\00a\00v\00a\00t\00a\00r\00E\00v\00e\00n\00t\00.\00l\00o\00g\00T\00y\00p\00e\00 \00s\00h\00o\00u\00l\00d\00 \00b\00e\00 \00'"))
