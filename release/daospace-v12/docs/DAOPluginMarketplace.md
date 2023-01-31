
<a name="0x1_DAOPluginMarketplace"></a>

# Module `0x1::DAOPluginMarketplace`



-  [Struct `PluginVersion`](#0x1_DAOPluginMarketplace_PluginVersion)
-  [Resource `PluginRegistry`](#0x1_DAOPluginMarketplace_PluginRegistry)
-  [Resource `PluginEntry`](#0x1_DAOPluginMarketplace_PluginEntry)
-  [Resource `Star`](#0x1_DAOPluginMarketplace_Star)
-  [Resource `RegistryEventHandlers`](#0x1_DAOPluginMarketplace_RegistryEventHandlers)
-  [Struct `PluginRegisterEvent`](#0x1_DAOPluginMarketplace_PluginRegisterEvent)
-  [Resource `PluginEventHandlers`](#0x1_DAOPluginMarketplace_PluginEventHandlers)
-  [Struct `PluginPublishVersionEvent`](#0x1_DAOPluginMarketplace_PluginPublishVersionEvent)
-  [Struct `StarPluginEvent`](#0x1_DAOPluginMarketplace_StarPluginEvent)
-  [Struct `UnstarPluginEvent`](#0x1_DAOPluginMarketplace_UnstarPluginEvent)
-  [Struct `UpdatePluginInfoEvent`](#0x1_DAOPluginMarketplace_UpdatePluginInfoEvent)
-  [Constants](#@Constants_0)
-  [Function `next_plugin_id`](#0x1_DAOPluginMarketplace_next_plugin_id)
-  [Function `next_plugin_version_number`](#0x1_DAOPluginMarketplace_next_plugin_version_number)
-  [Function `assert_tag_no_repeat`](#0x1_DAOPluginMarketplace_assert_tag_no_repeat)
-  [Function `assert_string_length`](#0x1_DAOPluginMarketplace_assert_string_length)
-  [Function `assert_string_array_length`](#0x1_DAOPluginMarketplace_assert_string_array_length)
-  [Function `initialize`](#0x1_DAOPluginMarketplace_initialize)
-  [Function `register_plugin`](#0x1_DAOPluginMarketplace_register_plugin)
-  [Function `exists_plugin`](#0x1_DAOPluginMarketplace_exists_plugin)
-  [Function `take_plugin_id`](#0x1_DAOPluginMarketplace_take_plugin_id)
-  [Function `publish_plugin_version`](#0x1_DAOPluginMarketplace_publish_plugin_version)
-  [Function `exists_plugin_version`](#0x1_DAOPluginMarketplace_exists_plugin_version)
-  [Function `star_plugin`](#0x1_DAOPluginMarketplace_star_plugin)
-  [Function `unstar_plugin`](#0x1_DAOPluginMarketplace_unstar_plugin)
-  [Function `has_star_plugin`](#0x1_DAOPluginMarketplace_has_star_plugin)
-  [Function `update_plugin`](#0x1_DAOPluginMarketplace_update_plugin)
-  [Function `star_plugin_entry`](#0x1_DAOPluginMarketplace_star_plugin_entry)
-  [Function `unstar_plugin_entry`](#0x1_DAOPluginMarketplace_unstar_plugin_entry)


<pre><code><b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Event.md#0x1_Event">0x1::Event</a>;
<b>use</b> <a href="GenesisSignerCapability.md#0x1_GenesisSignerCapability">0x1::GenesisSignerCapability</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
<b>use</b> <a href="TypeInfo.md#0x1_TypeInfo">0x1::TypeInfo</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_DAOPluginMarketplace_PluginVersion"></a>

## Struct `PluginVersion`



<pre><code><b>struct</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginVersion">PluginVersion</a> <b>has</b> store
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
<code>implement_extpoints: vector&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>depend_extpoints: vector&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>js_entry_uri: vector&lt;u8&gt;</code>
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

<a name="0x1_DAOPluginMarketplace_PluginRegistry"></a>

## Resource `PluginRegistry`



<pre><code><b>struct</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginRegistry">PluginRegistry</a> <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>next_plugin_id: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOPluginMarketplace_PluginEntry"></a>

## Resource `PluginEntry`



<pre><code><b>struct</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>&lt;PluginT&gt; <b>has</b> store, key
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
<code>versions: vector&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginVersion">DAOPluginMarketplace::PluginVersion</a>&gt;</code>
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

<a name="0x1_DAOPluginMarketplace_Star"></a>

## Resource `Star`



<pre><code><b>struct</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_Star">Star</a>&lt;PluginT&gt; <b>has</b> store, key
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

<a name="0x1_DAOPluginMarketplace_RegistryEventHandlers"></a>

## Resource `RegistryEventHandlers`

registry event handlers


<pre><code><b>struct</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_RegistryEventHandlers">RegistryEventHandlers</a> <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>register: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginRegisterEvent">DAOPluginMarketplace::PluginRegisterEvent</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOPluginMarketplace_PluginRegisterEvent"></a>

## Struct `PluginRegisterEvent`



<pre><code><b>struct</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginRegisterEvent">PluginRegisterEvent</a> <b>has</b> drop, store
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

<a name="0x1_DAOPluginMarketplace_PluginEventHandlers"></a>

## Resource `PluginEventHandlers`

plugin event handlers


<pre><code><b>struct</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEventHandlers">PluginEventHandlers</a>&lt;PluginT&gt; <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>publish_version: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginPublishVersionEvent">DAOPluginMarketplace::PluginPublishVersionEvent</a>&lt;PluginT&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>star: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_StarPluginEvent">DAOPluginMarketplace::StarPluginEvent</a>&lt;PluginT&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>unstar: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_UnstarPluginEvent">DAOPluginMarketplace::UnstarPluginEvent</a>&lt;PluginT&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>update_plugin: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_UpdatePluginInfoEvent">DAOPluginMarketplace::UpdatePluginInfoEvent</a>&lt;PluginT&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOPluginMarketplace_PluginPublishVersionEvent"></a>

## Struct `PluginPublishVersionEvent`



<pre><code><b>struct</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginPublishVersionEvent">PluginPublishVersionEvent</a>&lt;PluginT&gt; <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>plugin_type: <a href="TypeInfo.md#0x1_TypeInfo_TypeInfo">TypeInfo::TypeInfo</a></code>
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

<a name="0x1_DAOPluginMarketplace_StarPluginEvent"></a>

## Struct `StarPluginEvent`



<pre><code><b>struct</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_StarPluginEvent">StarPluginEvent</a>&lt;PluginT&gt; <b>has</b> drop, store
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

<a name="0x1_DAOPluginMarketplace_UnstarPluginEvent"></a>

## Struct `UnstarPluginEvent`



<pre><code><b>struct</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_UnstarPluginEvent">UnstarPluginEvent</a>&lt;PluginT&gt; <b>has</b> drop, store
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

<a name="0x1_DAOPluginMarketplace_UpdatePluginInfoEvent"></a>

## Struct `UpdatePluginInfoEvent`



<pre><code><b>struct</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_UpdatePluginInfoEvent">UpdatePluginInfoEvent</a>&lt;PluginT&gt; <b>has</b> drop, store
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

<a name="@Constants_0"></a>

## Constants


<a name="0x1_DAOPluginMarketplace_ERR_ALREADY_INITIALIZED"></a>



<pre><code><b>const</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_ALREADY_INITIALIZED">ERR_ALREADY_INITIALIZED</a>: u64 = 100;
</code></pre>



<a name="0x1_DAOPluginMarketplace_ERR_EXPECT_PLUGIN_NFT"></a>



<pre><code><b>const</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_EXPECT_PLUGIN_NFT">ERR_EXPECT_PLUGIN_NFT</a>: u64 = 103;
</code></pre>



<a name="0x1_DAOPluginMarketplace_ERR_ITEMS_COUNT_LIMIT"></a>



<pre><code><b>const</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_ITEMS_COUNT_LIMIT">ERR_ITEMS_COUNT_LIMIT</a>: u64 = 109;
</code></pre>



<a name="0x1_DAOPluginMarketplace_ERR_NOT_CONTRACT_OWNER"></a>



<pre><code><b>const</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_NOT_CONTRACT_OWNER">ERR_NOT_CONTRACT_OWNER</a>: u64 = 101;
</code></pre>



<a name="0x1_DAOPluginMarketplace_ERR_NOT_FOUND_PLUGIN"></a>



<pre><code><b>const</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_NOT_FOUND_PLUGIN">ERR_NOT_FOUND_PLUGIN</a>: u64 = 102;
</code></pre>



<a name="0x1_DAOPluginMarketplace_ERR_PLUGIN_ALREADY_EXISTS"></a>



<pre><code><b>const</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_PLUGIN_ALREADY_EXISTS">ERR_PLUGIN_ALREADY_EXISTS</a>: u64 = 104;
</code></pre>



<a name="0x1_DAOPluginMarketplace_ERR_STAR_ALREADY_STARED"></a>



<pre><code><b>const</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_STAR_ALREADY_STARED">ERR_STAR_ALREADY_STARED</a>: u64 = 105;
</code></pre>



<a name="0x1_DAOPluginMarketplace_ERR_STAR_NOT_FOUND_STAR"></a>



<pre><code><b>const</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_STAR_NOT_FOUND_STAR">ERR_STAR_NOT_FOUND_STAR</a>: u64 = 106;
</code></pre>



<a name="0x1_DAOPluginMarketplace_ERR_STRING_TOO_LONG"></a>



<pre><code><b>const</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_STRING_TOO_LONG">ERR_STRING_TOO_LONG</a>: u64 = 110;
</code></pre>



<a name="0x1_DAOPluginMarketplace_ERR_TAG_DUPLICATED"></a>



<pre><code><b>const</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_TAG_DUPLICATED">ERR_TAG_DUPLICATED</a>: u64 = 107;
</code></pre>



<a name="0x1_DAOPluginMarketplace_ERR_VERSION_COUNT_LIMIT"></a>



<pre><code><b>const</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_VERSION_COUNT_LIMIT">ERR_VERSION_COUNT_LIMIT</a>: u64 = 108;
</code></pre>



<a name="0x1_DAOPluginMarketplace_MAX_INPUT_LEN"></a>



<pre><code><b>const</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_INPUT_LEN">MAX_INPUT_LEN</a>: u64 = 64;
</code></pre>



<a name="0x1_DAOPluginMarketplace_MAX_ITEMS_COUNT"></a>



<pre><code><b>const</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_ITEMS_COUNT">MAX_ITEMS_COUNT</a>: u64 = 20;
</code></pre>



<a name="0x1_DAOPluginMarketplace_MAX_TEXT_LEN"></a>



<pre><code><b>const</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_TEXT_LEN">MAX_TEXT_LEN</a>: u64 = 256;
</code></pre>



<a name="0x1_DAOPluginMarketplace_MAX_VERSION_COUNT"></a>



<pre><code><b>const</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_VERSION_COUNT">MAX_VERSION_COUNT</a>: u64 = 5;
</code></pre>



<a name="0x1_DAOPluginMarketplace_next_plugin_id"></a>

## Function `next_plugin_id`



<pre><code><b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_next_plugin_id">next_plugin_id</a>(plugin_registry: &<b>mut</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginRegistry">DAOPluginMarketplace::PluginRegistry</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_next_plugin_id">next_plugin_id</a>(plugin_registry: &<b>mut</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginRegistry">PluginRegistry</a>): u64 {
    <b>let</b> plugin_id = plugin_registry.next_plugin_id;
    plugin_registry.next_plugin_id = plugin_id + 1;
    plugin_id
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_next_plugin_version_number"></a>

## Function `next_plugin_version_number`



<pre><code><b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_next_plugin_version_number">next_plugin_version_number</a>&lt;PluginT&gt;(plugin: &<b>mut</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">DAOPluginMarketplace::PluginEntry</a>&lt;PluginT&gt;): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_next_plugin_version_number">next_plugin_version_number</a>&lt;PluginT&gt;(plugin: &<b>mut</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>&lt;PluginT&gt;): u64 {
    <b>let</b> version_number = plugin.next_version_number;
    plugin.next_version_number = version_number + 1;
    version_number
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_assert_tag_no_repeat"></a>

## Function `assert_tag_no_repeat`



<pre><code><b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_tag_no_repeat">assert_tag_no_repeat</a>(v: &vector&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginVersion">DAOPluginMarketplace::PluginVersion</a>&gt;, tag: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_tag_no_repeat">assert_tag_no_repeat</a>(v: &vector&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginVersion">PluginVersion</a>&gt;, tag:vector&lt;u8&gt;) {
    <b>let</b> i = 0;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(v);
    <b>while</b> (i &lt; len) {
        <b>let</b> e = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(v, i);
        <b>assert</b>!(*&e.tag != *&tag, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_TAG_DUPLICATED">ERR_TAG_DUPLICATED</a>));
        i = i + 1;
    };
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_assert_string_length"></a>

## Function `assert_string_length`



<pre><code><b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_string_length">assert_string_length</a>(s: &vector&lt;u8&gt;, max_len: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_string_length">assert_string_length</a>(s: &vector&lt;u8&gt;, max_len: u64) {
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(s);
    <b>assert</b>!(len &lt;= max_len, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_STRING_TOO_LONG">ERR_STRING_TOO_LONG</a>));
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_assert_string_array_length"></a>

## Function `assert_string_array_length`



<pre><code><b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_string_array_length">assert_string_array_length</a>(v: &vector&lt;vector&lt;u8&gt;&gt;, max_item_len: u64, max_string_len: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_string_array_length">assert_string_array_length</a>(v: &vector&lt;vector&lt;u8&gt;&gt;, max_item_len: u64, max_string_len: u64) {
    <b>assert</b>!(<a href="Vector.md#0x1_Vector_length">Vector::length</a>(v) &lt;= max_item_len, <a href="Errors.md#0x1_Errors_limit_exceeded">Errors::limit_exceeded</a>(<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_ITEMS_COUNT_LIMIT">ERR_ITEMS_COUNT_LIMIT</a>));

    <b>let</b> i = 0;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(v);
    <b>while</b> (i &lt; len) {
        <b>let</b> e = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(v, i);
        <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_string_length">assert_string_length</a>(e, max_string_len);
        i = i + 1;
    };
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_initialize"></a>

## Function `initialize`



<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_initialize">initialize</a>()
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_initialize">initialize</a>() {
    <b>assert</b>!(!<b>exists</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginRegistry">PluginRegistry</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_ALREADY_INITIALIZED">ERR_ALREADY_INITIALIZED</a>));
    <b>let</b> signer = <a href="GenesisSignerCapability.md#0x1_GenesisSignerCapability_get_genesis_signer">GenesisSignerCapability::get_genesis_signer</a>();

    <b>move_to</b>(&signer, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginRegistry">PluginRegistry</a>{
        next_plugin_id: 1,
    });

    <b>move_to</b>(&signer, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_RegistryEventHandlers">RegistryEventHandlers</a> {
        register: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginRegisterEvent">PluginRegisterEvent</a>&gt;(&signer),
    });
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_register_plugin"></a>

## Function `register_plugin`



<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_register_plugin">register_plugin</a>&lt;PluginT: store&gt;(_witness: &PluginT, name: vector&lt;u8&gt;, description: vector&lt;u8&gt;, option_labels: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;vector&lt;u8&gt;&gt;&gt;): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_register_plugin">register_plugin</a>&lt;PluginT: store&gt;(_witness: &PluginT, name: vector&lt;u8&gt;, description: vector&lt;u8&gt;, option_labels: <a href="Option.md#0x1_Option">Option</a>&lt;vector&lt;vector&lt;u8&gt;&gt;&gt;): u64
    <b>acquires</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginRegistry">PluginRegistry</a>, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_RegistryEventHandlers">RegistryEventHandlers</a> {
    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_string_length">assert_string_length</a>(&name, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_INPUT_LEN">MAX_INPUT_LEN</a>);
    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_string_length">assert_string_length</a>(&description, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_TEXT_LEN">MAX_TEXT_LEN</a>);

    <b>assert</b>!(!<b>exists</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>&lt;PluginT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>()), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_PLUGIN_ALREADY_EXISTS">ERR_PLUGIN_ALREADY_EXISTS</a>));
    <b>let</b> plugin_registry = <b>borrow_global_mut</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginRegistry">PluginRegistry</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <b>let</b> plugin_id = <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_next_plugin_id">next_plugin_id</a>(plugin_registry);

    <b>let</b> genesis_account = <a href="GenesisSignerCapability.md#0x1_GenesisSignerCapability_get_genesis_signer">GenesisSignerCapability::get_genesis_signer</a>();

    <b>let</b> labels = <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&option_labels)){
        <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(option_labels)
    } <b>else</b> {
        <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;()
    };

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_string_array_length">assert_string_array_length</a>(&labels, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_ITEMS_COUNT">MAX_ITEMS_COUNT</a>, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_INPUT_LEN">MAX_INPUT_LEN</a>);

    <b>move_to</b>(&genesis_account, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>&lt;PluginT&gt;{
        id: <b>copy</b> plugin_id,
        name: <b>copy</b> name,
        description: <b>copy</b> description,
        labels: <b>copy</b> labels,
        next_version_number: 1,
        versions: <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginVersion">PluginVersion</a>&gt;(),
        star_count: 0,
        created_at: <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>(),
        updated_at: <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>(),
    });

    <b>move_to</b>(&genesis_account, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEventHandlers">PluginEventHandlers</a>&lt;PluginT&gt;{
        publish_version: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginPublishVersionEvent">PluginPublishVersionEvent</a>&lt;PluginT&gt;&gt;(&genesis_account),
        star: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_StarPluginEvent">StarPluginEvent</a>&lt;PluginT&gt;&gt;(&genesis_account),
        unstar: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_UnstarPluginEvent">UnstarPluginEvent</a>&lt;PluginT&gt;&gt;(&genesis_account),
        update_plugin: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_UpdatePluginInfoEvent">UpdatePluginInfoEvent</a>&lt;PluginT&gt;&gt;(&genesis_account),
    });

    // registry register event emit
    <b>let</b> registry_event_handlers = <b>borrow_global_mut</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_RegistryEventHandlers">RegistryEventHandlers</a>&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> registry_event_handlers.register,
        <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginRegisterEvent">PluginRegisterEvent</a> {
            id: <b>copy</b> plugin_id,
            type: <a href="TypeInfo.md#0x1_TypeInfo_type_of">TypeInfo::type_of</a>&lt;PluginT&gt;(),
            name: <b>copy</b> name,
            description: <b>copy</b> description,
            labels: <b>copy</b> labels,
        },
    );

    plugin_id
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_exists_plugin"></a>

## Function `exists_plugin`



<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_exists_plugin">exists_plugin</a>&lt;PluginT&gt;(): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_exists_plugin">exists_plugin</a>&lt;PluginT&gt;(): bool {
    <b>return</b> <b>exists</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>&lt;PluginT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>())
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_take_plugin_id"></a>

## Function `take_plugin_id`



<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_take_plugin_id">take_plugin_id</a>&lt;PluginT&gt;(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_take_plugin_id">take_plugin_id</a>&lt;PluginT&gt;(): u64 <b>acquires</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a> {
    <b>let</b> plugin = <b>borrow_global</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>&lt;PluginT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <b>return</b> plugin.id
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_publish_plugin_version"></a>

## Function `publish_plugin_version`



<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_publish_plugin_version">publish_plugin_version</a>&lt;PluginT&gt;(_witness: &PluginT, tag: vector&lt;u8&gt;, implement_extpoints: vector&lt;vector&lt;u8&gt;&gt;, depend_extpoints: vector&lt;vector&lt;u8&gt;&gt;, js_entry_uri: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_publish_plugin_version">publish_plugin_version</a>&lt;PluginT&gt;(
    _witness: &PluginT,
    tag: vector&lt;u8&gt;,
    implement_extpoints: vector&lt;vector&lt;u8&gt;&gt;,
    depend_extpoints: vector&lt;vector&lt;u8&gt;&gt;,
    js_entry_uri: vector&lt;u8&gt;,
) <b>acquires</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEventHandlers">PluginEventHandlers</a> {
    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_string_length">assert_string_length</a>(&tag, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_INPUT_LEN">MAX_INPUT_LEN</a>);
    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_string_array_length">assert_string_array_length</a>(&implement_extpoints, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_ITEMS_COUNT">MAX_ITEMS_COUNT</a>, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_INPUT_LEN">MAX_INPUT_LEN</a>);
    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_string_array_length">assert_string_array_length</a>(&depend_extpoints, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_ITEMS_COUNT">MAX_ITEMS_COUNT</a>, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_INPUT_LEN">MAX_INPUT_LEN</a>);
    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_string_length">assert_string_length</a>(&js_entry_uri, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_TEXT_LEN">MAX_TEXT_LEN</a>);

    <b>let</b> plugin = <b>borrow_global_mut</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>&lt;PluginT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());

    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_tag_no_repeat">assert_tag_no_repeat</a>(&plugin.versions, <b>copy</b> tag);

    // Remove the <b>old</b> version when the number of versions is greater than <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_VERSION_COUNT">MAX_VERSION_COUNT</a>
    <b>if</b> (<a href="Vector.md#0x1_Vector_length">Vector::length</a>(&plugin.versions) &gt;= <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_VERSION_COUNT">MAX_VERSION_COUNT</a>) {
        <b>let</b> oldest_version = <a href="Vector.md#0x1_Vector_remove">Vector::remove</a>(&<b>mut</b> plugin.versions, 0);
        <b>let</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginVersion">PluginVersion</a> {
            number: _,
            tag: _,
            implement_extpoints: _,
            depend_extpoints: _,
            js_entry_uri: _,
            created_at: _,
        } = oldest_version;
    };

    <b>let</b> version_number = <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_next_plugin_version_number">next_plugin_version_number</a>(plugin);
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginVersion">PluginVersion</a>&gt;(&<b>mut</b> plugin.versions, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginVersion">PluginVersion</a>{
        number: <b>copy</b> version_number,
        tag: tag,
        implement_extpoints: implement_extpoints,
        depend_extpoints: depend_extpoints,
        js_entry_uri: js_entry_uri,
        created_at: <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>(),
    });

    plugin.updated_at = <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>();

    // plugin register event emit
    <b>let</b> plugin_event_handlers = <b>borrow_global_mut</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEventHandlers">PluginEventHandlers</a>&lt;PluginT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> plugin_event_handlers.publish_version,
        <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginPublishVersionEvent">PluginPublishVersionEvent</a> {
            plugin_type: <a href="TypeInfo.md#0x1_TypeInfo_type_of">TypeInfo::type_of</a>&lt;PluginT&gt;(),
            version_number: <b>copy</b> version_number,
        },
    );
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_exists_plugin_version"></a>

## Function `exists_plugin_version`



<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_exists_plugin_version">exists_plugin_version</a>&lt;PluginT&gt;(version_number: u64): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_exists_plugin_version">exists_plugin_version</a>&lt;PluginT&gt;(
    version_number: u64,
): bool <b>acquires</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a> {
    <b>let</b> plugin = <b>borrow_global_mut</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>&lt;PluginT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <b>return</b> version_number &gt; 0 && version_number &lt; plugin.next_version_number
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_star_plugin"></a>

## Function `star_plugin`



<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_star_plugin">star_plugin</a>&lt;PluginT&gt;(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_star_plugin">star_plugin</a>&lt;PluginT&gt;(sender: &signer) <b>acquires</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEventHandlers">PluginEventHandlers</a> {
    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>assert</b>!(!<b>exists</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_Star">Star</a>&lt;PluginT&gt;&gt;(sender_addr), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_STAR_ALREADY_STARED">ERR_STAR_ALREADY_STARED</a>));

    <b>move_to</b>(sender, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_Star">Star</a>&lt;PluginT&gt;{
        created_at: <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>(),
    });

    <b>let</b> plugin = <b>borrow_global_mut</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>&lt;PluginT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    plugin.star_count = plugin.star_count + 1;
    plugin.updated_at = <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>();

    // star plugin event emit
    <b>let</b> plugin_event_handlers = <b>borrow_global_mut</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEventHandlers">PluginEventHandlers</a>&lt;PluginT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> plugin_event_handlers.star,
        <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_StarPluginEvent">StarPluginEvent</a> {
            sender: sender_addr,
        },
    );
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_unstar_plugin"></a>

## Function `unstar_plugin`



<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_unstar_plugin">unstar_plugin</a>&lt;PluginT&gt;(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_unstar_plugin">unstar_plugin</a>&lt;PluginT&gt;(sender: &signer) <b>acquires</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_Star">Star</a>, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEventHandlers">PluginEventHandlers</a> {
    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>assert</b>!(<b>exists</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_Star">Star</a>&lt;PluginT&gt;&gt;(sender_addr), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_ERR_STAR_NOT_FOUND_STAR">ERR_STAR_NOT_FOUND_STAR</a>));

    <b>let</b> star = <b>move_from</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_Star">Star</a>&lt;PluginT&gt;&gt;(sender_addr);
    <b>let</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_Star">Star</a>&lt;PluginT&gt; { created_at:_} = star;

    <b>let</b> plugin = <b>borrow_global_mut</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>&lt;PluginT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    plugin.star_count = plugin.star_count - 1;
    plugin.updated_at = <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>();

    // unstar plugin event emit
    <b>let</b> plugin_event_handlers = <b>borrow_global_mut</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEventHandlers">PluginEventHandlers</a>&lt;PluginT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> plugin_event_handlers.unstar,
        <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_UnstarPluginEvent">UnstarPluginEvent</a> {
            sender: sender_addr,
        },
    );
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_has_star_plugin"></a>

## Function `has_star_plugin`



<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_has_star_plugin">has_star_plugin</a>&lt;PluginT&gt;(sender: &signer): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_has_star_plugin">has_star_plugin</a>&lt;PluginT&gt;(sender: &signer): bool {
    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>return</b> <b>exists</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_Star">Star</a>&lt;PluginT&gt;&gt;(sender_addr)
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_update_plugin"></a>

## Function `update_plugin`



<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_update_plugin">update_plugin</a>&lt;PluginT&gt;(_witness: &PluginT, name: vector&lt;u8&gt;, description: vector&lt;u8&gt;, option_labels: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;vector&lt;u8&gt;&gt;&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_update_plugin">update_plugin</a>&lt;PluginT&gt;(_witness: &PluginT, name: vector&lt;u8&gt;, description: vector&lt;u8&gt;, option_labels: <a href="Option.md#0x1_Option">Option</a>&lt;vector&lt;vector&lt;u8&gt;&gt;&gt;) <b>acquires</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEventHandlers">PluginEventHandlers</a> {
    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_string_length">assert_string_length</a>(&name, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_INPUT_LEN">MAX_INPUT_LEN</a>);
    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_string_length">assert_string_length</a>(&description, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_TEXT_LEN">MAX_TEXT_LEN</a>);

    <b>let</b> plugin = <b>borrow_global_mut</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>&lt;PluginT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());

    plugin.name = name;
    plugin.description = description;

    <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&option_labels)){
        <b>let</b> labels = <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(option_labels);
        <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_assert_string_array_length">assert_string_array_length</a>(&labels, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_ITEMS_COUNT">MAX_ITEMS_COUNT</a>, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_MAX_INPUT_LEN">MAX_INPUT_LEN</a>);
        plugin.labels = labels;
    };

    plugin.updated_at = <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>();

    // <b>update</b> plugin event emit
    <b>let</b> plugin_event_handlers = <b>borrow_global_mut</b>&lt;<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEventHandlers">PluginEventHandlers</a>&lt;PluginT&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> plugin_event_handlers.update_plugin,
        <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_UpdatePluginInfoEvent">UpdatePluginInfoEvent</a> {
            id: *&plugin.id,
            type: <a href="TypeInfo.md#0x1_TypeInfo_type_of">TypeInfo::type_of</a>&lt;PluginT&gt;(),
            name: *&plugin.name,
            description: *&plugin.description,
            labels: *&plugin.labels,
        },
    );
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_star_plugin_entry"></a>

## Function `star_plugin_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_star_plugin_entry">star_plugin_entry</a>&lt;PluginT&gt;(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_star_plugin_entry">star_plugin_entry</a>&lt;PluginT&gt;(sender: signer) <b>acquires</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEventHandlers">PluginEventHandlers</a> {
    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_star_plugin">star_plugin</a>&lt;PluginT&gt;(&sender);
}
</code></pre>



</details>

<a name="0x1_DAOPluginMarketplace_unstar_plugin_entry"></a>

## Function `unstar_plugin_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_unstar_plugin_entry">unstar_plugin_entry</a>&lt;PluginT&gt;(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_unstar_plugin_entry">unstar_plugin_entry</a>&lt;PluginT&gt;(sender: signer) <b>acquires</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEntry">PluginEntry</a>, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_Star">Star</a>, <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_PluginEventHandlers">PluginEventHandlers</a> {
    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_unstar_plugin">unstar_plugin</a>&lt;PluginT&gt;(&sender);
}
</code></pre>



</details>
