/// Called by other contract which need proposal config
module StarcoinFramework::ConfigProposalPlugin {
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::InstallPluginProposalPlugin;

    struct ConfigProposalPlugin has store, drop{}

    struct ConfigProposalAction<ConfigT> has store {
        config: ConfigT,
    }

    public fun required_caps(): vector<CapType> {
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::modify_config_cap_type());
        caps
    }

    public fun create_proposal<DAOT: store, ConfigT: store>(sender: signer, description: vector<u8>,action_delay: u64, config: ConfigT) {
        let witness = ConfigProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, ConfigProposalPlugin>(&witness);
        let action = ConfigProposalAction<ConfigT>{
            config
        };
        DAOSpace::create_proposal<
            DAOT,
            ConfigProposalPlugin,
            ConfigProposalAction<ConfigT>>(&cap, &sender, action, description, action_delay);
    }

    public (script) fun execute_proposal<DAOT: store, ConfigT: copy + drop + store>(sender: signer, proposal_id: u64) {
        let witness = ConfigProposalPlugin{};
        let proposal_cap =
            DAOSpace::acquire_proposal_cap<DAOT, ConfigProposalPlugin>(&witness);
        let modify_config_cap =
            DAOSpace::acquire_modify_config_cap<DAOT, ConfigProposalPlugin>(&witness);

        let ConfigProposalAction<ConfigT>{ config } = DAOSpace::execute_proposal<
            DAOT,
            ConfigProposalPlugin,
            ConfigProposalAction<ConfigT>>(&proposal_cap, &sender, proposal_id);
        DAOSpace::set_custom_config<DAOT, ConfigProposalPlugin, ConfigT>(&mut modify_config_cap, config);
    }

    public (script) fun install_plugin_proposal<DAOT:store>(sender:signer, description: vector<u8>, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, ConfigProposalPlugin>(&sender, required_caps(), description, action_delay);
    } 
}