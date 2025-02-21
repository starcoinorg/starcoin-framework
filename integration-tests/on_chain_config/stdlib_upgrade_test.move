//# init -n dev

//# faucet --addr alice --amount 10000000000

//# faucet --addr Genesis


//# run --signers alice
script {
    use StarcoinFramework::Debug;
    use StarcoinFramework::Signer;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Account;
    use StarcoinFramework::StdlibUpgradeScripts;

    fun burn_illegal_token_for_upgrade(sender: signer) {
        let sender_addr = Signer::address_of(&sender);
        Debug::print(&sender_addr);
        let balance = Account::balance<STC>(sender_addr);
        Debug::print(&balance);
        StdlibUpgradeScripts::burn_illegal_token(sender, 9999000000);
        let balance_1 = Account::balance<STC>(sender_addr);
        Debug::print(&balance_1);
        assert!(balance_1 <= 1000000, 10010);
    }
}
// check: EXECUTED

//# run --signers Genesis
script {
    use StarcoinFramework::Debug;
    use StarcoinFramework::Signer;
    use StarcoinFramework::StdlibUpgradeScripts;
    use StarcoinFramework::ConsensusConfig;
    fun upgrade_from_v12_to_v13(sender: signer) {
        let sender_addr = Signer::address_of(&sender);
        Debug::print(&sender_addr);
        StdlibUpgradeScripts::upgrade_from_v12_to_v13(sender);
        let consensus_config = ConsensusConfig::get_config();
        assert!(ConsensusConfig::base_max_uncles_per_block(&consensus_config) == 16, 10011);
    }
}
// check: EXECUTED

