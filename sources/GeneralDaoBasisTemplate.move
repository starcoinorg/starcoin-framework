address StarcoinFramework {

/// Implements template for Basis Dao
module GeneralDaoBasisTemplate {
    use StarcoinFramework::GeneralDao;
    use StarcoinFramework::GeneralDaoMember;
    use StarcoinFramework::IDizedSet;
    use StarcoinFramework::BCS;
    use StarcoinFramework::GeneralDaoPlugin;
    use StarcoinFramework::GeneralDaoProposal;
    use StarcoinFramework::Signer;

    const PLUGIN_A: vector<u8> = b"x123456";
    const PLUGIN_B: vector<u8> = b"x123456";

    struct DaoBasisGlobal<phantom DaoType> has key {
        dao_cap: GeneralDao::DaoCapability<DaoType>,
        member_cap: GeneralDaoMember::MemberCapability<DaoType>,
        proposal_cap: GeneralDaoProposal::ProposalCapability<DaoType>,
    }

    struct Daos<phantom DaoType> has key {
        dao_inst_set: IDizedSet::Set<DaoProgress<DaoType>>,
    }

    struct DaoProgress<phantom DaoType> has key, store {
        dao_inst: GeneralDao::DaoInstance<DaoType>,
    }

    public fun genesis_dao<DaoType: copy + drop + store>(signer: &signer) {
        // TODO: Check privilege with signer with plugin contract module

        // Register DAO
        let dao_cap = GeneralDao::genesis_dao<DaoType>(signer);

        // Register member
        let member_cap = GeneralDaoMember::genesis_dao_member<DaoType>(signer);

        // Register proposal
        let proposal_cap =
            GeneralDaoProposal::plugin<DaoType>(signer, 0, 10000, 50, 0);

        move_to(signer, DaoBasisGlobal{
            dao_cap,
            member_cap,
            proposal_cap,
        });
    }

    /// Create DAO by general dao basis type
    public fun create_dao<DaoType: store, DaoActionT: store>(signer: &signer,
                                                             genesis_broker: address,
                                                             name: &vector<u8>) acquires DaoBasisGlobal, Daos {
        let global = borrow_global_mut<DaoBasisGlobal<DaoType>>(genesis_broker);
        let (id, dao_inst, guard) =
            GeneralDao::create_dao<DaoType>(signer, genesis_broker, name, &global.dao_cap);

        let broker = Signer::address_of(signer);

        if (exists<Daos<DaoType>(broker)) {
            let daos = borrow_global_mut<Daos<DaoType>>(broker);
            IDizedSet::push_back(&mut daos.dao_inst_set, &BCS::to_bytes(&id), DaoProgress<DaoType>{
                dao_inst
            });
        } else {
            let dao_inst_set = IDizedSet::empty<DaoProgress<DaoType>>();
            IDizedSet::push_back(&mut dao_inst_set, &BCS::to_bytes(&id), DaoProgress<DaoType>{
                dao_inst,
            });
            move_to(signer, Daos<DaoType>{
                dao_inst_set,
            });
        };

        let signer_cap = GeneralDao::borrow_account_signer_cap(&global.dao_cap, genesis_account());
        GeneralDaoPlugin::create_plugin<DaoType>(signer_cap, &guard);

        // TODO: to add default plugin
        GeneralDaoPlugin::add<DaoType>(id, &PLUGIN_A, signer_cap);
        GeneralDaoPlugin::add<DaoType>(id, &PLUGIN_B, signer_cap);
    }

    /// Register member by basis type
    public fun register_member<DaoType: store>(signer: &signer, dao_id: u128) acquires DaoBasisGlobal {
        let global = borrow_global<DaoBasisGlobal<DaoType>>(genesis_account());
        GeneralDaoMember::register_dao<DaoType>(signer, &global.member_cap);
    }

    public fun proposal<DaoType: copy + drop + store,
                        ProposalActionT: copy + drop + store>(signer: &signer,
                                                      dao_id: u128,
                                                      action: ProposalActionT,
                                                      action_delay: u64) {
        GeneralDaoProposal::propose<DaoType, ProposalActionT>(signer, dao_id, action);
    }

    public fun do_cast_vote<DaoType: store, Action: store>(signer: &signer,
                                                           proposer_address: address,
                                                           proposal_id: u64,
                                                           agree: bool) {

    }



    public fun genesis_account(): address {
        @0x1
    }
}
}
