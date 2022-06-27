
<a name="0x1_Ring"></a>

# Module `0x1::Ring`



-  [Struct `Ring`](#0x1_Ring_Ring)
-  [Constants](#@Constants_0)
-  [Function `empty`](#0x1_Ring_empty)
-  [Function `length`](#0x1_Ring_length)
-  [Function `add_element`](#0x1_Ring_add_element)
-  [Function `delete_element`](#0x1_Ring_delete_element)
-  [Function `remove_element`](#0x1_Ring_remove_element)
-  [Function `set`](#0x1_Ring_set)
-  [Function `borrow`](#0x1_Ring_borrow)
-  [Function `borrow_mut`](#0x1_Ring_borrow_mut)
-  [Function `is_empty`](#0x1_Ring_is_empty)
-  [Function `index_of`](#0x1_Ring_index_of)
-  [Function `get_index`](#0x1_Ring_get_index)


<pre><code><b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_Ring_Ring"></a>

## Struct `Ring`



<pre><code><b>struct</b> <a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt; <b>has</b> drop
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>v: vector&lt;Element&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>i: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_Ring_ERROR_RING_INDEX_OUT_OF_BOUNDS"></a>



<pre><code><b>const</b> <a href="Ring.md#0x1_Ring_ERROR_RING_INDEX_OUT_OF_BOUNDS">ERROR_RING_INDEX_OUT_OF_BOUNDS</a>: u64 = 10011;
</code></pre>



<a name="0x1_Ring_ERROR_RING_IS_EMPTY"></a>



<pre><code><b>const</b> <a href="Ring.md#0x1_Ring_ERROR_RING_IS_EMPTY">ERROR_RING_IS_EMPTY</a>: u64 = 10010;
</code></pre>



<a name="0x1_Ring_empty"></a>

## Function `empty`



<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_empty">empty</a>&lt;Element&gt;(): <a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_empty">empty</a>&lt;Element&gt;(): <a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;{
    <a href="Ring.md#0x1_Ring">Ring</a> {
        v :<a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;Element&gt;(),
        i :0
    }
}
</code></pre>



</details>

<a name="0x1_Ring_length"></a>

## Function `length`



<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_length">length</a>&lt;Element&gt;(r: &<a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_length">length</a>&lt;Element&gt;(r: &<a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;): u64{
    <a href="Vector.md#0x1_Vector_length">Vector::length</a>&lt;Element&gt;( &r.v )
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> intrinsic = <b>true</b>;
</code></pre>



</details>

<a name="0x1_Ring_add_element"></a>

## Function `add_element`



<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_add_element">add_element</a>&lt;Element&gt;(r: &<b>mut</b> <a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;, e: Element)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_add_element">add_element</a>&lt;Element&gt;(r: &<b>mut</b> <a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;, e: Element){
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>&lt;Element&gt;(&<b>mut</b> r.v, e);
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> intrinsic = <b>true</b>;
</code></pre>



</details>

<a name="0x1_Ring_delete_element"></a>

## Function `delete_element`



<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_delete_element">delete_element</a>&lt;Element&gt;(r: &<b>mut</b> <a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;): Element
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_delete_element">delete_element</a>&lt;Element&gt;(r: &<b>mut</b> <a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;):Element{
    <b>assert</b>!(!<a href="Ring.md#0x1_Ring_is_empty">is_empty</a>&lt;Element&gt;(r), <a href="Ring.md#0x1_Ring_ERROR_RING_IS_EMPTY">ERROR_RING_IS_EMPTY</a>);
    <b>let</b> e = <a href="Vector.md#0x1_Vector_pop_back">Vector::pop_back</a>&lt;Element&gt;(&<b>mut</b> r.v);
    <b>if</b>( r.i &gt;= <a href="Ring.md#0x1_Ring_length">length</a>&lt;Element&gt;(r)){
        r.i = r.i - 1;
    };
    e
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> intrinsic = <b>true</b>;
</code></pre>



</details>

<a name="0x1_Ring_remove_element"></a>

## Function `remove_element`



<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_remove_element">remove_element</a>&lt;Element&gt;(r: &<b>mut</b> <a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;, i: u64): Element
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_remove_element">remove_element</a>&lt;Element&gt;(r: &<b>mut</b> <a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;, i: u64):Element{
    <b>assert</b>!(!<a href="Ring.md#0x1_Ring_is_empty">is_empty</a>&lt;Element&gt;(r), <a href="Ring.md#0x1_Ring_ERROR_RING_IS_EMPTY">ERROR_RING_IS_EMPTY</a>);
    <b>let</b> e = <a href="Vector.md#0x1_Vector_remove">Vector::remove</a>&lt;Element&gt;(&<b>mut</b> r.v, i);
    <b>if</b>( r.i &gt; i ){
        r.i = r.i - 1;
    };
    e
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> intrinsic = <b>true</b>;
</code></pre>



</details>

<a name="0x1_Ring_set"></a>

## Function `set`



<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_set">set</a>&lt;Element&gt;(r: &<b>mut</b> <a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;): &<b>mut</b> Element
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_set">set</a>&lt;Element&gt;(r: &<b>mut</b> <a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;):&<b>mut</b> Element{
    <b>let</b> len = <a href="Ring.md#0x1_Ring_length">length</a>&lt;Element&gt;(r);
    <b>let</b> next_i = ( len + r.i + 1 ) % len ;
    <b>let</b> element = <a href="Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>&lt;Element&gt;(&<b>mut</b> r.v, next_i);
    r.i = next_i;
    element
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> intrinsic = <b>true</b>;
</code></pre>



</details>

<a name="0x1_Ring_borrow"></a>

## Function `borrow`



<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_borrow">borrow</a>&lt;Element&gt;(r: &<a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;, i: u64): &Element
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_borrow">borrow</a>&lt;Element&gt;(r:& <a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;, i: u64):&Element{
    <b>assert</b>!(!<a href="Ring.md#0x1_Ring_is_empty">is_empty</a>&lt;Element&gt;(r), <a href="Ring.md#0x1_Ring_ERROR_RING_IS_EMPTY">ERROR_RING_IS_EMPTY</a>);
    <b>let</b> len = <a href="Ring.md#0x1_Ring_length">length</a>&lt;Element&gt;(r);
    <b>assert</b>!( len &gt; i ,<a href="Ring.md#0x1_Ring_ERROR_RING_INDEX_OUT_OF_BOUNDS">ERROR_RING_INDEX_OUT_OF_BOUNDS</a>);
    <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>&lt;Element&gt;(&r.v, i)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> intrinsic = <b>true</b>;
</code></pre>



</details>

<a name="0x1_Ring_borrow_mut"></a>

## Function `borrow_mut`



<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_borrow_mut">borrow_mut</a>&lt;Element&gt;(r: &<b>mut</b> <a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;, i: u64): &<b>mut</b> Element
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_borrow_mut">borrow_mut</a>&lt;Element&gt;(r: &<b>mut</b> <a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;, i: u64):&<b>mut</b> Element{
    <b>assert</b>!(!<a href="Ring.md#0x1_Ring_is_empty">is_empty</a>&lt;Element&gt;(r), <a href="Ring.md#0x1_Ring_ERROR_RING_IS_EMPTY">ERROR_RING_IS_EMPTY</a>);
    <b>let</b> len = <a href="Ring.md#0x1_Ring_length">length</a>&lt;Element&gt;(r);
    <b>assert</b>!( len &gt; i ,<a href="Ring.md#0x1_Ring_ERROR_RING_INDEX_OUT_OF_BOUNDS">ERROR_RING_INDEX_OUT_OF_BOUNDS</a>);
    <a href="Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>&lt;Element&gt;(&<b>mut</b> r.v, i)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> intrinsic = <b>true</b>;
</code></pre>



</details>

<a name="0x1_Ring_is_empty"></a>

## Function `is_empty`



<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_is_empty">is_empty</a>&lt;Element&gt;(r: &<a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_is_empty">is_empty</a>&lt;Element&gt;(r:&<a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;): bool{
    <a href="Vector.md#0x1_Vector_is_empty">Vector::is_empty</a>&lt;Element&gt;(&r.v)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> intrinsic = <b>true</b>;
</code></pre>



</details>

<a name="0x1_Ring_index_of"></a>

## Function `index_of`



<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_index_of">index_of</a>&lt;Element&gt;(r: &<a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;, e: &Element): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_index_of">index_of</a>&lt;Element&gt;(r:&<a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;, e: &Element):<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;{
    <b>let</b> i = 0;
    <b>let</b> len = <a href="Ring.md#0x1_Ring_length">length</a>&lt;Element&gt;(r);
    <b>while</b> (i &lt; len) {
        <b>if</b> (<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&r.v, i) == e) <b>return</b> <a href="Option.md#0x1_Option_some">Option::some</a>(i);
        i = i + 1;
    };
    <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u64&gt;()
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> intrinsic = <b>true</b>;
</code></pre>



</details>

<a name="0x1_Ring_get_index"></a>

## Function `get_index`



<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_get_index">get_index</a>&lt;Element&gt;(r: &<a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_get_index">get_index</a>&lt;Element&gt;(r: &<a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;):u64{
    r.i
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> intrinsic = <b>true</b>;
</code></pre>



</details>
