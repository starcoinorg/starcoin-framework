//TODO find more good name
module StarcoinFramework::AnyMemberPlugin{
    use StarcoinFramework::GenesisSignerCapability;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Errors;
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Option;
    use StarcoinFramework::InstallPluginProposalPlugin;
    use StarcoinFramework::IdentifierNFT;
    
    const ERR_ALREADY_INITIALIZED: u64 = 100;

    struct AnyMemberPlugin has key, store, drop{}

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(DAOSpace::member_cap_type());  
        caps 
    }

    public fun initialize() {
        assert!(!exists<AnyMemberPlugin>(CoreAddresses::GENESIS_ADDRESS()), Errors::already_published(ERR_ALREADY_INITIALIZED));
        let signer = GenesisSignerCapability::get_genesis_signer();
        
        DAOPluginMarketplace::register_plugin<AnyMemberPlugin>(
            &signer,
            b"0x1::AnyMemberPlugin",
            b"The member plugin that allow all member to do join.",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();

        DAOPluginMarketplace::publish_plugin_version<AnyMemberPlugin>(
            &signer, 
            b"v0.1.0", 
            *&implement_extpoints,
            *&depend_extpoints,
            b"inner-plugin://any-member-plugin",
        );
    }

    //TODO how to unify arguments.
    public (script) fun join<DAOT: store>(sender: signer, image_data:vector<u8>, image_url:vector<u8>){
        let witness = AnyMemberPlugin{};
        let member_cap = DAOSpace::acquire_member_cap<DAOT, AnyMemberPlugin>(&witness);
        IdentifierNFT::accept<DAOSpace::DAOMember<DAOT>,DAOSpace::DAOMemberBody<DAOT>>(&sender);
        DAOSpace::join_member(&member_cap, Signer::address_of(&sender), Option::some(image_data), Option::some(image_url), 1);
    }

    public (script) fun install_plugin_proposal<DAOT:store>(sender:signer, plugin_version: u64, description: vector<u8>, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, AnyMemberPlugin>(&sender, plugin_version, required_caps(), description, action_delay);
    } 
}