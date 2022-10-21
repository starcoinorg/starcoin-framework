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

    public fun initialize(_sender: &signer) {
        let witness = AnyMemberPlugin{};

        DAOPluginMarketplace::register_plugin<AnyMemberPlugin>(
            &witness,
            b"0x1::AnyMemberPlugin",
            b"The member plugin that allow all member to do join.",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();

        DAOPluginMarketplace::publish_plugin_version<AnyMemberPlugin>(
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
        let op_image_data = if(Vector::is_empty(&image_data)){
            Option::none<vector<u8>>()
        }else{
            Option::some(image_data)
        };
        let op_image_url = if(Vector::is_empty(&image_url)){
            Option::none<vector<u8>>()
        }else{
            Option::some(image_url)
        };
        DAOSpace::join_member_with_member_cap(&member_cap, Signer::address_of(sender), op_image_data, op_image_url, 1);
    }

    public (script) fun join_entry<DAOT: store>(sender: signer, image_data:vector<u8>, image_url:vector<u8>){
        join<DAOT>(&sender, image_data, image_url);
    }

    public fun install_plugin_proposal<DAOT:store>(sender:&signer, title:vector<u8>, introduction:vector<u8>, description: vector<u8>, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, AnyMemberPlugin>(sender, required_caps(), title, introduction, description, action_delay);
    }

    public (script) fun install_plugin_proposal_entry<DAOT:store>(sender:signer, title:vector<u8>, introduction:vector<u8>, description: vector<u8>, action_delay:u64){
        install_plugin_proposal<DAOT>(&sender, title, introduction, description, action_delay);
    }

}