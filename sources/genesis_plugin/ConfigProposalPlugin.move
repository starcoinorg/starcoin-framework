/// Called by other contract which need proposal config
module StarcoinFramework::ConfigProposalPlugin {
    use StarcoinFramework::GenesisDao::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::InstallPluginProposalPlugin;

    struct ConfigProposalPlugin has drop {}

    struct ConfigProposalAction<ConfigT> has store {
        config: ConfigT,
    }

    public fun required_caps(): vector<CapType> {
        let caps = Vector::singleton(GenesisDao::proposal_cap_type());
        Vector::push_back(&mut caps, GenesisDao::modify_config_cap_type());
        caps
    }

    public fun create_proposal<DaoT: store, ConfigT: store>(sender: signer, action_delay: u64, config: ConfigT) {
        let witness = ConfigProposalPlugin{};
        let cap = GenesisDao::acquire_proposal_cap<DaoT, ConfigProposalPlugin>(&witness);
        let action = ConfigProposalAction<ConfigT>{
            config
        };
        GenesisDao::create_proposal<
            DaoT,
            ConfigProposalPlugin,
            ConfigProposalAction<ConfigT>>(&cap, &sender, action, action_delay);
    }

    public (script) fun execute_proposal<DaoT: store, ConfigT: copy + drop + store>(sender: signer, proposal_id: u64) {
        let witness = ConfigProposalPlugin{};
        let proposal_cap =
            GenesisDao::acquire_proposal_cap<DaoT, ConfigProposalPlugin>(&witness);
        let modify_config_cap =
            GenesisDao::acquire_modify_config_cap<DaoT, ConfigProposalPlugin>(&witness);

        let ConfigProposalAction<ConfigT>{ config } = GenesisDao::execute_proposal<
            DaoT,
            ConfigProposalPlugin,
            ConfigProposalAction<ConfigT>>(&proposal_cap, &sender, proposal_id);
        GenesisDao::set_custom_config<DaoT, ConfigProposalPlugin, ConfigT>(&mut modify_config_cap, config);
    }

    public (script) fun install_plugin_proposal<DaoT:store>(sender:signer, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DaoT, ConfigProposalPlugin>(&sender, required_caps(), action_delay);
    } 
}