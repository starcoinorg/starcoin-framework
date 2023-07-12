
<a name="0x1_GasSchedule"></a>

# Module `0x1::GasSchedule`

Gas schedule configuration.


-  [Struct `GasEntry`](#0x1_GasSchedule_GasEntry)
-  [Resource `GasSchedule`](#0x1_GasSchedule_GasSchedule)
-  [Function `gas_schedule`](#0x1_GasSchedule_gas_schedule)
-  [Function `new_gas_entry`](#0x1_GasSchedule_new_gas_entry)
-  [Function `new_constant_entry`](#0x1_GasSchedule_new_constant_entry)
-  [Function `initialize`](#0x1_GasSchedule_initialize)
-  [Function `new_gas_schedule_for_test`](#0x1_GasSchedule_new_gas_schedule_for_test)
-  [Module Specification](#@Module_Specification_0)


<pre><code><b>use</b> <a href="ChainId.md#0x1_ChainId">0x1::ChainId</a>;
<b>use</b> <a href="Config.md#0x1_Config">0x1::Config</a>;
<b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
</code></pre>



<a name="0x1_GasSchedule_GasEntry"></a>

## Struct `GasEntry`



<pre><code><b>struct</b> <a href="GasSchedule.md#0x1_GasSchedule_GasEntry">GasEntry</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>key: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>val: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GasSchedule_GasSchedule"></a>

## Resource `GasSchedule`



<pre><code><b>struct</b> <a href="GasSchedule.md#0x1_GasSchedule">GasSchedule</a> <b>has</b> <b>copy</b>, drop, store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>entries: vector&lt;<a href="GasSchedule.md#0x1_GasSchedule_GasEntry">GasSchedule::GasEntry</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GasSchedule_gas_schedule"></a>

## Function `gas_schedule`

The  <code>GasCost</code> tracks:
- instruction cost: how much time/computational power is needed to perform the instruction
- memory cost: how much memory is required for the instruction, and storage overhead


<pre><code><b>public</b> <b>fun</b> <a href="GasSchedule.md#0x1_GasSchedule_gas_schedule">gas_schedule</a>(): vector&lt;<a href="GasSchedule.md#0x1_GasSchedule_GasEntry">GasSchedule::GasEntry</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GasSchedule.md#0x1_GasSchedule_gas_schedule">gas_schedule</a>(): vector&lt;<a href="GasSchedule.md#0x1_GasSchedule_GasEntry">GasEntry</a>&gt; {
    <b>let</b> table = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>();

    // instruction_schedule
    // POP
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.pop", 1, 1));
    // RET
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.ret", 638, 1));
    // BR_TRUE
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.br_true", 1, 1));
    // BR_FALSE
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.br_false", 1, 1));
    // BRANCH
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.branch", 1, 1));
    // LD_U64
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.ld_u64", 1, 1));
    // LD_CONST
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.ld_const.per_byte", 1, 1));
    // LD_TRUE
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.ld_true", 1, 1));
    // LD_FALSE
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.ld_false", 1, 1));
    // COPY_LOC
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.copy_loc.per_abs_mem_unit", 1, 1));
    // MOVE_LOC
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.move_loc.per_abs_mem_unit", 1, 1));
    // ST_LOC
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.st_loc.per_abs_mem_unit", 1, 1));
    // MUT_BORROW_LOC
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.mut_borrow_loc", 2, 1));
    // IMM_BORROW_LOC
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.imm_borrow_loc", 1, 1));
    // MUT_BORROW_FIELD
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.mut_borrow_field", 1, 1));
    // IMM_BORROW_FIELD
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.imm_borrow_field", 1, 1));
    // CALL
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.call.per_arg", 1132, 1));
    // PACK
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.pack.per_abs_mem_unit", 2, 1));
    // UNPACK
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.unpack.per_abs_mem_unit", 2, 1));
    // READ_REF
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.read_ref.per_abs_mem_unit", 1, 1));
    // WRITE_REF
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.write_ref.per_abs_mem_unit", 1, 1));
    // ADD
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.add", 1, 1));
    // SUB
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.sub", 1, 1));
    // MUL
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.mul", 1, 1));
    // MOD
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.mod", 1, 1));
    // DIV
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.div", 3, 1));
    // BIT_OR
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.bit_or", 2, 1));
    // BIT_AND
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.bit_and", 2, 1));
    // XOR
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.xor", 1, 1));
    // OR
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.or", 2, 1));
    // AND
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.and", 1, 1));
    // NOT
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.not", 1, 1));
    // EQ
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.eq.per_abs_mem_unit", 1, 1));
    // NEQ
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.neq.per_abs_mem_unit", 1, 1));
    // LT
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.lt", 1, 1));
    // GT
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.gt", 1, 1));
    // LE
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.le", 2, 1));
    // GE
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.ge", 1, 1));
    // ABORT
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.<b>abort</b>", 1, 1));
    // NOP
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.nop", 1, 1));
    // EXISTS
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.<b>exists</b>.per_abs_mem_unit", 41, 1));
    // MUT_BORROW_GLOBAL
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.mut_borrow_global.per_abs_mem_unit", 21, 1));
    // IML_BORROW_GLOBAL
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.imm_borrow_global.per_abs_mem_unit", 23, 1));
    // MOVE_FROM
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.<b>move_from</b>.per_abs_mem_unit", 459, 1));
    // MOVE_TO
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.<b>move_to</b>.per_abs_mem_unit", 13, 1));
    // FREEZE_REF
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.freeze_ref", 1, 1));
    // SHL
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.shl", 2, 1));
    // SHR
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.shr", 1, 1));
    // LD_U8
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.ld_u8", 1, 1));
    // LD_U128
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.ld_u128", 1, 1));

    // CAST_U8
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.cast_u8", 2, 1));
    // CAST_U64
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.cast_u64", 1, 1));
    // CAST_U128
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.cast_u128", 1, 1));
    // MUT_BORORW_FIELD_GENERIC
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.mut_borrow_field_generic.base", 1, 1));
    // IMM_BORORW_FIELD_GENERIC
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.imm_borrow_field_generic.base", 1, 1));
    // CALL_GENERIC
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.call_generic.per_arg", 582, 1));
    // PACK_GENERIC
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.pack_generic.per_abs_mem_unit", 2, 1));
    // UNPACK_GENERIC
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.unpack_generic.per_abs_mem_unit", 2, 1));
    // EXISTS_GENERIC
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.exists_generic.per_abs_mem_unit", 34, 1));
    // MUT_BORROW_GLOBAL_GENERIC
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.mut_borrow_global_generic.per_abs_mem_unit", 15, 1));
    // IMM_BORROW_GLOBAL_GENERIC
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.imm_borrow_global_generic.per_abs_mem_unit", 14, 1));
    // MOVE_FROM_GENERIC
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.move_from_generic.per_abs_mem_unit", 13, 1));
    // MOVE_TO_GENERIC
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.move_to_generic.per_abs_mem_unit", 27, 1));

    // VEC_PACK
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.vec_pack.per_elem", 84, 1));
    // VEC_LEN
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.vec_len.base", 98, 1));
    // VEC_IMM_BORROW
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.vec_imm_borrow.base", 1334, 1));
    // VEC_MUT_BORROW
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.vec_mut_borrow.base", 1902, 1));
    // VEC_PUSH_BACK
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.vec_push_back.per_abs_mem_unit", 53, 1));
    // VEC_POP_BACK
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.vec_pop_back.base", 227, 1));
    // VEC_UNPACK
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.vec_unpack.per_expected_elem", 572, 1));
    // VEC_SWAP
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"instr.vec_swap.base", 1436, 1));

    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"instr.ld_u16", 3));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"instr.ld_u32", 2));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"instr.ld_u256", 3));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"instr.cast_u16", 3));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"instr.cast_u32", 2));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"instr.cast_u256", 3));

    // native_schedule
    //<a href="Hash.md#0x1_Hash_sha2_256">Hash::sha2_256</a> 0
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.hash.sha2_256.per_byte", 21, 1));
    //<a href="Hash.md#0x1_Hash_sha3_256">Hash::sha3_256</a> 1
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.hash.sha3_256.per_byte", 64, 1));
    //<a href="Signature.md#0x1_Signature_ed25519_verify">Signature::ed25519_verify</a> 2
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.signature.ed25519_verify.per_byte", 61, 1));
    //ED25519_THRESHOLD_VERIFY 3 this <b>native</b> funciton is deprecated
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"", 3351, 1));
    //BSC::to_bytes 4
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.bcs.to_bytes.per_byte_serialized", 181, 1));
    //<a href="Vector.md#0x1_Vector_length">Vector::length</a> 5
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.vector.length.base", 98, 1));
    //<a href="Vector.md#0x1_Vector_empty">Vector::empty</a> 6
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.vector.empty.base", 84, 1));
    //<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a> 7
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.vector.borrow.base", 1334, 1));
    //<a href="Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a> 8
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"", 1902, 1));
    //<a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a> 9
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.vector.push_back.legacy_per_abstract_memory_unit", 53, 1));
    //<a href="Vector.md#0x1_Vector_pop_back">Vector::pop_back</a> 10
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.vector.pop_back.base", 227, 1));
    //Vector::destory_empty 11
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.vector.destroy_empty.base", 572, 1));
    //<a href="Vector.md#0x1_Vector_swap">Vector::swap</a> 12
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.vector.swap.base", 1436, 1));
    //<a href="Signature.md#0x1_Signature_ed25519_validate_pubkey">Signature::ed25519_validate_pubkey</a> 13
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.signature.ed25519_validate_key.per_byte", 26, 1));
    //<a href="Signer.md#0x1_Signer_borrow_address">Signer::borrow_address</a> 14
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.signer.borrow_address.base", 353, 1));
    //Account::creator_signer 15
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.account.create_signer.base", 24, 1));
    //Account::destroy_signer 16
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.account.destroy_signer.base", 212, 1));
    //<a href="Event.md#0x1_Event_emit_event">Event::emit_event</a> 17
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"nursery.event.write_to_event_store.unit_cost", 52, 1));
    //<a href="BCS.md#0x1_BCS_to_address">BCS::to_address</a> 18
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.bcs.to_address.per_byte", 26, 1));
    //<a href="Token.md#0x1_Token_name_of">Token::name_of</a> 19
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.token.name_of.base", 2002, 1));
    //<a href="Hash.md#0x1_Hash_keccak_256">Hash::keccak_256</a> 20
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.hash.keccak256.per_byte", 64, 1));
    //<a href="Hash.md#0x1_Hash_ripemd160">Hash::ripemd160</a> 21
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.hash.ripemd160.per_byte", 64, 1));
    //<a href="Signature.md#0x1_Signature_native_ecrecover">Signature::native_ecrecover</a> 22
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.signature.ec_recover.per_byte", 128, 1));
    //<a href="U256.md#0x1_U256_from_bytes">U256::from_bytes</a> 23
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.u256.from_bytes.per_byte", 2, 1));
    //<a href="U256.md#0x1_U256_add">U256::add</a> 24
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.u256.add.base", 4, 1));
    //<a href="U256.md#0x1_U256_sub">U256::sub</a> 25
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.u256.sub.base", 4, 1));
    //<a href="U256.md#0x1_U256_mul">U256::mul</a> 26
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.u256.mul.base", 4, 1));
    //<a href="U256.md#0x1_U256_div">U256::div</a> 27
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.u256.div.base", 10, 1));
    // <a href="U256.md#0x1_U256_rem">U256::rem</a> 28
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.u256.rem.base", 4, 1));
    // <a href="U256.md#0x1_U256_pow">U256::pow</a> 29
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.u256.pow.base", 8, 1));
    // TODO: settle down the gas cost
    // <a href="Vector.md#0x1_Vector_append">Vector::append</a> 30
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.vector.append.legacy_per_abstract_memory_unit", 40, 1));
    // <a href="Vector.md#0x1_Vector_remove">Vector::remove</a> 31
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.vector.remove.legacy_per_abstract_memory_unit", 20, 1));
    // <a href="Vector.md#0x1_Vector_reverse">Vector::reverse</a> 32
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.vector.reverse.legacy_per_abstract_memory_unit", 10, 1));
    // <a href="Table.md#0x1_Table_new_table_handle">Table::new_table_handle</a> 33
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"table.new_table_handle.base", 4, 1));
    // <a href="Table.md#0x1_Table_add_box">Table::add_box</a> 34
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"table.add_box.per_byte_serialized", 4, 1));
    // <a href="Table.md#0x1_Table_borrow_box">Table::borrow_box</a> 35
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"table.borrow_box.per_byte_serialized", 10, 1));
    // <a href="Table.md#0x1_Table_remove_box">Table::remove_box</a> 36
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"table.remove_box.per_byte_serialized", 8, 1));
    // <a href="Table.md#0x1_Table_contains_box">Table::contains_box</a> 37
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"table.contains_box.per_byte_serialized", 40, 1));
    // <a href="Table.md#0x1_Table_destroy_empty_box">Table::destroy_empty_box</a> 38
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"table.destroy_empty_box.base", 20, 1));
    // <a href="Table.md#0x1_Table_drop_unchecked_box">Table::drop_unchecked_box</a> 39
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"table.drop_unchecked_box.base", 73, 1));
    // string.check_utf8 40
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.string.check_utf8.per_byte", 4, 1));
    // string.sub_str 41
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.string.sub_string.per_byte", 4, 1));
    // string.is_char_boundary 42
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.string.is_char_boundary.base", 4, 1));
    // Table::string.index_of 43
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.string.index_of.per_byte_searched", 4, 1));
    // Table::string.index_of 44
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.frombcs.base", 4, 1));
    // Table::string.index_of 45
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"starcoin_natives.secp256k1.base", 4, 1));
    // Table::string.index_of 46
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(b"move_stdlib.vector.spawn_from.legacy_per_abstract_memory_unit", 4, 1));

    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"nursery.debug.print.base_cost", 1));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"nursery.debug.print_stack_trace.base_cost", 1));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"move_stdlib.hash.sha2_256.legacy_min_input_len", 1));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"move_stdlib.hash.sha3_256.legacy_min_input_len", 1));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"move_stdlib.bcs.to_bytes.failure", 182));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"move_stdlib.bcs.to_bytes.legacy_min_output_size", 1));

    // constant config values
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"txn.global_memory_per_byte_cost", 4));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"txn.global_memory_per_byte_write_cost", 9));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"txn.min_transaction_gas_units", 600));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"txn.large_transaction_cutoff", 600));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"txn.intrinsic_gas_per_byte", 8));
    <b>let</b> maximum_number_of_gas_units: u64 = 40000000;//must less than base_block_gas_limit
    <b>if</b> (<a href="ChainId.md#0x1_ChainId_is_test">ChainId::is_test</a>() || <a href="ChainId.md#0x1_ChainId_is_dev">ChainId::is_dev</a>() || <a href="ChainId.md#0x1_ChainId_is_halley">ChainId::is_halley</a>()) {
        maximum_number_of_gas_units = maximum_number_of_gas_units * 10
    };
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"txn.maximum_number_of_gas_units", maximum_number_of_gas_units));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"txn.min_price_per_gas_unit", <b>if</b> (<a href="ChainId.md#0x1_ChainId_is_test">ChainId::is_test</a>()) { 0 }  <b>else</b> { 1 }));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"txn.max_price_per_gas_unit", 10000));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"txn.max_transaction_size_in_bytes", 1024 * 128));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"txn.gas_unit_scaling_factor", 1));
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> table, <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(b"txn.default_account_size", 800));

    table
}
</code></pre>



</details>

<a name="0x1_GasSchedule_new_gas_entry"></a>

## Function `new_gas_entry`



<pre><code><b>public</b> <b>fun</b> <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(key: vector&lt;u8&gt;, instr_gas: u64, mem_gas: u64): <a href="GasSchedule.md#0x1_GasSchedule_GasEntry">GasSchedule::GasEntry</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GasSchedule.md#0x1_GasSchedule_new_gas_entry">new_gas_entry</a>(key: vector&lt;u8&gt;, instr_gas: u64, mem_gas: u64): <a href="GasSchedule.md#0x1_GasSchedule_GasEntry">GasEntry</a> {
    <a href="GasSchedule.md#0x1_GasSchedule_GasEntry">GasEntry</a> {
        key,
        val: instr_gas + mem_gas,
    }
}
</code></pre>



</details>

<a name="0x1_GasSchedule_new_constant_entry"></a>

## Function `new_constant_entry`



<pre><code><b>fun</b> <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(key: vector&lt;u8&gt;, val: u64): <a href="GasSchedule.md#0x1_GasSchedule_GasEntry">GasSchedule::GasEntry</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GasSchedule.md#0x1_GasSchedule_new_constant_entry">new_constant_entry</a>(key: vector&lt;u8&gt;, val: u64): <a href="GasSchedule.md#0x1_GasSchedule_GasEntry">GasEntry</a> {
    <a href="GasSchedule.md#0x1_GasSchedule_GasEntry">GasEntry</a> {
        key,
        val,
    }
}
</code></pre>



</details>

<a name="0x1_GasSchedule_initialize"></a>

## Function `initialize`

Initialize the gas schedule under the genesis account


<pre><code><b>public</b> <b>fun</b> <a href="GasSchedule.md#0x1_GasSchedule_initialize">initialize</a>(account: &signer, gas_schedule: <a href="GasSchedule.md#0x1_GasSchedule_GasSchedule">GasSchedule::GasSchedule</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GasSchedule.md#0x1_GasSchedule_initialize">initialize</a>(account: &signer, gas_schedule: <a href="GasSchedule.md#0x1_GasSchedule">GasSchedule</a>) {
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(account);
    <a href="Config.md#0x1_Config_publish_new_config">Config::publish_new_config</a>&lt;<a href="GasSchedule.md#0x1_GasSchedule">GasSchedule</a>&gt;(
        account,
        gas_schedule,
    );
}
</code></pre>



</details>

<a name="0x1_GasSchedule_new_gas_schedule_for_test"></a>

## Function `new_gas_schedule_for_test`



<pre><code><b>public</b> <b>fun</b> <a href="GasSchedule.md#0x1_GasSchedule_new_gas_schedule_for_test">new_gas_schedule_for_test</a>(): <a href="GasSchedule.md#0x1_GasSchedule_GasSchedule">GasSchedule::GasSchedule</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GasSchedule.md#0x1_GasSchedule_new_gas_schedule_for_test">new_gas_schedule_for_test</a>(): <a href="GasSchedule.md#0x1_GasSchedule">GasSchedule</a> {
    <b>let</b> entry = <a href="GasSchedule.md#0x1_GasSchedule_GasEntry">GasEntry</a> {
        key: <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>(),
        val: 1,
    };
    <b>let</b> entries = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>();
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> entries, entry);

    <a href="GasSchedule.md#0x1_GasSchedule">GasSchedule</a> {
        entries,
    }
}
</code></pre>



</details>

<a name="@Module_Specification_0"></a>

## Module Specification



<pre><code><b>pragma</b> verify = <b>false</b>;
<b>pragma</b> aborts_if_is_strict;
</code></pre>
