//TODO find more good name
module StarcoinFramework::AnyMemberPlugin{
    use StarcoinFramework::GenesisDao::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;
    use StarcoinFramework::InstallPluginProposalPlugin;

    struct AnyMemberPlugin has drop{}

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(GenesisDao::member_cap_type());  
        caps 
    }

    //TODO how to unify arguments.
    public (script) fun join<DaoT: store>(sender: signer){
        let witness = AnyMemberPlugin{};
        let member_cap = GenesisDao::acquire_member_cap<DaoT, AnyMemberPlugin>(&witness);
        GenesisDao::join_member(&member_cap, Signer::address_of(&sender), 1);
    }

    public (script) fun install_plugin_proposal<DaoT:store>(sender:signer, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DaoT, AnyMemberPlugin>(&sender, required_caps(), action_delay);
    } 
}