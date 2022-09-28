
<a name="0x1_StdlibUpgradeScripts"></a>

# Module `0x1::StdlibUpgradeScripts`

The module for StdlibUpgrade init scripts


-  [Function `upgrade_from_v2_to_v3`](#0x1_StdlibUpgradeScripts_upgrade_from_v2_to_v3)
-  [Function `take_linear_withdraw_capability`](#0x1_StdlibUpgradeScripts_take_linear_withdraw_capability)
-  [Function `do_upgrade_from_v5_to_v6`](#0x1_StdlibUpgradeScripts_do_upgrade_from_v5_to_v6)
-  [Function `upgrade_from_v5_to_v6`](#0x1_StdlibUpgradeScripts_upgrade_from_v5_to_v6)
-  [Function `upgrade_from_v6_to_v7`](#0x1_StdlibUpgradeScripts_upgrade_from_v6_to_v7)
-  [Function `do_upgrade_from_v6_to_v7`](#0x1_StdlibUpgradeScripts_do_upgrade_from_v6_to_v7)
-  [Function `do_upgrade_from_v6_to_v7_with_language_version`](#0x1_StdlibUpgradeScripts_do_upgrade_from_v6_to_v7_with_language_version)
-  [Function `upgrade_from_v7_to_v8`](#0x1_StdlibUpgradeScripts_upgrade_from_v7_to_v8)
-  [Function `do_upgrade_from_v7_to_v8`](#0x1_StdlibUpgradeScripts_do_upgrade_from_v7_to_v8)
-  [Function `upgrade_from_v11_to_v12`](#0x1_StdlibUpgradeScripts_upgrade_from_v11_to_v12)
-  [Function `do_upgrade_from_v11_to_v12`](#0x1_StdlibUpgradeScripts_do_upgrade_from_v11_to_v12)
-  [Module Specification](#@Module_Specification_0)


<pre><code><b>use</b> <a href="Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin">0x1::AnyMemberPlugin</a>;
<b>use</b> <a href="Block.md#0x1_Block">0x1::Block</a>;
<b>use</b> <a href="Collection.md#0x1_Collection">0x1::Collection</a>;
<b>use</b> <a href="Config.md#0x1_Config">0x1::Config</a>;
<b>use</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">0x1::ConfigProposalPlugin</a>;
<b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
<b>use</b> <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint">0x1::DAOExtensionPoint</a>;
<b>use</b> <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace">0x1::DAOPluginMarketplace</a>;
<b>use</b> <a href="DAORegistry.md#0x1_DAORegistry">0x1::DAORegistry</a>;
<b>use</b> <a href="Dao.md#0x1_Dao">0x1::Dao</a>;
<b>use</b> <a href="GenesisNFT.md#0x1_GenesisNFT">0x1::GenesisNFT</a>;
<b>use</b> <a href="GenesisSignerCapability.md#0x1_GenesisSignerCapability">0x1::GenesisSignerCapability</a>;
<b>use</b> <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin">0x1::GrantProposalPlugin</a>;
<b>use</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">0x1::InstallPluginProposalPlugin</a>;
<b>use</b> <a href="LanguageVersion.md#0x1_LanguageVersion">0x1::LanguageVersion</a>;
<b>use</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">0x1::MemberProposalPlugin</a>;
<b>use</b> <a href="MintProposalPlugin.md#0x1_MintProposalPlugin">0x1::MintProposalPlugin</a>;
<b>use</b> <a href="NFT.md#0x1_NFT">0x1::NFT</a>;
<b>use</b> <a href="Offer.md#0x1_Offer">0x1::Offer</a>;
<b>use</b> <a href="OnChainConfigDao.md#0x1_OnChainConfigDao">0x1::OnChainConfigDao</a>;
<b>use</b> <a href="Oracle.md#0x1_Oracle">0x1::Oracle</a>;
<b>use</b> <a href="STC.md#0x1_STC">0x1::STC</a>;
<b>use</b> <a href="Oracle.md#0x1_STCUSDOracle">0x1::STCUSDOracle</a>;
<b>use</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">0x1::StakeToSBTPlugin</a>;
<b>use</b> <a href="StarcoinDAO.md#0x1_StarcoinDAO">0x1::StarcoinDAO</a>;
<b>use</b> <a href="Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
<b>use</b> <a href="Token.md#0x1_Token">0x1::Token</a>;
<b>use</b> <a href="Treasury.md#0x1_Treasury">0x1::Treasury</a>;
<b>use</b> <a href="TreasuryWithdrawDaoProposal.md#0x1_TreasuryWithdrawDaoProposal">0x1::TreasuryWithdrawDaoProposal</a>;
<b>use</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">0x1::UpgradeModulePlugin</a>;
</code></pre>



<a name="0x1_StdlibUpgradeScripts_upgrade_from_v2_to_v3"></a>

## Function `upgrade_from_v2_to_v3`

Stdlib upgrade script from v2 to v3


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_upgrade_from_v2_to_v3">upgrade_from_v2_to_v3</a>(account: signer, total_stc_amount: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_upgrade_from_v2_to_v3">upgrade_from_v2_to_v3</a>(account: signer, total_stc_amount: u128 ) {
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(&account);

    <b>let</b> withdraw_cap = <a href="STC.md#0x1_STC_upgrade_from_v1_to_v2">STC::upgrade_from_v1_to_v2</a>(&account, total_stc_amount);

    <b>let</b> mint_keys = <a href="Collection.md#0x1_Collection_borrow_collection">Collection::borrow_collection</a>&lt;LinearTimeMintKey&lt;<a href="STC.md#0x1_STC">STC</a>&gt;&gt;(<a href="CoreAddresses.md#0x1_CoreAddresses_ASSOCIATION_ROOT_ADDRESS">CoreAddresses::ASSOCIATION_ROOT_ADDRESS</a>());
    <b>let</b> mint_key = <a href="Collection.md#0x1_Collection_borrow">Collection::borrow</a>(&mint_keys, 0);
    <b>let</b> (total, minted, start_time, period) = <a href="Token.md#0x1_Token_read_linear_time_key">Token::read_linear_time_key</a>(mint_key);
    <a href="Collection.md#0x1_Collection_return_collection">Collection::return_collection</a>(mint_keys);

    <b>let</b> now = <a href="Timestamp.md#0x1_Timestamp_now_seconds">Timestamp::now_seconds</a>();
    <b>let</b> linear_withdraw_cap = <a href="Treasury.md#0x1_Treasury_issue_linear_withdraw_capability">Treasury::issue_linear_withdraw_capability</a>(&<b>mut</b> withdraw_cap, total-minted, period - (now - start_time));
    // Lock the TreasuryWithdrawCapability <b>to</b> <a href="Dao.md#0x1_Dao">Dao</a>
    <a href="TreasuryWithdrawDaoProposal.md#0x1_TreasuryWithdrawDaoProposal_plugin">TreasuryWithdrawDaoProposal::plugin</a>(&account, withdraw_cap);
    // Give a LinearWithdrawCapability <a href="Offer.md#0x1_Offer">Offer</a> <b>to</b> association, association need <b>to</b> take the offer, and destroy <b>old</b> LinearTimeMintKey.
    <a href="Offer.md#0x1_Offer_create">Offer::create</a>(&account, linear_withdraw_cap, <a href="CoreAddresses.md#0x1_CoreAddresses_ASSOCIATION_ROOT_ADDRESS">CoreAddresses::ASSOCIATION_ROOT_ADDRESS</a>(), 0);
}
</code></pre>



</details>

<a name="0x1_StdlibUpgradeScripts_take_linear_withdraw_capability"></a>

## Function `take_linear_withdraw_capability`

association account should call this script after upgrade from v2 to v3.


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_take_linear_withdraw_capability">take_linear_withdraw_capability</a>(signer: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_take_linear_withdraw_capability">take_linear_withdraw_capability</a>(signer: signer){
    <b>let</b> offered = <a href="Offer.md#0x1_Offer_redeem">Offer::redeem</a>&lt;LinearWithdrawCapability&lt;<a href="STC.md#0x1_STC">STC</a>&gt;&gt;(&signer, <a href="CoreAddresses.md#0x1_CoreAddresses_GENESIS_ADDRESS">CoreAddresses::GENESIS_ADDRESS</a>());
    <a href="Treasury.md#0x1_Treasury_add_linear_withdraw_capability">Treasury::add_linear_withdraw_capability</a>(&signer, offered);
    <b>let</b> mint_key = <a href="Collection.md#0x1_Collection_take">Collection::take</a>&lt;LinearTimeMintKey&lt;<a href="STC.md#0x1_STC">STC</a>&gt;&gt;(&signer);
    <a href="Token.md#0x1_Token_destroy_linear_time_key">Token::destroy_linear_time_key</a>(mint_key);
}
</code></pre>



</details>

<a name="0x1_StdlibUpgradeScripts_do_upgrade_from_v5_to_v6"></a>

## Function `do_upgrade_from_v5_to_v6`



<pre><code><b>public</b> <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_do_upgrade_from_v5_to_v6">do_upgrade_from_v5_to_v6</a>(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_do_upgrade_from_v5_to_v6">do_upgrade_from_v5_to_v6</a>(sender: &signer) {
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_genesis_address">CoreAddresses::assert_genesis_address</a>(sender);
    <a href="Oracle.md#0x1_Oracle_initialize">Oracle::initialize</a>(sender);
    //register oracle
    <a href="Oracle.md#0x1_STCUSDOracle_register">STCUSDOracle::register</a>(sender);
    <a href="NFT.md#0x1_NFT_initialize">NFT::initialize</a>(sender);
    <b>let</b> merkle_root = x"5969f0e8e19f8769276fb638e6060d5c02e40088f5fde70a6778dd69d659ee6d";
    <b>let</b> image = b"ipfs://QmSPcvcXgdtHHiVTAAarzTeubk5X3iWymPAoKBfiRFjPMY";
    <a href="GenesisNFT.md#0x1_GenesisNFT_initialize">GenesisNFT::initialize</a>(sender, merkle_root, 1639u64, image);
}
</code></pre>



</details>

<a name="0x1_StdlibUpgradeScripts_upgrade_from_v5_to_v6"></a>

## Function `upgrade_from_v5_to_v6`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_upgrade_from_v5_to_v6">upgrade_from_v5_to_v6</a>(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_upgrade_from_v5_to_v6">upgrade_from_v5_to_v6</a>(sender: signer) {
   <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_do_upgrade_from_v5_to_v6">Self::do_upgrade_from_v5_to_v6</a>(&sender)
}
</code></pre>



</details>

<a name="0x1_StdlibUpgradeScripts_upgrade_from_v6_to_v7"></a>

## Function `upgrade_from_v6_to_v7`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_upgrade_from_v6_to_v7">upgrade_from_v6_to_v7</a>(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_upgrade_from_v6_to_v7">upgrade_from_v6_to_v7</a>(sender: signer) {
    <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_do_upgrade_from_v6_to_v7_with_language_version">Self::do_upgrade_from_v6_to_v7_with_language_version</a>(&sender, 2);
}
</code></pre>



</details>

<a name="0x1_StdlibUpgradeScripts_do_upgrade_from_v6_to_v7"></a>

## Function `do_upgrade_from_v6_to_v7`

deprecated, use <code>do_upgrade_from_v6_to_v7_with_language_version</code>.


<pre><code><b>public</b> <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_do_upgrade_from_v6_to_v7">do_upgrade_from_v6_to_v7</a>(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_do_upgrade_from_v6_to_v7">do_upgrade_from_v6_to_v7</a>(sender: &signer) {
   <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_do_upgrade_from_v6_to_v7_with_language_version">do_upgrade_from_v6_to_v7_with_language_version</a>(sender, 2);
}
</code></pre>



</details>

<a name="0x1_StdlibUpgradeScripts_do_upgrade_from_v6_to_v7_with_language_version"></a>

## Function `do_upgrade_from_v6_to_v7_with_language_version`



<pre><code><b>public</b> <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_do_upgrade_from_v6_to_v7_with_language_version">do_upgrade_from_v6_to_v7_with_language_version</a>(sender: &signer, language_version: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_do_upgrade_from_v6_to_v7_with_language_version">do_upgrade_from_v6_to_v7_with_language_version</a>(sender: &signer, language_version: u64) {
    // initialize the language version config.
    <a href="Config.md#0x1_Config_publish_new_config">Config::publish_new_config</a>(sender, <a href="LanguageVersion.md#0x1_LanguageVersion_new">LanguageVersion::new</a>(language_version));
    // <b>use</b> <a href="STC.md#0x1_STC">STC</a> <a href="Dao.md#0x1_Dao">Dao</a> <b>to</b> upgrade onchain's <b>move</b>-language-version configuration.
    <a href="OnChainConfigDao.md#0x1_OnChainConfigDao_plugin">OnChainConfigDao::plugin</a>&lt;<a href="STC.md#0x1_STC">STC</a>, <a href="LanguageVersion.md#0x1_LanguageVersion_LanguageVersion">LanguageVersion::LanguageVersion</a>&gt;(sender);
    // upgrade genesis <a href="NFT.md#0x1_NFT">NFT</a>
    <a href="GenesisNFT.md#0x1_GenesisNFT_upgrade_to_nft_type_info_v2">GenesisNFT::upgrade_to_nft_type_info_v2</a>(sender);
}
</code></pre>



</details>

<a name="0x1_StdlibUpgradeScripts_upgrade_from_v7_to_v8"></a>

## Function `upgrade_from_v7_to_v8`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_upgrade_from_v7_to_v8">upgrade_from_v7_to_v8</a>(sender: signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_upgrade_from_v7_to_v8">upgrade_from_v7_to_v8</a>(sender: signer) {
    <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_do_upgrade_from_v7_to_v8">do_upgrade_from_v7_to_v8</a>(&sender);
}
</code></pre>



</details>

<a name="0x1_StdlibUpgradeScripts_do_upgrade_from_v7_to_v8"></a>

## Function `do_upgrade_from_v7_to_v8`



<pre><code><b>public</b> <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_do_upgrade_from_v7_to_v8">do_upgrade_from_v7_to_v8</a>(sender: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_do_upgrade_from_v7_to_v8">do_upgrade_from_v7_to_v8</a>(sender: &signer) {
    {
        <b>let</b> cap = <a href="Oracle.md#0x1_Oracle_extract_signer_cap">Oracle::extract_signer_cap</a>(sender);
        <a href="GenesisSignerCapability.md#0x1_GenesisSignerCapability_initialize">GenesisSignerCapability::initialize</a>(sender, cap);
    };

    {
        <b>let</b> cap = <a href="NFT.md#0x1_NFT_extract_signer_cap">NFT::extract_signer_cap</a>(sender);
        <a href="Account.md#0x1_Account_destroy_signer_cap">Account::destroy_signer_cap</a>(cap);
    };
}
</code></pre>



</details>

<a name="0x1_StdlibUpgradeScripts_upgrade_from_v11_to_v12"></a>

## Function `upgrade_from_v11_to_v12`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_upgrade_from_v11_to_v12">upgrade_from_v11_to_v12</a>()
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_upgrade_from_v11_to_v12">upgrade_from_v11_to_v12</a>() {
    <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_do_upgrade_from_v11_to_v12">do_upgrade_from_v11_to_v12</a>();
}
</code></pre>



</details>

<a name="0x1_StdlibUpgradeScripts_do_upgrade_from_v11_to_v12"></a>

## Function `do_upgrade_from_v11_to_v12`



<pre><code><b>public</b> <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_do_upgrade_from_v11_to_v12">do_upgrade_from_v11_to_v12</a>()
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="StdlibUpgradeScripts.md#0x1_StdlibUpgradeScripts_do_upgrade_from_v11_to_v12">do_upgrade_from_v11_to_v12</a>() {
    <a href="Block.md#0x1_Block_checkpoints_init">Block::checkpoints_init</a>();
    <a href="DAORegistry.md#0x1_DAORegistry_initialize">DAORegistry::initialize</a>();

    <a href="DAOExtensionPoint.md#0x1_DAOExtensionPoint_initialize">DAOExtensionPoint::initialize</a>();
    <a href="DAOPluginMarketplace.md#0x1_DAOPluginMarketplace_initialize">DAOPluginMarketplace::initialize</a>();

    <a href="AnyMemberPlugin.md#0x1_AnyMemberPlugin_initialize">AnyMemberPlugin::initialize</a>();
    <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_initialize">ConfigProposalPlugin::initialize</a>();
    <a href="GrantProposalPlugin.md#0x1_GrantProposalPlugin_initialize">GrantProposalPlugin::initialize</a>();
    <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_initialize">InstallPluginProposalPlugin::initialize</a>();
    <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_initialize">MemberProposalPlugin::initialize</a>();
    <a href="MintProposalPlugin.md#0x1_MintProposalPlugin_initialize">MintProposalPlugin::initialize</a>();
    <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_initialize">StakeToSBTPlugin::initialize</a>();
    <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_initialize">UpgradeModulePlugin::initialize</a>();

    //TODO : config rate need mind
    // voting_delay: 60000 ms
    // voting_period: 3600000 ms
    // voting_quorum_rate: 4
    // min_action_delay: 3600000 ms
    <a href="StarcoinDAO.md#0x1_StarcoinDAO_create_dao">StarcoinDAO::create_dao</a>( <a href="Dao.md#0x1_Dao_voting_delay">Dao::voting_delay</a>&lt;<a href="STC.md#0x1_STC">STC</a>&gt;(), <a href="Dao.md#0x1_Dao_voting_period">Dao::voting_period</a>&lt;<a href="STC.md#0x1_STC">STC</a>&gt;(), <a href="Dao.md#0x1_Dao_voting_quorum_rate">Dao::voting_quorum_rate</a>&lt;<a href="STC.md#0x1_STC">STC</a>&gt;(), <a href="Dao.md#0x1_Dao_min_action_delay">Dao::min_action_delay</a>&lt;<a href="STC.md#0x1_STC">STC</a>&gt;(), 1000 * 1000 * 1000 * 1000);
}
</code></pre>



</details>

<a name="@Module_Specification_0"></a>

## Module Specification



<pre><code><b>pragma</b> verify = <b>false</b>;
<b>pragma</b> aborts_if_is_strict = <b>true</b>;
</code></pre>
