
<a name="0x1_NFTGalleryScripts"></a>

# Module `0x1::NFTGalleryScripts`



-  [Function `accept`](#0x1_NFTGalleryScripts_accept)
-  [Function `transfer`](#0x1_NFTGalleryScripts_transfer)
-  [Function `remove_empty_gallery`](#0x1_NFTGalleryScripts_remove_empty_gallery)
-  [Module Specification](#@Module_Specification_0)


<pre><code><b>use</b> <a href="NFT.md#0x1_NFTGallery">0x1::NFTGallery</a>;
</code></pre>



<a name="0x1_NFTGalleryScripts_accept"></a>

## Function `accept`

Init a  NFTGallery for accept NFT<NFTMeta, NFTBody>


<pre><code><b>public</b> entry <b>fun</b> <a href="NFT.md#0x1_NFTGalleryScripts_accept">accept</a>&lt;NFTMeta: <b>copy</b>, drop, store, NFTBody: store&gt;(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="NFT.md#0x1_NFTGalleryScripts_accept">accept</a>&lt;NFTMeta: <b>copy</b> + store + drop, NFTBody: store&gt;(sender: signer) {
    <a href="NFT.md#0x1_NFTGallery_accept_entry">NFTGallery::accept_entry</a>&lt;NFTMeta, NFTBody&gt;(sender);
}
</code></pre>



</details>

<a name="0x1_NFTGalleryScripts_transfer"></a>

## Function `transfer`

Transfer NFT<NFTMeta, NFTBody> with <code>id</code> from <code>sender</code> to <code>receiver</code>


<pre><code><b>public</b> entry <b>fun</b> <a href="NFT.md#0x1_NFTGalleryScripts_transfer">transfer</a>&lt;NFTMeta: <b>copy</b>, drop, store, NFTBody: store&gt;(sender: signer, id: u64, receiver: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="NFT.md#0x1_NFTGalleryScripts_transfer">transfer</a>&lt;NFTMeta: <b>copy</b> + store + drop, NFTBody: store&gt;(
    sender: signer,
    id: u64, receiver: <b>address</b>
) {
    <a href="NFT.md#0x1_NFTGallery_transfer_entry">NFTGallery::transfer_entry</a>&lt;NFTMeta, NFTBody&gt;(sender, id, receiver);
}
</code></pre>



</details>

<a name="0x1_NFTGalleryScripts_remove_empty_gallery"></a>

## Function `remove_empty_gallery`

Remove empty NFTGallery<Meta,Body>.


<pre><code><b>public</b> entry <b>fun</b> <a href="NFT.md#0x1_NFTGalleryScripts_remove_empty_gallery">remove_empty_gallery</a>&lt;NFTMeta: <b>copy</b>, drop, store, NFTBody: store&gt;(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="NFT.md#0x1_NFTGalleryScripts_remove_empty_gallery">remove_empty_gallery</a>&lt;NFTMeta: <b>copy</b> + store + drop, NFTBody: store&gt;(sender: signer) {
    <a href="NFT.md#0x1_NFTGallery_remove_empty_gallery_entry">NFTGallery::remove_empty_gallery_entry</a>&lt;NFTMeta, NFTBody&gt;(sender);
}
</code></pre>



</details>

<a name="@Module_Specification_0"></a>

## Module Specification



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>
