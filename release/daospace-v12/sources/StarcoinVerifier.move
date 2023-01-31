address StarcoinFramework {
module StarcoinVerifier {
    use StarcoinFramework::Vector;
    use StarcoinFramework::Option;
    use StarcoinFramework::BCS;
    use StarcoinFramework::StructuredHash;
    use StarcoinFramework::Hash;

    const HASH_LEN_IN_BITS: u64 = 32 * 8;
    const SPARSE_MERKLE_LEAF_NODE: vector<u8> = b"SparseMerkleLeafNode";
    const SPARSE_MERKLE_INTERNAL_NODE: vector<u8> = b"SparseMerkleInternalNode";
    const BLOB_HASH_PREFIX: vector<u8> = b"Blob";
    const DEFAULT_VALUE: vector<u8> = x"";
    const ACCOUNT_STORAGE_INDEX_RESOURCE: u64 = 1;
    const ERROR_ACCOUNT_STORAGE_ROOTS: u64 = 101;
    const ERROR_LITERAL_HASH_WRONG_LENGTH: u64 = 102;
    const SPARSE_MERKLE_PLACEHOLDER_HASH_LITERAL: vector<u8> = b"SPARSE_MERKLE_PLACEHOLDER_HASH";


    struct AccountState has store, drop, copy {
        storage_roots: vector<Option::Option<vector<u8>>>,
    }

    public fun bcs_deserialize_account_state(data: &vector<u8>): AccountState {
        let (vec, _) = BCS::deserialize_option_bytes_vector(data, 0);
        AccountState{
            storage_roots: vec
        }
    }

    struct StateProof has store, drop, copy {
        /**
        * Account state's proof for global state root.
        */
        account_proof: SparseMerkleProof,
        /**
         * Account state including storage roots.
         */
        account_state: vector<u8>,
        /**
         * State's proof for account storage root.
         */
        proof: SparseMerkleProof,
    }

    public fun new_state_proof(account_proof: SparseMerkleProof, account_state: vector<u8>, proof: SparseMerkleProof): StateProof {
        StateProof{
            account_proof,
            account_state,
            proof,
        }
    }

    struct SparseMerkleProof has store, drop, copy {
        siblings: vector<vector<u8>>,
        leaf: SMTNode,
    }

    public fun new_sparse_merkle_proof(siblings: vector<vector<u8>>, leaf: SMTNode): SparseMerkleProof {
        SparseMerkleProof{
            siblings,
            leaf,
        }
    }

    struct SMTNode has store, drop, copy {
        hash1: vector<u8>,
        hash2: vector<u8>,
    }

    public fun new_smt_node(hash1: vector<u8>, hash2: vector<u8>): SMTNode {
        SMTNode{
            hash1,
            hash2,
        }
    }

    public fun empty_smt_node(): SMTNode {
        SMTNode{
            hash1: Vector::empty(),
            hash2: Vector::empty(),
        }
    }

    public fun verify_state_proof(state_proof: &StateProof, state_root: &vector<u8>,
                                           account_address: address, resource_struct_tag: &vector<u8>,
                                           state: &vector<u8>): bool {
        let accountState: AccountState = bcs_deserialize_account_state(&state_proof.account_state);
        assert!(Vector::length(&accountState.storage_roots) > ACCOUNT_STORAGE_INDEX_RESOURCE, ERROR_ACCOUNT_STORAGE_ROOTS);

        // First, verify state for storage root.
        let storageRoot = Option::borrow(Vector::borrow(&accountState.storage_roots, ACCOUNT_STORAGE_INDEX_RESOURCE));
        let ok: bool = verify_smp(&state_proof.proof.siblings,
            &state_proof.proof.leaf,
            storageRoot,
            resource_struct_tag, // resource struct tag BCS serialized as key
            state);
        if (!ok) {
            return false
        };

        // Then, verify account state for global state root.
        ok = verify_smp(&state_proof.account_proof.siblings,
            &state_proof.account_proof.leaf,
            state_root,
            &BCS::to_bytes<address>(&account_address), // account address as key
            &state_proof.account_state,
        );
        ok
    }

    #[test]
    fun test_verify_state_proof() {
        // miannet, block number 6495396
        let state_root = x"d337896a5cd8bae3d0130e09409c0f5eede159d93af38a642528acb15c1204b8";
        let account_address = @0x47d36856884d7fb9e91a475ea3472341;
//        let state = x"";
        let state = x"00000000000000000000000000000000";
        // 0x00000000000000000000000000000001::Account::Balance<0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        let resource_struct_tag = x"00000000000000000000000000000001074163636f756e740742616c616e636501078c109349c6bd91411d6bc962e080c4a30453544152045354415200";

        let account_proof_sibling_nodes = Vector::empty<vector<u8>>();
        Vector::push_back(&mut account_proof_sibling_nodes, x"b81050a469dbe041f915cda6942143c691b1735599815142c895f77cf088a656");
        Vector::push_back(&mut account_proof_sibling_nodes, x"5350415253455f4d45524b4c455f504c414345484f4c4445525f484153480000");
        Vector::push_back(&mut account_proof_sibling_nodes, x"1c0cbf70e7474e739db9ca9958470f605f37a5a0f322c7c854b24866c4330577");
        Vector::push_back(&mut account_proof_sibling_nodes, x"68dde7ba4f4a9cf6329675e598a1ab7b545f8de36e5cb8151be8ff167e479c26");
        Vector::push_back(&mut account_proof_sibling_nodes, x"3c59423b2956d25cdacf638540e39dbc53238d36ca1420d31c4321580aeff633");
        Vector::push_back(&mut account_proof_sibling_nodes, x"5befec9a99ad40f1cb6d5b44c87ca6ad26841535cd7fac27f2f88205088b55e3");
        Vector::push_back(&mut account_proof_sibling_nodes, x"32f4d82b78b1339fb5d9c60ac2e49780c87b9e9c675bee9d1cb3ace3f34a63d6");
        Vector::push_back(&mut account_proof_sibling_nodes, x"a60429524592cac0170763196269c4997e08b6a09b2ad45647775486a81559af");
        Vector::push_back(&mut account_proof_sibling_nodes, x"6b6bc4e16bad1fbc6c6df21a923a9be06ae8508827cdd3dbdd4e0e6607abdb6d");
        Vector::push_back(&mut account_proof_sibling_nodes, x"5e6165bc60b30f46611d52f9779668e0fa79eeb60bf3a0d90346b33331156155");
        Vector::push_back(&mut account_proof_sibling_nodes, x"dfc42240b0d542457748e873e3ab0ee362c68dedd91df13532cd85a1a6ea6f00");
        Vector::push_back(&mut account_proof_sibling_nodes, x"610cba3b3c467b137ddbda0f5783ef269357ca4e30aaa2cfecb96e2ee8b2c5e7");
        Vector::push_back(&mut account_proof_sibling_nodes, x"179235bb93b8ece25921f7405a2f797f80630d90f71e763e8a700734d6945b99");
        Vector::push_back(&mut account_proof_sibling_nodes, x"85d80d435c4cb8b8034d32aff6b05230efc43b583154428a0990e1f752adcf3a");
        Vector::push_back(&mut account_proof_sibling_nodes, x"a2f4a3e6f11e6b42d700c920c06a89ffe6d086d5411aa578d56d8de000704669");
        Vector::push_back(&mut account_proof_sibling_nodes, x"ee57409d642877366ac26b2bf8948f7daae3c45a545b931b28a6d902e01bdc1f");

        let state_proof_sibling_nodes = Vector::empty<vector<u8>>();
        Vector::push_back(&mut state_proof_sibling_nodes, x"2a3c2096fbd5a1a2e81077e4b2156c7232b9291ad3d85ea7451eb8b7cda828fd");
        Vector::push_back(&mut state_proof_sibling_nodes, x"4cc4f038091aba95645a5b8153dc088ffdbfb7c7e82dd6b166f187b33eea7432");
        Vector::push_back(&mut state_proof_sibling_nodes, x"aa140a1627b5385e108f6580062110463d09768bce681bbb88c3d9c59680d75d");
        Vector::push_back(&mut state_proof_sibling_nodes, x"7c8f59d557168dd5667fcc950ed444cfa0cbce778e032c918a8b2a2084c48c03");
        Vector::push_back(&mut state_proof_sibling_nodes, x"a0718e77be611f67f880f5fc4d7c801940aae65890f02b38a663458ed924c2f9");

        let proof = new_state_proof(
            new_sparse_merkle_proof(
                account_proof_sibling_nodes,
                new_smt_node(
                    x"3fe0547cb3576cad025fb5cfa98b85a3545a41e5b14e844fd8cad5edaa619c05",
                    x"ed0e07d03371a130b84bea8245f84bf546955e5a190afc20ef34f310614c6d10",
                ),
            ),
            x"02000120ceaafd667b54252bba61993770d87bbb997b1a689b0e08899543e3c8f82adca7",
            new_sparse_merkle_proof(
                state_proof_sibling_nodes,
                new_smt_node(
                    x"1de0d92e4e770fa53ceaa12c83edb8c0e51c1d19499d769c572ffd9d38cef40f",
                    x"6493204f1b87055adb8937a385daa238b3c08c491026f2ac50ebe4dab9133030",
                ),
            ),
        );

        let b = verify_state_proof(
            &proof,
            &state_root,
            account_address,
            &resource_struct_tag,
            &state,
        );
        assert!(b, 1110);
    }

    /// Verify sparse merkle proof by key and value.
    public fun verify_smp(sibling_nodes: &vector<vector<u8>>, leaf_data: &SMTNode, expected_root: &vector<u8>, key: &vector<u8>, value: &vector<u8>): bool {
        let path = hash_key(key);
        let current_hash: vector<u8>;
        if (*value == DEFAULT_VALUE) {
            // Non-membership proof.
            if (empty_smt_node() == *leaf_data) {
                current_hash = placeholder();
            } else {
                if (*&leaf_data.hash1 == *&path) {
                    return false
                };
                if (!(count_common_prefix(&leaf_data.hash1, &path) >= Vector::length(sibling_nodes))) {
                    return false
                };
                current_hash = StructuredHash::hash(SPARSE_MERKLE_LEAF_NODE, leaf_data);
            };
        } else {
            // Membership proof.
            if (empty_smt_node() == *leaf_data) {
                return false
            };
            if (*&leaf_data.hash1 != *&path) {
                return false
            };
            let value_hash = hash_value(value);
            if (*&leaf_data.hash2 != value_hash) {
                return false
            };
            current_hash = StructuredHash::hash(SPARSE_MERKLE_LEAF_NODE, leaf_data);
        };

        current_hash = compute_smp_root_by_path_and_node_hash(sibling_nodes, &path, &current_hash);
        current_hash == *expected_root
    }

//    #[test]
//    fun test_print_storage_root(){
//        let account_state = x"02000120ceaafd667b54252bba61993770d87bbb997b1a689b0e08899543e3c8f82adca7";
//        let accountState: AccountState = bcs_deserialize_account_state(&account_state);
//        let storageRoot = Option::borrow(Vector::borrow(&accountState.storage_roots, ACCOUNT_STORAGE_INDEX_RESOURCE));
//        Debug::print(storageRoot);
//    }

    #[test]
    fun test_verify_smp() {
        let sibling_nodes = Vector::empty<vector<u8>>();
        Vector::push_back(&mut sibling_nodes, x"2a3c2096fbd5a1a2e81077e4b2156c7232b9291ad3d85ea7451eb8b7cda828fd");
        Vector::push_back(&mut sibling_nodes, x"4cc4f038091aba95645a5b8153dc088ffdbfb7c7e82dd6b166f187b33eea7432");
        Vector::push_back(&mut sibling_nodes, x"aa140a1627b5385e108f6580062110463d09768bce681bbb88c3d9c59680d75d");
        Vector::push_back(&mut sibling_nodes, x"7c8f59d557168dd5667fcc950ed444cfa0cbce778e032c918a8b2a2084c48c03");
        Vector::push_back(&mut sibling_nodes, x"a0718e77be611f67f880f5fc4d7c801940aae65890f02b38a663458ed924c2f9");

        let leaf_node = new_smt_node(
            x"1de0d92e4e770fa53ceaa12c83edb8c0e51c1d19499d769c572ffd9d38cef40f",
            x"6493204f1b87055adb8937a385daa238b3c08c491026f2ac50ebe4dab9133030",
        );
        let account_state = x"02000120ceaafd667b54252bba61993770d87bbb997b1a689b0e08899543e3c8f82adca7";
        let accountState: AccountState = bcs_deserialize_account_state(&account_state);
        let expected_root = Option::borrow(Vector::borrow(&accountState.storage_roots, ACCOUNT_STORAGE_INDEX_RESOURCE));
//        let expected_root = x"0f30a41872208c6324fa842889315b14f9be6f3dd0d5050686317adfdd0cda60";
        let key = x"00000000000000000000000000000001074163636f756e740742616c616e636501078c109349c6bd91411d6bc962e080c4a30453544152045354415200";
        // Above key is this StructTag BCS serialized bytes:
        let value = x"00000000000000000000000000000000";

        let b = verify_smp(&sibling_nodes, &leaf_node, expected_root, &key, &value);
        assert!(b, 1112)
    }

    #[test]
    fun test_verify_smp_2() {
        let sibling_nodes: vector<vector<u8>> = Vector::empty();
        let leaf_data: SMTNode = empty_smt_node();
        let expected_root: vector<u8> = placeholder();
        let key: vector<u8> = b"random key";
        let value: vector<u8> = Vector::empty(); //x""
        let b = verify_smp(&sibling_nodes, &leaf_data, &expected_root, &key, &value);
        assert!(b, 1113);

        value = b"random value";
        b = verify_smp(&sibling_nodes, &leaf_data, &expected_root, &key, &value);
        assert!(!b, 1114);
    }

    public fun compute_smp_root_by_path_and_node_hash(sibling_nodes: &vector<vector<u8>>, path: &vector<u8>, node_hash: &vector<u8>): vector<u8> {
        let current_hash = *node_hash;
        let i = 0;
        let proof_length = Vector::length(sibling_nodes);
        while (i < proof_length) {
            let sibling = *Vector::borrow(sibling_nodes, i);
            let bit = get_bit_at_from_msb(path, proof_length - i - 1);
            let internal_node = if (bit) {
                SMTNode{ hash1: sibling, hash2: current_hash }
            } else {
                SMTNode{ hash1: current_hash, hash2: sibling }
            };
            current_hash = StructuredHash::hash(SPARSE_MERKLE_INTERNAL_NODE, &internal_node);
            i = i + 1;
        };
        current_hash
    }

    public fun placeholder(): vector<u8> {
        create_literal_hash(&SPARSE_MERKLE_PLACEHOLDER_HASH_LITERAL)
    }

    public fun create_literal_hash(word: &vector<u8>): vector<u8> {
        if (Vector::length(word)  <= 32) {
            let lenZero = 32 - Vector::length(word);
            let i = 0;
            let r = *word;
            while (i < lenZero) {
                Vector::push_back(&mut r, 0);
                i = i + 1;
            };
            return r
        };
        abort ERROR_LITERAL_HASH_WRONG_LENGTH
    }

    #[test]
    fun test_create_literal_hash() {
        let word = b"SPARSE_MERKLE_PLACEHOLDER_HASH";
        let r = create_literal_hash(&word);
        assert!(r == x"5350415253455f4d45524b4c455f504c414345484f4c4445525f484153480000", 1115);
    }

    fun hash_key(key: &vector<u8>): vector<u8> {
        Hash::sha3_256(*key)
    }

    fun hash_value(value: &vector<u8>): vector<u8> {
        StructuredHash::hash(BLOB_HASH_PREFIX, value)
    }

    fun count_common_prefix(data1: &vector<u8>, data2: &vector<u8>): u64 {
        let count = 0;
        let i = 0;
        while ( i < Vector::length(data1) * 8) {
            if (get_bit_at_from_msb(data1, i) == get_bit_at_from_msb(data2, i)) {
                count = count + 1;
            } else {
                break
            };
            i = i + 1;
        };
        count
    }

    fun get_bit_at_from_msb(data: &vector<u8>, index: u64): bool {
        let pos = index / 8;
        let bit = (7 - index % 8);
        (*Vector::borrow(data, pos) >> (bit as u8)) & 1u8 != 0
    }
}

module StructuredHash {
    use StarcoinFramework::Hash;
    use StarcoinFramework::Vector;
    use StarcoinFramework::BCS;

    const STARCOIN_HASH_PREFIX: vector<u8> = b"STARCOIN::";

    public fun hash<MoveValue: store>(structure: vector<u8>, data: &MoveValue): vector<u8> {
        let prefix_hash = Hash::sha3_256(concat(&STARCOIN_HASH_PREFIX, structure));
        let bcs_bytes = BCS::to_bytes(data);
        Hash::sha3_256(concat(&prefix_hash, bcs_bytes))
    }

    fun concat(v1: &vector<u8>, v2: vector<u8>): vector<u8> {
        let data = *v1;
        Vector::append(&mut data, v2);
        data
    }
}

}