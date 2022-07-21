address StarcoinFramework {
module SalaryGovPlugin {

    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Account;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Errors;

    const ERR_PLUGIN_USER_NOT_MEMBER: u64 = 1002;
    const ERR_PLUGIN_USER_IS_MEMBER: u64 = 1003;
    const ERR_PLUGIN_USER_NOT_PRIVILEGE: u64 = 1004;

    struct SalaryGovPlugin has drop {}

    struct PluginBossCap<phantom DaoT> has key, store, drop {}

    struct SalaryConfig<phantom DaoT, phantom TokenT> has store {
        period: u64,
    }

    struct SalaryReceive<phantom DaoT, phantom TokenT> has key {
        last_receive_time: u64,
    }

    struct BossProposalAction<phantom DaoT> has key, store {
        boss: address,
    }

    public fun required_caps(): vector<DAOSpace::CapType> {
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::member_cap_type());
        Vector::push_back(&mut caps, DAOSpace::withdraw_token_cap_type());
        Vector::push_back(&mut caps, DAOSpace::storage_cap_type());
        caps
    }

    public(script) fun set_salary_period<DaoT: store, TokenT>(sender: signer, period: u64) {
        assert_boss<DaoT>(&sender);

        let witness = SalaryGovPlugin{};
        let cap = DAOSpace::acquire_storage_cap<DaoT, SalaryGovPlugin>(&witness);
        let SalaryConfig<DaoT, TokenT>{
            period: _
        } = DAOSpace::take<DaoT, SalaryGovPlugin, SalaryConfig<DaoT, TokenT>>(&cap);

        DAOSpace::save(&cap, SalaryConfig<DaoT, TokenT>{
            period
        });
    }

    public(script) fun join<DaoT: store, TokenT: store>(sender: signer) {
        let member = Signer::address_of(&sender);
        assert!(!DAOSpace::is_member<DaoT>(member), Errors::invalid_state(ERR_PLUGIN_USER_IS_MEMBER));

        let witness = SalaryGovPlugin{};
        let cap = DAOSpace::acquire_member_cap<DaoT, SalaryGovPlugin>(&witness);
        DAOSpace::join_member<DaoT, SalaryGovPlugin>(&cap, member, 0);

        move_to(&sender, SalaryReceive<DaoT, TokenT>{
            last_receive_time: Timestamp::now_seconds(),
        });
    }

    public(script) fun quit<DaoT: store, TokenT: store>(sender: signer)
    acquires SalaryReceive {
        let member = Signer::address_of(&sender);
        assert!(DAOSpace::is_member<DaoT>(member), Errors::invalid_state(ERR_PLUGIN_USER_NOT_MEMBER));

        let witness = SalaryGovPlugin{};
        let cap = DAOSpace::acquire_member_cap<DaoT, SalaryGovPlugin>(&witness);
        DAOSpace::revoke_member(&cap, member);

        receive_with_amount<DaoT, TokenT>(member,
            compute_salary_amount<DaoT, TokenT>(member));

        let SalaryReceive<DaoT, TokenT>{
            last_receive_time: _
        } = move_from<SalaryReceive<DaoT, TokenT>>(member);
    }

    public(script) fun add_sbt<DaoT: store, TokenT: store>(sender: signer, member: address, amount: u128)
    acquires SalaryReceive {
        assert_boss<DaoT>(&sender);
        assert!(DAOSpace::is_member<DaoT>(member), Errors::invalid_state(ERR_PLUGIN_USER_NOT_MEMBER));

        receive_with_amount<DaoT, TokenT>(member, compute_salary_amount<DaoT, TokenT>(member));

        let witness = SalaryGovPlugin{};
        let cap = DAOSpace::acquire_member_cap<DaoT, SalaryGovPlugin>(&witness);
        DAOSpace::increase_member_sbt(&cap, member, amount);
    }

    public(script) fun remove_sbt<DaoT: store, TokenT: store>(sender: signer, member: address, amount: u128)
    acquires SalaryReceive {
        assert_boss<DaoT>(&sender);
        assert!(DAOSpace::is_member<DaoT>(member), Errors::invalid_state(ERR_PLUGIN_USER_NOT_MEMBER));

        receive_with_amount<DaoT, TokenT>(member, compute_salary_amount<DaoT, TokenT>(member));

        let witness = SalaryGovPlugin{};
        let cap = DAOSpace::acquire_member_cap<DaoT, SalaryGovPlugin>(&witness);
        DAOSpace::increase_member_sbt(&cap, member, amount);
    }

    public(script) fun receive<DaoT: store, TokenT: store>(member: address) acquires SalaryReceive {
        assert!(DAOSpace::is_member<DaoT>(member), Errors::invalid_state(ERR_PLUGIN_USER_NOT_MEMBER));

        let amount = compute_salary_amount<DaoT, TokenT>(member);
        //assert!(now_seconds() - receive.last_receive_time > config.period,
        //    Errors::invalid_state(ERR_PLUGIN_RECEIVE_TIME_NOT_REACHED))
        receive_with_amount<DaoT, TokenT>(member, amount);
    }

    fun compute_salary_amount<DaoT: store, TokenT>(member: address): u128 acquires SalaryReceive {
        let sbt_amount = DAOSpace::query_sbt<DaoT, SalaryGovPlugin>(member);
        let receive = borrow_global<SalaryReceive<DaoT, TokenT>>(member);

        let witness = SalaryGovPlugin{};
        let storage_cap =
            DAOSpace::acquire_storage_cap<DaoT, SalaryGovPlugin>(&witness);

        // TODO: Need implementing borrow function
        let SalaryConfig<DaoT, TokenT>{
            period
        } = DAOSpace::take<DaoT, SalaryGovPlugin, SalaryConfig<DaoT, TokenT>>(&storage_cap);
        DAOSpace::save(&storage_cap, SalaryConfig<DaoT, TokenT>{
            period,
        });

        sbt_amount * ((Timestamp::now_seconds() - receive.last_receive_time) as u128) / (period as u128)
    }

    /// Calling by member that receive salary
    fun receive_with_amount<DaoT: store, TokenT: store>(member: address, amount: u128)
    acquires SalaryReceive {
        let witness = SalaryGovPlugin{};

        let withdraw_cap =
            DAOSpace::acquire_withdraw_token_cap<DaoT, SalaryGovPlugin>(&witness);
        let token = DAOSpace::withdraw_token<DaoT, SalaryGovPlugin, TokenT>(&withdraw_cap, amount);
        Account::deposit<TokenT>(member, token);

        let receive = borrow_global_mut<SalaryReceive<DaoT, TokenT>>(member);
        receive.last_receive_time = Timestamp::now_seconds();
    }

    /// Create proposal for specific admin account
    public(script) fun create_boss_elect_proposal<DaoT: store>(sender: signer, action_delay: u64) {
        let witness = SalaryGovPlugin{};

        let cap = DAOSpace::acquire_proposal_cap<DaoT, SalaryGovPlugin>(&witness);
        let action = BossProposalAction<DaoT>{
            boss: Signer::address_of(&sender)
        };
        DAOSpace::create_proposal(&cap, &sender, action, action_delay);
    }

    public(script) fun execute_proposal<DaoT: store>(sender: signer, proposal_id: u64) {
        let witness = SalaryGovPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DaoT, SalaryGovPlugin>(&witness);
        let BossProposalAction<DaoT>{ boss } =
            DAOSpace::execute_proposal<DaoT, SalaryGovPlugin, BossProposalAction<DaoT>>(&proposal_cap, &sender, proposal_id);
        assert!(boss == Signer::address_of(&sender), Errors::invalid_state(ERR_PLUGIN_USER_NOT_PRIVILEGE));
        move_to(&sender, PluginBossCap<DaoT>{})
    }

    fun assert_boss<DaoT: store>(signer: &signer) {
        let user = Signer::address_of(signer);
        assert!(exists<PluginBossCap<DaoT>>(user), Errors::invalid_state(ERR_PLUGIN_USER_NOT_PRIVILEGE))
    }
}
}