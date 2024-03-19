
<a name="0x1_FrozenConfigStrategy"></a>

# Module `0x1::FrozenConfigStrategy`



-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1_FrozenConfigStrategy_initialize)
-  [Function `do_initialize`](#0x1_FrozenConfigStrategy_do_initialize)
-  [Function `add_account`](#0x1_FrozenConfigStrategy_add_account)
-  [Function `remove_account`](#0x1_FrozenConfigStrategy_remove_account)
-  [Function `set_global_frozen`](#0x1_FrozenConfigStrategy_set_global_frozen)
-  [Function `has_frozen_global`](#0x1_FrozenConfigStrategy_has_frozen_global)
-  [Function `has_frozen_account`](#0x1_FrozenConfigStrategy_has_frozen_account)
-  [Function `frozen_list_v1`](#0x1_FrozenConfigStrategy_frozen_list_v1)
-  [Function `config_address`](#0x1_FrozenConfigStrategy_config_address)
-  [Function `assert_config_address`](#0x1_FrozenConfigStrategy_assert_config_address)


<pre><code><b>use</b> <a href="ACL.md#0x1_ACL">0x1::ACL</a>;
<b>use</b> <a href="Config.md#0x1_Config">0x1::Config</a>;
<b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="FrozenConfig.md#0x1_FrozenConfig">0x1::FrozenConfig</a>;
</code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="0x1_FrozenConfigStrategy_ERR_ADD_ACCOUNT_FAILED"></a>



<pre><code><b>const</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_ADD_ACCOUNT_FAILED">ERR_ADD_ACCOUNT_FAILED</a>: u64 = 101;
</code></pre>



<a name="0x1_FrozenConfigStrategy_ERR_ADD_CANNOT_BE_CORE_ADDRESS"></a>



<pre><code><b>const</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_ADD_CANNOT_BE_CORE_ADDRESS">ERR_ADD_CANNOT_BE_CORE_ADDRESS</a>: u64 = 103;
</code></pre>



<a name="0x1_FrozenConfigStrategy_ERR_REMOVE_ACCOUNT_FAILED"></a>



<pre><code><b>const</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_REMOVE_ACCOUNT_FAILED">ERR_REMOVE_ACCOUNT_FAILED</a>: u64 = 102;
</code></pre>



<a name="0x1_FrozenConfigStrategy_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_initialize">initialize</a>(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_initialize">initialize</a>(sender: signer) {
    <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_do_initialize">do_initialize</a>(&sender);
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_do_initialize"></a>

## Function `do_initialize`



<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_do_initialize">do_initialize</a>(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_do_initialize">do_initialize</a>(sender: &signer) {
    <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_assert_config_address">assert_config_address</a>(sender);
    <a href="FrozenConfig.md#0x1_FrozenConfig_initialize">FrozenConfig::initialize</a>(sender, <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_frozen_list_v1">frozen_list_v1</a>());
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_add_account"></a>

## Function `add_account`



<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_add_account">add_account</a>(sender: signer, account: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_add_account">add_account</a>(sender: signer, account: <b>address</b>) {
    <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_assert_config_address">assert_config_address</a>(&sender);
    <b>assert</b>!(!<a href="CoreAddresses.md#0x1_CoreAddresses_is_core_address">CoreAddresses::is_core_address</a>(account), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_ADD_CANNOT_BE_CORE_ADDRESS">ERR_ADD_CANNOT_BE_CORE_ADDRESS</a>));

    <b>let</b> acl = <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">FrozenConfig::get_frozen_account_list</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>());
    <b>if</b> (!<a href="ACL.md#0x1_ACL_contains">ACL::contains</a>(&acl, account)) {
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, account);
        <a href="FrozenConfig.md#0x1_FrozenConfig_set_account_list">FrozenConfig::set_account_list</a>(&sender, acl);
    };
    <b>let</b> new_acl = <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">FrozenConfig::get_frozen_account_list</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>());
    <b>assert</b>!(<a href="ACL.md#0x1_ACL_contains">ACL::contains</a>(&new_acl, account), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_ADD_ACCOUNT_FAILED">ERR_ADD_ACCOUNT_FAILED</a>));
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_remove_account"></a>

## Function `remove_account`



<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_remove_account">remove_account</a>(sender: signer, account: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_remove_account">remove_account</a>(sender: signer, account: <b>address</b>) {
    <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_assert_config_address">assert_config_address</a>(&sender);
    <b>let</b> acl = <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">FrozenConfig::get_frozen_account_list</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>());
    <b>if</b> (<a href="ACL.md#0x1_ACL_contains">ACL::contains</a>(&acl, account)) {
        <a href="ACL.md#0x1_ACL_remove">ACL::remove</a>(&<b>mut</b> acl, account);
        <a href="FrozenConfig.md#0x1_FrozenConfig_set_account_list">FrozenConfig::set_account_list</a>(&sender, acl);
    };
    <b>let</b> new_acl = <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">FrozenConfig::get_frozen_account_list</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>());
    <b>assert</b>!(!<a href="ACL.md#0x1_ACL_contains">ACL::contains</a>(&new_acl, account), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_REMOVE_ACCOUNT_FAILED">ERR_REMOVE_ACCOUNT_FAILED</a>));
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
        <b>false</b>
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
        <b>false</b>
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
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x114774968e64412c323605ceaf4fe8d5);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x211e0ae997fdd0da507713be1c160e8d);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xb6cda160a6433f7d648bd24a10a06a6a);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x79e5f6ce285211fe350369d0a52fee0d);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x58da94cd48805d9f98e80ae6734c0248);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x8f838a32dfaf44911466410ceed7e398);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xda9c2b5689b3c9ab8ecd3b0140505117);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x614d3e65850a05365ed0556e483c9bae);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xe14270fab28624f05ff56472e3f1c2f7);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x10ab9214c40102c524a12788849210f1);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xba73558ae7b59f6fdcff09c9ad1821cf);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xca34c1afcbec6401b65642bdc9aa4e09);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x375842560f651807d837b71ffd715458);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xe0c0ce2df4f1e0b0f1b6dc10bbabfdb3);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xe8891c3775e9ce4e827b7a575e0731fa);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x1e92f96b0d230e7b61b22b4d1d356b77);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x1eef2699f7ba8c79133c261bc54fce2c);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x00b7563162ee94a57457ba08a5f80c3c);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x3a126aee08f6c4cc905091943e9140b9);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xf9f1bfbbea129e6cbb6d0e11ece3e737);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xb78ff901ddc89744269f5b194fe124ec);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x7b202199ec36e84b5fa89027690d2a6e);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xbab1094a9ed5b2a2d3a10c143cded8a5);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x4532c92d46cda2257fc9896b7bc0d031);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x23b1620cf3b4f4528b09e31f109e732d);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x8d9b5f9874a911297d39cdd931b6466b);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x329173fe798bfd77094a101c0adad3b4);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x1702e4f0df56482d09d233e4affbc0b3);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x11ed1fa4209b6f0f03e5385b8bc5d1ea);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x2e890d015e7bd850e4ec99da86a952c0);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x414f5c01ce1fe0020883020ef878f934);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x55d770233251c2973c09f8929610f12b);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xe845c1ae63507c3fbc2f31af0bcc18bb);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xa6caa5c2a2a4168c383be7f08b31087f);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x8697aa50a5776d0ab22614fb9edf6675);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x0c44cf1168999b923b16d50c86934b56);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x7af065f4fa20ff2e1bc54be9b17184ed);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xdc9d382c448261ff4ba836fc5dbaba63);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xf0d8331409d2da08b5d22c41772d7df7);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x15c37f15045f448d26fd262d86d5619c);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xa631d4daafec285ac92a81a9bd50f753);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x8096295553fd54c584b8e961da18ab0c);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x9c59015c60e0f262d3b6571bcd9c5b0b);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xa62594faff9b19cecc3a511ca0dd3abd);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x12d95e1db2a54d15bc50927e5655af2d);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xb9ad8b357eb59ec508db8e0f19515ae0);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x4a7198503af3c765030d4e43863f64a7);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x7b2ac05e6467aeb927cd6fa473badcf8);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x0ae121570b3fd6c9701fce43f06a3c27);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x5918b0782056c9b698459ad37565d15b);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x03691f8d00b79502498f3b47faa8eafa);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x7e969eb99f7d9c08cf71db20bc7323bf);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x340893ca7178356e2a303129e5933bfe);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0xb1e87052146eb1651a1c404b33480a5a);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x0ca8b57eb98c34d558a167989415de73);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x0782a3dd4f2e460f19270ff3ade92335);
    <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, @0x482cad7b30e39763b5e2f5423070be35);

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
