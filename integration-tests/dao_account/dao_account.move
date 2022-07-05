//# init -n dev

//# faucet --addr alice --amount 1000000


//# run --signers alice
script {
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Account;
    use StarcoinFramework::DaoAccount;
    use StarcoinFramework::Signer;

    fun main(sender: signer) {
        let dao_cap = DaoAccount::create_account(&sender);
        let dao_signer = DaoAccount::dao_signer(&dao_cap);
        let dao_address= Signer::address_of(&dao_signer);
        Account::pay_from<STC>(&sender, dao_address, 10000);
        let dao_balance = Account::balance<STC>(dao_address);
        assert!(dao_balance == 10000, 1001);
        DaoAccount::restore_dao_account_cap(&sender, dao_cap);
    }
}
// check: EXECUTED




//# run --signers alice
script {
    use StarcoinFramework::DaoAccount;
    use StarcoinFramework::Vector;

    fun main(sender: signer) {
        let dao_cap = DaoAccount::extract_dao_account_cap(&sender);
        let package_hash = Vector::empty<u8>();
        DaoAccount::submit_upgrade_plan(&dao_cap, package_hash, 2, false);
        DaoAccount::restore_dao_account_cap(&sender, dao_cap);
    }
}
// check: EXECUTED