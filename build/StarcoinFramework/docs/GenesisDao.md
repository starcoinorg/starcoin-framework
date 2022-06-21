
<a name="0x1_GenesisDao"></a>

# Module `0x1::GenesisDao`



-  [Resource `Dao`](#0x1_GenesisDao_Dao)
-  [Resource `DaoExt`](#0x1_GenesisDao_DaoExt)
-  [Resource `DaoAccountCapHolder`](#0x1_GenesisDao_DaoAccountCapHolder)
-  [Resource `DaoTokenMintCapHolder`](#0x1_GenesisDao_DaoTokenMintCapHolder)
-  [Resource `DaoTokenBurnCapHolder`](#0x1_GenesisDao_DaoTokenBurnCapHolder)
-  [Resource `DaoNFTMintCapHolder`](#0x1_GenesisDao_DaoNFTMintCapHolder)
-  [Resource `DaoNFTBurnCapHolder`](#0x1_GenesisDao_DaoNFTBurnCapHolder)
-  [Resource `DaoNFTUpdateCapHolder`](#0x1_GenesisDao_DaoNFTUpdateCapHolder)
-  [Struct `CapType`](#0x1_GenesisDao_CapType)
-  [Struct `DaoRootCap`](#0x1_GenesisDao_DaoRootCap)
-  [Struct `DaoUpgradeModuleCap`](#0x1_GenesisDao_DaoUpgradeModuleCap)
-  [Struct `DaoWithdrawTokenCap`](#0x1_GenesisDao_DaoWithdrawTokenCap)
-  [Struct `DaoWithdrawNFTCap`](#0x1_GenesisDao_DaoWithdrawNFTCap)
-  [Struct `DaoStorageCap`](#0x1_GenesisDao_DaoStorageCap)
-  [Struct `DaoMemberCap`](#0x1_GenesisDao_DaoMemberCap)
-  [Struct `DaoProposalCap`](#0x1_GenesisDao_DaoProposalCap)
-  [Resource `DaoRootCapHolder`](#0x1_GenesisDao_DaoRootCapHolder)
-  [Resource `InstalledPluginInfo`](#0x1_GenesisDao_InstalledPluginInfo)
-  [Struct `DaoMember`](#0x1_GenesisDao_DaoMember)
-  [Struct `DaoMemberBody`](#0x1_GenesisDao_DaoMemberBody)
-  [Resource `StorageItem`](#0x1_GenesisDao_StorageItem)
-  [Struct `ProposalState`](#0x1_GenesisDao_ProposalState)
-  [Struct `VotingChoice`](#0x1_GenesisDao_VotingChoice)
-  [Struct `Proposal`](#0x1_GenesisDao_Proposal)
-  [Struct `ProposalAction`](#0x1_GenesisDao_ProposalAction)
-  [Struct `ProposalInfo`](#0x1_GenesisDao_ProposalInfo)
-  [Resource `MyProposals`](#0x1_GenesisDao_MyProposals)
-  [Resource `GlobalProposals`](#0x1_GenesisDao_GlobalProposals)
-  [Struct `Vote`](#0x1_GenesisDao_Vote)
-  [Resource `MyVotes`](#0x1_GenesisDao_MyVotes)
-  [Constants](#@Constants_0)
-  [Function `upgrade_module_cap_type`](#0x1_GenesisDao_upgrade_module_cap_type)
-  [Function `withdraw_token_cap_type`](#0x1_GenesisDao_withdraw_token_cap_type)
-  [Function `withdraw_nft_cap_type`](#0x1_GenesisDao_withdraw_nft_cap_type)
-  [Function `storage_cap_type`](#0x1_GenesisDao_storage_cap_type)
-  [Function `member_cap_type`](#0x1_GenesisDao_member_cap_type)
-  [Function `proposal_cap_type`](#0x1_GenesisDao_proposal_cap_type)
-  [Function `all_caps`](#0x1_GenesisDao_all_caps)
-  [Function `create_dao`](#0x1_GenesisDao_create_dao)
-  [Function `upgrade_to_dao`](#0x1_GenesisDao_upgrade_to_dao)
-  [Function `install_plugin`](#0x1_GenesisDao_install_plugin)
-  [Function `save`](#0x1_GenesisDao_save)
-  [Function `take`](#0x1_GenesisDao_take)
-  [Function `withdraw_token`](#0x1_GenesisDao_withdraw_token)
-  [Function `next_member_id`](#0x1_GenesisDao_next_member_id)
-  [Function `join_member`](#0x1_GenesisDao_join_member)
-  [Function `quit_member`](#0x1_GenesisDao_quit_member)
-  [Function `revoke_member`](#0x1_GenesisDao_revoke_member)
-  [Function `update_member_sbt`](#0x1_GenesisDao_update_member_sbt)
-  [Function `is_member`](#0x1_GenesisDao_is_member)
-  [Function `validate_cap`](#0x1_GenesisDao_validate_cap)
-  [Function `acquire_withdraw_token_cap`](#0x1_GenesisDao_acquire_withdraw_token_cap)
-  [Function `acquire_storage_cap`](#0x1_GenesisDao_acquire_storage_cap)
-  [Function `acquire_proposal_cap`](#0x1_GenesisDao_acquire_proposal_cap)
-  [Function `choice_yes`](#0x1_GenesisDao_choice_yes)
-  [Function `choice_no`](#0x1_GenesisDao_choice_no)
-  [Function `choice_no_with_veto`](#0x1_GenesisDao_choice_no_with_veto)
-  [Function `choice_abstain`](#0x1_GenesisDao_choice_abstain)
-  [Function `create_proposal`](#0x1_GenesisDao_create_proposal)
-  [Function `block_number_and_state_root`](#0x1_GenesisDao_block_number_and_state_root)
-  [Function `voting_period`](#0x1_GenesisDao_voting_period)
-  [Function `voting_delay`](#0x1_GenesisDao_voting_delay)
-  [Function `min_action_delay`](#0x1_GenesisDao_min_action_delay)
-  [Function `generate_next_proposal_id`](#0x1_GenesisDao_generate_next_proposal_id)
-  [Function `quorum_votes`](#0x1_GenesisDao_quorum_votes)
-  [Function `cast_vote`](#0x1_GenesisDao_cast_vote)
-  [Function `change_vote`](#0x1_GenesisDao_change_vote)
-  [Function `revoke_vote`](#0x1_GenesisDao_revoke_vote)
-  [Function `extract_proposal_action`](#0x1_GenesisDao_extract_proposal_action)
-  [Function `has_voted`](#0x1_GenesisDao_has_voted)
-  [Function `do_cast_vote`](#0x1_GenesisDao_do_cast_vote)
-  [Function `get_vote`](#0x1_GenesisDao_get_vote)
-  [Function `proposal_state`](#0x1_GenesisDao_proposal_state)
-  [Function `get_proposal_mut`](#0x1_GenesisDao_get_proposal_mut)
-  [Function `get_proposal`](#0x1_GenesisDao_get_proposal)
-  [Function `remove_element`](#0x1_GenesisDao_remove_element)
-  [Function `add_element`](#0x1_GenesisDao_add_element)
-  [Function `dao_signer`](#0x1_GenesisDao_dao_signer)
-  [Function `dao_address`](#0x1_GenesisDao_dao_address)


<pre><code><b>use</b> <a href="Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="DaoAccount.md#0x1_DaoAccount">0x1::DaoAccount</a>;
<b>use</b> <a href="DaoRegistry.md#0x1_DaoRegistry">0x1::DaoRegistry</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="NFT.md#0x1_IdentifierNFT">0x1::IdentifierNFT</a>;
<b>use</b> <a href="NFT.md#0x1_NFT">0x1::NFT</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="STC.md#0x1_STC">0x1::STC</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
<b>use</b> <a href="Token.md#0x1_Token">0x1::Token</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
<b>use</b> <a href="VoteUtil.md#0x1_VoteUtil">0x1::VoteUtil</a>;
</code></pre>



<a name="0x1_GenesisDao_Dao"></a>

## Resource `Dao`



<pre><code><b>struct</b> <a href="Dao.md#0x1_Dao">Dao</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>name: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>dao_address: <b>address</b></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoExt"></a>

## Resource `DaoExt`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoExt">DaoExt</a>&lt;DaoT: store&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>ext: DaoT</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoAccountCapHolder"></a>

## Resource `DaoAccountCapHolder`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccount::DaoAccountCapability</a></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoTokenMintCapHolder"></a>

## Resource `DaoTokenMintCapHolder`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoTokenMintCapHolder">DaoTokenMintCapHolder</a>&lt;DaoT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="Token.md#0x1_Token_MintCapability">Token::MintCapability</a>&lt;DaoT&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoTokenBurnCapHolder"></a>

## Resource `DaoTokenBurnCapHolder`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoTokenBurnCapHolder">DaoTokenBurnCapHolder</a>&lt;DaoT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="Token.md#0x1_Token_BurnCapability">Token::BurnCapability</a>&lt;DaoT&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoNFTMintCapHolder"></a>

## Resource `DaoNFTMintCapHolder`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoNFTMintCapHolder">DaoNFTMintCapHolder</a>&lt;DaoT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="NFT.md#0x1_NFT_MintCapability">NFT::MintCapability</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">GenesisDao::DaoMember</a>&lt;DaoT&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoNFTBurnCapHolder"></a>

## Resource `DaoNFTBurnCapHolder`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoNFTBurnCapHolder">DaoNFTBurnCapHolder</a>&lt;DaoT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="NFT.md#0x1_NFT_BurnCapability">NFT::BurnCapability</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">GenesisDao::DaoMember</a>&lt;DaoT&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoNFTUpdateCapHolder"></a>

## Resource `DaoNFTUpdateCapHolder`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoNFTUpdateCapHolder">DaoNFTUpdateCapHolder</a>&lt;DaoT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="NFT.md#0x1_NFT_UpdateCapability">NFT::UpdateCapability</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">GenesisDao::DaoMember</a>&lt;DaoT&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_CapType"></a>

## Struct `CapType`

A type describing a capability.


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>code: u8</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoRootCap"></a>

## Struct `DaoRootCap`

RootCap only have one instance, and can not been <code>drop</code>


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">DaoRootCap</a>&lt;DaoT&gt; <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dummy_field: bool</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoUpgradeModuleCap"></a>

## Struct `DaoUpgradeModuleCap`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoUpgradeModuleCap">DaoUpgradeModuleCap</a>&lt;DaoT, PluginT&gt; <b>has</b> drop
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dummy_field: bool</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoWithdrawTokenCap"></a>

## Struct `DaoWithdrawTokenCap`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawTokenCap">DaoWithdrawTokenCap</a>&lt;DaoT, PluginT&gt; <b>has</b> drop
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dummy_field: bool</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoWithdrawNFTCap"></a>

## Struct `DaoWithdrawNFTCap`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawNFTCap">DaoWithdrawNFTCap</a>&lt;DaoT, PluginT&gt; <b>has</b> drop
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dummy_field: bool</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoStorageCap"></a>

## Struct `DaoStorageCap`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoStorageCap">DaoStorageCap</a>&lt;DaoT, PluginT&gt; <b>has</b> drop
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dummy_field: bool</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoMemberCap"></a>

## Struct `DaoMemberCap`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">DaoMemberCap</a>&lt;DaoT, PluginT&gt; <b>has</b> drop
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dummy_field: bool</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoProposalCap"></a>

## Struct `DaoProposalCap`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoProposalCap">DaoProposalCap</a>&lt;DaoT, ActionT&gt; <b>has</b> drop
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dummy_field: bool</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoRootCapHolder"></a>

## Resource `DaoRootCapHolder`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCapHolder">DaoRootCapHolder</a>&lt;DaoT, GovPluginT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">GenesisDao::DaoRootCap</a>&lt;DaoT&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_InstalledPluginInfo"></a>

## Resource `InstalledPluginInfo`

The info for Dao installed Plugin


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a>&lt;PluginT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>granted_caps: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoMember"></a>

## Struct `DaoMember`

The Dao member NFT metadata


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt; <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>id: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoMemberBody"></a>

## Struct `DaoMemberBody`

The Dao member NFT Body, hold the SBT token


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberBody">DaoMemberBody</a>&lt;DaoT&gt; <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>sbt: <a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;DaoT&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_StorageItem"></a>

## Resource `StorageItem`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_StorageItem">StorageItem</a>&lt;PluginT, V: store&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>item: V</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_ProposalState"></a>

## Struct `ProposalState`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_ProposalState">ProposalState</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>state: u8</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_VotingChoice"></a>

## Struct `VotingChoice`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>choice: u8</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_Proposal"></a>

## Struct `Proposal`

Proposal data struct.


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_Proposal">Proposal</a> <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>id: u64</code>
</dt>
<dd>
 id of the proposal
</dd>
<dt>
<code>proposer: <b>address</b></code>
</dt>
<dd>
 creator of the proposal
</dd>
<dt>
<code>start_time: u64</code>
</dt>
<dd>
 when voting begins.
</dd>
<dt>
<code>end_time: u64</code>
</dt>
<dd>
 when voting ends.
</dd>
<dt>
<code>votes: vector&lt;u128&gt;</code>
</dt>
<dd>
 count of voters who <code>yes|no|no_with_veto|abstain</code> with the proposal
</dd>
<dt>
<code>eta: u64</code>
</dt>
<dd>
 executable after this time.
</dd>
<dt>
<code>action_delay: u64</code>
</dt>
<dd>
 after how long, the agreed proposal can be executed.
</dd>
<dt>
<code>quorum_votes: u128</code>
</dt>
<dd>
 how many votes to reach to make the proposal pass.
</dd>
<dt>
<code>block_number: u64</code>
</dt>
<dd>
 The block number when submit proposal
</dd>
<dt>
<code>state_root: vector&lt;u8&gt;</code>
</dt>
<dd>
 the state root of the block which has the block_number
</dd>
</dl>


</details>

<a name="0x1_GenesisDao_ProposalAction"></a>

## Struct `ProposalAction`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_ProposalAction">ProposalAction</a>&lt;Action: store&gt; <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>deposit: <a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;<a href="STC.md#0x1_STC_STC">STC::STC</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>action: Action</code>
</dt>
<dd>
 proposal action.
</dd>
</dl>


</details>

<a name="0x1_GenesisDao_ProposalInfo"></a>

## Struct `ProposalInfo`

Same as Proposal but has copy and drop


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_ProposalInfo">ProposalInfo</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dummy_field: bool</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_MyProposals"></a>

## Resource `MyProposals`

Every proposer keep a vector<ProposalAction<ActionT>> for per Dao, per Action


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_MyProposals">MyProposals</a>&lt;DaoT, ActionT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>proposals: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_ProposalAction">GenesisDao::ProposalAction</a>&lt;ActionT&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_GlobalProposals"></a>

## Resource `GlobalProposals`

Keep a global proposal record for query proposal by id.
Replace with Table when support Table.


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>proposals: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_Proposal">GenesisDao::Proposal</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_Vote"></a>

## Struct `Vote`

User vote info.


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_Vote">Vote</a> <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>proposal_id: u64</code>
</dt>
<dd>
 proposal id.
</dd>
<dt>
<code>weight: u128</code>
</dt>
<dd>
 vote weight
</dd>
<dt>
<code>choice: u8</code>
</dt>
<dd>
 vote choise
</dd>
</dl>


</details>

<a name="0x1_GenesisDao_MyVotes"></a>

## Resource `MyVotes`

Every voter keep a vector Vote for per Dao


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_MyVotes">MyVotes</a>&lt;DaoT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>votes: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_Vote">GenesisDao::Vote</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_GenesisDao_ERR_NOT_AUTHORIZED"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_NOT_AUTHORIZED">ERR_NOT_AUTHORIZED</a>: u64 = 1401;
</code></pre>



<a name="0x1_GenesisDao_ACTIVE"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ACTIVE">ACTIVE</a>: u8 = 2;
</code></pre>



<a name="0x1_GenesisDao_AGREED"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_AGREED">AGREED</a>: u8 = 4;
</code></pre>



<a name="0x1_GenesisDao_DEFEATED"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_DEFEATED">DEFEATED</a>: u8 = 3;
</code></pre>



<a name="0x1_GenesisDao_ERR_ACTION_DELAY_TOO_SMALL"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_ACTION_DELAY_TOO_SMALL">ERR_ACTION_DELAY_TOO_SMALL</a>: u64 = 1402;
</code></pre>



<a name="0x1_GenesisDao_ERR_ACTION_MUST_EXIST"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_ACTION_MUST_EXIST">ERR_ACTION_MUST_EXIST</a>: u64 = 1409;
</code></pre>



<a name="0x1_GenesisDao_ERR_CONFIG_PARAM_INVALID"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>: u64 = 1407;
</code></pre>



<a name="0x1_GenesisDao_ERR_PROPOSAL_ID_MISMATCH"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSAL_ID_MISMATCH">ERR_PROPOSAL_ID_MISMATCH</a>: u64 = 1404;
</code></pre>



<a name="0x1_GenesisDao_ERR_PROPOSAL_STATE_INVALID"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSAL_STATE_INVALID">ERR_PROPOSAL_STATE_INVALID</a>: u64 = 1403;
</code></pre>



<a name="0x1_GenesisDao_ERR_PROPOSER_MISMATCH"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSER_MISMATCH">ERR_PROPOSER_MISMATCH</a>: u64 = 1405;
</code></pre>



<a name="0x1_GenesisDao_ERR_QUORUM_RATE_INVALID"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_QUORUM_RATE_INVALID">ERR_QUORUM_RATE_INVALID</a>: u64 = 1406;
</code></pre>



<a name="0x1_GenesisDao_ERR_VOTED_OTHERS_ALREADY"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_VOTED_OTHERS_ALREADY">ERR_VOTED_OTHERS_ALREADY</a>: u64 = 1410;
</code></pre>



<a name="0x1_GenesisDao_ERR_VOTE_STATE_MISMATCH"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_VOTE_STATE_MISMATCH">ERR_VOTE_STATE_MISMATCH</a>: u64 = 1408;
</code></pre>



<a name="0x1_GenesisDao_EXECUTABLE"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_EXECUTABLE">EXECUTABLE</a>: u8 = 6;
</code></pre>



<a name="0x1_GenesisDao_EXTRACTED"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_EXTRACTED">EXTRACTED</a>: u8 = 7;
</code></pre>



<a name="0x1_GenesisDao_PENDING"></a>

Proposal
--------------------------------------------------
Proposal state


<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_PENDING">PENDING</a>: u8 = 1;
</code></pre>



<a name="0x1_GenesisDao_QUEUED"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_QUEUED">QUEUED</a>: u8 = 5;
</code></pre>



<a name="0x1_GenesisDao_E_NO_GRANTED"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_E_NO_GRANTED">E_NO_GRANTED</a>: u64 = 1;
</code></pre>



<a name="0x1_GenesisDao_VOTING_CHOICE_ABSTAIN"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_VOTING_CHOICE_ABSTAIN">VOTING_CHOICE_ABSTAIN</a>: u8 = 4;
</code></pre>



<a name="0x1_GenesisDao_VOTING_CHOICE_NO"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_VOTING_CHOICE_NO">VOTING_CHOICE_NO</a>: u8 = 2;
</code></pre>



<a name="0x1_GenesisDao_VOTING_CHOICE_NO_WITH_VETO"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_VOTING_CHOICE_NO_WITH_VETO">VOTING_CHOICE_NO_WITH_VETO</a>: u8 = 3;
</code></pre>



<a name="0x1_GenesisDao_VOTING_CHOICE_YES"></a>

voting choice: 1:yes, 2:no, 3: no_with_veto, 4:abstain


<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_VOTING_CHOICE_YES">VOTING_CHOICE_YES</a>: u8 = 1;
</code></pre>



<a name="0x1_GenesisDao_upgrade_module_cap_type"></a>

## Function `upgrade_module_cap_type`

Creates a upgrade module capability type.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_upgrade_module_cap_type">upgrade_module_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_upgrade_module_cap_type">upgrade_module_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a> { <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>{ code : 0 } }
</code></pre>



</details>

<a name="0x1_GenesisDao_withdraw_token_cap_type"></a>

## Function `withdraw_token_cap_type`

Creates a withdraw Token capability type.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_withdraw_token_cap_type">withdraw_token_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_withdraw_token_cap_type">withdraw_token_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a> { <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>{ code : 1 } }
</code></pre>



</details>

<a name="0x1_GenesisDao_withdraw_nft_cap_type"></a>

## Function `withdraw_nft_cap_type`

Creates a withdraw NFT capability type.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_withdraw_nft_cap_type">withdraw_nft_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_withdraw_nft_cap_type">withdraw_nft_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a> { <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>{ code : 2 } }
</code></pre>



</details>

<a name="0x1_GenesisDao_storage_cap_type"></a>

## Function `storage_cap_type`

Crates a write data to Dao account capability type.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_storage_cap_type">storage_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_storage_cap_type">storage_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a> { <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>{ code : 3 } }
</code></pre>



</details>

<a name="0x1_GenesisDao_member_cap_type"></a>

## Function `member_cap_type`

Crates a member capability type.
This cap can issue Dao member NFT or update member's SBT


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_member_cap_type">member_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_member_cap_type">member_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a> { <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>{ code : 4 } }
</code></pre>



</details>

<a name="0x1_GenesisDao_proposal_cap_type"></a>

## Function `proposal_cap_type`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_proposal_cap_type">proposal_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_proposal_cap_type">proposal_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a> { <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>{ code : 5 } }
</code></pre>



</details>

<a name="0x1_GenesisDao_all_caps"></a>

## Function `all_caps`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_all_caps">all_caps</a>(): vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_all_caps">all_caps</a>(): vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>&gt;{
    <b>let</b> caps = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(<a href="GenesisDao.md#0x1_GenesisDao_upgrade_module_cap_type">upgrade_module_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="GenesisDao.md#0x1_GenesisDao_withdraw_token_cap_type">withdraw_token_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="GenesisDao.md#0x1_GenesisDao_withdraw_nft_cap_type">withdraw_nft_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="GenesisDao.md#0x1_GenesisDao_storage_cap_type">storage_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="GenesisDao.md#0x1_GenesisDao_member_cap_type">member_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="GenesisDao.md#0x1_GenesisDao_proposal_cap_type">proposal_cap_type</a>());
    caps
}
</code></pre>



</details>

<a name="0x1_GenesisDao_create_dao"></a>

## Function `create_dao`

Create a dao with a exists Dao account


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_create_dao">create_dao</a>&lt;DaoT: store&gt;(cap: <a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCapability">DaoAccount::DaoAccountCapability</a>, name: vector&lt;u8&gt;, ext: DaoT): <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">GenesisDao::DaoRootCap</a>&lt;DaoT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_create_dao">create_dao</a>&lt;DaoT: store&gt;(cap: DaoAccountCapability, name: vector&lt;u8&gt;, ext: DaoT): <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">DaoRootCap</a>&lt;DaoT&gt; {
    <b>let</b> dao_signer = <a href="DaoAccount.md#0x1_DaoAccount_dao_signer">DaoAccount::dao_signer</a>(&cap);

    <b>let</b> dao_address = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&dao_signer);
    <b>let</b> id = <a href="DaoRegistry.md#0x1_DaoRegistry_register">DaoRegistry::register</a>&lt;DaoT&gt;(dao_address);
    <b>let</b> dao = <a href="Dao.md#0x1_Dao">Dao</a>{
        id,
        name: *&name,
        dao_address,
    };

    <b>move_to</b>(&dao_signer, dao);
    <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_DaoExt">DaoExt</a>{
        ext
    });
    <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a>{
        cap
    });

    <a href="Token.md#0x1_Token_register_token">Token::register_token</a>&lt;DaoT&gt;(&dao_signer, 1);
    <b>let</b> token_mint_cap = <a href="Token.md#0x1_Token_remove_mint_capability">Token::remove_mint_capability</a>&lt;DaoT&gt;(&dao_signer);
    <b>let</b> token_burn_cap = <a href="Token.md#0x1_Token_remove_burn_capability">Token::remove_burn_capability</a>&lt;DaoT&gt;(&dao_signer);

    <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_DaoTokenMintCapHolder">DaoTokenMintCapHolder</a>{
        cap: token_mint_cap,
    });
    <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_DaoTokenBurnCapHolder">DaoTokenBurnCapHolder</a>{
        cap: token_burn_cap,
    });

    <b>let</b> nft_name = name;
    <b>let</b> nft_image = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>let</b> nft_description = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;u8&gt;();
    <b>let</b> basemeta = <a href="NFT.md#0x1_NFT_new_meta_with_image_data">NFT::new_meta_with_image_data</a>(nft_name, nft_image, nft_description);

    <a href="NFT.md#0x1_NFT_register_v2">NFT::register_v2</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;&gt;(&dao_signer, basemeta);
    <b>let</b> nft_mint_cap = <a href="NFT.md#0x1_NFT_remove_mint_capability">NFT::remove_mint_capability</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;&gt;(&dao_signer);
    <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_DaoNFTMintCapHolder">DaoNFTMintCapHolder</a>{
        cap: nft_mint_cap,
    });
    //TODO hold the <a href="NFT.md#0x1_NFT">NFT</a> burn and <b>update</b> cap.

    <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">DaoRootCap</a>&lt;DaoT&gt;{}
}
</code></pre>



</details>

<a name="0x1_GenesisDao_upgrade_to_dao"></a>

## Function `upgrade_to_dao`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_upgrade_to_dao">upgrade_to_dao</a>&lt;DaoT: store&gt;(sender: signer, name: vector&lt;u8&gt;, ext: DaoT): <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">GenesisDao::DaoRootCap</a>&lt;DaoT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_upgrade_to_dao">upgrade_to_dao</a>&lt;DaoT: store&gt;(sender:signer, name: vector&lt;u8&gt;, ext: DaoT): <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">DaoRootCap</a>&lt;DaoT&gt; {
    <b>let</b> cap = <a href="DaoAccount.md#0x1_DaoAccount_upgrade_to_dao">DaoAccount::upgrade_to_dao</a>(sender);
    <a href="GenesisDao.md#0x1_GenesisDao_create_dao">create_dao</a>&lt;DaoT&gt;(cap, name, ext)
}
</code></pre>



</details>

<a name="0x1_GenesisDao_install_plugin"></a>

## Function `install_plugin`

Install PluginT to Dao and grant the capabilites


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_install_plugin">install_plugin</a>&lt;DaoT: store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">GenesisDao::DaoRootCap</a>&lt;DaoT&gt;, granted_caps: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_install_plugin">install_plugin</a>&lt;DaoT:store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">DaoRootCap</a>&lt;DaoT&gt;, granted_caps: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>&gt;) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a>{
    //TODO check no repeat item in granted_caps
    <b>let</b> dao_signer = <a href="GenesisDao.md#0x1_GenesisDao_dao_signer">dao_signer</a>&lt;DaoT&gt;();
    //TODO error code
    <b>assert</b>!(!<b>exists</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a>&lt;PluginT&gt;&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&dao_signer)), 1);
    <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a>&lt;PluginT&gt;{
        granted_caps,
    });
}
</code></pre>



</details>

<a name="0x1_GenesisDao_save"></a>

## Function `save`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_save">save</a>&lt;DaoT: store, PluginT, V: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoStorageCap">GenesisDao::DaoStorageCap</a>&lt;DaoT, PluginT&gt;, item: V)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_save">save</a>&lt;DaoT:store, PluginT, V: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoStorageCap">DaoStorageCap</a>&lt;DaoT, PluginT&gt;, item: V) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a>{
    <b>let</b> dao_signer = <a href="GenesisDao.md#0x1_GenesisDao_dao_signer">dao_signer</a>&lt;DaoT&gt;();
    //TODO check <b>exists</b>
    <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_StorageItem">StorageItem</a>&lt;PluginT,V&gt;{
        item
    });
}
</code></pre>



</details>

<a name="0x1_GenesisDao_take"></a>

## Function `take`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_take">take</a>&lt;DaoT: store, PluginT, V: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoStorageCap">GenesisDao::DaoStorageCap</a>&lt;DaoT, PluginT&gt;): V
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_take">take</a>&lt;DaoT:store, PluginT, V: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoStorageCap">DaoStorageCap</a>&lt;DaoT, PluginT&gt;): V <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_StorageItem">StorageItem</a>{
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();
    //TODO check <b>exists</b>
    <b>let</b> <a href="GenesisDao.md#0x1_GenesisDao_StorageItem">StorageItem</a>{item} = <b>move_from</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_StorageItem">StorageItem</a>&lt;PluginT, V&gt;&gt;(dao_address);
    item
}
</code></pre>



</details>

<a name="0x1_GenesisDao_withdraw_token"></a>

## Function `withdraw_token`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_withdraw_token">withdraw_token</a>&lt;DaoT: store, PluginT, TokenT: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawTokenCap">GenesisDao::DaoWithdrawTokenCap</a>&lt;DaoT, PluginT&gt;, amount: u128): <a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_withdraw_token">withdraw_token</a>&lt;DaoT:store, PluginT, TokenT:store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawTokenCap">DaoWithdrawTokenCap</a>&lt;DaoT, PluginT&gt;, amount: u128): <a href="Token.md#0x1_Token">Token</a>&lt;TokenT&gt; <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a>{
    <b>let</b> dao_signer = <a href="GenesisDao.md#0x1_GenesisDao_dao_signer">dao_signer</a>&lt;DaoT&gt;();
    //we should extract the WithdrawCapability from account, and invoke the withdraw_with_cap ?
    <a href="Account.md#0x1_Account_withdraw">Account::withdraw</a>&lt;TokenT&gt;(&dao_signer, amount)
}
</code></pre>



</details>

<a name="0x1_GenesisDao_next_member_id"></a>

## Function `next_member_id`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_next_member_id">next_member_id</a>(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_next_member_id">next_member_id</a>(): u64{
    //TODO implement
    0
}
</code></pre>



</details>

<a name="0x1_GenesisDao_join_member"></a>

## Function `join_member`

Join Dao and get a membership


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_join_member">join_member</a>&lt;DaoT: store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">GenesisDao::DaoMemberCap</a>&lt;DaoT, PluginT&gt;, to_address: <b>address</b>, init_sbt: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_join_member">join_member</a>&lt;DaoT:store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">DaoMemberCap</a>&lt;DaoT, PluginT&gt;, to_address: <b>address</b>, init_sbt: u128) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoNFTMintCapHolder">DaoNFTMintCapHolder</a>, <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a>{
    //TODO error code
    <b>assert</b>!(!<a href="GenesisDao.md#0x1_GenesisDao_is_member">is_member</a>&lt;DaoT&gt;(to_address), 11);

    <b>let</b> member_id = <a href="GenesisDao.md#0x1_GenesisDao_next_member_id">next_member_id</a>();

    <b>let</b> meta = <a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;{
        id: member_id,
    };

    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();
    <b>let</b> dao_signer = <a href="GenesisDao.md#0x1_GenesisDao_dao_signer">dao_signer</a>&lt;DaoT&gt;();
    <b>let</b> sbt = <a href="Token.md#0x1_Token_mint">Token::mint</a>&lt;DaoT&gt;(&dao_signer, init_sbt);

    <b>let</b> body = <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberBody">DaoMemberBody</a>&lt;DaoT&gt;{
        sbt,
    };
    //TODO init base metadata
    <b>let</b> basemeta = <a href="NFT.md#0x1_NFT_empty_meta">NFT::empty_meta</a>();

    <b>let</b> nft_mint_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoNFTMintCapHolder">DaoNFTMintCapHolder</a>&lt;DaoT&gt;&gt;(dao_address).cap;

    <b>let</b> nft = <a href="NFT.md#0x1_NFT_mint_with_cap_v2">NFT::mint_with_cap_v2</a>(dao_address, nft_mint_cap, basemeta, meta, body);
    <a href="NFT.md#0x1_IdentifierNFT_grant_to">IdentifierNFT::grant_to</a>(nft_mint_cap, to_address, nft);
}
</code></pre>



</details>

<a name="0x1_GenesisDao_quit_member"></a>

## Function `quit_member`

Member quit Dao by self


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_quit_member">quit_member</a>&lt;DaoT&gt;(_sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_quit_member">quit_member</a>&lt;DaoT&gt;(_sender: &signer){
    //revoke <a href="NFT.md#0x1_IdentifierNFT">IdentifierNFT</a>
    //burn <a href="NFT.md#0x1_NFT">NFT</a>
    //burn SBT <a href="Token.md#0x1_Token">Token</a>
}
</code></pre>



</details>

<a name="0x1_GenesisDao_revoke_member"></a>

## Function `revoke_member`

Revoke membership with cap


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_revoke_member">revoke_member</a>&lt;DaoT: store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">GenesisDao::DaoMemberCap</a>&lt;DaoT, PluginT&gt;, _member_addr: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_revoke_member">revoke_member</a>&lt;DaoT:store,PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">DaoMemberCap</a>&lt;DaoT, PluginT&gt;, _member_addr: <b>address</b>){
    //revoke <a href="NFT.md#0x1_IdentifierNFT">IdentifierNFT</a>
    //burn <a href="NFT.md#0x1_NFT">NFT</a>
    //burn SBT <a href="Token.md#0x1_Token">Token</a>
}
</code></pre>



</details>

<a name="0x1_GenesisDao_update_member_sbt"></a>

## Function `update_member_sbt`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_update_member_sbt">update_member_sbt</a>&lt;DaoT: store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">GenesisDao::DaoMemberCap</a>&lt;DaoT, PluginT&gt;, _member_addr: <b>address</b>, _new_amount: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_update_member_sbt">update_member_sbt</a>&lt;DaoT:store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">DaoMemberCap</a>&lt;DaoT, PluginT&gt;, _member_addr: <b>address</b>, _new_amount: u128){
    //borrow <b>mut</b> the <a href="NFT.md#0x1_NFT">NFT</a>
    // compare sbt and new_amount
    // mint more sbt token or burn sbt token
}
</code></pre>



</details>

<a name="0x1_GenesisDao_is_member"></a>

## Function `is_member`

Check the <code>member_addr</code> account is a member of DaoT


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_is_member">is_member</a>&lt;DaoT: store&gt;(member_addr: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_is_member">is_member</a>&lt;DaoT: store&gt;(member_addr: <b>address</b>): bool{
    <a href="NFT.md#0x1_IdentifierNFT_owns">IdentifierNFT::owns</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;, <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberBody">DaoMemberBody</a>&lt;DaoT&gt;&gt;(member_addr)
}
</code></pre>



</details>

<a name="0x1_GenesisDao_validate_cap"></a>

## Function `validate_cap`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_validate_cap">validate_cap</a>&lt;DaoT: store, PluginT&gt;(cap: <a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_validate_cap">validate_cap</a>&lt;DaoT: store, PluginT&gt;(cap: <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a>{
    <b>let</b> addr = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();
    <b>if</b> (<b>exists</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a>&lt;PluginT&gt;&gt;(addr)) {
        <b>let</b> plugin_info = <b>borrow_global</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a>&lt;PluginT&gt;&gt;(addr);
        <b>assert</b>!(<a href="Vector.md#0x1_Vector_contains">Vector::contains</a>(&plugin_info.granted_caps, &cap), <a href="Errors.md#0x1_Errors_requires_capability">Errors::requires_capability</a>(<a href="GenesisDao.md#0x1_GenesisDao_E_NO_GRANTED">E_NO_GRANTED</a>));
    } <b>else</b> {
        <b>abort</b>(<a href="Errors.md#0x1_Errors_requires_capability">Errors::requires_capability</a>(<a href="GenesisDao.md#0x1_GenesisDao_E_NO_GRANTED">E_NO_GRANTED</a>))
    }
}
</code></pre>



</details>

<a name="0x1_GenesisDao_acquire_withdraw_token_cap"></a>

## Function `acquire_withdraw_token_cap`

Acquires the capability of withdraw Token from Dao for Plugin. The Plugin with appropriate capabilities.
_witness parameter ensure the invoke is from the PluginT module.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_withdraw_token_cap">acquire_withdraw_token_cap</a>&lt;DaoT: store, PluginT: drop&gt;(_witness: PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawTokenCap">GenesisDao::DaoWithdrawTokenCap</a>&lt;DaoT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_withdraw_token_cap">acquire_withdraw_token_cap</a>&lt;DaoT:store, PluginT: drop&gt;(_witness: PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawTokenCap">DaoWithdrawTokenCap</a>&lt;DaoT, PluginT&gt; <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a>{
    <a href="GenesisDao.md#0x1_GenesisDao_validate_cap">validate_cap</a>&lt;DaoT, PluginT&gt;(<a href="GenesisDao.md#0x1_GenesisDao_withdraw_token_cap_type">withdraw_token_cap_type</a>());
    <a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawTokenCap">DaoWithdrawTokenCap</a>&lt;DaoT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_GenesisDao_acquire_storage_cap"></a>

## Function `acquire_storage_cap`

Storage cap only suppport acquire from plugin


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_storage_cap">acquire_storage_cap</a>&lt;DaoT: store, PluginT: drop&gt;(_witness: PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoStorageCap">GenesisDao::DaoStorageCap</a>&lt;DaoT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_storage_cap">acquire_storage_cap</a>&lt;DaoT:store, PluginT: drop&gt;(_witness: PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoStorageCap">DaoStorageCap</a>&lt;DaoT, PluginT&gt; <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a>{
    <a href="GenesisDao.md#0x1_GenesisDao_validate_cap">validate_cap</a>&lt;DaoT, PluginT&gt;(<a href="GenesisDao.md#0x1_GenesisDao_storage_cap_type">storage_cap_type</a>());
    <a href="GenesisDao.md#0x1_GenesisDao_DaoStorageCap">DaoStorageCap</a>&lt;DaoT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_GenesisDao_acquire_proposal_cap"></a>

## Function `acquire_proposal_cap`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_proposal_cap">acquire_proposal_cap</a>&lt;DaoT: store, PluginT: drop&gt;(_witness: PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoProposalCap">GenesisDao::DaoProposalCap</a>&lt;DaoT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_proposal_cap">acquire_proposal_cap</a>&lt;DaoT:store, PluginT: drop&gt;(_witness: PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoProposalCap">DaoProposalCap</a>&lt;DaoT, PluginT&gt; <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a>{
    <a href="GenesisDao.md#0x1_GenesisDao_validate_cap">validate_cap</a>&lt;DaoT, PluginT&gt;(<a href="GenesisDao.md#0x1_GenesisDao_proposal_cap_type">proposal_cap_type</a>());
    <a href="GenesisDao.md#0x1_GenesisDao_DaoProposalCap">DaoProposalCap</a>&lt;DaoT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_GenesisDao_choice_yes"></a>

## Function `choice_yes`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_choice_yes">choice_yes</a>(): <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">GenesisDao::VotingChoice</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_choice_yes">choice_yes</a>(): <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a>{<a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a>{choice: <a href="GenesisDao.md#0x1_GenesisDao_VOTING_CHOICE_YES">VOTING_CHOICE_YES</a>}}
</code></pre>



</details>

<a name="0x1_GenesisDao_choice_no"></a>

## Function `choice_no`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_choice_no">choice_no</a>(): <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">GenesisDao::VotingChoice</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_choice_no">choice_no</a>(): <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a>{<a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a>{choice: <a href="GenesisDao.md#0x1_GenesisDao_VOTING_CHOICE_NO">VOTING_CHOICE_NO</a>}}
</code></pre>



</details>

<a name="0x1_GenesisDao_choice_no_with_veto"></a>

## Function `choice_no_with_veto`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_choice_no_with_veto">choice_no_with_veto</a>(): <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">GenesisDao::VotingChoice</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_choice_no_with_veto">choice_no_with_veto</a>(): <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a>{<a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a>{choice: <a href="GenesisDao.md#0x1_GenesisDao_VOTING_CHOICE_NO_WITH_VETO">VOTING_CHOICE_NO_WITH_VETO</a>}}
</code></pre>



</details>

<a name="0x1_GenesisDao_choice_abstain"></a>

## Function `choice_abstain`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_choice_abstain">choice_abstain</a>(): <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">GenesisDao::VotingChoice</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_choice_abstain">choice_abstain</a>(): <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a>{<a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a>{choice: <a href="GenesisDao.md#0x1_GenesisDao_VOTING_CHOICE_ABSTAIN">VOTING_CHOICE_ABSTAIN</a>}}
</code></pre>



</details>

<a name="0x1_GenesisDao_create_proposal"></a>

## Function `create_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_create_proposal">create_proposal</a>&lt;DaoT: store, ActionT: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoProposalCap">GenesisDao::DaoProposalCap</a>&lt;DaoT, ActionT&gt;, sender: &signer, action: ActionT, action_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_create_proposal">create_proposal</a>&lt;DaoT: store, ActionT: store&gt;(
    _cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoProposalCap">DaoProposalCap</a>&lt;DaoT, ActionT&gt;,
    sender: &signer,
    action: ActionT,
    action_delay: u64,
) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a> {

    <b>if</b> (action_delay == 0) {
        action_delay = <a href="GenesisDao.md#0x1_GenesisDao_min_action_delay">min_action_delay</a>&lt;DaoT&gt;();
    } <b>else</b> {
        //TODO error code
        <b>assert</b>!(action_delay &gt;= <a href="GenesisDao.md#0x1_GenesisDao_min_action_delay">min_action_delay</a>&lt;DaoT&gt;(), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(1));
    };
    //TODO load from config
    <b>let</b> min_proposal_deposit = 1000;
    <b>let</b> deposit = <a href="Account.md#0x1_Account_withdraw">Account::withdraw</a>&lt;<a href="STC.md#0x1_STC">STC</a>&gt;(sender, min_proposal_deposit);

    <b>let</b> proposal_id = <a href="GenesisDao.md#0x1_GenesisDao_generate_next_proposal_id">generate_next_proposal_id</a>&lt;DaoT&gt;();
    <b>let</b> proposer = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>let</b> start_time = <a href="Timestamp.md#0x1_Timestamp_now_milliseconds">Timestamp::now_milliseconds</a>() + <a href="GenesisDao.md#0x1_GenesisDao_voting_delay">voting_delay</a>&lt;DaoT&gt;();
    <b>let</b> quorum_votes = <a href="GenesisDao.md#0x1_GenesisDao_quorum_votes">quorum_votes</a>&lt;DaoT&gt;();

    <b>let</b> (block_number,state_root) = <a href="GenesisDao.md#0x1_GenesisDao_block_number_and_state_root">block_number_and_state_root</a>();

    //four choise, so init four length vector.
    <b>let</b> votes = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(0u128);
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> votes, 0u128);
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> votes, 0u128);
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> votes, 0u128);

    <b>let</b> proposal = <a href="GenesisDao.md#0x1_GenesisDao_Proposal">Proposal</a> {
        id: proposal_id,
        proposer,
        start_time,
        end_time: start_time + <a href="GenesisDao.md#0x1_GenesisDao_voting_period">voting_period</a>&lt;DaoT&gt;(),
        votes,
        eta: 0,
        action_delay,
        quorum_votes,
        block_number,
        state_root,
    };
    <b>let</b> proposal_action = <a href="GenesisDao.md#0x1_GenesisDao_ProposalAction">ProposalAction</a>{
        deposit,
        action,
    };
    <b>let</b> proposals = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(proposal_action);
    //TODO check <a href="GenesisDao.md#0x1_GenesisDao_MyProposals">MyProposals</a> is <b>exists</b>
    <b>move_to</b>(sender, <a href="GenesisDao.md#0x1_GenesisDao_MyProposals">MyProposals</a>&lt;DaoT, ActionT&gt;{
        proposals,
    });
    <b>let</b> global_proposals = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>&gt;(<a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;());
    //TODO add limit <b>to</b> max proposal before support Table
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> global_proposals.proposals, proposal);
    //TODO trigger event
}
</code></pre>



</details>

<a name="0x1_GenesisDao_block_number_and_state_root"></a>

## Function `block_number_and_state_root`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_block_number_and_state_root">block_number_and_state_root</a>(): (u64, vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_block_number_and_state_root">block_number_and_state_root</a>():(u64, vector&lt;u8&gt;){
    //TODO how <b>to</b> get state root
    (0, <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>())
}
</code></pre>



</details>

<a name="0x1_GenesisDao_voting_period"></a>

## Function `voting_period`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_voting_period">voting_period</a>&lt;DaoT&gt;(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_voting_period">voting_period</a>&lt;DaoT&gt;():u64{
    //TODO
    0
}
</code></pre>



</details>

<a name="0x1_GenesisDao_voting_delay"></a>

## Function `voting_delay`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_voting_delay">voting_delay</a>&lt;DaoT&gt;(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_voting_delay">voting_delay</a>&lt;DaoT&gt;():u64{
    //TODO
    0
}
</code></pre>



</details>

<a name="0x1_GenesisDao_min_action_delay"></a>

## Function `min_action_delay`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_min_action_delay">min_action_delay</a>&lt;DaoT&gt;(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_min_action_delay">min_action_delay</a>&lt;DaoT&gt;(): u64{
    //TODO
    0
}
</code></pre>



</details>

<a name="0x1_GenesisDao_generate_next_proposal_id"></a>

## Function `generate_next_proposal_id`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_generate_next_proposal_id">generate_next_proposal_id</a>&lt;DaoT&gt;(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_generate_next_proposal_id">generate_next_proposal_id</a>&lt;DaoT&gt;(): u64{
    //TODO
    0
}
</code></pre>



</details>

<a name="0x1_GenesisDao_quorum_votes"></a>

## Function `quorum_votes`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_quorum_votes">quorum_votes</a>&lt;DaoT&gt;(): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_quorum_votes">quorum_votes</a>&lt;DaoT&gt;(): u128{
    //TODO we need get the
    0
}
</code></pre>



</details>

<a name="0x1_GenesisDao_cast_vote"></a>

## Function `cast_vote`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_cast_vote">cast_vote</a>&lt;DaoT: <b>copy</b>, drop, store&gt;(sender: &signer, proposal_id: u64, sbt_proof: vector&lt;u8&gt;, choice: <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">GenesisDao::VotingChoice</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_cast_vote">cast_vote</a>&lt;DaoT: <b>copy</b> + drop + store&gt;(
    sender: &signer,
    proposal_id: u64,
    sbt_proof: vector&lt;u8&gt;,
    choice: <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a>,
)  <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>, <a href="GenesisDao.md#0x1_GenesisDao_MyVotes">MyVotes</a>{
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();
    <b>let</b> proposals = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>&gt;(dao_address);
    <b>let</b> proposal = <a href="GenesisDao.md#0x1_GenesisDao_get_proposal_mut">get_proposal_mut</a>(proposals, proposal_id);

    {
        <b>let</b> state = <a href="GenesisDao.md#0x1_GenesisDao_proposal_state">proposal_state</a>(proposal);
        // only when proposal is active, <b>use</b> can cast vote.
        //TODO
        <b>assert</b>!(state == <a href="GenesisDao.md#0x1_GenesisDao_ACTIVE">ACTIVE</a>, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSAL_STATE_INVALID">ERR_PROPOSAL_STATE_INVALID</a>));
    };

    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);

    // TODO is allowed just <b>use</b> part of weight?
    <b>let</b> weight = <a href="VoteUtil.md#0x1_VoteUtil_get_vote_weight_from_sbt_snapshot">VoteUtil::get_vote_weight_from_sbt_snapshot</a>(sender_addr, *&proposal.state_root, sbt_proof);

    //TODO errorcode
    <b>assert</b>!(!<a href="GenesisDao.md#0x1_GenesisDao_has_voted">has_voted</a>&lt;DaoT&gt;(sender_addr, proposal_id), 0);

    <b>let</b> vote = <a href="GenesisDao.md#0x1_GenesisDao_Vote">Vote</a>{
        proposal_id,
        weight,
        choice: choice.choice,
    };

    <a href="GenesisDao.md#0x1_GenesisDao_do_cast_vote">do_cast_vote</a>(proposal, &<b>mut</b> vote);

    <b>if</b> (<b>exists</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MyVotes">MyVotes</a>&lt;DaoT&gt;&gt;(sender_addr)) {
        <b>let</b> my_votes = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MyVotes">MyVotes</a>&lt;DaoT&gt;&gt;(sender_addr);
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> my_votes.votes, vote);
        //<b>assert</b>!(my_vote.id == proposal_id, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_VOTED_OTHERS_ALREADY">ERR_VOTED_OTHERS_ALREADY</a>));
        //TODO
        //<b>assert</b>!(vote.choice == choice, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_VOTE_STATE_MISMATCH">ERR_VOTE_STATE_MISMATCH</a>));
    } <b>else</b> {
        <b>move_to</b>(sender, <a href="GenesisDao.md#0x1_GenesisDao_MyVotes">MyVotes</a>&lt;DaoT&gt;{
            votes: <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(vote),
        });
    };

}
</code></pre>



</details>

<a name="0x1_GenesisDao_change_vote"></a>

## Function `change_vote`

Just change vote choice, the weight do not change.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_change_vote">change_vote</a>&lt;DaoT: <b>copy</b>, drop, store&gt;(_sender: &signer, _proposal_id: u64, _choice: <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">GenesisDao::VotingChoice</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_change_vote">change_vote</a>&lt;DaoT: <b>copy</b> + drop + store&gt;(
    _sender: &signer,
    _proposal_id: u64,
    _choice: <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a>,
){
    //TODO
}
</code></pre>



</details>

<a name="0x1_GenesisDao_revoke_vote"></a>

## Function `revoke_vote`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_revoke_vote">revoke_vote</a>&lt;DaoT: <b>copy</b>, drop, store&gt;(_sender: &signer, _proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_revoke_vote">revoke_vote</a>&lt;DaoT: <b>copy</b> + drop + store&gt;(
    _sender: &signer,
    _proposal_id: u64,
){
    //TODO
}
</code></pre>



</details>

<a name="0x1_GenesisDao_extract_proposal_action"></a>

## Function `extract_proposal_action`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_extract_proposal_action">extract_proposal_action</a>&lt;DaoT: <b>copy</b>, drop, store, ActionT: <b>copy</b>, drop, store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoProposalCap">GenesisDao::DaoProposalCap</a>&lt;DaoT, ActionT&gt;, _proposal_id: u64): ActionT
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_extract_proposal_action">extract_proposal_action</a>&lt;DaoT: <b>copy</b> + drop + store, ActionT: <b>copy</b> + drop + store&gt;(
    _cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoProposalCap">DaoProposalCap</a>&lt;DaoT, ActionT&gt;,
    _proposal_id: u64,
): ActionT {
    // Only executable proposal's action can be extracted.
    // <b>assert</b>!(
    //     <a href="GenesisDao.md#0x1_GenesisDao_proposal_state">proposal_state</a>&lt;DaoT&gt;(proposer_address, proposal_id) == <a href="GenesisDao.md#0x1_GenesisDao_EXECUTABLE">EXECUTABLE</a>,
    //     <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSAL_STATE_INVALID">ERR_PROPOSAL_STATE_INVALID</a>),
    // );
    //<b>let</b> proposal = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_Proposal">Proposal</a>&lt;TokenT, ActionT&gt;&gt;(proposer_address);
    //<b>let</b> action: ActionT = <a href="Option.md#0x1_Option_extract">Option::extract</a>(&<b>mut</b> proposal.action);
    //TODO borrow MyProposal from proposer
    // Find <a href="GenesisDao.md#0x1_GenesisDao_ProposalAction">ProposalAction</a> by proposal_id
    <b>abort</b> 0
}
</code></pre>



</details>

<a name="0x1_GenesisDao_has_voted"></a>

## Function `has_voted`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_has_voted">has_voted</a>&lt;DaoT&gt;(sender: <b>address</b>, proposal_id: u64): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_has_voted">has_voted</a>&lt;DaoT&gt;(sender: <b>address</b>, proposal_id: u64): bool <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_MyVotes">MyVotes</a>{
    <b>if</b>(<b>exists</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MyVotes">MyVotes</a>&lt;DaoT&gt;&gt;(sender)){
        <b>let</b> my_votes = <b>borrow_global</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MyVotes">MyVotes</a>&lt;DaoT&gt;&gt;(sender);
        <b>let</b> vote = <a href="GenesisDao.md#0x1_GenesisDao_get_vote">get_vote</a>&lt;DaoT&gt;(my_votes, proposal_id);
        <a href="Option.md#0x1_Option_is_some">Option::is_some</a>(vote)
    }<b>else</b>{
        <b>false</b>
    }
}
</code></pre>



</details>

<a name="0x1_GenesisDao_do_cast_vote"></a>

## Function `do_cast_vote`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_do_cast_vote">do_cast_vote</a>(proposal: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_Proposal">GenesisDao::Proposal</a>, vote: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_Vote">GenesisDao::Vote</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_do_cast_vote">do_cast_vote</a>(proposal: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_Proposal">Proposal</a>, vote: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_Vote">Vote</a>){
    <b>let</b> weight = *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&proposal.votes, (vote.choice <b>as</b> u64));
    <b>let</b> total_weight = <a href="Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> proposal.votes, (vote.choice <b>as</b> u64));
    *total_weight = weight + vote.weight;
}
</code></pre>



</details>

<a name="0x1_GenesisDao_get_vote"></a>

## Function `get_vote`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_get_vote">get_vote</a>&lt;DaoT&gt;(_my_votes: &<a href="GenesisDao.md#0x1_GenesisDao_MyVotes">GenesisDao::MyVotes</a>&lt;DaoT&gt;, _proposal_id: u64): &<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_Vote">GenesisDao::Vote</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_get_vote">get_vote</a>&lt;DaoT&gt;(_my_votes: &<a href="GenesisDao.md#0x1_GenesisDao_MyVotes">MyVotes</a>&lt;DaoT&gt;, _proposal_id: u64):&<a href="Option.md#0x1_Option">Option</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_Vote">Vote</a>&gt;{
    //TODO
    <b>abort</b> 0
}
</code></pre>



</details>

<a name="0x1_GenesisDao_proposal_state"></a>

## Function `proposal_state`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_proposal_state">proposal_state</a>(_proposal: &<a href="GenesisDao.md#0x1_GenesisDao_Proposal">GenesisDao::Proposal</a>): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_proposal_state">proposal_state</a>(_proposal: &<a href="GenesisDao.md#0x1_GenesisDao_Proposal">Proposal</a>):u8 {
    //TOOD
    0
}
</code></pre>



</details>

<a name="0x1_GenesisDao_get_proposal_mut"></a>

## Function `get_proposal_mut`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_get_proposal_mut">get_proposal_mut</a>(_proposals: &<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GenesisDao::GlobalProposals</a>, _proposal_id: u64): &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_Proposal">GenesisDao::Proposal</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_get_proposal_mut">get_proposal_mut</a>(_proposals: &<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>, _proposal_id: u64): &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_Proposal">Proposal</a>{
    //TODO
    <b>abort</b> 0
}
</code></pre>



</details>

<a name="0x1_GenesisDao_get_proposal"></a>

## Function `get_proposal`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_get_proposal">get_proposal</a>(_proposals: &<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GenesisDao::GlobalProposals</a>, _proposal_id: u64): &<a href="GenesisDao.md#0x1_GenesisDao_Proposal">GenesisDao::Proposal</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_get_proposal">get_proposal</a>(_proposals: &<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>, _proposal_id: u64): &<a href="GenesisDao.md#0x1_GenesisDao_Proposal">Proposal</a> {
    //TODO find proposal by proposal_id from GlobalProposalss
    <b>abort</b> 0
}
</code></pre>



</details>

<a name="0x1_GenesisDao_remove_element"></a>

## Function `remove_element`

Helpers
---------------------------------------------------
Helper to remove an element from a vector.


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_remove_element">remove_element</a>&lt;E: drop&gt;(v: &<b>mut</b> vector&lt;E&gt;, x: &E)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_remove_element">remove_element</a>&lt;E: drop&gt;(v: &<b>mut</b> vector&lt;E&gt;, x: &E) {
    <b>let</b> (found, index) = <a href="Vector.md#0x1_Vector_index_of">Vector::index_of</a>(v, x);
    <b>if</b> (found) {
        <a href="Vector.md#0x1_Vector_remove">Vector::remove</a>(v, index);
    }
}
</code></pre>



</details>

<a name="0x1_GenesisDao_add_element"></a>

## Function `add_element`

Helper to add an element to a vector.


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_add_element">add_element</a>&lt;E: drop&gt;(v: &<b>mut</b> vector&lt;E&gt;, x: E)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_add_element">add_element</a>&lt;E: drop&gt;(v: &<b>mut</b> vector&lt;E&gt;, x: E) {
    <b>if</b> (!<a href="Vector.md#0x1_Vector_contains">Vector::contains</a>(v, &x)) {
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(v, x)
    }
}
</code></pre>



</details>

<a name="0x1_GenesisDao_dao_signer"></a>

## Function `dao_signer`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_dao_signer">dao_signer</a>&lt;DaoT&gt;(): signer
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_dao_signer">dao_signer</a>&lt;DaoT&gt;(): signer <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a>{
    <b>let</b> cap = &<b>borrow_global</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a>&gt;(<a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;()).cap;
    <a href="DaoAccount.md#0x1_DaoAccount_dao_signer">DaoAccount::dao_signer</a>(cap)
}
</code></pre>



</details>

<a name="0x1_GenesisDao_dao_address"></a>

## Function `dao_address`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;(): <b>address</b>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;(): <b>address</b> {
    <a href="DaoRegistry.md#0x1_DaoRegistry_dao_address">DaoRegistry::dao_address</a>&lt;DaoT&gt;()
}
</code></pre>



</details>
