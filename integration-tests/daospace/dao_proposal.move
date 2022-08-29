//# init -n dev

//# faucet --addr creator --amount 100000000000

//# faucet --addr alice --amount 10000000000

//# faucet --addr bob --amount 10000000000

//# faucet --addr cindy --amount 10000000000

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
    use StarcoinFramework::DAOAccount;
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::MemberProposalPlugin::{Self, MemberProposalPlugin};
    use StarcoinFramework::InstallPluginProposalPlugin::{Self, InstallPluginProposalPlugin};
    use StarcoinFramework::Account;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Option;

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
        let dao_account_cap = DAOAccount::upgrade_to_dao(sender);

        // checkpoint store
        let dao_signer = DAOAccount::dao_signer(&dao_account_cap);
        move_to(&dao_signer, Checkpoint<X> {
            proposal_id:0,
        });

        //let dao_signer = DAOAccount::dao_signer(&dao_account_cap);
        let config = DAOSpace::new_dao_config(
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            min_proposal_deposit,
        );
        let dao_root_cap = DAOSpace::create_dao<X>(dao_account_cap, *&NAME, Option::none<vector<u8>>(), Option::none<vector<u8>>(), b"ipfs://description", X{}, config);
        
        DAOSpace::install_plugin_with_root_cap<X, InstallPluginProposalPlugin>(&dao_root_cap, InstallPluginProposalPlugin::required_caps()); 
        DAOSpace::install_plugin_with_root_cap<X, MemberProposalPlugin>(&dao_root_cap, MemberProposalPlugin::required_caps());

        DAOSpace::install_plugin_with_root_cap<X, XPlugin>(&dao_root_cap, required_caps());

        DAOSpace::burn_root_cap(dao_root_cap);

    }

    struct XPlugin has store, drop{}

    struct XAction<phantom TokenT> has store {
        total: u128,
        receiver: address,
    }

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::install_plugin_cap_type());
        Vector::push_back(&mut caps, DAOSpace::member_cap_type());
        Vector::push_back(&mut caps, DAOSpace::withdraw_token_cap_type());
        caps
    }

    public fun create_x_proposal<DAOT: store, TokenT:store>(sender: &signer, total: u128, receiver:address, action_delay:u64): u64 acquires Checkpoint {
        let witness = XPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, XPlugin>(&witness);
        let action = XAction<TokenT>{
            total,
            receiver,
        };
        let proposal_id = DAOSpace::create_proposal(&cap, sender, action, b"ipfs://description", action_delay);
        checkpoint<DAOT>(proposal_id);

        proposal_id
    }

    public fun execute_x_proposal<DAOT: store, TokenT:store>(sender: &signer, proposal_id: u64){
        let witness = XPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, XPlugin>(&witness);
        let XAction{receiver, total} = DAOSpace::execute_proposal<DAOT, XPlugin, XAction<TokenT>>(&proposal_cap, sender, proposal_id);
        let withdraw_cap = DAOSpace::acquire_withdraw_token_cap<DAOT, XPlugin>(&witness);
        let token = DAOSpace::withdraw_token<DAOT, XPlugin, TokenT>(&withdraw_cap, total);
        Account::deposit(receiver, token);
    }

    public fun member_join<DAOT:store>(to_address: address, init_sbt: u128){
        let witness = XPlugin{};
        let member_cap = DAOSpace::acquire_member_cap<DAOT, XPlugin>(&witness);
        DAOSpace::join_member<DAOT, XPlugin>(&member_cap, to_address, Option::none<vector<u8>>(), Option::none<vector<u8>>(), init_sbt);
    }

    struct Checkpoint<phantom DAOt:store> has key{
        //last proposal id
        proposal_id: u64,
    }

    public fun checkpoint<DAOT:store>(proposal_id: u64) acquires Checkpoint {
        let checkpoint = borrow_global_mut<Checkpoint<DAOT>>(@creator);
        checkpoint.proposal_id = proposal_id;
    }

    public fun last_proposal_id<DAOT:store>(): u64 acquires Checkpoint {
        let checkpoint = borrow_global<Checkpoint<DAOT>>(@creator);
        checkpoint.proposal_id
    }
}

//# block --author 0x1 --timestamp 86400000

//# run --signers creator
script{
    use creator::DAOHelper;

    fun main(sender: signer){
        // time unit is millsecond
        DAOHelper::create_dao(sender, 10000, 3600000, 2, 10000, 10);
    }
}
// check: EXECUTED



//# run --signers creator
script{
    use creator::DAOHelper::{X};
    use StarcoinFramework::DAORegistry;
    use StarcoinFramework::Account;
    use StarcoinFramework::STC::STC;

    //deposit to dao address
    fun main(sender: signer){
        let dao_address = DAORegistry::dao_address<X>();
        let deposit = Account::withdraw<STC>(&sender, 500000);
        Account::deposit(dao_address, deposit);
    }
}
// check: EXECUTED

//# run --signers alice
script{
    use creator::DAOHelper::{X};
    use StarcoinFramework::Token;
    use StarcoinFramework::Debug;
    use StarcoinFramework::BCS;

    fun token_code(_sender: signer){
        //        let struct_tag = b"";
        let token_code = Token::token_code<X>();
        let bcs_token_code = BCS::to_bytes(&token_code);

        let offset = 0;
        let (address, offset) = BCS::deserialize_address(&bcs_token_code, offset);
        let (module_name, offset) = BCS::deserialize_bytes(&bcs_token_code, offset);
        let (name, _offset) = BCS::deserialize_bytes(&bcs_token_code, offset);
        Debug::print(&address);
        Debug::print(&module_name);
        Debug::print(&name);
        Debug::print(&110220);
        Debug::print(&token_code);
        Debug::print(&b"DAOHelper");
        Debug::print(&b"X");
    }
}
// check: EXECUTED

//# run --signers alice
script{
    use creator::DAOHelper::{Self, X};
    use StarcoinFramework::IdentifierNFT;
    use StarcoinFramework::DAOSpace::{DAOMember, DAOMemberBody};
    use StarcoinFramework::Signer;

    //alice join dao
    fun member_join(sender: signer){
        //nft must be accept before grant
        IdentifierNFT::accept<DAOMember<X>, DAOMemberBody<X>>(&sender);

        let user_add = Signer::address_of(&sender);
        DAOHelper::member_join<X>(user_add, 1000u128);
    }
}
// check: EXECUTED

//# run --signers bob
script{
    use creator::DAOHelper::{Self, X};
    use StarcoinFramework::IdentifierNFT;
    use StarcoinFramework::DAOSpace::{DAOMember, DAOMemberBody};
    use StarcoinFramework::Signer;

    //bob join dao
    fun member_join(sender: signer){
        //nft must be accept before grant
        IdentifierNFT::accept<DAOMember<X>, DAOMemberBody<X>>(&sender);

        let user_add = Signer::address_of(&sender);
        DAOHelper::member_join<X>(user_add, 3000u128);
    }
}
// check: EXECUTED


//# run --signers alice
script{
    use StarcoinFramework::STC::STC;
    use creator::DAOHelper::{Self, X};
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::Debug;

    //alice create proposal
    fun create_proposal(sender: signer){
        let proposal_id = DAOHelper::create_x_proposal<X, STC>(&sender, 100u128, @alice, 10000);
//        (u64, address, u64, u64, u128, u128, u128, u128, u64, vector<u8>)
        let (_id, proposer, start_time, end_time, _yes_votes, _no_votes, _no_with_veto_votes, _abstain_votes, block_number, state_root) = DAOSpace::proposal_info<X>(proposal_id);

        Debug::print(&proposer);
        Debug::print(&start_time);
        Debug::print(&end_time);
        Debug::print(&block_number);
        Debug::print(&state_root);

    }
}
// check: EXECUTED

//# block --author 0x1 --timestamp 86420000

//# run --signers bob
script{
    use creator::DAOHelper::{Self, X};
    use StarcoinFramework::DAOSpace;
//    use StarcoinFramework::Debug;

    // bob vote
    fun cast_vote(sender: signer){
        let proposal_id = DAOHelper::last_proposal_id<X>();
        let snapshot_proofs = x"";
        let choice = DAOSpace::choice_yes();
        DAOSpace::cast_vote<X>(&sender, proposal_id, snapshot_proofs, choice);
    }
}
// check: ABORT

////# run --signers alice
//script{
//    use creator::DAOHelper::{Self, X};
//    use StarcoinFramework::DAOSpace;
//    //    use StarcoinFramework::Debug;
//
//    // alice vote
//    fun cast_vote(sender: signer){
//        let proposal_id = DAOHelper::last_proposal_id<X>();
//        let snapshot_proofs = x"";
//        let choice = DAOSpace::choice_abstain();
//        DAOSpace::cast_vote<X>(&sender, proposal_id, snapshot_proofs, choice);
//    }
//}
//// check: EXECUTED
//
////# run --signers cindy
//script{
//    use creator::DAOHelper::{Self, X};
//    use StarcoinFramework::DAOSpace;
//    //    use StarcoinFramework::Debug;
//
//    // cindy vote
//    fun cast_vote(sender: signer){
//        let proposal_id = DAOHelper::last_proposal_id<X>();
//        let snapshot_proofs = x"";
//        let choice = DAOSpace::choice_yes();
//        DAOSpace::cast_vote<X>(&sender, proposal_id, snapshot_proofs, choice);
//    }
//}
//// check: ABORT


//# block --author 0x1 --timestamp 90015000

//# run --signers bob
script{
    use creator::DAOHelper::{Self, X};
    use StarcoinFramework::STC::STC;
    //    use StarcoinFramework::Debug;

    // execute action
    fun execute_action(sender: signer){
        let proposal_id = DAOHelper::last_proposal_id<X>();
        DAOHelper::execute_x_proposal<X, STC>(&sender, proposal_id);
    }
}
// check: ABORT
