
<a name="0x1_DaoAccount"></a>

# Module `0x1::DaoAccount`



-  [Resource `DaoAccount`](#0x1_DaoAccount_DaoAccount)
-  [Resource `DaoAccountCapability`](#0x1_DaoAccount_DaoAccountCapability)
-  [Function `create_account`](#0x1_DaoAccount_create_account)
-  [Function `create_account_entry`](#0x1_DaoAccount_create_account_entry)
-  [Function `extract_dao_account_cap`](#0x1_DaoAccount_extract_dao_account_cap)
-  [Function `upgrade_to_dao`](#0x1_DaoAccount_upgrade_to_dao)
-  [Function `dao_signer`](#0x1_DaoAccount_dao_signer)
-  [Function `submit_upgrade_plan`](#0x1_DaoAccount_submit_upgrade_plan)
-  [Function `submit_upgrade_plan_entry`](#0x1_DaoAccount_submit_upgrade_plan_entry)


<pre><code><b>use</b> <a href="Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="PackageTxnManager.md#0x1_PackageTxnManager">0x1::PackageTxnManager</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
</code></pre>



<a name="0x1_DaoAccount_DaoAccount"></a>

## Resource `DaoAccount`

DaoAccount


<pre><code><b>struct</b> <a href="DaoAccount.md#0x1_DaoAccount">DaoAccount</a> <b>has</b> key
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
</dl>


</details>

<a name="0x1_DaoAccount_DaoAccountCapability"></a>

## Resource `DaoAccountCapability`

This capability can control the Dao account


<pre><code><b>struct</b> <a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a> <b>has</b> store, key
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

<a name="0x1_DaoAccount_create_account"></a>

## Function `create_account`

Create a new Dao Account and return DaoAccountCapability
Dao Account is a delegate account, the <code>creator</code> has the <code><a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a></code>


<pre><code><b>public</b> <b>fun</b> <a href="DaoAccount.md#0x1_DaoAccount_create_account">create_account</a>(creator: &signer): <a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccount::DaoAccountCapability</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DaoAccount.md#0x1_DaoAccount_create_account">create_account</a>(creator: &signer): <a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a> {
    <b>let</b> (dao_address, signer_cap) = <a href="Account.md#0x1_Account_create_delegate_account">Account::create_delegate_account</a>(creator);
    <b>let</b> dao_signer = <a href="Account.md#0x1_Account_create_signer_with_cap">Account::create_signer_with_cap</a>(&signer_cap);

    <a href="PackageTxnManager.md#0x1_PackageTxnManager_update_module_upgrade_strategy">PackageTxnManager::update_module_upgrade_strategy</a>(&dao_signer, <a href="PackageTxnManager.md#0x1_PackageTxnManager_get_strategy_two_phase">PackageTxnManager::get_strategy_two_phase</a>(), <a href="Option.md#0x1_Option_some">Option::some</a>(0));
    <b>move_to</b>(&dao_signer, <a href="DaoAccount.md#0x1_DaoAccount">DaoAccount</a>{
        dao_address,
        signer_cap: signer_cap,
    });
    <a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a>{
        dao_address
    }
}
</code></pre>



</details>

<a name="0x1_DaoAccount_create_account_entry"></a>

## Function `create_account_entry`

Entry function for create dao account, the <code><a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a></code> save to the <code>creator</code> account


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DaoAccount.md#0x1_DaoAccount_create_account_entry">create_account_entry</a>(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DaoAccount.md#0x1_DaoAccount_create_account_entry">create_account_entry</a>(sender: signer){
    <b>let</b> cap = <a href="DaoAccount.md#0x1_DaoAccount_create_account">create_account</a>(&sender);
    <b>move_to</b>(&sender, cap);
}
</code></pre>



</details>

<a name="0x1_DaoAccount_extract_dao_account_cap"></a>

## Function `extract_dao_account_cap`



<pre><code><b>public</b> <b>fun</b> <a href="DaoAccount.md#0x1_DaoAccount_extract_dao_account_cap">extract_dao_account_cap</a>(sender: &signer): <a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccount::DaoAccountCapability</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DaoAccount.md#0x1_DaoAccount_extract_dao_account_cap">extract_dao_account_cap</a>(sender: &signer): <a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a> <b>acquires</b> <a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a>{
    //TODO check
    <b>move_from</b>&lt;<a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a>&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender))
}
</code></pre>



</details>

<a name="0x1_DaoAccount_upgrade_to_dao"></a>

## Function `upgrade_to_dao`

Upgrade <code>sender</code> account to Dao account


<pre><code><b>public</b> <b>fun</b> <a href="DaoAccount.md#0x1_DaoAccount_upgrade_to_dao">upgrade_to_dao</a>(sender: signer): <a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccount::DaoAccountCapability</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DaoAccount.md#0x1_DaoAccount_upgrade_to_dao">upgrade_to_dao</a>(sender: signer): <a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a> {
    //TODO <b>assert</b> sender not <a href="Dao.md#0x1_Dao">Dao</a>
    <b>let</b> signer_cap = <a href="Account.md#0x1_Account_remove_signer_capability">Account::remove_signer_capability</a>(&sender);
    //TODO check the account upgrade_strategy
    <a href="PackageTxnManager.md#0x1_PackageTxnManager_update_module_upgrade_strategy">PackageTxnManager::update_module_upgrade_strategy</a>(&sender, <a href="PackageTxnManager.md#0x1_PackageTxnManager_get_strategy_two_phase">PackageTxnManager::get_strategy_two_phase</a>(), <a href="Option.md#0x1_Option_some">Option::some</a>(0));
    <b>let</b> dao_address = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&sender);
    <b>move_to</b>(&sender, <a href="DaoAccount.md#0x1_DaoAccount">DaoAccount</a>{
        dao_address,
        signer_cap: signer_cap,
    });
    <a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a>{
        dao_address
    }
}
</code></pre>



</details>

<a name="0x1_DaoAccount_dao_signer"></a>

## Function `dao_signer`

Provide a function to create signer with <code><a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a></code>


<pre><code><b>public</b> <b>fun</b> <a href="DaoAccount.md#0x1_DaoAccount_dao_signer">dao_signer</a>(cap: &<a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccount::DaoAccountCapability</a>): signer
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DaoAccount.md#0x1_DaoAccount_dao_signer">dao_signer</a>(cap: &<a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a>): signer <b>acquires</b> <a href="DaoAccount.md#0x1_DaoAccount">DaoAccount</a> {
    <b>let</b> signer_cap = &<b>borrow_global</b>&lt;<a href="DaoAccount.md#0x1_DaoAccount">DaoAccount</a>&gt;(cap.dao_address).signer_cap;
    <a href="Account.md#0x1_Account_create_signer_with_cap">Account::create_signer_with_cap</a>(signer_cap)
}
</code></pre>



</details>

<a name="0x1_DaoAccount_submit_upgrade_plan"></a>

## Function `submit_upgrade_plan`

Sumbit upgrade plan for the Dao account
This function is a shortcut for create signer with DaoAccountCapability and invoke <code><a href="PackageTxnManager.md#0x1_PackageTxnManager_submit_upgrade_plan_v2">PackageTxnManager::submit_upgrade_plan_v2</a></code>


<pre><code><b>public</b> <b>fun</b> <a href="DaoAccount.md#0x1_DaoAccount_submit_upgrade_plan">submit_upgrade_plan</a>(cap: &<a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccount::DaoAccountCapability</a>, package_hash: vector&lt;u8&gt;, version: u64, enforced: bool)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DaoAccount.md#0x1_DaoAccount_submit_upgrade_plan">submit_upgrade_plan</a>(cap: &<a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a>, package_hash: vector&lt;u8&gt;, version:u64, enforced: bool) <b>acquires</b> <a href="DaoAccount.md#0x1_DaoAccount">DaoAccount</a>{
    <b>let</b> dao_signer = <a href="DaoAccount.md#0x1_DaoAccount_dao_signer">dao_signer</a>(cap);
    <a href="PackageTxnManager.md#0x1_PackageTxnManager_submit_upgrade_plan_v2">PackageTxnManager::submit_upgrade_plan_v2</a>(&dao_signer, package_hash, version, enforced);
}
</code></pre>



</details>

<a name="0x1_DaoAccount_submit_upgrade_plan_entry"></a>

## Function `submit_upgrade_plan_entry`

Sumbit upgrade plan for the Dao account, sender must hold the <code><a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a></code>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DaoAccount.md#0x1_DaoAccount_submit_upgrade_plan_entry">submit_upgrade_plan_entry</a>(sender: signer, package_hash: vector&lt;u8&gt;, version: u64, enforced: bool)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DaoAccount.md#0x1_DaoAccount_submit_upgrade_plan_entry">submit_upgrade_plan_entry</a>(sender: signer, package_hash: vector&lt;u8&gt;, version:u64, enforced: bool) <b>acquires</b> <a href="DaoAccount.md#0x1_DaoAccount">DaoAccount</a>, <a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a>{
    <b>let</b> addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&sender);
    <b>let</b> cap = <b>borrow_global</b>&lt;<a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccountCapability</a>&gt;(addr);
    <a href="DaoAccount.md#0x1_DaoAccount_submit_upgrade_plan">submit_upgrade_plan</a>(cap, package_hash, version, enforced)
}
</code></pre>



</details>
