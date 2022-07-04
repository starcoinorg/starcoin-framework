
<a name="0x1_BCS"></a>

# Module `0x1::BCS`

Utility for converting a Move value to its binary representation in BCS (Diem Canonical
Serialization). BCS is the binary encoding for Move resources and other non-module values
published on-chain.


-  [Constants](#@Constants_0)
-  [Function `to_bytes`](#0x1_BCS_to_bytes)
-  [Function `to_address`](#0x1_BCS_to_address)
-  [Function `deserialize_option_bytes_vector`](#0x1_BCS_deserialize_option_bytes_vector)
-  [Function `deserialize_bytes_vector`](#0x1_BCS_deserialize_bytes_vector)
-  [Function `deserialize_u64_vector`](#0x1_BCS_deserialize_u64_vector)
-  [Function `deserialize_u128_vector`](#0x1_BCS_deserialize_u128_vector)
-  [Function `deserialize_option_bytes`](#0x1_BCS_deserialize_option_bytes)
-  [Function `deserialize_address`](#0x1_BCS_deserialize_address)
-  [Function `deserialize_16_bytes`](#0x1_BCS_deserialize_16_bytes)
-  [Function `deserialize_bytes`](#0x1_BCS_deserialize_bytes)
-  [Function `deserialize_u128`](#0x1_BCS_deserialize_u128)
-  [Function `deserialize_u64`](#0x1_BCS_deserialize_u64)
-  [Function `deserialize_u32`](#0x1_BCS_deserialize_u32)
-  [Function `deserialize_u16`](#0x1_BCS_deserialize_u16)
-  [Function `deserialize_u8`](#0x1_BCS_deserialize_u8)
-  [Function `deserialize_option_tag`](#0x1_BCS_deserialize_option_tag)
-  [Function `deserialize_len`](#0x1_BCS_deserialize_len)
-  [Function `deserialize_bool`](#0x1_BCS_deserialize_bool)
-  [Function `get_byte`](#0x1_BCS_get_byte)
-  [Function `get_n_bytes`](#0x1_BCS_get_n_bytes)
-  [Function `get_n_bytes_as_u128`](#0x1_BCS_get_n_bytes_as_u128)
-  [Function `deserialize_uleb128_as_u32`](#0x1_BCS_deserialize_uleb128_as_u32)
-  [Function `serialize_u32_as_uleb128`](#0x1_BCS_serialize_u32_as_uleb128)
-  [Function `skip_option_bytes_vector`](#0x1_BCS_skip_option_bytes_vector)
-  [Function `skip_option_bytes`](#0x1_BCS_skip_option_bytes)
-  [Function `skip_bytes_vector`](#0x1_BCS_skip_bytes_vector)
-  [Function `skip_bytes`](#0x1_BCS_skip_bytes)
-  [Function `skip_n_bytes`](#0x1_BCS_skip_n_bytes)
-  [Function `skip_u64_vector`](#0x1_BCS_skip_u64_vector)
-  [Function `skip_u128_vector`](#0x1_BCS_skip_u128_vector)
-  [Function `skip_u256`](#0x1_BCS_skip_u256)
-  [Function `skip_u128`](#0x1_BCS_skip_u128)
-  [Function `skip_u64`](#0x1_BCS_skip_u64)
-  [Function `skip_u32`](#0x1_BCS_skip_u32)
-  [Function `skip_u16`](#0x1_BCS_skip_u16)
-  [Function `skip_address`](#0x1_BCS_skip_address)
-  [Function `skip_bool`](#0x1_BCS_skip_bool)
-  [Function `can_skip`](#0x1_BCS_can_skip)
-  [Module Specification](#@Module_Specification_1)


<pre><code><b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="0x1_BCS_ERR_INPUT_NOT_LARGE_ENOUGH"></a>



<pre><code><b>const</b> <a href="BCS.md#0x1_BCS_ERR_INPUT_NOT_LARGE_ENOUGH">ERR_INPUT_NOT_LARGE_ENOUGH</a>: u64 = 201;
</code></pre>



<a name="0x1_BCS_ERR_INVALID_ULEB128_NUMBER_UNEXPECTED_ZERO_DIGIT"></a>



<pre><code><b>const</b> <a href="BCS.md#0x1_BCS_ERR_INVALID_ULEB128_NUMBER_UNEXPECTED_ZERO_DIGIT">ERR_INVALID_ULEB128_NUMBER_UNEXPECTED_ZERO_DIGIT</a>: u64 = 207;
</code></pre>



<a name="0x1_BCS_ERR_OVERFLOW_PARSING_ULEB128_ENCODED_UINT32"></a>



<pre><code><b>const</b> <a href="BCS.md#0x1_BCS_ERR_OVERFLOW_PARSING_ULEB128_ENCODED_UINT32">ERR_OVERFLOW_PARSING_ULEB128_ENCODED_UINT32</a>: u64 = 206;
</code></pre>



<a name="0x1_BCS_ERR_UNEXPECTED_BOOL_VALUE"></a>



<pre><code><b>const</b> <a href="BCS.md#0x1_BCS_ERR_UNEXPECTED_BOOL_VALUE">ERR_UNEXPECTED_BOOL_VALUE</a>: u64 = 205;
</code></pre>



<a name="0x1_BCS_INTEGER32_MAX_VALUE"></a>



<pre><code><b>const</b> <a href="BCS.md#0x1_BCS_INTEGER32_MAX_VALUE">INTEGER32_MAX_VALUE</a>: u64 = 2147483647;
</code></pre>



<a name="0x1_BCS_to_bytes"></a>

## Function `to_bytes`

Return the binary representation of <code>v</code> in BCS (Starcoin Canonical Serialization) format


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_to_bytes">to_bytes</a>&lt;MoveValue: store&gt;(v: &MoveValue): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>native</b> <b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_to_bytes">to_bytes</a>&lt;MoveValue: store&gt;(v: &MoveValue): vector&lt;u8&gt;;
</code></pre>



</details>

<a name="0x1_BCS_to_address"></a>

## Function `to_address`

Return the address of key bytes


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_to_address">to_address</a>(key_bytes: vector&lt;u8&gt;): <b>address</b>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>native</b> <b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_to_address">to_address</a>(key_bytes: vector&lt;u8&gt;): <b>address</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_option_bytes_vector"></a>

## Function `deserialize_option_bytes_vector`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_option_bytes_vector">deserialize_option_bytes_vector</a>(input: &vector&lt;u8&gt;, offset: u64): (vector&lt;<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;&gt;, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_option_bytes_vector">deserialize_option_bytes_vector</a>(input: &vector&lt;u8&gt;, offset: u64): (vector&lt;<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;&gt;, u64) {
    <b>let</b> (len, new_offset) = <a href="BCS.md#0x1_BCS_deserialize_len">deserialize_len</a>(input, offset);
    <b>let</b> i = 0;
    <b>let</b> vec = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;&gt;();
    <b>while</b> (i &lt; len) {
        <b>let</b> (opt_bs, o) = <a href="BCS.md#0x1_BCS_deserialize_option_bytes">deserialize_option_bytes</a>(input, new_offset);
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> vec, opt_bs);
        new_offset = o;
        i = i + 1;
    };
    (vec, new_offset)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_bytes_vector"></a>

## Function `deserialize_bytes_vector`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_bytes_vector">deserialize_bytes_vector</a>(input: &vector&lt;u8&gt;, offset: u64): (vector&lt;vector&lt;u8&gt;&gt;, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_bytes_vector">deserialize_bytes_vector</a>(input: &vector&lt;u8&gt;, offset: u64): (vector&lt;vector&lt;u8&gt;&gt;, u64) {
    <b>let</b> (len, new_offset) = <a href="BCS.md#0x1_BCS_deserialize_len">deserialize_len</a>(input, offset);
    <b>let</b> i = 0;
    <b>let</b> vec = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();
    <b>while</b> (i &lt; len) {
        <b>let</b> (opt_bs, o) = <a href="BCS.md#0x1_BCS_deserialize_bytes">deserialize_bytes</a>(input, new_offset);
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> vec, opt_bs);
        new_offset = o;
        i = i + 1;
    };
    (vec, new_offset)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_u64_vector"></a>

## Function `deserialize_u64_vector`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_u64_vector">deserialize_u64_vector</a>(input: &vector&lt;u8&gt;, offset: u64): (vector&lt;u64&gt;, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_u64_vector">deserialize_u64_vector</a>(input: &vector&lt;u8&gt;, offset: u64): (vector&lt;u64&gt;, u64) {
    <b>let</b> (len, new_offset) = <a href="BCS.md#0x1_BCS_deserialize_len">deserialize_len</a>(input, offset);
    <b>let</b> i = 0;
    <b>let</b> vec = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u64&gt;();
    <b>while</b> (i &lt; len) {
        <b>let</b> (opt_bs, o) = <a href="BCS.md#0x1_BCS_deserialize_u64">deserialize_u64</a>(input, new_offset);
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> vec, opt_bs);
        new_offset = o;
        i = i + 1;
    };
    (vec, new_offset)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_u128_vector"></a>

## Function `deserialize_u128_vector`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_u128_vector">deserialize_u128_vector</a>(input: &vector&lt;u8&gt;, offset: u64): (vector&lt;u128&gt;, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_u128_vector">deserialize_u128_vector</a>(input: &vector&lt;u8&gt;, offset: u64): (vector&lt;u128&gt;, u64) {
    <b>let</b> (len, new_offset) = <a href="BCS.md#0x1_BCS_deserialize_len">deserialize_len</a>(input, offset);
    <b>let</b> i = 0;
    <b>let</b> vec = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u128&gt;();
    <b>while</b> (i &lt; len) {
        <b>let</b> (opt_bs, o) = <a href="BCS.md#0x1_BCS_deserialize_u128">deserialize_u128</a>(input, new_offset);
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> vec, opt_bs);
        new_offset = o;
        i = i + 1;
    };
    (vec, new_offset)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_option_bytes"></a>

## Function `deserialize_option_bytes`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_option_bytes">deserialize_option_bytes</a>(input: &vector&lt;u8&gt;, offset: u64): (<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_option_bytes">deserialize_option_bytes</a>(input: &vector&lt;u8&gt;, offset: u64): (<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, u64) {
    <b>let</b> (tag, new_offset) = <a href="BCS.md#0x1_BCS_deserialize_option_tag">deserialize_option_tag</a>(input, offset);
    <b>if</b> (!tag) {
        <b>return</b> (<a href="Option.md#0x1_Option_none">Option::none</a>&lt;vector&lt;u8&gt;&gt;(), new_offset)
    } <b>else</b> {
        <b>let</b> (bs, new_offset) = <a href="BCS.md#0x1_BCS_deserialize_bytes">deserialize_bytes</a>(input, new_offset);
        <b>return</b> (<a href="Option.md#0x1_Option_some">Option::some</a>&lt;vector&lt;u8&gt;&gt;(bs), new_offset)
    }
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_address"></a>

## Function `deserialize_address`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_address">deserialize_address</a>(input: &vector&lt;u8&gt;, offset: u64): (<b>address</b>, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_address">deserialize_address</a>(input: &vector&lt;u8&gt;, offset: u64): (<b>address</b>, u64) {
    <b>let</b> (content, new_offset) = <a href="BCS.md#0x1_BCS_deserialize_16_bytes">deserialize_16_bytes</a>(input, offset);
    (<a href="BCS.md#0x1_BCS_to_address">BCS::to_address</a>(content), new_offset)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_16_bytes"></a>

## Function `deserialize_16_bytes`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_16_bytes">deserialize_16_bytes</a>(input: &vector&lt;u8&gt;, offset: u64): (vector&lt;u8&gt;, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_16_bytes">deserialize_16_bytes</a>(input: &vector&lt;u8&gt;, offset: u64): (vector&lt;u8&gt;, u64) {
    <b>let</b> content = <a href="BCS.md#0x1_BCS_get_n_bytes">get_n_bytes</a>(input, offset, 16);
    (content, offset + 16)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_bytes"></a>

## Function `deserialize_bytes`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_bytes">deserialize_bytes</a>(input: &vector&lt;u8&gt;, offset: u64): (vector&lt;u8&gt;, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_bytes">deserialize_bytes</a>(input: &vector&lt;u8&gt;, offset: u64): (vector&lt;u8&gt;, u64) {
    <b>let</b> (len, new_offset) = <a href="BCS.md#0x1_BCS_deserialize_len">deserialize_len</a>(input, offset);
    <b>let</b> content = <a href="BCS.md#0x1_BCS_get_n_bytes">get_n_bytes</a>(input, new_offset, len);
    (content, new_offset + len)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_u128"></a>

## Function `deserialize_u128`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_u128">deserialize_u128</a>(input: &vector&lt;u8&gt;, offset: u64): (u128, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_u128">deserialize_u128</a>(input: &vector&lt;u8&gt;, offset: u64): (u128, u64) {
    <b>let</b> u = <a href="BCS.md#0x1_BCS_get_n_bytes_as_u128">get_n_bytes_as_u128</a>(input, offset, 16);
    (u, offset + 16)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_u64"></a>

## Function `deserialize_u64`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_u64">deserialize_u64</a>(input: &vector&lt;u8&gt;, offset: u64): (u64, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_u64">deserialize_u64</a>(input: &vector&lt;u8&gt;, offset: u64): (u64, u64) {
    <b>let</b> u = <a href="BCS.md#0x1_BCS_get_n_bytes_as_u128">get_n_bytes_as_u128</a>(input, offset, 8);
    ((u <b>as</b> u64), offset + 8)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_u32"></a>

## Function `deserialize_u32`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_u32">deserialize_u32</a>(input: &vector&lt;u8&gt;, offset: u64): (u64, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_u32">deserialize_u32</a>(input: &vector&lt;u8&gt;, offset: u64): (u64, u64) {
    <b>let</b> u = <a href="BCS.md#0x1_BCS_get_n_bytes_as_u128">get_n_bytes_as_u128</a>(input, offset, 4);
    ((u <b>as</b> u64), offset + 4)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_u16"></a>

## Function `deserialize_u16`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_u16">deserialize_u16</a>(input: &vector&lt;u8&gt;, offset: u64): (u64, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_u16">deserialize_u16</a>(input: &vector&lt;u8&gt;, offset: u64): (u64, u64) {
    <b>let</b> u = <a href="BCS.md#0x1_BCS_get_n_bytes_as_u128">get_n_bytes_as_u128</a>(input, offset, 2);
    ((u <b>as</b> u64), offset + 2)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_u8"></a>

## Function `deserialize_u8`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_u8">deserialize_u8</a>(input: &vector&lt;u8&gt;, offset: u64): (u8, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_u8">deserialize_u8</a>(input: &vector&lt;u8&gt;, offset: u64): (u8, u64) {
    <b>let</b> u = <a href="BCS.md#0x1_BCS_get_byte">get_byte</a>(input, offset);
    (u, offset + 1)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_option_tag"></a>

## Function `deserialize_option_tag`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_option_tag">deserialize_option_tag</a>(input: &vector&lt;u8&gt;, offset: u64): (bool, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_option_tag">deserialize_option_tag</a>(input: &vector&lt;u8&gt;, offset: u64): (bool, u64) {
    <a href="BCS.md#0x1_BCS_deserialize_bool">deserialize_bool</a>(input, offset)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_len"></a>

## Function `deserialize_len`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_len">deserialize_len</a>(input: &vector&lt;u8&gt;, offset: u64): (u64, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_len">deserialize_len</a>(input: &vector&lt;u8&gt;, offset: u64): (u64, u64) {
    <a href="BCS.md#0x1_BCS_deserialize_uleb128_as_u32">deserialize_uleb128_as_u32</a>(input, offset)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_bool"></a>

## Function `deserialize_bool`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_bool">deserialize_bool</a>(input: &vector&lt;u8&gt;, offset: u64): (bool, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_bool">deserialize_bool</a>(input: &vector&lt;u8&gt;, offset: u64): (bool, u64) {
    <b>let</b> b = <a href="BCS.md#0x1_BCS_get_byte">get_byte</a>(input, offset);
    <b>if</b> (b == 1) {
        <b>return</b> (<b>true</b>, offset + 1)
    } <b>else</b> <b>if</b> (b == 0) {
        <b>return</b> (<b>false</b>, offset + 1)
    } <b>else</b> {
        <b>abort</b> <a href="BCS.md#0x1_BCS_ERR_UNEXPECTED_BOOL_VALUE">ERR_UNEXPECTED_BOOL_VALUE</a>
    }
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_get_byte"></a>

## Function `get_byte`



<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_get_byte">get_byte</a>(input: &vector&lt;u8&gt;, offset: u64): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_get_byte">get_byte</a>(input: &vector&lt;u8&gt;, offset: u64): u8 {
    <b>assert</b>!(((offset + 1) &lt;= <a href="Vector.md#0x1_Vector_length">Vector::length</a>(input)) && (offset &lt; offset + 1), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="BCS.md#0x1_BCS_ERR_INPUT_NOT_LARGE_ENOUGH">ERR_INPUT_NOT_LARGE_ENOUGH</a>));
    *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(input, offset)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_get_n_bytes"></a>

## Function `get_n_bytes`



<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_get_n_bytes">get_n_bytes</a>(input: &vector&lt;u8&gt;, offset: u64, n: u64): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_get_n_bytes">get_n_bytes</a>(input: &vector&lt;u8&gt;, offset: u64, n: u64): vector&lt;u8&gt; {
    <b>assert</b>!(((offset + n) &lt;= <a href="Vector.md#0x1_Vector_length">Vector::length</a>(input)) && (offset &lt; offset + n), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="BCS.md#0x1_BCS_ERR_INPUT_NOT_LARGE_ENOUGH">ERR_INPUT_NOT_LARGE_ENOUGH</a>));
    <b>let</b> i = 0;
    <b>let</b> content = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>while</b> (i &lt; n) {
        <b>let</b> b = *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(input, offset + i);
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> content, b);
        i = i + 1;
    };
    content
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_get_n_bytes_as_u128"></a>

## Function `get_n_bytes_as_u128`



<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_get_n_bytes_as_u128">get_n_bytes_as_u128</a>(input: &vector&lt;u8&gt;, offset: u64, n: u64): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_get_n_bytes_as_u128">get_n_bytes_as_u128</a>(input: &vector&lt;u8&gt;, offset: u64, n: u64): u128 {
    <b>assert</b>!(((offset + n) &lt;= <a href="Vector.md#0x1_Vector_length">Vector::length</a>(input)) && (offset &lt; offset + n), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="BCS.md#0x1_BCS_ERR_INPUT_NOT_LARGE_ENOUGH">ERR_INPUT_NOT_LARGE_ENOUGH</a>));
    <b>let</b> number: u128 = 0;
    <b>let</b> i = 0;
    <b>while</b> (i &lt; n) {
        <b>let</b> byte = *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(input, offset + i);
        <b>let</b> s = (i <b>as</b> u8) * 8;
        number = number + ((byte <b>as</b> u128) &lt;&lt; s);
        i = i + 1;
    };
    number
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_deserialize_uleb128_as_u32"></a>

## Function `deserialize_uleb128_as_u32`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_uleb128_as_u32">deserialize_uleb128_as_u32</a>(input: &vector&lt;u8&gt;, offset: u64): (u64, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_uleb128_as_u32">deserialize_uleb128_as_u32</a>(input: &vector&lt;u8&gt;, offset: u64): (u64, u64) {
    <b>let</b> value: u64 = 0;
    <b>let</b> shift = 0;
    <b>let</b> new_offset = offset;
    <b>while</b> (shift &lt; 32) {
        <b>let</b> x = <a href="BCS.md#0x1_BCS_get_byte">get_byte</a>(input, new_offset);
        new_offset = new_offset + 1;
        <b>let</b> digit: u8 = x & 0x7F;
        value = value | (digit <b>as</b> u64) &lt;&lt; shift;
        <b>if</b> ((value &lt; 0) || (value &gt; <a href="BCS.md#0x1_BCS_INTEGER32_MAX_VALUE">INTEGER32_MAX_VALUE</a>)) {
            <b>abort</b> <a href="BCS.md#0x1_BCS_ERR_OVERFLOW_PARSING_ULEB128_ENCODED_UINT32">ERR_OVERFLOW_PARSING_ULEB128_ENCODED_UINT32</a>
        };
        <b>if</b> (digit == x) {
            <b>if</b> (shift &gt; 0 && digit == 0) {
                <b>abort</b> <a href="BCS.md#0x1_BCS_ERR_INVALID_ULEB128_NUMBER_UNEXPECTED_ZERO_DIGIT">ERR_INVALID_ULEB128_NUMBER_UNEXPECTED_ZERO_DIGIT</a>
            };
            <b>return</b> (value, new_offset)
        };
        shift = shift + 7
    };
    <b>abort</b> <a href="BCS.md#0x1_BCS_ERR_OVERFLOW_PARSING_ULEB128_ENCODED_UINT32">ERR_OVERFLOW_PARSING_ULEB128_ENCODED_UINT32</a>
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_serialize_u32_as_uleb128"></a>

## Function `serialize_u32_as_uleb128`



<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_serialize_u32_as_uleb128">serialize_u32_as_uleb128</a>(value: u64): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_serialize_u32_as_uleb128">serialize_u32_as_uleb128</a>(value: u64): vector&lt;u8&gt; {
    <b>let</b> output = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>while</b> ((value &gt;&gt; 7) != 0) {
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> output, (((value & 0x7f) | 0x80) <b>as</b> u8));
        value = value &gt;&gt; 7;
    };
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> output, (value <b>as</b> u8));
    output
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_skip_option_bytes_vector"></a>

## Function `skip_option_bytes_vector`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_option_bytes_vector">skip_option_bytes_vector</a>(input: &vector&lt;u8&gt;, offset: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_option_bytes_vector">skip_option_bytes_vector</a>(input: &vector&lt;u8&gt;, offset: u64): u64 {
    <b>let</b> (len, new_offset) = <a href="BCS.md#0x1_BCS_deserialize_len">deserialize_len</a>(input, offset);
    <b>let</b> i = 0;
    <b>while</b> (i &lt; len) {
        new_offset = <a href="BCS.md#0x1_BCS_skip_option_bytes">skip_option_bytes</a>(input, new_offset);
        i = i + 1;
    };
    new_offset
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_skip_option_bytes"></a>

## Function `skip_option_bytes`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_option_bytes">skip_option_bytes</a>(input: &vector&lt;u8&gt;, offset: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_option_bytes">skip_option_bytes</a>(input: &vector&lt;u8&gt;, offset: u64):  u64 {
    <b>let</b> (tag, new_offset) = <a href="BCS.md#0x1_BCS_deserialize_option_tag">deserialize_option_tag</a>(input, offset);
    <b>if</b> (!tag) {
        new_offset
    } <b>else</b> {
        <a href="BCS.md#0x1_BCS_skip_bytes">skip_bytes</a>(input, new_offset)
    }
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_skip_bytes_vector"></a>

## Function `skip_bytes_vector`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_bytes_vector">skip_bytes_vector</a>(input: &vector&lt;u8&gt;, offset: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_bytes_vector">skip_bytes_vector</a>(input: &vector&lt;u8&gt;, offset: u64): u64 {
    <b>let</b> (len, new_offset) = <a href="BCS.md#0x1_BCS_deserialize_len">deserialize_len</a>(input, offset);
    <b>let</b> i = 0;
    <b>while</b> (i &lt; len) {
        new_offset = <a href="BCS.md#0x1_BCS_skip_bytes">skip_bytes</a>(input, new_offset);
        i = i + 1;
    };
    new_offset
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_skip_bytes"></a>

## Function `skip_bytes`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_bytes">skip_bytes</a>(input: &vector&lt;u8&gt;, offset: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_bytes">skip_bytes</a>(input: &vector&lt;u8&gt;, offset: u64): u64 {
    <b>let</b> (len, new_offset) = <a href="BCS.md#0x1_BCS_deserialize_len">deserialize_len</a>(input, offset);
    new_offset + len
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_skip_n_bytes"></a>

## Function `skip_n_bytes`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_n_bytes">skip_n_bytes</a>(input: &vector&lt;u8&gt;, offset: u64, n: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_n_bytes">skip_n_bytes</a>(input: &vector&lt;u8&gt;, offset: u64, n:u64): u64 {
    <a href="BCS.md#0x1_BCS_can_skip">can_skip</a>(input, offset, n );
    offset + n
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_skip_u64_vector"></a>

## Function `skip_u64_vector`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_u64_vector">skip_u64_vector</a>(input: &vector&lt;u8&gt;, offset: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_u64_vector">skip_u64_vector</a>(input: &vector&lt;u8&gt;, offset: u64): u64 {
    <b>let</b> (len, new_offset) = <a href="BCS.md#0x1_BCS_deserialize_len">deserialize_len</a>(input, offset);
    <a href="BCS.md#0x1_BCS_can_skip">can_skip</a>(input, new_offset, len * 8);
    new_offset + len * 8
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_skip_u128_vector"></a>

## Function `skip_u128_vector`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_u128_vector">skip_u128_vector</a>(input: &vector&lt;u8&gt;, offset: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_u128_vector">skip_u128_vector</a>(input: &vector&lt;u8&gt;, offset: u64): u64 {
    <b>let</b> (len, new_offset) = <a href="BCS.md#0x1_BCS_deserialize_len">deserialize_len</a>(input, offset);
    <a href="BCS.md#0x1_BCS_can_skip">can_skip</a>(input, new_offset, len * 16);
    new_offset + len * 16
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_skip_u256"></a>

## Function `skip_u256`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_u256">skip_u256</a>(input: &vector&lt;u8&gt;, offset: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_u256">skip_u256</a>(input: &vector&lt;u8&gt;, offset: u64): u64 {
    <a href="BCS.md#0x1_BCS_can_skip">can_skip</a>(input, offset, 32 );
    offset + 32
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_skip_u128"></a>

## Function `skip_u128`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_u128">skip_u128</a>(input: &vector&lt;u8&gt;, offset: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_u128">skip_u128</a>(input: &vector&lt;u8&gt;, offset: u64): u64 {
    <a href="BCS.md#0x1_BCS_can_skip">can_skip</a>(input, offset, 16 );
    offset + 16
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_skip_u64"></a>

## Function `skip_u64`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_u64">skip_u64</a>(input: &vector&lt;u8&gt;, offset: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_u64">skip_u64</a>(input: &vector&lt;u8&gt;, offset: u64): u64 {
    <a href="BCS.md#0x1_BCS_can_skip">can_skip</a>(input, offset, 8 );
    offset + 8
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_skip_u32"></a>

## Function `skip_u32`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_u32">skip_u32</a>(input: &vector&lt;u8&gt;, offset: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_u32">skip_u32</a>(input: &vector&lt;u8&gt;, offset: u64): u64 {
    <a href="BCS.md#0x1_BCS_can_skip">can_skip</a>(input, offset, 4 );
    offset + 4
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_skip_u16"></a>

## Function `skip_u16`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_u16">skip_u16</a>(input: &vector&lt;u8&gt;, offset: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_u16">skip_u16</a>(input: &vector&lt;u8&gt;, offset: u64): u64 {
    <a href="BCS.md#0x1_BCS_can_skip">can_skip</a>(input, offset, 2 );
    offset + 2
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_skip_address"></a>

## Function `skip_address`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_address">skip_address</a>(input: &vector&lt;u8&gt;, offset: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_address">skip_address</a>(input: &vector&lt;u8&gt;, offset: u64): u64 {
    <a href="BCS.md#0x1_BCS_skip_n_bytes">skip_n_bytes</a>(input, offset, 16)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_skip_bool"></a>

## Function `skip_bool`



<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_bool">skip_bool</a>(input: &vector&lt;u8&gt;, offset: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_skip_bool">skip_bool</a>(input: &vector&lt;u8&gt;, offset: u64):  u64{
    <a href="BCS.md#0x1_BCS_can_skip">can_skip</a>(input, offset, 1);
    offset + 1
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_BCS_can_skip"></a>

## Function `can_skip`



<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_can_skip">can_skip</a>(input: &vector&lt;u8&gt;, offset: u64, n: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_can_skip">can_skip</a>(input: &vector&lt;u8&gt;, offset: u64, n: u64){
    <b>assert</b>!(((offset + n) &lt;= <a href="Vector.md#0x1_Vector_length">Vector::length</a>(input)) && (offset &lt; offset + n), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="BCS.md#0x1_BCS_ERR_INPUT_NOT_LARGE_ENOUGH">ERR_INPUT_NOT_LARGE_ENOUGH</a>));
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
<b>pragma</b> aborts_if_is_strict;
</code></pre>




<a name="0x1_BCS_serialize"></a>


<pre><code><b>native</b> <b>fun</b> <a href="BCS.md#0x1_BCS_serialize">serialize</a>&lt;MoveValue&gt;(v: &MoveValue): vector&lt;u8&gt;;
</code></pre>
