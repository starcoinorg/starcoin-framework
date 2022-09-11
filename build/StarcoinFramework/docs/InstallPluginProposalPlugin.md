
<a name="0x1_InstallPluginProposalPlugin"></a>

# Module `0x1::InstallPluginProposalPlugin`



-  [Resource `InstallPluginProposalPlugin`](#0x1_InstallPluginProposalPlugin_InstallPluginProposalPlugin)
-  [Struct `InstallPluginAction`](#0x1_InstallPluginProposalPlugin_InstallPluginAction)
-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1_InstallPluginProposalPlugin_initialize)
-  [Function `required_caps`](#0x1_InstallPluginProposalPlugin_required_caps)
-  [Function `create_proposal`](#0x1_InstallPluginProposalPlugin_create_proposal)
-  [Function `execute_proposal`](#0x1_InstallPluginProposalPlugin_execute_proposal)


<pre><code><b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
<b>use</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace">0x1::DAOPluginMarketplace</a>;
<b>use</b> <a href="DAOSpace.md#0x1_DAOSpace">0x1::DAOSpace</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="GenesisSignerCapability.md#0x1_GenesisSignerCapability">0x1::GenesisSignerCapability</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_InstallPluginProposalPlugin_InstallPluginProposalPlugin"></a>

## Resource `InstallPluginProposalPlugin`



<pre><code><b>struct</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a> <b>has</b> drop, store, key
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

<a name="0x1_InstallPluginProposalPlugin_InstallPluginAction"></a>

## Struct `InstallPluginAction`



<pre><code><b>struct</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_InstallPluginAction">InstallPluginAction</a>&lt;ToInstallPluginT&gt; <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>plugin_version: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>required_caps: vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_InstallPluginProposalPlugin_ERR_ALREADY_INITIALIZED"></a>



<pre><code><b>const</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_ERR_ALREADY_INITIALIZED">ERR_ALREADY_INITIALIZED</a>: u64 = 100;
</code></pre>



<a name="0x1_InstallPluginProposalPlugin_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_initialize">initialize</a>()
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_initialize">initialize</a>() {
    <b>assert</b>!(!<b>exists</b>&lt;<a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_ERR_ALREADY_INITIALIZED">ERR_ALREADY_INITIALIZED</a>));
    <b>let</b> signer = <a href="GenesisSignerCapability.md#0x1_GenesisSignerCapability_get_genesis_signer">GenesisSignerCapability::get_genesis_signer</a>();

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_register_plugin">DAOPluginMarketplace::register_plugin</a>&lt;<a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>&gt;(
        &signer,
        b"<a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">0x1::InstallPluginProposalPlugin</a>",
        b"The plugin for install plugin proposal",
        <a href="Option.md#0x1_Option_none">Option::none</a>(),
    );

    <b>let</b> implement_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();
    <b>let</b> depend_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_publish_plugin_version">DAOPluginMarketplace::publish_plugin_version</a>&lt;<a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>&gt;(
        &signer,
        b"v0.1.0",
        *&implement_extpoints,
        *&depend_extpoints,
        b"inner-plugin://install-plugin-proposal-plugin",
    );
}
</code></pre>



</details>

<a name="0x1_InstallPluginProposalPlugin_required_caps"></a>

## Function `required_caps`



<pre><code><b>public</b> <b>fun</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_required_caps">required_caps</a>(): vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_required_caps">required_caps</a>():vector&lt;CapType&gt;{
    <b>let</b> caps = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(<a href="DAOSpace.md#0x1_DAOSpace_proposal_cap_type">DAOSpace::proposal_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_install_plugin_cap_type">DAOSpace::install_plugin_cap_type</a>());
    caps
}
</code></pre>



</details>

<a name="0x1_InstallPluginProposalPlugin_create_proposal"></a>

## Function `create_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_create_proposal">create_proposal</a>&lt;DAOT: store, ToInstallPluginT: store&gt;(sender: &signer, plugin_version: u64, required_caps: vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;, description: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_create_proposal">create_proposal</a>&lt;DAOT: store, ToInstallPluginT: store&gt;(sender: &signer, plugin_version: u64, required_caps: vector&lt;CapType&gt;, description: vector&lt;u8&gt;, action_delay: u64){
    <b>let</b> witness = <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>{};

    <b>let</b> cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>&gt;(&witness);
    <b>let</b> action = <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_InstallPluginAction">InstallPluginAction</a>&lt;ToInstallPluginT&gt;{
        plugin_version: plugin_version,
        required_caps,
    };

    <a href="DAOSpace.md#0x1_DAOSpace_create_proposal">DAOSpace::create_proposal</a>(&cap, sender, action, description, action_delay);
}
</code></pre>



</details>

<a name="0x1_InstallPluginProposalPlugin_execute_proposal"></a>

## Function `execute_proposal`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_execute_proposal">execute_proposal</a>&lt;DAOT: store, ToInstallPluginT: store&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_execute_proposal">execute_proposal</a>&lt;DAOT: store, ToInstallPluginT: store&gt;(sender: signer, proposal_id: u64){
    <b>let</b> witness = <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>{};

    <b>let</b> proposal_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>&gt;(&witness);
    <b>let</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_InstallPluginAction">InstallPluginAction</a>{plugin_version, required_caps} = <a href="DAOSpace.md#0x1_DAOSpace_execute_proposal">DAOSpace::execute_proposal</a>&lt;DAOT, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_InstallPluginAction">InstallPluginAction</a>&lt;ToInstallPluginT&gt;&gt;(&proposal_cap, &sender, proposal_id);

    <b>let</b> install_plugin_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_install_plugin_cap">DAOSpace::acquire_install_plugin_cap</a>&lt;DAOT, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>&gt;(&witness);
    <a href="DAOSpace.md#0x1_DAOSpace_install_plugin">DAOSpace::install_plugin</a>&lt;DAOT, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>, ToInstallPluginT&gt;(&install_plugin_cap, plugin_version, required_caps);
}
</code></pre>



</details>
