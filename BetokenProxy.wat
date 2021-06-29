(module
  (type (;0;) (func))
  (type (;1;) (func (param i32 i32) (result i32)))
  (type (;2;) (func (param i32 i32 i32 i32)))
  (type (;3;) (func (param i32) (result i32)))
  (type (;4;) (func (param i32 i32 i32)))
  (type (;5;) (func (param i32)))
  (type (;6;) (func (param i32 i32 i32) (result i32)))
  (type (;7;) (func (param i32 i32)))
  (type (;8;) (func (result i32)))
  (import "env" "abort" (func $~lib/env/abort (type 2)))
  (import "index" "bigDecimal.fromString" (func $~lib/@graphprotocol/graph-ts/index/bigDecimal.fromString (type 3)))
  (import "index" "bigInt.times" (func $~lib/@graphprotocol/graph-ts/index/bigInt.times (type 1)))
  (import "index" "typeConversion.stringToH160" (func $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160 (type 3)))
  (import "index" "store.get" (func $~lib/@graphprotocol/graph-ts/index/store.get (type 1)))
  (import "index" "bigDecimal.dividedBy" (func $~lib/@graphprotocol/graph-ts/index/bigDecimal.dividedBy (type 1)))
  (import "index" "typeConversion.bytesToHex" (func $~lib/@graphprotocol/graph-ts/index/typeConversion.bytesToHex (type 3)))
  (import "index" "bigDecimal.times" (func $~lib/@graphprotocol/graph-ts/index/bigDecimal.times (type 1)))
  (import "index" "store.set" (func $~lib/@graphprotocol/graph-ts/index/store.set (type 4)))
  (import "index" "dataSource.create" (func $~lib/@graphprotocol/graph-ts/index/dataSource.create (type 7)))
  (import "index" "bigInt.plus" (func $~lib/@graphprotocol/graph-ts/index/bigInt.plus (type 1)))
  (import "log" "log.log" (func $~lib/subtest-as/assembly/log/log.log (type 7)))
  (func $~lib/internal/arraybuffer/computeSize (type 3) (param i32) (result i32)
    i32.const 1
    i32.const 32
    local.get 0
    i32.const 7
    i32.add
    i32.clz
    i32.sub
    i32.shl)
  (func $~lib/allocator/arena/__memory_allocate (type 3) (param i32) (result i32)
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
  (func $~lib/internal/arraybuffer/allocateUnsafe (type 3) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.const 1073741816
    i32.gt_u
    if  ;; label = @1
      i32.const 0
      i32.const 40
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
  (func $~lib/memory/memory.allocate (type 3) (param i32) (result i32)
    local.get 0
    call $~lib/allocator/arena/__memory_allocate)
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
  (func $~lib/array/Array<~lib/string/String>#constructor (type 3) (param i32) (result i32)
    (local i32 i32 i32)
    local.get 0
    i32.const 268435454
    i32.gt_u
    if  ;; label = @1
      i32.const 0
      i32.const 8
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
  (func $~lib/internal/arraybuffer/reallocateUnsafe (type 1) (param i32 i32) (result i32)
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
        i32.const 40
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
          i32.const 40
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
  (func $~lib/array/Array<~lib/string/String>#push (type 7) (param i32 i32)
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
        i32.const 8
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
  (func $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set (type 4) (param i32 i32 i32)
    local.get 0
    i32.load
    local.get 1
    i32.const 2
    i32.shl
    i32.add
    local.get 2
    i32.store offset=8)
  (func $start:src/fulcrum_tokens (type 0)
    (local i32 i32 i32 i32)
    i32.const 6
    call $~lib/array/Array<~lib/string/String>#constructor
    local.tee 3
    i32.const 0
    i32.const 12
    call $~lib/allocator/arena/__memory_allocate
    local.tee 2
    i32.const 208
    i32.store
    local.get 2
    i32.const 224
    i32.store offset=4
    i32.const 7
    call $~lib/array/Array<~lib/string/String>#constructor
    local.tee 1
    i32.const 0
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 312
    i32.store
    local.get 0
    f64.const 0x1p+0 (;=1;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 1
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 400
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 2
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 488
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 3
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 576
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 4
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 664
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 5
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 752
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 6
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 840
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 2
    local.get 1
    i32.store offset=8
    local.get 2
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 3
    i32.const 1
    i32.const 12
    call $~lib/allocator/arena/__memory_allocate
    local.tee 2
    i32.const 928
    i32.store
    local.get 2
    i32.const 944
    i32.store offset=4
    i32.const 7
    call $~lib/array/Array<~lib/string/String>#constructor
    local.tee 1
    i32.const 0
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 1032
    i32.store
    local.get 0
    f64.const 0x1p+0 (;=1;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 1
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 1120
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 2
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 1208
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 3
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 1296
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 4
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 1384
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 5
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 1472
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 6
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 1560
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 2
    local.get 1
    i32.store offset=8
    local.get 2
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 3
    i32.const 2
    i32.const 12
    call $~lib/allocator/arena/__memory_allocate
    local.tee 2
    i32.const 1648
    i32.store
    local.get 2
    i32.const 1664
    i32.store offset=4
    i32.const 7
    call $~lib/array/Array<~lib/string/String>#constructor
    local.tee 1
    i32.const 0
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 1752
    i32.store
    local.get 0
    f64.const 0x1p+0 (;=1;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 1
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 1840
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 2
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 1928
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 3
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 2016
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 4
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 2104
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 5
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 2192
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 6
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 2280
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 2
    local.get 1
    i32.store offset=8
    local.get 2
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 3
    i32.const 3
    i32.const 12
    call $~lib/allocator/arena/__memory_allocate
    local.tee 2
    i32.const 2368
    i32.store
    local.get 2
    i32.const 2384
    i32.store offset=4
    i32.const 7
    call $~lib/array/Array<~lib/string/String>#constructor
    local.tee 1
    i32.const 0
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 2472
    i32.store
    local.get 0
    f64.const 0x1p+0 (;=1;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 1
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 2560
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 2
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 2648
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 3
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 2736
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 4
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 2824
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 5
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 2912
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 6
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 3000
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 2
    local.get 1
    i32.store offset=8
    local.get 2
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 3
    i32.const 4
    i32.const 12
    call $~lib/allocator/arena/__memory_allocate
    local.tee 2
    i32.const 3088
    i32.store
    local.get 2
    i32.const 3104
    i32.store offset=4
    i32.const 7
    call $~lib/array/Array<~lib/string/String>#constructor
    local.tee 1
    i32.const 0
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 3192
    i32.store
    local.get 0
    f64.const 0x1p+0 (;=1;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 1
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 3280
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 2
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 3368
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 3
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 3456
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 4
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 3544
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 5
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 3632
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 6
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 3720
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 2
    local.get 1
    i32.store offset=8
    local.get 2
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 3
    i32.const 5
    i32.const 12
    call $~lib/allocator/arena/__memory_allocate
    local.tee 2
    i32.const 3808
    i32.store
    local.get 2
    i32.const 3824
    i32.store offset=4
    i32.const 7
    call $~lib/array/Array<~lib/string/String>#constructor
    local.tee 1
    i32.const 0
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 3912
    i32.store
    local.get 0
    f64.const 0x1p+0 (;=1;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 1
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 4000
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 2
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 4088
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 3
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 4176
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 4
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 4264
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 5
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 4352
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 6
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 4440
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 2
    local.get 1
    i32.store offset=8
    local.get 2
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 3
    global.set 4
    i32.const 3
    call $~lib/array/Array<~lib/string/String>#constructor
    local.tee 3
    i32.const 0
    i32.const 12
    call $~lib/allocator/arena/__memory_allocate
    local.tee 2
    i32.const 208
    i32.store
    local.get 2
    i32.const 224
    i32.store offset=4
    i32.const 7
    call $~lib/array/Array<~lib/string/String>#constructor
    local.tee 1
    i32.const 0
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 4528
    i32.store
    local.get 0
    f64.const 0x1p+0 (;=1;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 1
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 4616
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 2
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 4704
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 3
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 4792
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 4
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 4880
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 5
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 4968
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 6
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 5056
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 2
    local.get 1
    i32.store offset=8
    local.get 2
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 3
    i32.const 1
    i32.const 12
    call $~lib/allocator/arena/__memory_allocate
    local.tee 2
    i32.const 928
    i32.store
    local.get 2
    i32.const 944
    i32.store offset=4
    i32.const 7
    call $~lib/array/Array<~lib/string/String>#constructor
    local.tee 1
    i32.const 0
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 5144
    i32.store
    local.get 0
    f64.const 0x1p+0 (;=1;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 1
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 5232
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 2
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 5320
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 3
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 5408
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 4
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 5496
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 5
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 5584
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 6
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 5672
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 2
    local.get 1
    i32.store offset=8
    local.get 2
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 3
    i32.const 2
    i32.const 12
    call $~lib/allocator/arena/__memory_allocate
    local.tee 2
    i32.const 5760
    i32.store
    local.get 2
    i32.const 5776
    i32.store offset=4
    i32.const 7
    call $~lib/array/Array<~lib/string/String>#constructor
    local.tee 1
    i32.const 0
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 5864
    i32.store
    local.get 0
    f64.const 0x1p+0 (;=1;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 1
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 5952
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 2
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 6040
    i32.store
    local.get 0
    f64.const 0x1p+1 (;=2;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 3
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 6128
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 4
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 6216
    i32.store
    local.get 0
    f64.const 0x1.8p+1 (;=3;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 5
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 6304
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 1
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    i32.const 6
    i32.const 17
    call $~lib/allocator/arena/__memory_allocate
    local.tee 0
    i32.const 6392
    i32.store
    local.get 0
    f64.const 0x1p+2 (;=4;)
    f64.store offset=8
    local.get 0
    i32.const 0
    i32.store8 offset=16
    local.get 0
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 2
    local.get 1
    i32.store offset=8
    local.get 2
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 3
    global.set 5)
  (func $~lib/internal/typedarray/TypedArray<u8>#constructor (type 3) (param i32) (result i32)
    (local i32)
    i32.const 4
    call $~lib/internal/arraybuffer/allocateUnsafe
    local.tee 1
    i32.const 8
    i32.add
    i32.const 4
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
    local.get 1
    i32.store
    local.get 0
    i32.const 0
    i32.store offset=4
    local.get 0
    i32.const 4
    i32.store offset=8
    local.get 0)
  (func $~lib/@graphprotocol/graph-ts/index/ByteArray#constructor (type 3) (param i32) (result i32)
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
    call $~lib/internal/typedarray/TypedArray<u8>#constructor)
  (func $~lib/internal/typedarray/TypedArray<u8>#__set (type 4) (param i32 i32 i32)
    local.get 1
    local.get 0
    i32.load offset=8
    i32.ge_u
    if  ;; label = @1
      i32.const 0
      i32.const 6480
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
  (func $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32 (type 3) (param i32) (result i32)
    (local i32)
    i32.const 0
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
  (func $~lib/@graphprotocol/graph-ts/index/BigDecimal#constructor (type 3) (param i32) (result i32)
    (local i32)
    i32.const 8
    call $~lib/allocator/arena/__memory_allocate
    local.tee 1
    i32.const 0
    i32.store
    local.get 1
    i32.const 0
    i32.store offset=4
    local.get 1
    local.get 0
    i32.store
    local.get 1
    i32.const 0
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    i32.store offset=4
    local.get 1)
  (func $src/utils/tenPow (type 8) (result i32)
    (local i32 i32)
    i32.const 1
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    local.set 0
    loop  ;; label = @1
      local.get 1
      f64.convert_i32_s
      f64.const 0x1.2p+4 (;=18;)
      f64.lt
      if  ;; label = @2
        local.get 0
        i32.const 10
        call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
        call $~lib/@graphprotocol/graph-ts/index/bigInt.times
        local.set 0
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        br 1 (;@1;)
      end
    end
    local.get 0)
  (func $start:src/utils (type 0)
    i32.const 0
    call $~lib/array/Array<~lib/string/String>#constructor
    global.set 2
    global.get 2
    i32.const 104
    call $~lib/array/Array<~lib/string/String>#push
    global.get 2
    i32.const 136
    call $~lib/array/Array<~lib/string/String>#push
    i32.const 0
    call $~lib/array/Array<~lib/string/String>#constructor
    global.set 3
    global.get 3
    i32.const 152
    call $~lib/array/Array<~lib/string/String>#push
    global.get 3
    i32.const 168
    call $~lib/array/Array<~lib/string/String>#push
    global.get 3
    i32.const 184
    call $~lib/array/Array<~lib/string/String>#push
    call $start:src/fulcrum_tokens
    i32.const 0
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    global.set 6
    i32.const 6544
    call $~lib/@graphprotocol/graph-ts/index/bigDecimal.fromString
    global.set 7
    i32.const 6552
    call $~lib/@graphprotocol/graph-ts/index/bigDecimal.fromString
    global.set 8
    call $src/utils/tenPow
    call $~lib/@graphprotocol/graph-ts/index/BigDecimal#constructor
    global.set 9
    i32.const 6560
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
    global.set 10
    i32.const 6552
    call $~lib/@graphprotocol/graph-ts/index/bigDecimal.fromString
    global.set 12
    i32.const 259200
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    call $~lib/@graphprotocol/graph-ts/index/BigDecimal#constructor
    global.set 13
    i32.const 5760
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    global.set 14
    i32.const 20
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    global.set 15
    i32.const 10004888
    call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
    global.set 16)
  (func $~lib/arraybuffer/ArrayBuffer#constructor (type 1) (param i32 i32) (result i32)
    (local i32)
    local.get 0
    i32.const 1073741816
    i32.gt_u
    if  ;; label = @1
      i32.const 0
      i32.const 14504
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
  (func $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#clear (type 5) (param i32)
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
  (func $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#constructor (type 8) (result i32)
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
  (func $src/mappings/betokenProxy/TestEvent#constructor (type 6) (param i32 i32 i32) (result i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 8
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
    local.get 1
    i32.store
    local.get 0
    local.get 2
    i32.store offset=4
    local.get 0)
  (func $~lib/@graphprotocol/graph-ts/index/Entity#constructor (type 3) (param i32) (result i32)
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
    call $~lib/array/Array<~lib/string/String>#constructor
    i32.store
    local.get 0)
  (func $~lib/@graphprotocol/graph-ts/index/Value#constructor (type 8) (result i32)
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
  (func $src/mappings/betokenProxy/TestEntity#constructor (type 6) (param i32 i32 i32) (result i32)
    (local i32)
    local.get 0
    if (result i32)  ;; label = @1
      local.get 0
    else
      i32.const 8
      call $~lib/allocator/arena/__memory_allocate
    end
    call $~lib/@graphprotocol/graph-ts/index/Entity#constructor
    local.tee 0
    i32.const 0
    i32.store offset=4
    call $~lib/@graphprotocol/graph-ts/index/Value#constructor
    local.tee 3
    i32.const 1
    i32.store
    local.get 3
    local.get 2
    i64.extend_i32_s
    i64.store offset=8
    local.get 0
    i32.load
    i32.const 0
    i32.const 14592
    local.get 3
    call $src/mappings/betokenProxy/TestEvent#constructor
    call $~lib/array/Array<~lib/string/String>#push
    local.get 0
    local.get 1
    i32.store offset=4
    local.get 0)
  (func $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get (type 1) (param i32 i32) (result i32)
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
  (func $~lib/string/String.__eq (type 1) (param i32 i32) (result i32)
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
  (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#getEntry (type 1) (param i32 i32) (result i32)
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
      i32.const 0
      local.get 1
      local.get 2
      call $src/mappings/betokenProxy/TestEvent#constructor
      local.set 1
      local.get 0
      i32.load
      local.get 1
      call $~lib/array/Array<~lib/string/String>#push
    end)
  (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get (type 1) (param i32 i32) (result i32)
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
          i32.load offset=4
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
  (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#isSet (type 1) (param i32 i32) (result i32)
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
          i32.const 1
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
  (func $~lib/@graphprotocol/graph-ts/index/Entity#unset (type 7) (param i32 i32)
    local.get 0
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/Value#constructor
    local.tee 0
    i32.const 5
    i32.store
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set)
  (func $~lib/@graphprotocol/graph-ts/index/Entity#merge (type 1) (param i32 i32) (result i32)
    (local i32 i32 i32)
    loop  ;; label = @1
      block  ;; label = @2
        local.get 3
        local.get 1
        i32.load offset=4
        i32.ge_s
        br_if 0 (;@2;)
        local.get 1
        local.get 3
        call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
        i32.load
        local.set 4
        i32.const 0
        local.set 2
        loop  ;; label = @3
          block  ;; label = @4
            local.get 2
            local.get 4
            i32.load offset=4
            i32.ge_s
            br_if 0 (;@4;)
            local.get 0
            local.get 4
            local.get 2
            call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
            i32.load
            local.get 4
            local.get 2
            call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
            i32.load offset=4
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
            local.get 2
            i32.const 1
            i32.add
            local.set 2
            br 1 (;@3;)
          end
        end
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        br 1 (;@1;)
      end
    end
    local.get 0)
  (func $~lib/internal/hash/hashStr (type 3) (param i32) (result i32)
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
  (func $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#find (type 6) (param i32 i32 i32) (result i32)
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
  (func $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#has (type 1) (param i32 i32) (result i32)
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
  (func $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#set (type 4) (param i32 i32 i32)
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
  (func $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get (type 1) (param i32 i32) (result i32)
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
  (func $~lib/subtest-as/assembly/store/store.set (type 4) (param i32 i32 i32)
    global.get 18
    local.get 0
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#has
    i32.eqz
    if  ;; label = @1
      global.get 18
      local.get 0
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#constructor
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#set
    end
    global.get 18
    local.get 0
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
    local.get 1
    local.get 2
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#set)
  (func $src/mappings/betokenProxy/handleTestEvent (type 5) (param i32)
    i32.const 14568
    i32.const 0
    local.get 0
    i32.load
    local.get 0
    i32.load offset=4
    call $src/mappings/betokenProxy/TestEntity#constructor
    local.tee 0
    i32.load offset=4
    local.get 0
    call $~lib/subtest-as/assembly/store/store.set)
  (func $src/mappings/betokenProxy/handleTestEvents~anonymous|0 (type 4) (param i32 i32 i32)
    local.get 0
    call $src/mappings/betokenProxy/handleTestEvent)
  (func $~lib/array/Array<src/mappings/betokenProxy/TestEvent>#forEach (type 7) (param i32 i32)
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
        global.set 22
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
  (func $src/mappings/betokenProxy/handleTestEvents (type 5) (param i32)
    local.get 0
    i32.const 1
    call $~lib/array/Array<src/mappings/betokenProxy/TestEvent>#forEach)
  (func $src/mappings/betokenProxy/Burger#constructor (type 6) (param i32 i32 i32) (result i32)
    (local i32)
    local.get 0
    if (result i32)  ;; label = @1
      local.get 0
    else
      i32.const 8
      call $~lib/allocator/arena/__memory_allocate
    end
    call $~lib/@graphprotocol/graph-ts/index/Entity#constructor
    local.tee 0
    i32.const 0
    i32.store offset=4
    call $~lib/@graphprotocol/graph-ts/index/Value#constructor
    local.tee 3
    i32.const 0
    i32.store
    local.get 3
    local.get 2
    i64.extend_i32_u
    i64.store offset=8
    local.get 0
    i32.load
    i32.const 0
    i32.const 14592
    local.get 3
    call $src/mappings/betokenProxy/TestEvent#constructor
    call $~lib/array/Array<~lib/string/String>#push
    local.get 0
    local.get 1
    i32.store offset=4
    local.get 0)
  (func $src/mappings/betokenProxy/handleNewBurger (type 5) (param i32)
    i32.const 14552
    i32.const 0
    local.get 0
    i32.load
    local.get 0
    i32.load offset=4
    call $src/mappings/betokenProxy/Burger#constructor
    local.tee 0
    i32.load offset=4
    local.get 0
    call $~lib/subtest-as/assembly/store/store.set)
  (func $src/mappings/betokenProxy/handleNewBurgers~anonymous|0 (type 4) (param i32 i32 i32)
    local.get 0
    call $src/mappings/betokenProxy/handleNewBurger)
  (func $src/mappings/betokenProxy/handleNewBurgers (type 5) (param i32)
    local.get 0
    i32.const 2
    call $~lib/array/Array<src/mappings/betokenProxy/TestEvent>#forEach)
  (func $~lib/@graphprotocol/graph-ts/index/Value.fromString (type 3) (param i32) (result i32)
    (local i32)
    call $~lib/@graphprotocol/graph-ts/index/Value#constructor
    local.tee 1
    i32.const 0
    i32.store
    local.get 1
    local.get 0
    i64.extend_i32_u
    i64.store offset=8
    local.get 1)
  (func $generated/schema/Fund#constructor (type 3) (param i32) (result i32)
    (local i32)
    i32.const 4
    call $~lib/allocator/arena/__memory_allocate
    call $~lib/@graphprotocol/graph-ts/index/Entity#constructor
    local.tee 1
    i32.const 14624
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/Value.fromString
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
    local.get 1)
  (func $generated/BetokenProxy/BetokenProxy/UpdatedFundAddress__Params#constructor (type 3) (param i32) (result i32)
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
  (func $~lib/@graphprotocol/graph-ts/index/EthereumValue#toAddress (type 3) (param i32) (result i32)
    local.get 0
    i32.load
    if  ;; label = @1
      i32.const 14632
      i32.const 14704
      i32.const 688
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i64.load offset=8
    i32.wrap_i64)
  (func $generated/BetokenProxy/BetokenProxy/UpdatedFundAddress__Params#get:_newFundAddr (type 3) (param i32) (result i32)
    local.get 0
    i32.load
    i32.load offset=24
    i32.const 0
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
    i32.load offset=4
    call $~lib/@graphprotocol/graph-ts/index/EthereumValue#toAddress)
  (func $generated/templates/BetokenFund/BetokenFund/BetokenFund#constructor (type 1) (param i32 i32) (result i32)
    i32.const 8
    call $~lib/allocator/arena/__memory_allocate
    local.get 0
    local.get 1
    call $src/mappings/betokenProxy/TestEvent#constructor)
  (func $~lib/@graphprotocol/graph-ts/index/SmartContractCall#constructor (type 2) (param i32 i32 i32 i32)
    (local i32)
    i32.const 16
    call $~lib/allocator/arena/__memory_allocate
    local.tee 4
    i32.const 0
    i32.store
    local.get 4
    i32.const 0
    i32.store offset=4
    local.get 4
    i32.const 0
    i32.store offset=8
    local.get 4
    i32.const 0
    i32.store offset=12
    local.get 4
    local.get 0
    i32.store
    local.get 4
    local.get 1
    i32.store offset=4
    local.get 4
    local.get 2
    i32.store offset=8
    local.get 4
    local.get 3
    i32.store offset=12)
  (func $~lib/internal/string/allocateUnsafe (type 3) (param i32) (result i32)
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
      i32.const 15112
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
  (func $~lib/internal/string/copyUnsafe (type 2) (param i32 i32 i32 i32)
    local.get 0
    local.get 1
    i32.const 1
    i32.shl
    i32.add
    i32.const 4
    i32.add
    local.get 2
    i32.const 4
    i32.add
    local.get 3
    i32.const 1
    i32.shl
    call $~lib/internal/memory/memmove)
  (func $~lib/string/String#concat (type 1) (param i32 i32) (result i32)
    (local i32 i32 i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 0
      i32.const 15072
      i32.const 110
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i32.load
    local.tee 3
    local.get 1
    i32.const 15056
    local.get 1
    select
    local.tee 1
    i32.load
    local.tee 4
    i32.add
    local.tee 2
    i32.eqz
    if  ;; label = @1
      i32.const 15104
      return
    end
    local.get 2
    call $~lib/internal/string/allocateUnsafe
    local.tee 2
    i32.const 0
    local.get 0
    local.get 3
    call $~lib/internal/string/copyUnsafe
    local.get 2
    local.get 3
    local.get 1
    local.get 4
    call $~lib/internal/string/copyUnsafe
    local.get 2)
  (func $~lib/string/String.__concat (type 1) (param i32 i32) (result i32)
    local.get 0
    i32.const 15056
    local.get 0
    select
    local.get 1
    call $~lib/string/String#concat)
  (func $~lib/@graphprotocol/graph-ts/index/SmartContract#call (type 6) (param i32 i32 i32) (result i32)
    local.get 0
    i32.load
    local.get 0
    i32.load offset=4
    local.get 1
    local.get 2
    call $~lib/@graphprotocol/graph-ts/index/SmartContractCall#constructor
    i32.const 0
    local.tee 0
    i32.eqz
    if  ;; label = @1
      i32.const 14840
      i32.const 15008
      call $~lib/string/String.__concat
      local.get 1
      call $~lib/string/String.__concat
      i32.const 15168
      call $~lib/string/String.__concat
      i32.const 14704
      i32.const 1356
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 0)
  (func $generated/templates/MiniMeToken/MiniMeToken/MiniMeToken.bind (type 3) (param i32) (result i32)
    i32.const 15240
    local.get 0
    call $generated/templates/BetokenFund/BetokenFund/BetokenFund#constructor)
  (func $generated/templates/BetokenFund/BetokenFund/BetokenFund#shareTokenAddr (type 3) (param i32) (result i32)
    local.get 0
    i32.const 15272
    i32.const 15312
    call $~lib/@graphprotocol/graph-ts/index/SmartContract#call
    i32.const 0
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
    call $~lib/@graphprotocol/graph-ts/index/EthereumValue#toAddress)
  (func $~lib/@graphprotocol/graph-ts/index/EthereumValue#toBigInt (type 3) (param i32) (result i32)
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
      i32.const 15376
      i32.const 14704
      i32.const 715
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i64.load offset=8
    i32.wrap_i64)
  (func $~lib/@graphprotocol/graph-ts/index/BigDecimal#div (type 1) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/bigDecimal.dividedBy)
  (func $src/utils/normalize (type 3) (param i32) (result i32)
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/BigDecimal#constructor
    global.get 9
    call $~lib/@graphprotocol/graph-ts/index/BigDecimal#div)
  (func $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal (type 3) (param i32) (result i32)
    (local i32)
    call $~lib/@graphprotocol/graph-ts/index/Value#constructor
    local.tee 1
    i32.const 2
    i32.store
    local.get 1
    local.get 0
    i64.extend_i32_u
    i64.store offset=8
    local.get 1)
  (func $~lib/@graphprotocol/graph-ts/index/Value#toBigDecimal (type 3) (param i32) (result i32)
    local.get 0
    i32.load
    i32.const 2
    i32.ne
    if  ;; label = @1
      i32.const 15456
      i32.const 14704
      i32.const 1041
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i64.load offset=8
    i32.wrap_i64)
  (func $generated/schema/Fund#get:totalFundsInDAI (type 3) (param i32) (result i32)
    local.get 0
    i32.const 15320
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
    call $~lib/@graphprotocol/graph-ts/index/Value#toBigDecimal)
  (func $generated/templates/MiniMeToken/MiniMeToken/MiniMeToken#totalSupply (type 3) (param i32) (result i32)
    local.get 0
    i32.const 15600
    i32.const 15640
    call $~lib/@graphprotocol/graph-ts/index/SmartContract#call
    i32.const 0
    call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
    call $~lib/@graphprotocol/graph-ts/index/EthereumValue#toBigInt)
  (func $~lib/internal/typedarray/TypedArray<u8>#__get (type 1) (param i32 i32) (result i32)
    local.get 1
    local.get 0
    i32.load offset=8
    i32.ge_u
    if  ;; label = @1
      i32.const 0
      i32.const 6480
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
  (func $~lib/@graphprotocol/graph-ts/index/BigInt.compare (type 1) (param i32 i32) (result i32)
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
  (func $generated/schema/Fund#set:sharesPrice (type 7) (param i32 i32)
    local.get 0
    i32.const 15688
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set)
  (func $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/Value>#__set (type 4) (param i32 i32 i32)
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
        i32.const 8
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
  (func $~lib/@graphprotocol/graph-ts/index/Value.fromArray (type 3) (param i32) (result i32)
    (local i32)
    call $~lib/@graphprotocol/graph-ts/index/Value#constructor
    local.tee 1
    i32.const 4
    i32.store
    local.get 1
    local.get 0
    i64.extend_i32_u
    i64.store offset=8
    local.get 1)
  (func $~lib/@graphprotocol/graph-ts/index/Value.fromStringArray (type 3) (param i32) (result i32)
    (local i32 i32)
    local.get 0
    i32.load offset=4
    call $~lib/array/Array<~lib/string/String>#constructor
    local.set 2
    loop  ;; label = @1
      block  ;; label = @2
        local.get 1
        local.get 0
        i32.load offset=4
        i32.ge_s
        br_if 0 (;@2;)
        local.get 2
        local.get 1
        local.get 0
        local.get 1
        call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
        call $~lib/@graphprotocol/graph-ts/index/Value.fromString
        call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/Value>#__set
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        br 1 (;@1;)
      end
    end
    local.get 2
    call $~lib/@graphprotocol/graph-ts/index/Value.fromArray)
  (func $generated/schema/Fund#set:managers (type 7) (param i32 i32)
    local.get 0
    i32.const 15888
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/Value.fromStringArray
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set)
  (func $~lib/@graphprotocol/graph-ts/index/Value.fromBigInt (type 3) (param i32) (result i32)
    (local i32)
    call $~lib/@graphprotocol/graph-ts/index/Value#constructor
    local.tee 1
    i32.const 7
    i32.store
    local.get 1
    local.get 0
    i64.extend_i32_u
    i64.store offset=8
    local.get 1)
  (func $~lib/@graphprotocol/graph-ts/index/ByteArray#toI32 (type 3) (param i32) (result i32)
    (local i32 i32 i32)
    i32.const 255
    i32.const 0
    local.get 0
    i32.load offset=8
    i32.const 0
    i32.gt_s
    local.tee 1
    if (result i32)  ;; label = @1
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
    else
      local.get 1
    end
    select
    local.set 2
    i32.const 4
    local.set 1
    loop  ;; label = @1
      local.get 1
      local.get 0
      i32.load offset=8
      i32.lt_s
      if  ;; label = @2
        local.get 0
        local.get 1
        call $~lib/internal/typedarray/TypedArray<u8>#__get
        i32.const 255
        i32.and
        local.get 2
        i32.ne
        if  ;; label = @3
          i32.const 16000
          local.get 0
          call $~lib/@graphprotocol/graph-ts/index/typeConversion.bytesToHex
          call $~lib/string/String.__concat
          i32.const 16048
          call $~lib/string/String.__concat
          i32.const 14704
          i32.const 324
          i32.const 8
          call $~lib/env/abort
          unreachable
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
    i32.const 12
    call $~lib/allocator/arena/__memory_allocate
    call $~lib/@graphprotocol/graph-ts/index/ByteArray#constructor
    local.tee 1
    i32.const 0
    local.get 2
    call $~lib/internal/typedarray/TypedArray<u8>#__set
    local.get 1
    i32.const 1
    local.get 2
    call $~lib/internal/typedarray/TypedArray<u8>#__set
    local.get 1
    i32.const 2
    local.get 2
    call $~lib/internal/typedarray/TypedArray<u8>#__set
    local.get 1
    i32.const 3
    local.get 2
    call $~lib/internal/typedarray/TypedArray<u8>#__set
    local.get 1
    i32.load offset=8
    local.get 0
    i32.load offset=8
    i32.lt_s
    if (result i32)  ;; label = @1
      local.get 1
      i32.load offset=8
    else
      local.get 0
      i32.load offset=8
    end
    local.set 3
    i32.const 0
    local.set 2
    loop  ;; label = @1
      local.get 2
      local.get 3
      i32.lt_s
      if  ;; label = @2
        local.get 1
        local.get 2
        local.get 0
        local.get 2
        call $~lib/internal/typedarray/TypedArray<u8>#__get
        i32.const 255
        i32.and
        call $~lib/internal/typedarray/TypedArray<u8>#__set
        local.get 2
        i32.const 1
        i32.add
        local.set 2
        br 1 (;@1;)
      end
    end
    local.get 1
    i32.const 3
    call $~lib/internal/typedarray/TypedArray<u8>#__get
    i32.const 255
    i32.and
    i32.const 8
    i32.shl
    local.get 1
    i32.const 2
    call $~lib/internal/typedarray/TypedArray<u8>#__get
    i32.const 255
    i32.and
    i32.or
    i32.const 8
    i32.shl
    local.get 1
    i32.const 1
    call $~lib/internal/typedarray/TypedArray<u8>#__get
    i32.const 255
    i32.and
    i32.or
    i32.const 8
    i32.shl
    local.get 1
    i32.const 0
    call $~lib/internal/typedarray/TypedArray<u8>#__get
    i32.const 255
    i32.and
    i32.or)
  (func $~lib/@graphprotocol/graph-ts/index/EthereumValue#toI32 (type 3) (param i32) (result i32)
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
      i32.const 15376
      i32.const 14704
      i32.const 706
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i64.load offset=8
    i32.wrap_i64
    call $~lib/@graphprotocol/graph-ts/index/ByteArray#toI32)
  (func $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimalArray (type 3) (param i32) (result i32)
    (local i32 i32)
    local.get 0
    i32.load offset=4
    call $~lib/array/Array<~lib/string/String>#constructor
    local.set 2
    loop  ;; label = @1
      block  ;; label = @2
        local.get 1
        local.get 0
        i32.load offset=4
        i32.ge_s
        br_if 0 (;@2;)
        local.get 2
        local.get 1
        local.get 0
        local.get 1
        call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
        call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
        call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/Value>#__set
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        br 1 (;@1;)
      end
    end
    local.get 2
    call $~lib/@graphprotocol/graph-ts/index/Value.fromArray)
  (func $generated/schema/Fund#set:versionNum (type 7) (param i32 i32)
    local.get 0
    i32.const 16160
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/Value.fromBigInt
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set)
  (func $~lib/@graphprotocol/graph-ts/index/EthereumValue.fromAddress (type 3) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.load offset=8
    i32.const 20
    i32.ne
    if  ;; label = @1
      i32.const 16232
      i32.const 14704
      i32.const 832
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    call $~lib/@graphprotocol/graph-ts/index/Value#constructor
    local.tee 1
    i32.const 0
    i32.store
    local.get 1
    local.get 0
    i64.extend_i32_u
    i64.store offset=8
    local.get 1)
  (func $generated/schema/Manager#get:kairoBalance (type 3) (param i32) (result i32)
    local.get 0
    i32.const 16312
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
    call $~lib/@graphprotocol/graph-ts/index/Value#toBigDecimal)
  (func $~lib/@graphprotocol/graph-ts/index/Value.fromBoolean (type 8) (result i32)
    (local i32)
    call $~lib/@graphprotocol/graph-ts/index/Value#constructor
    local.tee 0
    i32.const 3
    i32.store
    local.get 0
    i64.const 0
    i64.store offset=8
    local.get 0)
  (func $~lib/@graphprotocol/graph-ts/index/Value#toString (type 3) (param i32) (result i32)
    local.get 0
    i32.load
    if  ;; label = @1
      i32.const 17160
      i32.const 14704
      i32.const 1031
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i64.load offset=8
    i32.wrap_i64)
  (func $generated/schema/Manager#save (type 5) (param i32)
    (local i32)
    local.get 0
    i32.const 14624
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
    local.tee 1
    i32.eqz
    if  ;; label = @1
      i32.const 16792
      i32.const 16880
      i32.const 23
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 1
    i32.load
    if  ;; label = @1
      i32.const 16928
      i32.const 17032
      call $~lib/string/String.__concat
      i32.const 16880
      i32.const 24
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    i32.const 16184
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/Value#toString
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/store.set)
  (func $~lib/@graphprotocol/graph-ts/index/Value#toArray (type 3) (param i32) (result i32)
    local.get 0
    i32.load
    i32.const 4
    i32.ne
    if  ;; label = @1
      i32.const 17208
      i32.const 14704
      i32.const 1046
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i64.load offset=8
    i32.wrap_i64)
  (func $~lib/@graphprotocol/graph-ts/index/Value#toStringArray (type 3) (param i32) (result i32)
    (local i32 i32)
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/Value#toArray
    local.tee 1
    i32.load offset=4
    call $~lib/array/Array<~lib/string/String>#constructor
    local.set 2
    i32.const 0
    local.set 0
    loop  ;; label = @1
      block  ;; label = @2
        local.get 0
        local.get 1
        i32.load offset=4
        i32.ge_s
        br_if 0 (;@2;)
        local.get 2
        local.get 0
        local.get 1
        local.get 0
        call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
        call $~lib/@graphprotocol/graph-ts/index/Value#toString
        call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/Value>#__set
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        br 1 (;@1;)
      end
    end
    local.get 2)
  (func $~lib/@graphprotocol/graph-ts/index/DataSourceTemplate.create (type 7) (param i32 i32)
    local.get 0
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/dataSource.create)
  (func $~lib/@graphprotocol/graph-ts/index/Value#toBigInt (type 3) (param i32) (result i32)
    local.get 0
    i32.load
    i32.const 7
    i32.ne
    if  ;; label = @1
      i32.const 17256
      i32.const 14704
      i32.const 1036
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 0
    i64.load offset=8
    i32.wrap_i64)
  (func $generated/schema/Fund#save (type 5) (param i32)
    (local i32)
    local.get 0
    i32.const 14624
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
    local.tee 1
    i32.eqz
    if  ;; label = @1
      i32.const 17656
      i32.const 16880
      i32.const 900
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    local.get 1
    i32.load
    if  ;; label = @1
      i32.const 17736
      i32.const 17032
      call $~lib/string/String.__concat
      i32.const 16880
      i32.const 901
      i32.const 4
      call $~lib/env/abort
      unreachable
    end
    i32.const 14608
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/Value#toString
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/store.set)
  (func $src/mappings/betokenProxy/handleUpdatedFundAddress (type 5) (param i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    i32.const 14608
    global.get 11
    call $~lib/@graphprotocol/graph-ts/index/store.get
    local.tee 1
    if  ;; label = @1
      local.get 1
      local.get 1
      i32.const 16160
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
      call $~lib/@graphprotocol/graph-ts/index/Value#toBigInt
      i32.const 1
      call $~lib/@graphprotocol/graph-ts/index/ByteArray.fromI32
      call $~lib/@graphprotocol/graph-ts/index/bigInt.plus
      call $generated/schema/Fund#set:versionNum
    else
      global.get 11
      call $generated/schema/Fund#constructor
      local.set 1
      i32.const 6648
      local.get 0
      call $generated/BetokenProxy/BetokenProxy/UpdatedFundAddress__Params#constructor
      call $generated/BetokenProxy/BetokenProxy/UpdatedFundAddress__Params#get:_newFundAddr
      call $generated/templates/BetokenFund/BetokenFund/BetokenFund#constructor
      local.tee 3
      i32.const 14784
      i32.const 14832
      call $~lib/@graphprotocol/graph-ts/index/SmartContract#call
      i32.const 0
      call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
      call $~lib/@graphprotocol/graph-ts/index/EthereumValue#toAddress
      call $generated/templates/MiniMeToken/MiniMeToken/MiniMeToken.bind
      local.set 6
      local.get 3
      call $generated/templates/BetokenFund/BetokenFund/BetokenFund#shareTokenAddr
      call $generated/templates/MiniMeToken/MiniMeToken/MiniMeToken.bind
      local.set 2
      local.get 1
      i32.const 15320
      local.get 3
      i32.const 15320
      i32.const 15368
      call $~lib/@graphprotocol/graph-ts/index/SmartContract#call
      i32.const 0
      call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
      call $~lib/@graphprotocol/graph-ts/index/EthereumValue#toBigInt
      call $src/utils/normalize
      call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
      local.get 1
      i32.const 15512
      local.get 1
      call $generated/schema/Fund#get:totalFundsInDAI
      call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
      local.get 1
      i32.const 15560
      local.get 3
      i32.const 15560
      i32.const 15592
      call $~lib/@graphprotocol/graph-ts/index/SmartContract#call
      i32.const 0
      call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
      call $~lib/@graphprotocol/graph-ts/index/EthereumValue#toBigInt
      call $src/utils/normalize
      call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
      local.get 1
      i32.const 15648
      local.get 6
      call $generated/templates/MiniMeToken/MiniMeToken/MiniMeToken#totalSupply
      call $src/utils/normalize
      call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
      local.get 2
      call $generated/templates/MiniMeToken/MiniMeToken/MiniMeToken#totalSupply
      global.get 6
      call $~lib/@graphprotocol/graph-ts/index/BigInt.compare
      if  ;; label = @2
        local.get 1
        local.get 1
        call $generated/schema/Fund#get:totalFundsInDAI
        local.get 2
        call $generated/templates/MiniMeToken/MiniMeToken/MiniMeToken#totalSupply
        call $src/utils/normalize
        call $~lib/@graphprotocol/graph-ts/index/BigDecimal#div
        call $generated/schema/Fund#set:sharesPrice
      else
        local.get 1
        i32.const 6552
        call $~lib/@graphprotocol/graph-ts/index/bigDecimal.fromString
        call $generated/schema/Fund#set:sharesPrice
      end
      local.get 1
      i32.const 15720
      local.get 2
      call $generated/templates/MiniMeToken/MiniMeToken/MiniMeToken#totalSupply
      call $src/utils/normalize
      call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
      local.get 1
      i32.const 15760
      i32.const 0
      call $~lib/array/Array<~lib/string/String>#constructor
      call $~lib/@graphprotocol/graph-ts/index/Value.fromStringArray
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
      local.get 1
      i32.const 15800
      local.get 1
      call $generated/schema/Fund#get:totalFundsInDAI
      call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
      local.get 1
      i32.const 15816
      i32.const 0
      call $~lib/array/Array<~lib/string/String>#constructor
      call $~lib/@graphprotocol/graph-ts/index/Value.fromStringArray
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
      local.get 1
      i32.const 15840
      global.get 7
      call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
      local.get 1
      i32.const 0
      call $~lib/array/Array<~lib/string/String>#constructor
      call $generated/schema/Fund#set:managers
      local.get 1
      i32.const 15912
      local.get 3
      i32.const 15912
      i32.const 15952
      call $~lib/@graphprotocol/graph-ts/index/SmartContract#call
      i32.const 0
      call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
      call $~lib/@graphprotocol/graph-ts/index/EthereumValue#toBigInt
      call $~lib/@graphprotocol/graph-ts/index/Value.fromBigInt
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
      local.get 1
      i32.const 15960
      global.get 2
      local.get 3
      i32.const 15960
      i32.const 15992
      call $~lib/@graphprotocol/graph-ts/index/SmartContract#call
      i32.const 0
      call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
      call $~lib/@graphprotocol/graph-ts/index/EthereumValue#toI32
      call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
      call $~lib/@graphprotocol/graph-ts/index/Value.fromString
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
      local.get 1
      i32.const 16072
      global.get 6
      call $~lib/@graphprotocol/graph-ts/index/Value.fromBigInt
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
      local.get 1
      i32.const 16120
      i32.const 0
      call $~lib/array/Array<~lib/string/String>#constructor
      call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimalArray
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
      local.get 1
      global.get 6
      call $generated/schema/Fund#set:versionNum
      loop  ;; label = @2
        local.get 5
        global.get 17
        i32.load offset=4
        i32.lt_s
        if  ;; label = @3
          i32.const 16184
          global.get 17
          local.get 5
          call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
          local.tee 4
          call $~lib/@graphprotocol/graph-ts/index/store.get
          i32.eqz
          if  ;; label = @4
            local.get 4
            call $generated/schema/Fund#constructor
            local.tee 2
            i32.const 16312
            local.get 4
            call $~lib/@graphprotocol/graph-ts/index/typeConversion.stringToH160
            local.set 4
            local.get 6
            i32.const 16208
            i32.const 1
            call $~lib/array/Array<~lib/string/String>#constructor
            local.tee 7
            i32.const 0
            local.get 4
            call $~lib/@graphprotocol/graph-ts/index/EthereumValue.fromAddress
            call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
            local.get 7
            call $~lib/@graphprotocol/graph-ts/index/SmartContract#call
            i32.const 0
            call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
            call $~lib/@graphprotocol/graph-ts/index/EthereumValue#toBigInt
            call $src/utils/normalize
            call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
            local.get 2
            i32.const 16344
            local.get 2
            call $generated/schema/Manager#get:kairoBalance
            call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
            local.get 2
            i32.const 16392
            local.get 2
            call $generated/schema/Manager#get:kairoBalance
            call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
            local.get 2
            i32.const 16416
            global.get 7
            call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
            local.get 2
            i32.const 16440
            local.get 2
            i32.const 16392
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
            call $~lib/@graphprotocol/graph-ts/index/Value#toBigDecimal
            global.get 13
            call $~lib/@graphprotocol/graph-ts/index/bigDecimal.times
            call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
            local.get 2
            i32.const 16472
            global.get 6
            call $~lib/@graphprotocol/graph-ts/index/Value.fromBigInt
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
            local.get 2
            i32.const 16528
            i32.const 0
            call $~lib/array/Array<~lib/string/String>#constructor
            call $~lib/@graphprotocol/graph-ts/index/Value.fromStringArray
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
            local.get 2
            i32.const 16560
            i32.const 0
            call $~lib/array/Array<~lib/string/String>#constructor
            call $~lib/@graphprotocol/graph-ts/index/Value.fromStringArray
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
            local.get 2
            i32.const 16592
            i32.const 0
            call $~lib/array/Array<~lib/string/String>#constructor
            call $~lib/@graphprotocol/graph-ts/index/Value.fromStringArray
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
            local.get 2
            i32.const 16624
            i32.const 0
            call $~lib/array/Array<~lib/string/String>#constructor
            call $~lib/@graphprotocol/graph-ts/index/Value.fromStringArray
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
            local.get 2
            i32.const 16664
            i32.const 0
            call $~lib/array/Array<~lib/string/String>#constructor
            call $~lib/@graphprotocol/graph-ts/index/Value.fromStringArray
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
            local.get 2
            i32.const 16680
            call $~lib/@graphprotocol/graph-ts/index/Value.fromBoolean
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
            local.get 2
            i32.const 16712
            global.get 7
            call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
            local.get 2
            i32.const 16768
            i32.const 0
            call $~lib/array/Array<~lib/string/String>#constructor
            call $~lib/@graphprotocol/graph-ts/index/Value.fromStringArray
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
            local.get 2
            call $generated/schema/Manager#save
            local.get 1
            i32.const 15888
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
            call $~lib/@graphprotocol/graph-ts/index/Value#toStringArray
            local.tee 4
            local.get 2
            i32.const 14624
            call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
            call $~lib/@graphprotocol/graph-ts/index/Value#toString
            call $~lib/array/Array<~lib/string/String>#push
            local.get 1
            local.get 4
            call $generated/schema/Fund#set:managers
          end
          local.get 5
          i32.const 1
          i32.add
          local.set 5
          br 1 (;@2;)
        end
      end
      local.get 3
      call $generated/templates/BetokenFund/BetokenFund/BetokenFund#shareTokenAddr
      local.set 2
      i32.const 15240
      i32.const 1
      call $~lib/array/Array<~lib/string/String>#constructor
      local.tee 3
      i32.const 0
      local.get 2
      call $~lib/@graphprotocol/graph-ts/index/typeConversion.bytesToHex
      call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
      local.get 3
      call $~lib/@graphprotocol/graph-ts/index/DataSourceTemplate.create
    end
    local.get 1
    i32.const 17304
    local.get 0
    call $generated/BetokenProxy/BetokenProxy/UpdatedFundAddress__Params#constructor
    call $generated/BetokenProxy/BetokenProxy/UpdatedFundAddress__Params#get:_newFundAddr
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.bytesToHex
    call $~lib/@graphprotocol/graph-ts/index/Value.fromString
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
    local.get 1
    i32.const 17328
    local.get 0
    i32.load offset=16
    i32.load offset=28
    call $~lib/@graphprotocol/graph-ts/index/Value.fromBigInt
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
    local.get 1
    i32.const 17368
    call $~lib/@graphprotocol/graph-ts/index/Value.fromBoolean
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
    local.get 1
    i32.const 17424
    call $~lib/@graphprotocol/graph-ts/index/Value.fromBoolean
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
    local.get 1
    i32.const 17472
    i32.const 15104
    call $~lib/@graphprotocol/graph-ts/index/Value.fromString
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
    local.get 1
    i32.const 17504
    i32.const 0
    call $~lib/array/Array<~lib/string/String>#constructor
    call $~lib/@graphprotocol/graph-ts/index/Value.fromStringArray
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
    local.get 1
    i32.const 17528
    i32.const 0
    call $~lib/array/Array<~lib/string/String>#constructor
    call $~lib/@graphprotocol/graph-ts/index/Value.fromStringArray
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
    local.get 1
    i32.const 17552
    i32.const 0
    call $~lib/array/Array<~lib/string/String>#constructor
    call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimalArray
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
    local.get 1
    i32.const 17576
    i32.const 0
    call $~lib/array/Array<~lib/string/String>#constructor
    call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimalArray
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
    local.get 1
    i32.const 17608
    global.get 7
    call $~lib/@graphprotocol/graph-ts/index/Value.fromBigDecimal
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set
    local.get 1
    call $generated/schema/Fund#save
    local.get 0
    call $generated/BetokenProxy/BetokenProxy/UpdatedFundAddress__Params#constructor
    call $generated/BetokenProxy/BetokenProxy/UpdatedFundAddress__Params#get:_newFundAddr
    local.set 0
    i32.const 6648
    i32.const 1
    call $~lib/array/Array<~lib/string/String>#constructor
    local.tee 1
    i32.const 0
    local.get 0
    call $~lib/@graphprotocol/graph-ts/index/typeConversion.bytesToHex
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 1
    call $~lib/@graphprotocol/graph-ts/index/DataSourceTemplate.create)
  (func $src/mappings/betokenProxy/handleUpdatedFundAddresses~anonymous|0 (type 4) (param i32 i32 i32)
    local.get 0
    call $src/mappings/betokenProxy/handleUpdatedFundAddress)
  (func $src/mappings/betokenProxy/handleUpdatedFundAddresses (type 5) (param i32)
    local.get 0
    i32.const 3
    call $~lib/array/Array<src/mappings/betokenProxy/TestEvent>#forEach)
  (func $~lib/subtest-as/assembly/store/store.assertFieldEq (type 7) (param i32 i32)
    (local i32)
    global.get 18
    i32.const 14552
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#has
    local.tee 2
    if  ;; label = @1
      global.get 18
      i32.const 14552
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      local.get 0
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#has
      local.set 2
    end
    local.get 2
    if (result i32)  ;; label = @1
      global.get 18
      i32.const 14552
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      local.get 0
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      i32.const 14592
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
    else
      local.get 2
    end
    if  ;; label = @1
      i32.const 3
      i32.const 18040
      i32.const 14592
      call $~lib/string/String.__concat
      i32.const 18080
      call $~lib/string/String.__concat
      i32.const 14552
      call $~lib/string/String.__concat
      i32.const 18136
      call $~lib/string/String.__concat
      local.get 0
      call $~lib/string/String.__concat
      i32.const 18160
      call $~lib/string/String.__concat
      local.get 1
      call $~lib/string/String.__concat
      i32.const 18184
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.log
      global.get 18
      i32.const 14552
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      local.get 0
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      i32.const 14592
      call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
      call $~lib/@graphprotocol/graph-ts/index/Value#toString
      local.get 1
      call $~lib/string/String.__eq
      drop
    end)
  (func $src/test/tests/runTests~anonymous|0 (type 0)
    (local i32 i32)
    i32.const 0
    i32.const 17944
    i32.const 4
    call $src/mappings/betokenProxy/TestEntity#constructor
    local.set 0
    i32.const 0
    i32.const 17976
    i32.const 18000
    call $src/mappings/betokenProxy/Burger#constructor
    local.set 1
    i32.const 14568
    local.get 0
    i32.load offset=4
    local.get 0
    call $~lib/subtest-as/assembly/store/store.set
    i32.const 14552
    local.get 1
    i32.load offset=4
    local.get 1
    call $~lib/subtest-as/assembly/store/store.set
    i32.const 17976
    i32.const 18000
    call $~lib/subtest-as/assembly/store/store.assertFieldEq
    global.get 18
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#clear)
  (func $~lib/subtest-as/assembly/index/test (type 5) (param i32)
    i32.const 0
    global.set 22
    local.get 0
    call_indirect (type 0))
  (func $src/test/tests/runTests~anonymous|1 (type 0)
    (local i32 i32 i32)
    i32.const 14552
    i32.const 0
    i32.const 18272
    i32.const 18000
    call $src/mappings/betokenProxy/Burger#constructor
    local.tee 0
    i32.load offset=4
    local.get 0
    call $~lib/subtest-as/assembly/store/store.set
    i32.const 0
    i32.const 17944
    i32.const 4
    call $src/mappings/betokenProxy/TestEvent#constructor
    call $src/mappings/betokenProxy/handleTestEvent
    i32.const 0
    i32.const 18296
    i32.const 18320
    call $src/mappings/betokenProxy/TestEvent#constructor
    local.set 1
    i32.const 0
    i32.const 18336
    i32.const 18360
    call $src/mappings/betokenProxy/TestEvent#constructor
    local.set 2
    i32.const 2
    call $~lib/array/Array<~lib/string/String>#constructor
    local.tee 0
    i32.const 0
    local.get 1
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 0
    i32.const 1
    local.get 2
    call $~lib/array/Array<src/fulcrum_tokens/pTokenInfo>#__unchecked_set
    local.get 0
    call $src/mappings/betokenProxy/handleNewBurgers
    i32.const 18272
    i32.const 18000
    call $~lib/subtest-as/assembly/store/store.assertFieldEq
    i32.const 18296
    i32.const 18320
    call $~lib/subtest-as/assembly/store/store.assertFieldEq
    i32.const 18336
    i32.const 18360
    call $~lib/subtest-as/assembly/store/store.assertFieldEq
    global.get 18
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#clear)
  (func $~lib/subtest-as/assembly/log/log.critical (type 5) (param i32)
    i32.const 0
    local.get 0
    call $~lib/subtest-as/assembly/log/log.log)
  (func $~lib/subtest-as/assembly/store/store.get (type 8) (result i32)
    global.get 18
    i32.const 14552
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#has
    if  ;; label = @1
      global.get 18
      i32.const 14552
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      i32.const 18496
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      return
    end
    i32.const 18528
    i32.const 14552
    call $~lib/string/String.__concat
    call $~lib/subtest-as/assembly/log/log.critical
    i32.const 0
    call $~lib/@graphprotocol/graph-ts/index/Entity#constructor)
  (func $~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>#delete (type 5) (param i32)
    (local i32 i32)
    local.get 0
    i32.const 18496
    i32.const 18496
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
  (func $~lib/subtest-as/assembly/store/store.remove (type 0)
    (local i32)
    global.get 18
    i32.const 14552
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#has
    local.tee 0
    if (result i32)  ;; label = @1
      global.get 18
      i32.const 14552
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      i32.const 18496
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#has
    else
      local.get 0
    end
    if  ;; label = @1
      global.get 18
      i32.const 14552
      call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#get
      call $~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>#delete
    end)
  (func $src/test/tests/runTests~anonymous|2 (type 0)
    (local i32)
    i32.const 14552
    i32.const 0
    i32.const 18496
    i32.const 18504
    call $src/mappings/betokenProxy/Burger#constructor
    local.tee 0
    i32.load offset=4
    local.get 0
    call $~lib/subtest-as/assembly/store/store.set
    i32.const 18496
    call $~lib/subtest-as/assembly/store/store.get
    i32.const 14592
    call $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get
    call $~lib/@graphprotocol/graph-ts/index/Value#toString
    call $~lib/subtest-as/assembly/store/store.assertFieldEq
    call $~lib/subtest-as/assembly/store/store.remove
    global.get 18
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#clear)
  (func $~lib/string/String#charCodeAt (type 1) (param i32 i32) (result i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 0
      i32.const 15072
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
  (func $~lib/subtest-as/assembly/index/createHash (type 3) (param i32) (result i32)
    (local i32 i32)
    i32.const 18608
    i32.const 18640
    call $~lib/string/String.__concat
    local.set 2
    loop  ;; label = @1
      local.get 1
      local.get 0
      i32.load offset=4
      i32.lt_s
      if  ;; label = @2
        local.get 2
        local.get 0
        local.get 1
        call $~lib/array/Array<~lib/@graphprotocol/graph-ts/index/TypedMapEntry<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>>#__get
        call $~lib/string/String#concat
        drop
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        br 1 (;@1;)
      end
    end
    i32.const 0
    local.set 1
    local.get 2
    i32.load
    i32.eqz
    if  ;; label = @1
      i32.const 0
      return
    end
    i32.const 0
    local.set 0
    loop  ;; label = @1
      local.get 0
      local.get 2
      i32.load
      i32.lt_s
      if  ;; label = @2
        local.get 2
        local.get 0
        call $~lib/string/String#charCodeAt
        local.get 1
        i32.const 5
        i32.shl
        local.get 1
        i32.sub
        i32.add
        local.set 1
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        br 1 (;@1;)
      end
    end
    local.get 1)
  (func $~lib/internal/hash/hash32 (type 3) (param i32) (result i32)
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
  (func $~lib/map/Map<i32_~lib/string/String>#find (type 6) (param i32 i32 i32) (result i32)
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
  (func $~lib/map/Map<i32_~lib/string/String>#set (type 7) (param i32 i32)
    (local i32 i32)
    local.get 0
    local.get 1
    local.get 1
    call $~lib/internal/hash/hash32
    local.tee 3
    call $~lib/map/Map<i32_~lib/string/String>#find
    local.tee 2
    if  ;; label = @1
      local.get 2
      i32.const 18736
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
      local.tee 2
      i32.const 1
      i32.add
      i32.store offset=16
      local.get 2
      i32.const 12
      i32.mul
      i32.add
      local.tee 2
      local.get 1
      i32.store
      local.get 2
      i32.const 18736
      i32.store offset=4
      local.get 0
      local.get 0
      i32.load offset=20
      i32.const 1
      i32.add
      i32.store offset=20
      local.get 2
      local.get 0
      i32.load
      local.get 3
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
      local.get 2
      i32.store offset=8
    end)
  (func $~lib/subtest-as/assembly/index/callFunction (type 8) (result i32)
    (local i32 i32)
    i32.const 18784
    call $~lib/subtest-as/assembly/index/createHash
    local.tee 0
    local.set 1
    global.get 19
    local.get 1
    local.get 1
    call $~lib/internal/hash/hash32
    call $~lib/map/Map<i32_~lib/string/String>#find
    if  ;; label = @1
      global.get 19
      local.get 0
      local.get 0
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
    i32.const 18792
    i32.const 18640
    call $~lib/string/String.__concat
    i32.const 18848
    call $~lib/string/String.__concat
    i32.const 18608
    call $~lib/string/String.__concat
    i32.const 18896
    call $~lib/string/String.__concat
    call $~lib/subtest-as/assembly/log/log.critical
    i32.const 15104)
  (func $src/test/tests/runTests~anonymous|3 (type 0)
    (local i32)
    i32.const 18728
    call $~lib/subtest-as/assembly/index/createHash
    local.set 0
    global.get 19
    local.get 0
    call $~lib/map/Map<i32_~lib/string/String>#set
    i32.const 18736
    call $~lib/subtest-as/assembly/index/callFunction
    local.tee 0
    call $~lib/string/String.__eq
    i32.eqz
    if  ;; label = @1
      i32.const 18960
      local.get 0
      call $~lib/string/String.__concat
      i32.const 19056
      call $~lib/string/String.__concat
      call $~lib/subtest-as/assembly/log/log.critical
    end)
  (func $src/test/tests/runTests (type 0)
    i32.const 4
    call $~lib/subtest-as/assembly/index/test
    i32.const 5
    call $~lib/subtest-as/assembly/index/test
    i32.const 6
    call $~lib/subtest-as/assembly/index/test
    i32.const 7
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
    i32.const 19080
    global.set 0
    global.get 0
    global.set 1
    call $start:src/utils
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#constructor
    global.set 18
    call $~lib/map/Map<~lib/string/String_~lib/map/Map<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Entity>>#constructor
    global.set 19)
  (func $null (type 0)
    nop)
  (func $TestEvent#get:id (type 3) (param i32) (result i32)
    local.get 0
    i32.load)
  (func $TestEvent#set:id (type 7) (param i32 i32)
    local.get 0
    local.get 1
    i32.store)
  (func $TestEvent#get:num (type 3) (param i32) (result i32)
    local.get 0
    i32.load offset=4)
  (func $TestEvent#set:num (type 7) (param i32 i32)
    local.get 0
    local.get 1
    i32.store offset=4)
  (table (;0;) 8 funcref)
  (memory (;0;) 1)
  (global (;0;) (mut i32) (i32.const 0))
  (global (;1;) (mut i32) (i32.const 0))
  (global (;2;) (mut i32) (i32.const 0))
  (global (;3;) (mut i32) (i32.const 0))
  (global (;4;) (mut i32) (i32.const 0))
  (global (;5;) (mut i32) (i32.const 0))
  (global (;6;) (mut i32) (i32.const 0))
  (global (;7;) (mut i32) (i32.const 0))
  (global (;8;) (mut i32) (i32.const 0))
  (global (;9;) (mut i32) (i32.const 0))
  (global (;10;) (mut i32) (i32.const 0))
  (global (;11;) (mut i32) (i32.const 6648))
  (global (;12;) (mut i32) (i32.const 0))
  (global (;13;) (mut i32) (i32.const 0))
  (global (;14;) (mut i32) (i32.const 0))
  (global (;15;) (mut i32) (i32.const 0))
  (global (;16;) (mut i32) (i32.const 0))
  (global (;17;) (mut i32) (i32.const 14496))
  (global (;18;) (mut i32) (i32.const 0))
  (global (;19;) (mut i32) (i32.const 0))
  (global (;20;) i32 (i32.const 14552))
  (global (;21;) i32 (i32.const 14568))
  (global (;22;) (mut i32) (i32.const 0))
  (export "memory" (memory 0))
  (export "table" (table 0))
  (export "EntityTypes.BURGER" (global 20))
  (export "EntityTypes.TEST_ENTITY" (global 21))
  (export "TestEvent#get:id" (func $TestEvent#get:id))
  (export "TestEvent#set:id" (func $TestEvent#set:id))
  (export "TestEvent#get:num" (func $TestEvent#get:num))
  (export "TestEvent#set:num" (func $TestEvent#set:num))
  (export "TestEvent#constructor" (func $src/mappings/betokenProxy/TestEvent#constructor))
  (export "TestEntity#get:entries" (func $TestEvent#get:id))
  (export "TestEntity#set:entries" (func $TestEvent#set:id))
  (export "TestEntity#constructor" (func $src/mappings/betokenProxy/TestEntity#constructor))
  (export "TestEntity#set" (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set))
  (export "TestEntity#getEntry" (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#getEntry))
  (export "TestEntity#get" (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get))
  (export "TestEntity#isSet" (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#isSet))
  (export "TestEntity#unset" (func $~lib/@graphprotocol/graph-ts/index/Entity#unset))
  (export "TestEntity#merge" (func $~lib/@graphprotocol/graph-ts/index/Entity#merge))
  (export "TestEntity#get:id" (func $TestEvent#get:num))
  (export "TestEntity#set:id" (func $TestEvent#set:num))
  (export "handleTestEvent" (func $src/mappings/betokenProxy/handleTestEvent))
  (export "handleTestEvents" (func $src/mappings/betokenProxy/handleTestEvents))
  (export "NewFruitEvent#get:id" (func $TestEvent#get:id))
  (export "NewFruitEvent#set:id" (func $TestEvent#set:id))
  (export "NewFruitEvent#get:name" (func $TestEvent#get:num))
  (export "NewFruitEvent#set:name" (func $TestEvent#set:num))
  (export "NewFruitEvent#constructor" (func $src/mappings/betokenProxy/TestEvent#constructor))
  (export "NewBurgerEvent#get:id" (func $TestEvent#get:id))
  (export "NewBurgerEvent#set:id" (func $TestEvent#set:id))
  (export "NewBurgerEvent#get:name" (func $TestEvent#get:num))
  (export "NewBurgerEvent#set:name" (func $TestEvent#set:num))
  (export "NewBurgerEvent#constructor" (func $src/mappings/betokenProxy/TestEvent#constructor))
  (export "Burger#get:entries" (func $TestEvent#get:id))
  (export "Burger#set:entries" (func $TestEvent#set:id))
  (export "Burger#constructor" (func $src/mappings/betokenProxy/Burger#constructor))
  (export "Burger#set" (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#set))
  (export "Burger#getEntry" (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#getEntry))
  (export "Burger#get" (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#get))
  (export "Burger#isSet" (func $~lib/@graphprotocol/graph-ts/index/TypedMap<~lib/string/String_~lib/@graphprotocol/graph-ts/index/Value>#isSet))
  (export "Burger#unset" (func $~lib/@graphprotocol/graph-ts/index/Entity#unset))
  (export "Burger#merge" (func $~lib/@graphprotocol/graph-ts/index/Entity#merge))
  (export "Burger#get:id" (func $TestEvent#get:num))
  (export "Burger#set:id" (func $TestEvent#set:num))
  (export "handleNewBurger" (func $src/mappings/betokenProxy/handleNewBurger))
  (export "handleNewBurgers" (func $src/mappings/betokenProxy/handleNewBurgers))
  (export "handleUpdatedFundAddress" (func $src/mappings/betokenProxy/handleUpdatedFundAddress))
  (export "handleUpdatedFundAddresses" (func $src/mappings/betokenProxy/handleUpdatedFundAddresses))
  (export "runTests" (func $src/test/tests/runTests))
  (export "memory.compare" (func $~lib/memory/memory.compare))
  (export "memory.allocate" (func $~lib/memory/memory.allocate))
  (export "memory.free" (func $~lib/memory/memory.free))
  (export "memory.reset" (func $~lib/memory/memory.reset))
  (start $start)
  (elem (;0;) (i32.const 0) func $null $src/mappings/betokenProxy/handleTestEvents~anonymous|0 $src/mappings/betokenProxy/handleNewBurgers~anonymous|0 $src/mappings/betokenProxy/handleUpdatedFundAddresses~anonymous|0 $src/test/tests/runTests~anonymous|0 $src/test/tests/runTests~anonymous|1 $src/test/tests/runTests~anonymous|2 $src/test/tests/runTests~anonymous|3)
  (data (;0;) (i32.const 8) "\0d\00\00\00~\00l\00i\00b\00/\00a\00r\00r\00a\00y\00.\00t\00s")
  (data (;1;) (i32.const 40) "\1c\00\00\00~\00l\00i\00b\00/\00i\00n\00t\00e\00r\00n\00a\00l\00/\00a\00r\00r\00a\00y\00b\00u\00f\00f\00e\00r\00.\00t\00s")
  (data (;2;) (i32.const 104) "\0c\00\00\00I\00N\00T\00E\00R\00M\00I\00S\00S\00I\00O\00N")
  (data (;3;) (i32.const 136) "\06\00\00\00M\00A\00N\00A\00G\00E")
  (data (;4;) (i32.const 152) "\05\00\00\00E\00M\00P\00T\00Y")
  (data (;5;) (i32.const 168) "\03\00\00\00F\00O\00R")
  (data (;6;) (i32.const 184) "\07\00\00\00A\00G\00A\00I\00N\00S\00T")
  (data (;7;) (i32.const 208) "\03\00\00\00E\00T\00H")
  (data (;8;) (i32.const 224) "*\00\00\000\00x\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e\00e")
  (data (;9;) (i32.const 312) "*\00\00\000\00x\002\009\008\003\008\00a\008\00f\001\006\00e\00a\005\00d\002\003\00d\00f\004\007\006\00f\001\00b\001\00d\00a\00b\006\002\00f\00c\00e\007\008\008\003\00a\006\00b")
  (data (;10;) (i32.const 400) "*\00\00\000\00x\008\004\000\00d\008\007\002\00c\006\00a\00c\00e\00d\000\00d\00c\005\00c\00c\00d\007\002\00a\007\00c\007\00b\00f\007\001\004\009\006\00b\00b\00c\006\00c\004\000")
  (data (;11;) (i32.const 488) "*\00\00\000\00x\004\00e\00f\005\002\002\00f\000\00d\00e\004\004\009\004\006\00e\003\00e\00e\00a\007\001\006\00f\00a\000\007\001\00c\001\002\00e\008\009\00d\003\000\007\007\004")
  (data (;12;) (i32.const 576) "*\00\00\000\00x\002\00c\006\00b\009\00b\00b\00b\000\00b\001\007\00c\00f\008\006\00b\006\008\007\00f\004\001\008\00f\001\00d\003\004\00f\00a\009\002\00d\001\005\00f\006\00f\00c")
  (data (;13;) (i32.const 664) "*\00\00\000\00x\001\009\00a\005\00c\009\007\009\00e\009\006\008\002\003\00a\007\009\00f\000\005\00d\003\00e\007\006\005\008\00d\00d\00b\00c\002\00d\005\000\00b\00d\003\002\006")
  (data (;14;) (i32.const 752) "*\00\00\000\00x\00e\006\005\000\00c\002\00a\00a\006\007\007\009\003\005\00f\00b\001\000\00c\005\00e\000\009\00f\00f\00a\009\00a\00d\009\007\00d\001\00f\00b\00c\004\00e\009\00f")
  (data (;15;) (i32.const 840) "*\00\00\000\00x\008\00e\00f\00e\009\007\002\00d\00e\007\00e\00e\000\004\004\001\00d\001\00e\000\001\00f\00b\000\00c\008\004\00e\00a\009\000\000\00f\00d\001\007\007\000\00d\000")
  (data (;16;) (i32.const 928) "\04\00\00\00W\00B\00T\00C")
  (data (;17;) (i32.const 944) "*\00\00\000\00x\002\002\006\000\00f\00a\00c\005\00e\005\005\004\002\00a\007\007\003\00a\00a\004\004\00f\00b\00c\00f\00e\00d\00f\007\00c\001\009\003\00b\00c\002\00c\005\009\009")
  (data (;18;) (i32.const 1032) "*\00\00\000\00x\009\00f\00c\002\000\008\009\004\007\00d\009\002\00b\001\005\008\008\00f\007\00b\00d\00e\002\004\005\006\002\000\004\003\009\005\006\008\00a\008\005\008\007\00a")
  (data (;19;) (i32.const 1120) "*\00\00\000\00x\006\007\001\00c\007\008\008\006\00c\006\001\00a\001\008\00f\00c\006\00e\009\004\008\009\003\00a\007\009\001\00e\00a\00a\000\006\009\00d\007\000\00e\00b\00a\007")
  (data (;20;) (i32.const 1208) "*\00\00\000\00x\009\00f\00e\006\008\005\004\004\004\007\00b\00b\003\009\00d\00c\008\00b\007\008\009\006\000\008\008\002\008\003\001\002\006\009\00f\009\00e\007\008\004\000\008")
  (data (;21;) (i32.const 1296) "*\00\00\000\00x\008\004\009\005\004\008\00f\005\00d\009\006\006\000\001\007\00b\006\00b\004\009\00f\006\00a\003\00a\007\004\000\00b\00b\00d\00b\007\008\001\007\006\00e\00d\00b")
  (data (;22;) (i32.const 1384) "*\00\00\000\00x\006\00d\000\008\00b\008\006\000\000\002\002\002\001\00d\00c\002\00f\00e\004\00e\002\007\001\007\000\00f\00f\009\000\00e\001\00b\009\002\00d\00e\003\002\005\004")
  (data (;23;) (i32.const 1472) "*\00\00\000\00x\002\00f\00c\009\00f\005\002\002\004\000\00f\006\008\00e\00f\000\00f\001\007\008\00e\001\00b\008\009\006\004\003\005\00d\008\00f\006\004\00a\008\00d\00f\00a\00a")
  (data (;24;) (i32.const 1560) "*\00\00\000\00x\004\00f\004\00d\005\002\003\00c\006\009\00a\004\007\00c\005\00c\003\00e\00f\000\006\00c\005\003\00e\00c\006\004\008\000\001\00f\001\001\00a\008\008\004\00d\00d")
  (data (;25;) (i32.const 1648) "\03\00\00\00Z\00R\00X")
  (data (;26;) (i32.const 1664) "*\00\00\000\00x\00e\004\001\00d\002\004\008\009\005\007\001\00d\003\002\002\001\008\009\002\004\006\00d\00a\00f\00a\005\00e\00b\00d\00e\001\00f\004\006\009\009\00f\004\009\008")
  (data (;27;) (i32.const 1752) "*\00\00\000\00x\00d\00f\000\00d\007\002\007\007\004\002\00a\008\00a\009\00e\00a\00c\00f\00c\003\003\000\005\00c\006\008\007\00a\000\00d\002\001\008\002\006\00d\00a\00e\007\00e")
  (data (;28;) (i32.const 1840) "*\00\00\000\00x\00e\001\008\00e\001\007\008\009\00b\009\006\00f\00e\00f\007\003\006\009\000\009\005\00d\00e\001\003\000\003\00c\003\00a\00c\00d\00c\00f\000\003\007\007\005\00a")
  (data (;29;) (i32.const 1928) "*\00\00\000\00x\001\00b\007\003\009\005\00d\007\00d\008\00b\002\008\009\00a\007\008\009\002\000\00a\008\007\00c\00e\001\002\001\006\000\00b\00a\00c\00d\003\000\004\00c\005\001")
  (data (;30;) (i32.const 2016) "*\00\00\000\00x\004\008\007\008\006\00d\002\004\003\008\009\007\00c\005\008\001\00e\008\008\00b\005\009\008\00d\004\00f\007\008\006\00f\00b\007\001\006\009\00e\000\008\00a\00c")
  (data (;31;) (i32.const 2104) "*\00\00\000\00x\002\00a\009\003\00c\00b\00e\00c\000\00d\001\003\004\002\000\005\00c\003\005\002\00d\009\002\00d\008\001\00b\00b\007\00c\004\00e\00c\005\00e\00f\004\00d\004\00e")
  (data (;32;) (i32.const 2192) "*\00\00\000\00x\00b\007\000\00a\00e\007\007\00f\00f\009\00e\00c\00f\001\003\00b\00a\00e\00a\009\008\000\007\006\001\008\00e\00c\007\002\003\006\00a\00c\00f\004\004\00b\00d\001")
  (data (;33;) (i32.const 2280) "*\00\00\000\00x\00f\008\005\007\005\003\00f\00b\000\00d\00c\000\00a\006\00c\009\00b\004\00f\002\003\000\00e\00b\008\006\001\007\000\008\006\007\007\00a\00c\003\00c\000\000\00f")
  (data (;34;) (i32.const 2368) "\03\00\00\00B\00A\00T")
  (data (;35;) (i32.const 2384) "*\00\00\000\00x\000\00d\008\007\007\005\00f\006\004\008\004\003\000\006\007\009\00a\007\000\009\00e\009\008\00d\002\00b\000\00c\00b\006\002\005\000\00d\002\008\008\007\00e\00f")
  (data (;36;) (i32.const 2472) "*\00\00\000\00x\002\00a\004\000\002\005\001\00b\00a\007\003\003\00f\001\000\008\003\005\004\004\007\00a\008\00f\00c\00f\000\00e\000\00f\001\00c\00e\006\005\008\00f\001\008\00a")
  (data (;37;) (i32.const 2560) "*\00\00\000\00x\001\004\003\00b\005\009\001\00d\00e\009\00c\00f\00f\002\00b\00a\00f\00f\00b\007\001\007\00a\00c\000\00d\001\000\009\00b\00c\005\00c\000\001\00e\002\000\003\00e")
  (data (;38;) (i32.const 2648) "*\00\00\000\00x\006\00f\003\00a\005\00d\00c\00c\003\006\00e\00e\00e\00e\005\00b\00d\008\00b\009\00b\005\00d\00b\003\00b\006\004\003\001\001\008\007\00a\008\00f\001\00e\001\007")
  (data (;39;) (i32.const 2736) "*\00\00\000\00x\008\003\00a\000\00d\00c\003\001\007\000\000\00a\00f\001\007\007\002\00b\007\00e\00a\008\004\00f\00d\00e\007\006\007\005\00c\00a\006\000\002\001\00b\005\00d\00a")
  (data (;40;) (i32.const 2824) "*\00\00\000\00x\00e\007\00b\00e\00d\002\00e\005\00f\00c\00a\000\001\00f\001\003\00e\008\002\003\000\00b\00f\009\00b\006\007\009\006\003\00a\00d\002\003\001\00b\008\001\00a\006")
  (data (;41;) (i32.const 2912) "*\00\00\000\00x\00c\003\007\00a\000\00d\008\001\00d\009\006\001\000\005\001\004\00d\00b\001\000\004\007\00d\00e\005\002\00e\009\00a\009\000\009\003\005\003\000\00d\002\00e\004")
  (data (;42;) (i32.const 3000) "*\00\00\000\00x\008\008\008\000\00f\007\001\00f\00e\000\007\008\00a\00a\001\00c\005\00b\00b\00f\008\00a\005\00f\00f\006\00f\00b\009\003\00e\004\007\005\00a\009\00f\00c\00e\003")
  (data (;43;) (i32.const 3088) "\03\00\00\00K\00N\00C")
  (data (;44;) (i32.const 3104) "*\00\00\000\00x\00d\00d\009\007\004\00d\005\00c\002\00e\002\009\002\008\00d\00e\00a\005\00f\007\001\00b\009\008\002\005\00b\008\00b\006\004\006\006\008\006\00b\00d\002\000\000")
  (data (;45;) (i32.const 3192) "*\00\00\000\00x\006\009\002\00a\002\00b\008\00b\00e\007\00e\001\006\006\00d\006\00e\00e\009\003\00b\002\002\00a\004\00b\008\00b\003\005\001\00e\005\00d\004\004\004\003\003\009")
  (data (;46;) (i32.const 3280) "*\00\00\000\00x\003\000\00b\00b\002\00d\003\000\00b\003\00a\003\00a\003\00f\004\009\004\003\00f\008\001\00d\004\006\000\00b\004\005\00d\002\00d\00a\00c\005\007\003\005\00d\00f")
  (data (;47;) (i32.const 3368) "*\00\00\000\00x\005\00c\002\004\00f\001\009\00f\009\001\00f\004\00e\00a\008\00a\003\00f\009\005\00c\00b\002\001\00e\00b\00b\00e\00a\000\005\003\004\004\006\00d\008\006\003\002")
  (data (;48;) (i32.const 3456) "*\00\00\000\00x\005\00e\009\001\008\008\002\008\000\00e\001\00e\003\005\00a\00e\008\00f\008\009\009\00b\000\009\00c\009\007\005\005\008\00d\000\00f\001\009\005\00c\00c\001\004")
  (data (;49;) (i32.const 3544) "*\00\00\000\00x\009\00b\007\000\00e\006\00a\00a\00c\004\006\009\00c\007\005\00f\004\000\004\004\00c\007\008\00d\004\001\006\00e\00e\003\00b\00c\001\00a\009\002\00a\00c\002\002")
  (data (;50;) (i32.const 3632) "*\00\00\000\00x\004\006\006\005\00a\006\00f\004\00f\007\008\00b\00c\001\003\00a\00c\00e\00c\00b\003\002\008\00f\005\00f\002\002\00f\000\00e\004\00e\006\006\00d\002\002\008\005")
  (data (;51;) (i32.const 3720) "*\00\00\000\00x\007\00f\00d\007\005\00a\00c\009\006\00c\00a\001\00f\000\00a\00f\00f\00a\001\005\004\00f\00b\00c\001\00a\00e\000\008\007\005\002\00d\004\008\008\000\00e\008\003")
  (data (;52;) (i32.const 3808) "\03\00\00\00R\00E\00P")
  (data (;53;) (i32.const 3824) "*\00\00\000\00x\001\009\008\005\003\006\005\00e\009\00f\007\008\003\005\009\00a\009\00B\006\00A\00D\007\006\000\00e\003\002\004\001\002\00f\004\00a\004\004\005\00E\008\006\002")
  (data (;54;) (i32.const 3912) "*\00\00\000\00x\00e\003\003\002\009\007\00b\009\009\003\00c\008\009\00a\005\005\008\000\006\009\003\002\001\003\008\008\000\004\00b\000\00d\00b\00b\008\00d\007\00c\00a\001\00c")
  (data (;55;) (i32.const 4000) "*\00\00\000\00x\004\004\002\006\002\00a\006\00a\000\007\002\005\006\00f\000\007\001\001\00f\008\001\005\004\005\001\00f\002\00c\00d\001\00a\000\002\008\00a\000\00a\007\005\005")
  (data (;56;) (i32.const 4088) "*\00\00\000\00x\00f\00d\006\00c\007\006\005\004\006\00d\009\003\00e\006\001\002\000\00e\00b\006\00e\00a\00a\002\006\006\009\006\006\00f\005\001\003\003\000\002\008\000\00c\003")
  (data (;57;) (i32.const 4176) "*\00\00\000\00x\00e\00c\003\00d\00e\003\003\009\006\007\008\009\008\00c\004\007\00e\00c\008\00f\00b\00b\001\006\002\00b\009\003\009\00c\007\000\001\004\00b\00d\000\006\000\001")
  (data (;58;) (i32.const 4264) "*\00\00\000\00x\00a\00f\001\006\003\000\008\008\000\008\003\006\001\00b\002\000\003\00d\004\00e\00d\005\002\001\00c\00d\00d\00e\006\00d\00d\002\00e\009\00b\001\006\008\00f\000")
  (data (;59;) (i32.const 4352) "*\00\00\000\00x\006\006\005\006\004\00d\003\00b\00c\00e\00c\006\009\00c\007\00f\00b\00e\00f\00e\00a\001\008\005\00b\00d\006\00b\009\00f\00a\00a\005\007\00f\00a\00e\00b\00b\009")
  (data (;60;) (i32.const 4440) "*\00\00\000\00x\002\004\000\00f\00e\008\005\004\004\007\00a\008\007\008\00f\005\001\00a\007\004\00a\005\00d\00c\000\00b\006\004\004\00b\004\00a\007\002\005\008\007\008\003\009")
  (data (;61;) (i32.const 4528) "*\00\00\000\00x\00d\002\00a\001\00d\000\006\008\00b\00a\00a\00c\000\00b\000\006\00a\008\00e\002\00b\001\00d\00c\009\002\004\00a\004\003\00d\008\001\00a\006\00d\00a\003\002\005")
  (data (;62;) (i32.const 4616) "*\00\00\000\00x\008\00f\00a\001\00a\004\009\001\00f\005\005\00d\009\003\00b\00d\004\000\00f\00f\000\002\003\009\005\006\002\006\001\00f\002\00f\00b\005\000\004\007\002\009\007")
  (data (;63;) (i32.const 4704) "*\00\00\000\00x\00d\008\000\00e\005\005\008\000\002\007\00e\00e\007\005\003\00a\000\00b\009\005\007\005\007\00d\00c\003\005\002\001\00d\000\003\002\006\00f\001\003\00d\00a\002")
  (data (;64;) (i32.const 4792) "*\00\00\000\00x\000\004\002\008\004\008\008\005\008\002\004\007\002\00a\004\007\00d\007\00a\002\000\00b\00e\009\006\009\00f\00d\00f\00d\00f\00b\003\00b\00a\001\00f\007\00c\00b")
  (data (;65;) (i32.const 4880) "*\00\00\000\00x\001\003\007\000\00b\007\001\006\005\007\005\00b\00d\007\00d\005\00a\00e\00e\001\004\001\002\008\00e\002\003\001\00a\007\007\009\001\009\008\00e\005\003\009\007")
  (data (;66;) (i32.const 4968) "*\00\00\000\00x\004\006\00b\00b\004\005\007\006\009\009\003\00f\005\000\003\000\002\00b\00b\000\00d\005\00f\007\004\004\000\00a\00e\00f\00f\00b\00a\00b\00f\00d\00b\00b\007\008")
  (data (;67;) (i32.const 5056) "*\00\00\000\00x\00f\002\00a\00d\001\00e\00e\009\006\007\001\00f\006\003\00d\00f\007\00c\008\00f\008\00d\00a\00a\008\002\002\00d\00a\001\00e\006\00f\00c\000\008\00b\008\000\00d")
  (data (;68;) (i32.const 5144) "*\00\00\000\00x\005\005\009\000\00b\000\005\004\009\005\00b\00a\00d\007\002\003\006\005\00d\004\00a\00f\00a\00a\003\00e\00d\005\00f\00b\00a\005\00d\008\00d\006\007\00a\00f\002")
  (data (;69;) (i32.const 5232) "*\00\00\000\00x\00e\006\003\00d\006\001\001\00b\007\006\00e\00e\001\00a\00d\009\002\00d\00f\005\001\005\003\00f\003\00e\005\007\003\00f\007\004\005\003\00c\00a\000\009\000\001")
  (data (;70;) (i32.const 5320) "*\00\00\000\00x\00e\005\00b\00d\001\002\001\007\008\009\001\000\00c\009\002\008\00b\006\009\00c\00d\000\009\000\00b\001\008\00d\004\00b\009\008\001\00f\001\001\005\000\00d\00c")
  (data (;71;) (i32.const 5408) "*\00\00\000\00x\007\00d\00d\004\007\004\00d\00c\00e\000\003\005\00d\00e\00b\00f\000\007\003\00d\00c\00b\009\00c\001\008\008\005\008\004\00d\007\006\001\00b\001\00d\000\002\004")
  (data (;72;) (i32.const 5496) "*\00\00\000\00x\000\003\008\00e\001\00b\005\006\00b\006\001\005\00f\00f\003\00d\00d\002\000\00e\000\00b\00d\004\00c\007\00e\009\001\00c\007\00e\00e\000\007\00d\003\005\000\008")
  (data (;73;) (i32.const 5584) "*\00\00\000\00x\001\001\00b\00a\00b\00e\004\00a\001\00d\00e\00e\003\005\000\00b\00a\005\00b\005\00a\00d\009\000\002\00f\001\00d\002\00c\009\008\002\002\00a\000\00a\009\008\00b")
  (data (;74;) (i32.const 5672) "*\00\00\000\00x\00d\00b\00c\005\004\00c\006\000\00a\004\00d\00d\00e\006\00f\009\005\00d\00e\003\00c\007\008\00a\00f\005\009\00f\009\00f\00f\007\007\00e\002\006\00a\00f\00d\002")
  (data (;75;) (i32.const 5760) "\04\00\00\00L\00I\00N\00K")
  (data (;76;) (i32.const 5776) "*\00\00\000\00x\005\001\004\009\001\000\007\007\001\00a\00f\009\00c\00a\006\005\006\00a\00f\008\004\000\00d\00f\00f\008\003\00e\008\002\006\004\00e\00c\00f\009\008\006\00c\00a")
  (data (;77;) (i32.const 5864) "*\00\00\000\00x\003\00b\00f\001\003\00d\007\006\00a\005\00d\006\002\005\00f\00c\008\005\004\008\006\00f\007\003\003\002\008\009\002\006\00a\006\004\00f\002\002\006\00a\00c\00c")
  (data (;78;) (i32.const 5952) "*\00\00\000\00x\007\00d\007\00a\00b\001\00d\00b\002\00c\008\007\006\006\00d\009\008\004\006\005\00a\003\009\002\00f\003\007\004\00e\00b\009\007\003\006\001\002\008\009\00e\00f")
  (data (;79;) (i32.const 6040) "*\00\00\000\00x\009\001\00f\004\006\00d\00d\006\00e\00e\005\00f\003\00f\008\00c\00e\008\003\002\008\007\008\009\007\009\003\008\00f\007\008\005\008\00f\005\007\006\001\00e\004")
  (data (;80;) (i32.const 6128) "*\00\00\000\00x\004\00a\001\00d\00b\001\000\000\005\00c\00b\00c\005\006\008\004\00a\00a\005\001\00e\007\00a\004\00e\00e\00e\000\006\00d\00b\000\002\009\008\00e\007\000\00f\006")
  (data (;81;) (i32.const 6216) "*\00\00\000\00x\00c\000\00f\002\00a\00d\009\006\00e\002\00e\009\004\006\00b\005\000\007\00f\009\000\003\00b\00b\005\00e\00f\006\009\00a\000\008\00b\001\00b\00d\00c\007\006\006")
  (data (;82;) (i32.const 6304) "*\00\00\000\00x\001\00f\008\00b\00d\00a\00d\005\00f\003\000\00e\00f\00f\00d\00f\001\004\00c\008\00d\00a\001\007\005\003\004\009\00c\007\002\000\007\00b\00b\003\007\000\00f\008")
  (data (;83;) (i32.const 6392) "*\00\00\000\00x\00c\00c\001\006\007\004\005\00a\001\007\007\003\00d\00d\009\005\00a\00b\009\00e\00d\009\008\005\009\009\00b\008\00d\009\00b\008\003\005\00e\004\002\00e\002\005")
  (data (;84;) (i32.const 6480) "\1b\00\00\00~\00l\00i\00b\00/\00i\00n\00t\00e\00r\00n\00a\00l\00/\00t\00y\00p\00e\00d\00a\00r\00r\00a\00y\00.\00t\00s")
  (data (;85;) (i32.const 6544) "\01\00\00\000")
  (data (;86;) (i32.const 6552) "\01\00\00\001")
  (data (;87;) (i32.const 6560) "*\00\00\000\00x\008\001\008\00E\006\00F\00E\00C\00D\005\001\006\00E\00c\00c\003\008\004\009\00D\00A\00f\006\008\004\005\00e\003\00E\00C\008\006\008\000\008\007\00B\007\005\005")
  (data (;88;) (i32.const 6648) "\0b\00\00\00B\00e\00t\00o\00k\00e\00n\00F\00u\00n\00d")
  (data (;89;) (i32.const 6680) "*\00\00\000\00x\002\004\00d\00d\002\004\002\00c\003\00c\004\000\006\001\00b\001\00f\00c\00a\00a\005\001\001\009\00a\00f\006\000\008\00b\005\006\00a\00f\00b\00a\00e\00a\009\005")
  (data (;90;) (i32.const 6768) "*\00\00\000\00x\00a\001\009\009\008\00b\008\002\001\00c\003\007\005\001\009\008\008\009\00a\00f\005\002\00f\009\005\00d\001\00b\009\00d\00d\000\00d\005\001\006\007\00d\006\00a")
  (data (;91;) (i32.const 6856) "*\00\00\000\00x\005\002\00b\007\008\004\000\00b\007\003\005\00d\005\001\008\00d\003\008\009\008\00d\00e\003\000\00a\005\00f\00f\00d\008\005\005\000\00e\006\002\00b\006\006\000")
  (data (;92;) (i32.const 6944) "*\00\00\000\00x\002\00b\004\006\004\001\001\006\000\008\00c\009\008\009\001\00c\001\009\002\00c\007\000\000\00f\00f\008\002\003\00e\00f\00a\004\00e\00f\00e\003\00c\008\00c\00b")
  (data (;93;) (i32.const 7032) "*\00\00\000\00x\00e\003\007\00b\001\006\000\000\003\001\00c\002\00c\00b\00c\007\00f\009\00e\00e\002\004\005\008\005\00f\00e\007\00f\005\00f\005\00c\001\000\00d\00e\000\005\00d")
  (data (;94;) (i32.const 7120) "*\00\00\000\00x\006\008\004\00c\007\001\002\001\001\002\002\006\00c\00a\00a\007\00f\008\003\00d\00c\007\005\004\007\00d\001\000\006\004\000\005\004\009\006\00f\001\000\00e\000")
  (data (;95;) (i32.const 7208) "*\00\00\000\00x\001\00b\00a\00e\002\00e\007\00c\00b\005\007\00d\006\009\009\00d\003\003\006\002\00d\008\006\009\006\004\00c\006\00e\002\006\008\00b\001\009\00d\000\005\00c\00a")
  (data (;96;) (i32.const 7296) "*\00\00\000\00x\00a\005\00c\00d\003\00b\00c\003\00f\003\00d\003\004\00b\003\00a\007\001\006\001\001\001\006\004\003\00e\001\009\00d\00b\008\008\00b\00f\00a\006\004\009\00c\007")
  (data (;97;) (i32.const 7384) "*\00\00\000\00x\006\00d\000\003\00b\005\002\00c\002\00c\005\00c\008\00b\00f\009\00d\005\007\00a\00d\00c\00b\00d\000\00b\00c\00b\001\007\000\003\000\005\008\003\004\002\00c\008")
  (data (;98;) (i32.const 7472) "*\00\00\000\00x\00d\005\003\004\004\000\001\00f\00b\00b\007\009\002\006\00a\000\003\002\002\005\00c\00b\009\008\00b\00b\005\001\001\004\001\008\00b\002\002\003\001\001\006\00a")
  (data (;99;) (i32.const 7560) "*\00\00\000\00x\006\00d\008\003\001\001\00b\00e\009\00b\002\00f\00d\000\006\000\005\005\002\00f\000\008\001\004\005\00a\003\000\003\00c\00d\00f\006\00c\002\008\00d\008\00e\009")
  (data (;100;) (i32.const 7648) "*\00\00\000\00x\007\003\000\006\00f\005\00f\005\001\00a\00e\001\00d\007\00c\009\000\006\006\009\006\008\00e\00a\007\009\003\004\000\001\003\002\007\005\006\00a\008\000\007\000")
  (data (;101;) (i32.const 7736) "*\00\00\000\00x\000\007\000\000\005\00c\009\00b\005\00f\009\004\008\009\001\008\001\001\001\003\002\002\001\002\006\00b\001\00d\00b\007\003\009\00d\004\003\00b\001\00d\007\00c")
  (data (;102;) (i32.const 7824) "*\00\00\000\00x\006\00d\00e\007\005\004\00c\000\008\001\006\00a\00a\001\00e\00c\009\008\00d\002\00f\00f\005\005\00a\00d\006\00e\00a\007\00d\000\000\00a\00b\006\00e\001\003\001")
  (data (;103;) (i32.const 7912) "*\00\00\000\00x\00a\00f\00d\005\00f\006\000\00a\00a\008\00e\00b\004\00f\004\008\008\00e\00a\00a\000\00e\00f\009\008\00c\001\00c\005\00b\000\006\004\005\00d\009\00a\000\00a\000")
  (data (;104;) (i32.const 8000) "*\00\00\000\00x\004\00a\00d\00a\001\00b\009\00d\009\00f\00e\002\008\00a\00b\00d\009\005\008\005\00f\005\008\00c\00f\00e\00e\00d\002\001\006\009\00a\003\009\00e\001\00c\006\00b")
  (data (;105;) (i32.const 8088) "*\00\00\000\00x\006\004\004\007\00f\00f\007\009\000\006\003\004\00d\005\003\000\00a\007\00d\00b\009\004\00d\001\002\004\00d\002\005\00a\00a\006\00a\001\001\007\002\001\000\005")
  (data (;106;) (i32.const 8176) "*\00\00\000\00x\00c\00a\00a\00d\00f\00a\00a\00d\00d\007\003\00f\00d\00d\00e\00d\00e\006\003\003\008\00a\003\000\00d\00c\00a\00a\00a\006\00b\000\009\007\001\004\00c\009\006\00e")
  (data (;107;) (i32.const 8264) "*\00\00\000\00x\005\00d\002\007\00f\007\000\00b\00d\00f\009\000\00c\00e\009\00b\007\003\00d\003\000\003\001\008\007\00b\00d\000\00b\00f\001\00a\006\005\005\002\008\00e\00b\00d")
  (data (;108;) (i32.const 8352) "*\00\00\000\00x\00c\00f\001\001\001\000\001\00c\003\001\001\008\00e\00a\00c\001\00f\004\003\00f\000\00d\008\003\00d\007\00c\00b\003\00c\00a\007\00a\00e\00f\00e\000\005\002\004")
  (data (;109;) (i32.const 8440) "*\00\00\000\00x\001\001\007\006\003\00f\000\00c\00b\006\000\008\005\001\006\00e\007\006\008\003\005\008\00c\002\00a\003\008\009\000\00b\00d\00f\008\00a\001\005\008\00b\003\005")
  (data (;110;) (i32.const 8528) "*\00\00\000\00x\004\002\006\001\003\004\006\00b\00e\008\00a\007\00c\007\00f\00c\007\00f\007\005\00f\00a\003\00f\009\006\000\006\001\00e\007\007\009\009\002\003\002\00e\00a\002")
  (data (;111;) (i32.const 8616) "*\00\00\000\00x\00e\004\00b\00f\004\001\00c\00f\00c\004\003\00d\00c\005\003\006\001\00d\003\00e\00c\006\002\001\009\00f\00c\00b\001\000\00b\006\00a\002\008\003\00b\004\000\00d")
  (data (;112;) (i32.const 8704) "*\00\00\000\00x\009\008\00d\00e\002\004\00d\002\005\00c\008\007\00d\001\008\003\00a\003\009\003\004\002\007\007\001\004\00d\006\006\000\00b\006\002\008\006\003\001\00c\003\00a")
  (data (;113;) (i32.const 8792) "*\00\00\000\00x\007\003\004\004\00d\002\001\00a\004\006\007\004\009\00d\006\005\001\003\00f\00a\009\00a\005\003\00f\00a\005\003\00f\00d\004\000\007\00c\008\006\00f\006\001\004")
  (data (;114;) (i32.const 8880) "*\00\00\000\00x\00e\006\008\00f\00c\008\009\00a\003\006\00e\00c\00f\00c\005\009\002\00e\00e\007\00f\004\00a\00e\00f\002\009\009\008\007\007\00f\00f\00a\00c\00a\00e\00a\00e\00c")
  (data (;115;) (i32.const 8968) "*\00\00\000\00x\005\000\00f\001\002\004\00e\00b\008\00e\008\00d\004\002\00c\007\00a\000\005\006\006\006\00e\007\009\000\008\00b\002\008\008\007\008\007\007\009\00c\008\00e\004")
  (data (;116;) (i32.const 9056) "*\00\00\000\00x\00d\005\003\000\004\006\006\000\001\00e\008\008\00e\00a\003\00d\007\00e\00c\002\009\00f\007\002\003\00e\00e\008\005\005\00a\00c\001\00a\00e\007\00a\00b\006\000")
  (data (;117;) (i32.const 9144) "*\00\00\000\00x\006\001\007\000\009\006\00e\00c\009\002\003\001\005\00d\006\00a\002\003\00a\005\00e\00b\00d\00c\00f\004\00f\001\00f\00c\003\00a\008\00c\005\009\00e\005\00d\005")
  (data (;118;) (i32.const 9232) "*\00\00\000\00x\005\001\002\00e\00a\00e\003\001\000\003\001\00c\00a\009\00d\00f\00a\008\00d\009\00c\006\00f\000\00b\003\006\009\004\00c\000\00b\008\005\003\00b\003\00b\00a\00b")
  (data (;119;) (i32.const 9320) "*\00\00\000\00x\004\009\003\003\005\00b\00a\002\001\00f\00b\007\008\009\002\000\001\001\009\00c\009\00e\004\00e\00b\00a\006\005\00e\002\000\009\007\00e\002\006\009\008\00e\002")
  (data (;120;) (i32.const 9408) "*\00\00\000\00x\00a\006\001\001\003\009\007\00e\00d\007\005\005\003\003\003\006\00b\001\007\001\005\005\006\000\00a\007\009\003\007\00b\00f\00b\003\001\008\00d\001\00f\009\00a")
  (data (;121;) (i32.const 9496) "*\00\00\000\00x\005\00e\00e\00e\004\000\004\001\00a\006\008\001\00b\00a\008\003\00e\00a\009\005\00a\002\005\005\00a\007\001\001\008\006\00a\003\00a\001\00f\006\00f\00b\008\00e")
  (data (;122;) (i32.const 9584) "*\00\00\000\00x\006\00c\00f\001\006\00c\00b\006\002\002\00a\001\00d\00c\00f\004\00b\002\00a\00c\00d\00d\001\009\005\00e\004\000\004\00a\009\000\009\005\00b\008\003\00d\00a\007")
  (data (;123;) (i32.const 9672) "*\00\00\000\00x\00a\00c\000\00d\007\008\008\005\00d\00c\00e\001\00d\00f\000\00e\00b\00d\00c\003\00c\00c\008\005\004\000\00c\00b\00b\009\00f\00e\006\001\004\001\001\008\006\00e")
  (data (;124;) (i32.const 9760) "*\00\00\000\00x\004\00d\00d\006\006\009\004\00d\000\005\005\00a\008\002\008\004\006\00b\00d\00a\009\007\001\007\007\002\000\00d\00c\00e\003\00f\002\009\000\006\00f\009\00b\007")
  (data (;125;) (i32.const 9848) "*\00\00\000\00x\007\001\00a\004\00f\00f\00c\000\009\00d\00d\005\00a\007\006\009\007\00c\003\00e\001\000\002\006\00e\007\000\004\00e\002\00d\00b\001\00a\001\004\009\00d\00f\00e")
  (data (;126;) (i32.const 9936) "*\00\00\000\00x\005\00f\003\005\000\00b\00f\005\00f\00e\00e\008\00e\002\005\004\00d\006\000\007\007\00f\008\006\006\001\00e\009\00c\007\00b\008\003\00a\003\000\003\006\004\00e")
  (data (;127;) (i32.const 10024) "*\00\00\000\00x\007\005\001\00d\009\002\00c\00d\006\00e\00c\000\003\00a\007\00d\008\001\004\008\00f\00c\00a\00f\006\003\005\003\002\00d\008\00f\008\00f\009\00e\00c\000\009\00b")
  (data (;128;) (i32.const 10112) "*\00\00\000\00x\00b\006\00b\001\006\00b\00b\007\004\000\00b\002\009\009\00f\00d\00b\00f\007\001\00d\00b\004\007\00c\005\001\00b\001\001\000\003\000\008\009\005\00b\000\006\007")
  (data (;129;) (i32.const 10200) "*\00\00\000\00x\006\00d\00b\00e\009\000\001\00d\006\008\009\00f\005\004\008\001\005\002\002\006\006\003\009\008\009\00f\008\004\00b\001\004\001\006\000\001\009\008\001\005\00f")
  (data (;130;) (i32.const 10288) "*\00\00\000\00x\00d\007\00c\00e\001\008\008\003\005\00f\003\007\001\00c\00f\000\004\00a\009\00a\00d\008\00b\006\001\00e\006\001\002\002\006\008\007\005\00b\00c\00c\002\00d\008")
  (data (;131;) (i32.const 10376) "*\00\00\000\00x\009\001\003\00b\007\009\003\00a\004\00a\00c\001\00f\00b\008\00b\006\004\005\00a\000\001\006\005\00d\00d\005\00b\009\008\00b\005\005\00c\005\004\00b\005\00f\00a")
  (data (;132;) (i32.const 10464) "*\00\00\000\00x\00a\000\004\000\00a\002\008\00c\00e\00d\00f\004\008\004\006\00d\002\00e\008\00c\00e\006\00f\00c\00f\000\003\00c\00b\00b\008\006\002\007\00c\004\004\004\00c\003")
  (data (;133;) (i32.const 10552) "*\00\00\000\00x\00e\001\003\00c\00c\00b\008\00c\002\009\00e\001\00a\009\002\001\00c\00b\00d\007\000\00e\001\00d\00d\005\00c\00f\00e\008\000\002\00f\009\00f\009\00d\004\001\005")
  (data (;134;) (i32.const 10640) "*\00\00\000\00x\00a\002\008\009\003\006\004\003\004\007\00b\00f\00c\001\009\001\002\00a\00b\006\007\002\004\002\005\00a\00b\00e\005\009\003\00e\00c\000\001\00c\00a\005\006\00e")
  (data (;135;) (i32.const 10728) "*\00\00\000\00x\001\000\007\00a\00f\005\003\002\00e\006\00f\008\002\008\00d\00a\006\00f\00e\007\009\006\009\009\001\002\003\00c\009\00a\005\00e\00a\000\001\002\003\00d\001\006")
  (data (;136;) (i32.const 10816) "*\00\00\000\00x\008\007\00b\00f\001\00f\00c\00c\00f\003\00a\000\007\007\001\005\008\004\00c\006\008\004\006\00e\00c\007\004\004\002\00e\00a\000\007\008\009\00f\00f\00a\006\00b")
  (data (;137;) (i32.const 10904) "*\00\00\000\00x\009\004\002\003\004\00c\00f\00d\006\003\00e\002\000\00f\002\008\000\001\001\001\00d\00a\00f\008\006\002\007\00c\009\005\00c\000\00a\00b\002\00c\003\00a\00c\007")
  (data (;138;) (i32.const 10992) "*\00\00\000\00x\003\004\009\00b\00d\000\009\004\002\000\009\00d\005\000\002\008\000\00d\00f\00a\00c\00a\001\002\007\007\009\005\007\006\00c\007\004\008\003\009\005\00c\001\005")
  (data (;139;) (i32.const 11080) "*\00\00\000\00x\00b\003\00a\00d\00d\00a\00c\006\003\00a\007\002\009\008\001\006\001\00c\006\006\00e\00d\00d\004\009\009\003\00c\005\008\008\00d\008\002\000\00f\006\009\003\00a")
  (data (;140;) (i32.const 11168) "*\00\00\000\00x\00a\008\00e\00e\004\008\00e\00a\00a\00b\006\00b\00d\000\003\007\00c\00b\009\009\002\00e\002\009\00f\001\002\00a\007\00b\009\00d\00a\003\001\00e\00a\002\002\002")
  (data (;141;) (i32.const 11256) "*\00\00\000\00x\008\001\006\005\009\00e\00c\00f\001\00e\00f\009\007\005\005\00e\009\004\007\007\00b\00b\008\009\002\00e\000\00b\001\00a\00c\006\00d\001\00d\00f\00b\00f\003\002")
  (data (;142;) (i32.const 11344) "*\00\00\000\00x\00f\00c\006\009\006\003\00d\009\004\004\001\00b\00b\007\00a\009\007\001\00d\003\00b\000\002\006\001\00d\004\002\00b\003\002\00d\00b\00a\00f\007\005\00b\002\009")
  (data (;143;) (i32.const 11432) "*\00\00\000\00x\009\005\004\009\005\007\00c\008\001\001\00f\00a\00c\00f\00e\000\006\002\00c\00e\000\005\00b\005\00b\003\00a\003\009\002\006\004\00e\001\005\003\009\006\002\00a")
  (data (;144;) (i32.const 11520) "*\00\00\000\00x\009\00c\00a\004\00e\003\004\00a\00d\002\003\00a\003\00b\001\007\007\00b\00d\000\00d\006\00e\004\008\001\004\009\00e\00f\00d\000\008\005\002\00a\007\007\005\002")
  (data (;145;) (i32.const 11608) "*\00\00\000\00x\002\00e\00d\009\008\006\006\002\000\00c\00f\000\00c\00b\007\00d\00a\001\006\00f\00e\006\00b\007\003\002\006\00a\00e\008\00c\006\00a\005\00d\008\003\005\00e\009")
  (data (;146;) (i32.const 11696) "*\00\00\000\00x\003\008\006\000\009\00b\006\00b\006\008\008\003\00e\005\008\00c\007\006\00e\00c\006\008\001\00e\00a\00e\00d\00d\008\00d\001\00c\005\00c\006\00f\00d\006\00a\004")
  (data (;147;) (i32.const 11784) "*\00\00\000\00x\00e\003\007\003\00a\00b\002\00f\001\000\00e\005\00a\002\00d\006\000\00e\004\000\00e\00b\00c\009\002\009\00e\00c\003\008\00c\00f\00c\004\009\000\004\003\00d\002")
  (data (;148;) (i32.const 11872) "*\00\00\000\00x\00c\001\006\007\000\00f\00f\000\009\00c\00c\00f\00b\00c\009\005\000\003\008\009\009\001\004\00e\00d\00e\005\001\005\007\002\005\000\00d\009\008\00d\00e\00e\008")
  (data (;149;) (i32.const 11960) "*\00\00\000\00x\00d\005\00d\003\000\00c\00f\000\00b\006\007\005\005\00d\00b\000\00c\001\00b\004\001\004\00b\00b\002\008\008\00e\000\00a\00c\005\005\00b\00b\00c\009\008\003\00b")
  (data (;150;) (i32.const 12048) "*\00\00\000\00x\00a\00d\008\00d\005\004\000\00e\008\001\00a\008\002\000\00b\005\008\002\00b\007\00f\007\00b\00c\00f\00e\003\004\004\008\007\008\00a\007\008\00f\000\006\009\002")
  (data (;151;) (i32.const 12136) "*\00\00\000\00x\00d\000\004\007\00b\006\005\00f\005\004\00f\004\00a\00a\008\00e\00a\00e\006\00b\00b\009\00f\003\00d\009\00d\005\00d\001\002\006\00f\00e\007\002\002\00b\009\00f")
  (data (;152;) (i32.const 12224) "*\00\00\000\00x\002\005\008\00c\001\009\00d\005\00e\001\000\004\00d\001\009\00e\001\00f\006\008\00c\009\00e\00e\002\002\00a\00d\002\008\00b\004\00c\001\00a\003\006\00f\00e\00e")
  (data (;153;) (i32.const 12312) "*\00\00\000\00x\00c\00e\00f\006\00c\009\004\004\009\00c\003\007\008\005\004\004\00f\007\001\003\00a\005\007\00f\000\000\004\005\005\00c\00e\009\00b\004\009\003\006\00a\008\004")
  (data (;154;) (i32.const 12400) "*\00\00\000\00x\000\00b\00d\007\008\005\00d\008\00a\00b\007\006\00d\00e\001\005\009\005\00e\005\009\005\00d\00b\00c\001\002\00e\00f\003\003\007\00c\00c\004\009\00e\00d\007\002")
  (data (;155;) (i32.const 12488) "*\00\00\000\00x\00a\00e\003\00d\004\00c\00d\00d\000\002\007\00c\008\001\004\008\009\001\003\00d\00d\002\00b\002\00a\000\009\006\00f\000\00d\00c\00f\009\007\00e\00d\003\00c\00f")
  (data (;156;) (i32.const 12576) "*\00\00\000\00x\003\00f\00b\002\002\009\007\004\00f\006\008\007\008\006\005\005\00d\00b\00c\009\00c\002\000\00c\00c\00f\00b\000\00a\009\004\002\00c\00d\00e\00d\009\00c\00e\00c")
  (data (;157;) (i32.const 12664) "*\00\00\000\00x\001\001\00e\000\005\009\00d\009\00a\00c\006\00b\00d\00e\006\007\001\008\00c\00c\009\00c\008\006\005\005\005\00f\004\000\00b\00d\00b\000\005\00e\004\004\00f\009")
  (data (;158;) (i32.const 12752) "*\00\00\000\00x\00e\00b\00d\002\000\004\004\008\00d\00b\006\000\000\001\004\00a\002\008\003\009\00e\00c\004\00c\005\005\00a\00f\00f\004\002\00e\004\00f\002\00f\00a\002\00c\00b")
  (data (;159;) (i32.const 12840) "*\00\00\000\00x\00e\00e\008\000\00d\00b\004\009\009\007\000\009\008\00b\002\00b\005\001\007\002\002\003\006\003\006\00f\001\005\00d\005\001\00a\006\001\00f\003\005\004\009\00b")
  (data (;160;) (i32.const 12928) "*\00\00\000\00x\00f\00d\004\00c\003\006\001\00d\002\008\005\00e\003\002\007\008\006\005\006\009\00f\009\002\003\002\002\00a\005\00a\00b\007\004\008\00b\00b\00c\00a\00b\00a\000")
  (data (;161;) (i32.const 13016) "*\00\00\000\00x\008\002\00c\006\009\00f\008\008\007\00d\008\00c\004\007\005\002\001\008\001\00b\00f\009\00a\009\005\006\00d\001\00a\00e\00b\002\005\005\001\00f\00e\001\004\00c")
  (data (;162;) (i32.const 13104) "*\00\00\000\00x\004\006\003\007\008\003\00c\00a\00b\002\006\00b\002\00e\002\000\00b\00d\001\001\008\00e\004\00b\002\007\00a\000\00c\004\005\005\005\009\007\008\007\008\00a\005")
  (data (;163;) (i32.const 13192) "*\00\00\000\00x\00f\008\009\00a\006\00d\004\001\004\000\008\001\006\00f\003\00f\004\003\009\004\007\00b\000\001\00d\00e\00c\007\000\001\00d\007\00e\00a\007\003\00b\00a\004\00f")
  (data (;164;) (i32.const 13280) "*\00\00\000\00x\001\009\008\00a\001\002\003\005\009\009\00e\006\005\001\004\000\00b\00f\00e\00f\00a\000\009\006\006\004\008\00d\009\006\008\00a\006\007\00c\003\00b\008\000\007")
  (data (;165;) (i32.const 13368) "*\00\00\000\00x\00c\00a\004\00e\00f\009\00e\003\00c\004\00e\003\008\007\008\00e\000\000\000\00a\00f\001\008\003\000\00a\00a\00b\004\008\008\004\006\00f\004\002\002\003\006\00f")
  (data (;166;) (i32.const 13456) "*\00\00\000\00x\00d\001\006\00a\00a\003\009\00e\002\008\001\002\00f\00a\001\00c\009\00d\00a\00e\006\00c\00a\004\00e\00e\00e\000\00a\001\001\00d\00e\00e\002\006\002\00a\009\00a")
  (data (;167;) (i32.const 13544) "*\00\00\000\00x\00c\006\002\004\00a\008\00e\008\009\002\00c\00d\000\00b\006\007\005\00c\000\003\00b\006\009\005\00e\004\003\005\001\008\00b\00c\009\005\00f\00a\00b\00a\000\000")
  (data (;168;) (i32.const 13632) "*\00\00\000\00x\001\004\00a\004\00c\00a\003\004\00e\00e\003\004\006\004\003\007\009\001\00d\00d\00d\008\004\001\00f\00a\00f\00e\003\00c\007\007\004\003\003\006\00b\003\000\006")
  (data (;169;) (i32.const 13720) "*\00\00\000\00x\00e\002\003\008\00a\009\006\003\00b\00e\007\00c\00a\001\00f\00e\00c\00d\005\009\005\00c\004\008\009\00f\00b\002\00e\004\00f\00a\009\006\00a\009\004\00d\00f\004")
  (data (;170;) (i32.const 13808) "*\00\00\000\00x\008\00e\009\008\001\008\00e\007\005\00e\00a\002\005\00d\000\001\006\002\00f\004\009\009\008\00e\000\003\003\00e\00a\00e\002\008\00c\00d\00d\00c\002\003\001\00e")
  (data (;171;) (i32.const 13896) "*\00\00\000\00x\000\009\007\002\003\007\005\00c\000\008\006\00a\006\006\009\00f\00c\00d\007\00b\00a\003\002\007\004\006\008\009\000\002\007\00a\00c\008\004\004\00e\001\00c\005")
  (data (;172;) (i32.const 13984) "L\01\00\00\00\00\00\00\18\1a\00\00p\1a\00\00\c8\1a\00\00 \1b\00\00x\1b\00\00\d0\1b\00\00(\1c\00\00\80\1c\00\00\d8\1c\00\000\1d\00\00\88\1d\00\00\e0\1d\00\008\1e\00\00\90\1e\00\00\e8\1e\00\00@\1f\00\00\98\1f\00\00\f0\1f\00\00H \00\00\a0 \00\00\f8 \00\00P!\00\00\a8!\00\00\00\22\00\00X\22\00\00\b0\22\00\00\08#\00\00`#\00\00\b8#\00\00\10$\00\00h$\00\00\c0$\00\00\18%\00\00p%\00\00\c8%\00\00 &\00\00x&\00\00\d0&\00\00('\00\00\80'\00\00\d8'\00\000(\00\00\88(\00\00\e0(\00\008)\00\00\90)\00\00\e8)\00\00@*\00\00\98*\00\00\f0*\00\00H+\00\00\a0+\00\00\f8+\00\00P,\00\00\a8,\00\00\00-\00\00X-\00\00\b0-\00\00\08.\00\00`.\00\00\b8.\00\00\10/\00\00h/\00\00\c0/\00\00\180\00\00p0\00\00\c80\00\00 1\00\00x1\00\00\d01\00\00(2\00\00\802\00\00\d82\00\0003\00\00\883\00\00\e03\00\0084\00\00\904\00\00\e84\00\00@5\00\00\985\00\00\f05\00\00H6")
  (data (;173;) (i32.const 14496) "\a06\00\00S")
  (data (;174;) (i32.const 14504) "\13\00\00\00~\00l\00i\00b\00/\00a\00r\00r\00a\00y\00b\00u\00f\00f\00e\00r\00.\00t\00s")
  (data (;175;) (i32.const 14552) "\06\00\00\00B\00u\00r\00g\00e\00r")
  (data (;176;) (i32.const 14568) "\0a\00\00\00T\00e\00s\00t\00E\00n\00t\00i\00t\00y")
  (data (;177;) (i32.const 14592) "\04\00\00\00n\00a\00m\00e")
  (data (;178;) (i32.const 14608) "\04\00\00\00F\00u\00n\00d")
  (data (;179;) (i32.const 14624) "\02\00\00\00i\00d")
  (data (;180;) (i32.const 14632) "\1f\00\00\00E\00t\00h\00e\00r\00e\00u\00m\00V\00a\00l\00u\00e\00 \00i\00s\00 \00n\00o\00t\00 \00a\00n\00 \00a\00d\00d\00r\00e\00s\00s")
  (data (;181;) (i32.const 14704) "%\00\00\00~\00l\00i\00b\00/\00@\00g\00r\00a\00p\00h\00p\00r\00o\00t\00o\00c\00o\00l\00/\00g\00r\00a\00p\00h\00-\00t\00s\00/\00i\00n\00d\00e\00x\00.\00t\00s")
  (data (;182;) (i32.const 14784) "\10\00\00\00c\00o\00n\00t\00r\00o\00l\00T\00o\00k\00e\00n\00A\00d\00d\00r")
  (data (;183;) (i32.const 14832) "\e89")
  (data (;184;) (i32.const 14840) "Q\00\00\00C\00a\00l\00l\00 \00r\00e\00v\00e\00r\00t\00e\00d\00,\00 \00p\00r\00o\00b\00a\00b\00l\00y\00 \00b\00e\00c\00a\00u\00s\00e\00 \00a\00n\00 \00`\00a\00s\00s\00e\00r\00t\00`\00 \00o\00r\00 \00`\00r\00e\00q\00u\00i\00r\00e\00`\00 \00i\00n\00 \00t\00h\00e\00 \00c\00o\00n\00t\00r\00a\00c\00t\00 \00f\00a\00i\00l\00e\00d\00,\00 ")
  (data (;185;) (i32.const 15008) "\14\00\00\00c\00o\00n\00s\00i\00d\00e\00r\00 \00u\00s\00i\00n\00g\00 \00`\00t\00r\00y\00_")
  (data (;186;) (i32.const 15056) "\04\00\00\00n\00u\00l\00l")
  (data (;187;) (i32.const 15072) "\0e\00\00\00~\00l\00i\00b\00/\00s\00t\00r\00i\00n\00g\00.\00t\00s")
  (data (;188;) (i32.const 15112) "\17\00\00\00~\00l\00i\00b\00/\00i\00n\00t\00e\00r\00n\00a\00l\00/\00s\00t\00r\00i\00n\00g\00.\00t\00s")
  (data (;189;) (i32.const 15168) " \00\00\00`\00 \00t\00o\00 \00h\00a\00n\00d\00l\00e\00 \00t\00h\00i\00s\00 \00i\00n\00 \00t\00h\00e\00 \00m\00a\00p\00p\00i\00n\00g\00.")
  (data (;190;) (i32.const 15240) "\0b\00\00\00M\00i\00n\00i\00M\00e\00T\00o\00k\00e\00n")
  (data (;191;) (i32.const 15272) "\0e\00\00\00s\00h\00a\00r\00e\00T\00o\00k\00e\00n\00A\00d\00d\00r")
  (data (;192;) (i32.const 15312) "\c8;")
  (data (;193;) (i32.const 15320) "\0f\00\00\00t\00o\00t\00a\00l\00F\00u\00n\00d\00s\00I\00n\00D\00A\00I")
  (data (;194;) (i32.const 15369) "<")
  (data (;195;) (i32.const 15376) "$\00\00\00E\00t\00h\00e\00r\00e\00u\00m\00V\00a\00l\00u\00e\00 \00i\00s\00 \00n\00o\00t\00 \00a\00n\00 \00i\00n\00t\00 \00o\00r\00 \00u\00i\00n\00t\00.")
  (data (;196;) (i32.const 15456) "\1a\00\00\00V\00a\00l\00u\00e\00 \00i\00s\00 \00n\00o\00t\00 \00a\00 \00B\00i\00g\00D\00e\00c\00i\00m\00a\00l\00.")
  (data (;197;) (i32.const 15512) "\16\00\00\00t\00o\00t\00a\00l\00F\00u\00n\00d\00s\00A\00t\00P\00h\00a\00s\00e\00S\00t\00a\00r\00t")
  (data (;198;) (i32.const 15560) "\0a\00\00\00k\00a\00i\00r\00o\00P\00r\00i\00c\00e")
  (data (;199;) (i32.const 15592) "\e0<")
  (data (;200;) (i32.const 15600) "\0b\00\00\00t\00o\00t\00a\00l\00S\00u\00p\00p\00l\00y")
  (data (;201;) (i32.const 15640) "\10=")
  (data (;202;) (i32.const 15648) "\10\00\00\00k\00a\00i\00r\00o\00T\00o\00t\00a\00l\00S\00u\00p\00p\00l\00y")
  (data (;203;) (i32.const 15688) "\0b\00\00\00s\00h\00a\00r\00e\00s\00P\00r\00i\00c\00e")
  (data (;204;) (i32.const 15720) "\11\00\00\00s\00h\00a\00r\00e\00s\00T\00o\00t\00a\00l\00S\00u\00p\00p\00l\00y")
  (data (;205;) (i32.const 15760) "\12\00\00\00s\00h\00a\00r\00e\00s\00P\00r\00i\00c\00e\00H\00i\00s\00t\00o\00r\00y")
  (data (;206;) (i32.const 15800) "\03\00\00\00a\00u\00m")
  (data (;207;) (i32.const 15816) "\0a\00\00\00a\00u\00m\00H\00i\00s\00t\00o\00r\00y")
  (data (;208;) (i32.const 15840) "\14\00\00\00c\00y\00c\00l\00e\00T\00o\00t\00a\00l\00C\00o\00m\00m\00i\00s\00s\00i\00o\00n")
  (data (;209;) (i32.const 15888) "\08\00\00\00m\00a\00n\00a\00g\00e\00r\00s")
  (data (;210;) (i32.const 15912) "\0b\00\00\00c\00y\00c\00l\00e\00N\00u\00m\00b\00e\00r")
  (data (;211;) (i32.const 15952) "H>")
  (data (;212;) (i32.const 15960) "\0a\00\00\00c\00y\00c\00l\00e\00P\00h\00a\00s\00e")
  (data (;213;) (i32.const 15992) "p>")
  (data (;214;) (i32.const 16000) "\14\00\00\00o\00v\00e\00r\00f\00l\00o\00w\00 \00c\00o\00n\00v\00e\00r\00t\00i\00n\00g\00 ")
  (data (;215;) (i32.const 16048) "\07\00\00\00 \00t\00o\00 \00u\003\002")
  (data (;216;) (i32.const 16072) "\15\00\00\00s\00t\00a\00r\00t\00T\00i\00m\00e\00O\00f\00C\00y\00c\00l\00e\00P\00h\00a\00s\00e")
  (data (;217;) (i32.const 16120) "\0f\00\00\00c\00y\00c\00l\00e\00R\00O\00I\00H\00i\00s\00t\00o\00r\00y")
  (data (;218;) (i32.const 16160) "\0a\00\00\00v\00e\00r\00s\00i\00o\00n\00N\00u\00m")
  (data (;219;) (i32.const 16184) "\07\00\00\00M\00a\00n\00a\00g\00e\00r")
  (data (;220;) (i32.const 16208) "\09\00\00\00b\00a\00l\00a\00n\00c\00e\00O\00f")
  (data (;221;) (i32.const 16232) "%\00\00\00A\00d\00d\00r\00e\00s\00s\00 \00m\00u\00s\00t\00 \00c\00o\00n\00t\00a\00i\00n\00 \00e\00x\00a\00c\00t\00l\00y\00 \002\000\00 \00b\00y\00t\00e\00s")
  (data (;222;) (i32.const 16312) "\0c\00\00\00k\00a\00i\00r\00o\00B\00a\00l\00a\00n\00c\00e")
  (data (;223;) (i32.const 16344) "\15\00\00\00k\00a\00i\00r\00o\00B\00a\00l\00a\00n\00c\00e\00W\00i\00t\00h\00S\00t\00a\00k\00e")
  (data (;224;) (i32.const 16392) "\09\00\00\00b\00a\00s\00e\00S\00t\00a\00k\00e")
  (data (;225;) (i32.const 16416) "\09\00\00\00r\00i\00s\00k\00T\00a\00k\00e\00n")
  (data (;226;) (i32.const 16440) "\0d\00\00\00r\00i\00s\00k\00T\00h\00r\00e\00s\00h\00o\00l\00d")
  (data (;227;) (i32.const 16472) "\18\00\00\00l\00a\00s\00t\00C\00o\00m\00m\00i\00s\00s\00i\00o\00n\00R\00e\00d\00e\00m\00p\00t\00i\00o\00n")
  (data (;228;) (i32.const 16528) "\0b\00\00\00b\00a\00s\00i\00c\00O\00r\00d\00e\00r\00s")
  (data (;229;) (i32.const 16560) "\0d\00\00\00f\00u\00l\00c\00r\00u\00m\00O\00r\00d\00e\00r\00s")
  (data (;230;) (i32.const 16592) "\0e\00\00\00c\00o\00m\00p\00o\00u\00n\00d\00O\00r\00d\00e\00r\00s")
  (data (;231;) (i32.const 16624) "\11\00\00\00c\00o\00m\00m\00i\00s\00s\00i\00o\00n\00H\00i\00s\00t\00o\00r\00y")
  (data (;232;) (i32.const 16664) "\05\00\00\00v\00o\00t\00e\00s")
  (data (;233;) (i32.const 16680) "\0d\00\00\00u\00p\00g\00r\00a\00d\00e\00S\00i\00g\00n\00a\00l")
  (data (;234;) (i32.const 16712) "\17\00\00\00t\00o\00t\00a\00l\00C\00o\00m\00m\00i\00s\00s\00i\00o\00n\00R\00e\00c\00e\00i\00v\00e\00d")
  (data (;235;) (i32.const 16768) "\0a\00\00\00r\00o\00i\00H\00i\00s\00t\00o\00r\00y")
  (data (;236;) (i32.const 16792) "(\00\00\00C\00a\00n\00n\00o\00t\00 \00s\00a\00v\00e\00 \00M\00a\00n\00a\00g\00e\00r\00 \00e\00n\00t\00i\00t\00y\00 \00w\00i\00t\00h\00o\00u\00t\00 \00a\00n\00 \00I\00D")
  (data (;237;) (i32.const 16880) "\13\00\00\00g\00e\00n\00e\00r\00a\00t\00e\00d\00/\00s\00c\00h\00e\00m\00a\00.\00t\00s")
  (data (;238;) (i32.const 16928) "/\00\00\00C\00a\00n\00n\00o\00t\00 \00s\00a\00v\00e\00 \00M\00a\00n\00a\00g\00e\00r\00 \00e\00n\00t\00i\00t\00y\00 \00w\00i\00t\00h\00 \00n\00o\00n\00-\00s\00t\00r\00i\00n\00g\00 \00I\00D\00.\00 ")
  (data (;239;) (i32.const 17032) ";\00\00\00C\00o\00n\00s\00i\00d\00e\00r\00i\00n\00g\00 \00u\00s\00i\00n\00g\00 \00.\00t\00o\00H\00e\00x\00(\00)\00 \00t\00o\00 \00c\00o\00n\00v\00e\00r\00t\00 \00t\00h\00e\00 \00\22\00i\00d\00\22\00 \00t\00o\00 \00a\00 \00s\00t\00r\00i\00n\00g\00.")
  (data (;240;) (i32.const 17160) "\16\00\00\00V\00a\00l\00u\00e\00 \00i\00s\00 \00n\00o\00t\00 \00a\00 \00s\00t\00r\00i\00n\00g\00.")
  (data (;241;) (i32.const 17208) "\16\00\00\00V\00a\00l\00u\00e\00 \00i\00s\00 \00n\00o\00t\00 \00a\00n\00 \00a\00r\00r\00a\00y\00.")
  (data (;242;) (i32.const 17256) "\16\00\00\00V\00a\00l\00u\00e\00 \00i\00s\00 \00n\00o\00t\00 \00a\00 \00B\00i\00g\00I\00n\00t\00.")
  (data (;243;) (i32.const 17304) "\07\00\00\00a\00d\00d\00r\00e\00s\00s")
  (data (;244;) (i32.const 17328) "\12\00\00\00l\00a\00s\00t\00P\00r\00o\00c\00e\00s\00s\00e\00d\00B\00l\00o\00c\00k")
  (data (;245;) (i32.const 17368) "\17\00\00\00h\00a\00s\00F\00i\00n\00a\00l\00i\00z\00e\00d\00N\00e\00x\00t\00V\00e\00r\00s\00i\00o\00n")
  (data (;246;) (i32.const 17424) "\13\00\00\00u\00p\00g\00r\00a\00d\00e\00V\00o\00t\00i\00n\00g\00A\00c\00t\00i\00v\00e")
  (data (;247;) (i32.const 17472) "\0b\00\00\00n\00e\00x\00t\00V\00e\00r\00s\00i\00o\00n")
  (data (;248;) (i32.const 17504) "\09\00\00\00p\00r\00o\00p\00o\00s\00e\00r\00s")
  (data (;249;) (i32.const 17528) "\0a\00\00\00c\00a\00n\00d\00i\00d\00a\00t\00e\00s")
  (data (;250;) (i32.const 17552) "\08\00\00\00f\00o\00r\00V\00o\00t\00e\00s")
  (data (;251;) (i32.const 17576) "\0c\00\00\00a\00g\00a\00i\00n\00s\00t\00V\00o\00t\00e\00s")
  (data (;252;) (i32.const 17608) "\15\00\00\00u\00p\00g\00r\00a\00d\00e\00S\00i\00g\00n\00a\00l\00S\00t\00r\00e\00n\00g\00t\00h")
  (data (;253;) (i32.const 17656) "%\00\00\00C\00a\00n\00n\00o\00t\00 \00s\00a\00v\00e\00 \00F\00u\00n\00d\00 \00e\00n\00t\00i\00t\00y\00 \00w\00i\00t\00h\00o\00u\00t\00 \00a\00n\00 \00I\00D")
  (data (;254;) (i32.const 17736) ",\00\00\00C\00a\00n\00n\00o\00t\00 \00s\00a\00v\00e\00 \00F\00u\00n\00d\00 \00e\00n\00t\00i\00t\00y\00 \00w\00i\00t\00h\00 \00n\00o\00n\00-\00s\00t\00r\00i\00n\00g\00 \00I\00D\00.\00 ")
  (data (;255;) (i32.const 17832) "4\00\00\00C\00a\00n\00 \00i\00n\00i\00t\00i\00a\00l\00i\00s\00e\00 \00s\00t\00o\00r\00e\00 \00w\00i\00t\00h\00 \00a\00n\00 \00a\00r\00r\00a\00y\00 \00o\00f\00 \00E\00n\00t\00i\00t\00y\00 \00o\00b\00j\00e\00c\00t\00s")
  (data (;256;) (i32.const 17944) "\0c\00\00\00t\00e\00s\00t\00E\00n\00t\00i\00t\00y\00I\00d")
  (data (;257;) (i32.const 17976) "\08\00\00\00b\00u\00r\00g\00e\00r\00I\00d")
  (data (;258;) (i32.const 18000) "\12\00\00\00P\00u\00l\00l\00e\00d\00 \00p\00o\00r\00k\00 \00b\00u\00r\00g\00e\00r")
  (data (;259;) (i32.const 18040) "\10\00\00\00S\00u\00c\00c\00e\00s\00s\00!\00 \00F\00i\00e\00l\00d\00 \00'")
  (data (;260;) (i32.const 18080) "\17\00\00\00'\00 \00o\00n\00 \00e\00n\00t\00i\00t\00y\00 \00w\00i\00t\00h\00 \00t\00y\00p\00e\00 \00'")
  (data (;261;) (i32.const 18136) "\0a\00\00\00'\00 \00a\00n\00d\00 \00i\00d\00 \00'")
  (data (;262;) (i32.const 18160) "\0a\00\00\00'\00 \00e\00q\00u\00a\00l\00s\00 \00'")
  (data (;263;) (i32.const 18184) "\02\00\00\00'\00.")
  (data (;264;) (i32.const 18192) "$\00\00\00C\00a\00n\00 \00c\00a\00l\00l\00 \00m\00a\00p\00p\00i\00n\00g\00s\00 \00w\00i\00t\00h\00 \00c\00u\00s\00t\00o\00m\00 \00e\00v\00e\00n\00t\00s")
  (data (;265;) (i32.const 18272) "\09\00\00\00b\00u\00r\00g\00e\00r\00I\00d\000")
  (data (;266;) (i32.const 18296) "\09\00\00\00b\00u\00r\00g\00e\00r\00I\00d\001")
  (data (;267;) (i32.const 18320) "\06\00\00\00V\00e\00g\00g\00i\00e")
  (data (;268;) (i32.const 18336) "\09\00\00\00b\00u\00r\00g\00e\00r\00I\00d\002")
  (data (;269;) (i32.const 18360) "\16\00\00\00C\00h\00i\00k\00e\00n\00 \00t\00e\00r\00i\00y\00a\00k\00i\00 \00b\00u\00r\00g\00e\00r")
  (data (;270;) (i32.const 18408) "*\00\00\00C\00a\00n\00 \00a\00d\00d\00,\00 \00g\00e\00t\00,\00 \00a\00s\00s\00e\00r\00t\00 \00a\00n\00d\00 \00r\00e\00m\00o\00v\00e\00 \00f\00r\00o\00m\00 \00s\00t\00o\00r\00e")
  (data (;271;) (i32.const 18496) "\02\00\00\002\003")
  (data (;272;) (i32.const 18504) "\09\00\00\00H\00a\00m\00b\00u\00r\00g\00e\00r")
  (data (;273;) (i32.const 18528) "#\00\00\00F\00o\00l\00l\00o\00w\00i\00n\00g\00 \00t\00y\00p\00e\00 \00i\00s\00 \00a\00b\00s\00e\00n\00t\00 \00f\00r\00o\00m\00 \00m\00a\00p\00:\00 ")
  (data (;274;) (i32.const 18608) "\0e\00\00\000\00x\000\000\000\000\000\001\002\003\004\001\002\003")
  (data (;275;) (i32.const 18640) "\0f\00\00\00e\00x\00a\00m\00p\00l\00e\00F\00u\00n\00c\00N\00a\00m\00e")
  (data (;276;) (i32.const 18680) "\06\00\00\00p\00a\00r\00a\00m\001")
  (data (;277;) (i32.const 18696) "\06\00\00\00p\00a\00r\00a\00m\002")
  (data (;278;) (i32.const 18712) "\08\00\00\00\00\00\00\00\f8H\00\00\08I")
  (data (;279;) (i32.const 18728) "\18I\00\00\02")
  (data (;280;) (i32.const 18736) "\0b\00\00\00r\00e\00t\00u\00r\00n\00V\00a\00l\00u\00e")
  (data (;281;) (i32.const 18768) "\08\00\00\00\00\00\00\00\f8H\00\00\08I")
  (data (;282;) (i32.const 18784) "PI\00\00\02")
  (data (;283;) (i32.const 18792) "\17\00\00\00N\00o\00 \00f\00u\00n\00c\00t\00i\00o\00n\00 \00w\00i\00t\00h\00 \00n\00a\00m\00e\00 \00'")
  (data (;284;) (i32.const 18848) "\15\00\00\00'\00,\00 \00c\00o\00n\00t\00r\00a\00c\00t\00 \00a\00d\00d\00r\00e\00s\00s\00 \00'")
  (data (;285;) (i32.const 18896) "\1c\00\00\00'\00 \00a\00n\00d\00 \00g\00i\00v\00e\00n\00 \00a\00r\00g\00u\00m\00e\00n\00t\00s\00 \00f\00o\00u\00n\00d\00.")
  (data (;286;) (i32.const 18960) ",\00\00\00E\00x\00p\00e\00c\00t\00e\00d\00 \00v\00a\00l\00u\00e\00 \00t\00o\00 \00b\00e\00 \00'\00r\00e\00t\00u\00r\00n\00V\00a\00l\00u\00e\00'\00 \00b\00u\00t\00 \00w\00a\00s\00 \00'")
  (data (;287;) (i32.const 19056) "\0a\00\00\00'\00 \00i\00n\00s\00t\00e\00a\00d\00."))
