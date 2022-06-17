address StarcoinFramework {
module StarcoinVerifier {
    use StarcoinFramework::Vector;
    use StarcoinFramework::Option;
    use StarcoinFramework::BCS;
    //use StarcoinFramework::Bit;
    use StarcoinFramework::StructuredHash;
    use StarcoinFramework::BCSDeserializer;
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
        let (vec, _) = BCSDeserializer::deserialize_option_bytes_vector(data, 0);
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

    public fun new_state_proof_from_proof(account_proof_leaf: vector<vector<u8>>,
                                          account_proof_siblings: vector<vector<u8>>,
                                          account_state: vector<u8>,
                                          account_state_proof_leaf: vector<vector<u8>>,
                                          account_state_proof_siblings: vector<vector<u8>>): StateProof{
        let (account_proof_leaf_hash1, account_proof_leaf_hash2) = (Vector::empty(), Vector::empty());
        let (account_state_proof_leaf_hash1, account_state_proof_leaf_hash2) = (Vector::empty(), Vector::empty());

        if (Vector::length(&account_proof_leaf) >= 2){
            account_proof_leaf_hash1 = *Vector::borrow(&account_proof_leaf, 0);
            account_proof_leaf_hash2 = *Vector::borrow(&account_proof_leaf, 1);
        };
        if (Vector::length(&account_state_proof_leaf) >= 2){
            account_state_proof_leaf_hash1 = *Vector::borrow(&account_state_proof_leaf, 0);
            account_state_proof_leaf_hash2 = *Vector::borrow(&account_state_proof_leaf, 1);
        };
        let proof = new_state_proof(
            new_sparse_merkle_proof(
                account_proof_siblings,
                new_smt_node(
                    account_proof_leaf_hash1,
                    account_proof_leaf_hash2,
                ),
            ),
            account_state,
            new_sparse_merkle_proof(
                account_state_proof_siblings,
                new_smt_node(
                    account_state_proof_leaf_hash1,
                    account_state_proof_leaf_hash2,
                ),
            ),
        );
        proof
    }


    //    struct StarcoinMerkle has key {
    //        merkle_root: vector<u8>,
    //    }

    //    public fun create(signer: &signer, merkle_root: vector<u8>) {
    //        let s = StarcoinMerkle{
    //            merkle_root
    //        };
    //        move_to(signer, s);
    //    }

    //    public fun verify_on(merkle_address: address, account_address: vector<u8>, account_state_root_hash: vector<u8>, proofs: vector<vector<u8>>): bool
    //    acquires StarcoinMerkle {
    //        let merkle = borrow_global<StarcoinMerkle>(merkle_address);
    //
    //        verify(*&merkle.merkle_root, account_address, account_state_root_hash, proofs)
    //    }


    public fun verify_resource_state_proof(state_proof: &StateProof, state_root: &vector<u8>,
                                           account_address: address, resource_struct_tag: &vector<u8>,
                                           state: &vector<u8>): bool {
        let accountState: AccountState = bcs_deserialize_account_state(&state_proof.account_state);
        assert!(Vector::length(&accountState.storage_roots) > ACCOUNT_STORAGE_INDEX_RESOURCE, ERROR_ACCOUNT_STORAGE_ROOTS);
        //
        // First, verify state for storage root.
        //
        let storageRoot = Option::borrow(Vector::borrow(&accountState.storage_roots, ACCOUNT_STORAGE_INDEX_RESOURCE));
        let ok: bool = verify_sm_proof_by_key_value(&state_proof.proof.siblings,
            &state_proof.proof.leaf,
            storageRoot,
            resource_struct_tag, // resource struct tag BCS serialized as key
            state);
        if (!ok) {
            return false
        };
        //
        // Then, verify account state for global state root.
        //
        ok = verify_sm_proof_by_key_value(&state_proof.account_proof.siblings,
            &state_proof.account_proof.leaf,
            state_root,
            &BCS::to_bytes<address>(&account_address), // account address as key
            &state_proof.account_state,
        );
        ok
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

    fun hash_key(key: &vector<u8>): vector<u8> {
        Hash::sha3_256(*key)
    }

    fun hash_value(value: &vector<u8>): vector<u8> {
        StructuredHash::hash(BLOB_HASH_PREFIX, value)
    }


    //
    //module Bit {
    //    use 0x1::Vector;
    //
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
    //
    //}
    //
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


//    module StarcoinVerifierScripts {
//        use 0x18351d311d32201149a4df2a9fc2db8a::StarcoinVerifier;
//        public(script) fun create(signer: signer, merkle_root: vector<u8>) {
//            StarcoinVerifier::create(&signer, merkle_root);
//        }
//    }
}