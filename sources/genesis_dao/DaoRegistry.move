module StarcoinFramework::DaoRegistry{
    use StarcoinFramework::GenesisSignerCapability;
    use StarcoinFramework::CoreAddresses;

    friend StarcoinFramework::GenesisDao;

    struct DaoRegistryEntry<phantom DaoT> has key{
        dao_id: u64,
        dao_address: address,
    }

    //This function should call from GenesisDao module
    public(friend) fun register<DaoT>(dao_address: address): u64{
        let genesis_account = GenesisSignerCapability::get_genesis_signer();
        let dao_id = next_id();
        move_to(&genesis_account, DaoRegistryEntry<DaoT>{
            dao_id,
            dao_address,
        });
        dao_id
    }

    fun next_id(): u64{
        //TODO implement id generate
        0
    }
  
    public fun dao_address<DaoT>():address acquires DaoRegistryEntry{
        *&borrow_global<DaoRegistryEntry<DaoT>>(CoreAddresses::GENESIS_ADDRESS()).dao_address
    }   

}