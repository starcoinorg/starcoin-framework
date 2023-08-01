
<a name="0x1_EasyGasOracleScript"></a>

# Module `0x1::EasyGasOracleScript`



-  [Function `register`](#0x1_EasyGasOracleScript_register)
-  [Function `init_data_source`](#0x1_EasyGasOracleScript_init_data_source)
-  [Function `update`](#0x1_EasyGasOracleScript_update)


<pre><code><b>use</b> <a href="EasyGas.md#0x1_EasyGasOracle">0x1::EasyGasOracle</a>;
</code></pre>



<a name="0x1_EasyGasOracleScript_register"></a>

## Function `register`



<pre><code><b>public</b> entry <b>fun</b> <a href="EasyGas.md#0x1_EasyGasOracleScript_register">register</a>&lt;TokenType: store&gt;(sender: signer, precision: u8)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="EasyGas.md#0x1_EasyGasOracleScript_register">register</a>&lt;TokenType: store&gt;(sender: signer, precision: u8) {
    <a href="EasyGas.md#0x1_EasyGasOracle_register">EasyGasOracle::register</a>&lt;TokenType&gt;(&sender, precision)
}
</code></pre>



</details>

<a name="0x1_EasyGasOracleScript_init_data_source"></a>

## Function `init_data_source`



<pre><code><b>public</b> entry <b>fun</b> <a href="EasyGas.md#0x1_EasyGasOracleScript_init_data_source">init_data_source</a>&lt;TokenType: store&gt;(sender: signer, init_value: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="EasyGas.md#0x1_EasyGasOracleScript_init_data_source">init_data_source</a>&lt;TokenType: store&gt;(sender: signer, init_value: u128) {
    <a href="EasyGas.md#0x1_EasyGasOracle_init_data_source">EasyGasOracle::init_data_source</a>&lt;TokenType&gt;(&sender,init_value);
}
</code></pre>



</details>

<a name="0x1_EasyGasOracleScript_update"></a>

## Function `update`



<pre><code><b>public</b> entry <b>fun</b> <b>update</b>&lt;TokenType: store&gt;(sender: signer, value: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <b>update</b>&lt;TokenType: store&gt;(sender: signer, value: u128) {
    <a href="EasyGas.md#0x1_EasyGasOracle_update">EasyGasOracle::update</a>&lt;TokenType&gt;(&sender,value)
}
</code></pre>



</details>
