address StarcoinFramework {

module GeneralDaoAccount {

    use StarcoinFramework::Account;
    use StarcoinFramework::PackageTxnManager;
    use StarcoinFramework::Option;

    friend StarcoinFramework::GeneralDao;

    struct DaoSignerCapability has key {
        cap: Account::SignerCapability,
    }

    /// The capability for write data to dao account
    struct StorageCapability has drop {
        dao_address: address
    }

    struct DaoSignerDelegate has key {
        signer_cap: Account::SignerCapability,
    }

    struct DaoUpgradePlanCapability has key {
        cap: PackageTxnManager::UpgradePlanCapability,
    }


    struct StorageItem<V> has key {
        item: V,
    }

    /// Create delegate account by creator
    public fun create_account(creator: &signer): address {
        let (dao_address, signer_cap) = Account::create_delegate_account(creator);
        let dao_signer = Account::create_signer_with_cap(&signer_cap);
        move_to(&dao_signer, DaoSignerCapability{
            cap: signer_cap,
        });

        PackageTxnManager::update_module_upgrade_strategy(&dao_signer, PackageTxnManager::get_strategy_two_phase(), Option::some(0));
        let upgrade_cap = PackageTxnManager::extract_submit_upgrade_plan_cap(&dao_signer);
        move_to(&dao_signer, DaoUpgradePlanCapability{
            cap: upgrade_cap,
        });
        dao_address
    }

    /// Get dao signer with dao address, only used by module GeneralDAO
    public(friend) fun dao_signer(dao_address: address): signer acquires DaoSignerDelegate {
        let signer_delegate = borrow_global<DaoSignerDelegate>(dao_address);
        Account::create_signer_with_cap(&signer_delegate.signer_cap)
    }

    public(friend) fun apply_storage_capability(dao_address: address): StorageCapability {
        StorageCapability{
            dao_address
        }
    }

    public fun move_to_with_cap<V>(cap: &StorageCapability, item: V) acquires DaoSignerDelegate {
        let signer = dao_signer(cap.dao_address);
        move_to(&signer, StorageItem{
            item,
        })
    }

    public fun move_from_with_cap<V>(cap: &StorageCapability): V acquires StorageItem {
        let StorageItem{ item } = move_from<StorageItem<V>>(cap.dao_address);
        item
    }
}
}
