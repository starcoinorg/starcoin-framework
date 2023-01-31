
<a name="0x1_MintProposalPlugin"></a>

# Module `0x1::MintProposalPlugin`



-  [Struct `MintProposalPlugin`](#0x1_MintProposalPlugin_MintProposalPlugin)
-  [Struct `MintTokenAction`](#0x1_MintProposalPlugin_MintTokenAction)
-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1_MintProposalPlugin_initialize)
-  [Function `required_caps`](#0x1_MintProposalPlugin_required_caps)
-  [Function `delegate_token_mint_cap`](#0x1_MintProposalPlugin_delegate_token_mint_cap)
-  [Function `delegate_token_mint_cap_entry`](#0x1_MintProposalPlugin_delegate_token_mint_cap_entry)
-  [Function `create_mint_proposal`](#0x1_MintProposalPlugin_create_mint_proposal)
-  [Function `create_mint_proposal_entry`](#0x1_MintProposalPlugin_create_mint_proposal_entry)
-  [Function `execute_mint_proposal`](#0x1_MintProposalPlugin_execute_mint_proposal)
-  [Function `execute_mint_proposal_entry`](#0x1_MintProposalPlugin_execute_mint_proposal_entry)
-  [Function `install_plugin_proposal`](#0x1_MintProposalPlugin_install_plugin_proposal)
-  [Function `install_plugin_proposal_entry`](#0x1_MintProposalPlugin_install_plugin_proposal_entry)


<pre><code><b>use</b> <a href="Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace">0x1::DAOPluginMarketplace</a>;
<b>use</b> <a href="DAOSpace.md#0x1_DAOSpace">0x1::DAOSpace</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">0x1::InstallPluginProposalPlugin</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="Token.md#0x1_Token">0x1::Token</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_MintProposalPlugin_MintProposalPlugin"></a>

## Struct `MintProposalPlugin`



<pre><code><b>struct</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin">MintProposalPlugin</a> <b>has</b> drop, store
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

<a name="0x1_MintProposalPlugin_MintTokenAction"></a>

## Struct `MintTokenAction`

MintToken request.


<pre><code><b>struct</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_MintTokenAction">MintTokenAction</a>&lt;TokenT: store&gt; <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>receiver: <b>address</b></code>
</dt>
<dd>
 the receiver of minted tokens.
</dd>
<dt>
<code>amount: u128</code>
</dt>
<dd>
 how many tokens to mint.
</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_MintProposalPlugin_ERR_NOT_RECEIVER"></a>



<pre><code><b>const</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_ERR_NOT_RECEIVER">ERR_NOT_RECEIVER</a>: u64 = 101;
</code></pre>



<a name="0x1_MintProposalPlugin_ERR_NO_MINT_CAP"></a>



<pre><code><b>const</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_ERR_NO_MINT_CAP">ERR_NO_MINT_CAP</a>: u64 = 102;
</code></pre>



<a name="0x1_MintProposalPlugin_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_initialize">initialize</a>(_sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_initialize">initialize</a>(_sender: &signer) {
    <b>let</b> witness = <a href="MintProposalPlugin.md#0x1_MintProposalPlugin">MintProposalPlugin</a>{};

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_register_plugin">DAOPluginMarketplace::register_plugin</a>&lt;<a href="MintProposalPlugin.md#0x1_MintProposalPlugin">MintProposalPlugin</a>&gt;(
        &witness,
        b"<a href="MintProposalPlugin.md#0x1_MintProposalPlugin">0x1::MintProposalPlugin</a>",
        b"The plugin for minting tokens.",
        <a href="Option.md#0x1_Option_none">Option::none</a>(),
    );

    <b>let</b> implement_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();
    <b>let</b> depend_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_publish_plugin_version">DAOPluginMarketplace::publish_plugin_version</a>&lt;<a href="MintProposalPlugin.md#0x1_MintProposalPlugin">MintProposalPlugin</a>&gt;(
        &witness,
        b"v0.1.0",
        *&implement_extpoints,
        *&depend_extpoints,
        b"inner-plugin://mint-proposal-plugin",
    );
}
</code></pre>



</details>

<a name="0x1_MintProposalPlugin_required_caps"></a>

## Function `required_caps`



<pre><code><b>public</b> <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_required_caps">required_caps</a>(): vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_required_caps">required_caps</a>():vector&lt;CapType&gt;{
    <b>let</b> caps = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(<a href="DAOSpace.md#0x1_DAOSpace_proposal_cap_type">DAOSpace::proposal_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_token_mint_cap_type">DAOSpace::token_mint_cap_type</a>());
    caps
}
</code></pre>



</details>

<a name="0x1_MintProposalPlugin_delegate_token_mint_cap"></a>

## Function `delegate_token_mint_cap`



<pre><code><b>public</b> <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_delegate_token_mint_cap">delegate_token_mint_cap</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_delegate_token_mint_cap">delegate_token_mint_cap</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer) {
    <b>let</b> witness = <a href="MintProposalPlugin.md#0x1_MintProposalPlugin">MintProposalPlugin</a> {};
    <b>let</b> mint_cap = <a href="Token.md#0x1_Token_remove_mint_capability">Token::remove_mint_capability</a>&lt;TokenT&gt;(sender);
    <a href="DAOSpace.md#0x1_DAOSpace_delegate_token_mint_cap">DAOSpace::delegate_token_mint_cap</a>&lt;DAOT, <a href="MintProposalPlugin.md#0x1_MintProposalPlugin">MintProposalPlugin</a>, TokenT&gt;(mint_cap, &witness);
}
</code></pre>



</details>

<a name="0x1_MintProposalPlugin_delegate_token_mint_cap_entry"></a>

## Function `delegate_token_mint_cap_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_delegate_token_mint_cap_entry">delegate_token_mint_cap_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_delegate_token_mint_cap_entry">delegate_token_mint_cap_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer) {
    <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_delegate_token_mint_cap">delegate_token_mint_cap</a>&lt;DAOT, TokenT&gt;(&sender);
}
</code></pre>



</details>

<a name="0x1_MintProposalPlugin_create_mint_proposal"></a>

## Function `create_mint_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_create_mint_proposal">create_mint_proposal</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, receiver: <b>address</b>, amount: u128, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_create_mint_proposal">create_mint_proposal</a>&lt;DAOT: store, TokenT:store&gt;(sender: &signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, receiver: <b>address</b>, amount: u128, action_delay: u64){
    <b>let</b> witness = <a href="MintProposalPlugin.md#0x1_MintProposalPlugin">MintProposalPlugin</a>{};
    <b>let</b> cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="MintProposalPlugin.md#0x1_MintProposalPlugin">MintProposalPlugin</a>&gt;(&witness);
    <b>let</b> action = <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_MintTokenAction">MintTokenAction</a>&lt;TokenT&gt;{
        receiver,
        amount,
    };
    <a href="DAOSpace.md#0x1_DAOSpace_create_proposal">DAOSpace::create_proposal</a>(&cap, sender, action, title, introduction, extend, action_delay, <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u8&gt;());
}
</code></pre>



</details>

<a name="0x1_MintProposalPlugin_create_mint_proposal_entry"></a>

## Function `create_mint_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_create_mint_proposal_entry">create_mint_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, receiver: <b>address</b>, amount: u128, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_create_mint_proposal_entry">create_mint_proposal_entry</a>&lt;DAOT: store, TokenT:store&gt;(sender: signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, receiver: <b>address</b>, amount: u128, action_delay: u64){
    <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_create_mint_proposal">create_mint_proposal</a>&lt;DAOT, TokenT&gt;(&sender, extend, title, introduction, receiver, amount, action_delay);
}
</code></pre>



</details>

<a name="0x1_MintProposalPlugin_execute_mint_proposal"></a>

## Function `execute_mint_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_execute_mint_proposal">execute_mint_proposal</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_execute_mint_proposal">execute_mint_proposal</a>&lt;DAOT: store, TokenT:store&gt;(sender: &signer, proposal_id: u64){
    <b>let</b> witness = <a href="MintProposalPlugin.md#0x1_MintProposalPlugin">MintProposalPlugin</a>{};
    <b>let</b> proposal_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="MintProposalPlugin.md#0x1_MintProposalPlugin">MintProposalPlugin</a>&gt;(&witness);
    <b>let</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_MintTokenAction">MintTokenAction</a>&lt;TokenT&gt;{receiver, amount} = <a href="DAOSpace.md#0x1_DAOSpace_execute_proposal">DAOSpace::execute_proposal</a>&lt;DAOT, <a href="MintProposalPlugin.md#0x1_MintProposalPlugin">MintProposalPlugin</a>, <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_MintTokenAction">MintTokenAction</a>&lt;TokenT&gt;&gt;(&proposal_cap, sender, proposal_id);
    <b>assert</b>!(receiver == <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender),<a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="MintProposalPlugin.md#0x1_MintProposalPlugin_ERR_NOT_RECEIVER">ERR_NOT_RECEIVER</a>));
    <b>let</b> tokens = <a href="DAOSpace.md#0x1_DAOSpace_mint_token">DAOSpace::mint_token</a>&lt;DAOT, <a href="MintProposalPlugin.md#0x1_MintProposalPlugin">MintProposalPlugin</a>, TokenT&gt;(amount, &witness);
    <a href="Account.md#0x1_Account_deposit">Account::deposit</a>&lt;TokenT&gt;(receiver, tokens);
}
</code></pre>



</details>

<a name="0x1_MintProposalPlugin_execute_mint_proposal_entry"></a>

## Function `execute_mint_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_execute_mint_proposal_entry">execute_mint_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_execute_mint_proposal_entry">execute_mint_proposal_entry</a>&lt;DAOT: store, TokenT:store&gt;(sender: signer, proposal_id: u64){
    <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_execute_mint_proposal">execute_mint_proposal</a>&lt;DAOT, TokenT&gt;(&sender, proposal_id);
}
</code></pre>



</details>

<a name="0x1_MintProposalPlugin_install_plugin_proposal"></a>

## Function `install_plugin_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT:store&gt;(sender:&signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay:u64){
    <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_create_proposal">InstallPluginProposalPlugin::create_proposal</a>&lt;DAOT, <a href="MintProposalPlugin.md#0x1_MintProposalPlugin">MintProposalPlugin</a>&gt;(sender,<a href="MintProposalPlugin.md#0x1_MintProposalPlugin_required_caps">required_caps</a>(), title, introduction,  extend, action_delay);
}
</code></pre>



</details>

<a name="0x1_MintProposalPlugin_install_plugin_proposal_entry"></a>

## Function `install_plugin_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT:store&gt;(sender:signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay:u64){
    <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT&gt;(&sender, title, introduction, extend, action_delay);
}
</code></pre>



</details>
