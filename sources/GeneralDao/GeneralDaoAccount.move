address StarcoinFramework {

/// Unity module that can create an account by a signer
module GeneralDaoAccount {

    use StarcoinFramework::Account;
    use StarcoinFramework::PackageTxnManager;
    use StarcoinFramework::Option;

    friend StarcoinFramework::GeneralDao;

    struct SignerCapability has key, store {
        account: address,
        cap: Account::SignerCapability,
    }

    struct DaoUpgradePlanCapability has key {
        cap: PackageTxnManager::UpgradePlanCapability,
    }

    struct StorageItem<V> has key {
        item: V,
    }

    /// Create delegate account by creator
    public fun create_account(creator: &signer): SignerCapability {
        let (dao_address, signer_cap) = Account::create_delegate_account(creator);
        let dao_signer = Account::create_signer_with_cap(&signer_cap);

        PackageTxnManager::update_module_upgrade_strategy(&dao_signer, PackageTxnManager::get_strategy_two_phase(), Option::some(0));
        let upgrade_cap = PackageTxnManager::extract_submit_upgrade_plan_cap(&dao_signer);
        move_to(&dao_signer, DaoUpgradePlanCapability{
            cap: upgrade_cap,
        });

        SignerCapability{
            account: dao_address,
            cap: signer_cap
        }
    }

    /// Get dao signer with dao address, only used by module GeneralDAO
    public(friend) fun dao_signer(cap: &SignerCapability): signer {
        Account::create_signer_with_cap(&cap.signer_cap)
    }

    public fun move_to_with_cap<V>(cap: &SignerCapability, item: V) {
        let signer = dao_signer(cap);
        move_to(&signer, StorageItem{
            item,
        })
    }

    public fun move_from_with_cap<V>(cap: &SignerCapability): V acquires StorageItem {
        let StorageItem{ item } = move_from<StorageItem<V>>(cap.dao_address);
        item
    }

    public fun borrow_with_cap<V>(cap: &SignerCapability): &V acquires StorageItem {
        let StorageItem{ item } = borrow_global<StorageItem<V>>(cap.dao_address);
        item
    }

    public fun borrow_mut_with_cap<V>(cap: &SignerCapability): &mut V acquires StorageItem {
        let StorageItem{ item } = borrow_global_mut<StorageItem<V>>(cap.dao_address);
        item
    }

    public fun exists_with_cap<V: key>(cap: &SignerCapability): bool {
        exists<V>(cap.account)
    }
}
}
