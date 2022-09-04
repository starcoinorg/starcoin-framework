//# init -n dev

//# faucet --addr creator --amount 100000000000

//# faucet --addr alice --amount 10000000000

//# faucet --addr bob --amount 10000000000

//# publish
module creator::DAOHelper {
    use StarcoinFramework::DAOAccount;
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::Option;

    struct X has store, copy, drop {
        value: u64,
    }

    const NAME: vector<u8> = b"X";

    /// directly upgrade the sender account to DAOAccount and create DAO
    public(script) fun create_dao(
        sender: signer,
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        min_proposal_deposit: u128, ) {
        let dao_account_cap = DAOAccount::upgrade_to_dao(sender);


        //let dao_signer = DAOAccount::dao_signer(&dao_account_cap);
        let config = DAOSpace::new_dao_config(
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            min_proposal_deposit,
        );
        let dao_ext = X { value: 0};
        let dao_root_cap = DAOSpace::create_dao<X>(dao_account_cap, *&NAME, Option::none<vector<u8>>(), Option::none<vector<u8>>(), b"ipfs://description", dao_ext, config);

        DAOSpace::burn_root_cap(dao_root_cap);
    }

    public fun modify_ext(value: u64): u64 {
        let witness = X { value: 0 };
        let X { value: old_value } = DAOSpace::take_ext(&witness);
        DAOSpace::save_ext(X { value });
        old_value
    }
}

//# block --author 0x1 --timestamp 86400000

//# run --signers creator
script {
    use creator::DAOHelper;

    fun main(sender: signer) {
        // time unit is millsecond
        DAOHelper::create_dao(sender, 10000, 3600000, 2, 10000, 10);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use creator::DAOHelper;

    fun main(_sender: signer) {
        let ext_value = DAOHelper::modify_ext(123);
        assert!(ext_value == 0, 101);
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use creator::DAOHelper;

    fun main(_sender: signer) {
        let ext_value = DAOHelper::modify_ext(234);
        assert!(ext_value == 123, 101);
    }
}
// check: EXECUTED
