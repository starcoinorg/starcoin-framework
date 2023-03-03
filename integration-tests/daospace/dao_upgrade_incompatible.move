//# init -n dev

//# faucet --addr creator --amount 100000000000

//# faucet --addr alice --amount 10000000000

//# publish
module creator::DAOHelper {
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::DAOAccount;
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::AnyMemberPlugin::{Self, AnyMemberPlugin};
    use StarcoinFramework::InstallPluginProposalPlugin::{Self, InstallPluginProposalPlugin};
    use StarcoinFramework::Vector;
    use StarcoinFramework::Option;

    struct X has store, copy, drop {}

    const NAME: vector<u8> = b"X";

    /// directly upgrade the sender account to DAOAccount and create DAO
    public(script) fun create_dao(
        sender: signer,
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        min_proposal_deposit: u128, ) {
        let dao_account_cap = DAOAccount::upgrade_to_dao(sender);

        let config = DAOSpace::new_dao_config(
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            min_proposal_deposit,
        );
        let dao_root_cap = DAOSpace::create_dao<X>(dao_account_cap, *&NAME, Option::none<vector<u8>>(), Option::none<vector<u8>>(), b"ipfs://description", X {}, config);

        DAOSpace::install_plugin_with_root_cap<X, InstallPluginProposalPlugin>(&dao_root_cap, InstallPluginProposalPlugin::required_caps());
        DAOSpace::install_plugin_with_root_cap<X, AnyMemberPlugin>(&dao_root_cap, AnyMemberPlugin::required_caps());

        DAOSpace::install_plugin_with_root_cap<X, XPlugin>(&dao_root_cap, required_caps());

        DAOSpace::burn_root_cap(dao_root_cap);
    }

    struct XPlugin has store, drop {}

    public fun initialize_x_plugin(sender: &signer) {
        DAOPluginMarketplace::register_plugin<XPlugin>(
            sender,
            b"0x1::XPlugin",
            b"The X plugin.",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();

        let witness = XPlugin{};
        DAOPluginMarketplace::publish_plugin_version<XPlugin>(
            sender,
            &witness,
            b"v0.1.0", 
            *&implement_extpoints,
            *&depend_extpoints,
            b"inner-plugin://x-plugin",
        );
    }

    public fun required_caps(): vector<CapType> {
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::install_plugin_cap_type());
        Vector::push_back(&mut caps, DAOSpace::member_cap_type());
        Vector::push_back(&mut caps, DAOSpace::upgrade_module_cap_type());
        caps
    }

    public fun submit_upgrade_plan(package_hash: vector<u8>, version: u64, enforced: bool) {
        let witness = XPlugin {};
        let upgrade_cap = DAOSpace::acquire_upgrade_module_cap<X, XPlugin>(&witness);
        DAOSpace::submit_upgrade_plan(&upgrade_cap, package_hash, version, enforced);
    }
}

//# run --signers creator
script {
    use creator::DAOHelper;

    fun main(sender: signer) {
        DAOHelper::initialize_x_plugin(&sender);
    }
}
// check: EXECUTED

//# package
module creator::test {
    public fun hello() {}
}

//# package
module creator::test {
    public fun hello() {}
    public fun world(_i: u8) {}
}

//# package
module creator::test {
    public fun hello(_i: u8) {}

    public fun world(_i: u8) {}
}

//# deploy {{$.package[0].file}}

//# run --signers creator
script {
    use StarcoinFramework::Config;
    use StarcoinFramework::PackageTxnManager;
    use StarcoinFramework::Version;
    use StarcoinFramework::Option;
    use StarcoinFramework::Signer;

    fun main(account: signer) {
        Config::publish_new_config<Version::Version>(&account, Version::new_version(1));
        PackageTxnManager::update_module_upgrade_strategy(&account, PackageTxnManager::get_strategy_two_phase(), Option::some<u64>(1));
        let strategy = PackageTxnManager::get_module_upgrade_strategy(Signer::address_of(&account));
        assert!(strategy == PackageTxnManager::get_strategy_two_phase(), 1001);
    }
}
//check: EXECUTED

//# run --signers creator
script {
    use creator::DAOHelper;

    fun main(sender: signer) {
        // time unit is millsecond
        DAOHelper::create_dao(sender, 10000, 3600000, 2, 10000, 10);
    }
}
// check: EXECUTED

//# block --author 0x1 --timestamp 86400000

//# run --signers alice --args {{$.package[1].package_hash}}
script {
    use creator::DAOHelper;

    fun main(_sender: signer, package_hash: vector<u8>) {
        DAOHelper::submit_upgrade_plan(package_hash, 2, true);
    }
}
//check: EXECUTED

//# block --author 0x1 --timestamp 86600000

//# deploy {{$.package[1].file}} --signers alice

//# run --signers alice
script {
    use creator::test;

    fun main(_sender: signer) {
        test::world(2);
    }
}
//check: EXECUTED

//# run --signers alice --args {{$.package[2].package_hash}}
script {
    use creator::DAOHelper;

    fun main(_sender: signer, package_hash: vector<u8>) {
        DAOHelper::submit_upgrade_plan(package_hash, 2, true);
    }
}
//check: EXECUTED

//# block --author 0x1 --timestamp 86700000

//# deploy {{$.package[2].file}} --signers alice
//check: Publish failure: MiscellaneousError

//# run --signers alice
script {
    use creator::test;

    fun main(_sender: signer) {
        test::hello(3);
    }
}
//check: ABORT. incompatiable upgrade is not allowed.