module StarcoinFramework::XProposalPlugin{
//    use StarcoinFramework::GenesisDao::{Self,  ProposalPluginCapability};
//    use StarcoinFramework::DaoRegistry;
//    use StarcoinFramework::XProposal;
//
//    // type identify for XPlugin
//    struct XPlugin{
//    }
//
//    struct XPluginConfig{
//        cfg_1: u64,
//    }
//
//    struct XAction{
//    }
//
//    struct ProposalPluginCapability<phantom XPlugin: store>{
//    }
//
//    struct ProposalPluginCapabilityHolder<phantom XPlugin: store>{
////        cap: ProposalPluginCapability<XPlugin>{}
//    }
//
//    fun new_action(args:vector<u8>): XAction{
//        //bcs decode args
//        //construct XAction
//        XAction {
//
//        }
//    }
//
//    //return plugin accuqire capabilities
//    public fun get_capabilities():vector<u8>{}
//
//    public fun install_plugin<DaoT>(cap: &Dao::PluginInstallCapability, installer: &signer, capabilities: vector<u8>, config:vector<u8>){
//        //bcs decode config arg, construct config.
//        let config = XPluginConfig{}
//        let plugin = XPlugin{};
//        Dao::install_proposal_plugin_capability<DaoT, XPlugin>(cap, &plugin, installer, capabilities);
//        //save config
//        Dao::move_to<DaoT, XPlugin>(&plugin, config);
//    }
//
//    public fun execute_proposal<DaoT>(sender: &signer, proposal_id: u64) acquires ProposalPluginCapabilityHolder{
//        let dao_address = DaoRegistry::dao_address<DaoT>();
//        let cap_holder = borrow_global<ProposalPluginCapabilityHolder>(dao_address);
//        let actoin = XProposal::extract_proposal_action<DaoT, XAction>(&cap_holder.cap, sender, proposal_id);
//        //execute the action,such as trasnfer token
//        let plugin = XPlugin{};
//        let withdraw_cap = Dao::acquire_withdraw_token_cap_for_plugin<DaoT,XPlugin>(&plugin);
//        let token = Dao::withdraw<STC>(&withdraw_cap, 1000);
//        //update the executor
//    }
//
//    //the entry script function
//    public(script) fun execute_proposal_entry<DaoT>(sender: signer, proposal_id: u64){
//        execute_proposal<DaoT>(&sender, proposal_id)
//    }
//
//    public fun propose<DaoT>(sender:&signer, args:vector<u8>, exec_delay: u64){
//        let action = new_action(args);
//
//        let dao_address = GenesisDao::DaoRegistry::dao_address<DaoT>();
//        let cap_holder = borrow_global<ProposalPluginCapabilityHolder>(dao_address);
//
//        Dao::propose<DaoT, XAction>(&cap_holder.cap, sender, action, exec_delay, exec_delay);
//    }
//
//    public(script) fun propose_entry<DaoT>(sender:signer, args:vector<u8>, exec_delay: u64){
//        propose(&sender, args, exec_delay)
//    }

}