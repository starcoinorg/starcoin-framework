address StarcoinFramework {

module GeneralDao {

    use StarcoinFramework::GeneralDaoAccount;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;

    const GUARD_STATE_INIT: u8 = 1;
    const GUARD_STATE_PLUGIN_ADDED: u8 = 2;
    const GUARD_STATE_CLOSED: u8 = 3;
    const GUARD_STATE_READY: u8 = 4;

    const ERROR_INVALID_GLOBAL_STATE: u64 = 101;

    struct DaoGlobal<phantom DaoType> has key {
        next_id: u64,
    }

    struct Dao<phantom DaoType> has key {
        id: u64,
        name: vector<u8>,
        creator: address,
        signer_cap: GeneralDaoAccount::SignerCapability,
        state: u8,
    }

    /// This Dao capability can be used to operate resource in Dao
    struct DaoCapability<phantom DaoType> has key, store {}

    /// Genesis dao type from a genesis signer
    /// Only called by genesis
    public fun genesis_dao<DaoType>(signer: &signer): DaoCapability<DaoType> {
        let genesis_broker = Signer::address_of(signer);
        assert!(!exists<DaoGlobal<DaoType>>(genesis_broker), Errors::invalid_state(ERROR_INVALID_GLOBAL_STATE));

        move_to(signer, DaoGlobal<DaoType>{
            next_id: 0,
        });

        DaoCapability<DaoType>{}
    }

    /// Create DAO from name
    public fun create_dao<DaoType: store>(signer: &signer,
                                          genesis_broker: address,
                                          name: &vector<u8>,
                                          _cap: &DaoCapability<DaoType>) acquires DaoGlobal {
        assert!(exists<DaoGlobal<DaoType>>(genesis_broker), Errors::invalid_state(ERROR_INVALID_GLOBAL_STATE));

        // Create delegate account
        let signer_cap = GeneralDaoAccount::create_account(signer);
        let dao_signer = GeneralDaoAccount::dao_signer(&signer_cap);

        let state = GUARD_STATE_INIT;
        let dao_global = borrow_global_mut<DaoGlobal<DaoType>>(genesis_broker);
        dao_global.next_id = dao_global.next_id + 1;
        let dao_id = dao_global.next_id;

        move_to(signer, Dao<DaoType>{
            id: dao_id,
            name: *name,
            creator: Signer::address_of(signer),
            signer_cap,
            state,
        });
    }

    public fun borrow_account_signer_cap<DaoType: store>(dao_cap: &DaoCapability<DaoType>, dao_creator: address)
    : &GeneralDaoAccount::SignerCapability acquires Dao {
        let dao = borrow_global<Dao<DaoType>>(dao_creator);
        &dao.signer_cap
    }
}
}
