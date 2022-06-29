module StarcoinFramework::VoteStrategy{
//    use StarcoinFramework::GenesisDao::{Self,  ProposalPluginCapability};
    use StarcoinFramework::DaoRegistry;
    use StarcoinFramework::BCS;
    use StarcoinFramework::Signer;
    #[test_only]
    use StarcoinFramework::Debug;

    const ERR_VOTING_STRATEGY_MAPPING_EXIST: u64 = 1451;


    struct VoteStrategyPluginCapability has key{
    }

    //    https://stcscan.io/barnard/address/0x6bfb460477adf9dd0455d3de2fc7f211/resources
    //    0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMember<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>, 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMemberBody<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>>
    //    {"json":{"nft":{"vec":[{"base_meta":{"description":"0x","image":"0x","image_data":"0x69616d67655f64617461","name":"0x64616f313031"},"body":{"sbt":{"value":100}},"creator":"0x6bfb460477adf9dd0455d3de2fc7f211","id":1,"type_meta":{"id":1111}}]}},"raw":"0x016bfb460477adf9dd0455d3de2fc7f21101000000000000000664616f313031000a69616d67655f6461746100570400000000000064000000000000000000000000000000"}
    struct SBTStrategy<phantom DaoT: store> has key {
        strategy_name: vector<u8>,
        //    0x6E9B83ADaA64f901048AE4bEAD8A1016/1/0x8c109349c6bd91411d6bc962e080c4a3::TokenSwapFarmBoost::UserInfo<0x00000000000000000000000000000001::STC::STC,0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        //        access_path: vector<u8>,
        // access_path_suffix = user_address + access_path_suffix
        access_path_suffix: vector<u8>, //  /1/0x8c109349c6bd91411d6bc962e080c4a3::TokenSwapFarmBoost::UserInfo<0x00000000000000000000000000000001::STC::STC,0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        //            state: vector<u8>,
        offset: u64, //sbt token deserialize offset in state bcs value
        weight_factor: u128, // How to abstract into a function ?  default 1
    }

    // veSTAR value
    //    struct SBTStrategy<phantom DaoT: store> has Key {
    //        strategy_name: vector<u8>,
    //        //    0x6E9B83ADaA64f901048AE4bEAD8A1016/1/0x8c109349c6bd91411d6bc962e080c4a3::TokenSwapFarmBoost::UserInfo<0x00000000000000000000000000000001::STC::STC,0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
    //        //        access_path: vector<u8>,
    //        // access_path_suffix = user_address + access_path_suffix
    //        access_path_suffix: vector<u8>, //  /1/0x8c109349c6bd91411d6bc962e080c4a3::TokenSwapFarmBoost::UserInfo<0x00000000000000000000000000000001::STC::STC,0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
    //        //            state: vector<u8>,
    //        offset: u64, //sbt token deserialize offset in state bcs value
    //        weight_factor: u128, // How to abstract into a function ?  default 1
    //    }

//    0x8c109349c6bd91411d6bc962e080c4a3::TokenSwapFarmBoost::UserInfo<0x00000000000000000000000000000001::STC::STC, 0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
//
//    {"json":{"boost_factor":250,"locked_vetoken":{"token":{"value":47945205478}},"user_amount":0},"raw":"0xfa00000000000000e6c6c1290b000000000000000000000000000000000000000000000000000000"}

    struct BalanceStrategy<phantom DaoT: store> has key {
        strategy_name: vector<u8>, //need by unique
        //        module_address: address,
//        module_name: vector<u8>,
//        struct_name: vector<u8>,
//        0x00000000000000000000000000000001::Account::Balance<0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
//        0xcCF1ADEdf0Ba6f9BdB9A6905173A5d72/1/0x00000000000000000000000000000001::Account::Balance<0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        // access_path_suffix = user_address + access_path_suffix
        access_path_suffix: vector<u8>, // /1/0x00000000000000000000000000000001::Account::Balance<0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        //            state: vector<u8>,
        offset: u64, //token balance deserialize offset in state bcs value, default 0
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
        let dao_addr = DaoRegistry::dao_address<DaoT>();
        let StrategyMapping {
            strategy_name: _,
            access_path_suffix: _,
            offset: _,
            weight_factor: _,
        } = move_from<StrategyMapping<DaoT>>(dao_addr);
    }


    public fun get_vote_strategy_plugin<DaoT: copy + drop + store>():(vector<u8>, vector<u8>, u64, u128) acquires StrategyMapping{
        let dao_addr = DaoRegistry::dao_address<DaoT>();
        let strategy_mapping = borrow_global<StrategyMapping<DaoT>>(dao_addr);
        (*&strategy_mapping.strategy_name, *&strategy_mapping.access_path_suffix, strategy_mapping.offset, strategy_mapping.weight_factor)
    }


    /// read snapshot vote value from state
    public fun get_voting_power<DaoT: store>(_sender: address, _state_root: &vector<u8>, state: &vector<u8>) : u128 acquires StrategyMapping{
        //TODO how to verify state ?

        let dao_addr = DaoRegistry::dao_address<DaoT>();
        let strategy_mapping = borrow_global<StrategyMapping<DaoT>>(dao_addr);

        //TODO check state with access_path_suffix ?
        let offset = strategy_mapping.offset;

        let (value, _) = BCS::deserialize_u128(state, offset);

        //TODO calculate weight_factor
        value
    }

    #[test]
    public fun test_from_deserialize_state_for_vestar_value() {
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
    //TODO
    public fun test_from_deserialize_state_for_sbt_value() {
        //      {"json":{"boost_factor":250,"locked_vetoken":{"token":{"value":47945205478}},"user_amount":0},"raw":"0xfa00000000000000e6c6c1290b000000000000000000000000000000000000000000000000000000"}
        let bs = x"fa0000000000000038bc7e1800000000000000000000000000000000000000000000000000000000";
        Debug::print<vector<u8>>(&bs);
        let offset = 0;

        let (r, offset) = BCS::deserialize_u128(&bs, offset);
        Debug::print(&r);
        Debug::print<u64>(&offset);
    }

    #[test]
    public fun test_deserialize_state_for_balance() {
        //      {"json":{"token":{"value":40350083678552}},"raw":"0x588167bcb22400000000000000000000"}
        let bs = x"588167bcb22400000000000000000000";
        Debug::print<vector<u8>>(&bs);
        let offset = 0;

        let (balance, offset) = BCS::deserialize_u128(&bs, offset);
        Debug::print(&balance);
        Debug::print<u64>(&offset);
    }

}