//# init -n dev

//// creator address is 0x662ba5a1a1da0f1c70a9762c7eeb7aaf
//# faucet --addr creator --amount 100000000000

//# faucet --addr alice --amount 10000000000

//// bob address is 0xb5d577dc9ce59725e29886632e69ecdf
//# faucet --addr bob --amount 10000000000

//# faucet --addr cindy --amount 10000000000


//# publish
module creator::DAOHelper {
    use StarcoinFramework::DAOAccount;
    use StarcoinFramework::DAOSpace::{Self, CapType, Proposal};
    use StarcoinFramework::MemberProposalPlugin::{Self, MemberProposalPlugin};
    use StarcoinFramework::InstallPluginProposalPlugin::{Self, InstallPluginProposalPlugin};
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
        DAOSpace::create_dao<X>(dao_account_cap, *&NAME, Option::none<vector<u8>>(), Option::none<vector<u8>>(), b"ipfs://description", X{}, config);
        
        let install_cap = DAOSpace::acquire_install_plugin_cap<X, X>(&X{});
        DAOSpace::install_plugin<X, X, InstallPluginProposalPlugin>(&install_cap, InstallPluginProposalPlugin::required_caps()); 
        DAOSpace::install_plugin<X, X, MemberProposalPlugin>(&install_cap, MemberProposalPlugin::required_caps());
        DAOSpace::install_plugin<X, X, XPlugin>(&install_cap, required_caps());
    }

    struct XPlugin has store, drop{}

    struct XAction<phantom TokenT> has store, drop {
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
        let proposal_id = DAOSpace::create_proposal(&cap, sender, action,b"title",b"ipfs://introduction", b"ipfs://extend", action_delay, Option::none<u8>());
        checkpoint<DAOT>(proposal_id);

        proposal_id
    }

    public fun reject_proposal<DAOT: store, TokenT:store>(sender: &signer, proposal_id: u64){
        DAOSpace::reject_proposal<DAOT, XAction<TokenT>>(sender, proposal_id);
    }

    public fun member_join<DAOT:store>(sender: &signer, init_sbt: u128){
        let witness = XPlugin{};
        let member_cap = DAOSpace::acquire_member_cap<DAOT, XPlugin>(&witness);
        DAOSpace::join_member_with_member_cap<DAOT, XPlugin>(&member_cap, sender, Option::none<vector<u8>>(), Option::none<vector<u8>>(), init_sbt);
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

    public fun proposal_state<DAOT:store>(proposal_id: u64): u8 {
        DAOSpace::proposal_state<DAOT>(proposal_id)
    }

    public fun proposal<DAOT:store>(proposal_id: u64): Proposal {
        DAOSpace::proposal<DAOT>(proposal_id)
    }
}

//# block --author 0x1 --timestamp 86410000

//# run --signers creator
script{
    use creator::DAOHelper;

    fun main(sender: signer){
        // time unit is millsecond
        DAOHelper::create_dao(sender, 10000, 600000, 2, 10000, 1000);
    }
}
// check: EXECUTED



//# run --signers alice
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


//# block --author=0x2 --timestamp 86415000

//# run --signers alice
script{
    use creator::DAOHelper::{Self, X};

    //alice join dao
    fun member_join(sender: signer){
        DAOHelper::member_join<X>(&sender, 10000u128);
    }
}
// check: EXECUTED

//# run --signers bob
script{
    use creator::DAOHelper::{Self, X};

    //bob join dao
    fun member_join(sender: signer){
        //nft must be accept before grant
        DAOHelper::member_join<X>(&sender, 30000u128);
    }
}
// check: EXECUTED

//# block --author=0x2 --timestamp 86418000

//# block --author=0x2 --timestamp 86420000

//# call-api chain.info

//# run --signers alice --args {{$.call-api[0].head.parent_hash}}
script {
    use StarcoinFramework::Block;
    use StarcoinFramework::Debug;

    fun checkpoint(_account: signer, parent_hash: vector<u8>) {
        let expect_parent_hash = Block::get_parent_hash();
        Debug::print(&expect_parent_hash);
        Debug::print(&parent_hash);
        assert!(expect_parent_hash == parent_hash, 1001);

        Block::checkpoint();
    }
}
// check: EXECUTED


//# block --author=0x2 --timestamp 86430000

//# call-api chain.get_block_by_hash ["{{$.call-api[0].head.block_hash}}",{"raw":true}]

//# run --signers alice  --args {{$.call-api[1].raw.header}}

script {
    use StarcoinFramework::Block;
    use StarcoinFramework::Debug;

    fun update(_account: signer, raw_header: vector<u8>) {
        let current_block_number = Block::get_current_block_number();
        Debug::print(&current_block_number);
        Debug::print(&raw_header);
        Block::update_state_root(raw_header);
    }
}
// check: ABORT. reason: Block from call-api[0] is not in checkpoint, its parent is in.


//# block --author=0x3 --timestamp 86450000

//# call-api chain.get_block_by_hash ["{{$.call-api[0].head.parent_hash}}",{"raw":true}]

//# run --signers alice  --args {{$.call-api[2].raw.header}}

script {
    use StarcoinFramework::Block;
    use StarcoinFramework::Debug;

    fun update(_account: signer, raw_header: vector<u8>) {
        Debug::print(&raw_header);
        Block::update_state_root(raw_header);
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
        let proposal = DAOSpace::proposal<X>(proposal_id);
        
        let proposer = DAOSpace::proposal_proposer(&proposal);
        let (start_time,end_time) = DAOSpace::proposal_time(&proposal);
        let block_number = DAOSpace::proposal_block_number(&proposal);
        let state_root = DAOSpace::proposal_state_root(&proposal);

        Debug::print(&proposer);
        Debug::print(&start_time);
        Debug::print(&end_time);
        Debug::print(&block_number);
        Debug::print(&state_root);
    }
}
// check: EXECUTED

//# block --author=0x3 --timestamp 86461000

//# run --signers bob --args {{$.faucet[0].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}} --args {{$.faucet[2].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}
script{
    use StarcoinFramework::Debug;

    /// faucet address generated from a hash of the faucet name
    fun print_faucet(_sender: signer, address1: address, address2: address){
        Debug::print(&address1);
        Debug::print(&address2);
    }
}

//# call 0x1::SnapshotUtil::get_access_path --type-args 0x662ba5a1a1da0f1c70a9762c7eeb7aaf::DAOHelper::X --args {{$.faucet[2].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}

//# call-api state.get_with_proof_by_root_raw ["{{$.call[0]}}","{{$.call-api[2].header.state_root}}"]

//# run --signers bob --args {{$.call-api[3]}}
script{
    use creator::DAOHelper::{Self, X};
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::Debug;

    // bob vote
    fun cast_vote(sender: signer, snpashot_raw_proofs: vector<u8>){
        let proposal_id = DAOHelper::last_proposal_id<X>();
        let choice = DAOSpace::choice_no_with_veto();
        Debug::print(&snpashot_raw_proofs);

        //deserize sbt
        // decode sbt value from snapshot state
//        let vote_weight = SBTVoteStrategy::get_voting_power(&snapshot_proof.state);

        DAOSpace::cast_vote<X>(&sender, proposal_id, snpashot_raw_proofs, choice);
    }
}
// check: EXECUTED


//# call 0x1::SnapshotUtil::get_access_path --type-args 0x662ba5a1a1da0f1c70a9762c7eeb7aaf::DAOHelper::X --args {{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}

//# call-api state.get_with_proof_by_root_raw ["{{$.call[1]}}","{{$.call-api[2].header.state_root}}"]

//# run --signers alice --args {{$.call-api[4]}}
script{
    use creator::DAOHelper::{Self, X};
    use StarcoinFramework::DAOSpace;
    //    use StarcoinFramework::Debug;

    // alice vote
    fun cast_vote(sender: signer, snpashot_raw_proofs: vector<u8>){
        let proposal_id = DAOHelper::last_proposal_id<X>();
        let choice = DAOSpace::choice_no_with_veto();
        DAOSpace::cast_vote<X>(&sender, proposal_id, snpashot_raw_proofs, choice);
    }
}
// check: EXECUTED


//# call 0x1::SnapshotUtil::get_access_path --type-args 0x662ba5a1a1da0f1c70a9762c7eeb7aaf::DAOHelper::X --args {{$.faucet[3].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}

//# call-api state.get_with_proof_by_root_raw ["{{$.call[2]}}","{{$.call-api[2].header.state_root}}"]

//# run --signers cindy --args {{$.call-api[5]}}
script{
    use creator::DAOHelper::{Self, X};
    use StarcoinFramework::DAOSpace;
    //    use StarcoinFramework::Debug;

    // cindy vote
    fun cast_vote(sender: signer, snpashot_raw_proofs: vector<u8>){
        let proposal_id = DAOHelper::last_proposal_id<X>();
        let choice = DAOSpace::choice_no_with_veto();
        DAOSpace::cast_vote<X>(&sender, proposal_id, snpashot_raw_proofs, choice);
    }
}
// check: ABORT


//# block --author 0x4 --timestamp 90060000

//# run --signers bob
script{
    use creator::DAOHelper::{Self, X};
    use StarcoinFramework::Debug;

    fun get_proposal_info(_sender: signer){
        let proposal_id = DAOHelper::last_proposal_id<X>();
        let proposal_state = DAOHelper::proposal_state<X>(proposal_id);
        Debug::print(&120100);
        Debug::print(&proposal_state);

        let proposal = DAOHelper::proposal<X>(proposal_id);
        Debug::print(&proposal);
    }
}
// check: EXECUTED


//# call-api state.list_resource ["0xb5d577dc9ce59725e29886632e69ecdf",{"decode":true}]

//# call-api state.get_resource ["0xb5d577dc9ce59725e29886632e69ecdf","0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT<0x00000000000000000000000000000001::DAOSpace::DAOMember<0x662ba5a1a1da0f1c70a9762c7eeb7aaf::DAOHelper::X>,0x00000000000000000000000000000001::DAOSpace::DAOMemberBody<0x662ba5a1a1da0f1c70a9762c7eeb7aaf::DAOHelper::X>>",{"decode":true}]


//# run --signers bob
script{
    use creator::DAOHelper::{Self, X};
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Token;
    use StarcoinFramework::DAOSpace;
    
    // execute action
    fun queue_proposal_action(sender: signer){
        let total = Token::market_cap<STC>();
        StarcoinFramework::Debug::print(&DAOSpace::proposal_state<X>(1));
        let proposal_id = DAOHelper::last_proposal_id<X>();
        DAOHelper::reject_proposal<X, STC>(&sender, proposal_id);
        assert!(total - (1000 - 1000 / 10)  == Token::market_cap<STC>(), 1001);
    }
}
// check: EXECUTED