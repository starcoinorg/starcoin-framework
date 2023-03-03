
<a name="0x1_MemberProposalPlugin"></a>

# Module `0x1::MemberProposalPlugin`



-  [Struct `MemberProposalPlugin`](#0x1_MemberProposalPlugin_MemberProposalPlugin)
-  [Struct `MemberJoinAction`](#0x1_MemberProposalPlugin_MemberJoinAction)
-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1_MemberProposalPlugin_initialize)
-  [Function `required_caps`](#0x1_MemberProposalPlugin_required_caps)
-  [Function `create_proposal`](#0x1_MemberProposalPlugin_create_proposal)
-  [Function `create_proposal_entry`](#0x1_MemberProposalPlugin_create_proposal_entry)
-  [Function `execute_proposal`](#0x1_MemberProposalPlugin_execute_proposal)
-  [Function `execute_proposal_entry`](#0x1_MemberProposalPlugin_execute_proposal_entry)
-  [Function `install_plugin_proposal`](#0x1_MemberProposalPlugin_install_plugin_proposal)
-  [Function `install_plugin_proposal_entry`](#0x1_MemberProposalPlugin_install_plugin_proposal_entry)


<pre><code><b>use</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace">0x1::DAOPluginMarketplace</a>;
<b>use</b> <a href="DAOSpace.md#0x1_DAOSpace">0x1::DAOSpace</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">0x1::InstallPluginProposalPlugin</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_MemberProposalPlugin_MemberProposalPlugin"></a>

## Struct `MemberProposalPlugin`



<pre><code><b>struct</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a> <b>has</b> drop, store
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

<a name="0x1_MemberProposalPlugin_MemberJoinAction"></a>

## Struct `MemberJoinAction`



<pre><code><b>struct</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_MemberJoinAction">MemberJoinAction</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>member: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>init_sbt: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>image_url: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>image_data: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_MemberProposalPlugin_ERR_MEMBER_EXIST"></a>



<pre><code><b>const</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_ERR_MEMBER_EXIST">ERR_MEMBER_EXIST</a>: u64 = 101;
</code></pre>



<a name="0x1_MemberProposalPlugin_ERR_MEMBER_OFFER_EXIST"></a>



<pre><code><b>const</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_ERR_MEMBER_OFFER_EXIST">ERR_MEMBER_OFFER_EXIST</a>: u64 = 102;
</code></pre>



<a name="0x1_MemberProposalPlugin_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_initialize">initialize</a>(_sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_initialize">initialize</a>(_sender: &signer) {
    <b>let</b> witness = <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>{};

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_register_plugin">DAOPluginMarketplace::register_plugin</a>&lt;<a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>&gt;(
        &witness,
        b"<a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">0x1::MemberProposalPlugin</a>",
        b"The plugin for member proposal",
        <a href="Option.md#0x1_Option_none">Option::none</a>(),
    );

    <b>let</b> implement_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();
    <b>let</b> depend_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_publish_plugin_version">DAOPluginMarketplace::publish_plugin_version</a>&lt;<a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>&gt;(
        &witness,
        b"v0.1.0",
        *&implement_extpoints,
        *&depend_extpoints,
        b"inner-plugin://member-proposal-plugin",
    );
}
</code></pre>



</details>

<a name="0x1_MemberProposalPlugin_required_caps"></a>

## Function `required_caps`



<pre><code><b>public</b> <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_required_caps">required_caps</a>(): vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_required_caps">required_caps</a>():vector&lt;CapType&gt;{
    <b>let</b> caps = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(<a href="DAOSpace.md#0x1_DAOSpace_member_cap_type">DAOSpace::member_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_proposal_cap_type">DAOSpace::proposal_cap_type</a>());
    caps
}
</code></pre>



</details>

<a name="0x1_MemberProposalPlugin_create_proposal"></a>

## Function `create_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_create_proposal">create_proposal</a>&lt;DAOT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, member: <b>address</b>, image_data: vector&lt;u8&gt;, image_url: vector&lt;u8&gt;, init_sbt: u128, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_create_proposal">create_proposal</a>&lt;DAOT: store&gt;(sender: &signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, description: vector&lt;u8&gt;, member: <b>address</b>, image_data:vector&lt;u8&gt;, image_url:vector&lt;u8&gt;, init_sbt: u128, action_delay: u64){
    <b>let</b> witness = <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>{};
    <b>let</b> cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>&gt;(&witness);
    <b>let</b> action = <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_MemberJoinAction">MemberJoinAction</a>{
        member,
        init_sbt,
        image_data,
        image_url
    };
    <b>assert</b>!(!<a href="DAOSpace.md#0x1_DAOSpace_is_exist_member_offer">DAOSpace::is_exist_member_offer</a>&lt;DAOT&gt;(member), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_ERR_MEMBER_OFFER_EXIST">ERR_MEMBER_OFFER_EXIST</a>));
    <b>assert</b>!(!<a href="DAOSpace.md#0x1_DAOSpace_is_member">DAOSpace::is_member</a>&lt;DAOT&gt;(member), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_ERR_MEMBER_EXIST">ERR_MEMBER_EXIST</a>));
    <a href="DAOSpace.md#0x1_DAOSpace_create_proposal">DAOSpace::create_proposal</a>(&cap, sender, action, title, introduction, description, action_delay);
}
</code></pre>



</details>

<a name="0x1_MemberProposalPlugin_create_proposal_entry"></a>

## Function `create_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_create_proposal_entry">create_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, member: <b>address</b>, image_data: vector&lt;u8&gt;, image_url: vector&lt;u8&gt;, init_sbt: u128, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_create_proposal_entry">create_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, description: vector&lt;u8&gt;, member: <b>address</b>, image_data:vector&lt;u8&gt;, image_url:vector&lt;u8&gt;, init_sbt: u128, action_delay: u64){
    <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_create_proposal">create_proposal</a>&lt;DAOT&gt;(&sender, title, introduction, description, member, image_data, image_url, init_sbt, action_delay);
}
</code></pre>



</details>

<a name="0x1_MemberProposalPlugin_execute_proposal"></a>

## Function `execute_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_execute_proposal">execute_proposal</a>&lt;DAOT: store&gt;(sender: &signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_execute_proposal">execute_proposal</a>&lt;DAOT: store&gt;(sender: &signer, proposal_id: u64){
    <b>let</b> witness = <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>{};
    <b>let</b> proposal_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>&gt;(&witness);
    <b>let</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_MemberJoinAction">MemberJoinAction</a>{member, init_sbt, image_data, image_url} = <a href="DAOSpace.md#0x1_DAOSpace_execute_proposal">DAOSpace::execute_proposal</a>&lt;DAOT, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_MemberJoinAction">MemberJoinAction</a>&gt;(&proposal_cap, sender, proposal_id);
    <b>let</b> member_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_member_cap">DAOSpace::acquire_member_cap</a>&lt;DAOT, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>&gt;(&witness);
    <a href="DAOSpace.md#0x1_DAOSpace_member_offer">DAOSpace::member_offer</a>(&member_cap, member, <a href="Option.md#0x1_Option_some">Option::some</a>(image_data), <a href="Option.md#0x1_Option_some">Option::some</a>(image_url) , init_sbt);
}
</code></pre>



</details>

<a name="0x1_MemberProposalPlugin_execute_proposal_entry"></a>

## Function `execute_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_execute_proposal_entry">execute_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_execute_proposal_entry">execute_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, proposal_id: u64){
    <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_execute_proposal">execute_proposal</a>&lt;DAOT&gt;(&sender, proposal_id);
}
</code></pre>



</details>

<a name="0x1_MemberProposalPlugin_install_plugin_proposal"></a>

## Function `install_plugin_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT:store&gt;(sender:&signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, description: vector&lt;u8&gt;,action_delay:u64){
    <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_create_proposal">InstallPluginProposalPlugin::create_proposal</a>&lt;DAOT, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_MemberJoinAction">MemberJoinAction</a>&gt;(sender, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_required_caps">required_caps</a>(), title, introduction, description, action_delay);
}
</code></pre>



</details>

<a name="0x1_MemberProposalPlugin_install_plugin_proposal_entry"></a>

## Function `install_plugin_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT:store&gt;(sender:signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, description: vector&lt;u8&gt;, action_delay:u64){
    <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT&gt;(&sender, title, introduction, description, action_delay);
}
</code></pre>



</details>
