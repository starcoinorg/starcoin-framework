
<a name="0x1_StakeToSBTPlugin"></a>

# Module `0x1::StakeToSBTPlugin`



-  [Struct `StakeToSBTPlugin`](#0x1_StakeToSBTPlugin_StakeToSBTPlugin)
-  [Resource `Stake`](#0x1_StakeToSBTPlugin_Stake)
-  [Resource `StakeList`](#0x1_StakeToSBTPlugin_StakeList)
-  [Struct `LockWeightConfig`](#0x1_StakeToSBTPlugin_LockWeightConfig)
-  [Struct `LockWeight`](#0x1_StakeToSBTPlugin_LockWeight)
-  [Struct `AcceptTokenCap`](#0x1_StakeToSBTPlugin_AcceptTokenCap)
-  [Struct `SBTTokenAcceptedEvent`](#0x1_StakeToSBTPlugin_SBTTokenAcceptedEvent)
-  [Struct `SBTWeightChangedEvent`](#0x1_StakeToSBTPlugin_SBTWeightChangedEvent)
-  [Struct `SBTStakeEvent`](#0x1_StakeToSBTPlugin_SBTStakeEvent)
-  [Struct `SBTUnstakeEvent`](#0x1_StakeToSBTPlugin_SBTUnstakeEvent)
-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1_StakeToSBTPlugin_initialize)
-  [Function `required_caps`](#0x1_StakeToSBTPlugin_required_caps)
-  [Function `accept_token_by_dao`](#0x1_StakeToSBTPlugin_accept_token_by_dao)
-  [Function `install_event`](#0x1_StakeToSBTPlugin_install_event)
-  [Function `set_sbt_weight_by_dao`](#0x1_StakeToSBTPlugin_set_sbt_weight_by_dao)
-  [Function `accept_token`](#0x1_StakeToSBTPlugin_accept_token)
-  [Function `stake`](#0x1_StakeToSBTPlugin_stake)
-  [Function `query_stake`](#0x1_StakeToSBTPlugin_query_stake)
-  [Function `query_stake_count`](#0x1_StakeToSBTPlugin_query_stake_count)
-  [Function `unstake_by_id`](#0x1_StakeToSBTPlugin_unstake_by_id)
-  [Function `unstake_all`](#0x1_StakeToSBTPlugin_unstake_all)
-  [Function `unstake_item`](#0x1_StakeToSBTPlugin_unstake_item)
-  [Function `get_sbt_weight`](#0x1_StakeToSBTPlugin_get_sbt_weight)
-  [Function `set_sbt_weight`](#0x1_StakeToSBTPlugin_set_sbt_weight)
-  [Function `find_item`](#0x1_StakeToSBTPlugin_find_item)
-  [Function `compute_token_to_sbt`](#0x1_StakeToSBTPlugin_compute_token_to_sbt)
-  [Function `create_weight_proposal`](#0x1_StakeToSBTPlugin_create_weight_proposal)
-  [Function `create_weight_proposal_entry`](#0x1_StakeToSBTPlugin_create_weight_proposal_entry)
-  [Function `execute_weight_proposal`](#0x1_StakeToSBTPlugin_execute_weight_proposal)
-  [Function `execute_weight_proposal_entry`](#0x1_StakeToSBTPlugin_execute_weight_proposal_entry)
-  [Function `create_token_accept_proposal`](#0x1_StakeToSBTPlugin_create_token_accept_proposal)
-  [Function `create_token_accept_proposal_entry`](#0x1_StakeToSBTPlugin_create_token_accept_proposal_entry)
-  [Function `execute_token_accept_proposal`](#0x1_StakeToSBTPlugin_execute_token_accept_proposal)
-  [Function `execute_token_accept_proposal_entry`](#0x1_StakeToSBTPlugin_execute_token_accept_proposal_entry)
-  [Function `install_plugin_proposal`](#0x1_StakeToSBTPlugin_install_plugin_proposal)
-  [Function `install_plugin_proposal_entry`](#0x1_StakeToSBTPlugin_install_plugin_proposal_entry)
-  [Function `stake_entry`](#0x1_StakeToSBTPlugin_stake_entry)
-  [Function `unstake_item_entry`](#0x1_StakeToSBTPlugin_unstake_item_entry)


<pre><code><b>use</b> <a href="Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace">0x1::DAOPluginMarketplace</a>;
<b>use</b> <a href="DAOSpace.md#0x1_DAOSpace">0x1::DAOSpace</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">0x1::InstallPluginProposalPlugin</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
<b>use</b> <a href="Token.md#0x1_Token">0x1::Token</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_StakeToSBTPlugin_StakeToSBTPlugin"></a>

## Struct `StakeToSBTPlugin`



<pre><code><b>struct</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a> <b>has</b> drop, store
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

<a name="0x1_StakeToSBTPlugin_Stake"></a>

## Resource `Stake`



<pre><code><b>struct</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_Stake">Stake</a>&lt;DAOT, TokenT&gt; <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>token: <a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenT&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>stake_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>lock_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>weight: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>sbt_amount: u128</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_StakeToSBTPlugin_StakeList"></a>

## Resource `StakeList`



<pre><code><b>struct</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a>&lt;DAOT, TokenT&gt; <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>items: vector&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_Stake">StakeToSBTPlugin::Stake</a>&lt;DAOT, TokenT&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>next_id: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_StakeToSBTPlugin_LockWeightConfig"></a>

## Struct `LockWeightConfig`



<pre><code><b>struct</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_LockWeightConfig">LockWeightConfig</a>&lt;DAOT, TokenT&gt; <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>weight_vec: vector&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_LockWeight">StakeToSBTPlugin::LockWeight</a>&lt;DAOT, TokenT&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_StakeToSBTPlugin_LockWeight"></a>

## Struct `LockWeight`



<pre><code><b>struct</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_LockWeight">LockWeight</a>&lt;DAOT, TokenT&gt; <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>lock_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>weight: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_StakeToSBTPlugin_AcceptTokenCap"></a>

## Struct `AcceptTokenCap`



<pre><code><b>struct</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_AcceptTokenCap">AcceptTokenCap</a>&lt;DAOT, TokenT&gt; <b>has</b> drop, store
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

<a name="0x1_StakeToSBTPlugin_SBTTokenAcceptedEvent"></a>

## Struct `SBTTokenAcceptedEvent`

Events


<pre><code><b>struct</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_SBTTokenAcceptedEvent">SBTTokenAcceptedEvent</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>token_code: <a href="Token.md#0x1_Token_TokenCode">Token::TokenCode</a></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_StakeToSBTPlugin_SBTWeightChangedEvent"></a>

## Struct `SBTWeightChangedEvent`



<pre><code><b>struct</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_SBTWeightChangedEvent">SBTWeightChangedEvent</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>token_code: <a href="Token.md#0x1_Token_TokenCode">Token::TokenCode</a></code>
</dt>
<dd>

</dd>
<dt>
<code>lock_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>weight: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_StakeToSBTPlugin_SBTStakeEvent"></a>

## Struct `SBTStakeEvent`



<pre><code><b>struct</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_SBTStakeEvent">SBTStakeEvent</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>stake_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>token_code: <a href="Token.md#0x1_Token_TokenCode">Token::TokenCode</a></code>
</dt>
<dd>

</dd>
<dt>
<code>amount: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>lock_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>weight: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>sbt_amount: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>member: <b>address</b></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_StakeToSBTPlugin_SBTUnstakeEvent"></a>

## Struct `SBTUnstakeEvent`



<pre><code><b>struct</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_SBTUnstakeEvent">SBTUnstakeEvent</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>stake_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>token_code: <a href="Token.md#0x1_Token_TokenCode">Token::TokenCode</a></code>
</dt>
<dd>

</dd>
<dt>
<code>amount: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>lock_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>weight: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>sbt_amount: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>member: <b>address</b></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_StakeToSBTPlugin_ERR_PLUGIN_CONFIG_INIT_REPEATE"></a>



<pre><code><b>const</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_CONFIG_INIT_REPEATE">ERR_PLUGIN_CONFIG_INIT_REPEATE</a>: u64 = 1005;
</code></pre>



<a name="0x1_StakeToSBTPlugin_ERR_PLUGIN_HAS_STAKED"></a>



<pre><code><b>const</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_HAS_STAKED">ERR_PLUGIN_HAS_STAKED</a>: u64 = 1002;
</code></pre>



<a name="0x1_StakeToSBTPlugin_ERR_PLUGIN_ITEM_CANT_FOUND"></a>



<pre><code><b>const</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_ITEM_CANT_FOUND">ERR_PLUGIN_ITEM_CANT_FOUND</a>: u64 = 1006;
</code></pre>



<a name="0x1_StakeToSBTPlugin_ERR_PLUGIN_NOT_STAKE"></a>



<pre><code><b>const</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_NOT_STAKE">ERR_PLUGIN_NOT_STAKE</a>: u64 = 1003;
</code></pre>



<a name="0x1_StakeToSBTPlugin_ERR_PLUGIN_NO_MATCH_LOCKTIME"></a>



<pre><code><b>const</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_NO_MATCH_LOCKTIME">ERR_PLUGIN_NO_MATCH_LOCKTIME</a>: u64 = 1007;
</code></pre>



<a name="0x1_StakeToSBTPlugin_ERR_PLUGIN_STILL_LOCKED"></a>



<pre><code><b>const</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_STILL_LOCKED">ERR_PLUGIN_STILL_LOCKED</a>: u64 = 1004;
</code></pre>



<a name="0x1_StakeToSBTPlugin_ERR_PLUGIN_USER_IS_MEMBER"></a>



<pre><code><b>const</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_USER_IS_MEMBER">ERR_PLUGIN_USER_IS_MEMBER</a>: u64 = 1001;
</code></pre>



<a name="0x1_StakeToSBTPlugin_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_initialize">initialize</a>(_sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_initialize">initialize</a>(_sender: &signer) {
    <b>let</b> witness = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a> {};

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_register_plugin">DAOPluginMarketplace::register_plugin</a>&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(
        &witness,
        b"<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">0x1::StakeToSBTPlugin</a>",
        b"The plugin for stake <b>to</b> SBT",
        <a href="Option.md#0x1_Option_none">Option::none</a>(),
    );

    <b>let</b> implement_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();
    <b>let</b> depend_extpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_publish_plugin_version">DAOPluginMarketplace::publish_plugin_version</a>&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(
        &witness,
        b"v0.1.0",
        *&implement_extpoints,
        *&depend_extpoints,
        b"inner-plugin://stake-<b>to</b>-sbt-plugin",
    );
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_required_caps"></a>

## Function `required_caps`



<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_required_caps">required_caps</a>(): vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_required_caps">required_caps</a>(): vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt; {
    <b>let</b> caps = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(<a href="DAOSpace.md#0x1_DAOSpace_proposal_cap_type">DAOSpace::proposal_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_member_cap_type">DAOSpace::member_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_modify_config_cap_type">DAOSpace::modify_config_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_plugin_event_cap_type">DAOSpace::plugin_event_cap_type</a>());
    caps
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_accept_token_by_dao"></a>

## Function `accept_token_by_dao`

Accept token with token type by given DAO


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_accept_token_by_dao">accept_token_by_dao</a>&lt;DAOT: store, TokenT: store&gt;(_witness: &DAOT)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_accept_token_by_dao">accept_token_by_dao</a>&lt;DAOT: store, TokenT: store&gt;(_witness: &DAOT) {
    <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_install_event">install_event</a>&lt;DAOT&gt;();
    <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_accept_token">accept_token</a>(<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_AcceptTokenCap">AcceptTokenCap</a>&lt;DAOT, TokenT&gt; {});
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_install_event"></a>

## Function `install_event`



<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_install_event">install_event</a>&lt;DAOT: store&gt;()
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_install_event">install_event</a>&lt;DAOT: store&gt;() {
    <b>let</b> witness = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a> {};
    <b>let</b> plugin_event_cap =
        <a href="DAOSpace.md#0x1_DAOSpace_acquire_plugin_event_cap">DAOSpace::acquire_plugin_event_cap</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(&witness);

    <a href="DAOSpace.md#0x1_DAOSpace_init_plugin_event">DAOSpace::init_plugin_event</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_SBTTokenAcceptedEvent">SBTTokenAcceptedEvent</a>&gt;(&plugin_event_cap);
    <a href="DAOSpace.md#0x1_DAOSpace_init_plugin_event">DAOSpace::init_plugin_event</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_SBTWeightChangedEvent">SBTWeightChangedEvent</a>&gt;(&plugin_event_cap);
    <a href="DAOSpace.md#0x1_DAOSpace_init_plugin_event">DAOSpace::init_plugin_event</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_SBTStakeEvent">SBTStakeEvent</a>&gt;(&plugin_event_cap);
    <a href="DAOSpace.md#0x1_DAOSpace_init_plugin_event">DAOSpace::init_plugin_event</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_SBTUnstakeEvent">SBTUnstakeEvent</a>&gt;(&plugin_event_cap);
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_set_sbt_weight_by_dao"></a>

## Function `set_sbt_weight_by_dao`

Set sbt weight by given DAO


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_set_sbt_weight_by_dao">set_sbt_weight_by_dao</a>&lt;DAOT: store, TokenT: store&gt;(_witness: &DAOT, lock_time: u64, weight: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_set_sbt_weight_by_dao">set_sbt_weight_by_dao</a>&lt;DAOT: store, TokenT: store&gt;(
    _witness: &DAOT,
    lock_time: u64,
    weight: u64
) {
    <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_set_sbt_weight">set_sbt_weight</a>&lt;DAOT, TokenT&gt;(lock_time, weight);
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_accept_token"></a>

## Function `accept_token`

Accept token with token type


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_accept_token">accept_token</a>&lt;DAOT: store, TokenT: store&gt;(cap: <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_AcceptTokenCap">StakeToSBTPlugin::AcceptTokenCap</a>&lt;DAOT, TokenT&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_accept_token">accept_token</a>&lt;DAOT: store, TokenT: store&gt;(cap: <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_AcceptTokenCap">AcceptTokenCap</a>&lt;DAOT, TokenT&gt;) {
    <b>let</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_AcceptTokenCap">AcceptTokenCap</a>&lt;DAOT, TokenT&gt; {} = cap;
    <b>assert</b>!(
        !<a href="DAOSpace.md#0x1_DAOSpace_exists_custom_config">DAOSpace::exists_custom_config</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_LockWeightConfig">LockWeightConfig</a>&lt;DAOT, TokenT&gt;&gt;(),
        <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_CONFIG_INIT_REPEATE">ERR_PLUGIN_CONFIG_INIT_REPEATE</a>)
    );

    <b>let</b> witness = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a> {};
    <b>let</b> modify_config_cap =
        <a href="DAOSpace.md#0x1_DAOSpace_acquire_modify_config_cap">DAOSpace::acquire_modify_config_cap</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(&witness);

    <a href="DAOSpace.md#0x1_DAOSpace_set_custom_config">DAOSpace::set_custom_config</a>&lt;
        DAOT,
        <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>,
        <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_LockWeightConfig">LockWeightConfig</a>&lt;DAOT, TokenT&gt;
    &gt;(&<b>mut</b> modify_config_cap, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_LockWeightConfig">LockWeightConfig</a>&lt;DAOT, TokenT&gt; {
        weight_vec: <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_LockWeight">LockWeight</a>&lt;DAOT, TokenT&gt;&gt;()
    });

    <b>let</b> witness = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a> {};
    <b>let</b> plugin_event_cap =
        <a href="DAOSpace.md#0x1_DAOSpace_acquire_plugin_event_cap">DAOSpace::acquire_plugin_event_cap</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(&witness);

    <a href="DAOSpace.md#0x1_DAOSpace_emit_plugin_event">DAOSpace::emit_plugin_event</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_SBTTokenAcceptedEvent">SBTTokenAcceptedEvent</a>&gt;(
        &plugin_event_cap,
        <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_SBTTokenAcceptedEvent">SBTTokenAcceptedEvent</a> {
            dao_id: <a href="DAOSpace.md#0x1_DAOSpace_dao_id">DAOSpace::dao_id</a>(<a href="DAOSpace.md#0x1_DAOSpace_dao_address">DAOSpace::dao_address</a>&lt;DAOT&gt;()),
            token_code: <a href="Token.md#0x1_Token_token_code">Token::token_code</a>&lt;TokenT&gt;(),
        }
    );
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_stake"></a>

## Function `stake`



<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_stake">stake</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer, token: <a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenT&gt;, lock_time: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_stake">stake</a>&lt;DAOT: store, TokenT: store&gt;(
    sender: &signer,
    token: <a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenT&gt;,
    lock_time: u64
): u64 <b>acquires</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a> {
    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    // Increase SBT
    <b>let</b> witness = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a> {};
    <b>let</b> member_cap =
        <a href="DAOSpace.md#0x1_DAOSpace_acquire_member_cap">DAOSpace::acquire_member_cap</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(&witness);

    <b>if</b> (!<a href="DAOSpace.md#0x1_DAOSpace_is_member">DAOSpace::is_member</a>&lt;DAOT&gt;(sender_addr) ) {
        <a href="DAOSpace.md#0x1_DAOSpace_issue_member_offer">DAOSpace::issue_member_offer</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(
            &member_cap,
            sender_addr,
            <a href="Option.md#0x1_Option_none">Option::none</a>&lt;vector&lt;u8&gt;&gt;(),
            <a href="Option.md#0x1_Option_none">Option::none</a>&lt;vector&lt;u8&gt;&gt;(),
            0
        );
        <a href="DAOSpace.md#0x1_DAOSpace_accept_member_offer">DAOSpace::accept_member_offer</a>&lt;DAOT&gt;(sender);
    };

    <b>if</b> (!<b>exists</b>&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a>&lt;DAOT, TokenT&gt;&gt;(sender_addr)) {
        <b>move_to</b>(sender, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a>&lt;DAOT, TokenT&gt; {
            items: <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>(),
            next_id: 0
        });
    };

    <b>let</b> weight_opt = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_get_sbt_weight">get_sbt_weight</a>&lt;DAOT, TokenT&gt;(lock_time);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&weight_opt), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_NO_MATCH_LOCKTIME">ERR_PLUGIN_NO_MATCH_LOCKTIME</a>));

    <b>let</b> weight = <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(weight_opt);
    <b>let</b> sbt_amount = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_compute_token_to_sbt">compute_token_to_sbt</a>(weight, &token);
    <a href="DAOSpace.md#0x1_DAOSpace_increase_member_sbt">DAOSpace::increase_member_sbt</a>(&member_cap, sender_addr, sbt_amount);

    <b>let</b> stake_list = <b>borrow_global_mut</b>&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a>&lt;DAOT, TokenT&gt;&gt;(sender_addr);
    <b>let</b> id = stake_list.next_id + 1;
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(
        &<b>mut</b> stake_list.items,
        <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_Stake">Stake</a>&lt;DAOT, TokenT&gt; {
            id,
            token,
            lock_time,
            stake_time: <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>(),
            weight,
            sbt_amount
        });
    stake_list.next_id = id;

    <b>let</b> witness = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a> {};
    <b>let</b> plugin_event_cap =
        <a href="DAOSpace.md#0x1_DAOSpace_acquire_plugin_event_cap">DAOSpace::acquire_plugin_event_cap</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(&witness);
    <a href="DAOSpace.md#0x1_DAOSpace_emit_plugin_event">DAOSpace::emit_plugin_event</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_SBTStakeEvent">SBTStakeEvent</a>&gt;(
        &plugin_event_cap,
        <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_SBTStakeEvent">SBTStakeEvent</a> {
            dao_id: <a href="DAOSpace.md#0x1_DAOSpace_dao_id">DAOSpace::dao_id</a>(<a href="DAOSpace.md#0x1_DAOSpace_dao_address">DAOSpace::dao_address</a>&lt;DAOT&gt;()),
            stake_id: id,
            token_code: <a href="Token.md#0x1_Token_token_code">Token::token_code</a>&lt;TokenT&gt;(),
            amount: sbt_amount,
            lock_time,
            weight,
            sbt_amount,
            member: sender_addr,
        }
    );
    id
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_query_stake"></a>

## Function `query_stake`



<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_query_stake">query_stake</a>&lt;DAOT: store, TokenT: store&gt;(member: <b>address</b>, id: u64): (u64, u64, u64, u128, u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_query_stake">query_stake</a>&lt;DAOT: store, TokenT: store&gt;(member: <b>address</b>, id: u64)
: (u64, u64, u64, u128, u128) <b>acquires</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a>&lt;DAOT, TokenT&gt;&gt;(member), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_NOT_STAKE">ERR_PLUGIN_NOT_STAKE</a>));
    <b>let</b> stake_list = <b>borrow_global_mut</b>&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a>&lt;DAOT, TokenT&gt;&gt;(member);
    <b>let</b> item_index = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_find_item">find_item</a>(id, &stake_list.items);

    // Check item in item container
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&item_index), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_ITEM_CANT_FOUND">ERR_PLUGIN_ITEM_CANT_FOUND</a>));

    <b>let</b> stake =
        <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&<b>mut</b> stake_list.items, <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(item_index));
    (
        stake.stake_time,
        stake.lock_time,
        stake.weight,
        stake.sbt_amount,
        <a href="Token.md#0x1_Token_value">Token::value</a>(&stake.token),
    )
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_query_stake_count"></a>

## Function `query_stake_count`

Query stake count from stake list


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_query_stake_count">query_stake_count</a>&lt;DAOT: store, TokenT: store&gt;(member: <b>address</b>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_query_stake_count">query_stake_count</a>&lt;DAOT: store, TokenT: store&gt;(member: <b>address</b>): u64 <b>acquires</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a>&lt;DAOT, TokenT&gt;&gt;(member), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_NOT_STAKE">ERR_PLUGIN_NOT_STAKE</a>));
    <b>let</b> stake_list = <b>borrow_global</b>&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a>&lt;DAOT, TokenT&gt;&gt;(member);
    <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&stake_list.items)
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_unstake_by_id"></a>

## Function `unstake_by_id`

Unstake from staking


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_unstake_by_id">unstake_by_id</a>&lt;DAOT: store, TokenT: store&gt;(member: <b>address</b>, id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_unstake_by_id">unstake_by_id</a>&lt;DAOT: store, TokenT: store&gt;(member: <b>address</b>, id: u64) <b>acquires</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a>&lt;DAOT, TokenT&gt;&gt;(member), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_NOT_STAKE">ERR_PLUGIN_NOT_STAKE</a>));
    <b>let</b> stake_list = <b>borrow_global_mut</b>&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a>&lt;DAOT, TokenT&gt;&gt;(member);
    <b>let</b> item_index = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_find_item">find_item</a>(id, &stake_list.items);

    // Check item in item container
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&item_index), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_ITEM_CANT_FOUND">ERR_PLUGIN_ITEM_CANT_FOUND</a>));

    <b>let</b> poped_item =
        <a href="Vector.md#0x1_Vector_remove">Vector::remove</a>(&<b>mut</b> stake_list.items, <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(item_index));

    <b>let</b> amount = <a href="Token.md#0x1_Token_value">Token::value</a>&lt;TokenT&gt;(&poped_item.token);
    <b>let</b> lock_time = poped_item.lock_time;
    <b>let</b> weight = poped_item.weight;
    <b>let</b> sbt_amount = poped_item.sbt_amount;

    <a href="Account.md#0x1_Account_deposit">Account::deposit</a>&lt;TokenT&gt;(member, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_unstake_item">unstake_item</a>(member, poped_item));

    <b>let</b> witness = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a> {};
    <b>let</b> plugin_event_cap =
        <a href="DAOSpace.md#0x1_DAOSpace_acquire_plugin_event_cap">DAOSpace::acquire_plugin_event_cap</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(&witness);
    <a href="DAOSpace.md#0x1_DAOSpace_emit_plugin_event">DAOSpace::emit_plugin_event</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_SBTUnstakeEvent">SBTUnstakeEvent</a>&gt;(
        &plugin_event_cap,
        <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_SBTUnstakeEvent">SBTUnstakeEvent</a> {
            dao_id: <a href="DAOSpace.md#0x1_DAOSpace_dao_id">DAOSpace::dao_id</a>(<a href="DAOSpace.md#0x1_DAOSpace_dao_address">DAOSpace::dao_address</a>&lt;DAOT&gt;()),
            stake_id: id,
            token_code: <a href="Token.md#0x1_Token_token_code">Token::token_code</a>&lt;TokenT&gt;(),
            amount,
            lock_time,
            weight,
            sbt_amount,
            member,
        }
    );
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_unstake_all"></a>

## Function `unstake_all`

Unstake all staking items from member address,
No care whether the user is member or not


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_unstake_all">unstake_all</a>&lt;DAOT: store, TokenT: store&gt;(member: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_unstake_all">unstake_all</a>&lt;DAOT: store, TokenT: store&gt;(member: <b>address</b>) <b>acquires</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a>&lt;DAOT, TokenT&gt;&gt;(member), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_NOT_STAKE">ERR_PLUGIN_NOT_STAKE</a>));
    <b>let</b> stake_list = <b>borrow_global_mut</b>&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a>&lt;DAOT, TokenT&gt;&gt;(member);
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&<b>mut</b> stake_list.items);

    <b>let</b> idx = 0;
    <b>while</b> (idx &lt; len) {
        <b>let</b> item = <a href="Vector.md#0x1_Vector_remove">Vector::remove</a>(&<b>mut</b> stake_list.items, idx);
        <a href="Account.md#0x1_Account_deposit">Account::deposit</a>(member, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_unstake_item">unstake_item</a>&lt;DAOT, TokenT&gt;(member, item));
        idx = idx + 1;
    };
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_unstake_item"></a>

## Function `unstake_item`

Unstake a item from a item object


<pre><code><b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_unstake_item">unstake_item</a>&lt;DAOT: store, TokenT: store&gt;(member: <b>address</b>, item: <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_Stake">StakeToSBTPlugin::Stake</a>&lt;DAOT, TokenT&gt;): <a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_unstake_item">unstake_item</a>&lt;DAOT: store, TokenT: store&gt;(
    member: <b>address</b>,
    item: <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_Stake">Stake</a>&lt;DAOT, TokenT&gt;
): <a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenT&gt; {
    <b>let</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_Stake">Stake</a>&lt;DAOT, TokenT&gt; {
        id: _,
        token,
        lock_time,
        stake_time,
        weight: _,
        sbt_amount,
    } = item;

    <b>assert</b>!((<a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>() - stake_time) &gt; lock_time, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_ERR_PLUGIN_STILL_LOCKED">ERR_PLUGIN_STILL_LOCKED</a>));

    // Deduct the corresponding SBT amount <b>if</b> the signer account is a DAO member <b>while</b> unstake
    <b>if</b> (<a href="DAOSpace.md#0x1_DAOSpace_is_member">DAOSpace::is_member</a>&lt;DAOT&gt;(member)) {
        <b>let</b> witness = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a> {};
        <b>let</b> member_cap =
            <a href="DAOSpace.md#0x1_DAOSpace_acquire_member_cap">DAOSpace::acquire_member_cap</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(&witness);

        // Decrease the SBT using `sbt_amount` which from unwrapped <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_Stake">Stake</a> data,
        // rather than the value that calculate a SBT amount from lock time and weight,
        // because of the `weight` could change at any time
        <a href="DAOSpace.md#0x1_DAOSpace_decrease_member_sbt">DAOSpace::decrease_member_sbt</a>(&member_cap, member, sbt_amount);
    };

    token
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_get_sbt_weight"></a>

## Function `get_sbt_weight`



<pre><code><b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_get_sbt_weight">get_sbt_weight</a>&lt;DAOT: store, TokenT: store&gt;(lock_time: u64): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_get_sbt_weight">get_sbt_weight</a>&lt;DAOT: store, TokenT: store&gt;(lock_time: u64): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt; {
    <b>let</b> config =
        <a href="DAOSpace.md#0x1_DAOSpace_get_custom_config">DAOSpace::get_custom_config</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_LockWeightConfig">LockWeightConfig</a>&lt;DAOT, TokenT&gt;&gt;();
    <b>let</b> c =
        &<b>mut</b> config.weight_vec;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(c);
    <b>let</b> idx = 0;

    <b>while</b> (idx &lt; len) {
        <b>let</b> e = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(c, idx);
        <b>if</b> (e.lock_time == lock_time) {
            <b>return</b> <a href="Option.md#0x1_Option_some">Option::some</a>(e.weight)
        };
        idx = idx + 1;
    };

    <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u64&gt;()
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_set_sbt_weight"></a>

## Function `set_sbt_weight`



<pre><code><b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_set_sbt_weight">set_sbt_weight</a>&lt;DAOT: store, TokenT: store&gt;(lock_time: u64, weight: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_set_sbt_weight">set_sbt_weight</a>&lt;DAOT: store, TokenT: store&gt;(lock_time: u64, weight: u64) {
    <b>let</b> config =
        <a href="DAOSpace.md#0x1_DAOSpace_get_custom_config">DAOSpace::get_custom_config</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_LockWeightConfig">LockWeightConfig</a>&lt;DAOT, TokenT&gt;&gt;();
    <b>let</b> c = &<b>mut</b> config.weight_vec;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(c);
    <b>let</b> idx = 0;
    <b>let</b> new_el = <b>true</b>;
    <b>while</b> (idx &lt; len) {
        <b>let</b> lock_weight = <a href="Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(c, idx);
        <b>if</b> (lock_weight.lock_time == lock_time) {
            lock_weight.weight = weight;
            new_el = <b>false</b>;
            <b>break</b>
        };
        idx = idx + 1;
    };

    <b>if</b> (new_el) {
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(c, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_LockWeight">LockWeight</a>&lt;DAOT, TokenT&gt; {
            lock_time,
            weight,
        });
    };

    <b>let</b> witness = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a> {};
    <b>let</b> modify_config_cap =
        <a href="DAOSpace.md#0x1_DAOSpace_acquire_modify_config_cap">DAOSpace::acquire_modify_config_cap</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(&witness);

    <a href="DAOSpace.md#0x1_DAOSpace_set_custom_config">DAOSpace::set_custom_config</a>&lt;
        DAOT,
        <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>,
        <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_LockWeightConfig">LockWeightConfig</a>&lt;DAOT, TokenT&gt;
    &gt;(&<b>mut</b> modify_config_cap, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_LockWeightConfig">LockWeightConfig</a>&lt;DAOT, TokenT&gt; {
        weight_vec: *&config.weight_vec
    });
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_find_item"></a>

## Function `find_item`



<pre><code><b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_find_item">find_item</a>&lt;DAOT: store, TokenT: store&gt;(id: u64, c: &vector&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_Stake">StakeToSBTPlugin::Stake</a>&lt;DAOT, TokenT&gt;&gt;): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_find_item">find_item</a>&lt;DAOT: store, TokenT: store&gt;(
    id: u64,
    c: &vector&lt;<a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_Stake">Stake</a>&lt;DAOT, TokenT&gt;&gt;
): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt; {
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(c);
    <b>let</b> idx = 0;
    <b>while</b> (idx &lt; len) {
        <b>let</b> item = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(c, idx);
        <b>if</b> (item.id == id) {
            <b>return</b> <a href="Option.md#0x1_Option_some">Option::some</a>(idx)
        };
        idx = idx + 1;
    };
    <a href="Option.md#0x1_Option_none">Option::none</a>()
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_compute_token_to_sbt"></a>

## Function `compute_token_to_sbt`



<pre><code><b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_compute_token_to_sbt">compute_token_to_sbt</a>&lt;TokenT: store&gt;(weight: u64, token: &<a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenT&gt;): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_compute_token_to_sbt">compute_token_to_sbt</a>&lt;TokenT: store&gt;(weight: u64, token: &<a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenT&gt;): u128 {
    (weight <b>as</b> u128) * <a href="Token.md#0x1_Token_value">Token::value</a>&lt;TokenT&gt;(token) / <a href="Token.md#0x1_Token_scaling_factor">Token::scaling_factor</a>&lt;TokenT&gt;()
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_create_weight_proposal"></a>

## Function `create_weight_proposal`

Create proposal that to specific a weight for a locktime


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_create_weight_proposal">create_weight_proposal</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, lock_time: u64, weight: u64, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_create_weight_proposal">create_weight_proposal</a>&lt;DAOT: store, TokenT: store&gt;(
    sender: &signer,
    title:vector&lt;u8&gt;,
    introduction:vector&lt;u8&gt;,
    description: vector&lt;u8&gt;,
    lock_time: u64,
    weight: u64,
    action_delay: u64
) {
    <b>let</b> witness = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a> {};

    <b>let</b> cap =
        <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(&witness);
    <a href="DAOSpace.md#0x1_DAOSpace_create_proposal">DAOSpace::create_proposal</a>(&cap, sender, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_LockWeight">LockWeight</a>&lt;DAOT, TokenT&gt; {
            lock_time,
            weight,
        },
        title,
        introduction,
        description,
        action_delay,
        <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u8&gt;());
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_create_weight_proposal_entry"></a>

## Function `create_weight_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_create_weight_proposal_entry">create_weight_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, lock_time: u64, weight: u64, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_create_weight_proposal_entry">create_weight_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(
    sender: signer,
    title:vector&lt;u8&gt;,
    introduction:vector&lt;u8&gt;,
    description: vector&lt;u8&gt;,
    lock_time: u64,
    weight: u64,
    action_delay: u64
) {
    <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_create_weight_proposal">create_weight_proposal</a>&lt;DAOT, TokenT&gt;(&sender,title, introduction, description, lock_time, weight, action_delay);
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_execute_weight_proposal"></a>

## Function `execute_weight_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_execute_weight_proposal">execute_weight_proposal</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_execute_weight_proposal">execute_weight_proposal</a>&lt;DAOT: store, TokenT: store&gt;(
    sender: &signer,
    proposal_id: u64
) {
    <b>let</b> witness = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a> {};
    <b>let</b> proposal_cap =
        <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(&witness);

    <b>let</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_LockWeight">LockWeight</a>&lt;DAOT, TokenT&gt; {
        lock_time,
        weight
    } = <a href="DAOSpace.md#0x1_DAOSpace_execute_proposal">DAOSpace::execute_proposal</a>&lt;
        DAOT,
        <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>,
        <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_LockWeight">LockWeight</a>&lt;DAOT, TokenT&gt;
    &gt;(&proposal_cap, sender, proposal_id);

    <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_set_sbt_weight">set_sbt_weight</a>&lt;DAOT, TokenT&gt;(lock_time, weight);
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_execute_weight_proposal_entry"></a>

## Function `execute_weight_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_execute_weight_proposal_entry">execute_weight_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_execute_weight_proposal_entry">execute_weight_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(
    sender: signer,
    proposal_id: u64
) {
    <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_execute_weight_proposal">execute_weight_proposal</a>&lt;DAOT, TokenT&gt;(&sender, proposal_id);
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_create_token_accept_proposal"></a>

## Function `create_token_accept_proposal`

Create proposal that to accept a token type, which allow user to convert amount of token to SBT


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_create_token_accept_proposal">create_token_accept_proposal</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_create_token_accept_proposal">create_token_accept_proposal</a>&lt;DAOT: store, TokenT: store&gt;(
    sender: &signer,
    title:vector&lt;u8&gt;,
    introduction:vector&lt;u8&gt;,
    description: vector&lt;u8&gt;,
    action_delay: u64
) {
    <b>let</b> witness = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a> {};

    <b>let</b> cap =
        <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(&witness);
    <a href="DAOSpace.md#0x1_DAOSpace_create_proposal">DAOSpace::create_proposal</a>(
        &cap,
        sender,
        <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_AcceptTokenCap">AcceptTokenCap</a>&lt;DAOT, TokenT&gt; {},
        title,
        introduction,
        description,
        action_delay,
        <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u8&gt;()
    );
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_create_token_accept_proposal_entry"></a>

## Function `create_token_accept_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_create_token_accept_proposal_entry">create_token_accept_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_create_token_accept_proposal_entry">create_token_accept_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(
    sender: signer,
    title:vector&lt;u8&gt;,
    introduction:vector&lt;u8&gt;,
    description: vector&lt;u8&gt;,
    action_delay: u64
) {
    <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_create_token_accept_proposal">create_token_accept_proposal</a>&lt;DAOT, TokenT&gt;(&sender, title, introduction, description, action_delay);
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_execute_token_accept_proposal"></a>

## Function `execute_token_accept_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_execute_token_accept_proposal">execute_token_accept_proposal</a>&lt;DAOT: store, TokenT: store&gt;(sender: &signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_execute_token_accept_proposal">execute_token_accept_proposal</a>&lt;DAOT: store, TokenT: store&gt;(
    sender: &signer,
    proposal_id: u64
) {
    <b>let</b> witness = <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a> {};
    <b>let</b> proposal_cap =
        <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">DAOSpace::acquire_proposal_cap</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(&witness);

    <b>let</b> cap = <a href="DAOSpace.md#0x1_DAOSpace_execute_proposal">DAOSpace::execute_proposal</a>&lt;
        DAOT,
        <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>,
        <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_AcceptTokenCap">AcceptTokenCap</a>&lt;DAOT, TokenT&gt;
    &gt;(&proposal_cap, sender, proposal_id);

    <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_accept_token">accept_token</a>(cap);
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_execute_token_accept_proposal_entry"></a>

## Function `execute_token_accept_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_execute_token_accept_proposal_entry">execute_token_accept_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_execute_token_accept_proposal_entry">execute_token_accept_proposal_entry</a>&lt;DAOT: store, TokenT: store&gt;(
    sender: signer,
    proposal_id: u64
) {
    <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_execute_token_accept_proposal">execute_token_accept_proposal</a>&lt;DAOT, TokenT&gt;(&sender, proposal_id);
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_install_plugin_proposal"></a>

## Function `install_plugin_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT: store&gt;(sender: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT: store&gt;(
    sender: &signer,
    title:vector&lt;u8&gt;,
    introduction:vector&lt;u8&gt;,
    description: vector&lt;u8&gt;,
    action_delay: u64
) {
    <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_create_proposal">InstallPluginProposalPlugin::create_proposal</a>&lt;DAOT, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(
        sender,
        <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_required_caps">required_caps</a>(),
        title,
        introduction,
        description,
        action_delay
    );
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_install_plugin_proposal_entry"></a>

## Function `install_plugin_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT: store&gt;(sender: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_install_plugin_proposal_entry">install_plugin_proposal_entry</a>&lt;DAOT: store&gt;(
    sender: signer,
    title:vector&lt;u8&gt;,
    introduction:vector&lt;u8&gt;,
    description: vector&lt;u8&gt;,
    action_delay: u64
) {
    <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_install_plugin_proposal">install_plugin_proposal</a>&lt;DAOT&gt;(&sender, title, introduction, description, action_delay);
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_stake_entry"></a>

## Function `stake_entry`

Called by script


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_stake_entry">stake_entry</a>&lt;DAOT: store, TokenT: store&gt;(sender: signer, amount: u128, lock_time: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_stake_entry">stake_entry</a>&lt;DAOT: store, TokenT: store&gt;(
    sender: signer,
    amount: u128,
    lock_time: u64
) <b>acquires</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a> {
    <b>let</b> token = <a href="Account.md#0x1_Account_withdraw">Account::withdraw</a>&lt;TokenT&gt;(&sender, amount);
    <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_stake">stake</a>&lt;DAOT, TokenT&gt;(&sender, token, lock_time);
}
</code></pre>



</details>

<a name="0x1_StakeToSBTPlugin_unstake_item_entry"></a>

## Function `unstake_item_entry`

Called by script


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_unstake_item_entry">unstake_item_entry</a>&lt;DAOT: store, TokenT: store&gt;(member: <b>address</b>, id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_unstake_item_entry">unstake_item_entry</a>&lt;DAOT: store, TokenT: store&gt;(
    member: <b>address</b>,
    id: u64
) <b>acquires</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_StakeList">StakeList</a> {
    <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_unstake_by_id">unstake_by_id</a>&lt;DAOT, TokenT&gt;(member, id);
}
</code></pre>



</details>
