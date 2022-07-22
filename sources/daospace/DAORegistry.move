module StarcoinFramework::DAORegistry{
    use StarcoinFramework::GenesisSignerCapability;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Errors;

    friend StarcoinFramework::Genesis;
    friend StarcoinFramework::StdlibUpgradeScripts;
    friend StarcoinFramework::DAOSpace;

    spec module {
        pragma verify = false;
        pragma aborts_if_is_strict = true;
    }

    const ERR_ALREADY_INITIALIZED: u64 = 100;

    /// Global Dao registry info
    struct DAORegistry has key{
        next_dao_id: u64,
    }

    /// Registry Entry for record the mapping between `DaoT` and `dao_address`
    struct DAORegistryEntry<phantom DaoT> has key{
        dao_id: u64,
        dao_address: address,
    }

    public(friend) fun initialize(){
        assert!(!exists<DAORegistry>(CoreAddresses::GENESIS_ADDRESS()), Errors::already_published(ERR_ALREADY_INITIALIZED));
        let signer = GenesisSignerCapability::get_genesis_signer();
        move_to(&signer, DAORegistry{next_dao_id: 1})
    }

    // This function should call from DAOSpace module
    public(friend) fun register<DaoT>(dao_address: address): u64 acquires DAORegistry{
        let genesis_account = GenesisSignerCapability::get_genesis_signer();
        let dao_id = next_dao_id();
        move_to(&genesis_account, DAORegistryEntry<DaoT>{
            dao_id,
            dao_address,
        });
        dao_id
    }

    fun next_dao_id(): u64 acquires DAORegistry {
        let dao_registry = borrow_global_mut<DAORegistry>(CoreAddresses::GENESIS_ADDRESS());
        let dao_id = dao_registry.next_dao_id;
        dao_registry.next_dao_id = dao_id + 1;
        dao_id
    
    }
  
    public fun dao_address<DaoT>():address acquires DAORegistryEntry{
        *&borrow_global<DAORegistryEntry<DaoT>>(CoreAddresses::GENESIS_ADDRESS()).dao_address
    }   

}