module StarcoinFramework::UpgradeModulePlugin {
    use StarcoinFramework::Option;
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::InstallPluginProposalPlugin;

    struct UpgradeModulePlugin has store, drop{}

    struct UpgradeModuleAction has store, drop {
        package_hash: vector<u8>,
        version: u64,
        enforced: bool
    }

    public fun initialize(_sender: &signer) {
        let witness = UpgradeModulePlugin{};

        DAOPluginMarketplace::register_plugin<UpgradeModulePlugin>(
            &witness,
            b"0x1::UpgradeModulePlugin",
            b"The plugin for upgrade module.",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();

        DAOPluginMarketplace::publish_plugin_version<UpgradeModulePlugin>(
            &witness,
            b"v0.1.0",
            *&implement_extpoints,
            *&depend_extpoints,
            b"inner-plugin://upgrade-module-plugin",
        );
    }

    public fun required_caps(): vector<CapType> {
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::upgrade_module_cap_type());
        caps
    }

    public fun create_proposal<DAOT: store>(sender: &signer, title:vector<u8>, introduction:vector<u8>, description: vector<u8>, action_delay:u64, package_hash: vector<u8>, version: u64, enforced: bool) {
        let witness = UpgradeModulePlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, UpgradeModulePlugin>(&witness);
        let action = UpgradeModuleAction{
            package_hash,
            version,
            enforced
        };
        DAOSpace::create_proposal<
            DAOT,
            UpgradeModulePlugin,
            UpgradeModuleAction>(&cap, sender, action, title, introduction, description, action_delay);
    }

    public (script) fun create_proposal_entry <DAOT: store>(sender: signer, title:vector<u8>, introduction:vector<u8>, description: vector<u8>, action_delay:u64, package_hash: vector<u8>, version: u64, enforced: bool) {
        create_proposal<DAOT>(&sender, title, introduction, description, action_delay, package_hash, version, enforced);
    }

    public fun execute_proposal<DAOT: store>(sender: &signer, proposal_id: u64) {
        let witness = UpgradeModulePlugin{};
        let proposal_cap =
            DAOSpace::acquire_proposal_cap<DAOT, UpgradeModulePlugin>(&witness);
        let upgrade_module_cap =
            DAOSpace::acquire_upgrade_module_cap<DAOT, UpgradeModulePlugin>(&witness);

        let UpgradeModuleAction{
            package_hash,
            version,
            enforced
        } = DAOSpace::execute_proposal<
            DAOT,
            UpgradeModulePlugin,
            UpgradeModuleAction>(&proposal_cap, sender, proposal_id);
        DAOSpace::submit_upgrade_plan<DAOT, UpgradeModulePlugin>(&mut upgrade_module_cap, package_hash, version, enforced);
    }

    public (script) fun execute_proposal_entry<DAOT: store>(sender: signer, proposal_id: u64) {
        execute_proposal<DAOT>(&sender, proposal_id);
    }

    public fun install_plugin_proposal<DAOT:store>(sender:&signer, title:vector<u8>, introduction:vector<u8>, description: vector<u8>, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, UpgradeModulePlugin>(sender,required_caps(), title, introduction,  description, action_delay);
    } 

    public (script) fun install_plugin_proposal_entry<DAOT:store>(sender:signer, title:vector<u8>, introduction:vector<u8>, description: vector<u8>, action_delay:u64){
        install_plugin_proposal<DAOT>(&sender, title, introduction, description, action_delay);
    }
}