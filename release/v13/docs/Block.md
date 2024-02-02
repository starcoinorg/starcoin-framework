
<a name="0x1_Block"></a>

# Module `0x1::Block`

Block module provide metadata for generated blocks.


-  [Resource `BlockMetadata`](#0x1_Block_BlockMetadata)
-  [Struct `NewBlockEvent`](#0x1_Block_NewBlockEvent)
-  [Resource `BlockMetadataV2`](#0x1_Block_BlockMetadataV2)
-  [Struct `NewBlockEventV2`](#0x1_Block_NewBlockEventV2)
-  [Struct `Checkpoint`](#0x1_Block_Checkpoint)
-  [Resource `Checkpoints`](#0x1_Block_Checkpoints)
-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1_Block_initialize)
-  [Function `initialize_blockmetadata_v2`](#0x1_Block_initialize_blockmetadata_v2)
-  [Function `get_current_block_number`](#0x1_Block_get_current_block_number)
-  [Function `get_parent_hash`](#0x1_Block_get_parent_hash)
-  [Function `get_current_author`](#0x1_Block_get_current_author)
-  [Function `get_parents_hash`](#0x1_Block_get_parents_hash)
-  [Function `process_block_metadata`](#0x1_Block_process_block_metadata)
-  [Function `process_block_metadata_v2`](#0x1_Block_process_block_metadata_v2)
-  [Function `checkpoints_init`](#0x1_Block_checkpoints_init)
-  [Function `checkpoint_entry`](#0x1_Block_checkpoint_entry)
-  [Function `checkpoint`](#0x1_Block_checkpoint)
-  [Function `base_checkpoint`](#0x1_Block_base_checkpoint)
-  [Function `latest_state_root`](#0x1_Block_latest_state_root)
-  [Function `base_latest_state_root`](#0x1_Block_base_latest_state_root)
-  [Function `update_state_root_entry`](#0x1_Block_update_state_root_entry)
-  [Function `update_state_root`](#0x1_Block_update_state_root)
-  [Function `base_update_state_root`](#0x1_Block_base_update_state_root)
-  [Module Specification](#@Module_Specification_1)


<pre><code><b>use</b> <a href="BCS.md#0x1_BCS">0x1::BCS</a>;
<b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Event.md#0x1_Event">0x1::Event</a>;
<b>use</b> <a href="Hash.md#0x1_Hash">0x1::Hash</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Ring.md#0x1_Ring">0x1::Ring</a>;
<b>use</b> <a href="Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_Block_BlockMetadata"></a>

## Resource `BlockMetadata`

Block metadata struct.


<pre><code><b>struct</b> <a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>number: u64</code>
</dt>
<dd>
 number of the current block
</dd>
<dt>
<code>parent_hash: vector&lt;u8&gt;</code>
</dt>
<dd>
 Hash of the parent block.
</dd>
<dt>
<code>author: <b>address</b></code>
</dt>
<dd>
 Author of the current block.
</dd>
<dt>
<code>uncles: u64</code>
</dt>
<dd>
 number of uncles.
</dd>
<dt>
<code>new_block_events: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="Block.md#0x1_Block_NewBlockEvent">Block::NewBlockEvent</a>&gt;</code>
</dt>
<dd>
 Handle of events when new blocks are emitted
</dd>
</dl>


</details>

<a name="0x1_Block_NewBlockEvent"></a>

## Struct `NewBlockEvent`

Events emitted when new block generated.


<pre><code><b>struct</b> <a href="Block.md#0x1_Block_NewBlockEvent">NewBlockEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>number: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>author: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>timestamp: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>uncles: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_Block_BlockMetadataV2"></a>

## Resource `BlockMetadataV2`

Block metadata struct.


<pre><code><b>struct</b> <a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>number: u64</code>
</dt>
<dd>
 number of the current block
</dd>
<dt>
<code>parent_hash: vector&lt;u8&gt;</code>
</dt>
<dd>
 Hash of the parent block.
</dd>
<dt>
<code>author: <b>address</b></code>
</dt>
<dd>
 Author of the current block.
</dd>
<dt>
<code>uncles: u64</code>
</dt>
<dd>
 number of uncles.
</dd>
<dt>
<code>parents_hash: vector&lt;u8&gt;</code>
</dt>
<dd>
 An Array of the parents hash for a Dag block.
</dd>
<dt>
<code>new_block_events: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="Block.md#0x1_Block_NewBlockEventV2">Block::NewBlockEventV2</a>&gt;</code>
</dt>
<dd>
 Handle of events when new blocks are emitted
</dd>
</dl>


</details>

<a name="0x1_Block_NewBlockEventV2"></a>

## Struct `NewBlockEventV2`

Events emitted when new block generated.


<pre><code><b>struct</b> <a href="Block.md#0x1_Block_NewBlockEventV2">NewBlockEventV2</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>number: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>author: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>timestamp: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>uncles: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>parents_hash: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_Block_Checkpoint"></a>

## Struct `Checkpoint`



<pre><code><b>struct</b> <a href="Block.md#0x1_Block_Checkpoint">Checkpoint</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>block_number: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>block_hash: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>state_root: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_Block_Checkpoints"></a>

## Resource `Checkpoints`



<pre><code><b>struct</b> <a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a> <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>checkpoints: <a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;<a href="Block.md#0x1_Block_Checkpoint">Block::Checkpoint</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>index: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>last_number: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_Block_BLOCK_HEADER_LENGTH"></a>



<pre><code><b>const</b> <a href="Block.md#0x1_Block_BLOCK_HEADER_LENGTH">BLOCK_HEADER_LENGTH</a>: u64 = 247;
</code></pre>



<a name="0x1_Block_BLOCK_INTERVAL_NUMBER"></a>



<pre><code><b>const</b> <a href="Block.md#0x1_Block_BLOCK_INTERVAL_NUMBER">BLOCK_INTERVAL_NUMBER</a>: u64 = 5;
</code></pre>



<a name="0x1_Block_CHECKPOINT_LENGTH"></a>



<pre><code><b>const</b> <a href="Block.md#0x1_Block_CHECKPOINT_LENGTH">CHECKPOINT_LENGTH</a>: u64 = 60;
</code></pre>



<a name="0x1_Block_EBLOCK_NUMBER_MISMATCH"></a>



<pre><code><b>const</b> <a href="Block.md#0x1_Block_EBLOCK_NUMBER_MISMATCH">EBLOCK_NUMBER_MISMATCH</a>: u64 = 17;
</code></pre>



<a name="0x1_Block_ERROR_INTERVAL_TOO_LITTLE"></a>



<pre><code><b>const</b> <a href="Block.md#0x1_Block_ERROR_INTERVAL_TOO_LITTLE">ERROR_INTERVAL_TOO_LITTLE</a>: u64 = 20;
</code></pre>



<a name="0x1_Block_ERROR_NOT_BLOCK_HEADER"></a>



<pre><code><b>const</b> <a href="Block.md#0x1_Block_ERROR_NOT_BLOCK_HEADER">ERROR_NOT_BLOCK_HEADER</a>: u64 = 19;
</code></pre>



<a name="0x1_Block_ERROR_NO_HAVE_CHECKPOINT"></a>



<pre><code><b>const</b> <a href="Block.md#0x1_Block_ERROR_NO_HAVE_CHECKPOINT">ERROR_NO_HAVE_CHECKPOINT</a>: u64 = 18;
</code></pre>



<a name="0x1_Block_initialize"></a>

## Function `initialize`

This can only be invoked by the GENESIS_ACCOUNT at genesis


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_initialize">initialize</a>(account: &signer, parent_hash: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_initialize">initialize</a>(account: &signer, parent_hash: vector&lt;u8&gt;) {
    <a href="Timestamp.md#0x1_Timestamp_assert_genesis">Timestamp::assert_genesis</a>();
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(account);

    <b>move_to</b>&lt;<a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>&gt;(
        account,
        <a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a> {
            number: 0,
            parent_hash,
            author: <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>(),
            uncles: 0,
            new_block_events: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="Block.md#0x1_Block_NewBlockEvent">Self::NewBlockEvent</a>&gt;(account),
        });
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<a href="Timestamp.md#0x1_Timestamp_is_genesis">Timestamp::is_genesis</a>();
<b>aborts_if</b> <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account) != <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>();
<b>aborts_if</b> <b>exists</b>&lt;<a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account));
</code></pre>



</details>

<a name="0x1_Block_initialize_blockmetadata_v2"></a>

## Function `initialize_blockmetadata_v2`



<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_initialize_blockmetadata_v2">initialize_blockmetadata_v2</a>(account: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_initialize_blockmetadata_v2">initialize_blockmetadata_v2</a>(account: &signer) <b>acquires</b> <a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a> {
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(account);

    <b>let</b> block_meta_ref = <b>borrow_global</b>&lt;<a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());

    // create new resource base on current block metadata
    <b>move_to</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(
        account,
        <a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a> {
            number: block_meta_ref.number,
            parent_hash: block_meta_ref.parent_hash,
            author: block_meta_ref.author,
            uncles: block_meta_ref.uncles,
            parents_hash: <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>(),
            new_block_events: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="Block.md#0x1_Block_NewBlockEventV2">Self::NewBlockEventV2</a>&gt;(account),
        });
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account) != <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>();
<b>aborts_if</b> <b>exists</b>&lt;<a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account));
<b>ensures</b> <b>exists</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account));
</code></pre>



</details>

<a name="0x1_Block_get_current_block_number"></a>

## Function `get_current_block_number`

Get the current block number


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_get_current_block_number">get_current_block_number</a>(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_get_current_block_number">get_current_block_number</a>(): u64 <b>acquires</b> <a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a> {
    <b>borrow_global</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()).number
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
</code></pre>



</details>

<a name="0x1_Block_get_parent_hash"></a>

## Function `get_parent_hash`

Get the hash of the parent block.


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_get_parent_hash">get_parent_hash</a>(): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_get_parent_hash">get_parent_hash</a>(): vector&lt;u8&gt; <b>acquires</b> <a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a> {
    *&<b>borrow_global</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()).parent_hash
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
</code></pre>



</details>

<a name="0x1_Block_get_current_author"></a>

## Function `get_current_author`

Gets the address of the author of the current block


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_get_current_author">get_current_author</a>(): <b>address</b>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_get_current_author">get_current_author</a>(): <b>address</b> <b>acquires</b> <a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a> {
    <b>borrow_global</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()).author
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
</code></pre>



</details>

<a name="0x1_Block_get_parents_hash"></a>

## Function `get_parents_hash`



<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_get_parents_hash">get_parents_hash</a>(): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_get_parents_hash">get_parents_hash</a>(): vector&lt;u8&gt; <b>acquires</b> <a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a> {
    *&<b>borrow_global</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()).parents_hash
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
</code></pre>



</details>

<a name="0x1_Block_process_block_metadata"></a>

## Function `process_block_metadata`

Call at block prologue


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_process_block_metadata">process_block_metadata</a>(account: &signer, parent_hash: vector&lt;u8&gt;, author: <b>address</b>, timestamp: u64, uncles: u64, number: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_process_block_metadata">process_block_metadata</a>(account: &signer,
                                  parent_hash: vector&lt;u8&gt;,
                                  author: <b>address</b>,
                                  timestamp: u64,
                                  uncles:u64,
                                  number:u64) <b>acquires</b> <a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>{
    <a href="Block.md#0x1_Block_process_block_metadata_v2">Self::process_block_metadata_v2</a>(account, parent_hash, author, timestamp, uncles, number, <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;())

}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account) != <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>();
<b>aborts_if</b> !<b>exists</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
<b>aborts_if</b> number != <b>global</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()).number + 1;
</code></pre>



</details>

<a name="0x1_Block_process_block_metadata_v2"></a>

## Function `process_block_metadata_v2`

Call at block prologue for flexidag


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_process_block_metadata_v2">process_block_metadata_v2</a>(account: &signer, parent_hash: vector&lt;u8&gt;, author: <b>address</b>, timestamp: u64, uncles: u64, number: u64, parents_hash: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_process_block_metadata_v2">process_block_metadata_v2</a>(account: &signer,
                                     parent_hash: vector&lt;u8&gt;,
                                     author: <b>address</b>,
                                     timestamp: u64,
                                     uncles:u64,
                                     number:u64,
                                     parents_hash: vector&lt;u8&gt;) <b>acquires</b> <a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a> {
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(account);

    <b>let</b> block_metadata_ref = <b>borrow_global_mut</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <b>assert</b>!(number == (block_metadata_ref.number + 1), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="Block.md#0x1_Block_EBLOCK_NUMBER_MISMATCH">EBLOCK_NUMBER_MISMATCH</a>));
    block_metadata_ref.number = number;
    block_metadata_ref.author= author;
    block_metadata_ref.parent_hash = parent_hash;
    block_metadata_ref.uncles = uncles;
    block_metadata_ref.parents_hash = parents_hash;

    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>&lt;<a href="Block.md#0x1_Block_NewBlockEventV2">NewBlockEventV2</a>&gt;(
      &<b>mut</b> block_metadata_ref.new_block_events,
      <a href="Block.md#0x1_Block_NewBlockEventV2">NewBlockEventV2</a> {
          number,
          author,
          timestamp,
          uncles,
          parents_hash,
      }
    );
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account) != <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>();
<b>aborts_if</b> !<b>exists</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
<b>aborts_if</b> number != <b>global</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()).number + 1;
</code></pre>




<a name="0x1_Block_AbortsIfBlockMetadataNotExist"></a>


<pre><code><b>schema</b> <a href="Block.md#0x1_Block_AbortsIfBlockMetadataNotExist">AbortsIfBlockMetadataNotExist</a> {
    <b>aborts_if</b> !<b>exists</b>&lt;<a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
}
</code></pre>



</details>

<a name="0x1_Block_checkpoints_init"></a>

## Function `checkpoints_init`



<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_checkpoints_init">checkpoints_init</a>(account: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_checkpoints_init">checkpoints_init</a>(account: &signer){
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(account);

    <b>let</b> checkpoints = <a href="Ring.md#0x1_Ring_create_with_capacity">Ring::create_with_capacity</a>&lt;<a href="Block.md#0x1_Block_Checkpoint">Checkpoint</a>&gt;(<a href="Block.md#0x1_Block_CHECKPOINT_LENGTH">CHECKPOINT_LENGTH</a>);
    <b>move_to</b>&lt;<a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a>&gt;(
        account,
        <a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a> {
           checkpoints,
           index        : 0,
           last_number  : 0,
    });
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_Block_checkpoint_entry"></a>

## Function `checkpoint_entry`



<pre><code><b>public</b> entry <b>fun</b> <a href="Block.md#0x1_Block_checkpoint_entry">checkpoint_entry</a>(_account: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="Block.md#0x1_Block_checkpoint_entry">checkpoint_entry</a>(_account: signer) <b>acquires</b> <a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>, <a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a> {
    <a href="Block.md#0x1_Block_checkpoint">checkpoint</a>();
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_Block_checkpoint"></a>

## Function `checkpoint`



<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_checkpoint">checkpoint</a>()
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_checkpoint">checkpoint</a>() <b>acquires</b> <a href="Block.md#0x1_Block_BlockMetadataV2">BlockMetadataV2</a>, <a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a>{
    <b>let</b> parent_block_number = <a href="Block.md#0x1_Block_get_current_block_number">get_current_block_number</a>() - 1;
    <b>let</b> parent_block_hash   = <a href="Block.md#0x1_Block_get_parent_hash">get_parent_hash</a>();

    <b>let</b> checkpoints = <b>borrow_global_mut</b>&lt;<a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <a href="Block.md#0x1_Block_base_checkpoint">base_checkpoint</a>(checkpoints, parent_block_number, parent_block_hash);

}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_Block_base_checkpoint"></a>

## Function `base_checkpoint`



<pre><code><b>fun</b> <a href="Block.md#0x1_Block_base_checkpoint">base_checkpoint</a>(checkpoints: &<b>mut</b> <a href="Block.md#0x1_Block_Checkpoints">Block::Checkpoints</a>, parent_block_number: u64, parent_block_hash: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="Block.md#0x1_Block_base_checkpoint">base_checkpoint</a>(checkpoints: &<b>mut</b> <a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a>, parent_block_number: u64, parent_block_hash:vector&lt;u8&gt;){
    <b>assert</b>!(checkpoints.last_number + <a href="Block.md#0x1_Block_BLOCK_INTERVAL_NUMBER">BLOCK_INTERVAL_NUMBER</a> &lt;= parent_block_number || checkpoints.last_number == 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="Block.md#0x1_Block_ERROR_INTERVAL_TOO_LITTLE">ERROR_INTERVAL_TOO_LITTLE</a>));

    checkpoints.index = checkpoints.index + 1;
    checkpoints.last_number = parent_block_number;
    <b>let</b> op_checkpoint = <a href="Ring.md#0x1_Ring_push">Ring::push</a>&lt;<a href="Block.md#0x1_Block_Checkpoint">Checkpoint</a>&gt;(&<b>mut</b> checkpoints.checkpoints, <a href="Block.md#0x1_Block_Checkpoint">Checkpoint</a> {
                                                            block_number: parent_block_number,
                                                            block_hash: parent_block_hash,
                                                            state_root: <a href="Option.md#0x1_Option_none">Option::none</a>&lt;vector&lt;u8&gt;&gt;(),
                                                        } );
    <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&op_checkpoint)){
        <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(op_checkpoint);
    }<b>else</b>{
        <a href="Option.md#0x1_Option_destroy_none">Option::destroy_none</a>(op_checkpoint);
    }
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_Block_latest_state_root"></a>

## Function `latest_state_root`



<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_latest_state_root">latest_state_root</a>(): (u64, vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_latest_state_root">latest_state_root</a>():(u64,vector&lt;u8&gt;) <b>acquires</b>  <a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a>{
    <b>let</b> checkpoints = <b>borrow_global</b>&lt;<a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <a href="Block.md#0x1_Block_base_latest_state_root">base_latest_state_root</a>(checkpoints)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_Block_base_latest_state_root"></a>

## Function `base_latest_state_root`



<pre><code><b>fun</b> <a href="Block.md#0x1_Block_base_latest_state_root">base_latest_state_root</a>(checkpoints: &<a href="Block.md#0x1_Block_Checkpoints">Block::Checkpoints</a>): (u64, vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="Block.md#0x1_Block_base_latest_state_root">base_latest_state_root</a>(checkpoints: &<a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a>):(u64,vector&lt;u8&gt;){
    <b>let</b> len = <a href="Ring.md#0x1_Ring_capacity">Ring::capacity</a>&lt;<a href="Block.md#0x1_Block_Checkpoint">Checkpoint</a>&gt;(&checkpoints.checkpoints);
    <b>let</b> j = <b>if</b>(checkpoints.index &lt; len - 1){
        checkpoints.index
    }<b>else</b>{
        len
    };
    <b>let</b> i = checkpoints.index;
    <b>while</b>( j &gt; 0){
        <b>let</b> op_checkpoint = <a href="Ring.md#0x1_Ring_borrow">Ring::borrow</a>(&checkpoints.checkpoints, i - 1 );
        <b>if</b>( <a href="Option.md#0x1_Option_is_some">Option::is_some</a>(op_checkpoint) && <a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&<a href="Option.md#0x1_Option_borrow">Option::borrow</a>(op_checkpoint).state_root) ) {
            <b>let</b> state_root = <a href="Option.md#0x1_Option_borrow">Option::borrow</a>(&<a href="Option.md#0x1_Option_borrow">Option::borrow</a>(op_checkpoint).state_root);
            <b>return</b> (<a href="Option.md#0x1_Option_borrow">Option::borrow</a>(op_checkpoint).block_number, *state_root)
        };
        j = j - 1;
        i = i - 1;
    };

    <b>abort</b> <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="Block.md#0x1_Block_ERROR_NO_HAVE_CHECKPOINT">ERROR_NO_HAVE_CHECKPOINT</a>)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_Block_update_state_root_entry"></a>

## Function `update_state_root_entry`



<pre><code><b>public</b> entry <b>fun</b> <a href="Block.md#0x1_Block_update_state_root_entry">update_state_root_entry</a>(_account: signer, header: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="Block.md#0x1_Block_update_state_root_entry">update_state_root_entry</a>(_account: signer , header: vector&lt;u8&gt;)
<b>acquires</b> <a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a> {
    <a href="Block.md#0x1_Block_update_state_root">update_state_root</a>(header);
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_Block_update_state_root"></a>

## Function `update_state_root`



<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_update_state_root">update_state_root</a>(header: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_update_state_root">update_state_root</a>(header: vector&lt;u8&gt;) <b>acquires</b>  <a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a> {
    <b>let</b> checkpoints = <b>borrow_global_mut</b>&lt;<a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <a href="Block.md#0x1_Block_base_update_state_root">base_update_state_root</a>(checkpoints, header);
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_Block_base_update_state_root"></a>

## Function `base_update_state_root`



<pre><code><b>fun</b> <a href="Block.md#0x1_Block_base_update_state_root">base_update_state_root</a>(checkpoints: &<b>mut</b> <a href="Block.md#0x1_Block_Checkpoints">Block::Checkpoints</a>, header: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="Block.md#0x1_Block_base_update_state_root">base_update_state_root</a>(checkpoints: &<b>mut</b> <a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a>, header: vector&lt;u8&gt;){
    <b>let</b> prefix = <a href="Hash.md#0x1_Hash_sha3_256">Hash::sha3_256</a>(b"STARCOIN::BlockHeader");

    //parent_hash
    <b>let</b> new_offset = <a href="BCS.md#0x1_BCS_skip_bytes">BCS::skip_bytes</a>(&header,0);
    //timestamp
    <b>let</b> new_offset = <a href="BCS.md#0x1_BCS_skip_u64">BCS::skip_u64</a>(&header,new_offset);
    //number
    <b>let</b> (number,new_offset) = <a href="BCS.md#0x1_BCS_deserialize_u64">BCS::deserialize_u64</a>(&header,new_offset);
    //author
    new_offset = <a href="BCS.md#0x1_BCS_skip_address">BCS::skip_address</a>(&header,new_offset);
    //author_auth_key
    new_offset = <a href="BCS.md#0x1_BCS_skip_option_bytes">BCS::skip_option_bytes</a>(&header,new_offset);
    //txn_accumulator_root
    new_offset = <a href="BCS.md#0x1_BCS_skip_bytes">BCS::skip_bytes</a>(&header,new_offset);
    //block_accumulator_root
    new_offset = <a href="BCS.md#0x1_BCS_skip_bytes">BCS::skip_bytes</a>(&header,new_offset);
    //state_root
    <b>let</b> (state_root,_new_offset) = <a href="BCS.md#0x1_BCS_deserialize_bytes">BCS::deserialize_bytes</a>(&header,new_offset);

    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> prefix,header);
    <b>let</b> block_hash = <a href="Hash.md#0x1_Hash_sha3_256">Hash::sha3_256</a>(prefix);

    <b>let</b> len = <a href="Ring.md#0x1_Ring_capacity">Ring::capacity</a>&lt;<a href="Block.md#0x1_Block_Checkpoint">Checkpoint</a>&gt;(&checkpoints.checkpoints);
    <b>let</b> j = <b>if</b>(checkpoints.index &lt; len - 1){
        checkpoints.index
    }<b>else</b>{
        len
    };
    <b>let</b> i = checkpoints.index;
    <b>while</b>( j &gt; 0){
        <b>let</b> op_checkpoint = <a href="Ring.md#0x1_Ring_borrow_mut">Ring::borrow_mut</a>(&<b>mut</b> checkpoints.checkpoints, i - 1);

        <b>if</b>( <a href="Option.md#0x1_Option_is_some">Option::is_some</a>(op_checkpoint) && &<a href="Option.md#0x1_Option_borrow">Option::borrow</a>(op_checkpoint).block_hash == &block_hash && <a href="Option.md#0x1_Option_borrow">Option::borrow</a>&lt;<a href="Block.md#0x1_Block_Checkpoint">Checkpoint</a>&gt;(op_checkpoint).block_number == number) {

            <b>let</b> op_state_root = &<b>mut</b> <a href="Option.md#0x1_Option_borrow_mut">Option::borrow_mut</a>&lt;<a href="Block.md#0x1_Block_Checkpoint">Checkpoint</a>&gt;(op_checkpoint).state_root;
            <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(op_state_root)){
                <a href="Option.md#0x1_Option_swap">Option::swap</a>(op_state_root, state_root);
            }<b>else</b>{
                <a href="Option.md#0x1_Option_fill">Option::fill</a>(op_state_root, state_root);
            };
            <b>return</b>
        };
        j = j - 1;
        i = i - 1;
    };

    <b>abort</b> <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="Block.md#0x1_Block_ERROR_NO_HAVE_CHECKPOINT">ERROR_NO_HAVE_CHECKPOINT</a>)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="@Module_Specification_1"></a>

## Module Specification



<pre><code><b>pragma</b> verify;
<b>pragma</b> aborts_if_is_strict = <b>true</b>;
</code></pre>
