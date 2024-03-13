
<a name="0x1_FrozenConfigStrategy"></a>

# Module `0x1::FrozenConfigStrategy`



-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1_FrozenConfigStrategy_initialize)
-  [Function `add_account`](#0x1_FrozenConfigStrategy_add_account)
-  [Function `remove_account`](#0x1_FrozenConfigStrategy_remove_account)
-  [Function `set_global_frozen`](#0x1_FrozenConfigStrategy_set_global_frozen)
-  [Function `has_frozen_global`](#0x1_FrozenConfigStrategy_has_frozen_global)
-  [Function `has_frozen_account`](#0x1_FrozenConfigStrategy_has_frozen_account)
-  [Function `frozen_list_v1`](#0x1_FrozenConfigStrategy_frozen_list_v1)
-  [Function `config_address`](#0x1_FrozenConfigStrategy_config_address)
-  [Function `assert_config_address`](#0x1_FrozenConfigStrategy_assert_config_address)


<pre><code><b>use</b> <a href="ACL.md#0x1_ACL">0x1::ACL</a>;
<b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="FrozenConfig.md#0x1_FrozenConfig">0x1::FrozenConfig</a>;
</code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="0x1_FrozenConfigStrategy_ERR_ADD_ACCOUNT_FAILED"></a>



<pre><code><b>const</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_ADD_ACCOUNT_FAILED">ERR_ADD_ACCOUNT_FAILED</a>: u64 = 101;
</code></pre>



<a name="0x1_FrozenConfigStrategy_ERR_REMOVE_ACCOUNT_FAILED"></a>



<pre><code><b>const</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_REMOVE_ACCOUNT_FAILED">ERR_REMOVE_ACCOUNT_FAILED</a>: u64 = 102;
</code></pre>



<a name="0x1_FrozenConfigStrategy_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_initialize">initialize</a>(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_initialize">initialize</a>(sender: &signer) {
    <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_assert_config_address">assert_config_address</a>(sender);
    <a href="FrozenConfig.md#0x1_FrozenConfig_initialize">FrozenConfig::initialize</a>(sender, <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_frozen_list_v1">frozen_list_v1</a>());
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_add_account"></a>

## Function `add_account`



<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_add_account">add_account</a>(sender: &signer, account: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_add_account">add_account</a>(sender: &signer, account: <b>address</b>) {
    <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_assert_config_address">assert_config_address</a>(sender);
    <b>let</b> acl = <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">FrozenConfig::get_frozen_account_list</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>());
    <b>if</b> (!<a href="ACL.md#0x1_ACL_contains">ACL::contains</a>(&acl, account)) {
        <a href="ACL.md#0x1_ACL_add">ACL::add</a>(&<b>mut</b> acl, account);
        <a href="FrozenConfig.md#0x1_FrozenConfig_set_account_list">FrozenConfig::set_account_list</a>(sender, acl);
    };
    <b>let</b> new_acl = <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">FrozenConfig::get_frozen_account_list</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>());
    <b>assert</b>!(<a href="ACL.md#0x1_ACL_contains">ACL::contains</a>(&new_acl, account), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_ADD_ACCOUNT_FAILED">ERR_ADD_ACCOUNT_FAILED</a>));
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_remove_account"></a>

## Function `remove_account`



<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_remove_account">remove_account</a>(sender: &signer, account: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_remove_account">remove_account</a>(sender: &signer, account: <b>address</b>) {
    <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_assert_config_address">assert_config_address</a>(sender);
    <b>let</b> acl = <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">FrozenConfig::get_frozen_account_list</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>());
    <b>if</b> (<a href="ACL.md#0x1_ACL_contains">ACL::contains</a>(&acl, account)) {
        <a href="ACL.md#0x1_ACL_remove">ACL::remove</a>(&<b>mut</b> acl, account);
        <a href="FrozenConfig.md#0x1_FrozenConfig_set_account_list">FrozenConfig::set_account_list</a>(sender, acl);
    };
    <b>let</b> new_acl = <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">FrozenConfig::get_frozen_account_list</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>());
    <b>assert</b>!(!<a href="ACL.md#0x1_ACL_contains">ACL::contains</a>(&new_acl, account), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_ERR_REMOVE_ACCOUNT_FAILED">ERR_REMOVE_ACCOUNT_FAILED</a>));
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_set_global_frozen"></a>

## Function `set_global_frozen`



<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_set_global_frozen">set_global_frozen</a>(sender: &signer, frozen: bool)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_set_global_frozen">set_global_frozen</a>(sender: &signer, frozen: bool) {
    <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_assert_config_address">assert_config_address</a>(sender);
    <a href="FrozenConfig.md#0x1_FrozenConfig_set_global_frozen">FrozenConfig::set_global_frozen</a>(sender, frozen);
}
</code></pre>



</details>

<a name="0x1_FrozenConfigStrategy_has_frozen_global"></a>

## Function `has_frozen_global`



<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_has_frozen_global">has_frozen_global</a>(): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_has_frozen_global">has_frozen_global</a>(): bool {
    <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_global">FrozenConfig::get_frozen_global</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>())
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
    <b>let</b> list = <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">FrozenConfig::get_frozen_account_list</a>(<a href="FrozenConfigStrategy.md#0x1_FrozenConfigStrategy_config_address">config_address</a>());
    <a href="ACL.md#0x1_ACL_contains">ACL::contains</a>(&list, txn_sender)
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
    // TODO(bob): To add the initialize frozen account list
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
