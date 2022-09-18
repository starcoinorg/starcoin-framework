//# init -n dev

//# faucet --addr creator --amount 100000000000

//# faucet --addr alice --amount 10000000000

//# faucet --addr bob --amount 10000000000

//# faucet --addr cindy --amount 10000000000

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
    use StarcoinFramework::AnyMemberPlugin::{Self, AnyMemberPlugin};
    use StarcoinFramework::InstallPluginProposalPlugin::{Self, InstallPluginProposalPlugin};
    use StarcoinFramework::MintProposalPlugin::{Self, MintProposalPlugin};
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
        DAOSpace::install_plugin_with_root_cap<XDAO, MintProposalPlugin>(&dao_root_cap, MintProposalPlugin::required_caps());

        DAOSpace::burn_root_cap(dao_root_cap);

    }
}

//# publish
module alice::AliceToken {
    use StarcoinFramework::Token;

    struct AliceToken has copy, drop, store { }

    public fun init(account: &signer) {
        Token::register_token<AliceToken>(
            account,
            3,
        );
    }
}

//# block --author 0x1 --timestamp 86400000

//# run --signers alice
script {
    use alice::AliceToken::{AliceToken, Self};
    use StarcoinFramework::Account;
    use StarcoinFramework::Token;

    fun main(account: signer) {
        AliceToken::init(&account);
        let market_cap = Token::market_cap<AliceToken>();
        assert!(market_cap == 0, 101);
        assert!(Token::is_registered_in<AliceToken>(@alice), 102);
        Account::do_accept_token<AliceToken>(&account);
    }
}
// check: EXECUTED

//# run --signers creator
script{
    use creator::XDAO;

    fun main(sender: signer){
        // time unit is millsecond
        XDAO::create_dao(sender, 10000, 360000, 1, 10000, 0);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use alice::AliceToken::AliceToken;
    use creator::XDAO::XDAO;
    use StarcoinFramework::MintProposalPlugin;

    fun main(sender: signer) {
        MintProposalPlugin::delegate_token_mint_cap_entry<XDAO, AliceToken>(sender);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use alice::AliceToken::AliceToken;
    use StarcoinFramework::Account;
    use StarcoinFramework::Token;
    use StarcoinFramework::Signer;
    
    fun main(sender: signer) {
        let token = Token::mint<AliceToken>(&sender, 100000);
        let receiver = Signer::address_of(&sender);
        Account::deposit<AliceToken>(receiver, token);
    }
}
// check: ABORTED, Alice don't have MintCapability

//# run --signers alice
script {
    use creator::XDAO::XDAO;
    use StarcoinFramework::AnyMemberPlugin;
    use StarcoinFramework::IdentifierNFT;
    use StarcoinFramework::DAOSpace::{DAOMember, DAOMemberBody};

    fun main(sender: signer) {
        IdentifierNFT::accept<DAOMember<XDAO>, DAOMemberBody<XDAO>>(&sender);
        let image_data = b"image";
        let image_url = b"";
        AnyMemberPlugin::join<XDAO>(&sender, image_data, image_url);
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

//# run --signers alice 
script {
    use alice::AliceToken::AliceToken;
    use creator::XDAO::XDAO;
    use StarcoinFramework::MintProposalPlugin;

    use StarcoinFramework::Debug;
    use StarcoinFramework::DAOSpace;

    fun main(sender: signer) {
        let description = b"mint to bob";
        let amount = 100000;
        let action_delay = 0;
        MintProposalPlugin::create_mint_proposal<XDAO, AliceToken>(
            &sender, description, @bob, amount, action_delay);

        let proposal = DAOSpace::proposal<XDAO>(1);
        
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

//# block --author=0x3 --timestamp 86460000

//# call 0x1::SnapshotUtil::get_access_path --type-args {{$.faucet[0].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::XDAO::XDAO --args {{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}

//# call-api state.get_with_proof_by_root_raw ["{{$.call[0]}}","{{$.call-api[1].header.state_root}}"]

//# run --signers alice --args {{$.call-api[2]}}
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

//# run --signers alice
script{
    use creator::XDAO::XDAO;
    use StarcoinFramework::DAOSpace;

    // execute action
    fun queue_proposal_action(_sender: signer){
        let proposal_id = 1;
        let proposal_state = DAOSpace::proposal_state<XDAO>(proposal_id);
        assert!(proposal_state == 5, 105); // DAOSpace::AGREED
        DAOSpace::queue_proposal_action<XDAO>(proposal_id);

    }
}
// check: EXECUTED

//# block --author=0x3 --timestamp 86840000

//# run --signers bob
script {
    use creator::XDAO::XDAO;
    use alice::AliceToken::AliceToken;
    use StarcoinFramework::MintProposalPlugin;
    use StarcoinFramework::Account;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Token;
    use StarcoinFramework::DAOSpace;

    fun main(sender: signer) {
        let proposal_id = 1;
        let proposal_state = DAOSpace::proposal_state<XDAO>(proposal_id);
        assert!(proposal_state == 7, 106); // DAOSpace::EXECUTABLE

        let addr = Signer::address_of(&sender);
        MintProposalPlugin::execute_mint_proposal<XDAO, AliceToken>(&sender, proposal_id);
        let balance = Account::balance<AliceToken>(addr);
        assert!(balance == 100000, 107);
        assert!(Token::market_cap<AliceToken>() == balance, 108);
    }
}