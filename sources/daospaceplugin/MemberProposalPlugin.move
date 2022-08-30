//TODO find more good name
module StarcoinFramework::MemberProposalPlugin{
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::Option;
    use StarcoinFramework::InstallPluginProposalPlugin;

    struct MemberProposalPlugin has store, drop{}

    struct MemberJoinAction has store {
        member: address,
        init_sbt: u128,
        image_url: vector<u8> ,
        image_data: vector<u8>
    }

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(DAOSpace::member_cap_type());   
        Vector::push_back(&mut caps, DAOSpace::proposal_cap_type());    
        caps 
    }

    //TODO how to unify arguments.
    public (script) fun create_proposal<DAOT: store>(sender: signer, description: vector<u8>, member: address, image_data:vector<u8>, image_url:vector<u8>, init_sbt: u128, action_delay: u64){
        let witness = MemberProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, MemberProposalPlugin>(&witness);
        let action = MemberJoinAction{
            member,
            init_sbt,
            image_data,
            image_url
        };
        DAOSpace::create_proposal(&cap, &sender, action, description, action_delay);
    }

    public (script) fun execute_proposal<DAOT: store>(sender: signer, proposal_id: u64){
        let witness = MemberProposalPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, MemberProposalPlugin>(&witness);
        let MemberJoinAction{member, init_sbt, image_data, image_url} = DAOSpace::execute_proposal<DAOT, MemberProposalPlugin, MemberJoinAction>(&proposal_cap, &sender, proposal_id);
        let member_cap = DAOSpace::acquire_member_cap<DAOT, MemberProposalPlugin>(&witness);
        DAOSpace::join_member(&member_cap, member, Option::some(image_data), Option::some(image_url) , init_sbt);
    }

    public (script) fun install_plugin_proposal<DAOT:store>(sender:signer, description: vector<u8>,action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, MemberJoinAction>(&sender, required_caps(), description, action_delay);
    } 
}