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

    struct SalaryGovPlugin has store, drop{}

    struct PluginBossCap<phantom DAOT> has key, store, drop {}

    struct SalaryConfig<phantom DAOT, phantom TokenT> has store {
        period: u64,
    }

    struct SalaryReceive<phantom DAOT, phantom TokenT> has key {
        last_receive_time: u64,
    }

    struct BossProposalAction<phantom DAOT> has key, store {
        boss: address,
    }

    public fun required_caps(): vector<DAOSpace::CapType> {
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::member_cap_type());
        Vector::push_back(&mut caps, DAOSpace::withdraw_token_cap_type());
        Vector::push_back(&mut caps, DAOSpace::storage_cap_type());
        caps
    }

    public(script) fun set_salary_period<DAOT: store, TokenT>(sender: signer, period: u64) {
        assert_boss<DAOT>(&sender);

        let witness = SalaryGovPlugin{};
        let cap = DAOSpace::acquire_storage_cap<DAOT, SalaryGovPlugin>(&witness);
        let SalaryConfig<DAOT, TokenT>{
            period: _
        } = DAOSpace::take<DAOT, SalaryGovPlugin, SalaryConfig<DAOT, TokenT>>(&cap);

        DAOSpace::save(&cap, SalaryConfig<DAOT, TokenT>{
            period
        });
    }

    public(script) fun join<DAOT: store, TokenT: store>(sender: signer) {
        let member = Signer::address_of(&sender);
        assert!(!DAOSpace::is_member<DAOT>(member), Errors::invalid_state(ERR_PLUGIN_USER_IS_MEMBER));

        let witness = SalaryGovPlugin{};
        let cap = DAOSpace::acquire_member_cap<DAOT, SalaryGovPlugin>(&witness);
        DAOSpace::join_member<DAOT, SalaryGovPlugin>(&cap, member, 0);

        move_to(&sender, SalaryReceive<DAOT, TokenT>{
            last_receive_time: Timestamp::now_seconds(),
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
            last_receive_time: _
        } = move_from<SalaryReceive<DAOT, TokenT>>(member);
    }

    public(script) fun add_sbt<DAOT: store, TokenT: store>(sender: signer, member: address, amount: u128)
    acquires SalaryReceive {
        assert_boss<DAOT>(&sender);
        assert!(DAOSpace::is_member<DAOT>(member), Errors::invalid_state(ERR_PLUGIN_USER_NOT_MEMBER));

        receive_with_amount<DAOT, TokenT>(member, compute_salary_amount<DAOT, TokenT>(member));

        let witness = SalaryGovPlugin{};
        let cap = DAOSpace::acquire_member_cap<DAOT, SalaryGovPlugin>(&witness);
        DAOSpace::increase_member_sbt(&cap, member, amount);
    }

    public(script) fun remove_sbt<DAOT: store, TokenT: store>(sender: signer, member: address, amount: u128)
    acquires SalaryReceive {
        assert_boss<DAOT>(&sender);
        assert!(DAOSpace::is_member<DAOT>(member), Errors::invalid_state(ERR_PLUGIN_USER_NOT_MEMBER));

        receive_with_amount<DAOT, TokenT>(member, compute_salary_amount<DAOT, TokenT>(member));

        let witness = SalaryGovPlugin{};
        let cap = DAOSpace::acquire_member_cap<DAOT, SalaryGovPlugin>(&witness);
        DAOSpace::increase_member_sbt(&cap, member, amount);
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

        let witness = SalaryGovPlugin{};
        let storage_cap =
            DAOSpace::acquire_storage_cap<DAOT, SalaryGovPlugin>(&witness);

        // TODO: Need implementing borrow function
        let SalaryConfig<DAOT, TokenT>{
            period
        } = DAOSpace::take<DAOT, SalaryGovPlugin, SalaryConfig<DAOT, TokenT>>(&storage_cap);
        DAOSpace::save(&storage_cap, SalaryConfig<DAOT, TokenT>{
            period,
        });

        sbt_amount * ((Timestamp::now_seconds() - receive.last_receive_time) as u128) / (period as u128)
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