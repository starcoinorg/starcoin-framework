
<a name="0x1_DAOAccount"></a>

# Module `0x1::DAOAccount`



-  [Resource `DAOAccount`](#0x1_DAOAccount_DAOAccount)
-  [Resource `DAOAccountCap`](#0x1_DAOAccount_DAOAccountCap)
-  [Constants](#@Constants_0)
-  [Function `create_account`](#0x1_DAOAccount_create_account)
-  [Function `create_account_entry`](#0x1_DAOAccount_create_account_entry)
-  [Function `extract_dao_account_cap`](#0x1_DAOAccount_extract_dao_account_cap)
-  [Function `restore_dao_account_cap`](#0x1_DAOAccount_restore_dao_account_cap)
-  [Function `upgrade_to_dao`](#0x1_DAOAccount_upgrade_to_dao)
-  [Function `upgrade_to_dao_with_signer_cap`](#0x1_DAOAccount_upgrade_to_dao_with_signer_cap)
-  [Function `upgrade_to_dao_with_signer_cap_and_upgrade_plan_cap`](#0x1_DAOAccount_upgrade_to_dao_with_signer_cap_and_upgrade_plan_cap)
-  [Function `dao_signer`](#0x1_DAOAccount_dao_signer)
-  [Function `submit_upgrade_plan`](#0x1_DAOAccount_submit_upgrade_plan)
-  [Function `submit_upgrade_plan_entry`](#0x1_DAOAccount_submit_upgrade_plan_entry)
-  [Module Specification](#@Module_Specification_1)


<pre><code><b>use</b> <a href="Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="Config.md#0x1_Config">0x1::Config</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="PackageTxnManager.md#0x1_PackageTxnManager">0x1::PackageTxnManager</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="Version.md#0x1_Version">0x1::Version</a>;
</code></pre>



<a name="0x1_DAOAccount_DAOAccount"></a>

## Resource `DAOAccount`

DAOAccount


<pre><code><b>struct</b> <a href="DAOAccount.md#0x1_DAOAccount">DAOAccount</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_address: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>signer_cap: <a href="Account.md#0x1_Account_SignerCapability">Account::SignerCapability</a></code>
</dt>
<dd>

</dd>
<dt>
<code>upgrade_plan_cap: <a href="PackageTxnManager.md#0x1_PackageTxnManager_UpgradePlanCapability">PackageTxnManager::UpgradePlanCapability</a></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOAccount_DAOAccountCap"></a>

## Resource `DAOAccountCap`

This capability can control the DAO account


<pre><code><b>struct</b> <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a> <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_address: <b>address</b></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_DAOAccount_ERR_ACCOUNT_CAP_EXISTS"></a>



<pre><code><b>const</b> <a href="DAOAccount.md#0x1_DAOAccount_ERR_ACCOUNT_CAP_EXISTS">ERR_ACCOUNT_CAP_EXISTS</a>: u64 = 101;
</code></pre>



<a name="0x1_DAOAccount_ERR_ACCOUNT_CAP_NOT_EXISTS"></a>



<pre><code><b>const</b> <a href="DAOAccount.md#0x1_DAOAccount_ERR_ACCOUNT_CAP_NOT_EXISTS">ERR_ACCOUNT_CAP_NOT_EXISTS</a>: u64 = 100;
</code></pre>



<a name="0x1_DAOAccount_ERR_ACCOUNT_IS_NOT_SAME"></a>



<pre><code><b>const</b> <a href="DAOAccount.md#0x1_DAOAccount_ERR_ACCOUNT_IS_NOT_SAME">ERR_ACCOUNT_IS_NOT_SAME</a>: u64 = 102;
</code></pre>



<a name="0x1_DAOAccount_ERR_UPGARDE_PLAN_CAP_NOT_EXISTS"></a>



<pre><code><b>const</b> <a href="DAOAccount.md#0x1_DAOAccount_ERR_UPGARDE_PLAN_CAP_NOT_EXISTS">ERR_UPGARDE_PLAN_CAP_NOT_EXISTS</a>: u64 = 103;
</code></pre>



<a name="0x1_DAOAccount_create_account"></a>

## Function `create_account`

Create a new DAO Account and return DAOAccountCap
DAO Account is a delegate account, the <code>creator</code> has the <code><a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a></code>


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_create_account">create_account</a>(creator: &signer): <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccount::DAOAccountCap</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_create_account">create_account</a>(creator: &signer): <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a> {
    <b>let</b> (_dao_address, signer_cap) = <a href="Account.md#0x1_Account_create_delegate_account">Account::create_delegate_account</a>(creator);
    <a href="DAOAccount.md#0x1_DAOAccount_upgrade_to_dao_with_signer_cap">upgrade_to_dao_with_signer_cap</a>(signer_cap)
}
</code></pre>



</details>

<a name="0x1_DAOAccount_create_account_entry"></a>

## Function `create_account_entry`

Entry function for create dao account, the <code><a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a></code> save to the <code>creator</code> account


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_create_account_entry">create_account_entry</a>(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_create_account_entry">create_account_entry</a>(sender: signer){
    <b>let</b> cap = <a href="DAOAccount.md#0x1_DAOAccount_create_account">create_account</a>(&sender);
    <b>assert</b>!(!<b>exists</b>&lt;<a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a>&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&sender)), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="DAOAccount.md#0x1_DAOAccount_ERR_ACCOUNT_CAP_EXISTS">ERR_ACCOUNT_CAP_EXISTS</a>));
    <b>move_to</b>(&sender, cap);
}
</code></pre>



</details>

<a name="0x1_DAOAccount_extract_dao_account_cap"></a>

## Function `extract_dao_account_cap`

Extract the DAOAccountCap from the <code>sender</code>


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_extract_dao_account_cap">extract_dao_account_cap</a>(sender: &signer): <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccount::DAOAccountCap</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_extract_dao_account_cap">extract_dao_account_cap</a>(sender: &signer): <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a> <b>acquires</b> <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a> {
    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>assert</b>!(<b>exists</b>&lt;<a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a>&gt;(sender_addr), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="DAOAccount.md#0x1_DAOAccount_ERR_ACCOUNT_CAP_NOT_EXISTS">ERR_ACCOUNT_CAP_NOT_EXISTS</a>));
    <b>move_from</b>&lt;<a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a>&gt;(sender_addr)
}
</code></pre>



</details>

<a name="0x1_DAOAccount_restore_dao_account_cap"></a>

## Function `restore_dao_account_cap`

Restore the DAOAccountCap to the <code>sender</code>


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_restore_dao_account_cap">restore_dao_account_cap</a>(sender: &signer, cap: <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccount::DAOAccountCap</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_restore_dao_account_cap">restore_dao_account_cap</a>(sender: &signer, cap: <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a>) {
    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>assert</b>!(!<b>exists</b>&lt;<a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a>&gt;(sender_addr), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="DAOAccount.md#0x1_DAOAccount_ERR_ACCOUNT_CAP_EXISTS">ERR_ACCOUNT_CAP_EXISTS</a>));
    <b>move_to</b>(sender, cap)
}
</code></pre>



</details>

<a name="0x1_DAOAccount_upgrade_to_dao"></a>

## Function `upgrade_to_dao`

Upgrade <code>sender</code> account to DAO account


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_upgrade_to_dao">upgrade_to_dao</a>(sender: signer): <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccount::DAOAccountCap</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_upgrade_to_dao">upgrade_to_dao</a>(sender: signer): <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a> {
    <b>let</b> signer_cap = <a href="Account.md#0x1_Account_remove_signer_capability">Account::remove_signer_capability</a>(&sender);
    <a href="DAOAccount.md#0x1_DAOAccount_upgrade_to_dao_with_signer_cap">upgrade_to_dao_with_signer_cap</a>(signer_cap)
}
</code></pre>



</details>

<a name="0x1_DAOAccount_upgrade_to_dao_with_signer_cap"></a>

## Function `upgrade_to_dao_with_signer_cap`

Upgrade the account which have the <code>signer_cap</code> to a DAO Account


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_upgrade_to_dao_with_signer_cap">upgrade_to_dao_with_signer_cap</a>(signer_cap: <a href="Account.md#0x1_Account_SignerCapability">Account::SignerCapability</a>): <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccount::DAOAccountCap</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_upgrade_to_dao_with_signer_cap">upgrade_to_dao_with_signer_cap</a>(signer_cap: SignerCapability): <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a> {
    <b>let</b> dao_signer = <a href="Account.md#0x1_Account_create_signer_with_cap">Account::create_signer_with_cap</a>(&signer_cap);
    <b>let</b> dao_address = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&dao_signer);

    <b>let</b> upgrade_plan_cap = <b>if</b>(<a href="Config.md#0x1_Config_config_exist_by_address">Config::config_exist_by_address</a>&lt;<a href="Version.md#0x1_Version_Version">Version::Version</a>&gt;(dao_address)){
        <b>assert</b>!(<a href="PackageTxnManager.md#0x1_PackageTxnManager_exists_upgrade_plan_cap">PackageTxnManager::exists_upgrade_plan_cap</a>(dao_address), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="DAOAccount.md#0x1_DAOAccount_ERR_UPGARDE_PLAN_CAP_NOT_EXISTS">ERR_UPGARDE_PLAN_CAP_NOT_EXISTS</a>));
        <a href="PackageTxnManager.md#0x1_PackageTxnManager_extract_submit_upgrade_plan_cap">PackageTxnManager::extract_submit_upgrade_plan_cap</a>(&dao_signer)
    }<b>else</b>{
        <a href="Config.md#0x1_Config_publish_new_config">Config::publish_new_config</a>&lt;<a href="Version.md#0x1_Version_Version">Version::Version</a>&gt;(&dao_signer, <a href="Version.md#0x1_Version_new_version">Version::new_version</a>(1));
        <a href="PackageTxnManager.md#0x1_PackageTxnManager_update_module_upgrade_strategy">PackageTxnManager::update_module_upgrade_strategy</a>(&dao_signer, <a href="PackageTxnManager.md#0x1_PackageTxnManager_get_strategy_two_phase">PackageTxnManager::get_strategy_two_phase</a>(), <a href="Option.md#0x1_Option_some">Option::some</a>(1));
        <a href="PackageTxnManager.md#0x1_PackageTxnManager_extract_submit_upgrade_plan_cap">PackageTxnManager::extract_submit_upgrade_plan_cap</a>(&dao_signer)
    };
    <a href="DAOAccount.md#0x1_DAOAccount_upgrade_to_dao_with_signer_cap_and_upgrade_plan_cap">upgrade_to_dao_with_signer_cap_and_upgrade_plan_cap</a>(signer_cap, upgrade_plan_cap)
}
</code></pre>



</details>

<a name="0x1_DAOAccount_upgrade_to_dao_with_signer_cap_and_upgrade_plan_cap"></a>

## Function `upgrade_to_dao_with_signer_cap_and_upgrade_plan_cap`

Upgrade the account which have the <code>signer_cap</code> to a DAO Account


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_upgrade_to_dao_with_signer_cap_and_upgrade_plan_cap">upgrade_to_dao_with_signer_cap_and_upgrade_plan_cap</a>(signer_cap: <a href="Account.md#0x1_Account_SignerCapability">Account::SignerCapability</a>, upgrade_plan_cap: <a href="PackageTxnManager.md#0x1_PackageTxnManager_UpgradePlanCapability">PackageTxnManager::UpgradePlanCapability</a>): <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccount::DAOAccountCap</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_upgrade_to_dao_with_signer_cap_and_upgrade_plan_cap">upgrade_to_dao_with_signer_cap_and_upgrade_plan_cap</a>(signer_cap: SignerCapability, upgrade_plan_cap:UpgradePlanCapability): <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a> {
    <b>let</b> dao_signer = <a href="Account.md#0x1_Account_create_signer_with_cap">Account::create_signer_with_cap</a>(&signer_cap);
    <b>let</b> dao_address = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&dao_signer);

    <b>assert</b>!(<a href="Account.md#0x1_Account_signer_address">Account::signer_address</a>(&signer_cap) == <a href="PackageTxnManager.md#0x1_PackageTxnManager_account_address">PackageTxnManager::account_address</a>(&upgrade_plan_cap), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="DAOAccount.md#0x1_DAOAccount_ERR_ACCOUNT_IS_NOT_SAME">ERR_ACCOUNT_IS_NOT_SAME</a>));

    <b>move_to</b>(&dao_signer, <a href="DAOAccount.md#0x1_DAOAccount">DAOAccount</a>{
        dao_address,
        signer_cap,
        upgrade_plan_cap,
    });

    <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a>{
        dao_address
    }
}
</code></pre>



</details>

<a name="0x1_DAOAccount_dao_signer"></a>

## Function `dao_signer`

Provide a function to create signer with <code><a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a></code>


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_dao_signer">dao_signer</a>(cap: &<a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccount::DAOAccountCap</a>): signer
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_dao_signer">dao_signer</a>(cap: &<a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a>): signer <b>acquires</b> <a href="DAOAccount.md#0x1_DAOAccount">DAOAccount</a> {
    <b>let</b> signer_cap = &<b>borrow_global</b>&lt;<a href="DAOAccount.md#0x1_DAOAccount">DAOAccount</a>&gt;(cap.dao_address).signer_cap;
    <a href="Account.md#0x1_Account_create_signer_with_cap">Account::create_signer_with_cap</a>(signer_cap)
}
</code></pre>



</details>

<a name="0x1_DAOAccount_submit_upgrade_plan"></a>

## Function `submit_upgrade_plan`

Sumbit upgrade plan for the DAO account
This function is a shortcut for create signer with DAOAccountCap and invoke <code><a href="PackageTxnManager.md#0x1_PackageTxnManager_submit_upgrade_plan_v2">PackageTxnManager::submit_upgrade_plan_v2</a></code>


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_submit_upgrade_plan">submit_upgrade_plan</a>(cap: &<a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccount::DAOAccountCap</a>, package_hash: vector&lt;u8&gt;, version: u64, enforced: bool)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_submit_upgrade_plan">submit_upgrade_plan</a>(cap: &<a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a>, package_hash: vector&lt;u8&gt;, version:u64, enforced: bool) <b>acquires</b> <a href="DAOAccount.md#0x1_DAOAccount">DAOAccount</a>{
    <b>let</b> upgrade_plan_cap = &<b>borrow_global</b>&lt;<a href="DAOAccount.md#0x1_DAOAccount">DAOAccount</a>&gt;(cap.dao_address).upgrade_plan_cap;
    <a href="PackageTxnManager.md#0x1_PackageTxnManager_submit_upgrade_plan_with_cap_v2">PackageTxnManager::submit_upgrade_plan_with_cap_v2</a>(upgrade_plan_cap, package_hash, version, enforced);
}
</code></pre>



</details>

<a name="0x1_DAOAccount_submit_upgrade_plan_entry"></a>

## Function `submit_upgrade_plan_entry`

Sumbit upgrade plan for the DAO account, sender must hold the <code><a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a></code>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_submit_upgrade_plan_entry">submit_upgrade_plan_entry</a>(sender: signer, package_hash: vector&lt;u8&gt;, version: u64, enforced: bool)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOAccount.md#0x1_DAOAccount_submit_upgrade_plan_entry">submit_upgrade_plan_entry</a>(sender: signer, package_hash: vector&lt;u8&gt;, version:u64, enforced: bool) <b>acquires</b> <a href="DAOAccount.md#0x1_DAOAccount">DAOAccount</a>, <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a>{
    <b>let</b> addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&sender);
    <b>let</b> cap = <b>borrow_global</b>&lt;<a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccountCap</a>&gt;(addr);
    <a href="DAOAccount.md#0x1_DAOAccount_submit_upgrade_plan">submit_upgrade_plan</a>(cap, package_hash, version, enforced)
}
</code></pre>



</details>

<a name="@Module_Specification_1"></a>

## Module Specification



<pre><code><b>pragma</b> verify = <b>false</b>;
<b>pragma</b> aborts_if_is_strict = <b>true</b>;
</code></pre>
