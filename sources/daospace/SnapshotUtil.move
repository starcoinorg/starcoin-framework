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
        let state = Option::extract(&mut state_option);
        Debug::print(&state);
        Debug::print(&x"016bfb460477adf9dd0455d3de2fc7f21101000000000000000664616f313031000a69616d67655f6461746100570400000000000064000000000000000000000000000000");
        Debug::print(&offset);
        let (_account_state_option, offset) = BCS::deserialize_option_bytes(&snpashot_raw_proofs, offset);
        let _account_state = Option::extract(&mut _account_state_option);
        Debug::print(&110110);
        Debug::print(&_account_state);
        Debug::print(&offset);

        let (_account_proof_leaf1_option, _account_proof_leaf2_option, offset) = BCS::deserialize_option_tuple(&snpashot_raw_proofs, offset);
        let _account_proof_leaf1 = Option::extract(&mut _account_proof_leaf1_option);
        let _account_proof_leaf2 = Option::extract(&mut _account_proof_leaf2_option);
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
        let _account_state_proof_leaf1 = Option::extract(&mut _account_state_proof_leaf1_option);
        let _account_state_proof_leaf2 = Option::extract(&mut _account_state_proof_leaf2_option);
        Debug::print(&_account_state_proof_leaf1);
        Debug::print(&_account_state_proof_leaf2);
        let (_account_state_proof_siblings, _offset) = BCS::deserialize_bytes_vector(&snpashot_raw_proofs, offset);

        Debug::print(&_account_state_proof_siblings);
        Debug::print(&_offset);
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

    public fun get_sturct_tag<DaoT: store>(): vector<u8> {
        let struct_tags = generate_struct_tag<DaoT>();
        BCS::to_bytes(&struct_tags)
    }

    //  0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMember<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>, 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMemberBody<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>>
    fun generate_struct_tag<DaoT: store>(): StructTag2{
        let dao_struct_tag = get_dao_struct_tag<DaoT>();
        let dao_type_tag = TypeTag0 {
            variant_index: 7,
            struct_tag: dao_struct_tag,
        };
        let dao_type_tags = Vector::empty<TypeTag0>();
        Vector::push_back(&mut dao_type_tags, dao_type_tag);

        // 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMember
        let dao_member_struct_tag = StructTag1 {
            addr: @0x00000000000000000000000000000001,
            module_name: b"DAOSpace",
            name: b"DaoMember",
            types: *&dao_type_tags
        };

        // 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMemberBody
        let dao_member_body_struct_tag = StructTag1 {
            addr: @0x00000000000000000000000000000001,
            module_name: b"DAOSpace",
            name: b"DaoMemberBody",
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

    fun get_dao_struct_tag<DaoT: store>(): StructTag0{
        // DaoT is also TokenT
        let token_code = Token::token_code<DaoT>();
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

        // 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMember
        let dao_member_struct_tag = StructTag1 {
            addr: @0x6bfb460477adf9dd0455d3de2fc7f211,
            module_name: b"SBTModule",
            name: b"DaoMember",
            types: *&dao_type_tags
        };

        // 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMemberBody
        let dao_member_body_struct_tag = StructTag1 {
            addr: @0x6bfb460477adf9dd0455d3de2fc7f211,
            module_name: b"SBTModule",
            name: b"DaoMemberBody",
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
        let expect_resource_struct_tags = x"000000000000000000000000000000010d4964656e7469666965724e46540d4964656e7469666965724e465402076bfb460477adf9dd0455d3de2fc7f211095342544d6f64756c650944616f4d656d62657201076bfb460477adf9dd0455d3de2fc7f211095342544d6f64756c650a5362745465737444414f00076bfb460477adf9dd0455d3de2fc7f211095342544d6f64756c650d44616f4d656d626572426f647901076bfb460477adf9dd0455d3de2fc7f211095342544d6f64756c650a5362745465737444414f00";
        Debug::print(&expect_resource_struct_tags);

        Debug::print(&b"IdentifierNFT");
        Debug::print(&x"6bfb460477adf9dd0455d3de2fc7f211");
        Debug::print(&b"SBTModule");
        Debug::print(&b"DaoMember");
        Debug::print(&b"DaoMemberBody");

        assert!(expect_resource_struct_tags == resource_struct_tags, 8010);
    }


//    "0x6bfb460477adf9dd0455d3de2fc7f211/1/0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMember<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>,0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMemberBody<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>>"
    public fun get_access_path<DaoT: store>(user_addr: address): vector<u8> {

//    0x6bfb460477adf9dd0455d3de2fc7f211/1/0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT<
//        0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMember<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>
//        ,0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMemberBody<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>>

        let access_path_slice_0 = b"/1/0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT";
        let access_path_bytes = Vector::empty();
        Vector::append(&mut access_path_bytes, address_to_hex_string(*&user_addr));
        Vector::append(&mut access_path_bytes, access_path_slice_0);
        Vector::append(&mut access_path_bytes, b"<");
        Vector::append(&mut access_path_bytes, get_access_path_dao_member_slice<DaoT>());
        Vector::append(&mut access_path_bytes, b",");
        Vector::append(&mut access_path_bytes, get_access_path_dao_member_body_slice<DaoT>());
        Vector::append(&mut access_path_bytes, b">");

        access_path_bytes
    }

    #[test]
    fun test_get_access_path(){
        let user_addr = @0x6bfb460477adf9dd0455d3de2fc7f211;

        let module_addr = @0x6bfb460477adf9dd0455d3de2fc7f211;
        let struct_tag_slice = Vector::empty();
        Vector::append(&mut struct_tag_slice, address_to_hex_string(*&module_addr));
        Vector::append(&mut struct_tag_slice, b"::");
        Vector::append(&mut struct_tag_slice, b"SBTModule");
        Vector::append(&mut struct_tag_slice, b"::");
        Vector::append(&mut struct_tag_slice, b"SbtTestDAO");


        let dao_member_slice_0 = b"0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMember";
        let dao_member_slice = Vector::empty();
        Vector::append(&mut dao_member_slice, dao_member_slice_0);
        Vector::append(&mut dao_member_slice, b"<");
        Vector::append(&mut dao_member_slice, copy struct_tag_slice);
        Vector::append(&mut dao_member_slice, b">");

        let dao_member_body_slice_0 = b"0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMemberBody";
        let dao_member_body_slice = Vector::empty();
        Vector::append(&mut dao_member_body_slice, dao_member_body_slice_0);
        Vector::append(&mut dao_member_body_slice, b"<");
        Vector::append(&mut dao_member_body_slice, copy struct_tag_slice);
        Vector::append(&mut dao_member_body_slice, b">");



        let access_path_slice_0 = b"/1/0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT";
        let access_path_bytes = Vector::empty();
        Vector::append(&mut access_path_bytes, address_to_hex_string(*&user_addr));
        Vector::append(&mut access_path_bytes, access_path_slice_0);
        Vector::append(&mut access_path_bytes, b"<");
        Vector::append(&mut access_path_bytes, dao_member_slice);
        Vector::append(&mut access_path_bytes, b",");
        Vector::append(&mut access_path_bytes, dao_member_body_slice);
        Vector::append(&mut access_path_bytes, b">");

        let expect_access_path = b"0x6bfb460477adf9dd0455d3de2fc7f211/1/0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMember<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>,0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMemberBody<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>>";
        Debug::print(&expect_access_path);
        Debug::print(&access_path_bytes);
        assert!(expect_access_path == access_path_bytes, 8012);
    }


    fun get_access_path_dao_member_slice<DaoT:store>(): vector<u8>{
        let dao_member_slice_0 = b"0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMember";
        let slice = Vector::empty();
        Vector::append(&mut slice, dao_member_slice_0);
        Vector::append(&mut slice, b"<");
        Vector::append(&mut slice, struct_tag_to_string<DaoT>());
        Vector::append(&mut slice, b">");

        slice
    }


    fun get_access_path_dao_member_body_slice<DaoT:store>(): vector<u8>{
        let dao_member_body_slice_0 = b"0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMemberBody";
        let slice = Vector::empty();
        Vector::append(&mut slice, dao_member_body_slice_0);
        Vector::append(&mut slice, b"<");
        Vector::append(&mut slice, struct_tag_to_string<DaoT>());
        Vector::append(&mut slice, b">");

        slice
    }

    fun struct_tag_to_string<DaoT:store>(): vector<u8> {
        let struct_tag = get_dao_struct_tag<DaoT>();
        let struct_tag_slice = Vector::empty();
        Vector::append(&mut struct_tag_slice, address_to_hex_string(*&struct_tag.addr));
        Vector::append(&mut struct_tag_slice, b"::");
        Vector::append(&mut struct_tag_slice, *&struct_tag.module_name);
        Vector::append(&mut struct_tag_slice, b"::");
        Vector::append(&mut struct_tag_slice, *&struct_tag.name);

        struct_tag_slice
    }

    const HEX_SYMBOLS: vector<u8> = b"0123456789abcdef";

    /// Converts a `u8` to its  hexadecimal representation with fixed length (in whole bytes).
    /// so the returned String is `2 * length`  in size
    public fun to_hex_string_without_prefix(value: u8): vector<u8> {
        if (value == 0) {
            return b"00"
        };

        let buffer = Vector::empty<u8>();
        let len = 1;
        let i: u64 = 0;
        while (i < len * 2) {
            Vector::push_back(&mut buffer, *Vector::borrow(&mut HEX_SYMBOLS, (value & 0xf as u64)));
            value = value >> 4;
            i = i + 1;
        };
        assert!(value == 0, 1);
        Vector::reverse(&mut buffer);
        buffer
    }

    /// Converts a `address` to its  hexadecimal representation with fixed length (in whole bytes).
    /// so the returned String is `2 * length + 2`(with '0x') in size
    fun address_to_hex_string(addr: address): vector<u8>{
        let hex_string = Vector::empty<u8>();
        Vector::append(&mut hex_string, b"0x");
        let addr_bytes = BCS::to_bytes<address>(&addr);
        let i = 0;
        let len = Vector::length(&addr_bytes);
        while (i < len) {
            let hex_slice = to_hex_string_without_prefix(*Vector::borrow(&addr_bytes, i));
            Vector::append(&mut hex_string, hex_slice);
            i = i + 1;
        };
        hex_string
    }

    #[test]
    fun test_address_to_byte(){
        let user_addr = @0x6bfb460477adf9dd0455d3de2fc7f211;
        let user_addr_b = b"0x6bfb460477adf9dd0455d3de2fc7f211";
        let user_addr_hex = address_to_hex_string(user_addr);
        Debug::print(&user_addr);
        Debug::print(&user_addr_b);
        Debug::print(&user_addr_hex);

        let str1 = b"0x6bfb460477adf9dd0455d3de2fc7f211/1/";
        let str2 = Vector::empty();
        Vector::append(&mut str2, user_addr_hex);
        Vector::append(&mut str2, b"/1/");
        Debug::print(&str1);
        Debug::print(&str2);
        assert!(str1 == str2, 8013)
    }
}