//# init -n dev

//# faucet --addr alice --amount 0

//# run --signers alice
script {
    use StarcoinFramework::STC::{STC};
    use StarcoinFramework::Signer;
    use StarcoinFramework::Account;
    use StarcoinFramework::Token;

    fun main(account: signer) {
        let addr: address = Signer::address_of(&account);

        let coin = Token::zero<STC>();
        Account::deposit_to_self<STC>(&account, coin);

        Account::remove_zero_balance<STC>(&account);

        Account::set_auto_accept_token(&account, false);
        assert!(!Account::is_accept_token<STC>(addr), 101);
    }
}
// check: EXECUTED