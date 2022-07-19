
<a name="0x1_InstallPluginProposalPlugin"></a>

# Module `0x1::InstallPluginProposalPlugin`



-  [Struct `InstallPluginProposalPlugin`](#0x1_InstallPluginProposalPlugin_InstallPluginProposalPlugin)
-  [Struct `InstallPluginAction`](#0x1_InstallPluginProposalPlugin_InstallPluginAction)
-  [Function `required_caps`](#0x1_InstallPluginProposalPlugin_required_caps)
-  [Function `create_proposal`](#0x1_InstallPluginProposalPlugin_create_proposal)
-  [Function `execute_proposal`](#0x1_InstallPluginProposalPlugin_execute_proposal)


<pre><code><b>use</b> <a href="GenesisDao.md#0x1_GenesisDao">0x1::GenesisDao</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_InstallPluginProposalPlugin_InstallPluginProposalPlugin"></a>

## Struct `InstallPluginProposalPlugin`



<pre><code><b>struct</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a> <b>has</b> drop
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
<code>required_caps: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_InstallPluginProposalPlugin_required_caps"></a>

## Function `required_caps`



<pre><code><b>public</b> <b>fun</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_required_caps">required_caps</a>(): vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_required_caps">required_caps</a>():vector&lt;CapType&gt;{
    <b>let</b> caps = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(<a href="GenesisDao.md#0x1_GenesisDao_proposal_cap_type">GenesisDao::proposal_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="GenesisDao.md#0x1_GenesisDao_install_plugin_cap_type">GenesisDao::install_plugin_cap_type</a>());
    caps
}
</code></pre>



</details>

<a name="0x1_InstallPluginProposalPlugin_create_proposal"></a>

## Function `create_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_create_proposal">create_proposal</a>&lt;DaoT: store, ToInstallPluginT&gt;(sender: &signer, required_caps: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_create_proposal">create_proposal</a>&lt;DaoT: store, ToInstallPluginT&gt;(sender: &signer, required_caps: vector&lt;CapType&gt;, action_delay: u64){
    <b>let</b> witness = <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>{};

    <b>let</b> cap = <a href="GenesisDao.md#0x1_GenesisDao_acquire_proposal_cap">GenesisDao::acquire_proposal_cap</a>&lt;DaoT, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>&gt;(&witness);
    <b>let</b> action = <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_InstallPluginAction">InstallPluginAction</a>&lt;ToInstallPluginT&gt;{
        required_caps,
    };
    <a href="GenesisDao.md#0x1_GenesisDao_create_proposal">GenesisDao::create_proposal</a>(&cap, sender, action, action_delay);
}
</code></pre>



</details>

<a name="0x1_InstallPluginProposalPlugin_execute_proposal"></a>

## Function `execute_proposal`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_execute_proposal">execute_proposal</a>&lt;DaoT: store, ToInstallPluginT&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_execute_proposal">execute_proposal</a>&lt;DaoT: store, ToInstallPluginT&gt;(sender: signer, proposal_id: u64){
    <b>let</b> witness = <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>{};
    <b>let</b> proposal_cap = <a href="GenesisDao.md#0x1_GenesisDao_acquire_proposal_cap">GenesisDao::acquire_proposal_cap</a>&lt;DaoT, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>&gt;(&witness);
    <b>let</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_InstallPluginAction">InstallPluginAction</a>{required_caps} = <a href="GenesisDao.md#0x1_GenesisDao_execute_proposal">GenesisDao::execute_proposal</a>&lt;DaoT, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_InstallPluginAction">InstallPluginAction</a>&lt;ToInstallPluginT&gt;&gt;(&proposal_cap, &sender, proposal_id);
    <b>let</b> install_plugin_cap = <a href="GenesisDao.md#0x1_GenesisDao_acquire_install_plugin_cap">GenesisDao::acquire_install_plugin_cap</a>&lt;DaoT, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>&gt;(&witness);
    <a href="GenesisDao.md#0x1_GenesisDao_install_plugin">GenesisDao::install_plugin</a>&lt;DaoT, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>, ToInstallPluginT&gt;(&install_plugin_cap, required_caps);
}
</code></pre>



</details>
