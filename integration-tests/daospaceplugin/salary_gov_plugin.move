//# init -n dev

//# faucet --addr creator --amount 10000000000000

//# faucet --addr acting_boss --amount 100000000000

//# faucet --addr alice --amount 10000000000

//# publish
module creator::SalaryGovPlugin {
    use StarcoinFramework::Signer;
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Account;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Option;

    const ERR_PLUGIN_USER_NOT_MEMBER: u64 = 1002;
    const ERR_PLUGIN_USER_IS_MEMBER: u64 = 1003;
    const ERR_PLUGIN_USER_NOT_PRIVILEGE: u64 = 1004;
    const ERR_PLUGIN_PERIOD_NOT_SAME: u64 = 1005;
    const ERR_PLUGIN_PERIOD_APPLICATION: u64 = 1006;

    struct SalaryGovPlugin has store, drop {}

    struct PluginBossCap<phantom DAOT> has key, store, drop {}

    struct SalaryReceive<phantom DAOT, phantom TokenT> has key {
        last_receive_time: u64,
    }

    struct BossProposalAction<phantom DAOT> has key, store, drop {
        boss: address,
    }

    public fun initialize(_sender: &signer) {
        let witness = SalaryGovPlugin{};

        DAOPluginMarketplace::register_plugin<SalaryGovPlugin>(
            &witness,
            b"0x1::SalaryGovPlugin",
            b"The salary plugin for DAO",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();

        DAOPluginMarketplace::publish_plugin_version<SalaryGovPlugin>(
            &witness,
            b"v0.1.0", 
            *&implement_extpoints,
            *&depend_extpoints,
            b"inner-plugin://salary-gov-plugin",
        );
    }

    public fun required_caps(): vector<DAOSpace::CapType> {
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::member_cap_type());
        Vector::push_back(&mut caps, DAOSpace::withdraw_token_cap_type());
        caps
    }

    /// acting_boss_claim_cap
    public fun acting_boss_claim_cap<DAOT: store>(sender: signer, _witness: &DAOT) {
        move_to<PluginBossCap<DAOT>>(&sender, PluginBossCap<DAOT> {});
    }

    /// burn boss cap
    public(script) fun burn_boss_cap<DAOT: store>(sender: signer) acquires PluginBossCap {
        assert_boss<DAOT>(&sender);
        let _ = move_from<PluginBossCap<DAOT>>(Signer::address_of(&sender));
    }

    public(script) fun join<DAOT: store, TokenT: store>(sender: signer, image_data: vector<u8>, image_url: vector<u8>) {
        let member = Signer::address_of(&sender);
        assert!(!DAOSpace::is_member<DAOT>(member), Errors::invalid_state(ERR_PLUGIN_USER_IS_MEMBER));

        let witness = SalaryGovPlugin {};
        let cap = DAOSpace::acquire_member_cap<DAOT, SalaryGovPlugin>(&witness);
        DAOSpace::join_member_with_member_cap<DAOT, SalaryGovPlugin>(&cap, &sender, Option::some(image_data), Option::some(image_url), 0);
        move_to(&sender, SalaryReceive<DAOT, TokenT> {
            last_receive_time: Timestamp::now_seconds(),
        });
    }

    public(script) fun quit<DAOT: store, TokenT: store>(sender: signer)
    acquires SalaryReceive {
        let member = Signer::address_of(&sender);
        assert!(DAOSpace::is_member<DAOT>(member), Errors::invalid_state(ERR_PLUGIN_USER_NOT_MEMBER));

        let witness = SalaryGovPlugin {};
        let cap = DAOSpace::acquire_member_cap<DAOT, SalaryGovPlugin>(&witness);
        DAOSpace::revoke_member(&cap, member);

        receive_with_amount<DAOT, TokenT>(member,
            compute_salary_amount<DAOT, TokenT>(member));

        let SalaryReceive<DAOT, TokenT> {
            last_receive_time: _,
        } = move_from<SalaryReceive<DAOT, TokenT>>(member);
    }

    /// Increase salary per second for member
    public(script) fun increase_salary<DAOT: store, TokenT: store>(sender: signer, member: address, amount: u128)
    acquires SalaryReceive {
        assert_boss<DAOT>(&sender);
        assert!(DAOSpace::is_member<DAOT>(member), Errors::invalid_state(ERR_PLUGIN_USER_NOT_MEMBER));

        receive_with_amount<DAOT, TokenT>(member, compute_salary_amount<DAOT, TokenT>(member));

        let witness = SalaryGovPlugin {};
        let cap = DAOSpace::acquire_member_cap<DAOT, SalaryGovPlugin>(&witness);
        DAOSpace::increase_member_sbt(&cap, member, amount);
    }

    /// Decrease salary per second for member
    public(script) fun decrease_salary<DAOT: store, TokenT: store>(sender: signer, member: address, amount: u128)
    acquires SalaryReceive {
        assert_boss<DAOT>(&sender);
        assert!(DAOSpace::is_member<DAOT>(member), Errors::invalid_state(ERR_PLUGIN_USER_NOT_MEMBER));

        receive_with_amount<DAOT, TokenT>(member, compute_salary_amount<DAOT, TokenT>(member));

        let witness = SalaryGovPlugin {};
        let cap = DAOSpace::acquire_member_cap<DAOT, SalaryGovPlugin>(&witness);
        DAOSpace::decrease_member_sbt(&cap, member, amount);
    }

    public(script) fun receive<DAOT: store, TokenT: store>(member: address) acquires SalaryReceive {
        assert!(DAOSpace::is_member<DAOT>(member), Errors::invalid_state(ERR_PLUGIN_USER_NOT_MEMBER));

        let amount = compute_salary_amount<DAOT, TokenT>(member);
        //assert!(now_seconds() - receive.last_receive_time > config.period,
        //    Errors::invalid_state(ERR_PLUGIN_RECEIVE_TIME_NOT_REACHED))
        receive_with_amount<DAOT, TokenT>(member, amount);
    }

    fun compute_salary_amount<DAOT: store, TokenT>(member: address): u128 acquires SalaryReceive {
        let sbt_amount = DAOSpace::query_sbt<DAOT>(member);
        let receive = borrow_global<SalaryReceive<DAOT, TokenT>>(member);

        sbt_amount * ((Timestamp::now_seconds() - receive.last_receive_time) as u128)
    }

    /// Calling by member that receive salary
    fun receive_with_amount<DAOT: store, TokenT: store>(member: address, amount: u128)
    acquires SalaryReceive {
        let witness = SalaryGovPlugin {};

        let withdraw_cap =
            DAOSpace::acquire_withdraw_token_cap<DAOT, SalaryGovPlugin>(&witness);
        let token = DAOSpace::withdraw_token<DAOT, SalaryGovPlugin, TokenT>(&withdraw_cap, amount);
        Account::deposit<TokenT>(member, token);

        let receive = borrow_global_mut<SalaryReceive<DAOT, TokenT>>(member);
        receive.last_receive_time = Timestamp::now_seconds();
    }

    /// Create proposal for specific admin account
    public(script) fun create_boss_elect_proposal<DAOT: store>(sender: signer, title:vector<u8>, introduction:vector<u8>, description: vector<u8>, action_delay: u64) {
        let witness = SalaryGovPlugin {};

        let cap = DAOSpace::acquire_proposal_cap<DAOT, SalaryGovPlugin>(&witness);
        let action = BossProposalAction<DAOT> {
            boss: Signer::address_of(&sender)
        };
        DAOSpace::create_proposal(&cap, &sender, action, title, introduction, description, action_delay, Option::none<u8>());
    }

    public(script) fun execute_proposal<DAOT: store>(sender: signer, proposal_id: u64) {
        let witness = SalaryGovPlugin {};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, SalaryGovPlugin>(&witness);
        let BossProposalAction<DAOT> { boss } =
            DAOSpace::execute_proposal<DAOT, SalaryGovPlugin, BossProposalAction<DAOT>>(&proposal_cap, &sender, proposal_id);
        assert!(boss == Signer::address_of(&sender), Errors::invalid_state(ERR_PLUGIN_USER_NOT_PRIVILEGE));
        move_to(&sender, PluginBossCap<DAOT> {})
    }

    fun assert_boss<DAOT: store>(signer: &signer) {
        let user = Signer::address_of(signer);
        assert!(exists<PluginBossCap<DAOT>>(user), Errors::invalid_state(ERR_PLUGIN_USER_NOT_PRIVILEGE))
    }
}

//# publish
module creator::XDAO {
    use creator::SalaryGovPlugin::{Self, SalaryGovPlugin};
    use StarcoinFramework::DAOAccount;
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::AnyMemberPlugin::{Self, AnyMemberPlugin};
    use StarcoinFramework::InstallPluginProposalPlugin::{Self, InstallPluginProposalPlugin};
    use StarcoinFramework::Option;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;

    const ERR_NOT_ACTING_BOSS: u64 = 1001;

    struct XDAO has store, copy, drop {
        acting_boss: address,
    }

    const NAME: vector<u8> = b"X";

    /// directly upgrade the sender account to DAOAccount and create DAO
    public(script) fun create_dao(
        sender: signer,
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        min_proposal_deposit: u128,
        acting_boss: address) {
        let dao_account_cap = DAOAccount::upgrade_to_dao(sender);


        //let dao_signer = DAOAccount::dao_signer(&dao_account_cap);
        let config = DAOSpace::new_dao_config(
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            min_proposal_deposit,
        );
        DAOSpace::create_dao<XDAO>(dao_account_cap, *&NAME, Option::none<vector<u8>>(),
            Option::none<vector<u8>>(), b"ipfs://description", XDAO { acting_boss }, config);

        let witness = XDAO { acting_boss };
        let install_cap = DAOSpace::acquire_install_plugin_cap<XDAO, XDAO>(&witness);
        DAOSpace::install_plugin<XDAO, XDAO, InstallPluginProposalPlugin>(&install_cap, InstallPluginProposalPlugin::required_caps());
        DAOSpace::install_plugin<XDAO, XDAO, AnyMemberPlugin>(&install_cap, AnyMemberPlugin::required_caps());
        DAOSpace::install_plugin<XDAO, XDAO, SalaryGovPlugin>(&install_cap, SalaryGovPlugin::required_caps());
    }

    /// acting boss claim boss cap
    public(script) fun acting_boss_claim_cap(sender: signer) {
        let witness = XDAO {
            acting_boss: Signer::address_of(&sender),
        };
        let XDAO { acting_boss } = DAOSpace::take_ext(&witness);
        assert!(acting_boss == Signer::address_of(&sender), Errors::invalid_state(ERR_NOT_ACTING_BOSS));
        SalaryGovPlugin::acting_boss_claim_cap(sender, &witness);
    }
}

//# block --author 0x1 --timestamp 86400000

//# run --signers creator
script {
    use creator::SalaryGovPlugin;
    use creator::XDAO;

    fun main(sender: signer) {
        SalaryGovPlugin::initialize(&sender);

        // time unit is millsecond
        XDAO::create_dao(sender, 10000, 360000, 1, 10000, 0, @acting_boss);
    }
}
// check: EXECUTED


//# run --signers acting_boss
script {
    use creator::XDAO;

    fun main(sender: signer) {
        XDAO::acting_boss_claim_cap(sender);
    }
}
// check: EXECUTED


//# block --timestamp 86500000

//# run --signers alice
script {
    use creator::XDAO::XDAO;
    use creator::SalaryGovPlugin;
    use StarcoinFramework::STC::STC;

    fun main(sender: signer) {
        let image_data = b"image";
        let image_url = b"";
        SalaryGovPlugin::join<XDAO, STC>(sender, image_data, image_url);
    }
}
// check: EXECUTED


//# run --signers acting_boss
script {
    use creator::XDAO::XDAO;
    use creator::SalaryGovPlugin;
    use StarcoinFramework::STC::STC;

    fun main(sender: signer) {
        let salary = 123332u128;
        SalaryGovPlugin::increase_salary<XDAO, STC>(sender, @alice, salary);
    }
}
// check: EXECUTED


//# block --timestamp 87500000

//# run --signers alice
script {
    use creator::XDAO::XDAO;
    use creator::SalaryGovPlugin;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Account;

    fun main(_sender: signer) {
        let old_balance = Account::balance<STC>(@alice);
        SalaryGovPlugin::receive<XDAO, STC>(@alice);
        let new_balance = Account::balance<STC>(@alice);

        let expect_received = 123332u128 * (87500 - 86500);
        assert!(new_balance == old_balance + expect_received, 101);
    }
}
// check: EXECUTED


//# run --signers alice
script {
    use creator::XDAO::XDAO;
    use creator::SalaryGovPlugin;
    use StarcoinFramework::STC::STC;

    fun main(sender: signer) {
        SalaryGovPlugin::increase_salary<XDAO, STC>(sender, @alice, 20000u128);
    }
}
// check: ABORTED, only boss can increase_salary

//# block --timestamp 89500000

//# run --signers acting_boss
script {
    use creator::XDAO::XDAO;
    use creator::SalaryGovPlugin;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Account;

    fun main(sender: signer) {

        let old_balance = Account::balance<STC>(@alice);
        SalaryGovPlugin::increase_salary<XDAO, STC>(sender, @alice, 20000u128);
        let new_balance = Account::balance<STC>(@alice);

        let expect_received = 123332u128 * (89500 - 87500);
        assert!(new_balance == old_balance + expect_received, 101);
    }
}
// check: EXECUTED

//# block --timestamp 901921000

//# run --signers alice
script {
    use creator::XDAO::XDAO;
    use creator::SalaryGovPlugin;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Account;

    fun main(_sender: signer) {
        let old_balance = Account::balance<STC>(@alice);
        SalaryGovPlugin::receive<XDAO, STC>(@alice);
        let new_balance = Account::balance<STC>(@alice);

        let expect_received = (123332u128 + 20000u128) * (901921 - 89500);
        assert!(new_balance == old_balance + expect_received, 101);
    }
}
// check: EXECUTED

//# run --signers acting_boss
script {
    use creator::XDAO::XDAO;
    use creator::SalaryGovPlugin;

    fun main(sender: signer) {
        SalaryGovPlugin::burn_boss_cap<XDAO>(sender);
    }
}
// check: EXECUTED

//# run --signers acting_boss
script {
    use creator::XDAO::XDAO;
    use creator::SalaryGovPlugin;
    use StarcoinFramework::STC::STC;

    fun main(sender: signer) {
        SalaryGovPlugin::increase_salary<XDAO, STC>(sender, @alice, 20000u128);
    }
}
// check: ABORT, reason: acting_boss has no boss_cap anymore.