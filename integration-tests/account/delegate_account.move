//# init -n dev

//# faucet --addr bob --amount 2000000000

//# faucet --addr alice

//# faucet --addr default

//# publish
module default::Holder {

    struct Hold<T> has key, store {
        x: T
    }

    public fun hold<T: store>(account: &signer, x: T) {
        move_to(account, Hold<T>{x})
    }

    public fun get<T: store>(account: address): T
    acquires Hold {
        let Hold {x} = move_from<Hold<T>>(account);
        x
    }
}

//# run --signers bob

script {
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Account;
    use StarcoinFramework::Signer;
    use default::Holder;    

    fun main(sender: signer) {
        let (new_address, signer_cap) = Account::create_delegate_account(&sender);    
        // transfer STC to new account
        Account::pay_from<STC>(&sender, new_address, 10000);
        let new_account_signer = Account::create_signer_with_cap(&signer_cap);
        assert!(new_address == Signer::address_of(&new_account_signer), 1000);
        Holder::hold(&sender, signer_cap);
    }
}
// check: EXECUTED


//# run --signers alice
script {
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Account::{Self, SignerCapability};
    use default::Holder;
    fun main(sender: signer) {
        let contract_account_signer_cap = Holder::get<SignerCapability>(@bob);
        //alice withdraw from contract account and deposit to self.
        let contract_account = Account::create_signer_with_cap(&contract_account_signer_cap);
        let stc = Account::withdraw<STC>(&contract_account, 10000);
        Account::deposit_to_self(&sender, stc);
        Holder::hold(&sender, contract_account_signer_cap);
    }
}

// check: EXECUTED
