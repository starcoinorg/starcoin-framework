/// Called by other contract which need proposal config
module StarcoinFramework::ConfigProposalPlugin {
    use StarcoinFramework::Option;
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::InstallPluginProposalPlugin;

    struct ConfigProposalPlugin has store, drop{}

    struct ConfigProposalAction<ConfigT> has store, drop {
        config: ConfigT,
    }

    public fun initialize(_sender: &signer) {
        let witness = ConfigProposalPlugin{};

        DAOPluginMarketplace::register_plugin<ConfigProposalPlugin>(
            &witness,
            b"0x1::ConfigProposalPlugin",
            b"The config proposal plugin",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();

        DAOPluginMarketplace::publish_plugin_version<ConfigProposalPlugin>(
            &witness,
            b"v0.1.0", 
            *&implement_extpoints,
            *&depend_extpoints,
            b"inner-plugin://config-proposal-plugin",
        );
    }

    public fun required_caps(): vector<CapType> {
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::modify_config_cap_type());
        caps
    }

    public fun create_proposal<DAOT: store, ConfigT: store+drop>(sender: &signer, title:vector<u8>, introduction:vector<u8>, description: vector<u8>,action_delay: u64, config: ConfigT) {
        let witness = ConfigProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, ConfigProposalPlugin>(&witness);
        let action = ConfigProposalAction<ConfigT>{
            config
        };
        DAOSpace::create_proposal<
            DAOT,
            ConfigProposalPlugin,
            ConfigProposalAction<ConfigT>>(&cap, sender, action, title, introduction, description, action_delay);
    }

    public fun execute_proposal<DAOT: store, ConfigT: copy + drop + store>(sender: &signer, proposal_id: u64) {
        let witness = ConfigProposalPlugin{};
        let proposal_cap =
            DAOSpace::acquire_proposal_cap<DAOT, ConfigProposalPlugin>(&witness);
        let modify_config_cap =
            DAOSpace::acquire_modify_config_cap<DAOT, ConfigProposalPlugin>(&witness);

        let ConfigProposalAction<ConfigT>{ config } = DAOSpace::execute_proposal<
            DAOT,
            ConfigProposalPlugin,
            ConfigProposalAction<ConfigT>>(&proposal_cap, sender, proposal_id);
        DAOSpace::set_custom_config<DAOT, ConfigProposalPlugin, ConfigT>(&mut modify_config_cap, config);
    }

    public (script) fun execute_proposal_entry<DAOT: store, ConfigT: copy + drop + store>(sender: signer, proposal_id: u64) {
        execute_proposal<DAOT, ConfigT>(&sender, proposal_id);
    }

    public fun install_plugin_proposal<DAOT:store>(sender:&signer, title:vector<u8>, introduction:vector<u8>, description: vector<u8>, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, ConfigProposalPlugin>(sender, required_caps(), title, introduction, description, action_delay);
    }

    public (script) fun install_plugin_proposal_entry<DAOT:store>(sender:signer, title:vector<u8>, introduction:vector<u8>, description: vector<u8>, action_delay:u64){
        install_plugin_proposal<DAOT>(&sender, title, introduction, description, action_delay);
    }

}