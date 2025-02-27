
<a name="0x1_FrozenConfigStrategy"></a>

# Module `0x1::FrozenConfigStrategy`



-  [Resource `BurnBlockNumber`](#0x1_FrozenConfigStrategy_BurnBlockNumber)
-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1_FrozenConfigStrategy_initialize)
-  [Function `add_account`](#0x1_FrozenConfigStrategy_add_account)
-  [Function `remove_account`](#0x1_FrozenConfigStrategy_remove_account)
-  [Function `set_global_frozen`](#0x1_FrozenConfigStrategy_set_global_frozen)
-  [Function `has_frozen_global`](#0x1_FrozenConfigStrategy_has_frozen_global)
-  [Function `has_frozen_account`](#0x1_FrozenConfigStrategy_has_frozen_account)
-  [Function `update_burn_block_number`](#0x1_FrozenConfigStrategy_update_burn_block_number)
-  [Function `do_burn_frozen`](#0x1_FrozenConfigStrategy_do_burn_frozen)
-  [Function `frozen_list_v1`](#0x1_FrozenConfigStrategy_frozen_list_v1)
-  [Function `config_address`](#0x1_FrozenConfigStrategy_config_address)
-  [Function `assert_config_address`](#0x1_FrozenConfigStrategy_assert_config_address)


<pre><code><b>use</b> <a href="ACL.md#0x1_ACL">0x1::ACL</a>;
<b>use</b> <a href="Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="Block.md#0x1_Block">0x1::Block</a>;
<b>use</b> <a href="ChainId.md#0x1_ChainId">0x1::ChainId</a>;
<b>use</b> <a href="Config.md#0x1_Config">0x1::Config</a>;
<b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="FrozenConfig.md#0x1_FrozenConfig">0x1::FrozenConfig</a>;
<b>use</b> <a href="STC.md#0x1_STC">0x1::STC</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="Token.md#0x1_Token">0x1::Token</a>;
</code></pre>



<a name="0x1_FrozenConfigStrategy_BurnBlockNumber"></a>

## Resource `BurnBlockNumber`



<pre><code><b>struct</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_BurnBlockNumber">BurnBlockNumber</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>block_number: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_FrozenConfigStrategy_ERR_ADD_ACCOUNT_FAILED"></a>



<pre><code><b>const</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_ADD_ACCOUNT_FAILED">ERR_ADD_ACCOUNT_FAILED</a>: u64 = 101;
</code></pre>



<a name="0x1_FrozenConfigStrategy_ERR_ADD_ACCOUNT_HAS_EXISTS"></a>



<pre><code><b>const</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_ADD_ACCOUNT_HAS_EXISTS">ERR_ADD_ACCOUNT_HAS_EXISTS</a>: u64 = 102;
</code></pre>



<a name="0x1_FrozenConfigStrategy_ERR_ADD_CANNOT_BE_CORE_ADDRESS"></a>



<pre><code><b>const</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_ADD_CANNOT_BE_CORE_ADDRESS">ERR_ADD_CANNOT_BE_CORE_ADDRESS</a>: u64 = 103;
</code></pre>



<a name="0x1_FrozenConfigStrategy_ERR_BURN_FROZEN_LIST_IS_EMPTY"></a>



<pre><code><b>const</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_BURN_FROZEN_LIST_IS_EMPTY">ERR_BURN_FROZEN_LIST_IS_EMPTY</a>: u64 = 107;
</code></pre>



<a name="0x1_FrozenConfigStrategy_ERR_BURN_NOT_YET_TIME"></a>



<pre><code><b>const</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_BURN_NOT_YET_TIME">ERR_BURN_NOT_YET_TIME</a>: u64 = 106;
</code></pre>



<a name="0x1_FrozenConfigStrategy_ERR_REMOVE_ACCOUNT_FAILED"></a>



<pre><code><b>const</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_REMOVE_ACCOUNT_FAILED">ERR_REMOVE_ACCOUNT_FAILED</a>: u64 = 104;
</code></pre>



<a name="0x1_FrozenConfigStrategy_ERR_REMOVE_ACCOUNT_NOT_EXISTS"></a>



<pre><code><b>const</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_REMOVE_ACCOUNT_NOT_EXISTS">ERR_REMOVE_ACCOUNT_NOT_EXISTS</a>: u64 = 105;
</code></pre>



<a name="0x1_FrozenConfigStrategy_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_initialize">initialize</a>(framework_account: &signer, main_bnum: u64, barnard_bnum: u64, test_bnum: u64, other_bnum: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_initialize">initialize</a>(
    framework_account: &signer,
    main_bnum: u64,
    barnard_bnum: u64,
    test_bnum: u64,
    other_bnum: u64
) {
    assert_genesis_address(framework_account);

    <b>let</b> association_account_address = <a href="CoreAddresses.md#0x1_CoreAddresses_ASSOCIATION_ROOT_ADDRESS">CoreAddresses::ASSOCIATION_ROOT_ADDRESS</a>();

    <b>let</b> block_number_by_chain = <b>if</b> (<a href="ChainId.md#0x1_ChainId_is_main">ChainId::is_main</a>()) {
        main_bnum
    } <b>else</b> <b>if</b> (<a href="ChainId.md#0x1_ChainId_is_barnard">ChainId::is_barnard</a>()) {
        barnard_bnum
    } <b>else</b> <b>if</b> (<a href="ChainId.md#0x1_ChainId_is_test">ChainId::is_test</a>()) {
       test_bnum
    } <b>else</b> {
        other_bnum
    };
    <b>if</b> (!<b>exists</b>&lt;<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_BurnBlockNumber">BurnBlockNumber</a>&gt;(association_account_address)) {
        <b>let</b> association_account = <a href="Account.md#0x1_Account_create_signer_friend">Account::create_signer_friend</a>(association_account_address);

        // Initialize config
        <a href="FrozenConfig.md#0x1_FrozenConfig_initialize">FrozenConfig::initialize</a>(&association_account, <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_frozen_list_v1">Self::frozen_list_v1</a>());

        // Initalize <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_BurnBlockNumber">BurnBlockNumber</a>
        <b>move_to</b>(&association_account, <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_BurnBlockNumber">BurnBlockNumber</a> {
            block_number: block_number_by_chain
        })
    }
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_add_account"></a>

## Function `add_account`



<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_add_account">add_account</a>(accocial_account: signer, account: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_add_account">add_account</a>(accocial_account: signer, account: <b>address</b>) {
    <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_assert_config_address">assert_config_address</a>(&accocial_account);

    <b>assert</b>!(!<a href="CoreAddresses.md#0x1_CoreAddresses_is_core_address">CoreAddresses::is_core_address</a>(account), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_ADD_CANNOT_BE_CORE_ADDRESS">ERR_ADD_CANNOT_BE_CORE_ADDRESS</a>));

    <b>let</b> acl = <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">FrozenConfig::get_frozen_account_list</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>());
    <b>assert</b>!(!<a href="ACL.md#0x1_ACL_contains">ACL::contains</a>(&acl, account), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_ADD_ACCOUNT_HAS_EXISTS">ERR_ADD_ACCOUNT_HAS_EXISTS</a>));
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, account);
    <a href="FrozenConfig.md#0x1_FrozenConfig_set_account_list">FrozenConfig::set_account_list</a>(&accocial_account, acl);

    <b>assert</b>!(
        <a href="ACL.md#0x1_ACL_contains">ACL::contains</a>(&<a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">FrozenConfig::get_frozen_account_list</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>()), account),
        <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_ADD_ACCOUNT_FAILED">ERR_ADD_ACCOUNT_FAILED</a>)
    );
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_remove_account"></a>

## Function `remove_account`



<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_remove_account">remove_account</a>(associal_account: signer, account: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_remove_account">remove_account</a>(associal_account: signer, account: <b>address</b>) {
    <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_assert_config_address">assert_config_address</a>(&associal_account);

    <b>let</b> acl = <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">FrozenConfig::get_frozen_account_list</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>());
    <b>assert</b>!(<a href="ACL.md#0x1_ACL_contains">ACL::contains</a>(&acl, account), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_REMOVE_ACCOUNT_NOT_EXISTS">ERR_REMOVE_ACCOUNT_NOT_EXISTS</a>));
    <a href="ACL.md#0x1_ACL_remove">ACL::remove</a>(&<b>mut</b> acl, account);
    <a href="FrozenConfig.md#0x1_FrozenConfig_set_account_list">FrozenConfig::set_account_list</a>(&associal_account, acl);

    // Check <b>has</b> added
    <b>assert</b>!(
        !<a href="ACL.md#0x1_ACL_contains">ACL::contains</a>(&<a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">FrozenConfig::get_frozen_account_list</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>()), account),
        <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_REMOVE_ACCOUNT_FAILED">ERR_REMOVE_ACCOUNT_FAILED</a>)
    );
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_set_global_frozen"></a>

## Function `set_global_frozen`



<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_set_global_frozen">set_global_frozen</a>(sender: signer, frozen: bool)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_set_global_frozen">set_global_frozen</a>(sender: signer, frozen: bool) {
    <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_assert_config_address">assert_config_address</a>(&sender);
    <a href="FrozenConfig.md#0x1_FrozenConfig_set_global_frozen">FrozenConfig::set_global_frozen</a>(&sender, frozen);
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_has_frozen_global"></a>

## Function `has_frozen_global`



<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_has_frozen_global">has_frozen_global</a>(txn_sender: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_has_frozen_global">has_frozen_global</a>(txn_sender: <b>address</b>): bool {
    <b>if</b> (<a href="CoreAddresses.md#0x1_CoreAddresses_is_core_address">CoreAddresses::is_core_address</a>(txn_sender)) {
        <b>return</b> <b>false</b>
    };

    <b>if</b> (<a href="Config.md#0x1_Config_config_exist_by_address">Config::config_exist_by_address</a>&lt;<a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a>&gt;(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>())) {
        <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_global">FrozenConfig::get_frozen_global</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>())
    } <b>else</b> {
        <b>true</b>
    }
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_has_frozen_account"></a>

## Function `has_frozen_account`



<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_has_frozen_account">has_frozen_account</a>(txn_sender: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_has_frozen_account">has_frozen_account</a>(txn_sender: <b>address</b>): bool {
    <b>if</b> (<a href="CoreAddresses.md#0x1_CoreAddresses_is_core_address">CoreAddresses::is_core_address</a>(txn_sender)) {
        <b>return</b> <b>false</b>
    };

    <b>if</b> (<a href="Config.md#0x1_Config_config_exist_by_address">Config::config_exist_by_address</a>&lt;<a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a>&gt;(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>())) {
        <b>let</b> list = <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">FrozenConfig::get_frozen_account_list</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>());
        <a href="ACL.md#0x1_ACL_contains">ACL::contains</a>(&list, txn_sender)
    } <b>else</b> {
        <b>true</b>
    }
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_update_burn_block_number"></a>

## Function `update_burn_block_number`



<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_update_burn_block_number">update_burn_block_number</a>(associal_account: signer, block_number: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_update_burn_block_number">update_burn_block_number</a>(associal_account: signer, block_number: u64) <b>acquires</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_BurnBlockNumber">BurnBlockNumber</a> {
    assert_association_root_address(&associal_account);

    <b>let</b> burn_block_number =
        <b>borrow_global_mut</b>&lt;<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_BurnBlockNumber">BurnBlockNumber</a>&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&associal_account));
    burn_block_number.block_number = block_number;
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_do_burn_frozen"></a>

## Function `do_burn_frozen`

Burn all frozen account balance
First checks if the current block number is greater than the block number stored in the <code><a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_BurnBlockNumber">BurnBlockNumber</a></code> resource.
If the condition is met, it retrieves the list of frozen account addresses from the access - control list (ACL).
Then it iterates through this list, withdraws the entire STC balance from each frozen account, and burns the withdrawn STC.


<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_do_burn_frozen">do_burn_frozen</a>()
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_do_burn_frozen">do_burn_frozen</a>() <b>acquires</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_BurnBlockNumber">BurnBlockNumber</a> {
    <b>let</b> current_block_number = <a href="Block.md#0x1_Block_get_current_block_number">Block::get_current_block_number</a>();
    <b>let</b> burn_block_number =
        <b>borrow_global_mut</b>&lt;<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_BurnBlockNumber">BurnBlockNumber</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_ASSOCIATION_ROOT_ADDRESS">CoreAddresses::ASSOCIATION_ROOT_ADDRESS</a>());

    <b>assert</b>!(current_block_number &gt;= burn_block_number.block_number, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_BURN_NOT_YET_TIME">ERR_BURN_NOT_YET_TIME</a>));

    <b>let</b> acl = <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">FrozenConfig::get_frozen_account_list</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>());
    <b>let</b> addresses = <a href="ACL.md#0x1_ACL_get_vector">ACL::get_vector</a>(&acl);
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&addresses);
    <b>assert</b>!(len &gt; 0, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_BURN_FROZEN_LIST_IS_EMPTY">ERR_BURN_FROZEN_LIST_IS_EMPTY</a>));

    <b>let</b> i = 0;
    <b>while</b> (i &lt; len) {
        <b>let</b> frozen_address = *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&addresses, i);
        <b>let</b> balance = <a href="Account.md#0x1_Account_balance">Account::balance</a>&lt;<a href="STC.md#0x1_STC">STC</a>&gt;(frozen_address);
        <b>if</b> (balance &gt; 0) {
            <b>let</b> frozen_signer = <a href="Account.md#0x1_Account_create_signer_friend">Account::create_signer_friend</a>(frozen_address);
            <b>let</b> stc = <a href="Account.md#0x1_Account_withdraw">Account::withdraw</a>&lt;<a href="STC.md#0x1_STC">STC</a>&gt;(&frozen_signer, balance);
            <a href="STC.md#0x1_STC_destroy">STC::destroy</a>(stc);
        };
        i = i + 1;
    }
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_frozen_list_v1"></a>

## Function `frozen_list_v1`



<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_frozen_list_v1">frozen_list_v1</a>(): <a href="ACL.md#0x1_ACL_ACL">ACL::ACL</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_frozen_list_v1">frozen_list_v1</a>(): <a href="ACL.md#0x1_ACL_ACL">ACL::ACL</a> {
    <b>let</b> acl = <a href="ACL.md#0x1_ACL_empty">ACL::empty</a>();

    // Add the initialize frozen account list
    <b>if</b> (<a href="ChainId.md#0x1_ChainId_is_main">ChainId::is_main</a>()) {
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x11ed1fa4209b6f0f03e5385b8bc5d1ea);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x329173fe798bfd77094a101c0adad3b4);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xe845c1ae63507c3fbc2f31af0bcc18bb);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x4a7198503af3c765030d4e43863f64a7);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xbab1094a9ed5b2a2d3a10c143cded8a5);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x7af065f4fa20ff2e1bc54be9b17184ed);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x10ab9214c40102c524a12788849210f1);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x2e890d015e7bd850e4ec99da86a952c0);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xb9ad8b357eb59ec508db8e0f19515ae0);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xe14270fab28624f05ff56472e3f1c2f7);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xf9f1bfbbea129e6cbb6d0e11ece3e737);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x0c44cf1168999b923b16d50c86934b56);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x0ae121570b3fd6c9701fce43f06a3c27);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x414f5c01ce1fe0020883020ef878f934);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x7e969eb99f7d9c08cf71db20bc7323bf);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xa62594faff9b19cecc3a511ca0dd3abd);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x15c37f15045f448d26fd262d86d5619c);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xf0d8331409d2da08b5d22c41772d7df7);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xe0c0ce2df4f1e0b0f1b6dc10bbabfdb3);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x4532c92d46cda2257fc9896b7bc0d031);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xb78ff901ddc89744269f5b194fe124ec);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xda9c2b5689b3c9ab8ecd3b0140505117);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xa631d4daafec285ac92a81a9bd50f753);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x58da94cd48805d9f98e80ae6734c0248);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x3a126aee08f6c4cc905091943e9140b9);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x79e5f6ce285211fe350369d0a52fee0d);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x55d770233251c2973c09f8929610f12b);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x375842560f651807d837b71ffd715458);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x7b202199ec36e84b5fa89027690d2a6e);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x8d9b5f9874a911297d39cdd931b6466b);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x5918b0782056c9b698459ad37565d15b);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x23b1620cf3b4f4528b09e31f109e732d);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x614d3e65850a05365ed0556e483c9bae);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xe8891c3775e9ce4e827b7a575e0731fa);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x1e92f96b0d230e7b61b22b4d1d356b77);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x114774968e64412c323605ceaf4fe8d5);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x8f838a32dfaf44911466410ceed7e398);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xdc9d382c448261ff4ba836fc5dbaba63);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x1702e4f0df56482d09d233e4affbc0b3);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x7b2ac05e6467aeb927cd6fa473badcf8);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x8096295553fd54c584b8e961da18ab0c);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x1eef2699f7ba8c79133c261bc54fce2c);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xba73558ae7b59f6fdcff09c9ad1821cf);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x211e0ae997fdd0da507713be1c160e8d);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x03691f8d00b79502498f3b47faa8eafa);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xa6caa5c2a2a4168c383be7f08b31087f);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xca34c1afcbec6401b65642bdc9aa4e09);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x8697aa50a5776d0ab22614fb9edf6675);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xb6cda160a6433f7d648bd24a10a06a6a);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x00b7563162ee94a57457ba08a5f80c3c);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x12d95e1db2a54d15bc50927e5655af2d);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x9c59015c60e0f262d3b6571bcd9c5b0b);
    } <b>else</b> {
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xd0c5a06ae6100ce115cad1600fe59e96);
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x1af80d10cb642adcd9f7fee1420104ec);
    };
    acl
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_config_address"></a>

## Function `config_address`



<pre><code><b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>(): <b>address</b>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>(): <b>address</b> {
    <a href="CoreAddresses.md#0x1_CoreAddresses_ASSOCIATION_ROOT_ADDRESS">CoreAddresses::ASSOCIATION_ROOT_ADDRESS</a>()
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_assert_config_address"></a>

## Function `assert_config_address`



<pre><code><b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_assert_config_address">assert_config_address</a>(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_assert_config_address">assert_config_address</a>(sender: &signer) {
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_association_root_address">CoreAddresses::assert_association_root_address</a>(sender);
}
</code></pre>



</details>
