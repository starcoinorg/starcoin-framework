//# init -n dev

//# faucet --addr creator --amount 100000000000

// TODO figure out how to call genesis init script in integration tests

// //# run --signers creator
// script{
//     use StarcoinFramework::StdlibUpgradeScripts;

//     fun main(){
//         StdlibUpgradeScripts::upgrade_from_v12_to_v12_1();
//     }
// }

//# publish
module creator::XDAO {
    use StarcoinFramework::DAOAccount;
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::Option;
    use StarcoinFramework::MemberProposalPlugin::{Self, MemberProposalPlugin};
    use StarcoinFramework::InstallPluginProposalPlugin::{Self, InstallPluginProposalPlugin};

    struct X has store, drop {}
    
    const NAME: vector<u8> = b"X";

    /// directly upgrade the sender account to DAOAccount and create DAO
    public(script) fun create_dao(
        sender: signer, 
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        min_proposal_deposit: u128,){
        let dao_account_cap = DAOAccount::upgrade_to_dao(sender);
        //let dao_signer = DAOAccount::dao_signer(&dao_account_cap);
        let config = DAOSpace::new_dao_config(
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            min_proposal_deposit,
        );
        let dao_root_cap = DAOSpace::create_dao<X>(dao_account_cap, *&NAME, Option::none<vector<u8>>(), Option::none<vector<u8>>(),b"ipfs://description", X{}, config);
        
        let install_cap = DAOSpace::acquire_install_plugin_cap<X, X>(&X{});
        DAOSpace::install_plugin<X, X, InstallPluginProposalPlugin>(&install_cap, InstallPluginProposalPlugin::required_caps()); 
        DAOSpace::install_plugin<X, X, MemberProposalPlugin>(&install_cap, MemberProposalPlugin::required_caps());
        
        DAOSpace::burn_root_cap(dao_root_cap);
    }
}

//# run --signers creator
script{
    use creator::XDAO;
    
    fun main(sender: signer){
        XDAO::create_dao(sender, 10, 10, 10, 10, 10);
    }
}

//# view --address creator --resource 0x1::DAOSpace::DAO

//# view --address creator --resource 0x1::DAOSpace::InstalledPluginInfo<0x1::InstallPluginProposalPlugin::InstallPluginProposalPlugin>

//# view --address creator --resource 0x1::DAOSpace::InstalledPluginInfo<0x1::MemberProposalPlugin::MemberProposalPlugin>