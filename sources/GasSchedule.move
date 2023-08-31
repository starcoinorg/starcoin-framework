address StarcoinFramework {
/// Gas schedule configuration.
module GasSchedule {
    use StarcoinFramework::Vector;
    use StarcoinFramework::ChainId;
    use StarcoinFramework::Config;
    use StarcoinFramework::CoreAddresses;
    spec module {
        pragma verify = false;
        pragma aborts_if_is_strict;
    }

    struct GasEntry has store, copy, drop {
        key: vector<u8>,
        val: u64,
    }

    struct GasSchedule has copy, drop, store, key {
        entries: vector<GasEntry>,
    }

    /// The  `GasCost` tracks:
    /// - instruction cost: how much time/computational power is needed to perform the instruction
    /// - memory cost: how much memory is required for the instruction, and storage overhead
    public fun gas_schedule(): vector<GasEntry> {
        let table = Vector::empty();

        // instruction_schedule
        // POP
        Vector::push_back(&mut table, new_gas_entry(b"instr.pop", 1, 1));
        // RET
        Vector::push_back(&mut table, new_gas_entry(b"instr.ret", 638, 1));
        // BR_TRUE
        Vector::push_back(&mut table, new_gas_entry(b"instr.br_true", 1, 1));
        // BR_FALSE
        Vector::push_back(&mut table, new_gas_entry(b"instr.br_false", 1, 1));
        // BRANCH
        Vector::push_back(&mut table, new_gas_entry(b"instr.branch", 1, 1));
        // LD_U64
        Vector::push_back(&mut table, new_gas_entry(b"instr.ld_u64", 1, 1));
        // LD_CONST
        Vector::push_back(&mut table, new_gas_entry(b"instr.ld_const.per_byte", 1, 1));
        // LD_TRUE
        Vector::push_back(&mut table, new_gas_entry(b"instr.ld_true", 1, 1));
        // LD_FALSE
        Vector::push_back(&mut table, new_gas_entry(b"instr.ld_false", 1, 1));
        // COPY_LOC
        Vector::push_back(&mut table, new_gas_entry(b"instr.copy_loc.per_abs_mem_unit", 1, 1));
        // MOVE_LOC
        Vector::push_back(&mut table, new_gas_entry(b"instr.move_loc.per_abs_mem_unit", 1, 1));
        // ST_LOC
        Vector::push_back(&mut table, new_gas_entry(b"instr.st_loc.per_abs_mem_unit", 1, 1));
        // MUT_BORROW_LOC
        Vector::push_back(&mut table, new_gas_entry(b"instr.mut_borrow_loc", 2, 1));
        // IMM_BORROW_LOC
        Vector::push_back(&mut table, new_gas_entry(b"instr.imm_borrow_loc", 1, 1));
        // MUT_BORROW_FIELD
        Vector::push_back(&mut table, new_gas_entry(b"instr.mut_borrow_field", 1, 1));
        // IMM_BORROW_FIELD
        Vector::push_back(&mut table, new_gas_entry(b"instr.imm_borrow_field", 1, 1));
        // CALL
        Vector::push_back(&mut table, new_gas_entry(b"instr.call.per_arg", 1132, 1));
        // PACK
        Vector::push_back(&mut table, new_gas_entry(b"instr.pack.per_abs_mem_unit", 2, 1));
        // UNPACK
        Vector::push_back(&mut table, new_gas_entry(b"instr.unpack.per_abs_mem_unit", 2, 1));
        // READ_REF
        Vector::push_back(&mut table, new_gas_entry(b"instr.read_ref.per_abs_mem_unit", 1, 1));
        // WRITE_REF
        Vector::push_back(&mut table, new_gas_entry(b"instr.write_ref.per_abs_mem_unit", 1, 1));
        // ADD
        Vector::push_back(&mut table, new_gas_entry(b"instr.add", 1, 1));
        // SUB
        Vector::push_back(&mut table, new_gas_entry(b"instr.sub", 1, 1));
        // MUL
        Vector::push_back(&mut table, new_gas_entry(b"instr.mul", 1, 1));
        // MOD
        Vector::push_back(&mut table, new_gas_entry(b"instr.mod", 1, 1));
        // DIV
        Vector::push_back(&mut table, new_gas_entry(b"instr.div", 3, 1));
        // BIT_OR
        Vector::push_back(&mut table, new_gas_entry(b"instr.bit_or", 2, 1));
        // BIT_AND
        Vector::push_back(&mut table, new_gas_entry(b"instr.bit_and", 2, 1));
        // XOR
        Vector::push_back(&mut table, new_gas_entry(b"instr.xor", 1, 1));
        // OR
        Vector::push_back(&mut table, new_gas_entry(b"instr.or", 2, 1));
        // AND
        Vector::push_back(&mut table, new_gas_entry(b"instr.and", 1, 1));
        // NOT
        Vector::push_back(&mut table, new_gas_entry(b"instr.not", 1, 1));
        // EQ
        Vector::push_back(&mut table, new_gas_entry(b"instr.eq.per_abs_mem_unit", 1, 1));
        // NEQ
        Vector::push_back(&mut table, new_gas_entry(b"instr.neq.per_abs_mem_unit", 1, 1));
        // LT
        Vector::push_back(&mut table, new_gas_entry(b"instr.lt", 1, 1));
        // GT
        Vector::push_back(&mut table, new_gas_entry(b"instr.gt", 1, 1));
        // LE
        Vector::push_back(&mut table, new_gas_entry(b"instr.le", 2, 1));
        // GE
        Vector::push_back(&mut table, new_gas_entry(b"instr.ge", 1, 1));
        // ABORT
        Vector::push_back(&mut table, new_gas_entry(b"instr.abort", 1, 1));
        // NOP
        Vector::push_back(&mut table, new_gas_entry(b"instr.nop", 1, 1));
        // EXISTS
        Vector::push_back(&mut table, new_gas_entry(b"instr.exists.per_abs_mem_unit", 41, 1));
        // MUT_BORROW_GLOBAL
        Vector::push_back(&mut table, new_gas_entry(b"instr.mut_borrow_global.per_abs_mem_unit", 21, 1));
        // IML_BORROW_GLOBAL
        Vector::push_back(&mut table, new_gas_entry(b"instr.imm_borrow_global.per_abs_mem_unit", 23, 1));
        // MOVE_FROM
        Vector::push_back(&mut table, new_gas_entry(b"instr.move_from.per_abs_mem_unit", 459, 1));
        // MOVE_TO
        Vector::push_back(&mut table, new_gas_entry(b"instr.move_to.per_abs_mem_unit", 13, 1));
        // FREEZE_REF
        Vector::push_back(&mut table, new_gas_entry(b"instr.freeze_ref", 1, 1));
        // SHL
        Vector::push_back(&mut table, new_gas_entry(b"instr.shl", 2, 1));
        // SHR
        Vector::push_back(&mut table, new_gas_entry(b"instr.shr", 1, 1));
        // LD_U8
        Vector::push_back(&mut table, new_gas_entry(b"instr.ld_u8", 1, 1));
        // LD_U128
        Vector::push_back(&mut table, new_gas_entry(b"instr.ld_u128", 1, 1));

        // CAST_U8
        Vector::push_back(&mut table, new_gas_entry(b"instr.cast_u8", 2, 1));
        // CAST_U64
        Vector::push_back(&mut table, new_gas_entry(b"instr.cast_u64", 1, 1));
        // CAST_U128
        Vector::push_back(&mut table, new_gas_entry(b"instr.cast_u128", 1, 1));
        // MUT_BORORW_FIELD_GENERIC
        Vector::push_back(&mut table, new_gas_entry(b"instr.mut_borrow_field_generic.base", 1, 1));
        // IMM_BORORW_FIELD_GENERIC
        Vector::push_back(&mut table, new_gas_entry(b"instr.imm_borrow_field_generic.base", 1, 1));
        // CALL_GENERIC
        Vector::push_back(&mut table, new_gas_entry(b"instr.call_generic.per_arg", 582, 1));
        // PACK_GENERIC
        Vector::push_back(&mut table, new_gas_entry(b"instr.pack_generic.per_abs_mem_unit", 2, 1));
        // UNPACK_GENERIC
        Vector::push_back(&mut table, new_gas_entry(b"instr.unpack_generic.per_abs_mem_unit", 2, 1));
        // EXISTS_GENERIC
        Vector::push_back(&mut table, new_gas_entry(b"instr.exists_generic.per_abs_mem_unit", 34, 1));
        // MUT_BORROW_GLOBAL_GENERIC
        Vector::push_back(&mut table, new_gas_entry(b"instr.mut_borrow_global_generic.per_abs_mem_unit", 15, 1));
        // IMM_BORROW_GLOBAL_GENERIC
        Vector::push_back(&mut table, new_gas_entry(b"instr.imm_borrow_global_generic.per_abs_mem_unit", 14, 1));
        // MOVE_FROM_GENERIC
        Vector::push_back(&mut table, new_gas_entry(b"instr.move_from_generic.per_abs_mem_unit", 13, 1));
        // MOVE_TO_GENERIC
        Vector::push_back(&mut table, new_gas_entry(b"instr.move_to_generic.per_abs_mem_unit", 27, 1));

        // VEC_PACK
        Vector::push_back(&mut table, new_gas_entry(b"instr.vec_pack.per_elem", 84, 1));
        // VEC_LEN
        Vector::push_back(&mut table, new_gas_entry(b"instr.vec_len.base", 98, 1));
        // VEC_IMM_BORROW
        Vector::push_back(&mut table, new_gas_entry(b"instr.vec_imm_borrow.base", 1334, 1));
        // VEC_MUT_BORROW
        Vector::push_back(&mut table, new_gas_entry(b"instr.vec_mut_borrow.base", 1902, 1));
        // VEC_PUSH_BACK
        Vector::push_back(&mut table, new_gas_entry(b"instr.vec_push_back.per_abs_mem_unit", 53, 1));
        // VEC_POP_BACK
        Vector::push_back(&mut table, new_gas_entry(b"instr.vec_pop_back.base", 227, 1));
        // VEC_UNPACK
        Vector::push_back(&mut table, new_gas_entry(b"instr.vec_unpack.per_expected_elem", 572, 1));
        // VEC_SWAP
        Vector::push_back(&mut table, new_gas_entry(b"instr.vec_swap.base", 1436, 1));

        Vector::push_back(&mut table, new_constant_entry(b"instr.ld_u16", 3));
        Vector::push_back(&mut table, new_constant_entry(b"instr.ld_u32", 2));
        Vector::push_back(&mut table, new_constant_entry(b"instr.ld_u256", 3));
        Vector::push_back(&mut table, new_constant_entry(b"instr.cast_u16", 3));
        Vector::push_back(&mut table, new_constant_entry(b"instr.cast_u32", 2));
        Vector::push_back(&mut table, new_constant_entry(b"instr.cast_u256", 3));

        // native_schedule
        //Hash::sha2_256 0
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.hash.sha2_256.per_byte", 21, 1));
        //Hash::sha3_256 1
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.hash.sha3_256.per_byte", 64, 1));
        //Signature::ed25519_verify 2
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.signature.ed25519_verify.per_byte", 61, 1));
        //ED25519_THRESHOLD_VERIFY 3 this native funciton is deprecated
        //Vector::push_back(&mut table, new_gas_entry(b"", 3351, 1));
        //BSC::to_bytes 4
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.bcs.to_bytes.per_byte_serialized", 181, 1));
        //Vector::length 5
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.vector.length.base", 98, 1));
        //Vector::empty 6
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.vector.empty.base", 84, 1));
        //Vector::borrow 7
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.vector.borrow.base", 1334, 1));
        //Vector::borrow_mut 8
        //Vector::push_back(&mut table, new_gas_entry(b"", 1902, 1));
        //Vector::push_back 9
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.vector.push_back.legacy_per_abstract_memory_unit", 53, 1));
        //Vector::pop_back 10
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.vector.pop_back.base", 227, 1));
        //Vector::destory_empty 11
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.vector.destroy_empty.base", 572, 1));
        //Vector::swap 12
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.vector.swap.base", 1436, 1));
        //Signature::ed25519_validate_pubkey 13
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.signature.ed25519_validate_key.per_byte", 26, 1));
        //Signer::borrow_address 14
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.signer.borrow_address.base", 353, 1));
        //Account::creator_signer 15
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.account.create_signer.base", 24, 1));
        //Account::destroy_signer 16
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.account.destroy_signer.base", 212, 1));
        //Event::emit_event 17
        Vector::push_back(&mut table, new_gas_entry(b"nursery.event.write_to_event_store.unit_cost", 52, 1));
        //BCS::to_address 18
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.bcs.to_address.per_byte", 26, 1));
        //Token::name_of 19
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.token.name_of.base", 2002, 1));
        //Hash::keccak_256 20
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.hash.keccak256.per_byte", 64, 1));
        //Hash::ripemd160 21
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.hash.ripemd160.per_byte", 64, 1));
        //Signature::native_ecrecover 22
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.signature.ec_recover.per_byte", 128, 1));
        //U256::from_bytes 23
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.u256.from_bytes.per_byte", 2, 1));
        //U256::add 24
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.u256.add.base", 4, 1));
        //U256::sub 25
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.u256.sub.base", 4, 1));
        //U256::mul 26
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.u256.mul.base", 4, 1));
        //U256::div 27
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.u256.div.base", 10, 1));
        // U256::rem 28
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.u256.rem.base", 4, 1));
        // U256::pow 29
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.u256.pow.base", 8, 1));
        // TODO: settle down the gas cost
        // Vector::append 30
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.vector.append.legacy_per_abstract_memory_unit", 40, 1));
        // Vector::remove 31
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.vector.remove.legacy_per_abstract_memory_unit", 20, 1));
        // Vector::reverse 32
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.vector.reverse.legacy_per_abstract_memory_unit", 10, 1));
        // Table::new_table_handle 33
        Vector::push_back(&mut table, new_gas_entry(b"table.new_table_handle.base", 4, 1));
        // Table::add_box 34
        Vector::push_back(&mut table, new_gas_entry(b"table.add_box.per_byte_serialized", 4, 1));
        // Table::borrow_box 35
        Vector::push_back(&mut table, new_gas_entry(b"table.borrow_box.per_byte_serialized", 10, 1));
        // Table::remove_box 36
        Vector::push_back(&mut table, new_gas_entry(b"table.remove_box.per_byte_serialized", 8, 1));
        // Table::contains_box 37
        Vector::push_back(&mut table, new_gas_entry(b"table.contains_box.per_byte_serialized", 40, 1));
        // Table::destroy_empty_box 38
        Vector::push_back(&mut table, new_gas_entry(b"table.destroy_empty_box.base", 20, 1));
        // Table::drop_unchecked_box 39
        Vector::push_back(&mut table, new_gas_entry(b"table.drop_unchecked_box.base", 73, 1));
        // string.check_utf8 40
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.string.check_utf8.per_byte", 4, 1));
        // string.sub_str 41
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.string.sub_string.per_byte", 4, 1));
        // string.is_char_boundary 42
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.string.is_char_boundary.base", 4, 1));
        // Table::string.index_of 43
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.string.index_of.per_byte_searched", 4, 1));
        // Table::string.index_of 44
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.frombcs.base", 4, 1));
        // Table::string.index_of 45
        Vector::push_back(&mut table, new_gas_entry(b"starcoin_natives.secp256k1.base", 4, 1));
        // Table::string.index_of 46
        Vector::push_back(&mut table, new_gas_entry(b"move_stdlib.vector.spawn_from.legacy_per_abstract_memory_unit", 4, 1));

        Vector::push_back(&mut table, new_constant_entry(b"nursery.debug.print.base_cost", 1));
        Vector::push_back(&mut table, new_constant_entry(b"nursery.debug.print_stack_trace.base_cost", 1));
        Vector::push_back(&mut table, new_constant_entry(b"move_stdlib.hash.sha2_256.legacy_min_input_len", 1));
        Vector::push_back(&mut table, new_constant_entry(b"move_stdlib.hash.sha3_256.legacy_min_input_len", 1));
        Vector::push_back(&mut table, new_constant_entry(b"move_stdlib.bcs.to_bytes.failure", 182));
        Vector::push_back(&mut table, new_constant_entry(b"move_stdlib.bcs.to_bytes.legacy_min_output_size", 1));

        // constant config values
        Vector::push_back(&mut table, new_constant_entry(b"txn.global_memory_per_byte_cost", 4));
        Vector::push_back(&mut table, new_constant_entry(b"txn.global_memory_per_byte_write_cost", 9));
        Vector::push_back(&mut table, new_constant_entry(b"txn.min_transaction_gas_units", 600));
        Vector::push_back(&mut table, new_constant_entry(b"txn.large_transaction_cutoff", 600));
        Vector::push_back(&mut table, new_constant_entry(b"txn.intrinsic_gas_per_byte", 8));
        let maximum_number_of_gas_units: u64 = 40000000;//must less than base_block_gas_limit
        if (ChainId::is_test() || ChainId::is_dev() || ChainId::is_halley()) {
            maximum_number_of_gas_units = maximum_number_of_gas_units * 10
        };
        Vector::push_back(&mut table, new_constant_entry(b"txn.maximum_number_of_gas_units", maximum_number_of_gas_units));
        Vector::push_back(&mut table, new_constant_entry(b"txn.min_price_per_gas_unit", if (ChainId::is_test()) { 0 }  else { 1 }));
        Vector::push_back(&mut table, new_constant_entry(b"txn.max_price_per_gas_unit", 10000));
        Vector::push_back(&mut table, new_constant_entry(b"txn.max_transaction_size_in_bytes", 1024 * 128));
        Vector::push_back(&mut table, new_constant_entry(b"txn.gas_unit_scaling_factor", 1));
        Vector::push_back(&mut table, new_constant_entry(b"txn.default_account_size", 800));

        table
    }

    public fun new_gas_entry(key: vector<u8>, instr_gas: u64, mem_gas: u64): GasEntry {
        GasEntry {
            key,
            val: instr_gas + mem_gas,
        }
    }

    fun new_constant_entry(key: vector<u8>, val: u64): GasEntry {
        GasEntry {
            key,
            val,
        }
    }

    /// Initialize the gas schedule under the genesis account
    public fun initialize(account: &signer, gas_schedule: GasSchedule) {
        CoreAddresses::assert_genesis_address(account);
        Config::publish_new_config<GasSchedule>(
            account,
            gas_schedule,
        );
    }

    public fun new_gas_schedule(): GasSchedule {
        GasSchedule {
            entries: gas_schedule(),
        }
    }

    public fun new_gas_schedule_for_test(): GasSchedule {
        let entry = GasEntry {
            key: Vector::empty(),
            val: 1,
        };
        let entries = Vector::empty();
        Vector::push_back(&mut entries, entry);

        GasSchedule {
            entries,
        }
    }

    #[test]
    fun test_gas_schedule_initialized() {
        use StarcoinFramework::Account;
        let genesis_account = Account::create_genesis_account(CoreAddresses::GENESIS_ADDRESS());
        Self::initialize(&genesis_account, Self::new_gas_schedule_for_test());
        assert!(Config::config_exist_by_address<GasSchedule>(CoreAddresses::GENESIS_ADDRESS()), 0);
    }
}
}
