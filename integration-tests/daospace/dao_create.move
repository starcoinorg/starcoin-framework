//# init -n dev

//# faucet --addr alice --amount 10000000000

//# faucet --addr bob --amount 10000000000

//# block --author=0x3 --timestamp 900000

//# run --signers alice
script{
    use StarcoinFramework::DAOAccount;

    fun main(sender: signer){
        DAOAccount::create_account_entry(sender);
    }
}
// check: EXECUTED

//# view --address alice --resource 0x1::DAOAccount::DAOAccountCap

//# package
module 0xbf3a917cf4fb6425b95cc12763e6038b::XDAO {
    use StarcoinFramework::Option;
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::DAOAccount;
    use StarcoinFramework::Signer;
    use StarcoinFramework::InstallPluginProposalPlugin::{Self, InstallPluginProposalPlugin};
    use StarcoinFramework::MemberProposalPlugin::{Self, MemberProposalPlugin};
    struct X has store{}
    
    const NAME: vector<u8> = b"X";
    public (script) fun create_new_proposal_dao(
        sender: signer, 
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        min_proposal_deposit: u128,)
    {
                
        let config = DAOSpace::new_dao_config(
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            min_proposal_deposit,
        );

        let cap = DAOAccount::extract_dao_account_cap(&sender);
        let dao_root_cap = DAOSpace::create_dao<X>(cap, *&NAME, Option::none<vector<u8>>(), Option::none<vector<u8>>(), b"ipfs://description", X{}, config);
        
        let install_cap = DAOSpace::acquire_install_plugin_cap<X, X>(&X{});
        DAOSpace::install_plugin<X, X, InstallPluginProposalPlugin>(&install_cap, InstallPluginProposalPlugin::required_caps()); 
        DAOSpace::install_plugin<X, X, MemberProposalPlugin>(&install_cap, MemberProposalPlugin::required_caps());
        
        DAOSpace::join_member_with_root_cap(&dao_root_cap, Signer::address_of(&sender), Option::none<vector<u8>>(), Option::none<vector<u8>>(), 1);
        DAOSpace::burn_root_cap(dao_root_cap);
    }
}

//# run --signers alice --args {{$.package[0].package_hash}}
script{
    use StarcoinFramework::DAOAccount;

    fun main(sender: signer, package_hash: vector<u8>){
        DAOAccount::submit_upgrade_plan_entry(sender, package_hash, 1, false);
    }
}
// check: EXECUTED

//# block --author=0x3 --timestamp 90240000

//# deploy {{$.package[0].file}} --signers bob

//# run --signers alice
script{
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::IdentifierNFT;
    use 0xbf3a917cf4fb6425b95cc12763e6038b::XDAO::{Self, X};

    fun main(sender: signer){
        IdentifierNFT::accept<DAOSpace::DAOMember<X>, DAOSpace::DAOMemberBody<X>>(&sender);
        XDAO::create_new_proposal_dao(sender, 1000, 1000, 1, 1000, 1000);
    }
}
// check: EXECUTED