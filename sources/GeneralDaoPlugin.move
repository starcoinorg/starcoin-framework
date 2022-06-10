address StarcoinFramework {

module GeneralDaoPlugin {

    use StarcoinFramework::GeneralDaoAccount;
    use StarcoinFramework::Vector;
    use StarcoinFramework::GeneralDaoStateGuard;

    struct PluginData<phantom DaoType> has key {
        data_list: vector<vector<u8>>
    }

    public fun create_plugin<DaoType>(delegate_signer: &GeneralDaoAccount::SignerCapability,
                                      guard: &GeneralDaoStateGuard::Guard<GeneralDaoStateGuard::Dao>) {
        GeneralDaoAccount::move_to_with_cap<PluginData<DaoType>>(delegate_signer, PluginData<DaoType>{
            data_list: Vector::empty<vector<u8>>()
        });
    }

    public fun add<DaoType>(id: u64,
                            plugin_data: &vector<u8>,
                            delegate_signer: &GeneralDaoAccount::SignerCapability) {
        // TODO to complete plugin type
        let plugin_data =
            GeneralDaoAccount::borrow_mut_with_cap<DaoType>>(plugin_data, delegate_signer);
        Vector::push_back(&mut plugin_data.data_list, *plugin_data);
    }

    public fun get<DaoType>(id: u64, delegate_signer: &GeneralDaoAccount::SignerCapability): &vector<vector<u8>> {
        // TODO to complete plugin type
        &GeneralDaoAccount::borrow_with_cap<PluginData<DaoType>>(delegate_signer).data_list
    }
}
}
