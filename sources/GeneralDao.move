address StarcoinFramework {

module GeneralDao {

    use StarcoinFramework::GeneralDaoAccount;
    use StarcoinFramework::GeneralDaoStateGuard;
    use StarcoinFramework::Signer;
    use StarcoinFramework::IDizedSet;
    use StarcoinFramework::Errors;
    use StarcoinFramework::BCS;

    const GUARD_STATE_INIT: u8 = 1;
    const GUARD_STATE_PLUGIN_ADDED: u8 = 2;
    const GUARD_STATE_CLOSED: u8 = 3;
    const GUARD_STATE_READY: u8 = 4;

    const ERROR_INVALID_GLOBAL_STATE: u64 = 101;

    struct DaoGlobal<phantom DaoType> has key {
        next_id: u64,
        dao_set: IDizedSet::Set<Dao<DaoType>>,
    }

    struct Dao<phantom DaoType> has key {
        name: vector<u8>,
        creator: address,
        signer_cap: GeneralDaoAccount::SignerCapability,
        state: u8,
    }

    /// This Dao capability can be used to operate resource in Dao
    struct DaoCapability<phantom DaoType> has key {
        id: u64,
    }

    /// Genesis dao type from a genesis signer
    public fun genesis_dao<DaoType>(signer: &signer) {
        let broker = Signer::address_of(signer);
        assert!(!exists<DaoGlobal<DaoType>>(broker), Errors::invalid_state(ERROR_INVALID_GLOBAL_STATE));

        move_to(signer, DaoGlobal<DaoType>{
            next_id: 0,
            dao_set: IDizedSet::empty<Dao<DaoType>>()
        });
    }

    /// Create DAO from name
    public fun create_dao<DaoType: store>(signer: &signer, genesis_broker: address, name: &vector<u8>)
    : (u64, DaoCapability<DaoType>, GeneralDaoStateGuard::Guard<GeneralDaoStateGuard::Dao>) acquires DaoGlobal {
        assert!(exists<DaoGlobal<DaoType>>(genesis_broker), Errors::invalid_state(ERROR_INVALID_GLOBAL_STATE));

        // Create delegate account
        let signer_cap = GeneralDaoAccount::create_account(signer);
        let dao_signer = GeneralDaoAccount::dao_signer(&signer_cap);

        let state = GUARD_STATE_INIT;
        let dao_global = borrow_global_mut<DaoGlobal<DaoType>>(genesis_broker);
        dao_global.next_id = dao_global.next_id + 1;
        let dao_id = dao_global.next_id;

        IDizedSet::push_back(&mut dao_global.dao_set, &BCS::to_bytes<u64>(&dao_id), Dao<DaoType>{
            name: *name,
            creator: Signer::address_of(signer),
            signer_cap,
            state,
        });

        (
            dao_id,
            DaoCapability<DaoType>{ id: dao_id },
            GeneralDaoStateGuard::gen_guard<GeneralDaoStateGuard::Dao>(GUARD_STATE_INIT)
        )
    }

    public fun update_guard_state<DaoType: store, GuardType: store>(genesis_broker: address,
                                                                    id: u64,
                                                                    guard: GeneralDaoStateGuard::Guard<GuardType>) acquires DaoGlobal {
        let dao_global = borrow_global_mut<DaoGlobal<DaoType>>(genesis_broker);
        let dao = IDizedSet::borrow(&dao_global.dao_set, &BCS::to_bytes<u64>(&id));
        if (GeneralDaoStateGuard::typeof<GuardType, GeneralDaoStateGuard::Plugin>(&guard)) {
            dao.state = GUARD_STATE_PLUGIN_ADDED;
        } else if (GeneralDaoStateGuard::typeof<GuardType, GeneralDaoStateGuard::Proposal>(&guard)) {
            dao.state = GUARD_STATE_READY;
        };
    }

    public fun query_guard<DaoType: store>(genesis_broker: address, id: u64)
    : GeneralDaoStateGuard::Guard<GeneralDaoStateGuard::Dao> acquires DaoGlobal {
        let dao_global = borrow_global_mut<DaoGlobal<DaoType>>(genesis_broker);
        let dao = IDizedSet::borrow(&dao_global.dao_set, &BCS::to_bytes<u64>(&id));
        GeneralDaoStateGuard::gen_guard<GeneralDaoStateGuard::Dao>(dao.state)
    }
}
}
