address StarcoinFramework {
/// `TransactionManager` manages:
/// 1. prologue and epilogue of transactions.
/// 2. prologue of blocks.
module TransactionManager {
    use StarcoinFramework::Authenticator;
    use StarcoinFramework::Account::{exists_at, is_signer_delegated, transaction_fee_simulate,
        balance, Account, Balance
    };
    use StarcoinFramework::TransactionTimeout;
    use StarcoinFramework::Signer;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Account;
    use StarcoinFramework::PackageTxnManager;
    use StarcoinFramework::BlockReward;
    use StarcoinFramework::Block;
    use StarcoinFramework::STC::{STC, is_stc};
    use StarcoinFramework::TransactionFee;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::ChainId;
    use StarcoinFramework::Errors;
    use StarcoinFramework::TransactionPublishOption;
    use StarcoinFramework::Epoch;
    use StarcoinFramework::Hash;
    use StarcoinFramework::Vector;
    use StarcoinFramework::STC;
    use StarcoinFramework::EasyGas;
    spec module {
        pragma verify = false;
        pragma aborts_if_is_strict = true;
    }

    const TXN_PAYLOAD_TYPE_SCRIPT: u8 = 0;
    const TXN_PAYLOAD_TYPE_PACKAGE: u8 = 1;
    const TXN_PAYLOAD_TYPE_SCRIPT_FUNCTION: u8 = 2;

    const EPROLOGUE_ACCOUNT_DOES_NOT_EXIST: u64 = 0;
    const EPROLOGUE_TRANSACTION_EXPIRED: u64 = 5;
    const EPROLOGUE_BAD_CHAIN_ID: u64 = 6;
    const EPROLOGUE_MODULE_NOT_ALLOWED: u64 = 7;
    const EPROLOGUE_SCRIPT_NOT_ALLOWED: u64 = 8;


    /// The prologue is invoked at the beginning of every transaction
    /// It verifies:
    /// - The account's auth key matches the transaction's public key
    /// - That the account has enough balance to pay for all of the gas
    /// - That the sequence number matches the transaction's sequence key
    public fun prologue<TokenType: store>(
        account: signer,
        txn_sender: address,
        txn_sequence_number: u64,
        txn_authentication_key_preimage: vector<u8>,
        txn_gas_price: u64,
        txn_max_gas_units: u64,
        txn_expiration_time: u64,
        chain_id: u8,
        txn_payload_type: u8,
        txn_script_or_package_hash: vector<u8>,
        txn_package_address: address,
    ) {
        // Can only be invoked by genesis account
        assert!(
            Signer::address_of(&account) == CoreAddresses::GENESIS_ADDRESS(),
            Errors::requires_address(EPROLOGUE_ACCOUNT_DOES_NOT_EXIST),
        );
        // Check that the chain ID stored on-chain matches the chain ID
        // specified by the transaction
        assert!(ChainId::get() == chain_id, Errors::invalid_argument(EPROLOGUE_BAD_CHAIN_ID));
        let (stc_price,scaling_factor)= if (!STC::is_stc<TokenType>()){
            (EasyGas::gas_oracle_read<TokenType>(), EasyGas::get_scaling_factor<TokenType>())
        }else{
            (1,1)
        };

        txn_prologue_v2<TokenType>(
            &account,
            txn_sender,
            txn_sequence_number,
            txn_authentication_key_preimage,
            txn_gas_price,
            txn_max_gas_units,
            stc_price,
            scaling_factor,
        );
        assert!(
            TransactionTimeout::is_valid_transaction_timestamp(txn_expiration_time),
            Errors::invalid_argument(EPROLOGUE_TRANSACTION_EXPIRED),
        );
        if (txn_payload_type == TXN_PAYLOAD_TYPE_PACKAGE) {
            // stdlib upgrade is not affected by PublishOption
            if (txn_package_address != CoreAddresses::GENESIS_ADDRESS()) {
                assert!(
                    TransactionPublishOption::is_module_allowed(Signer::address_of(&account)),
                    Errors::invalid_argument(EPROLOGUE_MODULE_NOT_ALLOWED),
                );
            };
            PackageTxnManager::package_txn_prologue_v2(
                &account,
                txn_sender,
                txn_package_address,
                txn_script_or_package_hash,
            );
        } else if (txn_payload_type == TXN_PAYLOAD_TYPE_SCRIPT) {
            assert!(
                TransactionPublishOption::is_script_allowed(
                    Signer::address_of(&account),
                ),
                Errors::invalid_argument(EPROLOGUE_SCRIPT_NOT_ALLOWED),
            );
        };
        // do nothing for TXN_PAYLOAD_TYPE_SCRIPT_FUNCTION
    }

    spec prologue {
        aborts_if Signer::address_of(account) != CoreAddresses::GENESIS_ADDRESS();
        aborts_if !exists<ChainId::ChainId>(CoreAddresses::GENESIS_ADDRESS());
        aborts_if ChainId::get() != chain_id;
        aborts_if !exists<Account::Account>(txn_sender);
        aborts_if Hash::sha3_256(txn_authentication_key_preimage) != global<Account::Account>(txn_sender).authentication_key;
        aborts_if txn_gas_price * txn_max_gas_units > max_u64();
        include Timestamp::AbortsIfTimestampNotExists;
        include Block::AbortsIfBlockMetadataNotExist;
        aborts_if txn_gas_price * txn_max_gas_units > 0 && !exists<Account::Balance<TokenType>>(txn_sender);
        aborts_if txn_gas_price * txn_max_gas_units > 0 && txn_sequence_number >= max_u64();
        aborts_if txn_sequence_number < global<Account::Account>(txn_sender).sequence_number;
        aborts_if txn_sequence_number != global<Account::Account>(txn_sender).sequence_number;
        include TransactionTimeout::AbortsIfTimestampNotValid;
        aborts_if !TransactionTimeout::spec_is_valid_transaction_timestamp(txn_expiration_time);
        include TransactionPublishOption::AbortsIfTxnPublishOptionNotExistWithBool {
            is_script_or_package: (txn_payload_type == TXN_PAYLOAD_TYPE_PACKAGE || txn_payload_type == TXN_PAYLOAD_TYPE_SCRIPT),
        };
        aborts_if txn_payload_type == TXN_PAYLOAD_TYPE_PACKAGE && txn_package_address != CoreAddresses::GENESIS_ADDRESS() && !TransactionPublishOption::spec_is_module_allowed(Signer::address_of(account));
        aborts_if txn_payload_type == TXN_PAYLOAD_TYPE_SCRIPT && !TransactionPublishOption::spec_is_script_allowed(Signer::address_of(account));
        include PackageTxnManager::CheckPackageTxnAbortsIfWithType{is_package: (txn_payload_type == TXN_PAYLOAD_TYPE_PACKAGE), sender:txn_sender, package_address: txn_package_address, package_hash: txn_script_or_package_hash};
    }

    /// The epilogue is invoked at the end of transactions.
    /// It collects gas and bumps the sequence number
    public fun epilogue<TokenType: store>(
        account: signer,
        txn_sender: address,
        txn_sequence_number: u64,
        txn_gas_price: u64,
        txn_max_gas_units: u64,
        gas_units_remaining: u64,
        txn_payload_type: u8,
        _txn_script_or_package_hash: vector<u8>,
        txn_package_address: address,
        // txn execute success or fail.
        success: bool,
    ) {
        epilogue_v2<TokenType>(account, txn_sender, txn_sequence_number, Vector::empty(), txn_gas_price, txn_max_gas_units, gas_units_remaining, txn_payload_type, _txn_script_or_package_hash, txn_package_address, success)
    }

    /// The epilogue is invoked at the end of transactions.
    /// It collects gas and bumps the sequence number
    public fun epilogue_v2<TokenType: store>(
        account: signer,
        txn_sender: address,
        txn_sequence_number: u64,
        txn_authentication_key_preimage: vector<u8>,
        txn_gas_price: u64,
        txn_max_gas_units: u64,
        gas_units_remaining: u64,
        txn_payload_type: u8,
        _txn_script_or_package_hash: vector<u8>,
        txn_package_address: address,
        // txn execute success or fail.
        success: bool,
    ) {
        CoreAddresses::assert_genesis_address(&account);
        let (stc_price,scaling_factor) =
        if (!STC::is_stc<TokenType>()){
            (EasyGas::gas_oracle_read<TokenType>(), EasyGas::get_scaling_factor<TokenType>())
        }else{
            (1,1)
        };
        txn_epilogue_v3<TokenType>(
            &account,
            txn_sender,
            txn_sequence_number,
            txn_authentication_key_preimage,
            txn_gas_price,
            txn_max_gas_units,
            gas_units_remaining,
            stc_price,
            scaling_factor
        );
        if (txn_payload_type == TXN_PAYLOAD_TYPE_PACKAGE) {
            PackageTxnManager::package_txn_epilogue(
                &account,
                txn_sender,
                txn_package_address,
                success,
            );
        }
    }

    spec epilogue {
        pragma verify = false;//fixme : timeout
        include CoreAddresses::AbortsIfNotGenesisAddress;
        aborts_if Signer::address_of(account) != CoreAddresses::GENESIS_ADDRESS();
        aborts_if !exists<Account::Account>(txn_sender);
        aborts_if !exists<Account::Balance<TokenType>>(txn_sender);
        aborts_if txn_max_gas_units < gas_units_remaining;
        aborts_if txn_sequence_number + 1 > max_u64();
        aborts_if txn_gas_price * (txn_max_gas_units - gas_units_remaining) > max_u64();
        include PackageTxnManager::AbortsIfPackageTxnEpilogue {
            is_package: (txn_payload_type == TXN_PAYLOAD_TYPE_PACKAGE),
            package_address: txn_package_address,
            success: success,
        };
    }

    /// Set the metadata for the current block and distribute transaction fees and block rewards.
    /// The runtime always runs this before executing the transactions in a block.
    public fun block_prologue(
        account: signer,
        parent_hash: vector<u8>,
        timestamp: u64,
        author: address,
        auth_key_vec: vector<u8>,
        uncles: u64,
        number: u64,
        chain_id: u8,
        parent_gas_used: u64,
    ) {
        // Can only be invoked by genesis account
        CoreAddresses::assert_genesis_address(&account);
        // Check that the chain ID stored on-chain matches the chain ID
        // specified by the transaction
        assert!(ChainId::get() == chain_id, Errors::invalid_argument(EPROLOGUE_BAD_CHAIN_ID));

        // deal with previous block first.
        let txn_fee = TransactionFee::distribute_transaction_fees<STC>(&account);

        // then deal with current block.
        Timestamp::update_global_time(&account, timestamp);
        Block::process_block_metadata(
            &account,
            parent_hash,
            author,
            timestamp,
            uncles,
            number,
        );
        let reward = Epoch::adjust_epoch(&account, number, timestamp, uncles, parent_gas_used);
        // pass in previous block gas fees.
        BlockReward::process_block_reward(&account, number, reward, author, auth_key_vec, txn_fee);
    }

    spec block_prologue {
        pragma verify = false;//fixme : timeout
    }

    const MAX_U64: u128 = 18446744073709551615;
    const EPROLOGUE_INVALID_ACCOUNT_AUTH_KEY: u64 = 1;
    const EPROLOGUE_SEQUENCE_NUMBER_TOO_OLD: u64 = 2;
    const EPROLOGUE_SEQUENCE_NUMBER_TOO_NEW: u64 = 3;
    const EPROLOGUE_CANT_PAY_GAS_DEPOSIT: u64 = 4;
    const EPROLOGUE_SEQUENCE_NUMBER_TOO_BIG: u64 = 9;
    const EINSUFFICIENT_BALANCE: u64 = 10;
    const ECOIN_DEPOSIT_IS_ZERO: u64 = 15;
    const EDEPRECATED_FUNCTION: u64 = 19;
    const EPROLOGUE_SIGNER_ALREADY_DELEGATED: u64 = 200;

    public fun txn_prologue_v2<TokenType: store>(
        account: &signer,
        txn_sender: address,
        txn_sequence_number: u64,
        txn_authentication_key_preimage: vector<u8>,
        txn_gas_price: u64,
        txn_max_gas_units: u64,
        stc_price: u128,
        stc_price_scaling: u128
    )  {
        CoreAddresses::assert_genesis_address(account);

        // Verify that the transaction sender's account exists
        assert!(exists_at(txn_sender), Errors::requires_address(EPROLOGUE_ACCOUNT_DOES_NOT_EXIST));
        // Verify the account has not delegate its signer cap.
        assert!(!is_signer_delegated(txn_sender), Errors::invalid_state(EPROLOGUE_SIGNER_ALREADY_DELEGATED));

        // Load the transaction sender's account
        //let sender_account = borrow_global_mut<Account>(txn_sender);
        if (Account::is_dummy_auth_key_v2(txn_sender)){
            // if sender's auth key is empty, use address as auth key for check transaction.
            assert!(
                Authenticator::derived_address(Hash::sha3_256(txn_authentication_key_preimage)) == txn_sender,
                Errors::invalid_argument(EPROLOGUE_INVALID_ACCOUNT_AUTH_KEY)
            );
        }else{
            // Check that the hash of the transaction's public key matches the account's auth key
            assert!(
                Hash::sha3_256(txn_authentication_key_preimage) == Account::authentication_key(txn_sender),
                Errors::invalid_argument(EPROLOGUE_INVALID_ACCOUNT_AUTH_KEY)
            );
        };
        // Check that the account has enough balance for all of the gas
        let (max_transaction_fee_stc,max_transaction_fee_token) = transaction_fee_simulate(txn_gas_price,txn_max_gas_units,0, stc_price, stc_price_scaling);
        assert!(
            max_transaction_fee_stc <= MAX_U64,
            Errors::invalid_argument(EPROLOGUE_CANT_PAY_GAS_DEPOSIT),
        );
        if (max_transaction_fee_stc > 0) {
            assert!(
                (txn_sequence_number as u128) < MAX_U64,
                Errors::limit_exceeded(EPROLOGUE_SEQUENCE_NUMBER_TOO_BIG)
            );
            let balance_amount_token = balance<TokenType>(txn_sender);
            assert!(balance_amount_token >= max_transaction_fee_token, Errors::invalid_argument(EPROLOGUE_CANT_PAY_GAS_DEPOSIT));
            if (!is_stc<TokenType>()){
                let gas_fee_address = EasyGas::get_gas_fee_address();
                let balance_amount_stc= balance<STC>(gas_fee_address);
                assert!(balance_amount_stc >= max_transaction_fee_stc, Errors::invalid_argument(EPROLOGUE_CANT_PAY_GAS_DEPOSIT));
            }
        };
        // Check that the transaction sequence number matches the sequence number of the account
        assert!(txn_sequence_number >= Account::sequence_number(txn_sender), Errors::invalid_argument(EPROLOGUE_SEQUENCE_NUMBER_TOO_OLD));
        assert!(txn_sequence_number == Account::sequence_number(txn_sender), Errors::invalid_argument(EPROLOGUE_SEQUENCE_NUMBER_TOO_NEW));

    }

    /// The epilogue is invoked at the end of transactions.
    /// It collects gas and bumps the sequence number
    public fun txn_epilogue_v3<TokenType: store>(
        account: &signer,
        txn_sender: address,
        txn_sequence_number: u64,
        txn_authentication_key_preimage: vector<u8>,
        txn_gas_price: u64,
        txn_max_gas_units: u64,
        gas_units_remaining: u64,
        stc_price: u128,
        stc_price_scaling: u128,
    ) {
        CoreAddresses::assert_genesis_address(account);
        // Charge for gas
        let (transaction_fee_amount_stc,transaction_fee_amount_token) = transaction_fee_simulate(
            txn_gas_price,
            txn_max_gas_units,
            gas_units_remaining,
            stc_price,
            stc_price_scaling);
        assert!(
            balance<TokenType>(txn_sender) >= transaction_fee_amount_token,
            Errors::limit_exceeded(EINSUFFICIENT_BALANCE)
        );

        if (!is_stc<TokenType>()){
            let gas_fee_address = EasyGas::get_gas_fee_address();
            let genesis_balance_amount_stc=balance<STC>(gas_fee_address);
            assert!(genesis_balance_amount_stc >= transaction_fee_amount_stc,
                Errors::invalid_argument(EPROLOGUE_CANT_PAY_GAS_DEPOSIT)
            );
        };
        // Bump the sequence number
        Account::set_sequence_number(txn_sender,txn_sequence_number+1);
        // Set auth key when user send transaction first.
        if (Account::is_dummy_auth_key_v2(txn_sender) && !Vector::is_empty(&txn_authentication_key_preimage)){
            Account::set_authentication_key(txn_sender, Hash::sha3_256(txn_authentication_key_preimage));
        };

        if (transaction_fee_amount_stc > 0) {
            let transaction_fee_token = Account::withdraw_from_balance_v2<TokenType>(
                txn_sender,
                transaction_fee_amount_token
            );
            if(!is_stc<TokenType>()) {
                let gas_fee_address = EasyGas::get_gas_fee_address();
                Account::deposit<TokenType>(gas_fee_address, transaction_fee_token);
                let stc_fee_token = Account::withdraw_from_balance_v2<STC>(gas_fee_address, transaction_fee_amount_stc);
                TransactionFee::pay_fee(stc_fee_token);
            }else{
                TransactionFee::pay_fee(transaction_fee_token);
            }
        };
    }

    spec txn_epilogue_v3 {

        pragma verify = false; // Todo: fix me, cost too much time
        aborts_if Signer::address_of(account) != CoreAddresses::GENESIS_ADDRESS();
        aborts_if !exists<Account>(txn_sender);
        aborts_if !exists<Balance<TokenType>>(txn_sender);
        aborts_if txn_sequence_number + 1 > max_u64();
        aborts_if !exists<Balance<TokenType>>(txn_sender);
        aborts_if txn_max_gas_units < gas_units_remaining;
    }
}
}
