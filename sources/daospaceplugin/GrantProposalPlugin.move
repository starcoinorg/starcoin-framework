//TODO find more good name
module StarcoinFramework::GrantProposalPlugin{
    use StarcoinFramework::Errors;
    use StarcoinFramework::Option;
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Signer;
    use StarcoinFramework::Vector;
    use StarcoinFramework::InstallPluginProposalPlugin;

    struct GrantProposalPlugin has store, drop{}

    struct GrantCreateAction<phantom TokenT:store> has store, drop {
        grantee: address,
        total: u128,
        start_time:u64,
        period:u64
    }

    struct GrantConfigAction<phantom TokenT:store> has store, drop {
        old_grantee: address,
        new_grantee:address,
        total: u128,
        start_time:u64,
        period:u64
    }

    struct GrantRevokeAction<phantom TokenT:store> has store, drop {
        grantee:address
    }

    public fun initialize(_sender: &signer) {
        let witness = GrantProposalPlugin{};

        DAOPluginMarketplace::register_plugin<GrantProposalPlugin>(
            &witness,
            b"0x1::GrantProposalPlugin",
            b"The plugin for grant proposal",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();
        
        DAOPluginMarketplace::publish_plugin_version<GrantProposalPlugin>(
            &witness,
            b"v0.1.0", 
            *&implement_extpoints,
            *&depend_extpoints,
            b"inner-plugin://grant-proposal-plugin",
        );
    }

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::grant_cap_type());
        caps 
    }

    const ERR_GRANTTREASURY_WITHDRAW_NOT_GRANTEE :u64 = 101;
    const ERR_GRANTTREASURY_WITHDRAW_TOO_MORE :u64 = 102;
    const ERR_SENDER_NOT_SAME :u64 = 103;

    public fun create_grant_proposal<DAOT: store, TokenT:store>(sender: &signer, title:vector<u8>, introduction:vector<u8>, extend: vector<u8>,grantee: address, total: u128, start_time:u64, period: u64, action_delay:u64){
        let witness = GrantProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, GrantProposalPlugin>(&witness);
        let action = GrantCreateAction<TokenT>{
            grantee:grantee,
            total:total,
            start_time:start_time,
            period:period
        };
        DAOSpace::create_proposal(&cap, sender, action, title, introduction, extend, action_delay, Option::none<u8>());
    }

    public (script) fun create_grant_proposal_entry<DAOT: store, TokenT:store>(sender: signer, title:vector<u8>, introduction:vector<u8>, extend: vector<u8>,grantee: address, total: u128, start_time:u64, period: u64, action_delay:u64){
        create_grant_proposal<DAOT, TokenT>(&sender, title, introduction, extend, grantee, total, start_time, period, action_delay);
    }

    public fun execute_grant_proposal<DAOT: store, TokenT:store>(sender: &signer, proposal_id: u64){
        let witness = GrantProposalPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, GrantProposalPlugin>(&witness);
        let GrantCreateAction{grantee, total, start_time, period} = DAOSpace::execute_proposal<DAOT, GrantProposalPlugin, GrantCreateAction<TokenT>>(&proposal_cap, sender, proposal_id);
        assert!(grantee == Signer::address_of(sender),Errors::not_published(ERR_SENDER_NOT_SAME));
        let grant_cap = DAOSpace::acquire_grant_cap<DAOT, GrantProposalPlugin>(&witness);
        DAOSpace::grant_offer<DAOT, GrantProposalPlugin, TokenT>(&grant_cap, Signer::address_of(sender), total, start_time, period);
    }

    public (script) fun execute_grant_proposal_entry<DAOT: store, TokenT:store>(sender: signer, proposal_id: u64){
        execute_grant_proposal<DAOT, TokenT>(&sender, proposal_id);
    }

    public fun create_grant_revoke_proposal<DAOT: store, TokenT:store>(sender: &signer, title:vector<u8>, introduction:vector<u8>, extend: vector<u8>, grantee:address, action_delay:u64){
        let witness = GrantProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, GrantProposalPlugin>(&witness);
        let action = GrantRevokeAction<TokenT>{ grantee };
        DAOSpace::create_proposal(&cap, sender, action, title, introduction, extend, action_delay, Option::none<u8>());
    }

    public (script) fun create_grant_revoke_proposal_entry<DAOT: store, TokenT:store>(sender: signer, title:vector<u8>, introduction:vector<u8>, extend: vector<u8>, grantee:address, action_delay:u64){
        create_grant_revoke_proposal<DAOT, TokenT>(&sender, title, introduction, extend, grantee, action_delay);
    }

    public fun execute_grant_revoke_proposal<DAOT: store, TokenT:store>(sender: &signer, proposal_id: u64){
        let witness = GrantProposalPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, GrantProposalPlugin>(&witness);
        let GrantRevokeAction{ grantee } = DAOSpace::execute_proposal<DAOT, GrantProposalPlugin, GrantRevokeAction<TokenT>>(&proposal_cap, sender, proposal_id);
        let grant_cap = DAOSpace::acquire_grant_cap<DAOT, GrantProposalPlugin>(&witness);
        DAOSpace::grant_revoke<DAOT, GrantProposalPlugin, TokenT>(&grant_cap , grantee);
    }

    public (script) fun execute_grant_revoke_proposal_entry<DAOT: store, TokenT:store>(sender: signer, proposal_id: u64){
        execute_grant_revoke_proposal<DAOT, TokenT>(&sender, proposal_id);
    }

    public fun install_plugin_proposal<DAOT:store>(sender: &signer, title:vector<u8>, introduction:vector<u8>, extend: vector<u8>, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, GrantProposalPlugin>(sender, required_caps(), title, introduction, extend, action_delay);
    }

    public (script) fun install_plugin_proposal_entry<DAOT: store>(sender:signer, title:vector<u8>, introduction:vector<u8>, extend: vector<u8>, action_delay:u64){
        install_plugin_proposal<DAOT>(&sender, title, introduction, extend, action_delay);
    }

}