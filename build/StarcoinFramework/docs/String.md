
<a name="0x1_String"></a>

# Module `0x1::String`

The <code>string</code> module defines the <code><a href="String.md#0x1_String">String</a></code> type which represents UTF8 encoded strings.


-  [Struct `String`](#0x1_String_String)
-  [Constants](#@Constants_0)
-  [Function `utf8`](#0x1_String_utf8)
-  [Function `try_utf8`](#0x1_String_try_utf8)
-  [Function `bytes`](#0x1_String_bytes)
-  [Function `is_empty`](#0x1_String_is_empty)
-  [Function `length`](#0x1_String_length)
-  [Function `append`](#0x1_String_append)
-  [Function `append_utf8`](#0x1_String_append_utf8)
-  [Function `insert`](#0x1_String_insert)
-  [Function `sub_string`](#0x1_String_sub_string)
-  [Function `index_of`](#0x1_String_index_of)
-  [Function `internal_check_utf8`](#0x1_String_internal_check_utf8)
-  [Function `internal_is_char_boundary`](#0x1_String_internal_is_char_boundary)
-  [Function `internal_sub_string`](#0x1_String_internal_sub_string)
-  [Function `internal_index_of`](#0x1_String_internal_index_of)
-  [Module Specification](#@Module_Specification_1)


<pre><code><b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_String_String"></a>

## Struct `String`

A <code><a href="String.md#0x1_String">String</a></code> holds a sequence of bytes which is guaranteed to be in utf8 format.


<pre><code><b>struct</b> <a href="String.md#0x1_String">String</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>bytes: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_String_EINVALID_INDEX"></a>

Index out of range.


<pre><code><b>const</b> <a href="String.md#0x1_String_EINVALID_INDEX">EINVALID_INDEX</a>: u64 = 2;
</code></pre>



<a name="0x1_String_EINVALID_UTF8"></a>

An invalid UTF8 encoding.


<pre><code><b>const</b> <a href="String.md#0x1_String_EINVALID_UTF8">EINVALID_UTF8</a>: u64 = 1;
</code></pre>



<a name="0x1_String_utf8"></a>

## Function `utf8`

Creates a new string from a sequence of bytes. Aborts if the bytes do not represent valid utf8.


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_utf8">utf8</a>(bytes: vector&lt;u8&gt;): <a href="String.md#0x1_String_String">String::String</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_utf8">utf8</a>(bytes: vector&lt;u8&gt;): <a href="String.md#0x1_String">String</a> {
    <b>assert</b>!(<a href="String.md#0x1_String_internal_check_utf8">internal_check_utf8</a>(&bytes), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="String.md#0x1_String_EINVALID_UTF8">EINVALID_UTF8</a>));
    <a href="String.md#0x1_String">String</a>{bytes}
}
</code></pre>



</details>

<a name="0x1_String_try_utf8"></a>

## Function `try_utf8`

Tries to create a new string from a sequence of bytes.


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_try_utf8">try_utf8</a>(bytes: vector&lt;u8&gt;): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;<a href="String.md#0x1_String_String">String::String</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_try_utf8">try_utf8</a>(bytes: vector&lt;u8&gt;): <a href="Option.md#0x1_Option">Option</a>&lt;<a href="String.md#0x1_String">String</a>&gt; {
    <b>if</b> (<a href="String.md#0x1_String_internal_check_utf8">internal_check_utf8</a>(&bytes)) {
        <a href="Option.md#0x1_Option_some">Option::some</a>(<a href="String.md#0x1_String">String</a>{bytes})
    } <b>else</b> {
        <a href="Option.md#0x1_Option_none">Option::none</a>()
    }
}
</code></pre>



</details>

<a name="0x1_String_bytes"></a>

## Function `bytes`

Returns a reference to the underlying byte vector.


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_bytes">bytes</a>(s: &<a href="String.md#0x1_String_String">String::String</a>): &vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_bytes">bytes</a>(s: &<a href="String.md#0x1_String">String</a>): &vector&lt;u8&gt; {
    &s.bytes
}
</code></pre>



</details>

<a name="0x1_String_is_empty"></a>

## Function `is_empty`

Checks whether this string is empty.


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_is_empty">is_empty</a>(s: &<a href="String.md#0x1_String_String">String::String</a>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_is_empty">is_empty</a>(s: &<a href="String.md#0x1_String">String</a>): bool {
    <a href="Vector.md#0x1_Vector_is_empty">Vector::is_empty</a>(&s.bytes)
}
</code></pre>



</details>

<a name="0x1_String_length"></a>

## Function `length`

Returns the length of this string, in bytes.


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_length">length</a>(s: &<a href="String.md#0x1_String_String">String::String</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_length">length</a>(s: &<a href="String.md#0x1_String">String</a>): u64 {
    <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&s.bytes)
}
</code></pre>



</details>

<a name="0x1_String_append"></a>

## Function `append`

Appends a string.


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_append">append</a>(s: &<b>mut</b> <a href="String.md#0x1_String_String">String::String</a>, r: <a href="String.md#0x1_String_String">String::String</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_append">append</a>(s: &<b>mut</b> <a href="String.md#0x1_String">String</a>, r: <a href="String.md#0x1_String">String</a>) {
    <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> s.bytes, *&r.bytes)
}
</code></pre>



</details>

<a name="0x1_String_append_utf8"></a>

## Function `append_utf8`

Appends bytes which must be in valid utf8 format.


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_append_utf8">append_utf8</a>(s: &<b>mut</b> <a href="String.md#0x1_String_String">String::String</a>, bytes: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_append_utf8">append_utf8</a>(s: &<b>mut</b> <a href="String.md#0x1_String">String</a>, bytes: vector&lt;u8&gt;) {
    <a href="String.md#0x1_String_append">append</a>(s, <a href="String.md#0x1_String_utf8">utf8</a>(bytes))
}
</code></pre>



</details>

<a name="0x1_String_insert"></a>

## Function `insert`

Insert the other string at the byte index in given string. The index must be at a valid utf8 char
boundary.


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_insert">insert</a>(s: &<b>mut</b> <a href="String.md#0x1_String_String">String::String</a>, at: u64, o: <a href="String.md#0x1_String_String">String::String</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_insert">insert</a>(s: &<b>mut</b> <a href="String.md#0x1_String">String</a>, at: u64, o: <a href="String.md#0x1_String">String</a>) {
    <b>let</b> bytes = &s.bytes;
    <b>assert</b>!(at &lt;= <a href="Vector.md#0x1_Vector_length">Vector::length</a>(bytes) && <a href="String.md#0x1_String_internal_is_char_boundary">internal_is_char_boundary</a>(bytes, at), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="String.md#0x1_String_EINVALID_INDEX">EINVALID_INDEX</a>));
    <b>let</b> l = <a href="String.md#0x1_String_length">length</a>(s);
    <b>let</b> front = <a href="String.md#0x1_String_sub_string">sub_string</a>(s, 0, at);
    <b>let</b> end = <a href="String.md#0x1_String_sub_string">sub_string</a>(s, at, l);
    <a href="String.md#0x1_String_append">append</a>(&<b>mut</b> front, o);
    <a href="String.md#0x1_String_append">append</a>(&<b>mut</b> front, end);
    *s = front;
}
</code></pre>



</details>

<a name="0x1_String_sub_string"></a>

## Function `sub_string`

Returns a sub-string using the given byte indices, where <code>i</code> is the first byte position and <code>j</code> is the start
of the first byte not included (or the length of the string). The indices must be at valid utf8 char boundaries,
guaranteeing that the result is valid utf8.


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_sub_string">sub_string</a>(s: &<a href="String.md#0x1_String_String">String::String</a>, i: u64, j: u64): <a href="String.md#0x1_String_String">String::String</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_sub_string">sub_string</a>(s: &<a href="String.md#0x1_String">String</a>, i: u64, j: u64): <a href="String.md#0x1_String">String</a> {
    <b>let</b> bytes = &s.bytes;
    <b>let</b> l = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(bytes);
    <b>assert</b>!(
        j &lt;= l && i &lt;= j && <a href="String.md#0x1_String_internal_is_char_boundary">internal_is_char_boundary</a>(bytes, i) && <a href="String.md#0x1_String_internal_is_char_boundary">internal_is_char_boundary</a>(bytes, j),
        <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="String.md#0x1_String_EINVALID_INDEX">EINVALID_INDEX</a>)
    );
    <a href="String.md#0x1_String">String</a>{bytes: <a href="String.md#0x1_String_internal_sub_string">internal_sub_string</a>(bytes, i, j)}
}
</code></pre>



</details>

<a name="0x1_String_index_of"></a>

## Function `index_of`

Computes the index of the first occurrence of a string. Returns <code><a href="String.md#0x1_String_length">length</a>(s)</code> if no occurrence found.


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_index_of">index_of</a>(s: &<a href="String.md#0x1_String_String">String::String</a>, r: &<a href="String.md#0x1_String_String">String::String</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="String.md#0x1_String_index_of">index_of</a>(s: &<a href="String.md#0x1_String">String</a>, r: &<a href="String.md#0x1_String">String</a>): u64 {
    <a href="String.md#0x1_String_internal_index_of">internal_index_of</a>(&s.bytes, &r.bytes)
}
</code></pre>



</details>

<a name="0x1_String_internal_check_utf8"></a>

## Function `internal_check_utf8`



<pre><code><b>fun</b> <a href="String.md#0x1_String_internal_check_utf8">internal_check_utf8</a>(v: &vector&lt;u8&gt;): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>native</b> <b>fun</b> <a href="String.md#0x1_String_internal_check_utf8">internal_check_utf8</a>(v: &vector&lt;u8&gt;): bool;
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> opaque;
<b>aborts_if</b> [abstract] <b>false</b>;
<b>ensures</b> [abstract] result == <a href="String.md#0x1_String_spec_internal_check_utf8">spec_internal_check_utf8</a>(v);
</code></pre>



</details>

<a name="0x1_String_internal_is_char_boundary"></a>

## Function `internal_is_char_boundary`



<pre><code><b>fun</b> <a href="String.md#0x1_String_internal_is_char_boundary">internal_is_char_boundary</a>(v: &vector&lt;u8&gt;, i: u64): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>native</b> <b>fun</b> <a href="String.md#0x1_String_internal_is_char_boundary">internal_is_char_boundary</a>(v: &vector&lt;u8&gt;, i: u64): bool;
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> opaque;
<b>aborts_if</b> [abstract] <b>false</b>;
<b>ensures</b> [abstract] result == <a href="String.md#0x1_String_spec_internal_is_char_boundary">spec_internal_is_char_boundary</a>(v, i);
</code></pre>



</details>

<a name="0x1_String_internal_sub_string"></a>

## Function `internal_sub_string`



<pre><code><b>fun</b> <a href="String.md#0x1_String_internal_sub_string">internal_sub_string</a>(v: &vector&lt;u8&gt;, i: u64, j: u64): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>native</b> <b>fun</b> <a href="String.md#0x1_String_internal_sub_string">internal_sub_string</a>(v: &vector&lt;u8&gt;, i: u64, j: u64): vector&lt;u8&gt;;
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> opaque;
<b>aborts_if</b> [abstract] <b>false</b>;
<b>ensures</b> [abstract] result == <a href="String.md#0x1_String_spec_internal_sub_string">spec_internal_sub_string</a>(v, i, j);
</code></pre>



</details>

<a name="0x1_String_internal_index_of"></a>

## Function `internal_index_of`



<pre><code><b>fun</b> <a href="String.md#0x1_String_internal_index_of">internal_index_of</a>(v: &vector&lt;u8&gt;, r: &vector&lt;u8&gt;): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>native</b> <b>fun</b> <a href="String.md#0x1_String_internal_index_of">internal_index_of</a>(v: &vector&lt;u8&gt;, r: &vector&lt;u8&gt;): u64;
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> opaque;
<b>aborts_if</b> [abstract] <b>false</b>;
<b>ensures</b> [abstract] result == <a href="String.md#0x1_String_spec_internal_index_of">spec_internal_index_of</a>(v, r);
</code></pre>




<a name="0x1_String_spec_internal_check_utf8"></a>


<pre><code><b>fun</b> <a href="String.md#0x1_String_spec_internal_check_utf8">spec_internal_check_utf8</a>(v: vector&lt;u8&gt;): bool;
<a name="0x1_String_spec_internal_is_char_boundary"></a>
<b>fun</b> <a href="String.md#0x1_String_spec_internal_is_char_boundary">spec_internal_is_char_boundary</a>(v: vector&lt;u8&gt;, i: u64): bool;
<a name="0x1_String_spec_internal_sub_string"></a>
<b>fun</b> <a href="String.md#0x1_String_spec_internal_sub_string">spec_internal_sub_string</a>(v: vector&lt;u8&gt;, i: u64, j: u64): vector&lt;u8&gt;;
<a name="0x1_String_spec_internal_index_of"></a>
<b>fun</b> <a href="String.md#0x1_String_spec_internal_index_of">spec_internal_index_of</a>(v: vector&lt;u8&gt;, r: vector&lt;u8&gt;): u64;
</code></pre>



</details>

<a name="@Module_Specification_1"></a>

## Module Specification



<a name="0x1_String_spec_utf8"></a>


<pre><code><b>fun</b> <a href="String.md#0x1_String_spec_utf8">spec_utf8</a>(bytes: vector&lt;u8&gt;): <a href="String.md#0x1_String">String</a> {
   <a href="String.md#0x1_String">String</a>{bytes}
}
</code></pre>
