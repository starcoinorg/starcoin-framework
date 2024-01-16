
<a name="0x1_TransactionManager"></a>

# Module `0x1::TransactionManager`

<code><a href="TransactionManager.md#0x1_TransactionManager">TransactionManager</a></code> manages:
1. prologue and epilogue of transactions.
2. prologue of blocks.


-  [Constants](#@Constants_0)
-  [Function `prologue`](#0x1_TransactionManager_prologue)
-  [Function `epilogue`](#0x1_TransactionManager_epilogue)
-  [Function `epilogue_v2`](#0x1_TransactionManager_epilogue_v2)
-  [Function `block_prologue`](#0x1_TransactionManager_block_prologue)
-  [Function `txn_prologue_v2`](#0x1_TransactionManager_txn_prologue_v2)
-  [Function `txn_epilogue_v3`](#0x1_TransactionManager_txn_epilogue_v3)
-  [Module Specification](#@Module_Specification_1)


<pre><code><b>use</b> <a href="Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="Authenticator.md#0x1_Authenticator">0x1::Authenticator</a>;
<b>use</b> <a href="Block.md#0x1_Block">0x1::Block</a>;
<b>use</b> <a href="BlockReward.md#0x1_BlockReward">0x1::BlockReward</a>;
<b>use</b> <a href="ChainId.md#0x1_ChainId">0x1::ChainId</a>;
<b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
<b>use</b> <a href="EasyGas.md#0x1_EasyGas">0x1::EasyGas</a>;
<b>use</b> <a href="Epoch.md#0x1_Epoch">0x1::Epoch</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Hash.md#0x1_Hash">0x1::Hash</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="PackageTxnManager.md#0x1_PackageTxnManager">0x1::PackageTxnManager</a>;
<b>use</b> <a href="STC.md#0x1_STC">0x1::STC</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
<b>use</b> <a href="Token.md#0x1_Token">0x1::Token</a>;
<b>use</b> <a href="TransactionFee.md#0x1_TransactionFee">0x1::TransactionFee</a>;
<b>use</b> <a href="TransactionPublishOption.md#0x1_TransactionPublishOption">0x1::TransactionPublishOption</a>;
<b>use</b> <a href="TransactionTimeout.md#0x1_TransactionTimeout">0x1::TransactionTimeout</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="0x1_TransactionManager_MAX_U64"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_MAX_U64">MAX_U64</a>: u128 = 18446744073709551615;
</code></pre>



<a name="0x1_TransactionManager_EDEPRECATED_FUNCTION"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_EDEPRECATED_FUNCTION">EDEPRECATED_FUNCTION</a>: u64 = 19;
</code></pre>



<a name="0x1_TransactionManager_EPROLOGUE_ACCOUNT_DOES_NOT_EXIST"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_ACCOUNT_DOES_NOT_EXIST">EPROLOGUE_ACCOUNT_DOES_NOT_EXIST</a>: u64 = 0;
</code></pre>



<a name="0x1_TransactionManager_ECOIN_DEPOSIT_IS_ZERO"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_ECOIN_DEPOSIT_IS_ZERO">ECOIN_DEPOSIT_IS_ZERO</a>: u64 = 15;
</code></pre>



<a name="0x1_TransactionManager_EINSUFFICIENT_BALANCE"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_EINSUFFICIENT_BALANCE">EINSUFFICIENT_BALANCE</a>: u64 = 10;
</code></pre>



<a name="0x1_TransactionManager_EPROLOGUE_CANT_PAY_GAS_DEPOSIT"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_CANT_PAY_GAS_DEPOSIT">EPROLOGUE_CANT_PAY_GAS_DEPOSIT</a>: u64 = 4;
</code></pre>



<a name="0x1_TransactionManager_EPROLOGUE_INVALID_ACCOUNT_AUTH_KEY"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_INVALID_ACCOUNT_AUTH_KEY">EPROLOGUE_INVALID_ACCOUNT_AUTH_KEY</a>: u64 = 1;
</code></pre>



<a name="0x1_TransactionManager_EPROLOGUE_SEQUENCE_NUMBER_TOO_BIG"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_SEQUENCE_NUMBER_TOO_BIG">EPROLOGUE_SEQUENCE_NUMBER_TOO_BIG</a>: u64 = 9;
</code></pre>



<a name="0x1_TransactionManager_EPROLOGUE_SEQUENCE_NUMBER_TOO_NEW"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_SEQUENCE_NUMBER_TOO_NEW">EPROLOGUE_SEQUENCE_NUMBER_TOO_NEW</a>: u64 = 3;
</code></pre>



<a name="0x1_TransactionManager_EPROLOGUE_SEQUENCE_NUMBER_TOO_OLD"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_SEQUENCE_NUMBER_TOO_OLD">EPROLOGUE_SEQUENCE_NUMBER_TOO_OLD</a>: u64 = 2;
</code></pre>



<a name="0x1_TransactionManager_EPROLOGUE_SIGNER_ALREADY_DELEGATED"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_SIGNER_ALREADY_DELEGATED">EPROLOGUE_SIGNER_ALREADY_DELEGATED</a>: u64 = 200;
</code></pre>



<a name="0x1_TransactionManager_EPROLOGUE_BAD_CHAIN_ID"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_BAD_CHAIN_ID">EPROLOGUE_BAD_CHAIN_ID</a>: u64 = 6;
</code></pre>



<a name="0x1_TransactionManager_EPROLOGUE_MODULE_NOT_ALLOWED"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_MODULE_NOT_ALLOWED">EPROLOGUE_MODULE_NOT_ALLOWED</a>: u64 = 7;
</code></pre>



<a name="0x1_TransactionManager_EPROLOGUE_SCRIPT_NOT_ALLOWED"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_SCRIPT_NOT_ALLOWED">EPROLOGUE_SCRIPT_NOT_ALLOWED</a>: u64 = 8;
</code></pre>



<a name="0x1_TransactionManager_EPROLOGUE_TRANSACTION_EXPIRED"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_TRANSACTION_EXPIRED">EPROLOGUE_TRANSACTION_EXPIRED</a>: u64 = 5;
</code></pre>



<a name="0x1_TransactionManager_TXN_PAYLOAD_TYPE_PACKAGE"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_TXN_PAYLOAD_TYPE_PACKAGE">TXN_PAYLOAD_TYPE_PACKAGE</a>: u8 = 1;
</code></pre>



<a name="0x1_TransactionManager_TXN_PAYLOAD_TYPE_SCRIPT"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_TXN_PAYLOAD_TYPE_SCRIPT">TXN_PAYLOAD_TYPE_SCRIPT</a>: u8 = 0;
</code></pre>



<a name="0x1_TransactionManager_TXN_PAYLOAD_TYPE_SCRIPT_FUNCTION"></a>



<pre><code><b>const</b> <a href="TransactionManager.md#0x1_TransactionManager_TXN_PAYLOAD_TYPE_SCRIPT_FUNCTION">TXN_PAYLOAD_TYPE_SCRIPT_FUNCTION</a>: u8 = 2;
</code></pre>



<a name="0x1_TransactionManager_prologue"></a>

## Function `prologue`

The prologue is invoked at the beginning of every transaction
It verifies:
- The account's auth key matches the transaction's public key
- That the account has enough balance to pay for all of the gas
- That the sequence number matches the transaction's sequence key


<pre><code><b>public</b> <b>fun</b> <a href="TransactionManager.md#0x1_TransactionManager_prologue">prologue</a>&lt;TokenType: store&gt;(account: signer, txn_sender: <b>address</b>, txn_sequence_number: u64, txn_authentication_key_preimage: vector&lt;u8&gt;, txn_gas_price: u64, txn_max_gas_units: u64, txn_expiration_time: u64, chain_id: u8, txn_payload_type: u8, txn_script_or_package_hash: vector&lt;u8&gt;, txn_package_address: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TransactionManager.md#0x1_TransactionManager_prologue">prologue</a>&lt;TokenType: store&gt;(
    account: signer,
    txn_sender: <b>address</b>,
    txn_sequence_number: u64,
    txn_authentication_key_preimage: vector&lt;u8&gt;,
    txn_gas_price: u64,
    txn_max_gas_units: u64,
    txn_expiration_time: u64,
    chain_id: u8,
    txn_payload_type: u8,
    txn_script_or_package_hash: vector&lt;u8&gt;,
    txn_package_address: <b>address</b>,
) {
    // Can only be invoked by genesis account
    <b>assert</b>!(
        <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&account) == <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>(),
        <a href="Errors.md#0x1_Errors_requires_address">Errors::requires_address</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_ACCOUNT_DOES_NOT_EXIST">EPROLOGUE_ACCOUNT_DOES_NOT_EXIST</a>),
    );
    // Check that the chain ID stored on-chain matches the chain ID
    // specified by the transaction
    <b>assert</b>!(<a href="ChainId.md#0x1_ChainId_get">ChainId::get</a>() == chain_id, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_BAD_CHAIN_ID">EPROLOGUE_BAD_CHAIN_ID</a>));
    <b>let</b> (stc_price,scaling_factor)= <b>if</b> (!<a href="STC.md#0x1_STC_is_stc">STC::is_stc</a>&lt;TokenType&gt;()){
        (<a href="EasyGas.md#0x1_EasyGas_gas_oracle_read">EasyGas::gas_oracle_read</a>&lt;TokenType&gt;(), <a href="EasyGas.md#0x1_EasyGas_get_scaling_factor">EasyGas::get_scaling_factor</a>&lt;TokenType&gt;())
    }<b>else</b>{
        (1,1)
    };

    <a href="TransactionManager.md#0x1_TransactionManager_txn_prologue_v2">txn_prologue_v2</a>&lt;TokenType&gt;(
        &account,
        txn_sender,
        txn_sequence_number,
        txn_authentication_key_preimage,
        txn_gas_price,
        txn_max_gas_units,
        stc_price,
        scaling_factor,
    );
    <b>assert</b>!(
        <a href="TransactionTimeout.md#0x1_TransactionTimeout_is_valid_transaction_timestamp">TransactionTimeout::is_valid_transaction_timestamp</a>(txn_expiration_time),
        <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_TRANSACTION_EXPIRED">EPROLOGUE_TRANSACTION_EXPIRED</a>),
    );
    <b>if</b> (txn_payload_type == <a href="TransactionManager.md#0x1_TransactionManager_TXN_PAYLOAD_TYPE_PACKAGE">TXN_PAYLOAD_TYPE_PACKAGE</a>) {
        // stdlib upgrade is not affected by PublishOption
        <b>if</b> (txn_package_address != <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()) {
            <b>assert</b>!(
                <a href="TransactionPublishOption.md#0x1_TransactionPublishOption_is_module_allowed">TransactionPublishOption::is_module_allowed</a>(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&account)),
                <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_MODULE_NOT_ALLOWED">EPROLOGUE_MODULE_NOT_ALLOWED</a>),
            );
        };
        <a href="PackageTxnManager.md#0x1_PackageTxnManager_package_txn_prologue_v2">PackageTxnManager::package_txn_prologue_v2</a>(
            &account,
            txn_sender,
            txn_package_address,
            txn_script_or_package_hash,
        );
    } <b>else</b> <b>if</b> (txn_payload_type == <a href="TransactionManager.md#0x1_TransactionManager_TXN_PAYLOAD_TYPE_SCRIPT">TXN_PAYLOAD_TYPE_SCRIPT</a>) {
        <b>assert</b>!(
            <a href="TransactionPublishOption.md#0x1_TransactionPublishOption_is_script_allowed">TransactionPublishOption::is_script_allowed</a>(
                <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&account),
            ),
            <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_SCRIPT_NOT_ALLOWED">EPROLOGUE_SCRIPT_NOT_ALLOWED</a>),
        );
    };
    // do nothing for <a href="TransactionManager.md#0x1_TransactionManager_TXN_PAYLOAD_TYPE_SCRIPT_FUNCTION">TXN_PAYLOAD_TYPE_SCRIPT_FUNCTION</a>
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account) != <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>();
<b>aborts_if</b> !<b>exists</b>&lt;<a href="ChainId.md#0x1_ChainId_ChainId">ChainId::ChainId</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
<b>aborts_if</b> <a href="ChainId.md#0x1_ChainId_get">ChainId::get</a>() != chain_id;
<b>aborts_if</b> !<b>exists</b>&lt;<a href="Account.md#0x1_Account_Account">Account::Account</a>&gt;(txn_sender);
<b>aborts_if</b> <a href="Hash.md#0x1_Hash_sha3_256">Hash::sha3_256</a>(txn_authentication_key_preimage) != <b>global</b>&lt;<a href="Account.md#0x1_Account_Account">Account::Account</a>&gt;(txn_sender).authentication_key;
<b>aborts_if</b> txn_gas_price * txn_max_gas_units &gt; max_u64();
<b>include</b> <a href="Timestamp.md#0x1_Timestamp_AbortsIfTimestampNotExists">Timestamp::AbortsIfTimestampNotExists</a>;
<b>include</b> <a href="Block.md#0x1_Block_AbortsIfBlockMetadataNotExist">Block::AbortsIfBlockMetadataNotExist</a>;
<b>aborts_if</b> txn_gas_price * txn_max_gas_units &gt; 0 && !<b>exists</b>&lt;<a href="Account.md#0x1_Account_Balance">Account::Balance</a>&lt;TokenType&gt;&gt;(txn_sender);
<b>aborts_if</b> txn_gas_price * txn_max_gas_units &gt; 0 && txn_sequence_number &gt;= max_u64();
<b>aborts_if</b> txn_sequence_number &lt; <b>global</b>&lt;<a href="Account.md#0x1_Account_Account">Account::Account</a>&gt;(txn_sender).sequence_number;
<b>aborts_if</b> txn_sequence_number != <b>global</b>&lt;<a href="Account.md#0x1_Account_Account">Account::Account</a>&gt;(txn_sender).sequence_number;
<b>include</b> <a href="TransactionTimeout.md#0x1_TransactionTimeout_AbortsIfTimestampNotValid">TransactionTimeout::AbortsIfTimestampNotValid</a>;
<b>aborts_if</b> !<a href="TransactionTimeout.md#0x1_TransactionTimeout_spec_is_valid_transaction_timestamp">TransactionTimeout::spec_is_valid_transaction_timestamp</a>(txn_expiration_time);
<b>include</b> <a href="TransactionPublishOption.md#0x1_TransactionPublishOption_AbortsIfTxnPublishOptionNotExistWithBool">TransactionPublishOption::AbortsIfTxnPublishOptionNotExistWithBool</a> {
    is_script_or_package: (txn_payload_type == <a href="TransactionManager.md#0x1_TransactionManager_TXN_PAYLOAD_TYPE_PACKAGE">TXN_PAYLOAD_TYPE_PACKAGE</a> || txn_payload_type == <a href="TransactionManager.md#0x1_TransactionManager_TXN_PAYLOAD_TYPE_SCRIPT">TXN_PAYLOAD_TYPE_SCRIPT</a>),
};
<b>aborts_if</b> txn_payload_type == <a href="TransactionManager.md#0x1_TransactionManager_TXN_PAYLOAD_TYPE_PACKAGE">TXN_PAYLOAD_TYPE_PACKAGE</a> && txn_package_address != <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>() && !<a href="TransactionPublishOption.md#0x1_TransactionPublishOption_spec_is_module_allowed">TransactionPublishOption::spec_is_module_allowed</a>(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account));
<b>aborts_if</b> txn_payload_type == <a href="TransactionManager.md#0x1_TransactionManager_TXN_PAYLOAD_TYPE_SCRIPT">TXN_PAYLOAD_TYPE_SCRIPT</a> && !<a href="TransactionPublishOption.md#0x1_TransactionPublishOption_spec_is_script_allowed">TransactionPublishOption::spec_is_script_allowed</a>(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account));
<b>include</b> <a href="PackageTxnManager.md#0x1_PackageTxnManager_CheckPackageTxnAbortsIfWithType">PackageTxnManager::CheckPackageTxnAbortsIfWithType</a>{is_package: (txn_payload_type == <a href="TransactionManager.md#0x1_TransactionManager_TXN_PAYLOAD_TYPE_PACKAGE">TXN_PAYLOAD_TYPE_PACKAGE</a>), sender:txn_sender, package_address: txn_package_address, package_hash: txn_script_or_package_hash};
</code></pre>



</details>

<a name="0x1_TransactionManager_epilogue"></a>

## Function `epilogue`

The epilogue is invoked at the end of transactions.
It collects gas and bumps the sequence number


<pre><code><b>public</b> <b>fun</b> <a href="TransactionManager.md#0x1_TransactionManager_epilogue">epilogue</a>&lt;TokenType: store&gt;(account: signer, txn_sender: <b>address</b>, txn_sequence_number: u64, txn_gas_price: u64, txn_max_gas_units: u64, gas_units_remaining: u64, txn_payload_type: u8, _txn_script_or_package_hash: vector&lt;u8&gt;, txn_package_address: <b>address</b>, success: bool)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TransactionManager.md#0x1_TransactionManager_epilogue">epilogue</a>&lt;TokenType: store&gt;(
    account: signer,
    txn_sender: <b>address</b>,
    txn_sequence_number: u64,
    txn_gas_price: u64,
    txn_max_gas_units: u64,
    gas_units_remaining: u64,
    txn_payload_type: u8,
    _txn_script_or_package_hash: vector&lt;u8&gt;,
    txn_package_address: <b>address</b>,
    // txn execute success or fail.
    success: bool,
) {
    <a href="TransactionManager.md#0x1_TransactionManager_epilogue_v2">epilogue_v2</a>&lt;TokenType&gt;(account, txn_sender, txn_sequence_number, <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>(), txn_gas_price, txn_max_gas_units, gas_units_remaining, txn_payload_type, _txn_script_or_package_hash, txn_package_address, success)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
<b>include</b> <a href="CoreAddresses.md#0x1_CoreAddresses_AbortsIfNotGenesisAddress">CoreAddresses::AbortsIfNotGenesisAddress</a>;
<b>aborts_if</b> <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account) != <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>();
<b>aborts_if</b> !<b>exists</b>&lt;<a href="Account.md#0x1_Account_Account">Account::Account</a>&gt;(txn_sender);
<b>aborts_if</b> !<b>exists</b>&lt;<a href="Account.md#0x1_Account_Balance">Account::Balance</a>&lt;TokenType&gt;&gt;(txn_sender);
<b>aborts_if</b> txn_max_gas_units &lt; gas_units_remaining;
<b>aborts_if</b> txn_sequence_number + 1 &gt; max_u64();
<b>aborts_if</b> txn_gas_price * (txn_max_gas_units - gas_units_remaining) &gt; max_u64();
<b>include</b> <a href="PackageTxnManager.md#0x1_PackageTxnManager_AbortsIfPackageTxnEpilogue">PackageTxnManager::AbortsIfPackageTxnEpilogue</a> {
    is_package: (txn_payload_type == <a href="TransactionManager.md#0x1_TransactionManager_TXN_PAYLOAD_TYPE_PACKAGE">TXN_PAYLOAD_TYPE_PACKAGE</a>),
    package_address: txn_package_address,
    success: success,
};
</code></pre>



</details>

<a name="0x1_TransactionManager_epilogue_v2"></a>

## Function `epilogue_v2`

The epilogue is invoked at the end of transactions.
It collects gas and bumps the sequence number


<pre><code><b>public</b> <b>fun</b> <a href="TransactionManager.md#0x1_TransactionManager_epilogue_v2">epilogue_v2</a>&lt;TokenType: store&gt;(account: signer, txn_sender: <b>address</b>, txn_sequence_number: u64, txn_authentication_key_preimage: vector&lt;u8&gt;, txn_gas_price: u64, txn_max_gas_units: u64, gas_units_remaining: u64, txn_payload_type: u8, _txn_script_or_package_hash: vector&lt;u8&gt;, txn_package_address: <b>address</b>, success: bool)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TransactionManager.md#0x1_TransactionManager_epilogue_v2">epilogue_v2</a>&lt;TokenType: store&gt;(
    account: signer,
    txn_sender: <b>address</b>,
    txn_sequence_number: u64,
    txn_authentication_key_preimage: vector&lt;u8&gt;,
    txn_gas_price: u64,
    txn_max_gas_units: u64,
    gas_units_remaining: u64,
    txn_payload_type: u8,
    _txn_script_or_package_hash: vector&lt;u8&gt;,
    txn_package_address: <b>address</b>,
    // txn execute success or fail.
    success: bool,
) {
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(&account);
    <b>let</b> (stc_price,scaling_factor) =
    <b>if</b> (!<a href="STC.md#0x1_STC_is_stc">STC::is_stc</a>&lt;TokenType&gt;()){
        (<a href="EasyGas.md#0x1_EasyGas_gas_oracle_read">EasyGas::gas_oracle_read</a>&lt;TokenType&gt;(), <a href="EasyGas.md#0x1_EasyGas_get_scaling_factor">EasyGas::get_scaling_factor</a>&lt;TokenType&gt;())
    }<b>else</b>{
        (1,1)
    };
    <a href="TransactionManager.md#0x1_TransactionManager_txn_epilogue_v3">txn_epilogue_v3</a>&lt;TokenType&gt;(
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
    <b>if</b> (txn_payload_type == <a href="TransactionManager.md#0x1_TransactionManager_TXN_PAYLOAD_TYPE_PACKAGE">TXN_PAYLOAD_TYPE_PACKAGE</a>) {
        <a href="PackageTxnManager.md#0x1_PackageTxnManager_package_txn_epilogue">PackageTxnManager::package_txn_epilogue</a>(
            &account,
            txn_sender,
            txn_package_address,
            success,
        );
    }
}
</code></pre>



</details>

<a name="0x1_TransactionManager_block_prologue"></a>

## Function `block_prologue`

Set the metadata for the current block and distribute transaction fees and block rewards.
The runtime always runs this before executing the transactions in a block.


<pre><code><b>public</b> <b>fun</b> <a href="TransactionManager.md#0x1_TransactionManager_block_prologue">block_prologue</a>(account: signer, parent_hash: vector&lt;u8&gt;, timestamp: u64, author: <b>address</b>, auth_key_vec: vector&lt;u8&gt;, uncles: u64, number: u64, chain_id: u8, parent_gas_used: u64, parents_hash: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TransactionManager.md#0x1_TransactionManager_block_prologue">block_prologue</a>(
    account: signer,
    parent_hash: vector&lt;u8&gt;,
    timestamp: u64,
    author: <b>address</b>,
    auth_key_vec: vector&lt;u8&gt;,
    uncles: u64,
    number: u64,
    chain_id: u8,
    parent_gas_used: u64,
    parents_hash: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;,
) {
    // Can only be invoked by genesis account
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(&account);
    // Check that the chain ID stored on-chain matches the chain ID
    // specified by the transaction
    <b>assert</b>!(<a href="ChainId.md#0x1_ChainId_get">ChainId::get</a>() == chain_id, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_BAD_CHAIN_ID">EPROLOGUE_BAD_CHAIN_ID</a>));

    // deal <b>with</b> previous block first.
    <b>let</b> txn_fee = <a href="TransactionFee.md#0x1_TransactionFee_distribute_transaction_fees">TransactionFee::distribute_transaction_fees</a>&lt;<a href="STC.md#0x1_STC">STC</a>&gt;(&account);

    // then deal <b>with</b> current block.
    <a href="Timestamp.md#0x1_Timestamp_update_global_time">Timestamp::update_global_time</a>(&account, timestamp);
    <a href="Block.md#0x1_Block_process_block_metadata">Block::process_block_metadata</a>(
        &account,
        parent_hash,
        author,
        timestamp,
        uncles,
        number,
        parents_hash,
    );
    <b>let</b> reward = <a href="Epoch.md#0x1_Epoch_adjust_epoch">Epoch::adjust_epoch</a>(&account, number, timestamp, uncles, parent_gas_used);
    // pass in previous block gas fees.
    <a href="BlockReward.md#0x1_BlockReward_process_block_reward">BlockReward::process_block_reward</a>(&account, number, reward, author, auth_key_vec, txn_fee);
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_TransactionManager_txn_prologue_v2"></a>

## Function `txn_prologue_v2`



<pre><code><b>public</b> <b>fun</b> <a href="TransactionManager.md#0x1_TransactionManager_txn_prologue_v2">txn_prologue_v2</a>&lt;TokenType: store&gt;(account: &signer, txn_sender: <b>address</b>, txn_sequence_number: u64, txn_authentication_key_preimage: vector&lt;u8&gt;, txn_gas_price: u64, txn_max_gas_units: u64, stc_price: u128, stc_price_scaling: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TransactionManager.md#0x1_TransactionManager_txn_prologue_v2">txn_prologue_v2</a>&lt;TokenType: store&gt;(
    account: &signer,
    txn_sender: <b>address</b>,
    txn_sequence_number: u64,
    txn_authentication_key_preimage: vector&lt;u8&gt;,
    txn_gas_price: u64,
    txn_max_gas_units: u64,
    stc_price: u128,
    stc_price_scaling: u128
)  {
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(account);

    // Verify that the transaction sender's account <b>exists</b>
    <b>assert</b>!(exists_at(txn_sender), <a href="Errors.md#0x1_Errors_requires_address">Errors::requires_address</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_ACCOUNT_DOES_NOT_EXIST">EPROLOGUE_ACCOUNT_DOES_NOT_EXIST</a>));
    // Verify the account <b>has</b> not delegate its signer cap.
    <b>assert</b>!(!is_signer_delegated(txn_sender), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_SIGNER_ALREADY_DELEGATED">EPROLOGUE_SIGNER_ALREADY_DELEGATED</a>));

    // Load the transaction sender's account
    //<b>let</b> sender_account = <b>borrow_global_mut</b>&lt;<a href="Account.md#0x1_Account">Account</a>&gt;(txn_sender);
    <b>if</b> (<a href="Account.md#0x1_Account_is_dummy_auth_key_v2">Account::is_dummy_auth_key_v2</a>(txn_sender)){
        // <b>if</b> sender's auth key is empty, <b>use</b> <b>address</b> <b>as</b> auth key for check transaction.
        <b>assert</b>!(
            <a href="Authenticator.md#0x1_Authenticator_derived_address">Authenticator::derived_address</a>(<a href="Hash.md#0x1_Hash_sha3_256">Hash::sha3_256</a>(txn_authentication_key_preimage)) == txn_sender,
            <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_INVALID_ACCOUNT_AUTH_KEY">EPROLOGUE_INVALID_ACCOUNT_AUTH_KEY</a>)
        );
    }<b>else</b>{
        // Check that the hash of the transaction's <b>public</b> key matches the account's auth key
        <b>assert</b>!(
            <a href="Hash.md#0x1_Hash_sha3_256">Hash::sha3_256</a>(txn_authentication_key_preimage) == <a href="Account.md#0x1_Account_authentication_key">Account::authentication_key</a>(txn_sender),
            <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_INVALID_ACCOUNT_AUTH_KEY">EPROLOGUE_INVALID_ACCOUNT_AUTH_KEY</a>)
        );
    };
    // Check that the account <b>has</b> enough balance for all of the gas
    <b>let</b> (max_transaction_fee_stc,max_transaction_fee_token) = transaction_fee_simulate(txn_gas_price,txn_max_gas_units,0, stc_price, stc_price_scaling);
    <b>assert</b>!(
        max_transaction_fee_stc &lt;= <a href="TransactionManager.md#0x1_TransactionManager_MAX_U64">MAX_U64</a>,
        <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_CANT_PAY_GAS_DEPOSIT">EPROLOGUE_CANT_PAY_GAS_DEPOSIT</a>),
    );
    <b>if</b> (max_transaction_fee_stc &gt; 0) {
        <b>assert</b>!(
            (txn_sequence_number <b>as</b> u128) &lt; <a href="TransactionManager.md#0x1_TransactionManager_MAX_U64">MAX_U64</a>,
            <a href="Errors.md#0x1_Errors_limit_exceeded">Errors::limit_exceeded</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_SEQUENCE_NUMBER_TOO_BIG">EPROLOGUE_SEQUENCE_NUMBER_TOO_BIG</a>)
        );
        <b>let</b> balance_amount_token = balance&lt;TokenType&gt;(txn_sender);
        <b>assert</b>!(balance_amount_token &gt;= max_transaction_fee_token, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_CANT_PAY_GAS_DEPOSIT">EPROLOGUE_CANT_PAY_GAS_DEPOSIT</a>));
        <b>if</b> (!is_stc&lt;TokenType&gt;()){
            <b>let</b> gas_fee_address = <a href="EasyGas.md#0x1_EasyGas_get_gas_fee_address">EasyGas::get_gas_fee_address</a>();
            <b>let</b> balance_amount_stc= balance&lt;<a href="STC.md#0x1_STC">STC</a>&gt;(gas_fee_address);
            <b>assert</b>!(balance_amount_stc &gt;= max_transaction_fee_stc, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_CANT_PAY_GAS_DEPOSIT">EPROLOGUE_CANT_PAY_GAS_DEPOSIT</a>));
        }
    };
    // Check that the transaction sequence number matches the sequence number of the account
    <b>assert</b>!(txn_sequence_number &gt;= <a href="Account.md#0x1_Account_sequence_number">Account::sequence_number</a>(txn_sender), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_SEQUENCE_NUMBER_TOO_OLD">EPROLOGUE_SEQUENCE_NUMBER_TOO_OLD</a>));
    <b>assert</b>!(txn_sequence_number == <a href="Account.md#0x1_Account_sequence_number">Account::sequence_number</a>(txn_sender), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_SEQUENCE_NUMBER_TOO_NEW">EPROLOGUE_SEQUENCE_NUMBER_TOO_NEW</a>));

}
</code></pre>



</details>

<a name="0x1_TransactionManager_txn_epilogue_v3"></a>

## Function `txn_epilogue_v3`

The epilogue is invoked at the end of transactions.
It collects gas and bumps the sequence number


<pre><code><b>public</b> <b>fun</b> <a href="TransactionManager.md#0x1_TransactionManager_txn_epilogue_v3">txn_epilogue_v3</a>&lt;TokenType: store&gt;(account: &signer, txn_sender: <b>address</b>, txn_sequence_number: u64, txn_authentication_key_preimage: vector&lt;u8&gt;, txn_gas_price: u64, txn_max_gas_units: u64, gas_units_remaining: u64, stc_price: u128, stc_price_scaling: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TransactionManager.md#0x1_TransactionManager_txn_epilogue_v3">txn_epilogue_v3</a>&lt;TokenType: store&gt;(
    account: &signer,
    txn_sender: <b>address</b>,
    txn_sequence_number: u64,
    txn_authentication_key_preimage: vector&lt;u8&gt;,
    txn_gas_price: u64,
    txn_max_gas_units: u64,
    gas_units_remaining: u64,
    stc_price: u128,
    stc_price_scaling: u128,
) {
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(account);
    // Charge for gas
    <b>let</b> (transaction_fee_amount_stc,transaction_fee_amount_token) = transaction_fee_simulate(
        txn_gas_price,
        txn_max_gas_units,
        gas_units_remaining,
        stc_price,
        stc_price_scaling);
    <b>assert</b>!(
        balance&lt;TokenType&gt;(txn_sender) &gt;= transaction_fee_amount_token,
        <a href="Errors.md#0x1_Errors_limit_exceeded">Errors::limit_exceeded</a>(<a href="TransactionManager.md#0x1_TransactionManager_EINSUFFICIENT_BALANCE">EINSUFFICIENT_BALANCE</a>)
    );

    <b>if</b> (!is_stc&lt;TokenType&gt;()){
        <b>let</b> gas_fee_address = <a href="EasyGas.md#0x1_EasyGas_get_gas_fee_address">EasyGas::get_gas_fee_address</a>();
        <b>let</b> genesis_balance_amount_stc=balance&lt;<a href="STC.md#0x1_STC">STC</a>&gt;(gas_fee_address);
        <b>assert</b>!(genesis_balance_amount_stc &gt;= transaction_fee_amount_stc,
            <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TransactionManager.md#0x1_TransactionManager_EPROLOGUE_CANT_PAY_GAS_DEPOSIT">EPROLOGUE_CANT_PAY_GAS_DEPOSIT</a>)
        );
    };
    // Bump the sequence number
    <a href="Account.md#0x1_Account_set_sequence_number">Account::set_sequence_number</a>(txn_sender,txn_sequence_number+1);
    // Set auth key when user send transaction first.
    <b>if</b> (<a href="Account.md#0x1_Account_is_dummy_auth_key_v2">Account::is_dummy_auth_key_v2</a>(txn_sender) && !<a href="Vector.md#0x1_Vector_is_empty">Vector::is_empty</a>(&txn_authentication_key_preimage)){
        <a href="Account.md#0x1_Account_set_authentication_key">Account::set_authentication_key</a>(txn_sender, <a href="Hash.md#0x1_Hash_sha3_256">Hash::sha3_256</a>(txn_authentication_key_preimage));
    };

    <b>if</b> (transaction_fee_amount_stc &gt; 0) {
        <b>let</b> transaction_fee_token = <a href="Account.md#0x1_Account_withdraw_from_balance_v2">Account::withdraw_from_balance_v2</a>&lt;TokenType&gt;(
            txn_sender,
            transaction_fee_amount_token
        );
        <b>if</b>(!is_stc&lt;TokenType&gt;()) {
            <b>let</b> gas_fee_address = <a href="EasyGas.md#0x1_EasyGas_get_gas_fee_address">EasyGas::get_gas_fee_address</a>();
            <a href="Account.md#0x1_Account_deposit">Account::deposit</a>&lt;TokenType&gt;(gas_fee_address, transaction_fee_token);
            <b>let</b> stc_fee_token = <a href="Account.md#0x1_Account_withdraw_from_balance_v2">Account::withdraw_from_balance_v2</a>&lt;<a href="STC.md#0x1_STC">STC</a>&gt;(gas_fee_address, transaction_fee_amount_stc);
            <a href="TransactionFee.md#0x1_TransactionFee_pay_fee">TransactionFee::pay_fee</a>(stc_fee_token);
        }<b>else</b>{
            <a href="TransactionFee.md#0x1_TransactionFee_pay_fee">TransactionFee::pay_fee</a>(transaction_fee_token);
        }
    };
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
<b>aborts_if</b> <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account) != <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>();
<b>aborts_if</b> !<b>exists</b>&lt;<a href="Account.md#0x1_Account">Account</a>&gt;(txn_sender);
<b>aborts_if</b> !<b>exists</b>&lt;Balance&lt;TokenType&gt;&gt;(txn_sender);
<b>aborts_if</b> txn_sequence_number + 1 &gt; max_u64();
<b>aborts_if</b> !<b>exists</b>&lt;Balance&lt;TokenType&gt;&gt;(txn_sender);
<b>aborts_if</b> txn_max_gas_units &lt; gas_units_remaining;
</code></pre>



</details>

<a name="@Module_Specification_1"></a>

## Module Specification



<pre><code><b>pragma</b> verify = <b>false</b>;
<b>pragma</b> aborts_if_is_strict = <b>true</b>;
</code></pre>