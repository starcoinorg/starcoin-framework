
<a name="0x1_SBTVoteStrategy"></a>

# Module `0x1::SBTVoteStrategy`



-  [Constants](#@Constants_0)
-  [Function `get_voting_power`](#0x1_SBTVoteStrategy_get_voting_power)
-  [Function `deserialize_sbt_value_from_bcs_state`](#0x1_SBTVoteStrategy_deserialize_sbt_value_from_bcs_state)


<pre><code><b>use</b> <a href="BCS.md#0x1_BCS">0x1::BCS</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="0x1_SBTVoteStrategy_ERR_BCS_STATE_NTFS_LENGHT_TYPE_INVALID"></a>



<pre><code><b>const</b> <a href="SBTVoteStrategy.md#0x1_SBTVoteStrategy_ERR_BCS_STATE_NTFS_LENGHT_TYPE_INVALID">ERR_BCS_STATE_NTFS_LENGHT_TYPE_INVALID</a>: u64 = 1413;
</code></pre>



<a name="0x1_SBTVoteStrategy_get_voting_power"></a>

## Function `get_voting_power`

deserialize snapshot vote value from state


<pre><code><b>public</b> <b>fun</b> <a href="SBTVoteStrategy.md#0x1_SBTVoteStrategy_get_voting_power">get_voting_power</a>(state: &vector&lt;u8&gt;): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SBTVoteStrategy.md#0x1_SBTVoteStrategy_get_voting_power">get_voting_power</a>(state: &vector&lt;u8&gt;) : u128 {
    <b>let</b> sbt_value = <a href="SBTVoteStrategy.md#0x1_SBTVoteStrategy_deserialize_sbt_value_from_bcs_state">deserialize_sbt_value_from_bcs_state</a>(state);
    sbt_value
}
</code></pre>



</details>

<a name="0x1_SBTVoteStrategy_deserialize_sbt_value_from_bcs_state"></a>

## Function `deserialize_sbt_value_from_bcs_state`

deserialize sbt value from bcs state


<pre><code><b>public</b> <b>fun</b> <a href="SBTVoteStrategy.md#0x1_SBTVoteStrategy_deserialize_sbt_value_from_bcs_state">deserialize_sbt_value_from_bcs_state</a>(state: &vector&lt;u8&gt;): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SBTVoteStrategy.md#0x1_SBTVoteStrategy_deserialize_sbt_value_from_bcs_state">deserialize_sbt_value_from_bcs_state</a>(state: &vector&lt;u8&gt;) : u128{
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(state);
    <b>if</b> (len == 0) {
        <b>return</b> 0u128
    };

    // nfts array length
    <b>let</b> offset = 0;
    <b>let</b> (nfts_len, offset) = <a href="BCS.md#0x1_BCS_deserialize_u8">BCS::deserialize_u8</a>(state, offset);
    // user <b>has</b> no sbt yet
    <b>if</b> (nfts_len == 0) {
        <b>return</b> 0u128
    };

    offset = <a href="BCS.md#0x1_BCS_skip_address">BCS::skip_address</a>(state, offset);
    offset = <a href="BCS.md#0x1_BCS_skip_u64">BCS::skip_u64</a>(state, offset);
    offset = <a href="BCS.md#0x1_BCS_skip_bytes">BCS::skip_bytes</a>(state, offset);
    offset = <a href="BCS.md#0x1_BCS_skip_bytes">BCS::skip_bytes</a>(state, offset);
    offset = <a href="BCS.md#0x1_BCS_skip_bytes">BCS::skip_bytes</a>(state, offset);
    offset = <a href="BCS.md#0x1_BCS_skip_bytes">BCS::skip_bytes</a>(state, offset);
    offset = <a href="BCS.md#0x1_BCS_skip_u64">BCS::skip_u64</a>(state, offset);
    <b>let</b> (value, _offset) = <a href="BCS.md#0x1_BCS_deserialize_u128">BCS::deserialize_u128</a>(state, offset);

    value
}
</code></pre>



</details>
