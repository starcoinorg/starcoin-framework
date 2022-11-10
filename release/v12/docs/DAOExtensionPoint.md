
<a name="0x1_DAOExtensionPoint"></a>

# Module `0x1::DAOExtensionPoint`



-  [Struct `Version`](#0x1_DAOExtensionPoint_Version)
-  [Resource `Registry`](#0x1_DAOExtensionPoint_Registry)
-  [Resource `Entry`](#0x1_DAOExtensionPoint_Entry)
-  [Resource `Star`](#0x1_DAOExtensionPoint_Star)
-  [Struct `OwnerNFTMeta`](#0x1_DAOExtensionPoint_OwnerNFTMeta)
-  [Struct `OwnerNFTBody`](#0x1_DAOExtensionPoint_OwnerNFTBody)
-  [Resource `NFTMintCapHolder`](#0x1_DAOExtensionPoint_NFTMintCapHolder)
-  [Resource `RegistryEventHandlers`](#0x1_DAOExtensionPoint_RegistryEventHandlers)
-  [Struct `ExtensionPointRegisterEvent`](#0x1_DAOExtensionPoint_ExtensionPointRegisterEvent)
-  [Resource `ExtensionPointEventHandlers`](#0x1_DAOExtensionPoint_ExtensionPointEventHandlers)
-  [Struct `PublishVersionEvent`](#0x1_DAOExtensionPoint_PublishVersionEvent)
-  [Struct `StarEvent`](#0x1_DAOExtensionPoint_StarEvent)
-  [Struct `UnstarEvent`](#0x1_DAOExtensionPoint_UnstarEvent)
-  [Struct `UpdateInfoEvent`](#0x1_DAOExtensionPoint_UpdateInfoEvent)
-  [Constants](#@Constants_0)
-  [Function `next_extpoint_id`](#0x1_DAOExtensionPoint_next_extpoint_id)
-  [Function `next_extpoint_version_number`](#0x1_DAOExtensionPoint_next_extpoint_version_number)
-  [Function `has_extpoint_nft`](#0x1_DAOExtensionPoint_has_extpoint_nft)
-  [Function `ensure_exists_extpoint_nft`](#0x1_DAOExtensionPoint_ensure_exists_extpoint_nft)
-  [Function `assert_tag_no_repeat`](#0x1_DAOExtensionPoint_assert_tag_no_repeat)
-  [Function `assert_string_length`](#0x1_DAOExtensionPoint_assert_string_length)
-  [Function `assert_string_array_length`](#0x1_DAOExtensionPoint_assert_string_array_length)
-  [Function `initialize`](#0x1_DAOExtensionPoint_initialize)
-  [Function `register`](#0x1_DAOExtensionPoint_register)
-  [Function `publish_version`](#0x1_DAOExtensionPoint_publish_version)
-  [Function `update`](#0x1_DAOExtensionPoint_update)
-  [Function `has_star_plugin`](#0x1_DAOExtensionPoint_has_star_plugin)
-  [Function `star`](#0x1_DAOExtensionPoint_star)
-  [Function `unstar`](#0x1_DAOExtensionPoint_unstar)
-  [Function `register_entry`](#0x1_DAOExtensionPoint_register_entry)
-  [Function `publish_version_entry`](#0x1_DAOExtensionPoint_publish_version_entry)
-  [Function `update_entry`](#0x1_DAOExtensionPoint_update_entry)
-  [Function `star_entry`](#0x1_DAOExtensionPoint_star_entry)
-  [Function `unstar_entry`](#0x1_DAOExtensionPoint_unstar_entry)


<pre><code><b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Event.md#0x1_Event">0x1::Event</a>;
<b>use</b> <a href="GenesisSignerCapability.md#0x1_GenesisSignerCapability">0x1::GenesisSignerCapability</a>;
<b>use</b> <a href="NFT.md#0x1_NFT">0x1::NFT</a>;
<b>use</b> <a href="NFT.md#0x1_NFTGallery">0x1::NFTGallery</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
<b>use</b> <a href="TypeInfo.md#0x1_TypeInfo">0x1::TypeInfo</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_DAOExtensionPoint_Version"></a>

## Struct `Version`



<pre><code><b>struct</b> <a href="Version.md#0x1_Version">Version</a> <b>has</b> store
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
<code>tag: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>types_d_ts: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>document: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>created_at: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOExtensionPoint_Registry"></a>

## Resource `Registry`



<pre><code><b>struct</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Registry">Registry</a> <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>next_id: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOExtensionPoint_Entry"></a>

## Resource `Entry`



<pre><code><b>struct</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>&lt;ExtPointT&gt; <b>has</b> store, key
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
<code>name: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>description: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>labels: vector&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>next_version_number: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>versions: vector&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Version">DAOExtensionPoint::Version</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>star_count: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>created_at: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>updated_at: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOExtensionPoint_Star"></a>

## Resource `Star`



<pre><code><b>struct</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Star">Star</a>&lt;ExtPointT&gt; <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>created_at: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOExtensionPoint_OwnerNFTMeta"></a>

## Struct `OwnerNFTMeta`



<pre><code><b>struct</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_OwnerNFTMeta">OwnerNFTMeta</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>extpoint_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>registry_address: <b>address</b></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOExtensionPoint_OwnerNFTBody"></a>

## Struct `OwnerNFTBody`



<pre><code><b>struct</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_OwnerNFTBody">OwnerNFTBody</a> <b>has</b> store
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

<a name="0x1_DAOExtensionPoint_NFTMintCapHolder"></a>

## Resource `NFTMintCapHolder`



<pre><code><b>struct</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_NFTMintCapHolder">NFTMintCapHolder</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="NFT.md#0x1_NFT_MintCapability">NFT::MintCapability</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_OwnerNFTMeta">DAOExtensionPoint::OwnerNFTMeta</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>nft_metadata: <a href="NFT.md#0x1_NFT_Metadata">NFT::Metadata</a></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOExtensionPoint_RegistryEventHandlers"></a>

## Resource `RegistryEventHandlers`

registry event handlers


<pre><code><b>struct</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_RegistryEventHandlers">RegistryEventHandlers</a> <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>register: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointRegisterEvent">DAOExtensionPoint::ExtensionPointRegisterEvent</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOExtensionPoint_ExtensionPointRegisterEvent"></a>

## Struct `ExtensionPointRegisterEvent`



<pre><code><b>struct</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointRegisterEvent">ExtensionPointRegisterEvent</a> <b>has</b> drop, store
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
<code>type: <a href="TypeInfo.md#0x1_TypeInfo_TypeInfo">TypeInfo::TypeInfo</a></code>
</dt>
<dd>

</dd>
<dt>
<code>name: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>description: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>labels: vector&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOExtensionPoint_ExtensionPointEventHandlers"></a>

## Resource `ExtensionPointEventHandlers`

extension point event handlers


<pre><code><b>struct</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointEventHandlers">ExtensionPointEventHandlers</a>&lt;PluginT&gt; <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>publish_version: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_PublishVersionEvent">DAOExtensionPoint::PublishVersionEvent</a>&lt;PluginT&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>star: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_StarEvent">DAOExtensionPoint::StarEvent</a>&lt;PluginT&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>unstar: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_UnstarEvent">DAOExtensionPoint::UnstarEvent</a>&lt;PluginT&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code><b>update</b>: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_UpdateInfoEvent">DAOExtensionPoint::UpdateInfoEvent</a>&lt;PluginT&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOExtensionPoint_PublishVersionEvent"></a>

## Struct `PublishVersionEvent`



<pre><code><b>struct</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_PublishVersionEvent">PublishVersionEvent</a>&lt;PluginT&gt; <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>sender: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>version_number: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOExtensionPoint_StarEvent"></a>

## Struct `StarEvent`



<pre><code><b>struct</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_StarEvent">StarEvent</a>&lt;PluginT&gt; <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>sender: <b>address</b></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOExtensionPoint_UnstarEvent"></a>

## Struct `UnstarEvent`



<pre><code><b>struct</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_UnstarEvent">UnstarEvent</a>&lt;PluginT&gt; <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>sender: <b>address</b></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOExtensionPoint_UpdateInfoEvent"></a>

## Struct `UpdateInfoEvent`



<pre><code><b>struct</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_UpdateInfoEvent">UpdateInfoEvent</a>&lt;PluginT&gt; <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>sender: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>name: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>description: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>labels: vector&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_DAOExtensionPoint_ERR_ALREADY_INITIALIZED"></a>



<pre><code><b>const</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_ALREADY_INITIALIZED">ERR_ALREADY_INITIALIZED</a>: u64 = 100;
</code></pre>



<a name="0x1_DAOExtensionPoint_ERR_ITEMS_COUNT_LIMIT"></a>



<pre><code><b>const</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_ITEMS_COUNT_LIMIT">ERR_ITEMS_COUNT_LIMIT</a>: u64 = 109;
</code></pre>



<a name="0x1_DAOExtensionPoint_ERR_NOT_CONTRACT_OWNER"></a>



<pre><code><b>const</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_NOT_CONTRACT_OWNER">ERR_NOT_CONTRACT_OWNER</a>: u64 = 101;
</code></pre>



<a name="0x1_DAOExtensionPoint_ERR_STAR_ALREADY_STARED"></a>



<pre><code><b>const</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_STAR_ALREADY_STARED">ERR_STAR_ALREADY_STARED</a>: u64 = 105;
</code></pre>



<a name="0x1_DAOExtensionPoint_ERR_STAR_NOT_FOUND_STAR"></a>



<pre><code><b>const</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_STAR_NOT_FOUND_STAR">ERR_STAR_NOT_FOUND_STAR</a>: u64 = 106;
</code></pre>



<a name="0x1_DAOExtensionPoint_ERR_STRING_TOO_LONG"></a>



<pre><code><b>const</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_STRING_TOO_LONG">ERR_STRING_TOO_LONG</a>: u64 = 110;
</code></pre>



<a name="0x1_DAOExtensionPoint_ERR_TAG_DUPLICATED"></a>



<pre><code><b>const</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_TAG_DUPLICATED">ERR_TAG_DUPLICATED</a>: u64 = 107;
</code></pre>



<a name="0x1_DAOExtensionPoint_ERR_VERSION_COUNT_LIMIT"></a>



<pre><code><b>const</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_VERSION_COUNT_LIMIT">ERR_VERSION_COUNT_LIMIT</a>: u64 = 108;
</code></pre>



<a name="0x1_DAOExtensionPoint_MAX_INPUT_LEN"></a>



<pre><code><b>const</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_INPUT_LEN">MAX_INPUT_LEN</a>: u64 = 64;
</code></pre>



<a name="0x1_DAOExtensionPoint_MAX_TEXT_LEN"></a>



<pre><code><b>const</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_TEXT_LEN">MAX_TEXT_LEN</a>: u64 = 256;
</code></pre>



<a name="0x1_DAOExtensionPoint_MAX_VERSION_COUNT"></a>



<pre><code><b>const</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_VERSION_COUNT">MAX_VERSION_COUNT</a>: u64 = 256;
</code></pre>



<a name="0x1_DAOExtensionPoint_ERR_ALREADY_REGISTERED"></a>



<pre><code><b>const</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_ALREADY_REGISTERED">ERR_ALREADY_REGISTERED</a>: u64 = 104;
</code></pre>



<a name="0x1_DAOExtensionPoint_ERR_EXPECT_EXT_POINT_NFT"></a>



<pre><code><b>const</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_EXPECT_EXT_POINT_NFT">ERR_EXPECT_EXT_POINT_NFT</a>: u64 = 102;
</code></pre>



<a name="0x1_DAOExtensionPoint_ERR_NOT_FOUND_EXT_POINT"></a>



<pre><code><b>const</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_NOT_FOUND_EXT_POINT">ERR_NOT_FOUND_EXT_POINT</a>: u64 = 103;
</code></pre>



<a name="0x1_DAOExtensionPoint_MAX_LABELS_COUNT"></a>



<pre><code><b>const</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_LABELS_COUNT">MAX_LABELS_COUNT</a>: u64 = 20;
</code></pre>



<a name="0x1_DAOExtensionPoint_next_extpoint_id"></a>

## Function `next_extpoint_id`



<pre><code><b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_next_extpoint_id">next_extpoint_id</a>(registry: &<b>mut</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Registry">DAOExtensionPoint::Registry</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_next_extpoint_id">next_extpoint_id</a>(registry: &<b>mut</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Registry">Registry</a>): u64 {
    <b>let</b> extpoint_id = registry.next_id;
    registry.next_id = extpoint_id + 1;
    extpoint_id
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_next_extpoint_version_number"></a>

## Function `next_extpoint_version_number`



<pre><code><b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_next_extpoint_version_number">next_extpoint_version_number</a>&lt;ExtPointT: store&gt;(extpoint: &<b>mut</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">DAOExtensionPoint::Entry</a>&lt;ExtPointT&gt;): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_next_extpoint_version_number">next_extpoint_version_number</a>&lt;ExtPointT: store&gt;(extpoint: &<b>mut</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>&lt;ExtPointT&gt;): u64 {
    <b>let</b> version_number = extpoint.next_version_number;
    extpoint.next_version_number = version_number + 1;
    version_number
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_has_extpoint_nft"></a>

## Function `has_extpoint_nft`



<pre><code><b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_has_extpoint_nft">has_extpoint_nft</a>(sender_addr: <b>address</b>, extpoint_id: u64): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_has_extpoint_nft">has_extpoint_nft</a>(sender_addr: <b>address</b>, extpoint_id: u64): bool {
    <b>if</b> (!<a href="NFT.md#0x1_NFTGallery_is_accept">NFTGallery::is_accept</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_OwnerNFTMeta">OwnerNFTMeta</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_OwnerNFTBody">OwnerNFTBody</a>&gt;(sender_addr)) {
        <b>return</b> <b>false</b>
    };

    <b>let</b> nft_infos = <a href="NFT.md#0x1_NFTGallery_get_nft_infos">NFTGallery::get_nft_infos</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_OwnerNFTMeta">OwnerNFTMeta</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_OwnerNFTBody">OwnerNFTBody</a>&gt;(sender_addr);
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&nft_infos);
    <b>if</b> (len == 0) {
        <b>return</b> <b>false</b>
    };

    <b>let</b> idx = len - 1;
    <b>loop</b> {
        <b>let</b> nft_info = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&nft_infos, idx);
        <b>let</b> (_, _, _, type_meta) = <a href="NFT.md#0x1_NFT_unpack_info">NFT::unpack_info</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_OwnerNFTMeta">OwnerNFTMeta</a>&gt;(*nft_info);
        <b>if</b> (type_meta.extpoint_id == extpoint_id) {
            <b>return</b> <b>true</b>
        };

        <b>if</b> (idx == 0) {
            <b>return</b> <b>false</b>
        };

        idx = idx - 1;
    }
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_ensure_exists_extpoint_nft"></a>

## Function `ensure_exists_extpoint_nft`



<pre><code><b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ensure_exists_extpoint_nft">ensure_exists_extpoint_nft</a>(sender_addr: <b>address</b>, extpoint_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ensure_exists_extpoint_nft">ensure_exists_extpoint_nft</a>(sender_addr: <b>address</b>, extpoint_id: u64) {
    <b>assert</b>!(<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_has_extpoint_nft">has_extpoint_nft</a>(sender_addr, extpoint_id), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_EXPECT_EXT_POINT_NFT">ERR_EXPECT_EXT_POINT_NFT</a>));
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_assert_tag_no_repeat"></a>

## Function `assert_tag_no_repeat`



<pre><code><b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_tag_no_repeat">assert_tag_no_repeat</a>(v: &vector&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Version">DAOExtensionPoint::Version</a>&gt;, tag: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_tag_no_repeat">assert_tag_no_repeat</a>(v: &vector&lt;<a href="Version.md#0x1_Version">Version</a>&gt;, tag:vector&lt;u8&gt;) {
    <b>let</b> i = 0;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(v);
    <b>while</b> (i &lt; len) {
        <b>let</b> e = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(v, i);
        <b>assert</b>!(*&e.tag != *&tag, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_TAG_DUPLICATED">ERR_TAG_DUPLICATED</a>));
        i = i + 1;
    };
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_assert_string_length"></a>

## Function `assert_string_length`



<pre><code><b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_length">assert_string_length</a>(s: &vector&lt;u8&gt;, max_len: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_length">assert_string_length</a>(s: &vector&lt;u8&gt;, max_len: u64) {
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(s);
    <b>assert</b>!(len &lt;= max_len, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_STRING_TOO_LONG">ERR_STRING_TOO_LONG</a>));
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_assert_string_array_length"></a>

## Function `assert_string_array_length`



<pre><code><b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_array_length">assert_string_array_length</a>(v: &vector&lt;vector&lt;u8&gt;&gt;, max_item_len: u64, max_string_len: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_array_length">assert_string_array_length</a>(v: &vector&lt;vector&lt;u8&gt;&gt;, max_item_len: u64, max_string_len: u64) {
    <b>assert</b>!(<a href="Vector.md#0x1_Vector_length">Vector::length</a>(v) &lt;= max_item_len, <a href="Errors.md#0x1_Errors_limit_exceeded">Errors::limit_exceeded</a>(<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_ITEMS_COUNT_LIMIT">ERR_ITEMS_COUNT_LIMIT</a>));

    <b>let</b> i = 0;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(v);
    <b>while</b> (i &lt; len) {
        <b>let</b> e = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(v, i);
        <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_length">assert_string_length</a>(e, max_string_len);
        i = i + 1;
    };
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_initialize">initialize</a>()
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_initialize">initialize</a>() {
    <b>assert</b>!(!<b>exists</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Registry">Registry</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_ALREADY_INITIALIZED">ERR_ALREADY_INITIALIZED</a>));
    <b>let</b> signer = <a href="GenesisSignerCapability.md#0x1_GenesisSignerCapability_get_genesis_signer">GenesisSignerCapability::get_genesis_signer</a>();

    <b>let</b> nft_name = b"ExtPointOwnerNFT";
    <b>let</b> nft_image = b"ipfs://QmdTwdhFi61zhRM3MtPLxuKyaqv3ePECLGsMg9pMrePv4i";
    <b>let</b> nft_description = b"The extension point owner <a href="NFT.md#0x1_NFT">NFT</a>";
    <b>let</b> basemeta = <a href="NFT.md#0x1_NFT_new_meta_with_image_data">NFT::new_meta_with_image_data</a>(nft_name, nft_image, nft_description);
    <b>let</b> basemeta_bak = *&basemeta;
    <a href="NFT.md#0x1_NFT_register_v2">NFT::register_v2</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_OwnerNFTMeta">OwnerNFTMeta</a>&gt;(&signer, basemeta);

    <b>let</b> nft_mint_cap = <a href="NFT.md#0x1_NFT_remove_mint_capability">NFT::remove_mint_capability</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_OwnerNFTMeta">OwnerNFTMeta</a>&gt;(&signer);
    <b>move_to</b>(&signer, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_NFTMintCapHolder">NFTMintCapHolder</a>{
        cap: nft_mint_cap,
        nft_metadata: basemeta_bak,
    });

    <b>move_to</b>(&signer, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Registry">Registry</a>{
        next_id: 1,
    });

    <b>move_to</b>(&signer, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_RegistryEventHandlers">RegistryEventHandlers</a> {
        register: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointRegisterEvent">ExtensionPointRegisterEvent</a>&gt;(&signer),
    });
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_register"></a>

## Function `register`



<pre><code><b>public</b> <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_register">register</a>&lt;ExtPointT: store&gt;(sender: &signer, name: vector&lt;u8&gt;, description: vector&lt;u8&gt;, types_d_ts: vector&lt;u8&gt;, dts_doc: vector&lt;u8&gt;, option_labels: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;vector&lt;u8&gt;&gt;&gt;): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_register">register</a>&lt;ExtPointT: store&gt;(sender: &signer, name: vector&lt;u8&gt;, description: vector&lt;u8&gt;, types_d_ts:vector&lt;u8&gt;, dts_doc:vector&lt;u8&gt;,
    option_labels: <a href="Option.md#0x1_Option">Option</a>&lt;vector&lt;vector&lt;u8&gt;&gt;&gt;):u64 <b>acquires</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Registry">Registry</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_NFTMintCapHolder">NFTMintCapHolder</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_RegistryEventHandlers">RegistryEventHandlers</a> {
    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_length">assert_string_length</a>(&name, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_INPUT_LEN">MAX_INPUT_LEN</a>);
    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_length">assert_string_length</a>(&description, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_TEXT_LEN">MAX_TEXT_LEN</a>);
    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_length">assert_string_length</a>(&types_d_ts, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_TEXT_LEN">MAX_TEXT_LEN</a>);
    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_length">assert_string_length</a>(&dts_doc, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_TEXT_LEN">MAX_TEXT_LEN</a>);

    <b>assert</b>!(!<b>exists</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>&lt;ExtPointT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_ALREADY_REGISTERED">ERR_ALREADY_REGISTERED</a>));
    <b>let</b> registry = <b>borrow_global_mut</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Registry">Registry</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <b>let</b> extpoint_id = <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_next_extpoint_id">next_extpoint_id</a>(registry);

    <b>let</b> version = <a href="Version.md#0x1_Version">Version</a> {
        number: 1,
        tag: b"v0.1.0",
        types_d_ts: types_d_ts,
        document: dts_doc,
        created_at: <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>(),
    };

    <b>let</b> labels = <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&option_labels)){
        <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(option_labels)
    } <b>else</b> {
        <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;()
    };

    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_array_length">assert_string_array_length</a>(&labels, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_LABELS_COUNT">MAX_LABELS_COUNT</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_INPUT_LEN">MAX_INPUT_LEN</a>);

    <b>let</b> genesis_account = <a href="GenesisSignerCapability.md#0x1_GenesisSignerCapability_get_genesis_signer">GenesisSignerCapability::get_genesis_signer</a>();
    <b>move_to</b>(&genesis_account, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>&lt;ExtPointT&gt;{
        id: <b>copy</b> extpoint_id,
        name: <b>copy</b> name,
        description: <b>copy</b> description,
        labels: <b>copy</b> labels,
        next_version_number: 2,
        versions: <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>&lt;<a href="Version.md#0x1_Version">Version</a>&gt;(version),
        star_count: 0,
        created_at: <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>(),
        updated_at: <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>(),
    });

    <b>move_to</b>(&genesis_account, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointEventHandlers">ExtensionPointEventHandlers</a>&lt;ExtPointT&gt;{
        publish_version: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_PublishVersionEvent">PublishVersionEvent</a>&lt;ExtPointT&gt;&gt;(&genesis_account),
        star: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_StarEvent">StarEvent</a>&lt;ExtPointT&gt;&gt;(&genesis_account),
        unstar: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_UnstarEvent">UnstarEvent</a>&lt;ExtPointT&gt;&gt;(&genesis_account),
        <b>update</b>: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_UpdateInfoEvent">UpdateInfoEvent</a>&lt;ExtPointT&gt;&gt;(&genesis_account),
    });

    // grant owner <a href="NFT.md#0x1_NFT">NFT</a> <b>to</b> sender
    <b>let</b> nft_mint_cap = <b>borrow_global_mut</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_NFTMintCapHolder">NFTMintCapHolder</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <b>let</b> meta = <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_OwnerNFTMeta">OwnerNFTMeta</a>{
        registry_address: <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>(),
        extpoint_id: extpoint_id,
    };

    <b>let</b> nft = <a href="NFT.md#0x1_NFT_mint_with_cap_v2">NFT::mint_with_cap_v2</a>(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>(), &<b>mut</b> nft_mint_cap.cap, *&nft_mint_cap.nft_metadata, meta, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_OwnerNFTBody">OwnerNFTBody</a>{});
    <a href="NFT.md#0x1_NFTGallery_deposit">NFTGallery::deposit</a>(sender, nft);

    // registry register event emit
    <b>let</b> registry_event_handlers = <b>borrow_global_mut</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_RegistryEventHandlers">RegistryEventHandlers</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> registry_event_handlers.register,
        <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointRegisterEvent">ExtensionPointRegisterEvent</a> {
            id: <b>copy</b> extpoint_id,
            type: <a href="TypeInfo.md#0x1_TypeInfo_type_of">TypeInfo::type_of</a>&lt;ExtPointT&gt;(),
            name: <b>copy</b> name,
            description: <b>copy</b> description,
            labels: <b>copy</b> labels,
        },
    );

    extpoint_id
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_publish_version"></a>

## Function `publish_version`



<pre><code><b>public</b> <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_publish_version">publish_version</a>&lt;ExtPointT: store&gt;(sender: &signer, tag: vector&lt;u8&gt;, types_d_ts: vector&lt;u8&gt;, dts_doc: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_publish_version">publish_version</a>&lt;ExtPointT: store&gt;(
    sender: &signer,
    tag: vector&lt;u8&gt;,
    types_d_ts:vector&lt;u8&gt;,
    dts_doc: vector&lt;u8&gt;,
) <b>acquires</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointEventHandlers">ExtensionPointEventHandlers</a> {
    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_length">assert_string_length</a>(&tag, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_INPUT_LEN">MAX_INPUT_LEN</a>);
    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_length">assert_string_length</a>(&types_d_ts, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_TEXT_LEN">MAX_TEXT_LEN</a>);
    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_length">assert_string_length</a>(&dts_doc, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_TEXT_LEN">MAX_TEXT_LEN</a>);

    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>let</b> extp = <b>borrow_global_mut</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>&lt;ExtPointT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());

    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ensure_exists_extpoint_nft">ensure_exists_extpoint_nft</a>(sender_addr, extp.id);
    <b>assert</b>!(<a href="Vector.md#0x1_Vector_length">Vector::length</a>(&extp.versions) &lt;= <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_VERSION_COUNT">MAX_VERSION_COUNT</a>, <a href="Errors.md#0x1_Errors_limit_exceeded">Errors::limit_exceeded</a>(<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_VERSION_COUNT_LIMIT">ERR_VERSION_COUNT_LIMIT</a>));
    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_tag_no_repeat">assert_tag_no_repeat</a>(&extp.versions, <b>copy</b> tag);

    <b>let</b> number = <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_next_extpoint_version_number">next_extpoint_version_number</a>(extp);
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;<a href="Version.md#0x1_Version">Version</a>&gt;(&<b>mut</b> extp.versions, <a href="Version.md#0x1_Version">Version</a>{
        number: number,
        tag: tag,
        types_d_ts: types_d_ts,
        document: dts_doc,
        created_at: <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>(),
    });

    extp.updated_at = <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>();

    // publish version event emit
    <b>let</b> plugin_event_handlers = <b>borrow_global_mut</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointEventHandlers">ExtensionPointEventHandlers</a>&lt;ExtPointT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> plugin_event_handlers.publish_version,
        <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_PublishVersionEvent">PublishVersionEvent</a> {
            sender: <b>copy</b> sender_addr,
            version_number: <b>copy</b> number,
        },
    );
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_update"></a>

## Function `update`



<pre><code><b>public</b> <b>fun</b> <b>update</b>&lt;ExtPointT&gt;(sender: &signer, name: vector&lt;u8&gt;, description: vector&lt;u8&gt;, option_labels: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;vector&lt;u8&gt;&gt;&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <b>update</b>&lt;ExtPointT&gt;(sender: &signer, name: vector&lt;u8&gt;, description: vector&lt;u8&gt;, option_labels: <a href="Option.md#0x1_Option">Option</a>&lt;vector&lt;vector&lt;u8&gt;&gt;&gt;) <b>acquires</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointEventHandlers">ExtensionPointEventHandlers</a> {
    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_length">assert_string_length</a>(&name, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_INPUT_LEN">MAX_INPUT_LEN</a>);
    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_length">assert_string_length</a>(&description, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_TEXT_LEN">MAX_TEXT_LEN</a>);

    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>let</b> extp = <b>borrow_global_mut</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>&lt;ExtPointT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ensure_exists_extpoint_nft">ensure_exists_extpoint_nft</a>(sender_addr, extp.id);

    extp.name = name;
    extp.description = description;

    <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&option_labels)){
        <b>let</b> labels = <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(option_labels);
        <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_assert_string_array_length">assert_string_array_length</a>(&labels, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_LABELS_COUNT">MAX_LABELS_COUNT</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_MAX_INPUT_LEN">MAX_INPUT_LEN</a>);
        extp.labels = labels;
    };

    extp.updated_at = <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>();

    // <b>update</b> extpoint entry event emit
    <b>let</b> plugin_event_handlers = <b>borrow_global_mut</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointEventHandlers">ExtensionPointEventHandlers</a>&lt;ExtPointT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> plugin_event_handlers.<b>update</b>,
        <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_UpdateInfoEvent">UpdateInfoEvent</a> {
            sender: sender_addr,
            id: *&extp.id,
            name: *&extp.name,
            description: *&extp.description,
            labels: *&extp.labels,
        },
    );
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_has_star_plugin"></a>

## Function `has_star_plugin`



<pre><code><b>public</b> <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_has_star_plugin">has_star_plugin</a>&lt;ExtPointT&gt;(sender: &signer): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_has_star_plugin">has_star_plugin</a>&lt;ExtPointT&gt;(sender: &signer): bool {
    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>return</b> <b>exists</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Star">Star</a>&lt;ExtPointT&gt;&gt;(sender_addr)
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_star"></a>

## Function `star`



<pre><code><b>public</b> <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_star">star</a>&lt;ExtPointT&gt;(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_star">star</a>&lt;ExtPointT&gt;(sender: &signer) <b>acquires</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointEventHandlers">ExtensionPointEventHandlers</a> {
    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>assert</b>!(!<b>exists</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Star">Star</a>&lt;ExtPointT&gt;&gt;(sender_addr), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_STAR_ALREADY_STARED">ERR_STAR_ALREADY_STARED</a>));

    <b>move_to</b>(sender, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Star">Star</a>&lt;ExtPointT&gt;{
        created_at: <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>(),
    });

    <b>let</b> entry = <b>borrow_global_mut</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>&lt;ExtPointT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    entry.star_count = entry.star_count + 1;
    entry.updated_at = <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>();

    // star event emit
    <b>let</b> extpoint_event_handlers = <b>borrow_global_mut</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointEventHandlers">ExtensionPointEventHandlers</a>&lt;ExtPointT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> extpoint_event_handlers.star,
        <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_StarEvent">StarEvent</a> {
            sender: sender_addr,
        },
    );
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_unstar"></a>

## Function `unstar`



<pre><code><b>public</b> <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_unstar">unstar</a>&lt;ExtPointT&gt;(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_unstar">unstar</a>&lt;ExtPointT&gt;(sender: &signer) <b>acquires</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Star">Star</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointEventHandlers">ExtensionPointEventHandlers</a> {
    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>assert</b>!(<b>exists</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Star">Star</a>&lt;ExtPointT&gt;&gt;(sender_addr), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ERR_STAR_NOT_FOUND_STAR">ERR_STAR_NOT_FOUND_STAR</a>));

    <b>let</b> star = <b>move_from</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Star">Star</a>&lt;ExtPointT&gt;&gt;(sender_addr);
    <b>let</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Star">Star</a>&lt;ExtPointT&gt; {created_at:_} = star;

    <b>let</b> entry = <b>borrow_global_mut</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>&lt;ExtPointT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    entry.star_count = entry.star_count - 1;
    entry.updated_at = <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>();

    // unstar event emit
    <b>let</b> extpoint_event_handlers = <b>borrow_global_mut</b>&lt;<a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointEventHandlers">ExtensionPointEventHandlers</a>&lt;ExtPointT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> extpoint_event_handlers.unstar,
        <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_UnstarEvent">UnstarEvent</a> {
            sender: sender_addr,
        },
    );
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_register_entry"></a>

## Function `register_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_register_entry">register_entry</a>&lt;ExtPointT: store&gt;(sender: signer, name: vector&lt;u8&gt;, description: vector&lt;u8&gt;, types_d_ts: vector&lt;u8&gt;, dts_doc: vector&lt;u8&gt;, labels: vector&lt;vector&lt;u8&gt;&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_register_entry">register_entry</a>&lt;ExtPointT: store&gt;(sender: signer, name: vector&lt;u8&gt;, description: vector&lt;u8&gt;, types_d_ts:vector&lt;u8&gt;, dts_doc:vector&lt;u8&gt;,
    labels: vector&lt;vector&lt;u8&gt;&gt;) <b>acquires</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Registry">Registry</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_NFTMintCapHolder">NFTMintCapHolder</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_RegistryEventHandlers">RegistryEventHandlers</a> {
    <b>let</b> option_labels = <b>if</b>(<a href="Vector.md#0x1_Vector_length">Vector::length</a>(&labels) == 0){
        <a href="Option.md#0x1_Option_none">Option::none</a>&lt;vector&lt;vector&lt;u8&gt;&gt;&gt;()
    } <b>else</b> {
        <a href="Option.md#0x1_Option_some">Option::some</a>(labels)
    };

    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_register">register</a>&lt;ExtPointT&gt;(&sender, name, description, types_d_ts, dts_doc, option_labels);
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_publish_version_entry"></a>

## Function `publish_version_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_publish_version_entry">publish_version_entry</a>&lt;ExtPointT: store&gt;(sender: signer, tag: vector&lt;u8&gt;, types_d_ts: vector&lt;u8&gt;, dts_doc: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_publish_version_entry">publish_version_entry</a>&lt;ExtPointT: store&gt;(
    sender: signer,
    tag: vector&lt;u8&gt;,
    types_d_ts:vector&lt;u8&gt;,
    dts_doc: vector&lt;u8&gt;,
) <b>acquires</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointEventHandlers">ExtensionPointEventHandlers</a> {
    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_publish_version">publish_version</a>&lt;ExtPointT&gt;(&sender, tag, types_d_ts, dts_doc);
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_update_entry"></a>

## Function `update_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_update_entry">update_entry</a>&lt;ExtPointT&gt;(sender: signer, name: vector&lt;u8&gt;, description: vector&lt;u8&gt;, labels: vector&lt;vector&lt;u8&gt;&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_update_entry">update_entry</a>&lt;ExtPointT&gt;(sender: signer, name: vector&lt;u8&gt;, description: vector&lt;u8&gt;, labels: vector&lt;vector&lt;u8&gt;&gt;) <b>acquires</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointEventHandlers">ExtensionPointEventHandlers</a> {
    <b>let</b> option_labels = <b>if</b>(<a href="Vector.md#0x1_Vector_length">Vector::length</a>(&labels) == 0){
        <a href="Option.md#0x1_Option_none">Option::none</a>&lt;vector&lt;vector&lt;u8&gt;&gt;&gt;()
    } <b>else</b> {
        <a href="Option.md#0x1_Option_some">Option::some</a>(labels)
    };

    <b>update</b>&lt;ExtPointT&gt;(&sender, name, description, option_labels);
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_star_entry"></a>

## Function `star_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_star_entry">star_entry</a>&lt;ExtPointT: store&gt;(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_star_entry">star_entry</a>&lt;ExtPointT:store&gt;(sender: signer) <b>acquires</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointEventHandlers">ExtensionPointEventHandlers</a> {
    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_star">star</a>&lt;ExtPointT&gt;(&sender);
}
</code></pre>



</details>

<a name="0x1_DAOExtensionPoint_unstar_entry"></a>

## Function `unstar_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_unstar_entry">unstar_entry</a>&lt;ExtPointT: store&gt;(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_unstar_entry">unstar_entry</a>&lt;ExtPointT:store&gt;(sender: signer) <b>acquires</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Star">Star</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_Entry">Entry</a>, <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_ExtensionPointEventHandlers">ExtensionPointEventHandlers</a> {
    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_unstar">unstar</a>&lt;ExtPointT&gt;(&sender);
}
</code></pre>



</details>
