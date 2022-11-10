
<a name="0x1_TreasuryPlugin"></a>

# Module `0x1::TreasuryPlugin`



-  [Struct `TreasuryPlugin`](#0x1_TreasuryPlugin_TreasuryPlugin)
-  [Resource `WithdrawCapabilityHolder`](#0x1_TreasuryPlugin_WithdrawCapabilityHolder)
-  [Struct `QuorumScale`](#0x1_TreasuryPlugin_QuorumScale)
-  [Struct `WithdrawTokenAction`](#0x1_TreasuryPlugin_WithdrawTokenAction)
-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1_TreasuryPlugin_initialize)
-  [Function `delegate_capability`](#0x1_TreasuryPlugin_delegate_capability)
-  [Function `required_caps`](#0x1_TreasuryPlugin_required_caps)
-  [Function `withdraw_limitation`](#0x1_TreasuryPlugin_withdraw_limitation)
-  [Function `create_withdraw_proposal`](#0x1_TreasuryPlugin_create_withdraw_proposal)
-  [Function `create_withdraw_proposal_entry`](#0x1_TreasuryPlugin_create_withdraw_proposal_entry)
-  [Function `execute_withdraw_proposal`](#0x1_TreasuryPlugin_execute_withdraw_proposal)
-  [Function `execute_withdraw_proposal_entry`](#0x1_TreasuryPlugin_execute_withdraw_proposal_entry)
-  [Function `withdraw_for_block_reward`](#0x1_TreasuryPlugin_withdraw_for_block_reward)
-  [Function `set_scale_factor`](#0x1_TreasuryPlugin_set_scale_factor)
-  [Function `set_scale_factor_inner`](#0x1_TreasuryPlugin_set_scale_factor_inner)


<pre><code><b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
<b>use</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace">0x1::DAOPluginMarketplace</a>;
<b>use</b> <a href="DAOSpace.md#0x1_DAOSpace">0x1::DAOSpace</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="Token.md#0x1_Token">0x1::Token</a>;
<b>use</b> <a href="Treasury.md#0x1_Treasury">0x1::Treasury</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_TreasuryPlugin_TreasuryPlugin"></a>

## Struct `TreasuryPlugin`



<pre><code><b>struct</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin">TreasuryPlugin</a> <b>has</b> drop, store
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

<a name="0x1_TreasuryPlugin_WithdrawCapabilityHolder"></a>

## Resource `WithdrawCapabilityHolder`

A wrapper of Token MintCapability.


<pre><code><b>struct</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_WithdrawCapabilityHolder">WithdrawCapabilityHolder</a>&lt;TokenT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="Treasury.md#0x1_Treasury_WithdrawCapability">Treasury::WithdrawCapability</a>&lt;TokenT&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_TreasuryPlugin_QuorumScale"></a>

## Struct `QuorumScale`

Scale up quorum_votes for withdraw proposal.
<code>scale</code> must be in [0, 100].
The final quorum_votes = (1.0 + scale / 100) * base_quorum_votes


<pre><code><b>struct</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_QuorumScale">QuorumScale</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>scale: u8</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_TreasuryPlugin_WithdrawTokenAction"></a>

## Struct `WithdrawTokenAction`

WithdrawToken request.


<pre><code><b>struct</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_WithdrawTokenAction">WithdrawTokenAction</a>&lt;TokenT&gt; <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>receiver: <b>address</b></code>
</dt>
<dd>
 the receiver of withdraw tokens.
</dd>
<dt>
<code>amount: u128</code>
</dt>
<dd>
 how many tokens to mint.
</dd>
<dt>
<code>period: u64</code>
</dt>
<dd>
 How long in milliseconds does it take for the token to be released
</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_TreasuryPlugin_ERR_NOT_AUTHORIZED"></a>



<pre><code><b>const</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_ERR_NOT_AUTHORIZED">ERR_NOT_AUTHORIZED</a>: u64 = 101;
</code></pre>



<a name="0x1_TreasuryPlugin_ERR_CAPABILITY_NOT_EXIST"></a>



<pre><code><b>const</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_ERR_CAPABILITY_NOT_EXIST">ERR_CAPABILITY_NOT_EXIST</a>: u64 = 104;
</code></pre>



<a name="0x1_TreasuryPlugin_ERR_INVALID_SCALE_FACTOR"></a>



<pre><code><b>const</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_ERR_INVALID_SCALE_FACTOR">ERR_INVALID_SCALE_FACTOR</a>: u64 = 105;
</code></pre>



<a name="0x1_TreasuryPlugin_ERR_NOT_RECEIVER"></a>

Only receiver can execute treasury withdraw proposal


<pre><code><b>const</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_ERR_NOT_RECEIVER">ERR_NOT_RECEIVER</a>: u64 = 102;
</code></pre>



<a name="0x1_TreasuryPlugin_ERR_TOO_MANY_WITHDRAW_AMOUNT"></a>

The withdraw amount of propose is too many.


<pre><code><b>const</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_ERR_TOO_MANY_WITHDRAW_AMOUNT">ERR_TOO_MANY_WITHDRAW_AMOUNT</a>: u64 = 103;
</code></pre>



<a name="0x1_TreasuryPlugin_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_initialize">initialize</a>(_sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_initialize">initialize</a>(_sender: &signer) {
    <b>let</b> witness = <a href="TreasuryPlugin.md#0x1_TreasuryPlugin">TreasuryPlugin</a> {};

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_register_plugin">DAOPluginMarketplace::register_plugin</a>&lt;<a href="TreasuryPlugin.md#0x1_TreasuryPlugin">TreasuryPlugin</a>&gt;(
        &witness,
        b"<a href="TreasuryPlugin.md#0x1_TreasuryPlugin">0x1::TreasuryPlugin</a>",
        b"The plugin for withdraw token from <a href="Treasury.md#0x1_Treasury">Treasury</a>.",
        <a href="Option.md#0x1_Option_none">Option::none</a>(),
    );

    <b>let</b> implement_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();
    <b>let</b> depend_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_publish_plugin_version">DAOPluginMarketplace::publish_plugin_version</a>&lt;<a href="TreasuryPlugin.md#0x1_TreasuryPlugin">TreasuryPlugin</a>&gt;(
        &witness,
        b"v0.1.0",
        *&implement_extpoints,
        *&depend_extpoints,
        b"inner-plugin://treasury-plugin",
    );
}
</code></pre>



</details>

<a name="0x1_TreasuryPlugin_delegate_capability"></a>

## Function `delegate_capability`

Delegate Treasury::WithdrawCapability to DAO
Should be called by token issuer.


<pre><code><b>public</b> <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_delegate_capability">delegate_capability</a>&lt;TokenT: store&gt;(sender: &signer, cap: <a href="Treasury.md#0x1_Treasury_WithdrawCapability">Treasury::WithdrawCapability</a>&lt;TokenT&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_delegate_capability">delegate_capability</a>&lt;TokenT: store&gt;(sender: &signer, cap: <a href="Treasury.md#0x1_Treasury_WithdrawCapability">Treasury::WithdrawCapability</a>&lt;TokenT&gt;) {
    <b>let</b> token_issuer = <a href="Token.md#0x1_Token_token_address">Token::token_address</a>&lt;TokenT&gt;();
    <b>assert</b>!(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender) == token_issuer, <a href="Errors.md#0x1_Errors_requires_address">Errors::requires_address</a>(<a href="TreasuryPlugin.md#0x1_TreasuryPlugin_ERR_NOT_AUTHORIZED">ERR_NOT_AUTHORIZED</a>));
    <b>move_to</b>(sender, <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_WithdrawCapabilityHolder">WithdrawCapabilityHolder</a>&lt;TokenT&gt; { cap });
}
</code></pre>



</details>

<a name="0x1_TreasuryPlugin_required_caps"></a>

## Function `required_caps`



<pre><code><b>public</b> <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_required_caps">required_caps</a>(): vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_required_caps">required_caps</a>(): vector&lt;CapType&gt; {
    <b>let</b> caps = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(<a href="DAOSpace.md#0x1_DAOSpace_proposal_cap_type">DAOSpace::proposal_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_modify_config_cap_type">DAOSpace::modify_config_cap_type</a>());
    caps
}
</code></pre>



</details>

<a name="0x1_TreasuryPlugin_withdraw_limitation"></a>

## Function `withdraw_limitation`



<pre><code><b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_withdraw_limitation">withdraw_limitation</a>&lt;DAOT: store, TokenT: store&gt;(): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_withdraw_limitation">withdraw_limitation</a>&lt;DAOT: store, TokenT: store&gt;(): u128 {
    <b>let</b> market_cap = <a href="Token.md#0x1_Token_market_cap">Token::market_cap</a>&lt;TokenT&gt;();
    <b>let</b> balance_in_treasury = <a href="Treasury.md#0x1_Treasury_balance">Treasury::balance</a>&lt;TokenT&gt;();
    <b>let</b> supply = market_cap - balance_in_treasury;
    <b>let</b> rate = <a href="DAOSpace.md#0x1_DAOSpace_voting_quorum_rate">DAOSpace::voting_quorum_rate</a>&lt;DAOT&gt;();
    <b>let</b> rate = (rate <b>as</b> u128);
    supply * rate / 100
}
</code></pre>



</details>

<a name="0x1_TreasuryPlugin_create_withdraw_proposal"></a>

## Function `create_withdraw_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_create_withdraw_proposal">create_withdraw_proposal</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, receiver: <b>address</b>, amount: u128, period: u64, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_create_withdraw_proposal">create_withdraw_proposal</a>&lt;DAOT: store, TokenT: store&gt;(
    sender: &signer,
    title:vector&lt;u8&gt;,
    introduction:vector&lt;u8&gt;,
    description: vector&lt;u8&gt;,
    receiver: <b>address</b>,
    amount: u128,
    period: u64,
    action_delay: u64)
{
    <b>let</b> limit = <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_withdraw_limitation">withdraw_limitation</a>&lt;DAOT, TokenT&gt;();
    <b>assert</b>!(amount &lt;= limit,  <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TreasuryPlugin.md#0x1_TreasuryPlugin_ERR_TOO_MANY_WITHDRAW_AMOUNT">ERR_TOO_MANY_WITHDRAW_AMOUNT</a>));
    <b>let</b> witness = <a href="TreasuryPlugin.md#0x1_TreasuryPlugin">TreasuryPlugin</a> {};
    <b>let</b> cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="TreasuryPlugin.md#0x1_TreasuryPlugin">TreasuryPlugin</a>&gt;(&witness);
    <b>let</b> action = <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_WithdrawTokenAction">WithdrawTokenAction</a>&lt;TokenT&gt; {
        receiver,
        amount,
        period,
    };

    <b>if</b> (!<a href="DAOSpace.md#0x1_DAOSpace_exists_custom_config">DAOSpace::exists_custom_config</a>&lt;DAOT, <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_QuorumScale">QuorumScale</a>&gt;()) {
        <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_set_scale_factor_inner">set_scale_factor_inner</a>&lt;DAOT&gt;(0u8);
    };
    <b>let</b> scale = <a href="DAOSpace.md#0x1_DAOSpace_get_custom_config">DAOSpace::get_custom_config</a>&lt;DAOT, <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_QuorumScale">QuorumScale</a>&gt;().scale;
    <a href="DAOSpace.md#0x1_DAOSpace_create_proposal">DAOSpace::create_proposal</a>(&cap, sender, action, title, introduction, description, action_delay, <a href="Option.md#0x1_Option_some">Option::some</a>(scale));
}
</code></pre>



</details>

<a name="0x1_TreasuryPlugin_create_withdraw_proposal_entry"></a>

## Function `create_withdraw_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_create_withdraw_proposal_entry">create_withdraw_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, receiver: <b>address</b>, amount: u128, period: u64, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_create_withdraw_proposal_entry">create_withdraw_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(
    sender: signer,
    title:vector&lt;u8&gt;,
    introduction:vector&lt;u8&gt;,
    description: vector&lt;u8&gt;,
    receiver: <b>address</b>,
    amount: u128,
    period: u64,
    action_delay: u64)
{
    <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_create_withdraw_proposal">create_withdraw_proposal</a>&lt;DAOT, TokenT&gt;(&sender, title, introduction, description, receiver, amount, period, action_delay);
}
</code></pre>



</details>

<a name="0x1_TreasuryPlugin_execute_withdraw_proposal"></a>

## Function `execute_withdraw_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_execute_withdraw_proposal">execute_withdraw_proposal</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_execute_withdraw_proposal">execute_withdraw_proposal</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer, proposal_id: u64) <b>acquires</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_WithdrawCapabilityHolder">WithdrawCapabilityHolder</a> {
    <b>let</b> witness = <a href="TreasuryPlugin.md#0x1_TreasuryPlugin">TreasuryPlugin</a> {};
    <b>let</b> proposal_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="TreasuryPlugin.md#0x1_TreasuryPlugin">TreasuryPlugin</a>&gt;(&witness);
    <b>let</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_WithdrawTokenAction">WithdrawTokenAction</a>&lt;TokenT&gt; { receiver, amount, period } =
        <a href="DAOSpace.md#0x1_DAOSpace_execute_proposal">DAOSpace::execute_proposal</a>&lt;DAOT, <a href="TreasuryPlugin.md#0x1_TreasuryPlugin">TreasuryPlugin</a>, <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_WithdrawTokenAction">WithdrawTokenAction</a>&lt;TokenT&gt;&gt;(&proposal_cap, sender, proposal_id);
    <b>assert</b>!(receiver == <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="TreasuryPlugin.md#0x1_TreasuryPlugin_ERR_NOT_RECEIVER">ERR_NOT_RECEIVER</a>));
    <b>let</b> token_issuer = <a href="Token.md#0x1_Token_token_address">Token::token_address</a>&lt;TokenT&gt;();
    <b>assert</b>!(<b>exists</b>&lt;<a href="TreasuryPlugin.md#0x1_TreasuryPlugin_WithdrawCapabilityHolder">WithdrawCapabilityHolder</a>&lt;TokenT&gt;&gt;(token_issuer), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="TreasuryPlugin.md#0x1_TreasuryPlugin_ERR_CAPABILITY_NOT_EXIST">ERR_CAPABILITY_NOT_EXIST</a>));
    <b>let</b> cap = <b>borrow_global_mut</b>&lt;<a href="TreasuryPlugin.md#0x1_TreasuryPlugin_WithdrawCapabilityHolder">WithdrawCapabilityHolder</a>&lt;TokenT&gt;&gt;(token_issuer);
    <b>let</b> linear_cap = <a href="Treasury.md#0x1_Treasury_issue_linear_withdraw_capability">Treasury::issue_linear_withdraw_capability</a>&lt;TokenT&gt;(&<b>mut</b> cap.cap, amount, period);
    <a href="Treasury.md#0x1_Treasury_add_linear_withdraw_capability">Treasury::add_linear_withdraw_capability</a>(sender, linear_cap);
}
</code></pre>



</details>

<a name="0x1_TreasuryPlugin_execute_withdraw_proposal_entry"></a>

## Function `execute_withdraw_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_execute_withdraw_proposal_entry">execute_withdraw_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_execute_withdraw_proposal_entry">execute_withdraw_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer, proposal_id: u64) <b>acquires</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_WithdrawCapabilityHolder">WithdrawCapabilityHolder</a> {
    <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_execute_withdraw_proposal">execute_withdraw_proposal</a>&lt;DAOT, TokenT&gt;(&sender, proposal_id);
}
</code></pre>



</details>

<a name="0x1_TreasuryPlugin_withdraw_for_block_reward"></a>

## Function `withdraw_for_block_reward`

Provider a port for get block reward STC from Treasury, only genesis account can invoke this function.
The TreasuryWithdrawCapability is locked in TreasuryWithdrawDaoProposal, and only can withdraw by DAO proposal.
This approach is not graceful, but restricts the operation to genesis accounts only, so there are no security issues either.


<pre><code><b>public</b> <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_withdraw_for_block_reward">withdraw_for_block_reward</a>&lt;TokenT: store&gt;(signer: &signer, reward: u128): <a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_withdraw_for_block_reward">withdraw_for_block_reward</a>&lt;TokenT: store&gt;(signer: &signer, reward: u128): <a href="Token.md#0x1_Token">Token</a>&lt;TokenT&gt;
<b>acquires</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_WithdrawCapabilityHolder">WithdrawCapabilityHolder</a>  {
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(signer);
    <b>let</b> cap = <b>borrow_global_mut</b>&lt;<a href="TreasuryPlugin.md#0x1_TreasuryPlugin_WithdrawCapabilityHolder">WithdrawCapabilityHolder</a>&lt;TokenT&gt;&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(signer));
    <a href="Treasury.md#0x1_Treasury_withdraw_with_capability">Treasury::withdraw_with_capability</a>(&<b>mut</b> cap.cap, reward)
}
</code></pre>



</details>

<a name="0x1_TreasuryPlugin_set_scale_factor"></a>

## Function `set_scale_factor`



<pre><code><b>public</b> <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_set_scale_factor">set_scale_factor</a>&lt;DAOT: store&gt;(scale: u8, _witness: &DAOT)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_set_scale_factor">set_scale_factor</a>&lt;DAOT: store&gt;(scale: u8, _witness: &DAOT) {
    <b>assert</b>!(
        scale &gt;= 0 && scale &lt;= 100,
        <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="TreasuryPlugin.md#0x1_TreasuryPlugin_ERR_INVALID_SCALE_FACTOR">ERR_INVALID_SCALE_FACTOR</a>),
    );
    <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_set_scale_factor_inner">set_scale_factor_inner</a>&lt;DAOT&gt;(scale);
}
</code></pre>



</details>

<a name="0x1_TreasuryPlugin_set_scale_factor_inner"></a>

## Function `set_scale_factor_inner`



<pre><code><b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_set_scale_factor_inner">set_scale_factor_inner</a>&lt;DAOT: store&gt;(scale: u8)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_set_scale_factor_inner">set_scale_factor_inner</a>&lt;DAOT: store&gt;(scale: u8) {
    <b>let</b> plugin = <a href="TreasuryPlugin.md#0x1_TreasuryPlugin">TreasuryPlugin</a> {};
    <b>let</b> cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_modify_config_cap">DAOSpace::acquire_modify_config_cap</a>&lt;DAOT, <a href="TreasuryPlugin.md#0x1_TreasuryPlugin">TreasuryPlugin</a>&gt;(&plugin);
    <a href="DAOSpace.md#0x1_DAOSpace_set_custom_config">DAOSpace::set_custom_config</a>&lt;DAOT, <a href="TreasuryPlugin.md#0x1_TreasuryPlugin">TreasuryPlugin</a>, <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_QuorumScale">QuorumScale</a>&gt;(&<b>mut</b> cap, <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_QuorumScale">QuorumScale</a> { scale });
}
</code></pre>



</details>
