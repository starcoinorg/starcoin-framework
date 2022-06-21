
<a name="0x1_VoteUtil"></a>

# Module `0x1::VoteUtil`



-  [Function `get_vote_weight_from_sbt_snapshot`](#0x1_VoteUtil_get_vote_weight_from_sbt_snapshot)


<pre><code></code></pre>



<a name="0x1_VoteUtil_get_vote_weight_from_sbt_snapshot"></a>

## Function `get_vote_weight_from_sbt_snapshot`



<pre><code><b>public</b> <b>fun</b> <a href="VoteUtil.md#0x1_VoteUtil_get_vote_weight_from_sbt_snapshot">get_vote_weight_from_sbt_snapshot</a>(_sender: <b>address</b>, _state_root: vector&lt;u8&gt;, _sbt_proof: vector&lt;u8&gt;): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="VoteUtil.md#0x1_VoteUtil_get_vote_weight_from_sbt_snapshot">get_vote_weight_from_sbt_snapshot</a>(_sender: <b>address</b>, _state_root: vector&lt;u8&gt;, _sbt_proof:vector&lt;u8&gt;) : u128{
    //verify sbt_proof <b>with</b> state_root
    //read sbt value from sbt proof's leaf
    0u128
}
</code></pre>



</details>
