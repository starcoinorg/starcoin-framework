/// Called by other contract which need proposal config
module StarcoinFramework::ConfigProposalPlugin {
    use StarcoinFramework::GenesisDao::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::Config;

    struct ConfigProposalPlugin has drop {}

    struct ConfigProposalAction<ConfigT> has store {
        config: ConfigT,
    }

    public fun required_caps(): vector<CapType> {
        Vector::singleton(GenesisDao::proposal_cap_type())
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

    public(script) fun execute_proposal<DaoT: store, ConfigT: copy + drop + store>(sender: signer, proposal_id: u64) {
        let witness = ConfigProposalPlugin{};
        let proposal_cap = GenesisDao::acquire_proposal_cap<DaoT, ConfigProposalPlugin>(&witness);
        let ConfigProposalAction<ConfigT>{ config } = GenesisDao::execute_proposal<
            DaoT,
            ConfigProposalPlugin,
            ConfigProposalAction<ConfigT>>(&proposal_cap, &sender, proposal_id);
        Config::publish_new_config<ConfigT>(&sender, config);
    }
}