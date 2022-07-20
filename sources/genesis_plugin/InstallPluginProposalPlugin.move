//TODO find more good name
module StarcoinFramework::InstallPluginProposalPlugin{
    use StarcoinFramework::DaoSpace::{Self, CapType};
    use StarcoinFramework::Vector;

    struct InstallPluginProposalPlugin has drop{}

    struct InstallPluginAction<phantom ToInstallPluginT> has store {
        required_caps: vector<CapType>,
    }

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(DaoSpace::proposal_cap_type());   
        Vector::push_back(&mut caps, DaoSpace::install_plugin_cap_type());    
        caps
    }

    //TODO how to unify arguments.
    public fun create_proposal<DaoT: store, ToInstallPluginT>(sender: &signer, required_caps: vector<CapType>, action_delay: u64){
        let witness = InstallPluginProposalPlugin{};

        let cap = DaoSpace::acquire_proposal_cap<DaoT, InstallPluginProposalPlugin>(&witness);
        let action = InstallPluginAction<ToInstallPluginT>{
            required_caps,
        };
        DaoSpace::create_proposal(&cap, sender, action, action_delay);
    }

    public (script) fun execute_proposal<DaoT: store, ToInstallPluginT>(sender: signer, proposal_id: u64){
        let witness = InstallPluginProposalPlugin{};
        let proposal_cap = DaoSpace::acquire_proposal_cap<DaoT, InstallPluginProposalPlugin>(&witness);
        let InstallPluginAction{required_caps} = DaoSpace::execute_proposal<DaoT, InstallPluginProposalPlugin, InstallPluginAction<ToInstallPluginT>>(&proposal_cap, &sender, proposal_id);
        let install_plugin_cap = DaoSpace::acquire_install_plugin_cap<DaoT, InstallPluginProposalPlugin>(&witness);
        DaoSpace::install_plugin<DaoT, InstallPluginProposalPlugin, ToInstallPluginT>(&install_plugin_cap, required_caps);
    }
}