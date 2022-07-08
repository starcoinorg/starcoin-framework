//TODO find more good name
module StarcoinFramework::GrantProposalPlugin{
    use StarcoinFramework::GenesisDao::{Self};
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;

    struct GrantProposalPlugin<phantom Grant> has drop{}

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


    const ERR_GRANTTREASURY_WITHDRAW_NOT_GRANTEE :u64 = 101;
    const ERR_GRANTTREASURY_WITHDRAW_TOO_MORE :u64 = 102;
    const ERR_SENDER_NOT_SAME :u64 = 103;

    public fun create_grant_proposal<DaoT: store, Grant, TokenT:store>(sender: &signer, grantee: address, total: u128, start_time:u64, period: u64, action_delay:u64){
        let witness = GrantProposalPlugin{};
        let cap = GenesisDao::acquire_proposal_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let action = GrantCreateAction<TokenT>{
            grantee:grantee,
            total:total,
            start_time:start_time,
            period:period
        };
        GenesisDao::create_proposal(&cap, sender, action, action_delay);
    }

    public fun execute_grant_proposal<DaoT: store, Grant, TokenT:store>(sender: &signer, proposal_id: u64){
        let witness = GrantProposalPlugin{};
        let proposal_cap = GenesisDao::acquire_proposal_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let GrantCreateAction{grantee, total, start_time, period} = GenesisDao::execute_proposal<DaoT, GrantProposalPlugin<Grant>, GrantCreateAction<TokenT>>(&proposal_cap, sender, proposal_id);
        assert!(grantee == Signer::address_of(sender),Errors::not_published(ERR_SENDER_NOT_SAME));
        let grant_cap = GenesisDao::acquire_grant_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        GenesisDao::create_grant<DaoT, GrantProposalPlugin<Grant>, TokenT>(&grant_cap, sender, total, start_time, period);
    }

    public fun create_grant_revoke_proposal<DaoT: store, Grant, TokenT:store>(sender: &signer, grantee:address, action_delay:u64){
        let witness = GrantProposalPlugin{};
        let cap = GenesisDao::acquire_proposal_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let action = GrantRevokeAction<TokenT>{ grantee };
        GenesisDao::create_proposal(&cap, sender, action, action_delay);
    }

    public fun execute_grant_revoke_proposal<DaoT: store, Grant, TokenT:store>(sender: &signer, proposal_id: u64){
        let witness = GrantProposalPlugin{};
        let proposal_cap = GenesisDao::acquire_proposal_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let GrantRevokeAction{ grantee } = GenesisDao::execute_proposal<DaoT, GrantProposalPlugin<Grant>, GrantRevokeAction<TokenT>>(&proposal_cap, sender, proposal_id);
        let grant_cap = GenesisDao::acquire_grant_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        GenesisDao::grant_revoke<DaoT, GrantProposalPlugin<Grant>, TokenT>(&grant_cap , grantee);
    }

    public fun create_grant_config_proposal<DaoT: store, Grant, TokenT:store>(sender: &signer, old_grantee: address, new_grantee: address, total: u128, period: u64,start_time:u64, action_delay:u64){
        let witness = GrantProposalPlugin{};
        let cap = GenesisDao::acquire_proposal_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let action = GrantConfigAction<TokenT>{
            old_grantee: old_grantee,
            new_grantee: new_grantee,
            total:total,
            start_time:start_time,
            period:period
        };
        GenesisDao::create_proposal(&cap, sender, action, action_delay);
    }

    public fun execute_grant_config_proposal<DaoT: store, Grant, TokenT:store>(sender: &signer, proposal_id: u64){
        let witness = GrantProposalPlugin{};
        let proposal_cap = GenesisDao::acquire_proposal_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let GrantConfigAction{
            old_grantee: old_grantee,
            new_grantee: new_grantee,
            total:total,
            start_time:start_time,
            period:period
        } = GenesisDao::execute_proposal<DaoT, GrantProposalPlugin<Grant>, GrantConfigAction<TokenT>>(&proposal_cap, sender, proposal_id);
        assert!(new_grantee == Signer::address_of(sender),Errors::not_published(ERR_SENDER_NOT_SAME));
        let grant_cap = GenesisDao::acquire_grant_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        GenesisDao::grant_config<DaoT, GrantProposalPlugin<Grant>, TokenT>(&grant_cap , old_grantee , sender, total, start_time, period);
    }
}