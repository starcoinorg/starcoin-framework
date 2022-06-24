module StarcoinFramework::VoteStrategy{
    use StarcoinFramework::GenesisDao::{Self,  ProposalPluginCapability};
    use StarcoinFramework::DaoRegistry;
    use StarcoinFramework::BCSDeserializer;
    use StarcoinFramework::Signer;

    const ERR_VOTING_STRATEGY_MAPPING_EXIST: u64 = 1451;


    struct VoteStrategyPluginCapability has key{
    }

    struct SBTStrategy<phantom DaoT: store> has Key {
        stragegy_name: vector<u8>,
    //    0x6E9B83ADaA64f901048AE4bEAD8A1016/1/0x8c109349c6bd91411d6bc962e080c4a3::TokenSwapFarmBoost::UserInfo<0x00000000000000000000000000000001::STC::STC,0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
//        access_path: vector<u8>,
    // access_path_suffix = user_address + access_path_suffix
        access_path_suffix: vector<u8>, //  /1/0x8c109349c6bd91411d6bc962e080c4a3::TokenSwapFarmBoost::UserInfo<0x00000000000000000000000000000001::STC::STC,0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        //            state: vector<u8>,
        offset: u64, //sbt token deserialize offset in state bcs value
        weight_factor: u128, // How to abstract into a function ?  default 1
    }


    struct BalanceStrategy<phantom DaoT: store> has Key {
        stragegy_name: vector<u8>,
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
    struct StrategyMapping<phantom DaoT: store> has key {
        stragegy_name: vector<u8>,
        access_path_suffix: vector<u8>, //  /1/0x8c109349c6bd91411d6bc962e080c4a3::TokenSwapFarmBoost::UserInfo<0x00000000000000000000000000000001::STC::STC,0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        offset: u64, //sbt token deserialize offset in state bcs value
        weight_factor: u128, // How to abstract into a function ? default 1
    }

    public fun install_vote_strategy_plugin<DaoT: copy + drop + store>(cap: &VoteStrategyPluginCapability, installer: &signer, stragegy_name: vector<u8>, access_path_suffix:vector<u8>, offset: u64, weight_factor: u128){
        //TODO get dao_singer cap
        let dao_signer;
        let dao_addr = Signer::address_of(dao_signer);
        //TODO support multi stragegies for a DAO ?
        assert!(exists<StrategyMapping<DaoT>>(dao_addr), ERR_VOTING_STRATEGY_MAPPING_EXIST);

        //TODO check vote strategy template

        let strategy = StrategyMapping{
            stragegy_name,
            access_path_suffix,
            offset,
            weight_factor,
        };
    }

    public fun uninstall_vote_strategy_plugin<DaoT: copy + drop + store>(cap: &VoteStrategyPluginCapability, uninstaller: &signer){
//        let dao_addr = Signer::address_of(dao_signer);
        let dao_addr = DaoRegistry::dao_address<DaoT>();
        let StrategyMapping {
            stragegy_name: _,
            access_path_suffix: _,
            offset: _,
            weight_factor: _,
        } = move_from<StrategyMapping<DaoT>(dao_addr);
    }


    public fun get_vote_strategy_plugin<DaoT: copy + drop + store>():(vector<u8>, vector<u8>, u64, u128) acquires StrategyMapping{
        let dao_addr = DaoRegistry::dao_address<DaoT>();
        let stragegy_mapping = borrow_global<StrategyMapping<DaoT>>(dao_addr);
        (*&stragegy_mapping.stragegy_name, *&stragegy_mapping.access_path_suffix, stragegy_mapping.offset, stragegy_mapping.weight_factor)
    }


    /// read snapshot vote value from state
    public fun get_voting_power<DaoT: copy + drop + store>(sender: address, state_root: &vector<u8>, state: &vector<u8>) : u128 acquires StrategyMapping{
        //TODO how to verify state ?

        let dao_addr = DaoRegistry::dao_address<DaoT>();
        let stragegy_mapping = borrow_global<StrategyMapping<DaoT>>(dao_addr);

        //TODO check state with access_path_suffix ?
        let offset = stragegy_mapping.offset;

        let (value, _) = BCSDeserializer::deserialize_u128(state, offset);

        //TODO calculate weight_factor
        value
    }

}