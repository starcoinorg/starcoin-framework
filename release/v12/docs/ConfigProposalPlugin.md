
<a name="0x1_ConfigProposalPlugin"></a>

# Module `0x1::ConfigProposalPlugin`

Called by other contract which need proposal config


-  [Struct `ConfigProposalPlugin`](#0x1_ConfigProposalPlugin_ConfigProposalPlugin)
-  [Struct `ConfigProposalAction`](#0x1_ConfigProposalPlugin_ConfigProposalAction)
-  [Function `initialize`](#0x1_ConfigProposalPlugin_initialize)
-  [Function `required_caps`](#0x1_ConfigProposalPlugin_required_caps)
-  [Function `create_proposal`](#0x1_ConfigProposalPlugin_create_proposal)
-  [Function `execute_proposal`](#0x1_ConfigProposalPlugin_execute_proposal)
-  [Function `execute_proposal_entry`](#0x1_ConfigProposalPlugin_execute_proposal_entry)
-  [Function `install_plugin_proposal`](#0x1_ConfigProposalPlugin_install_plugin_proposal)
-  [Function `install_plugin_proposal_entry`](#0x1_ConfigProposalPlugin_install_plugin_proposal_entry)


<pre><code><b>use</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace">0x1::DAOPluginMarketplace</a>;
<b>use</b> <a href="DAOSpace.md#0x1_DAOSpace">0x1::DAOSpace</a>;
<b>use</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">0x1::InstallPluginProposalPlugin</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_ConfigProposalPlugin_ConfigProposalPlugin"></a>

## Struct `ConfigProposalPlugin`



<pre><code><b>struct</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">ConfigProposalPlugin</a> <b>has</b> drop, store
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

<a name="0x1_ConfigProposalPlugin_ConfigProposalAction"></a>

## Struct `ConfigProposalAction`



<pre><code><b>struct</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_ConfigProposalAction">ConfigProposalAction</a>&lt;ConfigT&gt; <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>config: ConfigT</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_ConfigProposalPlugin_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_initialize">initialize</a>(_sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_initialize">initialize</a>(_sender: &signer) {
    <b>let</b> witness = <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">ConfigProposalPlugin</a>{};

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_register_plugin">DAOPluginMarketplace::register_plugin</a>&lt;<a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">ConfigProposalPlugin</a>&gt;(
        &witness,
        b"<a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">0x1::ConfigProposalPlugin</a>",
        b"The config proposal plugin",
        <a href="Option.md#0x1_Option_none">Option::none</a>(),
    );

    <b>let</b> implement_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();
    <b>let</b> depend_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_publish_plugin_version">DAOPluginMarketplace::publish_plugin_version</a>&lt;<a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">ConfigProposalPlugin</a>&gt;(
        &witness,
        b"v0.1.0",
        *&implement_extpoints,
        *&depend_extpoints,
        b"inner-plugin://config-proposal-plugin",
    );
}
</code></pre>



</details>

<a name="0x1_ConfigProposalPlugin_required_caps"></a>

## Function `required_caps`



<pre><code><b>public</b> <b>fun</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_required_caps">required_caps</a>(): vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_required_caps">required_caps</a>(): vector&lt;CapType&gt; {
    <b>let</b> caps = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(<a href="DAOSpace.md#0x1_DAOSpace_proposal_cap_type">DAOSpace::proposal_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_modify_config_cap_type">DAOSpace::modify_config_cap_type</a>());
    caps
}
</code></pre>



</details>

<a name="0x1_ConfigProposalPlugin_create_proposal"></a>

## Function `create_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_create_proposal">create_proposal</a>&lt;DAOT: store, ConfigT: drop, store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, action_delay: u64, config: ConfigT)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_create_proposal">create_proposal</a>&lt;DAOT: store, ConfigT: store+drop&gt;(sender: &signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, description: vector&lt;u8&gt;,action_delay: u64, config: ConfigT) {
    <b>let</b> witness = <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">ConfigProposalPlugin</a>{};
    <b>let</b> cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">ConfigProposalPlugin</a>&gt;(&witness);
    <b>let</b> action = <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_ConfigProposalAction">ConfigProposalAction</a>&lt;ConfigT&gt;{
        config
    };
    <a href="DAOSpace.md#0x1_DAOSpace_create_proposal">DAOSpace::create_proposal</a>&lt;
        DAOT,
        <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">ConfigProposalPlugin</a>,
        <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_ConfigProposalAction">ConfigProposalAction</a>&lt;ConfigT&gt;&gt;(&cap, sender, action, title, introduction, description, action_delay, <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u8&gt;());
}
</code></pre>



</details>

<a name="0x1_ConfigProposalPlugin_execute_proposal"></a>

## Function `execute_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_execute_proposal">execute_proposal</a>&lt;DAOT: store, ConfigT: <b>copy</b>, drop, store&gt;(sender: &signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_execute_proposal">execute_proposal</a>&lt;DAOT: store, ConfigT: <b>copy</b> + drop + store&gt;(sender: &signer, proposal_id: u64) {
    <b>let</b> witness = <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">ConfigProposalPlugin</a>{};
    <b>let</b> proposal_cap =
        <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">ConfigProposalPlugin</a>&gt;(&witness);
    <b>let</b> modify_config_cap =
        <a href="DAOSpace.md#0x1_DAOSpace_acquire_modify_config_cap">DAOSpace::acquire_modify_config_cap</a>&lt;DAOT, <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">ConfigProposalPlugin</a>&gt;(&witness);

    <b>let</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_ConfigProposalAction">ConfigProposalAction</a>&lt;ConfigT&gt;{ config } = <a href="DAOSpace.md#0x1_DAOSpace_execute_proposal">DAOSpace::execute_proposal</a>&lt;
        DAOT,
        <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">ConfigProposalPlugin</a>,
        <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_ConfigProposalAction">ConfigProposalAction</a>&lt;ConfigT&gt;&gt;(&proposal_cap, sender, proposal_id);
    <a href="DAOSpace.md#0x1_DAOSpace_set_custom_config">DAOSpace::set_custom_config</a>&lt;DAOT, <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">ConfigProposalPlugin</a>, ConfigT&gt;(&<b>mut</b> modify_config_cap, config);
}
</code></pre>



</details>

<a name="0x1_ConfigProposalPlugin_execute_proposal_entry"></a>

## Function `execute_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_execute_proposal_entry">execute_proposal_entry</a>&lt;DAOT: store, ConfigT: <b>copy</b>, drop, store&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_execute_proposal_entry">execute_proposal_entry</a>&lt;DAOT: store, ConfigT: <b>copy</b> + drop + store&gt;(sender: signer, proposal_id: u64) {
    <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_execute_proposal">execute_proposal</a>&lt;DAOT, ConfigT&gt;(&sender, proposal_id);
}
</code></pre>



</details>

<a name="0x1_ConfigProposalPlugin_install_plugin_proposal"></a>

## Function `install_plugin_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT:store&gt;(sender:&signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, description: vector&lt;u8&gt;, action_delay:u64){
    <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_create_proposal">InstallPluginProposalPlugin::create_proposal</a>&lt;DAOT, <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">ConfigProposalPlugin</a>&gt;(sender, <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_required_caps">required_caps</a>(), title, introduction, description, action_delay);
}
</code></pre>



</details>

<a name="0x1_ConfigProposalPlugin_install_plugin_proposal_entry"></a>

## Function `install_plugin_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT:store&gt;(sender:signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, description: vector&lt;u8&gt;, action_delay:u64){
    <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT&gt;(&sender, title, introduction, description, action_delay);
}
</code></pre>



</details>
