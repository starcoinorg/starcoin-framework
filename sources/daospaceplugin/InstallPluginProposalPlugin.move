//TODO find more good name
module StarcoinFramework::InstallPluginProposalPlugin{
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;

    struct InstallPluginProposalPlugin has store, drop{}

    struct InstallPluginAction<phantom ToInstallPluginT> has store {
        required_caps: vector<CapType>,
    }

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());   
        Vector::push_back(&mut caps, DAOSpace::install_plugin_cap_type());    
        caps
    }

    //TODO how to unify arguments.
    public fun create_proposal<DAOT: store, ToInstallPluginT: store>(sender: &signer, required_caps: vector<CapType>, description: vector<u8>, action_delay: u64){
        let witness = InstallPluginProposalPlugin{};

        let cap = DAOSpace::acquire_proposal_cap<DAOT, InstallPluginProposalPlugin>(&witness);
        let action = InstallPluginAction<ToInstallPluginT>{
            required_caps,
        };
        DAOSpace::create_proposal(&cap, sender, action, description, action_delay);
    }

    public (script) fun execute_proposal<DAOT: store, ToInstallPluginT: store>(sender: signer, proposal_id: u64){
        let witness = InstallPluginProposalPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, InstallPluginProposalPlugin>(&witness);
        let InstallPluginAction{required_caps} = DAOSpace::execute_proposal<DAOT, InstallPluginProposalPlugin, InstallPluginAction<ToInstallPluginT>>(&proposal_cap, &sender, proposal_id);
        let install_plugin_cap = DAOSpace::acquire_install_plugin_cap<DAOT, InstallPluginProposalPlugin>(&witness);
        DAOSpace::install_plugin<DAOT, InstallPluginProposalPlugin, ToInstallPluginT>(&install_plugin_cap, required_caps);
    }
}