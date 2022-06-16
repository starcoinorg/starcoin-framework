address StarcoinFramework {

/// Implements template for Basis Dao
module GeneralDaoBasisTemplate {
    use StarcoinFramework::GeneralDao;
    use StarcoinFramework::GeneralDaoMember;
    use StarcoinFramework::GeneralDaoProposal;
    use StarcoinFramework::Signer;

    struct DaoBasisGlobal<phantom DaoType> has key {
        dao_cap: GeneralDao::DaoCapability<DaoType>,
        member_cap: GeneralDaoMember::MemberCapability<DaoType>,
        proposal_cap: GeneralDaoProposal::ProposalCapability<DaoType>,
    }

    public fun genesis_dao<DaoType: copy + drop + store>(signer: &signer) {
        // TODO: Check privilege with signer with plugin contract module

        move_to(signer, DaoBasisGlobal{
            dao_cap: GeneralDao::genesis_dao<DaoType>(signer),
            member_cap: GeneralDaoMember::genesis_dao_member<DaoType>(signer),
            proposal_cap: GeneralDaoProposal::plugin<DaoType>(signer, 0, 10000, 50, 0)
        });

    }

    /// Create DAO by general dao basis type
    public fun create_dao<DaoType: store>(signer: &signer,
                                          genesis_broker: address,
                                          name: &vector<u8>) acquires DaoBasisGlobal {
        let global = borrow_global_mut<DaoBasisGlobal<DaoType>>(genesis_broker);
        GeneralDao::create_dao<DaoType>(signer, genesis_broker, name, &global.dao_cap);

        let broker = Signer::address_of(signer);
        let signer_cap = GeneralDao::borrow_account_signer_cap<DaoType>(&global.dao_cap, genesis_account());

        //GeneralDaoPlugin::add_plugin_send_token<DaoType>(signer,);
    }

    /// Register member by basis type
    public fun register_member<DaoType: store>(signer: &signer, dao_id: u128) acquires DaoBasisGlobal {
        let global = borrow_global<DaoBasisGlobal<DaoType>>(genesis_account());
        GeneralDaoMember::register_dao<DaoType>(signer, &global.member_cap);
    }

    public fun proposal<DaoType: copy + drop + store,
                        ProposalActionT: copy + drop + store>(signer: &signer,
                                                              dao_id: u128,
                                                              action_delay: u64) acquires DaoBasisGlobal {
        let global = borrow_global<DaoBasisGlobal<DaoType>>(genesis_account());

        //GeneralDaoProposal::propose<DaoT<DaoType, DaoPluginT>, ProposalActionT>(signer, action, action_delay, &global.proposal_cap);
    }

    public fun do_cast_vote<DaoType: copy + drop + store>(signer: &signer,
                                                          proposer_address: address,
                                                          proposal_id: u64,
                                                          agree: bool) {

    }

    public fun do_execute_proposal<DaoType: copy + drop + store>(proposer_address: address,
                                                                 proposal_id: u64) {

    }


    public fun genesis_account(): address {
        @0x1
    }
}
}
