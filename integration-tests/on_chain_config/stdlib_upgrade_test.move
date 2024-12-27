//# init -n dev

//# faucet --addr alice --amount 10000000000

//# faucet --addr Genesis --amount 10000000000

//# run --signers StarcoinAssociation
script {
    use StarcoinFramework::FrozenConfigStrategy;

    fun do_initialize_config(account: signer) {
        FrozenConfigStrategy::do_initialize(&account);
    }
}
// check: EXECUTED

//# run --signers StarcoinAssociation
script {
    use StarcoinFramework::FrozenConfigStrategy;

    fun add_alice_into_the_frozen_list(account: signer) {
        FrozenConfigStrategy::add_account(account, @alice);
        assert!(FrozenConfigStrategy::has_frozen_account(@alice), 10010);
    }
}
// check: EXECUTED

//# run --signers StarcoinAssociation
script {
    use StarcoinFramework::Debug;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Account;
    use StarcoinFramework::StdlibUpgradeScripts;

    fun burn_illegal_token_for_upgrade(account: signer) {
        Debug::print(&1111);
        StdlibUpgradeScripts::burn_illegal_token_from_frozen_address(account, @alice, 9999000000);
        let balance_1 = Account::balance<STC>(@alice);
        Debug::print(&2222);
        Debug::print(&balance_1);
        assert!(balance_1 == 1000000, 10010);
    }
}
// check: EXECUTED