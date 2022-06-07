module StarcoinFramework::DaoAccount{
    use StarcoinFramework::Account::{Self, SignerCapability};
    use StarcoinFramework::PackageTxnManager;
    use StarcoinFramework::Option;
    use StarcoinFramework::Signer;

    /// DaoAccount
    struct DaoAccount has key{
        dao_address: address,
        signer_cap: SignerCapability,
    }

    /// This capability can control the Dao account
    struct DaoAccountCapability has store, key{
        dao_address: address,
    }
    
    /// Create a new Dao Account and return DaoAccountCapability
    /// Dao Account is a delegate account, the `creator` has the `DaoAccountCapability` 
    public fun create_account(creator: &signer): DaoAccountCapability {
        let (dao_address, signer_cap) = Account::create_delegate_account(creator);
        let dao_signer = Account::create_signer_with_cap(&signer_cap);

        PackageTxnManager::update_module_upgrade_strategy(&dao_signer, PackageTxnManager::get_strategy_two_phase(), Option::some(0));
        move_to(&dao_signer, DaoAccount{
            dao_address,
            signer_cap: signer_cap,
        });
        DaoAccountCapability{
            dao_address
        }
    }

    /// Entry function for create dao account, the `DaoAccountCapability` save to the `creator` account
    public(script) fun create_account_entry(sender: signer){
        let cap = create_account(&sender);
        move_to(&sender, cap);
    }

    /// Upgrade `sender` account to Dao account
    public fun upgrade_to_dao(sender: signer): DaoAccountCapability {
        //TODO assert sender not Dao
        let signer_cap = Account::remove_signer_capability(&sender);
        //TODO check the account upgrade_strategy
        PackageTxnManager::update_module_upgrade_strategy(&sender, PackageTxnManager::get_strategy_two_phase(), Option::some(0));
        let dao_address = Signer::address_of(&sender);
        move_to(&sender, DaoAccount{
            dao_address,
            signer_cap: signer_cap,
        });
        DaoAccountCapability{
            dao_address
        }
    }
    
    /// Provide a function to create signer with `DaoAccountCapability`
    public fun dao_signer(cap: &DaoAccountCapability): signer acquires DaoAccount {
        let signer_cap = &borrow_global<DaoAccount>(cap.dao_address).signer_cap;
        Account::create_signer_with_cap(signer_cap)
    }
    
    /// Sumbit upgrade plan for the Dao account
    /// This function is a shortcut for create signer with DaoAccountCapability and invoke `PackageTxnManager::submit_upgrade_plan_v2`
    public fun submit_upgrade_plan(cap: &DaoAccountCapability, package_hash: vector<u8>, version:u64, enforced: bool) acquires DaoAccount{
        let dao_signer = dao_signer(cap);
        PackageTxnManager::submit_upgrade_plan_v2(&dao_signer, package_hash, version, enforced);
    }

    /// Sumbit upgrade plan for the Dao account, sender must hold the `DaoAccountCapability`
    public(script) fun submit_upgrade_plan_entry(sender: signer, package_hash: vector<u8>, version:u64, enforced: bool) acquires DaoAccount, DaoAccountCapability{
        let addr = Signer::address_of(&sender);
        let cap = borrow_global<DaoAccountCapability>(addr);
        submit_upgrade_plan(cap, package_hash, version, enforced) 
    }
}