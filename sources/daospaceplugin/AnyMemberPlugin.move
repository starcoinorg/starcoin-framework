//TODO find more good name
module StarcoinFramework::AnyMemberPlugin{
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Option;
    use StarcoinFramework::InstallPluginProposalPlugin;
    use StarcoinFramework::IdentifierNFT;

    struct AnyMemberPlugin has store, drop{}

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(DAOSpace::member_cap_type());  
        caps 
    }

    //TODO how to unify arguments.
    public (script) fun join<DAOT: store>(sender: signer, image_data:vector<u8>, image_url:vector<u8>){
        let witness = AnyMemberPlugin{};
        let member_cap = DAOSpace::acquire_member_cap<DAOT, AnyMemberPlugin>(&witness);
        IdentifierNFT::accept<DAOSpace::DAOMember<DAOT>,DAOSpace::DAOMemberBody<DAOT>>(&sender);
        DAOSpace::join_member(&member_cap, Signer::address_of(&sender), Option::some(image_data), Option::some(image_url), 1);
    }

    public (script) fun install_plugin_proposal<DAOT:store>(sender:signer, description: vector<u8>, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, AnyMemberPlugin>(&sender, required_caps(), description, action_delay);
    } 
}