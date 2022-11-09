//# init -n dev

//# faucet --addr creator --amount 100000000000

//# faucet --addr alice --amount 10000000000

//# faucet --addr bob --amount 10000000000

//# faucet --addr cindy --amount 10000000000

//# block --author 0x1 --timestamp 86200000

//# publish
module creator::DAOHelper {
    use StarcoinFramework::DAOAccount;
    use StarcoinFramework::DAOSpace::{Self};
    use StarcoinFramework::Option;
    use StarcoinFramework::InstallPluginProposalPlugin::InstallPluginProposalPlugin;
    use StarcoinFramework::AnyMemberPlugin::AnyMemberPlugin;
    use StarcoinFramework::AnyMemberPlugin;
    use StarcoinFramework::InstallPluginProposalPlugin;
    use StarcoinFramework::MemberProposalPlugin;
    use StarcoinFramework::MemberProposalPlugin::MemberProposalPlugin;

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

        let config = DAOSpace::new_dao_config(
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            min_proposal_deposit,
        );
        let dao_root_cap = DAOSpace::create_dao<X>(dao_account_cap, *&NAME, Option::none<vector<u8>>(), Option::none<vector<u8>>(), b"ipfs://description", X{}, config);

        let install_cap = DAOSpace::acquire_install_plugin_cap<X, X>(&X{});
        DAOSpace::install_plugin<X, X, InstallPluginProposalPlugin>(&install_cap, InstallPluginProposalPlugin::required_caps());
        DAOSpace::install_plugin<X, X, AnyMemberPlugin>(&install_cap, AnyMemberPlugin::required_caps());
        DAOSpace::install_plugin<X, X, MemberProposalPlugin>(&install_cap, MemberProposalPlugin::required_caps());

        DAOSpace::burn_root_cap(dao_root_cap);

    }

    public fun create_offer_proposal(sender: &signer, title:vector<u8>, introduction:vector<u8>, description: vector<u8>, member: address, image_data:vector<u8>, image_url:vector<u8>, init_sbt: u128, action_delay: u64){
        MemberProposalPlugin::create_proposal<X>(sender, title, introduction, description, member, image_data, image_url,init_sbt, action_delay);
    }

    public fun execute_offer_proposal(sender: &signer, proposal_id: u64){
        MemberProposalPlugin::execute_proposal<X>(sender, proposal_id);
    }

    public fun add_member(sender: &signer, image_data:vector<u8>, image_url:vector<u8>){
        AnyMemberPlugin::join<X>(sender, image_data, image_url);
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

//# block --author 0x1 --timestamp 86400010

//# run --signers alice
script {
    use creator::DAOHelper::{Self};
    fun add_member(sender: signer){
        DAOHelper::add_member(&sender, b"",b"ipfs://");
    }

}
//# block --author 0x1 --timestamp 86400020

//# block --author 0x1 --timestamp 86400030

//# block --author 0x1 --timestamp 86400040

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

//# run --signers alice
script{
    use creator::DAOHelper::{Self};

    //alice create grant to alice
    fun create_offer_proposal(sender: signer){
        DAOHelper::create_offer_proposal(&sender, b"Add member",b"Add bob to DAO", b"ipfs://",@bob,b"",b"ipfs://",1, 10000);
    }
}
// check: EXECUTED

//# block --author 0x1 --timestamp 86411000

//# call-api chain.get_block_by_hash ["{{$.call-api[0].head.parent_hash}}",{"raw":true}]

//# call 0x1::SnapshotUtil::get_access_path --type-args 0x662ba5a1a1da0f1c70a9762c7eeb7aaf::DAOHelper::X --args {{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}

//# call-api state.get_with_proof_by_root_raw ["{{$.call[0]}}","{{$.call-api[2].header.state_root}}"]

//# run --signers alice --args {{$.call-api[3]}}
script{
    use creator::DAOHelper::{X};
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::Debug;

    // alice vote
    fun cast_vote(sender: signer, snpashot_raw_proofs: vector<u8>){
        let choice = DAOSpace::choice_yes();
        Debug::print(&choice);

        DAOSpace::cast_vote<X>(&sender, 1, snpashot_raw_proofs, choice);
    }
}
// check: EXECUTED

//# block --author 0x1 --timestamp 90012000

//# run --signers bob
script{
    use creator::DAOHelper::{X};
    use StarcoinFramework::DAOSpace;

    // execute action
    fun queue_proposal_action(_sender: signer){
        DAOSpace::queue_proposal_action<X>(1);
    }
}
// check: EXECUTED

//# block --author 0x4 --timestamp 90022000

//# run --signers alice
script{
    use creator::DAOHelper::{X};
    use StarcoinFramework::MemberProposalPlugin;

    // execute action
    fun execute_action(sender: signer){
        MemberProposalPlugin::execute_proposal<X>(&sender,1);
    }
}
// check: EXECUTED

//# run --signers bob
script{
    use creator::DAOHelper::{X};
    use StarcoinFramework::DAOSpace;

    // execute action
    fun join(sender: signer){
        DAOSpace::accept_member_offer_entry<X>(sender);
    }
}
// check: EXECUTED