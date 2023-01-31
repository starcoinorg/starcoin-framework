
<a name="0x1_StarcoinDAO"></a>

# Module `0x1::StarcoinDAO`



-  [Struct `StarcoinDAO`](#0x1_StarcoinDAO_StarcoinDAO)
-  [Constants](#@Constants_0)
-  [Function `create_dao`](#0x1_StarcoinDAO_create_dao)
-  [Function `delegate_config_capability`](#0x1_StarcoinDAO_delegate_config_capability)
-  [Function `set_treasury_withdraw_proposal_scale`](#0x1_StarcoinDAO_set_treasury_withdraw_proposal_scale)


<pre><code><b>use</b> <a href="Account.md#0x1_Account">0x1::Account</a>;
<b>use</b> <a href="Config.md#0x1_Config">0x1::Config</a>;
<b>use</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">0x1::ConfigProposalPlugin</a>;
<b>use</b> <a href="DAOAccount.md#0x1_DAOAccount">0x1::DAOAccount</a>;
<b>use</b> <a href="DAOSpace.md#0x1_DAOSpace">0x1::DAOSpace</a>;
<b>use</b> <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">0x1::GasOracleProposalPlugin</a>;
<b>use</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">0x1::InstallPluginProposalPlugin</a>;
<b>use</b> <a href="Option.md#0x1_Option">0x1::Option</a>;
<b>use</b> <a href="PackageTxnManager.md#0x1_PackageTxnManager">0x1::PackageTxnManager</a>;
<b>use</b> <a href="STC.md#0x1_STC">0x1::STC</a>;
<b>use</b> <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">0x1::StakeToSBTPlugin</a>;
<b>use</b> <a href="TreasuryPlugin.md#0x1_TreasuryPlugin">0x1::TreasuryPlugin</a>;
<b>use</b> <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">0x1::UpgradeModulePlugin</a>;
</code></pre>



<a name="0x1_StarcoinDAO_StarcoinDAO"></a>

## Struct `StarcoinDAO`



<pre><code><b>struct</b> <a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a> <b>has</b> drop, store
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

<a name="@Constants_0"></a>

## Constants


<a name="0x1_StarcoinDAO_NAME"></a>



<pre><code><b>const</b> <a href="StarcoinDAO.md#0x1_StarcoinDAO_NAME">NAME</a>: vector&lt;u8&gt; = [83, 116, 97, 114, 99, 111, 105, 110, 68, 65, 79];
</code></pre>



<a name="0x1_StarcoinDAO_create_dao"></a>

## Function `create_dao`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="StarcoinDAO.md#0x1_StarcoinDAO_create_dao">create_dao</a>(signer_cap: <a href="Account.md#0x1_Account_SignerCapability">Account::SignerCapability</a>, upgrade_plan_cap: <a href="PackageTxnManager.md#0x1_PackageTxnManager_UpgradePlanCapability">PackageTxnManager::UpgradePlanCapability</a>, voting_delay: u64, voting_period: u64, voting_quorum_rate: u8, min_action_delay: u64, min_proposal_deposit: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="StarcoinDAO.md#0x1_StarcoinDAO_create_dao">create_dao</a>(
    signer_cap: <a href="Account.md#0x1_Account_SignerCapability">Account::SignerCapability</a>,
    upgrade_plan_cap: <a href="PackageTxnManager.md#0x1_PackageTxnManager_UpgradePlanCapability">PackageTxnManager::UpgradePlanCapability</a>,
    voting_delay: u64,
    voting_period: u64,
    voting_quorum_rate: u8,
    min_action_delay: u64,
    min_proposal_deposit: u128
) {
    <b>let</b> dao_account_cap = <a href="DAOAccount.md#0x1_DAOAccount_upgrade_to_dao_with_signer_cap_and_upgrade_plan_cap">DAOAccount::upgrade_to_dao_with_signer_cap_and_upgrade_plan_cap</a>(signer_cap, upgrade_plan_cap);

    <b>let</b> config = <a href="DAOSpace.md#0x1_DAOSpace_new_dao_config">DAOSpace::new_dao_config</a>(
        voting_delay,
        voting_period,
        voting_quorum_rate,
        min_action_delay,
        min_proposal_deposit,
    );


    <a href="DAOSpace.md#0x1_DAOSpace_create_dao">DAOSpace::create_dao</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>&gt;(dao_account_cap, *&<a href="StarcoinDAO.md#0x1_StarcoinDAO_NAME">NAME</a>, <a href="Option.md#0x1_Option_none">Option::none</a>&lt;vector&lt;u8&gt;&gt;(), <a href="Option.md#0x1_Option_none">Option::none</a>&lt;vector&lt;u8&gt;&gt;(), b"ipfs://description", config);

    <b>let</b> witness = <a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a> {};
    <b>let</b> install_cap = <a href="DAOSpace.md#0x1_DAOSpace_acquire_install_plugin_cap">DAOSpace::acquire_install_plugin_cap</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>&gt;(&witness);
    <a href="DAOSpace.md#0x1_DAOSpace_install_plugin">DAOSpace::install_plugin</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>&gt;(&install_cap, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_required_caps">InstallPluginProposalPlugin::required_caps</a>());
    <a href="DAOSpace.md#0x1_DAOSpace_install_plugin">DAOSpace::install_plugin</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin">UpgradeModulePlugin</a>&gt;(&install_cap, <a href="UpgradeModulePlugin.md#0x1_UpgradeModulePlugin_required_caps">UpgradeModulePlugin::required_caps</a>());
    <a href="DAOSpace.md#0x1_DAOSpace_install_plugin">DAOSpace::install_plugin</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">ConfigProposalPlugin</a>&gt;(&install_cap, <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_required_caps">ConfigProposalPlugin::required_caps</a>());
    <a href="DAOSpace.md#0x1_DAOSpace_install_plugin">DAOSpace::install_plugin</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin">StakeToSBTPlugin</a>&gt;(&install_cap, <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_required_caps">StakeToSBTPlugin::required_caps</a>());
    <a href="DAOSpace.md#0x1_DAOSpace_install_plugin">DAOSpace::install_plugin</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin">GasOracleProposalPlugin</a>&gt;(&install_cap, <a href="GasOracleProposalPlugin.md#0x1_GasOracleProposalPlugin_required_caps">GasOracleProposalPlugin::required_caps</a>());
    <a href="DAOSpace.md#0x1_DAOSpace_install_plugin">DAOSpace::install_plugin</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="TreasuryPlugin.md#0x1_TreasuryPlugin">TreasuryPlugin</a>&gt;(&install_cap, <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_required_caps">TreasuryPlugin::required_caps</a>());

    <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_accept_token_by_dao">StakeToSBTPlugin::accept_token_by_dao</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="STC.md#0x1_STC">STC</a>&gt;(&witness);
    <a href="StakeToSBTPlugin.md#0x1_StakeToSBTPlugin_set_sbt_weight_by_dao">StakeToSBTPlugin::set_sbt_weight_by_dao</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="STC.md#0x1_STC">STC</a>&gt;(&witness, 60000, 1000);
}
</code></pre>



</details>

<a name="0x1_StarcoinDAO_delegate_config_capability"></a>

## Function `delegate_config_capability`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="StarcoinDAO.md#0x1_StarcoinDAO_delegate_config_capability">delegate_config_capability</a>&lt;TokenT: store, ConfigT: <b>copy</b>, drop, store&gt;(cap: <a href="Config.md#0x1_Config_ModifyConfigCapability">Config::ModifyConfigCapability</a>&lt;ConfigT&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="StarcoinDAO.md#0x1_StarcoinDAO_delegate_config_capability">delegate_config_capability</a>&lt;TokenT: store, ConfigT: <b>copy</b> + drop + store&gt;(cap: <a href="Config.md#0x1_Config_ModifyConfigCapability">Config::ModifyConfigCapability</a>&lt;ConfigT&gt;) {
    <a href="DAOSpace.md#0x1_DAOSpace_set_custom_config_cap">DAOSpace::set_custom_config_cap</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, ConfigT&gt;(cap);
}
</code></pre>



</details>

<a name="0x1_StarcoinDAO_set_treasury_withdraw_proposal_scale"></a>

## Function `set_treasury_withdraw_proposal_scale`

scale up the quorum votes for treasury withdraw proposal.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="StarcoinDAO.md#0x1_StarcoinDAO_set_treasury_withdraw_proposal_scale">set_treasury_withdraw_proposal_scale</a>(scale: u8)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="StarcoinDAO.md#0x1_StarcoinDAO_set_treasury_withdraw_proposal_scale">set_treasury_withdraw_proposal_scale</a>(scale: u8) {
    <a href="TreasuryPlugin.md#0x1_TreasuryPlugin_set_scale_factor">TreasuryPlugin::set_scale_factor</a>(scale, &<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a> {});
}
</code></pre>



</details>
