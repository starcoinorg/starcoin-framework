
<a name="0x1_Offer"></a>

# Module `0x1::Offer`



-  [Resource `Offer`](#0x1_Offer_Offer)
-  [Resource `Offers`](#0x1_Offer_Offers)
-  [Constants](#@Constants_0)
-  [Function `create`](#0x1_Offer_create)
-  [Function `redeem`](#0x1_Offer_redeem)
-  [Function `exists_at`](#0x1_Offer_exists_at)
-  [Function `address_of`](#0x1_Offer_address_of)
-  [Function `take_offer`](#0x1_Offer_take_offer)
-  [Function `find_offer`](#0x1_Offer_find_offer)
-  [Module Specification](#@Module_Specification_1)


<pre><code><b>use</b> <a href="Collection2.md#0x1_Collection2">0x1::Collection2</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_Offer_Offer"></a>

## Resource `Offer`

A wrapper around value <code>offered</code> that can be claimed by the address stored in <code>for</code> when after lock time.


<pre><code><b>struct</b> <a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt; <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>offered: Offered</code>
</dt>
<dd>

</dd>
<dt>
<code>for: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>time_lock: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_Offer_Offers"></a>

## Resource `Offers`



<pre><code><b>struct</b> <a href="Offer.md#0x1_Offer_Offers">Offers</a>&lt;Offered: store&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>offers: vector&lt;<a href="Offer.md#0x1_Offer_Offer">Offer::Offer</a>&lt;Offered&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_Offer_EOFFER_DNE_FOR_ACCOUNT"></a>

An offer of the specified type for the account does not match


<pre><code><b>const</b> <a href="Offer.md#0x1_Offer_EOFFER_DNE_FOR_ACCOUNT">EOFFER_DNE_FOR_ACCOUNT</a>: u64 = 101;
</code></pre>



<a name="0x1_Offer_EOFFER_NOT_UNLOCKED"></a>

Offer is not unlocked yet.


<pre><code><b>const</b> <a href="Offer.md#0x1_Offer_EOFFER_NOT_UNLOCKED">EOFFER_NOT_UNLOCKED</a>: u64 = 102;
</code></pre>



<a name="0x1_Offer_create"></a>

## Function `create`

Publish a value of type <code>Offered</code> under the sender's account. The value can be claimed by
either the <code>for</code> address or the transaction sender.


<pre><code><b>public</b> <b>fun</b> <a href="Offer.md#0x1_Offer_create">create</a>&lt;Offered: store&gt;(account: &signer, offered: Offered, for: <b>address</b>, lock_period: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Offer.md#0x1_Offer_create">create</a>&lt;Offered: store&gt;(account: &signer, offered: Offered, for: <b>address</b>, lock_period: u64) <b>acquires</b> <a href="Offer.md#0x1_Offer_Offers">Offers</a>, <a href="Offer.md#0x1_Offer">Offer</a> {
    <b>let</b> time_lock = <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>() + lock_period;
    //TODO should support multi <a href="Offer.md#0x1_Offer">Offer</a>?
    <b>let</b> account_address = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account);

    <b>if</b>(<b>exists</b>&lt;<a href="Offer.md#0x1_Offer_Offers">Offers</a>&lt;Offered&gt;&gt;(account_address)){
        <b>let</b> offers = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="Offer.md#0x1_Offer_Offers">Offers</a>&lt;Offered&gt;&gt;(account_address).offers;
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(offers, <a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt; { offered, for, time_lock });

    }<b>else</b> <b>if</b>(<b>exists</b>&lt;<a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt;&gt;(account_address)){
        <b>let</b> offers = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;<a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt;&gt;();
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> offers, <b>move_from</b>&lt;<a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt;&gt;(account_address));
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> offers, <a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt; { offered, for, time_lock });
        <b>move_to</b>(account, <a href="Offer.md#0x1_Offer_Offers">Offers</a>&lt;Offered&gt; { offers });

    }<b>else</b>{
        <b>move_to</b>(account, <a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt; { offered, for, time_lock });
    }
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>include</b> <a href="Timestamp.md#0x1_Timestamp_AbortsIfTimestampNotExists">Timestamp::AbortsIfTimestampNotExists</a>;
<b>aborts_if</b> <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>() + lock_period &gt; max_u64();
<b>aborts_if</b> <b>exists</b>&lt;<a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt;&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account));
</code></pre>



</details>

<a name="0x1_Offer_redeem"></a>

## Function `redeem`

Claim the value of type <code>Offered</code> published at <code>offer_address</code>.
Only succeeds if the sender is the intended recipient stored in <code>for</code> or the original
publisher <code>offer_address</code>, and now >= time_lock
Also fails if no such value exists.


<pre><code><b>public</b> <b>fun</b> <a href="Offer.md#0x1_Offer_redeem">redeem</a>&lt;Offered: store&gt;(account: &signer, offer_address: <b>address</b>): Offered
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Offer.md#0x1_Offer_redeem">redeem</a>&lt;Offered: store&gt;(account: &signer, offer_address: <b>address</b>): Offered <b>acquires</b> <a href="Offer.md#0x1_Offer">Offer</a>, <a href="Offer.md#0x1_Offer_Offers">Offers</a> {
    <b>let</b> account_address = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account);
    <b>let</b> <a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt; { offered, for, time_lock } = <b>if</b>(<b>exists</b>&lt;<a href="Offer.md#0x1_Offer_Offers">Offers</a>&lt;Offered&gt;&gt;(offer_address)){
        <b>let</b> offers = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="Offer.md#0x1_Offer_Offers">Offers</a>&lt;Offered&gt;&gt;(offer_address).offers;
        <b>let</b> op_index = <a href="Offer.md#0x1_Offer_find_offer">find_offer</a>(offers, account_address);
        <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&op_index),<a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="Offer.md#0x1_Offer_EOFFER_DNE_FOR_ACCOUNT">EOFFER_DNE_FOR_ACCOUNT</a>));
        <b>let</b> index = <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(op_index);
        <b>let</b> offer = <a href="Vector.md#0x1_Vector_remove">Vector::remove</a>(offers , index);
        <b>if</b>(<a href="Vector.md#0x1_Vector_length">Vector::length</a>(offers) == 0){
            <b>let</b> <a href="Offer.md#0x1_Offer_Offers">Offers</a> { offers } = <b>move_from</b>&lt;<a href="Offer.md#0x1_Offer_Offers">Offers</a>&lt;Offered&gt;&gt;(offer_address);
            <a href="Vector.md#0x1_Vector_destroy_empty">Vector::destroy_empty</a>(offers);
        };
        offer
    }<b>else</b> <b>if</b>(<b>exists</b>&lt;<a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt;&gt;(offer_address)){
        <b>move_from</b>&lt;<a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt;&gt;(offer_address)
    }<b>else</b>{
        //TODO: err code
        <b>abort</b> 10000
    };

    <b>let</b> sender = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account);
    <b>let</b> now = <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>();
    <b>assert</b>!(sender == for || sender == offer_address, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="Offer.md#0x1_Offer_EOFFER_DNE_FOR_ACCOUNT">EOFFER_DNE_FOR_ACCOUNT</a>));
    <b>assert</b>!(now &gt;= time_lock, <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Offer.md#0x1_Offer_EOFFER_NOT_UNLOCKED">EOFFER_NOT_UNLOCKED</a>));
    offered
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt;&gt;(offer_address);
<b>aborts_if</b> <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account) != <b>global</b>&lt;<a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt;&gt;(offer_address).for && <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account) != offer_address;
<b>aborts_if</b> <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>() &lt; <b>global</b>&lt;<a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt;&gt;(offer_address).time_lock;
<b>include</b> <a href="Timestamp.md#0x1_Timestamp_AbortsIfTimestampNotExists">Timestamp::AbortsIfTimestampNotExists</a>;
</code></pre>



</details>

<a name="0x1_Offer_exists_at"></a>

## Function `exists_at`

Returns true if an offer of type <code>Offered</code> exists at <code>offer_address</code>.


<pre><code><b>public</b> <b>fun</b> <a href="Offer.md#0x1_Offer_exists_at">exists_at</a>&lt;Offered: store&gt;(offer_address: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Offer.md#0x1_Offer_exists_at">exists_at</a>&lt;Offered: store&gt;(offer_address: <b>address</b>): bool {
    <b>exists</b>&lt;<a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt;&gt;(offer_address)
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> <b>false</b>;
</code></pre>



</details>

<a name="0x1_Offer_address_of"></a>

## Function `address_of`

Returns the address of the <code>Offered</code> type stored at <code>offer_address</code>.
Fails if no such <code><a href="Offer.md#0x1_Offer">Offer</a></code> exists.


<pre><code><b>public</b> <b>fun</b> <a href="Offer.md#0x1_Offer_address_of">address_of</a>&lt;Offered: store&gt;(offer_address: <b>address</b>): <b>address</b>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Offer.md#0x1_Offer_address_of">address_of</a>&lt;Offered: store&gt;(offer_address: <b>address</b>): <b>address</b> <b>acquires</b> <a href="Offer.md#0x1_Offer">Offer</a> {
    <b>borrow_global</b>&lt;<a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt;&gt;(offer_address).for
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt;&gt;(offer_address);
</code></pre>



</details>

<a name="0x1_Offer_take_offer"></a>

## Function `take_offer`

Take Offer and put to signer's Collection<Offered>.


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="Offer.md#0x1_Offer_take_offer">take_offer</a>&lt;Offered: store&gt;(signer: signer, offer_address: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="Offer.md#0x1_Offer_take_offer">take_offer</a>&lt;Offered: store&gt;(
    signer: signer,
    offer_address: <b>address</b>,
) <b>acquires</b> <a href="Offer.md#0x1_Offer">Offer</a>, <a href="Offer.md#0x1_Offer_Offers">Offers</a> {
    <b>let</b> offered = <a href="Offer.md#0x1_Offer_redeem">redeem</a>&lt;Offered&gt;(&signer, offer_address);
    <a href="Collection2.md#0x1_Collection2_put">Collection2::put</a>(&signer, <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&signer), offered);
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_Offer_find_offer"></a>

## Function `find_offer`



<pre><code><b>fun</b> <a href="Offer.md#0x1_Offer_find_offer">find_offer</a>&lt;Offered: store&gt;(offers: &vector&lt;<a href="Offer.md#0x1_Offer_Offer">Offer::Offer</a>&lt;Offered&gt;&gt;, for: <b>address</b>): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="Offer.md#0x1_Offer_find_offer">find_offer</a>&lt;Offered: store&gt;(offers: &vector&lt;<a href="Offer.md#0x1_Offer">Offer</a>&lt;Offered&gt;&gt;, for: <b>address</b>):<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;{
    <b>let</b> now = <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>();
    <b>let</b> length = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(offers);
    <b>let</b> i = 0;
    <b>while</b>(i &lt; length){
        <b>let</b> offer = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(offers, i);
        <b>if</b>( offer.for == for && now &gt;= offer.time_lock ){
            <b>return</b> <a href="Option.md#0x1_Option_some">Option::some</a>(i)
        };
        i = i + 1;
    };
    <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u64&gt;()
}
</code></pre>



</details>

<a name="@Module_Specification_1"></a>

## Module Specification



<pre><code><b>pragma</b> verify = <b>true</b>;
<b>pragma</b> aborts_if_is_strict = <b>true</b>;
</code></pre>
