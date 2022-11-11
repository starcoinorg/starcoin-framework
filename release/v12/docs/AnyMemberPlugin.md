
<a name="0x1_AnyMemberPlugin"></a>

# Module `0x1::AnyMemberPlugin`

This plugin let every can join the DAO, and auto get 1 sbt.


-  [Struct `AnyMemberPlugin`](#0x1_AnyMemberPlugin_AnyMemberPlugin)
-  [Function `required_caps`](#0x1_AnyMemberPlugin_required_caps)
-  [Function `initialize`](#0x1_AnyMemberPlugin_initialize)
-  [Function `join`](#0x1_AnyMemberPlugin_join)
-  [Function `join_entry`](#0x1_AnyMemberPlugin_join_entry)
-  [Function `install_plugin_proposal`](#0x1_AnyMemberPlugin_install_plugin_proposal)
-  [Function `install_plugin_proposal_entry`](#0x1_AnyMemberPlugin_install_plugin_proposal_entry)


<pre><code><b>use</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace">0x1::DAOPluginMarketplace</a>;
<b>use</b> <a href="DAOSpace.md#0x1_DAOSpace">0x1::DAOSpace</a>;
<b>use</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">0x1::InstallPluginProposalPlugin</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_AnyMemberPlugin_AnyMemberPlugin"></a>

## Struct `AnyMemberPlugin`



<pre><code><b>struct</b> <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin">AnyMemberPlugin</a> <b>has</b> drop, store
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

<a name="0x1_AnyMemberPlugin_required_caps"></a>

## Function `required_caps`



<pre><code><b>public</b> <b>fun</b> <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_required_caps">required_caps</a>(): vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_required_caps">required_caps</a>():vector&lt;CapType&gt;{
    <b>let</b> caps = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(<a href="DAOSpace.md#0x1_DAOSpace_member_cap_type">DAOSpace::member_cap_type</a>());
    caps
}
</code></pre>



</details>

<a name="0x1_AnyMemberPlugin_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_initialize">initialize</a>(_sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_initialize">initialize</a>(_sender: &signer) {
    <b>let</b> witness = <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin">AnyMemberPlugin</a>{};

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_register_plugin">DAOPluginMarketplace::register_plugin</a>&lt;<a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin">AnyMemberPlugin</a>&gt;(
        &witness,
        b"<a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin">0x1::AnyMemberPlugin</a>",
        b"The member plugin that allow all member <b>to</b> do join.",
        <a href="Option.md#0x1_Option_none">Option::none</a>(),
    );

    <b>let</b> implement_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();
    <b>let</b> depend_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_publish_plugin_version">DAOPluginMarketplace::publish_plugin_version</a>&lt;<a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin">AnyMemberPlugin</a>&gt;(
        &witness,
        b"v0.1.0",
        *&implement_extpoints,
        *&depend_extpoints,
        b"inner-plugin://any-member-plugin",
    );
}
</code></pre>



</details>

<a name="0x1_AnyMemberPlugin_join"></a>

## Function `join`



<pre><code><b>public</b> <b>fun</b> <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_join">join</a>&lt;DAOT: store&gt;(sender: &signer, image_data: vector&lt;u8&gt;, image_url: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_join">join</a>&lt;DAOT: store&gt;(sender: &signer, image_data:vector&lt;u8&gt;, image_url:vector&lt;u8&gt;){
    <b>let</b> witness = <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin">AnyMemberPlugin</a>{};
    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>if</b> (<a href="DAOSpace.md#0x1_DAOSpace_is_member">DAOSpace::is_member</a>&lt;DAOT&gt;(sender_addr) ) {
        <b>return</b>
    };
    <b>let</b> member_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_member_cap">DAOSpace::acquire_member_cap</a>&lt;DAOT, <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin">AnyMemberPlugin</a>&gt;(&witness);
    <b>let</b> op_image_data = <b>if</b>(<a href="Vector.md#0x1_Vector_is_empty">Vector::is_empty</a>(&image_data)){
        <a href="Option.md#0x1_Option_none">Option::none</a>&lt;vector&lt;u8&gt;&gt;()
    }<b>else</b>{
        <a href="Option.md#0x1_Option_some">Option::some</a>(image_data)
    };
    <b>let</b> op_image_url = <b>if</b>(<a href="Vector.md#0x1_Vector_is_empty">Vector::is_empty</a>(&image_url)){
        <a href="Option.md#0x1_Option_none">Option::none</a>&lt;vector&lt;u8&gt;&gt;()
    }<b>else</b>{
        <a href="Option.md#0x1_Option_some">Option::some</a>(image_url)
    };

    <a href="DAOSpace.md#0x1_DAOSpace_issue_member_offer">DAOSpace::issue_member_offer</a>&lt;DAOT, <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin">AnyMemberPlugin</a>&gt;(&member_cap, sender_addr,  op_image_data, op_image_url, 1);
    <a href="DAOSpace.md#0x1_DAOSpace_accept_member_offer">DAOSpace::accept_member_offer</a>&lt;DAOT&gt;(sender);
}
</code></pre>



</details>

<a name="0x1_AnyMemberPlugin_join_entry"></a>

## Function `join_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_join_entry">join_entry</a>&lt;DAOT: store&gt;(sender: signer, image_data: vector&lt;u8&gt;, image_url: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_join_entry">join_entry</a>&lt;DAOT: store&gt;(sender: signer, image_data:vector&lt;u8&gt;, image_url:vector&lt;u8&gt;){
    <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_join">join</a>&lt;DAOT&gt;(&sender, image_data, image_url);
}
</code></pre>



</details>

<a name="0x1_AnyMemberPlugin_install_plugin_proposal"></a>

## Function `install_plugin_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT:store&gt;(sender:&signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay:u64){
    <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_create_proposal">InstallPluginProposalPlugin::create_proposal</a>&lt;DAOT, <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin">AnyMemberPlugin</a>&gt;(sender, <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_required_caps">required_caps</a>(), title, introduction, extend, action_delay);
}
</code></pre>



</details>

<a name="0x1_AnyMemberPlugin_install_plugin_proposal_entry"></a>

## Function `install_plugin_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT:store&gt;(sender:signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay:u64){
    <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT&gt;(&sender, title, introduction, extend, action_delay);
}
</code></pre>



</details>
