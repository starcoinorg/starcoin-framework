//# init -n dev

//# faucet --addr creator --amount 1000000000000000

//# faucet --addr alice --amount 1000000000000000

//# block --author 0x1 --timestamp 86400000

//# run --signers creator
script{
   use StarcoinFramework::StdlibUpgradeScripts;

   fun main(){
       StdlibUpgradeScripts::upgrade_from_v12_to_v12_1();
   }
}
// check: EXECUTED

//# run --signers alice
script {
    use StarcoinFramework::StakeToSBTPlugin;
    use StarcoinFramework::STC;
    use StarcoinFramework::Token;
    use StarcoinFramework::Account;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Debug;
    use StarcoinFramework::StarcoinDAO::StarcoinDAO;

    fun stake_and_check(sender: signer) {
        let token = Account::withdraw<STC::STC>(
            &sender, 1000 * Token::scaling_factor<STC::STC>());
        StakeToSBTPlugin::stake<StarcoinDAO, STC::STC>(&sender, token, 100000);

        let (
            stake_time,
            lock_time,
            weight,
            sbt_amount,
            token_amount
        ) = StakeToSBTPlugin::query_stake<StarcoinDAO, STC::STC>(Signer::address_of(&sender), 1);

        Debug::print(&stake_time);
        Debug::print(&lock_time);
        Debug::print(&weight);
        Debug::print(&sbt_amount);
        Debug::print(&token_amount);
    }
}
// check: EXECUTED

//# block --author 0x1 --timestamp 86401000

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


//# block --author=0x3 --timestamp 86450000

//# call-api chain.get_block_by_hash ["{{$.call-api[0].head.parent_hash}}",{"raw":true}]

//# run --signers alice  --args {{$.call-api[1].raw.header}}

script {
    use StarcoinFramework::Block;
    use StarcoinFramework::Debug;

    fun update(_account: signer, raw_header: vector<u8>) {
        Debug::print(&raw_header);
        Block::update_state_root(raw_header);
    }
}
// check: EXECUTED

//# package
module creator::test {
    public fun hello() {}
}

//# run --signers alice --args {{$.package[0].package_hash}}
script{
    use StarcoinFramework::StarcoinDAO::StarcoinDAO;
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::Debug;
    use StarcoinFramework::UpgradeModulePlugin;

    //alice create proposal
    fun create_proposal(sender: signer, package_hash: vector<u8>){
        UpgradeModulePlugin::create_proposal<StarcoinDAO>(&sender, b"Upgrade module", 10000, package_hash, 1, true);
        let (_id, proposer, start_time, end_time, _yes_votes, _no_votes, _no_with_veto_votes, _abstain_votes, block_number, state_root) = DAOSpace::proposal_info<StarcoinDAO>(1);

        Debug::print(&proposer);
        Debug::print(&start_time);
        Debug::print(&end_time);
        Debug::print(&block_number);
        Debug::print(&state_root);
    }
}
// check: EXECUTED


//# block --author=0x3 --timestamp 86520000

//# call 0x1::SnapshotUtil::get_access_path --type-args 0x1::StarcoinDAO::StarcoinDAO --args {{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}

//# call-api state.get_with_proof_by_root_raw ["{{$.call[0]}}","{{$.call-api[1].header.state_root}}"]


//# run --signers alice --args {{$.call-api[2]}}
script{
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::Debug;
    use StarcoinFramework::StarcoinDAO::StarcoinDAO;
    // alice vote
    fun cast_vote(sender: signer, snpashot_raw_proofs: vector<u8>){
        
        Debug::print(&snpashot_raw_proofs);

        DAOSpace::cast_vote_entry<StarcoinDAO>(sender, 1, snpashot_raw_proofs, 1);
    }
}
// check: EXECUTED


//# block --author=0x3 --timestamp 86640000

//# run --signers alice
script{
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::StarcoinDAO::StarcoinDAO;
    fun state(_sender: signer){
        StarcoinFramework::Debug::print(&DAOSpace::proposal_state<StarcoinDAO>(1));
        let (id, proposer, start_time, end_time, yes_votes, no_votes, abstain_votes, veto_votes, block_number, state_root) = DAOSpace::proposal_info<StarcoinDAO>(1);
        StarcoinFramework::Debug::print(&yes_votes);
        // assert!(DAOSpace::proposal_state<StarcoinDAO>(1) == 4,10);
    }
}
// check: EXECUTED
