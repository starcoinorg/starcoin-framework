//TODO find more good name
module StarcoinFramework::AnyMemberPlugin{
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;
    use StarcoinFramework::InstallPluginProposalPlugin;
    use StarcoinFramework::IdentifierNFT;

    struct AnyMemberPlugin has drop{}

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(DAOSpace::member_cap_type());  
        caps 
    }

    //TODO how to unify arguments.
    public (script) fun join<DAOT: store>(sender: signer){
        let witness = AnyMemberPlugin{};
        let member_cap = DAOSpace::acquire_member_cap<DAOT, AnyMemberPlugin>(&witness);
        IdentifierNFT::accept<DAOSpace::DAOMember<DAOT>,DAOSpace::DAOMemberBody<DAOT>>(&sender);
        DAOSpace::join_member(&member_cap, Signer::address_of(&sender), 1);
    }

    public (script) fun install_plugin_proposal<DAOT:store>(sender:signer, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, AnyMemberPlugin>(&sender, required_caps(), action_delay);
    } 
}