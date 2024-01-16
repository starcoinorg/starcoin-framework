
<a name="0x1_FlexiDagConfig"></a>

# Module `0x1::FlexiDagConfig`



-  [Struct `FlexiDagConfig`](#0x1_FlexiDagConfig_FlexiDagConfig)
-  [Function `new_flexidag_config`](#0x1_FlexiDagConfig_new_flexidag_config)
-  [Function `initialize`](#0x1_FlexiDagConfig_initialize)
-  [Function `effective_height`](#0x1_FlexiDagConfig_effective_height)
-  [Module Specification](#@Module_Specification_0)


<pre><code><b>use</b> <a href="Config.md#0x1_Config">0x1::Config</a>;
<b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
</code></pre>



<a name="0x1_FlexiDagConfig_FlexiDagConfig"></a>

## Struct `FlexiDagConfig`

The struct to hold all config data needed for Flexidag.


<pre><code><b>struct</b> <a href="FlexiDagConfig.md#0x1_FlexiDagConfig">FlexiDagConfig</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>effective_height: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_FlexiDagConfig_new_flexidag_config"></a>

## Function `new_flexidag_config`

Create a new configuration for flexidag, mainly used in DAO.


<pre><code><b>public</b> <b>fun</b> <a href="FlexiDagConfig.md#0x1_FlexiDagConfig_new_flexidag_config">new_flexidag_config</a>(effective_height: u64): <a href="FlexiDagConfig.md#0x1_FlexiDagConfig_FlexiDagConfig">FlexiDagConfig::FlexiDagConfig</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="FlexiDagConfig.md#0x1_FlexiDagConfig_new_flexidag_config">new_flexidag_config</a>(effective_height: u64): <a href="FlexiDagConfig.md#0x1_FlexiDagConfig">FlexiDagConfig</a> {
    <a href="FlexiDagConfig.md#0x1_FlexiDagConfig">FlexiDagConfig</a> {
        effective_height,
    }
}
</code></pre>



</details>

<a name="0x1_FlexiDagConfig_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="FlexiDagConfig.md#0x1_FlexiDagConfig_initialize">initialize</a>(account: &signer, effective_height: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="FlexiDagConfig.md#0x1_FlexiDagConfig_initialize">initialize</a>(account: &signer, effective_height: u64) {
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(account);
    <b>if</b> (!<a href="Config.md#0x1_Config_config_exist_by_address">Config::config_exist_by_address</a>&lt;<a href="FlexiDagConfig.md#0x1_FlexiDagConfig">FlexiDagConfig</a>&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account))) {
        <a href="Config.md#0x1_Config_publish_new_config">Config::publish_new_config</a>&lt;<a href="FlexiDagConfig.md#0x1_FlexiDagConfig">FlexiDagConfig</a>&gt;(account, <a href="FlexiDagConfig.md#0x1_FlexiDagConfig_new_flexidag_config">new_flexidag_config</a>(effective_height))
    }
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account) != <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>();
<b>ensures</b> <b>exists</b>&lt;<a href="Config.md#0x1_Config_Config">Config::Config</a>&lt;<a href="FlexiDagConfig.md#0x1_FlexiDagConfig">FlexiDagConfig</a>&gt;&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account));
<b>ensures</b>
    <b>exists</b>&lt;<a href="Config.md#0x1_Config_ModifyConfigCapabilityHolder">Config::ModifyConfigCapabilityHolder</a>&lt;<a href="FlexiDagConfig.md#0x1_FlexiDagConfig">FlexiDagConfig</a>&gt;&gt;(
        <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account),
    );
</code></pre>



</details>

<a name="0x1_FlexiDagConfig_effective_height"></a>

## Function `effective_height`



<pre><code><b>public</b> <b>fun</b> <a href="FlexiDagConfig.md#0x1_FlexiDagConfig_effective_height">effective_height</a>(account: <b>address</b>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="FlexiDagConfig.md#0x1_FlexiDagConfig_effective_height">effective_height</a>(account: <b>address</b>): u64 {
    <b>let</b> flexi_dag_config = <a href="Config.md#0x1_Config_get_by_address">Config::get_by_address</a>&lt;<a href="FlexiDagConfig.md#0x1_FlexiDagConfig">FlexiDagConfig</a>&gt;(account);
    flexi_dag_config.effective_height
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>include</b> <a href="Config.md#0x1_Config_AbortsIfConfigNotExist">Config::AbortsIfConfigNotExist</a>&lt;<a href="FlexiDagConfig.md#0x1_FlexiDagConfig">FlexiDagConfig</a>&gt; { addr: account };
</code></pre>



</details>

<a name="@Module_Specification_0"></a>

## Module Specification



<pre><code><b>pragma</b> verify = <b>false</b>;
<b>pragma</b> aborts_if_is_strict;
</code></pre>
