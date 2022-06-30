module StarcoinFramework::DaoAccount{
    use StarcoinFramework::Account::{Self, SignerCapability};
    use StarcoinFramework::PackageTxnManager;
    use StarcoinFramework::Option;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;

    spec module {
        pragma verify = false;
        pragma aborts_if_is_strict = true;
    }

    const ERR_ACCOUNT_CAP_NOT_EXISTS:u64 = 100;

    /// DaoAccount
    struct DaoAccount has key{
        dao_address: address,
        signer_cap: SignerCapability,
    }

    /// This capability can control the Dao account
    struct DaoAccountCap has store, key{
        dao_address: address,
    }
    
    /// Create a new Dao Account and return DaoAccountCap
    /// Dao Account is a delegate account, the `creator` has the `DaoAccountCap` 
    public fun create_account(creator: &signer): DaoAccountCap {
        let (dao_address, signer_cap) = Account::create_delegate_account(creator);
        let dao_signer = Account::create_signer_with_cap(&signer_cap);

        PackageTxnManager::update_module_upgrade_strategy(&dao_signer, PackageTxnManager::get_strategy_two_phase(), Option::some(0));
        move_to(&dao_signer, DaoAccount{
            dao_address,
            signer_cap: signer_cap,
        });
        DaoAccountCap{
            dao_address
        }
    }

    /// Entry function for create dao account, the `DaoAccountCap` save to the `creator` account
    public(script) fun create_account_entry(sender: signer){
        let cap = create_account(&sender);
        move_to(&sender, cap);
    }

    public fun extract_dao_account_cap(sender: &signer): DaoAccountCap acquires DaoAccountCap {
        let sender_addr = Signer::address_of(sender);
        assert!(exists<DaoAccountCap>(sender_addr), Errors::not_published(ERR_ACCOUNT_CAP_NOT_EXISTS));
        move_from<DaoAccountCap>(sender_addr)
    }

    /// Upgrade `sender` account to Dao account
    public fun upgrade_to_dao(sender: signer): DaoAccountCap {
        //TODO assert sender not Dao
        let signer_cap = Account::remove_signer_capability(&sender);
        //TODO check the account upgrade_strategy
        PackageTxnManager::update_module_upgrade_strategy(&sender, PackageTxnManager::get_strategy_two_phase(), Option::some(0));
        let dao_address = Signer::address_of(&sender);
        move_to(&sender, DaoAccount{
            dao_address,
            signer_cap: signer_cap,
        });
        DaoAccountCap{
            dao_address
        }
    }
    
    /// Provide a function to create signer with `DaoAccountCap`
    public fun dao_signer(cap: &DaoAccountCap): signer acquires DaoAccount {
        let signer_cap = &borrow_global<DaoAccount>(cap.dao_address).signer_cap;
        Account::create_signer_with_cap(signer_cap)
    }
    
    /// Sumbit upgrade plan for the Dao account
    /// This function is a shortcut for create signer with DaoAccountCap and invoke `PackageTxnManager::submit_upgrade_plan_v2`
    public fun submit_upgrade_plan(cap: &DaoAccountCap, package_hash: vector<u8>, version:u64, enforced: bool) acquires DaoAccount{
        let dao_signer = dao_signer(cap);
        PackageTxnManager::submit_upgrade_plan_v2(&dao_signer, package_hash, version, enforced);
    }

    /// Sumbit upgrade plan for the Dao account, sender must hold the `DaoAccountCap`
    public(script) fun submit_upgrade_plan_entry(sender: signer, package_hash: vector<u8>, version:u64, enforced: bool) acquires DaoAccount, DaoAccountCap{
        let addr = Signer::address_of(&sender);
        let cap = borrow_global<DaoAccountCap>(addr);
        submit_upgrade_plan(cap, package_hash, version, enforced) 
    }
}