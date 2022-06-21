
<a name="0x1_DaoRegistry"></a>

# Module `0x1::DaoRegistry`



-  [Resource `DaoRegistryEntry`](#0x1_DaoRegistry_DaoRegistryEntry)
-  [Function `register`](#0x1_DaoRegistry_register)
-  [Function `next_id`](#0x1_DaoRegistry_next_id)
-  [Function `dao_address`](#0x1_DaoRegistry_dao_address)


<pre><code><b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
<b>use</b> <a href="GenesisSignerCapability.md#0x1_GenesisSignerCapability">0x1::GenesisSignerCapability</a>;
</code></pre>



<a name="0x1_DaoRegistry_DaoRegistryEntry"></a>

## Resource `DaoRegistryEntry`



<pre><code><b>struct</b> <a href="DaoRegistry.md#0x1_DaoRegistry_DaoRegistryEntry">DaoRegistryEntry</a>&lt;DaoT&gt; <b>has</b> key
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
<code>dao_address: <b>address</b></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DaoRegistry_register"></a>

## Function `register`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="DaoRegistry.md#0x1_DaoRegistry_register">register</a>&lt;DaoT&gt;(dao_address: <b>address</b>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="DaoRegistry.md#0x1_DaoRegistry_register">register</a>&lt;DaoT&gt;(dao_address: <b>address</b>): u64{
    <b>let</b> genesis_account = <a href="GenesisSignerCapability.md#0x1_GenesisSignerCapability_get_genesis_signer">GenesisSignerCapability::get_genesis_signer</a>();
    <b>let</b> dao_id = <a href="DaoRegistry.md#0x1_DaoRegistry_next_id">next_id</a>();
    <b>move_to</b>(&genesis_account, <a href="DaoRegistry.md#0x1_DaoRegistry_DaoRegistryEntry">DaoRegistryEntry</a>&lt;DaoT&gt;{
        dao_id,
        dao_address,
    });
    dao_id
}
</code></pre>



</details>

<a name="0x1_DaoRegistry_next_id"></a>

## Function `next_id`



<pre><code><b>fun</b> <a href="DaoRegistry.md#0x1_DaoRegistry_next_id">next_id</a>(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DaoRegistry.md#0x1_DaoRegistry_next_id">next_id</a>(): u64{
    //TODO implement id generate
    0
}
</code></pre>



</details>

<a name="0x1_DaoRegistry_dao_address"></a>

## Function `dao_address`



<pre><code><b>public</b> <b>fun</b> <a href="DaoRegistry.md#0x1_DaoRegistry_dao_address">dao_address</a>&lt;DaoT&gt;(): <b>address</b>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DaoRegistry.md#0x1_DaoRegistry_dao_address">dao_address</a>&lt;DaoT&gt;():<b>address</b> <b>acquires</b> <a href="DaoRegistry.md#0x1_DaoRegistry_DaoRegistryEntry">DaoRegistryEntry</a>{
    *&<b>borrow_global</b>&lt;<a href="DaoRegistry.md#0x1_DaoRegistry_DaoRegistryEntry">DaoRegistryEntry</a>&lt;DaoT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()).dao_address
}
</code></pre>



</details>
