//# init -n dev

//# faucet --addr creator --amount 100000000000

// TODO figure out how to call genesis init script in integration tests

//# run --signers creator
script{
    use StarcoinFramework::StdlibUpgradeScripts;
    
    fun main(){
        StdlibUpgradeScripts::upgrade_from_v11_to_v12();
    }
}

//# publish
module creator::XDAO {
    use StarcoinFramework::DaoAccount;
    use StarcoinFramework::DaoSpace;
    use StarcoinFramework::MemberProposalPlugin::{Self, MemberProposalPlugin};
    use StarcoinFramework::InstallPluginProposalPlugin::{Self, InstallPluginProposalPlugin};

    struct X has store{}
    
    const NAME: vector<u8> = b"X";

    /// directly upgrade the sender account to DAOAccount and create DAO
    public(script) fun create_dao(
        sender: signer, 
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        min_proposal_deposit: u128,){
        let dao_account_cap = DaoAccount::upgrade_to_dao(sender);
        //let dao_signer = DaoAccount::dao_signer(&dao_account_cap);
        let config = DaoSpace::new_dao_config(
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            min_proposal_deposit,
        );
        let dao_root_cap = DaoSpace::create_dao<X>(dao_account_cap, *&NAME, X{}, config);
        
        DaoSpace::install_plugin_with_root_cap<X, InstallPluginProposalPlugin>(&dao_root_cap, InstallPluginProposalPlugin::required_caps()); 
        DaoSpace::install_plugin_with_root_cap<X, MemberProposalPlugin>(&dao_root_cap, MemberProposalPlugin::required_caps());
        
        DaoSpace::burn_root_cap(dao_root_cap);
    }
}

//# run --signers creator
script{
    use creator::XDAO;
    
    fun main(sender: signer){
        XDAO::create_dao(sender, 10, 10, 10, 10, 10);
    }
}