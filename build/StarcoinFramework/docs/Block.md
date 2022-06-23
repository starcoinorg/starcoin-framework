
<a name="0x1_Block"></a>

# Module `0x1::Block`

Block module provide metadata for generated blocks.


-  [Resource `BlockMetadata`](#0x1_Block_BlockMetadata)
-  [Struct `NewBlockEvent`](#0x1_Block_NewBlockEvent)
-  [Struct `Checkpoint`](#0x1_Block_Checkpoint)
-  [Resource `Checkpoints`](#0x1_Block_Checkpoints)
-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1_Block_initialize)
-  [Function `get_current_block_number`](#0x1_Block_get_current_block_number)
-  [Function `get_parent_hash`](#0x1_Block_get_parent_hash)
-  [Function `get_current_author`](#0x1_Block_get_current_author)
-  [Function `process_block_metadata`](#0x1_Block_process_block_metadata)
-  [Function `checkpoints_init`](#0x1_Block_checkpoints_init)
-  [Function `checkpoint`](#0x1_Block_checkpoint)
-  [Function `latest_state_root`](#0x1_Block_latest_state_root)
-  [Function `update_state_root`](#0x1_Block_update_state_root)
-  [Module Specification](#@Module_Specification_1)


<pre><code><b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Event.md#0x1_Event">0x1::Event</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
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



<pre><code><b>struct</b> <a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>checkpoints: vector&lt;<a href="Block.md#0x1_Block_Checkpoint">Block::Checkpoint</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>index: u64</code>
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



<a name="0x1_Block_CHECKPOINT_LENGTHR"></a>



<pre><code><b>const</b> <a href="Block.md#0x1_Block_CHECKPOINT_LENGTHR">CHECKPOINT_LENGTHR</a>: u64 = 60;
</code></pre>



<a name="0x1_Block_EBLOCK_NUMBER_MISMATCH"></a>



<pre><code><b>const</b> <a href="Block.md#0x1_Block_EBLOCK_NUMBER_MISMATCH">EBLOCK_NUMBER_MISMATCH</a>: u64 = 17;
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
            parent_hash: parent_hash,
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

<a name="0x1_Block_get_current_block_number"></a>

## Function `get_current_block_number`

Get the current block number


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_get_current_block_number">get_current_block_number</a>(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_get_current_block_number">get_current_block_number</a>(): u64 <b>acquires</b> <a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a> {
  <b>borrow_global</b>&lt;<a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()).number
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
</code></pre>



</details>

<a name="0x1_Block_get_parent_hash"></a>

## Function `get_parent_hash`

Get the hash of the parent block.


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_get_parent_hash">get_parent_hash</a>(): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_get_parent_hash">get_parent_hash</a>(): vector&lt;u8&gt; <b>acquires</b> <a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a> {
  *&<b>borrow_global</b>&lt;<a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()).parent_hash
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
</code></pre>



</details>

<a name="0x1_Block_get_current_author"></a>

## Function `get_current_author`

Gets the address of the author of the current block


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_get_current_author">get_current_author</a>(): <b>address</b>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_get_current_author">get_current_author</a>(): <b>address</b> <b>acquires</b> <a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a> {
  <b>borrow_global</b>&lt;<a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()).author
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
</code></pre>



</details>

<a name="0x1_Block_process_block_metadata"></a>

## Function `process_block_metadata`

Call at block prologue


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_process_block_metadata">process_block_metadata</a>(account: &signer, parent_hash: vector&lt;u8&gt;, author: <b>address</b>, timestamp: u64, uncles: u64, number: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_process_block_metadata">process_block_metadata</a>(account: &signer, parent_hash: vector&lt;u8&gt;,author: <b>address</b>, timestamp: u64, uncles:u64, number:u64) <b>acquires</b> <a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>{
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(account);

    <b>let</b> block_metadata_ref = <b>borrow_global_mut</b>&lt;<a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <b>assert</b>!(number == (block_metadata_ref.number + 1), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="Block.md#0x1_Block_EBLOCK_NUMBER_MISMATCH">EBLOCK_NUMBER_MISMATCH</a>));
    block_metadata_ref.number = number;
    block_metadata_ref.author= author;
    block_metadata_ref.parent_hash = parent_hash;
    block_metadata_ref.uncles = uncles;

    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>&lt;<a href="Block.md#0x1_Block_NewBlockEvent">NewBlockEvent</a>&gt;(
      &<b>mut</b> block_metadata_ref.new_block_events,
      <a href="Block.md#0x1_Block_NewBlockEvent">NewBlockEvent</a> {
          number: number,
          author: author,
          timestamp: timestamp,
          uncles: uncles,
      }
    );
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account) != <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>();
<b>aborts_if</b> !<b>exists</b>&lt;<a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
<b>aborts_if</b> number != <b>global</b>&lt;<a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()).number + 1;
</code></pre>




<a name="0x1_Block_AbortsIfBlockMetadataNotExist"></a>


<pre><code><b>schema</b> <a href="Block.md#0x1_Block_AbortsIfBlockMetadataNotExist">AbortsIfBlockMetadataNotExist</a> {
    <b>aborts_if</b> !<b>exists</b>&lt;<a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
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
    <b>let</b> i = 0;
    <b>let</b> checkpoints = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;<a href="Block.md#0x1_Block_Checkpoint">Checkpoint</a>&gt;();
    <b>while</b>( i &lt; <a href="Block.md#0x1_Block_CHECKPOINT_LENGTHR">CHECKPOINT_LENGTHR</a>){
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;<a href="Block.md#0x1_Block_Checkpoint">Checkpoint</a>&gt;(&<b>mut</b> checkpoints,<a href="Block.md#0x1_Block_Checkpoint">Checkpoint</a> {
            block_number: 0,
            block_hash  : <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;(),
            state_root  : <a href="Option.md#0x1_Option_none">Option::none</a>&lt;vector&lt;u8&gt;&gt;(),
        });
        i = i + 1;
    };
    <b>move_to</b>&lt;<a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a>&gt;(
        account,
        <a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a> {
           checkpoints: checkpoints,
           index: 0
        });
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> <b>exists</b>&lt;<a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
</code></pre>



</details>

<a name="0x1_Block_checkpoint"></a>

## Function `checkpoint`



<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_checkpoint">checkpoint</a>(account: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_checkpoint">checkpoint</a>(account: &signer) <b>acquires</b> <a href="Block.md#0x1_Block_BlockMetadata">BlockMetadata</a>, <a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a>{
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(account);
    <b>let</b> parent_block_number = <a href="Block.md#0x1_Block_get_current_block_number">get_current_block_number</a>() - 1;
    <b>let</b> parent_block_hash   = <a href="Block.md#0x1_Block_get_parent_hash">get_parent_hash</a>();

    <b>let</b> checkpoints = <b>borrow_global_mut</b>&lt;<a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    checkpoints.index =  <b>if</b>( checkpoints.index + 1 &gt;= <a href="Block.md#0x1_Block_CHECKPOINT_LENGTHR">CHECKPOINT_LENGTHR</a> ){
        0
    }<b>else</b>{
        checkpoints.index + 1
    };

    <b>let</b> checkpoint = <a href="Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>&lt;<a href="Block.md#0x1_Block_Checkpoint">Checkpoint</a>&gt;(&<b>mut</b> checkpoints.checkpoints , checkpoints.index);
    checkpoint.block_number = parent_block_number;
    checkpoint.block_hash   = parent_block_hash;
    checkpoint.state_root   = <a href="Option.md#0x1_Option_none">Option::none</a>&lt;vector&lt;u8&gt;&gt;();
}
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
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>&lt;<a href="Block.md#0x1_Block_Checkpoint">Checkpoint</a>&gt;(&checkpoints.checkpoints);
    <b>let</b> i = checkpoints.index ;
    <b>while</b>( i &lt;  len + checkpoints.index){
        <b>if</b>( <a href="Option.md#0x1_Option_is_some">Option::is_some</a>&lt;vector&lt;u8&gt;&gt;(&<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&checkpoints.checkpoints, i % len).state_root)) {
            <b>return</b> (<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&checkpoints.checkpoints, i % len).block_number, *&<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&checkpoints.checkpoints, i % len).block_hash)
        };

        i = i + 1;
    };
    <b>abort</b> <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="Block.md#0x1_Block_ERROR_NO_HAVE_CHECKPOINT">ERROR_NO_HAVE_CHECKPOINT</a>)
}
</code></pre>



</details>

<a name="0x1_Block_update_state_root"></a>

## Function `update_state_root`



<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_update_state_root">update_state_root</a>(account: &signer, header: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Block.md#0x1_Block_update_state_root">update_state_root</a>(account: &signer, header:vector&lt;u8&gt;) <b>acquires</b>  <a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a>{
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(account);
    // header = x"20b82a2c11f2df62bf87c2933d0281e5fe47ea94d5f0049eec1485b682df29529abf17ac7d79010000000000000000000000000000000000000000000000000001002043609d52fdf8e4a253c62dfe127d33c77e1fb4afdefb306d46ec42e21b9103ae20414343554d554c41544f525f504c414345484f4c4445525f48415348000000002061125a3ab755b993d72accfea741f8537104db8e022098154f3a66d5c23e828d00000000000000000000000000000000000000000000000000000000000000000000000000b1ec37207564db97ee270a6c1f2f73fbf517dc0777a6119b7460b7eae2890d1ce504537b010000000000000000";

    <b>assert</b>!(<a href="Vector.md#0x1_Vector_length">Vector::length</a>&lt;u8&gt;(&header) == <a href="Block.md#0x1_Block_BLOCK_HEADER_LENGTH">BLOCK_HEADER_LENGTH</a> , <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="Block.md#0x1_Block_ERROR_NOT_BLOCK_HEADER">ERROR_NOT_BLOCK_HEADER</a>));
    <b>let</b> i = 1 ;
    <b>let</b> block_hash = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>while</b>(i &lt; 33){
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u8&gt;(&<b>mut</b> block_hash , *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>&lt;u8&gt;(&header , i));
        i = i + 1;
    };
    i = 41 ;
    <b>let</b> number_vec = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>while</b>(i &lt; 49){
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u8&gt;(&<b>mut</b> number_vec , *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>&lt;u8&gt;(&header , i));
        i = i + 1;
    };
    <b>let</b> number: u128 = 0;
    <b>let</b> offset  = 0;
    <b>let</b> i = 0;
    <b>while</b> (i &lt; 8) {
        <b>let</b> byte = *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&number_vec, offset + i);
        <b>let</b> s = (i <b>as</b> u8) * 8;
        number = number + ((byte <b>as</b> u128) &lt;&lt; s);
        i = i + 1;
    };

    <b>let</b> state_root = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    i = 133;
    <b>while</b>(i &lt; 165){
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u8&gt;(&<b>mut</b> state_root , *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>&lt;u8&gt;(&header , i));
        i = i + 1;
    };

    <b>let</b> checkpoints = <b>borrow_global_mut</b>&lt;<a href="Block.md#0x1_Block_Checkpoints">Checkpoints</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>&lt;<a href="Block.md#0x1_Block_Checkpoint">Checkpoint</a>&gt;(&checkpoints.checkpoints);
    <b>let</b> i = checkpoints.index ;
    <b>while</b>( i &lt;  len + checkpoints.index){
        <b>if</b>( &<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&<b>mut</b> checkpoints.checkpoints, i % len).block_hash == &block_hash ) {
            <a href="Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> checkpoints.checkpoints, i % len).block_number = (number <b>as</b> u64 );
            *<a href="Option.md#0x1_Option_borrow_mut">Option::borrow_mut</a>&lt;vector&lt;u8&gt;&gt;( &<b>mut</b> <a href="Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> checkpoints.checkpoints, i % len).state_root) = state_root;
            <b>return</b>
        };
        i = i + 1 ;
    };

    <b>abort</b> <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="Block.md#0x1_Block_ERROR_NO_HAVE_CHECKPOINT">ERROR_NO_HAVE_CHECKPOINT</a>)
}
</code></pre>



</details>

<a name="@Module_Specification_1"></a>

## Module Specification



<pre><code><b>pragma</b> verify;
<b>pragma</b> aborts_if_is_strict = <b>true</b>;
</code></pre>
