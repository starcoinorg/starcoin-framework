//# init -n dev

//# faucet --addr Genesis --amount 1000000000000

//# faucet --addr alice --amount 10000000

//# run --signers alice
// create txn sender account
script {
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Account;
    use StarcoinFramework::Authenticator;
    use StarcoinFramework::DummyToken;
    use StarcoinFramework::DummyToken::DummyToken;

    fun main(account: signer) {
        let txn_public_key = x"c48b687a1dd8265101b33df6ae0b6825234e3f28df9ecb38fb286cf76dae919d";
        let auth_key_vec = Authenticator::ed25519_authentication_key(copy txn_public_key);
        let address = Authenticator::derived_address(auth_key_vec);
        Account::create_account_with_address<STC>(address);
        Account::pay_from<STC>(&account, address, 5000);
        let coin = DummyToken::mint(&account, 500);
        Account::deposit(address, coin);
        assert!(Account::balance<DummyToken>(address) == 500, 1000);

    }
}
// check: EXECUTED

//# run --signers alice
// prologue sender is not genesis
script {
    use StarcoinFramework::TransactionManager;
    use StarcoinFramework::Account;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Authenticator;
    use StarcoinFramework::Vector;
    fun main(account: signer) {
        let txn_public_key = x"c48b687a1dd8265101b33df6ae0b6825234e3f28df9ecb38fb286cf76dae919d";
        let auth_key_vec = Authenticator::ed25519_authentication_key(copy txn_public_key);
        let txn_sender = Authenticator::derived_address(copy auth_key_vec);
        Vector::push_back(&mut txn_public_key, 0u8); //create preimage

        let seq = Account::sequence_number(txn_sender);
        assert!(seq == 0, 1001);
        let balance = Account::balance<STC>(txn_sender);
        assert!(balance == 5000, 1001);

        let txn_sequence_number = 0;
        let txn_gas_price = 1;
        let txn_max_gas_units = 1000;

        TransactionManager::txn_prologue_v2<STC>(
            &account,
            txn_sender,
            txn_sequence_number,
            txn_public_key,
            txn_gas_price,
            txn_max_gas_units,
            1,1
        );
    }
}
// check: "Keep(ABORTED { code: 2818"



//# run --signers Genesis
// gas is not enough
script {
    use StarcoinFramework::Account;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Authenticator;
    use StarcoinFramework::Vector;
    fun main(account: signer) {
        let txn_public_key = x"c48b687a1dd8265101b33df6ae0b6825234e3f28df9ecb38fb286cf76dae919d";
        let auth_key_vec = Authenticator::ed25519_authentication_key(copy txn_public_key);
        let txn_sender = Authenticator::derived_address(copy auth_key_vec);
        Vector::push_back(&mut txn_public_key, 0u8); //create preimage

        let txn_sequence_number = 0;
        let txn_gas_price = 1;
        let txn_max_gas_units = 10000; //EPROLOGUE_CANT_PAY_GAS_DEPOSIT
        Account::txn_prologue<STC>(
            &account,
            txn_sender,
            txn_sequence_number,
            txn_public_key,
            txn_gas_price,
            txn_max_gas_units
        );
    }
}
// check: "Keep(ABORTED { code: 1031"



//# run --signers Genesis
// invalid pub key
script {
    use StarcoinFramework::Account;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Authenticator;
    use StarcoinFramework::Vector;
    fun main(account: signer) {
        let txn_public_key = x"c48b687a1dd8265101b33df6ae0b6825234e3f28df9ecb38fb286cf76dae919d";
        let auth_key_vec = Authenticator::ed25519_authentication_key(copy txn_public_key);
        let txn_sender = Authenticator::derived_address(copy auth_key_vec);
        Vector::push_back(&mut txn_public_key, 0u8); //create preimage

        let wrong_txn_public_key = x"c48b687a";
        let txn_sequence_number = 0;
        let txn_gas_price = 1;
        let txn_max_gas_units = 1000;

        Account::txn_prologue<STC>(
            &account,
            txn_sender,
            txn_sequence_number,
            wrong_txn_public_key, //EPROLOGUE_INVALID_ACCOUNT_AUTH_KEY
            txn_gas_price,
            txn_max_gas_units
        );
    }
}
// check: "Keep(ABORTED { code: 263"



//# run --signers Genesis
// sequence number too new
script {
    use StarcoinFramework::Account;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Authenticator;
    use StarcoinFramework::Vector;
    fun main(account: signer) {
        let txn_public_key = x"c48b687a1dd8265101b33df6ae0b6825234e3f28df9ecb38fb286cf76dae919d";
        let auth_key_vec = Authenticator::ed25519_authentication_key(copy txn_public_key);
        let txn_sender = Authenticator::derived_address(copy auth_key_vec);
        Vector::push_back(&mut txn_public_key, 0u8); //create preimage

        let seq = Account::sequence_number(txn_sender);
        assert!(seq == 0, 1005);

        let txn_sequence_number = 1; //EPROLOGUE_SEQUENCE_NUMBER_TOO_NEW
        let txn_gas_price = 1;
        let txn_max_gas_units = 1000;

        Account::txn_prologue<STC>(
            &account,
            txn_sender,
            txn_sequence_number,
            txn_public_key,
            txn_gas_price,
            txn_max_gas_units
        );
    }
}
// check: "Keep(ABORTED { code: 775"



//# run --signers Genesis
// successfully executed
script {
    use StarcoinFramework::TransactionManager;
    use StarcoinFramework::Account;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Authenticator;
    use StarcoinFramework::Vector;
    fun main(account: signer) {
        let txn_public_key = x"c48b687a1dd8265101b33df6ae0b6825234e3f28df9ecb38fb286cf76dae919d";
        let auth_key_vec = Authenticator::ed25519_authentication_key(copy txn_public_key);
        let txn_sender = Authenticator::derived_address(copy auth_key_vec);
        Vector::push_back(&mut txn_public_key, 0u8); //create preimage

        let seq = Account::sequence_number(txn_sender);
        assert!(seq == 0, 1005);

        let txn_sequence_number = 0;
        let txn_gas_price = 1;
        let txn_max_gas_units = 1000;

        TransactionManager::txn_prologue_v2<STC>(
            &account,
            txn_sender,
            txn_sequence_number,
            txn_public_key,
            txn_gas_price,
            txn_max_gas_units,1,1
        );

        // execute the txn...

        let gas_units_remaining = 10;

        Account::txn_epilogue<STC>(
            &account,
            txn_sender,
            txn_sequence_number,
            txn_gas_price,
            txn_max_gas_units,
            gas_units_remaining
        );
        let seq = Account::sequence_number(txn_sender);
        assert!(seq == 1, 1006);
    }
}
// check: EXECUTED



//# run --signers Genesis
// sequence number too old
script {
    use StarcoinFramework::Account;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Authenticator;
    use StarcoinFramework::Vector;
    fun main(account: signer) {
        let txn_public_key = x"c48b687a1dd8265101b33df6ae0b6825234e3f28df9ecb38fb286cf76dae919d";
        let auth_key_vec = Authenticator::ed25519_authentication_key(copy txn_public_key);
        let txn_sender = Authenticator::derived_address(copy auth_key_vec);
        Vector::push_back(&mut txn_public_key, 0u8); //create preimage

        let seq = Account::sequence_number(txn_sender);
        assert!(seq == 1, 1005);

        let txn_sequence_number = 0; //EPROLOGUE_SEQUENCE_NUMBER_TOO_OLD
        let txn_gas_price = 1;
        let txn_max_gas_units = 1000;

        Account::txn_prologue<STC>(
            &account,
            txn_sender,
            txn_sequence_number,
            txn_public_key,
            txn_gas_price,
            txn_max_gas_units
        );
    }
}
// check: "Keep(ABORTED { code: 519"



//# run --signers Genesis
// epilouge insufficient balance
script {
    use StarcoinFramework::Account;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Authenticator;
    use StarcoinFramework::Vector;
    fun main(account: signer) {
        let txn_public_key = x"c48b687a1dd8265101b33df6ae0b6825234e3f28df9ecb38fb286cf76dae919d";
        let auth_key_vec = Authenticator::ed25519_authentication_key(copy txn_public_key);
        let txn_sender = Authenticator::derived_address(copy auth_key_vec);
        Vector::push_back(&mut txn_public_key, 0u8); //create preimage

        let seq = Account::sequence_number(txn_sender);
        assert!(seq == 1, 1007);

        let txn_sequence_number = 1;
        let txn_gas_price = 1;
        let txn_max_gas_units = 6000; //EINSUFFICIENT_BALANCE
        let gas_units_remaining = 10;

        Account::txn_epilogue<STC>(
            &account,
            txn_sender,
            txn_sequence_number,
            txn_gas_price,
            txn_max_gas_units,
            gas_units_remaining
        );
    }
}
// check: "Keep(ABORTED { code: 2568"



//# run --signers alice
// epilogue sender is not genesis
script {
    use StarcoinFramework::Account;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Authenticator;
    use StarcoinFramework::Vector;
    fun main(account: signer) {
        let txn_public_key = x"c48b687a1dd8265101b33df6ae0b6825234e3f28df9ecb38fb286cf76dae919d";
        let auth_key_vec = Authenticator::ed25519_authentication_key(copy txn_public_key);
        let txn_sender = Authenticator::derived_address(copy auth_key_vec);
        Vector::push_back(&mut txn_public_key, 0u8); //create preimage

        let seq = Account::sequence_number(txn_sender);
        assert!(seq == 1, 1007);

        let txn_sequence_number = 1;
        let txn_gas_price = 1;
        let txn_max_gas_units = 1000;
        let gas_units_remaining = 10;

        Account::txn_epilogue<STC>(
            &account,
            txn_sender,
            txn_sequence_number,
            txn_gas_price,
            txn_max_gas_units,
            gas_units_remaining
        );
    }
}
// check: "Keep(ABORTED { code: 2818"

//# run --signers Genesis
// epilouge cant pay gas deposit

script {
    use StarcoinFramework::Account;
    use StarcoinFramework::Authenticator;
    use StarcoinFramework::Vector;
    use StarcoinFramework::DummyToken::DummyToken;

    fun main(account: signer) {
        let txn_public_key = x"c48b687a1dd8265101b33df6ae0b6825234e3f28df9ecb38fb286cf76dae919d";
        let auth_key_vec = Authenticator::ed25519_authentication_key(copy txn_public_key);
        let txn_sender = Authenticator::derived_address(copy auth_key_vec);
        Vector::push_back(&mut txn_public_key, 0u8); //create preimage

        let seq = Account::sequence_number(txn_sender);
        assert!(seq == 1, 1005);

        let txn_sequence_number = 1;
        let txn_gas_price = 1;
        let txn_max_gas_units = 2510;
        Account::do_accept_token<DummyToken>(&account);

        Account::txn_prologue_v2<DummyToken>(
            &account,
            txn_sender,
            txn_sequence_number,
            txn_public_key,
            txn_gas_price,
            txn_max_gas_units,
            2,
            10,
        );
    }

}
// check: "Keep(ABORTED { code: 1031"

//# run --signers Genesis
script {
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Account::{deposit, withdraw};
    use StarcoinFramework::EasyGas;
    fun main(account: signer){
        EasyGas::initialize(&account,@0x1,b"DummyToken",b"DummyToken",@alice);
        let token = withdraw<STC>(&account,100000000000);
        deposit(EasyGas::get_gas_fee_address(), token);
    }
}
//check: EXECUTED

//# run --signers Genesis
// successfully executed
script {
    use StarcoinFramework::TransactionManager;
    use StarcoinFramework::Account;
    use StarcoinFramework::Authenticator;
    use StarcoinFramework::Vector;
    use StarcoinFramework::DummyToken::DummyToken;

    fun main(account: signer) {
        let txn_public_key = x"c48b687a1dd8265101b33df6ae0b6825234e3f28df9ecb38fb286cf76dae919d";
        let auth_key_vec = Authenticator::ed25519_authentication_key(copy txn_public_key);
        let txn_sender = Authenticator::derived_address(copy auth_key_vec);
        Vector::push_back(&mut txn_public_key, 0u8); //create preimage
        let seq = Account::sequence_number(txn_sender);
        assert!(seq == 1, 1005);

        let txn_sequence_number = 1;
        let txn_gas_price = 1;
        let txn_max_gas_units = 2500;
        Account::do_accept_token<DummyToken>(&account);

        TransactionManager::txn_prologue_v2<DummyToken>(
            &account,
            txn_sender,
            txn_sequence_number,
            txn_public_key,
            txn_gas_price,
            txn_max_gas_units,
            2,
            10,
        );
        // execute the txn...
        let gas_units_remaining = 10;
        TransactionManager::txn_epilogue_v3<DummyToken>(
            &account,
            txn_sender,
            txn_sequence_number,
            Vector::empty(),
            txn_gas_price,
            txn_max_gas_units,
            gas_units_remaining,
            2,
            10,
        );
        let seq = Account::sequence_number(txn_sender);
        assert!(seq == 2, 1006);
    }

}
// check: EXECUTED


//# run --signers Genesis
script {
    use StarcoinFramework::Account;

    fun main(_account: signer){
        let (txn_gas_price, txn_max_gas_units, gas_units_remaining,
            stc_price, stc_price_scaling
        ) = (1, 100000, 0, 43793, 1000000000000000);
        let (stc_amount, token_amount) = Account::transaction_fee_simulate(txn_gas_price, txn_max_gas_units, gas_units_remaining,
            stc_price, stc_price_scaling);
        assert!(stc_amount==100000, 100);
        assert!(token_amount==1, 101);

        let (txn_gas_price, txn_max_gas_units, gas_units_remaining,
            stc_price, stc_price_scaling
        ) = (1000000, 100000, 0, 43793, 1000000000000000);
        let (stc_amount, token_amount) = Account::transaction_fee_simulate(txn_gas_price, txn_max_gas_units, gas_units_remaining,
            stc_price, stc_price_scaling);
        assert!(stc_amount==100000000000, 102);
        assert!(token_amount==4, 103);
        
    }
}
// check: EXECUTED
