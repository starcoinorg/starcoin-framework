
<a name="0x1_CheckpointScript"></a>

# Module `0x1::CheckpointScript`



-  [Function `latest_state_root`](#0x1_CheckpointScript_latest_state_root)
-  [Function `update_state_root`](#0x1_CheckpointScript_update_state_root)


<pre><code><b>use</b> <a href="Block.md#0x1_Block">0x1::Block</a>;
</code></pre>



<a name="0x1_CheckpointScript_latest_state_root"></a>

## Function `latest_state_root`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="Block.md#0x1_CheckpointScript_latest_state_root">latest_state_root</a>(_account: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="Block.md#0x1_CheckpointScript_latest_state_root">latest_state_root</a>(_account: signer){
    <a href="Block.md#0x1_Block_latest_state_root">Block::latest_state_root</a>();
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_CheckpointScript_update_state_root"></a>

## Function `update_state_root`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="Block.md#0x1_CheckpointScript_update_state_root">update_state_root</a>(_account: signer, header: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="Block.md#0x1_CheckpointScript_update_state_root">update_state_root</a>(_account: signer , header: vector&lt;u8&gt;){
    <a href="Block.md#0x1_Block_update_state_root">Block::update_state_root</a>(header);
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>
