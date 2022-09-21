module StarcoinFramework::PackageTxnManagerUpgradeScripts {
    use StarcoinFramework::Account;
    use StarcoinFramework::Errors;
    use StarcoinFramework::PackageTxnManager::{Self, UpgradePlanCapability};

    const ERR_ADDRESS_NOT_MATCH: u64 = 100;

    /// Used for
    public fun claim_upgrade_plan_event_with_cap(account_address: address, cap: &UpgradePlanCapability) {
        let addr_ref = PackageTxnManager::account_address(cap);
        assert!(addr_ref == account_address, Errors::invalid_argument(ERR_ADDRESS_NOT_MATCH));
        let signer_cap = Account::get_capability_for(account_address);
        let temp_signer = Account::create_signer_with_cap(&signer_cap);
        PackageTxnManager::claim_upgrade_plan_event(&temp_signer);
        Account::destroy_signer_cap(signer_cap);
    }

    public(script) fun claim_upgrade_plan_event_entry(sender: signer) {
        PackageTxnManager::claim_upgrade_plan_event(&sender);
    }
}