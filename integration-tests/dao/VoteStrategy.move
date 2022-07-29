//# init -n dev

//# faucet --addr default

//# publish
module default::VoteStrategy{
//    use StarcoinFramework::DAOSpace::{Self,  ProposalPluginCapability};
    use StarcoinFramework::DAORegistry;
    use StarcoinFramework::BCS;
    use StarcoinFramework::Signer;
    #[test_only]
    use StarcoinFramework::Debug;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Errors;

    const ERR_VOTING_STRATEGY_MAPPING_EXIST: u64 = 1411;
    const ERR_PRE_ORDER_TYPE_INVALID: u64 = 1413;
    const ERR_BCS_STATE_NTFS_LENGHT_TYPE_INVALID: u64 = 1414;


    struct VoteStrategyPluginCapability has key{
    }

    struct SBTStrategy<phantom DaoT: store> has key {
        //    https://stcscan.io/barnard/address/0x6bfb460477adf9dd0455d3de2fc7f211/resources
        //    0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMember<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>, 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMemberBody<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>>
        //    {"json":{"nft":{"vec":[{"base_meta":{"description":"0x","image":"0x","image_data":"0x69616d67655f64617461","name":"0x64616f313031"},"body":{"sbt":{"value":100}},"creator":"0x6bfb460477adf9dd0455d3de2fc7f211","id":1,"type_meta":{"id":1111}}]}},"raw":"0x016bfb460477adf9dd0455d3de2fc7f21101000000000000000664616f313031000a69616d67655f6461746100570400000000000064000000000000000000000000000000"}

        strategy_name: vector<u8>,
        //        access_path: vector<u8>,
        // access_path_suffix = user_address + access_path_suffix
        access_path_suffix: vector<u8>, //  /1/0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMember<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>, 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMemberBody<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>>
        //            state: vector<u8>,
        pre_order_types_vector: vector<vector<u8>>, //sbt token deserialize pre order types vector in state bcs value
        weight_factor: u128, // How to abstract into a function ?  default 1
    }

    // veSTAR value
    struct VeSTARStrategy<phantom DaoT: store> has key {
        strategy_name: vector<u8>,
        //    0x6E9B83ADaA64f901048AE4bEAD8A1016/1/0x8c109349c6bd91411d6bc962e080c4a3::TokenSwapFarmBoost::UserInfo<0x00000000000000000000000000000001::STC::STC,0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        //        access_path: vector<u8>,
        // access_path_suffix = user_address + access_path_suffix
        access_path_suffix: vector<u8>, //  /1/0x8c109349c6bd91411d6bc962e080c4a3::TokenSwapFarmBoost::UserInfo<0x00000000000000000000000000000001::STC::STC,0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        //            state: vector<u8>,
        pre_order_types_vector: vector<vector<u8>>, //sbt token deserialize pre order types vector in state bcs value
        weight_factor: u128, // How to abstract into a function ?  default 1
    }

    struct BalanceStrategy<phantom DaoT: store> has key {
        //    0x8c109349c6bd91411d6bc962e080c4a3::TokenSwapFarmBoost::UserInfo<0x00000000000000000000000000000001::STC::STC, 0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        //
        //    {"json":{"boost_factor":250,"locked_vetoken":{"token":{"value":47945205478}},"user_amount":0},"raw":"0xfa00000000000000e6c6c1290b000000000000000000000000000000000000000000000000000000"}

        strategy_name: vector<u8>, //need by unique
//        0x00000000000000000000000000000001::Account::Balance<0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
//        0xcCF1ADEdf0Ba6f9BdB9A6905173A5d72/1/0x00000000000000000000000000000001::Account::Balance<0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        // access_path_suffix = user_address + access_path_suffix
        access_path_suffix: vector<u8>, // /1/0x00000000000000000000000000000001::Account::Balance<0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        //            state: vector<u8>,
        pre_order_types_vector: vector<vector<u8>>, //token balance deserialize pre order types vector in state bcs value
        weight_factor: u128, // How to abstract into a function ?  default 1
    }


    // TODO extend to List to support multi stragegies for a DAO ?
    struct  StrategyMapping<phantom DaoT: store> has key {
        strategy_name: vector<u8>,
        access_path_suffix: vector<u8>, //  /1/0x8c109349c6bd91411d6bc962e080c4a3::TokenSwapFarmBoost::UserInfo<0x00000000000000000000000000000001::STC::STC,0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        offset: u64, //sbt token deserialize offset in state bcs value
        weight_factor: u128, // How to abstract into a function ? default 1
    }

    public fun install_vote_strategy_plugin<DaoT: copy + drop + store>(_cap: &VoteStrategyPluginCapability, installer: &signer, strategy_name: vector<u8>, access_path_suffix:vector<u8>, offset: u64, weight_factor: u128){
        //TODO get dao_singer cap
        let dao_signer = installer;
        let dao_addr = Signer::address_of(dao_signer);
        //TODO support multi stragegies for a DAO ?
        assert!(exists<StrategyMapping<DaoT>>(dao_addr), ERR_VOTING_STRATEGY_MAPPING_EXIST);

        //TODO check vote strategy template

        let strategy = StrategyMapping<DaoT>{
            strategy_name,
            access_path_suffix,
            offset,
            weight_factor,
        };
        move_to(dao_signer, strategy);
    }

    public fun uninstall_vote_strategy_plugin<DaoT: copy + drop + store>(_cap: &VoteStrategyPluginCapability, _uninstaller: &signer) acquires StrategyMapping {
//        let dao_addr = Signer::address_of(dao_signer);
        let dao_addr = DAORegistry::dao_address<DaoT>();
        let StrategyMapping {
            strategy_name: _,
            access_path_suffix: _,
            offset: _,
            weight_factor: _,
        } = move_from<StrategyMapping<DaoT>>(dao_addr);
    }


    public fun get_vote_strategy_plugin<DaoT: copy + drop + store>():(vector<u8>, vector<u8>, u64, u128) acquires StrategyMapping{
        let dao_addr = DAORegistry::dao_address<DaoT>();
        let strategy_mapping = borrow_global<StrategyMapping<DaoT>>(dao_addr);
        (*&strategy_mapping.strategy_name, *&strategy_mapping.access_path_suffix, strategy_mapping.offset, strategy_mapping.weight_factor)
    }

    /// read snapshot vote value from state
    public fun get_voting_power<DaoT: store>(_sender: address, _state_root: &vector<u8>, state: &vector<u8>) : u128 acquires StrategyMapping{
        //TODO how to verify state ?

        let dao_addr = DAORegistry::dao_address<DaoT>();
        let strategy_mapping = borrow_global<StrategyMapping<DaoT>>(dao_addr);

        //TODO check state with access_path_suffix ?
        let offset = strategy_mapping.offset;

        let (value, _) = BCS::deserialize_u128(state, offset);

        //TODO calculate weight_factor
        value
    }

    /// Move types
    const TYPE_U8: vector<u8> = b"u8";
    const TYPE_U64: vector<u8> = b"u64";
    const TYPE_U128: vector<u8> = b"u128";
    const TYPE_BYTES: vector<u8> = b"bytes";
    const TYPE_BYTES_VECTOR: vector<u8> = b"bytes_vector";
    const TYPE_ADDRESS: vector<u8> = b"address";
    const TYPE_BOOL: vector<u8> = b"bool";
    const TYPE_OPTION_BYTES: vector<u8> = b"option_bytes";


    /// deserialize sbt value from bcs state
    public fun deserialize_sbt_value_from_bcs_state(state: &vector<u8>, pre_order_types_vector: &vector<vector<u8>>) : u128{
        let len = Vector::length<vector<u8>>(pre_order_types_vector);
        if (len == 0) {
            return 0u128
        };

        // nfts array length
        let ctype = Vector::borrow(&mut *pre_order_types_vector, 0);
        assert!(TYPE_U8 == *ctype, Errors::invalid_state(ERR_BCS_STATE_NTFS_LENGHT_TYPE_INVALID));
        let offset = 0;
        let (nfts_len, _offset) = BCS::deserialize_u8(state, offset);
        // user has no sbt yet
        if (nfts_len == 0) {
            return 0u128
        };
        deserialize_resource_value(state, pre_order_types_vector)
    }

    public fun deserialize_vestar_value_from_bcs_state(state: &vector<u8>, pre_order_types_vector: &vector<vector<u8>>) : u128{
        let len = Vector::length<vector<u8>>(pre_order_types_vector);
        if (len == 0) {
            return 0u128
        };
        deserialize_resource_value(state, pre_order_types_vector)
    }

    public fun deserialize_balance_from_bcs_state(state: &vector<u8>, pre_order_types_vector: &vector<vector<u8>>) : u128{
        let len = Vector::length<vector<u8>>(pre_order_types_vector);
        if (len == 0) {
            return 0u128
        };
        deserialize_resource_value(state, pre_order_types_vector)
    }

    public fun deserialize_resource_value(input: &vector<u8>, pre_order_types_vector: &vector<vector<u8>>) : u128{
    //      {address, u64, {...}, {...}, {...}}
        let len = Vector::length<vector<u8>>(pre_order_types_vector);
        if (len == 0) {
            return 0u128
        };
        let idx = 0;
        let offset = 0;
        loop {
            if (idx >= len) {
                break
            };
            let ctype = Vector::borrow(pre_order_types_vector, idx);
            offset = deserialize_one_type_cursor(input, ctype, offset);
            idx = idx + 1;
        };
        let (amount_value, _offset) = BCS::deserialize_u128(input, offset);
        amount_value
    }

    public fun deserialize_one_type_cursor(input: &vector<u8>, ctype: &vector<u8>, offset:u64) : u64 {
        if (TYPE_U8 == *ctype) {
            offset = BCS::skip_u8(input, offset);
        } else if (TYPE_U64 == *ctype) {
            offset = BCS::skip_u64(input, offset);
        } else if (TYPE_U128 == *ctype) {
            offset = BCS::skip_u128(input, offset);
        } else if (TYPE_BYTES == *ctype) {
            offset = BCS::skip_bytes(input, offset);
        } else if (TYPE_BYTES_VECTOR == *ctype) {
            offset = BCS::skip_bytes_vector(input, offset);
        } else if (TYPE_ADDRESS == *ctype) {
            offset = BCS::skip_address(input, offset);
        } else if (TYPE_BOOL == *ctype) {
            offset = BCS::skip_bool(input, offset);
        } else if (TYPE_OPTION_BYTES == *ctype) {
            offset = BCS::skip_option_bytes(input, offset);
        } else {
            abort Errors::invalid_argument(ERR_PRE_ORDER_TYPE_INVALID)
        };
        offset
    }

    #[test]
    fun test_deserialize_sbt_value() {
        let _state = x"016bfb460477adf9dd0455d3de2fc7f21101000000000000000664616f313031000a69616d67655f6461746100570400000000000064000000000000000000000000000000";

        let pre_order_types_vector =  Vector::empty<vector<u8>>();
        Vector::push_back(&mut pre_order_types_vector, b"u8");
        Vector::push_back(&mut pre_order_types_vector, b"address");
        Vector::push_back(&mut pre_order_types_vector, b"u64");
        Vector::push_back(&mut pre_order_types_vector, b"bytes");
        Vector::push_back(&mut pre_order_types_vector, b"bytes");
        Vector::push_back(&mut pre_order_types_vector, b"bytes");
        Vector::push_back(&mut pre_order_types_vector, b"bytes");
        Vector::push_back(&mut pre_order_types_vector, b"u64");

        let sbt_value = deserialize_sbt_value_from_bcs_state(&_state, &pre_order_types_vector);
        let _expect_sb_value = 100;
        assert!(_expect_sb_value == sbt_value, 8001);
        Debug::print(&sbt_value);
    }


    #[test]
    fun test_origin_deserialize_sbt_value_from_bcs_state() {
        // https://stcscan.io/barnard/address/0x6bfb460477adf9dd0455d3de2fc7f211/resources
        // 0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMember<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>, 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMemberBody<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>>
        // {"json":{"nft":{"vec":[{"base_meta":{"description":"0x","image":"0x","image_data":"0x69616d67655f64617461","name":"0x64616f313031"},"body":{"sbt":{"value":100}},"creator":"0x6bfb460477adf9dd0455d3de2fc7f211","id":1,"type_meta":{"id":1111}}]}},"raw":"0x016bfb460477adf9dd0455d3de2fc7f21101000000000000000664616f313031000a69616d67655f6461746100570400000000000064000000000000000000000000000000"}
        let bs = x"016bfb460477adf9dd0455d3de2fc7f21101000000000000000664616f313031000a69616d67655f6461746100570400000000000064000000000000000000000000000000";
        Debug::print<vector<u8>>(&bs);
        let offset = 0;

        // array length
        let offset = BCS::skip_u8(&bs, offset);
        // creator
        let offset = BCS::skip_address(&bs, offset);
        // id
        let offset = BCS::skip_u64(&bs, offset);
        Debug::print<u64>(&offset);
        // base_meta
        let offset = BCS::skip_bytes(&bs, offset);
        let offset = BCS::skip_bytes(&bs, offset);
        let offset = BCS::skip_bytes(&bs, offset);
        let offset = BCS::skip_bytes(&bs, offset);
        // type_meta
        let offset = BCS::skip_u64(&bs, offset);
        Debug::print<u64>(&offset);
        // body
        let (sbt_value, offset) = BCS::deserialize_u128(&bs, offset);
        Debug::print(&sbt_value);
        Debug::print<u64>(&offset);
        let expect_sb_value = 100;
        assert!(expect_sb_value == sbt_value, 8003);
        Debug::print(&b"testdao02");
    }


    #[test]
    fun test_origin_deserialize_vestar_value_from_bcs_state() {
        //      {"json":{"boost_factor":250,"locked_vetoken":{"token":{"value":47945205478}},"user_amount":0},"raw":"0xfa00000000000000e6c6c1290b000000000000000000000000000000000000000000000000000000"}
        let bs = x"fa0000000000000038bc7e1800000000000000000000000000000000000000000000000000000000";
        Debug::print<vector<u8>>(&bs);

        let (r, offset) = BCS::deserialize_u64(&bs, 0);
        Debug::print(&r);
        Debug::print<u64>(&offset);
        let (r, offset) = BCS::deserialize_u128(&bs, offset);
        Debug::print(&r);
        Debug::print<u64>(&offset);
        let (r, offset) = BCS::deserialize_u128(&bs, offset);
        Debug::print(&r);
        Debug::print<u64>(&offset);
    }

    #[test]
    fun test_origin_deserialize_balance_from_bcs_state() {
        // {"json":{"token":{"value":40350083678552}},"raw":"0x588167bcb22400000000000000000000"}

        let bs = x"588167bcb22400000000000000000000";
        Debug::print<vector<u8>>(&bs);
        let offset = 0;

        let (balance, offset) = BCS::deserialize_u128(&bs, offset);
        Debug::print(&balance);
        Debug::print<u64>(&offset);
    }

    #[test]
    fun test_bcs() {
        // vector<u8>
        let v = x"";
        let expected_output = x"00";
        let v_bcs = BCS::to_bytes(&v);
        Debug::print(&v_bcs);
        assert!(copy v_bcs == expected_output, 8006);

        let offset = 0;
        let (_r, offset) = BCS::deserialize_bytes(&v_bcs, offset);
        Debug::print(&_r);
        Debug::print<u64>(&offset);

        // vector<vector<u8>>
    }

    #[test]
    fun test_origin_deserialize_nfts_from_bcs_state() {
        // https://stcscan.io/main/address/0x44bc6adfdc1f718ed2014699b239f035/resources
        // 0x00000000000000000000000000000001::NFTGallery::NFTGallery<0x2d32bee4f260694a0b3f1143c64a505a::Market::GoodsNFTInfo, 0x2d32bee4f260694a0b3f1143c64a505a::Market::GoodsNFTBody>
        // {"json":{"deposit_events":{"counter":2,"guid":"0x180000000000000044bc6adfdc1f718ed2014699b239f035"},"items":[{"base_meta":{"description":"0x41646f707420746865206669727374204e4654206f6e2053746172636f696e2066726f6d2074686520426f72656420456c697a616265746820494920636f6c6c656374696f6e2e2068747470733a2f2f747769747465722e636f6d2f426f726564456c697a6162657468","image":"0x68747470733a2f2f6333722e6f73732d636e2d6265696a696e672e616c6979756e63732e636f6d2f6e6f726d616c2f307861383663306664643836303732663861346133366331656237353664656665632f393437353333373132313434313834362e706e673f782d6f73732d70726f636573733d696d6167652f726573697a652c775f3634302f726573697a652c685f363430","image_data":"0x","name":"0x233131"},"body":{"quantity":1},"creator":"0xa86c0fdd86072f8a4a36c1eb756defec","id":499,"type_meta":{"has_in_kind":false,"mail":"0x","resource_url":"0x68747470733a2f2f6333722e6f73732d636e2d6265696a696e672e616c6979756e63732e636f6d2f6e6f726d616c2f307861383663306664643836303732663861346133366331656237353664656665632f393437353333373132313434313834362e706e67","type":1002}},{"base_meta":{"description":"0x41646f707420746865206669727374204e4654206f6e2053746172636f696e2066726f6d2074686520426f72656420456c697a616265746820494920636f6c6c656374696f6e2e2068747470733a2f2f747769747465722e636f6d2f426f726564456c697a6162657468","image":"0x68747470733a2f2f6333722e6f73732d636e2d6265696a696e672e616c6979756e63732e636f6d2f6e6f726d616c2f307861383663306664643836303732663861346133366331656237353664656665632f373336333338333932393234323336392e706e673f782d6f73732d70726f636573733d696d6167652f726573697a652c775f3634302f726573697a652c685f363430","image_data":"0x","name":"0x233233"},"body":{"quantity":1},"creator":"0xa86c0fdd86072f8a4a36c1eb756defec","id":501,"type_meta":{"has_in_kind":false,"mail":"0x","resource_url":"0x68747470733a2f2f6333722e6f73732d636e2d6265696a696e672e616c6979756e63732e636f6d2f6e6f726d616c2f307861383663306664643836303732663861346133366331656237353664656665632f373336333338333932393234323336392e706e67","type":1002}}],"withdraw_events":{"counter":0,"guid":"0x170000000000000044bc6adfdc1f718ed2014699b239f035"}},"raw":"0x000000000000000018170000000000000044bc6adfdc1f718ed2014699b239f035020000000000000018180000000000000044bc6adfdc1f718ed2014699b239f03502a86c0fdd86072f8a4a36c1eb756defecf30100000000000003233131940168747470733a2f2f6333722e6f73732d636e2d6265696a696e672e616c6979756e63732e636f6d2f6e6f726d616c2f307861383663306664643836303732663861346133366331656237353664656665632f393437353333373132313434313834362e706e673f782d6f73732d70726f636573733d696d6167652f726573697a652c775f3634302f726573697a652c685f363430006a41646f707420746865206669727374204e4654206f6e2053746172636f696e2066726f6d2074686520426f72656420456c697a616265746820494920636f6c6c656374696f6e2e2068747470733a2f2f747769747465722e636f6d2f426f726564456c697a616265746800ea030000000000006668747470733a2f2f6333722e6f73732d636e2d6265696a696e672e616c6979756e63732e636f6d2f6e6f726d616c2f307861383663306664643836303732663861346133366331656237353664656665632f393437353333373132313434313834362e706e67000100000000000000a86c0fdd86072f8a4a36c1eb756defecf50100000000000003233233940168747470733a2f2f6333722e6f73732d636e2d6265696a696e672e616c6979756e63732e636f6d2f6e6f726d616c2f307861383663306664643836303732663861346133366331656237353664656665632f373336333338333932393234323336392e706e673f782d6f73732d70726f636573733d696d6167652f726573697a652c775f3634302f726573697a652c685f363430006a41646f707420746865206669727374204e4654206f6e2053746172636f696e2066726f6d2074686520426f72656420456c697a616265746820494920636f6c6c656374696f6e2e2068747470733a2f2f747769747465722e636f6d2f426f726564456c697a616265746800ea030000000000006668747470733a2f2f6333722e6f73732d636e2d6265696a696e672e616c6979756e63732e636f6d2f6e6f726d616c2f307861383663306664643836303732663861346133366331656237353664656665632f373336333338333932393234323336392e706e67000100000000000000"}

        let bs = x"000000000000000018170000000000000044bc6adfdc1f718ed2014699b239f035020000000000000018180000000000000044bc6adfdc1f718ed2014699b239f03502a86c0fdd86072f8a4a36c1eb756defecf30100000000000003233131940168747470733a2f2f6333722e6f73732d636e2d6265696a696e672e616c6979756e63732e636f6d2f6e6f726d616c2f307861383663306664643836303732663861346133366331656237353664656665632f393437353333373132313434313834362e706e673f782d6f73732d70726f636573733d696d6167652f726573697a652c775f3634302f726573697a652c685f363430006a41646f707420746865206669727374204e4654206f6e2053746172636f696e2066726f6d2074686520426f72656420456c697a616265746820494920636f6c6c656374696f6e2e2068747470733a2f2f747769747465722e636f6d2f426f726564456c697a616265746800ea030000000000006668747470733a2f2f6333722e6f73732d636e2d6265696a696e672e616c6979756e63732e636f6d2f6e6f726d616c2f307861383663306664643836303732663861346133366331656237353664656665632f393437353333373132313434313834362e706e67000100000000000000a86c0fdd86072f8a4a36c1eb756defecf50100000000000003233233940168747470733a2f2f6333722e6f73732d636e2d6265696a696e672e616c6979756e63732e636f6d2f6e6f726d616c2f307861383663306664643836303732663861346133366331656237353664656665632f373336333338333932393234323336392e706e673f782d6f73732d70726f636573733d696d6167652f726573697a652c775f3634302f726573697a652c685f363430006a41646f707420746865206669727374204e4654206f6e2053746172636f696e2066726f6d2074686520426f72656420456c697a616265746820494920636f6c6c656374696f6e2e2068747470733a2f2f747769747465722e636f6d2f426f726564456c697a616265746800ea030000000000006668747470733a2f2f6333722e6f73732d636e2d6265696a696e672e616c6979756e63732e636f6d2f6e6f726d616c2f307861383663306664643836303732663861346133366331656237353664656665632f373336333338333932393234323336392e706e67000100000000000000";
        Debug::print<vector<u8>>(&bs);
        let offset = 0;

        let (_r, offset) = BCS::deserialize_u64(&bs, offset);
        Debug::print(&_r);
        Debug::print<u64>(&offset);
        let (_r, offset) = BCS::deserialize_bytes(&bs, offset);
        Debug::print(&_r);
        Debug::print<u64>(&offset);

        let (_r, offset) = BCS::deserialize_u64(&bs, offset);
        Debug::print(&_r);
        Debug::print<u64>(&offset);
        let (_r, offset) = BCS::deserialize_bytes(&bs, offset);
        Debug::print(&_r);
        Debug::print<u64>(&offset);

        // array length
        let (_r, offset) = BCS::deserialize_u8(&bs, offset);
        Debug::print(&_r);
        Debug::print<u64>(&offset);

        let (_r, offset) = BCS::deserialize_address(&bs, offset);
        Debug::print(&_r);
        Debug::print(&@0xa86c0fdd86072f8a4a36c1eb756defec);
        let (_r, offset) = BCS::deserialize_u64(&bs, offset);
        Debug::print(&_r);
        Debug::print<u64>(&offset);
        let (_r, offset) = BCS::deserialize_bytes(&bs, offset);
        let (_r, offset) = BCS::deserialize_bytes(&bs, offset);
        let offset = BCS::skip_bytes(&bs, offset);
        let offset = BCS::skip_bytes(&bs, offset);
        let offset = BCS::skip_u64(&bs, offset);
        Debug::print(&_r);
        Debug::print<u64>(&offset);
        let (_r, offset) = BCS::deserialize_u128(&bs, offset);
        Debug::print(&_r);
        Debug::print<u64>(&offset);
    }


}