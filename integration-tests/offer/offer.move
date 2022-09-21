//# init -n dev

//# faucet --addr alice

//# faucet --addr bob

//# faucet --addr carol

//# run --signers alice
script {
    use StarcoinFramework::Account;
    use StarcoinFramework::Offer;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Token::Token;

    fun create_offer(account: signer) {
        let token = Account::withdraw<STC>(&account, 10000);
        Offer::create(&account, token, @bob, 5);
        // test Offer::exists_at
        assert!(Offer::exists_at<Token<STC>>(Signer::address_of(&account)), 1001);
        // test Offer::address_of
        assert!(Offer::address_of<Token<STC>>(Signer::address_of(&account)) == @bob, 1002);
    }
}
// check: EXECUTED

//! block-prologue
//! author: alice
//! block-time: 1000
//! block-number: 1



//# run --signers bob
script {
    use StarcoinFramework::Account;
    use StarcoinFramework::Offer;
    use StarcoinFramework::Token::Token;
    use StarcoinFramework::STC::STC;

    fun redeem_offer(account: signer) {
        let token = Offer::redeem<Token<STC>>(&account, @alice);
        Account::deposit_to_self(&account, token);
    }
}
// check: "Keep(ABORTED { code: 26117"

//# block --author alice --timestamp 86400000

//# run --signers carol
script {
    use StarcoinFramework::Account;
    use StarcoinFramework::Offer;
    use StarcoinFramework::Token::Token;
    use StarcoinFramework::STC::STC;

    fun redeem_offer(account: signer) {
        let token = Offer::redeem<Token<STC>>(&account, @alice);
        Account::deposit_to_self(&account, token);
    }
}
// check: "Keep(ABORTED { code: 25863"

//# block --author alice --timestamp 86405000

//# run --signers bob
script {
    use StarcoinFramework::Account;
    use StarcoinFramework::Offer;
    use StarcoinFramework::Token::Token;
    use StarcoinFramework::STC::STC;

    fun redeem_offer(account: signer) {
        let token = Offer::redeem<Token<STC>>(&account, @alice);
        Account::deposit_to_self(&account, token);
    }
}
// check: EXECUTED


//# run --signers alice
script {
    use StarcoinFramework::Account;
    use StarcoinFramework::Offer;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Token::Token;

    fun create_offer_v2(account: signer) {
        let token = Account::withdraw<STC>(&account, 10000);
        Offer::create_v2(&account, token, @bob, 5);
        let token = Account::withdraw<STC>(&account, 10000);
        Offer::create_v2(&account, token, @bob, 10);
        let token = Account::withdraw<STC>(&account, 10000);
        Offer::create(&account, token, @bob, 10);
        // test Offer::exists_at_v2
        assert!(Offer::exists_at_v2<Token<STC>>(Signer::address_of(&account)), 1001);
        // test Offer::address_of_v2
        assert!(Offer::address_of_v2<Token<STC>>(Signer::address_of(&account), 0) == @bob, 1002);
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use StarcoinFramework::Account;
    use StarcoinFramework::Offer;
    use StarcoinFramework::Token::Token;
    use StarcoinFramework::STC::STC;

    fun redeem_offer_v2(account: signer) {
        let token = Offer::redeem_v2<Token<STC>>(&account, @alice, 0);
        Account::deposit_to_self(&account, token);
    }
}
// check: "Keep(ABORTED { code: 26117"

//# block --author alice --timestamp 86410000

//# run --signers carol
script {
    use StarcoinFramework::Offer;
    use StarcoinFramework::Token::Token;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Option;
    use StarcoinFramework::STC::STC;

    fun redeem_offer_v2(_account: signer) {
        let op_offer_infos = Offer::get_offers_infos<Token<STC>>(@alice);
        assert!(Option::is_some(&op_offer_infos), 101);
        let offer_infos = Option::destroy_some(op_offer_infos);
        let offers_length = Offer::get_offers_length<Token<STC>>(@alice);
        assert!(Vector::length(&offer_infos) == 2, 102);
        assert!(offers_length == 2,103);
        let ( for, time_lock) = Offer::unpack_Offer_info(Vector::remove(&mut offer_infos, 0));
        assert!(for == @bob, 104);
        assert!(time_lock == 86410, 105);

        let op_idx = Offer::find_offer<Token<STC>>(@alice, @bob);
        assert!(Option::is_some(&op_idx), 106);
        assert!(Option::destroy_some(op_idx) == 0, 107);
    }
}
// check: "Keep(ABORTED { code: 25863"

//# run --signers bob
script {
    use StarcoinFramework::Account;
    use StarcoinFramework::Offer;
    use StarcoinFramework::Token::Token;
    use StarcoinFramework::STC::STC;

    fun redeem_offer_v2(account: signer) {
        let token = Offer::redeem_v2<Token<STC>>(&account, @alice, 0);
        Account::deposit_to_self(&account, token);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use StarcoinFramework::Account;
    use StarcoinFramework::Offer;
    use StarcoinFramework::Token::Token;
    use StarcoinFramework::STC::STC;

    fun retake_offer(account: signer) {
        let token = Offer::retake_v2<Token<STC>>(&account, 0);
        Account::deposit_to_self(&account, token);
        let token = Offer::retake<Token<STC>>(&account);
        Account::deposit_to_self(&account, token);
    }
}
// check: EXECUTED
