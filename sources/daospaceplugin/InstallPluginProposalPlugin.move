//TODO find more good name
module StarcoinFramework::InstallPluginProposalPlugin{
    use StarcoinFramework::GenesisSignerCapability;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Option;
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;

    const ERR_ALREADY_INITIALIZED: u64 = 100;

    struct InstallPluginProposalPlugin has key, store, drop{}

    struct InstallPluginAction<phantom ToInstallPluginT> has store {
        plugin_version: u64,
        required_caps: vector<CapType>,
    }

    public fun initialize() {
        assert!(!exists<InstallPluginProposalPlugin>(CoreAddresses::GENESIS_ADDRESS()), Errors::already_published(ERR_ALREADY_INITIALIZED));
        let signer = GenesisSignerCapability::get_genesis_signer();
        
        DAOPluginMarketplace::register_plugin<InstallPluginProposalPlugin>(
            &signer,
            b"0x1::InstallPluginProposalPlugin",
            b"The plugin for install plugin proposal",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();

        DAOPluginMarketplace::publish_plugin_version<InstallPluginProposalPlugin>(
            &signer, 
            b"v0.1.0", 
            *&implement_extpoints,
            *&depend_extpoints,
            b"inner-plugin://install-plugin-proposal-plugin",
        );
    }

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());   
        Vector::push_back(&mut caps, DAOSpace::install_plugin_cap_type());    
        caps
    }

    //TODO how to unify arguments.
    public fun create_proposal<DAOT: store, ToInstallPluginT: store>(sender: &signer, plugin_version: u64, required_caps: vector<CapType>, description: vector<u8>, action_delay: u64){
        let witness = InstallPluginProposalPlugin{};

        let cap = DAOSpace::acquire_proposal_cap<DAOT, InstallPluginProposalPlugin>(&witness);
        let action = InstallPluginAction<ToInstallPluginT>{
            plugin_version: plugin_version,
            required_caps,
        };

        DAOSpace::create_proposal(&cap, sender, action, description, action_delay);
    }

    public (script) fun execute_proposal<DAOT: store, ToInstallPluginT: store>(sender: signer, proposal_id: u64){
        let witness = InstallPluginProposalPlugin{};

        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, InstallPluginProposalPlugin>(&witness);
        let InstallPluginAction{plugin_version, required_caps} = DAOSpace::execute_proposal<DAOT, InstallPluginProposalPlugin, InstallPluginAction<ToInstallPluginT>>(&proposal_cap, &sender, proposal_id);
        
        let install_plugin_cap = DAOSpace::acquire_install_plugin_cap<DAOT, InstallPluginProposalPlugin>(&witness);
        DAOSpace::install_plugin<DAOT, InstallPluginProposalPlugin, ToInstallPluginT>(&install_plugin_cap, plugin_version, required_caps);
    }
}