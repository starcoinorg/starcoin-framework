//TODO find more good name
module StarcoinFramework::AnyMemberPlugin{
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Option;
    use StarcoinFramework::InstallPluginProposalPlugin;

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

    public fun join<DAOT: store>(sender: &signer, image_data:vector<u8>, image_url:vector<u8>){
        let witness = AnyMemberPlugin{};
        let sender_addr = Signer::address_of(sender);
        if (DAOSpace::is_member<DAOT>(sender_addr) ) {
            return
        };
        let member_cap = DAOSpace::acquire_member_cap<DAOT, AnyMemberPlugin>(&witness);
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
         
        DAOSpace::issue_member_offer<DAOT, AnyMemberPlugin>(&member_cap, sender_addr,  op_image_data, op_image_url, 1);
        DAOSpace::accept_member_offer<DAOT>(sender);
    }

    public (script) fun join_entry<DAOT: store>(sender: signer, image_data:vector<u8>, image_url:vector<u8>){
        join<DAOT>(&sender, image_data, image_url);
    }

    public fun install_plugin_proposal<DAOT:store>(sender:&signer, title:vector<u8>, introduction:vector<u8>, extend: vector<u8>, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, AnyMemberPlugin>(sender, required_caps(), title, introduction, extend, action_delay);
    }

    public (script) fun install_plugin_proposal_entry<DAOT:store>(sender:signer, title:vector<u8>, introduction:vector<u8>, extend: vector<u8>, action_delay:u64){
        install_plugin_proposal<DAOT>(&sender, title, introduction, extend, action_delay);
    }

}