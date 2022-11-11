
<a name="0x1_GasOracleProposalPlugin"></a>

# Module `0x1::GasOracleProposalPlugin`



-  [Struct `GasOracleProposalPlugin`](#0x1_GasOracleProposalPlugin_GasOracleProposalPlugin)
-  [Struct `OracleCreateAction`](#0x1_GasOracleProposalPlugin_OracleCreateAction)
-  [Struct `OracleSourceAddAction`](#0x1_GasOracleProposalPlugin_OracleSourceAddAction)
-  [Struct `OracleSourceRemoveAction`](#0x1_GasOracleProposalPlugin_OracleSourceRemoveAction)
-  [Struct `OracleSources`](#0x1_GasOracleProposalPlugin_OracleSources)
-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1_GasOracleProposalPlugin_initialize)
-  [Function `required_caps`](#0x1_GasOracleProposalPlugin_required_caps)
-  [Function `create_oracle_add_proposal`](#0x1_GasOracleProposalPlugin_create_oracle_add_proposal)
-  [Function `execute_oracle_add_proposal`](#0x1_GasOracleProposalPlugin_execute_oracle_add_proposal)
-  [Function `create_oracle_remove_proposal`](#0x1_GasOracleProposalPlugin_create_oracle_remove_proposal)
-  [Function `execute_oracle_remove_proposal`](#0x1_GasOracleProposalPlugin_execute_oracle_remove_proposal)
-  [Function `gas_oracle_read`](#0x1_GasOracleProposalPlugin_gas_oracle_read)
-  [Function `install_plugin_proposal`](#0x1_GasOracleProposalPlugin_install_plugin_proposal)
-  [Function `install_plugin_proposal_entry`](#0x1_GasOracleProposalPlugin_install_plugin_proposal_entry)


<pre><code><b>use</b> <a href="Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace">0x1::DAOPluginMarketplace</a>;
<b>use</b> <a href="DAOSpace.md#0x1_DAOSpace">0x1::DAOSpace</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Oracle.md#0x1_GasOracle">0x1::GasOracle</a>;
<b>use</b> <a href="GenesisSignerCapability.md#0x1_GenesisSignerCapability">0x1::GenesisSignerCapability</a>;
<b>use</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">0x1::InstallPluginProposalPlugin</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Oracle.md#0x1_PriceOracleAggregator">0x1::PriceOracleAggregator</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_GasOracleProposalPlugin_GasOracleProposalPlugin"></a>

## Struct `GasOracleProposalPlugin`



<pre><code><b>struct</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dummy_field: bool</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GasOracleProposalPlugin_OracleCreateAction"></a>

## Struct `OracleCreateAction`



<pre><code><b>struct</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleCreateAction">OracleCreateAction</a>&lt;TokenType: store&gt; <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>precision: u8</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GasOracleProposalPlugin_OracleSourceAddAction"></a>

## Struct `OracleSourceAddAction`



<pre><code><b>struct</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSourceAddAction">OracleSourceAddAction</a>&lt;TokenType: store&gt; <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>source_address: <b>address</b></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GasOracleProposalPlugin_OracleSourceRemoveAction"></a>

## Struct `OracleSourceRemoveAction`



<pre><code><b>struct</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSourceRemoveAction">OracleSourceRemoveAction</a>&lt;TokenType: store&gt; <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>source_address: <b>address</b></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GasOracleProposalPlugin_OracleSources"></a>

## Struct `OracleSources`



<pre><code><b>struct</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSources">OracleSources</a>&lt;TokenType: store&gt; <b>has</b> <b>copy</b>, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>source_addresses: vector&lt;<b>address</b>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_GasOracleProposalPlugin_ERR_PLUGIN_ORACLE_EXIST"></a>



<pre><code><b>const</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_ERR_PLUGIN_ORACLE_EXIST">ERR_PLUGIN_ORACLE_EXIST</a>: u64 = 1001;
</code></pre>



<a name="0x1_GasOracleProposalPlugin_ERR_PLUGIN_ORACLE_NOT_EXIST"></a>



<pre><code><b>const</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_ERR_PLUGIN_ORACLE_NOT_EXIST">ERR_PLUGIN_ORACLE_NOT_EXIST</a>: u64 = 1002;
</code></pre>



<a name="0x1_GasOracleProposalPlugin_ORACLE_UPDATED_IN"></a>



<pre><code><b>const</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_ORACLE_UPDATED_IN">ORACLE_UPDATED_IN</a>: u64 = 600000;
</code></pre>



<a name="0x1_GasOracleProposalPlugin_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_initialize">initialize</a>(_sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_initialize">initialize</a>(_sender: &signer) {
    <b>let</b> witness = <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>{};

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_register_plugin">DAOPluginMarketplace::register_plugin</a>&lt;<a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>&gt;(
        &witness,
        b"0x1::GasOraclePlugin",
        b"The plugin for gas oracle.",
        <a href="Option.md#0x1_Option_none">Option::none</a>(),
    );

    <b>let</b> implement_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();
    <b>let</b> depend_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_publish_plugin_version">DAOPluginMarketplace::publish_plugin_version</a>&lt;<a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>&gt;(
        &witness,
        b"v0.1.0",
        *&implement_extpoints,
        *&depend_extpoints,
        b"inner-plugin://gas-oracle-plugin",
    );
}
</code></pre>



</details>

<a name="0x1_GasOracleProposalPlugin_required_caps"></a>

## Function `required_caps`



<pre><code><b>public</b> <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_required_caps">required_caps</a>(): vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_required_caps">required_caps</a>(): vector&lt;CapType&gt; {
    <b>let</b> caps = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(<a href="DAOSpace.md#0x1_DAOSpace_proposal_cap_type">DAOSpace::proposal_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_storage_cap_type">DAOSpace::storage_cap_type</a>());
    caps
}
</code></pre>



</details>

<a name="0x1_GasOracleProposalPlugin_create_oracle_add_proposal"></a>

## Function `create_oracle_add_proposal`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_create_oracle_add_proposal">create_oracle_add_proposal</a>&lt;DAOT: store, TokenType: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64, source_address: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_create_oracle_add_proposal">create_oracle_add_proposal</a>&lt;DAOT: store, TokenType: store&gt;(sender: signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64, source_address: <b>address</b>) {
    <b>let</b> witness = <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>{};
    <b>let</b> cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>&gt;(&witness);
    <b>let</b> action = <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSourceAddAction">OracleSourceAddAction</a>&lt;TokenType&gt;{
        source_address
    };
    <a href="DAOSpace.md#0x1_DAOSpace_create_proposal">DAOSpace::create_proposal</a>(&cap, &sender, action, title, introduction, extend, action_delay, <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u8&gt;());
}
</code></pre>



</details>

<a name="0x1_GasOracleProposalPlugin_execute_oracle_add_proposal"></a>

## Function `execute_oracle_add_proposal`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_execute_oracle_add_proposal">execute_oracle_add_proposal</a>&lt;DAOT: store, TokenType: store&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_execute_oracle_add_proposal">execute_oracle_add_proposal</a>&lt;DAOT: store, TokenType: store&gt;(sender: signer, proposal_id: u64) {
    <b>let</b> witness = <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>{};
    <b>let</b> proposal_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>&gt;(&witness);
    <b>let</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSourceAddAction">OracleSourceAddAction</a>&lt;TokenType&gt;{ source_address } = <a href="DAOSpace.md#0x1_DAOSpace_execute_proposal">DAOSpace::execute_proposal</a>&lt;DAOT, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSourceAddAction">OracleSourceAddAction</a>&lt;TokenType&gt;&gt;(&proposal_cap, &sender, proposal_id);
    <b>let</b> storage_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_storage_cap">DAOSpace::acquire_storage_cap</a>&lt;DAOT, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>&gt;(&witness);
    <b>let</b> source_addresses = <b>if</b> (!<a href="DAOSpace.md#0x1_DAOSpace_exists_in_storage">DAOSpace::exists_in_storage</a>&lt;DAOT, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSources">OracleSources</a>&lt;TokenType&gt;&gt;()) {
        <b>let</b> genesis_singer= <a href="GenesisSignerCapability.md#0x1_GenesisSignerCapability_get_genesis_signer">GenesisSignerCapability::get_genesis_signer</a>();
        <a href="Account.md#0x1_Account_accept_token">Account::accept_token</a>&lt;TokenType&gt;(genesis_singer);
        <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(source_address)
    }<b>else</b> {
        <b>let</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSources">OracleSources</a>&lt;TokenType&gt;{ source_addresses } = <a href="DAOSpace.md#0x1_DAOSpace_take_from_storage">DAOSpace::take_from_storage</a>&lt;DAOT, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSources">OracleSources</a>&lt;TokenType&gt;&gt;(&storage_cap);
        <b>assert</b>!(<a href="Vector.md#0x1_Vector_contains">Vector::contains</a>(&source_addresses, &source_address) == <b>false</b>, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_ERR_PLUGIN_ORACLE_EXIST">ERR_PLUGIN_ORACLE_EXIST</a>));
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> source_addresses, source_address);
        source_addresses
    };

    <a href="DAOSpace.md#0x1_DAOSpace_save_to_storage">DAOSpace::save_to_storage</a>(&storage_cap, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSources">OracleSources</a>&lt;TokenType&gt;{ source_addresses });
}
</code></pre>



</details>

<a name="0x1_GasOracleProposalPlugin_create_oracle_remove_proposal"></a>

## Function `create_oracle_remove_proposal`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_create_oracle_remove_proposal">create_oracle_remove_proposal</a>&lt;DAOT: store, TokenType: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64, source_address: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_create_oracle_remove_proposal">create_oracle_remove_proposal</a>&lt;DAOT: store, TokenType: store&gt;(sender: signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64, source_address: <b>address</b>) {
    <b>let</b> witness = <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>{};
    <b>let</b> cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>&gt;(&witness);
    <b>let</b> action = <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSourceRemoveAction">OracleSourceRemoveAction</a>&lt;TokenType&gt;{
        source_address
    };
    <a href="DAOSpace.md#0x1_DAOSpace_create_proposal">DAOSpace::create_proposal</a>(&cap, &sender, action, title, introduction, extend, action_delay, <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u8&gt;());
}
</code></pre>



</details>

<a name="0x1_GasOracleProposalPlugin_execute_oracle_remove_proposal"></a>

## Function `execute_oracle_remove_proposal`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_execute_oracle_remove_proposal">execute_oracle_remove_proposal</a>&lt;DAOT: store, TokenType: store&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_execute_oracle_remove_proposal">execute_oracle_remove_proposal</a>&lt;DAOT: store, TokenType: store&gt;(sender: signer, proposal_id: u64) {
    <b>let</b> witness = <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>{};
    <b>let</b> proposal_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>&gt;(&witness);
    <b>let</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSourceRemoveAction">OracleSourceRemoveAction</a>&lt;TokenType&gt;{ source_address } = <a href="DAOSpace.md#0x1_DAOSpace_execute_proposal">DAOSpace::execute_proposal</a>&lt;DAOT, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSourceRemoveAction">OracleSourceRemoveAction</a>&lt;TokenType&gt;&gt;(&proposal_cap, &sender, proposal_id);
    <b>let</b> storage_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_storage_cap">DAOSpace::acquire_storage_cap</a>&lt;DAOT, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>&gt;(&witness);
    <b>assert</b>!(<a href="DAOSpace.md#0x1_DAOSpace_exists_in_storage">DAOSpace::exists_in_storage</a>&lt;DAOT, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSources">OracleSources</a>&lt;TokenType&gt;&gt;(), <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_ERR_PLUGIN_ORACLE_NOT_EXIST">ERR_PLUGIN_ORACLE_NOT_EXIST</a>);
    <b>let</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSources">OracleSources</a>&lt;TokenType&gt;{ source_addresses } = <a href="DAOSpace.md#0x1_DAOSpace_take_from_storage">DAOSpace::take_from_storage</a>&lt;DAOT, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSources">OracleSources</a>&lt;TokenType&gt;&gt;(&storage_cap);
    <b>let</b> (exist,index)= <a href="Vector.md#0x1_Vector_index_of">Vector::index_of</a>(&source_addresses, &source_address);
    <b>assert</b>!(exist, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_ERR_PLUGIN_ORACLE_NOT_EXIST">ERR_PLUGIN_ORACLE_NOT_EXIST</a>));
    <a href="Vector.md#0x1_Vector_remove">Vector::remove</a>(&<b>mut</b> source_addresses,index);
    <a href="DAOSpace.md#0x1_DAOSpace_save_to_storage">DAOSpace::save_to_storage</a>(&storage_cap, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSources">OracleSources</a>&lt;TokenType&gt;{ source_addresses });
}
</code></pre>



</details>

<a name="0x1_GasOracleProposalPlugin_gas_oracle_read"></a>

## Function `gas_oracle_read`



<pre><code><b>public</b> <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_gas_oracle_read">gas_oracle_read</a>&lt;DAOT: store, TokenType: store&gt;(): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_gas_oracle_read">gas_oracle_read</a>&lt;DAOT: store, TokenType: store&gt;(): u128 {
    <b>let</b> witness = <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>{};
    <b>let</b> storage_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_storage_cap">DAOSpace::acquire_storage_cap</a>&lt;DAOT, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>&gt;(&witness);
    <b>let</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSources">OracleSources</a>{ source_addresses } = <a href="DAOSpace.md#0x1_DAOSpace_copy_from_storage">DAOSpace::copy_from_storage</a>&lt;DAOT, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_OracleSources">OracleSources</a>&lt;TokenType&gt;&gt;(&storage_cap);
    <a href="Oracle.md#0x1_PriceOracleAggregator_latest_price_average_aggregator">PriceOracleAggregator::latest_price_average_aggregator</a>&lt;STCToken&lt;TokenType&gt;&gt;(&source_addresses, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_ORACLE_UPDATED_IN">ORACLE_UPDATED_IN</a>)
}
</code></pre>



</details>

<a name="0x1_GasOracleProposalPlugin_install_plugin_proposal"></a>

## Function `install_plugin_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT: store&gt;(sender: &signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64) {
    <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_create_proposal">InstallPluginProposalPlugin::create_proposal</a>&lt;DAOT, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>&gt;(sender, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_required_caps">required_caps</a>(), title, introduction, extend, action_delay);
}
</code></pre>



</details>

<a name="0x1_GasOracleProposalPlugin_install_plugin_proposal_entry"></a>

## Function `install_plugin_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64) {
    <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT&gt;(&sender, title, introduction, extend, action_delay);
}
</code></pre>



</details>
