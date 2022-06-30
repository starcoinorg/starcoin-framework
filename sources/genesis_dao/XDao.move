///this is a demo Dao, this module should generate by template
module StarcoinFramework::XDao{
    use StarcoinFramework::DaoAccount;
    use StarcoinFramework::GenesisDao;
    use StarcoinFramework::MemberProposalPlugin::{Self, MemberProposalPlugin};
    use StarcoinFramework::InstallPluginProposalPlugin::{Self, InstallPluginProposalPlugin};

    struct X has store{}
    
    const NAME: vector<u8> = b"X";

    /// sender should create a DaoAccount before call this entry function.
    public(script) fun create_dao(sender: signer, voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        min_proposal_deposit: u128,){
        //TODO check dao account address equals module address.
        let dao_account_cap = DaoAccount::extract_dao_account_cap(&sender);
        //let dao_signer = DaoAccount::dao_signer(&dao_account_cap);
        let config = GenesisDao::new_dao_config(
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            min_proposal_deposit,
        );
        let dao_root_cap = GenesisDao::create_dao<X>(dao_account_cap, *&NAME, X{}, config);
        
        GenesisDao::install_plugin_with_root_cap<X, InstallPluginProposalPlugin>(&dao_root_cap, InstallPluginProposalPlugin::required_caps()); 
        GenesisDao::install_plugin_with_root_cap<X, MemberProposalPlugin>(&dao_root_cap, MemberProposalPlugin::required_caps());
        
        GenesisDao::burn_root_cap(dao_root_cap);
    }


}