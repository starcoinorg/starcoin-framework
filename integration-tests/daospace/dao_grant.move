//# init -n dev

//# faucet --addr creator --amount 100000000000

//# faucet --addr alice --amount 10000000000

//# faucet --addr bob --amount 10000000000

//# faucet --addr cindy --amount 10000000000

//# block --author 0x1 --timestamp 86200000

//# publish
module creator::DAOHelper {
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::DAOAccount;
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::STC;
    use StarcoinFramework::Option;
    use StarcoinFramework::Signer;
    use StarcoinFramework::InstallPluginProposalPlugin::InstallPluginProposalPlugin;
    use StarcoinFramework::AnyMemberPlugin::AnyMemberPlugin;
    use StarcoinFramework::AnyMemberPlugin;
    use StarcoinFramework::InstallPluginProposalPlugin;

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

        DAOSpace::install_plugin_with_root_cap<X, InstallPluginProposalPlugin>(&dao_root_cap, InstallPluginProposalPlugin::required_caps());
        DAOSpace::install_plugin_with_root_cap<X, AnyMemberPlugin>(&dao_root_cap, AnyMemberPlugin::required_caps());

        DAOSpace::install_plugin_with_root_cap<X, XPlugin>(&dao_root_cap, required_caps());

        DAOSpace::burn_root_cap(dao_root_cap);

    }

    struct XPlugin has store, drop{}

    public fun initialize_x_plugin(sender: &signer) {
        DAOPluginMarketplace::register_plugin<XPlugin>(
            sender,
            b"0x1::XPlugin",
            b"The X plugin.",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();

        let witness = XPlugin{};
        DAOPluginMarketplace::publish_plugin_version<XPlugin>(
            sender,
            &witness,
            b"v0.1.0", 
            *&implement_extpoints,
            *&depend_extpoints,
            b"inner-plugin://x-plugin",
        );
    }

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::install_plugin_cap_type());
        Vector::push_back(&mut caps, DAOSpace::member_cap_type());
        Vector::push_back(&mut caps, DAOSpace::withdraw_token_cap_type());
        Vector::push_back(&mut caps, DAOSpace::grant_cap_type());
        caps
    }

    public fun create_grant(sender:&signer, total:u128, start_time:u64,period:u64){
        let witness = XPlugin{};
        let grant_cap = DAOSpace::acquire_grant_cap<X, XPlugin>(&witness);
        DAOSpace::grant_offer<X,XPlugin,STC::STC>(&grant_cap, Signer::address_of(sender), total, start_time, period);
        DAOSpace::grant_accept_offer<X, XPlugin, STC::STC>(sender)
    }

    public fun grant_revoke(grantee:address){
        let witness = XPlugin{};
        let grant_cap = DAOSpace::acquire_grant_cap<X, XPlugin>(&witness);
        DAOSpace::grant_revoke<X,XPlugin,STC::STC>(&grant_cap, grantee);
    }
}

//# block --author 0x1 --timestamp 86400000

//# run --signers creator
script{
    use creator::DAOHelper;

    fun main(sender: signer){
        DAOHelper::initialize_x_plugin(&sender);

        // time unit is millsecond
        DAOHelper::create_dao(sender, 10000, 3600000, 2, 10000, 10);
    }
}
// check: EXECUTED

//# run --signers alice
script{
    use creator::DAOHelper::{Self, X, XPlugin};
    use StarcoinFramework::DAOSpace::{query_grant, query_grant_withdrawable_amount};
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::STC;

    //alice create grant to alice
    fun create_grant(sender: signer){
        DAOHelper::create_grant(&sender, 1000000000u128, 86400u64, 3600u64);
        let grant_info = query_grant<X, XPlugin, STC::STC>(@alice);    
        assert!(DAOSpace::query_grant_info_total(&grant_info) == 1000000000,1001);
        assert!(DAOSpace::query_grant_info_withdraw(&grant_info)== 0,1002);
        assert!(DAOSpace::query_grant_info_start_time(&grant_info) == 86400,1003);
        assert!(DAOSpace::query_grant_info_period(&grant_info) == 3600,1004);
        
        assert!(query_grant_withdrawable_amount<X, XPlugin, STC::STC>(@alice) == 0,1005);
    }
}
// check: EXECUTED

//# run --signers bob
script{
    use creator::DAOHelper::{Self, X, XPlugin};
    use StarcoinFramework::DAOSpace::{Self,query_grant, query_grant_withdrawable_amount, grant_withdraw};
    use StarcoinFramework::STC;
    use StarcoinFramework::Account;

    //bob create grant to bob
    fun create_grant(sender: signer){
        DAOHelper::create_grant(&sender, 1000000000u128, 86400u64, 0u64);
        let grant_info = query_grant<X, XPlugin, STC::STC>(@bob);    
        assert!(DAOSpace::query_grant_info_total(&grant_info) == 1000000000,1005);
        assert!(DAOSpace::query_grant_info_withdraw(&grant_info)== 0,1006);
        assert!(DAOSpace::query_grant_info_start_time(&grant_info) == 86400,1007);
        assert!(DAOSpace::query_grant_info_period(&grant_info) == 0,1008);

        assert!(query_grant_withdrawable_amount<X, XPlugin, STC::STC>(@bob) == 1000000000,1009);

        grant_withdraw<X, XPlugin, STC::STC>(&sender, 500000000u128);
        assert!(Account::balance<STC::STC>(@bob) == 10000000000 + 500000000, 1010);

        let grant_info = query_grant<X, XPlugin, STC::STC>(@bob);    
        assert!(DAOSpace::query_grant_info_total(&grant_info) == 1000000000,1011);
        assert!(DAOSpace::query_grant_info_withdraw(&grant_info)== 500000000,1012);
        assert!(DAOSpace::query_grant_info_start_time(&grant_info) == 86400,1013);
        assert!(DAOSpace::query_grant_info_period(&grant_info) == 0,1014);
        assert!(query_grant_withdrawable_amount<X, XPlugin, STC::STC>(@bob) == 0,1015);

        DAOHelper::grant_revoke(@bob);
        assert!(DAOSpace::is_exist_grant<X, XPlugin, STC::STC>(@bob) == false, 1016);
    }
}
// check: EXECUTED

//# block --author 0x1 --timestamp 86401000

//# run --signers alice
script{
    use creator::DAOHelper::{X, XPlugin};
    use StarcoinFramework::DAOSpace::{Self, query_grant_withdrawable_amount};
    use StarcoinFramework::STC;

    //alice withdraw more grant 
    fun withdraw_grant(sender: signer){
        assert!(query_grant_withdrawable_amount<X, XPlugin, STC::STC>(@alice) == 277777, 1001);
        DAOSpace::grant_withdraw<X, XPlugin, STC::STC>(&sender, 377777u128);
    }
}
// check: MoveAbort 77319

//# run --signers alice
script{
    use creator::DAOHelper::{X, XPlugin};
    use StarcoinFramework::DAOSpace::{Self, query_grant, query_grant_withdrawable_amount};
    use StarcoinFramework::STC;
    use StarcoinFramework::Account;

    //alice withdraw grant 
    fun withdraw_grant(sender: signer){
        assert!(query_grant_withdrawable_amount<X, XPlugin, STC::STC>(@alice) == 277777, 1001);
        let old_balance = Account::balance<STC::STC>(@alice);
        DAOSpace::grant_withdraw<X, XPlugin, STC::STC>(&sender, 277777u128);
        assert!(Account::balance<STC::STC>(@alice) == old_balance + 277777, 1002);
        let grant_info = query_grant<X, XPlugin, STC::STC>(@alice);    
        assert!(DAOSpace::query_grant_info_total(&grant_info) == 1000000000,1003);
        assert!(DAOSpace::query_grant_info_withdraw(&grant_info)== 277777,1004);
        assert!(DAOSpace::query_grant_info_start_time(&grant_info) == 86400,1005);
        assert!(DAOSpace::query_grant_info_period(&grant_info) == 3600,1006);
    }
}
// check: EXECUTED

//# block --author 0x1 --timestamp 90000000

//# run --signers alice
script{
    use creator::DAOHelper::{X, XPlugin};
    use StarcoinFramework::DAOSpace::{Self, query_grant, query_grant_withdrawable_amount};
    use StarcoinFramework::STC;
    use StarcoinFramework::Account;

    //alice withdraw grant 
    fun withdraw_grant(sender: signer){
        assert!(query_grant_withdrawable_amount<X, XPlugin, STC::STC>(@alice) == 1000000000 - 277777, 1001);
        let old_balance = Account::balance<STC::STC>(@alice);
        DAOSpace::grant_withdraw<X, XPlugin, STC::STC>(&sender, 1000000000 - 277777);
        assert!(Account::balance<STC::STC>(@alice) == old_balance + 1000000000 - 277777, 1002);
        let grant_info = query_grant<X, XPlugin, STC::STC>(@alice);    
        assert!(DAOSpace::query_grant_info_total(&grant_info) == 1000000000,1003);
        assert!(DAOSpace::query_grant_info_withdraw(&grant_info)== 1000000000,1004);
        assert!(DAOSpace::query_grant_info_start_time(&grant_info) == 86400,1005);
        assert!(DAOSpace::query_grant_info_period(&grant_info) == 3600,1006);
    }
}
// check: EXECUTED

//# run --signers cindy
script{
    use creator::DAOHelper::{Self, X, XPlugin};
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::STC;

    //alice create grant to cindy
    fun create_grant(sender: signer){
        DAOHelper::create_grant(&sender, 1000000000u128, 90000u64, 3600u64);
        assert!(DAOSpace::is_exist_grant<X, XPlugin, STC::STC>(@cindy) == true, 1001);
        DAOSpace::refund_grant<X, XPlugin, STC::STC>(&sender);
        assert!(DAOSpace::is_exist_grant<X, XPlugin, STC::STC>(@cindy) == false, 1002);
    }
}
// check: EXECUTED