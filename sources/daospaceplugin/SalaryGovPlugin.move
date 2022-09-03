address StarcoinFramework {
module SalaryGovPlugin {

    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Account;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Option;
    use StarcoinFramework::Math;

    const ERR_PLUGIN_USER_NOT_MEMBER: u64 = 1002;
    const ERR_PLUGIN_USER_IS_MEMBER: u64 = 1003;
    const ERR_PLUGIN_USER_NOT_PRIVILEGE: u64 = 1004;
    const ERR_PLUGIN_PERIOD_NOT_SAME: u64 = 1005;
    const ERR_PLUGIN_PERIOD_APPLICATION: u64 = 1006;

    struct SalaryGovPlugin has store, drop{}

    struct PluginBossCap<phantom DAOT> has key, store, drop {}

    struct SalaryReceive<phantom DAOT, phantom TokenT> has key {
        last_receive_time: u64,
        period: u64,
    }

    struct BossProposalAction<phantom DAOT> has key, store {
        boss: address,
    }

    struct PeriodApplication<phantom DAOT> has key {
        /// new period
        period: u64,
    }

    public fun required_caps(): vector<DAOSpace::CapType> {
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::member_cap_type());
        Vector::push_back(&mut caps, DAOSpace::withdraw_token_cap_type());
        caps
    }

    /// Members apply for changing period.
    public (script) fun member_apply_period<DAOT: store, TokenT>(sender: signer, period: u64) {
        let member = Signer::address_of(&sender);
        assert!(DAOSpace::is_member<DAOT>(member), Errors::invalid_state(ERR_PLUGIN_USER_NOT_MEMBER));
        assert!(!exists<PeriodApplication<DAOT>>(member), Errors::already_published(ERR_PLUGIN_PERIOD_APPLICATION));
        move_to<PeriodApplication<DAOT>>(&sender, PeriodApplication<DAOT> { period });
    }

    /// Boss confirm the changing period application.
    public (script) fun boss_confirm_period<DAOT: store, TokenT: store>(boss: signer, member: address, period: u64)
    acquires PeriodApplication, SalaryReceive {
        assert_boss<DAOT>(&boss);
        assert!(exists<PeriodApplication<DAOT>>(member), Errors::not_published(ERR_PLUGIN_PERIOD_APPLICATION));
        let PeriodApplication<DAOT> { period: applied_period } = move_from<PeriodApplication<DAOT>>(member);
        assert!(applied_period == period, Errors::invalid_state(ERR_PLUGIN_PERIOD_NOT_SAME));
        receive_with_amount<DAOT, TokenT>(member,
            compute_salary_amount<DAOT, TokenT>(member));

        let receive = borrow_global_mut<SalaryReceive<DAOT, TokenT>>(member);
        receive.period = period;
    }

    public(script) fun join<DAOT: store, TokenT: store>(sender: signer, period: u64, image_data:vector<u8>, image_url:vector<u8>) {
        let member = Signer::address_of(&sender);
        assert!(!DAOSpace::is_member<DAOT>(member), Errors::invalid_state(ERR_PLUGIN_USER_IS_MEMBER));

        let witness = SalaryGovPlugin{};
        let cap = DAOSpace::acquire_member_cap<DAOT, SalaryGovPlugin>(&witness);
        DAOSpace::join_member<DAOT, SalaryGovPlugin>(&cap, member, Option::some(image_data), Option::some(image_url), 0);

        move_to(&sender, SalaryReceive<DAOT, TokenT>{
            last_receive_time: Timestamp::now_seconds(),
            period,
        });
    }

    public(script) fun quit<DAOT: store, TokenT: store>(sender: signer)
    acquires SalaryReceive {
        let member = Signer::address_of(&sender);
        assert!(DAOSpace::is_member<DAOT>(member), Errors::invalid_state(ERR_PLUGIN_USER_NOT_MEMBER));

        let witness = SalaryGovPlugin{};
        let cap = DAOSpace::acquire_member_cap<DAOT, SalaryGovPlugin>(&witness);
        DAOSpace::revoke_member(&cap, member);

        receive_with_amount<DAOT, TokenT>(member,
            compute_salary_amount<DAOT, TokenT>(member));

        let SalaryReceive<DAOT, TokenT>{
            last_receive_time: _,
            period: _,
        } = move_from<SalaryReceive<DAOT, TokenT>>(member);
    }

    public(script) fun increase_salary<DAOT: store, TokenT: store>(sender: signer, member: address, amount: u128)
    acquires SalaryReceive {
        assert_boss<DAOT>(&sender);
        assert!(DAOSpace::is_member<DAOT>(member), Errors::invalid_state(ERR_PLUGIN_USER_NOT_MEMBER));

        receive_with_amount<DAOT, TokenT>(member, compute_salary_amount<DAOT, TokenT>(member));

        let witness = SalaryGovPlugin{};
        let cap = DAOSpace::acquire_member_cap<DAOT, SalaryGovPlugin>(&witness);
        DAOSpace::increase_member_sbt(&cap, member, amount);
    }

    public(script) fun decrease_salary<DAOT: store, TokenT: store>(sender: signer, member: address, amount: u128)
    acquires SalaryReceive {
        assert_boss<DAOT>(&sender);
        assert!(DAOSpace::is_member<DAOT>(member), Errors::invalid_state(ERR_PLUGIN_USER_NOT_MEMBER));

        receive_with_amount<DAOT, TokenT>(member, compute_salary_amount<DAOT, TokenT>(member));

        let witness = SalaryGovPlugin{};
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
        let sbt_amount = DAOSpace::query_sbt<DAOT, SalaryGovPlugin>(member);
        let receive = borrow_global<SalaryReceive<DAOT, TokenT>>(member);

        let period = receive.period;
        Math::mul_div(sbt_amount, ((Timestamp::now_seconds() - receive.last_receive_time) as u128), (period as u128))
    }

    /// Calling by member that receive salary
    fun receive_with_amount<DAOT: store, TokenT: store>(member: address, amount: u128)
    acquires SalaryReceive {
        let witness = SalaryGovPlugin{};

        let withdraw_cap =
            DAOSpace::acquire_withdraw_token_cap<DAOT, SalaryGovPlugin>(&witness);
        let token = DAOSpace::withdraw_token<DAOT, SalaryGovPlugin, TokenT>(&withdraw_cap, amount);
        Account::deposit<TokenT>(member, token);

        let receive = borrow_global_mut<SalaryReceive<DAOT, TokenT>>(member);
        receive.last_receive_time = Timestamp::now_seconds();
    }

    /// Create proposal for specific admin account
    public(script) fun create_boss_elect_proposal<DAOT: store>(sender: signer, description: vector<u8>, action_delay: u64) {
        let witness = SalaryGovPlugin{};

        let cap = DAOSpace::acquire_proposal_cap<DAOT, SalaryGovPlugin>(&witness);
        let action = BossProposalAction<DAOT>{
            boss: Signer::address_of(&sender)
        };
        DAOSpace::create_proposal(&cap, &sender, action, description, action_delay);
    }

    public(script) fun execute_proposal<DAOT: store>(sender: signer, proposal_id: u64) {
        let witness = SalaryGovPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, SalaryGovPlugin>(&witness);
        let BossProposalAction<DAOT>{ boss } =
            DAOSpace::execute_proposal<DAOT, SalaryGovPlugin, BossProposalAction<DAOT>>(&proposal_cap, &sender, proposal_id);
        assert!(boss == Signer::address_of(&sender), Errors::invalid_state(ERR_PLUGIN_USER_NOT_PRIVILEGE));
        move_to(&sender, PluginBossCap<DAOT>{})
    }

    fun assert_boss<DAOT: store>(signer: &signer) {
        let user = Signer::address_of(signer);
        assert!(exists<PluginBossCap<DAOT>>(user), Errors::invalid_state(ERR_PLUGIN_USER_NOT_PRIVILEGE))
    }
}
}