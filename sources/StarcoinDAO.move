module StarcoinFramework::StarcoinDAO {
    use StarcoinFramework::DAOAccount;
    use StarcoinFramework::Account;
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::UpgradeModulePlugin::{Self, UpgradeModulePlugin};
    use StarcoinFramework::ConfigProposalPlugin::{Self, ConfigProposalPlugin};
    use StarcoinFramework::StakeToSBTPlugin::{Self, StakeToSBTPlugin};
    use StarcoinFramework::InstallPluginProposalPlugin::{Self, InstallPluginProposalPlugin};
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Option;
    use StarcoinFramework::GasOracleProposalPlugin::GasOracleProposalPlugin;
    use StarcoinFramework::GasOracleProposalPlugin;
    use StarcoinFramework::TreasuryPlugin::{Self, TreasuryPlugin};
    use StarcoinFramework::Config;
    use StarcoinFramework::PackageTxnManager;

    friend StarcoinFramework::Genesis;
    friend StarcoinFramework::StdlibUpgradeScripts;

    struct StarcoinDAO has store, drop {}

    const NAME: vector<u8> = b"StarcoinDAO";

    public(friend) fun create_dao(
        signer_cap: Account::SignerCapability,
        upgrade_plan_cap: PackageTxnManager::UpgradePlanCapability,
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        min_proposal_deposit: u128
    ) {
        let dao_account_cap = DAOAccount::upgrade_to_dao_with_signer_cap_and_upgrade_plan_cap(signer_cap, upgrade_plan_cap);

        let config = DAOSpace::new_dao_config(
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            min_proposal_deposit,
        );


        DAOSpace::create_dao<StarcoinDAO>(dao_account_cap, *&NAME, Option::none<vector<u8>>(), Option::none<vector<u8>>(), b"ipfs://description", config);

        let witness = StarcoinDAO {};
        let install_cap = DAOSpace::acquire_install_plugin_cap<StarcoinDAO, StarcoinDAO>(&witness);
        DAOSpace::install_plugin<StarcoinDAO, StarcoinDAO, InstallPluginProposalPlugin>(&install_cap, InstallPluginProposalPlugin::required_caps());
        DAOSpace::install_plugin<StarcoinDAO, StarcoinDAO, UpgradeModulePlugin>(&install_cap, UpgradeModulePlugin::required_caps());
        DAOSpace::install_plugin<StarcoinDAO, StarcoinDAO, ConfigProposalPlugin>(&install_cap, ConfigProposalPlugin::required_caps());
        DAOSpace::install_plugin<StarcoinDAO, StarcoinDAO, StakeToSBTPlugin>(&install_cap, StakeToSBTPlugin::required_caps());
        DAOSpace::install_plugin<StarcoinDAO, StarcoinDAO, GasOracleProposalPlugin>(&install_cap, GasOracleProposalPlugin::required_caps());
        DAOSpace::install_plugin<StarcoinDAO, StarcoinDAO, TreasuryPlugin>(&install_cap, TreasuryPlugin::required_caps());

        StakeToSBTPlugin::accept_token_by_dao<StarcoinDAO, STC>(&witness);
        StakeToSBTPlugin::set_sbt_weight_by_dao<StarcoinDAO, STC>(&witness, 60000, 1000);
    }

    public(friend) fun delegate_config_capability<TokenT: store, ConfigT: copy + drop + store>(cap: Config::ModifyConfigCapability<ConfigT>) {
        DAOSpace::set_custom_config_cap<StarcoinDAO, ConfigT>(cap);
    }

    /// scale up the quorum votes for treasury withdraw proposal.
    public(friend) fun set_treasury_withdraw_proposal_scale(scale: u8) {
        TreasuryPlugin::set_scale_factor(scale, &StarcoinDAO {});
    }
}