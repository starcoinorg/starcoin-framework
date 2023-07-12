
<a name="0x1_StarcoinVerifier"></a>

# Module `0x1::StarcoinVerifier`



-  [Struct `AccountState`](#0x1_StarcoinVerifier_AccountState)
-  [Struct `StateProof`](#0x1_StarcoinVerifier_StateProof)
-  [Struct `SparseMerkleProof`](#0x1_StarcoinVerifier_SparseMerkleProof)
-  [Struct `SMTNode`](#0x1_StarcoinVerifier_SMTNode)
-  [Constants](#@Constants_0)
-  [Function `bcs_deserialize_account_state`](#0x1_StarcoinVerifier_bcs_deserialize_account_state)
-  [Function `new_state_proof`](#0x1_StarcoinVerifier_new_state_proof)
-  [Function `new_sparse_merkle_proof`](#0x1_StarcoinVerifier_new_sparse_merkle_proof)
-  [Function `new_smt_node`](#0x1_StarcoinVerifier_new_smt_node)
-  [Function `empty_smt_node`](#0x1_StarcoinVerifier_empty_smt_node)
-  [Function `verify_state_proof`](#0x1_StarcoinVerifier_verify_state_proof)
-  [Function `verify_smp`](#0x1_StarcoinVerifier_verify_smp)
-  [Function `compute_smp_root_by_path_and_node_hash`](#0x1_StarcoinVerifier_compute_smp_root_by_path_and_node_hash)
-  [Function `placeholder`](#0x1_StarcoinVerifier_placeholder)
-  [Function `create_literal_hash`](#0x1_StarcoinVerifier_create_literal_hash)
-  [Function `hash_key`](#0x1_StarcoinVerifier_hash_key)
-  [Function `hash_value`](#0x1_StarcoinVerifier_hash_value)
-  [Function `count_common_prefix`](#0x1_StarcoinVerifier_count_common_prefix)
-  [Function `get_bit_at_from_msb`](#0x1_StarcoinVerifier_get_bit_at_from_msb)


<pre><code><b>use</b> <a href="BCS.md#0x1_BCS">0x1::BCS</a>;
<b>use</b> <a href="Hash.md#0x1_Hash">0x1::Hash</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="StarcoinVerifier.md#0x1_StructuredHash">0x1::StructuredHash</a>;
</code></pre>



<a name="0x1_StarcoinVerifier_AccountState"></a>

## Struct `AccountState`



<pre><code><b>struct</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_AccountState">AccountState</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>storage_roots: vector&lt;<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_StarcoinVerifier_StateProof"></a>

## Struct `StateProof`



<pre><code><b>struct</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_StateProof">StateProof</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>account_proof: <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SparseMerkleProof">StarcoinVerifier::SparseMerkleProof</a></code>
</dt>
<dd>

        * Account state's proof for global state root.

</dd>
<dt>
<code>account_state: vector&lt;u8&gt;</code>
</dt>
<dd>

         * Account state including storage roots.

</dd>
<dt>
<code>proof: <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SparseMerkleProof">StarcoinVerifier::SparseMerkleProof</a></code>
</dt>
<dd>

         * State's proof for account storage root.

</dd>
</dl>


</details>

<a name="0x1_StarcoinVerifier_SparseMerkleProof"></a>

## Struct `SparseMerkleProof`



<pre><code><b>struct</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SparseMerkleProof">SparseMerkleProof</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>siblings: vector&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>leaf: <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SMTNode">StarcoinVerifier::SMTNode</a></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_StarcoinVerifier_SMTNode"></a>

## Struct `SMTNode`



<pre><code><b>struct</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SMTNode">SMTNode</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>hash1: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>hash2: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_StarcoinVerifier_ACCOUNT_STORAGE_INDEX_RESOURCE"></a>



<pre><code><b>const</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_ACCOUNT_STORAGE_INDEX_RESOURCE">ACCOUNT_STORAGE_INDEX_RESOURCE</a>: u64 = 1;
</code></pre>



<a name="0x1_StarcoinVerifier_BLOB_HASH_PREFIX"></a>



<pre><code><b>const</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_BLOB_HASH_PREFIX">BLOB_HASH_PREFIX</a>: vector&lt;u8&gt; = [66, 108, 111, 98];
</code></pre>



<a name="0x1_StarcoinVerifier_DEFAULT_VALUE"></a>



<pre><code><b>const</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_DEFAULT_VALUE">DEFAULT_VALUE</a>: vector&lt;u8&gt; = [];
</code></pre>



<a name="0x1_StarcoinVerifier_ERROR_ACCOUNT_STORAGE_ROOTS"></a>



<pre><code><b>const</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_ERROR_ACCOUNT_STORAGE_ROOTS">ERROR_ACCOUNT_STORAGE_ROOTS</a>: u64 = 101;
</code></pre>



<a name="0x1_StarcoinVerifier_ERROR_LITERAL_HASH_WRONG_LENGTH"></a>



<pre><code><b>const</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_ERROR_LITERAL_HASH_WRONG_LENGTH">ERROR_LITERAL_HASH_WRONG_LENGTH</a>: u64 = 102;
</code></pre>



<a name="0x1_StarcoinVerifier_HASH_LEN_IN_BITS"></a>



<pre><code><b>const</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_HASH_LEN_IN_BITS">HASH_LEN_IN_BITS</a>: u64 = 256;
</code></pre>



<a name="0x1_StarcoinVerifier_SPARSE_MERKLE_INTERNAL_NODE"></a>



<pre><code><b>const</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SPARSE_MERKLE_INTERNAL_NODE">SPARSE_MERKLE_INTERNAL_NODE</a>: vector&lt;u8&gt; = [83, 112, 97, 114, 115, 101, 77, 101, 114, 107, 108, 101, 73, 110, 116, 101, 114, 110, 97, 108, 78, 111, 100, 101];
</code></pre>



<a name="0x1_StarcoinVerifier_SPARSE_MERKLE_LEAF_NODE"></a>



<pre><code><b>const</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SPARSE_MERKLE_LEAF_NODE">SPARSE_MERKLE_LEAF_NODE</a>: vector&lt;u8&gt; = [83, 112, 97, 114, 115, 101, 77, 101, 114, 107, 108, 101, 76, 101, 97, 102, 78, 111, 100, 101];
</code></pre>



<a name="0x1_StarcoinVerifier_SPARSE_MERKLE_PLACEHOLDER_HASH_LITERAL"></a>



<pre><code><b>const</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SPARSE_MERKLE_PLACEHOLDER_HASH_LITERAL">SPARSE_MERKLE_PLACEHOLDER_HASH_LITERAL</a>: vector&lt;u8&gt; = [83, 80, 65, 82, 83, 69, 95, 77, 69, 82, 75, 76, 69, 95, 80, 76, 65, 67, 69, 72, 79, 76, 68, 69, 82, 95, 72, 65, 83, 72];
</code></pre>



<a name="0x1_StarcoinVerifier_bcs_deserialize_account_state"></a>

## Function `bcs_deserialize_account_state`



<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_bcs_deserialize_account_state">bcs_deserialize_account_state</a>(data: &vector&lt;u8&gt;): <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_AccountState">StarcoinVerifier::AccountState</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_bcs_deserialize_account_state">bcs_deserialize_account_state</a>(data: &vector&lt;u8&gt;): <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_AccountState">AccountState</a> {
    <b>let</b> (vec, _) = <a href="BCS.md#0x1_BCS_deserialize_option_bytes_vector">BCS::deserialize_option_bytes_vector</a>(data, 0);
    <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_AccountState">AccountState</a>{
        storage_roots: vec
    }
}
</code></pre>



</details>

<a name="0x1_StarcoinVerifier_new_state_proof"></a>

## Function `new_state_proof`



<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_state_proof">new_state_proof</a>(account_proof: <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SparseMerkleProof">StarcoinVerifier::SparseMerkleProof</a>, account_state: vector&lt;u8&gt;, proof: <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SparseMerkleProof">StarcoinVerifier::SparseMerkleProof</a>): <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_StateProof">StarcoinVerifier::StateProof</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_state_proof">new_state_proof</a>(account_proof: <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SparseMerkleProof">SparseMerkleProof</a>, account_state: vector&lt;u8&gt;, proof: <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SparseMerkleProof">SparseMerkleProof</a>): <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_StateProof">StateProof</a> {
    <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_StateProof">StateProof</a>{
        account_proof,
        account_state,
        proof,
    }
}
</code></pre>



</details>

<a name="0x1_StarcoinVerifier_new_sparse_merkle_proof"></a>

## Function `new_sparse_merkle_proof`



<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_sparse_merkle_proof">new_sparse_merkle_proof</a>(siblings: vector&lt;vector&lt;u8&gt;&gt;, leaf: <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SMTNode">StarcoinVerifier::SMTNode</a>): <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SparseMerkleProof">StarcoinVerifier::SparseMerkleProof</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_sparse_merkle_proof">new_sparse_merkle_proof</a>(siblings: vector&lt;vector&lt;u8&gt;&gt;, leaf: <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SMTNode">SMTNode</a>): <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SparseMerkleProof">SparseMerkleProof</a> {
    <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SparseMerkleProof">SparseMerkleProof</a>{
        siblings,
        leaf,
    }
}
</code></pre>



</details>

<a name="0x1_StarcoinVerifier_new_smt_node"></a>

## Function `new_smt_node`



<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_smt_node">new_smt_node</a>(hash1: vector&lt;u8&gt;, hash2: vector&lt;u8&gt;): <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SMTNode">StarcoinVerifier::SMTNode</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_smt_node">new_smt_node</a>(hash1: vector&lt;u8&gt;, hash2: vector&lt;u8&gt;): <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SMTNode">SMTNode</a> {
    <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SMTNode">SMTNode</a>{
        hash1,
        hash2,
    }
}
</code></pre>



</details>

<a name="0x1_StarcoinVerifier_empty_smt_node"></a>

## Function `empty_smt_node`



<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_empty_smt_node">empty_smt_node</a>(): <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SMTNode">StarcoinVerifier::SMTNode</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_empty_smt_node">empty_smt_node</a>(): <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SMTNode">SMTNode</a> {
    <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SMTNode">SMTNode</a>{
        hash1: <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>(),
        hash2: <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>(),
    }
}
</code></pre>



</details>

<a name="0x1_StarcoinVerifier_verify_state_proof"></a>

## Function `verify_state_proof`



<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_verify_state_proof">verify_state_proof</a>(state_proof: &<a href="StarcoinVerifier.md#0x1_StarcoinVerifier_StateProof">StarcoinVerifier::StateProof</a>, state_root: &vector&lt;u8&gt;, account_address: <b>address</b>, resource_struct_tag: &vector&lt;u8&gt;, state: &vector&lt;u8&gt;): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_verify_state_proof">verify_state_proof</a>(state_proof: &<a href="StarcoinVerifier.md#0x1_StarcoinVerifier_StateProof">StateProof</a>, state_root: &vector&lt;u8&gt;,
                                       account_address: <b>address</b>, resource_struct_tag: &vector&lt;u8&gt;,
                                       state: &vector&lt;u8&gt;): bool {
    <b>let</b> accountState: <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_AccountState">AccountState</a> = <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_bcs_deserialize_account_state">bcs_deserialize_account_state</a>(&state_proof.account_state);
    <b>assert</b>!(<a href="Vector.md#0x1_Vector_length">Vector::length</a>(&accountState.storage_roots) &gt; <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_ACCOUNT_STORAGE_INDEX_RESOURCE">ACCOUNT_STORAGE_INDEX_RESOURCE</a>, <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_ERROR_ACCOUNT_STORAGE_ROOTS">ERROR_ACCOUNT_STORAGE_ROOTS</a>);

    // First, verify state for storage root.
    <b>let</b> storageRoot = <a href="Option.md#0x1_Option_borrow">Option::borrow</a>(<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&accountState.storage_roots, <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_ACCOUNT_STORAGE_INDEX_RESOURCE">ACCOUNT_STORAGE_INDEX_RESOURCE</a>));
    <b>let</b> ok: bool = <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_verify_smp">verify_smp</a>(&state_proof.proof.siblings,
        &state_proof.proof.leaf,
        storageRoot,
        resource_struct_tag, // resource <b>struct</b> tag <a href="BCS.md#0x1_BCS">BCS</a> serialized <b>as</b> key
        state);
    <b>if</b> (!ok) {
        <b>return</b> <b>false</b>
    };

    // Then, verify account state for <b>global</b> state root.
    ok = <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_verify_smp">verify_smp</a>(&state_proof.account_proof.siblings,
        &state_proof.account_proof.leaf,
        state_root,
        &<a href="BCS.md#0x1_BCS_to_bytes">BCS::to_bytes</a>&lt;<b>address</b>&gt;(&account_address), // account <b>address</b> <b>as</b> key
        &state_proof.account_state,
    );
    ok
}
</code></pre>



</details>

<a name="0x1_StarcoinVerifier_verify_smp"></a>

## Function `verify_smp`

Verify sparse merkle proof by key and value.


<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_verify_smp">verify_smp</a>(sibling_nodes: &vector&lt;vector&lt;u8&gt;&gt;, leaf_data: &<a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SMTNode">StarcoinVerifier::SMTNode</a>, expected_root: &vector&lt;u8&gt;, key: &vector&lt;u8&gt;, value: &vector&lt;u8&gt;): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_verify_smp">verify_smp</a>(sibling_nodes: &vector&lt;vector&lt;u8&gt;&gt;, leaf_data: &<a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SMTNode">SMTNode</a>, expected_root: &vector&lt;u8&gt;, key: &vector&lt;u8&gt;, value: &vector&lt;u8&gt;): bool {
    <b>let</b> path = <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_hash_key">hash_key</a>(key);
    <b>let</b> current_hash: vector&lt;u8&gt;;
    <b>if</b> (*value == <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_DEFAULT_VALUE">DEFAULT_VALUE</a>) {
        // Non-membership proof.
        <b>if</b> (<a href="StarcoinVerifier.md#0x1_StarcoinVerifier_empty_smt_node">empty_smt_node</a>() == *leaf_data) {
            current_hash = <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_placeholder">placeholder</a>();
        } <b>else</b> {
            <b>if</b> (*&leaf_data.hash1 == *&path) {
                <b>return</b> <b>false</b>
            };
            <b>if</b> (!(<a href="StarcoinVerifier.md#0x1_StarcoinVerifier_count_common_prefix">count_common_prefix</a>(&leaf_data.hash1, &path) &gt;= <a href="Vector.md#0x1_Vector_length">Vector::length</a>(sibling_nodes))) {
                <b>return</b> <b>false</b>
            };
            current_hash = <a href="StarcoinVerifier.md#0x1_StructuredHash_hash">StructuredHash::hash</a>(<a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SPARSE_MERKLE_LEAF_NODE">SPARSE_MERKLE_LEAF_NODE</a>, leaf_data);
        };
    } <b>else</b> {
        // Membership proof.
        <b>if</b> (<a href="StarcoinVerifier.md#0x1_StarcoinVerifier_empty_smt_node">empty_smt_node</a>() == *leaf_data) {
            <b>return</b> <b>false</b>
        };
        <b>if</b> (*&leaf_data.hash1 != *&path) {
            <b>return</b> <b>false</b>
        };
        <b>let</b> value_hash = <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_hash_value">hash_value</a>(value);
        <b>if</b> (*&leaf_data.hash2 != value_hash) {
            <b>return</b> <b>false</b>
        };
        current_hash = <a href="StarcoinVerifier.md#0x1_StructuredHash_hash">StructuredHash::hash</a>(<a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SPARSE_MERKLE_LEAF_NODE">SPARSE_MERKLE_LEAF_NODE</a>, leaf_data);
    };

    current_hash = <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_compute_smp_root_by_path_and_node_hash">compute_smp_root_by_path_and_node_hash</a>(sibling_nodes, &path, &current_hash);
    current_hash == *expected_root
}
</code></pre>



</details>

<a name="0x1_StarcoinVerifier_compute_smp_root_by_path_and_node_hash"></a>

## Function `compute_smp_root_by_path_and_node_hash`



<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_compute_smp_root_by_path_and_node_hash">compute_smp_root_by_path_and_node_hash</a>(sibling_nodes: &vector&lt;vector&lt;u8&gt;&gt;, path: &vector&lt;u8&gt;, node_hash: &vector&lt;u8&gt;): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_compute_smp_root_by_path_and_node_hash">compute_smp_root_by_path_and_node_hash</a>(sibling_nodes: &vector&lt;vector&lt;u8&gt;&gt;, path: &vector&lt;u8&gt;, node_hash: &vector&lt;u8&gt;): vector&lt;u8&gt; {
    <b>let</b> current_hash = *node_hash;
    <b>let</b> i = 0;
    <b>let</b> proof_length = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(sibling_nodes);
    <b>while</b> (i &lt; proof_length) {
        <b>let</b> sibling = *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(sibling_nodes, i);
        <b>let</b> bit = <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_get_bit_at_from_msb">get_bit_at_from_msb</a>(path, proof_length - i - 1);
        <b>let</b> internal_node = <b>if</b> (bit) {
            <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SMTNode">SMTNode</a>{ hash1: sibling, hash2: current_hash }
        } <b>else</b> {
            <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SMTNode">SMTNode</a>{ hash1: current_hash, hash2: sibling }
        };
        current_hash = <a href="StarcoinVerifier.md#0x1_StructuredHash_hash">StructuredHash::hash</a>(<a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SPARSE_MERKLE_INTERNAL_NODE">SPARSE_MERKLE_INTERNAL_NODE</a>, &internal_node);
        i = i + 1;
    };
    current_hash
}
</code></pre>



</details>

<a name="0x1_StarcoinVerifier_placeholder"></a>

## Function `placeholder`



<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_placeholder">placeholder</a>(): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_placeholder">placeholder</a>(): vector&lt;u8&gt; {
    <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_create_literal_hash">create_literal_hash</a>(&<a href="StarcoinVerifier.md#0x1_StarcoinVerifier_SPARSE_MERKLE_PLACEHOLDER_HASH_LITERAL">SPARSE_MERKLE_PLACEHOLDER_HASH_LITERAL</a>)
}
</code></pre>



</details>

<a name="0x1_StarcoinVerifier_create_literal_hash"></a>

## Function `create_literal_hash`



<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_create_literal_hash">create_literal_hash</a>(word: &vector&lt;u8&gt;): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_create_literal_hash">create_literal_hash</a>(word: &vector&lt;u8&gt;): vector&lt;u8&gt; {
    <b>if</b> (<a href="Vector.md#0x1_Vector_length">Vector::length</a>(word)  &lt;= 32) {
        <b>let</b> lenZero = 32 - <a href="Vector.md#0x1_Vector_length">Vector::length</a>(word);
        <b>let</b> i = 0;
        <b>let</b> r = *word;
        <b>while</b> (i &lt; lenZero) {
            <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> r, 0);
            i = i + 1;
        };
        <b>return</b> r
    };
    <b>abort</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_ERROR_LITERAL_HASH_WRONG_LENGTH">ERROR_LITERAL_HASH_WRONG_LENGTH</a>
}
</code></pre>



</details>

<a name="0x1_StarcoinVerifier_hash_key"></a>

## Function `hash_key`



<pre><code><b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_hash_key">hash_key</a>(key: &vector&lt;u8&gt;): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_hash_key">hash_key</a>(key: &vector&lt;u8&gt;): vector&lt;u8&gt; {
    <a href="Hash.md#0x1_Hash_sha3_256">Hash::sha3_256</a>(*key)
}
</code></pre>



</details>

<a name="0x1_StarcoinVerifier_hash_value"></a>

## Function `hash_value`



<pre><code><b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_hash_value">hash_value</a>(value: &vector&lt;u8&gt;): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_hash_value">hash_value</a>(value: &vector&lt;u8&gt;): vector&lt;u8&gt; {
    <a href="StarcoinVerifier.md#0x1_StructuredHash_hash">StructuredHash::hash</a>(<a href="StarcoinVerifier.md#0x1_StarcoinVerifier_BLOB_HASH_PREFIX">BLOB_HASH_PREFIX</a>, value)
}
</code></pre>



</details>

<a name="0x1_StarcoinVerifier_count_common_prefix"></a>

## Function `count_common_prefix`



<pre><code><b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_count_common_prefix">count_common_prefix</a>(data1: &vector&lt;u8&gt;, data2: &vector&lt;u8&gt;): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_count_common_prefix">count_common_prefix</a>(data1: &vector&lt;u8&gt;, data2: &vector&lt;u8&gt;): u64 {
    <b>let</b> count = 0;
    <b>let</b> i = 0;
    <b>while</b> ( i &lt; <a href="Vector.md#0x1_Vector_length">Vector::length</a>(data1) * 8) {
        <b>if</b> (<a href="StarcoinVerifier.md#0x1_StarcoinVerifier_get_bit_at_from_msb">get_bit_at_from_msb</a>(data1, i) == <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_get_bit_at_from_msb">get_bit_at_from_msb</a>(data2, i)) {
            count = count + 1;
        } <b>else</b> {
            <b>break</b>
        };
        i = i + 1;
    };
    count
}
</code></pre>



</details>

<a name="0x1_StarcoinVerifier_get_bit_at_from_msb"></a>

## Function `get_bit_at_from_msb`



<pre><code><b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_get_bit_at_from_msb">get_bit_at_from_msb</a>(data: &vector&lt;u8&gt;, index: u64): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_get_bit_at_from_msb">get_bit_at_from_msb</a>(data: &vector&lt;u8&gt;, index: u64): bool {
    <b>let</b> pos = index / 8;
    <b>let</b> bit = (7 - index % 8);
    (*<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(data, pos) &gt;&gt; (bit <b>as</b> u8)) & 1u8 != 0
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
<b>pragma</b> opaque;
</code></pre>



</details>
