
<a name="0x1_simple_map"></a>

# Module `0x1::simple_map`

This module provides a solution for sorted maps, that is it has the properties that
1) Keys point to Values
2) Each Key must be unique
3) A Key can be found within O(N) time
4) The keys are unsorted.
5) Adds and removals take O(N) time


-  [Struct `SimpleMap`](#0x1_simple_map_SimpleMap)
-  [Struct `Element`](#0x1_simple_map_Element)
-  [Constants](#@Constants_0)
-  [Function `length`](#0x1_simple_map_length)
-  [Function `create`](#0x1_simple_map_create)
-  [Function `borrow`](#0x1_simple_map_borrow)
-  [Function `borrow_mut`](#0x1_simple_map_borrow_mut)
-  [Function `contains_key`](#0x1_simple_map_contains_key)
-  [Function `destroy_empty`](#0x1_simple_map_destroy_empty)
-  [Function `add`](#0x1_simple_map_add)
-  [Function `upsert`](#0x1_simple_map_upsert)
-  [Function `remove`](#0x1_simple_map_remove)
-  [Function `find`](#0x1_simple_map_find)


<pre><code><b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_simple_map_SimpleMap"></a>

## Struct `SimpleMap`



<pre><code><b>struct</b> <a href="SimpleMap.md#0x1_simple_map_SimpleMap">SimpleMap</a>&lt;Key, Value&gt; <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>data: vector&lt;<a href="SimpleMap.md#0x1_simple_map_Element">simple_map::Element</a>&lt;Key, Value&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_simple_map_Element"></a>

## Struct `Element`



<pre><code><b>struct</b> <a href="SimpleMap.md#0x1_simple_map_Element">Element</a>&lt;Key, Value&gt; <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>key: Key</code>
</dt>
<dd>

</dd>
<dt>
<code>value: Value</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_simple_map_EKEY_ALREADY_EXISTS"></a>

Map key already exists


<pre><code><b>const</b> <a href="SimpleMap.md#0x1_simple_map_EKEY_ALREADY_EXISTS">EKEY_ALREADY_EXISTS</a>: u64 = 1;
</code></pre>



<a name="0x1_simple_map_EKEY_NOT_FOUND"></a>

Map key is not found


<pre><code><b>const</b> <a href="SimpleMap.md#0x1_simple_map_EKEY_NOT_FOUND">EKEY_NOT_FOUND</a>: u64 = 2;
</code></pre>



<a name="0x1_simple_map_length"></a>

## Function `length`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_length">length</a>&lt;Key: store, Value: store&gt;(map: &<a href="SimpleMap.md#0x1_simple_map_SimpleMap">simple_map::SimpleMap</a>&lt;Key, Value&gt;): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_length">length</a>&lt;Key: store, Value: store&gt;(map: &<a href="SimpleMap.md#0x1_simple_map_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;): u64 {
    <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&map.data)
}
</code></pre>



</details>

<a name="0x1_simple_map_create"></a>

## Function `create`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_create">create</a>&lt;Key: store, Value: store&gt;(): <a href="SimpleMap.md#0x1_simple_map_SimpleMap">simple_map::SimpleMap</a>&lt;Key, Value&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_create">create</a>&lt;Key: store, Value: store&gt;(): <a href="SimpleMap.md#0x1_simple_map_SimpleMap">SimpleMap</a>&lt;Key, Value&gt; {
    <a href="SimpleMap.md#0x1_simple_map_SimpleMap">SimpleMap</a> {
        data: <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>(),
    }
}
</code></pre>



</details>

<a name="0x1_simple_map_borrow"></a>

## Function `borrow`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_borrow">borrow</a>&lt;Key: store, Value: store&gt;(map: &<a href="SimpleMap.md#0x1_simple_map_SimpleMap">simple_map::SimpleMap</a>&lt;Key, Value&gt;, key: &Key): &Value
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_borrow">borrow</a>&lt;Key: store, Value: store&gt;(
    map: &<a href="SimpleMap.md#0x1_simple_map_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;,
    key: &Key,
): &Value {
    <b>let</b> maybe_idx = <a href="SimpleMap.md#0x1_simple_map_find">find</a>(map, key);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&maybe_idx), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="SimpleMap.md#0x1_simple_map_EKEY_NOT_FOUND">EKEY_NOT_FOUND</a>));
    <b>let</b> idx = <a href="Option.md#0x1_Option_extract">Option::extract</a>(&<b>mut</b> maybe_idx);
    &<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&map.data, idx).value
}
</code></pre>



</details>

<a name="0x1_simple_map_borrow_mut"></a>

## Function `borrow_mut`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_borrow_mut">borrow_mut</a>&lt;Key: store, Value: store&gt;(map: &<b>mut</b> <a href="SimpleMap.md#0x1_simple_map_SimpleMap">simple_map::SimpleMap</a>&lt;Key, Value&gt;, key: &Key): &<b>mut</b> Value
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_borrow_mut">borrow_mut</a>&lt;Key: store, Value: store&gt;(
    map: &<b>mut</b> <a href="SimpleMap.md#0x1_simple_map_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;,
    key: &Key,
): &<b>mut</b> Value {
    <b>let</b> maybe_idx = <a href="SimpleMap.md#0x1_simple_map_find">find</a>(map, key);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&maybe_idx), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="SimpleMap.md#0x1_simple_map_EKEY_NOT_FOUND">EKEY_NOT_FOUND</a>));
    <b>let</b> idx = <a href="Option.md#0x1_Option_extract">Option::extract</a>(&<b>mut</b> maybe_idx);
    &<b>mut</b> <a href="Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> map.data, idx).value
}
</code></pre>



</details>

<a name="0x1_simple_map_contains_key"></a>

## Function `contains_key`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_contains_key">contains_key</a>&lt;Key: store, Value: store&gt;(map: &<a href="SimpleMap.md#0x1_simple_map_SimpleMap">simple_map::SimpleMap</a>&lt;Key, Value&gt;, key: &Key): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_contains_key">contains_key</a>&lt;Key: store, Value: store&gt;(
    map: &<a href="SimpleMap.md#0x1_simple_map_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;,
    key: &Key,
): bool {
    <b>let</b> maybe_idx = <a href="SimpleMap.md#0x1_simple_map_find">find</a>(map, key);
    <a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&maybe_idx)
}
</code></pre>



</details>

<a name="0x1_simple_map_destroy_empty"></a>

## Function `destroy_empty`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_destroy_empty">destroy_empty</a>&lt;Key: store, Value: store&gt;(map: <a href="SimpleMap.md#0x1_simple_map_SimpleMap">simple_map::SimpleMap</a>&lt;Key, Value&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_destroy_empty">destroy_empty</a>&lt;Key: store, Value: store&gt;(map: <a href="SimpleMap.md#0x1_simple_map_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;) {
    <b>let</b> <a href="SimpleMap.md#0x1_simple_map_SimpleMap">SimpleMap</a> { data } = map;
    <a href="Vector.md#0x1_Vector_destroy_empty">Vector::destroy_empty</a>(data);
}
</code></pre>



</details>

<a name="0x1_simple_map_add"></a>

## Function `add`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_add">add</a>&lt;Key: store, Value: store&gt;(map: &<b>mut</b> <a href="SimpleMap.md#0x1_simple_map_SimpleMap">simple_map::SimpleMap</a>&lt;Key, Value&gt;, key: Key, value: Value)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_add">add</a>&lt;Key: store, Value: store&gt;(
    map: &<b>mut</b> <a href="SimpleMap.md#0x1_simple_map_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;,
    key: Key,
    value: Value,
) {
    <b>let</b> maybe_idx = <a href="SimpleMap.md#0x1_simple_map_find">find</a>(map, &key);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_none">Option::is_none</a>(&maybe_idx), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="SimpleMap.md#0x1_simple_map_EKEY_ALREADY_EXISTS">EKEY_ALREADY_EXISTS</a>));

    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> map.data, <a href="SimpleMap.md#0x1_simple_map_Element">Element</a> { key, value });
}
</code></pre>



</details>

<a name="0x1_simple_map_upsert"></a>

## Function `upsert`

Insert key/value pair or update an existing key to a new value


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_upsert">upsert</a>&lt;Key: store, Value: store&gt;(map: &<b>mut</b> <a href="SimpleMap.md#0x1_simple_map_SimpleMap">simple_map::SimpleMap</a>&lt;Key, Value&gt;, key: Key, value: Value): (<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;Key&gt;, <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;Value&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_upsert">upsert</a>&lt;Key: store, Value: store&gt;(
    map: &<b>mut</b> <a href="SimpleMap.md#0x1_simple_map_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;,
    key: Key,
    value: Value
): (<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;Key&gt;, <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;Value&gt;) {
    <b>let</b> data = &<b>mut</b> map.data;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(data);
    <b>let</b> i = 0;
    <b>while</b> (i &lt; len) {
        <b>let</b> element = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(data, i);
        <b>if</b> (&element.key == &key) {
            <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(data, <a href="SimpleMap.md#0x1_simple_map_Element">Element</a> { key, value});
            <a href="Vector.md#0x1_Vector_swap">Vector::swap</a>(data, i, len);
            <b>let</b> <a href="SimpleMap.md#0x1_simple_map_Element">Element</a> { key, value } = <a href="Vector.md#0x1_Vector_pop_back">Vector::pop_back</a>(data);
            <b>return</b> (<a href="Option.md#0x1_Option_some">Option::some</a>(key), <a href="Option.md#0x1_Option_some">Option::some</a>(value))
        };
        i = i + 1;
    };
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> map.data, <a href="SimpleMap.md#0x1_simple_map_Element">Element</a> { key, value });
    (<a href="Option.md#0x1_Option_none">Option::none</a>(), <a href="Option.md#0x1_Option_none">Option::none</a>())
}
</code></pre>



</details>

<a name="0x1_simple_map_remove"></a>

## Function `remove`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_remove">remove</a>&lt;Key: store, Value: store&gt;(map: &<b>mut</b> <a href="SimpleMap.md#0x1_simple_map_SimpleMap">simple_map::SimpleMap</a>&lt;Key, Value&gt;, key: &Key): (Key, Value)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_simple_map_remove">remove</a>&lt;Key: store, Value: store&gt;(
    map: &<b>mut</b> <a href="SimpleMap.md#0x1_simple_map_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;,
    key: &Key,
): (Key, Value) {
    <b>let</b> maybe_idx = <a href="SimpleMap.md#0x1_simple_map_find">find</a>(map, key);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&maybe_idx), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="SimpleMap.md#0x1_simple_map_EKEY_NOT_FOUND">EKEY_NOT_FOUND</a>));
    <b>let</b> placement = <a href="Option.md#0x1_Option_extract">Option::extract</a>(&<b>mut</b> maybe_idx);
    <b>let</b> <a href="SimpleMap.md#0x1_simple_map_Element">Element</a> { key, value } = <a href="Vector.md#0x1_Vector_swap_remove">Vector::swap_remove</a>(&<b>mut</b> map.data, placement);
    (key, value)
}
</code></pre>



</details>

<a name="0x1_simple_map_find"></a>

## Function `find`



<pre><code><b>fun</b> <a href="SimpleMap.md#0x1_simple_map_find">find</a>&lt;Key: store, Value: store&gt;(map: &<a href="SimpleMap.md#0x1_simple_map_SimpleMap">simple_map::SimpleMap</a>&lt;Key, Value&gt;, key: &Key): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="SimpleMap.md#0x1_simple_map_find">find</a>&lt;Key: store, Value: store&gt;(
    map: &<a href="SimpleMap.md#0x1_simple_map_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;,
    key: &Key,
): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;{
    <b>let</b> leng = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&map.data);
    <b>let</b> i = 0;
    <b>while</b> (i &lt; leng) {
        <b>let</b> element = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&map.data, i);
        <b>if</b> (&element.key == key){
            <b>return</b> <a href="Option.md#0x1_Option_some">Option::some</a>(i)
        };
        i = i + 1;
    };
    <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u64&gt;()
}
</code></pre>



</details>
