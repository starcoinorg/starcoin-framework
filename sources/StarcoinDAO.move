module StarcoinFramework::StarcoinDAO{
    use StarcoinFramework::DAOAccount;
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::UpgradeModulePlugin::{Self, UpgradeModulePlugin};
    use StarcoinFramework::ConfigProposalPlugin::{Self, ConfigProposalPlugin};
    use StarcoinFramework::StakeToSBTPlugin::{Self, StakeToSBTPlugin};  
    use StarcoinFramework::InstallPluginProposalPlugin::{Self, InstallPluginProposalPlugin};
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Option;

    friend StarcoinFramework::Genesis;
    friend StarcoinFramework::StdlibUpgradeScripts;

    struct STARCOINDAO has store{}

    const NAME: vector<u8> = b"StarcoinDAO";
    
    public (friend) fun create_dao(
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        min_proposal_deposit: u128
    ){
        let dao_account_cap = DAOAccount::upgrade_starcoin_dao();

        let config = DAOSpace::new_dao_config(
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            min_proposal_deposit,
        );

        let dao_root_cap = DAOSpace::create_dao<STARCOINDAO>(dao_account_cap, *&NAME,Option::none<vector<u8>>(), Option::none<vector<u8>>(), b"ipfs://description", STARCOINDAO{}, config);
        DAOSpace::install_plugin_with_root_cap<STARCOINDAO, InstallPluginProposalPlugin>(&dao_root_cap, InstallPluginProposalPlugin::required_caps()); 
        DAOSpace::install_plugin_with_root_cap<STARCOINDAO, UpgradeModulePlugin>(&dao_root_cap,UpgradeModulePlugin::required_caps());
        DAOSpace::install_plugin_with_root_cap<STARCOINDAO, ConfigProposalPlugin>(&dao_root_cap, ConfigProposalPlugin::required_caps());
        
        DAOSpace::install_plugin_with_root_cap<STARCOINDAO, StakeToSBTPlugin>(&dao_root_cap, StakeToSBTPlugin::required_caps());
        StakeToSBTPlugin::accept_token_with_root_cap<STARCOINDAO, STC>(&dao_root_cap);
        StakeToSBTPlugin::set_sbt_weight_with_root_cap<STARCOINDAO, STC>(&dao_root_cap, 10, 2000);
        
        DAOSpace::burn_root_cap(dao_root_cap);

    }
}