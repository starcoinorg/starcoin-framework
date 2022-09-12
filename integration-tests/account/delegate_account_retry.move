//# init -n dev

//# faucet --addr alice --amount 2000000000

//# run --signers alice

script {
    use StarcoinFramework::Account;

    fun main(sender: signer) {
        let (_new_address, signer_cap) = Account::create_delegate_account(&sender);    
        let new_account_signer = Account::create_signer_with_cap(&signer_cap);

        let (address_0, cap_0) = Account::create_delegate_account(&new_account_signer); 
        let i = 1;
        while(i < 10){
            let (address_i, cap_i) = Account::create_delegate_account(&new_account_signer);
            assert!(address_0 != address_i, 1000);
            Account::destroy_signer_cap(cap_i);
            i = i + 1;
        };
        Account::destroy_signer_cap(cap_0);
        Account::destroy_signer_cap(signer_cap);
    }
}
// check: EXECUTED

