//# init -n dev

//# faucet --addr creator --amount 100000000000

//# faucet --addr boss --amount 10000000000

//# faucet --addr alice --amount 10000000000

//# faucet --addr bob --amount 10000000000

//# publish
module creator::XDAO {
    use StarcoinFramework::DAOAccount;
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::AnyMemberPlugin::{Self, AnyMemberPlugin};
    use StarcoinFramework::InstallPluginProposalPlugin::{Self, InstallPluginProposalPlugin};
    use StarcoinFramework::SalaryGovPlugin::{Self, SalaryGovPlugin};
    use StarcoinFramework::Option;

    struct XDAO has store, copy, drop{}

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
        let dao_root_cap = DAOSpace::create_dao<XDAO>(dao_account_cap, *&NAME, Option::none<vector<u8>>(),
            Option::none<vector<u8>>(), b"ipfs://description", XDAO{}, config);

        DAOSpace::install_plugin_with_root_cap<XDAO, InstallPluginProposalPlugin>(&dao_root_cap, InstallPluginProposalPlugin::required_caps());
        DAOSpace::install_plugin_with_root_cap<XDAO, AnyMemberPlugin>(&dao_root_cap, AnyMemberPlugin::required_caps());
        DAOSpace::install_plugin_with_root_cap<XDAO, SalaryGovPlugin>(&dao_root_cap, SalaryGovPlugin::required_caps());

        DAOSpace::burn_root_cap(dao_root_cap);

    }
}

//# block --author 0x1 --timestamp 86400000

//# run --signers creator
script{
    use creator::XDAO;

    fun main(sender: signer){
        // time unit is millsecond
        XDAO::create_dao(sender, 10000, 360000, 1, 10000, 0);
    }
}
// check: EXECUTED


//# run --signers boss
script {
    use creator::XDAO::XDAO;
    use StarcoinFramework::SalaryGovPlugin;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::IdentifierNFT;
    use StarcoinFramework::DAOSpace::{DAOMember, DAOMemberBody};

    fun main(sender: signer) {
        IdentifierNFT::accept<DAOMember<XDAO>, DAOMemberBody<XDAO>>(&sender);
        let image_data = b"image";
        let image_url = b"";
        SalaryGovPlugin::join<XDAO, STC>(sender, 60000, image_data, image_url);
    }
}
// check: EXECUTED


//# run --signers boss
script {
    use creator::XDAO::XDAO;
    use StarcoinFramework::SalaryGovPlugin;
    use StarcoinFramework::STC::STC;

    fun main(sender: signer) {
        SalaryGovPlugin::increase_salary<XDAO, STC>(sender, @boss, 1000);
    }
}
// check: EXECUTED

//# block --author 0x1 --timestamp 86410000

//# block --author=0x2 --timestamp 86420000

//# call-api chain.info

//# run --signers alice --args {{$.call-api[0].head.parent_hash}}
script {
    use StarcoinFramework::Block;

    fun checkpoint(_account: signer, parent_hash: vector<u8>) {
        let expect_parent_hash = Block::get_parent_hash();
        assert!(expect_parent_hash == parent_hash, 103);

        Block::checkpoint();
    }
}
// check: EXECUTED

//# block --author=0x3 --timestamp 86450000

//# call-api chain.get_block_by_hash ["{{$.call-api[0].head.parent_hash}}",{"raw":true}]

//# run --signers alice  --args {{$.call-api[1].raw.header}}

script {
    use StarcoinFramework::Block;

    fun update(_account: signer, raw_header: vector<u8>) {
        Block::update_state_root(raw_header);
    }
}
// check: EXECUTED

//# run --signers boss
script {
    use creator::XDAO::XDAO;
    use StarcoinFramework::SalaryGovPlugin;
    use StarcoinFramework::Debug;
    use StarcoinFramework::DAOSpace;

    fun main(sender: signer) {
        let description = b"select boss";
        let action_delay = 0;
        SalaryGovPlugin::create_boss_elect_proposal<XDAO>(
            sender, description, action_delay);
        let (_id, proposer, start_time, end_time, _yes_votes, _no_votes, _no_with_veto_votes, _abstain_votes, _block_number, _state_root) = DAOSpace::proposal_info<XDAO>(1);

        Debug::print(&proposer);
        Debug::print(&start_time);
        Debug::print(&end_time);

    }
}
// check: EXECUTED

//# block --author=0x3 --timestamp 86460000

//# call 0x1::SnapshotUtil::get_access_path --type-args {{$.faucet[0].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::XDAO::XDAO --args {{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}

//# call-api state.get_with_proof_by_root_raw ["{{$.call[0]}}","{{$.call-api[1].header.state_root}}"]

//# run --signers boss --args {{$.call-api[2]}}
script{
    use creator::XDAO::XDAO;
    use StarcoinFramework::DAOSpace;

    fun cast_vote(sender: signer, snpashot_raw_proofs: vector<u8>){
        let proposal_id = 1;
        let choice = DAOSpace::choice_yes();
        DAOSpace::cast_vote<XDAO>(&sender, proposal_id, snpashot_raw_proofs, choice);

        let proposal_state = DAOSpace::proposal_state<XDAO>(1);
        assert!(proposal_state == 2, 104); // DAOSpace::ACTIVE
    }
}
// check: EXECUTED

//# block --author=0x3 --timestamp 86830000

//# run --signers boss
script{
    use creator::XDAO::XDAO;
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::Debug;

    // execute action
    fun queue_proposal_action(sender: signer){
        let proposal_id = 1;

        let (_id, _proposer, _start_time, _end_time, yes_votes, no_votes, no_with_veto_votes, abstain_votes, _block_number, _state_root) = DAOSpace::proposal_info<XDAO>(1);

        Debug::print(&yes_votes);
        Debug::print(&no_votes);
        Debug::print(&no_with_veto_votes);
        Debug::print(&abstain_votes);

        let proposal_state = DAOSpace::proposal_state<XDAO>(proposal_id);
        Debug::print(&proposal_state);
        assert!(proposal_state == 4, 105); // DAOSpace::AGREED
        DAOSpace::do_queue_proposal_action<XDAO>(&sender, proposal_id);

    }
}
// check: EXECUTED

//# block --author=0x3 --timestamp 86840000

//# run --signers boss
script {
    use creator::XDAO::XDAO;
    use StarcoinFramework::SalaryGovPlugin;
    use StarcoinFramework::Account;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Token;
    use StarcoinFramework::DAOSpace;

    fun main(sender: signer) {
        let proposal_id = 1;
        let proposal_state = DAOSpace::proposal_state<XDAO>(proposal_id);
        assert!(proposal_state == 6, 106); // DAOSpace::EXECUTABLE

        SalaryGovPlugin::execute_proposal<XDAO>(sender, proposal_id);
    }
}
// check: EXECUTED

//# block --timestamp 90000000

//# run --signers alice
script {
    use creator::XDAO::XDAO;
    use StarcoinFramework::SalaryGovPlugin;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::IdentifierNFT;
    use StarcoinFramework::DAOSpace::{DAOMember, DAOMemberBody};

    fun main(sender: signer) {
        IdentifierNFT::accept<DAOMember<XDAO>, DAOMemberBody<XDAO>>(&sender);
        let image_data = b"image";
        let image_url = b"";
        SalaryGovPlugin::join<XDAO, STC>(sender, 60000, image_data, image_url);
    }
}
// check: EXECUTED

//# run --signers boss
script {
    use creator::XDAO::XDAO;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::SalaryGovPlugin;

    fun main(sender: signer) {
        let salary = 123332u128;
        SalaryGovPlugin::increase_salary<XDAO, STC>(sender, @alice, salary);
    }
}
// check: EXECUTED

//# block --timestamp 900525000

//# run --signers alice
script {
    use creator::XDAO::XDAO;
    use StarcoinFramework::SalaryGovPlugin;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Account;

    fun main(sender: signer) {
        let new_period = 2000;
        SalaryGovPlugin::member_apply_period<XDAO, STC>(sender, new_period);
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use creator::XDAO::XDAO;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::SalaryGovPlugin;

    fun main(sender: signer) {
        let new_period = 2000;
        SalaryGovPlugin::boss_confirm_period<XDAO, STC>(sender, @alice, new_period);
    }
}
// check: ABORTED, bob is not the boss.

//# run --signers boss
script {
    use creator::XDAO::XDAO;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::SalaryGovPlugin;

    fun main(sender: signer) {
        let new_period = 1000;
        SalaryGovPlugin::boss_confirm_period<XDAO, STC>(sender, @alice, new_period);
    }
}
// check: ABORTED, the confirming period is not same with application period.

//# run --signers boss
script {
    use creator::XDAO::XDAO;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::SalaryGovPlugin;
    use StarcoinFramework::Account;
    use StarcoinFramework::Math;

    fun main(sender: signer) {
        let new_period = 20000;
        let old_balance = Account::balance<STC>(@alice);
        SalaryGovPlugin::boss_confirm_period<XDAO, STC>(sender, @alice, new_period);
        let new_balance = Account::balance<STC>(@alice);

        let expect_received = Math::mul_div(123332u128, 900525000 - 90000000, 60000);
        assert!(new_balance == old_balance + expect_received, 101);
    }
}
// check: EXECUTED

//# block --timestamp 900921000

//# run --signers alice
script {
    use creator::XDAO::XDAO;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::SalaryGovPlugin;
    use StarcoinFramework::Account;
    use StarcoinFramework::Math;

    fun main(sender: signer) {
        let old_balance = Account::balance<STC>(@alice);
        SalaryGovPlugin::receive<XDAO, STC>(@alice);
        let new_balance = Account::balance<STC>(@alice);

        let expect_received = Math::mul_div(123332u128, 900921000 - 900525000, 20000);
        assert!(new_balance == old_balance +expect_received, 101);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use creator::XDAO::XDAO;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::SalaryGovPlugin;

    fun main(sender: signer) {
        SalaryGovPlugin::increase_salary<XDAO, STC>(sender, @alice, 20000u128);
    }
}
// check: ABORTED, only boss can increase_salary

//# run --signers boss
script {
    use creator::XDAO::XDAO;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::SalaryGovPlugin;

    fun main(sender: signer) {
        SalaryGovPlugin::increase_salary<XDAO, STC>(sender, @alice, 20000u128);
    }
}
// check: EXECUTED

//# block --timestamp 901921000

//# run --signers alice
script {
    use creator::XDAO::XDAO;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::SalaryGovPlugin;
    use StarcoinFramework::Account;
    use StarcoinFramework::Math;

    fun main(sender: signer) {
        let old_balance = Account::balance<STC>(@alice);
        SalaryGovPlugin::receive<XDAO, STC>(@alice);
        let new_balance = Account::balance<STC>(@alice);

        let expect_received = Math::mul_div(123332u128 + 20000u128, 901921000 - 900921000, 20000);
        assert!(new_balance == old_balance +expect_received, 101);
    }
}
// check: EXECUTED