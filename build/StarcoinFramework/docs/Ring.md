
<a name="0x1_Ring"></a>

# Module `0x1::Ring`

A ring-shaped container that can hold any type, indexed from 0
The capacity is fixed at creation time, and the accessible index is constantly growing


-  [Struct `Ring`](#0x1_Ring_Ring)
-  [Constants](#@Constants_0)
-  [Function `create_with_capacity`](#0x1_Ring_create_with_capacity)
-  [Function `is_full`](#0x1_Ring_is_full)
-  [Function `capacity`](#0x1_Ring_capacity)
-  [Function `push`](#0x1_Ring_push)
-  [Function `borrow`](#0x1_Ring_borrow)
-  [Function `borrow_mut`](#0x1_Ring_borrow_mut)
-  [Function `index_of`](#0x1_Ring_index_of)
-  [Function `destroy`](#0x1_Ring_destroy)


<pre><code><b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_Ring_Ring"></a>

## Struct `Ring`



<pre><code><b>struct</b> <a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt; <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>data: vector&lt;<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;Element&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>insertion_index: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>external_index: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_Ring_ERROR_RING_INDEX_OUT_OF_BOUNDS"></a>

The index into the vector is out of bounds


<pre><code><b>const</b> <a href="Ring.md#0x1_Ring_ERROR_RING_INDEX_OUT_OF_BOUNDS">ERROR_RING_INDEX_OUT_OF_BOUNDS</a>: u64 = 101;
</code></pre>



<a name="0x1_Ring_create_with_capacity"></a>

## Function `create_with_capacity`

Create a Ring with capacity.


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_create_with_capacity">create_with_capacity</a>&lt;Element&gt;(len: u64): <a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_create_with_capacity">create_with_capacity</a>&lt;Element&gt;( len: u64 ):<a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;{
    <b>let</b> data = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;Element&gt;&gt;();
    <b>let</b> i = 0;
    <b>while</b>(i &lt; len){
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> data , <a href="Option.md#0x1_Option_none">Option::none</a>&lt;Element&gt;());
        i = i + 1;
    };
    <a href="Ring.md#0x1_Ring">Ring</a> {
        data             : data,
        insertion_index  : 0,
        external_index   : 0,
    }
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> intrinsic = <b>true</b>;
</code></pre>



</details>

<a name="0x1_Ring_is_full"></a>

## Function `is_full`

is Ring full


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_is_full">is_full</a>&lt;Element&gt;(r: &<a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_is_full">is_full</a>&lt;Element&gt;(r: &<a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;):bool{
    <a href="Option.md#0x1_Option_is_some">Option::is_some</a>(<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&r.data, r.insertion_index))
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> intrinsic = <b>true</b>;
</code></pre>



</details>

<a name="0x1_Ring_capacity"></a>

## Function `capacity`

Return the capacity of the Ring.


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_capacity">capacity</a>&lt;Element&gt;(r: &<a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_capacity">capacity</a>&lt;Element&gt;(r: &<a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;): u64{
    <a href="Vector.md#0x1_Vector_length">Vector::length</a>( &r.data )
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



</details>

<a name="0x1_Ring_push"></a>

## Function `push`

Add element <code>e</code> to the insertion_index of the Ring <code>r</code>.


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_push">push</a>&lt;Element&gt;(r: &<b>mut</b> <a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;, e: Element): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;Element&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_push">push</a>&lt;Element&gt; (r: &<b>mut</b> <a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt; , e: Element):<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;Element&gt;{
    <b>let</b> op_e = <a href="Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>&lt;<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;Element&gt;&gt;(&<b>mut</b> r.data, r.insertion_index);
    <b>let</b> res = <b>if</b>(  <a href="Option.md#0x1_Option_is_none">Option::is_none</a>&lt;Element&gt;(op_e) ){
        <a href="Option.md#0x1_Option_fill">Option::fill</a>( op_e, e);
        <a href="Option.md#0x1_Option_none">Option::none</a>&lt;Element&gt;()
    }<b>else</b>{
       <a href="Option.md#0x1_Option_some">Option::some</a>&lt;Element&gt;( <a href="Option.md#0x1_Option_swap">Option::swap</a>( op_e, e) )
    };
    r.insertion_index = ( r.insertion_index + 1 ) % <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&r.data);
    r.external_index = r.external_index + 1;
    res
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

Return a reference to the <code>i</code>th element in the Ring <code>r</code>.


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_borrow">borrow</a>&lt;Element&gt;(r: &<a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;, i: u64): &<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;Element&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_borrow">borrow</a>&lt;Element&gt;(r:& <a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;, i: u64):&<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;Element&gt;{
    <b>let</b> len = <a href="Ring.md#0x1_Ring_capacity">capacity</a>&lt;Element&gt;(r);
    <b>if</b>( r.external_index &gt; len - 1) {
        <b>assert</b>!( i &gt;= r.external_index - len && i &lt; r.external_index , <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="Ring.md#0x1_Ring_ERROR_RING_INDEX_OUT_OF_BOUNDS">ERROR_RING_INDEX_OUT_OF_BOUNDS</a>));
        <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&r.data, i % len)
    }<b>else</b> {
        <b>assert</b>!( i &lt; len , <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="Ring.md#0x1_Ring_ERROR_RING_INDEX_OUT_OF_BOUNDS">ERROR_RING_INDEX_OUT_OF_BOUNDS</a>));
        <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&r.data, i )
    }
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

Return a mutable reference to the <code>i</code>th element in the Ring <code>r</code>.


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_borrow_mut">borrow_mut</a>&lt;Element&gt;(r: &<b>mut</b> <a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;, i: u64): &<b>mut</b> <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;Element&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_borrow_mut">borrow_mut</a>&lt;Element&gt;(r: &<b>mut</b> <a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;, i: u64):&<b>mut</b> <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;Element&gt;{
    <b>let</b> len = <a href="Ring.md#0x1_Ring_capacity">capacity</a>&lt;Element&gt;(r);
    <b>if</b>( r.external_index &gt; len - 1) {
        <b>assert</b>!( i &gt;= r.external_index - len && i &lt; r.external_index , <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="Ring.md#0x1_Ring_ERROR_RING_INDEX_OUT_OF_BOUNDS">ERROR_RING_INDEX_OUT_OF_BOUNDS</a>));
        <a href="Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> r.data, i % len)
    }<b>else</b> {
        <b>assert</b>!( i &lt; len , <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="Ring.md#0x1_Ring_ERROR_RING_INDEX_OUT_OF_BOUNDS">ERROR_RING_INDEX_OUT_OF_BOUNDS</a>));
        <a href="Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> r.data, i )
    }

}
</code></pre>



</details>

<details>
<summary>Specification</summary>



</details>

<a name="0x1_Ring_index_of"></a>

## Function `index_of`

Return <code><a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;</code> if <code>e</code> is in the Ring <code>r</code> at index <code>i</code>.
Otherwise, returns <code><a href="Option.md#0x1_Option_none">Option::none</a>&lt;u64&gt;</code>.


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_index_of">index_of</a>&lt;Element&gt;(r: &<a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;, e: &Element): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_index_of">index_of</a>&lt;Element&gt;(r: &<a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;, e: &Element):<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;{
    <b>let</b> i = 0;
    <b>let</b> len = <a href="Ring.md#0x1_Ring_capacity">capacity</a>&lt;Element&gt;(r);
    <b>while</b> ( i &lt; len ) {
        <b>if</b> ( <a href="Option.md#0x1_Option_borrow">Option::borrow</a>(<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>( &r.data, i )) == e) <b>return</b> <a href="Option.md#0x1_Option_some">Option::some</a>(i + r.external_index - len);
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

<a name="0x1_Ring_destroy"></a>

## Function `destroy`

Destroy the Ring <code>r</code>.
Returns the vector<Element> saved by ring


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_destroy">destroy</a>&lt;Element&gt;(r: <a href="Ring.md#0x1_Ring_Ring">Ring::Ring</a>&lt;Element&gt;): vector&lt;Element&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Ring.md#0x1_Ring_destroy">destroy</a>&lt;Element&gt;(r: <a href="Ring.md#0x1_Ring">Ring</a>&lt;Element&gt;):vector&lt;Element&gt;{
    <b>let</b> <a href="Ring.md#0x1_Ring">Ring</a> {
        data            : data ,
        insertion_index : _,
        external_index  : _,
    } = r ;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&data);
    <b>let</b> i = 0;
    <b>let</b> vec = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;Element&gt;();
    <b>while</b> ( i &lt; len ) {
        <b>let</b> op_e = <a href="Vector.md#0x1_Vector_pop_back">Vector::pop_back</a>( &<b>mut</b> data );
        <b>if</b> ( <a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&op_e) ) {
            <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> vec, <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(op_e))
        }<b>else</b> {
           <a href="Option.md#0x1_Option_destroy_none">Option::destroy_none</a>(op_e)
        };
        i = i + 1;
    };
    <a href="Vector.md#0x1_Vector_destroy_empty">Vector::destroy_empty</a>(data);
    vec
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> intrinsic = <b>true</b>;
</code></pre>



</details>
