
<a name="0x1_SimpleMap"></a>

# Module `0x1::SimpleMap`

This module provides a solution for sorted maps, that is it has the properties that
1) Keys point to Values
2) Each Key must be unique
3) A Key can be found within O(Log N) time
4) The data is stored as sorted by Key
5) Adds and removals take O(N) time


-  [Struct `SimpleMap`](#0x1_SimpleMap_SimpleMap)
-  [Struct `Element`](#0x1_SimpleMap_Element)
-  [Constants](#@Constants_0)
-  [Function `length`](#0x1_SimpleMap_length)
-  [Function `create`](#0x1_SimpleMap_create)
-  [Function `borrow`](#0x1_SimpleMap_borrow)
-  [Function `borrow_mut`](#0x1_SimpleMap_borrow_mut)
-  [Function `contains_key`](#0x1_SimpleMap_contains_key)
-  [Function `destroy_empty`](#0x1_SimpleMap_destroy_empty)
-  [Function `add`](#0x1_SimpleMap_add)
-  [Function `remove`](#0x1_SimpleMap_remove)
-  [Function `find`](#0x1_SimpleMap_find)
-  [Module Specification](#@Module_Specification_1)


<pre><code><b>use</b> <a href="BCS.md#0x1_BCS">0x1::BCS</a>;
<b>use</b> <a href="Compare.md#0x1_Compare">0x1::Compare</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_SimpleMap_SimpleMap"></a>

## Struct `SimpleMap`



<pre><code><b>struct</b> <a href="SimpleMap.md#0x1_SimpleMap">SimpleMap</a>&lt;Key, Value&gt; <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>data: vector&lt;<a href="SimpleMap.md#0x1_SimpleMap_Element">SimpleMap::Element</a>&lt;Key, Value&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_SimpleMap_Element"></a>

## Struct `Element`



<pre><code><b>struct</b> <a href="SimpleMap.md#0x1_SimpleMap_Element">Element</a>&lt;Key, Value&gt; <b>has</b> <b>copy</b>, drop, store
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


<a name="0x1_SimpleMap_EKEY_ALREADY_EXISTS"></a>

Map key already exists


<pre><code><b>const</b> <a href="SimpleMap.md#0x1_SimpleMap_EKEY_ALREADY_EXISTS">EKEY_ALREADY_EXISTS</a>: u64 = 1;
</code></pre>



<a name="0x1_SimpleMap_EKEY_NOT_FOUND"></a>

Map key is not found


<pre><code><b>const</b> <a href="SimpleMap.md#0x1_SimpleMap_EKEY_NOT_FOUND">EKEY_NOT_FOUND</a>: u64 = 2;
</code></pre>



<a name="0x1_SimpleMap_length"></a>

## Function `length`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_length">length</a>&lt;Key: store, Value: store&gt;(map: &<a href="SimpleMap.md#0x1_SimpleMap_SimpleMap">SimpleMap::SimpleMap</a>&lt;Key, Value&gt;): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_length">length</a>&lt;Key: store, Value: store&gt;(map: &<a href="SimpleMap.md#0x1_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;): u64 {
    <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&map.data)
}
</code></pre>



</details>

<a name="0x1_SimpleMap_create"></a>

## Function `create`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_create">create</a>&lt;Key: store, Value: store&gt;(): <a href="SimpleMap.md#0x1_SimpleMap_SimpleMap">SimpleMap::SimpleMap</a>&lt;Key, Value&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_create">create</a>&lt;Key: store, Value: store&gt;(): <a href="SimpleMap.md#0x1_SimpleMap">SimpleMap</a>&lt;Key, Value&gt; {
    <a href="SimpleMap.md#0x1_SimpleMap">SimpleMap</a> {
        data: <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>(),
    }
}
</code></pre>



</details>

<a name="0x1_SimpleMap_borrow"></a>

## Function `borrow`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_borrow">borrow</a>&lt;Key: store, Value: store&gt;(map: &<a href="SimpleMap.md#0x1_SimpleMap_SimpleMap">SimpleMap::SimpleMap</a>&lt;Key, Value&gt;, key: &Key): &Value
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_borrow">borrow</a>&lt;Key: store, Value: store&gt;(
    map: &<a href="SimpleMap.md#0x1_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;,
    key: &Key,
): &Value {
    <b>let</b> (maybe_idx, _) = <a href="SimpleMap.md#0x1_SimpleMap_find">find</a>(map, key);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&maybe_idx), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="SimpleMap.md#0x1_SimpleMap_EKEY_NOT_FOUND">EKEY_NOT_FOUND</a>));
    <b>let</b> idx = <a href="Option.md#0x1_Option_extract">Option::extract</a>(&<b>mut</b> maybe_idx);
    &<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&map.data, idx).value
}
</code></pre>



</details>

<a name="0x1_SimpleMap_borrow_mut"></a>

## Function `borrow_mut`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_borrow_mut">borrow_mut</a>&lt;Key: store, Value: store&gt;(map: &<b>mut</b> <a href="SimpleMap.md#0x1_SimpleMap_SimpleMap">SimpleMap::SimpleMap</a>&lt;Key, Value&gt;, key: &Key): &<b>mut</b> Value
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_borrow_mut">borrow_mut</a>&lt;Key: store, Value: store&gt;(
    map: &<b>mut</b> <a href="SimpleMap.md#0x1_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;,
    key: &Key,
): &<b>mut</b> Value {
    <b>let</b> (maybe_idx, _) = <a href="SimpleMap.md#0x1_SimpleMap_find">find</a>(map, key);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&maybe_idx), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="SimpleMap.md#0x1_SimpleMap_EKEY_NOT_FOUND">EKEY_NOT_FOUND</a>));
    <b>let</b> idx = <a href="Option.md#0x1_Option_extract">Option::extract</a>(&<b>mut</b> maybe_idx);
    &<b>mut</b> <a href="Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> map.data, idx).value
}
</code></pre>



</details>

<a name="0x1_SimpleMap_contains_key"></a>

## Function `contains_key`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_contains_key">contains_key</a>&lt;Key: store, Value: store&gt;(map: &<a href="SimpleMap.md#0x1_SimpleMap_SimpleMap">SimpleMap::SimpleMap</a>&lt;Key, Value&gt;, key: &Key): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_contains_key">contains_key</a>&lt;Key: store, Value: store&gt;(
    map: &<a href="SimpleMap.md#0x1_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;,
    key: &Key,
): bool {
    <b>let</b> (maybe_idx, _) = <a href="SimpleMap.md#0x1_SimpleMap_find">find</a>(map, key);
    <a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&maybe_idx)
}
</code></pre>



</details>

<a name="0x1_SimpleMap_destroy_empty"></a>

## Function `destroy_empty`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_destroy_empty">destroy_empty</a>&lt;Key: store, Value: store&gt;(map: <a href="SimpleMap.md#0x1_SimpleMap_SimpleMap">SimpleMap::SimpleMap</a>&lt;Key, Value&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_destroy_empty">destroy_empty</a>&lt;Key: store, Value: store&gt;(map: <a href="SimpleMap.md#0x1_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;) {
    <b>let</b> <a href="SimpleMap.md#0x1_SimpleMap">SimpleMap</a> { data } = map;
    <a href="Vector.md#0x1_Vector_destroy_empty">Vector::destroy_empty</a>(data);
}
</code></pre>



</details>

<a name="0x1_SimpleMap_add"></a>

## Function `add`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_add">add</a>&lt;Key: store, Value: store&gt;(map: &<b>mut</b> <a href="SimpleMap.md#0x1_SimpleMap_SimpleMap">SimpleMap::SimpleMap</a>&lt;Key, Value&gt;, key: Key, value: Value)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_add">add</a>&lt;Key: store, Value: store&gt;(
    map: &<b>mut</b> <a href="SimpleMap.md#0x1_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;,
    key: Key,
    value: Value,
) {
    <b>let</b> (maybe_idx, maybe_placement) = <a href="SimpleMap.md#0x1_SimpleMap_find">find</a>(map, &key);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_none">Option::is_none</a>(&maybe_idx), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="SimpleMap.md#0x1_SimpleMap_EKEY_ALREADY_EXISTS">EKEY_ALREADY_EXISTS</a>));

    // Append <b>to</b> the end and then swap elements until the list is ordered again
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> map.data, <a href="SimpleMap.md#0x1_SimpleMap_Element">Element</a> { key, value });

    <b>let</b> placement = <a href="Option.md#0x1_Option_extract">Option::extract</a>(&<b>mut</b> maybe_placement);
    <b>let</b> end = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&map.data) - 1;
    <b>while</b> (placement &lt; end) {
        <a href="Vector.md#0x1_Vector_swap">Vector::swap</a>(&<b>mut</b> map.data, placement, end);
        placement = placement + 1;
    };
}
</code></pre>



</details>

<a name="0x1_SimpleMap_remove"></a>

## Function `remove`



<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_remove">remove</a>&lt;Key: store, Value: store&gt;(map: &<b>mut</b> <a href="SimpleMap.md#0x1_SimpleMap_SimpleMap">SimpleMap::SimpleMap</a>&lt;Key, Value&gt;, key: &Key): (Key, Value)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_remove">remove</a>&lt;Key: store, Value: store&gt;(
    map: &<b>mut</b> <a href="SimpleMap.md#0x1_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;,
    key: &Key,
): (Key, Value) {
    <b>let</b> (maybe_idx, _) = <a href="SimpleMap.md#0x1_SimpleMap_find">find</a>(map, key);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&maybe_idx), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="SimpleMap.md#0x1_SimpleMap_EKEY_NOT_FOUND">EKEY_NOT_FOUND</a>));

    <b>let</b> placement = <a href="Option.md#0x1_Option_extract">Option::extract</a>(&<b>mut</b> maybe_idx);
    <b>let</b> end = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&map.data) - 1;

    <b>while</b> (placement &lt; end) {
        <a href="Vector.md#0x1_Vector_swap">Vector::swap</a>(&<b>mut</b> map.data, placement, placement + 1);
        placement = placement + 1;
    };

    <b>let</b> <a href="SimpleMap.md#0x1_SimpleMap_Element">Element</a> { key, value } = <a href="Vector.md#0x1_Vector_pop_back">Vector::pop_back</a>(&<b>mut</b> map.data);
    (key, value)
}
</code></pre>



</details>

<a name="0x1_SimpleMap_find"></a>

## Function `find`



<pre><code><b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_find">find</a>&lt;Key: store, Value: store&gt;(map: &<a href="SimpleMap.md#0x1_SimpleMap_SimpleMap">SimpleMap::SimpleMap</a>&lt;Key, Value&gt;, key: &Key): (<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;, <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="SimpleMap.md#0x1_SimpleMap_find">find</a>&lt;Key: store, Value: store&gt;(
    map: &<a href="SimpleMap.md#0x1_SimpleMap">SimpleMap</a>&lt;Key, Value&gt;,
    key: &Key,
): (<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;, <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;) {
    <b>let</b> length = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&map.data);

    <b>if</b> (length == 0) {
        <b>return</b> (<a href="Option.md#0x1_Option_none">Option::none</a>(), <a href="Option.md#0x1_Option_some">Option::some</a>(0))
    };

    <b>let</b> left = 0;
    <b>let</b> right = length;

    <b>while</b> (left != right) {
        <b>let</b> mid = left + (right - left) / 2;
        <b>let</b> potential_key = &<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&map.data, mid).key;
        <b>if</b> (<a href="Compare.md#0x1_Compare_is_less_than">Compare::is_less_than</a>(<a href="Compare.md#0x1_Compare_cmp_bytes">Compare::cmp_bytes</a>(&<a href="BCS.md#0x1_BCS_to_bytes">BCS::to_bytes</a>(potential_key), &<a href="BCS.md#0x1_BCS_to_bytes">BCS::to_bytes</a>(key)))) {
            left = mid + 1;
        } <b>else</b> {
            right = mid;
        };
    };

    <b>if</b> (left != length && key == &<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&map.data, left).key) {
        (<a href="Option.md#0x1_Option_some">Option::some</a>(left), <a href="Option.md#0x1_Option_none">Option::none</a>())
    } <b>else</b> {
        (<a href="Option.md#0x1_Option_none">Option::none</a>(), <a href="Option.md#0x1_Option_some">Option::some</a>(left))
    }
}
</code></pre>



</details>

<a name="@Module_Specification_1"></a>

## Module Specification



<pre><code><b>pragma</b> verify = <b>false</b>;
<b>pragma</b> aborts_if_is_strict = <b>true</b>;
</code></pre>
