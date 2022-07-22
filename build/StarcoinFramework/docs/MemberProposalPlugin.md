
<a name="0x1_MemberProposalPlugin"></a>

# Module `0x1::MemberProposalPlugin`



-  [Struct `MemberProposalPlugin`](#0x1_MemberProposalPlugin_MemberProposalPlugin)
-  [Struct `MemberJoinAction`](#0x1_MemberProposalPlugin_MemberJoinAction)
-  [Function `required_caps`](#0x1_MemberProposalPlugin_required_caps)
-  [Function `create_proposal`](#0x1_MemberProposalPlugin_create_proposal)
-  [Function `execute_proposal`](#0x1_MemberProposalPlugin_execute_proposal)
-  [Function `install_plugin_proposal`](#0x1_MemberProposalPlugin_install_plugin_proposal)


<pre><code><b>use</b> <a href="DAOSpace.md#0x1_DAOSpace">0x1::DAOSpace</a>;
<b>use</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">0x1::InstallPluginProposalPlugin</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_MemberProposalPlugin_MemberProposalPlugin"></a>

## Struct `MemberProposalPlugin`



<pre><code><b>struct</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a> <b>has</b> drop
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



<pre><code><b>struct</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_MemberJoinAction">MemberJoinAction</a> <b>has</b> store
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
</dl>


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



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_create_proposal">create_proposal</a>&lt;DaoT: store&gt;(sender: signer, member: <b>address</b>, init_sbt: u128, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_create_proposal">create_proposal</a>&lt;DaoT: store&gt;(sender: signer, member: <b>address</b>, init_sbt: u128, action_delay: u64){
    <b>let</b> witness = <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>{};
    <b>let</b> cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DaoT, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>&gt;(&witness);
    <b>let</b> action = <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_MemberJoinAction">MemberJoinAction</a>{
        member,
        init_sbt,
    };
    <a href="DAOSpace.md#0x1_DAOSpace_create_proposal">DAOSpace::create_proposal</a>(&cap, &sender, action, action_delay);
}
</code></pre>



</details>

<a name="0x1_MemberProposalPlugin_execute_proposal"></a>

## Function `execute_proposal`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_execute_proposal">execute_proposal</a>&lt;DaoT: store&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_execute_proposal">execute_proposal</a>&lt;DaoT: store&gt;(sender: signer, proposal_id: u64){
    <b>let</b> witness = <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>{};
    <b>let</b> proposal_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DaoT, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>&gt;(&witness);
    <b>let</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_MemberJoinAction">MemberJoinAction</a>{member, init_sbt} = <a href="DAOSpace.md#0x1_DAOSpace_execute_proposal">DAOSpace::execute_proposal</a>&lt;DaoT, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_MemberJoinAction">MemberJoinAction</a>&gt;(&proposal_cap, &sender, proposal_id);
    <b>let</b> member_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_member_cap">DAOSpace::acquire_member_cap</a>&lt;DaoT, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>&gt;(&witness);
    <a href="DAOSpace.md#0x1_DAOSpace_join_member">DAOSpace::join_member</a>(&member_cap, member, init_sbt);
}
</code></pre>



</details>

<a name="0x1_MemberProposalPlugin_install_plugin_proposal"></a>

## Function `install_plugin_proposal`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DaoT: store&gt;(sender: signer, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DaoT:store&gt;(sender:signer, action_delay:u64){
    <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_create_proposal">InstallPluginProposalPlugin::create_proposal</a>&lt;DaoT, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_MemberJoinAction">MemberJoinAction</a>&gt;(&sender, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_required_caps">required_caps</a>(), action_delay);
}
</code></pre>



</details>
