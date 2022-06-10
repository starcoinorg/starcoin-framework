address StarcoinFramework {

/// Implements for Basis Dao
module GeneralDaoBasis {
    use StarcoinFramework::GeneralDao;
    use StarcoinFramework::GeneralDaoMember;
    use StarcoinFramework::IDizedSet;
    use StarcoinFramework::BCS;
    use StarcoinFramework::GeneralDaoPlugin;
    use StarcoinFramework::GeneralDaoProposal;
    use StarcoinFramework::GeneralDaoStateGuard;

    struct BasisType has store {}

    const PLUGIN_A: vector<u8> = b"x123456";
    const PLUGIN_B: vector<u8> = b"x123456";

    struct DaoBasisGlobal has key {
        member_cap: GeneralDaoMember::MemberCapability<BasisType>,
        dao_set: IDizedSet::Set<DaoBasis>
    }

    struct DaoBasis {
        dao_cap: GeneralDao::DaoCapability<BasisType>,
        dao_guard: GeneralDaoStateGuard::Guard<GeneralDaoStateGuard::Dao>
    }

    public fun genesis_dao(signer: &signer) {
        GeneralDao::genesis_dao<BasisType>(signer);
    }

    /// Create DAO by general dao basis type
    public fun create_dao(signer: &signer, genesis_broker: address, name: &vector<u8>) acquires DaoBasisGlobal {
        let (id, dao_cap, guard) =
            GeneralDao::create_dao<BasisType>(signer, genesis_broker, name);

        let global = borrow_global_mut<DaoBasisGlobal>(genesis_broker);
        IDizedSet::push_back(&mut global.dao_set, &BCS::to_bytes(&id), DaoBasis{
            dao_cap,
            dao_guard: guard
        });

        let signer_cap = GeneralDao::borrow_account_signer_cap(&dao_cap, genesis_account());
        GeneralDaoPlugin::create_plugin<DaoBasis>(signer_cap, &guard);

        // TODO: to add default plugin
        GeneralDaoPlugin::add<BasisType>(id, &PLUGIN_A, signer_cap);
        GeneralDaoPlugin::add<BasisType>(id, &PLUGIN_B, signer_cap);
    }

    public fun register_member(signer: &signer) {
        GeneralDaoMember::register_dao<BasisType>(signer, );
    }

    public fun proposal(signer: &signer) {
        // GeneralDaoProposal::create_proposal();
    }

    public fun vote(signer: &signer) {

    }


    public fun genesis_account(): address {
        @0x1
    }
}
}
