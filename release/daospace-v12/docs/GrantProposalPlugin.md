
<a name="0x1_GrantProposalPlugin"></a>

# Module `0x1::GrantProposalPlugin`



-  [Struct `GrantProposalPlugin`](#0x1_GrantProposalPlugin_GrantProposalPlugin)
-  [Struct `GrantCreateAction`](#0x1_GrantProposalPlugin_GrantCreateAction)
-  [Struct `GrantConfigAction`](#0x1_GrantProposalPlugin_GrantConfigAction)
-  [Struct `GrantRevokeAction`](#0x1_GrantProposalPlugin_GrantRevokeAction)
-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1_GrantProposalPlugin_initialize)
-  [Function `required_caps`](#0x1_GrantProposalPlugin_required_caps)
-  [Function `create_grant_proposal`](#0x1_GrantProposalPlugin_create_grant_proposal)
-  [Function `create_grant_proposal_entry`](#0x1_GrantProposalPlugin_create_grant_proposal_entry)
-  [Function `execute_grant_proposal`](#0x1_GrantProposalPlugin_execute_grant_proposal)
-  [Function `execute_grant_proposal_entry`](#0x1_GrantProposalPlugin_execute_grant_proposal_entry)
-  [Function `create_grant_revoke_proposal`](#0x1_GrantProposalPlugin_create_grant_revoke_proposal)
-  [Function `create_grant_revoke_proposal_entry`](#0x1_GrantProposalPlugin_create_grant_revoke_proposal_entry)
-  [Function `execute_grant_revoke_proposal`](#0x1_GrantProposalPlugin_execute_grant_revoke_proposal)
-  [Function `execute_grant_revoke_proposal_entry`](#0x1_GrantProposalPlugin_execute_grant_revoke_proposal_entry)
-  [Function `install_plugin_proposal`](#0x1_GrantProposalPlugin_install_plugin_proposal)
-  [Function `install_plugin_proposal_entry`](#0x1_GrantProposalPlugin_install_plugin_proposal_entry)


<pre><code><b>use</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace">0x1::DAOPluginMarketplace</a>;
<b>use</b> <a href="DAOSpace.md#0x1_DAOSpace">0x1::DAOSpace</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">0x1::InstallPluginProposalPlugin</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_GrantProposalPlugin_GrantProposalPlugin"></a>

## Struct `GrantProposalPlugin`



<pre><code><b>struct</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a> <b>has</b> drop, store
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

<a name="0x1_GrantProposalPlugin_GrantCreateAction"></a>

## Struct `GrantCreateAction`



<pre><code><b>struct</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_GrantCreateAction">GrantCreateAction</a>&lt;TokenT: store&gt; <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>grantee: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>total: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>start_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>period: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GrantProposalPlugin_GrantConfigAction"></a>

## Struct `GrantConfigAction`



<pre><code><b>struct</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_GrantConfigAction">GrantConfigAction</a>&lt;TokenT: store&gt; <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>old_grantee: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>new_grantee: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>total: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>start_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>period: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GrantProposalPlugin_GrantRevokeAction"></a>

## Struct `GrantRevokeAction`



<pre><code><b>struct</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_GrantRevokeAction">GrantRevokeAction</a>&lt;TokenT: store&gt; <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>grantee: <b>address</b></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_GrantProposalPlugin_ERR_GRANTTREASURY_WITHDRAW_NOT_GRANTEE"></a>



<pre><code><b>const</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_ERR_GRANTTREASURY_WITHDRAW_NOT_GRANTEE">ERR_GRANTTREASURY_WITHDRAW_NOT_GRANTEE</a>: u64 = 101;
</code></pre>



<a name="0x1_GrantProposalPlugin_ERR_GRANTTREASURY_WITHDRAW_TOO_MORE"></a>



<pre><code><b>const</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_ERR_GRANTTREASURY_WITHDRAW_TOO_MORE">ERR_GRANTTREASURY_WITHDRAW_TOO_MORE</a>: u64 = 102;
</code></pre>



<a name="0x1_GrantProposalPlugin_ERR_SENDER_NOT_SAME"></a>



<pre><code><b>const</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_ERR_SENDER_NOT_SAME">ERR_SENDER_NOT_SAME</a>: u64 = 103;
</code></pre>



<a name="0x1_GrantProposalPlugin_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_initialize">initialize</a>(_sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_initialize">initialize</a>(_sender: &signer) {
    <b>let</b> witness = <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>{};

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_register_plugin">DAOPluginMarketplace::register_plugin</a>&lt;<a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>&gt;(
        &witness,
        b"<a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">0x1::GrantProposalPlugin</a>",
        b"The plugin for grant proposal",
        <a href="Option.md#0x1_Option_none">Option::none</a>(),
    );

    <b>let</b> implement_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();
    <b>let</b> depend_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_publish_plugin_version">DAOPluginMarketplace::publish_plugin_version</a>&lt;<a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>&gt;(
        &witness,
        b"v0.1.0",
        *&implement_extpoints,
        *&depend_extpoints,
        b"inner-plugin://grant-proposal-plugin",
    );
}
</code></pre>



</details>

<a name="0x1_GrantProposalPlugin_required_caps"></a>

## Function `required_caps`



<pre><code><b>public</b> <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_required_caps">required_caps</a>(): vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_required_caps">required_caps</a>():vector&lt;CapType&gt;{
    <b>let</b> caps = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(<a href="DAOSpace.md#0x1_DAOSpace_proposal_cap_type">DAOSpace::proposal_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_grant_cap_type">DAOSpace::grant_cap_type</a>());
    caps
}
</code></pre>



</details>

<a name="0x1_GrantProposalPlugin_create_grant_proposal"></a>

## Function `create_grant_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_create_grant_proposal">create_grant_proposal</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, grantee: <b>address</b>, total: u128, start_time: u64, period: u64, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_create_grant_proposal">create_grant_proposal</a>&lt;DAOT: store, TokenT:store&gt;(sender: &signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;,grantee: <b>address</b>, total: u128, start_time:u64, period: u64, action_delay:u64){
    <b>let</b> witness = <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>{};
    <b>let</b> cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>&gt;(&witness);
    <b>let</b> action = <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_GrantCreateAction">GrantCreateAction</a>&lt;TokenT&gt;{
        grantee:grantee,
        total:total,
        start_time:start_time,
        period:period
    };
    <a href="DAOSpace.md#0x1_DAOSpace_create_proposal">DAOSpace::create_proposal</a>(&cap, sender, action, title, introduction, extend, action_delay, <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u8&gt;());
}
</code></pre>



</details>

<a name="0x1_GrantProposalPlugin_create_grant_proposal_entry"></a>

## Function `create_grant_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_create_grant_proposal_entry">create_grant_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, grantee: <b>address</b>, total: u128, start_time: u64, period: u64, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_create_grant_proposal_entry">create_grant_proposal_entry</a>&lt;DAOT: store, TokenT:store&gt;(sender: signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;,grantee: <b>address</b>, total: u128, start_time:u64, period: u64, action_delay:u64){
    <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_create_grant_proposal">create_grant_proposal</a>&lt;DAOT, TokenT&gt;(&sender, title, introduction, extend, grantee, total, start_time, period, action_delay);
}
</code></pre>



</details>

<a name="0x1_GrantProposalPlugin_execute_grant_proposal"></a>

## Function `execute_grant_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_execute_grant_proposal">execute_grant_proposal</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_execute_grant_proposal">execute_grant_proposal</a>&lt;DAOT: store, TokenT:store&gt;(sender: &signer, proposal_id: u64){
    <b>let</b> witness = <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>{};
    <b>let</b> proposal_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>&gt;(&witness);
    <b>let</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_GrantCreateAction">GrantCreateAction</a>{grantee, total, start_time, period} = <a href="DAOSpace.md#0x1_DAOSpace_execute_proposal">DAOSpace::execute_proposal</a>&lt;DAOT, <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>, <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_GrantCreateAction">GrantCreateAction</a>&lt;TokenT&gt;&gt;(&proposal_cap, sender, proposal_id);
    <b>assert</b>!(grantee == <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender),<a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_ERR_SENDER_NOT_SAME">ERR_SENDER_NOT_SAME</a>));
    <b>let</b> grant_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_grant_cap">DAOSpace::acquire_grant_cap</a>&lt;DAOT, <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>&gt;(&witness);
    <a href="DAOSpace.md#0x1_DAOSpace_grant_offer">DAOSpace::grant_offer</a>&lt;DAOT, <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>, TokenT&gt;(&grant_cap, <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender), total, start_time, period);
}
</code></pre>



</details>

<a name="0x1_GrantProposalPlugin_execute_grant_proposal_entry"></a>

## Function `execute_grant_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_execute_grant_proposal_entry">execute_grant_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_execute_grant_proposal_entry">execute_grant_proposal_entry</a>&lt;DAOT: store, TokenT:store&gt;(sender: signer, proposal_id: u64){
    <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_execute_grant_proposal">execute_grant_proposal</a>&lt;DAOT, TokenT&gt;(&sender, proposal_id);
}
</code></pre>



</details>

<a name="0x1_GrantProposalPlugin_create_grant_revoke_proposal"></a>

## Function `create_grant_revoke_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_create_grant_revoke_proposal">create_grant_revoke_proposal</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, grantee: <b>address</b>, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_create_grant_revoke_proposal">create_grant_revoke_proposal</a>&lt;DAOT: store, TokenT:store&gt;(sender: &signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, grantee:<b>address</b>, action_delay:u64){
    <b>let</b> witness = <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>{};
    <b>let</b> cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>&gt;(&witness);
    <b>let</b> action = <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_GrantRevokeAction">GrantRevokeAction</a>&lt;TokenT&gt;{ grantee };
    <a href="DAOSpace.md#0x1_DAOSpace_create_proposal">DAOSpace::create_proposal</a>(&cap, sender, action, title, introduction, extend, action_delay, <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u8&gt;());
}
</code></pre>



</details>

<a name="0x1_GrantProposalPlugin_create_grant_revoke_proposal_entry"></a>

## Function `create_grant_revoke_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_create_grant_revoke_proposal_entry">create_grant_revoke_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, grantee: <b>address</b>, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_create_grant_revoke_proposal_entry">create_grant_revoke_proposal_entry</a>&lt;DAOT: store, TokenT:store&gt;(sender: signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, grantee:<b>address</b>, action_delay:u64){
    <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_create_grant_revoke_proposal">create_grant_revoke_proposal</a>&lt;DAOT, TokenT&gt;(&sender, title, introduction, extend, grantee, action_delay);
}
</code></pre>



</details>

<a name="0x1_GrantProposalPlugin_execute_grant_revoke_proposal"></a>

## Function `execute_grant_revoke_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_execute_grant_revoke_proposal">execute_grant_revoke_proposal</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_execute_grant_revoke_proposal">execute_grant_revoke_proposal</a>&lt;DAOT: store, TokenT:store&gt;(sender: &signer, proposal_id: u64){
    <b>let</b> witness = <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>{};
    <b>let</b> proposal_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>&gt;(&witness);
    <b>let</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_GrantRevokeAction">GrantRevokeAction</a>{ grantee } = <a href="DAOSpace.md#0x1_DAOSpace_execute_proposal">DAOSpace::execute_proposal</a>&lt;DAOT, <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>, <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_GrantRevokeAction">GrantRevokeAction</a>&lt;TokenT&gt;&gt;(&proposal_cap, sender, proposal_id);
    <b>let</b> grant_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_grant_cap">DAOSpace::acquire_grant_cap</a>&lt;DAOT, <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>&gt;(&witness);
    <a href="DAOSpace.md#0x1_DAOSpace_grant_revoke">DAOSpace::grant_revoke</a>&lt;DAOT, <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>, TokenT&gt;(&grant_cap , grantee);
}
</code></pre>



</details>

<a name="0x1_GrantProposalPlugin_execute_grant_revoke_proposal_entry"></a>

## Function `execute_grant_revoke_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_execute_grant_revoke_proposal_entry">execute_grant_revoke_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_execute_grant_revoke_proposal_entry">execute_grant_revoke_proposal_entry</a>&lt;DAOT: store, TokenT:store&gt;(sender: signer, proposal_id: u64){
    <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_execute_grant_revoke_proposal">execute_grant_revoke_proposal</a>&lt;DAOT, TokenT&gt;(&sender, proposal_id);
}
</code></pre>



</details>

<a name="0x1_GrantProposalPlugin_install_plugin_proposal"></a>

## Function `install_plugin_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT:store&gt;(sender: &signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay:u64){
    <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_create_proposal">InstallPluginProposalPlugin::create_proposal</a>&lt;DAOT, <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">GrantProposalPlugin</a>&gt;(sender, <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_required_caps">required_caps</a>(), title, introduction, extend, action_delay);
}
</code></pre>



</details>

<a name="0x1_GrantProposalPlugin_install_plugin_proposal_entry"></a>

## Function `install_plugin_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT: store&gt;(sender:signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay:u64){
    <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT&gt;(&sender, title, introduction, extend, action_delay);
}
</code></pre>



</details>
