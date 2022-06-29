
<a name="0x1_XDao"></a>

# Module `0x1::XDao`

this is a demo Dao, this module should generate by template


-  [Struct `X`](#0x1_XDao_X)
-  [Constants](#@Constants_0)
-  [Function `create_dao`](#0x1_XDao_create_dao)


<pre><code><b>use</b> <a href="DaoAccount.md#0x1_DaoAccount">0x1::DaoAccount</a>;
<b>use</b> <a href="GenesisDao.md#0x1_GenesisDao">0x1::GenesisDao</a>;
<b>use</b> <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">0x1::InstallPluginProposalPlugin</a>;
<b>use</b> <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">0x1::MemberProposalPlugin</a>;
</code></pre>



<a name="0x1_XDao_X"></a>

## Struct `X`



<pre><code><b>struct</b> <a href="XDao.md#0x1_XDao_X">X</a> <b>has</b> store
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


<a name="0x1_XDao_NAME"></a>



<pre><code><b>const</b> <a href="XDao.md#0x1_XDao_NAME">NAME</a>: vector&lt;u8&gt; = [88];
</code></pre>



<a name="0x1_XDao_create_dao"></a>

## Function `create_dao`

sender should create a DaoAccount before call this entry function.


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="XDao.md#0x1_XDao_create_dao">create_dao</a>(sender: signer, voting_delay: u64, voting_period: u64, voting_quorum_rate: u8, min_action_delay: u64, min_proposal_deposit: u128)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="XDao.md#0x1_XDao_create_dao">create_dao</a>(sender: signer, voting_delay: u64,
    voting_period: u64,
    voting_quorum_rate: u8,
    min_action_delay: u64,
    min_proposal_deposit: u128,){
    //TODO check dao account <b>address</b> equals <b>module</b> <b>address</b>.
    <b>let</b> dao_account_cap = <a href="DaoAccount.md#0x1_DaoAccount_extract_dao_account_cap">DaoAccount::extract_dao_account_cap</a>(&sender);
    //<b>let</b> dao_signer = <a href="DaoAccount.md#0x1_DaoAccount_dao_signer">DaoAccount::dao_signer</a>(&dao_account_cap);
    <b>let</b> config = <a href="GenesisDao.md#0x1_GenesisDao_new_dao_config">GenesisDao::new_dao_config</a>(
        voting_delay,
        voting_period,
        voting_quorum_rate,
        min_action_delay,
        min_proposal_deposit,
    );
    <b>let</b> dao_root_cap = <a href="GenesisDao.md#0x1_GenesisDao_create_dao">GenesisDao::create_dao</a>&lt;<a href="XDao.md#0x1_XDao_X">X</a>&gt;(dao_account_cap, *&<a href="XDao.md#0x1_XDao_NAME">NAME</a>, <a href="XDao.md#0x1_XDao_X">X</a>{}, config);

    <a href="GenesisDao.md#0x1_GenesisDao_install_plugin_with_root_cap">GenesisDao::install_plugin_with_root_cap</a>&lt;<a href="XDao.md#0x1_XDao_X">X</a>, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin">InstallPluginProposalPlugin</a>&gt;(&dao_root_cap, <a href="InstallPluginProposalPlugin.md#0x1_InstallPluginProposalPlugin_required_caps">InstallPluginProposalPlugin::required_caps</a>());
    <a href="GenesisDao.md#0x1_GenesisDao_install_plugin_with_root_cap">GenesisDao::install_plugin_with_root_cap</a>&lt;<a href="XDao.md#0x1_XDao_X">X</a>, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin">MemberProposalPlugin</a>&gt;(&dao_root_cap, <a href="MemberProposalPlugin.md#0x1_MemberProposalPlugin_required_caps">MemberProposalPlugin::required_caps</a>());

    <a href="GenesisDao.md#0x1_GenesisDao_burn_root_cap">GenesisDao::burn_root_cap</a>(dao_root_cap);
}
</code></pre>



</details>
