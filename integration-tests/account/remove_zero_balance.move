//# init -n dev

//# faucet --addr alice

//# run --signers alice
script {
    use StarcoinFramework::DummyToken::DummyToken;
    use StarcoinFramework::Account;
    use StarcoinFramework::Token;

    fun main(account: signer) {
        let coin = Token::zero<DummyToken>();
        Account::deposit_to_self<DummyToken>(&account, coin);
        Account::remove_zero_balance<DummyToken>(&account);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use StarcoinFramework::DummyToken::{Self, DummyToken};
    use StarcoinFramework::Account;

    fun main(account: signer) {
        let coin = DummyToken::mint(&account, 10000);
        Account::deposit_to_self<DummyToken>(&account, coin);
        Account::remove_zero_balance<DummyToken>(&account);
    }
}
// check: ABORTED