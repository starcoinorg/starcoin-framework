module StarcoinFramework::FrozenConfigStrategy {
    use StarcoinFramework::Errors;
    use StarcoinFramework::ACL;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::FrozenConfig;

    const ERR_ADD_ACCOUNT_FAILED: u64 = 101;
    const ERR_REMOVE_ACCOUNT_FAILED: u64 = 102;

    public entry fun initialize(sender: &signer) {
        assert_config_address(sender);
        FrozenConfig::initialize(sender, frozen_list_v1());
    }

    public entry fun add_account(sender: &signer, account: address) {
        assert_config_address(sender);
        let acl = FrozenConfig::get_frozen_account_list(config_address());
        if (!ACL::contains(&acl, account)) {
            ACL::add(&mut acl, account);
            FrozenConfig::set_account_list(sender, acl);
        };
        let new_acl = FrozenConfig::get_frozen_account_list(config_address());
        assert!(ACL::contains(&new_acl, account), Errors::invalid_state(ERR_ADD_ACCOUNT_FAILED));
    }

    public entry fun remove_account(sender: &signer, account: address) {
        assert_config_address(sender);
        let acl = FrozenConfig::get_frozen_account_list(config_address());
        if (ACL::contains(&acl, account)) {
            ACL::remove(&mut acl, account);
            FrozenConfig::set_account_list(sender, acl);
        };
        let new_acl = FrozenConfig::get_frozen_account_list(config_address());
        assert!(!ACL::contains(&new_acl, account), Errors::invalid_state(ERR_REMOVE_ACCOUNT_FAILED));
    }

    public entry fun set_global_frozen(sender: &signer, frozen: bool) {
        assert_config_address(sender);
        FrozenConfig::set_global_frozen(sender, frozen);
    }

    public fun has_frozen_global(): bool {
        FrozenConfig::get_frozen_global(config_address())
    }

    public fun has_frozen_account(txn_sender: address): bool {
        let list = FrozenConfig::get_frozen_account_list(config_address());
        ACL::contains(&list, txn_sender)
    }

    public fun frozen_list_v1(): ACL::ACL {
        let acl = ACL::empty();
        // TODO(bob): To add the initialize frozen account list
        acl
    }

    fun config_address(): address {
        CoreAddresses::ASSOCIATION_ROOT_ADDRESS()
    }

    fun assert_config_address(sender: &signer) {
        CoreAddresses::assert_association_root_address(sender);
    }

}
