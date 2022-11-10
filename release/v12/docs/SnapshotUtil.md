
<a name="0x1_SnapshotUtil"></a>

# Module `0x1::SnapshotUtil`



-  [Struct `StructTag0`](#0x1_SnapshotUtil_StructTag0)
-  [Struct `TypeTag0`](#0x1_SnapshotUtil_TypeTag0)
-  [Struct `StructTag1`](#0x1_SnapshotUtil_StructTag1)
-  [Struct `TypeTag1`](#0x1_SnapshotUtil_TypeTag1)
-  [Struct `StructTag2`](#0x1_SnapshotUtil_StructTag2)
-  [Constants](#@Constants_0)
-  [Function `get_sturct_tag`](#0x1_SnapshotUtil_get_sturct_tag)
-  [Function `generate_struct_tag`](#0x1_SnapshotUtil_generate_struct_tag)
-  [Function `get_dao_struct_tag`](#0x1_SnapshotUtil_get_dao_struct_tag)
-  [Function `get_access_path`](#0x1_SnapshotUtil_get_access_path)
-  [Function `get_access_path_dao_member_slice`](#0x1_SnapshotUtil_get_access_path_dao_member_slice)
-  [Function `get_access_path_dao_member_body_slice`](#0x1_SnapshotUtil_get_access_path_dao_member_body_slice)
-  [Function `struct_tag_to_string`](#0x1_SnapshotUtil_struct_tag_to_string)
-  [Function `to_hex_string_without_prefix`](#0x1_SnapshotUtil_to_hex_string_without_prefix)
-  [Function `address_to_hex_string`](#0x1_SnapshotUtil_address_to_hex_string)


<pre><code><b>use</b> <a href="BCS.md#0x1_BCS">0x1::BCS</a>;
<b>use</b> <a href="Token.md#0x1_Token">0x1::Token</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_SnapshotUtil_StructTag0"></a>

## Struct `StructTag0`

Struct Tag which identify a unique Struct.


<pre><code><b>struct</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_StructTag0">StructTag0</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>module_name: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>name: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>types: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_SnapshotUtil_TypeTag0"></a>

## Struct `TypeTag0`



<pre><code><b>struct</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_TypeTag0">TypeTag0</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>variant_index: u8</code>
</dt>
<dd>

</dd>
<dt>
<code>struct_tag: <a href="SnapshotUtil.md#0x1_SnapshotUtil_StructTag0">SnapshotUtil::StructTag0</a></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_SnapshotUtil_StructTag1"></a>

## Struct `StructTag1`



<pre><code><b>struct</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_StructTag1">StructTag1</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>module_name: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>name: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>types: vector&lt;<a href="SnapshotUtil.md#0x1_SnapshotUtil_TypeTag0">SnapshotUtil::TypeTag0</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_SnapshotUtil_TypeTag1"></a>

## Struct `TypeTag1`



<pre><code><b>struct</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_TypeTag1">TypeTag1</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>variant_index: u8</code>
</dt>
<dd>

</dd>
<dt>
<code>struct_tag: <a href="SnapshotUtil.md#0x1_SnapshotUtil_StructTag1">SnapshotUtil::StructTag1</a></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_SnapshotUtil_StructTag2"></a>

## Struct `StructTag2`



<pre><code><b>struct</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_StructTag2">StructTag2</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>module_name: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>name: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>types: vector&lt;<a href="SnapshotUtil.md#0x1_SnapshotUtil_TypeTag1">SnapshotUtil::TypeTag1</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_SnapshotUtil_HEX_SYMBOLS"></a>



<pre><code><b>const</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_HEX_SYMBOLS">HEX_SYMBOLS</a>: vector&lt;u8&gt; = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 97, 98, 99, 100, 101, 102];
</code></pre>



<a name="0x1_SnapshotUtil_get_sturct_tag"></a>

## Function `get_sturct_tag`



<pre><code><b>public</b> <b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_get_sturct_tag">get_sturct_tag</a>&lt;DAOT: store&gt;(): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_get_sturct_tag">get_sturct_tag</a>&lt;DAOT: store&gt;(): vector&lt;u8&gt; {
    <b>let</b> struct_tags = <a href="SnapshotUtil.md#0x1_SnapshotUtil_generate_struct_tag">generate_struct_tag</a>&lt;DAOT&gt;();
    <a href="BCS.md#0x1_BCS_to_bytes">BCS::to_bytes</a>(&struct_tags)
}
</code></pre>



</details>

<a name="0x1_SnapshotUtil_generate_struct_tag"></a>

## Function `generate_struct_tag`



<pre><code><b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_generate_struct_tag">generate_struct_tag</a>&lt;DAOT: store&gt;(): <a href="SnapshotUtil.md#0x1_SnapshotUtil_StructTag2">SnapshotUtil::StructTag2</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_generate_struct_tag">generate_struct_tag</a>&lt;DAOT: store&gt;(): <a href="SnapshotUtil.md#0x1_SnapshotUtil_StructTag2">StructTag2</a>{
    <b>let</b> dao_struct_tag = <a href="SnapshotUtil.md#0x1_SnapshotUtil_get_dao_struct_tag">get_dao_struct_tag</a>&lt;DAOT&gt;();
    <b>let</b> dao_type_tag = <a href="SnapshotUtil.md#0x1_SnapshotUtil_TypeTag0">TypeTag0</a> {
        variant_index: 7,
        struct_tag: dao_struct_tag,
    };
    <b>let</b> dao_type_tags = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;<a href="SnapshotUtil.md#0x1_SnapshotUtil_TypeTag0">TypeTag0</a>&gt;();
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> dao_type_tags, dao_type_tag);

    // 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DAOMember
    <b>let</b> dao_member_struct_tag = <a href="SnapshotUtil.md#0x1_SnapshotUtil_StructTag1">StructTag1</a> {
        addr: @0x00000000000000000000000000000001,
        module_name: b"<a href="DAOSpace.md#0x1_DAOSpace">DAOSpace</a>",
        name: b"DAOMember",
        types: *&dao_type_tags
    };

    // 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DAOMemberBody
    <b>let</b> dao_member_body_struct_tag = <a href="SnapshotUtil.md#0x1_SnapshotUtil_StructTag1">StructTag1</a> {
        addr: @0x00000000000000000000000000000001,
        module_name: b"<a href="DAOSpace.md#0x1_DAOSpace">DAOSpace</a>",
        name: b"DAOMemberBody",
        types: *&dao_type_tags
    };

    <b>let</b> dao_member_type_tag = <a href="SnapshotUtil.md#0x1_SnapshotUtil_TypeTag1">TypeTag1</a> {
        variant_index: 7,
        struct_tag: dao_member_struct_tag,
    };
    <b>let</b> dao_member_body_type_tag = <a href="SnapshotUtil.md#0x1_SnapshotUtil_TypeTag1">TypeTag1</a> {
        variant_index: 7,
        struct_tag: dao_member_body_struct_tag,
    };
    <b>let</b> type_tags = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;<a href="SnapshotUtil.md#0x1_SnapshotUtil_TypeTag1">TypeTag1</a>&gt;();
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> type_tags, dao_member_type_tag);
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> type_tags, dao_member_body_type_tag);

    <a href="SnapshotUtil.md#0x1_SnapshotUtil_StructTag2">StructTag2</a> {
        addr: @0x00000000000000000000000000000001,
        module_name: b"<a href="NFT.md#0x1_IdentifierNFT">IdentifierNFT</a>",
        name: b"<a href="NFT.md#0x1_IdentifierNFT">IdentifierNFT</a>",
        types: type_tags,
    }
}
</code></pre>



</details>

<a name="0x1_SnapshotUtil_get_dao_struct_tag"></a>

## Function `get_dao_struct_tag`



<pre><code><b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_get_dao_struct_tag">get_dao_struct_tag</a>&lt;DAOT: store&gt;(): <a href="SnapshotUtil.md#0x1_SnapshotUtil_StructTag0">SnapshotUtil::StructTag0</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_get_dao_struct_tag">get_dao_struct_tag</a>&lt;DAOT: store&gt;(): <a href="SnapshotUtil.md#0x1_SnapshotUtil_StructTag0">StructTag0</a>{
    // DAOT is also TokenT
    <b>let</b> token_code = <a href="Token.md#0x1_Token_token_code">Token::token_code</a>&lt;DAOT&gt;();
    <b>let</b> token_code_bcs = <a href="BCS.md#0x1_BCS_to_bytes">BCS::to_bytes</a>(&token_code);

    <b>let</b> offset = 0;
    <b>let</b> (<b>address</b>, offset) = <a href="BCS.md#0x1_BCS_deserialize_address">BCS::deserialize_address</a>(&token_code_bcs, offset);
    <b>let</b> (module_name, offset) = <a href="BCS.md#0x1_BCS_deserialize_bytes">BCS::deserialize_bytes</a>(&token_code_bcs, offset);
    <b>let</b> (name, _offset) = <a href="BCS.md#0x1_BCS_deserialize_bytes">BCS::deserialize_bytes</a>(&token_code_bcs, offset);

    <a href="SnapshotUtil.md#0x1_SnapshotUtil_StructTag0">StructTag0</a> {
        addr: <b>address</b>,
        module_name,
        name,
        types: <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;(),
    }
}
</code></pre>



</details>

<a name="0x1_SnapshotUtil_get_access_path"></a>

## Function `get_access_path`



<pre><code><b>public</b> <b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_get_access_path">get_access_path</a>&lt;DaoT: store&gt;(user_addr: <b>address</b>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_get_access_path">get_access_path</a>&lt;DaoT: store&gt;(user_addr: <b>address</b>): vector&lt;u8&gt; {

    //    0x6bfb460477adf9dd0455d3de2fc7f211/1/<a href="NFT.md#0x1_IdentifierNFT_IdentifierNFT">0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT</a>&lt;
    //        0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMember&lt;0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO&gt;
    //        ,0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMemberBody&lt;0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO&gt;&gt;

    <b>let</b> access_path_slice_0 = b"/1/<a href="NFT.md#0x1_IdentifierNFT_IdentifierNFT">0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT</a>";
    <b>let</b> access_path_bytes = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>();
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> access_path_bytes, <a href="SnapshotUtil.md#0x1_SnapshotUtil_address_to_hex_string">address_to_hex_string</a>(*&user_addr));
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> access_path_bytes, access_path_slice_0);
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> access_path_bytes, b"&lt;");
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> access_path_bytes, <a href="SnapshotUtil.md#0x1_SnapshotUtil_get_access_path_dao_member_slice">get_access_path_dao_member_slice</a>&lt;DaoT&gt;());
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> access_path_bytes, b",");
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> access_path_bytes, <a href="SnapshotUtil.md#0x1_SnapshotUtil_get_access_path_dao_member_body_slice">get_access_path_dao_member_body_slice</a>&lt;DaoT&gt;());
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> access_path_bytes, b"&gt;");

    access_path_bytes
}
</code></pre>



</details>

<a name="0x1_SnapshotUtil_get_access_path_dao_member_slice"></a>

## Function `get_access_path_dao_member_slice`



<pre><code><b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_get_access_path_dao_member_slice">get_access_path_dao_member_slice</a>&lt;DaoT: store&gt;(): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_get_access_path_dao_member_slice">get_access_path_dao_member_slice</a>&lt;DaoT:store&gt;(): vector&lt;u8&gt;{
    <b>let</b> dao_member_slice_0 = b"<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">0x00000000000000000000000000000001::DAOSpace::DAOMember</a>";
    <b>let</b> slice = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>();
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> slice, dao_member_slice_0);
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> slice, b"&lt;");
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> slice, <a href="SnapshotUtil.md#0x1_SnapshotUtil_struct_tag_to_string">struct_tag_to_string</a>&lt;DaoT&gt;());
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> slice, b"&gt;");

    slice
}
</code></pre>



</details>

<a name="0x1_SnapshotUtil_get_access_path_dao_member_body_slice"></a>

## Function `get_access_path_dao_member_body_slice`



<pre><code><b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_get_access_path_dao_member_body_slice">get_access_path_dao_member_body_slice</a>&lt;DaoT: store&gt;(): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_get_access_path_dao_member_body_slice">get_access_path_dao_member_body_slice</a>&lt;DaoT:store&gt;(): vector&lt;u8&gt;{
    <b>let</b> dao_member_body_slice_0 = b"<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">0x00000000000000000000000000000001::DAOSpace::DAOMemberBody</a>";
    <b>let</b> slice = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>();
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> slice, dao_member_body_slice_0);
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> slice, b"&lt;");
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> slice, <a href="SnapshotUtil.md#0x1_SnapshotUtil_struct_tag_to_string">struct_tag_to_string</a>&lt;DaoT&gt;());
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> slice, b"&gt;");

    slice
}
</code></pre>



</details>

<a name="0x1_SnapshotUtil_struct_tag_to_string"></a>

## Function `struct_tag_to_string`



<pre><code><b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_struct_tag_to_string">struct_tag_to_string</a>&lt;DaoT: store&gt;(): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_struct_tag_to_string">struct_tag_to_string</a>&lt;DaoT:store&gt;(): vector&lt;u8&gt; {
    <b>let</b> struct_tag = <a href="SnapshotUtil.md#0x1_SnapshotUtil_get_dao_struct_tag">get_dao_struct_tag</a>&lt;DaoT&gt;();
    <b>let</b> struct_tag_slice = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>();
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> struct_tag_slice, <a href="SnapshotUtil.md#0x1_SnapshotUtil_address_to_hex_string">address_to_hex_string</a>(*&struct_tag.addr));
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> struct_tag_slice, b"::");
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> struct_tag_slice, *&struct_tag.module_name);
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> struct_tag_slice, b"::");
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> struct_tag_slice, *&struct_tag.name);

    struct_tag_slice
}
</code></pre>



</details>

<a name="0x1_SnapshotUtil_to_hex_string_without_prefix"></a>

## Function `to_hex_string_without_prefix`

Converts a <code>u8</code> to its  hexadecimal representation with fixed length (in whole bytes).
so the returned String is <code>2 * length</code>  in size


<pre><code><b>public</b> <b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_to_hex_string_without_prefix">to_hex_string_without_prefix</a>(value: u8): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_to_hex_string_without_prefix">to_hex_string_without_prefix</a>(value: u8): vector&lt;u8&gt; {
    <b>if</b> (value == 0) {
        <b>return</b> b"00"
    };

    <b>let</b> buffer = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>let</b> len = 1;
    <b>let</b> i: u64 = 0;
    <b>while</b> (i &lt; len * 2) {
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> buffer, *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&<a href="SnapshotUtil.md#0x1_SnapshotUtil_HEX_SYMBOLS">HEX_SYMBOLS</a>, (value & 0xf <b>as</b> u64)));
        value = value &gt;&gt; 4;
        i = i + 1;
    };
    <b>assert</b>!(value == 0, 1);
    <a href="Vector.md#0x1_Vector_reverse">Vector::reverse</a>(&<b>mut</b> buffer);
    buffer
}
</code></pre>



</details>

<a name="0x1_SnapshotUtil_address_to_hex_string"></a>

## Function `address_to_hex_string`

Converts a <code><b>address</b></code> to its  hexadecimal representation with fixed length (in whole bytes).
so the returned String is <code>2 * length + 2</code>(with '0x') in size


<pre><code><b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_address_to_hex_string">address_to_hex_string</a>(addr: <b>address</b>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil_address_to_hex_string">address_to_hex_string</a>(addr: <b>address</b>): vector&lt;u8&gt;{
    <b>let</b> hex_string = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> hex_string, b"0x");
    <b>let</b> addr_bytes = <a href="BCS.md#0x1_BCS_to_bytes">BCS::to_bytes</a>&lt;<b>address</b>&gt;(&addr);
    <b>let</b> i = 0;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&addr_bytes);
    <b>while</b> (i &lt; len) {
        <b>let</b> hex_slice = <a href="SnapshotUtil.md#0x1_SnapshotUtil_to_hex_string_without_prefix">to_hex_string_without_prefix</a>(*<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&addr_bytes, i));
        <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> hex_string, hex_slice);
        i = i + 1;
    };
    hex_string
}
</code></pre>



</details>
