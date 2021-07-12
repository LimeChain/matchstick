(module
  (type (;0;) (func))
  (type (;1;) (func (param i32) (result i32)))
  (type (;2;) (func (param i32)))
  (type (;3;) (func (param i32 i32 i32) (result i32)))
  (type (;4;) (func (param i32 i32 i32 i32)))
  (type (;5;) (func (param i32 i32 i32)))
  (type (;6;) (func (param i32 i32) (result i32)))
  (type (;7;) (func (param i32 i32)))
  (type (;8;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;9;) (func (param i32 i32 i32 i32 i32)))
  (type (;10;) (func (result i32)))
  (import "env" "abort" (func $~lib/env/abort (type 4)))
  (import "index" "typeConversion.stringToH160" (func $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160 (type 1)))
  (import "index" "typeConversion.bigIntToHex" (func $~lib/@graphprotocol/graph-ts/index/typeConversion.bigIntToHex (type 1)))
  (import "index" "store.get" (func $~lib/@graphprotocol/graph-ts/index/store.get (type 6)))
  (import "log" "log.log" (func $~lib/subtest-as/assembly/log/log.log (type 7)))
  (import "index" "testUtil.incrementSuccessfulTestsCount" (func $~lib/subtest-as/assembly/index/testUtil.incrementSuccessfulTestsCount (type 0)))
  (import "index" "testUtil.incrementFailedTestsCount" (func $~lib/subtest-as/assembly/index/testUtil.incrementFailedTestsCount (type 0)))
  (import "index" "typeConversion.bytesToHex" (func $~lib/@graphprotocol/graph-ts/index/typeConversion.bytesToHex (type 1)))
  (import "index" "typeConversion.bigIntToString" (func $~lib/@graphprotocol/graph-ts/index/typeConversion.bigIntToString (type 1)))
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
      i32.const 56
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
  (func $~lib/arraybuffer/ArrayBuffer#constructor (type 6) (param i32 i32) (result i32)
    (local i32)
    local.get 0
    i32.const 1073741816
    i32.gt_u
    if  ;; label = @1
      i32.const 0
      i32.const 8
      i32.const 47
      i32.const 40
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    call $~lib/internal/arraybuffer/allocateUnsafe
    local.set 2
    local.get 1
    i32.eqz
    if  ;; label = @1
      local.get 2
      i32.const 8
      i32.add
      local.get 0
      call $~lib/internal/memory/memset
    end
    local.get 2)
  (func $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#clear (type 2) (param i32)
    local.get 0
    i32.const 16
    i32.const 0
    call $~lib/arraybuffer/ArrayBuffer#constructor
    i32.store
    local.get 0
    i32.const 3
    i32.store offset=4
    local.get 0
    i32.const 48
    i32.const 1
    call $~lib/arraybuffer/ArrayBuffer#constructor
    i32.store offset=8
    local.get 0
    i32.const 4
    i32.store offset=12
    local.get 0
    i32.const 0
    i32.store offset=16
    local.get 0
    i32.const 0
    i32.store offset=20)
  (func $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#constructor (type 10) (result i32)
    (local i32)
    i32.const 24
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
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#clear
    local.get 0)
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
  (func $~lib/internal/typedarray/TypedArray<u8>#constructor (type 6) (param i32 i32) (result i32)
    (local i32 i32)
    local.get 1
    i32.const 1073741816
    i32.gt_u
    if  ;; label = @1
      i32.const 0
      i32.const 208
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
  (func $~lib/@graphprotocol/graph-ts/index/ByteArray#constructor (type 6) (param i32 i32) (result i32)
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
  (func $~lib/internal/typedarray/TypedArray<u8>#__set (type 5) (param i32 i32 i32)
    local.get 1
    local.get 0
    i32.load offset=8
    i32.ge_u
    if  ;; label = @1
      i32.const 0
      i32.const 208
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
      i32.const 272
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
  (func $~lib/internal/memory/memcpy (type 5) (param i32 i32 i32)
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
  (func $~lib/internal/memory/memmove (type 5) (param i32 i32 i32)
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
  (func $~lib/internal/arraybuffer/reallocateUnsafe (type 6) (param i32 i32) (result i32)
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
        i32.const 56
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
          i32.const 56
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
        i32.const 272
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
    global.set 4
    global.get 4
    i32.const 120
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store
    global.get 4
    i32.const 120
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=4
    global.get 4
    i32.const 120
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=8
    global.get 4
    i32.const 120
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=12
    global.get 4
    i32.const 120
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=16
    global.get 4
    i32.const 120
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=20
    global.get 4
    i32.const 120
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=24
    global.get 4
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=28
    global.get 4
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=32
    global.get 4
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=36
    global.get 4
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=40
    global.get 4
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=44
    global.get 4
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=48
    global.get 4
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=52
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Transaction#constructor
    global.set 5
    global.get 5
    i32.const 120
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store
    global.get 5
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=4
    global.get 5
    i32.const 120
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=8
    global.get 5
    i32.const 120
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=12
    global.get 5
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=16
    global.get 5
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=20
    global.get 5
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=24
    global.get 5
    i32.const 120
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store offset=28
    i32.const 0
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#constructor
    global.set 6
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam#constructor
    global.set 7
    global.get 7
    i32.const 304
    i32.store
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#constructor
    global.set 8
    global.get 8
    i32.const 3
    i32.store
    global.get 8
    i64.const 1
    i64.store offset=8
    global.get 6
    global.get 7
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#push
    i32.const 0
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Event#constructor
    global.set 9
    global.get 9
    i32.const 120
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store
    global.get 9
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=4
    global.get 9
    i32.const 320
    i32.store offset=12
    global.get 9
    global.get 4
    i32.store offset=16
    global.get 9
    global.get 5
    i32.store offset=20
    global.get 9
    global.get 6
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
  (func $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get (type 6) (param i32 i32) (result i32)
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
  (func $~lib/internal/string/compareUnsafe (type 3) (param i32 i32 i32) (result i32)
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
  (func $~lib/string/String.__eq (type 6) (param i32 i32) (result i32)
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
  (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#getEntry (type 6) (param i32 i32) (result i32)
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
  (func $~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#constructor (type 6) (param i32 i32) (result i32)
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
  (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set (type 5) (param i32 i32 i32)
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
    i32.const 384
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
      i32.const 392
      i32.const 472
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
      i32.const 568
      i32.const 472
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
    i32.const 640
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
      i32.const 656
      i32.const 472
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
    i32.const 728
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
    i32.const 760
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/Value.fromString
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set)
  (func $~lib/internal/hash/hashStr (type 1) (param i32) (result i32)
    (local i32 i32 i32)
    i32.const -2128831035
    local.set 2
    local.get 0
    i32.load
    i32.const 1
    i32.shl
    local.set 3
    loop  ;; label = @1
      block  ;; label = @2
        local.get 1
        local.get 3
        i32.ge_u
        br_if 0 (;@2;)
        local.get 2
        local.get 0
        local.get 1
        i32.add
        i32.load8_u offset=4
        i32.xor
        i32.const 16777619
        i32.mul
        local.set 2
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        br 1 (;@1;)
      end
    end
    local.get 2)
  (func $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#find (type 3) (param i32 i32 i32) (result i32)
    local.get 0
    i32.load
    local.get 2
    local.get 0
    i32.load offset=4
    i32.and
    i32.const 2
    i32.shl
    i32.add
    i32.load offset=8
    local.set 0
    loop  ;; label = @1
      local.get 0
      if  ;; label = @2
        local.get 0
        i32.load offset=8
        i32.const 1
        i32.and
        i32.eqz
        local.tee 2
        if (result i32)  ;; label = @3
          local.get 0
          i32.load
          local.get 1
          call $~lib/string/String.__eq
        else
          local.get 2
        end
        if  ;; label = @3
          local.get 0
          return
        end
        local.get 0
        i32.load offset=8
        i32.const -2
        i32.and
        local.set 0
        br 1 (;@1;)
      end
    end
    i32.const 0)
  (func $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#has (type 6) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 1
    call $~lib/internal/hash/hashStr
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#find
    i32.const 0
    i32.ne)
  (func $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#rehash (type 7) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    local.get 1
    i32.const 1
    i32.add
    local.tee 3
    i32.const 2
    i32.shl
    i32.const 0
    call $~lib/arraybuffer/ArrayBuffer#constructor
    local.set 5
    local.get 3
    f64.convert_i32_s
    f64.const 0x1.5555555555555p+1 (;=2.66667;)
    f64.mul
    i32.trunc_f64_s
    local.tee 7
    i32.const 12
    i32.mul
    i32.const 1
    call $~lib/arraybuffer/ArrayBuffer#constructor
    local.set 6
    local.get 0
    i32.load offset=8
    i32.const 8
    i32.add
    local.tee 3
    local.get 0
    i32.load offset=16
    i32.const 12
    i32.mul
    i32.add
    local.set 8
    local.get 6
    i32.const 8
    i32.add
    local.set 2
    loop  ;; label = @1
      local.get 3
      local.get 8
      i32.ne
      if  ;; label = @2
        local.get 3
        local.tee 4
        i32.load offset=8
        i32.const 1
        i32.and
        i32.eqz
        if  ;; label = @3
          local.get 2
          local.get 4
          i32.load
          i32.store
          local.get 2
          local.get 4
          i32.load offset=4
          i32.store offset=4
          local.get 2
          local.get 5
          local.get 4
          i32.load
          call $~lib/internal/hash/hashStr
          local.get 1
          i32.and
          i32.const 2
          i32.shl
          i32.add
          local.tee 4
          i32.load offset=8
          i32.store offset=8
          local.get 4
          local.get 2
          i32.store offset=8
          local.get 2
          i32.const 12
          i32.add
          local.set 2
        end
        local.get 3
        i32.const 12
        i32.add
        local.set 3
        br 1 (;@1;)
      end
    end
    local.get 0
    local.get 5
    i32.store
    local.get 0
    local.get 1
    i32.store offset=4
    local.get 0
    local.get 6
    i32.store offset=8
    local.get 0
    local.get 7
    i32.store offset=12
    local.get 0
    local.get 0
    i32.load offset=20
    i32.store offset=16)
  (func $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#set (type 5) (param i32 i32 i32)
    (local i32 i32)
    local.get 0
    local.get 1
    local.get 1
    call $~lib/internal/hash/hashStr
    local.tee 4
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#find
    local.tee 3
    if  ;; label = @1
      local.get 3
      local.get 2
      i32.store offset=4
    else
      local.get 0
      i32.load offset=16
      local.get 0
      i32.load offset=12
      i32.eq
      if  ;; label = @2
        local.get 0
        local.get 0
        i32.load offset=20
        local.get 0
        i32.load offset=12
        f64.convert_i32_s
        f64.const 0x1.8p-1 (;=0.75;)
        f64.mul
        i32.trunc_f64_s
        i32.lt_s
        if (result i32)  ;; label = @3
          local.get 0
          i32.load offset=4
        else
          local.get 0
          i32.load offset=4
          i32.const 1
          i32.shl
          i32.const 1
          i32.or
        end
        call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#rehash
      end
      local.get 0
      i32.load offset=8
      i32.const 8
      i32.add
      local.get 0
      local.get 0
      i32.load offset=16
      local.tee 3
      i32.const 1
      i32.add
      i32.store offset=16
      local.get 3
      i32.const 12
      i32.mul
      i32.add
      local.tee 3
      local.get 1
      i32.store
      local.get 3
      local.get 2
      i32.store offset=4
      local.get 0
      local.get 0
      i32.load offset=20
      i32.const 1
      i32.add
      i32.store offset=20
      local.get 3
      local.get 0
      i32.load
      local.get 4
      local.get 0
      i32.load offset=4
      i32.and
      i32.const 2
      i32.shl
      i32.add
      local.tee 0
      i32.load offset=8
      i32.store offset=8
      local.get 0
      local.get 3
      i32.store offset=8
    end)
  (func $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get (type 6) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 1
    call $~lib/internal/hash/hashStr
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#find
    local.tee 0
    if (result i32)  ;; label = @1
      local.get 0
      i32.load offset=4
    else
      unreachable
    end)
  (func $~lib/subtest-as/assembly/store/store.set (type 5) (param i32 i32 i32)
    global.get 2
    local.get 0
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#has
    i32.eqz
    if  ;; label = @1
      global.get 2
      local.get 0
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#constructor
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#set
    end
    global.get 2
    local.get 0
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
    local.get 1
    local.get 2
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#set)
  (func $src/mapping/handleNewGravatar (type 2) (param i32)
    (local i32)
    local.get 0
    call $generated/Gravity/Gravity/NewGravatar__Params#constructor
    call $generated/Gravity/Gravity/NewGravatar__Params#get:id
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.bigIntToHex
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
    global.get 12
    local.get 0
    call $generated/Gravity/Gravity/NewGravatar__Params#constructor
    call $generated/Gravity/Gravity/NewGravatar__Params#get:id
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.bigIntToHex
    local.get 1
    call $~lib/subtest-as/assembly/store/store.set)
  (func $src/mapping/handleNewGravatars~anonymous|0 (type 5) (param i32 i32 i32)
    local.get 0
    call $src/mapping/handleNewGravatar)
  (func $~lib/array/Array<generated/Gravity/Gravity/NewGravatar>#forEach (type 2) (param i32)
    (local i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.load offset=4
      local.set 2
      loop  ;; label = @2
        local.get 1
        local.get 2
        local.get 0
        i32.load offset=4
        local.tee 3
        local.get 2
        local.get 3
        i32.lt_s
        select
        i32.ge_s
        br_if 1 (;@1;)
        i32.const 3
        global.set 13
        local.get 0
        i32.load
        local.get 1
        i32.const 2
        i32.shl
        i32.add
        i32.load offset=8
        local.get 1
        local.get 0
        i32.const 1
        call_indirect (type 5)
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        br 0 (;@2;)
      end
      unreachable
    end)
  (func $src/mapping/handleNewGravatars (type 2) (param i32)
    local.get 0
    call $~lib/array/Array<generated/Gravity/Gravity/NewGravatar>#forEach)
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
        i32.const 384
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
  (func $~lib/@graphprotocol/graph-ts/index/Value#toString (type 1) (param i32) (result i32)
    local.get 0
    i32.load
    if  ;; label = @1
      i32.const 784
      i32.const 832
      i32.const 806
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i64.load offset=8
    i32.wrap_i64)
  (func $generated/schema/Gravatar#get:id (type 1) (param i32) (result i32)
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
    call $~lib/@graphprotocol/graph-ts/index/Value#toString)
  (func $src/mapping/handleUpdatedGravatar (type 2) (param i32)
    (local i32 i32)
    i32.const 360
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
    global.get 12
    local.get 1
    call $generated/schema/Gravatar#get:id
    local.get 1
    call $~lib/subtest-as/assembly/store/store.set)
  (func $generated/Gravity/Gravity/NewGravatar#constructor (type 10) (result i32)
    i32.const 28
    call $~lib/allocator/arena/__memory_allocate
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Event#constructor)
  (func $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value.fromAddress (type 1) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.load offset=8
    i32.const 20
    i32.ne
    if  ;; label = @1
      i32.const 912
      i32.const 472
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
  (func $src/mapping/createNewGravatarEvent (type 8) (param i32 i32 i32 i32) (result i32)
    (local i32 i32 i32)
    call $generated/Gravity/Gravity/NewGravatar#constructor
    local.tee 4
    i32.const 0
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#constructor
    i32.store offset=24
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam#constructor
    local.tee 6
    call $~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.Value#constructor
    local.tee 5
    i32.const 3
    i32.store
    local.get 5
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i64.extend_i32_u
    i64.store offset=8
    local.get 5
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
    local.get 6
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
      i32.const 1360
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
  (func $~lib/internal/string/copyUnsafe (type 9) (param i32 i32 i32 i32 i32)
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
  (func $~lib/string/String#concat (type 6) (param i32 i32) (result i32)
    (local i32 i32 i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 0
      i32.const 1320
      i32.const 110
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i32.load
    local.tee 3
    local.get 1
    i32.const 1304
    local.get 1
    select
    local.tee 1
    i32.load
    local.tee 4
    i32.add
    local.tee 2
    i32.eqz
    if  ;; label = @1
      i32.const 1352
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
  (func $~lib/string/String.__concat (type 6) (param i32 i32) (result i32)
    local.get 0
    i32.const 1304
    local.get 0
    select
    local.get 1
    call $~lib/string/String#concat)
  (func $~lib/string/String#charCodeAt (type 6) (param i32 i32) (result i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 0
      i32.const 1320
      i32.const 75
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 1
    local.get 0
    i32.load
    i32.ge_u
    if  ;; label = @1
      i32.const -1
      return
    end
    local.get 0
    local.get 1
    i32.const 1
    i32.shl
    i32.add
    i32.load16_u offset=4)
  (func $~lib/subtest-as/assembly/index/createHash (type 3) (param i32 i32 i32) (result i32)
    local.get 0
    local.get 1
    call $~lib/string/String.__concat
    local.set 1
    i32.const 0
    local.set 0
    loop  ;; label = @1
      block  ;; label = @2
        local.get 0
        local.get 2
        i32.load offset=4
        i32.ge_s
        br_if 0 (;@2;)
        local.get 1
        local.get 2
        local.get 0
        call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
        call $~lib/string/String#concat
        drop
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        br 1 (;@1;)
      end
    end
    i32.const 0
    local.set 0
    local.get 1
    i32.load
    i32.eqz
    if  ;; label = @1
      local.get 0
      return
    end
    i32.const 0
    local.set 2
    loop  ;; label = @1
      block  ;; label = @2
        local.get 2
        local.get 1
        i32.load
        i32.ge_s
        br_if 0 (;@2;)
        local.get 1
        local.get 2
        call $~lib/string/String#charCodeAt
        local.get 0
        i32.const 5
        i32.shl
        local.get 0
        i32.sub
        i32.add
        local.set 0
        local.get 2
        i32.const 1
        i32.add
        local.set 2
        br 1 (;@1;)
      end
    end
    local.get 0)
  (func $~lib/internal/hash/hash32 (type 1) (param i32) (result i32)
    local.get 0
    i32.const 255
    i32.and
    i32.const -2128831035
    i32.xor
    i32.const 16777619
    i32.mul
    local.get 0
    i32.const 8
    i32.shr_u
    i32.const 255
    i32.and
    i32.xor
    i32.const 16777619
    i32.mul
    local.get 0
    i32.const 16
    i32.shr_u
    i32.const 255
    i32.and
    i32.xor
    i32.const 16777619
    i32.mul
    local.get 0
    i32.const 24
    i32.shr_u
    i32.xor
    i32.const 16777619
    i32.mul)
  (func $~lib/map/Map<i32_~lib/string/String>#find (type 3) (param i32 i32 i32) (result i32)
    local.get 0
    i32.load
    local.get 2
    local.get 0
    i32.load offset=4
    i32.and
    i32.const 2
    i32.shl
    i32.add
    i32.load offset=8
    local.set 0
    loop  ;; label = @1
      local.get 0
      if  ;; label = @2
        local.get 0
        i32.load offset=8
        i32.const 1
        i32.and
        i32.eqz
        local.tee 2
        if (result i32)  ;; label = @3
          local.get 0
          i32.load
          local.get 1
          i32.eq
        else
          local.get 2
        end
        if  ;; label = @3
          local.get 0
          return
        end
        local.get 0
        i32.load offset=8
        i32.const -2
        i32.and
        local.set 0
        br 1 (;@1;)
      end
    end
    i32.const 0)
  (func $~lib/map/Map<i32_~lib/string/String>#rehash (type 7) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    local.get 1
    i32.const 1
    i32.add
    local.tee 3
    i32.const 2
    i32.shl
    i32.const 0
    call $~lib/arraybuffer/ArrayBuffer#constructor
    local.set 5
    local.get 3
    f64.convert_i32_s
    f64.const 0x1.5555555555555p+1 (;=2.66667;)
    f64.mul
    i32.trunc_f64_s
    local.tee 7
    i32.const 12
    i32.mul
    i32.const 1
    call $~lib/arraybuffer/ArrayBuffer#constructor
    local.set 6
    local.get 0
    i32.load offset=8
    i32.const 8
    i32.add
    local.tee 3
    local.get 0
    i32.load offset=16
    i32.const 12
    i32.mul
    i32.add
    local.set 8
    local.get 6
    i32.const 8
    i32.add
    local.set 2
    loop  ;; label = @1
      local.get 3
      local.get 8
      i32.ne
      if  ;; label = @2
        local.get 3
        local.tee 4
        i32.load offset=8
        i32.const 1
        i32.and
        i32.eqz
        if  ;; label = @3
          local.get 2
          local.get 4
          i32.load
          i32.store
          local.get 2
          local.get 4
          i32.load offset=4
          i32.store offset=4
          local.get 2
          local.get 5
          local.get 4
          i32.load
          call $~lib/internal/hash/hash32
          local.get 1
          i32.and
          i32.const 2
          i32.shl
          i32.add
          local.tee 4
          i32.load offset=8
          i32.store offset=8
          local.get 4
          local.get 2
          i32.store offset=8
          local.get 2
          i32.const 12
          i32.add
          local.set 2
        end
        local.get 3
        i32.const 12
        i32.add
        local.set 3
        br 1 (;@1;)
      end
    end
    local.get 0
    local.get 5
    i32.store
    local.get 0
    local.get 1
    i32.store offset=4
    local.get 0
    local.get 6
    i32.store offset=8
    local.get 0
    local.get 7
    i32.store offset=12
    local.get 0
    local.get 0
    i32.load offset=20
    i32.store offset=16)
  (func $~lib/map/Map<i32_~lib/string/String>#set (type 5) (param i32 i32 i32)
    (local i32 i32)
    local.get 0
    local.get 1
    local.get 1
    call $~lib/internal/hash/hash32
    local.tee 4
    call $~lib/map/Map<i32_~lib/string/String>#find
    local.tee 3
    if  ;; label = @1
      local.get 3
      local.get 2
      i32.store offset=4
    else
      local.get 0
      i32.load offset=16
      local.get 0
      i32.load offset=12
      i32.eq
      if  ;; label = @2
        local.get 0
        local.get 0
        i32.load offset=20
        local.get 0
        i32.load offset=12
        f64.convert_i32_s
        f64.const 0x1.8p-1 (;=0.75;)
        f64.mul
        i32.trunc_f64_s
        i32.lt_s
        if (result i32)  ;; label = @3
          local.get 0
          i32.load offset=4
        else
          local.get 0
          i32.load offset=4
          i32.const 1
          i32.shl
          i32.const 1
          i32.or
        end
        call $~lib/map/Map<i32_~lib/string/String>#rehash
      end
      local.get 0
      i32.load offset=8
      i32.const 8
      i32.add
      local.get 0
      local.get 0
      i32.load offset=16
      local.tee 3
      i32.const 1
      i32.add
      i32.store offset=16
      local.get 3
      i32.const 12
      i32.mul
      i32.add
      local.tee 3
      local.get 1
      i32.store
      local.get 3
      local.get 2
      i32.store offset=4
      local.get 0
      local.get 0
      i32.load offset=20
      i32.const 1
      i32.add
      i32.store offset=20
      local.get 3
      local.get 0
      i32.load
      local.get 4
      local.get 0
      i32.load offset=4
      i32.and
      i32.const 2
      i32.shl
      i32.add
      local.tee 0
      i32.load offset=8
      i32.store offset=8
      local.get 0
      local.get 3
      i32.store offset=8
    end)
  (func $~lib/subtest-as/assembly/index/mockFunction (type 9) (param i32 i32 i32 i32 i32)
    local.get 0
    local.get 1
    local.get 2
    call $~lib/subtest-as/assembly/index/createHash
    local.set 0
    local.get 4
    if  ;; label = @1
      global.get 10
      local.get 0
      i32.const 1352
      call $~lib/map/Map<i32_~lib/string/String>#set
    else
      global.get 10
      local.get 0
      local.get 3
      call $~lib/map/Map<i32_~lib/string/String>#set
    end)
  (func $~lib/subtest-as/assembly/log/log.error (type 2) (param i32)
    i32.const 1
    local.get 0
    call $~lib/subtest-as/assembly/log/log.log)
  (func $~lib/subtest-as/assembly/index/callFunction (type 3) (param i32 i32 i32) (result i32)
    (local i32)
    local.get 0
    local.get 1
    local.get 2
    call $~lib/subtest-as/assembly/index/createHash
    local.tee 2
    local.set 3
    global.get 10
    local.get 3
    local.get 3
    call $~lib/internal/hash/hash32
    call $~lib/map/Map<i32_~lib/string/String>#find
    if  ;; label = @1
      global.get 10
      local.get 2
      local.get 2
      call $~lib/internal/hash/hash32
      call $~lib/map/Map<i32_~lib/string/String>#find
      local.tee 0
      if (result i32)  ;; label = @2
        local.get 0
        i32.load offset=4
      else
        unreachable
      end
      return
    end
    i32.const 1440
    local.get 1
    call $~lib/string/String.__concat
    i32.const 1496
    call $~lib/string/String.__concat
    local.get 0
    call $~lib/string/String.__concat
    i32.const 1544
    call $~lib/string/String.__concat
    call $~lib/subtest-as/assembly/log/log.error
    i32.const 1352)
  (func $~lib/string/String.__ne (type 6) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    call $~lib/string/String.__eq
    i32.eqz)
  (func $~lib/subtest-as/assembly/log/log.critical (type 2) (param i32)
    i32.const 0
    local.get 0
    call $~lib/subtest-as/assembly/log/log.log)
  (func $src/tests/runTests~anonymous|0 (type 0)
    (local i32)
    i32.const 1032
    i32.const 1120
    i32.const 1280
    i32.const 1288
    i32.const 0
    call $~lib/subtest-as/assembly/index/mockFunction
    i32.const 1032
    i32.const 1120
    i32.const 1432
    call $~lib/subtest-as/assembly/index/callFunction
    local.tee 0
    i32.const 1288
    call $~lib/string/String.__ne
    if  ;; label = @1
      i32.const 1608
      local.get 0
      call $~lib/string/String.__concat
      i32.const 1712
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.critical
    end)
  (func $~lib/subtest-as/assembly/store/toggleTestPassedValue (type 0)
    global.get 3
    i32.eqz
    global.set 3)
  (func $~lib/subtest-as/assembly/index/test (type 7) (param i32 i32)
    i32.const 0
    global.set 13
    local.get 1
    call_indirect (type 0)
    global.get 3
    if  ;; label = @1
      i32.const 3
      i32.const 1736
      local.get 0
      call $~lib/string/String.__concat
      i32.const 1752
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.log
      call $~lib/subtest-as/assembly/index/testUtil.incrementSuccessfulTestsCount
    else
      i32.const 1736
      local.get 0
      call $~lib/string/String.__concat
      i32.const 1792
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
      call $~lib/subtest-as/assembly/store/toggleTestPassedValue
      call $~lib/subtest-as/assembly/index/testUtil.incrementFailedTestsCount
    end)
  (func $~lib/subtest-as/assembly/store/store.assertFieldEq (type 5) (param i32 i32 i32)
    (local i32)
    global.get 2
    local.get 0
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#has
    local.tee 3
    if  ;; label = @1
      global.get 2
      local.get 0
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      local.get 1
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#has
      local.set 3
    end
    local.get 3
    if (result i32)  ;; label = @1
      global.get 2
      local.get 0
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      local.get 1
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
    else
      local.get 3
    end
    if  ;; label = @1
      global.get 2
      local.get 0
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      local.get 1
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
      call $~lib/@graphprotocol/graph-ts/index/Value#toString
      local.get 2
      call $~lib/string/String.__ne
      if  ;; label = @2
        i32.const 1960
        global.get 2
        local.get 0
        call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
        local.get 1
        call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
        call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
        call $~lib/@graphprotocol/graph-ts/index/Value#toString
        call $~lib/string/String.__concat
        i32.const 1984
        call $~lib/string/String.__concat
        local.get 2
        call $~lib/string/String.__concat
        i32.const 2016
        call $~lib/string/String.__concat
        call $~lib/subtest-as/assembly/log/log.error
        call $~lib/subtest-as/assembly/store/toggleTestPassedValue
      end
    end)
  (func $src/tests/runTests~anonymous|1 (type 0)
    (local i32)
    i32.const 1936
    call $generated/schema/Gravatar#constructor
    local.set 0
    global.get 11
    i32.const 1936
    local.get 0
    call $~lib/subtest-as/assembly/store/store.set
    global.get 11
    i32.const 1936
    i32.const 1936
    call $~lib/subtest-as/assembly/store/store.assertFieldEq
    global.get 2
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#clear)
  (func $~lib/array/Array<generated/Gravity/Gravity/NewGravatar>#__unchecked_set (type 5) (param i32 i32 i32)
    local.get 0
    i32.load
    local.get 1
    i32.const 2
    i32.shl
    i32.add
    local.get 2
    i32.store offset=8)
  (func $src/tests/runTests~anonymous|2 (type 0)
    (local i32 i32 i32)
    i32.const 2104
    call $generated/schema/Gravatar#constructor
    local.set 0
    global.get 11
    local.get 0
    call $generated/schema/Gravatar#get:id
    local.get 0
    call $~lib/subtest-as/assembly/store/store.set
    i32.const 12345
    i32.const 2136
    i32.const 2224
    i32.const 2240
    call $src/mapping/createNewGravatarEvent
    local.set 1
    i32.const 3546
    i32.const 2136
    i32.const 2224
    i32.const 2240
    call $src/mapping/createNewGravatarEvent
    local.set 2
    i32.const 2
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/chain/ethereum/ethereum.EventParam>#constructor
    local.tee 0
    i32.const 0
    local.get 1
    call $~lib/array/Array<generated/Gravity/Gravity/NewGravatar>#__unchecked_set
    local.get 0
    i32.const 1
    local.get 2
    call $~lib/array/Array<generated/Gravity/Gravity/NewGravatar>#__unchecked_set
    local.get 0
    call $~lib/array/Array<generated/Gravity/Gravity/NewGravatar>#forEach
    global.get 11
    i32.const 2104
    i32.const 2104
    call $~lib/subtest-as/assembly/store/store.assertFieldEq
    global.get 11
    i32.const 2256
    i32.const 2256
    call $~lib/subtest-as/assembly/store/store.assertFieldEq
    global.get 11
    i32.const 2272
    i32.const 2272
    call $~lib/subtest-as/assembly/store/store.assertFieldEq
    global.get 2
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#clear)
  (func $~lib/subtest-as/assembly/store/store.get (type 1) (param i32) (result i32)
    global.get 2
    local.get 0
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#has
    if  ;; label = @1
      global.get 2
      local.get 0
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      i32.const 2376
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#has
      if  ;; label = @2
        global.get 2
        local.get 0
        call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
        i32.const 2376
        call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
        return
      else
        i32.const 2384
        i32.const 2376
        call $~lib/string/String.__concat
        i32.const 2400
        call $~lib/string/String.__concat
        local.get 0
        call $~lib/string/String.__concat
        call $~lib/subtest-as/assembly/log/log.error
      end
    else
      i32.const 2448
      local.get 0
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    i32.const 0
    call $~lib/@graphprotocol/graph-ts/index/Entity#constructor)
  (func $~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>#delete (type 2) (param i32)
    (local i32 i32)
    local.get 0
    i32.const 2376
    i32.const 2376
    call $~lib/internal/hash/hashStr
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#find
    local.tee 1
    i32.eqz
    if  ;; label = @1
      return
    end
    local.get 1
    local.get 1
    i32.load offset=8
    i32.const 1
    i32.or
    i32.store offset=8
    local.get 0
    local.get 0
    i32.load offset=20
    i32.const 1
    i32.sub
    i32.store offset=20
    local.get 0
    i32.load offset=4
    i32.const 1
    i32.shr_u
    local.tee 1
    i32.const 1
    i32.add
    i32.const 4
    local.get 0
    i32.load offset=20
    local.tee 2
    i32.const 4
    local.get 2
    i32.gt_u
    select
    i32.ge_u
    local.tee 2
    if (result i32)  ;; label = @1
      local.get 0
      i32.load offset=20
      local.get 0
      i32.load offset=12
      f64.convert_i32_s
      f64.const 0x1.8p-1 (;=0.75;)
      f64.mul
      i32.trunc_f64_s
      i32.lt_s
    else
      local.get 2
    end
    if  ;; label = @1
      local.get 0
      local.get 1
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#rehash
    end)
  (func $~lib/subtest-as/assembly/store/store.remove (type 2) (param i32)
    (local i32)
    global.get 2
    local.get 0
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#has
    local.tee 1
    if (result i32)  ;; label = @1
      global.get 2
      local.get 0
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      i32.const 2376
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#has
    else
      local.get 1
    end
    if  ;; label = @1
      global.get 2
      local.get 0
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      call $~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>#delete
    end)
  (func $src/tests/runTests~anonymous|3 (type 0)
    (local i32)
    i32.const 2376
    call $generated/schema/Gravatar#constructor
    local.set 0
    global.get 11
    local.get 0
    call $generated/schema/Gravatar#get:id
    local.get 0
    call $~lib/subtest-as/assembly/store/store.set
    global.get 11
    call $~lib/subtest-as/assembly/store/store.get
    local.set 0
    global.get 11
    i32.const 2376
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
    call $~lib/@graphprotocol/graph-ts/index/Value#toString
    call $~lib/subtest-as/assembly/store/store.assertFieldEq
    global.get 11
    call $~lib/subtest-as/assembly/store/store.remove
    global.get 2
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#clear)
  (func $src/tests/runTests~anonymous|4 (type 0)
    (local i32)
    i32.const 2528
    i32.const 2560
    i32.const 2648
    i32.const 2656
    i32.const 0
    call $~lib/subtest-as/assembly/index/mockFunction
    i32.const 2656
    i32.const 2528
    i32.const 2560
    i32.const 2704
    call $~lib/subtest-as/assembly/index/callFunction
    local.tee 0
    call $~lib/string/String.__ne
    if  ;; label = @1
      i32.const 2712
      local.get 0
      call $~lib/string/String.__concat
      i32.const 1712
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.critical
    end)
  (func $src/tests/runTests~anonymous|5 (type 0)
    i32.const 2888
    i32.const 2928
    i32.const 2952
    i32.const 2960
    i32.const 1
    call $~lib/subtest-as/assembly/index/mockFunction
    i32.const 2888
    i32.const 2928
    i32.const 2984
    call $~lib/subtest-as/assembly/index/callFunction
    i32.const 1352
    call $~lib/string/String.__ne
    if  ;; label = @1
      i32.const 2992
      call $~lib/subtest-as/assembly/log/log.critical
    end)
  (func $~lib/subtest-as/assembly/event/addMetadata (type 1) (param i32) (result i32)
    local.get 0
    global.get 9
    i32.load
    i32.store
    local.get 0
    global.get 9
    i32.load offset=4
    i32.store offset=4
    local.get 0
    global.get 9
    i32.load offset=12
    i32.store offset=12
    local.get 0
    global.get 9
    i32.load offset=16
    i32.store offset=16
    local.get 0
    global.get 9
    i32.load offset=20
    i32.store offset=20
    local.get 0
    global.get 9
    i32.load offset=24
    i32.store offset=24
    local.get 0)
  (func $~lib/internal/typedarray/TypedArray<u8>#__get (type 6) (param i32 i32) (result i32)
    local.get 1
    local.get 0
    i32.load offset=8
    i32.ge_u
    if  ;; label = @1
      i32.const 0
      i32.const 208
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
  (func $~lib/@graphprotocol/graph-ts/index/ByteArray#equals (type 6) (param i32 i32) (result i32)
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
  (func $~lib/@graphprotocol/graph-ts/index/ByteArray#notEqual (type 6) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray#equals
    i32.eqz)
  (func $~lib/@graphprotocol/graph-ts/index/BigInt.compare (type 6) (param i32 i32) (result i32)
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
  (func $~lib/@graphprotocol/graph-ts/index/BigInt#notEqual (type 6) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/BigInt.compare
    i32.eqz
    i32.eqz)
  (func $~lib/string/String#charAt (type 6) (param i32 i32) (result i32)
    (local i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 0
      i32.const 1320
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
      i32.const 1352
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
  (func $~lib/string/String#substr (type 3) (param i32 i32 i32) (result i32)
    (local i32 i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 0
      i32.const 1320
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
      i32.const 1352
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
      i32.const 3576
      local.get 0
      call $~lib/string/String.__concat
      i32.const 3592
      call $~lib/string/String.__concat
      i32.const 832
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
      i32.const 3632
      call $~lib/string/String.__eq
      local.set 1
    end
    local.get 1
    if (result i32)  ;; label = @1
      local.get 0
      i32.const 1
      call $~lib/string/String#charAt
      i32.const 3640
      call $~lib/string/String.__eq
    else
      local.get 1
    end
    if  ;; label = @1
      i32.const 1
      global.set 13
      i32.const 0
      local.set 1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            global.get 13
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
    i32.const 320
    call $~lib/string/String.__ne
    if  ;; label = @1
      i32.const 3208
      i32.const 320
      call $~lib/string/String.__concat
      i32.const 3296
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=12
      call $~lib/string/String.__concat
      i32.const 1712
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load
    i32.const 120
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    call $~lib/@graphprotocol/graph-ts/index/ByteArray#notEqual
    if  ;; label = @1
      i32.const 3344
      i32.const 120
      call $~lib/string/String.__concat
      i32.const 3424
      call $~lib/string/String.__concat
      local.get 0
      i32.load
      call $~lib/@graphprotocol/graph-ts/index/typeConversion.bytesToHex
      call $~lib/string/String.__concat
      i32.const 1712
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load offset=4
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    call $~lib/@graphprotocol/graph-ts/index/BigInt#notEqual
    if  ;; label = @1
      i32.const 3488
      i32.const 3200
      call $~lib/string/String.__concat
      i32.const 3296
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=4
      call $~lib/@graphprotocol/graph-ts/index/typeConversion.bigIntToString
      call $~lib/string/String.__concat
      i32.const 1712
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load offset=16
    i32.load
    i32.const 120
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromHexString
    call $~lib/@graphprotocol/graph-ts/index/ByteArray#notEqual
    if  ;; label = @1
      i32.const 3648
      i32.const 120
      call $~lib/string/String.__concat
      i32.const 3424
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=16
      i32.load
      call $~lib/@graphprotocol/graph-ts/index/typeConversion.bytesToHex
      call $~lib/string/String.__concat
      i32.const 1712
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load offset=24
    i32.const 0
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
    i32.load
    i32.const 304
    call $~lib/string/String.__ne
    if  ;; label = @1
      i32.const 3736
      i32.const 304
      call $~lib/string/String.__concat
      i32.const 3840
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=24
      i32.const 0
      call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
      i32.load
      call $~lib/string/String.__concat
      i32.const 1712
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end)
  (func $src/tests/runTests~anonymous|7 (type 0)
    (local i32)
    call $generated/Gravity/Gravity/NewGravatar#constructor
    call $~lib/subtest-as/assembly/event/addMetadata
    local.tee 0
    i32.const 3920
    i32.store offset=12
    local.get 0
    i32.const 3960
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    i32.store
    local.get 0
    i32.load offset=16
    i32.const 4048
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
    i32.const 4144
    i32.store
    local.get 0
    i32.load offset=12
    i32.const 3920
    call $~lib/string/String.__ne
    if  ;; label = @1
      i32.const 4168
      i32.const 3920
      call $~lib/string/String.__concat
      i32.const 3840
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=12
      call $~lib/string/String.__concat
      i32.const 1712
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load
    i32.const 3960
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    call $~lib/@graphprotocol/graph-ts/index/ByteArray#notEqual
    if  ;; label = @1
      i32.const 3344
      i32.const 3960
      call $~lib/string/String.__concat
      i32.const 3424
      call $~lib/string/String.__concat
      local.get 0
      i32.load
      call $~lib/@graphprotocol/graph-ts/index/typeConversion.bytesToHex
      call $~lib/string/String.__concat
      i32.const 1712
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load offset=4
    i32.const 42
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    call $~lib/@graphprotocol/graph-ts/index/BigInt#notEqual
    if  ;; label = @1
      i32.const 3488
      i32.const 4136
      call $~lib/string/String.__concat
      i32.const 3296
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=4
      call $~lib/@graphprotocol/graph-ts/index/typeConversion.bigIntToString
      call $~lib/string/String.__concat
      i32.const 1712
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load offset=16
    i32.load
    i32.const 4048
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromHexString
    call $~lib/@graphprotocol/graph-ts/index/ByteArray#notEqual
    if  ;; label = @1
      i32.const 3648
      i32.const 4048
      call $~lib/string/String.__concat
      i32.const 3424
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=16
      i32.load
      call $~lib/@graphprotocol/graph-ts/index/typeConversion.bytesToHex
      call $~lib/string/String.__concat
      i32.const 1712
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end
    local.get 0
    i32.load offset=24
    i32.const 0
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
    i32.load
    i32.const 4144
    call $~lib/string/String.__ne
    if  ;; label = @1
      i32.const 3736
      i32.const 4144
      call $~lib/string/String.__concat
      i32.const 3840
      call $~lib/string/String.__concat
      local.get 0
      i32.load offset=24
      i32.const 0
      call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
      i32.load
      call $~lib/string/String.__concat
      i32.const 1712
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.error
    end)
  (func $src/tests/runTests (type 0)
    i32.const 992
    i32.const 2
    call $~lib/subtest-as/assembly/index/test
    i32.const 1824
    i32.const 3
    call $~lib/subtest-as/assembly/index/test
    i32.const 2024
    i32.const 4
    call $~lib/subtest-as/assembly/index/test
    i32.const 2288
    i32.const 5
    call $~lib/subtest-as/assembly/index/test
    i32.const 2288
    i32.const 6
    call $~lib/subtest-as/assembly/index/test
    i32.const 2808
    i32.const 7
    call $~lib/subtest-as/assembly/index/test
    i32.const 3112
    i32.const 8
    call $~lib/subtest-as/assembly/index/test
    i32.const 3864
    i32.const 9
    call $~lib/subtest-as/assembly/index/test)
  (func $~lib/internal/memory/memcmp (type 3) (param i32 i32 i32) (result i32)
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
  (func $~lib/memory/memory.compare (type 3) (param i32 i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 2
    call $~lib/internal/memory/memcmp)
  (func $~lib/memory/memory.free (type 2) (param i32)
    nop)
  (func $~lib/memory/memory.reset (type 0)
    global.get 0
    global.set 1)
  (func $start (type 0)
    i32.const 4248
    global.set 0
    global.get 0
    global.set 1
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#constructor
    global.set 2
    call $start:~lib/subtest-as/assembly/event
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#constructor
    global.set 10)
  (func $null (type 0)
    nop)
  (table (;0;) 10 funcref)
  (memory (;0;) 1)
  (global (;0;) (mut i32) (i32.const 0))
  (global (;1;) (mut i32) (i32.const 0))
  (global (;2;) (mut i32) (i32.const 0))
  (global (;3;) (mut i32) (i32.const 1))
  (global (;4;) (mut i32) (i32.const 0))
  (global (;5;) (mut i32) (i32.const 0))
  (global (;6;) (mut i32) (i32.const 0))
  (global (;7;) (mut i32) (i32.const 0))
  (global (;8;) (mut i32) (i32.const 0))
  (global (;9;) (mut i32) (i32.const 0))
  (global (;10;) (mut i32) (i32.const 0))
  (global (;11;) (mut i32) (i32.const 360))
  (global (;12;) (mut i32) (i32.const 360))
  (global (;13;) (mut i32) (i32.const 0))
  (export "memory" (memory 0))
  (export "table" (table 0))
  (export "handleNewGravatar" (func $src/mapping/handleNewGravatar))
  (export "handleNewGravatars" (func $src/mapping/handleNewGravatars))
  (export "handleUpdatedGravatar" (func $src/mapping/handleUpdatedGravatar))
  (export "createNewGravatarEvent" (func $src/mapping/createNewGravatarEvent))
  (export "runTests" (func $src/tests/runTests))
  (export "memory.compare" (func $~lib/memory/memory.compare))
  (export "memory.allocate" (func $~lib/memory/memory.allocate))
  (export "memory.free" (func $~lib/memory/memory.free))
  (export "memory.reset" (func $~lib/memory/memory.reset))
  (start $start)
  (elem (;0;) (i32.const 0) func $null $src/mapping/handleNewGravatars~anonymous|0 $src/tests/runTests~anonymous|0 $src/tests/runTests~anonymous|1 $src/tests/runTests~anonymous|2 $src/tests/runTests~anonymous|3 $src/tests/runTests~anonymous|4 $src/tests/runTests~anonymous|5 $src/tests/runTests~anonymous|6 $src/tests/runTests~anonymous|7)
  (data (;0;) (i32.const 8) "\13\00\00\00~\00l\00i\00b\00/\00a\00r\00r\00a\00y\00b\00u\00f\00f\00e\00r\00.\00t\00s")
  (data (;1;) (i32.const 56) "\1c\00\00\00~\00l\00i\00b\00/\00i\00n\00t\00e\00r\00n\00a\00l\00/\00a\00r\00r\00a\00y\00b\00u\00f\00f\00e\00r\00.\00t\00s")
  (data (;2;) (i32.const 120) "*\00\00\000\00x\00A\001\006\000\008\001\00F\003\006\000\00e\003\008\004\007\000\000\006\00d\00B\006\006\000\00b\00a\00e\001\00c\006\00d\001\00b\002\00e\001\007\00e\00C\002\00A")
  (data (;3;) (i32.const 208) "\1b\00\00\00~\00l\00i\00b\00/\00i\00n\00t\00e\00r\00n\00a\00l\00/\00t\00y\00p\00e\00d\00a\00r\00r\00a\00y\00.\00t\00s")
  (data (;4;) (i32.const 272) "\0d\00\00\00~\00l\00i\00b\00/\00a\00r\00r\00a\00y\00.\00t\00s")
  (data (;5;) (i32.const 304) "\04\00\00\00n\00a\00m\00e")
  (data (;6;) (i32.const 320) "\10\00\00\00d\00e\00f\00a\00u\00l\00t\00_\00l\00o\00g\00_\00t\00y\00p\00e")
  (data (;7;) (i32.const 360) "\08\00\00\00G\00r\00a\00v\00a\00t\00a\00r")
  (data (;8;) (i32.const 384) "\02\00\00\00i\00d")
  (data (;9;) (i32.const 392) "%\00\00\00E\00t\00h\00e\00r\00e\00u\00m\00 \00v\00a\00l\00u\00e\00 \00i\00s\00 \00n\00o\00t\00 \00a\00n\00 \00i\00n\00t\00 \00o\00r\00 \00u\00i\00n\00t\00.")
  (data (;10;) (i32.const 472) ".\00\00\00~\00l\00i\00b\00/\00@\00g\00r\00a\00p\00h\00p\00r\00o\00t\00o\00c\00o\00l\00/\00g\00r\00a\00p\00h\00-\00t\00s\00/\00c\00h\00a\00i\00n\00/\00e\00t\00h\00e\00r\00e\00u\00m\00.\00t\00s")
  (data (;11;) (i32.const 568) " \00\00\00E\00t\00h\00e\00r\00e\00u\00m\00 \00v\00a\00l\00u\00e\00 \00i\00s\00 \00n\00o\00t\00 \00a\00n\00 \00a\00d\00d\00r\00e\00s\00s")
  (data (;12;) (i32.const 640) "\05\00\00\00o\00w\00n\00e\00r")
  (data (;13;) (i32.const 656) "\1f\00\00\00E\00t\00h\00e\00r\00e\00u\00m\00 \00v\00a\00l\00u\00e\00 \00i\00s\00 \00n\00o\00t\00 \00a\00 \00s\00t\00r\00i\00n\00g\00.")
  (data (;14;) (i32.const 728) "\0b\00\00\00d\00i\00s\00p\00l\00a\00y\00N\00a\00m\00e")
  (data (;15;) (i32.const 760) "\08\00\00\00i\00m\00a\00g\00e\00U\00r\00l")
  (data (;16;) (i32.const 784) "\16\00\00\00V\00a\00l\00u\00e\00 \00i\00s\00 \00n\00o\00t\00 \00a\00 \00s\00t\00r\00i\00n\00g\00.")
  (data (;17;) (i32.const 832) "%\00\00\00~\00l\00i\00b\00/\00@\00g\00r\00a\00p\00h\00p\00r\00o\00t\00o\00c\00o\00l\00/\00g\00r\00a\00p\00h\00-\00t\00s\00/\00i\00n\00d\00e\00x\00.\00t\00s")
  (data (;18;) (i32.const 912) "%\00\00\00A\00d\00d\00r\00e\00s\00s\00 \00m\00u\00s\00t\00 \00c\00o\00n\00t\00a\00i\00n\00 \00e\00x\00a\00c\00t\00l\00y\00 \002\000\00 \00b\00y\00t\00e\00s")
  (data (;19;) (i32.const 992) "\11\00\00\00C\00a\00n\00 \00m\00o\00c\00k\00 \00f\00u\00n\00c\00t\00i\00o\00n")
  (data (;20;) (i32.const 1032) "*\00\00\000\00x\009\000\00c\00B\00a\002\00B\00b\00b\001\009\00e\00c\00c\002\009\001\00A\001\002\000\006\006\00F\00d\008\003\002\009\00D\006\005\00F\00A\001\00f\001\009\004\007")
  (data (;21;) (i32.const 1120) "\0e\00\00\00c\00r\00e\00a\00t\00e\00G\00r\00a\00v\00a\00t\00a\00r")
  (data (;22;) (i32.const 1152) "\05\00\00\00G\00r\00u\00n\00t")
  (data (;23;) (i32.const 1168) ".\00\00\00h\00t\00t\00p\00:\00/\00/\00w\00w\00w\00.\00w\00g\00p\00o\00w\00e\00r\00.\00n\00e\00t\00/\00a\00r\00t\00i\00c\00l\00e\00s\00/\00i\00m\00a\00g\00e\00s\00/\001\005\008\00.\00g\00i\00f")
  (data (;24;) (i32.const 1264) "\08\00\00\00\00\00\00\00\80\04\00\00\90\04")
  (data (;25;) (i32.const 1280) "\f0\04\00\00\02")
  (data (;26;) (i32.const 1288) "\04\00\00\00v\00o\00i\00d")
  (data (;27;) (i32.const 1304) "\04\00\00\00n\00u\00l\00l")
  (data (;28;) (i32.const 1320) "\0e\00\00\00~\00l\00i\00b\00/\00s\00t\00r\00i\00n\00g\00.\00t\00s")
  (data (;29;) (i32.const 1360) "\17\00\00\00~\00l\00i\00b\00/\00i\00n\00t\00e\00r\00n\00a\00l\00/\00s\00t\00r\00i\00n\00g\00.\00t\00s")
  (data (;30;) (i32.const 1416) "\08\00\00\00\00\00\00\00\80\04\00\00\90\04")
  (data (;31;) (i32.const 1432) "\88\05\00\00\02")
  (data (;32;) (i32.const 1440) "\17\00\00\00N\00o\00 \00f\00u\00n\00c\00t\00i\00o\00n\00 \00w\00i\00t\00h\00 \00n\00a\00m\00e\00 \00'")
  (data (;33;) (i32.const 1496) "\15\00\00\00'\00,\00 \00c\00o\00n\00t\00r\00a\00c\00t\00 \00a\00d\00d\00r\00e\00s\00s\00 \00'")
  (data (;34;) (i32.const 1544) "\1c\00\00\00'\00 \00a\00n\00d\00 \00g\00i\00v\00e\00n\00 \00a\00r\00g\00u\00m\00e\00n\00t\00s\00 \00f\00o\00u\00n\00d\00.")
  (data (;35;) (i32.const 1608) "0\00\00\00E\00x\00p\00e\00c\00t\00e\00d\00 \00t\00h\00e\00 \00r\00e\00t\00u\00r\00n\00 \00v\00a\00l\00u\00e\00 \00t\00o\00 \00b\00e\00 \00'\00v\00o\00i\00d\00'\00 \00b\00u\00t\00 \00w\00a\00s\00 \00'")
  (data (;36;) (i32.const 1712) "\0a\00\00\00'\00 \00i\00n\00s\00t\00e\00a\00d\00.")
  (data (;37;) (i32.const 1736) "\05\00\00\00T\00E\00S\00T\00 ")
  (data (;38;) (i32.const 1752) "\11\00\00\00 \00r\00e\00s\00u\00l\00t\00 \00-\00 \00S\00U\00C\00C\00E\00S\00S")
  (data (;39;) (i32.const 1792) "\0e\00\00\00 \00r\00e\00s\00u\00l\00t\00 \00-\00 \00F\00A\00I\00L")
  (data (;40;) (i32.const 1824) "4\00\00\00C\00a\00n\00 \00i\00n\00i\00t\00i\00a\00l\00i\00s\00e\00 \00s\00t\00o\00r\00e\00 \00w\00i\00t\00h\00 \00a\00n\00 \00a\00r\00r\00a\00y\00 \00o\00f\00 \00E\00n\00t\00i\00t\00y\00 \00o\00b\00j\00e\00c\00t\00s")
  (data (;41;) (i32.const 1936) "\07\00\00\00e\00n\00t\00r\00y\00I\00d")
  (data (;42;) (i32.const 1960) "\0a\00\00\00E\00x\00p\00e\00c\00t\00e\00d\00 \00'")
  (data (;43;) (i32.const 1984) "\0c\00\00\00'\00 \00t\00o\00 \00e\00q\00u\00a\00l\00 \00'")
  (data (;44;) (i32.const 2016) "\02\00\00\00'\00.")
  (data (;45;) (i32.const 2024) "$\00\00\00C\00a\00n\00 \00c\00a\00l\00l\00 \00m\00a\00p\00p\00i\00n\00g\00s\00 \00w\00i\00t\00h\00 \00c\00u\00s\00t\00o\00m\00 \00e\00v\00e\00n\00t\00s")
  (data (;46;) (i32.const 2104) "\0b\00\00\00g\00r\00a\00v\00a\00t\00a\00r\00I\00d\000")
  (data (;47;) (i32.const 2136) "*\00\00\000\00x\008\009\002\000\005\00A\003\00A\003\00b\002\00A\006\009\00D\00e\006\00D\00b\00f\007\00f\000\001\00E\00D\001\003\00B\002\001\000\008\00B\002\00c\004\003\00e\007")
  (data (;48;) (i32.const 2224) "\03\00\00\00c\00a\00p")
  (data (;49;) (i32.const 2240) "\03\00\00\00p\00a\00c")
  (data (;50;) (i32.const 2256) "\05\00\00\001\002\003\004\005")
  (data (;51;) (i32.const 2272) "\04\00\00\003\005\004\006")
  (data (;52;) (i32.const 2288) "*\00\00\00C\00a\00n\00 \00a\00d\00d\00,\00 \00g\00e\00t\00,\00 \00a\00s\00s\00e\00r\00t\00 \00a\00n\00d\00 \00r\00e\00m\00o\00v\00e\00 \00f\00r\00o\00m\00 \00s\00t\00o\00r\00e")
  (data (;53;) (i32.const 2376) "\02\00\00\002\003")
  (data (;54;) (i32.const 2384) "\04\00\00\00I\00d\00:\00 ")
  (data (;55;) (i32.const 2400) "\16\00\00\00 \00i\00s\00 \00m\00i\00s\00s\00i\00n\00g\00 \00f\00o\00r\00 \00t\00y\00p\00e\00:\00 ")
  (data (;56;) (i32.const 2448) "#\00\00\00F\00o\00l\00l\00o\00w\00i\00n\00g\00 \00t\00y\00p\00e\00 \00i\00s\00 \00a\00b\00s\00e\00n\00t\00 \00f\00r\00o\00m\00 \00m\00a\00p\00:\00 ")
  (data (;57;) (i32.const 2528) "\0e\00\00\000\00x\000\000\000\000\000\001\002\003\004\001\002\003")
  (data (;58;) (i32.const 2560) "\0f\00\00\00e\00x\00a\00m\00p\00l\00e\00F\00u\00n\00c\00N\00a\00m\00e")
  (data (;59;) (i32.const 2600) "\06\00\00\00p\00a\00r\00a\00m\001")
  (data (;60;) (i32.const 2616) "\06\00\00\00p\00a\00r\00a\00m\002")
  (data (;61;) (i32.const 2632) "\08\00\00\00\00\00\00\00(\0a\00\008\0a")
  (data (;62;) (i32.const 2648) "H\0a\00\00\02")
  (data (;63;) (i32.const 2656) "\0b\00\00\00r\00e\00t\00u\00r\00n\00V\00a\00l\00u\00e")
  (data (;64;) (i32.const 2688) "\08\00\00\00\00\00\00\00(\0a\00\008\0a")
  (data (;65;) (i32.const 2704) "\80\0a\00\00\02")
  (data (;66;) (i32.const 2712) ",\00\00\00E\00x\00p\00e\00c\00t\00e\00d\00 \00v\00a\00l\00u\00e\00 \00t\00o\00 \00b\00e\00 \00'\00r\00e\00t\00u\00r\00n\00V\00a\00l\00u\00e\00'\00 \00b\00u\00t\00 \00w\00a\00s\00 \00'")
  (data (;67;) (i32.const 2808) "#\00\00\00C\00a\00n\00 \00t\00e\00s\00t\00 \00i\00f\00 \00m\00o\00c\00k\00e\00d\00 \00f\00u\00n\00c\00t\00i\00o\00n\00 \00r\00e\00v\00e\00r\00t\00s")
  (data (;68;) (i32.const 2888) "\11\00\00\000\00x\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000")
  (data (;69;) (i32.const 2928) "\06\00\00\00r\00e\00v\00e\00r\00t")
  (data (;70;) (i32.const 2952) "\80\0b")
  (data (;71;) (i32.const 2960) "\03\00\00\00v\00a\00l")
  (data (;72;) (i32.const 2984) "\a0\0b")
  (data (;73;) (i32.const 2992) "8\00\00\00F\00u\00n\00c\00t\00i\00o\00n\00 \00s\00h\00o\00u\00l\00d\00 \00r\00e\00v\00e\00r\00t\00 \00w\00h\00e\00n\00 \00b\00o\00o\00l\00 \00r\00e\00v\00e\00r\00t\00s\00 \00i\00s\00 \00s\00e\00t\00 \00t\00o\00 \00t\00r\00u\00e\00.")
  (data (;74;) (i32.const 3112) "*\00\00\00C\00a\00n\00 \00i\00n\00i\00t\00i\00a\00l\00i\00s\00e\00 \00e\00v\00e\00n\00t\00 \00w\00i\00t\00h\00 \00d\00e\00f\00a\00u\00l\00t\00 \00m\00e\00t\00a\00d\00a\00t\00a")
  (data (;75;) (i32.const 3200) "\01\00\00\001")
  (data (;76;) (i32.const 3208) ")\00\00\00n\00e\00w\00G\00r\00a\00v\00a\00t\00a\00r\00E\00v\00e\00n\00t\00.\00l\00o\00g\00T\00y\00p\00e\00 \00e\00x\00p\00e\00c\00t\00e\00d\00 \00t\00o\00 \00b\00e\00 \00'")
  (data (;77;) (i32.const 3296) "\13\00\00\00'\00 \00b\00u\00t\00 \00a\00c\00t\00u\00a\00l\00l\00y\00 \00i\00s\00 \00'")
  (data (;78;) (i32.const 3344) "$\00\00\00n\00e\00w\00G\00r\00a\00v\00a\00t\00a\00r\00E\00v\00e\00n\00t\00.\00a\00d\00d\00r\00e\00s\00s\00 \00s\00h\00o\00u\00l\00d\00 \00b\00e\00 \00'")
  (data (;79;) (i32.const 3424) "\1d\00\00\00'\00 \00(\00c\00a\00s\00e\00 \00i\00n\00s\00e\00n\00s\00i\00t\00i\00v\00e\00)\00 \00b\00u\00t\00 \00i\00s\00 \00'")
  (data (;80;) (i32.const 3488) "*\00\00\00n\00e\00w\00G\00r\00a\00v\00a\00t\00a\00r\00E\00v\00e\00n\00t\00.\00l\00o\00g\00I\00n\00d\00e\00x\00 \00e\00x\00p\00e\00c\00t\00e\00d\00 \00t\00o\00 \00b\00e\00 \00'")
  (data (;81;) (i32.const 3576) "\06\00\00\00i\00n\00p\00u\00t\00 ")
  (data (;82;) (i32.const 3592) "\0f\00\00\00 \00h\00a\00s\00 \00o\00d\00d\00 \00l\00e\00n\00g\00t\00h")
  (data (;83;) (i32.const 3632) "\01\00\00\000")
  (data (;84;) (i32.const 3640) "\01\00\00\00x")
  (data (;85;) (i32.const 3648) "'\00\00\00n\00e\00w\00G\00r\00a\00v\00a\00t\00a\00r\00E\00v\00e\00n\00t\00.\00b\00l\00o\00c\00k\00.\00h\00a\00s\00h\00 \00s\00h\00o\00u\00l\00d\00 \00b\00e\00 \00'")
  (data (;86;) (i32.const 3736) "/\00\00\00n\00e\00w\00G\00r\00a\00v\00a\00t\00a\00r\00E\00v\00e\00n\00t\00.\00p\00a\00r\00a\00m\00e\00t\00e\00r\00s\00[\000\00]\00.\00n\00a\00m\00e\00 \00s\00h\00o\00u\00l\00d\00 \00b\00e\00 \00'")
  (data (;87;) (i32.const 3840) "\0a\00\00\00'\00 \00b\00u\00t\00 \00i\00s\00 \00'")
  (data (;88;) (i32.const 3864) "\19\00\00\00C\00a\00n\00 \00u\00p\00d\00a\00t\00e\00 \00e\00v\00e\00n\00t\00 \00m\00e\00t\00a\00d\00a\00t\00a")
  (data (;89;) (i32.const 3920) "\10\00\00\00u\00p\00d\00a\00t\00e\00d\00_\00l\00o\00g\00_\00t\00y\00p\00e")
  (data (;90;) (i32.const 3960) "*\00\00\000\00x\00B\001\006\000\008\001\00F\003\006\000\00e\003\008\004\007\000\000\006\00d\00B\006\006\000\00b\00a\00e\001\00c\006\00d\001\00b\002\00e\001\007\00e\00C\002\00A")
  (data (;91;) (i32.const 4048) "*\00\00\000\00x\00C\001\006\000\008\001\00F\003\006\000\00e\003\008\004\007\000\000\006\00d\00B\006\006\000\00b\00a\00e\001\00c\006\00d\001\00b\002\00e\001\007\00e\00C\002\00A")
  (data (;92;) (i32.const 4136) "\02\00\00\004\002")
  (data (;93;) (i32.const 4144) "\08\00\00\00n\00e\00w\00_\00n\00a\00m\00e")
  (data (;94;) (i32.const 4168) "$\00\00\00n\00e\00w\00G\00r\00a\00v\00a\00t\00a\00r\00E\00v\00e\00n\00t\00.\00l\00o\00g\00T\00y\00p\00e\00 \00s\00h\00o\00u\00l\00d\00 \00b\00e\00 \00'"))
