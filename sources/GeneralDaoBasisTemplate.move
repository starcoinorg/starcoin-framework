address StarcoinFramework {

/// Implements template for Basis Dao
module GeneralDaoBasisTemplate {
    use StarcoinFramework::GeneralDao;
    use StarcoinFramework::GeneralDaoMember;
    use StarcoinFramework::GeneralDaoProposal;
    use StarcoinFramework::Signer;
    use StarcoinFramework::GeneralDaoPlugin;
    use StarcoinFramework::GenenralDaoPluginSendToken;
    use StarcoinFramework::STC;
    use StarcoinFramework::Token;

    struct DaoBasisGlobal<phantom DaoType> has key {
        dao_cap: GeneralDao::DaoCapability<DaoType>,
        member_cap: GeneralDaoMember::MemberCapability<DaoType>,
        proposal_cap: GeneralDaoProposal::ProposalCapability<DaoType>,
    }

    public fun genesis_dao<DaoType: copy + drop + store>(signer: &signer,
                                                         voting_delay: u64,
                                                         voting_period: u64,
                                                         voting_quorum_rate: u8,
                                                         min_action_delay: u64) {
        move_to(signer, DaoBasisGlobal{
            dao_cap: GeneralDao::genesis_dao<DaoType>(signer),
            member_cap: GeneralDaoMember::genesis_dao_member<DaoType>(signer),
            proposal_cap: GeneralDaoProposal::plugin<DaoType>(
                signer, voting_delay, voting_period, voting_quorum_rate, min_action_delay)
        });
    }

    /// Create DAO by general dao basis type
    public fun create_dao<DaoType: store>(dao_creator_signer: &signer,
                                          genesis_broker: address,
                                          name: &vector<u8>) acquires DaoBasisGlobal {
        let global = borrow_global_mut<DaoBasisGlobal<DaoType>>(genesis_broker);
        GeneralDao::create_dao<DaoType>(dao_creator_signer, genesis_broker, name, &global.dao_cap);

        let dao_creator_broker = Signer::address_of(dao_creator_signer);
        let account_signer_cap = GeneralDao::borrow_account_signer_cap(&global.dao_cap, dao_creator_broker);
        GeneralDaoPlugin::create_dao_plugin_table<DaoType>(account_signer_cap);

        // Create register DAO plugin table, which deicision what plugin be created on proposal section
        GeneralDaoPlugin::register_plugin_name<DaoType, GenenralDaoPluginSendToken::Plugin<DaoType, STC::STC>>(
            account_signer_cap,
            &GenenralDaoPluginSendToken::plugin_name(),
            true,
        );
    }

    /// Register member by basis type
    public fun register_member<DaoType: store>(signer: &signer, dao_id: u128) acquires DaoBasisGlobal {
        let global = borrow_global<DaoBasisGlobal<DaoType>>(genesis_account());
        GeneralDaoMember::register_dao<DaoType>(signer, &global.member_cap);
    }

    public fun proposal<DaoType: copy + drop + store>(signer: &signer,
                                                      dao_broker: address,
                                                      action_delay: u64) acquires DaoBasisGlobal {
        let global = borrow_global<DaoBasisGlobal<DaoType>>(genesis_account());

        //GeneralDaoProposal::propose<DaoT<DaoType, DaoPluginT>, ProposalActionT>(signer, action, action_delay, &global.proposal_cap);
        let table = GeneralDaoPlugin::create_empty_table<DaoType>();
        let signer_ability = GeneralDao::borrow_account_signer_cap(&global.dao_cap, dao_broker);

        GeneralDaoPlugin::register_plugin_data(
            signer, signer_ability, &mut table,
            GenenralDaoPluginSendToken::create_plugin<DaoType, STC::STC>(@0x1, Token::zero<STC::STC>()));

        GeneralDaoProposal::propose<DaoType, GeneralDaoPlugin::PluginRegistarTable<DaoType>>(
            signer, table, action_delay, &global.proposal_cap);
    }

    public fun do_cast_vote<DaoType: copy + drop + store>(signer: &signer,
                                                          proposer_address: address,
                                                          proposal_id: u64,
                                                          agree: bool) {}

    public fun do_execute_proposal<DaoType: copy + drop + store>(proposal_broker: address, proposal_id: u64) {
        let table =
            GeneralDaoProposal::extract_proposal_action<DaoType, GeneralDaoPlugin::PluginRegistarTable<DaoType>>(proposal_broker, proposal_id);
        let plugin_data = GeneralDaoPlugin::remove_from_table<
            DaoType,
            GenenralDaoPluginSendToken::Plugin<DaoType, STC::STC>>(proposal_broker, &mut table);
        GenenralDaoPluginSendToken::execute<DaoType, STC::STC>(plugin_data);
    }


    public fun genesis_account(): address {
        @0x1
    }
}
}
