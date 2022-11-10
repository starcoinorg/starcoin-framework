
<a name="0x1_TypeInfo"></a>

# Module `0x1::TypeInfo`



-  [Struct `TypeInfo`](#0x1_TypeInfo_TypeInfo)
-  [Function `account_address`](#0x1_TypeInfo_account_address)
-  [Function `module_name`](#0x1_TypeInfo_module_name)
-  [Function `struct_name`](#0x1_TypeInfo_struct_name)
-  [Function `type_of`](#0x1_TypeInfo_type_of)


<pre><code><b>use</b> <a href="Token.md#0x1_Token">0x1::Token</a>;
</code></pre>



<a name="0x1_TypeInfo_TypeInfo"></a>

## Struct `TypeInfo`



<pre><code><b>struct</b> <a href="TypeInfo.md#0x1_TypeInfo">TypeInfo</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>account_address: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>module_name: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>struct_name: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_TypeInfo_account_address"></a>

## Function `account_address`



<pre><code><b>public</b> <b>fun</b> <a href="TypeInfo.md#0x1_TypeInfo_account_address">account_address</a>(type_info: &<a href="TypeInfo.md#0x1_TypeInfo_TypeInfo">TypeInfo::TypeInfo</a>): <b>address</b>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TypeInfo.md#0x1_TypeInfo_account_address">account_address</a>(type_info: &<a href="TypeInfo.md#0x1_TypeInfo">TypeInfo</a>):<b>address</b>{
    type_info.account_address
}
</code></pre>



</details>

<a name="0x1_TypeInfo_module_name"></a>

## Function `module_name`



<pre><code><b>public</b> <b>fun</b> <a href="TypeInfo.md#0x1_TypeInfo_module_name">module_name</a>(type_info: &<a href="TypeInfo.md#0x1_TypeInfo_TypeInfo">TypeInfo::TypeInfo</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TypeInfo.md#0x1_TypeInfo_module_name">module_name</a>(type_info: &<a href="TypeInfo.md#0x1_TypeInfo">TypeInfo</a>):vector&lt;u8&gt;{
    *&type_info.module_name
}
</code></pre>



</details>

<a name="0x1_TypeInfo_struct_name"></a>

## Function `struct_name`



<pre><code><b>public</b> <b>fun</b> <a href="TypeInfo.md#0x1_TypeInfo_struct_name">struct_name</a>(type_info: &<a href="TypeInfo.md#0x1_TypeInfo_TypeInfo">TypeInfo::TypeInfo</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TypeInfo.md#0x1_TypeInfo_struct_name">struct_name</a>(type_info: &<a href="TypeInfo.md#0x1_TypeInfo">TypeInfo</a>):vector&lt;u8&gt;{
    *&type_info.struct_name
}
</code></pre>



</details>

<a name="0x1_TypeInfo_type_of"></a>

## Function `type_of`



<pre><code><b>public</b> <b>fun</b> <a href="TypeInfo.md#0x1_TypeInfo_type_of">type_of</a>&lt;T&gt;(): <a href="TypeInfo.md#0x1_TypeInfo_TypeInfo">TypeInfo::TypeInfo</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="TypeInfo.md#0x1_TypeInfo_type_of">type_of</a>&lt;T&gt;():<a href="TypeInfo.md#0x1_TypeInfo">TypeInfo</a>{
    <b>let</b> (account_address, module_name, struct_name) = <a href="Token.md#0x1_Token_type_of">Token::type_of</a>&lt;T&gt;();
    <a href="TypeInfo.md#0x1_TypeInfo">TypeInfo</a> {
        account_address,
        module_name,
        struct_name
    }
}
</code></pre>



</details>
