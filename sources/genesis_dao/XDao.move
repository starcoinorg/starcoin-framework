///this is a demo Dao, this module should generate by template
module StarcoinFramework::XDao{
    use StarcoinFramework::DaoAccount;
    use StarcoinFramework::GenesisDao;
    use StarcoinFramework::MemberProposalPlugin::{Self, MemberProposalPlugin};
    use StarcoinFramework::InstallPluginProposalPlugin::{Self, InstallPluginProposalPlugin};

    struct X has store{}
    
    const NAME: vector<u8> = b"X";

    /// sender should create a DaoAccount before call this entry function.
    public(script) fun create_dao(sender: signer){
        //TODO check dao account address equals module address.
        let dao_account_cap = DaoAccount::extract_dao_account_cap(&sender);
        //let dao_signer = DaoAccount::dao_signer(&dao_account_cap);
        let dao_root_cap = GenesisDao::create_dao<X>(dao_account_cap, *&NAME, X{});
        
        GenesisDao::install_plugin_with_root_cap<X, InstallPluginProposalPlugin>(&dao_root_cap, InstallPluginProposalPlugin::required_caps()); 
        GenesisDao::install_plugin_with_root_cap<X, MemberProposalPlugin>(&dao_root_cap, MemberProposalPlugin::required_caps());
        
        GenesisDao::burn_root_cap(dao_root_cap);
    }


}