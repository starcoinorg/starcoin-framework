//TODO find more good name
module StarcoinFramework::AnyMemberPlugin{
    use StarcoinFramework::DAOPluginMarketplace;
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

    public fun initialize(sender: &signer) {
        DAOPluginMarketplace::register_plugin<AnyMemberPlugin>(
            sender,
            b"0x1::AnyMemberPlugin",
            b"The member plugin that allow all member to do join.",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();

        let witness = AnyMemberPlugin{};
        DAOPluginMarketplace::publish_plugin_version<AnyMemberPlugin>(
            sender,
            &witness,
            b"v0.1.0", 
            *&implement_extpoints,
            *&depend_extpoints,
            b"inner-plugin://any-member-plugin",
        );
    }

    //TODO how to unify arguments.
    public fun join<DAOT: store>(sender: &signer, image_data:vector<u8>, image_url:vector<u8>){
        let witness = AnyMemberPlugin{};
        let member_cap = DAOSpace::acquire_member_cap<DAOT, AnyMemberPlugin>(&witness);
        IdentifierNFT::accept<DAOSpace::DAOMember<DAOT>,DAOSpace::DAOMemberBody<DAOT>>(sender);
        DAOSpace::join_member(&member_cap, Signer::address_of(sender), Option::some(image_data), Option::some(image_url), 1);
    }

    public (script) fun join_entry<DAOT: store>(sender: signer, image_data:vector<u8>, image_url:vector<u8>){
        join<DAOT>(&sender, image_data, image_url);
    }

    public fun install_plugin_proposal<DAOT:store>(sender:&signer, description: vector<u8>, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, AnyMemberPlugin>(sender, required_caps(), description, action_delay);
    }

    public (script) fun install_plugin_proposal_entry<DAOT:store>(sender:signer, description: vector<u8>, action_delay:u64){
        install_plugin_proposal<DAOT>(&sender, description, action_delay);
    }

}