
<a name="0x1_EasyGasScript"></a>

# Module `0x1::EasyGasScript`



-  [Function `register`](#0x1_EasyGasScript_register)
-  [Function `init_data_source`](#0x1_EasyGasScript_init_data_source)
-  [Function `update`](#0x1_EasyGasScript_update)
-  [Function `withdraw_gas_fee_entry`](#0x1_EasyGasScript_withdraw_gas_fee_entry)


<pre><code><b>use</b> <a href="EasyGas.md#0x1_EasyGas">0x1::EasyGas</a>;
</code></pre>



<a name="0x1_EasyGasScript_register"></a>

## Function `register`



<pre><code><b>public</b> entry <b>fun</b> <a href="EasyGas.md#0x1_EasyGasScript_register">register</a>&lt;TokenType: store&gt;(sender: signer, precision: u8)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="EasyGas.md#0x1_EasyGasScript_register">register</a>&lt;TokenType: store&gt;(sender: signer, precision: u8) {
    <a href="EasyGas.md#0x1_EasyGas_register_oracle">EasyGas::register_oracle</a>&lt;TokenType&gt;(&sender, precision)
}
</code></pre>



</details>

<a name="0x1_EasyGasScript_init_data_source"></a>

## Function `init_data_source`



<pre><code><b>public</b> entry <b>fun</b> <a href="EasyGas.md#0x1_EasyGasScript_init_data_source">init_data_source</a>&lt;TokenType: store&gt;(sender: signer, init_value: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="EasyGas.md#0x1_EasyGasScript_init_data_source">init_data_source</a>&lt;TokenType: store&gt;(sender: signer, init_value: u128) {
    <a href="EasyGas.md#0x1_EasyGas_init_oracle_source">EasyGas::init_oracle_source</a>&lt;TokenType&gt;(&sender, init_value);
}
</code></pre>



</details>

<a name="0x1_EasyGasScript_update"></a>

## Function `update`



<pre><code><b>public</b> entry <b>fun</b> <b>update</b>&lt;TokenType: store&gt;(sender: signer, value: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <b>update</b>&lt;TokenType: store&gt;(sender: signer, value: u128) {
    <a href="EasyGas.md#0x1_EasyGas_update_oracle">EasyGas::update_oracle</a>&lt;TokenType&gt;(&sender, value)
}
</code></pre>



</details>

<a name="0x1_EasyGasScript_withdraw_gas_fee_entry"></a>

## Function `withdraw_gas_fee_entry`



<pre><code><b>public</b> entry <b>fun</b> <a href="EasyGas.md#0x1_EasyGasScript_withdraw_gas_fee_entry">withdraw_gas_fee_entry</a>&lt;TokenType: store&gt;(sender: signer, amount: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="EasyGas.md#0x1_EasyGasScript_withdraw_gas_fee_entry">withdraw_gas_fee_entry</a>&lt;TokenType: store&gt;(sender: signer, amount: u128) {
    <a href="EasyGas.md#0x1_EasyGas_withdraw_gas_fee">EasyGas::withdraw_gas_fee</a>&lt;TokenType&gt;(&sender, amount);
}
</code></pre>



</details>
