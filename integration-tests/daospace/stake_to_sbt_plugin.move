//# init -n dev

//# faucet --addr creator --amount 1000000000000000

//# faucet --addr alice --amount 1000000000000000

//# block --author 0x1 --timestamp 86400000

//# run --signers creator
script {
    use StarcoinFramework::StdlibUpgradeScripts;

    fun upgrade_from_v11_to_v12() {
        StdlibUpgradeScripts::upgrade_from_v11_to_v12();
    }
}
// check: EXECUTED

//# run --signers creator
script {
    use StarcoinFramework::StdlibUpgradeScripts;

    fun upgrade_from_v11_to_v12() {
        StdlibUpgradeScripts::upgrade_from_v12_to_v12_1();
    }
}
// check: EXECUTED

//# publish
module creator::XDAO {
    use StarcoinFramework::DAOAccount;
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::StakeToSBTPlugin::StakeToSBTPlugin;
    use StarcoinFramework::StakeToSBTPlugin;
    use StarcoinFramework::STC;
    use StarcoinFramework::Option;

    struct X has store {}

    const NAME: vector<u8> = b"X";

    /// directly upgrade the sender account to DAOAccount and create DAO
    public(script) fun create_dao(
        sender: signer,
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        min_proposal_deposit: u128) {
        let dao_account_cap = DAOAccount::upgrade_to_dao(sender);
        //let dao_signer = DAOAccount::dao_signer(&dao_account_cap);
        let config = DAOSpace::new_dao_config(
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            min_proposal_deposit,
        );
        let dao_root_cap = DAOSpace::create_dao<X>(dao_account_cap, *&NAME, Option::none<vector<u8>>(), Option::none<vector<u8>>(),b"ipfs://description", X {}, config);

        DAOSpace::install_plugin_with_root_cap<X, StakeToSBTPlugin>(&dao_root_cap, 1, StakeToSBTPlugin::required_caps());
        StakeToSBTPlugin::accept_token_with_root_cap<X, STC::STC>(&dao_root_cap);

        StakeToSBTPlugin::set_sbt_weight_with_root_cap<X, STC::STC>(&dao_root_cap, 10, 2000);

        DAOSpace::burn_root_cap(dao_root_cap);
    }
}
// check: EXECUTED

//# run --signers creator
script {
    use creator::XDAO;

    fun create_dao(sender: signer) {
        XDAO::create_dao(sender, 10, 10, 10, 10, 10);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use creator::XDAO;
    use StarcoinFramework::StakeToSBTPlugin;
    use StarcoinFramework::STC;
    use StarcoinFramework::Token;
    use StarcoinFramework::Account;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Debug;

    fun stake_and_check(sender: signer) {
        let token = Account::withdraw<STC::STC>(
            &sender, 1 * Token::scaling_factor<STC::STC>());
        StakeToSBTPlugin::stake<XDAO::X, STC::STC>(&sender, token, 10);

        let (
            stake_time,
            lock_time,
            weight,
            sbt_amount,
            token_amount
        ) = StakeToSBTPlugin::query_stake<XDAO::X, STC::STC>(Signer::address_of(&sender), 1);

        Debug::print(&stake_time);
        Debug::print(&lock_time);
        Debug::print(&weight);
        Debug::print(&sbt_amount);
        Debug::print(&token_amount);

        assert!(stake_time == 86400, 1001);
        assert!(lock_time == 10, 1002);
        assert!(weight == 2000, 1003);
        assert!(sbt_amount == 2000, 1004);
        assert!(token_amount == 1000000000, 1005);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use creator::XDAO;
    use StarcoinFramework::StakeToSBTPlugin;
    use StarcoinFramework::STC;
    use StarcoinFramework::Signer;

    fun unstake_all_failed(sender: signer) {
        StakeToSBTPlugin::unstake_all<XDAO::X, STC::STC>(Signer::address_of(&sender));
    }
}
// check: ABORTED

//# block --author 0x1 --timestamp 87400000

//# run --signers alice
script {
    use creator::XDAO;
    use StarcoinFramework::StakeToSBTPlugin;
    use StarcoinFramework::STC;
    use StarcoinFramework::Signer;

    fun stake(sender: signer) {
        let user = Signer::address_of(&sender);
        StakeToSBTPlugin::unstake_all<XDAO::X, STC::STC>(user);
        assert!(StakeToSBTPlugin::query_stake_count<XDAO::X, STC::STC>(user) <= 0, 10001);
    }
}
// check: CHECKED

//# run --signers alice
script {
    use creator::XDAO;
    use StarcoinFramework::StakeToSBTPlugin;
    use StarcoinFramework::STC;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Account;
    use StarcoinFramework::Token;

    fun stake_again(sender: signer) {
        let user_addr = Signer::address_of(&sender);
        let token = Account::withdraw<STC::STC>(&sender, 1 * Token::scaling_factor<STC::STC>());
        StakeToSBTPlugin::stake<XDAO::X, STC::STC>(&sender, token, 10);
        assert!(StakeToSBTPlugin::query_stake_count<XDAO::X, STC::STC>(user_addr) > 0, 10002);
    }
}
// check: CHECKED

//# block --author 0x1 --timestamp 89400000

//# run --signers alice
script {
    use creator::XDAO;
    use StarcoinFramework::StakeToSBTPlugin;
    use StarcoinFramework::STC;
    use StarcoinFramework::Signer;

    fun stake_again(sender: signer) {
        let sender_addr = Signer::address_of(&sender);
        StakeToSBTPlugin::unstake_by_id<XDAO::X, STC::STC>(sender_addr, 2);
        assert!(StakeToSBTPlugin::query_stake_count<XDAO::X, STC::STC>(sender_addr) <= 0, 10003);
    }
}
// check: CHECKED

//# run --signers alice
script {
    use creator::XDAO;
    use StarcoinFramework::StakeToSBTPlugin;
    use StarcoinFramework::STC;
    use StarcoinFramework::Token;
    use StarcoinFramework::Account;
    use StarcoinFramework::DAOSpace;

    fun stake_for_quit(sender: signer) {
        let token = Account::withdraw<STC::STC>(&sender, 1 * Token::scaling_factor<STC::STC>());

        assert!(StakeToSBTPlugin::stake<XDAO::X, STC::STC>(&sender, token, 10) == 3, 10004);
        DAOSpace::quit_member<XDAO::X>(&sender);
    }
}
// check: CHECKED

//# block --author 0x1 --timestamp 89500000

//# run --signers alice
script {
    use creator::XDAO;
    use StarcoinFramework::StakeToSBTPlugin;
    use StarcoinFramework::STC;
    use StarcoinFramework::Signer;
    use StarcoinFramework::DAOSpace;

    fun quit_and_unstake(sender: signer) {
        let sender_addr = Signer::address_of(&sender);
        assert!(!DAOSpace::is_member<XDAO::X>(sender_addr), 10005);
        StakeToSBTPlugin::unstake_by_id<XDAO::X, STC::STC>(sender_addr, 3);
        assert!(StakeToSBTPlugin::query_stake_count<XDAO::X, STC::STC>(sender_addr) <= 0, 10006);
    }
}
// check: CHECKED