module StarcoinFramework::UpgradeModulePlugin {
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::InstallPluginProposalPlugin;

    struct UpgradeModulePlugin has store, drop{}

    struct UpgradeModuleAction has store {
        package_hash: vector<u8>,
        version: u64,
        enforced: bool
    }

    public fun required_caps(): vector<CapType> {
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::modify_config_cap_type());
        caps
    }

    public fun create_proposal<DAOT: store>(sender: signer, description: vector<u8>, action_delay:u64, package_hash: vector<u8>, version: u64, enforced: bool) {
        let witness = UpgradeModulePlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, UpgradeModulePlugin>(&witness);
        let action = UpgradeModuleAction{
            package_hash: package_hash,
            version: version,
            enforced: enforced
        };
        DAOSpace::create_proposal<
            DAOT,
            UpgradeModulePlugin,
            UpgradeModuleAction>(&cap, &sender, action, description, action_delay);
    }

    public (script) fun execute_proposal<DAOT: store>(sender: signer, proposal_id: u64) {
        let witness = UpgradeModulePlugin{};
        let proposal_cap =
            DAOSpace::acquire_proposal_cap<DAOT, UpgradeModulePlugin>(&witness);
        let upgrade_module_cap =
            DAOSpace::acquire_upgrade_module_cap<DAOT, UpgradeModulePlugin>(&witness);

        let UpgradeModuleAction{
            package_hash: package_hash,
            version: version,
            enforced: enforced 
        } = DAOSpace::execute_proposal<
            DAOT,
            UpgradeModulePlugin,
            UpgradeModuleAction>(&proposal_cap, &sender, proposal_id);
        DAOSpace::submit_upgrade_plan<DAOT, UpgradeModulePlugin>(&mut upgrade_module_cap, package_hash, version, enforced);
    }

    public (script) fun install_plugin_proposal<DAOT:store>(sender:signer, description: vector<u8>, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, UpgradeModulePlugin>(&sender, required_caps(), description, action_delay);
    } 
}