module StarcoinFramework::DaoAccount{
    use StarcoinFramework::Account::{Self, SignerCapability};
    use StarcoinFramework::PackageTxnManager::{Self, UpgradePlanCapability};
    use StarcoinFramework::Option;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Version;
    use StarcoinFramework::Config;

    spec module {
        pragma verify = false;
        pragma aborts_if_is_strict = true;
    }

    const ERR_ACCOUNT_CAP_NOT_EXISTS:u64 = 100;

    /// DaoAccount
    struct DaoAccount has key{
        dao_address: address,
        signer_cap: SignerCapability,
        upgrade_plan_cap: UpgradePlanCapability,
    }

    /// This capability can control the Dao account
    struct DaoAccountCap has store, key{
        dao_address: address,
    }
    
    /// Create a new Dao Account and return DaoAccountCap
    /// Dao Account is a delegate account, the `creator` has the `DaoAccountCap` 
    public fun create_account(creator: &signer): DaoAccountCap {
        let (_dao_address, signer_cap) = Account::create_delegate_account(creator);
        upgrade_to_dao_with_signer_cap(signer_cap)
    }

    /// Entry function for create dao account, the `DaoAccountCap` save to the `creator` account
    public(script) fun create_account_entry(sender: signer){
        let cap = create_account(&sender);
        move_to(&sender, cap);
    }

    /// Extract the DaoAccountCap from the `sender`
    public fun extract_dao_account_cap(sender: &signer): DaoAccountCap acquires DaoAccountCap {
        let sender_addr = Signer::address_of(sender);
        assert!(exists<DaoAccountCap>(sender_addr), Errors::not_published(ERR_ACCOUNT_CAP_NOT_EXISTS));
        move_from<DaoAccountCap>(sender_addr)
    }

    /// Restore the DaoAccountCap to the `sender`
    public fun restore_dao_account_cap(sender: &signer, cap: DaoAccountCap) {
        move_to(sender, cap)
    }

    /// Upgrade `sender` account to Dao account
    public fun upgrade_to_dao(sender: signer): DaoAccountCap {
        let signer_cap = Account::remove_signer_capability(&sender);
        upgrade_to_dao_with_signer_cap(signer_cap)
    }

     /// Upgrade the account which have the `signer_cap` to a Dao Account
    public fun upgrade_to_dao_with_signer_cap(signer_cap: SignerCapability): DaoAccountCap {
       let dao_signer = Account::create_signer_with_cap(&signer_cap);
       let dao_address = Signer::address_of(&dao_signer);
 
        let upgrade_plan_cap = if(Config::config_exist_by_address<Version::Version>(dao_address)){
            //TODO if the account has extract the upgrade plan cap
            PackageTxnManager::extract_submit_upgrade_plan_cap(&dao_signer)
        }else{
            Config::publish_new_config<Version::Version>(&dao_signer, Version::new_version(1));
            PackageTxnManager::update_module_upgrade_strategy(&dao_signer, PackageTxnManager::get_strategy_two_phase(), Option::some(1));
            PackageTxnManager::extract_submit_upgrade_plan_cap(&dao_signer)
        };
        move_to(&dao_signer, DaoAccount{
            dao_address,
            signer_cap,
            upgrade_plan_cap,
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
        let upgrade_plan_cap = &borrow_global<DaoAccount>(cap.dao_address).upgrade_plan_cap;
        PackageTxnManager::submit_upgrade_plan_with_cap_v2(upgrade_plan_cap, package_hash, version, enforced);
    }

    /// Sumbit upgrade plan for the Dao account, sender must hold the `DaoAccountCap`
    public(script) fun submit_upgrade_plan_entry(sender: signer, package_hash: vector<u8>, version:u64, enforced: bool) acquires DaoAccount, DaoAccountCap{
        let addr = Signer::address_of(&sender);
        let cap = borrow_global<DaoAccountCap>(addr);
        submit_upgrade_plan(cap, package_hash, version, enforced) 
    }
}