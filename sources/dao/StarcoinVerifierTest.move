address StarcoinFramework {
module StarcoinVerifierTest {
    #[test]
    use StarcoinFramework::Vector;
    #[test]
    use StarcoinFramework::Debug;
    #[test]
    use StarcoinFramework::StarcoinVerifier;

    #[test]
    fun test_create_literal_hash() {
        let word = b"SPARSE_MERKLE_PLACEHOLDER_HASH";
        let r = StarcoinVerifier::create_literal_hash(&word);
        assert!(r == x"5350415253455f4d45524b4c455f504c414345484f4c4445525f484153480000", 111);
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

        let proof = StarcoinVerifier::new_state_proof(
            StarcoinVerifier::new_sparse_merkle_proof(
                account_proof_side_nodes,
                StarcoinVerifier::new_smt_node(
                    x"5852858a6bd0e1607d7b0664fc35762466bbed4edfd80041b4318357f99abb73",
                    x"bbc50d7538140e5d721dffad1b799effe4393b552581400f07ec9e8aac2e506f",
                ),
            ),
            x"020120e3b097bd2d35e749599f5ab323dd8a1f9ad876a38a006b9f07068c3d662cc3d301206ceb24e0929653e882cb7dd3f4a4914a1e427f502c4f90c52ec6e591e1a2a94c",
            StarcoinVerifier::new_sparse_merkle_proof(
                state_proof_side_nodes,
                StarcoinVerifier::new_smt_node(
                    x"3173da2c06e9caf448ab60e9a475d0278c842810d611a25063b85f9cfd7605f8",
                    x"c6a66554c88f2e25c251a49f068574930681944e906f1c66fab1b7cfc42d9eb0",
                ),
            ),
        );
        //        _ = proof;
        //        _ = state_root;
        //        _ = account_address;
        //        _ = resource_struct_tag;
        //        _ = state;
        let b = StarcoinVerifier::verify_resource_state_proof(
            &proof,
            &state_root,
            account_address,
            &resource_struct_tag,
            &state,
        );
        Debug::print(&b);
        assert!(b, 111);
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

        let leaf_node = StarcoinVerifier::new_smt_node(
            x"313fcf74be39e19d75b6d028d28cf3e43efd92e95abd580971b6552667e69ee0",
            x"e5c11e706a534b191358b9954c2f03c371162d950ff81a7cd3d20701bbaec525",
        );
        let expected_root = x"0f30a41872208c6324fa842889315b14f9be6f3dd0d5050686317adfdd0cda60";
        let key = x"8c109349c6bd91411d6bc962e080c4a312546f6b656e537761704661726d426f6f73740855736572496e666f020700000000000000000000000000000001035354430353544300078c109349c6bd91411d6bc962e080c4a30453544152045354415200";
        //
        // Above key is this StructTag BCS serialized bytes:
        //
        //    private StructTag getTestStructTag() {
        //        List<TypeTag> typeParams = new ArrayList<>();
        //        StructTag innerStructTag1 = new StructTag(AccountAddress.valueOf(HexUtils.hexToByteArray("0x00000000000000000000000000000001")),
        //                new Identifier("STC"), new Identifier("STC"), Collections.emptyList());
        //        StructTag innerStructTag2 = new StructTag(AccountAddress.valueOf(HexUtils.hexToByteArray("0x8c109349c6bd91411d6bc962e080c4a3")),
        //                new Identifier("STAR"), new Identifier("STAR"), Collections.emptyList());
        //        typeParams.add(new TypeTag.Struct(innerStructTag1));
        //        typeParams.add(new TypeTag.Struct(innerStructTag2));
        //        StructTag structTag = new StructTag(AccountAddress.valueOf(HexUtils.hexToByteArray("0x8c109349c6bd91411d6bc962e080c4a3")),
        //                new Identifier("TokenSwapFarmBoost"), new Identifier("UserInfo"), typeParams);
        //        return structTag;
        //    }
        let value = x"fa000000000000007b161ceeef010000000000000000000000000000000000000000000000000000";

        let b = StarcoinVerifier::verify_sm_proof_by_key_value(&side_nodes, &leaf_node, &expected_root, &key, &value);
        Debug::print<bool>(&b);
        assert!(b, 111)
    }


    #[test]
    fun test_verify_sm_proof_by_key_value_2() {
        let side_nodes: vector<vector<u8>> = Vector::empty();
        let leaf_data: StarcoinVerifier::SMTNode = StarcoinVerifier::empty_smt_node();
        let expected_root: vector<u8> = StarcoinVerifier::placeholder();
        let key: vector<u8> = b"random key";
        let value: vector<u8> = Vector::empty(); //x""
        let b = StarcoinVerifier::verify_sm_proof_by_key_value(&side_nodes, &leaf_data, &expected_root, &key, &value);
        //Debug::print(&b);
        assert!(b, 111);

        value = b"random value";
        b = StarcoinVerifier::verify_sm_proof_by_key_value(&side_nodes, &leaf_data, &expected_root, &key, &value);
        assert!(!b, 111);
    }
}
}
