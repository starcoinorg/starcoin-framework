//TODO find more good name
module StarcoinFramework::GrantProposalPlugin{
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Vector;
    use StarcoinFramework::InstallPluginProposalPlugin;

    struct GrantProposalPlugin has store, drop{}

    struct GrantCreateAction<phantom TokenT:store> has store {
        grantee: address,
        total: u128,
        start_time:u64,
        period:u64
    }

    struct GrantConfigAction<phantom TokenT:store> has store {
        old_grantee: address,
        new_grantee:address,
        total: u128,
        start_time:u64,
        period:u64
    }

    struct GrantRevokeAction<phantom TokenT:store> has store {
        grantee:address
    }

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::grant_cap_type());
        caps 
    }

    const ERR_GRANTTREASURY_WITHDRAW_NOT_GRANTEE :u64 = 101;
    const ERR_GRANTTREASURY_WITHDRAW_TOO_MORE :u64 = 102;
    const ERR_SENDER_NOT_SAME :u64 = 103;

    public (script) fun create_grant_proposal<DAOT: store, TokenT:store>(sender: signer, description: vector<u8>,grantee: address, total: u128, start_time:u64, period: u64, action_delay:u64){
        let witness = GrantProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, GrantProposalPlugin>(&witness);
        let action = GrantCreateAction<TokenT>{
            grantee:grantee,
            total:total,
            start_time:start_time,
            period:period
        };
        DAOSpace::create_proposal(&cap, &sender, action, description, action_delay);
    }

    public (script) fun execute_grant_proposal<DAOT: store, TokenT:store>(sender: signer, proposal_id: u64){
        let witness = GrantProposalPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, GrantProposalPlugin>(&witness);
        let GrantCreateAction{grantee, total, start_time, period} = DAOSpace::execute_proposal<DAOT, GrantProposalPlugin, GrantCreateAction<TokenT>>(&proposal_cap, &sender, proposal_id);
        assert!(grantee == Signer::address_of(&sender),Errors::not_published(ERR_SENDER_NOT_SAME));
        let grant_cap = DAOSpace::acquire_grant_cap<DAOT, GrantProposalPlugin>(&witness);
        DAOSpace::create_grant<DAOT, GrantProposalPlugin, TokenT>(&grant_cap, &sender, total, start_time, period);
    }

    public (script) fun create_grant_revoke_proposal<DAOT: store, TokenT:store>(sender: signer, description: vector<u8>, grantee:address, action_delay:u64){
        let witness = GrantProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, GrantProposalPlugin>(&witness);
        let action = GrantRevokeAction<TokenT>{ grantee };
        DAOSpace::create_proposal(&cap, &sender, action, description, action_delay);
    }

    public (script) fun execute_grant_revoke_proposal<DAOT: store, TokenT:store>(sender: signer, proposal_id: u64){
        let witness = GrantProposalPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, GrantProposalPlugin>(&witness);
        let GrantRevokeAction{ grantee } = DAOSpace::execute_proposal<DAOT, GrantProposalPlugin, GrantRevokeAction<TokenT>>(&proposal_cap, &sender, proposal_id);
        let grant_cap = DAOSpace::acquire_grant_cap<DAOT, GrantProposalPlugin>(&witness);
        DAOSpace::grant_revoke<DAOT, GrantProposalPlugin, TokenT>(&grant_cap , grantee);
    }

    public (script) fun create_grant_config_proposal<DAOT: store, TokenT:store>(sender: signer, description: vector<u8>, old_grantee: address, new_grantee: address, total: u128, period: u64,start_time:u64, action_delay:u64){
        let witness = GrantProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, GrantProposalPlugin>(&witness);
        let action = GrantConfigAction<TokenT>{
            old_grantee: old_grantee,
            new_grantee: new_grantee,
            total:total,
            start_time:start_time,
            period:period
        };
        DAOSpace::create_proposal(&cap, &sender, action, description,action_delay);
    }

    public (script) fun execute_grant_config_proposal<DAOT: store, TokenT:store>(sender: signer, proposal_id: u64){
        let witness = GrantProposalPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, GrantProposalPlugin>(&witness);
        let GrantConfigAction{
            old_grantee: old_grantee,
            new_grantee: new_grantee,
            total:total,
            start_time:start_time,
            period:period
        } = DAOSpace::execute_proposal<DAOT, GrantProposalPlugin, GrantConfigAction<TokenT>>(&proposal_cap, &sender, proposal_id);
        assert!(new_grantee == Signer::address_of(&sender),Errors::not_published(ERR_SENDER_NOT_SAME));
        let grant_cap = DAOSpace::acquire_grant_cap<DAOT, GrantProposalPlugin>(&witness);
        DAOSpace::grant_config<DAOT, GrantProposalPlugin, TokenT>(&grant_cap , old_grantee , &sender, total, start_time, period);
    }

    public (script) fun install_plugin_proposal<DAOT:store>(sender:signer, description: vector<u8>, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, GrantProposalPlugin>(&sender, required_caps(), description, action_delay);
    } 
}