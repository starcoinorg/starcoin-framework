
<a name="0x1_EventUtil"></a>

# Module `0x1::EventUtil`



-  [Resource `EventHandleWrapper`](#0x1_EventUtil_EventHandleWrapper)
-  [Constants](#@Constants_0)
-  [Function `init_event`](#0x1_EventUtil_init_event)
-  [Function `uninit_event`](#0x1_EventUtil_uninit_event)
-  [Function `emit_event`](#0x1_EventUtil_emit_event)
-  [Function `exist_event`](#0x1_EventUtil_exist_event)


<pre><code><b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Event.md#0x1_Event">0x1::Event</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
</code></pre>



<a name="0x1_EventUtil_EventHandleWrapper"></a>

## Resource `EventHandleWrapper`



<pre><code><b>struct</b> <a href="EventUtil.md#0x1_EventUtil_EventHandleWrapper">EventHandleWrapper</a>&lt;EventT: drop, store&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>handle: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;EventT&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_EventUtil_ERR_INIT_REPEATE"></a>



<pre><code><b>const</b> <a href="EventUtil.md#0x1_EventUtil_ERR_INIT_REPEATE">ERR_INIT_REPEATE</a>: u64 = 101;
</code></pre>



<a name="0x1_EventUtil_ERR_RESOURCE_NOT_EXISTS"></a>



<pre><code><b>const</b> <a href="EventUtil.md#0x1_EventUtil_ERR_RESOURCE_NOT_EXISTS">ERR_RESOURCE_NOT_EXISTS</a>: u64 = 102;
</code></pre>



<a name="0x1_EventUtil_init_event"></a>

## Function `init_event`



<pre><code><b>public</b> <b>fun</b> <a href="EventUtil.md#0x1_EventUtil_init_event">init_event</a>&lt;EventT: drop, store&gt;(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="EventUtil.md#0x1_EventUtil_init_event">init_event</a>&lt;EventT: store + drop&gt;(sender: &signer) {
    <b>let</b> broker = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>assert</b>!(!<b>exists</b>&lt;<a href="EventUtil.md#0x1_EventUtil_EventHandleWrapper">EventHandleWrapper</a>&lt;EventT&gt;&gt;(broker), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="EventUtil.md#0x1_EventUtil_ERR_INIT_REPEATE">ERR_INIT_REPEATE</a>));
    <b>move_to</b>(sender, <a href="EventUtil.md#0x1_EventUtil_EventHandleWrapper">EventHandleWrapper</a>&lt;EventT&gt; {
        handle: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;EventT&gt;(sender)
    });
}
</code></pre>



</details>

<a name="0x1_EventUtil_uninit_event"></a>

## Function `uninit_event`



<pre><code><b>public</b> <b>fun</b> <a href="EventUtil.md#0x1_EventUtil_uninit_event">uninit_event</a>&lt;EventT: drop, store&gt;(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="EventUtil.md#0x1_EventUtil_uninit_event">uninit_event</a>&lt;EventT: store + drop&gt;(sender: &signer) <b>acquires</b> <a href="EventUtil.md#0x1_EventUtil_EventHandleWrapper">EventHandleWrapper</a> {
    <b>let</b> broker = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>assert</b>!(<b>exists</b>&lt;<a href="EventUtil.md#0x1_EventUtil_EventHandleWrapper">EventHandleWrapper</a>&lt;EventT&gt;&gt;(broker), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="EventUtil.md#0x1_EventUtil_ERR_RESOURCE_NOT_EXISTS">ERR_RESOURCE_NOT_EXISTS</a>));
    <b>let</b> <a href="EventUtil.md#0x1_EventUtil_EventHandleWrapper">EventHandleWrapper</a>&lt;EventT&gt; { handle } = <b>move_from</b>&lt;<a href="EventUtil.md#0x1_EventUtil_EventHandleWrapper">EventHandleWrapper</a>&lt;EventT&gt;&gt;(broker);
    <a href="Event.md#0x1_Event_destroy_handle">Event::destroy_handle</a>&lt;EventT&gt;(handle);
}
</code></pre>



</details>

<a name="0x1_EventUtil_emit_event"></a>

## Function `emit_event`



<pre><code><b>public</b> <b>fun</b> <a href="EventUtil.md#0x1_EventUtil_emit_event">emit_event</a>&lt;EventT: drop, store&gt;(broker: <b>address</b>, event: EventT)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="EventUtil.md#0x1_EventUtil_emit_event">emit_event</a>&lt;EventT: store + drop&gt;(broker: <b>address</b>, event: EventT) <b>acquires</b> <a href="EventUtil.md#0x1_EventUtil_EventHandleWrapper">EventHandleWrapper</a> {
    <b>let</b> event_handle = <b>borrow_global_mut</b>&lt;<a href="EventUtil.md#0x1_EventUtil_EventHandleWrapper">EventHandleWrapper</a>&lt;EventT&gt;&gt;(broker);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> event_handle.handle, event);
}
</code></pre>



</details>

<a name="0x1_EventUtil_exist_event"></a>

## Function `exist_event`



<pre><code><b>public</b> <b>fun</b> <a href="EventUtil.md#0x1_EventUtil_exist_event">exist_event</a>&lt;EventT: drop, store&gt;(broker: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="EventUtil.md#0x1_EventUtil_exist_event">exist_event</a>&lt;EventT: store + drop&gt;(broker: <b>address</b>): bool {
    <b>exists</b>&lt;<a href="EventUtil.md#0x1_EventUtil_EventHandleWrapper">EventHandleWrapper</a>&lt;EventT&gt;&gt;(broker)
}
</code></pre>



</details>
