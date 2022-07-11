
<a name="0x1_GenesisDao"></a>

# Module `0x1::GenesisDao`



-  [Resource `Dao`](#0x1_GenesisDao_Dao)
-  [Resource `DaoExt`](#0x1_GenesisDao_DaoExt)
-  [Struct `DaoConfig`](#0x1_GenesisDao_DaoConfig)
-  [Struct `DaoCustomConfig`](#0x1_GenesisDao_DaoCustomConfig)
-  [Resource `DaoAccountCapHolder`](#0x1_GenesisDao_DaoAccountCapHolder)
-  [Resource `DaoTokenMintCapHolder`](#0x1_GenesisDao_DaoTokenMintCapHolder)
-  [Resource `DaoTokenBurnCapHolder`](#0x1_GenesisDao_DaoTokenBurnCapHolder)
-  [Resource `DaoNFTMintCapHolder`](#0x1_GenesisDao_DaoNFTMintCapHolder)
-  [Resource `DaoNFTBurnCapHolder`](#0x1_GenesisDao_DaoNFTBurnCapHolder)
-  [Resource `DaoNFTUpdateCapHolder`](#0x1_GenesisDao_DaoNFTUpdateCapHolder)
-  [Resource `DaoConfigModifyCapHolder`](#0x1_GenesisDao_DaoConfigModifyCapHolder)
-  [Resource `DaoCustomConfigModifyCapHolder`](#0x1_GenesisDao_DaoCustomConfigModifyCapHolder)
-  [Struct `CapType`](#0x1_GenesisDao_CapType)
-  [Struct `DaoRootCap`](#0x1_GenesisDao_DaoRootCap)
-  [Struct `DaoInstallPluginCap`](#0x1_GenesisDao_DaoInstallPluginCap)
-  [Struct `DaoUpgradeModuleCap`](#0x1_GenesisDao_DaoUpgradeModuleCap)
-  [Struct `DaoModifyConfigCap`](#0x1_GenesisDao_DaoModifyConfigCap)
-  [Struct `DaoWithdrawTokenCap`](#0x1_GenesisDao_DaoWithdrawTokenCap)
-  [Struct `DaoWithdrawNFTCap`](#0x1_GenesisDao_DaoWithdrawNFTCap)
-  [Struct `DaoStorageCap`](#0x1_GenesisDao_DaoStorageCap)
-  [Struct `DaoMemberCap`](#0x1_GenesisDao_DaoMemberCap)
-  [Struct `DaoProposalCap`](#0x1_GenesisDao_DaoProposalCap)
-  [Resource `InstalledPluginInfo`](#0x1_GenesisDao_InstalledPluginInfo)
-  [Struct `DaoMember`](#0x1_GenesisDao_DaoMember)
-  [Struct `DaoMemberBody`](#0x1_GenesisDao_DaoMemberBody)
-  [Resource `MemberEvent`](#0x1_GenesisDao_MemberEvent)
-  [Struct `MemberJoinEvent`](#0x1_GenesisDao_MemberJoinEvent)
-  [Struct `MemberRevokeEvent`](#0x1_GenesisDao_MemberRevokeEvent)
-  [Struct `MemberQuitEvent`](#0x1_GenesisDao_MemberQuitEvent)
-  [Struct `MemberIncreaseSBTEvent`](#0x1_GenesisDao_MemberIncreaseSBTEvent)
-  [Struct `MemberDecreaseSBTEvent`](#0x1_GenesisDao_MemberDecreaseSBTEvent)
-  [Resource `StorageItem`](#0x1_GenesisDao_StorageItem)
-  [Struct `ProposalState`](#0x1_GenesisDao_ProposalState)
-  [Struct `VotingChoice`](#0x1_GenesisDao_VotingChoice)
-  [Struct `Proposal`](#0x1_GenesisDao_Proposal)
-  [Struct `ProposalAction`](#0x1_GenesisDao_ProposalAction)
-  [Struct `ProposalActionIndex`](#0x1_GenesisDao_ProposalActionIndex)
-  [Struct `ProposalInfo`](#0x1_GenesisDao_ProposalInfo)
-  [Resource `GlobalProposals`](#0x1_GenesisDao_GlobalProposals)
-  [Resource `ProposalActions`](#0x1_GenesisDao_ProposalActions)
-  [Resource `GlobalProposalActions`](#0x1_GenesisDao_GlobalProposalActions)
-  [Struct `Vote`](#0x1_GenesisDao_Vote)
-  [Struct `VoteInfo`](#0x1_GenesisDao_VoteInfo)
-  [Resource `MyVotes`](#0x1_GenesisDao_MyVotes)
-  [Struct `SnapshotProof`](#0x1_GenesisDao_SnapshotProof)
-  [Struct `ProposalCreatedEvent`](#0x1_GenesisDao_ProposalCreatedEvent)
-  [Struct `VoteChangedEvent`](#0x1_GenesisDao_VoteChangedEvent)
-  [Resource `ProposalEvent`](#0x1_GenesisDao_ProposalEvent)
-  [Constants](#@Constants_0)
-  [Function `install_plugin_cap_type`](#0x1_GenesisDao_install_plugin_cap_type)
-  [Function `upgrade_module_cap_type`](#0x1_GenesisDao_upgrade_module_cap_type)
-  [Function `modify_config_cap_type`](#0x1_GenesisDao_modify_config_cap_type)
-  [Function `withdraw_token_cap_type`](#0x1_GenesisDao_withdraw_token_cap_type)
-  [Function `withdraw_nft_cap_type`](#0x1_GenesisDao_withdraw_nft_cap_type)
-  [Function `storage_cap_type`](#0x1_GenesisDao_storage_cap_type)
-  [Function `member_cap_type`](#0x1_GenesisDao_member_cap_type)
-  [Function `proposal_cap_type`](#0x1_GenesisDao_proposal_cap_type)
-  [Function `all_caps`](#0x1_GenesisDao_all_caps)
-  [Function `create_dao`](#0x1_GenesisDao_create_dao)
-  [Function `upgrade_to_dao`](#0x1_GenesisDao_upgrade_to_dao)
-  [Function `burn_root_cap`](#0x1_GenesisDao_burn_root_cap)
-  [Function `install_plugin_with_root_cap`](#0x1_GenesisDao_install_plugin_with_root_cap)
-  [Function `install_plugin`](#0x1_GenesisDao_install_plugin)
-  [Function `do_install_plugin`](#0x1_GenesisDao_do_install_plugin)
-  [Function `submit_upgrade_plan`](#0x1_GenesisDao_submit_upgrade_plan)
-  [Function `save`](#0x1_GenesisDao_save)
-  [Function `take`](#0x1_GenesisDao_take)
-  [Function `withdraw_token`](#0x1_GenesisDao_withdraw_token)
-  [Function `withdraw_nft`](#0x1_GenesisDao_withdraw_nft)
-  [Function `join_member`](#0x1_GenesisDao_join_member)
-  [Function `quit_member`](#0x1_GenesisDao_quit_member)
-  [Function `revoke_member`](#0x1_GenesisDao_revoke_member)
-  [Function `do_remove_member`](#0x1_GenesisDao_do_remove_member)
-  [Function `increase_member_sbt`](#0x1_GenesisDao_increase_member_sbt)
-  [Function `decrease_member_sbt`](#0x1_GenesisDao_decrease_member_sbt)
-  [Function `query_sbt`](#0x1_GenesisDao_query_sbt)
-  [Function `is_member`](#0x1_GenesisDao_is_member)
-  [Function `validate_cap`](#0x1_GenesisDao_validate_cap)
-  [Function `acquire_install_plugin_cap`](#0x1_GenesisDao_acquire_install_plugin_cap)
-  [Function `acquire_upgrade_module_cap`](#0x1_GenesisDao_acquire_upgrade_module_cap)
-  [Function `acquire_modify_config_cap`](#0x1_GenesisDao_acquire_modify_config_cap)
-  [Function `acquire_withdraw_token_cap`](#0x1_GenesisDao_acquire_withdraw_token_cap)
-  [Function `acquire_withdraw_nft_cap`](#0x1_GenesisDao_acquire_withdraw_nft_cap)
-  [Function `acquire_storage_cap`](#0x1_GenesisDao_acquire_storage_cap)
-  [Function `acquire_member_cap`](#0x1_GenesisDao_acquire_member_cap)
-  [Function `acquire_proposal_cap`](#0x1_GenesisDao_acquire_proposal_cap)
-  [Function `choice_yes`](#0x1_GenesisDao_choice_yes)
-  [Function `choice_no`](#0x1_GenesisDao_choice_no)
-  [Function `choice_no_with_veto`](#0x1_GenesisDao_choice_no_with_veto)
-  [Function `choice_abstain`](#0x1_GenesisDao_choice_abstain)
-  [Function `initialize_proposal`](#0x1_GenesisDao_initialize_proposal)
-  [Function `create_proposal`](#0x1_GenesisDao_create_proposal)
-  [Function `block_number_and_state_root`](#0x1_GenesisDao_block_number_and_state_root)
-  [Function `cast_vote`](#0x1_GenesisDao_cast_vote)
-  [Function `deserialize_snapshot_proofs`](#0x1_GenesisDao_deserialize_snapshot_proofs)
-  [Function `new_state_proof_from_proofs`](#0x1_GenesisDao_new_state_proof_from_proofs)
-  [Function `execute_proposal`](#0x1_GenesisDao_execute_proposal)
-  [Function `take_proposal_action`](#0x1_GenesisDao_take_proposal_action)
-  [Function `find_action`](#0x1_GenesisDao_find_action)
-  [Function `do_cast_vote`](#0x1_GenesisDao_do_cast_vote)
-  [Function `has_voted`](#0x1_GenesisDao_has_voted)
-  [Function `get_vote_info`](#0x1_GenesisDao_get_vote_info)
-  [Function `proposal_state`](#0x1_GenesisDao_proposal_state)
-  [Function `proposal_state_with_proposal`](#0x1_GenesisDao_proposal_state_with_proposal)
-  [Function `do_proposal_state`](#0x1_GenesisDao_do_proposal_state)
-  [Function `proposal_info`](#0x1_GenesisDao_proposal_info)
-  [Function `borrow_proposal_mut`](#0x1_GenesisDao_borrow_proposal_mut)
-  [Function `borrow_proposal`](#0x1_GenesisDao_borrow_proposal)
-  [Function `find_proposal_action_index`](#0x1_GenesisDao_find_proposal_action_index)
-  [Function `proposal`](#0x1_GenesisDao_proposal)
-  [Function `new_dao_config`](#0x1_GenesisDao_new_dao_config)
-  [Function `set_custom_config`](#0x1_GenesisDao_set_custom_config)
-  [Function `voting_delay`](#0x1_GenesisDao_voting_delay)
-  [Function `voting_period`](#0x1_GenesisDao_voting_period)
-  [Function `quorum_votes`](#0x1_GenesisDao_quorum_votes)
-  [Function `voting_quorum_rate`](#0x1_GenesisDao_voting_quorum_rate)
-  [Function `min_action_delay`](#0x1_GenesisDao_min_action_delay)
-  [Function `min_proposal_deposit`](#0x1_GenesisDao_min_proposal_deposit)
-  [Function `get_config`](#0x1_GenesisDao_get_config)
-  [Function `modify_dao_config`](#0x1_GenesisDao_modify_dao_config)
-  [Function `set_voting_delay`](#0x1_GenesisDao_set_voting_delay)
-  [Function `set_voting_period`](#0x1_GenesisDao_set_voting_period)
-  [Function `set_voting_quorum_rate`](#0x1_GenesisDao_set_voting_quorum_rate)
-  [Function `set_min_action_delay`](#0x1_GenesisDao_set_min_action_delay)
-  [Function `set_min_proposal_deposit`](#0x1_GenesisDao_set_min_proposal_deposit)
-  [Function `next_member_id`](#0x1_GenesisDao_next_member_id)
-  [Function `next_proposal_id`](#0x1_GenesisDao_next_proposal_id)
-  [Function `assert_no_repeat`](#0x1_GenesisDao_assert_no_repeat)
-  [Function `remove_element`](#0x1_GenesisDao_remove_element)
-  [Function `add_element`](#0x1_GenesisDao_add_element)
-  [Function `dao_signer`](#0x1_GenesisDao_dao_signer)
-  [Function `dao_address`](#0x1_GenesisDao_dao_address)


<pre><code><b>use</b> <a href="Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="BCS.md#0x1_BCS">0x1::BCS</a>;
<b>use</b> <a href="Config.md#0x1_Config">0x1::Config</a>;
<b>use</b> <a href="DaoAccount.md#0x1_DaoAccount">0x1::DaoAccount</a>;
<b>use</b> <a href="DaoRegistry.md#0x1_DaoRegistry">0x1::DaoRegistry</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Event.md#0x1_Event">0x1::Event</a>;
<b>use</b> <a href="NFT.md#0x1_IdentifierNFT">0x1::IdentifierNFT</a>;
<b>use</b> <a href="NFT.md#0x1_NFT">0x1::NFT</a>;
<b>use</b> <a href="NFT.md#0x1_NFTGallery">0x1::NFTGallery</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="SBTVoteStrategy.md#0x1_SBTVoteStrategy">0x1::SBTVoteStrategy</a>;
<b>use</b> <a href="STC.md#0x1_STC">0x1::STC</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier">0x1::StarcoinVerifier</a>;
<b>use</b> <a href="Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
<b>use</b> <a href="Token.md#0x1_Token">0x1::Token</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
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
<dt>
<code>next_member_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>next_proposal_id: u64</code>
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

<a name="0x1_GenesisDao_DaoConfig"></a>

## Struct `DaoConfig`

Configuration of the DAO.


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">DaoConfig</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>voting_delay: u64</code>
</dt>
<dd>
 after proposal created, how long use should wait before he can vote (in milliseconds)
</dd>
<dt>
<code>voting_period: u64</code>
</dt>
<dd>
 how long the voting window is (in milliseconds).
</dd>
<dt>
<code>voting_quorum_rate: u8</code>
</dt>
<dd>
 the quorum rate to agree on the proposal.
 if 50% votes needed, then the voting_quorum_rate should be 50.
 it should between (0, 100].
</dd>
<dt>
<code>min_action_delay: u64</code>
</dt>
<dd>
 how long the proposal should wait before it can be executed (in milliseconds).
</dd>
<dt>
<code>min_proposal_deposit: u128</code>
</dt>
<dd>
 how many STC should be deposited to create a proposal.
</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoCustomConfig"></a>

## Struct `DaoCustomConfig`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoCustomConfig">DaoCustomConfig</a>&lt;ConfigT&gt; <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>config: ConfigT</code>
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
<code>cap: <a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCap">DaoAccount::DaoAccountCap</a></code>
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

<a name="0x1_GenesisDao_DaoConfigModifyCapHolder"></a>

## Resource `DaoConfigModifyCapHolder`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoConfigModifyCapHolder">DaoConfigModifyCapHolder</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="Config.md#0x1_Config_ModifyConfigCapability">Config::ModifyConfigCapability</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">GenesisDao::DaoConfig</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_DaoCustomConfigModifyCapHolder"></a>

## Resource `DaoCustomConfigModifyCapHolder`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoCustomConfigModifyCapHolder">DaoCustomConfigModifyCapHolder</a>&lt;DaoT, ConfigT: <b>copy</b>, drop, store&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="Config.md#0x1_Config_ModifyConfigCapability">Config::ModifyConfigCapability</a>&lt;ConfigT&gt;</code>
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

RootCap only have one instance, and can not been <code>drop</code> and <code>store</code>


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">DaoRootCap</a>&lt;DaoT&gt;
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

<a name="0x1_GenesisDao_DaoInstallPluginCap"></a>

## Struct `DaoInstallPluginCap`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoInstallPluginCap">DaoInstallPluginCap</a>&lt;DaoT, PluginT&gt; <b>has</b> drop
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

<a name="0x1_GenesisDao_DaoModifyConfigCap"></a>

## Struct `DaoModifyConfigCap`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoModifyConfigCap">DaoModifyConfigCap</a>&lt;DaoT, PluginT&gt; <b>has</b> drop
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



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoProposalCap">DaoProposalCap</a>&lt;DaoT, PluginT&gt; <b>has</b> drop
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

<a name="0x1_GenesisDao_MemberEvent"></a>

## Resource `MemberEvent`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_MemberEvent">MemberEvent</a>&lt;DaoT&gt; <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>member_join_event_handler: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MemberJoinEvent">GenesisDao::MemberJoinEvent</a>&lt;DaoT&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>member_quit_event_handler: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MemberQuitEvent">GenesisDao::MemberQuitEvent</a>&lt;DaoT&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>member_revoke_event_handler: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MemberRevokeEvent">GenesisDao::MemberRevokeEvent</a>&lt;DaoT&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>member_increase_sbt_event_handler: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MemberIncreaseSBTEvent">GenesisDao::MemberIncreaseSBTEvent</a>&lt;DaoT&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>member_decrease_sbt_event_handler: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MemberDecreaseSBTEvent">GenesisDao::MemberDecreaseSBTEvent</a>&lt;DaoT&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_MemberJoinEvent"></a>

## Struct `MemberJoinEvent`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_MemberJoinEvent">MemberJoinEvent</a>&lt;DaoT&gt; <b>has</b> drop, store
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
<code>addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>sbt: u128</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_MemberRevokeEvent"></a>

## Struct `MemberRevokeEvent`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_MemberRevokeEvent">MemberRevokeEvent</a>&lt;DaoT&gt; <b>has</b> drop, store
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
<code>addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>sbt: u128</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_MemberQuitEvent"></a>

## Struct `MemberQuitEvent`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_MemberQuitEvent">MemberQuitEvent</a>&lt;DaoT&gt; <b>has</b> drop, store
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
<code>addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>sbt: u128</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_MemberIncreaseSBTEvent"></a>

## Struct `MemberIncreaseSBTEvent`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_MemberIncreaseSBTEvent">MemberIncreaseSBTEvent</a>&lt;DaoT&gt; <b>has</b> drop, store
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
<code>addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>increase_sbt: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>sbt: u128</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_MemberDecreaseSBTEvent"></a>

## Struct `MemberDecreaseSBTEvent`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_MemberDecreaseSBTEvent">MemberDecreaseSBTEvent</a>&lt;DaoT&gt; <b>has</b> drop, store
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
<code>addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>decrease_sbt: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>sbt: u128</code>
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
review: it is safe to has <code><b>copy</b></code> and <code>drop</code>?


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_Proposal">Proposal</a> <b>has</b> <b>copy</b>, drop, store
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
<code>yes_votes: u128</code>
</dt>
<dd>
 count of voters who <code>yes|no|no_with_veto|abstain</code> with the proposal
</dd>
<dt>
<code>no_votes: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>no_with_veto_votes: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>abstain_votes: u128</code>
</dt>
<dd>

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
 the block number when submit proposal
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
<code>proposal_id: u64</code>
</dt>
<dd>
 id of the proposal
</dd>
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

<a name="0x1_GenesisDao_ProposalActionIndex"></a>

## Struct `ProposalActionIndex`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_ProposalActionIndex">ProposalActionIndex</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>proposal_id: u64</code>
</dt>
<dd>
 id of the proposal
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

<a name="0x1_GenesisDao_ProposalActions"></a>

## Resource `ProposalActions`

Every ActionT keep a vector in the Dao account


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_ProposalActions">ProposalActions</a>&lt;ActionT: store&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>actions: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_ProposalAction">GenesisDao::ProposalAction</a>&lt;ActionT&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_GlobalProposalActions"></a>

## Resource `GlobalProposalActions`

Keep a global proposal action record for query action by proposal_id.
Replace with Table when support Table.


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposalActions">GlobalProposalActions</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>proposal_action_indexs: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_ProposalActionIndex">GenesisDao::ProposalActionIndex</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_Vote"></a>

## Struct `Vote`

User vote.


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
<code>vote_weight: u128</code>
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

<a name="0x1_GenesisDao_VoteInfo"></a>

## Struct `VoteInfo`

User vote info. has drop cap


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_VoteInfo">VoteInfo</a> <b>has</b> drop, store
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
<code>vote_weight: u128</code>
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

<a name="0x1_GenesisDao_SnapshotProof"></a>

## Struct `SnapshotProof`

use bcs se/de for Snapshot proofs


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_SnapshotProof">SnapshotProof</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>account_proof_leaf: vector&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>account_proof_siblings: vector&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>account_state: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>account_state_proof_leaf: vector&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>account_state_proof_siblings: vector&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>state: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>resource_struct_tag: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_GenesisDao_ProposalCreatedEvent"></a>

## Struct `ProposalCreatedEvent`

emitted when proposal created.


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_ProposalCreatedEvent">ProposalCreatedEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>proposal_id: u64</code>
</dt>
<dd>
 the proposal id.
</dd>
<dt>
<code>proposer: <b>address</b></code>
</dt>
<dd>
 proposer is the user who create the proposal.
</dd>
</dl>


</details>

<a name="0x1_GenesisDao_VoteChangedEvent"></a>

## Struct `VoteChangedEvent`

emitted when user vote/revoke_vote.


<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_VoteChangedEvent">VoteChangedEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>proposal_id: u64</code>
</dt>
<dd>
 the proposal id.
</dd>
<dt>
<code>voter: <b>address</b></code>
</dt>
<dd>
 the voter.
</dd>
<dt>
<code>choice: u8</code>
</dt>
<dd>
 1:yes, 2:no, 3:no_with_veto, 4:abstain
</dd>
<dt>
<code>vote_weight: u128</code>
</dt>
<dd>
 latest vote count of the voter.
</dd>
</dl>


</details>

<a name="0x1_GenesisDao_ProposalEvent"></a>

## Resource `ProposalEvent`



<pre><code><b>struct</b> <a href="GenesisDao.md#0x1_GenesisDao_ProposalEvent">ProposalEvent</a>&lt;DaoT: store&gt; <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>proposal_create_event: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_ProposalCreatedEvent">GenesisDao::ProposalCreatedEvent</a>&gt;</code>
</dt>
<dd>
 proposal creating event.
</dd>
<dt>
<code>vote_changed_event: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_VoteChangedEvent">GenesisDao::VoteChangedEvent</a>&gt;</code>
</dt>
<dd>
 voting event.
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

action


<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_ACTION_MUST_EXIST">ERR_ACTION_MUST_EXIST</a>: u64 = 1430;
</code></pre>



<a name="0x1_GenesisDao_ERR_CONFIG_PARAM_INVALID"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>: u64 = 1403;
</code></pre>



<a name="0x1_GenesisDao_ERR_PROPOSAL_ID_MISMATCH"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSAL_ID_MISMATCH">ERR_PROPOSAL_ID_MISMATCH</a>: u64 = 1414;
</code></pre>



<a name="0x1_GenesisDao_ERR_PROPOSAL_STATE_INVALID"></a>

proposal


<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSAL_STATE_INVALID">ERR_PROPOSAL_STATE_INVALID</a>: u64 = 1413;
</code></pre>



<a name="0x1_GenesisDao_ERR_PROPOSER_MISMATCH"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSER_MISMATCH">ERR_PROPOSER_MISMATCH</a>: u64 = 1415;
</code></pre>



<a name="0x1_GenesisDao_ERR_QUORUM_RATE_INVALID"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_QUORUM_RATE_INVALID">ERR_QUORUM_RATE_INVALID</a>: u64 = 1417;
</code></pre>



<a name="0x1_GenesisDao_ERR_VOTED_OTHERS_ALREADY"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_VOTED_OTHERS_ALREADY">ERR_VOTED_OTHERS_ALREADY</a>: u64 = 1446;
</code></pre>



<a name="0x1_GenesisDao_ERR_VOTE_STATE_MISMATCH"></a>

vote


<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_VOTE_STATE_MISMATCH">ERR_VOTE_STATE_MISMATCH</a>: u64 = 1445;
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



<a name="0x1_GenesisDao_ERR_ACTION_INDEX_INVALID"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_ACTION_INDEX_INVALID">ERR_ACTION_INDEX_INVALID</a>: u64 = 1431;
</code></pre>



<a name="0x1_GenesisDao_ERR_ALREADY_INIT"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_ALREADY_INIT">ERR_ALREADY_INIT</a>: u64 = 104;
</code></pre>



<a name="0x1_GenesisDao_ERR_NFT_ERROR"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_NFT_ERROR">ERR_NFT_ERROR</a>: u64 = 103;
</code></pre>



<a name="0x1_GenesisDao_ERR_NOT_ALREADY_MEMBER"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_NOT_ALREADY_MEMBER">ERR_NOT_ALREADY_MEMBER</a>: u64 = 104;
</code></pre>



<a name="0x1_GenesisDao_ERR_NOT_DAO_MEMBER"></a>

member


<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_NOT_DAO_MEMBER">ERR_NOT_DAO_MEMBER</a>: u64 = 1436;
</code></pre>



<a name="0x1_GenesisDao_ERR_NOT_MEMBER"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_NOT_MEMBER">ERR_NOT_MEMBER</a>: u64 = 105;
</code></pre>



<a name="0x1_GenesisDao_ERR_PLUGIN_HAS_INSTALLED"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_PLUGIN_HAS_INSTALLED">ERR_PLUGIN_HAS_INSTALLED</a>: u64 = 101;
</code></pre>



<a name="0x1_GenesisDao_ERR_PROPOSAL_ACTIONS_NOT_EXIST"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSAL_ACTIONS_NOT_EXIST">ERR_PROPOSAL_ACTIONS_NOT_EXIST</a>: u64 = 1431;
</code></pre>



<a name="0x1_GenesisDao_ERR_PROPOSAL_ACTION_INDEX_NOT_EXIST"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSAL_ACTION_INDEX_NOT_EXIST">ERR_PROPOSAL_ACTION_INDEX_NOT_EXIST</a>: u64 = 1418;
</code></pre>



<a name="0x1_GenesisDao_ERR_PROPOSAL_NOT_EXIST"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSAL_NOT_EXIST">ERR_PROPOSAL_NOT_EXIST</a>: u64 = 1416;
</code></pre>



<a name="0x1_GenesisDao_ERR_REPEAT_ELEMENT"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_REPEAT_ELEMENT">ERR_REPEAT_ELEMENT</a>: u64 = 100;
</code></pre>



<a name="0x1_GenesisDao_ERR_SNAPSHOT_PROOF_PARAM_INVALID"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_SNAPSHOT_PROOF_PARAM_INVALID">ERR_SNAPSHOT_PROOF_PARAM_INVALID</a>: u64 = 1455;
</code></pre>



<a name="0x1_GenesisDao_ERR_STATE_PROOF_VERIFY_INVALID"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_STATE_PROOF_VERIFY_INVALID">ERR_STATE_PROOF_VERIFY_INVALID</a>: u64 = 1456;
</code></pre>



<a name="0x1_GenesisDao_ERR_STORAGE_ERROR"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_STORAGE_ERROR">ERR_STORAGE_ERROR</a>: u64 = 102;
</code></pre>



<a name="0x1_GenesisDao_ERR_VOTED_ALREADY"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_VOTED_ALREADY">ERR_VOTED_ALREADY</a>: u64 = 1447;
</code></pre>



<a name="0x1_GenesisDao_ERR_VOTE_PARAM_INVALID"></a>



<pre><code><b>const</b> <a href="GenesisDao.md#0x1_GenesisDao_ERR_VOTE_PARAM_INVALID">ERR_VOTE_PARAM_INVALID</a>: u64 = 1448;
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



<a name="0x1_GenesisDao_install_plugin_cap_type"></a>

## Function `install_plugin_cap_type`

Creates a install plugin capability type.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_install_plugin_cap_type">install_plugin_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_install_plugin_cap_type">install_plugin_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a> { <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>{ code: 0 } }
</code></pre>



</details>

<a name="0x1_GenesisDao_upgrade_module_cap_type"></a>

## Function `upgrade_module_cap_type`

Creates a upgrade module capability type.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_upgrade_module_cap_type">upgrade_module_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_upgrade_module_cap_type">upgrade_module_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a> { <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>{ code: 1 } }
</code></pre>



</details>

<a name="0x1_GenesisDao_modify_config_cap_type"></a>

## Function `modify_config_cap_type`

Creates a modify dao config capability type.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_modify_config_cap_type">modify_config_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_modify_config_cap_type">modify_config_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a> { <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>{ code: 2 } }
</code></pre>



</details>

<a name="0x1_GenesisDao_withdraw_token_cap_type"></a>

## Function `withdraw_token_cap_type`

Creates a withdraw Token capability type.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_withdraw_token_cap_type">withdraw_token_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_withdraw_token_cap_type">withdraw_token_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a> { <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>{ code: 3 } }
</code></pre>



</details>

<a name="0x1_GenesisDao_withdraw_nft_cap_type"></a>

## Function `withdraw_nft_cap_type`

Creates a withdraw NFT capability type.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_withdraw_nft_cap_type">withdraw_nft_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_withdraw_nft_cap_type">withdraw_nft_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a> { <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>{ code: 4 } }
</code></pre>



</details>

<a name="0x1_GenesisDao_storage_cap_type"></a>

## Function `storage_cap_type`

Creates a write data to Dao account capability type.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_storage_cap_type">storage_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_storage_cap_type">storage_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a> { <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>{ code: 5 } }
</code></pre>



</details>

<a name="0x1_GenesisDao_member_cap_type"></a>

## Function `member_cap_type`

Creates a member capability type.
This cap can issue Dao member NFT or update member's SBT


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_member_cap_type">member_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_member_cap_type">member_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a> { <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>{ code: 6 } }
</code></pre>



</details>

<a name="0x1_GenesisDao_proposal_cap_type"></a>

## Function `proposal_cap_type`

Creates a vote capability type.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_proposal_cap_type">proposal_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_proposal_cap_type">proposal_cap_type</a>(): <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a> { <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>{ code: 7 } }
</code></pre>



</details>

<a name="0x1_GenesisDao_all_caps"></a>

## Function `all_caps`

Creates all capability types.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_all_caps">all_caps</a>(): vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_all_caps">all_caps</a>(): vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>&gt; {
    <b>let</b> caps = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(<a href="GenesisDao.md#0x1_GenesisDao_install_plugin_cap_type">install_plugin_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="GenesisDao.md#0x1_GenesisDao_upgrade_module_cap_type">upgrade_module_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="GenesisDao.md#0x1_GenesisDao_modify_config_cap_type">modify_config_cap_type</a>());
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


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_create_dao">create_dao</a>&lt;DaoT: store&gt;(cap: <a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCap">DaoAccount::DaoAccountCap</a>, name: vector&lt;u8&gt;, ext: DaoT, config: <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">GenesisDao::DaoConfig</a>): <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">GenesisDao::DaoRootCap</a>&lt;DaoT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_create_dao">create_dao</a>&lt;DaoT: store&gt;(cap: DaoAccountCap, name: vector&lt;u8&gt;, ext: DaoT, config: <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">DaoConfig</a>): <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">DaoRootCap</a>&lt;DaoT&gt; {
    <b>let</b> dao_signer = <a href="DaoAccount.md#0x1_DaoAccount_dao_signer">DaoAccount::dao_signer</a>(&cap);

    <b>let</b> dao_address = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&dao_signer);
    <b>let</b> id = <a href="DaoRegistry.md#0x1_DaoRegistry_register">DaoRegistry::register</a>&lt;DaoT&gt;(dao_address);
    <b>let</b> dao = <a href="Dao.md#0x1_Dao">Dao</a>{
        id,
        name: *&name,
        dao_address,
        next_member_id: 1,
        next_proposal_id: 1,
    };

    // initialize dao proposal event
    <a href="GenesisDao.md#0x1_GenesisDao_initialize_proposal">initialize_proposal</a>&lt;DaoT&gt;(&cap);

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

    <b>let</b> nft_name = <b>copy</b> name;
    //TODO generate a svg <a href="NFT.md#0x1_NFT">NFT</a> image.
    <b>let</b> nft_image = b"SVG image";
    <b>let</b> nft_description = name;
    <b>let</b> basemeta = <a href="NFT.md#0x1_NFT_new_meta_with_image_data">NFT::new_meta_with_image_data</a>(nft_name, nft_image, nft_description);

    <a href="NFT.md#0x1_NFT_register_v2">NFT::register_v2</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;&gt;(&dao_signer, basemeta);
    <b>let</b> nft_mint_cap = <a href="NFT.md#0x1_NFT_remove_mint_capability">NFT::remove_mint_capability</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;&gt;(&dao_signer);
    <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_DaoNFTMintCapHolder">DaoNFTMintCapHolder</a>{
        cap: nft_mint_cap,
    });

    <b>let</b> nft_burn_cap = <a href="NFT.md#0x1_NFT_remove_burn_capability">NFT::remove_burn_capability</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;&gt;(&dao_signer);
    <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_DaoNFTBurnCapHolder">DaoNFTBurnCapHolder</a>{
        cap: nft_burn_cap,
    });

    <b>let</b> nft_update_cap = <a href="NFT.md#0x1_NFT_remove_update_capability">NFT::remove_update_capability</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;&gt;(&dao_signer);
    <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_DaoNFTUpdateCapHolder">DaoNFTUpdateCapHolder</a>{
        cap: nft_update_cap,
    });

    <b>let</b> config_modify_cap = <a href="Config.md#0x1_Config_publish_new_config_with_capability">Config::publish_new_config_with_capability</a>(&dao_signer, config);
    <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_DaoConfigModifyCapHolder">DaoConfigModifyCapHolder</a>{
        cap: config_modify_cap,
    });

    <b>move_to</b>(&dao_signer ,<a href="GenesisDao.md#0x1_GenesisDao_MemberEvent">MemberEvent</a>{
        member_join_event_handler:<a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MemberJoinEvent">MemberJoinEvent</a>&lt;DaoT&gt;&gt;(&dao_signer),
        member_quit_event_handler:<a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MemberQuitEvent">MemberQuitEvent</a>&lt;DaoT&gt;&gt;(&dao_signer),
        member_revoke_event_handler:<a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MemberRevokeEvent">MemberRevokeEvent</a>&lt;DaoT&gt;&gt;(&dao_signer),
        member_increase_sbt_event_handler:<a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MemberIncreaseSBTEvent">MemberIncreaseSBTEvent</a>&lt;DaoT&gt;&gt;(&dao_signer),
        member_decrease_sbt_event_handler:<a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MemberDecreaseSBTEvent">MemberDecreaseSBTEvent</a>&lt;DaoT&gt;&gt;(&dao_signer),
    });
    <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">DaoRootCap</a>&lt;DaoT&gt;{}
}
</code></pre>



</details>

<a name="0x1_GenesisDao_upgrade_to_dao"></a>

## Function `upgrade_to_dao`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_upgrade_to_dao">upgrade_to_dao</a>&lt;DaoT: store&gt;(sender: signer, name: vector&lt;u8&gt;, ext: DaoT, config: <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">GenesisDao::DaoConfig</a>): <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">GenesisDao::DaoRootCap</a>&lt;DaoT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_upgrade_to_dao">upgrade_to_dao</a>&lt;DaoT: store&gt;(sender: signer, name: vector&lt;u8&gt;, ext: DaoT, config: <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">DaoConfig</a>): <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">DaoRootCap</a>&lt;DaoT&gt; {
    <b>let</b> cap = <a href="DaoAccount.md#0x1_DaoAccount_upgrade_to_dao">DaoAccount::upgrade_to_dao</a>(sender);
    <a href="GenesisDao.md#0x1_GenesisDao_create_dao">create_dao</a>&lt;DaoT&gt;(cap, name, ext, config)
}
</code></pre>



</details>

<a name="0x1_GenesisDao_burn_root_cap"></a>

## Function `burn_root_cap`

Burn the root cap after init the Dao


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_burn_root_cap">burn_root_cap</a>&lt;DaoT&gt;(cap: <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">GenesisDao::DaoRootCap</a>&lt;DaoT&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_burn_root_cap">burn_root_cap</a>&lt;DaoT&gt;(cap: <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">DaoRootCap</a>&lt;DaoT&gt;) {
    <b>let</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">DaoRootCap</a>{} = cap;
}
</code></pre>



</details>

<a name="0x1_GenesisDao_install_plugin_with_root_cap"></a>

## Function `install_plugin_with_root_cap`

Install ToInstallPluginT to Dao and grant the capabilites


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_install_plugin_with_root_cap">install_plugin_with_root_cap</a>&lt;DaoT: store, ToInstallPluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">GenesisDao::DaoRootCap</a>&lt;DaoT&gt;, granted_caps: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_install_plugin_with_root_cap">install_plugin_with_root_cap</a>&lt;DaoT: store, ToInstallPluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoRootCap">DaoRootCap</a>&lt;DaoT&gt;, granted_caps: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>&gt;) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a> {
    <a href="GenesisDao.md#0x1_GenesisDao_do_install_plugin">do_install_plugin</a>&lt;DaoT, ToInstallPluginT&gt;(granted_caps);
}
</code></pre>



</details>

<a name="0x1_GenesisDao_install_plugin"></a>

## Function `install_plugin`

Install plugin with DaoInstallPluginCap


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_install_plugin">install_plugin</a>&lt;DaoT: store, PluginT, ToInstallPluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoInstallPluginCap">GenesisDao::DaoInstallPluginCap</a>&lt;DaoT, PluginT&gt;, granted_caps: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_install_plugin">install_plugin</a>&lt;DaoT: store, PluginT, ToInstallPluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoInstallPluginCap">DaoInstallPluginCap</a>&lt;DaoT, PluginT&gt;, granted_caps: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>&gt;) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a> {
    <a href="GenesisDao.md#0x1_GenesisDao_do_install_plugin">do_install_plugin</a>&lt;DaoT, ToInstallPluginT&gt;(granted_caps);
}
</code></pre>



</details>

<a name="0x1_GenesisDao_do_install_plugin"></a>

## Function `do_install_plugin`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_do_install_plugin">do_install_plugin</a>&lt;DaoT: store, ToInstallPluginT&gt;(granted_caps: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">GenesisDao::CapType</a>&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_do_install_plugin">do_install_plugin</a>&lt;DaoT: store, ToInstallPluginT&gt;(granted_caps: vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>&gt;) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a> {
    <a href="GenesisDao.md#0x1_GenesisDao_assert_no_repeat">assert_no_repeat</a>(&granted_caps);
    <b>let</b> dao_signer = <a href="GenesisDao.md#0x1_GenesisDao_dao_signer">dao_signer</a>&lt;DaoT&gt;();
    <b>assert</b>!(!<b>exists</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a>&lt;ToInstallPluginT&gt;&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&dao_signer)), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_PLUGIN_HAS_INSTALLED">ERR_PLUGIN_HAS_INSTALLED</a>));
    <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a>&lt;ToInstallPluginT&gt;{
        granted_caps,
    });
}
</code></pre>



</details>

<a name="0x1_GenesisDao_submit_upgrade_plan"></a>

## Function `submit_upgrade_plan`

Submit upgrade module plan


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_submit_upgrade_plan">submit_upgrade_plan</a>&lt;DaoT: store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoUpgradeModuleCap">GenesisDao::DaoUpgradeModuleCap</a>&lt;DaoT, PluginT&gt;, package_hash: vector&lt;u8&gt;, version: u64, enforced: bool)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_submit_upgrade_plan">submit_upgrade_plan</a>&lt;DaoT: store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoUpgradeModuleCap">DaoUpgradeModuleCap</a>&lt;DaoT, PluginT&gt;, package_hash: vector&lt;u8&gt;, version: u64, enforced: bool) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a> {
    <b>let</b> dao_account_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a>&gt;(<a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;()).cap;
    <a href="DaoAccount.md#0x1_DaoAccount_submit_upgrade_plan">DaoAccount::submit_upgrade_plan</a>(dao_account_cap, package_hash, version, enforced);
}
</code></pre>



</details>

<a name="0x1_GenesisDao_save"></a>

## Function `save`

Save the item to the storage


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_save">save</a>&lt;DaoT: store, PluginT, V: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoStorageCap">GenesisDao::DaoStorageCap</a>&lt;DaoT, PluginT&gt;, item: V)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_save">save</a>&lt;DaoT: store, PluginT, V: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoStorageCap">DaoStorageCap</a>&lt;DaoT, PluginT&gt;, item: V) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a> {
    <b>let</b> dao_signer = <a href="GenesisDao.md#0x1_GenesisDao_dao_signer">dao_signer</a>&lt;DaoT&gt;();
    <b>assert</b>!(!<b>exists</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_StorageItem">StorageItem</a>&lt;PluginT, V&gt;&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&dao_signer)), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_STORAGE_ERROR">ERR_STORAGE_ERROR</a>));
    <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_StorageItem">StorageItem</a>&lt;PluginT, V&gt;{
        item
    });
}
</code></pre>



</details>

<a name="0x1_GenesisDao_take"></a>

## Function `take`

Get the item from the storage


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_take">take</a>&lt;DaoT: store, PluginT, V: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoStorageCap">GenesisDao::DaoStorageCap</a>&lt;DaoT, PluginT&gt;): V
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_take">take</a>&lt;DaoT: store, PluginT, V: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoStorageCap">DaoStorageCap</a>&lt;DaoT, PluginT&gt;): V <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_StorageItem">StorageItem</a> {
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();
    <b>assert</b>!(<b>exists</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_StorageItem">StorageItem</a>&lt;PluginT, V&gt;&gt;(dao_address), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_STORAGE_ERROR">ERR_STORAGE_ERROR</a>));
    <b>let</b> <a href="GenesisDao.md#0x1_GenesisDao_StorageItem">StorageItem</a>{ item } = <b>move_from</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_StorageItem">StorageItem</a>&lt;PluginT, V&gt;&gt;(dao_address);
    item
}
</code></pre>



</details>

<a name="0x1_GenesisDao_withdraw_token"></a>

## Function `withdraw_token`

Withdraw the token from the Dao account


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_withdraw_token">withdraw_token</a>&lt;DaoT: store, PluginT, TokenT: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawTokenCap">GenesisDao::DaoWithdrawTokenCap</a>&lt;DaoT, PluginT&gt;, amount: u128): <a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_withdraw_token">withdraw_token</a>&lt;DaoT: store, PluginT, TokenT: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawTokenCap">DaoWithdrawTokenCap</a>&lt;DaoT, PluginT&gt;, amount: u128): <a href="Token.md#0x1_Token">Token</a>&lt;TokenT&gt; <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a> {
    <b>let</b> dao_signer = <a href="GenesisDao.md#0x1_GenesisDao_dao_signer">dao_signer</a>&lt;DaoT&gt;();
    //we should extract the WithdrawCapability from account, and invoke the withdraw_with_cap ?
    <a href="Account.md#0x1_Account_withdraw">Account::withdraw</a>&lt;TokenT&gt;(&dao_signer, amount)
}
</code></pre>



</details>

<a name="0x1_GenesisDao_withdraw_nft"></a>

## Function `withdraw_nft`

Withdraw the NFT from the Dao account


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_withdraw_nft">withdraw_nft</a>&lt;DaoT: store, PluginT, NFTMeta: <b>copy</b>, drop, store, NFTBody: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawNFTCap">GenesisDao::DaoWithdrawNFTCap</a>&lt;DaoT, PluginT&gt;, id: u64): <a href="NFT.md#0x1_NFT_NFT">NFT::NFT</a>&lt;NFTMeta, NFTBody&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_withdraw_nft">withdraw_nft</a>&lt;DaoT: store, PluginT, NFTMeta: store + <b>copy</b> + drop, NFTBody: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawNFTCap">DaoWithdrawNFTCap</a>&lt;DaoT, PluginT&gt;, id: u64): <a href="NFT.md#0x1_NFT">NFT</a>&lt;NFTMeta, NFTBody&gt; <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a> {
    <b>let</b> dao_signer = <a href="GenesisDao.md#0x1_GenesisDao_dao_signer">dao_signer</a>&lt;DaoT&gt;();
    <b>let</b> nft = <a href="NFT.md#0x1_NFTGallery_withdraw">NFTGallery::withdraw</a>&lt;NFTMeta, NFTBody&gt;(&dao_signer, id);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&nft), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_NFT_ERROR">ERR_NFT_ERROR</a>));
    <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(nft)
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


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_join_member">join_member</a>&lt;DaoT: store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">DaoMemberCap</a>&lt;DaoT, PluginT&gt;, to_address: <b>address</b>, init_sbt: u128) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoNFTMintCapHolder">DaoNFTMintCapHolder</a>, <a href="GenesisDao.md#0x1_GenesisDao_DaoTokenMintCapHolder">DaoTokenMintCapHolder</a>, <a href="Dao.md#0x1_Dao">Dao</a>, <a href="GenesisDao.md#0x1_GenesisDao_MemberEvent">MemberEvent</a> {
    <b>assert</b>!(!<a href="GenesisDao.md#0x1_GenesisDao_is_member">is_member</a>&lt;DaoT&gt;(to_address), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_NOT_ALREADY_MEMBER">ERR_NOT_ALREADY_MEMBER</a>));

    <b>let</b> member_id = <a href="GenesisDao.md#0x1_GenesisDao_next_member_id">next_member_id</a>&lt;DaoT&gt;();

    <b>let</b> meta = <a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;{
        id: member_id,
    };

    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();

    <b>let</b> token_mint_cap = &<b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoTokenMintCapHolder">DaoTokenMintCapHolder</a>&lt;DaoT&gt;&gt;(dao_address).cap;
    <b>let</b> sbt = <a href="Token.md#0x1_Token_mint_with_capability">Token::mint_with_capability</a>&lt;DaoT&gt;(token_mint_cap, init_sbt);

    <b>let</b> body = <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberBody">DaoMemberBody</a>&lt;DaoT&gt;{
        sbt,
    };

    <b>let</b> dao = <b>borrow_global</b>&lt;<a href="Dao.md#0x1_Dao">Dao</a>&gt;(dao_address);
    <b>let</b> nft_name = *&dao.name;
    //TODO generate a svg <a href="NFT.md#0x1_NFT">NFT</a> image.
    <b>let</b> nft_image = b"SVG image";
    <b>let</b> nft_description = *&dao.name;
    <b>let</b> basemeta = <a href="NFT.md#0x1_NFT_new_meta_with_image_data">NFT::new_meta_with_image_data</a>(nft_name, nft_image, nft_description);

    <b>let</b> nft_mint_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoNFTMintCapHolder">DaoNFTMintCapHolder</a>&lt;DaoT&gt;&gt;(dao_address).cap;

    <b>let</b> nft = <a href="NFT.md#0x1_NFT_mint_with_cap_v2">NFT::mint_with_cap_v2</a>(dao_address, nft_mint_cap, basemeta, meta, body);
    <a href="NFT.md#0x1_IdentifierNFT_grant_to">IdentifierNFT::grant_to</a>(nft_mint_cap, to_address, nft);
    <b>let</b> memeber_event = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MemberEvent">MemberEvent</a>&lt;DaoT&gt;&gt;(dao_address);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_join_event_handler, <a href="GenesisDao.md#0x1_GenesisDao_MemberJoinEvent">MemberJoinEvent</a>&lt;DaoT&gt; {
        id : member_id,
        addr:to_address,
        sbt: init_sbt,
    });
}
</code></pre>



</details>

<a name="0x1_GenesisDao_quit_member"></a>

## Function `quit_member`

Member quit Dao by self


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_quit_member">quit_member</a>&lt;DaoT: store&gt;(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_quit_member">quit_member</a>&lt;DaoT: store&gt;(sender: &signer) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoNFTBurnCapHolder">DaoNFTBurnCapHolder</a>, <a href="GenesisDao.md#0x1_GenesisDao_DaoTokenBurnCapHolder">DaoTokenBurnCapHolder</a>, <a href="GenesisDao.md#0x1_GenesisDao_MemberEvent">MemberEvent</a> {
    <b>let</b> member_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>let</b> (member_id , sbt) = <a href="GenesisDao.md#0x1_GenesisDao_do_remove_member">do_remove_member</a>&lt;DaoT&gt;(member_addr);
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();

    <b>let</b> memeber_event = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MemberEvent">MemberEvent</a>&lt;DaoT&gt;&gt;(dao_address);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_quit_event_handler, <a href="GenesisDao.md#0x1_GenesisDao_MemberQuitEvent">MemberQuitEvent</a>&lt;DaoT&gt; {
        id : member_id,
        addr:member_addr,
        sbt: sbt,
    });
}
</code></pre>



</details>

<a name="0x1_GenesisDao_revoke_member"></a>

## Function `revoke_member`

Revoke membership with cap


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_revoke_member">revoke_member</a>&lt;DaoT: store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">GenesisDao::DaoMemberCap</a>&lt;DaoT, PluginT&gt;, member_addr: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_revoke_member">revoke_member</a>&lt;DaoT: store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">DaoMemberCap</a>&lt;DaoT, PluginT&gt;, member_addr: <b>address</b>) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoNFTBurnCapHolder">DaoNFTBurnCapHolder</a>, <a href="GenesisDao.md#0x1_GenesisDao_DaoTokenBurnCapHolder">DaoTokenBurnCapHolder</a>, <a href="GenesisDao.md#0x1_GenesisDao_MemberEvent">MemberEvent</a> {
    <b>let</b> (member_id , sbt) = <a href="GenesisDao.md#0x1_GenesisDao_do_remove_member">do_remove_member</a>&lt;DaoT&gt;(member_addr);
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();

    <b>let</b> memeber_event = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MemberEvent">MemberEvent</a>&lt;DaoT&gt;&gt;(dao_address);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_revoke_event_handler, <a href="GenesisDao.md#0x1_GenesisDao_MemberRevokeEvent">MemberRevokeEvent</a>&lt;DaoT&gt; {
        id : member_id,
        addr:member_addr,
        sbt: sbt,
    });
}
</code></pre>



</details>

<a name="0x1_GenesisDao_do_remove_member"></a>

## Function `do_remove_member`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_do_remove_member">do_remove_member</a>&lt;DaoT: store&gt;(member_addr: <b>address</b>): (u64, u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_do_remove_member">do_remove_member</a>&lt;DaoT: store&gt;(member_addr: <b>address</b>):(u64,u128) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoNFTBurnCapHolder">DaoNFTBurnCapHolder</a>, <a href="GenesisDao.md#0x1_GenesisDao_DaoTokenBurnCapHolder">DaoTokenBurnCapHolder</a> {
    <b>assert</b>!(<a href="GenesisDao.md#0x1_GenesisDao_is_member">is_member</a>&lt;DaoT&gt;(member_addr), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_NOT_MEMBER">ERR_NOT_MEMBER</a>));
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();

    <b>let</b> nft_burn_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoNFTBurnCapHolder">DaoNFTBurnCapHolder</a>&lt;DaoT&gt;&gt;(dao_address).cap;
    <b>let</b> nft = <a href="NFT.md#0x1_IdentifierNFT_revoke">IdentifierNFT::revoke</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;, <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberBody">DaoMemberBody</a>&lt;DaoT&gt;&gt;(nft_burn_cap, member_addr);
    <b>let</b> member_id = <a href="NFT.md#0x1_NFT_get_type_meta">NFT::get_type_meta</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;, <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberBody">DaoMemberBody</a>&lt;DaoT&gt;&gt;(&nft).id;
    <b>let</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberBody">DaoMemberBody</a>&lt;DaoT&gt;{ sbt } = <a href="NFT.md#0x1_NFT_burn_with_cap">NFT::burn_with_cap</a>(nft_burn_cap, nft);
    <b>let</b> sbt_amount = <a href="Token.md#0x1_Token_value">Token::value</a>&lt;DaoT&gt;(&sbt);
    <b>let</b> token_burn_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoTokenBurnCapHolder">DaoTokenBurnCapHolder</a>&lt;DaoT&gt;&gt;(dao_address).cap;
    <a href="Token.md#0x1_Token_burn_with_capability">Token::burn_with_capability</a>(token_burn_cap, sbt);
    (member_id, sbt_amount)
}
</code></pre>



</details>

<a name="0x1_GenesisDao_increase_member_sbt"></a>

## Function `increase_member_sbt`

Increment the member SBT


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_increase_member_sbt">increase_member_sbt</a>&lt;DaoT: store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">GenesisDao::DaoMemberCap</a>&lt;DaoT, PluginT&gt;, member_addr: <b>address</b>, amount: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_increase_member_sbt">increase_member_sbt</a>&lt;DaoT: store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">DaoMemberCap</a>&lt;DaoT, PluginT&gt;, member_addr: <b>address</b>, amount: u128) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoNFTUpdateCapHolder">DaoNFTUpdateCapHolder</a>, <a href="GenesisDao.md#0x1_GenesisDao_DaoTokenMintCapHolder">DaoTokenMintCapHolder</a>, <a href="GenesisDao.md#0x1_GenesisDao_MemberEvent">MemberEvent</a> {
    <b>assert</b>!(<a href="GenesisDao.md#0x1_GenesisDao_is_member">is_member</a>&lt;DaoT&gt;(member_addr), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_NOT_MEMBER">ERR_NOT_MEMBER</a>));
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();

    <b>let</b> nft_update_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoNFTUpdateCapHolder">DaoNFTUpdateCapHolder</a>&lt;DaoT&gt;&gt;(dao_address).cap;
    <b>let</b> borrow_nft = <a href="NFT.md#0x1_IdentifierNFT_borrow_out">IdentifierNFT::borrow_out</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;, <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberBody">DaoMemberBody</a>&lt;DaoT&gt;&gt;(nft_update_cap, member_addr);
    <b>let</b> nft = <a href="NFT.md#0x1_IdentifierNFT_borrow_nft_mut">IdentifierNFT::borrow_nft_mut</a>(&<b>mut</b> borrow_nft);
    <b>let</b> member_id = <a href="NFT.md#0x1_NFT_get_type_meta">NFT::get_type_meta</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;, <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberBody">DaoMemberBody</a>&lt;DaoT&gt;&gt;(nft).id;

    <b>let</b> body = <a href="NFT.md#0x1_NFT_borrow_body_mut_with_cap">NFT::borrow_body_mut_with_cap</a>(nft_update_cap, nft);

    <b>let</b> token_mint_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoTokenMintCapHolder">DaoTokenMintCapHolder</a>&lt;DaoT&gt;&gt;(dao_address).cap;
    <b>let</b> increase_sbt = <a href="Token.md#0x1_Token_mint_with_capability">Token::mint_with_capability</a>&lt;DaoT&gt;(token_mint_cap, amount);
    <a href="Token.md#0x1_Token_deposit">Token::deposit</a>(&<b>mut</b> body.sbt, increase_sbt);

    <b>let</b> sbt_amount = <a href="Token.md#0x1_Token_value">Token::value</a>&lt;DaoT&gt;(&body.sbt);
    <a href="NFT.md#0x1_IdentifierNFT_return_back">IdentifierNFT::return_back</a>(borrow_nft);

    <b>let</b> memeber_event = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MemberEvent">MemberEvent</a>&lt;DaoT&gt;&gt;(dao_address);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_increase_sbt_event_handler, <a href="GenesisDao.md#0x1_GenesisDao_MemberIncreaseSBTEvent">MemberIncreaseSBTEvent</a>&lt;DaoT&gt; {
        id : member_id,
        addr:member_addr,
        increase_sbt:amount,
        sbt: sbt_amount,
    });
}
</code></pre>



</details>

<a name="0x1_GenesisDao_decrease_member_sbt"></a>

## Function `decrease_member_sbt`

Decrement the member SBT


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_decrease_member_sbt">decrease_member_sbt</a>&lt;DaoT: store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">GenesisDao::DaoMemberCap</a>&lt;DaoT, PluginT&gt;, member_addr: <b>address</b>, amount: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_decrease_member_sbt">decrease_member_sbt</a>&lt;DaoT: store, PluginT&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">DaoMemberCap</a>&lt;DaoT, PluginT&gt;, member_addr: <b>address</b>, amount: u128) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoNFTUpdateCapHolder">DaoNFTUpdateCapHolder</a>, <a href="GenesisDao.md#0x1_GenesisDao_DaoTokenBurnCapHolder">DaoTokenBurnCapHolder</a>, <a href="GenesisDao.md#0x1_GenesisDao_MemberEvent">MemberEvent</a> {
    <b>assert</b>!(<a href="GenesisDao.md#0x1_GenesisDao_is_member">is_member</a>&lt;DaoT&gt;(member_addr), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_NOT_MEMBER">ERR_NOT_MEMBER</a>));
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();

    <b>let</b> nft_update_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoNFTUpdateCapHolder">DaoNFTUpdateCapHolder</a>&lt;DaoT&gt;&gt;(dao_address).cap;
    <b>let</b> borrow_nft = <a href="NFT.md#0x1_IdentifierNFT_borrow_out">IdentifierNFT::borrow_out</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;, <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberBody">DaoMemberBody</a>&lt;DaoT&gt;&gt;(nft_update_cap, member_addr);
    <b>let</b> nft = <a href="NFT.md#0x1_IdentifierNFT_borrow_nft_mut">IdentifierNFT::borrow_nft_mut</a>(&<b>mut</b> borrow_nft);
    <b>let</b> member_id = <a href="NFT.md#0x1_NFT_get_type_meta">NFT::get_type_meta</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;, <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberBody">DaoMemberBody</a>&lt;DaoT&gt;&gt;(nft).id;

    <b>let</b> body = <a href="NFT.md#0x1_NFT_borrow_body_mut_with_cap">NFT::borrow_body_mut_with_cap</a>(nft_update_cap, nft);

    <b>let</b> token_burn_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoTokenBurnCapHolder">DaoTokenBurnCapHolder</a>&lt;DaoT&gt;&gt;(dao_address).cap;
    <b>let</b> decrease_sbt = <a href="Token.md#0x1_Token_withdraw">Token::withdraw</a>(&<b>mut</b> body.sbt, amount);
    <b>let</b> sbt_amount = <a href="Token.md#0x1_Token_value">Token::value</a>&lt;DaoT&gt;(&body.sbt);

    <a href="Token.md#0x1_Token_burn_with_capability">Token::burn_with_capability</a>(token_burn_cap, decrease_sbt);
    <a href="NFT.md#0x1_IdentifierNFT_return_back">IdentifierNFT::return_back</a>(borrow_nft);

    <b>let</b> memeber_event = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MemberEvent">MemberEvent</a>&lt;DaoT&gt;&gt;(dao_address);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_decrease_sbt_event_handler, <a href="GenesisDao.md#0x1_GenesisDao_MemberDecreaseSBTEvent">MemberDecreaseSBTEvent</a>&lt;DaoT&gt; {
        id : member_id,
        addr:member_addr,
        decrease_sbt:amount,
        sbt: sbt_amount,
    });
}
</code></pre>



</details>

<a name="0x1_GenesisDao_query_sbt"></a>

## Function `query_sbt`

Query amount of the member SBT


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_query_sbt">query_sbt</a>&lt;DaoT: store, PluginT&gt;(member_addr: <b>address</b>): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_query_sbt">query_sbt</a>&lt;DaoT: store, PluginT&gt;(member_addr: <b>address</b>)
: u128 <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoNFTUpdateCapHolder">DaoNFTUpdateCapHolder</a> {
    <b>assert</b>!(<a href="GenesisDao.md#0x1_GenesisDao_is_member">is_member</a>&lt;DaoT&gt;(member_addr), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_NOT_MEMBER">ERR_NOT_MEMBER</a>));
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();

    <b>let</b> nft_update_cap =
        &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoNFTUpdateCapHolder">DaoNFTUpdateCapHolder</a>&lt;DaoT&gt;&gt;(dao_address).cap;
    <b>let</b> borrow_nft =
        <a href="NFT.md#0x1_IdentifierNFT_borrow_out">IdentifierNFT::borrow_out</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoMember">DaoMember</a>&lt;DaoT&gt;, <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberBody">DaoMemberBody</a>&lt;DaoT&gt;&gt;(nft_update_cap, member_addr);
    <b>let</b> nft = <a href="NFT.md#0x1_IdentifierNFT_borrow_nft">IdentifierNFT::borrow_nft</a>(&<b>mut</b> borrow_nft);
    <b>let</b> body = <a href="NFT.md#0x1_NFT_borrow_body">NFT::borrow_body</a>(nft);

    <b>let</b> result = <a href="Token.md#0x1_Token_value">Token::value</a>(&body.sbt);
    <a href="NFT.md#0x1_IdentifierNFT_return_back">IdentifierNFT::return_back</a>(borrow_nft);
    result
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


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_is_member">is_member</a>&lt;DaoT: store&gt;(member_addr: <b>address</b>): bool {
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


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_validate_cap">validate_cap</a>&lt;DaoT: store, PluginT&gt;(cap: <a href="GenesisDao.md#0x1_GenesisDao_CapType">CapType</a>) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a> {
    <b>let</b> addr = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();
    <b>if</b> (<b>exists</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a>&lt;PluginT&gt;&gt;(addr)) {
        <b>let</b> plugin_info = <b>borrow_global</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a>&lt;PluginT&gt;&gt;(addr);
        <b>assert</b>!(<a href="Vector.md#0x1_Vector_contains">Vector::contains</a>(&plugin_info.granted_caps, &cap), <a href="Errors.md#0x1_Errors_requires_capability">Errors::requires_capability</a>(<a href="GenesisDao.md#0x1_GenesisDao_E_NO_GRANTED">E_NO_GRANTED</a>));
    } <b>else</b> {
        <b>abort</b> (<a href="Errors.md#0x1_Errors_requires_capability">Errors::requires_capability</a>(<a href="GenesisDao.md#0x1_GenesisDao_E_NO_GRANTED">E_NO_GRANTED</a>))
    }
}
</code></pre>



</details>

<a name="0x1_GenesisDao_acquire_install_plugin_cap"></a>

## Function `acquire_install_plugin_cap`

Acquire the installed plugin capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_install_plugin_cap">acquire_install_plugin_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoInstallPluginCap">GenesisDao::DaoInstallPluginCap</a>&lt;DaoT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_install_plugin_cap">acquire_install_plugin_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoInstallPluginCap">DaoInstallPluginCap</a>&lt;DaoT, PluginT&gt; <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="GenesisDao.md#0x1_GenesisDao_validate_cap">validate_cap</a>&lt;DaoT, PluginT&gt;(<a href="GenesisDao.md#0x1_GenesisDao_install_plugin_cap_type">install_plugin_cap_type</a>());
    <a href="GenesisDao.md#0x1_GenesisDao_DaoInstallPluginCap">DaoInstallPluginCap</a>&lt;DaoT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_GenesisDao_acquire_upgrade_module_cap"></a>

## Function `acquire_upgrade_module_cap`

Acquire the upgrade module capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_upgrade_module_cap">acquire_upgrade_module_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoUpgradeModuleCap">GenesisDao::DaoUpgradeModuleCap</a>&lt;DaoT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_upgrade_module_cap">acquire_upgrade_module_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoUpgradeModuleCap">DaoUpgradeModuleCap</a>&lt;DaoT, PluginT&gt; <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="GenesisDao.md#0x1_GenesisDao_validate_cap">validate_cap</a>&lt;DaoT, PluginT&gt;(<a href="GenesisDao.md#0x1_GenesisDao_upgrade_module_cap_type">upgrade_module_cap_type</a>());
    <a href="GenesisDao.md#0x1_GenesisDao_DaoUpgradeModuleCap">DaoUpgradeModuleCap</a>&lt;DaoT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_GenesisDao_acquire_modify_config_cap"></a>

## Function `acquire_modify_config_cap`

Acquire the modify config capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_modify_config_cap">acquire_modify_config_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoModifyConfigCap">GenesisDao::DaoModifyConfigCap</a>&lt;DaoT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_modify_config_cap">acquire_modify_config_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoModifyConfigCap">DaoModifyConfigCap</a>&lt;DaoT, PluginT&gt; <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="GenesisDao.md#0x1_GenesisDao_validate_cap">validate_cap</a>&lt;DaoT, PluginT&gt;(<a href="GenesisDao.md#0x1_GenesisDao_modify_config_cap_type">modify_config_cap_type</a>());
    <a href="GenesisDao.md#0x1_GenesisDao_DaoModifyConfigCap">DaoModifyConfigCap</a>&lt;DaoT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_GenesisDao_acquire_withdraw_token_cap"></a>

## Function `acquire_withdraw_token_cap`

Acquires the withdraw Token capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_withdraw_token_cap">acquire_withdraw_token_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawTokenCap">GenesisDao::DaoWithdrawTokenCap</a>&lt;DaoT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_withdraw_token_cap">acquire_withdraw_token_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawTokenCap">DaoWithdrawTokenCap</a>&lt;DaoT, PluginT&gt; <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="GenesisDao.md#0x1_GenesisDao_validate_cap">validate_cap</a>&lt;DaoT, PluginT&gt;(<a href="GenesisDao.md#0x1_GenesisDao_withdraw_token_cap_type">withdraw_token_cap_type</a>());
    <a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawTokenCap">DaoWithdrawTokenCap</a>&lt;DaoT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_GenesisDao_acquire_withdraw_nft_cap"></a>

## Function `acquire_withdraw_nft_cap`

Acquires the withdraw NFT capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_withdraw_nft_cap">acquire_withdraw_nft_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawNFTCap">GenesisDao::DaoWithdrawNFTCap</a>&lt;DaoT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_withdraw_nft_cap">acquire_withdraw_nft_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawNFTCap">DaoWithdrawNFTCap</a>&lt;DaoT, PluginT&gt; <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="GenesisDao.md#0x1_GenesisDao_validate_cap">validate_cap</a>&lt;DaoT, PluginT&gt;(<a href="GenesisDao.md#0x1_GenesisDao_withdraw_nft_cap_type">withdraw_nft_cap_type</a>());
    <a href="GenesisDao.md#0x1_GenesisDao_DaoWithdrawNFTCap">DaoWithdrawNFTCap</a>&lt;DaoT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_GenesisDao_acquire_storage_cap"></a>

## Function `acquire_storage_cap`

Acquires the storage capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_storage_cap">acquire_storage_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoStorageCap">GenesisDao::DaoStorageCap</a>&lt;DaoT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_storage_cap">acquire_storage_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoStorageCap">DaoStorageCap</a>&lt;DaoT, PluginT&gt; <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="GenesisDao.md#0x1_GenesisDao_validate_cap">validate_cap</a>&lt;DaoT, PluginT&gt;(<a href="GenesisDao.md#0x1_GenesisDao_storage_cap_type">storage_cap_type</a>());
    <a href="GenesisDao.md#0x1_GenesisDao_DaoStorageCap">DaoStorageCap</a>&lt;DaoT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_GenesisDao_acquire_member_cap"></a>

## Function `acquire_member_cap`

Acquires the membership capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_member_cap">acquire_member_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">GenesisDao::DaoMemberCap</a>&lt;DaoT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_member_cap">acquire_member_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">DaoMemberCap</a>&lt;DaoT, PluginT&gt; <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="GenesisDao.md#0x1_GenesisDao_validate_cap">validate_cap</a>&lt;DaoT, PluginT&gt;(<a href="GenesisDao.md#0x1_GenesisDao_member_cap_type">member_cap_type</a>());
    <a href="GenesisDao.md#0x1_GenesisDao_DaoMemberCap">DaoMemberCap</a>&lt;DaoT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_GenesisDao_acquire_proposal_cap"></a>

## Function `acquire_proposal_cap`

Acquire the proposql capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_proposal_cap">acquire_proposal_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoProposalCap">GenesisDao::DaoProposalCap</a>&lt;DaoT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_acquire_proposal_cap">acquire_proposal_cap</a>&lt;DaoT: store, PluginT&gt;(_witness: &PluginT): <a href="GenesisDao.md#0x1_GenesisDao_DaoProposalCap">DaoProposalCap</a>&lt;DaoT, PluginT&gt; <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_InstalledPluginInfo">InstalledPluginInfo</a> {
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


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_choice_yes">choice_yes</a>(): <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a> { <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a>{ choice: <a href="GenesisDao.md#0x1_GenesisDao_VOTING_CHOICE_YES">VOTING_CHOICE_YES</a> } }
</code></pre>



</details>

<a name="0x1_GenesisDao_choice_no"></a>

## Function `choice_no`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_choice_no">choice_no</a>(): <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">GenesisDao::VotingChoice</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_choice_no">choice_no</a>(): <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a> { <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a>{ choice: <a href="GenesisDao.md#0x1_GenesisDao_VOTING_CHOICE_NO">VOTING_CHOICE_NO</a> } }
</code></pre>



</details>

<a name="0x1_GenesisDao_choice_no_with_veto"></a>

## Function `choice_no_with_veto`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_choice_no_with_veto">choice_no_with_veto</a>(): <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">GenesisDao::VotingChoice</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_choice_no_with_veto">choice_no_with_veto</a>(): <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a> { <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a>{ choice: <a href="GenesisDao.md#0x1_GenesisDao_VOTING_CHOICE_NO_WITH_VETO">VOTING_CHOICE_NO_WITH_VETO</a> } }
</code></pre>



</details>

<a name="0x1_GenesisDao_choice_abstain"></a>

## Function `choice_abstain`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_choice_abstain">choice_abstain</a>(): <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">GenesisDao::VotingChoice</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_choice_abstain">choice_abstain</a>(): <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a> { <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a>{ choice: <a href="GenesisDao.md#0x1_GenesisDao_VOTING_CHOICE_ABSTAIN">VOTING_CHOICE_ABSTAIN</a> } }
</code></pre>



</details>

<a name="0x1_GenesisDao_initialize_proposal"></a>

## Function `initialize_proposal`

Initialize proposal
only call by dao singer when DAO create


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_initialize_proposal">initialize_proposal</a>&lt;DaoT: store&gt;(cap: &<a href="DaoAccount.md#0x1_DaoAccount_DaoAccountCap">DaoAccount::DaoAccountCap</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_initialize_proposal">initialize_proposal</a>&lt;DaoT: store&gt;(cap: &DaoAccountCap) {
    <b>let</b> dao_signer = <a href="DaoAccount.md#0x1_DaoAccount_dao_signer">DaoAccount::dao_signer</a>(cap);

    <b>let</b> proposal_event = <a href="GenesisDao.md#0x1_GenesisDao_ProposalEvent">ProposalEvent</a>&lt;DaoT&gt;  {
        proposal_create_event: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_ProposalCreatedEvent">ProposalCreatedEvent</a>&gt;(&dao_signer),
        vote_changed_event: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_VoteChangedEvent">VoteChangedEvent</a>&gt;(&dao_signer),
    };
    <b>move_to</b>(&dao_signer, proposal_event);
}
</code></pre>



</details>

<a name="0x1_GenesisDao_create_proposal"></a>

## Function `create_proposal`

propose a proposal.
<code>action</code>: the actual action to execute.
<code>action_delay</code>: the delay to execute after the proposal is agreed


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_create_proposal">create_proposal</a>&lt;DaoT: store, PluginT, ActionT: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoProposalCap">GenesisDao::DaoProposalCap</a>&lt;DaoT, PluginT&gt;, sender: &signer, action: ActionT, action_delay: u64): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_create_proposal">create_proposal</a>&lt;DaoT: store, PluginT, ActionT: store&gt;(
    _cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoProposalCap">DaoProposalCap</a>&lt;DaoT, PluginT&gt;,
    sender: &signer,
    action: ActionT,
    action_delay: u64,
): u64 <b>acquires</b> <a href="Dao.md#0x1_Dao">Dao</a>, <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>, <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a>, <a href="GenesisDao.md#0x1_GenesisDao_ProposalActions">ProposalActions</a>, <a href="GenesisDao.md#0x1_GenesisDao_ProposalEvent">ProposalEvent</a>, <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposalActions">GlobalProposalActions</a> {
    // check <a href="Dao.md#0x1_Dao">Dao</a> member
    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>assert</b>!(<a href="GenesisDao.md#0x1_GenesisDao_is_member">is_member</a>&lt;DaoT&gt;(sender_addr), <a href="Errors.md#0x1_Errors_requires_capability">Errors::requires_capability</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_NOT_DAO_MEMBER">ERR_NOT_DAO_MEMBER</a>));

    <b>if</b> (action_delay == 0) {
        action_delay = <a href="GenesisDao.md#0x1_GenesisDao_min_action_delay">min_action_delay</a>&lt;DaoT&gt;();
    } <b>else</b> {
        <b>assert</b>!(action_delay &gt;= <a href="GenesisDao.md#0x1_GenesisDao_min_action_delay">min_action_delay</a>&lt;DaoT&gt;(), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_ACTION_DELAY_TOO_SMALL">ERR_ACTION_DELAY_TOO_SMALL</a>));
    };

    <b>let</b> min_proposal_deposit = <a href="GenesisDao.md#0x1_GenesisDao_min_proposal_deposit">min_proposal_deposit</a>&lt;DaoT&gt;();
    <b>let</b> deposit = <a href="Account.md#0x1_Account_withdraw">Account::withdraw</a>&lt;<a href="STC.md#0x1_STC">STC</a>&gt;(sender, min_proposal_deposit);

    <b>let</b> proposal_id = <a href="GenesisDao.md#0x1_GenesisDao_next_proposal_id">next_proposal_id</a>&lt;DaoT&gt;();
    <b>let</b> proposer = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>let</b> start_time = <a href="Timestamp.md#0x1_Timestamp_now_milliseconds">Timestamp::now_milliseconds</a>() + <a href="GenesisDao.md#0x1_GenesisDao_voting_delay">voting_delay</a>&lt;DaoT&gt;();
    <b>let</b> quorum_votes = <a href="GenesisDao.md#0x1_GenesisDao_quorum_votes">quorum_votes</a>&lt;DaoT&gt;();
    <b>let</b> voting_period = <a href="GenesisDao.md#0x1_GenesisDao_voting_period">voting_period</a>&lt;DaoT&gt;();

    <b>let</b> (block_number,state_root) = <a href="GenesisDao.md#0x1_GenesisDao_block_number_and_state_root">block_number_and_state_root</a>();

    <b>let</b> proposal = <a href="GenesisDao.md#0x1_GenesisDao_Proposal">Proposal</a> {
        id: proposal_id,
        proposer,
        start_time,
        end_time: start_time + voting_period,
        yes_votes: 0,
        no_votes: 0,
        no_with_veto_votes: 0,
        abstain_votes: 0,
        eta: 0,
        action_delay,
        quorum_votes,
        block_number,
        state_root,
    };
    <b>let</b> proposal_action = <a href="GenesisDao.md#0x1_GenesisDao_ProposalAction">ProposalAction</a>{
        proposal_id,
        deposit,
        action,
    };
    <b>let</b> proposal_action_index = <a href="GenesisDao.md#0x1_GenesisDao_ProposalActionIndex">ProposalActionIndex</a>{
        proposal_id,
    };

    <b>let</b> dao_signer = <a href="GenesisDao.md#0x1_GenesisDao_dao_signer">dao_signer</a>&lt;DaoT&gt;();
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();

    <b>let</b> actions = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(proposal_action);
    // check <a href="GenesisDao.md#0x1_GenesisDao_ProposalActions">ProposalActions</a> is <b>exists</b>
    <b>if</b>(<b>exists</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_ProposalActions">ProposalActions</a>&lt;ActionT&gt;&gt;(dao_address)){
        //TODO add limit <b>to</b> max action before support Table.
        <b>let</b> current_actions = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_ProposalActions">ProposalActions</a>&lt;ActionT&gt;&gt;(dao_address);
        <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> current_actions.actions, actions);
    }<b>else</b>{
        <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_ProposalActions">ProposalActions</a>&lt;ActionT&gt;{
            actions,
        });
    };

    <b>let</b> proposal_action_indexs = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(proposal_action_index);
    // check <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposalActions">GlobalProposalActions</a> is <b>exists</b>
    <b>if</b>(<b>exists</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposalActions">GlobalProposalActions</a>&gt;(dao_address)){
        //TODO add limit <b>to</b> max <b>global</b> proposal action indexs before support Table
        <b>let</b> current_global_proposal_actions = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposalActions">GlobalProposalActions</a>&gt;(dao_address);
        <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> current_global_proposal_actions.proposal_action_indexs, proposal_action_indexs);
    }<b>else</b>{
        <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposalActions">GlobalProposalActions</a>{
            proposal_action_indexs,
        });
    };

    <b>let</b> proposals = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(proposal);
    // check <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a> is <b>exists</b>
    <b>if</b>(<b>exists</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>&gt;(dao_address)){
        //TODO add limit <b>to</b> max <b>global</b> proposal before support Table
        <b>let</b> current_global_proposals = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>&gt;(dao_address);
        <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> current_global_proposals.proposals, proposals);
    }<b>else</b>{
        <b>move_to</b>(&dao_signer, <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>{
            proposals,
        });
    };

    // emit event
    <b>let</b> proposal_event = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_ProposalEvent">ProposalEvent</a>&lt;DaoT&gt;&gt;(<a href="DaoRegistry.md#0x1_DaoRegistry_dao_address">DaoRegistry::dao_address</a>&lt;DaoT&gt;());
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> proposal_event.proposal_create_event,
        <a href="GenesisDao.md#0x1_GenesisDao_ProposalCreatedEvent">ProposalCreatedEvent</a> { proposal_id, proposer },
    );

    proposal_id
}
</code></pre>



</details>

<a name="0x1_GenesisDao_block_number_and_state_root"></a>

## Function `block_number_and_state_root`

get lastest block number and state root


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_block_number_and_state_root">block_number_and_state_root</a>(): (u64, vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_block_number_and_state_root">block_number_and_state_root</a>(): (u64, vector&lt;u8&gt;) {
//        <a href="Block.md#0x1_Block_latest_state_root">Block::latest_state_root</a>()
    (101, x"5981f1a692a6d9f4772e69a46d1380158a0e1b2c31654aa9df4b0e591e8faab0")
}
</code></pre>



</details>

<a name="0x1_GenesisDao_cast_vote"></a>

## Function `cast_vote`

votes for a proposal.
User can only vote once, then the stake is locked,
The voting power depends on the strategy of the proposal configuration and the user's token amount at the time of the snapshot


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_cast_vote">cast_vote</a>&lt;DaoT: store&gt;(sender: &signer, proposal_id: u64, snpashot_proofs: vector&lt;u8&gt;, choice: <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">GenesisDao::VotingChoice</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_cast_vote">cast_vote</a>&lt;DaoT: store&gt;(
    sender: &signer,
    proposal_id: u64,
    snpashot_proofs: vector&lt;u8&gt;,
    choice: <a href="GenesisDao.md#0x1_GenesisDao_VotingChoice">VotingChoice</a>,
)  <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>, <a href="GenesisDao.md#0x1_GenesisDao_MyVotes">MyVotes</a>, <a href="GenesisDao.md#0x1_GenesisDao_ProposalEvent">ProposalEvent</a>, <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposalActions">GlobalProposalActions</a> {
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();
    <b>let</b> proposals = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>&gt;(dao_address);
    <b>let</b> proposal = <a href="GenesisDao.md#0x1_GenesisDao_borrow_proposal_mut">borrow_proposal_mut</a>(proposals, proposal_id);

        {
            <b>let</b> state = <a href="GenesisDao.md#0x1_GenesisDao_proposal_state_with_proposal">proposal_state_with_proposal</a>&lt;DaoT&gt;(proposal);
            // only when proposal is active, <b>use</b> can cast vote.
            <b>assert</b>!(state == <a href="GenesisDao.md#0x1_GenesisDao_ACTIVE">ACTIVE</a>, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSAL_STATE_INVALID">ERR_PROPOSAL_STATE_INVALID</a>));
        };

    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    // check <a href="Dao.md#0x1_Dao">Dao</a> member
    <b>assert</b>!(<a href="GenesisDao.md#0x1_GenesisDao_is_member">is_member</a>&lt;DaoT&gt;(sender_addr), <a href="Errors.md#0x1_Errors_requires_capability">Errors::requires_capability</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_NOT_DAO_MEMBER">ERR_NOT_DAO_MEMBER</a>));

    // verify snapshot state proof
    <b>let</b> snapshot_proofs = <a href="GenesisDao.md#0x1_GenesisDao_deserialize_snapshot_proofs">deserialize_snapshot_proofs</a>(&snpashot_proofs);
    <b>let</b> state_proof = <a href="GenesisDao.md#0x1_GenesisDao_new_state_proof_from_proofs">new_state_proof_from_proofs</a>(&snapshot_proofs);
    // TODO check resource_struct_tag is DAO <b>struct</b> tag, need de resource_struct_tag
    // verify state_proof according <b>to</b> proposal snapshot proofs, and state root
    <b>let</b> verify = <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_verify_state_proof">StarcoinVerifier::verify_state_proof</a>(&state_proof, &proposal.state_root, sender_addr, &snapshot_proofs.resource_struct_tag, &snapshot_proofs.state);
    <b>assert</b>!(verify, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_STATE_PROOF_VERIFY_INVALID">ERR_STATE_PROOF_VERIFY_INVALID</a>));

    // TODO is allowed just <b>use</b> part of weight?
    // decode sbt value from snapshot state
    <b>let</b> vote_weight = <a href="SBTVoteStrategy.md#0x1_SBTVoteStrategy_get_voting_power">SBTVoteStrategy::get_voting_power</a>(&snapshot_proofs.state);

    <b>assert</b>!(!<a href="GenesisDao.md#0x1_GenesisDao_has_voted">has_voted</a>&lt;DaoT&gt;(sender_addr, proposal_id), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_VOTED_ALREADY">ERR_VOTED_ALREADY</a>));

    <b>let</b> vote = <a href="GenesisDao.md#0x1_GenesisDao_Vote">Vote</a>{
        proposal_id,
        vote_weight,
        choice: choice.choice,
    };

    <a href="GenesisDao.md#0x1_GenesisDao_do_cast_vote">do_cast_vote</a>(proposal, &<b>mut</b> vote);

    <b>if</b> (<b>exists</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MyVotes">MyVotes</a>&lt;DaoT&gt;&gt;(sender_addr)) {
        <b>assert</b>!(vote.proposal_id == proposal_id, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_VOTED_OTHERS_ALREADY">ERR_VOTED_OTHERS_ALREADY</a>));
        <b>let</b> my_votes = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_MyVotes">MyVotes</a>&lt;DaoT&gt;&gt;(sender_addr);
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> my_votes.votes, vote);
    } <b>else</b> {
        <b>move_to</b>(sender, <a href="GenesisDao.md#0x1_GenesisDao_MyVotes">MyVotes</a>&lt;DaoT&gt;{
            votes: <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(vote),
        });
    };

    // emit event
    <b>let</b> proposal_event = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_ProposalEvent">ProposalEvent</a>&lt;DaoT&gt; &gt;(<a href="DaoRegistry.md#0x1_DaoRegistry_dao_address">DaoRegistry::dao_address</a>&lt;DaoT&gt;());
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> proposal_event.vote_changed_event,
        <a href="GenesisDao.md#0x1_GenesisDao_VoteChangedEvent">VoteChangedEvent</a> {
            proposal_id,
            voter: sender_addr,
            choice: choice.choice,
            vote_weight,
        },
    );
}
</code></pre>



</details>

<a name="0x1_GenesisDao_deserialize_snapshot_proofs"></a>

## Function `deserialize_snapshot_proofs`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_deserialize_snapshot_proofs">deserialize_snapshot_proofs</a>(snapshot_proofs: &vector&lt;u8&gt;): <a href="GenesisDao.md#0x1_GenesisDao_SnapshotProof">GenesisDao::SnapshotProof</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_deserialize_snapshot_proofs">deserialize_snapshot_proofs</a>(snapshot_proofs: &vector&lt;u8&gt;): <a href="GenesisDao.md#0x1_GenesisDao_SnapshotProof">SnapshotProof</a>{
    <b>assert</b>!(<a href="Vector.md#0x1_Vector_length">Vector::length</a>(snapshot_proofs) &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_SNAPSHOT_PROOF_PARAM_INVALID">ERR_SNAPSHOT_PROOF_PARAM_INVALID</a>));

    <b>let</b> offset= 0;
    <b>let</b> (account_proof_leaf, offset) = <a href="BCS.md#0x1_BCS_deserialize_bytes_vector">BCS::deserialize_bytes_vector</a>(snapshot_proofs, offset);
    <b>let</b> (account_proof_siblings, offset) = <a href="BCS.md#0x1_BCS_deserialize_bytes_vector">BCS::deserialize_bytes_vector</a>(snapshot_proofs, offset);
    <b>let</b> (account_state, offset) = <a href="BCS.md#0x1_BCS_deserialize_bytes">BCS::deserialize_bytes</a>(snapshot_proofs, offset);
    <b>let</b> (account_state_proof_leaf, offset) = <a href="BCS.md#0x1_BCS_deserialize_bytes_vector">BCS::deserialize_bytes_vector</a>(snapshot_proofs, offset);
    <b>let</b> (account_state_proof_siblings, offset) = <a href="BCS.md#0x1_BCS_deserialize_bytes_vector">BCS::deserialize_bytes_vector</a>(snapshot_proofs, offset);
    <b>let</b> (state, offset) = <a href="BCS.md#0x1_BCS_deserialize_bytes">BCS::deserialize_bytes</a>(snapshot_proofs, offset);
    <b>let</b> (resource_struct_tag, _offset) = <a href="BCS.md#0x1_BCS_deserialize_bytes">BCS::deserialize_bytes</a>(snapshot_proofs, offset);

    <a href="GenesisDao.md#0x1_GenesisDao_SnapshotProof">SnapshotProof</a> {
        account_proof_leaf,
        account_proof_siblings,
        account_state,
        account_state_proof_leaf,
        account_state_proof_siblings,
        state,
        resource_struct_tag,
    }
}
</code></pre>



</details>

<a name="0x1_GenesisDao_new_state_proof_from_proofs"></a>

## Function `new_state_proof_from_proofs`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_new_state_proof_from_proofs">new_state_proof_from_proofs</a>(snpashot_proofs: &<a href="GenesisDao.md#0x1_GenesisDao_SnapshotProof">GenesisDao::SnapshotProof</a>): <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_StateProof">StarcoinVerifier::StateProof</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_new_state_proof_from_proofs">new_state_proof_from_proofs</a>(snpashot_proofs: &<a href="GenesisDao.md#0x1_GenesisDao_SnapshotProof">SnapshotProof</a>): StateProof{
    <b>let</b> (account_proof_leaf_hash1, account_proof_leaf_hash2) = (<a href="Vector.md#0x1_Vector_empty">Vector::empty</a>(), <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>());
    <b>let</b> (account_state_proof_leaf_hash1, account_state_proof_leaf_hash2) = (<a href="Vector.md#0x1_Vector_empty">Vector::empty</a>(), <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>());

    <b>if</b> (<a href="Vector.md#0x1_Vector_length">Vector::length</a>(&snpashot_proofs.account_proof_leaf) &gt;= 2){
        account_proof_leaf_hash1 = *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&snpashot_proofs.account_proof_leaf, 0);
        account_proof_leaf_hash2 = *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&snpashot_proofs.account_proof_leaf, 1);
    };
    <b>if</b> (<a href="Vector.md#0x1_Vector_length">Vector::length</a>(&snpashot_proofs.account_state_proof_leaf) &gt;= 2){
        account_state_proof_leaf_hash1 = *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&snpashot_proofs.account_state_proof_leaf, 0);
        account_state_proof_leaf_hash2 = *<a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&snpashot_proofs.account_state_proof_leaf, 1);
    };
    <b>let</b> state_proof = <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_state_proof">StarcoinVerifier::new_state_proof</a>(
        <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_sparse_merkle_proof">StarcoinVerifier::new_sparse_merkle_proof</a>(
            *&snpashot_proofs.account_proof_siblings,
            <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_smt_node">StarcoinVerifier::new_smt_node</a>(
                account_proof_leaf_hash1,
                account_proof_leaf_hash2,
            ),
        ),
        *&snpashot_proofs.account_state,
        <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_sparse_merkle_proof">StarcoinVerifier::new_sparse_merkle_proof</a>(
            *&snpashot_proofs.account_state_proof_siblings,
            <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_smt_node">StarcoinVerifier::new_smt_node</a>(
                account_state_proof_leaf_hash1,
                account_state_proof_leaf_hash2,
            ),
        ),
    );
    state_proof
}
</code></pre>



</details>

<a name="0x1_GenesisDao_execute_proposal"></a>

## Function `execute_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_execute_proposal">execute_proposal</a>&lt;DaoT: store, PluginT, ActionT: store&gt;(_cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoProposalCap">GenesisDao::DaoProposalCap</a>&lt;DaoT, PluginT&gt;, _sender: &signer, proposal_id: u64): ActionT
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_execute_proposal">execute_proposal</a>&lt;DaoT: store, PluginT, ActionT: store&gt;(
    _cap: &<a href="GenesisDao.md#0x1_GenesisDao_DaoProposalCap">DaoProposalCap</a>&lt;DaoT, PluginT&gt;,
    _sender: &signer,
    proposal_id: u64,
): ActionT <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_ProposalActions">ProposalActions</a>, <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>, <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposalActions">GlobalProposalActions</a> {
    // Only executable proposal's action can be extracted.
     <b>assert</b>!(<a href="GenesisDao.md#0x1_GenesisDao_proposal_state">proposal_state</a>&lt;DaoT&gt;(proposal_id) == <a href="GenesisDao.md#0x1_GenesisDao_EXECUTABLE">EXECUTABLE</a>, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSAL_STATE_INVALID">ERR_PROPOSAL_STATE_INVALID</a>));
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();
    <b>assert</b>!(<b>exists</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_ProposalActions">ProposalActions</a>&lt;ActionT&gt;&gt;(dao_address), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSAL_ACTIONS_NOT_EXIST">ERR_PROPOSAL_ACTIONS_NOT_EXIST</a>));

    <a href="GenesisDao.md#0x1_GenesisDao_take_proposal_action">take_proposal_action</a>(dao_address, proposal_id)

    //TODO add event
}
</code></pre>



</details>

<a name="0x1_GenesisDao_take_proposal_action"></a>

## Function `take_proposal_action`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_take_proposal_action">take_proposal_action</a>&lt;ActionT: store&gt;(dao_address: <b>address</b>, proposal_id: u64): ActionT
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_take_proposal_action">take_proposal_action</a>&lt;ActionT: store&gt;(dao_address: <b>address</b>, proposal_id: u64): ActionT <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_ProposalActions">ProposalActions</a>, <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>, <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposalActions">GlobalProposalActions</a> {
    <b>let</b> actions = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_ProposalActions">ProposalActions</a>&lt;ActionT&gt;&gt;(dao_address);
    <b>let</b> index_opt = <a href="GenesisDao.md#0x1_GenesisDao_find_action">find_action</a>(&actions.actions, proposal_id);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&index_opt), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_ACTION_INDEX_INVALID">ERR_ACTION_INDEX_INVALID</a>));

    <b>let</b> global_proposals = <b>borrow_global</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>&gt;(dao_address);
    <b>let</b> proposal = <a href="GenesisDao.md#0x1_GenesisDao_borrow_proposal">borrow_proposal</a>(global_proposals, proposal_id);

    <b>let</b> index = <a href="Option.md#0x1_Option_extract">Option::extract</a>(&<b>mut</b> index_opt);
    <b>let</b> <a href="GenesisDao.md#0x1_GenesisDao_ProposalAction">ProposalAction</a>{ proposal_id:_, deposit, action} = <a href="Vector.md#0x1_Vector_remove">Vector::remove</a>(&<b>mut</b> actions.actions, index);

    // remove proposal action index
    <b>let</b> global_proposal_actions = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposalActions">GlobalProposalActions</a>&gt;(dao_address);
    <b>let</b> proposal_action_index_opt = <a href="GenesisDao.md#0x1_GenesisDao_find_proposal_action_index">find_proposal_action_index</a>(global_proposal_actions, proposal_id);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&proposal_action_index_opt), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSAL_ACTION_INDEX_NOT_EXIST">ERR_PROPOSAL_ACTION_INDEX_NOT_EXIST</a>));
    <b>let</b> propopsal_action_index = <a href="Option.md#0x1_Option_extract">Option::extract</a>(&<b>mut</b> proposal_action_index_opt);
    <b>let</b> <a href="GenesisDao.md#0x1_GenesisDao_ProposalActionIndex">ProposalActionIndex</a>{ proposal_id:_,} = <a href="Vector.md#0x1_Vector_remove">Vector::remove</a>(&<b>mut</b> global_proposal_actions.proposal_action_indexs, propopsal_action_index);

    //TODO check the proposal state and do deposit or burn.
    <a href="Account.md#0x1_Account_deposit">Account::deposit</a>(proposal.proposer, deposit);
    action
}
</code></pre>



</details>

<a name="0x1_GenesisDao_find_action"></a>

## Function `find_action`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_find_action">find_action</a>&lt;ActionT: store&gt;(actions: &vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_ProposalAction">GenesisDao::ProposalAction</a>&lt;ActionT&gt;&gt;, proposal_id: u64): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_find_action">find_action</a>&lt;ActionT: store&gt;(actions: &vector&lt;<a href="GenesisDao.md#0x1_GenesisDao_ProposalAction">ProposalAction</a>&lt;ActionT&gt;&gt;, proposal_id: u64): <a href="Option.md#0x1_Option">Option</a>&lt;u64&gt;{
    <b>let</b> i = 0;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(actions);
    <b>while</b>(i &lt; len){
        <b>let</b> action = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(actions, i);
        <b>if</b>(action.proposal_id == proposal_id){
            <b>return</b> <a href="Option.md#0x1_Option_some">Option::some</a>(i)
        };
        i = i + 1;
    };
    <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u64&gt;()
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
    <b>if</b> (<a href="GenesisDao.md#0x1_GenesisDao_choice_yes">choice_yes</a>().choice == vote.choice) {
        proposal.yes_votes = proposal.yes_votes + vote.vote_weight;
    } <b>else</b> <b>if</b> (<a href="GenesisDao.md#0x1_GenesisDao_choice_no">choice_no</a>().choice == vote.choice) {
        proposal.no_votes = proposal.no_votes + vote.vote_weight;
    } <b>else</b> <b>if</b> ( <a href="GenesisDao.md#0x1_GenesisDao_choice_no_with_veto">choice_no_with_veto</a>().choice == vote.choice) {
        proposal.no_with_veto_votes = proposal.no_with_veto_votes + vote.vote_weight;
    } <b>else</b> <b>if</b> (<a href="GenesisDao.md#0x1_GenesisDao_choice_abstain">choice_abstain</a>().choice == vote.choice) {
        proposal.abstain_votes = proposal.abstain_votes + vote.vote_weight;
    } <b>else</b> {
        <b>abort</b> <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_VOTE_PARAM_INVALID">ERR_VOTE_PARAM_INVALID</a>)
    };
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
        <b>let</b> vote = <a href="GenesisDao.md#0x1_GenesisDao_get_vote_info">get_vote_info</a>&lt;DaoT&gt;(my_votes, proposal_id);
        <a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&vote)
    }<b>else</b>{
        <b>false</b>
    }
}
</code></pre>



</details>

<a name="0x1_GenesisDao_get_vote_info"></a>

## Function `get_vote_info`

get vote info by proposal_id


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_get_vote_info">get_vote_info</a>&lt;DaoT&gt;(my_votes: &<a href="GenesisDao.md#0x1_GenesisDao_MyVotes">GenesisDao::MyVotes</a>&lt;DaoT&gt;, proposal_id: u64): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_VoteInfo">GenesisDao::VoteInfo</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_get_vote_info">get_vote_info</a>&lt;DaoT&gt;(my_votes: &<a href="GenesisDao.md#0x1_GenesisDao_MyVotes">MyVotes</a>&lt;DaoT&gt;, proposal_id: u64): <a href="Option.md#0x1_Option">Option</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_VoteInfo">VoteInfo</a>&gt;{
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&my_votes.votes);
    <b>let</b> idx = 0;
    <b>loop</b> {
        <b>if</b> (idx &gt;= len) {
            <b>break</b>
        };
        <b>let</b> vote = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&my_votes.votes, idx);
        <b>if</b> (proposal_id == vote.proposal_id) {
            <b>let</b> vote_info = <a href="GenesisDao.md#0x1_GenesisDao_VoteInfo">VoteInfo</a> {
                proposal_id: vote.proposal_id,
                vote_weight: vote.vote_weight,
                choice: vote.choice,
            };
            <b>return</b> <a href="Option.md#0x1_Option_some">Option::some</a>(vote_info)
        };
        idx = idx + 1;
    };
    <a href="Option.md#0x1_Option_none">Option::none</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_VoteInfo">VoteInfo</a>&gt;()
}
</code></pre>



</details>

<a name="0x1_GenesisDao_proposal_state"></a>

## Function `proposal_state`



<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_proposal_state">proposal_state</a>&lt;DaoT: store&gt;(proposal_id: u64): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_proposal_state">proposal_state</a>&lt;DaoT: store&gt;(proposal_id: u64) : u8 <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposalActions">GlobalProposalActions</a>, <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a> {
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();
    <b>let</b> proposals = <b>borrow_global</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>&gt;(dao_address);
    <b>let</b> proposal = <a href="GenesisDao.md#0x1_GenesisDao_borrow_proposal">borrow_proposal</a>(proposals, proposal_id);

    <a href="GenesisDao.md#0x1_GenesisDao_proposal_state_with_proposal">proposal_state_with_proposal</a>&lt;DaoT&gt;(proposal)
}
</code></pre>



</details>

<a name="0x1_GenesisDao_proposal_state_with_proposal"></a>

## Function `proposal_state_with_proposal`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_proposal_state_with_proposal">proposal_state_with_proposal</a>&lt;DaoT: store&gt;(proposal: &<a href="GenesisDao.md#0x1_GenesisDao_Proposal">GenesisDao::Proposal</a>): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_proposal_state_with_proposal">proposal_state_with_proposal</a>&lt;DaoT: store&gt;(proposal: &<a href="GenesisDao.md#0x1_GenesisDao_Proposal">Proposal</a>) : u8 <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposalActions">GlobalProposalActions</a> {
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();
    <b>let</b> current_time = <a href="Timestamp.md#0x1_Timestamp_now_milliseconds">Timestamp::now_milliseconds</a>();

    <b>let</b> global_proposal_actions = <b>borrow_global</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposalActions">GlobalProposalActions</a>&gt;(dao_address);
    <b>let</b> action_index_opt = <a href="GenesisDao.md#0x1_GenesisDao_find_proposal_action_index">find_proposal_action_index</a>(global_proposal_actions, proposal.id);

    <a href="GenesisDao.md#0x1_GenesisDao_do_proposal_state">do_proposal_state</a>(proposal, current_time, action_index_opt)
}
</code></pre>



</details>

<a name="0x1_GenesisDao_do_proposal_state"></a>

## Function `do_proposal_state`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_do_proposal_state">do_proposal_state</a>(proposal: &<a href="GenesisDao.md#0x1_GenesisDao_Proposal">GenesisDao::Proposal</a>, current_time: u64, action_index_opt: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_do_proposal_state">do_proposal_state</a>(proposal: &<a href="GenesisDao.md#0x1_GenesisDao_Proposal">Proposal</a>, current_time: u64, action_index_opt: <a href="Option.md#0x1_Option">Option</a>&lt;u64&gt; ): u8 {
    <b>if</b> (current_time &lt; proposal.start_time) {
        // Pending
        <a href="GenesisDao.md#0x1_GenesisDao_PENDING">PENDING</a>
    } <b>else</b> <b>if</b> (current_time &lt;= proposal.end_time) {
        // Active
        <a href="GenesisDao.md#0x1_GenesisDao_ACTIVE">ACTIVE</a>
        //TODO need restrict yes votes ratio <b>with</b> (no/no_with_veto/abstain) ?
    } <b>else</b> <b>if</b> (proposal.yes_votes &lt;= (proposal.no_votes + proposal.no_with_veto_votes + proposal.abstain_votes) ||
               proposal.yes_votes &lt; proposal.quorum_votes) {
        // Defeated
        <a href="GenesisDao.md#0x1_GenesisDao_DEFEATED">DEFEATED</a>
    } <b>else</b> <b>if</b> (proposal.eta == 0) {
        // Agreed.
        <a href="GenesisDao.md#0x1_GenesisDao_AGREED">AGREED</a>
    } <b>else</b> <b>if</b> (current_time &lt; proposal.eta) {
        // Queued, waiting <b>to</b> execute
        <a href="GenesisDao.md#0x1_GenesisDao_QUEUED">QUEUED</a>
    } <b>else</b> <b>if</b> (<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&action_index_opt)) {
        <a href="GenesisDao.md#0x1_GenesisDao_EXECUTABLE">EXECUTABLE</a>
    } <b>else</b> {
        <a href="GenesisDao.md#0x1_GenesisDao_EXTRACTED">EXTRACTED</a>
    }
}
</code></pre>



</details>

<a name="0x1_GenesisDao_proposal_info"></a>

## Function `proposal_info`

get proposal's information.
return: (id, proposer, start_time, end_time, yes_votes, no_votes, no_with_veto_votes, abstain_votes, block_number, state_root).


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_proposal_info">proposal_info</a>&lt;DaoT: <b>copy</b>, drop, store&gt;(proposal_id: u64): (u64, <b>address</b>, u64, u64, u128, u128, u128, u128, u64, vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_proposal_info">proposal_info</a>&lt;DaoT: <b>copy</b> + drop + store&gt;(
    proposal_id: u64,
): (u64, <b>address</b>, u64, u64, u128, u128, u128, u128, u64, vector&lt;u8&gt;) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a> {
    <b>let</b> dao_address = <a href="DaoRegistry.md#0x1_DaoRegistry_dao_address">DaoRegistry::dao_address</a>&lt;DaoT&gt;();
    <b>let</b> proposals = <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>&gt;(dao_address);
    <b>let</b> proposal = <a href="GenesisDao.md#0x1_GenesisDao_borrow_proposal">borrow_proposal</a>(proposals, proposal_id);
    (proposal.id, proposal.proposer, proposal.start_time, proposal.end_time, proposal.yes_votes, proposal.no_votes, proposal.no_with_veto_votes, proposal.abstain_votes, proposal.block_number, *&proposal.state_root)
}
</code></pre>



</details>

<a name="0x1_GenesisDao_borrow_proposal_mut"></a>

## Function `borrow_proposal_mut`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_borrow_proposal_mut">borrow_proposal_mut</a>(proposals: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GenesisDao::GlobalProposals</a>, proposal_id: u64): &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_Proposal">GenesisDao::Proposal</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_borrow_proposal_mut">borrow_proposal_mut</a>(proposals: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>, proposal_id: u64): &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_Proposal">Proposal</a>{
    <b>let</b> i = 0;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&proposals.proposals);
    <b>while</b>(i &lt; len){
        <b>let</b> proposal = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&proposals.proposals, i);
        <b>if</b>(proposal.id == proposal_id){
            <b>return</b> <a href="Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> proposals.proposals, i)
        };
        i = i + 1;
    };
    <b>abort</b> <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSAL_NOT_EXIST">ERR_PROPOSAL_NOT_EXIST</a>)
}
</code></pre>



</details>

<a name="0x1_GenesisDao_borrow_proposal"></a>

## Function `borrow_proposal`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_borrow_proposal">borrow_proposal</a>(proposals: &<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GenesisDao::GlobalProposals</a>, proposal_id: u64): &<a href="GenesisDao.md#0x1_GenesisDao_Proposal">GenesisDao::Proposal</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_borrow_proposal">borrow_proposal</a>(proposals: &<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>, proposal_id: u64): &<a href="GenesisDao.md#0x1_GenesisDao_Proposal">Proposal</a> {
    <b>let</b> i = 0;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&proposals.proposals);
    <b>while</b>(i &lt; len){
        <b>let</b> proposal = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&proposals.proposals, i);
        <b>if</b>(proposal.id == proposal_id){
            <b>return</b> proposal
        };
        i = i + 1;
    };
    <b>abort</b> <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_PROPOSAL_NOT_EXIST">ERR_PROPOSAL_NOT_EXIST</a>)
}
</code></pre>



</details>

<a name="0x1_GenesisDao_find_proposal_action_index"></a>

## Function `find_proposal_action_index`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_find_proposal_action_index">find_proposal_action_index</a>(global_proposal_action: &<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposalActions">GenesisDao::GlobalProposalActions</a>, proposal_id: u64): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_find_proposal_action_index">find_proposal_action_index</a>(global_proposal_action: &<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposalActions">GlobalProposalActions</a>, proposal_id: u64): <a href="Option.md#0x1_Option">Option</a>&lt;u64&gt; {
    <b>let</b> i = 0;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&global_proposal_action.proposal_action_indexs);
    <b>while</b>(i &lt; len){
        <b>let</b> proposal_action_index = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&global_proposal_action.proposal_action_indexs, i);
        <b>if</b>(proposal_action_index.proposal_id == proposal_id){
            <b>return</b> <a href="Option.md#0x1_Option_some">Option::some</a>(i)
        };
        i = i + 1;
    };
    <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u64&gt;()
}
</code></pre>



</details>

<a name="0x1_GenesisDao_proposal"></a>

## Function `proposal`

Return a copy of Proposal


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_proposal">proposal</a>&lt;DaoT&gt;(proposal_id: u64): <a href="GenesisDao.md#0x1_GenesisDao_Proposal">GenesisDao::Proposal</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_proposal">proposal</a>&lt;DaoT&gt;(proposal_id: u64): <a href="GenesisDao.md#0x1_GenesisDao_Proposal">Proposal</a> <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>{
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();
    <b>let</b> global_proposals = <b>borrow_global</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_GlobalProposals">GlobalProposals</a>&gt;(dao_address);
    *<a href="GenesisDao.md#0x1_GenesisDao_borrow_proposal">borrow_proposal</a>(global_proposals, proposal_id)
}
</code></pre>



</details>

<a name="0x1_GenesisDao_new_dao_config"></a>

## Function `new_dao_config`

DaoConfig
---------------------------------------------------
create a dao config


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_new_dao_config">new_dao_config</a>(voting_delay: u64, voting_period: u64, voting_quorum_rate: u8, min_action_delay: u64, min_proposal_deposit: u128): <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">GenesisDao::DaoConfig</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_new_dao_config">new_dao_config</a>(
    voting_delay: u64,
    voting_period: u64,
    voting_quorum_rate: u8,
    min_action_delay: u64,
    min_proposal_deposit: u128,
): <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">DaoConfig</a>{
    <b>assert</b>!(voting_delay &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>));
    <b>assert</b>!(voting_period &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>));
    <b>assert</b>!(
        voting_quorum_rate &gt; 0 && <a href="GenesisDao.md#0x1_GenesisDao_voting_quorum_rate">voting_quorum_rate</a> &lt;= 100,
        <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>),
    );
    <b>assert</b>!(min_action_delay &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>));
    <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">DaoConfig</a> { voting_delay, voting_period, voting_quorum_rate, min_action_delay, min_proposal_deposit }
}
</code></pre>



</details>

<a name="0x1_GenesisDao_set_custom_config"></a>

## Function `set_custom_config`

Update, save function of custom plugin configuration


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_set_custom_config">set_custom_config</a>&lt;DaoT: store, PluginT: drop, ConfigT: <b>copy</b>, drop, store&gt;(_cap: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoModifyConfigCap">GenesisDao::DaoModifyConfigCap</a>&lt;DaoT, PluginT&gt;, config: ConfigT)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_set_custom_config">set_custom_config</a>&lt;DaoT: store,
                             PluginT: drop,
                             ConfigT: <b>copy</b> + store + drop&gt;(
    _cap: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoModifyConfigCap">DaoModifyConfigCap</a>&lt;DaoT, PluginT&gt;,
    config: ConfigT)
<b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoCustomConfigModifyCapHolder">DaoCustomConfigModifyCapHolder</a>, <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a> {
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();
    <b>if</b> (<a href="Config.md#0x1_Config_config_exist_by_address">Config::config_exist_by_address</a>&lt;ConfigT&gt;(dao_address)) {
        <b>let</b> modify_config_cap =
            &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoCustomConfigModifyCapHolder">DaoCustomConfigModifyCapHolder</a>&lt;DaoT, ConfigT&gt;&gt;(dao_address).cap;
        <a href="Config.md#0x1_Config_set_with_capability">Config::set_with_capability</a>(modify_config_cap, config);
    } <b>else</b> {
        <b>let</b> signer = <a href="GenesisDao.md#0x1_GenesisDao_dao_signer">dao_signer</a>&lt;DaoT&gt;();
        <a href="Config.md#0x1_Config_publish_new_config">Config::publish_new_config</a>&lt;ConfigT&gt;(&signer, config);
    }
}
</code></pre>



</details>

<a name="0x1_GenesisDao_voting_delay"></a>

## Function `voting_delay`

get default voting delay of the DAO.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_voting_delay">voting_delay</a>&lt;DaoT: store&gt;(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_voting_delay">voting_delay</a>&lt;DaoT: store&gt;(): u64 {
    <a href="GenesisDao.md#0x1_GenesisDao_get_config">get_config</a>&lt;DaoT&gt;().voting_delay
}
</code></pre>



</details>

<a name="0x1_GenesisDao_voting_period"></a>

## Function `voting_period`

get the default voting period of the DAO.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_voting_period">voting_period</a>&lt;DaoT: store&gt;(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_voting_period">voting_period</a>&lt;DaoT: store&gt;(): u64 {
    <a href="GenesisDao.md#0x1_GenesisDao_get_config">get_config</a>&lt;DaoT&gt;().voting_period
}
</code></pre>



</details>

<a name="0x1_GenesisDao_quorum_votes"></a>

## Function `quorum_votes`

Quorum votes to make proposal pass.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_quorum_votes">quorum_votes</a>&lt;DaoT: store&gt;(): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_quorum_votes">quorum_votes</a>&lt;DaoT: store&gt;(): u128 {
    <b>let</b> market_cap = <a href="Token.md#0x1_Token_market_cap">Token::market_cap</a>&lt;DaoT&gt;();
    <b>let</b> rate = <a href="GenesisDao.md#0x1_GenesisDao_voting_quorum_rate">voting_quorum_rate</a>&lt;DaoT&gt;();
    <b>let</b> rate = (rate <b>as</b> u128);
    market_cap * rate / 100
}
</code></pre>



</details>

<a name="0x1_GenesisDao_voting_quorum_rate"></a>

## Function `voting_quorum_rate`

Get the quorum rate in percent.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_voting_quorum_rate">voting_quorum_rate</a>&lt;DaoT: store&gt;(): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_voting_quorum_rate">voting_quorum_rate</a>&lt;DaoT: store&gt;(): u8 {
    <a href="GenesisDao.md#0x1_GenesisDao_get_config">get_config</a>&lt;DaoT&gt;().voting_quorum_rate
}
</code></pre>



</details>

<a name="0x1_GenesisDao_min_action_delay"></a>

## Function `min_action_delay`

Get the min action delay of the DAO.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_min_action_delay">min_action_delay</a>&lt;DaoT: store&gt;(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_min_action_delay">min_action_delay</a>&lt;DaoT: store&gt;(): u64 {
    <a href="GenesisDao.md#0x1_GenesisDao_get_config">get_config</a>&lt;DaoT&gt;().min_action_delay
}
</code></pre>



</details>

<a name="0x1_GenesisDao_min_proposal_deposit"></a>

## Function `min_proposal_deposit`

Get the min proposal deposit of the DAO.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_min_proposal_deposit">min_proposal_deposit</a>&lt;DaoT: store&gt;(): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_min_proposal_deposit">min_proposal_deposit</a>&lt;DaoT: store&gt;(): u128{
    <a href="GenesisDao.md#0x1_GenesisDao_get_config">get_config</a>&lt;DaoT&gt;().min_proposal_deposit
}
</code></pre>



</details>

<a name="0x1_GenesisDao_get_config"></a>

## Function `get_config`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_get_config">get_config</a>&lt;DaoT: store&gt;(): <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">GenesisDao::DaoConfig</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_get_config">get_config</a>&lt;DaoT: store&gt;(): <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">DaoConfig</a> {
    <b>let</b> dao_address= <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();
    <a href="Config.md#0x1_Config_get_by_address">Config::get_by_address</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">DaoConfig</a>&gt;(dao_address)
}
</code></pre>



</details>

<a name="0x1_GenesisDao_modify_dao_config"></a>

## Function `modify_dao_config`

Update function, modify dao config.


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_modify_dao_config">modify_dao_config</a>&lt;DaoT: store, PluginT&gt;(_cap: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoModifyConfigCap">GenesisDao::DaoModifyConfigCap</a>&lt;DaoT, PluginT&gt;, new_config: <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">GenesisDao::DaoConfig</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_modify_dao_config">modify_dao_config</a>&lt;DaoT: store, PluginT&gt;(
    _cap: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoModifyConfigCap">DaoModifyConfigCap</a>&lt;DaoT, PluginT&gt;,
    new_config: <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">DaoConfig</a>,
) <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoConfigModifyCapHolder">DaoConfigModifyCapHolder</a> {
    <b>let</b> modify_config_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoConfigModifyCapHolder">DaoConfigModifyCapHolder</a>&gt;(
        <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;(),
    ).cap;
    //<b>assert</b>!(<a href="Config.md#0x1_Config_account_address">Config::account_address</a>(cap) == <a href="Token.md#0x1_Token_token_address">Token::token_address</a>&lt;TokenT&gt;(), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_NOT_AUTHORIZED">ERR_NOT_AUTHORIZED</a>));
    <a href="Config.md#0x1_Config_set_with_capability">Config::set_with_capability</a>&lt;<a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">DaoConfig</a>&gt;(modify_config_cap, new_config);
}
</code></pre>



</details>

<a name="0x1_GenesisDao_set_voting_delay"></a>

## Function `set_voting_delay`

set voting delay


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_set_voting_delay">set_voting_delay</a>(config: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">GenesisDao::DaoConfig</a>, value: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_set_voting_delay">set_voting_delay</a>(
    config: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">DaoConfig</a>,
    value: u64,
) {
    <b>assert</b>!(value &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>));
    config.voting_delay = value;
}
</code></pre>



</details>

<a name="0x1_GenesisDao_set_voting_period"></a>

## Function `set_voting_period`

set voting period


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_set_voting_period">set_voting_period</a>&lt;DaoT: store&gt;(config: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">GenesisDao::DaoConfig</a>, value: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_set_voting_period">set_voting_period</a>&lt;DaoT: store&gt;(
    config: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">DaoConfig</a>,
    value: u64,
) {
    <b>assert</b>!(value &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>));
    config.voting_period = value;
}
</code></pre>



</details>

<a name="0x1_GenesisDao_set_voting_quorum_rate"></a>

## Function `set_voting_quorum_rate`

set voting quorum rate


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_set_voting_quorum_rate">set_voting_quorum_rate</a>&lt;DaoT: store&gt;(config: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">GenesisDao::DaoConfig</a>, value: u8)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_set_voting_quorum_rate">set_voting_quorum_rate</a>&lt;DaoT: store&gt;(
    config: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">DaoConfig</a>,
    value: u8,
) {
    <b>assert</b>!(value &lt;= 100 && value &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_QUORUM_RATE_INVALID">ERR_QUORUM_RATE_INVALID</a>));
    config.voting_quorum_rate = value;
}
</code></pre>



</details>

<a name="0x1_GenesisDao_set_min_action_delay"></a>

## Function `set_min_action_delay`

set min action delay


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_set_min_action_delay">set_min_action_delay</a>&lt;DaoT: store&gt;(config: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">GenesisDao::DaoConfig</a>, value: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_set_min_action_delay">set_min_action_delay</a>&lt;DaoT: store&gt;(
    config: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">DaoConfig</a>,
    value: u64,
) {
    <b>assert</b>!(value &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>));
    config.min_action_delay = value;
}
</code></pre>



</details>

<a name="0x1_GenesisDao_set_min_proposal_deposit"></a>

## Function `set_min_proposal_deposit`

set min action delay


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_set_min_proposal_deposit">set_min_proposal_deposit</a>&lt;DaoT: store&gt;(config: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">GenesisDao::DaoConfig</a>, value: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_set_min_proposal_deposit">set_min_proposal_deposit</a>&lt;DaoT: store&gt;(
    config: &<b>mut</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoConfig">DaoConfig</a>,
    value: u128,
) {
    config.min_proposal_deposit = value;
}
</code></pre>



</details>

<a name="0x1_GenesisDao_next_member_id"></a>

## Function `next_member_id`

Helpers
---------------------------------------------------


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_next_member_id">next_member_id</a>&lt;DaoT&gt;(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_next_member_id">next_member_id</a>&lt;DaoT&gt;(): u64 <b>acquires</b> <a href="Dao.md#0x1_Dao">Dao</a> {
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();
    <b>let</b> dao = <b>borrow_global_mut</b>&lt;<a href="Dao.md#0x1_Dao">Dao</a>&gt;(dao_address);
    <b>let</b> member_id = dao.next_member_id;
    dao.next_member_id = member_id + 1;
    member_id
}
</code></pre>



</details>

<a name="0x1_GenesisDao_next_proposal_id"></a>

## Function `next_proposal_id`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_next_proposal_id">next_proposal_id</a>&lt;DaoT&gt;(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_next_proposal_id">next_proposal_id</a>&lt;DaoT&gt;(): u64 <b>acquires</b> <a href="Dao.md#0x1_Dao">Dao</a> {
    <b>let</b> dao_address = <a href="GenesisDao.md#0x1_GenesisDao_dao_address">dao_address</a>&lt;DaoT&gt;();
    <b>let</b> dao = <b>borrow_global_mut</b>&lt;<a href="Dao.md#0x1_Dao">Dao</a>&gt;(dao_address);
    <b>let</b> proposal_id = dao.next_proposal_id;
    dao.next_proposal_id = proposal_id + 1;
    proposal_id
}
</code></pre>



</details>

<a name="0x1_GenesisDao_assert_no_repeat"></a>

## Function `assert_no_repeat`



<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_assert_no_repeat">assert_no_repeat</a>&lt;E&gt;(v: &vector&lt;E&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_assert_no_repeat">assert_no_repeat</a>&lt;E&gt;(v: &vector&lt;E&gt;) {
    <b>let</b> i = 1;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(v);
    <b>while</b> (i &lt; len) {
        <b>let</b> e = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(v, i);
        <b>let</b> j = 0;
        <b>while</b> (j &lt; i) {
            <b>let</b> f = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(v, j);
            <b>assert</b>!(e != f, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="GenesisDao.md#0x1_GenesisDao_ERR_REPEAT_ELEMENT">ERR_REPEAT_ELEMENT</a>));
            j = j + 1;
        };
        i = i + 1;
    };
}
</code></pre>



</details>

<a name="0x1_GenesisDao_remove_element"></a>

## Function `remove_element`

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


<pre><code><b>fun</b> <a href="GenesisDao.md#0x1_GenesisDao_dao_signer">dao_signer</a>&lt;DaoT&gt;(): signer <b>acquires</b> <a href="GenesisDao.md#0x1_GenesisDao_DaoAccountCapHolder">DaoAccountCapHolder</a> {
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
