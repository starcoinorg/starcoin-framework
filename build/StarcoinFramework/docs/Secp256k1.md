
<a name="0x1_Secp256k1"></a>

# Module `0x1::Secp256k1`

This module implements ECDSA signatures based on the prime-order secp256k1 ellptic curve (i.e., cofactor is 1).


-  [Struct `ECDSARawPublicKey`](#0x1_Secp256k1_ECDSARawPublicKey)
-  [Struct `ECDSASignature`](#0x1_Secp256k1_ECDSASignature)
-  [Constants](#@Constants_0)
-  [Function `ecdsa_signature_from_bytes`](#0x1_Secp256k1_ecdsa_signature_from_bytes)
-  [Function `ecdsa_raw_public_key_from_64_bytes`](#0x1_Secp256k1_ecdsa_raw_public_key_from_64_bytes)
-  [Function `ecdsa_raw_public_key_to_bytes`](#0x1_Secp256k1_ecdsa_raw_public_key_to_bytes)
-  [Function `ecdsa_signature_to_bytes`](#0x1_Secp256k1_ecdsa_signature_to_bytes)
-  [Function `ecdsa_recover`](#0x1_Secp256k1_ecdsa_recover)
-  [Function `ecdsa_recover_internal`](#0x1_Secp256k1_ecdsa_recover_internal)


<pre><code><b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_Secp256k1_ECDSARawPublicKey"></a>

## Struct `ECDSARawPublicKey`

A 64-byte ECDSA public key.


<pre><code><b>struct</b> <a href="Secp256k1.md#0x1_Secp256k1_ECDSARawPublicKey">ECDSARawPublicKey</a> <b>has</b> <b>copy</b>, drop, store
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

<a name="0x1_Secp256k1_ECDSASignature"></a>

## Struct `ECDSASignature`

A 64-byte ECDSA signature.


<pre><code><b>struct</b> <a href="Secp256k1.md#0x1_Secp256k1_ECDSASignature">ECDSASignature</a> <b>has</b> <b>copy</b>, drop, store
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


<a name="0x1_Secp256k1_E_DESERIALIZE"></a>

An error occurred while deserializing, for example due to wrong input size.


<pre><code><b>const</b> <a href="Secp256k1.md#0x1_Secp256k1_E_DESERIALIZE">E_DESERIALIZE</a>: u64 = 1;
</code></pre>



<a name="0x1_Secp256k1_RAW_PUBLIC_KEY_NUM_BYTES"></a>

The size of a secp256k1-based ECDSA public key, in bytes.


<pre><code><b>const</b> <a href="Secp256k1.md#0x1_Secp256k1_RAW_PUBLIC_KEY_NUM_BYTES">RAW_PUBLIC_KEY_NUM_BYTES</a>: u64 = 64;
</code></pre>



<a name="0x1_Secp256k1_SIGNATURE_NUM_BYTES"></a>

The size of a secp256k1-based ECDSA signature, in bytes.


<pre><code><b>const</b> <a href="Secp256k1.md#0x1_Secp256k1_SIGNATURE_NUM_BYTES">SIGNATURE_NUM_BYTES</a>: u64 = 64;
</code></pre>



<a name="0x1_Secp256k1_ecdsa_signature_from_bytes"></a>

## Function `ecdsa_signature_from_bytes`

Constructs an ECDSASignature struct from the given 64 bytes.


<pre><code><b>public</b> <b>fun</b> <a href="Secp256k1.md#0x1_Secp256k1_ecdsa_signature_from_bytes">ecdsa_signature_from_bytes</a>(bytes: vector&lt;u8&gt;): <a href="Secp256k1.md#0x1_Secp256k1_ECDSASignature">Secp256k1::ECDSASignature</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Secp256k1.md#0x1_Secp256k1_ecdsa_signature_from_bytes">ecdsa_signature_from_bytes</a>(bytes: vector&lt;u8&gt;): <a href="Secp256k1.md#0x1_Secp256k1_ECDSASignature">ECDSASignature</a> {
    <b>assert</b>!(<a href="Vector.md#0x1_Vector_length">Vector::length</a>(&bytes) == <a href="Secp256k1.md#0x1_Secp256k1_SIGNATURE_NUM_BYTES">SIGNATURE_NUM_BYTES</a>, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="Secp256k1.md#0x1_Secp256k1_E_DESERIALIZE">E_DESERIALIZE</a>));
    <a href="Secp256k1.md#0x1_Secp256k1_ECDSASignature">ECDSASignature</a> { bytes }
}
</code></pre>



</details>

<a name="0x1_Secp256k1_ecdsa_raw_public_key_from_64_bytes"></a>

## Function `ecdsa_raw_public_key_from_64_bytes`

Constructs an ECDSARawPublicKey struct, given a 64-byte raw representation.


<pre><code><b>public</b> <b>fun</b> <a href="Secp256k1.md#0x1_Secp256k1_ecdsa_raw_public_key_from_64_bytes">ecdsa_raw_public_key_from_64_bytes</a>(bytes: vector&lt;u8&gt;): <a href="Secp256k1.md#0x1_Secp256k1_ECDSARawPublicKey">Secp256k1::ECDSARawPublicKey</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Secp256k1.md#0x1_Secp256k1_ecdsa_raw_public_key_from_64_bytes">ecdsa_raw_public_key_from_64_bytes</a>(bytes: vector&lt;u8&gt;): <a href="Secp256k1.md#0x1_Secp256k1_ECDSARawPublicKey">ECDSARawPublicKey</a> {
    <b>assert</b>!(<a href="Vector.md#0x1_Vector_length">Vector::length</a>(&bytes) == <a href="Secp256k1.md#0x1_Secp256k1_RAW_PUBLIC_KEY_NUM_BYTES">RAW_PUBLIC_KEY_NUM_BYTES</a>, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="Secp256k1.md#0x1_Secp256k1_E_DESERIALIZE">E_DESERIALIZE</a>));
    <a href="Secp256k1.md#0x1_Secp256k1_ECDSARawPublicKey">ECDSARawPublicKey</a> { bytes }
}
</code></pre>



</details>

<a name="0x1_Secp256k1_ecdsa_raw_public_key_to_bytes"></a>

## Function `ecdsa_raw_public_key_to_bytes`

Serializes an ECDSARawPublicKey struct to 64-bytes.


<pre><code><b>public</b> <b>fun</b> <a href="Secp256k1.md#0x1_Secp256k1_ecdsa_raw_public_key_to_bytes">ecdsa_raw_public_key_to_bytes</a>(pk: &<a href="Secp256k1.md#0x1_Secp256k1_ECDSARawPublicKey">Secp256k1::ECDSARawPublicKey</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Secp256k1.md#0x1_Secp256k1_ecdsa_raw_public_key_to_bytes">ecdsa_raw_public_key_to_bytes</a>(pk: &<a href="Secp256k1.md#0x1_Secp256k1_ECDSARawPublicKey">ECDSARawPublicKey</a>): vector&lt;u8&gt; {
    *&pk.bytes
}
</code></pre>



</details>

<a name="0x1_Secp256k1_ecdsa_signature_to_bytes"></a>

## Function `ecdsa_signature_to_bytes`

Serializes an ECDSASignature struct to 64-bytes.


<pre><code><b>public</b> <b>fun</b> <a href="Secp256k1.md#0x1_Secp256k1_ecdsa_signature_to_bytes">ecdsa_signature_to_bytes</a>(sig: &<a href="Secp256k1.md#0x1_Secp256k1_ECDSASignature">Secp256k1::ECDSASignature</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Secp256k1.md#0x1_Secp256k1_ecdsa_signature_to_bytes">ecdsa_signature_to_bytes</a>(sig: &<a href="Secp256k1.md#0x1_Secp256k1_ECDSASignature">ECDSASignature</a>): vector&lt;u8&gt; {
    *&sig.bytes
}
</code></pre>



</details>

<a name="0x1_Secp256k1_ecdsa_recover"></a>

## Function `ecdsa_recover`

Recovers the signer's raw (64-byte) public key from a secp256k1 ECDSA <code>signature</code> given the <code>recovery_id</code> and the signed
<code>message</code> (32 byte digest).

Note that an invalid signature, or a signature from a different message, will result in the recovery of an
incorrect public key. This recovery algorithm can only be used to check validity of a signature if the signer's
public key (or its hash) is known beforehand.


<pre><code><b>public</b> <b>fun</b> <a href="Secp256k1.md#0x1_Secp256k1_ecdsa_recover">ecdsa_recover</a>(message: vector&lt;u8&gt;, recovery_id: u8, signature: &<a href="Secp256k1.md#0x1_Secp256k1_ECDSASignature">Secp256k1::ECDSASignature</a>): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;<a href="Secp256k1.md#0x1_Secp256k1_ECDSARawPublicKey">Secp256k1::ECDSARawPublicKey</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Secp256k1.md#0x1_Secp256k1_ecdsa_recover">ecdsa_recover</a>(
    message: vector&lt;u8&gt;,
    recovery_id: u8,
    signature: &<a href="Secp256k1.md#0x1_Secp256k1_ECDSASignature">ECDSASignature</a>,
): <a href="Option.md#0x1_Option">Option</a>&lt;<a href="Secp256k1.md#0x1_Secp256k1_ECDSARawPublicKey">ECDSARawPublicKey</a>&gt; {
    <b>let</b> (pk, success) = <a href="Secp256k1.md#0x1_Secp256k1_ecdsa_recover_internal">ecdsa_recover_internal</a>(message, recovery_id, *&signature.bytes);
    <b>if</b> (success) {
        <a href="Option.md#0x1_Option_some">Option::some</a>(<a href="Secp256k1.md#0x1_Secp256k1_ecdsa_raw_public_key_from_64_bytes">ecdsa_raw_public_key_from_64_bytes</a>(pk))
    } <b>else</b> {
        <a href="Option.md#0x1_Option_none">Option::none</a>&lt;<a href="Secp256k1.md#0x1_Secp256k1_ECDSARawPublicKey">ECDSARawPublicKey</a>&gt;()
    }
}
</code></pre>



</details>

<a name="0x1_Secp256k1_ecdsa_recover_internal"></a>

## Function `ecdsa_recover_internal`

Returns <code>(public_key, <b>true</b>)</code> if <code>signature</code> verifies on <code>message</code> under the recovered <code>public_key</code>
and returns <code>([], <b>false</b>)</code> otherwise.


<pre><code><b>fun</b> <a href="Secp256k1.md#0x1_Secp256k1_ecdsa_recover_internal">ecdsa_recover_internal</a>(message: vector&lt;u8&gt;, recovery_id: u8, signature: vector&lt;u8&gt;): (vector&lt;u8&gt;, bool)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>native</b> <b>fun</b> <a href="Secp256k1.md#0x1_Secp256k1_ecdsa_recover_internal">ecdsa_recover_internal</a>(
    message: vector&lt;u8&gt;,
    recovery_id: u8,
    signature: vector&lt;u8&gt;
): (vector&lt;u8&gt;, bool);
</code></pre>



</details>
