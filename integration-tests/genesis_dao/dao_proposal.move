//# init -n dev

//# faucet --addr creator --amount 100000000000

//# faucet --addr alice --amount 10000000000

//# faucet --addr bob --amount 10000000000

// TODO figure out how to call genesis init script in integration tests

//# run --signers creator
script{
    use StarcoinFramework::StdlibUpgradeScripts;
    
    fun main(){
        StdlibUpgradeScripts::upgrade_from_v11_to_v12();
    }
}
// check: EXECUTED

//# publish
module creator::DAOHelper {
    use StarcoinFramework::DaoAccount;
    use StarcoinFramework::GenesisDao::{Self, CapType};
    use StarcoinFramework::MemberProposalPlugin::{Self, MemberProposalPlugin};
    use StarcoinFramework::InstallPluginProposalPlugin::{Self, InstallPluginProposalPlugin};
    use StarcoinFramework::Account;
    use StarcoinFramework::Vector;

    struct X has store, copy, drop{}
    
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

        GenesisDao::install_plugin_with_root_cap<X, XPlugin>(&dao_root_cap, required_caps());

        GenesisDao::burn_root_cap(dao_root_cap);
    }

    struct XPlugin has drop{}

    struct XAction<phantom TokenT> has store {
        total: u128,
        receiver: address,
    }

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(GenesisDao::proposal_cap_type());
        Vector::push_back(&mut caps, GenesisDao::install_plugin_cap_type());
        Vector::push_back(&mut caps, GenesisDao::member_cap_type());
        Vector::push_back(&mut caps, GenesisDao::withdraw_token_cap_type());
        caps
    }

    public fun create_x_proposal<DaoT: store, TokenT:store>(sender: &signer, total: u128, receiver:address, action_delay:u64): u64{
        let witness = XPlugin{};
        let cap = GenesisDao::acquire_proposal_cap<DaoT, XPlugin>(&witness);
        let action = XAction<TokenT>{
            total,
            receiver,
        };
        GenesisDao::create_proposal(&cap, sender, action, action_delay)
    }

    public fun execute_x_proposal<DaoT: store, TokenT:store>(sender: &signer, proposal_id: u64){
        let witness = XPlugin{};
        let proposal_cap = GenesisDao::acquire_proposal_cap<DaoT, XPlugin>(&witness);
        let XAction{receiver, total} = GenesisDao::execute_proposal<DaoT, XPlugin, XAction<TokenT>>(&proposal_cap, sender, proposal_id);
        let withdraw_cap = GenesisDao::acquire_withdraw_token_cap<DaoT, XPlugin>(&witness);
        let token = GenesisDao::withdraw_token<DaoT, XPlugin, TokenT>(&withdraw_cap, total);
        Account::deposit(receiver, token);
    }

    public fun member_join<DaoT:store>(to_address: address, init_sbt: u128){
        let witness = XPlugin{};
        let member_cap = GenesisDao::acquire_member_cap<DaoT, XPlugin>(&witness);
        GenesisDao::join_member<DaoT, XPlugin>(&member_cap, to_address, init_sbt);
    }
}

//# run --signers creator
script{
    use creator::DAOHelper;
    
    fun main(sender: signer){
        DAOHelper::create_dao(sender, 10, 10, 10, 10, 10);
    }
}
// check: EXECUTED


//# run --signers alice
script{
    use creator::DAOHelper::{Self, X};
    use StarcoinFramework::IdentifierNFT;
    use StarcoinFramework::GenesisDao::{DaoMember, DaoMemberBody};
    use StarcoinFramework::Signer;

    fun member_join(sender: signer){
        //nft must be accept before grant
        IdentifierNFT::accept<DaoMember<X>, DaoMemberBody<X>>(&sender);

        let user_add = Signer::address_of(&sender);
        DAOHelper::member_join<X>(user_add, 100000u128);
    }
}
// check: EXECUTED


//# run --signers alice
script{
    use StarcoinFramework::STC::STC;
    use creator::DAOHelper::{Self, X};
    use StarcoinFramework::GenesisDao;
    use StarcoinFramework::Debug;

    fun create_proposal(sender: signer){
        let proposal_id = DAOHelper::create_x_proposal<X, STC>(&sender, 1000u128, @alice, 10);
//        (u64, address, u64, u64, u128, u128, u128, u128, u64, vector<u8>)
        let (id, proposer, start_time, end_time, yes_votes, no_votes, no_with_veto_votes, abstain_votes, block_number, state_root) = GenesisDao::proposal_info<X>(proposal_id);
        Debug::print(&proposer);
        Debug::print(&start_time);
        Debug::print(&block_number);
        Debug::print(&state_root);
    }
}
// check: EXECUTED