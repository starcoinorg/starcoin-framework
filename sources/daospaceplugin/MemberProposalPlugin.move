//TODO find more good name
module StarcoinFramework::MemberProposalPlugin{
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::InstallPluginProposalPlugin;

    struct MemberProposalPlugin has drop{}

    struct MemberJoinAction has store {
        member: address,
        init_sbt: u128,
    }

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(DAOSpace::member_cap_type());   
        Vector::push_back(&mut caps, DAOSpace::proposal_cap_type());    
        caps 
    }

    //TODO how to unify arguments.
    public (script) fun create_proposal<DaoT: store>(sender: signer, member: address, init_sbt: u128, action_delay: u64){
        let witness = MemberProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DaoT, MemberProposalPlugin>(&witness);
        let action = MemberJoinAction{
            member,
            init_sbt,
        };
        DAOSpace::create_proposal(&cap, &sender, action, action_delay);
    }

    public (script) fun execute_proposal<DaoT: store>(sender: signer, proposal_id: u64){
        let witness = MemberProposalPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DaoT, MemberProposalPlugin>(&witness);
        let MemberJoinAction{member, init_sbt} = DAOSpace::execute_proposal<DaoT, MemberProposalPlugin, MemberJoinAction>(&proposal_cap, &sender, proposal_id);
        let member_cap = DAOSpace::acquire_member_cap<DaoT, MemberProposalPlugin>(&witness);
        DAOSpace::join_member(&member_cap, member, init_sbt);
    }

    public (script) fun install_plugin_proposal<DaoT:store>(sender:signer, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DaoT, MemberJoinAction>(&sender, required_caps(), action_delay);
    } 
}