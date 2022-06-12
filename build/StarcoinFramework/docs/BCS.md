
<a name="0x1_BCS"></a>

# Module `0x1::BCS`

Utility for converting a Move value to its binary representation in BCS (Diem Canonical
Serialization). BCS is the binary encoding for Move resources and other non-module values
published on-chain.


-  [Constants](#@Constants_0)
-  [Function `to_bytes`](#0x1_BCS_to_bytes)
-  [Function `to_address`](#0x1_BCS_to_address)
-  [Function `from_bytes_to_bool`](#0x1_BCS_from_bytes_to_bool)
-  [Function `from_bytes_to_u64`](#0x1_BCS_from_bytes_to_u64)
-  [Function `from_bytes_to_u128`](#0x1_BCS_from_bytes_to_u128)
-  [Function `from_bytes_to_bool_vec`](#0x1_BCS_from_bytes_to_bool_vec)
-  [Function `from_bytes_to_u8_vec`](#0x1_BCS_from_bytes_to_u8_vec)
-  [Function `from_bytes_to_u64_vec`](#0x1_BCS_from_bytes_to_u64_vec)
-  [Function `from_bytes_to_u128_vec`](#0x1_BCS_from_bytes_to_u128_vec)
-  [Function `bytes_slice_to_u64`](#0x1_BCS_bytes_slice_to_u64)
-  [Function `bytes_slice_to_u128`](#0x1_BCS_bytes_slice_to_u128)
-  [Function `check_length`](#0x1_BCS_check_length)
-  [Function `deserialize_uleb128_to_u64`](#0x1_BCS_deserialize_uleb128_to_u64)
-  [Module Specification](#@Module_Specification_1)


<pre><code><b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="@Constants_0"></a>

## Constants


<a name="0x1_BCS_EBYTES_LENGTH_NOT_MATCH"></a>



<pre><code><b>const</b> <a href="BCS.md#0x1_BCS_EBYTES_LENGTH_NOT_MATCH">EBYTES_LENGTH_NOT_MATCH</a>: u64 = 1;
</code></pre>



<a name="0x1_BCS_EINCORRECT_VALUE"></a>



<pre><code><b>const</b> <a href="BCS.md#0x1_BCS_EINCORRECT_VALUE">EINCORRECT_VALUE</a>: u64 = 2;
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

<a name="0x1_BCS_from_bytes_to_bool"></a>

## Function `from_bytes_to_bool`

Deserialize bool


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_from_bytes_to_bool">from_bytes_to_bool</a>(bytes: &vector&lt;u8&gt;): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_from_bytes_to_bool">from_bytes_to_bool</a>(bytes: &vector&lt;u8&gt;): bool {
    <a href="BCS.md#0x1_BCS_check_length">check_length</a>(bytes, 1);
    <b>let</b> v = *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(bytes, 0);
    <b>assert</b>!(v == 0 || v == 1, <a href="BCS.md#0x1_BCS_EINCORRECT_VALUE">EINCORRECT_VALUE</a>);
    v == 1
}
</code></pre>



</details>

<a name="0x1_BCS_from_bytes_to_u64"></a>

## Function `from_bytes_to_u64`

Deserialize u64


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_from_bytes_to_u64">from_bytes_to_u64</a>(bytes: &vector&lt;u8&gt;): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_from_bytes_to_u64">from_bytes_to_u64</a>(bytes: &vector&lt;u8&gt;): u64 {
    <a href="BCS.md#0x1_BCS_check_length">check_length</a>(bytes, 8);
    <a href="BCS.md#0x1_BCS_bytes_slice_to_u64">bytes_slice_to_u64</a>(bytes, 0)
}
</code></pre>



</details>

<a name="0x1_BCS_from_bytes_to_u128"></a>

## Function `from_bytes_to_u128`

Deserialize u128


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_from_bytes_to_u128">from_bytes_to_u128</a>(bytes: &vector&lt;u8&gt;): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_from_bytes_to_u128">from_bytes_to_u128</a>(bytes: &vector&lt;u8&gt;): u128 {
    <a href="BCS.md#0x1_BCS_check_length">check_length</a>(bytes, 16);
    <a href="BCS.md#0x1_BCS_bytes_slice_to_u128">bytes_slice_to_u128</a>(bytes, 0)
}
</code></pre>



</details>

<a name="0x1_BCS_from_bytes_to_bool_vec"></a>

## Function `from_bytes_to_bool_vec`

Deserialize bool vector


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_from_bytes_to_bool_vec">from_bytes_to_bool_vec</a>(bytes: &vector&lt;u8&gt;): vector&lt;bool&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_from_bytes_to_bool_vec">from_bytes_to_bool_vec</a>(bytes: &vector&lt;u8&gt;): vector&lt;bool&gt; {
    <b>let</b> (data_len, uleb_encoding_len) = <a href="BCS.md#0x1_BCS_deserialize_uleb128_to_u64">deserialize_uleb128_to_u64</a>(bytes);
    <a href="BCS.md#0x1_BCS_check_length">check_length</a>(bytes, data_len * 1 + uleb_encoding_len);

    <b>let</b> value = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;bool&gt;();
    <b>let</b> i = 0u64;
    <b>while</b> (i &lt; data_len) {
        <b>let</b> v = *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(bytes, i + uleb_encoding_len);
        <b>assert</b>!(v == 0 || v == 1, <a href="BCS.md#0x1_BCS_EINCORRECT_VALUE">EINCORRECT_VALUE</a>);
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;bool&gt;(&<b>mut</b> value, v == 1);
        i = i + 1;
    };
    value
}
</code></pre>



</details>

<a name="0x1_BCS_from_bytes_to_u8_vec"></a>

## Function `from_bytes_to_u8_vec`

Deserialize u8 vector


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_from_bytes_to_u8_vec">from_bytes_to_u8_vec</a>(bytes: &vector&lt;u8&gt;): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_from_bytes_to_u8_vec">from_bytes_to_u8_vec</a>(bytes: &vector&lt;u8&gt;): vector&lt;u8&gt; {
    <b>let</b> (data_len, uleb128_encoding_len) = <a href="BCS.md#0x1_BCS_deserialize_uleb128_to_u64">deserialize_uleb128_to_u64</a>(bytes);
    <a href="BCS.md#0x1_BCS_check_length">check_length</a>(bytes, data_len * 1 + uleb128_encoding_len);

    <b>let</b> value = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>let</b> i = 0u64;
    <b>while</b> (i &lt; data_len) {
        <b>let</b> v = *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(bytes, i + uleb128_encoding_len);
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;u8&gt;(&<b>mut</b> value, v);
        i = i + 1;
    };
    value
}
</code></pre>



</details>

<a name="0x1_BCS_from_bytes_to_u64_vec"></a>

## Function `from_bytes_to_u64_vec`

Deserialize u64 vector


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_from_bytes_to_u64_vec">from_bytes_to_u64_vec</a>(bytes: &vector&lt;u8&gt;): vector&lt;u64&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_from_bytes_to_u64_vec">from_bytes_to_u64_vec</a>(bytes: &vector&lt;u8&gt;): vector&lt;u64&gt; {
    <b>let</b> (data_len, uleb128_encoding_len) = <a href="BCS.md#0x1_BCS_deserialize_uleb128_to_u64">deserialize_uleb128_to_u64</a>(bytes);
    <a href="BCS.md#0x1_BCS_check_length">check_length</a>(bytes, data_len * 8 + uleb128_encoding_len);

    <b>let</b> value = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u64&gt;();
    <b>let</b> i = 0u64;
    <b>while</b> (i &lt; data_len) {
        <b>let</b> offset = i * 8 + uleb128_encoding_len;
        <b>let</b> item = <a href="BCS.md#0x1_BCS_bytes_slice_to_u64">bytes_slice_to_u64</a>(bytes, offset);
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> value, item);
        i = i + 1;
    };
    value
}
</code></pre>



</details>

<a name="0x1_BCS_from_bytes_to_u128_vec"></a>

## Function `from_bytes_to_u128_vec`

Deserialize u128 vector


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_from_bytes_to_u128_vec">from_bytes_to_u128_vec</a>(bytes: &vector&lt;u8&gt;): vector&lt;u128&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="BCS.md#0x1_BCS_from_bytes_to_u128_vec">from_bytes_to_u128_vec</a>(bytes: &vector&lt;u8&gt;): vector&lt;u128&gt; {
    <b>let</b> (data_len, uleb128_encoding_len) = <a href="BCS.md#0x1_BCS_deserialize_uleb128_to_u64">deserialize_uleb128_to_u64</a>(bytes);
    <a href="BCS.md#0x1_BCS_check_length">check_length</a>(bytes, data_len * 16 + uleb128_encoding_len);

    <b>let</b> value = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u128&gt;();
    <b>let</b> i = 0u64;
    <b>while</b> (i &lt; data_len) {
        <b>let</b> offset = i * 16 + uleb128_encoding_len;
        <b>let</b> item = <a href="BCS.md#0x1_BCS_bytes_slice_to_u128">bytes_slice_to_u128</a>(bytes, offset);
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> value, item);
        i = i + 1;
    };
    value
}
</code></pre>



</details>

<a name="0x1_BCS_bytes_slice_to_u64"></a>

## Function `bytes_slice_to_u64`



<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_bytes_slice_to_u64">bytes_slice_to_u64</a>(bytes: &vector&lt;u8&gt;, offset: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_bytes_slice_to_u64">bytes_slice_to_u64</a>(bytes: &vector&lt;u8&gt;, offset: u64): u64 {
    <b>let</b> value = 0u64;
    <b>let</b> i = 0u64;
    <b>while</b> (i &lt; 8) {
        value = value | ((*<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(bytes, i + offset) <b>as</b> u64) &lt;&lt; ((8*i) <b>as</b> u8));
        i = i + 1;
    };
    value
}
</code></pre>



</details>

<a name="0x1_BCS_bytes_slice_to_u128"></a>

## Function `bytes_slice_to_u128`



<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_bytes_slice_to_u128">bytes_slice_to_u128</a>(bytes: &vector&lt;u8&gt;, offset: u64): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_bytes_slice_to_u128">bytes_slice_to_u128</a>(bytes: &vector&lt;u8&gt;, offset: u64): u128 {
    <b>let</b> value = 0u128;
    <b>let</b> i = 0;
    <b>while</b> (i &lt; 16) {
        value = value | ((*<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(bytes, i + offset) <b>as</b> u128) &lt;&lt; ((8*i) <b>as</b> u8));
        i = i + 1;
    };
    value
}
</code></pre>



</details>

<a name="0x1_BCS_check_length"></a>

## Function `check_length`



<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_check_length">check_length</a>(vec: &vector&lt;u8&gt;, expect: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_check_length">check_length</a>(vec: &vector&lt;u8&gt;, expect: u64) {
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(vec);
    <b>assert</b>!(len == expect, <a href="BCS.md#0x1_BCS_EBYTES_LENGTH_NOT_MATCH">EBYTES_LENGTH_NOT_MATCH</a>);
}
</code></pre>



</details>

<a name="0x1_BCS_deserialize_uleb128_to_u64"></a>

## Function `deserialize_uleb128_to_u64`

Return ULEB128 decoding data and ULEB128 encoding length.


<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_uleb128_to_u64">deserialize_uleb128_to_u64</a>(bytes: &vector&lt;u8&gt;): (u64, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="BCS.md#0x1_BCS_deserialize_uleb128_to_u64">deserialize_uleb128_to_u64</a>(bytes: &vector&lt;u8&gt;): (u64, u64) {
    <b>if</b> (<a href="Vector.md#0x1_Vector_length">Vector::length</a>(bytes) == 0) <b>abort</b> <a href="BCS.md#0x1_BCS_EBYTES_LENGTH_NOT_MATCH">EBYTES_LENGTH_NOT_MATCH</a>;
    <b>let</b> value = 0u64;
    <b>let</b> i = 0u64;
    <b>loop</b> {
        <b>let</b> byte = *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(bytes, i);
        <b>let</b> flag = byte & 0x80;
        <b>let</b> low7bit = byte & 0x7F;
        value = value | ((low7bit <b>as</b> u64) &lt;&lt; ((7*i) <b>as</b> u8));
        <b>if</b> (flag != 0) {
            i = i + 1;
        } <b>else</b> {
            <b>break</b>
        }
    };
    (value, i+1)
}
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
