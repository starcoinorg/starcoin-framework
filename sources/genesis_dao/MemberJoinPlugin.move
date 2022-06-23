//TODO find more good name
module StarcoinFramework::MemberJoinPlugin{
    use StarcoinFramework::GenesisDao;

    struct MemberJoinPlugin has drop{}

    struct MemberJoinAction has store {
        member: address,
        init_sbt: u128,
    }

    //TODO how to unify arguments.
    public fun create_proposal<DaoT: store>(sender: &signer, member: address, init_sbt: u128, action_delay: u64){
        let witness = MemberJoinPlugin{};
        let cap = GenesisDao::acquire_proposal_cap<DaoT, MemberJoinPlugin>(&witness);
        let action = MemberJoinAction{
            member,
            init_sbt,
        };
        GenesisDao::create_proposal(&cap, sender, action, action_delay);
    }

    public fun execute_proposal<DaoT: store>(sender: &signer, proposal_id: u64){
        let witness = MemberJoinPlugin{};
        let proposal_cap = GenesisDao::acquire_proposal_cap<DaoT, MemberJoinPlugin>(&witness);
        let MemberJoinAction{member, init_sbt} = GenesisDao::execute_proposal<DaoT, MemberJoinPlugin, MemberJoinAction>(&proposal_cap, sender, proposal_id);
        let member_cap = GenesisDao::acquire_member_cap<DaoT, MemberJoinPlugin>(&witness);
        GenesisDao::join_member(&member_cap, member, init_sbt);
    }
}