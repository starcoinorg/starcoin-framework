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

    public fun verify_resource_state_proof(state_proof: &StateProof, state_root: &vector<u8>,
                                           account_address: address, resource_struct_tag: &vector<u8>,
                                           state: &vector<u8>): bool {
        let accountState: AccountState = bcs_deserialize_account_state(&state_proof.account_state);
        assert!(Vector::length(&accountState.storage_roots) > ACCOUNT_STORAGE_INDEX_RESOURCE, ERROR_ACCOUNT_STORAGE_ROOTS);

        // First, verify state for storage root.
        let storageRoot = Option::borrow(Vector::borrow(&accountState.storage_roots, ACCOUNT_STORAGE_INDEX_RESOURCE));
        let ok: bool = verify_sm_proof_by_key_value(&state_proof.proof.siblings,
            &state_proof.proof.leaf,
            storageRoot,
            resource_struct_tag, // resource struct tag BCS serialized as key
            state);
        if (!ok) {
            return false
        };

        // Then, verify account state for global state root.
        ok = verify_sm_proof_by_key_value(&state_proof.account_proof.siblings,
            &state_proof.account_proof.leaf,
            state_root,
            &BCS::to_bytes<address>(&account_address), // account address as key
            &state_proof.account_state,
        );
        ok
    }

    #[test]
    fun test_verify_resource_state_proof() {
        let state_root = x"99163c0fc319b62c3897ada8f97881e396e33b30383f47e23d93aaed07d6806d";
        let account_address = @0x8c109349c6bd91411d6bc962e080c4a3;
        let state = x"";
        let resource_struct_tag = x"8c109349c6bd91411d6bc962e080c4a312546f6b656e537761704661726d426f6f73740855736572496e666f020700000000000000000000000000000001035354430353544300078c109349c6bd91411d6bc962e080c4a30453544152045354415200";

        let account_proof_side_nodes = Vector::empty<vector<u8>>();
        Vector::push_back(&mut account_proof_side_nodes, x"08525e1e7220b4a64f3fd89fc931b0beff7490607b0716faddf3bc942747386e");
        Vector::push_back(&mut account_proof_side_nodes, x"5cc7a4f20b31bddd3294b1e314fbf6bb791953ac6444d8a0ac4e5e7c6480812e");
        Vector::push_back(&mut account_proof_side_nodes, x"280cbb1fd1f796242ebea71068c798ef4a7a5b1da07f9422e288b746f67c1e06");
        Vector::push_back(&mut account_proof_side_nodes, x"159bdffefc930493129b8897e202bfcf17d7d3c74aa47d1d5b6c2f896b0d98f4");
        Vector::push_back(&mut account_proof_side_nodes, x"de769cbc998a1b2c4367adb540c4a75db394e20c0eb9bb4d5c0087624102ee0d");
        Vector::push_back(&mut account_proof_side_nodes, x"785f187c658ac42cb872ea7e18b88062b4870715414b6e3e872bf84d14d28d09");
        Vector::push_back(&mut account_proof_side_nodes, x"ccb4c4d91cfccf082b1e66a469d8d9e8ee2b433b24f7afda0a955e40d32a6ca4");
        Vector::push_back(&mut account_proof_side_nodes, x"b43df3454127a4a04542d6ba268e3a55bda95c4fb658627a2962744c05bc1349");
        Vector::push_back(&mut account_proof_side_nodes, x"4a0f4d65ebfc745229afba2edb4c68e5073e6b87db310e955c60adbc9e00d65d");
        Vector::push_back(&mut account_proof_side_nodes, x"7d91edf874ac7c8f7b65e95229e011e844c068cc1a0c81ea8b18cf1245793c21");
        Vector::push_back(&mut account_proof_side_nodes, x"0e381be317564409496aa53d9d7a734884116d0073495a00378ebb201ed50fd1");
        Vector::push_back(&mut account_proof_side_nodes, x"f6e248a05d4a69a606bfc8b7cd207948c9c3f574b46c01838cff1ffef9a05df3");
        Vector::push_back(&mut account_proof_side_nodes, x"c45577b225f3a1eb7c04fbe64c9a07a330a32a6eca8754e8f4a95ec869610dc6");
        Vector::push_back(&mut account_proof_side_nodes, x"f3e6cf306092cdbd478d2ff7153fbf688d5c3d1e3d62d2eab94eb1083c074306");

        let state_proof_side_nodes = Vector::empty<vector<u8>>();
        Vector::push_back(&mut state_proof_side_nodes, x"66d13f603dda1966f5da6cb1593f7beece2bed60447cfa3af6c8e554379af086");
        Vector::push_back(&mut state_proof_side_nodes, x"5350415253455f4d45524b4c455f504c414345484f4c4445525f484153480000");
        Vector::push_back(&mut state_proof_side_nodes, x"51294505d6efd9fbf1ab69acbab1f96affbb5a8d21ec0cb677749335ca0ca69b");
        Vector::push_back(&mut state_proof_side_nodes, x"8624870eed10be3da5bd4c844d2e353b1fa669fac2def2dc50ef41f83f0b88a0");
        Vector::push_back(&mut state_proof_side_nodes, x"ca94481b3ed045922fad7d8bf592af16c2c5c9253c79136ca3bed73ea3c23699");
        Vector::push_back(&mut state_proof_side_nodes, x"6ac0af801ccb0a6ceb5c6ac82c7c20e29b9e2c69ee12bb4a3c5395e4400f4bfb");
        Vector::push_back(&mut state_proof_side_nodes, x"4c2daa765e34f38cde5dcc20ea4b10264c10427ba1a02388077f33befb422677");
        Vector::push_back(&mut state_proof_side_nodes, x"8d7893145f15bb8aeccf0424f267b6aeb807b20889f8498f5f15f4defe0f806f");

        let proof = new_state_proof(
            new_sparse_merkle_proof(
                account_proof_side_nodes,
                new_smt_node(
                    x"5852858a6bd0e1607d7b0664fc35762466bbed4edfd80041b4318357f99abb73",
                    x"bbc50d7538140e5d721dffad1b799effe4393b552581400f07ec9e8aac2e506f",
                ),
            ),
            x"020120e3b097bd2d35e749599f5ab323dd8a1f9ad876a38a006b9f07068c3d662cc3d301206ceb24e0929653e882cb7dd3f4a4914a1e427f502c4f90c52ec6e591e1a2a94c",
            new_sparse_merkle_proof(
                state_proof_side_nodes,
                new_smt_node(
                    x"3173da2c06e9caf448ab60e9a475d0278c842810d611a25063b85f9cfd7605f8",
                    x"c6a66554c88f2e25c251a49f068574930681944e906f1c66fab1b7cfc42d9eb0",
                ),
            ),
        );

        let b = verify_resource_state_proof(
            &proof,
            &state_root,
            account_address,
            &resource_struct_tag,
            &state,
        );
        assert!(b, 1110);
    }

    /// Verify sparse merkle proof by key and value.
    public fun verify_sm_proof_by_key_value(side_nodes: &vector<vector<u8>>, leaf_data: &SMTNode, expected_root: &vector<u8>, key: &vector<u8>, value: &vector<u8>): bool {
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
                if (!(count_common_prefix(&leaf_data.hash1, &path) >= Vector::length(side_nodes))) {
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

        current_hash = compute_sm_root_by_path_and_node_hash(side_nodes, &path, &current_hash);
        current_hash == *expected_root
    }

    #[test]
    fun test_verify_sm_proof_by_key_value() {
        let side_nodes = Vector::empty<vector<u8>>();
        Vector::push_back(&mut side_nodes, x"24521d9cbd1bb73959b54a3993159b125f1500221e1455490189466858725948");
        Vector::push_back(&mut side_nodes, x"a5f028948c522a35e6a75775de25c097ffefee7d63c4949482e38df0428b3b6d");
        Vector::push_back(&mut side_nodes, x"33c4f5958cb1a1875eb1be51d2601e13f5e5a4f5518d578d4c6368ac0af6d648");
        Vector::push_back(&mut side_nodes, x"d9ff5eeb7dde4db48f44b79d54f7bb162b5a4ce32d583ee91431dea52d6fced1");
        Vector::push_back(&mut side_nodes, x"a2dbe6355af9d9f00d84d2e944b97841de2221451887e0fadbc957dbe39d1a3e");
        Vector::push_back(&mut side_nodes, x"3cc075bcc91302e92fb6a23880669085a0436a12e6e407aea6e7192344f41667");
        Vector::push_back(&mut side_nodes, x"fc8d88d2484e154836aca3afd927fec8a8168667d24ceaf5e4d3c22722020609");

        let leaf_node = new_smt_node(
            x"313fcf74be39e19d75b6d028d28cf3e43efd92e95abd580971b6552667e69ee0",
            x"e5c11e706a534b191358b9954c2f03c371162d950ff81a7cd3d20701bbaec525",
        );
        let expected_root = x"0f30a41872208c6324fa842889315b14f9be6f3dd0d5050686317adfdd0cda60";
        let key = x"8c109349c6bd91411d6bc962e080c4a312546f6b656e537761704661726d426f6f73740855736572496e666f020700000000000000000000000000000001035354430353544300078c109349c6bd91411d6bc962e080c4a30453544152045354415200";
        // Above key is this StructTag BCS serialized bytes:
        let value = x"fa000000000000007b161ceeef010000000000000000000000000000000000000000000000000000";

        let b = verify_sm_proof_by_key_value(&side_nodes, &leaf_node, &expected_root, &key, &value);
        assert!(b, 1112)
    }

    #[test]
    fun test_verify_sm_proof_by_key_value_2() {
        let side_nodes: vector<vector<u8>> = Vector::empty();
        let leaf_data: SMTNode = empty_smt_node();
        let expected_root: vector<u8> = placeholder();
        let key: vector<u8> = b"random key";
        let value: vector<u8> = Vector::empty(); //x""
        let b = verify_sm_proof_by_key_value(&side_nodes, &leaf_data, &expected_root, &key, &value);
        assert!(b, 1113);

        value = b"random value";
        b = verify_sm_proof_by_key_value(&side_nodes, &leaf_data, &expected_root, &key, &value);
        assert!(!b, 1114);
    }

    public fun compute_sm_root_by_path_and_node_hash(side_nodes: &vector<vector<u8>>, path: &vector<u8>, node_hash: &vector<u8>): vector<u8> {
        let current_hash = *node_hash;
        let i = 0;
        let proof_length = Vector::length(side_nodes);
        while (i < proof_length) {
            let sibling = *Vector::borrow(side_nodes, i);
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