address StarcoinFramework {

/// Implements template for Basis Dao
module GeneralDaoBasisTemplate {
    use StarcoinFramework::GeneralDao;
    use StarcoinFramework::GeneralDaoMember;
    use StarcoinFramework::GeneralDaoProposal;
    use StarcoinFramework::Signer;
    use StarcoinFramework::GeneralDaoPlugin;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Option;

    const ERROR_DAO_NOT_EXISTS: u64 = 101;
    const ERROR_DAO_TYPE_NOT_EXISTS: u64 = 102;
    const ERROR_DAO_PLUGIN_NOT_READY: u64 = 103;

    struct DaoBasisGlobal<phantom DaoType> has key {
        dao_cap: GeneralDao::DaoCapability<DaoType>,
        member_cap: GeneralDaoMember::MemberCapability<DaoType>,
        proposal_cap: GeneralDaoProposal::ProposalCapability<DaoType>,
    }

    struct DaoPluginTableWrapper<phantom DaoType> has key {
        table: Option::Option<GeneralDaoPlugin::PluginProposalRegisterTable<DaoType>>,
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

        move_to(dao_creator_signer, DaoPluginTableWrapper<DaoType>{
            table: Option::none<GeneralDaoPlugin::PluginProposalRegisterTable<DaoType>>(),
        });
    }

    /// Called by dao creator. This is allow the dao creator bind the name and plugin type
    public fun bind_plugin_name_with_type<DaoType: store, PluginT>(dao_creator_signer: &signer,
                                                                   genesis_broker: address,
                                                                   name: &vector<u8>) acquires DaoBasisGlobal {
        let global = borrow_global_mut<DaoBasisGlobal<DaoType>>(genesis_broker);

        // Create register DAO plugin table, which deicision what plugin be created on proposal section
        let dao_creator_broker = Signer::address_of(dao_creator_signer);
        let account_signer_cap = GeneralDao::borrow_account_signer_cap(&global.dao_cap, dao_creator_broker);
        GeneralDaoPlugin::register_plugin_name<DaoType, PluginT>>(
            account_signer_cap,
            *name,
            true,
        );
    }

    /// Add plugin data before creating proposal
    public fun add_plugin_data<DaoType: store, PluginT: store>(proposal_signer: &signer,
                                                               dao_broker: address,
                                                               plugin_data: PluginT)
    acquires DaoBasisGlobal, DaoPluginTableWrapper {
        assert!(GeneralDao::is_dao_account<DaoType>(dao_broker), Errors::invalid_state(ERROR_DAO_NOT_EXISTS));

        let global = borrow_global_mut<
            DaoBasisGlobal<DaoType>>(GeneralDao::query_genesis_broker<DaoType>(dao_broker));

        let signer_ability = GeneralDao::borrow_account_signer_cap(&global.dao_cap, dao_broker);
        let table_wrapper =
            borrow_global_mut<DaoPluginTableWrapper<DaoType>>(Signer::address_of(proposal_signer));

        if (Option::is_none(&table_wrapper.table)) {
            Option::fill(&mut table_wrapper.table, GeneralDaoPlugin::create_empty_register_table<DaoType>());
        };

        GeneralDaoPlugin::register_plugin_data(
            proposal_signer,
            signer_ability,
            Option::borrow_mut(&mut table_wrapper.table),
            plugin_data);
    }

    /// Register member by basis type
    public fun register_member<DaoType: store>(signer: &signer, dao_broker: address) acquires DaoBasisGlobal {
        let genesis_broker = GeneralDao::query_genesis_broker<DaoType>(dao_broker);
        let global = borrow_global<DaoBasisGlobal<DaoType>>(genesis_broker);
        GeneralDaoMember::register_dao<DaoType>(signer, &global.member_cap);
    }

    /// Create proposal
    public fun propose<DaoType: copy + drop + store>(proposal_signer: &signer,
                                                     dao_broker: address,
                                                     action_delay: u64)
    acquires DaoBasisGlobal, DaoPluginTableWrapper {
        let global = borrow_global<DaoBasisGlobal<DaoType>>(
            GeneralDao::query_genesis_broker<DaoType>(dao_broker));
        let signer_ability = GeneralDao::borrow_account_signer_cap(&global.dao_cap, dao_broker);

        // Checking the plugin data has ready
        let table_wrapper = borrow_global_mut<DaoPluginTableWrapper<DaoType>>(dao_broker);
        assert!(GeneralDaoPlugin::check_plugin_table_completed<DaoType>(
            signer_ability,
            Option::borrow(&table_wrapper.table)),
            Errors::invalid_state(ERROR_DAO_PLUGIN_NOT_READY));

        GeneralDaoProposal::propose<DaoType, GeneralDaoPlugin::PluginProposalRegisterTable<DaoType>>(
            proposal_signer,
            Option::extract(&mut table_wrapper.table),
            action_delay,
            &global.proposal_cap);
    }

    public fun do_cast_vote<DaoType: copy + drop + store>(signer: &signer,
                                                          proposer_address: address,
                                                          proposal_id: u64,
                                                          agree: bool) {
        // TODO
    }


    /// Exctract plugin data
    public fun extract_plugin<DaoType: copy + drop + store,
                              PluginT>(proposal_broker: address, proposal_id: u64): PluginT
    acquires DaoPluginTableWrapper {
        let wrapper = borrow_global_mut<DaoPluginTableWrapper<DaoType>>(proposal_broker);
        if (Option::is_none(&wrapper.table)) {
            let action = GeneralDaoProposal::extract_proposal_action<
                DaoType,
                GeneralDaoPlugin::PluginProposalRegisterTable<DaoType>>(
                proposal_broker,
                proposal_id);
            Option::fill(&mut wrapper.table, action);
        };

        let table = Option::borrow_mut(&mut wrapper.table);
        GeneralDaoPlugin::remove_from_table<DaoType, PluginT>(proposal_broker, table)
    }
}


}
