module StarcoinFramework::SnapshotUtil{
    #[test_only]
    use StarcoinFramework::Option;
    use StarcoinFramework::Token;
    #[test_only]
    use StarcoinFramework::Debug;
    use StarcoinFramework::Vector;
    use StarcoinFramework::BCS;

    #[test]
    fun test_snapshot_proof_deserialize() {
        // barnard, block number 6201718
        let snpashot_raw_proofs = x"0145016bfb460477adf9dd0455d3de2fc7f21101000000000000000664616f313031000a69616d67655f64617461005704000000000000640000000000000000000000000000000145020120cc969848619e507450ebf01437155ab5f2dbb554fe611cb71958855a1b2ec664012035f2374c333a51e46b62b693ebef25b9be2cefde8d156db08bff28f9a0b87742012073837fcf4e69ae60e18ea291b9f25c86ce8053c6ee647a2b287083327c67dd7e20dac300fb581a6df034a44a99e8eb1cd55c7dd8f0a9e78f1114a6b4eda01d834e0e2078179a07914562223d40068488a0d65673b3b2681642633dc33904575f8f070b20b7c2a21de200ca82241e5e480e922258591b219dd56c24c4d94299020ee8299a204f541db82477510f699c9d75dd6d8280639a1ec9d0b90962cbc0c2b06514a78b20cacfce99bb564cfb70eec6a61bb76b9d56eb1b626d7fa231338792e1f572a8df20da6c1337ca5d8f0fa18b2db35844c610858a710edac35206ef0bf52fd32a4ac920ef6fb8f82d32ca2b7c482b7942505e6492bffa3ed14dd635bae16a14b4ac32e6202ad7b36e08e7b5d208de8eec1ef1964dc8433ccca8ac4632f36054926e858ac32027d5ccc8aa57b964ad50334f62821188b89945ae999ad0bb31cdc16df1763f8120afa983813953d6aa9563db12d5e443c9e8114c3482867c95a661a240d6f0e0ec206466ac318f5d9deb7b64b12622a0f4bed2f19379667d18b6ccfeaa84171d812f20eb45021b7b39887925a5b49018cdc8ad44c14835a42e5775666315f4a3e0ba42204c2b365a78e4615873772a0f039a7326150472b4923d40640863dbe42a2351eb20825d0c21dd1105faf528934842419f8661d695fc72ec6ef8036f5d03359126d3205d806c027eecdfbc3960e68c5997718a0709a6079f96e1af3ffe21878ada2b830120fa60f8311936961f5e9dee5ccafaea83ed91c6eaa04a7dea0b85a38cf84d8564207ef6a85019523861474cdf47f4db8087e5368171d95cc2c1e57055a72ca39cb704208db1e4e4c864882bd611b1cda02ca30c43b3c7bc56ee7cb174598188da8b49ef2063b3f1e4f05973830ba40e0c50c4e59f31d3baa5643d19676ddbacbf797bf6b720b39d31107837c1751d439706c8ddac96f8c148b8430ac4f40546f33fb9871e4320fb0ad035780bb8f1c6481bd674ccad0948cd2e8e6b97c08e582f67cc26918fb3";
        //        let state_root = x"d5cd5dc44799c989a84b7d4a810259f373b13a9bf8ee21ecbed0fab264e2090d";
        //        let account_address = @0x6bfb460477adf9dd0455d3de2fc7f211;
        //        // 0x00000000000000000000000000000001::Account::Balance<0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        //        let resource_struct_tag = x"00000000000000000000000000000001074163636f756e740742616c616e636501078c109349c6bd91411d6bc962e080c4a30453544152045354415200";

        let offset = 0;
        let (state_option, offset) = BCS::deserialize_option_bytes(&snpashot_raw_proofs, offset);
        let state = Option::get_with_default(&mut state_option, Vector::empty());
        Debug::print(&state);
//        Debug::print(&x"016bfb460477adf9dd0455d3de2fc7f21101000000000000000664616f313031000a69616d67655f6461746100570400000000000064000000000000000000000000000000");
        Debug::print(&offset);
        let (_account_state_option, offset) = BCS::deserialize_option_bytes(&snpashot_raw_proofs, offset);
        let _account_state = Option::get_with_default(&mut _account_state_option, Vector::empty());
        Debug::print(&110110);
        Debug::print(&_account_state);
        Debug::print(&offset);

        let (_account_proof_leaf1_option, _account_proof_leaf2_option, offset) = BCS::deserialize_option_tuple(&snpashot_raw_proofs, offset);
        let _account_proof_leaf1 = Option::get_with_default(&mut _account_proof_leaf1_option, Vector::empty());
        let _account_proof_leaf2 = Option::get_with_default(&mut _account_proof_leaf2_option, Vector::empty());
        Debug::print(&offset);

        let account_proof_leaf_nodes = Vector::empty<vector<u8>>();
        Vector::push_back(&mut account_proof_leaf_nodes, x"73837fcf4e69ae60e18ea291b9f25c86ce8053c6ee647a2b287083327c67dd7e");
        Vector::push_back(&mut account_proof_leaf_nodes, x"dac300fb581a6df034a44a99e8eb1cd55c7dd8f0a9e78f1114a6b4eda01d834e");
        Debug::print(&account_proof_leaf_nodes);
        Debug::print(&_account_proof_leaf1);
        Debug::print(&_account_proof_leaf2);
        Debug::print(&offset);
        let (_account_proof_siblings, offset) = BCS::deserialize_bytes_vector(&snpashot_raw_proofs, offset);

        let (_account_state_proof_leaf1_option, _account_state_proof_leaf2_option, offset) = BCS::deserialize_option_tuple(&snpashot_raw_proofs, offset);
        let _account_state_proof_leaf1 = Option::get_with_default(&mut _account_state_proof_leaf1_option, Vector::empty());
        let _account_state_proof_leaf2 = Option::get_with_default(&mut _account_state_proof_leaf2_option, Vector::empty());
        Debug::print(&_account_state_proof_leaf1);
        Debug::print(&_account_state_proof_leaf2);
        let (_account_state_proof_siblings, _offset) = BCS::deserialize_bytes_vector(&snpashot_raw_proofs, offset);

        Debug::print(&_account_state_proof_siblings);
        Debug::print(&_offset);
    }

    #[test]
    fun test_snapshot_proof_deserialize_with_empty_state() {
        let snpashot_raw_proofs = x"00012402000120161d07d221d7b31df7d29d45926b6444fa07e8b5f1021dd704fc1def6738011d0120e76e5b4bcf07c7e3864b399cfca72b0863678487813a1cfe8df48cf35729def820f135bf4b03034b8a3c21950231d3c4fe8136442064c9809d593e78ed4775f0b6042072659a01138c59e84e8e608e0d1908be7289c47f8f4080a14eaa852d1ace35f420bb3f0cc0cde2e05ba56a26bbc15161a930af6f66a65091b285870c557e8bc07a205350415253455f4d45524b4c455f504c414345484f4c4445525f484153480000204bb30b63b4c41126a2f8c98a3d66f351160732481ae633da47d647976004942e000420fbd31ef1cbaf26c37259325e5ee71625e67f7ecf8311cbf67758431d65ae8f5c205350415253455f4d45524b4c455f504c414345484f4c4445525f484153480000207460a35efdba40ce6ec4442b32e0bf39fee59a69887e18f118f49b325434fda820417ddaf2cf3fce9b50dd9b16e1ea545d65d480b855bfd0aed0a819a6a7d0f641";

        let offset = 0;
        let (state_option, offset) = BCS::deserialize_option_bytes(&snpashot_raw_proofs, offset);
        Debug::print(&state_option);
        let state = Option::get_with_default(&mut state_option, Vector::empty());
        Debug::print(&state);
        Debug::print(&offset);
    }

    /// Struct Tag which identify a unique Struct.
    struct StructTag0 has drop,copy,store {
        addr: address,
        module_name: vector<u8>,
        name: vector<u8>,
        types: vector<u8>,
    }

    struct TypeTag0 has drop,copy,store {
        variant_index: u8,  // struct type tag variant index, must set be 7
        struct_tag: StructTag0,
    }

    struct StructTag1 has drop,copy,store {
        addr: address,
        module_name: vector<u8>,
        name: vector<u8>,
        types: vector<TypeTag0>,
    }

    struct TypeTag1 has drop,copy,store {
        variant_index: u8, // struct type tag variant index, must set be 7
        struct_tag: StructTag1,
    }

    struct StructTag2 has drop,copy,store {
        addr: address,
        module_name: vector<u8>,
        name: vector<u8>,
        types: vector<TypeTag1>,
    }

    public fun get_sturct_tag<DAOT: store>(): vector<u8> {
        let struct_tags = generate_struct_tag<DAOT>();
        BCS::to_bytes(&struct_tags)
    }

    //  0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DAOMember<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>, 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DAOMemberBody<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>>
    fun generate_struct_tag<DAOT: store>(): StructTag2{
        let dao_struct_tag = get_dao_struct_tag<DAOT>();
        let dao_type_tag = TypeTag0 {
            variant_index: 7,
            struct_tag: dao_struct_tag,
        };
        let dao_type_tags = Vector::empty<TypeTag0>();
        Vector::push_back(&mut dao_type_tags, dao_type_tag);

        // 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DAOMember
        let dao_member_struct_tag = StructTag1 {
            addr: @0x00000000000000000000000000000001,
            module_name: b"DAOSpace",
            name: b"DAOMember",
            types: *&dao_type_tags
        };

        // 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DAOMemberBody
        let dao_member_body_struct_tag = StructTag1 {
            addr: @0x00000000000000000000000000000001,
            module_name: b"DAOSpace",
            name: b"DAOMemberBody",
            types: *&dao_type_tags
        };

        let dao_member_type_tag = TypeTag1 {
            variant_index: 7,
            struct_tag: dao_member_struct_tag,
        };
        let dao_member_body_type_tag = TypeTag1 {
            variant_index: 7,
            struct_tag: dao_member_body_struct_tag,
        };
        let type_tags = Vector::empty<TypeTag1>();
        Vector::push_back(&mut type_tags, dao_member_type_tag);
        Vector::push_back(&mut type_tags, dao_member_body_type_tag);

        StructTag2 {
            addr: @0x00000000000000000000000000000001,
            module_name: b"IdentifierNFT",
            name: b"IdentifierNFT",
            types: type_tags,
        }
    }

    fun get_dao_struct_tag<DAOT: store>(): StructTag0{
        // DAOT is also TokenT
        let token_code = Token::token_code<DAOT>();
        let token_code_bcs = BCS::to_bytes(&token_code);

        let offset = 0;
        let (address, offset) = BCS::deserialize_address(&token_code_bcs, offset);
        let (module_name, offset) = BCS::deserialize_bytes(&token_code_bcs, offset);
        let (name, _offset) = BCS::deserialize_bytes(&token_code_bcs, offset);

        StructTag0 {
            addr: address,
            module_name,
            name,
            types: Vector::empty<u8>(),
        }
    }

    #[test]
    fun test_get_sturct_tag_bcs() {
        // 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO
        let dao_struct_tag = StructTag0 {
            addr: @0x6bfb460477adf9dd0455d3de2fc7f211,
            module_name: b"SBTModule",
            name: b"SbtTestDAO",
            types: Vector::empty<u8>(),
        };

        let dao_type_tag = TypeTag0 {
            variant_index: 7,
            struct_tag: dao_struct_tag,
        };
        let dao_type_tags = Vector::empty<TypeTag0>();
        Vector::push_back(&mut dao_type_tags, dao_type_tag);

        // 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DAOMember
        let dao_member_struct_tag = StructTag1 {
            addr: @0x6bfb460477adf9dd0455d3de2fc7f211,
            module_name: b"SBTModule",
            name: b"DAOMember",
            types: *&dao_type_tags
        };

        // 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DAOMemberBody
        let dao_member_body_struct_tag = StructTag1 {
            addr: @0x6bfb460477adf9dd0455d3de2fc7f211,
            module_name: b"SBTModule",
            name: b"DAOMemberBody",
            types: *&dao_type_tags
        };

        let dao_member_type_tag = TypeTag1 {
            variant_index: 7,
            struct_tag: dao_member_struct_tag,
        };
        let dao_member_body_type_tag = TypeTag1 {
            variant_index: 7,
            struct_tag: dao_member_body_struct_tag,
        };
        let type_tags = Vector::empty<TypeTag1>();
        Vector::push_back(&mut type_tags, dao_member_type_tag);
        Vector::push_back(&mut type_tags, dao_member_body_type_tag);

        let struct_tags = StructTag2 {
            addr: @0x00000000000000000000000000000001,
            module_name: b"IdentifierNFT",
            name: b"IdentifierNFT",
            types: type_tags,
        };

        let resource_struct_tags = BCS::to_bytes(&struct_tags);
        Debug::print(&resource_struct_tags);
        let expect_resource_struct_tags = x"000000000000000000000000000000010d4964656e7469666965724e46540d4964656e7469666965724e465402076bfb460477adf9dd0455d3de2fc7f211095342544d6f64756c650944414f4d656d62657201076bfb460477adf9dd0455d3de2fc7f211095342544d6f64756c650a5362745465737444414f00076bfb460477adf9dd0455d3de2fc7f211095342544d6f64756c650d44414f4d656d626572426f647901076bfb460477adf9dd0455d3de2fc7f211095342544d6f64756c650a5362745465737444414f00";
        Debug::print(&expect_resource_struct_tags);

        Debug::print(&b"IdentifierNFT");
        Debug::print(&x"6bfb460477adf9dd0455d3de2fc7f211");
        Debug::print(&b"SBTModule");
        Debug::print(&b"DAOMember");
        Debug::print(&b"DAOMemberBody");

        assert!(expect_resource_struct_tags == resource_struct_tags, 8010);
    }


}