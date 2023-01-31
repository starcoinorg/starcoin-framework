
<a name="0x1_UpgradeModulePlugin"></a>

# Module `0x1::UpgradeModulePlugin`



-  [Struct `UpgradeModulePlugin`](#0x1_UpgradeModulePlugin_UpgradeModulePlugin)
-  [Struct `UpgradeModuleAction`](#0x1_UpgradeModulePlugin_UpgradeModuleAction)
-  [Function `initialize`](#0x1_UpgradeModulePlugin_initialize)
-  [Function `required_caps`](#0x1_UpgradeModulePlugin_required_caps)
-  [Function `create_proposal`](#0x1_UpgradeModulePlugin_create_proposal)
-  [Function `create_proposal_entry`](#0x1_UpgradeModulePlugin_create_proposal_entry)
-  [Function `execute_proposal`](#0x1_UpgradeModulePlugin_execute_proposal)
-  [Function `execute_proposal_entry`](#0x1_UpgradeModulePlugin_execute_proposal_entry)
-  [Function `install_plugin_proposal`](#0x1_UpgradeModulePlugin_install_plugin_proposal)
-  [Function `install_plugin_proposal_entry`](#0x1_UpgradeModulePlugin_install_plugin_proposal_entry)


<pre><code><b>use</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace">0x1::DAOPluginMarketplace</a>;
<b>use</b> <a href="DAOSpace.md#0x1_DAOSpace">0x1::DAOSpace</a>;
<b>use</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">0x1::InstallPluginProposalPlugin</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_UpgradeModulePlugin_UpgradeModulePlugin"></a>

## Struct `UpgradeModulePlugin`



<pre><code><b>struct</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">UpgradeModulePlugin</a> <b>has</b> drop, store
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

<a name="0x1_UpgradeModulePlugin_UpgradeModuleAction"></a>

## Struct `UpgradeModuleAction`



<pre><code><b>struct</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_UpgradeModuleAction">UpgradeModuleAction</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>package_hash: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>version: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>enforced: bool</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_UpgradeModulePlugin_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_initialize">initialize</a>(_sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_initialize">initialize</a>(_sender: &signer) {
    <b>let</b> witness = <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">UpgradeModulePlugin</a>{};

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_register_plugin">DAOPluginMarketplace::register_plugin</a>&lt;<a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">UpgradeModulePlugin</a>&gt;(
        &witness,
        b"<a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">0x1::UpgradeModulePlugin</a>",
        b"The plugin for upgrade <b>module</b>.",
        <a href="Option.md#0x1_Option_none">Option::none</a>(),
    );

    <b>let</b> implement_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();
    <b>let</b> depend_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_publish_plugin_version">DAOPluginMarketplace::publish_plugin_version</a>&lt;<a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">UpgradeModulePlugin</a>&gt;(
        &witness,
        b"v0.1.0",
        *&implement_extpoints,
        *&depend_extpoints,
        b"inner-plugin://upgrade-<b>module</b>-plugin",
    );
}
</code></pre>



</details>

<a name="0x1_UpgradeModulePlugin_required_caps"></a>

## Function `required_caps`



<pre><code><b>public</b> <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_required_caps">required_caps</a>(): vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_required_caps">required_caps</a>(): vector&lt;CapType&gt; {
    <b>let</b> caps = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(<a href="DAOSpace.md#0x1_DAOSpace_proposal_cap_type">DAOSpace::proposal_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_upgrade_module_cap_type">DAOSpace::upgrade_module_cap_type</a>());
    caps
}
</code></pre>



</details>

<a name="0x1_UpgradeModulePlugin_create_proposal"></a>

## Function `create_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_create_proposal">create_proposal</a>&lt;DAOT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64, package_hash: vector&lt;u8&gt;, version: u64, enforced: bool)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_create_proposal">create_proposal</a>&lt;DAOT: store&gt;(sender: &signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay:u64, package_hash: vector&lt;u8&gt;, version: u64, enforced: bool) {
    <b>let</b> witness = <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">UpgradeModulePlugin</a>{};
    <b>let</b> cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">UpgradeModulePlugin</a>&gt;(&witness);
    <b>let</b> action = <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_UpgradeModuleAction">UpgradeModuleAction</a>{
        package_hash,
        version,
        enforced
    };
    <a href="DAOSpace.md#0x1_DAOSpace_create_proposal">DAOSpace::create_proposal</a>&lt;
        DAOT,
        <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">UpgradeModulePlugin</a>,
        <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_UpgradeModuleAction">UpgradeModuleAction</a>&gt;(&cap, sender, action, title, introduction, extend, action_delay, <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u8&gt;());
}
</code></pre>



</details>

<a name="0x1_UpgradeModulePlugin_create_proposal_entry"></a>

## Function `create_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_create_proposal_entry">create_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64, package_hash: vector&lt;u8&gt;, version: u64, enforced: bool)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_create_proposal_entry">create_proposal_entry</a> &lt;DAOT: store&gt;(sender: signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay:u64, package_hash: vector&lt;u8&gt;, version: u64, enforced: bool) {
    <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_create_proposal">create_proposal</a>&lt;DAOT&gt;(&sender, title, introduction, extend, action_delay, package_hash, version, enforced);
}
</code></pre>



</details>

<a name="0x1_UpgradeModulePlugin_execute_proposal"></a>

## Function `execute_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_execute_proposal">execute_proposal</a>&lt;DAOT: store&gt;(sender: &signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_execute_proposal">execute_proposal</a>&lt;DAOT: store&gt;(sender: &signer, proposal_id: u64) {
    <b>let</b> witness = <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">UpgradeModulePlugin</a>{};
    <b>let</b> proposal_cap =
        <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">UpgradeModulePlugin</a>&gt;(&witness);
    <b>let</b> upgrade_module_cap =
        <a href="DAOSpace.md#0x1_DAOSpace_acquire_upgrade_module_cap">DAOSpace::acquire_upgrade_module_cap</a>&lt;DAOT, <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">UpgradeModulePlugin</a>&gt;(&witness);

    <b>let</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_UpgradeModuleAction">UpgradeModuleAction</a>{
        package_hash,
        version,
        enforced
    } = <a href="DAOSpace.md#0x1_DAOSpace_execute_proposal">DAOSpace::execute_proposal</a>&lt;
        DAOT,
        <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">UpgradeModulePlugin</a>,
        <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_UpgradeModuleAction">UpgradeModuleAction</a>&gt;(&proposal_cap, sender, proposal_id);
    <a href="DAOSpace.md#0x1_DAOSpace_submit_upgrade_plan">DAOSpace::submit_upgrade_plan</a>&lt;DAOT, <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">UpgradeModulePlugin</a>&gt;(&<b>mut</b> upgrade_module_cap, package_hash, version, enforced);
}
</code></pre>



</details>

<a name="0x1_UpgradeModulePlugin_execute_proposal_entry"></a>

## Function `execute_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_execute_proposal_entry">execute_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_execute_proposal_entry">execute_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, proposal_id: u64) {
    <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_execute_proposal">execute_proposal</a>&lt;DAOT&gt;(&sender, proposal_id);
}
</code></pre>



</details>

<a name="0x1_UpgradeModulePlugin_install_plugin_proposal"></a>

## Function `install_plugin_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT:store&gt;(sender:&signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay:u64){
    <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_create_proposal">InstallPluginProposalPlugin::create_proposal</a>&lt;DAOT, <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">UpgradeModulePlugin</a>&gt;(sender,<a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_required_caps">required_caps</a>(), title, introduction,  extend, action_delay);
}
</code></pre>



</details>

<a name="0x1_UpgradeModulePlugin_install_plugin_proposal_entry"></a>

## Function `install_plugin_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT:store&gt;(sender:signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay:u64){
    <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT&gt;(&sender, title, introduction, extend, action_delay);
}
</code></pre>



</details>
