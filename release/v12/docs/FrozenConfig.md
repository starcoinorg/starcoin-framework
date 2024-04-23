
<a name="0x1_FrozenConfig"></a>

# Module `0x1::FrozenConfig`

The module provide configuration for frozen configuration.


-  [Struct `FrozenConfig`](#0x1_FrozenConfig_FrozenConfig)
-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1_FrozenConfig_initialize)
-  [Function `set_account_list`](#0x1_FrozenConfig_set_account_list)
-  [Function `set_global_frozen`](#0x1_FrozenConfig_set_global_frozen)
-  [Function `get_frozen_config`](#0x1_FrozenConfig_get_frozen_config)
-  [Function `get_frozen_account_list`](#0x1_FrozenConfig_get_frozen_account_list)
-  [Function `get_frozen_global`](#0x1_FrozenConfig_get_frozen_global)
-  [Module Specification](#@Module_Specification_1)


<pre><code><b>use</b> <a href="ACL.md#0x1_ACL">0x1::ACL</a>;
<b>use</b> <a href="Config.md#0x1_Config">0x1::Config</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
</code></pre>



<a name="0x1_FrozenConfig_FrozenConfig"></a>

## Struct `FrozenConfig`



<pre><code><b>struct</b> <a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>frozen_global_txn: bool</code>
</dt>
<dd>

</dd>
<dt>
<code>frozen_account_list: <a href="ACL.md#0x1_ACL_ACL">ACL::ACL</a></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_FrozenConfig_ERR_CONFIG_NOT_EXISTS"></a>



<pre><code><b>const</b> <a href="FrozenConfig.md#0x1_FrozenConfig_ERR_CONFIG_NOT_EXISTS">ERR_CONFIG_NOT_EXISTS</a>: u64 = 101;
</code></pre>



<a name="0x1_FrozenConfig_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfig.md#0x1_FrozenConfig_initialize">initialize</a>(sender: &signer, frozen_account_list: <a href="ACL.md#0x1_ACL_ACL">ACL::ACL</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfig.md#0x1_FrozenConfig_initialize">initialize</a>(sender: &signer, frozen_account_list: <a href="ACL.md#0x1_ACL_ACL">ACL::ACL</a>) {
    <a href="Config.md#0x1_Config_publish_new_config">Config::publish_new_config</a>&lt;<a href="FrozenConfig.md#0x1_FrozenConfig_FrozenConfig">Self::FrozenConfig</a>&gt;(
        sender,
        <a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a> {
            frozen_global_txn: <b>false</b>,
            frozen_account_list,
        }
    );
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<a href="Timestamp.md#0x1_Timestamp_is_genesis">Timestamp::is_genesis</a>();
<b>aborts_if</b> <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account) != <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>();
<b>aborts_if</b> <b>exists</b>&lt;<a href="Config.md#0x1_Config_Config">Config::Config</a>&lt;<a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a>&gt;&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account));
<b>include</b> <a href="Config.md#0x1_Config_PublishNewConfigAbortsIf">Config::PublishNewConfigAbortsIf</a>&lt;<a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a>&gt;;
<b>include</b> <a href="Config.md#0x1_Config_PublishNewConfigEnsures">Config::PublishNewConfigEnsures</a>&lt;<a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a>&gt;;
</code></pre>



</details>

<a name="0x1_FrozenConfig_set_account_list"></a>

## Function `set_account_list`



<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfig.md#0x1_FrozenConfig_set_account_list">set_account_list</a>(sender: &signer, frozen_account_list: <a href="ACL.md#0x1_ACL_ACL">ACL::ACL</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfig.md#0x1_FrozenConfig_set_account_list">set_account_list</a>(sender: &signer, frozen_account_list: <a href="ACL.md#0x1_ACL_ACL">ACL::ACL</a>) {
    <b>let</b> addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>assert</b>!(
        <a href="Config.md#0x1_Config_config_exist_by_address">Config::config_exist_by_address</a>&lt;<a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a>&gt;(addr),
        <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="FrozenConfig.md#0x1_FrozenConfig_ERR_CONFIG_NOT_EXISTS">ERR_CONFIG_NOT_EXISTS</a>)
    );

    <b>let</b> config= <a href="Config.md#0x1_Config_get_by_address">Config::get_by_address</a>&lt;<a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a>&gt;(addr);
    <a href="Config.md#0x1_Config_set">Config::set</a>&lt;<a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a>&gt;(
        sender,
        <a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a> {
            frozen_global_txn: config.frozen_global_txn,
            frozen_account_list,
        }
    );
}
</code></pre>



</details>

<a name="0x1_FrozenConfig_set_global_frozen"></a>

## Function `set_global_frozen`



<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfig.md#0x1_FrozenConfig_set_global_frozen">set_global_frozen</a>(sender: &signer, frozen: bool)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfig.md#0x1_FrozenConfig_set_global_frozen">set_global_frozen</a>(sender: &signer, frozen: bool) {
    <b>let</b> addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>assert</b>!(
        <a href="Config.md#0x1_Config_config_exist_by_address">Config::config_exist_by_address</a>&lt;<a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a>&gt;(addr),
        <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="FrozenConfig.md#0x1_FrozenConfig_ERR_CONFIG_NOT_EXISTS">ERR_CONFIG_NOT_EXISTS</a>)
    );

    <b>let</b> config = <a href="Config.md#0x1_Config_get_by_address">Config::get_by_address</a>&lt;<a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a>&gt;(addr);
    <a href="Config.md#0x1_Config_set">Config::set</a>&lt;<a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a>&gt;(
        sender,
        <a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a> {
            frozen_global_txn: frozen,
            frozen_account_list: config.frozen_account_list,
        }
    );
}
</code></pre>



</details>

<a name="0x1_FrozenConfig_get_frozen_config"></a>

## Function `get_frozen_config`

Get frozen configuration.


<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_config">get_frozen_config</a>(account: <b>address</b>): <a href="FrozenConfig.md#0x1_FrozenConfig_FrozenConfig">FrozenConfig::FrozenConfig</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_config">get_frozen_config</a>(account: <b>address</b>): <a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a> {
    <a href="Config.md#0x1_Config_get_by_address">Config::get_by_address</a>&lt;<a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a>&gt;(account)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>include</b> <a href="FrozenConfig.md#0x1_FrozenConfig_GetfrozenConfigAbortsIf">GetfrozenConfigAbortsIf</a>;
</code></pre>




<a name="0x1_FrozenConfig_GetfrozenConfigAbortsIf"></a>


<pre><code><b>schema</b> <a href="FrozenConfig.md#0x1_FrozenConfig_GetfrozenConfigAbortsIf">GetfrozenConfigAbortsIf</a> {
    <b>aborts_if</b> !<b>exists</b>&lt;<a href="Config.md#0x1_Config_Config">Config::Config</a>&lt;<a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a>&gt;&gt;(account);
}
</code></pre>



</details>

<a name="0x1_FrozenConfig_get_frozen_account_list"></a>

## Function `get_frozen_account_list`



<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">get_frozen_account_list</a>(account: <b>address</b>): <a href="ACL.md#0x1_ACL_ACL">ACL::ACL</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_account_list">get_frozen_account_list</a>(account: <b>address</b>): <a href="ACL.md#0x1_ACL_ACL">ACL::ACL</a> {
    <b>let</b> config = <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_config">get_frozen_config</a>(account);
    config.frozen_account_list
}
</code></pre>



</details>

<a name="0x1_FrozenConfig_get_frozen_global"></a>

## Function `get_frozen_global`

Get global frozen


<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_global">get_frozen_global</a>(account: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_global">get_frozen_global</a>(account: <b>address</b>): bool {
    <b>let</b> config = <a href="FrozenConfig.md#0x1_FrozenConfig_get_frozen_config">get_frozen_config</a>(account);
    config.frozen_global_txn
}
</code></pre>



</details>

<a name="@Module_Specification_1"></a>

## Module Specification



<pre><code><b>pragma</b> verify = <b>false</b>;
<b>pragma</b> aborts_if_is_strict = <b>true</b>;
</code></pre>





<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Config.md#0x1_Config_Config">Config::Config</a>&lt;<a href="FrozenConfig.md#0x1_FrozenConfig">FrozenConfig</a>&gt;&gt;(account);
</code></pre>
