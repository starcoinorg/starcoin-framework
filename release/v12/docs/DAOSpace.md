
<a name="0x1_DAOSpace"></a>

# Module `0x1::DAOSpace`



-  [Resource `DAO`](#0x1_DAOSpace_DAO)
-  [Struct `DAOConfig`](#0x1_DAOSpace_DAOConfig)
-  [Struct `DAOCustomConfig`](#0x1_DAOSpace_DAOCustomConfig)
-  [Resource `DAOAccountCapHolder`](#0x1_DAOSpace_DAOAccountCapHolder)
-  [Resource `DAOSBTMintCapHolder`](#0x1_DAOSpace_DAOSBTMintCapHolder)
-  [Resource `DAOSBTBurnCapHolder`](#0x1_DAOSpace_DAOSBTBurnCapHolder)
-  [Resource `DAOTokenMintCapHolder`](#0x1_DAOSpace_DAOTokenMintCapHolder)
-  [Resource `DAOTokenBurnCapHolder`](#0x1_DAOSpace_DAOTokenBurnCapHolder)
-  [Resource `DAONFTMintCapHolder`](#0x1_DAOSpace_DAONFTMintCapHolder)
-  [Resource `DAONFTBurnCapHolder`](#0x1_DAOSpace_DAONFTBurnCapHolder)
-  [Resource `DAONFTUpdateCapHolder`](#0x1_DAOSpace_DAONFTUpdateCapHolder)
-  [Resource `DAOConfigModifyCapHolder`](#0x1_DAOSpace_DAOConfigModifyCapHolder)
-  [Resource `DAOCustomConfigModifyCapHolder`](#0x1_DAOSpace_DAOCustomConfigModifyCapHolder)
-  [Struct `CapType`](#0x1_DAOSpace_CapType)
-  [Struct `DAOInstallPluginCap`](#0x1_DAOSpace_DAOInstallPluginCap)
-  [Struct `DAOUpgradeModuleCap`](#0x1_DAOSpace_DAOUpgradeModuleCap)
-  [Struct `DAOModifyConfigCap`](#0x1_DAOSpace_DAOModifyConfigCap)
-  [Struct `DAOWithdrawTokenCap`](#0x1_DAOSpace_DAOWithdrawTokenCap)
-  [Struct `DAOWithdrawNFTCap`](#0x1_DAOSpace_DAOWithdrawNFTCap)
-  [Struct `DAOStorageCap`](#0x1_DAOSpace_DAOStorageCap)
-  [Struct `DAOMemberCap`](#0x1_DAOSpace_DAOMemberCap)
-  [Struct `DAOProposalCap`](#0x1_DAOSpace_DAOProposalCap)
-  [Struct `DAOGrantCap`](#0x1_DAOSpace_DAOGrantCap)
-  [Struct `DAOPluginEventCap`](#0x1_DAOSpace_DAOPluginEventCap)
-  [Resource `DAOGrantWithdrawTokenKey`](#0x1_DAOSpace_DAOGrantWithdrawTokenKey)
-  [Resource `InstalledPluginInfo`](#0x1_DAOSpace_InstalledPluginInfo)
-  [Struct `DAOMember`](#0x1_DAOSpace_DAOMember)
-  [Struct `DAOMemberBody`](#0x1_DAOSpace_DAOMemberBody)
-  [Resource `DAOEvent`](#0x1_DAOSpace_DAOEvent)
-  [Struct `DAOCreatedEvent`](#0x1_DAOSpace_DAOCreatedEvent)
-  [Resource `MemberEvent`](#0x1_DAOSpace_MemberEvent)
-  [Struct `MemberOfferEvent`](#0x1_DAOSpace_MemberOfferEvent)
-  [Struct `MemberJoinEvent`](#0x1_DAOSpace_MemberJoinEvent)
-  [Struct `MemberRevokeEvent`](#0x1_DAOSpace_MemberRevokeEvent)
-  [Struct `MemberQuitEvent`](#0x1_DAOSpace_MemberQuitEvent)
-  [Struct `MemberIncreaseSBTEvent`](#0x1_DAOSpace_MemberIncreaseSBTEvent)
-  [Struct `MemberDecreaseSBTEvent`](#0x1_DAOSpace_MemberDecreaseSBTEvent)
-  [Resource `StorageItem`](#0x1_DAOSpace_StorageItem)
-  [Struct `MemeberOffer`](#0x1_DAOSpace_MemeberOffer)
-  [Resource `PluginEvent`](#0x1_DAOSpace_PluginEvent)
-  [Resource `GrantEvent`](#0x1_DAOSpace_GrantEvent)
-  [Struct `GrantCreateEvent`](#0x1_DAOSpace_GrantCreateEvent)
-  [Struct `GrantRevokeEvent`](#0x1_DAOSpace_GrantRevokeEvent)
-  [Struct `GrantRefundEvent`](#0x1_DAOSpace_GrantRefundEvent)
-  [Struct `GrantConfigEvent`](#0x1_DAOSpace_GrantConfigEvent)
-  [Struct `GrantWithdrawEvent`](#0x1_DAOSpace_GrantWithdrawEvent)
-  [Struct `GrantInfo`](#0x1_DAOSpace_GrantInfo)
-  [Struct `ProposalState`](#0x1_DAOSpace_ProposalState)
-  [Struct `VotingChoice`](#0x1_DAOSpace_VotingChoice)
-  [Struct `Proposal`](#0x1_DAOSpace_Proposal)
-  [Struct `ProposalAction`](#0x1_DAOSpace_ProposalAction)
-  [Struct `ProposalActionIndex`](#0x1_DAOSpace_ProposalActionIndex)
-  [Resource `GlobalProposals`](#0x1_DAOSpace_GlobalProposals)
-  [Resource `ProposalActions`](#0x1_DAOSpace_ProposalActions)
-  [Resource `GlobalProposalActions`](#0x1_DAOSpace_GlobalProposalActions)
-  [Struct `Vote`](#0x1_DAOSpace_Vote)
-  [Struct `VoteInfo`](#0x1_DAOSpace_VoteInfo)
-  [Resource `MyVotes`](#0x1_DAOSpace_MyVotes)
-  [Struct `SnapshotProof`](#0x1_DAOSpace_SnapshotProof)
-  [Struct `HashNode`](#0x1_DAOSpace_HashNode)
-  [Resource `ProposalEvent`](#0x1_DAOSpace_ProposalEvent)
-  [Struct `ProposalCreatedEvent`](#0x1_DAOSpace_ProposalCreatedEvent)
-  [Struct `VotedEvent`](#0x1_DAOSpace_VotedEvent)
-  [Struct `ProposalActionEvent`](#0x1_DAOSpace_ProposalActionEvent)
-  [Constants](#@Constants_0)
-  [Function `install_plugin_cap_type`](#0x1_DAOSpace_install_plugin_cap_type)
-  [Function `upgrade_module_cap_type`](#0x1_DAOSpace_upgrade_module_cap_type)
-  [Function `modify_config_cap_type`](#0x1_DAOSpace_modify_config_cap_type)
-  [Function `withdraw_token_cap_type`](#0x1_DAOSpace_withdraw_token_cap_type)
-  [Function `withdraw_nft_cap_type`](#0x1_DAOSpace_withdraw_nft_cap_type)
-  [Function `storage_cap_type`](#0x1_DAOSpace_storage_cap_type)
-  [Function `member_cap_type`](#0x1_DAOSpace_member_cap_type)
-  [Function `proposal_cap_type`](#0x1_DAOSpace_proposal_cap_type)
-  [Function `grant_cap_type`](#0x1_DAOSpace_grant_cap_type)
-  [Function `token_mint_cap_type`](#0x1_DAOSpace_token_mint_cap_type)
-  [Function `token_burn_cap_type`](#0x1_DAOSpace_token_burn_cap_type)
-  [Function `plugin_event_cap_type`](#0x1_DAOSpace_plugin_event_cap_type)
-  [Function `all_caps`](#0x1_DAOSpace_all_caps)
-  [Function `create_dao`](#0x1_DAOSpace_create_dao)
-  [Function `upgrade_to_dao`](#0x1_DAOSpace_upgrade_to_dao)
-  [Function `install_plugin`](#0x1_DAOSpace_install_plugin)
-  [Function `do_install_plugin`](#0x1_DAOSpace_do_install_plugin)
-  [Function `uninstall_plugin`](#0x1_DAOSpace_uninstall_plugin)
-  [Function `do_uninstall_plugin`](#0x1_DAOSpace_do_uninstall_plugin)
-  [Function `submit_upgrade_plan`](#0x1_DAOSpace_submit_upgrade_plan)
-  [Function `save_to_storage`](#0x1_DAOSpace_save_to_storage)
-  [Function `take_from_storage`](#0x1_DAOSpace_take_from_storage)
-  [Function `exists_in_storage`](#0x1_DAOSpace_exists_in_storage)
-  [Function `copy_from_storage`](#0x1_DAOSpace_copy_from_storage)
-  [Function `withdraw_token`](#0x1_DAOSpace_withdraw_token)
-  [Function `withdraw_nft`](#0x1_DAOSpace_withdraw_nft)
-  [Function `issue_member_offer`](#0x1_DAOSpace_issue_member_offer)
-  [Function `revoke_member_offer`](#0x1_DAOSpace_revoke_member_offer)
-  [Function `accept_member_offer`](#0x1_DAOSpace_accept_member_offer)
-  [Function `accept_member_offer_entry`](#0x1_DAOSpace_accept_member_offer_entry)
-  [Function `do_join_member`](#0x1_DAOSpace_do_join_member)
-  [Function `quit_member_entry`](#0x1_DAOSpace_quit_member_entry)
-  [Function `quit_member`](#0x1_DAOSpace_quit_member)
-  [Function `revoke_member`](#0x1_DAOSpace_revoke_member)
-  [Function `ensure_member`](#0x1_DAOSpace_ensure_member)
-  [Function `ensure_not_member`](#0x1_DAOSpace_ensure_not_member)
-  [Function `do_remove_member`](#0x1_DAOSpace_do_remove_member)
-  [Function `join_member_with_member_cap`](#0x1_DAOSpace_join_member_with_member_cap)
-  [Function `increase_member_sbt`](#0x1_DAOSpace_increase_member_sbt)
-  [Function `decrease_member_sbt`](#0x1_DAOSpace_decrease_member_sbt)
-  [Function `set_member_image`](#0x1_DAOSpace_set_member_image)
-  [Function `query_sbt`](#0x1_DAOSpace_query_sbt)
-  [Function `query_member_id`](#0x1_DAOSpace_query_member_id)
-  [Function `is_member`](#0x1_DAOSpace_is_member)
-  [Function `is_exist_member_offer`](#0x1_DAOSpace_is_exist_member_offer)
-  [Function `init_plugin_event`](#0x1_DAOSpace_init_plugin_event)
-  [Function `emit_plugin_event`](#0x1_DAOSpace_emit_plugin_event)
-  [Function `grant_accept_offer`](#0x1_DAOSpace_grant_accept_offer)
-  [Function `grant_accept_offer_entry`](#0x1_DAOSpace_grant_accept_offer_entry)
-  [Function `grant_offer`](#0x1_DAOSpace_grant_offer)
-  [Function `grant_offer_refund`](#0x1_DAOSpace_grant_offer_refund)
-  [Function `grant_offer_refund_entry`](#0x1_DAOSpace_grant_offer_refund_entry)
-  [Function `grant_withdraw_entry`](#0x1_DAOSpace_grant_withdraw_entry)
-  [Function `grant_withdraw`](#0x1_DAOSpace_grant_withdraw)
-  [Function `query_grant_withdrawable_amount`](#0x1_DAOSpace_query_grant_withdrawable_amount)
-  [Function `is_exist_grant`](#0x1_DAOSpace_is_exist_grant)
-  [Function `grant_revoke`](#0x1_DAOSpace_grant_revoke)
-  [Function `grant_offer_revoke`](#0x1_DAOSpace_grant_offer_revoke)
-  [Function `refund_grant`](#0x1_DAOSpace_refund_grant)
-  [Function `refund_grant_entry`](#0x1_DAOSpace_refund_grant_entry)
-  [Function `query_grant`](#0x1_DAOSpace_query_grant)
-  [Function `query_grant_info_total`](#0x1_DAOSpace_query_grant_info_total)
-  [Function `query_grant_info_withdraw`](#0x1_DAOSpace_query_grant_info_withdraw)
-  [Function `query_grant_info_start_time`](#0x1_DAOSpace_query_grant_info_start_time)
-  [Function `query_grant_info_period`](#0x1_DAOSpace_query_grant_info_period)
-  [Function `validate_cap`](#0x1_DAOSpace_validate_cap)
-  [Function `acquire_install_plugin_cap`](#0x1_DAOSpace_acquire_install_plugin_cap)
-  [Function `acquire_upgrade_module_cap`](#0x1_DAOSpace_acquire_upgrade_module_cap)
-  [Function `acquire_modify_config_cap`](#0x1_DAOSpace_acquire_modify_config_cap)
-  [Function `acquire_withdraw_token_cap`](#0x1_DAOSpace_acquire_withdraw_token_cap)
-  [Function `acquire_withdraw_nft_cap`](#0x1_DAOSpace_acquire_withdraw_nft_cap)
-  [Function `acquire_storage_cap`](#0x1_DAOSpace_acquire_storage_cap)
-  [Function `acquire_member_cap`](#0x1_DAOSpace_acquire_member_cap)
-  [Function `acquire_proposal_cap`](#0x1_DAOSpace_acquire_proposal_cap)
-  [Function `acquire_grant_cap`](#0x1_DAOSpace_acquire_grant_cap)
-  [Function `acquire_plugin_event_cap`](#0x1_DAOSpace_acquire_plugin_event_cap)
-  [Function `delegate_token_mint_cap`](#0x1_DAOSpace_delegate_token_mint_cap)
-  [Function `delegate_token_burn_cap`](#0x1_DAOSpace_delegate_token_burn_cap)
-  [Function `mint_token`](#0x1_DAOSpace_mint_token)
-  [Function `burn_token`](#0x1_DAOSpace_burn_token)
-  [Function `choice_yes`](#0x1_DAOSpace_choice_yes)
-  [Function `choice_no`](#0x1_DAOSpace_choice_no)
-  [Function `choice_no_with_veto`](#0x1_DAOSpace_choice_no_with_veto)
-  [Function `choice_abstain`](#0x1_DAOSpace_choice_abstain)
-  [Function `create_proposal`](#0x1_DAOSpace_create_proposal)
-  [Function `block_number_and_state_root`](#0x1_DAOSpace_block_number_and_state_root)
-  [Function `cast_vote`](#0x1_DAOSpace_cast_vote)
-  [Function `deserialize_snapshot_proofs`](#0x1_DAOSpace_deserialize_snapshot_proofs)
-  [Function `new_state_proof_from_proofs`](#0x1_DAOSpace_new_state_proof_from_proofs)
-  [Function `execute_proposal`](#0x1_DAOSpace_execute_proposal)
-  [Function `clean_proposals`](#0x1_DAOSpace_clean_proposals)
-  [Function `clean_proposals_entry`](#0x1_DAOSpace_clean_proposals_entry)
-  [Function `clean_proposal_by_id`](#0x1_DAOSpace_clean_proposal_by_id)
-  [Function `clean_proposal_by_id_entry`](#0x1_DAOSpace_clean_proposal_by_id_entry)
-  [Function `take_proposal_action`](#0x1_DAOSpace_take_proposal_action)
-  [Function `remove_proposal`](#0x1_DAOSpace_remove_proposal)
-  [Function `find_action`](#0x1_DAOSpace_find_action)
-  [Function `do_cast_vote`](#0x1_DAOSpace_do_cast_vote)
-  [Function `has_voted`](#0x1_DAOSpace_has_voted)
-  [Function `vote_info`](#0x1_DAOSpace_vote_info)
-  [Function `reject_proposal`](#0x1_DAOSpace_reject_proposal)
-  [Function `reject_proposal_entry`](#0x1_DAOSpace_reject_proposal_entry)
-  [Function `get_vote_info`](#0x1_DAOSpace_get_vote_info)
-  [Function `proposal_state`](#0x1_DAOSpace_proposal_state)
-  [Function `proposal_state_with_proposal`](#0x1_DAOSpace_proposal_state_with_proposal)
-  [Function `do_proposal_state`](#0x1_DAOSpace_do_proposal_state)
-  [Function `borrow_proposal_mut`](#0x1_DAOSpace_borrow_proposal_mut)
-  [Function `borrow_proposal`](#0x1_DAOSpace_borrow_proposal)
-  [Function `find_proposal_action_index`](#0x1_DAOSpace_find_proposal_action_index)
-  [Function `proposal`](#0x1_DAOSpace_proposal)
-  [Function `proposal_id`](#0x1_DAOSpace_proposal_id)
-  [Function `proposal_proposer`](#0x1_DAOSpace_proposal_proposer)
-  [Function `proposal_time`](#0x1_DAOSpace_proposal_time)
-  [Function `proposal_votes`](#0x1_DAOSpace_proposal_votes)
-  [Function `proposal_block_number`](#0x1_DAOSpace_proposal_block_number)
-  [Function `proposal_state_root`](#0x1_DAOSpace_proposal_state_root)
-  [Function `queue_proposal_action_entry`](#0x1_DAOSpace_queue_proposal_action_entry)
-  [Function `queue_proposal_action`](#0x1_DAOSpace_queue_proposal_action)
-  [Function `cast_vote_entry`](#0x1_DAOSpace_cast_vote_entry)
-  [Function `new_dao_config`](#0x1_DAOSpace_new_dao_config)
-  [Function `get_custom_config`](#0x1_DAOSpace_get_custom_config)
-  [Function `exists_custom_config`](#0x1_DAOSpace_exists_custom_config)
-  [Function `set_custom_config`](#0x1_DAOSpace_set_custom_config)
-  [Function `set_custom_config_cap`](#0x1_DAOSpace_set_custom_config_cap)
-  [Function `set_dao_description`](#0x1_DAOSpace_set_dao_description)
-  [Function `set_dao_image`](#0x1_DAOSpace_set_dao_image)
-  [Function `voting_delay`](#0x1_DAOSpace_voting_delay)
-  [Function `voting_period`](#0x1_DAOSpace_voting_period)
-  [Function `quorum_votes`](#0x1_DAOSpace_quorum_votes)
-  [Function `voting_quorum_rate`](#0x1_DAOSpace_voting_quorum_rate)
-  [Function `min_action_delay`](#0x1_DAOSpace_min_action_delay)
-  [Function `min_proposal_deposit`](#0x1_DAOSpace_min_proposal_deposit)
-  [Function `get_config`](#0x1_DAOSpace_get_config)
-  [Function `modify_dao_config`](#0x1_DAOSpace_modify_dao_config)
-  [Function `set_voting_delay`](#0x1_DAOSpace_set_voting_delay)
-  [Function `set_voting_period`](#0x1_DAOSpace_set_voting_period)
-  [Function `set_voting_quorum_rate`](#0x1_DAOSpace_set_voting_quorum_rate)
-  [Function `set_min_action_delay`](#0x1_DAOSpace_set_min_action_delay)
-  [Function `set_min_proposal_deposit`](#0x1_DAOSpace_set_min_proposal_deposit)
-  [Function `next_member_id`](#0x1_DAOSpace_next_member_id)
-  [Function `next_proposal_id`](#0x1_DAOSpace_next_proposal_id)
-  [Function `assert_no_repeat`](#0x1_DAOSpace_assert_no_repeat)
-  [Function `remove_element`](#0x1_DAOSpace_remove_element)
-  [Function `add_element`](#0x1_DAOSpace_add_element)
-  [Function `convert_option_bytes_vector`](#0x1_DAOSpace_convert_option_bytes_vector)
-  [Function `dao_signer`](#0x1_DAOSpace_dao_signer)
-  [Function `dao_address`](#0x1_DAOSpace_dao_address)
-  [Function `dao_id`](#0x1_DAOSpace_dao_id)


<pre><code><b>use</b> <a href="ASCII.md#0x1_ASCII">0x1::ASCII</a>;
<b>use</b> <a href="Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="BCS.md#0x1_BCS">0x1::BCS</a>;
<b>use</b> <a href="Block.md#0x1_Block">0x1::Block</a>;
<b>use</b> <a href="Config.md#0x1_Config">0x1::Config</a>;
<b>use</b> <a href="DAOAccount.md#0x1_DAOAccount">0x1::DAOAccount</a>;
<b>use</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace">0x1::DAOPluginMarketplace</a>;
<b>use</b> <a href="DAORegistry.md#0x1_DAORegistry">0x1::DAORegistry</a>;
<b>use</b> <a href="Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="Event.md#0x1_Event">0x1::Event</a>;
<b>use</b> <a href="EventUtil.md#0x1_EventUtil">0x1::EventUtil</a>;
<b>use</b> <a href="NFT.md#0x1_IdentifierNFT">0x1::IdentifierNFT</a>;
<b>use</b> <a href="Math.md#0x1_Math">0x1::Math</a>;
<b>use</b> <a href="NFT.md#0x1_NFT">0x1::NFT</a>;
<b>use</b> <a href="NFT.md#0x1_NFTGallery">0x1::NFTGallery</a>;
<b>use</b> <a href="Offer.md#0x1_Offer">0x1::Offer</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="SBTVoteStrategy.md#0x1_SBTVoteStrategy">0x1::SBTVoteStrategy</a>;
<b>use</b> <a href="STC.md#0x1_STC">0x1::STC</a>;
<b>use</b> <a href="Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="SnapshotUtil.md#0x1_SnapshotUtil">0x1::SnapshotUtil</a>;
<b>use</b> <a href="StarcoinVerifier.md#0x1_StarcoinVerifier">0x1::StarcoinVerifier</a>;
<b>use</b> <a href="Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
<b>use</b> <a href="Token.md#0x1_Token">0x1::Token</a>;
<b>use</b> <a href="TypeInfo.md#0x1_TypeInfo">0x1::TypeInfo</a>;
<b>use</b> <a href="Vector.md#0x1_Vector">0x1::Vector</a>;
</code></pre>



<a name="0x1_DAOSpace_DAO"></a>

## Resource `DAO`

DAO resource, every DAO has this resource at it's DAO account


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> <b>has</b> key
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
<code>description: vector&lt;u8&gt;</code>
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

<a name="0x1_DAOSpace_DAOConfig"></a>

## Struct `DAOConfig`

Configuration of the DAO.


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOConfig</a> <b>has</b> <b>copy</b>, drop, store
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

<a name="0x1_DAOSpace_DAOCustomConfig"></a>

## Struct `DAOCustomConfig`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOCustomConfig">DAOCustomConfig</a>&lt;ConfigT&gt; <b>has</b> <b>copy</b>, drop, store
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

<a name="0x1_DAOSpace_DAOAccountCapHolder"></a>

## Resource `DAOAccountCapHolder`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccount::DAOAccountCap</a></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_DAOSBTMintCapHolder"></a>

## Resource `DAOSBTMintCapHolder`

Capability for minting SBT.


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOSBTMintCapHolder">DAOSBTMintCapHolder</a>&lt;DAOT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="Token.md#0x1_Token_MintCapability">Token::MintCapability</a>&lt;DAOT&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_DAOSBTBurnCapHolder"></a>

## Resource `DAOSBTBurnCapHolder`

Capability for burning SBT.


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOSBTBurnCapHolder">DAOSBTBurnCapHolder</a>&lt;DAOT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="Token.md#0x1_Token_BurnCapability">Token::BurnCapability</a>&lt;DAOT&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_DAOTokenMintCapHolder"></a>

## Resource `DAOTokenMintCapHolder`

Capability for minting any tokens.


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOTokenMintCapHolder">DAOTokenMintCapHolder</a>&lt;DAOT, TokenT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="Token.md#0x1_Token_MintCapability">Token::MintCapability</a>&lt;TokenT&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_DAOTokenBurnCapHolder"></a>

## Resource `DAOTokenBurnCapHolder`

Capability for burning any tokens.


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOTokenBurnCapHolder">DAOTokenBurnCapHolder</a>&lt;DAOT, TokenT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="Token.md#0x1_Token_BurnCapability">Token::BurnCapability</a>&lt;TokenT&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_DAONFTMintCapHolder"></a>

## Resource `DAONFTMintCapHolder`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTMintCapHolder">DAONFTMintCapHolder</a>&lt;DAOT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="NFT.md#0x1_NFT_MintCapability">NFT::MintCapability</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOSpace::DAOMember</a>&lt;DAOT&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_DAONFTBurnCapHolder"></a>

## Resource `DAONFTBurnCapHolder`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTBurnCapHolder">DAONFTBurnCapHolder</a>&lt;DAOT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="NFT.md#0x1_NFT_BurnCapability">NFT::BurnCapability</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOSpace::DAOMember</a>&lt;DAOT&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_DAONFTUpdateCapHolder"></a>

## Resource `DAONFTUpdateCapHolder`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTUpdateCapHolder">DAONFTUpdateCapHolder</a>&lt;DAOT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="NFT.md#0x1_NFT_UpdateCapability">NFT::UpdateCapability</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOSpace::DAOMember</a>&lt;DAOT&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_DAOConfigModifyCapHolder"></a>

## Resource `DAOConfigModifyCapHolder`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOConfigModifyCapHolder">DAOConfigModifyCapHolder</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>cap: <a href="Config.md#0x1_Config_ModifyConfigCapability">Config::ModifyConfigCapability</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOSpace::DAOConfig</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_DAOCustomConfigModifyCapHolder"></a>

## Resource `DAOCustomConfigModifyCapHolder`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOCustomConfigModifyCapHolder">DAOCustomConfigModifyCapHolder</a>&lt;DAOT, ConfigT: <b>copy</b>, drop, store&gt; <b>has</b> key
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

<a name="0x1_DAOSpace_CapType"></a>

## Struct `CapType`

A type describing a capability.


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a> <b>has</b> <b>copy</b>, drop, store
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

<a name="0x1_DAOSpace_DAOInstallPluginCap"></a>

## Struct `DAOInstallPluginCap`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOInstallPluginCap">DAOInstallPluginCap</a>&lt;DAOT, PluginT&gt; <b>has</b> drop
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

<a name="0x1_DAOSpace_DAOUpgradeModuleCap"></a>

## Struct `DAOUpgradeModuleCap`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOUpgradeModuleCap">DAOUpgradeModuleCap</a>&lt;DAOT, PluginT&gt; <b>has</b> drop
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

<a name="0x1_DAOSpace_DAOModifyConfigCap"></a>

## Struct `DAOModifyConfigCap`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOModifyConfigCap">DAOModifyConfigCap</a>&lt;DAOT, PluginT&gt; <b>has</b> drop
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

<a name="0x1_DAOSpace_DAOWithdrawTokenCap"></a>

## Struct `DAOWithdrawTokenCap`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOWithdrawTokenCap">DAOWithdrawTokenCap</a>&lt;DAOT, PluginT&gt; <b>has</b> drop
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

<a name="0x1_DAOSpace_DAOWithdrawNFTCap"></a>

## Struct `DAOWithdrawNFTCap`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOWithdrawNFTCap">DAOWithdrawNFTCap</a>&lt;DAOT, PluginT&gt; <b>has</b> drop
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

<a name="0x1_DAOSpace_DAOStorageCap"></a>

## Struct `DAOStorageCap`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOStorageCap">DAOStorageCap</a>&lt;DAOT, PluginT&gt; <b>has</b> drop
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

<a name="0x1_DAOSpace_DAOMemberCap"></a>

## Struct `DAOMemberCap`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOMemberCap</a>&lt;DAOT, PluginT&gt; <b>has</b> drop
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

<a name="0x1_DAOSpace_DAOProposalCap"></a>

## Struct `DAOProposalCap`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOProposalCap">DAOProposalCap</a>&lt;DAOT, PluginT&gt; <b>has</b> drop
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

<a name="0x1_DAOSpace_DAOGrantCap"></a>

## Struct `DAOGrantCap`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantCap">DAOGrantCap</a>&lt;DAOT&gt; <b>has</b> drop
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

<a name="0x1_DAOSpace_DAOPluginEventCap"></a>

## Struct `DAOPluginEventCap`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOPluginEventCap">DAOPluginEventCap</a>&lt;DAOT, PluginT&gt; <b>has</b> drop
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

<a name="0x1_DAOSpace_DAOGrantWithdrawTokenKey"></a>

## Resource `DAOGrantWithdrawTokenKey`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, PluginT, TokenT&gt; <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>total: u128</code>
</dt>
<dd>
 The total amount of tokens that can be withdrawn by this capability
</dd>
<dt>
<code>withdraw: u128</code>
</dt>
<dd>
 The amount of tokens that have been withdrawn by this capability
</dd>
<dt>
<code>start_time: u64</code>
</dt>
<dd>
 The time-based linear release start time, timestamp in seconds.
</dd>
<dt>
<code>period: u64</code>
</dt>
<dd>
  The time-based linear release period in seconds
</dd>
</dl>


</details>

<a name="0x1_DAOSpace_InstalledPluginInfo"></a>

## Resource `InstalledPluginInfo`

The info for DAO installed Plugin


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a>&lt;PluginT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>plugin_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>granted_caps: vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_DAOMember"></a>

## Struct `DAOMember`

The DAO member NFT metadata


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt; <b>has</b> <b>copy</b>, drop, store
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

<a name="0x1_DAOSpace_DAOMemberBody"></a>

## Struct `DAOMemberBody`

The DAO member NFT Body, hold the SBT token


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt; <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>sbt: <a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;DAOT&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_DAOEvent"></a>

## Resource `DAOEvent`

dao event


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOEvent">DAOEvent</a>&lt;DAOT&gt; <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_create_event: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOCreatedEvent">DAOSpace::DAOCreatedEvent</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_DAOCreatedEvent"></a>

## Struct `DAOCreatedEvent`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOCreatedEvent">DAOCreatedEvent</a> <b>has</b> drop, store
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
<code>description: vector&lt;u8&gt;</code>
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

<a name="0x1_DAOSpace_MemberEvent"></a>

## Resource `MemberEvent`

member event


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a> <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>member_offer_event_handler: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberOfferEvent">DAOSpace::MemberOfferEvent</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>member_join_event_handler: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberJoinEvent">DAOSpace::MemberJoinEvent</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>member_quit_event_handler: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberQuitEvent">DAOSpace::MemberQuitEvent</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>member_revoke_event_handler: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberRevokeEvent">DAOSpace::MemberRevokeEvent</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>member_increase_sbt_event_handler: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberIncreaseSBTEvent">DAOSpace::MemberIncreaseSBTEvent</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>member_decrease_sbt_event_handler: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberDecreaseSBTEvent">DAOSpace::MemberDecreaseSBTEvent</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_MemberOfferEvent"></a>

## Struct `MemberOfferEvent`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_MemberOfferEvent">MemberOfferEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>
 dao id
</dd>
<dt>
<code>type: u8</code>
</dt>
<dd>

</dd>
<dt>
<code>addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>image_data: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>image_url: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;</code>
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

<a name="0x1_DAOSpace_MemberJoinEvent"></a>

## Struct `MemberJoinEvent`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_MemberJoinEvent">MemberJoinEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>
 dao id
</dd>
<dt>
<code>type: u8</code>
</dt>
<dd>

</dd>
<dt>
<code>member_id: u64</code>
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

<a name="0x1_DAOSpace_MemberRevokeEvent"></a>

## Struct `MemberRevokeEvent`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_MemberRevokeEvent">MemberRevokeEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>
 dao id
</dd>
<dt>
<code>member_id: u64</code>
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

<a name="0x1_DAOSpace_MemberQuitEvent"></a>

## Struct `MemberQuitEvent`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_MemberQuitEvent">MemberQuitEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>
 dao id
</dd>
<dt>
<code>member_id: u64</code>
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

<a name="0x1_DAOSpace_MemberIncreaseSBTEvent"></a>

## Struct `MemberIncreaseSBTEvent`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_MemberIncreaseSBTEvent">MemberIncreaseSBTEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>member_id: u64</code>
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

<a name="0x1_DAOSpace_MemberDecreaseSBTEvent"></a>

## Struct `MemberDecreaseSBTEvent`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_MemberDecreaseSBTEvent">MemberDecreaseSBTEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>member_id: u64</code>
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

<a name="0x1_DAOSpace_StorageItem"></a>

## Resource `StorageItem`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_StorageItem">StorageItem</a>&lt;PluginT, V: store&gt; <b>has</b> key
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

<a name="0x1_DAOSpace_MemeberOffer"></a>

## Struct `MemeberOffer`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_MemeberOffer">MemeberOffer</a>&lt;DAOT&gt; <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>to_address: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>image_data: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>image_url: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>init_sbt: u128</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_PluginEvent"></a>

## Resource `PluginEvent`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_PluginEvent">PluginEvent</a>&lt;DAOT: store, PluginT: store, EventT: drop, store&gt; <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>event_handle: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;EventT&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_GrantEvent"></a>

## Resource `GrantEvent`

Grant Event


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a> <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>create_grant_event_handler: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GrantCreateEvent">DAOSpace::GrantCreateEvent</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>revoke_grant_event_handler: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GrantRevokeEvent">DAOSpace::GrantRevokeEvent</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>withdraw_grant_event_handler: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GrantWithdrawEvent">DAOSpace::GrantWithdrawEvent</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>refund_grant_event_handler: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GrantRefundEvent">DAOSpace::GrantRefundEvent</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_GrantCreateEvent"></a>

## Struct `GrantCreateEvent`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_GrantCreateEvent">GrantCreateEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>grantee: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>total: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>start_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>period: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>now_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>plugin: <a href="TypeInfo.md#0x1_TypeInfo_TypeInfo">TypeInfo::TypeInfo</a></code>
</dt>
<dd>

</dd>
<dt>
<code>token: <a href="Token.md#0x1_Token_TokenCode">Token::TokenCode</a></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_GrantRevokeEvent"></a>

## Struct `GrantRevokeEvent`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_GrantRevokeEvent">GrantRevokeEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>grantee: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>total: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>withdraw: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>start_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>period: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>plugin: <a href="TypeInfo.md#0x1_TypeInfo_TypeInfo">TypeInfo::TypeInfo</a></code>
</dt>
<dd>

</dd>
<dt>
<code>token: <a href="Token.md#0x1_Token_TokenCode">Token::TokenCode</a></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_GrantRefundEvent"></a>

## Struct `GrantRefundEvent`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_GrantRefundEvent">GrantRefundEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>grantee: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>total: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>withdraw: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>start_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>period: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>plugin: <a href="TypeInfo.md#0x1_TypeInfo_TypeInfo">TypeInfo::TypeInfo</a></code>
</dt>
<dd>

</dd>
<dt>
<code>token: <a href="Token.md#0x1_Token_TokenCode">Token::TokenCode</a></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_GrantConfigEvent"></a>

## Struct `GrantConfigEvent`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_GrantConfigEvent">GrantConfigEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>old_grantee: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>new_grantee: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>total: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>withdraw: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>start_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>period: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>plugin: <a href="TypeInfo.md#0x1_TypeInfo_TypeInfo">TypeInfo::TypeInfo</a></code>
</dt>
<dd>

</dd>
<dt>
<code>token: <a href="Token.md#0x1_Token_TokenCode">Token::TokenCode</a></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_GrantWithdrawEvent"></a>

## Struct `GrantWithdrawEvent`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_GrantWithdrawEvent">GrantWithdrawEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>grantee: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>total: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>withdraw: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>start_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>period: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>withdraw_value: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>plugin: <a href="TypeInfo.md#0x1_TypeInfo_TypeInfo">TypeInfo::TypeInfo</a></code>
</dt>
<dd>

</dd>
<dt>
<code>token: <a href="Token.md#0x1_Token_TokenCode">Token::TokenCode</a></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_GrantInfo"></a>

## Struct `GrantInfo`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_GrantInfo">GrantInfo</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>total: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>grantee: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>withdraw: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>start_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>period: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_ProposalState"></a>

## Struct `ProposalState`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_ProposalState">ProposalState</a> <b>has</b> <b>copy</b>, drop, store
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

<a name="0x1_DAOSpace_VotingChoice"></a>

## Struct `VotingChoice`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">VotingChoice</a> <b>has</b> <b>copy</b>, drop, store
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

<a name="0x1_DAOSpace_Proposal"></a>

## Struct `Proposal`

Proposal data struct.
review: it is safe to has <code><b>copy</b></code> and <code>drop</code>?


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_Proposal">Proposal</a> <b>has</b> <b>copy</b>, drop, store
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
<code>title: vector&lt;u8&gt;</code>
</dt>
<dd>
 title of proposal
</dd>
<dt>
<code>introduction: vector&lt;u8&gt;</code>
</dt>
<dd>
 introduction of proposal , short introduction
</dd>
<dt>
<code>extend: vector&lt;u8&gt;</code>
</dt>
<dd>
 extend of proposal , ipfs:// | { "title":"xxxxx",........ }
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
 count of voters who <code>yes|no|abstain</code> with the proposal
</dd>
<dt>
<code>no_votes: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>abstain_votes: u128</code>
</dt>
<dd>

</dd>
<dt>
<code>no_with_veto_votes: u128</code>
</dt>
<dd>
 no_with_veto counts as no but also adds a veto vote
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
 how many votes to reach to make the proposal valid.
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

<a name="0x1_DAOSpace_ProposalAction"></a>

## Struct `ProposalAction`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_ProposalAction">ProposalAction</a>&lt;Action: store&gt; <b>has</b> store
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

<a name="0x1_DAOSpace_ProposalActionIndex"></a>

## Struct `ProposalActionIndex`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_ProposalActionIndex">ProposalActionIndex</a> <b>has</b> drop, store
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

<a name="0x1_DAOSpace_GlobalProposals"></a>

## Resource `GlobalProposals`

Keep a global proposal record for query proposal by id.
Replace with Table when support Table.


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>proposals: vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_Proposal">DAOSpace::Proposal</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_ProposalActions"></a>

## Resource `ProposalActions`

Every ActionT keep a vector in the DAO account


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_ProposalActions">ProposalActions</a>&lt;ActionT: drop, store&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>actions: vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalAction">DAOSpace::ProposalAction</a>&lt;ActionT&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_GlobalProposalActions"></a>

## Resource `GlobalProposalActions`

Keep a global proposal action record for query action by proposal_id.
Replace with Table when support Table.


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>proposal_action_indexs: vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalActionIndex">DAOSpace::ProposalActionIndex</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_Vote"></a>

## Struct `Vote`

User vote.


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_Vote">Vote</a> <b>has</b> store
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

<a name="0x1_DAOSpace_VoteInfo"></a>

## Struct `VoteInfo`

User vote info. has drop cap


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_VoteInfo">VoteInfo</a> <b>has</b> drop, store
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

<a name="0x1_DAOSpace_MyVotes"></a>

## Resource `MyVotes`

Every voter keep a vector Vote for per DAO


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_MyVotes">MyVotes</a>&lt;DAOT&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>votes: vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_Vote">DAOSpace::Vote</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_SnapshotProof"></a>

## Struct `SnapshotProof`

use bcs se/de for Snapshot proofs


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_SnapshotProof">SnapshotProof</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>state: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>account_state: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>account_proof_leaf: <a href="DAOSpace.md#0x1_DAOSpace_HashNode">DAOSpace::HashNode</a></code>
</dt>
<dd>

</dd>
<dt>
<code>account_proof_siblings: vector&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>account_state_proof_leaf: <a href="DAOSpace.md#0x1_DAOSpace_HashNode">DAOSpace::HashNode</a></code>
</dt>
<dd>

</dd>
<dt>
<code>account_state_proof_siblings: vector&lt;vector&lt;u8&gt;&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_HashNode"></a>

## Struct `HashNode`



<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_HashNode">HashNode</a> <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>hash1: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>hash2: vector&lt;u8&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_DAOSpace_ProposalEvent"></a>

## Resource `ProposalEvent`

proposal event


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_ProposalEvent">ProposalEvent</a>&lt;DAOT: store&gt; <b>has</b> store, key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>proposal_create_event: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalCreatedEvent">DAOSpace::ProposalCreatedEvent</a>&gt;</code>
</dt>
<dd>
 proposal creating event.
</dd>
<dt>
<code>vote_event: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_VotedEvent">DAOSpace::VotedEvent</a>&gt;</code>
</dt>
<dd>
 voting event.
</dd>
<dt>
<code>proposal_action_event: <a href="Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalActionEvent">DAOSpace::ProposalActionEvent</a>&gt;</code>
</dt>
<dd>
 proposal action event.
</dd>
</dl>


</details>

<a name="0x1_DAOSpace_ProposalCreatedEvent"></a>

## Struct `ProposalCreatedEvent`

emitted when proposal created.


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_ProposalCreatedEvent">ProposalCreatedEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>
 dao id
</dd>
<dt>
<code>title: vector&lt;u8&gt;</code>
</dt>
<dd>
 title
</dd>
<dt>
<code>proposal_id: u64</code>
</dt>
<dd>
 the proposal id.
</dd>
<dt>
<code>introduction: vector&lt;u8&gt;</code>
</dt>
<dd>
 introduction of proposal , short introduction
</dd>
<dt>
<code>extend: vector&lt;u8&gt;</code>
</dt>
<dd>
 extend of proposal , ipfs:// | { "title":"xxxxx",........ }
</dd>
<dt>
<code>proposer: <b>address</b></code>
</dt>
<dd>
 proposer is the user who create the proposal.
</dd>
</dl>


</details>

<a name="0x1_DAOSpace_VotedEvent"></a>

## Struct `VotedEvent`

emitted when user vote/revoke_vote.


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_VotedEvent">VotedEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>
 dao id
</dd>
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

<a name="0x1_DAOSpace_ProposalActionEvent"></a>

## Struct `ProposalActionEvent`

emitted when proposal executed.


<pre><code><b>struct</b> <a href="DAOSpace.md#0x1_DAOSpace_ProposalActionEvent">ProposalActionEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dao_id: u64</code>
</dt>
<dd>
 dao id
</dd>
<dt>
<code>proposal_id: u64</code>
</dt>
<dd>
 the proposal id.
</dd>
<dt>
<code>sender: <b>address</b></code>
</dt>
<dd>
 the sender.
</dd>
<dt>
<code>state: u8</code>
</dt>
<dd>
 proposal state after the action: EXTRACTED or REJECTED
</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_DAOSpace_ACTIVE"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ACTIVE">ACTIVE</a>: u8 = 2;
</code></pre>



<a name="0x1_DAOSpace_AGREED"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_AGREED">AGREED</a>: u8 = 5;
</code></pre>



<a name="0x1_DAOSpace_DEFEATED"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_DEFEATED">DEFEATED</a>: u8 = 4;
</code></pre>



<a name="0x1_DAOSpace_ERR_ACTION_DELAY_TOO_SMALL"></a>

config or arguments


<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_ACTION_DELAY_TOO_SMALL">ERR_ACTION_DELAY_TOO_SMALL</a>: u64 = 300;
</code></pre>



<a name="0x1_DAOSpace_ERR_ACTION_INDEX_INVALID"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_ACTION_INDEX_INVALID">ERR_ACTION_INDEX_INVALID</a>: u64 = 501;
</code></pre>



<a name="0x1_DAOSpace_ERR_ACTION_MUST_EXIST"></a>

action


<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_ACTION_MUST_EXIST">ERR_ACTION_MUST_EXIST</a>: u64 = 500;
</code></pre>



<a name="0x1_DAOSpace_ERR_ALREADY_INIT"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_ALREADY_INIT">ERR_ALREADY_INIT</a>: u64 = 104;
</code></pre>



<a name="0x1_DAOSpace_ERR_CONFIG_PARAM_INVALID"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>: u64 = 301;
</code></pre>



<a name="0x1_DAOSpace_ERR_DAO_EXT"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_DAO_EXT">ERR_DAO_EXT</a>: u64 = 106;
</code></pre>



<a name="0x1_DAOSpace_ERR_EXPECT_MEMBER"></a>

member


<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_EXPECT_MEMBER">ERR_EXPECT_MEMBER</a>: u64 = 200;
</code></pre>



<a name="0x1_DAOSpace_ERR_EXPECT_NOT_MEMBER"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_EXPECT_NOT_MEMBER">ERR_EXPECT_NOT_MEMBER</a>: u64 = 201;
</code></pre>



<a name="0x1_DAOSpace_ERR_HAVE_SAME_GRANT"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_HAVE_SAME_GRANT">ERR_HAVE_SAME_GRANT</a>: u64 = 304;
</code></pre>



<a name="0x1_DAOSpace_ERR_INVALID_AMOUNT"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_INVALID_AMOUNT">ERR_INVALID_AMOUNT</a>: u64 = 302;
</code></pre>



<a name="0x1_DAOSpace_ERR_NFT_ERROR"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_NFT_ERROR">ERR_NFT_ERROR</a>: u64 = 103;
</code></pre>



<a name="0x1_DAOSpace_ERR_NOT_HAVE_GRANT"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_NOT_HAVE_GRANT">ERR_NOT_HAVE_GRANT</a>: u64 = 305;
</code></pre>



<a name="0x1_DAOSpace_ERR_NO_GRANTED"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_NO_GRANTED">ERR_NO_GRANTED</a>: u64 = 100;
</code></pre>



<a name="0x1_DAOSpace_ERR_OFFER_NOT_EXIST"></a>

grant


<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_OFFER_NOT_EXIST">ERR_OFFER_NOT_EXIST</a>: u64 = 800;
</code></pre>



<a name="0x1_DAOSpace_ERR_OFFER_NOT_RECEIPTOR"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_OFFER_NOT_RECEIPTOR">ERR_OFFER_NOT_RECEIPTOR</a>: u64 = 801;
</code></pre>



<a name="0x1_DAOSpace_ERR_PLUGIN_HAS_INSTALLED"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_PLUGIN_HAS_INSTALLED">ERR_PLUGIN_HAS_INSTALLED</a>: u64 = 702;
</code></pre>



<a name="0x1_DAOSpace_ERR_PLUGIN_NOT_EXIST"></a>

plugin


<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_PLUGIN_NOT_EXIST">ERR_PLUGIN_NOT_EXIST</a>: u64 = 700;
</code></pre>



<a name="0x1_DAOSpace_ERR_PLUGIN_NOT_INSTALLED"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_PLUGIN_NOT_INSTALLED">ERR_PLUGIN_NOT_INSTALLED</a>: u64 = 703;
</code></pre>



<a name="0x1_DAOSpace_ERR_PLUGIN_VERSION_NOT_EXIST"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_PLUGIN_VERSION_NOT_EXIST">ERR_PLUGIN_VERSION_NOT_EXIST</a>: u64 = 701;
</code></pre>



<a name="0x1_DAOSpace_ERR_PROPOSAL_ACTIONS_NOT_EXIST"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_ACTIONS_NOT_EXIST">ERR_PROPOSAL_ACTIONS_NOT_EXIST</a>: u64 = 502;
</code></pre>



<a name="0x1_DAOSpace_ERR_PROPOSAL_ACTION_INDEX_NOT_EXIST"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_ACTION_INDEX_NOT_EXIST">ERR_PROPOSAL_ACTION_INDEX_NOT_EXIST</a>: u64 = 405;
</code></pre>



<a name="0x1_DAOSpace_ERR_PROPOSAL_ID_MISMATCH"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_ID_MISMATCH">ERR_PROPOSAL_ID_MISMATCH</a>: u64 = 401;
</code></pre>



<a name="0x1_DAOSpace_ERR_PROPOSAL_NOT_EXIST"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_NOT_EXIST">ERR_PROPOSAL_NOT_EXIST</a>: u64 = 403;
</code></pre>



<a name="0x1_DAOSpace_ERR_PROPOSAL_OUT_OF_LIMIT"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_OUT_OF_LIMIT">ERR_PROPOSAL_OUT_OF_LIMIT</a>: u64 = 406;
</code></pre>



<a name="0x1_DAOSpace_ERR_PROPOSAL_STATE_INVALID"></a>

proposal


<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_STATE_INVALID">ERR_PROPOSAL_STATE_INVALID</a>: u64 = 400;
</code></pre>



<a name="0x1_DAOSpace_ERR_PROPOSER_MISMATCH"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSER_MISMATCH">ERR_PROPOSER_MISMATCH</a>: u64 = 402;
</code></pre>



<a name="0x1_DAOSpace_ERR_QUORUM_RATE_INVALID"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_QUORUM_RATE_INVALID">ERR_QUORUM_RATE_INVALID</a>: u64 = 404;
</code></pre>



<a name="0x1_DAOSpace_ERR_REPEAT_ELEMENT"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_REPEAT_ELEMENT">ERR_REPEAT_ELEMENT</a>: u64 = 101;
</code></pre>



<a name="0x1_DAOSpace_ERR_SNAPSHOT_PROOF_PARAM_INVALID"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_SNAPSHOT_PROOF_PARAM_INVALID">ERR_SNAPSHOT_PROOF_PARAM_INVALID</a>: u64 = 604;
</code></pre>



<a name="0x1_DAOSpace_ERR_STATE_PROOF_VERIFY_INVALID"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_STATE_PROOF_VERIFY_INVALID">ERR_STATE_PROOF_VERIFY_INVALID</a>: u64 = 605;
</code></pre>



<a name="0x1_DAOSpace_ERR_STORAGE_ERROR"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_STORAGE_ERROR">ERR_STORAGE_ERROR</a>: u64 = 102;
</code></pre>



<a name="0x1_DAOSpace_ERR_TOKEN_ERROR"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_TOKEN_ERROR">ERR_TOKEN_ERROR</a>: u64 = 105;
</code></pre>



<a name="0x1_DAOSpace_ERR_TOO_SMALL_TOTAL"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_TOO_SMALL_TOTAL">ERR_TOO_SMALL_TOTAL</a>: u64 = 303;
</code></pre>



<a name="0x1_DAOSpace_ERR_VOTED_ALREADY"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_VOTED_ALREADY">ERR_VOTED_ALREADY</a>: u64 = 602;
</code></pre>



<a name="0x1_DAOSpace_ERR_VOTED_OTHERS_ALREADY"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_VOTED_OTHERS_ALREADY">ERR_VOTED_OTHERS_ALREADY</a>: u64 = 601;
</code></pre>



<a name="0x1_DAOSpace_ERR_VOTE_PARAM_INVALID"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_VOTE_PARAM_INVALID">ERR_VOTE_PARAM_INVALID</a>: u64 = 603;
</code></pre>



<a name="0x1_DAOSpace_ERR_VOTE_STATE_MISMATCH"></a>

vote


<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_ERR_VOTE_STATE_MISMATCH">ERR_VOTE_STATE_MISMATCH</a>: u64 = 600;
</code></pre>



<a name="0x1_DAOSpace_EXECUTABLE"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_EXECUTABLE">EXECUTABLE</a>: u8 = 7;
</code></pre>



<a name="0x1_DAOSpace_EXTRACTED"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_EXTRACTED">EXTRACTED</a>: u8 = 8;
</code></pre>



<a name="0x1_DAOSpace_MAX_PROPOSALS"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_MAX_PROPOSALS">MAX_PROPOSALS</a>: u64 = 1000;
</code></pre>



<a name="0x1_DAOSpace_MEMBERJOIN_DIRECT"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_MEMBERJOIN_DIRECT">MEMBERJOIN_DIRECT</a>: u8 = 0;
</code></pre>



<a name="0x1_DAOSpace_MEMBERJOIN_OFFER"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_MEMBERJOIN_OFFER">MEMBERJOIN_OFFER</a>: u8 = 1;
</code></pre>



<a name="0x1_DAOSpace_MEMBER_OFFER_CREATE"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_MEMBER_OFFER_CREATE">MEMBER_OFFER_CREATE</a>: u8 = 0;
</code></pre>



<a name="0x1_DAOSpace_MEMBER_OFFER_REBACK"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_MEMBER_OFFER_REBACK">MEMBER_OFFER_REBACK</a>: u8 = 1;
</code></pre>



<a name="0x1_DAOSpace_MEMBER_OFFER_USE"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_MEMBER_OFFER_USE">MEMBER_OFFER_USE</a>: u8 = 2;
</code></pre>



<a name="0x1_DAOSpace_PENDING"></a>

Proposal
--------------------------------------------------
Proposal state


<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_PENDING">PENDING</a>: u8 = 1;
</code></pre>



<a name="0x1_DAOSpace_QUEUED"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_QUEUED">QUEUED</a>: u8 = 6;
</code></pre>



<a name="0x1_DAOSpace_REJECTED"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_REJECTED">REJECTED</a>: u8 = 3;
</code></pre>



<a name="0x1_DAOSpace_VOTING_CHOICE_ABSTAIN"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_VOTING_CHOICE_ABSTAIN">VOTING_CHOICE_ABSTAIN</a>: u8 = 4;
</code></pre>



<a name="0x1_DAOSpace_VOTING_CHOICE_NO"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_VOTING_CHOICE_NO">VOTING_CHOICE_NO</a>: u8 = 2;
</code></pre>



<a name="0x1_DAOSpace_VOTING_CHOICE_NO_WITH_VETO"></a>



<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_VOTING_CHOICE_NO_WITH_VETO">VOTING_CHOICE_NO_WITH_VETO</a>: u8 = 3;
</code></pre>



<a name="0x1_DAOSpace_VOTING_CHOICE_YES"></a>

voting choice: 1:yes, 2:no, 3: no_with_veto, 4:abstain


<pre><code><b>const</b> <a href="DAOSpace.md#0x1_DAOSpace_VOTING_CHOICE_YES">VOTING_CHOICE_YES</a>: u8 = 1;
</code></pre>



<a name="0x1_DAOSpace_install_plugin_cap_type"></a>

## Function `install_plugin_cap_type`

Create a install plugin capability type.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_install_plugin_cap_type">install_plugin_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_install_plugin_cap_type">install_plugin_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a> { <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>{ code: 0 } }
</code></pre>



</details>

<a name="0x1_DAOSpace_upgrade_module_cap_type"></a>

## Function `upgrade_module_cap_type`

Create a upgrade module capability type.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_upgrade_module_cap_type">upgrade_module_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_upgrade_module_cap_type">upgrade_module_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a> { <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>{ code: 1 } }
</code></pre>



</details>

<a name="0x1_DAOSpace_modify_config_cap_type"></a>

## Function `modify_config_cap_type`

Create a modify dao config capability type.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_modify_config_cap_type">modify_config_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_modify_config_cap_type">modify_config_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a> { <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>{ code: 2 } }
</code></pre>



</details>

<a name="0x1_DAOSpace_withdraw_token_cap_type"></a>

## Function `withdraw_token_cap_type`

Create a withdraw Token capability type.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_withdraw_token_cap_type">withdraw_token_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_withdraw_token_cap_type">withdraw_token_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a> { <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>{ code: 3 } }
</code></pre>



</details>

<a name="0x1_DAOSpace_withdraw_nft_cap_type"></a>

## Function `withdraw_nft_cap_type`

Create a withdraw NFT capability type.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_withdraw_nft_cap_type">withdraw_nft_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_withdraw_nft_cap_type">withdraw_nft_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a> { <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>{ code: 4 } }
</code></pre>



</details>

<a name="0x1_DAOSpace_storage_cap_type"></a>

## Function `storage_cap_type`

Create a write data to DAO account capability type.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_storage_cap_type">storage_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_storage_cap_type">storage_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a> { <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>{ code: 5 } }
</code></pre>



</details>

<a name="0x1_DAOSpace_member_cap_type"></a>

## Function `member_cap_type`

Create a member capability type.
This cap can issue DAO member NFT or update member's SBT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_member_cap_type">member_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_member_cap_type">member_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a> { <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>{ code: 6 } }
</code></pre>



</details>

<a name="0x1_DAOSpace_proposal_cap_type"></a>

## Function `proposal_cap_type`

Create a vote capability type.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_cap_type">proposal_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_cap_type">proposal_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a> { <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>{ code: 7 } }
</code></pre>



</details>

<a name="0x1_DAOSpace_grant_cap_type"></a>

## Function `grant_cap_type`

Create a grant capability type.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_cap_type">grant_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_cap_type">grant_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a> { <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>{ code: 8 } }
</code></pre>



</details>

<a name="0x1_DAOSpace_token_mint_cap_type"></a>

## Function `token_mint_cap_type`

Create a token minting capability type.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_token_mint_cap_type">token_mint_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_token_mint_cap_type">token_mint_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a> { <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>{code: 9 } }
</code></pre>



</details>

<a name="0x1_DAOSpace_token_burn_cap_type"></a>

## Function `token_burn_cap_type`

Create a token burning capability type.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_token_burn_cap_type">token_burn_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_token_burn_cap_type">token_burn_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a> { <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>{code: 10 } }
</code></pre>



</details>

<a name="0x1_DAOSpace_plugin_event_cap_type"></a>

## Function `plugin_event_cap_type`

Creates a grant capability type.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_plugin_event_cap_type">plugin_event_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_plugin_event_cap_type">plugin_event_cap_type</a>(): <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a> { <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>{ code: 11 } }
</code></pre>



</details>

<a name="0x1_DAOSpace_all_caps"></a>

## Function `all_caps`

Create all capability types.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_all_caps">all_caps</a>(): vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_all_caps">all_caps</a>(): vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>&gt; {
    <b>let</b> caps = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(<a href="DAOSpace.md#0x1_DAOSpace_install_plugin_cap_type">install_plugin_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_upgrade_module_cap_type">upgrade_module_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_modify_config_cap_type">modify_config_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_withdraw_token_cap_type">withdraw_token_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_withdraw_nft_cap_type">withdraw_nft_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_storage_cap_type">storage_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_member_cap_type">member_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_proposal_cap_type">proposal_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_grant_cap_type">grant_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_token_mint_cap_type">token_mint_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_token_burn_cap_type">token_burn_cap_type</a>());
    <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> caps, <a href="DAOSpace.md#0x1_DAOSpace_plugin_event_cap_type">plugin_event_cap_type</a>());
    caps
}
</code></pre>



</details>

<a name="0x1_DAOSpace_create_dao"></a>

## Function `create_dao`

Create a dao with a exists DAO account


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_create_dao">create_dao</a>&lt;DAOT: store&gt;(cap: <a href="DAOAccount.md#0x1_DAOAccount_DAOAccountCap">DAOAccount::DAOAccountCap</a>, name: vector&lt;u8&gt;, image_data: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, image_url: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, description: vector&lt;u8&gt;, config: <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOSpace::DAOConfig</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_create_dao">create_dao</a>&lt;DAOT: store&gt;(
    cap: DAOAccountCap,
    name: vector&lt;u8&gt;,
    image_data:<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;,
    image_url:<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;,
    description: vector&lt;u8&gt;,
    config: <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOConfig</a>
) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOEvent">DAOEvent</a> {
    <b>let</b> dao_signer = <a href="DAOAccount.md#0x1_DAOAccount_dao_signer">DAOAccount::dao_signer</a>(&cap);

    <b>let</b> dao_address = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&dao_signer);
    <b>let</b> id = <a href="DAORegistry.md#0x1_DAORegistry_register">DAORegistry::register</a>&lt;DAOT&gt;(dao_address);
    <a href="ASCII.md#0x1_ASCII_string">ASCII::string</a>(<b>copy</b> name);
    <b>let</b> dao = <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>{
        id,
        name: <b>copy</b> name,
        description: <b>copy</b> description,
        dao_address,
        next_member_id: 1,
        next_proposal_id: 1,
    };

    <b>move_to</b>(&dao_signer, dao);
    <b>move_to</b>(&dao_signer, <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a>{
        cap
    });

    <a href="Token.md#0x1_Token_register_token">Token::register_token</a>&lt;DAOT&gt;(&dao_signer, 1);
    <b>let</b> token_mint_cap = <a href="Token.md#0x1_Token_remove_mint_capability">Token::remove_mint_capability</a>&lt;DAOT&gt;(&dao_signer);
    <b>let</b> token_burn_cap = <a href="Token.md#0x1_Token_remove_burn_capability">Token::remove_burn_capability</a>&lt;DAOT&gt;(&dao_signer);

    <b>move_to</b>(&dao_signer, <a href="DAOSpace.md#0x1_DAOSpace_DAOSBTMintCapHolder">DAOSBTMintCapHolder</a>{
        cap: token_mint_cap,
    });
    <b>move_to</b>(&dao_signer, <a href="DAOSpace.md#0x1_DAOSpace_DAOSBTBurnCapHolder">DAOSBTBurnCapHolder</a>{
        cap: token_burn_cap,
    });

    <b>let</b> nft_name = <b>copy</b> name;
    <b>let</b> nft_description = <b>copy</b> name;
    <b>let</b> basemeta = <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&image_data)){
        <a href="NFT.md#0x1_NFT_new_meta_with_image_data">NFT::new_meta_with_image_data</a>(nft_name, <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(image_data), nft_description)
    }<b>else</b> <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&image_url)){
        <a href="NFT.md#0x1_NFT_new_meta_with_image">NFT::new_meta_with_image</a>(nft_name, <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(image_url), nft_description)
    }<b>else</b>{
        <a href="NFT.md#0x1_NFT_new_meta">NFT::new_meta</a>(nft_name, nft_description)
    };


    <a href="NFT.md#0x1_NFT_register_v2">NFT::register_v2</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;&gt;(&dao_signer, basemeta);
    <b>let</b> nft_mint_cap = <a href="NFT.md#0x1_NFT_remove_mint_capability">NFT::remove_mint_capability</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;&gt;(&dao_signer);
    <b>move_to</b>(&dao_signer, <a href="DAOSpace.md#0x1_DAOSpace_DAONFTMintCapHolder">DAONFTMintCapHolder</a>{
        cap: nft_mint_cap,
    });

    <b>let</b> nft_burn_cap = <a href="NFT.md#0x1_NFT_remove_burn_capability">NFT::remove_burn_capability</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;&gt;(&dao_signer);
    <b>move_to</b>(&dao_signer, <a href="DAOSpace.md#0x1_DAOSpace_DAONFTBurnCapHolder">DAONFTBurnCapHolder</a>{
        cap: nft_burn_cap,
    });

    <b>let</b> nft_update_cap = <a href="NFT.md#0x1_NFT_remove_update_capability">NFT::remove_update_capability</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;&gt;(&dao_signer);
    <b>move_to</b>(&dao_signer, <a href="DAOSpace.md#0x1_DAOSpace_DAONFTUpdateCapHolder">DAONFTUpdateCapHolder</a>{
        cap: nft_update_cap,
    });

    <b>let</b> config_modify_cap = <a href="Config.md#0x1_Config_publish_new_config_with_capability">Config::publish_new_config_with_capability</a>(&dao_signer, config);
    <b>move_to</b>(&dao_signer, <a href="DAOSpace.md#0x1_DAOSpace_DAOConfigModifyCapHolder">DAOConfigModifyCapHolder</a>{
        cap: config_modify_cap,
    });

    <b>move_to</b>(&dao_signer, <a href="DAOSpace.md#0x1_DAOSpace_DAOEvent">DAOEvent</a>&lt;DAOT&gt;  {
        dao_create_event: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOCreatedEvent">DAOCreatedEvent</a>&gt;(&dao_signer),
    });
    <b>move_to</b>(&dao_signer ,<a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a>{
        member_offer_event_handler: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberOfferEvent">MemberOfferEvent</a>&gt;(&dao_signer),
        member_join_event_handler:<a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberJoinEvent">MemberJoinEvent</a>&gt;(&dao_signer),
        member_quit_event_handler:<a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberQuitEvent">MemberQuitEvent</a>&gt;(&dao_signer),
        member_revoke_event_handler:<a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberRevokeEvent">MemberRevokeEvent</a>&gt;(&dao_signer),
        member_increase_sbt_event_handler:<a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberIncreaseSBTEvent">MemberIncreaseSBTEvent</a>&gt;(&dao_signer),
        member_decrease_sbt_event_handler:<a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberDecreaseSBTEvent">MemberDecreaseSBTEvent</a>&gt;(&dao_signer),
    });
    <b>move_to</b>(&dao_signer, <a href="DAOSpace.md#0x1_DAOSpace_ProposalEvent">ProposalEvent</a>&lt;DAOT&gt;  {
        proposal_create_event: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalCreatedEvent">ProposalCreatedEvent</a>&gt;(&dao_signer),
        vote_event: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_VotedEvent">VotedEvent</a>&gt;(&dao_signer),
        proposal_action_event: <a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalActionEvent">ProposalActionEvent</a>&gt;(&dao_signer),
    });

    // dao event emit
    <b>let</b> dao_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOEvent">DAOEvent</a>&lt;DAOT&gt; &gt;(dao_address);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> dao_event.dao_create_event,
        <a href="DAOSpace.md#0x1_DAOSpace_DAOCreatedEvent">DAOCreatedEvent</a> {
            id,
            name: <b>copy</b> name,
            description:<b>copy</b> description,
            dao_address,
        },
    );
}
</code></pre>



</details>

<a name="0x1_DAOSpace_upgrade_to_dao"></a>

## Function `upgrade_to_dao`

Upgrade account to DAO account and create DAO


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_upgrade_to_dao">upgrade_to_dao</a>&lt;DAOT: store&gt;(sender: signer, name: vector&lt;u8&gt;, image_data: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, image_url: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, description: vector&lt;u8&gt;, config: <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOSpace::DAOConfig</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_upgrade_to_dao">upgrade_to_dao</a>&lt;DAOT: store&gt;(
    sender: signer,
    name: vector&lt;u8&gt;,
    image_data:<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;,
    image_url:<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;,
    description:vector&lt;u8&gt;,
    config: <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOConfig</a>
) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOEvent">DAOEvent</a>{
    <b>let</b> cap = <a href="DAOAccount.md#0x1_DAOAccount_upgrade_to_dao">DAOAccount::upgrade_to_dao</a>(sender);
    <a href="DAOSpace.md#0x1_DAOSpace_create_dao">create_dao</a>&lt;DAOT&gt;(cap, name, image_data, image_url, description, config)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_install_plugin"></a>

## Function `install_plugin`

Install plugin with DAOInstallPluginCap


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_install_plugin">install_plugin</a>&lt;DAOT: store, PluginT: store, ToInstallPluginT: store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOInstallPluginCap">DAOSpace::DAOInstallPluginCap</a>&lt;DAOT, PluginT&gt;, granted_caps: vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_install_plugin">install_plugin</a>&lt;DAOT: store, PluginT:store, ToInstallPluginT:store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOInstallPluginCap">DAOInstallPluginCap</a>&lt;DAOT, PluginT&gt;, granted_caps: vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>&gt;) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_do_install_plugin">do_install_plugin</a>&lt;DAOT, ToInstallPluginT&gt;(granted_caps);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_do_install_plugin"></a>

## Function `do_install_plugin`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_do_install_plugin">do_install_plugin</a>&lt;DAOT: store, ToInstallPluginT: store&gt;(granted_caps: vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_do_install_plugin">do_install_plugin</a>&lt;DAOT: store, ToInstallPluginT:store&gt;(granted_caps: vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>&gt;) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a> {
    <b>assert</b>!(<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_exists_plugin">DAOPluginMarketplace::exists_plugin</a>&lt;ToInstallPluginT&gt;(), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PLUGIN_NOT_EXIST">ERR_PLUGIN_NOT_EXIST</a>));
    <a href="DAOSpace.md#0x1_DAOSpace_assert_no_repeat">assert_no_repeat</a>(&granted_caps);
    <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
    <b>let</b> plugin_id = <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_take_plugin_id">DAOPluginMarketplace::take_plugin_id</a>&lt;ToInstallPluginT&gt;();

    <b>assert</b>!(!<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a>&lt;ToInstallPluginT&gt;&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&dao_signer)), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PLUGIN_HAS_INSTALLED">ERR_PLUGIN_HAS_INSTALLED</a>));
    <b>move_to</b>(&dao_signer, <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a>&lt;ToInstallPluginT&gt;{
        plugin_id: plugin_id,
        granted_caps,
    });
}
</code></pre>



</details>

<a name="0x1_DAOSpace_uninstall_plugin"></a>

## Function `uninstall_plugin`

Uninstall plugin with DAOInstallPluginCap


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_uninstall_plugin">uninstall_plugin</a>&lt;DAOT: store, PluginT: store, ToInstallPluginT: store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOInstallPluginCap">DAOSpace::DAOInstallPluginCap</a>&lt;DAOT, PluginT&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_uninstall_plugin">uninstall_plugin</a>&lt;DAOT: store, PluginT:store, ToInstallPluginT:store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOInstallPluginCap">DAOInstallPluginCap</a>&lt;DAOT, PluginT&gt;) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_do_uninstall_plugin">do_uninstall_plugin</a>&lt;DAOT, ToInstallPluginT&gt;();
}
</code></pre>



</details>

<a name="0x1_DAOSpace_do_uninstall_plugin"></a>

## Function `do_uninstall_plugin`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_do_uninstall_plugin">do_uninstall_plugin</a>&lt;DAOT: store, ToInstallPluginT: store&gt;()
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_do_uninstall_plugin">do_uninstall_plugin</a>&lt;DAOT: store, ToInstallPluginT:store&gt;() <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a> {
    <b>assert</b>!(<a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_exists_plugin">DAOPluginMarketplace::exists_plugin</a>&lt;ToInstallPluginT&gt;(), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PLUGIN_NOT_EXIST">ERR_PLUGIN_NOT_EXIST</a>));

    <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
    <b>let</b> dao_address = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&dao_signer);

    <b>assert</b>!(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a>&lt;ToInstallPluginT&gt;&gt;(dao_address), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PLUGIN_NOT_INSTALLED">ERR_PLUGIN_NOT_INSTALLED</a>));
    <b>let</b> installed_plugin = <b>move_from</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a>&lt;ToInstallPluginT&gt;&gt;(dao_address);

    <b>let</b> <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a>&lt;ToInstallPluginT&gt; {
        plugin_id:_,
        granted_caps:_,
    } = installed_plugin;
}
</code></pre>



</details>

<a name="0x1_DAOSpace_submit_upgrade_plan"></a>

## Function `submit_upgrade_plan`

Submit upgrade module plan


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_submit_upgrade_plan">submit_upgrade_plan</a>&lt;DAOT: store, PluginT&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOUpgradeModuleCap">DAOSpace::DAOUpgradeModuleCap</a>&lt;DAOT, PluginT&gt;, package_hash: vector&lt;u8&gt;, version: u64, enforced: bool)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_submit_upgrade_plan">submit_upgrade_plan</a>&lt;DAOT: store, PluginT&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOUpgradeModuleCap">DAOUpgradeModuleCap</a>&lt;DAOT, PluginT&gt;, package_hash: vector&lt;u8&gt;, version: u64, enforced: bool) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a> {
    <b>let</b> dao_account_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a>&gt;(<a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;()).cap;
    <a href="DAOAccount.md#0x1_DAOAccount_submit_upgrade_plan">DAOAccount::submit_upgrade_plan</a>(dao_account_cap, package_hash, version, enforced);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_save_to_storage"></a>

## Function `save_to_storage`

Save the item to the storage


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_save_to_storage">save_to_storage</a>&lt;DAOT: store, PluginT, V: store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOStorageCap">DAOSpace::DAOStorageCap</a>&lt;DAOT, PluginT&gt;, item: V)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_save_to_storage">save_to_storage</a>&lt;DAOT: store, PluginT, V: store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOStorageCap">DAOStorageCap</a>&lt;DAOT, PluginT&gt;, item: V) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a> {
    <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
    <b>assert</b>!(!<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_StorageItem">StorageItem</a>&lt;PluginT, V&gt;&gt;(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&dao_signer)), <a href="Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_STORAGE_ERROR">ERR_STORAGE_ERROR</a>));
    <b>move_to</b>(&dao_signer, <a href="DAOSpace.md#0x1_DAOSpace_StorageItem">StorageItem</a>&lt;PluginT, V&gt;{
        item
    });
}
</code></pre>



</details>

<a name="0x1_DAOSpace_take_from_storage"></a>

## Function `take_from_storage`

Get the item from the storage


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_take_from_storage">take_from_storage</a>&lt;DAOT: store, PluginT, V: store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOStorageCap">DAOSpace::DAOStorageCap</a>&lt;DAOT, PluginT&gt;): V
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_take_from_storage">take_from_storage</a>&lt;DAOT: store, PluginT, V: store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOStorageCap">DAOStorageCap</a>&lt;DAOT, PluginT&gt;): V <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_StorageItem">StorageItem</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>assert</b>!(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_StorageItem">StorageItem</a>&lt;PluginT, V&gt;&gt;(dao_address), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_STORAGE_ERROR">ERR_STORAGE_ERROR</a>));
    <b>let</b> <a href="DAOSpace.md#0x1_DAOSpace_StorageItem">StorageItem</a>{ item } = <b>move_from</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_StorageItem">StorageItem</a>&lt;PluginT, V&gt;&gt;(dao_address);
    item
}
</code></pre>



</details>

<a name="0x1_DAOSpace_exists_in_storage"></a>

## Function `exists_in_storage`

Check the item has exists in storage


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_exists_in_storage">exists_in_storage</a>&lt;DAOT: store, PluginT, V: store&gt;(): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_exists_in_storage">exists_in_storage</a>&lt;DAOT: store, PluginT, V: store&gt;(): bool {
    <b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_StorageItem">StorageItem</a>&lt;PluginT, V&gt;&gt;(<a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;())
}
</code></pre>



</details>

<a name="0x1_DAOSpace_copy_from_storage"></a>

## Function `copy_from_storage`

Copy the item from the storage


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_copy_from_storage">copy_from_storage</a>&lt;DAOT: store, PluginT, V: <b>copy</b>, store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOStorageCap">DAOSpace::DAOStorageCap</a>&lt;DAOT, PluginT&gt;): V
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_copy_from_storage">copy_from_storage</a>&lt;DAOT: store, PluginT, V: store+<b>copy</b>&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOStorageCap">DAOStorageCap</a>&lt;DAOT, PluginT&gt;): V <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_StorageItem">StorageItem</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>assert</b>!(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_StorageItem">StorageItem</a>&lt;PluginT, V&gt;&gt;(dao_address), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_STORAGE_ERROR">ERR_STORAGE_ERROR</a>));
    <b>let</b> storage_item  = <b>borrow_global</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_StorageItem">StorageItem</a>&lt;PluginT, V&gt;&gt;(dao_address);
    *&storage_item.item
}
</code></pre>



</details>

<a name="0x1_DAOSpace_withdraw_token"></a>

## Function `withdraw_token`

Withdraw the token from the DAO account


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_withdraw_token">withdraw_token</a>&lt;DAOT: store, PluginT, TokenT: store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOWithdrawTokenCap">DAOSpace::DAOWithdrawTokenCap</a>&lt;DAOT, PluginT&gt;, amount: u128): <a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_withdraw_token">withdraw_token</a>&lt;DAOT: store, PluginT, TokenT: store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOWithdrawTokenCap">DAOWithdrawTokenCap</a>&lt;DAOT, PluginT&gt;, amount: u128): <a href="Token.md#0x1_Token">Token</a>&lt;TokenT&gt; <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a> {
    <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
    //we should extract the WithdrawCapability from account, and invoke the withdraw_with_cap ?
    <a href="Account.md#0x1_Account_withdraw">Account::withdraw</a>&lt;TokenT&gt;(&dao_signer, amount)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_withdraw_nft"></a>

## Function `withdraw_nft`

Withdraw the NFT from the DAO account


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_withdraw_nft">withdraw_nft</a>&lt;DAOT: store, PluginT, NFTMeta: <b>copy</b>, drop, store, NFTBody: store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOWithdrawNFTCap">DAOSpace::DAOWithdrawNFTCap</a>&lt;DAOT, PluginT&gt;, id: u64): <a href="NFT.md#0x1_NFT_NFT">NFT::NFT</a>&lt;NFTMeta, NFTBody&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_withdraw_nft">withdraw_nft</a>&lt;DAOT: store, PluginT, NFTMeta: store + <b>copy</b> + drop, NFTBody: store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOWithdrawNFTCap">DAOWithdrawNFTCap</a>&lt;DAOT, PluginT&gt;, id: u64): <a href="NFT.md#0x1_NFT">NFT</a>&lt;NFTMeta, NFTBody&gt; <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a> {
    <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
    <b>let</b> nft = <a href="NFT.md#0x1_NFTGallery_withdraw">NFTGallery::withdraw</a>&lt;NFTMeta, NFTBody&gt;(&dao_signer, id);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&nft), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_NFT_ERROR">ERR_NFT_ERROR</a>));
    <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(nft)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_issue_member_offer"></a>

## Function `issue_member_offer`

invite a new member to the DAO


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_issue_member_offer">issue_member_offer</a>&lt;DAOT: store, PluginT&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOSpace::DAOMemberCap</a>&lt;DAOT, PluginT&gt;, to_address: <b>address</b>, image_data: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, image_url: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, init_sbt: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_issue_member_offer">issue_member_offer</a>&lt;DAOT: store, PluginT&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOMemberCap</a>&lt;DAOT, PluginT&gt;, to_address: <b>address</b>, image_data:<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, image_url:<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, init_sbt: u128) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
    <b>let</b> memeber_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a>&gt;(dao_address);
    <b>if</b>(<a href="DAOSpace.md#0x1_DAOSpace_is_member">is_member</a>&lt;DAOT&gt;(to_address)){
        <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_offer_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_MemberOfferEvent">MemberOfferEvent</a> {
            dao_id: <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address),
            addr:to_address,
            type:<a href="DAOSpace.md#0x1_DAOSpace_MEMBER_OFFER_REBACK">MEMBER_OFFER_REBACK</a>,
            image_data,
            image_url,
            sbt: init_sbt,
        });
        <b>return</b>
    };

    <b>let</b> op_index = <a href="Offer.md#0x1_Offer_find_offer">Offer::find_offer</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemeberOffer">MemeberOffer</a>&lt;DAOT&gt;&gt;(dao_address, to_address);
    <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&op_index)){
        <b>let</b> <a href="DAOSpace.md#0x1_DAOSpace_MemeberOffer">MemeberOffer</a>&lt;DAOT&gt;{
            to_address,
            image_data,
            image_url,
            init_sbt
        } = <a href="Offer.md#0x1_Offer_retake">Offer::retake</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemeberOffer">MemeberOffer</a>&lt;DAOT&gt;&gt;(&dao_signer, <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(op_index));
        <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_offer_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_MemberOfferEvent">MemberOfferEvent</a> {
            dao_id: <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address),
            addr:to_address,
            type:<a href="DAOSpace.md#0x1_DAOSpace_MEMBER_OFFER_REBACK">MEMBER_OFFER_REBACK</a>,
            image_data,
            image_url,
            sbt: init_sbt,
        });
        <b>return</b>
    };

    <b>let</b> offered = <a href="DAOSpace.md#0x1_DAOSpace_MemeberOffer">MemeberOffer</a>&lt;DAOT&gt; {
        to_address,
        image_data: <b>copy</b> image_data,
        image_url: <b>copy</b> image_url,
        init_sbt
    };
    <a href="Offer.md#0x1_Offer_create_v2">Offer::create_v2</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemeberOffer">MemeberOffer</a>&lt;DAOT&gt;&gt;(&dao_signer, offered, to_address, 0);

    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_offer_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_MemberOfferEvent">MemberOfferEvent</a> {
        dao_id: <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address),
        addr:to_address,
        type:<a href="DAOSpace.md#0x1_DAOSpace_MEMBER_OFFER_CREATE">MEMBER_OFFER_CREATE</a>,
        image_data,
        image_url,
        sbt: init_sbt,
    });
}
</code></pre>



</details>

<a name="0x1_DAOSpace_revoke_member_offer"></a>

## Function `revoke_member_offer`

Review the member offer


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_revoke_member_offer">revoke_member_offer</a>&lt;DAOT: store, PluginT&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOSpace::DAOMemberCap</a>&lt;DAOT, PluginT&gt;, to_address: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_revoke_member_offer">revoke_member_offer</a>&lt;DAOT: store, PluginT&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOMemberCap</a>&lt;DAOT, PluginT&gt;, to_address: <b>address</b>) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
    <b>let</b> op_index = <a href="Offer.md#0x1_Offer_find_offer">Offer::find_offer</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemeberOffer">MemeberOffer</a>&lt;DAOT&gt;&gt;(dao_address, to_address);
    <b>let</b> memeber_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a>&gt;(dao_address);
    <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&op_index)){
        <b>let</b> <a href="DAOSpace.md#0x1_DAOSpace_MemeberOffer">MemeberOffer</a>&lt;DAOT&gt;{
            to_address,
            image_data,
            image_url,
            init_sbt
        } = <a href="Offer.md#0x1_Offer_retake">Offer::retake</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemeberOffer">MemeberOffer</a>&lt;DAOT&gt;&gt;(&dao_signer, <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(op_index));
        <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_offer_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_MemberOfferEvent">MemberOfferEvent</a> {
            dao_id: <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address),
            addr:to_address,
            type:<a href="DAOSpace.md#0x1_DAOSpace_MEMBER_OFFER_REBACK">MEMBER_OFFER_REBACK</a>,
            image_data,
            image_url,
            sbt: init_sbt,
        });
    }
}
</code></pre>



</details>

<a name="0x1_DAOSpace_accept_member_offer"></a>

## Function `accept_member_offer`

Accept the MemberOffer and become a member


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_accept_member_offer">accept_member_offer</a>&lt;DAOT: store&gt;(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_accept_member_offer">accept_member_offer</a>&lt;DAOT: store&gt;(sender: &signer) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTMintCapHolder">DAONFTMintCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOSBTMintCapHolder">DAOSBTMintCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>, <a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAONFTUpdateCapHolder">DAONFTUpdateCapHolder</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> op_index = <a href="Offer.md#0x1_Offer_find_offer">Offer::find_offer</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemeberOffer">MemeberOffer</a>&lt;DAOT&gt;&gt;(dao_address, <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender));
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&op_index),1003);
    <b>let</b> memeber_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a>&gt;(dao_address);
    <b>let</b> <a href="DAOSpace.md#0x1_DAOSpace_MemeberOffer">MemeberOffer</a>&lt;DAOT&gt; {
        to_address,
        image_data,
        image_url,
        init_sbt
    }= <a href="Offer.md#0x1_Offer_redeem_v2">Offer::redeem_v2</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemeberOffer">MemeberOffer</a>&lt;DAOT&gt;&gt;(sender, dao_address, <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(op_index));
    <b>assert</b>!(to_address == <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_OFFER_NOT_RECEIPTOR">ERR_OFFER_NOT_RECEIPTOR</a>));
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_offer_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_MemberOfferEvent">MemberOfferEvent</a> {
        dao_id: <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address),
        addr:to_address,
        type:<a href="DAOSpace.md#0x1_DAOSpace_MEMBER_OFFER_USE">MEMBER_OFFER_USE</a>,
        image_data: <b>copy</b> image_data,
        image_url: <b>copy</b> image_url,
        sbt: init_sbt,
    });
    <b>if</b>(<a href="DAOSpace.md#0x1_DAOSpace_is_member">is_member</a>&lt;DAOT&gt;(to_address)){
        <a href="DAOSpace.md#0x1_DAOSpace_increase_member_sbt">increase_member_sbt</a>&lt;DAOT, DAOT&gt;(&<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOMemberCap</a>&lt;DAOT, DAOT&gt;{}, to_address, init_sbt);
    }<b>else</b>{
        <a href="DAOSpace.md#0x1_DAOSpace_do_join_member">do_join_member</a>&lt;DAOT&gt;(sender, image_data, image_url, init_sbt);
        <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_join_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_MemberJoinEvent">MemberJoinEvent</a> {
            dao_id: <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address),
            type:<a href="DAOSpace.md#0x1_DAOSpace_MEMBERJOIN_OFFER">MEMBERJOIN_OFFER</a>,
            member_id:<a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(<a href="DAOSpace.md#0x1_DAOSpace_query_member_id">query_member_id</a>&lt;DAOT&gt;(to_address)),
            addr:to_address,
            sbt: init_sbt,
        });
    }
}
</code></pre>



</details>

<a name="0x1_DAOSpace_accept_member_offer_entry"></a>

## Function `accept_member_offer_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_accept_member_offer_entry">accept_member_offer_entry</a>&lt;DAOT: store&gt;(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_accept_member_offer_entry">accept_member_offer_entry</a>&lt;DAOT: store&gt;(sender: signer) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTMintCapHolder">DAONFTMintCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOSBTMintCapHolder">DAOSBTMintCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>, <a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a> , <a href="DAOSpace.md#0x1_DAOSpace_DAONFTUpdateCapHolder">DAONFTUpdateCapHolder</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_accept_member_offer">accept_member_offer</a>&lt;DAOT&gt;(&sender)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_do_join_member"></a>

## Function `do_join_member`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_do_join_member">do_join_member</a>&lt;DAOT: store&gt;(sender: &signer, image_data: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, image_url: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, init_sbt: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_do_join_member">do_join_member</a>&lt;DAOT: store&gt;(sender: &signer, image_data:<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, image_url:<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, init_sbt: u128) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTMintCapHolder">DAONFTMintCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOSBTMintCapHolder">DAOSBTMintCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> {
    <b>let</b> to_address = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <a href="DAOSpace.md#0x1_DAOSpace_ensure_not_member">ensure_not_member</a>&lt;DAOT&gt;(to_address);
    <a href="NFT.md#0x1_IdentifierNFT_accept">IdentifierNFT::accept</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;, <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt;&gt;(sender);
    <b>let</b> member_id = <a href="DAOSpace.md#0x1_DAOSpace_next_member_id">next_member_id</a>&lt;DAOT&gt;();

    <b>let</b> meta = <a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;{
        id: member_id,
    };

    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();

    <b>let</b> token_mint_cap = &<b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOSBTMintCapHolder">DAOSBTMintCapHolder</a>&lt;DAOT&gt;&gt;(dao_address).cap;
    <b>let</b> sbt = <a href="Token.md#0x1_Token_mint_with_capability">Token::mint_with_capability</a>&lt;DAOT&gt;(token_mint_cap, init_sbt);

    <b>let</b> body = <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt;{
        sbt,
    };

    <b>let</b> dao = <b>borrow_global</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>&gt;(dao_address);
    <b>let</b> nft_name = *&dao.name;
    <b>let</b> nft_description = *&dao.name;

    <b>let</b> basemeta = <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&image_data)){
        <a href="NFT.md#0x1_NFT_new_meta_with_image_data">NFT::new_meta_with_image_data</a>(nft_name, <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(image_data), nft_description)
    }<b>else</b> <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&image_url)){
        <a href="NFT.md#0x1_NFT_new_meta_with_image">NFT::new_meta_with_image</a>(nft_name, <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(image_url), nft_description)
    }<b>else</b>{
        <a href="NFT.md#0x1_NFT_new_meta">NFT::new_meta</a>(nft_name, nft_description)
    };
    <b>let</b> nft_mint_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAONFTMintCapHolder">DAONFTMintCapHolder</a>&lt;DAOT&gt;&gt;(dao_address).cap;

    <b>let</b> nft = <a href="NFT.md#0x1_NFT_mint_with_cap_v2">NFT::mint_with_cap_v2</a>(dao_address, nft_mint_cap, basemeta, meta, body);
    <a href="NFT.md#0x1_IdentifierNFT_grant_to">IdentifierNFT::grant_to</a>(nft_mint_cap, to_address, nft);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_quit_member_entry"></a>

## Function `quit_member_entry`

Member quit DAO by self


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_quit_member_entry">quit_member_entry</a>&lt;DAOT: store&gt;(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_quit_member_entry">quit_member_entry</a>&lt;DAOT: store&gt;(sender: signer) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTBurnCapHolder">DAONFTBurnCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOSBTBurnCapHolder">DAOSBTBurnCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_quit_member">quit_member</a>&lt;DAOT&gt;(&sender);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_quit_member"></a>

## Function `quit_member`

Member quit DAO by self


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_quit_member">quit_member</a>&lt;DAOT: store&gt;(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_quit_member">quit_member</a>&lt;DAOT: store&gt;(sender: &signer) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTBurnCapHolder">DAONFTBurnCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOSBTBurnCapHolder">DAOSBTBurnCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a> {
    <b>let</b> member_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>if</b>(!<a href="DAOSpace.md#0x1_DAOSpace_is_member">is_member</a>&lt;DAOT&gt;(member_addr)){
        <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
        <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
        <b>let</b> op_index = <a href="Offer.md#0x1_Offer_find_offer">Offer::find_offer</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemeberOffer">MemeberOffer</a>&lt;DAOT&gt;&gt;(dao_address, member_addr);
        <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&op_index)){
            <a href="Offer.md#0x1_Offer_retake">Offer::retake</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemeberOffer">MemeberOffer</a>&lt;DAOT&gt;&gt;(&dao_signer, <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(op_index));
        };
        <b>return</b>
    };

    <b>let</b> (member_id , sbt) = <a href="DAOSpace.md#0x1_DAOSpace_do_remove_member">do_remove_member</a>&lt;DAOT&gt;(member_addr);
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();

    <b>let</b> memeber_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a>&gt;(dao_address);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_quit_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_MemberQuitEvent">MemberQuitEvent</a> {
        dao_id: <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address),
        member_id,
        addr:member_addr,
        sbt,
    });
}
</code></pre>



</details>

<a name="0x1_DAOSpace_revoke_member"></a>

## Function `revoke_member`

Revoke membership with cap


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_revoke_member">revoke_member</a>&lt;DAOT: store, PluginT&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOSpace::DAOMemberCap</a>&lt;DAOT, PluginT&gt;, member_addr: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_revoke_member">revoke_member</a>&lt;DAOT: store, PluginT&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOMemberCap</a>&lt;DAOT, PluginT&gt;, member_addr: <b>address</b>) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTBurnCapHolder">DAONFTBurnCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOSBTBurnCapHolder">DAOSBTBurnCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> {
    <b>let</b> (member_id , sbt) = <a href="DAOSpace.md#0x1_DAOSpace_do_remove_member">do_remove_member</a>&lt;DAOT&gt;(member_addr);
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();

    <b>let</b> memeber_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a>&gt;(dao_address);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_revoke_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_MemberRevokeEvent">MemberRevokeEvent</a> {
        dao_id: <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address),
        member_id,
        addr:member_addr,
        sbt: sbt,
    });
}
</code></pre>



</details>

<a name="0x1_DAOSpace_ensure_member"></a>

## Function `ensure_member`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_ensure_member">ensure_member</a>&lt;DAOT: store&gt;(member_addr: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_ensure_member">ensure_member</a>&lt;DAOT: store&gt;(member_addr:<b>address</b>){
    <b>assert</b>!(<a href="DAOSpace.md#0x1_DAOSpace_is_member">is_member</a>&lt;DAOT&gt;(member_addr), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_EXPECT_MEMBER">ERR_EXPECT_MEMBER</a>));
}
</code></pre>



</details>

<a name="0x1_DAOSpace_ensure_not_member"></a>

## Function `ensure_not_member`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_ensure_not_member">ensure_not_member</a>&lt;DAOT: store&gt;(member_addr: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_ensure_not_member">ensure_not_member</a>&lt;DAOT: store&gt;(member_addr:<b>address</b>){
    <b>assert</b>!(!<a href="DAOSpace.md#0x1_DAOSpace_is_member">is_member</a>&lt;DAOT&gt;(member_addr), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_EXPECT_NOT_MEMBER">ERR_EXPECT_NOT_MEMBER</a>));
}
</code></pre>



</details>

<a name="0x1_DAOSpace_do_remove_member"></a>

## Function `do_remove_member`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_do_remove_member">do_remove_member</a>&lt;DAOT: store&gt;(member_addr: <b>address</b>): (u64, u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_do_remove_member">do_remove_member</a>&lt;DAOT: store&gt;(member_addr: <b>address</b>):(u64,u128) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTBurnCapHolder">DAONFTBurnCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOSBTBurnCapHolder">DAOSBTBurnCapHolder</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_ensure_member">ensure_member</a>&lt;DAOT&gt;(member_addr);
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();

    <b>let</b> nft_burn_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAONFTBurnCapHolder">DAONFTBurnCapHolder</a>&lt;DAOT&gt;&gt;(dao_address).cap;
    <b>let</b> nft = <a href="NFT.md#0x1_IdentifierNFT_revoke">IdentifierNFT::revoke</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;, <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt;&gt;(nft_burn_cap, member_addr);
    <b>let</b> member_id = <a href="NFT.md#0x1_NFT_get_type_meta">NFT::get_type_meta</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;, <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt;&gt;(&nft).id;
    <b>let</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt;{ sbt } = <a href="NFT.md#0x1_NFT_burn_with_cap">NFT::burn_with_cap</a>(nft_burn_cap, nft);
    <b>let</b> sbt_amount = <a href="Token.md#0x1_Token_value">Token::value</a>&lt;DAOT&gt;(&sbt);
    <b>let</b> token_burn_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOSBTBurnCapHolder">DAOSBTBurnCapHolder</a>&lt;DAOT&gt;&gt;(dao_address).cap;
    <a href="Token.md#0x1_Token_burn_with_capability">Token::burn_with_capability</a>(token_burn_cap, sbt);
    (member_id, sbt_amount)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_join_member_with_member_cap"></a>

## Function `join_member_with_member_cap`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_join_member_with_member_cap">join_member_with_member_cap</a>&lt;DAOT: store, Plugin&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOSpace::DAOMemberCap</a>&lt;DAOT, Plugin&gt;, sender: &signer, image_data: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, image_url: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, init_sbt: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_join_member_with_member_cap">join_member_with_member_cap</a>&lt;DAOT: store, Plugin&gt;(
    _cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOMemberCap</a>&lt;DAOT, Plugin&gt;,
    sender: &signer,
    image_data:<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;,
    image_url:<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;,
    init_sbt: u128
) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTMintCapHolder">DAONFTMintCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOSBTMintCapHolder">DAOSBTMintCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>, <a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> memeber_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a>&gt;(dao_address);
    <a href="DAOSpace.md#0x1_DAOSpace_do_join_member">do_join_member</a>&lt;DAOT&gt;(sender, image_data, image_url, init_sbt);
    <b>let</b> to_address = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_join_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_MemberJoinEvent">MemberJoinEvent</a> {
        dao_id: <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address),
        type:<a href="DAOSpace.md#0x1_DAOSpace_MEMBERJOIN_DIRECT">MEMBERJOIN_DIRECT</a>,
        member_id:<a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(<a href="DAOSpace.md#0x1_DAOSpace_query_member_id">query_member_id</a>&lt;DAOT&gt;(to_address)),
        addr:to_address,
        sbt: init_sbt,
    });
}
</code></pre>



</details>

<a name="0x1_DAOSpace_increase_member_sbt"></a>

## Function `increase_member_sbt`

Increment the member SBT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_increase_member_sbt">increase_member_sbt</a>&lt;DAOT: store, PluginT&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOSpace::DAOMemberCap</a>&lt;DAOT, PluginT&gt;, member_addr: <b>address</b>, amount: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_increase_member_sbt">increase_member_sbt</a>&lt;DAOT: store, PluginT&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOMemberCap</a>&lt;DAOT, PluginT&gt;, member_addr: <b>address</b>, amount: u128) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTUpdateCapHolder">DAONFTUpdateCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOSBTMintCapHolder">DAOSBTMintCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_ensure_member">ensure_member</a>&lt;DAOT&gt;(member_addr);
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();

    <b>let</b> nft_update_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAONFTUpdateCapHolder">DAONFTUpdateCapHolder</a>&lt;DAOT&gt;&gt;(dao_address).cap;
    <b>let</b> borrow_nft = <a href="NFT.md#0x1_IdentifierNFT_borrow_out">IdentifierNFT::borrow_out</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;, <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt;&gt;(nft_update_cap, member_addr);
    <b>let</b> nft = <a href="NFT.md#0x1_IdentifierNFT_borrow_nft_mut">IdentifierNFT::borrow_nft_mut</a>(&<b>mut</b> borrow_nft);
    <b>let</b> member_id = <a href="NFT.md#0x1_NFT_get_type_meta">NFT::get_type_meta</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;, <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt;&gt;(nft).id;

    <b>let</b> body = <a href="NFT.md#0x1_NFT_borrow_body_mut_with_cap">NFT::borrow_body_mut_with_cap</a>(nft_update_cap, nft);

    <b>let</b> token_mint_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOSBTMintCapHolder">DAOSBTMintCapHolder</a>&lt;DAOT&gt;&gt;(dao_address).cap;
    <b>let</b> increase_sbt = <a href="Token.md#0x1_Token_mint_with_capability">Token::mint_with_capability</a>&lt;DAOT&gt;(token_mint_cap, amount);
    <a href="Token.md#0x1_Token_deposit">Token::deposit</a>(&<b>mut</b> body.sbt, increase_sbt);

    <b>let</b> sbt_amount = <a href="Token.md#0x1_Token_value">Token::value</a>&lt;DAOT&gt;(&body.sbt);
    <a href="NFT.md#0x1_IdentifierNFT_return_back">IdentifierNFT::return_back</a>(borrow_nft);

    <b>let</b> memeber_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a>&gt;(dao_address);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_increase_sbt_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_MemberIncreaseSBTEvent">MemberIncreaseSBTEvent</a> {
        member_id,
        addr:member_addr,
        increase_sbt:amount,
        sbt: sbt_amount,
    });
}
</code></pre>



</details>

<a name="0x1_DAOSpace_decrease_member_sbt"></a>

## Function `decrease_member_sbt`

Decrement the member SBT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_decrease_member_sbt">decrease_member_sbt</a>&lt;DAOT: store, PluginT&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOSpace::DAOMemberCap</a>&lt;DAOT, PluginT&gt;, member_addr: <b>address</b>, amount: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_decrease_member_sbt">decrease_member_sbt</a>&lt;DAOT: store, PluginT&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOMemberCap</a>&lt;DAOT, PluginT&gt;, member_addr: <b>address</b>, amount: u128) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTUpdateCapHolder">DAONFTUpdateCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOSBTBurnCapHolder">DAOSBTBurnCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_ensure_member">ensure_member</a>&lt;DAOT&gt;(member_addr);
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();

    <b>let</b> nft_update_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAONFTUpdateCapHolder">DAONFTUpdateCapHolder</a>&lt;DAOT&gt;&gt;(dao_address).cap;
    <b>let</b> borrow_nft = <a href="NFT.md#0x1_IdentifierNFT_borrow_out">IdentifierNFT::borrow_out</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;, <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt;&gt;(nft_update_cap, member_addr);
    <b>let</b> nft = <a href="NFT.md#0x1_IdentifierNFT_borrow_nft_mut">IdentifierNFT::borrow_nft_mut</a>(&<b>mut</b> borrow_nft);
    <b>let</b> member_id = <a href="NFT.md#0x1_NFT_get_type_meta">NFT::get_type_meta</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;, <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt;&gt;(nft).id;

    <b>let</b> body = <a href="NFT.md#0x1_NFT_borrow_body_mut_with_cap">NFT::borrow_body_mut_with_cap</a>(nft_update_cap, nft);

    <b>let</b> token_burn_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOSBTBurnCapHolder">DAOSBTBurnCapHolder</a>&lt;DAOT&gt;&gt;(dao_address).cap;
    <b>let</b> decrease_sbt = <a href="Token.md#0x1_Token_withdraw">Token::withdraw</a>(&<b>mut</b> body.sbt, amount);
    <b>let</b> sbt_amount = <a href="Token.md#0x1_Token_value">Token::value</a>&lt;DAOT&gt;(&body.sbt);

    <a href="Token.md#0x1_Token_burn_with_capability">Token::burn_with_capability</a>(token_burn_cap, decrease_sbt);
    <a href="NFT.md#0x1_IdentifierNFT_return_back">IdentifierNFT::return_back</a>(borrow_nft);

    <b>let</b> memeber_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemberEvent">MemberEvent</a>&gt;(dao_address);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> memeber_event.member_decrease_sbt_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_MemberDecreaseSBTEvent">MemberDecreaseSBTEvent</a> {
        member_id,
        addr:member_addr,
        decrease_sbt:amount,
        sbt: sbt_amount,
    });
}
</code></pre>



</details>

<a name="0x1_DAOSpace_set_member_image"></a>

## Function `set_member_image`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_member_image">set_member_image</a>&lt;DAOT: store, PluginT&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOSpace::DAOMemberCap</a>&lt;DAOT, PluginT&gt;, member_addr: <b>address</b>, image_data: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, image_url: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_member_image">set_member_image</a>&lt;DAOT: store, PluginT&gt;(
    _cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOMemberCap</a>&lt;DAOT, PluginT&gt;,
    member_addr: <b>address</b>,
    image_data: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;,
    image_url: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;
) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTUpdateCapHolder">DAONFTUpdateCapHolder</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_ensure_member">ensure_member</a>&lt;DAOT&gt;(member_addr);

    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();

    <b>let</b> nft_update_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAONFTUpdateCapHolder">DAONFTUpdateCapHolder</a>&lt;DAOT&gt;&gt;(dao_address).cap;
    <b>let</b> borrow_nft = <a href="NFT.md#0x1_IdentifierNFT_borrow_out">IdentifierNFT::borrow_out</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;, <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt;&gt;(nft_update_cap, member_addr);
    <b>let</b> nft = <a href="NFT.md#0x1_IdentifierNFT_borrow_nft_mut">IdentifierNFT::borrow_nft_mut</a>(&<b>mut</b> borrow_nft);
    <b>let</b> metadata = *<a href="NFT.md#0x1_NFT_get_type_meta">NFT::get_type_meta</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;, <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt;&gt;(nft);
    <b>let</b> old_basemeta = <a href="NFT.md#0x1_NFT_get_base_meta">NFT::get_base_meta</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;, <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt;&gt;(nft);
    <b>let</b> new_basemeta = <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&image_data)){
        <a href="NFT.md#0x1_NFT_new_meta_with_image_data">NFT::new_meta_with_image_data</a>(<a href="NFT.md#0x1_NFT_meta_name">NFT::meta_name</a>(old_basemeta), <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(image_data), <a href="NFT.md#0x1_NFT_meta_description">NFT::meta_description</a>(old_basemeta))
    }<b>else</b> <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&image_url)){
        <a href="NFT.md#0x1_NFT_new_meta_with_image">NFT::new_meta_with_image</a>(<a href="NFT.md#0x1_NFT_meta_name">NFT::meta_name</a>(old_basemeta), <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(image_url), <a href="NFT.md#0x1_NFT_meta_description">NFT::meta_description</a>(old_basemeta))
    }<b>else</b>{
        <a href="NFT.md#0x1_NFT_new_meta">NFT::new_meta</a>(<a href="NFT.md#0x1_NFT_meta_name">NFT::meta_name</a>(old_basemeta), <a href="NFT.md#0x1_NFT_meta_description">NFT::meta_description</a>(old_basemeta))
    };
    <a href="NFT.md#0x1_NFT_update_meta_with_cap">NFT::update_meta_with_cap</a>(nft_update_cap, nft, new_basemeta, metadata);

    <a href="NFT.md#0x1_IdentifierNFT_return_back">IdentifierNFT::return_back</a>(borrow_nft);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_query_sbt"></a>

## Function `query_sbt`

Query amount of the member SBT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_sbt">query_sbt</a>&lt;DAOT: store&gt;(member_addr: <b>address</b>): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_sbt">query_sbt</a>&lt;DAOT: store&gt;(member_addr: <b>address</b>)
: u128 <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTUpdateCapHolder">DAONFTUpdateCapHolder</a> {
    <b>if</b> (!<a href="DAOSpace.md#0x1_DAOSpace_is_member">is_member</a>&lt;DAOT&gt;(member_addr)) {
        <b>return</b> 0
    };
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();

    <b>let</b> nft_update_cap =
        &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAONFTUpdateCapHolder">DAONFTUpdateCapHolder</a>&lt;DAOT&gt;&gt;(dao_address).cap;
    <b>let</b> borrow_nft =
        <a href="NFT.md#0x1_IdentifierNFT_borrow_out">IdentifierNFT::borrow_out</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;, <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt;&gt;(nft_update_cap, member_addr);
    <b>let</b> nft = <a href="NFT.md#0x1_IdentifierNFT_borrow_nft">IdentifierNFT::borrow_nft</a>(&<b>mut</b> borrow_nft);
    <b>let</b> body = <a href="NFT.md#0x1_NFT_borrow_body">NFT::borrow_body</a>(nft);

    <b>let</b> result = <a href="Token.md#0x1_Token_value">Token::value</a>(&body.sbt);
    <a href="NFT.md#0x1_IdentifierNFT_return_back">IdentifierNFT::return_back</a>(borrow_nft);
    result
}
</code></pre>



</details>

<a name="0x1_DAOSpace_query_member_id"></a>

## Function `query_member_id`

Query member id of the member


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_member_id">query_member_id</a>&lt;DAOT: store&gt;(member_addr: <b>address</b>): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_member_id">query_member_id</a>&lt;DAOT: store&gt;(member_addr: <b>address</b>): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;{
    <b>if</b>(!<a href="DAOSpace.md#0x1_DAOSpace_is_member">is_member</a>&lt;DAOT&gt;(member_addr)){
        <b>return</b> <a href="Option.md#0x1_Option_none">Option::none</a>&lt;u64&gt;()
    };
    <b>let</b> nft_info = <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(<a href="NFT.md#0x1_IdentifierNFT_get_nft_info">IdentifierNFT::get_nft_info</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;, <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt;&gt;(member_addr));
    <b>let</b> (_, _, _, type_meta) = <a href="NFT.md#0x1_NFT_unpack_info">NFT::unpack_info</a>(nft_info);
    <a href="Option.md#0x1_Option_some">Option::some</a>(type_meta.id)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_is_member"></a>

## Function `is_member`

Check the <code>member_addr</code> account is a member of DAOT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_is_member">is_member</a>&lt;DAOT: store&gt;(member_addr: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_is_member">is_member</a>&lt;DAOT: store&gt;(member_addr: <b>address</b>): bool {
    <a href="NFT.md#0x1_IdentifierNFT_owns">IdentifierNFT::owns</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;, <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberBody">DAOMemberBody</a>&lt;DAOT&gt;&gt;(member_addr)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_is_exist_member_offer"></a>

## Function `is_exist_member_offer`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_is_exist_member_offer">is_exist_member_offer</a>&lt;DAOT&gt;(member_addr: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_is_exist_member_offer">is_exist_member_offer</a>&lt;DAOT&gt;(member_addr: <b>address</b>):bool{
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&<a href="Offer.md#0x1_Offer_find_offer">Offer::find_offer</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MemeberOffer">MemeberOffer</a>&lt;DAOT&gt;&gt;(dao_address, member_addr))
}
</code></pre>



</details>

<a name="0x1_DAOSpace_init_plugin_event"></a>

## Function `init_plugin_event`

Plugin event


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_init_plugin_event">init_plugin_event</a>&lt;DAOT: store, PluginT: store, EventT: drop, store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOPluginEventCap">DAOSpace::DAOPluginEventCap</a>&lt;DAOT, PluginT&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_init_plugin_event">init_plugin_event</a>&lt;
    DAOT: store,
    PluginT: store,
    EventT: store + drop
&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOPluginEventCap">DAOPluginEventCap</a>&lt;DAOT, PluginT&gt;) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a> {
    <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
    <a href="EventUtil.md#0x1_EventUtil_init_event">EventUtil::init_event</a>&lt;EventT&gt;(&dao_signer);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_emit_plugin_event"></a>

## Function `emit_plugin_event`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_emit_plugin_event">emit_plugin_event</a>&lt;DAOT: store, PluginT: store, EventT: drop, store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOPluginEventCap">DAOSpace::DAOPluginEventCap</a>&lt;DAOT, PluginT&gt;, event: EventT)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_emit_plugin_event">emit_plugin_event</a>&lt;
    DAOT: store,
    PluginT: store,
    EventT: store + drop
&gt;(
    _cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOPluginEventCap">DAOPluginEventCap</a>&lt;DAOT, PluginT&gt;,
    event: EventT
) {
    <a href="EventUtil.md#0x1_EventUtil_emit_event">EventUtil::emit_event</a>(<a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;(), event);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_grant_accept_offer"></a>

## Function `grant_accept_offer`

Grant function
Accept grant offer by self


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_accept_offer">grant_accept_offer</a>&lt;DAOT, Plugin, TokenT: store&gt;(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_accept_offer">grant_accept_offer</a>&lt;DAOT, Plugin, TokenT:store&gt;(sender: &signer) {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> op_index = <a href="Offer.md#0x1_Offer_find_offer">Offer::find_offer</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(dao_address, <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender));
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&op_index),1003);
    <b>let</b> grant_key = <a href="Offer.md#0x1_Offer_redeem_v2">Offer::redeem_v2</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(sender, dao_address, <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(op_index));
    <b>move_to</b>(sender, grant_key)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_grant_accept_offer_entry"></a>

## Function `grant_accept_offer_entry`

Accept grant offer by self entry


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_accept_offer_entry">grant_accept_offer_entry</a>&lt;DAOT, Plugin, TokenT: store&gt;(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_accept_offer_entry">grant_accept_offer_entry</a>&lt;DAOT, Plugin, TokenT:store&gt;(sender: signer) {
    <a href="DAOSpace.md#0x1_DAOSpace_grant_accept_offer">grant_accept_offer</a>&lt;DAOT, Plugin, TokenT&gt;(&sender)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_grant_offer"></a>

## Function `grant_offer`

Grant offer and init/emit a event


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_offer">grant_offer</a>&lt;DAOT, Plugin, TokenT: store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantCap">DAOSpace::DAOGrantCap</a>&lt;DAOT&gt;, grantee: <b>address</b>, total: u128, start_time: u64, period: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_offer">grant_offer</a>&lt;DAOT, Plugin, TokenT:store&gt;(_cap:&<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantCap">DAOGrantCap</a>&lt;DAOT&gt;, grantee: <b>address</b>, total:u128, start_time:u64, period:u64) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> {
    <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();

    <b>if</b> (!<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>&gt;(dao_address)){
        <b>move_to</b>(&dao_signer, <a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>{
            create_grant_event_handler:<a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GrantCreateEvent">GrantCreateEvent</a>&gt;(&dao_signer),
            revoke_grant_event_handler:<a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GrantRevokeEvent">GrantRevokeEvent</a>&gt;(&dao_signer),
            withdraw_grant_event_handler:<a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GrantWithdrawEvent">GrantWithdrawEvent</a>&gt;(&dao_signer),
            refund_grant_event_handler:<a href="Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GrantRefundEvent">GrantRefundEvent</a>&gt;(&dao_signer),
        });
    };
    <b>let</b> grant_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>&gt;(dao_address);

    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> grant_event.create_grant_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_GrantCreateEvent">GrantCreateEvent</a> {
        dao_id:<a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address),
        grantee,
        total,
        start_time,
        period,
        now_time:<a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>(),
        plugin: <a href="TypeInfo.md#0x1_TypeInfo_type_of">TypeInfo::type_of</a>&lt;Plugin&gt;(),
        token: <a href="Token.md#0x1_Token_token_code">Token::token_code</a>&lt;TokenT&gt;()
    });

    <a href="Offer.md#0x1_Offer_create_v2">Offer::create_v2</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(
        &dao_signer,
        <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;{
            total,
            withdraw: 0 ,
            start_time,
            period
        },
        grantee,
        0
    );
}
</code></pre>



</details>

<a name="0x1_DAOSpace_grant_offer_refund"></a>

## Function `grant_offer_refund`

Grant offer refund


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_offer_refund">grant_offer_refund</a>&lt;DAOT, Plugin, TokenT: store&gt;(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_offer_refund">grant_offer_refund</a>&lt;DAOT, Plugin, TokenT:store&gt;(sender: &signer)<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
    <b>let</b> grantee = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>let</b> op_index = <a href="Offer.md#0x1_Offer_find_offer">Offer::find_offer</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(dao_address, grantee);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&op_index), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_OFFER_NOT_EXIST">ERR_OFFER_NOT_EXIST</a>));
    <b>let</b> grant_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>&gt;(dao_address);
    <b>let</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;{
        total,
        withdraw,
        start_time,
        period
    } = <a href="Offer.md#0x1_Offer_retake">Offer::retake</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(&dao_signer, <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(op_index));
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> grant_event.revoke_grant_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_GrantRevokeEvent">GrantRevokeEvent</a> {
        dao_id:<a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address),
        grantee,
        total,
        withdraw,
        start_time,
        period,
        plugin: <a href="TypeInfo.md#0x1_TypeInfo_type_of">TypeInfo::type_of</a>&lt;Plugin&gt;(),
        token: <a href="Token.md#0x1_Token_token_code">Token::token_code</a>&lt;TokenT&gt;()
    });
}
</code></pre>



</details>

<a name="0x1_DAOSpace_grant_offer_refund_entry"></a>

## Function `grant_offer_refund_entry`

Grant offer refund entry


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_offer_refund_entry">grant_offer_refund_entry</a>&lt;DAOT, Plugin, TokenT: store&gt;(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_offer_refund_entry">grant_offer_refund_entry</a>&lt;DAOT, Plugin, TokenT:store&gt;(sender: signer)<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>{
    <a href="DAOSpace.md#0x1_DAOSpace_grant_offer_refund">grant_offer_refund</a>&lt;DAOT, Plugin, TokenT&gt;(&sender);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_grant_withdraw_entry"></a>

## Function `grant_withdraw_entry`

Withdraw token with grant


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_withdraw_entry">grant_withdraw_entry</a>&lt;DAOT, Plugin, TokenT: store&gt;(sender: signer, amount: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_withdraw_entry">grant_withdraw_entry</a>&lt;DAOT, Plugin, TokenT:store&gt;(sender: signer, amount:u128) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>, <a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>{
    <a href="DAOSpace.md#0x1_DAOSpace_grant_withdraw">grant_withdraw</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>, Plugin, TokenT&gt;(&sender, amount);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_grant_withdraw"></a>

## Function `grant_withdraw`

Withdraw token with grant


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_withdraw">grant_withdraw</a>&lt;DAOT, Plugin, TokenT: store&gt;(sender: &signer, amount: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_withdraw">grant_withdraw</a>&lt;DAOT, Plugin, TokenT:store&gt;(sender: &signer, amount:u128) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>, <a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>{
    <b>let</b> account_address = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>assert</b>!(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(account_address) , <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_NOT_HAVE_GRANT">ERR_NOT_HAVE_GRANT</a>));

    <b>let</b> cap = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(account_address);
    <b>let</b> now = <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>();
    <b>let</b> elapsed_time = now - cap.start_time;
    <b>let</b> can_amount =  <b>if</b> (elapsed_time &gt;= cap.period) {
        cap.total - cap.withdraw
    } <b>else</b> {
        <a href="Math.md#0x1_Math_mul_div">Math::mul_div</a>(cap.total, (elapsed_time <b>as</b> u128), (cap.period <b>as</b> u128)) - cap.withdraw
    };

    <b>assert</b>!(can_amount &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_INVALID_AMOUNT">ERR_INVALID_AMOUNT</a>));
    <b>assert</b>!(can_amount &gt;= amount, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_INVALID_AMOUNT">ERR_INVALID_AMOUNT</a>));

    <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();

    <b>assert</b>!(amount &lt;= <a href="Account.md#0x1_Account_balance">Account::balance</a>&lt;TokenT&gt;(dao_address) , <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_INVALID_AMOUNT">ERR_INVALID_AMOUNT</a>));
    cap.withdraw = cap.withdraw + amount;

    <b>let</b> grant_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>&gt;(dao_address);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> grant_event.withdraw_grant_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_GrantWithdrawEvent">GrantWithdrawEvent</a> {
        dao_id:<a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address),
        grantee: account_address,
        total:cap.total,
        withdraw:cap.withdraw,
        start_time:cap.start_time,
        period:cap.period,
        withdraw_value:amount,
        plugin: <a href="TypeInfo.md#0x1_TypeInfo_type_of">TypeInfo::type_of</a>&lt;Plugin&gt;(),
        token: <a href="Token.md#0x1_Token_token_code">Token::token_code</a>&lt;TokenT&gt;()
    });
    <b>let</b> token = <a href="Account.md#0x1_Account_withdraw">Account::withdraw</a>&lt;TokenT&gt;(&dao_signer, amount);
    <a href="Account.md#0x1_Account_deposit">Account::deposit</a>&lt;TokenT&gt;(account_address, token);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_query_grant_withdrawable_amount"></a>

## Function `query_grant_withdrawable_amount`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_grant_withdrawable_amount">query_grant_withdrawable_amount</a>&lt;DAOT, Plugin, TokenT: store&gt;(addr: <b>address</b>): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_grant_withdrawable_amount">query_grant_withdrawable_amount</a>&lt;DAOT, Plugin, TokenT:store&gt;(addr: <b>address</b>):u128 <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>{
    <b>assert</b>!(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(addr) , <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_NOT_HAVE_GRANT">ERR_NOT_HAVE_GRANT</a>));
    <b>let</b> cap = <b>borrow_global</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(addr);
    <b>let</b> now = <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>();
    <b>let</b> elapsed_time = now - cap.start_time;
    <b>if</b> (elapsed_time &gt;= cap.period) {
        cap.total - cap.withdraw
    } <b>else</b> {
        <a href="Math.md#0x1_Math_mul_div">Math::mul_div</a>(cap.total, (elapsed_time <b>as</b> u128), (cap.period <b>as</b> u128)) - cap.withdraw
    }
}
</code></pre>



</details>

<a name="0x1_DAOSpace_is_exist_grant"></a>

## Function `is_exist_grant`

Is exist DAOGrantWithdrawTokenKey


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_is_exist_grant">is_exist_grant</a>&lt;DAOT, Plugin, TokenT: store&gt;(addr: <b>address</b>): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_is_exist_grant">is_exist_grant</a>&lt;DAOT, Plugin, TokenT:store&gt;(addr:<b>address</b>):bool{
    <b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(addr)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_grant_revoke"></a>

## Function `grant_revoke`

Revoke grant


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_revoke">grant_revoke</a>&lt;DAOT, Plugin, TokenT: store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantCap">DAOSpace::DAOGrantCap</a>&lt;DAOT&gt;, grantee: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_revoke">grant_revoke</a>&lt;DAOT, Plugin, TokenT:store&gt;(_cap:&<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantCap">DAOGrantCap</a>&lt;DAOT&gt;, grantee: <b>address</b> ) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>, <a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> grant_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>&gt;(dao_address);
    <b>if</b>(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(grantee)){
        <b>let</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;{
            total,
            withdraw,
            start_time,
            period
        } = <b>move_from</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(grantee);

        <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> grant_event.revoke_grant_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_GrantRevokeEvent">GrantRevokeEvent</a> {
            dao_id:<a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address),
            grantee,
            total,
            withdraw,
            start_time,
            period,
            plugin: <a href="TypeInfo.md#0x1_TypeInfo_type_of">TypeInfo::type_of</a>&lt;Plugin&gt;(),
            token: <a href="Token.md#0x1_Token_token_code">Token::token_code</a>&lt;TokenT&gt;()
        });
    };
}
</code></pre>



</details>

<a name="0x1_DAOSpace_grant_offer_revoke"></a>

## Function `grant_offer_revoke`

Revoke grant offer


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_offer_revoke">grant_offer_revoke</a>&lt;DAOT, Plugin, TokenT: store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantCap">DAOSpace::DAOGrantCap</a>&lt;DAOT&gt;, grantee: <b>address</b>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_grant_offer_revoke">grant_offer_revoke</a>&lt;DAOT, Plugin, TokenT:store&gt;(_cap:&<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantCap">DAOGrantCap</a>&lt;DAOT&gt;, grantee: <b>address</b> ) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a> {
    <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> grant_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>&gt;(dao_address);
    <b>let</b> op_index = <a href="Offer.md#0x1_Offer_find_offer">Offer::find_offer</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(dao_address, grantee);
    <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&op_index)) {
        <b>let</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt; {
            total,
            withdraw,
            start_time,
            period
        } = <a href="Offer.md#0x1_Offer_retake">Offer::retake</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(&dao_signer, <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(op_index));
        <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> grant_event.revoke_grant_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_GrantRevokeEvent">GrantRevokeEvent</a> {
            dao_id: <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address),
            grantee,
            total,
            withdraw,
            start_time,
            period,
            plugin: <a href="TypeInfo.md#0x1_TypeInfo_type_of">TypeInfo::type_of</a>&lt;Plugin&gt;(),
            token: <a href="Token.md#0x1_Token_token_code">Token::token_code</a>&lt;TokenT&gt;()
        });
    };
}
</code></pre>



</details>

<a name="0x1_DAOSpace_refund_grant"></a>

## Function `refund_grant`

Refund the grant


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_refund_grant">refund_grant</a>&lt;DAOT, Plugin, TokenT: store&gt;(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_refund_grant">refund_grant</a>&lt;DAOT, Plugin, TokenT:store&gt;(sender: &signer) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>, <a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> grantee = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>assert</b>!(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(grantee) , <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_NOT_HAVE_GRANT">ERR_NOT_HAVE_GRANT</a>));
    <b>let</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;{
        total:total,
        withdraw:withdraw,
        start_time:start_time,
        period:period
    } = <b>move_from</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(grantee);

    <b>let</b> grant_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>&gt;(dao_address);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> grant_event.refund_grant_event_handler, <a href="DAOSpace.md#0x1_DAOSpace_GrantRefundEvent">GrantRefundEvent</a> {
        dao_id:<a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address),
        grantee,
        total:total,
        withdraw:withdraw,
        start_time:start_time,
        period:period,
        plugin: <a href="TypeInfo.md#0x1_TypeInfo_type_of">TypeInfo::type_of</a>&lt;Plugin&gt;(),
        token: <a href="Token.md#0x1_Token_token_code">Token::token_code</a>&lt;TokenT&gt;()
    });
}
</code></pre>



</details>

<a name="0x1_DAOSpace_refund_grant_entry"></a>

## Function `refund_grant_entry`

Refund the grant entry


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_refund_grant_entry">refund_grant_entry</a>&lt;DAOT, Plugin, TokenT: store&gt;(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_refund_grant_entry">refund_grant_entry</a>&lt;DAOT, Plugin, TokenT:store&gt;(sender: signer) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>, <a href="DAOSpace.md#0x1_DAOSpace_GrantEvent">GrantEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_refund_grant">refund_grant</a>&lt;DAOT, Plugin, TokenT&gt;(&sender);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_query_grant"></a>

## Function `query_grant`

Query address grant


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_grant">query_grant</a>&lt;DAOT, Plugin, TokenT: store&gt;(addr: <b>address</b>): <a href="DAOSpace.md#0x1_DAOSpace_GrantInfo">DAOSpace::GrantInfo</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_grant">query_grant</a>&lt;DAOT, Plugin, TokenT:store&gt;(addr: <b>address</b>): <a href="DAOSpace.md#0x1_DAOSpace_GrantInfo">GrantInfo</a> <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>{
    <b>assert</b>!(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(addr) , <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_NOT_HAVE_GRANT">ERR_NOT_HAVE_GRANT</a>));
    <b>let</b> cap = <b>borrow_global</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOGrantWithdrawTokenKey">DAOGrantWithdrawTokenKey</a>&lt;DAOT, Plugin, TokenT&gt;&gt;(addr);
    <a href="DAOSpace.md#0x1_DAOSpace_GrantInfo">GrantInfo</a>{
        total        :   cap.total,
        grantee      :   addr,
        withdraw     :   cap.withdraw,
        start_time   :   cap.start_time,
        period       :   cap.period
    }
}
</code></pre>



</details>

<a name="0x1_DAOSpace_query_grant_info_total"></a>

## Function `query_grant_info_total`

Query grant info total


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_grant_info_total">query_grant_info_total</a>(grant_info: &<a href="DAOSpace.md#0x1_DAOSpace_GrantInfo">DAOSpace::GrantInfo</a>): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_grant_info_total">query_grant_info_total</a>(grant_info: &<a href="DAOSpace.md#0x1_DAOSpace_GrantInfo">GrantInfo</a>):u128{
    grant_info.total
}
</code></pre>



</details>

<a name="0x1_DAOSpace_query_grant_info_withdraw"></a>

## Function `query_grant_info_withdraw`

Query grant info withdraw


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_grant_info_withdraw">query_grant_info_withdraw</a>(grant_info: &<a href="DAOSpace.md#0x1_DAOSpace_GrantInfo">DAOSpace::GrantInfo</a>): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_grant_info_withdraw">query_grant_info_withdraw</a>(grant_info: &<a href="DAOSpace.md#0x1_DAOSpace_GrantInfo">GrantInfo</a>):u128{
    grant_info.withdraw
}
</code></pre>



</details>

<a name="0x1_DAOSpace_query_grant_info_start_time"></a>

## Function `query_grant_info_start_time`

Query grant info start_time


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_grant_info_start_time">query_grant_info_start_time</a>(grant_info: &<a href="DAOSpace.md#0x1_DAOSpace_GrantInfo">DAOSpace::GrantInfo</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_grant_info_start_time">query_grant_info_start_time</a>(grant_info: &<a href="DAOSpace.md#0x1_DAOSpace_GrantInfo">GrantInfo</a>):u64{
    grant_info.start_time
}
</code></pre>



</details>

<a name="0x1_DAOSpace_query_grant_info_period"></a>

## Function `query_grant_info_period`

Query grant info period


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_grant_info_period">query_grant_info_period</a>(grant_info: &<a href="DAOSpace.md#0x1_DAOSpace_GrantInfo">DAOSpace::GrantInfo</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_query_grant_info_period">query_grant_info_period</a>(grant_info: &<a href="DAOSpace.md#0x1_DAOSpace_GrantInfo">GrantInfo</a>):u64{
    grant_info.period
}
</code></pre>



</details>

<a name="0x1_DAOSpace_validate_cap"></a>

## Function `validate_cap`

Acquiring Capabilities


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_validate_cap">validate_cap</a>&lt;DAOT: store, PluginT&gt;(cap: <a href="DAOSpace.md#0x1_DAOSpace_CapType">DAOSpace::CapType</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_validate_cap">validate_cap</a>&lt;DAOT: store, PluginT&gt;(cap: <a href="DAOSpace.md#0x1_DAOSpace_CapType">CapType</a>) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a> {
    <b>let</b> addr = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    // When create a new <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>, one can pass a `DAOT` type <b>as</b> the `PluginT` type,
    // in this case, the signer is equal <b>to</b> have the root cap.
    <b>if</b> (<a href="TypeInfo.md#0x1_TypeInfo_type_of">TypeInfo::type_of</a>&lt;DAOT&gt;() != <a href="TypeInfo.md#0x1_TypeInfo_type_of">TypeInfo::type_of</a>&lt;PluginT&gt;()) {
        <b>if</b> (<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a>&lt;PluginT&gt;&gt;(addr)) {
            <b>let</b> plugin_info = <b>borrow_global</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a>&lt;PluginT&gt;&gt;(addr);
            <b>assert</b>!(<a href="Vector.md#0x1_Vector_contains">Vector::contains</a>(&plugin_info.granted_caps, &cap), <a href="Errors.md#0x1_Errors_requires_capability">Errors::requires_capability</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_NO_GRANTED">ERR_NO_GRANTED</a>));
        } <b>else</b> {
            <b>abort</b> (<a href="Errors.md#0x1_Errors_requires_capability">Errors::requires_capability</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_NO_GRANTED">ERR_NO_GRANTED</a>))
        }
    }
}
</code></pre>



</details>

<a name="0x1_DAOSpace_acquire_install_plugin_cap"></a>

## Function `acquire_install_plugin_cap`

Acquire the installed plugin capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_install_plugin_cap">acquire_install_plugin_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOInstallPluginCap">DAOSpace::DAOInstallPluginCap</a>&lt;DAOT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_install_plugin_cap">acquire_install_plugin_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOInstallPluginCap">DAOInstallPluginCap</a>&lt;DAOT, PluginT&gt; <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_validate_cap">validate_cap</a>&lt;DAOT, PluginT&gt;(<a href="DAOSpace.md#0x1_DAOSpace_install_plugin_cap_type">install_plugin_cap_type</a>());
    <a href="DAOSpace.md#0x1_DAOSpace_DAOInstallPluginCap">DAOInstallPluginCap</a>&lt;DAOT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_DAOSpace_acquire_upgrade_module_cap"></a>

## Function `acquire_upgrade_module_cap`

Acquire the upgrade module capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_upgrade_module_cap">acquire_upgrade_module_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOUpgradeModuleCap">DAOSpace::DAOUpgradeModuleCap</a>&lt;DAOT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_upgrade_module_cap">acquire_upgrade_module_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOUpgradeModuleCap">DAOUpgradeModuleCap</a>&lt;DAOT, PluginT&gt; <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_validate_cap">validate_cap</a>&lt;DAOT, PluginT&gt;(<a href="DAOSpace.md#0x1_DAOSpace_upgrade_module_cap_type">upgrade_module_cap_type</a>());
    <a href="DAOSpace.md#0x1_DAOSpace_DAOUpgradeModuleCap">DAOUpgradeModuleCap</a>&lt;DAOT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_DAOSpace_acquire_modify_config_cap"></a>

## Function `acquire_modify_config_cap`

Acquire the modify config capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_modify_config_cap">acquire_modify_config_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOModifyConfigCap">DAOSpace::DAOModifyConfigCap</a>&lt;DAOT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_modify_config_cap">acquire_modify_config_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOModifyConfigCap">DAOModifyConfigCap</a>&lt;DAOT, PluginT&gt; <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_validate_cap">validate_cap</a>&lt;DAOT, PluginT&gt;(<a href="DAOSpace.md#0x1_DAOSpace_modify_config_cap_type">modify_config_cap_type</a>());
    <a href="DAOSpace.md#0x1_DAOSpace_DAOModifyConfigCap">DAOModifyConfigCap</a>&lt;DAOT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_DAOSpace_acquire_withdraw_token_cap"></a>

## Function `acquire_withdraw_token_cap`

Acquires the withdraw Token capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_withdraw_token_cap">acquire_withdraw_token_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOWithdrawTokenCap">DAOSpace::DAOWithdrawTokenCap</a>&lt;DAOT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_withdraw_token_cap">acquire_withdraw_token_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOWithdrawTokenCap">DAOWithdrawTokenCap</a>&lt;DAOT, PluginT&gt; <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_validate_cap">validate_cap</a>&lt;DAOT, PluginT&gt;(<a href="DAOSpace.md#0x1_DAOSpace_withdraw_token_cap_type">withdraw_token_cap_type</a>());
    <a href="DAOSpace.md#0x1_DAOSpace_DAOWithdrawTokenCap">DAOWithdrawTokenCap</a>&lt;DAOT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_DAOSpace_acquire_withdraw_nft_cap"></a>

## Function `acquire_withdraw_nft_cap`

Acquires the withdraw NFT capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_withdraw_nft_cap">acquire_withdraw_nft_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOWithdrawNFTCap">DAOSpace::DAOWithdrawNFTCap</a>&lt;DAOT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_withdraw_nft_cap">acquire_withdraw_nft_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOWithdrawNFTCap">DAOWithdrawNFTCap</a>&lt;DAOT, PluginT&gt; <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_validate_cap">validate_cap</a>&lt;DAOT, PluginT&gt;(<a href="DAOSpace.md#0x1_DAOSpace_withdraw_nft_cap_type">withdraw_nft_cap_type</a>());
    <a href="DAOSpace.md#0x1_DAOSpace_DAOWithdrawNFTCap">DAOWithdrawNFTCap</a>&lt;DAOT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_DAOSpace_acquire_storage_cap"></a>

## Function `acquire_storage_cap`

Acquires the storage capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_storage_cap">acquire_storage_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOStorageCap">DAOSpace::DAOStorageCap</a>&lt;DAOT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_storage_cap">acquire_storage_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOStorageCap">DAOStorageCap</a>&lt;DAOT, PluginT&gt; <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_validate_cap">validate_cap</a>&lt;DAOT, PluginT&gt;(<a href="DAOSpace.md#0x1_DAOSpace_storage_cap_type">storage_cap_type</a>());
    <a href="DAOSpace.md#0x1_DAOSpace_DAOStorageCap">DAOStorageCap</a>&lt;DAOT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_DAOSpace_acquire_member_cap"></a>

## Function `acquire_member_cap`

Acquires the membership capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_member_cap">acquire_member_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOSpace::DAOMemberCap</a>&lt;DAOT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_member_cap">acquire_member_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOMemberCap</a>&lt;DAOT, PluginT&gt; <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_validate_cap">validate_cap</a>&lt;DAOT, PluginT&gt;(<a href="DAOSpace.md#0x1_DAOSpace_member_cap_type">member_cap_type</a>());
    <a href="DAOSpace.md#0x1_DAOSpace_DAOMemberCap">DAOMemberCap</a>&lt;DAOT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_DAOSpace_acquire_proposal_cap"></a>

## Function `acquire_proposal_cap`

Acquire the proposql capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">acquire_proposal_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOProposalCap">DAOSpace::DAOProposalCap</a>&lt;DAOT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_proposal_cap">acquire_proposal_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOProposalCap">DAOProposalCap</a>&lt;DAOT, PluginT&gt; <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_validate_cap">validate_cap</a>&lt;DAOT, PluginT&gt;(<a href="DAOSpace.md#0x1_DAOSpace_proposal_cap_type">proposal_cap_type</a>());
    <a href="DAOSpace.md#0x1_DAOSpace_DAOProposalCap">DAOProposalCap</a>&lt;DAOT, PluginT&gt;{}
}
</code></pre>



</details>

<a name="0x1_DAOSpace_acquire_grant_cap"></a>

## Function `acquire_grant_cap`

Acquire the grant capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_grant_cap">acquire_grant_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantCap">DAOSpace::DAOGrantCap</a>&lt;DAOT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_grant_cap">acquire_grant_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantCap">DAOGrantCap</a>&lt;DAOT&gt; <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_validate_cap">validate_cap</a>&lt;DAOT, PluginT&gt;(<a href="DAOSpace.md#0x1_DAOSpace_grant_cap_type">grant_cap_type</a>());
    <a href="DAOSpace.md#0x1_DAOSpace_DAOGrantCap">DAOGrantCap</a>&lt;DAOT&gt;{}
}
</code></pre>



</details>

<a name="0x1_DAOSpace_acquire_plugin_event_cap"></a>

## Function `acquire_plugin_event_cap`

Acquire the plugin event capability
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_plugin_event_cap">acquire_plugin_event_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOPluginEventCap">DAOSpace::DAOPluginEventCap</a>&lt;DAOT, PluginT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_acquire_plugin_event_cap">acquire_plugin_event_cap</a>&lt;DAOT: store, PluginT&gt;(_witness: &PluginT): <a href="DAOSpace.md#0x1_DAOSpace_DAOPluginEventCap">DAOPluginEventCap</a>&lt;DAOT, PluginT&gt; <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_validate_cap">validate_cap</a>&lt;DAOT, PluginT&gt;(<a href="DAOSpace.md#0x1_DAOSpace_plugin_event_cap_type">plugin_event_cap_type</a>());
    <a href="DAOSpace.md#0x1_DAOSpace_DAOPluginEventCap">DAOPluginEventCap</a>&lt;DAOT, PluginT&gt; {}
}
</code></pre>



</details>

<a name="0x1_DAOSpace_delegate_token_mint_cap"></a>

## Function `delegate_token_mint_cap`

Delegate the token mint capability to DAO
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_delegate_token_mint_cap">delegate_token_mint_cap</a>&lt;DAOT: store, PluginT, TokenT: store&gt;(cap: <a href="Token.md#0x1_Token_MintCapability">Token::MintCapability</a>&lt;TokenT&gt;, _witness: &PluginT)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_delegate_token_mint_cap">delegate_token_mint_cap</a>&lt;DAOT: store, PluginT, TokenT: store&gt;(cap: <a href="Token.md#0x1_Token_MintCapability">Token::MintCapability</a>&lt;TokenT&gt;, _witness: &PluginT)
<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a> {
    <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
    <b>move_to</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOTokenMintCapHolder">DAOTokenMintCapHolder</a>&lt;DAOT, TokenT&gt;&gt;(
        &dao_signer,
        <a href="DAOSpace.md#0x1_DAOSpace_DAOTokenMintCapHolder">DAOTokenMintCapHolder</a>&lt;DAOT, TokenT&gt; { cap },
    );
}
</code></pre>



</details>

<a name="0x1_DAOSpace_delegate_token_burn_cap"></a>

## Function `delegate_token_burn_cap`

Delegate the token burn capability to DAO
_witness parameter ensures that the caller is the module which define PluginT


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_delegate_token_burn_cap">delegate_token_burn_cap</a>&lt;DAOT: store, PluginT, TokenT: store&gt;(cap: <a href="Token.md#0x1_Token_BurnCapability">Token::BurnCapability</a>&lt;TokenT&gt;, _witness: &PluginT)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_delegate_token_burn_cap">delegate_token_burn_cap</a>&lt;DAOT: store, PluginT, TokenT: store&gt;(cap: <a href="Token.md#0x1_Token_BurnCapability">Token::BurnCapability</a>&lt;TokenT&gt;, _witness: &PluginT)
<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a> {
    <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
    <b>move_to</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOTokenBurnCapHolder">DAOTokenBurnCapHolder</a>&lt;DAOT, TokenT&gt;&gt;(
        &dao_signer,
        <a href="DAOSpace.md#0x1_DAOSpace_DAOTokenBurnCapHolder">DAOTokenBurnCapHolder</a>&lt;DAOT, TokenT&gt; { cap },
    );
}
</code></pre>



</details>

<a name="0x1_DAOSpace_mint_token"></a>

## Function `mint_token`

Mint token


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_mint_token">mint_token</a>&lt;DAOT: store, PluginT, TokenT: store&gt;(amount: u128, _witness: &PluginT): <a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenT&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_mint_token">mint_token</a>&lt;DAOT: store, PluginT, TokenT: store&gt;(amount: u128, _witness: &PluginT): <a href="Token.md#0x1_Token">Token</a>&lt;TokenT&gt;
<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOTokenMintCapHolder">DAOTokenMintCapHolder</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_validate_cap">validate_cap</a>&lt;DAOT, PluginT&gt;(<a href="DAOSpace.md#0x1_DAOSpace_token_mint_cap_type">token_mint_cap_type</a>());
    <b>let</b> dao_addr = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>assert</b>!(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOTokenMintCapHolder">DAOTokenMintCapHolder</a>&lt;DAOT, TokenT&gt;&gt;(dao_addr), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_TOKEN_ERROR">ERR_TOKEN_ERROR</a>));
    <b>let</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOTokenMintCapHolder">DAOTokenMintCapHolder</a>&lt;DAOT, TokenT&gt; { cap } =
        <b>borrow_global</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOTokenMintCapHolder">DAOTokenMintCapHolder</a>&lt;DAOT, TokenT&gt;&gt;(dao_addr);
    <b>let</b> tokens = <a href="Token.md#0x1_Token_mint_with_capability">Token::mint_with_capability</a>&lt;TokenT&gt;(cap, amount);
    tokens
}
</code></pre>



</details>

<a name="0x1_DAOSpace_burn_token"></a>

## Function `burn_token`

Burn token


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_burn_token">burn_token</a>&lt;DAOT: store, PluginT, TokenT: store&gt;(tokens: <a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;TokenT&gt;, _witness: &PluginT)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_burn_token">burn_token</a>&lt;DAOT: store, PluginT, TokenT: store&gt;(tokens: <a href="Token.md#0x1_Token">Token</a>&lt;TokenT&gt;, _witness: &PluginT)
<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_InstalledPluginInfo">InstalledPluginInfo</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOTokenBurnCapHolder">DAOTokenBurnCapHolder</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_validate_cap">validate_cap</a>&lt;DAOT, PluginT&gt;(<a href="DAOSpace.md#0x1_DAOSpace_token_burn_cap_type">token_burn_cap_type</a>());
    <b>let</b> dao_addr = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>assert</b>!(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOTokenBurnCapHolder">DAOTokenBurnCapHolder</a>&lt;DAOT, TokenT&gt;&gt;(dao_addr), <a href="Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_TOKEN_ERROR">ERR_TOKEN_ERROR</a>));
    <b>let</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOTokenBurnCapHolder">DAOTokenBurnCapHolder</a>&lt;DAOT, TokenT&gt; { cap } =
        <b>borrow_global</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOTokenBurnCapHolder">DAOTokenBurnCapHolder</a>&lt;DAOT, TokenT&gt;&gt;(dao_addr);
    <a href="Token.md#0x1_Token_burn_with_capability">Token::burn_with_capability</a>&lt;TokenT&gt;(cap, tokens);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_choice_yes"></a>

## Function `choice_yes`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_choice_yes">choice_yes</a>(): <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">DAOSpace::VotingChoice</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_choice_yes">choice_yes</a>(): <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">VotingChoice</a> { <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">VotingChoice</a>{ choice: <a href="DAOSpace.md#0x1_DAOSpace_VOTING_CHOICE_YES">VOTING_CHOICE_YES</a> } }
</code></pre>



</details>

<a name="0x1_DAOSpace_choice_no"></a>

## Function `choice_no`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_choice_no">choice_no</a>(): <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">DAOSpace::VotingChoice</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_choice_no">choice_no</a>(): <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">VotingChoice</a> { <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">VotingChoice</a>{ choice: <a href="DAOSpace.md#0x1_DAOSpace_VOTING_CHOICE_NO">VOTING_CHOICE_NO</a> } }
</code></pre>



</details>

<a name="0x1_DAOSpace_choice_no_with_veto"></a>

## Function `choice_no_with_veto`

no_with_veto counts as no but also adds a veto vote


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_choice_no_with_veto">choice_no_with_veto</a>(): <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">DAOSpace::VotingChoice</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_choice_no_with_veto">choice_no_with_veto</a>(): <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">VotingChoice</a> { <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">VotingChoice</a>{ choice: <a href="DAOSpace.md#0x1_DAOSpace_VOTING_CHOICE_NO_WITH_VETO">VOTING_CHOICE_NO_WITH_VETO</a> } }
</code></pre>



</details>

<a name="0x1_DAOSpace_choice_abstain"></a>

## Function `choice_abstain`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_choice_abstain">choice_abstain</a>(): <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">DAOSpace::VotingChoice</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_choice_abstain">choice_abstain</a>(): <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">VotingChoice</a> { <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">VotingChoice</a>{ choice: <a href="DAOSpace.md#0x1_DAOSpace_VOTING_CHOICE_ABSTAIN">VOTING_CHOICE_ABSTAIN</a> } }
</code></pre>



</details>

<a name="0x1_DAOSpace_create_proposal"></a>

## Function `create_proposal`

propose a proposal.
<code>action</code>: the actual action to execute.
<code>action_delay</code>: the delay to execute after the proposal is agreed
<code>quorum_scale_factor</code>: used to scale up the base quorum_votes_rate.
The final quorum_votes_rate = (1.0 + scale / 100) * quorum_votes_rate


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_create_proposal">create_proposal</a>&lt;DAOT: store, PluginT, ActionT: drop, store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOProposalCap">DAOSpace::DAOProposalCap</a>&lt;DAOT, PluginT&gt;, sender: &signer, action: ActionT, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, extend: vector&lt;u8&gt;, action_delay: u64, quorum_scale_factor: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u8&gt;): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_create_proposal">create_proposal</a>&lt;DAOT: store, PluginT, ActionT: store+drop&gt;(
    _cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOProposalCap">DAOProposalCap</a>&lt;DAOT, PluginT&gt;,
    sender: &signer,
    action: ActionT,
    title: vector&lt;u8&gt;,
    introduction: vector&lt;u8&gt;,
    extend: vector&lt;u8&gt;,
    action_delay: u64,
    quorum_scale_factor: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u8&gt;,
): u64 <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_ProposalActions">ProposalActions</a>, <a href="DAOSpace.md#0x1_DAOSpace_ProposalEvent">ProposalEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a> {
    // check <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> member
    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <a href="DAOSpace.md#0x1_DAOSpace_ensure_member">ensure_member</a>&lt;DAOT&gt;(sender_addr);

    <b>if</b> (action_delay == 0) {
        action_delay = <a href="DAOSpace.md#0x1_DAOSpace_min_action_delay">min_action_delay</a>&lt;DAOT&gt;();
    } <b>else</b> {
        <b>assert</b>!(action_delay &gt;= <a href="DAOSpace.md#0x1_DAOSpace_min_action_delay">min_action_delay</a>&lt;DAOT&gt;(), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_ACTION_DELAY_TOO_SMALL">ERR_ACTION_DELAY_TOO_SMALL</a>));
    };

    <b>let</b> min_proposal_deposit = <a href="DAOSpace.md#0x1_DAOSpace_min_proposal_deposit">min_proposal_deposit</a>&lt;DAOT&gt;();
    <b>let</b> deposit = <a href="Account.md#0x1_Account_withdraw">Account::withdraw</a>&lt;<a href="STC.md#0x1_STC">STC</a>&gt;(sender, min_proposal_deposit);

    <b>let</b> proposal_id = <a href="DAOSpace.md#0x1_DAOSpace_next_proposal_id">next_proposal_id</a>&lt;DAOT&gt;();
    <b>let</b> proposer = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>let</b> start_time = <a href="Timestamp.md#0x1_Timestamp_now_milliseconds">Timestamp::now_milliseconds</a>() + <a href="DAOSpace.md#0x1_DAOSpace_voting_delay">voting_delay</a>&lt;DAOT&gt;();
    <b>let</b> quorum_votes = <a href="DAOSpace.md#0x1_DAOSpace_quorum_votes">quorum_votes</a>&lt;DAOT&gt;(quorum_scale_factor);
    <b>let</b> voting_period = <a href="DAOSpace.md#0x1_DAOSpace_voting_period">voting_period</a>&lt;DAOT&gt;();

    <b>let</b> (block_number,state_root) = <a href="DAOSpace.md#0x1_DAOSpace_block_number_and_state_root">block_number_and_state_root</a>();

    <b>let</b> proposal = <a href="DAOSpace.md#0x1_DAOSpace_Proposal">Proposal</a> {
        id: proposal_id,
        proposer,
        title: <b>copy</b> title,
        introduction: <b>copy</b> introduction,
        extend: <b>copy</b> extend,
        start_time,
        end_time: start_time + voting_period,
        yes_votes: 0,
        no_votes: 0,
        abstain_votes: 0,
        no_with_veto_votes: 0,
        eta: 0,
        action_delay,
        quorum_votes,
        block_number,
        state_root,
    };
    <b>let</b> proposal_action = <a href="DAOSpace.md#0x1_DAOSpace_ProposalAction">ProposalAction</a>{
        proposal_id,
        deposit,
        action,
    };
    <b>let</b> proposal_action_index = <a href="DAOSpace.md#0x1_DAOSpace_ProposalActionIndex">ProposalActionIndex</a>{
        proposal_id,
    };

    <b>let</b> dao_signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();

    <b>let</b> actions = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(proposal_action);
    // check <a href="DAOSpace.md#0x1_DAOSpace_ProposalActions">ProposalActions</a> is <b>exists</b>
    <b>if</b>(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalActions">ProposalActions</a>&lt;ActionT&gt;&gt;(dao_address)){
        <b>let</b> current_actions = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalActions">ProposalActions</a>&lt;ActionT&gt;&gt;(dao_address);
        <b>assert</b>!(<a href="Vector.md#0x1_Vector_length">Vector::length</a>(&current_actions.actions) &lt; <a href="DAOSpace.md#0x1_DAOSpace_MAX_PROPOSALS">MAX_PROPOSALS</a>, <a href="Errors.md#0x1_Errors_limit_exceeded">Errors::limit_exceeded</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_OUT_OF_LIMIT">ERR_PROPOSAL_OUT_OF_LIMIT</a>));
        <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> current_actions.actions, actions);
    }<b>else</b>{
        <b>move_to</b>(&dao_signer, <a href="DAOSpace.md#0x1_DAOSpace_ProposalActions">ProposalActions</a>&lt;ActionT&gt;{
            actions,
        });
    };

    <b>let</b> proposal_action_indexs = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(proposal_action_index);
    // check <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a> is <b>exists</b>
    <b>if</b>(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a>&gt;(dao_address)){
        <b>let</b> current_global_proposal_actions = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a>&gt;(dao_address);
        <b>assert</b>!(<a href="Vector.md#0x1_Vector_length">Vector::length</a>(&current_global_proposal_actions.proposal_action_indexs) &lt; <a href="DAOSpace.md#0x1_DAOSpace_MAX_PROPOSALS">MAX_PROPOSALS</a>,
            <a href="Errors.md#0x1_Errors_limit_exceeded">Errors::limit_exceeded</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_OUT_OF_LIMIT">ERR_PROPOSAL_OUT_OF_LIMIT</a>));
        <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> current_global_proposal_actions.proposal_action_indexs, proposal_action_indexs);
    }<b>else</b>{
        <b>move_to</b>(&dao_signer, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a>{
            proposal_action_indexs,
        });
    };

    <b>let</b> proposals = <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(proposal);
    // check <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a> is <b>exists</b>
    <b>if</b>(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>&gt;(dao_address)){
        <b>let</b> current_global_proposals = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>&gt;(dao_address);
        <b>assert</b>!(<a href="Vector.md#0x1_Vector_length">Vector::length</a>(&current_global_proposals.proposals) &lt; <a href="DAOSpace.md#0x1_DAOSpace_MAX_PROPOSALS">MAX_PROPOSALS</a>,
            <a href="Errors.md#0x1_Errors_limit_exceeded">Errors::limit_exceeded</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_OUT_OF_LIMIT">ERR_PROPOSAL_OUT_OF_LIMIT</a>));
        <a href="Vector.md#0x1_Vector_append">Vector::append</a>(&<b>mut</b> current_global_proposals.proposals, proposals);
    }<b>else</b>{
        <b>move_to</b>(&dao_signer, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>{
            proposals,
        });
    };

    // emit event
    <b>let</b> dao_id = <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address);
    <b>let</b> proposal_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalEvent">ProposalEvent</a>&lt;DAOT&gt;&gt;(dao_address);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> proposal_event.proposal_create_event,
        <a href="DAOSpace.md#0x1_DAOSpace_ProposalCreatedEvent">ProposalCreatedEvent</a> { dao_id, proposal_id, title,  introduction: <b>copy</b> introduction, extend: <b>copy</b> extend, proposer },
    );

    proposal_id
}
</code></pre>



</details>

<a name="0x1_DAOSpace_block_number_and_state_root"></a>

## Function `block_number_and_state_root`

get lastest block number and state root


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_block_number_and_state_root">block_number_and_state_root</a>(): (u64, vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_block_number_and_state_root">block_number_and_state_root</a>(): (u64, vector&lt;u8&gt;) {
    <a href="Block.md#0x1_Block_latest_state_root">Block::latest_state_root</a>()
}
</code></pre>



</details>

<a name="0x1_DAOSpace_cast_vote"></a>

## Function `cast_vote`

votes for a proposal.
User can only vote once, then the stake is locked,
The voting power depends on the strategy of the proposal configuration and the user's token amount at the time of the snapshot


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_cast_vote">cast_vote</a>&lt;DAOT: store&gt;(sender: &signer, proposal_id: u64, snpashot_raw_proofs: vector&lt;u8&gt;, choice: <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">DAOSpace::VotingChoice</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_cast_vote">cast_vote</a>&lt;DAOT: store&gt;(
    sender: &signer,
    proposal_id: u64,
    snpashot_raw_proofs: vector&lt;u8&gt;,
    choice: <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">VotingChoice</a>,
)  <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>, <a href="DAOSpace.md#0x1_DAOSpace_MyVotes">MyVotes</a>, <a href="DAOSpace.md#0x1_DAOSpace_ProposalEvent">ProposalEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> {
    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <a href="DAOSpace.md#0x1_DAOSpace_ensure_member">ensure_member</a>&lt;DAOT&gt;(sender_addr);

    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> proposals = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>&gt;(dao_address);
    <b>let</b> proposal = <a href="DAOSpace.md#0x1_DAOSpace_borrow_proposal_mut">borrow_proposal_mut</a>(proposals, proposal_id);

    {
        <b>let</b> state = <a href="DAOSpace.md#0x1_DAOSpace_proposal_state_with_proposal">proposal_state_with_proposal</a>&lt;DAOT&gt;(proposal);
        // only when proposal is active, <b>use</b> can cast vote.
        <b>assert</b>!(state == <a href="DAOSpace.md#0x1_DAOSpace_ACTIVE">ACTIVE</a>, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_STATE_INVALID">ERR_PROPOSAL_STATE_INVALID</a>));
    };

    // verify snapshot state proof
    <b>let</b> snapshot_proof = <a href="DAOSpace.md#0x1_DAOSpace_deserialize_snapshot_proofs">deserialize_snapshot_proofs</a>(&snpashot_raw_proofs);
    <b>let</b> state_proof = <a href="DAOSpace.md#0x1_DAOSpace_new_state_proof_from_proofs">new_state_proof_from_proofs</a>(&snapshot_proof);
    <b>let</b> resource_struct_tag = <a href="SnapshotUtil.md#0x1_SnapshotUtil_get_sturct_tag">SnapshotUtil::get_sturct_tag</a>&lt;DAOT&gt;();
    // verify state_proof according <b>to</b> proposal snapshot proofs, and state root
    <b>let</b> verify = <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_verify_state_proof">StarcoinVerifier::verify_state_proof</a>(&state_proof, &proposal.state_root, sender_addr, &resource_struct_tag, &snapshot_proof.state);
    <b>assert</b>!(verify, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_STATE_PROOF_VERIFY_INVALID">ERR_STATE_PROOF_VERIFY_INVALID</a>));

    // decode sbt value from snapshot state
    <b>let</b> vote_weight = <a href="SBTVoteStrategy.md#0x1_SBTVoteStrategy_get_voting_power">SBTVoteStrategy::get_voting_power</a>(&snapshot_proof.state);

    <b>assert</b>!(!<a href="DAOSpace.md#0x1_DAOSpace_has_voted">has_voted</a>&lt;DAOT&gt;(sender_addr, proposal_id), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_VOTED_ALREADY">ERR_VOTED_ALREADY</a>));

    <b>let</b> vote = <a href="DAOSpace.md#0x1_DAOSpace_Vote">Vote</a>{
        proposal_id,
        vote_weight,
        choice: choice.choice,
    };

    <a href="DAOSpace.md#0x1_DAOSpace_do_cast_vote">do_cast_vote</a>(proposal, &<b>mut</b> vote);

    <b>if</b> (<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MyVotes">MyVotes</a>&lt;DAOT&gt;&gt;(sender_addr)) {
        <b>assert</b>!(vote.proposal_id == proposal_id, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_VOTED_OTHERS_ALREADY">ERR_VOTED_OTHERS_ALREADY</a>));
        <b>let</b> my_votes = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MyVotes">MyVotes</a>&lt;DAOT&gt;&gt;(sender_addr);
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> my_votes.votes, vote);
    } <b>else</b> {
        <b>move_to</b>(sender, <a href="DAOSpace.md#0x1_DAOSpace_MyVotes">MyVotes</a>&lt;DAOT&gt;{
            votes: <a href="Vector.md#0x1_Vector_singleton">Vector::singleton</a>(vote),
        });
    };

    // emit event
    <b>let</b> dao_id = <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address);
    <b>let</b> proposal_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalEvent">ProposalEvent</a>&lt;DAOT&gt; &gt;(<a href="DAORegistry.md#0x1_DAORegistry_dao_address">DAORegistry::dao_address</a>&lt;DAOT&gt;());
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> proposal_event.vote_event,
        <a href="DAOSpace.md#0x1_DAOSpace_VotedEvent">VotedEvent</a> {
            dao_id,
            proposal_id,
            voter: sender_addr,
            choice: choice.choice,
            vote_weight,
        },
    );
}
</code></pre>



</details>

<a name="0x1_DAOSpace_deserialize_snapshot_proofs"></a>

## Function `deserialize_snapshot_proofs`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_deserialize_snapshot_proofs">deserialize_snapshot_proofs</a>(snpashot_raw_proofs: &vector&lt;u8&gt;): <a href="DAOSpace.md#0x1_DAOSpace_SnapshotProof">DAOSpace::SnapshotProof</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_deserialize_snapshot_proofs">deserialize_snapshot_proofs</a>(snpashot_raw_proofs: &vector&lt;u8&gt;): <a href="DAOSpace.md#0x1_DAOSpace_SnapshotProof">SnapshotProof</a>{
    <b>assert</b>!(<a href="Vector.md#0x1_Vector_length">Vector::length</a>(snpashot_raw_proofs) &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_SNAPSHOT_PROOF_PARAM_INVALID">ERR_SNAPSHOT_PROOF_PARAM_INVALID</a>));
    <b>let</b> offset= 0;
    <b>let</b> (state_option, offset) = <a href="BCS.md#0x1_BCS_deserialize_option_bytes">BCS::deserialize_option_bytes</a>(snpashot_raw_proofs, offset);
    <b>let</b> (account_state_option, offset) = <a href="BCS.md#0x1_BCS_deserialize_option_bytes">BCS::deserialize_option_bytes</a>(snpashot_raw_proofs, offset);

    <b>let</b> (account_proof_leaf1_option, account_proof_leaf2_option, offset) = <a href="BCS.md#0x1_BCS_deserialize_option_tuple">BCS::deserialize_option_tuple</a>(snpashot_raw_proofs, offset);
    <b>let</b> account_proof_leaf1 = <a href="Option.md#0x1_Option_get_with_default">Option::get_with_default</a>(&<b>mut</b> account_proof_leaf1_option, <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>());
    <b>let</b> account_proof_leaf2 = <a href="Option.md#0x1_Option_get_with_default">Option::get_with_default</a>(&<b>mut</b> account_proof_leaf2_option, <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>());
    <b>let</b> (account_proof_siblings, offset) = <a href="BCS.md#0x1_BCS_deserialize_bytes_vector">BCS::deserialize_bytes_vector</a>(snpashot_raw_proofs, offset);

    <b>let</b> (account_state_proof_leaf1_option, account_state_proof_leaf2_option, offset) = <a href="BCS.md#0x1_BCS_deserialize_option_tuple">BCS::deserialize_option_tuple</a>(snpashot_raw_proofs, offset);
    <b>let</b> account_state_proof_leaf1 = <a href="Option.md#0x1_Option_get_with_default">Option::get_with_default</a>(&<b>mut</b> account_state_proof_leaf1_option, <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>());
    <b>let</b> account_state_proof_leaf2 = <a href="Option.md#0x1_Option_get_with_default">Option::get_with_default</a>(&<b>mut</b> account_state_proof_leaf2_option, <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>());
    <b>let</b> (account_state_proof_siblings, _offset) = <a href="BCS.md#0x1_BCS_deserialize_bytes_vector">BCS::deserialize_bytes_vector</a>(snpashot_raw_proofs, offset);

    <a href="DAOSpace.md#0x1_DAOSpace_SnapshotProof">SnapshotProof</a> {
        state: <a href="Option.md#0x1_Option_get_with_default">Option::get_with_default</a>(&<b>mut</b> state_option, <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>()),
        account_state: <a href="Option.md#0x1_Option_get_with_default">Option::get_with_default</a>(&<b>mut</b> account_state_option, <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>()),
        account_proof_leaf: <a href="DAOSpace.md#0x1_DAOSpace_HashNode">HashNode</a> {
            hash1: account_proof_leaf1,
            hash2: account_proof_leaf2,
        },
        account_proof_siblings,
        account_state_proof_leaf: <a href="DAOSpace.md#0x1_DAOSpace_HashNode">HashNode</a> {
            hash1: account_state_proof_leaf1,
            hash2: account_state_proof_leaf2,
        },
        account_state_proof_siblings,
    }
}
</code></pre>



</details>

<a name="0x1_DAOSpace_new_state_proof_from_proofs"></a>

## Function `new_state_proof_from_proofs`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_new_state_proof_from_proofs">new_state_proof_from_proofs</a>(snpashot_proofs: &<a href="DAOSpace.md#0x1_DAOSpace_SnapshotProof">DAOSpace::SnapshotProof</a>): <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_StateProof">StarcoinVerifier::StateProof</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_new_state_proof_from_proofs">new_state_proof_from_proofs</a>(snpashot_proofs: &<a href="DAOSpace.md#0x1_DAOSpace_SnapshotProof">SnapshotProof</a>): StateProof{
    <b>let</b> state_proof = <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_state_proof">StarcoinVerifier::new_state_proof</a>(
        <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_sparse_merkle_proof">StarcoinVerifier::new_sparse_merkle_proof</a>(
            *&snpashot_proofs.account_proof_siblings,
            <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_smt_node">StarcoinVerifier::new_smt_node</a>(
                *&snpashot_proofs.account_proof_leaf.hash1,
                *&snpashot_proofs.account_proof_leaf.hash2,
            ),
        ),
        *&snpashot_proofs.account_state,
        <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_sparse_merkle_proof">StarcoinVerifier::new_sparse_merkle_proof</a>(
            *&snpashot_proofs.account_state_proof_siblings,
            <a href="StarcoinVerifier.md#0x1_StarcoinVerifier_new_smt_node">StarcoinVerifier::new_smt_node</a>(
                *&snpashot_proofs.account_state_proof_leaf.hash1,
                *&snpashot_proofs.account_state_proof_leaf.hash2,
            ),
        ),
    );
    state_proof
}
</code></pre>



</details>

<a name="0x1_DAOSpace_execute_proposal"></a>

## Function `execute_proposal`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_execute_proposal">execute_proposal</a>&lt;DAOT: store, PluginT, ActionT: drop, store&gt;(_cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOProposalCap">DAOSpace::DAOProposalCap</a>&lt;DAOT, PluginT&gt;, sender: &signer, proposal_id: u64): ActionT
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_execute_proposal">execute_proposal</a>&lt;DAOT: store, PluginT, ActionT: store+drop&gt;(
    _cap: &<a href="DAOSpace.md#0x1_DAOSpace_DAOProposalCap">DAOProposalCap</a>&lt;DAOT, PluginT&gt;,
    sender: &signer,
    proposal_id: u64,
): ActionT <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_ProposalActions">ProposalActions</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a>, <a href="DAOSpace.md#0x1_DAOSpace_ProposalEvent">ProposalEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> {
    // Only executable proposal's action can be extracted.
    <b>assert</b>!(<a href="DAOSpace.md#0x1_DAOSpace_proposal_state">proposal_state</a>&lt;DAOT&gt;(proposal_id) == <a href="DAOSpace.md#0x1_DAOSpace_EXECUTABLE">EXECUTABLE</a>, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_STATE_INVALID">ERR_PROPOSAL_STATE_INVALID</a>));
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender);
    <b>assert</b>!(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalActions">ProposalActions</a>&lt;ActionT&gt;&gt;(dao_address), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_ACTIONS_NOT_EXIST">ERR_PROPOSAL_ACTIONS_NOT_EXIST</a>));

    <b>let</b> (actionT, deposit) = <a href="DAOSpace.md#0x1_DAOSpace_take_proposal_action">take_proposal_action</a>(dao_address, proposal_id);

    <b>let</b> global_proposals = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>&gt;(dao_address);
    <b>let</b> proposal = <a href="DAOSpace.md#0x1_DAOSpace_borrow_proposal">borrow_proposal</a>(global_proposals, proposal_id);

    <a href="Account.md#0x1_Account_deposit">Account::deposit</a>(proposal.proposer, deposit);

    // emit event
    <b>let</b> dao_id = <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address);
    <b>let</b> proposal_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalEvent">ProposalEvent</a>&lt;DAOT&gt;&gt;(dao_address);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> proposal_event.proposal_action_event,
        <a href="DAOSpace.md#0x1_DAOSpace_ProposalActionEvent">ProposalActionEvent</a> { dao_id, proposal_id, sender: sender_addr, state: <a href="DAOSpace.md#0x1_DAOSpace_EXTRACTED">EXTRACTED</a> }
    );

    actionT
}
</code></pre>



</details>

<a name="0x1_DAOSpace_clean_proposals"></a>

## Function `clean_proposals`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_clean_proposals">clean_proposals</a>&lt;DAOT: store&gt;(_sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_clean_proposals">clean_proposals</a>&lt;DAOT: store&gt;(_sender: &signer)
<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> global_proposals = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>&gt;(dao_address);

    <b>let</b> i = 0;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&global_proposals.proposals);
    <b>while</b>(i &lt; len){
        <b>let</b> proposal = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&global_proposals.proposals, i);
        <b>let</b> state = <a href="DAOSpace.md#0x1_DAOSpace_proposal_state_with_proposal">proposal_state_with_proposal</a>&lt;DAOT&gt;(proposal);
        <b>if</b> (state == <a href="DAOSpace.md#0x1_DAOSpace_EXTRACTED">EXTRACTED</a> || state == <a href="DAOSpace.md#0x1_DAOSpace_REJECTED">REJECTED</a>) {
            <b>let</b> _ = <a href="Vector.md#0x1_Vector_remove">Vector::remove</a>(&<b>mut</b> global_proposals.proposals, i);
            len = len - 1;
        } <b>else</b> {
            i = i + 1;
        }
    };
}
</code></pre>



</details>

<a name="0x1_DAOSpace_clean_proposals_entry"></a>

## Function `clean_proposals_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_clean_proposals_entry">clean_proposals_entry</a>&lt;DAOT: store&gt;(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_clean_proposals_entry">clean_proposals_entry</a>&lt;DAOT: store&gt;(sender: signer)
<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_clean_proposals">clean_proposals</a>&lt;DAOT&gt;(&sender);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_clean_proposal_by_id"></a>

## Function `clean_proposal_by_id`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_clean_proposal_by_id">clean_proposal_by_id</a>&lt;DAOT: store&gt;(_sender: &signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_clean_proposal_by_id">clean_proposal_by_id</a>&lt;DAOT: store&gt;(_sender: &signer, proposal_id: u64)
<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> global_proposals = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>&gt;(dao_address);
    <b>let</b> proposal = <a href="DAOSpace.md#0x1_DAOSpace_borrow_proposal">borrow_proposal</a>(global_proposals, proposal_id);
    <b>let</b> state = <a href="DAOSpace.md#0x1_DAOSpace_proposal_state_with_proposal">proposal_state_with_proposal</a>&lt;DAOT&gt;(proposal);
    <b>assert</b>!(state == <a href="DAOSpace.md#0x1_DAOSpace_EXTRACTED">EXTRACTED</a> || state == <a href="DAOSpace.md#0x1_DAOSpace_REJECTED">REJECTED</a>, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_STATE_INVALID">ERR_PROPOSAL_STATE_INVALID</a>));

    <b>let</b> _ = <a href="DAOSpace.md#0x1_DAOSpace_remove_proposal">remove_proposal</a>(global_proposals, proposal_id);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_clean_proposal_by_id_entry"></a>

## Function `clean_proposal_by_id_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_clean_proposal_by_id_entry">clean_proposal_by_id_entry</a>&lt;DAOT: store&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_clean_proposal_by_id_entry">clean_proposal_by_id_entry</a>&lt;DAOT: store&gt;(sender: signer, proposal_id: u64)
<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_clean_proposal_by_id">clean_proposal_by_id</a>&lt;DAOT&gt;(&sender, proposal_id)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_take_proposal_action"></a>

## Function `take_proposal_action`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_take_proposal_action">take_proposal_action</a>&lt;ActionT: drop, store&gt;(dao_address: <b>address</b>, proposal_id: u64): (ActionT, <a href="Token.md#0x1_Token_Token">Token::Token</a>&lt;<a href="STC.md#0x1_STC_STC">STC::STC</a>&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_take_proposal_action">take_proposal_action</a>&lt;ActionT: store+drop&gt;(dao_address: <b>address</b>, proposal_id: u64): (ActionT, <a href="Token.md#0x1_Token">Token</a>&lt;<a href="STC.md#0x1_STC">STC</a>&gt;)
<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_ProposalActions">ProposalActions</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a> {
    <b>let</b> actions = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalActions">ProposalActions</a>&lt;ActionT&gt;&gt;(dao_address);
    <b>let</b> index_opt = <a href="DAOSpace.md#0x1_DAOSpace_find_action">find_action</a>(&actions.actions, proposal_id);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&index_opt), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_ACTION_INDEX_INVALID">ERR_ACTION_INDEX_INVALID</a>));

    <b>let</b> index = <a href="Option.md#0x1_Option_extract">Option::extract</a>(&<b>mut</b> index_opt);
    <b>let</b> <a href="DAOSpace.md#0x1_DAOSpace_ProposalAction">ProposalAction</a>{ proposal_id:_, deposit, action} = <a href="Vector.md#0x1_Vector_remove">Vector::remove</a>(&<b>mut</b> actions.actions, index);

    // remove proposal action index
    <b>let</b> global_proposal_actions = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a>&gt;(dao_address);
    <b>let</b> proposal_action_index_opt = <a href="DAOSpace.md#0x1_DAOSpace_find_proposal_action_index">find_proposal_action_index</a>(global_proposal_actions, proposal_id);
    <b>assert</b>!(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&proposal_action_index_opt), <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_ACTION_INDEX_NOT_EXIST">ERR_PROPOSAL_ACTION_INDEX_NOT_EXIST</a>));
    <b>let</b> propopsal_action_index = <a href="Option.md#0x1_Option_extract">Option::extract</a>(&<b>mut</b> proposal_action_index_opt);
    <b>let</b> <a href="DAOSpace.md#0x1_DAOSpace_ProposalActionIndex">ProposalActionIndex</a>{ proposal_id:_,} = <a href="Vector.md#0x1_Vector_remove">Vector::remove</a>(&<b>mut</b> global_proposal_actions.proposal_action_indexs, propopsal_action_index);

    (action, deposit)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_remove_proposal"></a>

## Function `remove_proposal`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_remove_proposal">remove_proposal</a>(proposals: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">DAOSpace::GlobalProposals</a>, proposal_id: u64): <a href="DAOSpace.md#0x1_DAOSpace_Proposal">DAOSpace::Proposal</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_remove_proposal">remove_proposal</a>(proposals: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>, proposal_id: u64): <a href="DAOSpace.md#0x1_DAOSpace_Proposal">Proposal</a> {
    <b>let</b> i = 0;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&proposals.proposals);
    <b>while</b>(i &lt; len){
        <b>let</b> proposal = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&proposals.proposals, i);
        <b>if</b>(proposal.id == proposal_id){
            <b>let</b> proposal = <a href="Vector.md#0x1_Vector_remove">Vector::remove</a>(&<b>mut</b> proposals.proposals, i);
            <b>return</b> proposal
        };
        i = i + 1;
    };
    <b>abort</b> <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_NOT_EXIST">ERR_PROPOSAL_NOT_EXIST</a>)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_find_action"></a>

## Function `find_action`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_find_action">find_action</a>&lt;ActionT: drop, store&gt;(actions: &vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalAction">DAOSpace::ProposalAction</a>&lt;ActionT&gt;&gt;, proposal_id: u64): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_find_action">find_action</a>&lt;ActionT: store+drop&gt;(actions: &vector&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalAction">ProposalAction</a>&lt;ActionT&gt;&gt;, proposal_id: u64): <a href="Option.md#0x1_Option">Option</a>&lt;u64&gt;{
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

<a name="0x1_DAOSpace_do_cast_vote"></a>

## Function `do_cast_vote`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_do_cast_vote">do_cast_vote</a>(proposal: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_Proposal">DAOSpace::Proposal</a>, vote: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_Vote">DAOSpace::Vote</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_do_cast_vote">do_cast_vote</a>(proposal: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_Proposal">Proposal</a>, vote: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_Vote">Vote</a>){
    <b>if</b> (<a href="DAOSpace.md#0x1_DAOSpace_choice_yes">choice_yes</a>().choice == vote.choice) {
        proposal.yes_votes = proposal.yes_votes + vote.vote_weight;
    } <b>else</b> <b>if</b> (<a href="DAOSpace.md#0x1_DAOSpace_choice_no">choice_no</a>().choice == vote.choice) {
        proposal.no_votes = proposal.no_votes + vote.vote_weight;
    } <b>else</b> <b>if</b> ( <a href="DAOSpace.md#0x1_DAOSpace_choice_no_with_veto">choice_no_with_veto</a>().choice == vote.choice) {
        proposal.no_with_veto_votes = proposal.no_with_veto_votes + vote.vote_weight;
    } <b>else</b> <b>if</b> (<a href="DAOSpace.md#0x1_DAOSpace_choice_abstain">choice_abstain</a>().choice == vote.choice) {
        proposal.abstain_votes = proposal.abstain_votes + vote.vote_weight;
    } <b>else</b> {
        <b>abort</b> <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_VOTE_PARAM_INVALID">ERR_VOTE_PARAM_INVALID</a>)
    };
}
</code></pre>



</details>

<a name="0x1_DAOSpace_has_voted"></a>

## Function `has_voted`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_has_voted">has_voted</a>&lt;DAOT&gt;(sender: <b>address</b>, proposal_id: u64): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_has_voted">has_voted</a>&lt;DAOT&gt;(sender: <b>address</b>, proposal_id: u64): bool <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_MyVotes">MyVotes</a>{
    <b>if</b>(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MyVotes">MyVotes</a>&lt;DAOT&gt;&gt;(sender)){
        <b>let</b> my_votes = <b>borrow_global</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MyVotes">MyVotes</a>&lt;DAOT&gt;&gt;(sender);
        <b>let</b> vote = <a href="DAOSpace.md#0x1_DAOSpace_vote_info">vote_info</a>&lt;DAOT&gt;(my_votes, proposal_id);
        <a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&vote)
    }<b>else</b>{
        <b>false</b>
    }
}
</code></pre>



</details>

<a name="0x1_DAOSpace_vote_info"></a>

## Function `vote_info`

vote info by proposal_id


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_vote_info">vote_info</a>&lt;DAOT&gt;(my_votes: &<a href="DAOSpace.md#0x1_DAOSpace_MyVotes">DAOSpace::MyVotes</a>&lt;DAOT&gt;, proposal_id: u64): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_VoteInfo">DAOSpace::VoteInfo</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_vote_info">vote_info</a>&lt;DAOT&gt;(my_votes: &<a href="DAOSpace.md#0x1_DAOSpace_MyVotes">MyVotes</a>&lt;DAOT&gt;, proposal_id: u64): <a href="Option.md#0x1_Option">Option</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_VoteInfo">VoteInfo</a>&gt;{
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&my_votes.votes);
    <b>let</b> idx = 0;
    <b>loop</b> {
        <b>if</b> (idx &gt;= len) {
            <b>break</b>
        };
        <b>let</b> vote = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&my_votes.votes, idx);
        <b>if</b> (proposal_id == vote.proposal_id) {
            <b>let</b> vote_info = <a href="DAOSpace.md#0x1_DAOSpace_VoteInfo">VoteInfo</a> {
                proposal_id: vote.proposal_id,
                vote_weight: vote.vote_weight,
                choice: vote.choice,
            };
            <b>return</b> <a href="Option.md#0x1_Option_some">Option::some</a>(vote_info)
        };
        idx = idx + 1;
    };
    <a href="Option.md#0x1_Option_none">Option::none</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_VoteInfo">VoteInfo</a>&gt;()
}
</code></pre>



</details>

<a name="0x1_DAOSpace_reject_proposal"></a>

## Function `reject_proposal`

Proposals are rejected when their nowithveto option reaches a certain threshold
A portion of the pledged tokens will be rewarded to the executor who executes the proposal


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_reject_proposal">reject_proposal</a>&lt;DAOT: store, ActionT: drop, store&gt;(sender: &signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_reject_proposal">reject_proposal</a>&lt;DAOT: store, ActionT: store+drop&gt;(sender: &signer, proposal_id: u64)
<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>, <a href="DAOSpace.md#0x1_DAOSpace_ProposalEvent">ProposalEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_ProposalActions">ProposalActions</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a>{
    // Only  <a href="DAOSpace.md#0x1_DAOSpace_REJECTED">REJECTED</a> proposal's action can be burn token.
    <b>assert</b>!(<a href="DAOSpace.md#0x1_DAOSpace_proposal_state">proposal_state</a>&lt;DAOT&gt;(proposal_id) == <a href="DAOSpace.md#0x1_DAOSpace_REJECTED">REJECTED</a>, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_STATE_INVALID">ERR_PROPOSAL_STATE_INVALID</a>));
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>assert</b>!(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalActions">ProposalActions</a>&lt;ActionT&gt;&gt;(dao_address), <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_ACTIONS_NOT_EXIST">ERR_PROPOSAL_ACTIONS_NOT_EXIST</a>));
    <b>let</b> (_, token) = <a href="DAOSpace.md#0x1_DAOSpace_take_proposal_action">take_proposal_action</a>&lt;ActionT&gt;(dao_address, proposal_id);
    // Part of the token is awarded <b>to</b> whoever executes this method , TODO: 10 %
    <b>let</b> award_amount = <a href="Token.md#0x1_Token_value">Token::value</a>(&token) / 10;
    <b>let</b> (burn_token , award_token) = <a href="Token.md#0x1_Token_split">Token::split</a>(token, award_amount);
    <a href="Account.md#0x1_Account_deposit">Account::deposit</a>(<a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender), award_token);
    <a href="STC.md#0x1_STC_burn">STC::burn</a>(burn_token);

    // emit event
    <b>let</b> dao_id = <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address);
    <b>let</b> proposal_event = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_ProposalEvent">ProposalEvent</a>&lt;DAOT&gt;&gt;(dao_address);
    <a href="Event.md#0x1_Event_emit_event">Event::emit_event</a>(&<b>mut</b> proposal_event.proposal_action_event,
        <a href="DAOSpace.md#0x1_DAOSpace_ProposalActionEvent">ProposalActionEvent</a> { dao_id, proposal_id, sender: <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(sender), state: <a href="DAOSpace.md#0x1_DAOSpace_REJECTED">REJECTED</a> }
    );
}
</code></pre>



</details>

<a name="0x1_DAOSpace_reject_proposal_entry"></a>

## Function `reject_proposal_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_reject_proposal_entry">reject_proposal_entry</a>&lt;DAOT: store, ActionT: drop, store&gt;(sender: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_reject_proposal_entry">reject_proposal_entry</a>&lt;DAOT: store, ActionT: store+drop&gt;(sender: signer, proposal_id: u64)
<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>, <a href="DAOSpace.md#0x1_DAOSpace_ProposalEvent">ProposalEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_ProposalActions">ProposalActions</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a>{
    <a href="DAOSpace.md#0x1_DAOSpace_reject_proposal">reject_proposal</a>&lt;DAOT, ActionT&gt;(&sender, proposal_id);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_get_vote_info"></a>

## Function `get_vote_info`

get vote info by proposal_id


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_get_vote_info">get_vote_info</a>&lt;DAOT&gt;(voter: <b>address</b>, proposal_id: u64): (u64, u8, u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_get_vote_info">get_vote_info</a>&lt;DAOT&gt;(voter: <b>address</b>, proposal_id: u64): (u64, u8, u128)<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_MyVotes">MyVotes</a> {
    <b>if</b>(<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MyVotes">MyVotes</a>&lt;DAOT&gt;&gt;(voter)){
        <b>let</b> my_votes = <b>borrow_global</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_MyVotes">MyVotes</a>&lt;DAOT&gt;&gt;(voter);
        <b>let</b> vote_option = <a href="DAOSpace.md#0x1_DAOSpace_vote_info">vote_info</a>&lt;DAOT&gt;(my_votes, proposal_id);
        <b>if</b>(!<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&vote_option)){
            <b>return</b> (0, 0, 0)
        };
        <b>let</b> vote = <a href="Option.md#0x1_Option_extract">Option::extract</a>(&<b>mut</b> vote_option);
        (vote.proposal_id, vote.choice, vote.vote_weight)
    }<b>else</b>{
        (0, 0, 0)
    }
}
</code></pre>



</details>

<a name="0x1_DAOSpace_proposal_state"></a>

## Function `proposal_state`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_state">proposal_state</a>&lt;DAOT: store&gt;(proposal_id: u64): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_state">proposal_state</a>&lt;DAOT: store&gt;(proposal_id: u64) : u8 <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> proposals = <b>borrow_global</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>&gt;(dao_address);
    <b>let</b> proposal = <a href="DAOSpace.md#0x1_DAOSpace_borrow_proposal">borrow_proposal</a>(proposals, proposal_id);

    <a href="DAOSpace.md#0x1_DAOSpace_proposal_state_with_proposal">proposal_state_with_proposal</a>&lt;DAOT&gt;(proposal)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_proposal_state_with_proposal"></a>

## Function `proposal_state_with_proposal`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_state_with_proposal">proposal_state_with_proposal</a>&lt;DAOT: store&gt;(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">DAOSpace::Proposal</a>): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_state_with_proposal">proposal_state_with_proposal</a>&lt;DAOT: store&gt;(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">Proposal</a>) : u8 <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> current_time = <a href="Timestamp.md#0x1_Timestamp_now_milliseconds">Timestamp::now_milliseconds</a>();

    <b>let</b> global_proposal_actions = <b>borrow_global</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a>&gt;(dao_address);
    <b>let</b> action_index_opt = <a href="DAOSpace.md#0x1_DAOSpace_find_proposal_action_index">find_proposal_action_index</a>(global_proposal_actions, proposal.id);

    <a href="DAOSpace.md#0x1_DAOSpace_do_proposal_state">do_proposal_state</a>(proposal, current_time, action_index_opt)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_do_proposal_state"></a>

## Function `do_proposal_state`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_do_proposal_state">do_proposal_state</a>(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">DAOSpace::Proposal</a>, current_time: u64, action_index_opt: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_do_proposal_state">do_proposal_state</a>(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">Proposal</a>, current_time: u64, action_index_opt: <a href="Option.md#0x1_Option">Option</a>&lt;u64&gt;): u8 {
    <b>if</b> (current_time &lt; proposal.start_time) {
        // Pending
        <a href="DAOSpace.md#0x1_DAOSpace_PENDING">PENDING</a>
    } <b>else</b> <b>if</b> (current_time &lt;= proposal.end_time) {
        // Active
        <a href="DAOSpace.md#0x1_DAOSpace_ACTIVE">ACTIVE</a>
    } <b>else</b> <b>if</b> (proposal.no_with_veto_votes &gt;= (proposal.no_votes + proposal.yes_votes) ){
        // rejected
        <a href="DAOSpace.md#0x1_DAOSpace_REJECTED">REJECTED</a>
    } <b>else</b> <b>if</b> (proposal.yes_votes &lt;=  (proposal.no_votes + proposal.no_with_veto_votes) ||
               ( proposal.yes_votes + proposal.no_votes + proposal.abstain_votes + proposal.no_with_veto_votes ) &lt; proposal.quorum_votes) {
        // Defeated
        <a href="DAOSpace.md#0x1_DAOSpace_DEFEATED">DEFEATED</a>
    } <b>else</b> <b>if</b> (proposal.eta == 0) {
        // Agreed.
        <a href="DAOSpace.md#0x1_DAOSpace_AGREED">AGREED</a>
    } <b>else</b> <b>if</b> (current_time &lt; proposal.eta) {
        // Queued, waiting <b>to</b> execute
        <a href="DAOSpace.md#0x1_DAOSpace_QUEUED">QUEUED</a>
    } <b>else</b> <b>if</b> (<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&action_index_opt)) {
        <a href="DAOSpace.md#0x1_DAOSpace_EXECUTABLE">EXECUTABLE</a>
    } <b>else</b> {
        <a href="DAOSpace.md#0x1_DAOSpace_EXTRACTED">EXTRACTED</a>
    }
}
</code></pre>



</details>

<a name="0x1_DAOSpace_borrow_proposal_mut"></a>

## Function `borrow_proposal_mut`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_borrow_proposal_mut">borrow_proposal_mut</a>(proposals: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">DAOSpace::GlobalProposals</a>, proposal_id: u64): &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_Proposal">DAOSpace::Proposal</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_borrow_proposal_mut">borrow_proposal_mut</a>(proposals: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>, proposal_id: u64): &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_Proposal">Proposal</a>{
    <b>let</b> i = 0;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&proposals.proposals);
    <b>while</b>(i &lt; len){
        <b>let</b> proposal = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&proposals.proposals, i);
        <b>if</b>(proposal.id == proposal_id){
            <b>return</b> <a href="Vector.md#0x1_Vector_borrow_mut">Vector::borrow_mut</a>(&<b>mut</b> proposals.proposals, i)
        };
        i = i + 1;
    };
    <b>abort</b> <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_NOT_EXIST">ERR_PROPOSAL_NOT_EXIST</a>)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_borrow_proposal"></a>

## Function `borrow_proposal`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_borrow_proposal">borrow_proposal</a>(proposals: &<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">DAOSpace::GlobalProposals</a>, proposal_id: u64): &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">DAOSpace::Proposal</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_borrow_proposal">borrow_proposal</a>(proposals: &<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>, proposal_id: u64): &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">Proposal</a> {
    <b>let</b> i = 0;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(&proposals.proposals);
    <b>while</b>(i &lt; len){
        <b>let</b> proposal = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(&proposals.proposals, i);
        <b>if</b>(proposal.id == proposal_id){
            <b>return</b> proposal
        };
        i = i + 1;
    };
    <b>abort</b> <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_NOT_EXIST">ERR_PROPOSAL_NOT_EXIST</a>)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_find_proposal_action_index"></a>

## Function `find_proposal_action_index`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_find_proposal_action_index">find_proposal_action_index</a>(global_proposal_action: &<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">DAOSpace::GlobalProposalActions</a>, proposal_id: u64): <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u64&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_find_proposal_action_index">find_proposal_action_index</a>(global_proposal_action: &<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a>, proposal_id: u64): <a href="Option.md#0x1_Option">Option</a>&lt;u64&gt; {
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

<a name="0x1_DAOSpace_proposal"></a>

## Function `proposal`

Return a copy of Proposal of proposal_id


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal">proposal</a>&lt;DAOT&gt;(proposal_id: u64): <a href="DAOSpace.md#0x1_DAOSpace_Proposal">DAOSpace::Proposal</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal">proposal</a>&lt;DAOT&gt;(proposal_id: u64): <a href="DAOSpace.md#0x1_DAOSpace_Proposal">Proposal</a> <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>{
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> global_proposals = <b>borrow_global</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>&gt;(dao_address);
    *<a href="DAOSpace.md#0x1_DAOSpace_borrow_proposal">borrow_proposal</a>(global_proposals, proposal_id)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_proposal_id"></a>

## Function `proposal_id`

get proposal's id.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_id">proposal_id</a>(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">DAOSpace::Proposal</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_id">proposal_id</a>(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">Proposal</a>): u64 {
    proposal.id
}
</code></pre>



</details>

<a name="0x1_DAOSpace_proposal_proposer"></a>

## Function `proposal_proposer`

get proposal's proposer.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_proposer">proposal_proposer</a>(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">DAOSpace::Proposal</a>): <b>address</b>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_proposer">proposal_proposer</a>(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">Proposal</a>): <b>address</b> {
    proposal.proposer
}
</code></pre>



</details>

<a name="0x1_DAOSpace_proposal_time"></a>

## Function `proposal_time`

get proposal's time(start_time/end_time).


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_time">proposal_time</a>(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">DAOSpace::Proposal</a>): (u64, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_time">proposal_time</a>(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">Proposal</a>): (u64, u64) {
    (proposal.start_time,proposal.end_time)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_proposal_votes"></a>

## Function `proposal_votes`

get proposal's votes(Yes/No/Abstain/Veto).


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_votes">proposal_votes</a>(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">DAOSpace::Proposal</a>): (u128, u128, u128, u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_votes">proposal_votes</a>(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">Proposal</a>): (u128, u128, u128, u128) {
    (proposal.yes_votes, proposal.no_votes, proposal.abstain_votes, proposal.no_with_veto_votes)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_proposal_block_number"></a>

## Function `proposal_block_number`

get proposal's block number.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_block_number">proposal_block_number</a>(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">DAOSpace::Proposal</a>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_block_number">proposal_block_number</a>(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">Proposal</a>): u64 {
    proposal.block_number
}
</code></pre>



</details>

<a name="0x1_DAOSpace_proposal_state_root"></a>

## Function `proposal_state_root`

get proposal's state root.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_state_root">proposal_state_root</a>(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">DAOSpace::Proposal</a>): vector&lt;u8&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_proposal_state_root">proposal_state_root</a>(proposal: &<a href="DAOSpace.md#0x1_DAOSpace_Proposal">Proposal</a>): vector&lt;u8&gt; {
    *&proposal.state_root
}
</code></pre>



</details>

<a name="0x1_DAOSpace_queue_proposal_action_entry"></a>

## Function `queue_proposal_action_entry`

queue agreed proposal to execute.


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_queue_proposal_action_entry">queue_proposal_action_entry</a>&lt;DAOT: store&gt;(_signer: signer, proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_queue_proposal_action_entry">queue_proposal_action_entry</a>&lt;DAOT:store&gt;(
    _signer: signer,
    proposal_id: u64,
) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a> {
    <a href="DAOSpace.md#0x1_DAOSpace_queue_proposal_action">queue_proposal_action</a>&lt;DAOT&gt;(proposal_id)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_queue_proposal_action"></a>

## Function `queue_proposal_action`

queue agreed proposal to execute.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_queue_proposal_action">queue_proposal_action</a>&lt;DAOT: store&gt;(proposal_id: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_queue_proposal_action">queue_proposal_action</a>&lt;DAOT:store&gt;(
    proposal_id: u64,
) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a> {
    // Only agreed proposal can be submitted.
    <b>assert</b>!(<a href="DAOSpace.md#0x1_DAOSpace_proposal_state">proposal_state</a>&lt;DAOT&gt;(proposal_id) == <a href="DAOSpace.md#0x1_DAOSpace_AGREED">AGREED</a>, <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_PROPOSAL_STATE_INVALID">ERR_PROPOSAL_STATE_INVALID</a>));
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> proposals = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>&gt;(dao_address);
    <b>let</b> proposal = <a href="DAOSpace.md#0x1_DAOSpace_borrow_proposal_mut">borrow_proposal_mut</a>(proposals, proposal_id);
    proposal.eta = <a href="Timestamp.md#0x1_Timestamp_now_milliseconds">Timestamp::now_milliseconds</a>() + proposal.action_delay;
}
</code></pre>



</details>

<a name="0x1_DAOSpace_cast_vote_entry"></a>

## Function `cast_vote_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_cast_vote_entry">cast_vote_entry</a>&lt;DAOT: store&gt;(sender: signer, proposal_id: u64, snpashot_raw_proofs: vector&lt;u8&gt;, choice: u8)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_cast_vote_entry">cast_vote_entry</a>&lt;DAOT:store&gt;(
    sender: signer,
    proposal_id: u64,
    snpashot_raw_proofs: vector&lt;u8&gt;,
    choice: u8,
) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_MyVotes">MyVotes</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposals">GlobalProposals</a>, <a href="DAOSpace.md#0x1_DAOSpace_ProposalEvent">ProposalEvent</a>, <a href="DAOSpace.md#0x1_DAOSpace_GlobalProposalActions">GlobalProposalActions</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> {
    <b>let</b> sender_addr = <a href="Signer.md#0x1_Signer_address_of">Signer::address_of</a>(&sender);
    <b>if</b> (<a href="DAOSpace.md#0x1_DAOSpace_has_voted">has_voted</a>&lt;DAOT&gt;(sender_addr, proposal_id)) {
        <b>abort</b> <a href="Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_VOTED_ALREADY">ERR_VOTED_ALREADY</a>)
    };

    <b>let</b> vote_choice = <a href="DAOSpace.md#0x1_DAOSpace_VotingChoice">VotingChoice</a> {
        choice,
    };
    <a href="DAOSpace.md#0x1_DAOSpace_cast_vote">cast_vote</a>&lt;DAOT&gt;(&sender, proposal_id, snpashot_raw_proofs, vote_choice)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_new_dao_config"></a>

## Function `new_dao_config`

DAOConfig
---------------------------------------------------
create a dao config


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_new_dao_config">new_dao_config</a>(voting_delay: u64, voting_period: u64, voting_quorum_rate: u8, min_action_delay: u64, min_proposal_deposit: u128): <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOSpace::DAOConfig</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_new_dao_config">new_dao_config</a>(
    voting_delay: u64,
    voting_period: u64,
    voting_quorum_rate: u8,
    min_action_delay: u64,
    min_proposal_deposit: u128,
): <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOConfig</a>{
    <b>assert</b>!(voting_delay &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>));
    <b>assert</b>!(voting_period &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>));
    <b>assert</b>!(
        voting_quorum_rate &gt; 0 && <a href="DAOSpace.md#0x1_DAOSpace_voting_quorum_rate">voting_quorum_rate</a> &lt;= 100,
        <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>),
    );
    <b>assert</b>!(min_action_delay &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>));
    <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOConfig</a> { voting_delay, voting_period, voting_quorum_rate, min_action_delay, min_proposal_deposit }
}
</code></pre>



</details>

<a name="0x1_DAOSpace_get_custom_config"></a>

## Function `get_custom_config`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_get_custom_config">get_custom_config</a>&lt;DAOT: store, ConfigT: <b>copy</b>, drop, store&gt;(): ConfigT
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_get_custom_config">get_custom_config</a>&lt;DAOT: store,
                             ConfigT: <b>copy</b> + store + drop&gt;(): ConfigT {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <a href="Config.md#0x1_Config_get_by_address">Config::get_by_address</a>&lt;ConfigT&gt;(dao_address)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_exists_custom_config"></a>

## Function `exists_custom_config`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_exists_custom_config">exists_custom_config</a>&lt;DAOT: store, ConfigT: <b>copy</b>, drop, store&gt;(): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_exists_custom_config">exists_custom_config</a>&lt;DAOT: store,
                                ConfigT: <b>copy</b> + store + drop&gt;(): bool {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <a href="Config.md#0x1_Config_config_exist_by_address">Config::config_exist_by_address</a>&lt;ConfigT&gt;(dao_address)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_set_custom_config"></a>

## Function `set_custom_config`

Update, save function of custom plugin configuration


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_custom_config">set_custom_config</a>&lt;DAOT: store, PluginT: drop, ConfigT: <b>copy</b>, drop, store&gt;(_cap: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOModifyConfigCap">DAOSpace::DAOModifyConfigCap</a>&lt;DAOT, PluginT&gt;, config: ConfigT)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_custom_config">set_custom_config</a>&lt;DAOT: store,
                             PluginT: drop,
                             ConfigT: <b>copy</b> + store + drop&gt;(
    _cap: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOModifyConfigCap">DAOModifyConfigCap</a>&lt;DAOT, PluginT&gt;,
    config: ConfigT)
<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOCustomConfigModifyCapHolder">DAOCustomConfigModifyCapHolder</a>, <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>if</b> (<a href="Config.md#0x1_Config_config_exist_by_address">Config::config_exist_by_address</a>&lt;ConfigT&gt;(dao_address)) {
        <b>let</b> cap_holder =
            <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOCustomConfigModifyCapHolder">DAOCustomConfigModifyCapHolder</a>&lt;DAOT, ConfigT&gt;&gt;(dao_address);
        <b>let</b> modify_config_cap = &<b>mut</b> cap_holder.cap;
        <a href="Config.md#0x1_Config_set_with_capability">Config::set_with_capability</a>(modify_config_cap, config);
    } <b>else</b> {
        <b>let</b> signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
        <b>move_to</b>(&signer, <a href="DAOSpace.md#0x1_DAOSpace_DAOCustomConfigModifyCapHolder">DAOCustomConfigModifyCapHolder</a>&lt;DAOT, ConfigT&gt; {
            cap: <a href="Config.md#0x1_Config_publish_new_config_with_capability">Config::publish_new_config_with_capability</a>&lt;ConfigT&gt;(&signer, config)
        });
    }
}
</code></pre>



</details>

<a name="0x1_DAOSpace_set_custom_config_cap"></a>

## Function `set_custom_config_cap`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_custom_config_cap">set_custom_config_cap</a>&lt;DAOT: store, ConfigT: <b>copy</b>, drop, store&gt;(config_cap: <a href="Config.md#0x1_Config_ModifyConfigCapability">Config::ModifyConfigCapability</a>&lt;ConfigT&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>friend</b>) <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_custom_config_cap">set_custom_config_cap</a>&lt;DAOT: store,
                                ConfigT:<b>copy</b> + store + drop&gt;(
    config_cap: <a href="Config.md#0x1_Config_ModifyConfigCapability">Config::ModifyConfigCapability</a>&lt;ConfigT&gt;)
    <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a>{
        <b>let</b> signer = <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;();
        <b>move_to</b>(&signer, <a href="DAOSpace.md#0x1_DAOSpace_DAOCustomConfigModifyCapHolder">DAOCustomConfigModifyCapHolder</a>&lt;DAOT, ConfigT&gt; {
            cap: config_cap
    });
}
</code></pre>



</details>

<a name="0x1_DAOSpace_set_dao_description"></a>

## Function `set_dao_description`

Update DAO description


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_dao_description">set_dao_description</a>&lt;DAOT: store, PluginT: drop, ConfigT: <b>copy</b>, drop, store&gt;(_cap: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOModifyConfigCap">DAOSpace::DAOModifyConfigCap</a>&lt;DAOT, PluginT&gt;, description: vector&lt;u8&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_dao_description">set_dao_description</a>&lt;DAOT: store,
                             PluginT: drop,
                             ConfigT: <b>copy</b> + store + drop&gt;(
    _cap: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOModifyConfigCap">DAOModifyConfigCap</a>&lt;DAOT, PluginT&gt;,
    description: vector&lt;u8&gt;)
<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>{
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> dao = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>&gt;(dao_address);
    dao.description = description;
}
</code></pre>



</details>

<a name="0x1_DAOSpace_set_dao_image"></a>

## Function `set_dao_image`

Update DAO NFT image


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_dao_image">set_dao_image</a>&lt;DAOT: store, PluginT: drop, ConfigT: <b>copy</b>, drop, store&gt;(_cap: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOModifyConfigCap">DAOSpace::DAOModifyConfigCap</a>&lt;DAOT, PluginT&gt;, image_data: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;, image_url: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_dao_image">set_dao_image</a>&lt;DAOT: store,
                             PluginT: drop,
                             ConfigT: <b>copy</b> + store + drop&gt;(
    _cap: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOModifyConfigCap">DAOModifyConfigCap</a>&lt;DAOT, PluginT&gt;,
    image_data:<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;,
    image_url:<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;)
<b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAONFTUpdateCapHolder">DAONFTUpdateCapHolder</a>{
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> nft_update_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAONFTUpdateCapHolder">DAONFTUpdateCapHolder</a>&lt;DAOT&gt;&gt;(dao_address).cap;
    <b>let</b> old_meta = <a href="NFT.md#0x1_NFT_nft_type_info_meta">NFT::nft_type_info_meta</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;&gt;();
    <b>let</b> new_meta = <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&image_data)){
        <a href="NFT.md#0x1_NFT_new_meta_with_image_data">NFT::new_meta_with_image_data</a>(<a href="NFT.md#0x1_NFT_meta_name">NFT::meta_name</a>(&old_meta), <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(image_data), <a href="NFT.md#0x1_NFT_meta_description">NFT::meta_description</a>(&old_meta))
    }<b>else</b> <b>if</b>(<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(&image_url)){
        <a href="NFT.md#0x1_NFT_new_meta_with_image">NFT::new_meta_with_image</a>(<a href="NFT.md#0x1_NFT_meta_name">NFT::meta_name</a>(&old_meta), <a href="Option.md#0x1_Option_destroy_some">Option::destroy_some</a>(image_url), <a href="NFT.md#0x1_NFT_meta_description">NFT::meta_description</a>(&old_meta))
    }<b>else</b>{
        <a href="NFT.md#0x1_NFT_new_meta">NFT::new_meta</a>(<a href="NFT.md#0x1_NFT_meta_name">NFT::meta_name</a>(&old_meta), <a href="NFT.md#0x1_NFT_meta_description">NFT::meta_description</a>(&old_meta))
    };
    <a href="NFT.md#0x1_NFT_update_nft_type_info_meta_with_cap">NFT::update_nft_type_info_meta_with_cap</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOMember">DAOMember</a>&lt;DAOT&gt;&gt;(nft_update_cap, new_meta);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_voting_delay"></a>

## Function `voting_delay`

get default voting delay of the DAO.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_voting_delay">voting_delay</a>&lt;DAOT: store&gt;(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_voting_delay">voting_delay</a>&lt;DAOT: store&gt;(): u64 {
    <a href="DAOSpace.md#0x1_DAOSpace_get_config">get_config</a>&lt;DAOT&gt;().voting_delay
}
</code></pre>



</details>

<a name="0x1_DAOSpace_voting_period"></a>

## Function `voting_period`

get the default voting period of the DAO.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_voting_period">voting_period</a>&lt;DAOT: store&gt;(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_voting_period">voting_period</a>&lt;DAOT: store&gt;(): u64 {
    <a href="DAOSpace.md#0x1_DAOSpace_get_config">get_config</a>&lt;DAOT&gt;().voting_period
}
</code></pre>



</details>

<a name="0x1_DAOSpace_quorum_votes"></a>

## Function `quorum_votes`

Quorum votes to make proposal valid.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_quorum_votes">quorum_votes</a>&lt;DAOT: store&gt;(scale_factor: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u8&gt;): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_quorum_votes">quorum_votes</a>&lt;DAOT: store&gt;(scale_factor: <a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;u8&gt;): u128 {
    <b>let</b> scale_factor = <b>if</b> (<a href="Option.md#0x1_Option_is_none">Option::is_none</a>(&scale_factor)) {
        0u8
    } <b>else</b> {
        <a href="Option.md#0x1_Option_extract">Option::extract</a>(&<b>mut</b> scale_factor)
    };
    <b>assert</b>!(
        scale_factor &gt;= 0 && scale_factor &lt;= 100,
        <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>),
    );

    <b>let</b> market_cap = <a href="Token.md#0x1_Token_market_cap">Token::market_cap</a>&lt;DAOT&gt;();
    <b>let</b> rate = (<a href="DAOSpace.md#0x1_DAOSpace_voting_quorum_rate">voting_quorum_rate</a>&lt;DAOT&gt;() <b>as</b> u128);
    <b>let</b> rate = rate + rate * (scale_factor <b>as</b> u128) / 100;
    <b>assert</b>!(
        rate &gt; 0 && rate &lt;= 100,
        <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>),
    );
    market_cap * rate / 100
}
</code></pre>



</details>

<a name="0x1_DAOSpace_voting_quorum_rate"></a>

## Function `voting_quorum_rate`

Get the quorum rate in percent.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_voting_quorum_rate">voting_quorum_rate</a>&lt;DAOT: store&gt;(): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_voting_quorum_rate">voting_quorum_rate</a>&lt;DAOT: store&gt;(): u8 {
    <a href="DAOSpace.md#0x1_DAOSpace_get_config">get_config</a>&lt;DAOT&gt;().voting_quorum_rate
}
</code></pre>



</details>

<a name="0x1_DAOSpace_min_action_delay"></a>

## Function `min_action_delay`

Get the min action delay of the DAO.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_min_action_delay">min_action_delay</a>&lt;DAOT: store&gt;(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_min_action_delay">min_action_delay</a>&lt;DAOT: store&gt;(): u64 {
    <a href="DAOSpace.md#0x1_DAOSpace_get_config">get_config</a>&lt;DAOT&gt;().min_action_delay
}
</code></pre>



</details>

<a name="0x1_DAOSpace_min_proposal_deposit"></a>

## Function `min_proposal_deposit`

Get the min proposal deposit of the DAO.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_min_proposal_deposit">min_proposal_deposit</a>&lt;DAOT: store&gt;(): u128
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_min_proposal_deposit">min_proposal_deposit</a>&lt;DAOT: store&gt;(): u128{
    <a href="DAOSpace.md#0x1_DAOSpace_get_config">get_config</a>&lt;DAOT&gt;().min_proposal_deposit
}
</code></pre>



</details>

<a name="0x1_DAOSpace_get_config"></a>

## Function `get_config`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_get_config">get_config</a>&lt;DAOT: store&gt;(): <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOSpace::DAOConfig</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_get_config">get_config</a>&lt;DAOT: store&gt;(): <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOConfig</a> {
    <b>let</b> dao_address= <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <a href="Config.md#0x1_Config_get_by_address">Config::get_by_address</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOConfig</a>&gt;(dao_address)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_modify_dao_config"></a>

## Function `modify_dao_config`

Update function, modify dao config.


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_modify_dao_config">modify_dao_config</a>&lt;DAOT: store, PluginT&gt;(_cap: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOModifyConfigCap">DAOSpace::DAOModifyConfigCap</a>&lt;DAOT, PluginT&gt;, new_config: <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOSpace::DAOConfig</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_modify_dao_config">modify_dao_config</a>&lt;DAOT: store, PluginT&gt;(
    _cap: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOModifyConfigCap">DAOModifyConfigCap</a>&lt;DAOT, PluginT&gt;,
    new_config: <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOConfig</a>,
) <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOConfigModifyCapHolder">DAOConfigModifyCapHolder</a> {
    <b>let</b> modify_config_cap = &<b>mut</b> <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOConfigModifyCapHolder">DAOConfigModifyCapHolder</a>&gt;(
        <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;(),
    ).cap;
    <a href="Config.md#0x1_Config_set_with_capability">Config::set_with_capability</a>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOConfig</a>&gt;(modify_config_cap, new_config);
}
</code></pre>



</details>

<a name="0x1_DAOSpace_set_voting_delay"></a>

## Function `set_voting_delay`

set voting delay


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_voting_delay">set_voting_delay</a>(config: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOSpace::DAOConfig</a>, value: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_voting_delay">set_voting_delay</a>(
    config: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOConfig</a>,
    value: u64,
) {
    <b>assert</b>!(value &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>));
    config.voting_delay = value;
}
</code></pre>



</details>

<a name="0x1_DAOSpace_set_voting_period"></a>

## Function `set_voting_period`

set voting period


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_voting_period">set_voting_period</a>&lt;DAOT: store&gt;(config: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOSpace::DAOConfig</a>, value: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_voting_period">set_voting_period</a>&lt;DAOT: store&gt;(
    config: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOConfig</a>,
    value: u64,
) {
    <b>assert</b>!(value &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>));
    config.voting_period = value;
}
</code></pre>



</details>

<a name="0x1_DAOSpace_set_voting_quorum_rate"></a>

## Function `set_voting_quorum_rate`

set voting quorum rate


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_voting_quorum_rate">set_voting_quorum_rate</a>&lt;DAOT: store&gt;(config: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOSpace::DAOConfig</a>, value: u8)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_voting_quorum_rate">set_voting_quorum_rate</a>&lt;DAOT: store&gt;(
    config: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOConfig</a>,
    value: u8,
) {
    <b>assert</b>!(value &lt;= 100 && value &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_QUORUM_RATE_INVALID">ERR_QUORUM_RATE_INVALID</a>));
    config.voting_quorum_rate = value;
}
</code></pre>



</details>

<a name="0x1_DAOSpace_set_min_action_delay"></a>

## Function `set_min_action_delay`

set min action delay


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_min_action_delay">set_min_action_delay</a>&lt;DAOT: store&gt;(config: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOSpace::DAOConfig</a>, value: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_min_action_delay">set_min_action_delay</a>&lt;DAOT: store&gt;(
    config: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOConfig</a>,
    value: u64,
) {
    <b>assert</b>!(value &gt; 0, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_CONFIG_PARAM_INVALID">ERR_CONFIG_PARAM_INVALID</a>));
    config.min_action_delay = value;
}
</code></pre>



</details>

<a name="0x1_DAOSpace_set_min_proposal_deposit"></a>

## Function `set_min_proposal_deposit`

set min action delay


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_min_proposal_deposit">set_min_proposal_deposit</a>&lt;DAOT: store&gt;(config: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOSpace::DAOConfig</a>, value: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_set_min_proposal_deposit">set_min_proposal_deposit</a>&lt;DAOT: store&gt;(
    config: &<b>mut</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOConfig">DAOConfig</a>,
    value: u128,
) {
    config.min_proposal_deposit = value;
}
</code></pre>



</details>

<a name="0x1_DAOSpace_next_member_id"></a>

## Function `next_member_id`

Helpers
---------------------------------------------------


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_next_member_id">next_member_id</a>&lt;DAOT&gt;(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_next_member_id">next_member_id</a>&lt;DAOT&gt;(): u64 <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> dao = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>&gt;(dao_address);
    <b>let</b> member_id = dao.next_member_id;
    dao.next_member_id = member_id + 1;
    member_id
}
</code></pre>



</details>

<a name="0x1_DAOSpace_next_proposal_id"></a>

## Function `next_proposal_id`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_next_proposal_id">next_proposal_id</a>&lt;DAOT&gt;(): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_next_proposal_id">next_proposal_id</a>&lt;DAOT&gt;(): u64 <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> {
    <b>let</b> dao_address = <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;();
    <b>let</b> dao = <b>borrow_global_mut</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>&gt;(dao_address);
    <b>let</b> proposal_id = dao.next_proposal_id;
    dao.next_proposal_id = proposal_id + 1;
    proposal_id
}
</code></pre>



</details>

<a name="0x1_DAOSpace_assert_no_repeat"></a>

## Function `assert_no_repeat`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_assert_no_repeat">assert_no_repeat</a>&lt;E&gt;(v: &vector&lt;E&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_assert_no_repeat">assert_no_repeat</a>&lt;E&gt;(v: &vector&lt;E&gt;) {
    <b>let</b> i = 1;
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(v);
    <b>while</b> (i &lt; len) {
        <b>let</b> e = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(v, i);
        <b>let</b> j = 0;
        <b>while</b> (j &lt; i) {
            <b>let</b> f = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(v, j);
            <b>assert</b>!(e != f, <a href="Errors.md#0x1_Errors_invalid_argument">Errors::invalid_argument</a>(<a href="DAOSpace.md#0x1_DAOSpace_ERR_REPEAT_ELEMENT">ERR_REPEAT_ELEMENT</a>));
            j = j + 1;
        };
        i = i + 1;
    };
}
</code></pre>



</details>

<a name="0x1_DAOSpace_remove_element"></a>

## Function `remove_element`

Helper to remove an element from a vector.


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_remove_element">remove_element</a>&lt;E: drop&gt;(v: &<b>mut</b> vector&lt;E&gt;, x: &E)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_remove_element">remove_element</a>&lt;E: drop&gt;(v: &<b>mut</b> vector&lt;E&gt;, x: &E) {
    <b>let</b> (found, index) = <a href="Vector.md#0x1_Vector_index_of">Vector::index_of</a>(v, x);
    <b>if</b> (found) {
        <a href="Vector.md#0x1_Vector_remove">Vector::remove</a>(v, index);
    }
}
</code></pre>



</details>

<a name="0x1_DAOSpace_add_element"></a>

## Function `add_element`

Helper to add an element to a vector.


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_add_element">add_element</a>&lt;E: drop&gt;(v: &<b>mut</b> vector&lt;E&gt;, x: E)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_add_element">add_element</a>&lt;E: drop&gt;(v: &<b>mut</b> vector&lt;E&gt;, x: E) {
    <b>if</b> (!<a href="Vector.md#0x1_Vector_contains">Vector::contains</a>(v, &x)) {
        <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(v, x)
    }
}
</code></pre>



</details>

<a name="0x1_DAOSpace_convert_option_bytes_vector"></a>

## Function `convert_option_bytes_vector`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_convert_option_bytes_vector">convert_option_bytes_vector</a>(input: &vector&lt;<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;&gt;): vector&lt;vector&lt;u8&gt;&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_convert_option_bytes_vector">convert_option_bytes_vector</a>(input: &vector&lt;<a href="Option.md#0x1_Option_Option">Option::Option</a>&lt;vector&lt;u8&gt;&gt;&gt;): vector&lt;vector&lt;u8&gt;&gt; {
    <b>let</b> len = <a href="Vector.md#0x1_Vector_length">Vector::length</a>(input);
    <b>let</b> i = 0;
    <b>let</b> output = <a href="Vector.md#0x1_Vector_empty">Vector::empty</a>&lt;vector&lt;u8&gt;&gt;();
    <b>while</b> (i &lt; len) {
        <b>let</b> option = <a href="Vector.md#0x1_Vector_borrow">Vector::borrow</a>(input, i);
        <b>if</b> (<a href="Option.md#0x1_Option_is_some">Option::is_some</a>(option)){
            <a href="Vector.md#0x1_Vector_push_back">Vector::push_back</a>(&<b>mut</b> output, <a href="Option.md#0x1_Option_extract">Option::extract</a>(&<b>mut</b> *option));
        };
        i = i + 1;
    };
    output
}
</code></pre>



</details>

<a name="0x1_DAOSpace_dao_signer"></a>

## Function `dao_signer`



<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;(): signer
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_dao_signer">dao_signer</a>&lt;DAOT&gt;(): signer <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a> {
    <b>let</b> cap = &<b>borrow_global</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAOAccountCapHolder">DAOAccountCapHolder</a>&gt;(<a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;()).cap;
    <a href="DAOAccount.md#0x1_DAOAccount_dao_signer">DAOAccount::dao_signer</a>(cap)
}
</code></pre>



</details>

<a name="0x1_DAOSpace_dao_address"></a>

## Function `dao_address`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;(): <b>address</b>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_dao_address">dao_address</a>&lt;DAOT&gt;(): <b>address</b> {
    <a href="DAORegistry.md#0x1_DAORegistry_dao_address">DAORegistry::dao_address</a>&lt;DAOT&gt;()
}
</code></pre>



</details>

<a name="0x1_DAOSpace_dao_id"></a>

## Function `dao_id`



<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address: <b>address</b>): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="DAOSpace.md#0x1_DAOSpace_dao_id">dao_id</a>(dao_address: <b>address</b>): u64 <b>acquires</b> <a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a> {
    <b>if</b> (<b>exists</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>&gt;(dao_address)){
        <b>let</b> dao = <b>borrow_global</b>&lt;<a href="DAOSpace.md#0x1_DAOSpace_DAO">DAO</a>&gt;(dao_address);
        dao.id
    }<b>else</b>{
        0
    }
}
</code></pre>



</details>
