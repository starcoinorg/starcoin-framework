address StarcoinFramework {
module SalaryGovPlugin {

    use StarcoinFramework::GenesisDao;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Account;
    use StarcoinFramework::Timestamp;

    const ERR_PLUGIN_RECEIVE_TIME_NOT_REACHED: u64 = 1001;

    struct SalaryGovPlugin has drop {}

    struct PluginCapability<phantom DaoT> has store, drop {}

    struct SalaryConfig<phantom DaoT, phantom TokenT> has store {
        period: u64,
    }

    struct SalaryReceive<phantom DaoT, phantom TokenT> has key {
        last_receive_time: u64,
    }

    public fun required_caps(): vector<GenesisDao::CapType> {
        let caps = Vector::singleton(GenesisDao::proposal_cap_type());
        Vector::push_back(&mut caps, GenesisDao::member_cap_type());
        Vector::push_back(&mut caps, GenesisDao::withdraw_token_cap_type());
        Vector::push_back(&mut caps, GenesisDao::storage_cap_type());
        caps
    }

    public fun init_plugin_config<DaoT: store, TokenT>(period: u64): PluginCapability<DaoT> {
        let witness = SalaryGovPlugin{};
        let cap = GenesisDao::acquire_storage_cap<DaoT, SalaryGovPlugin>(&witness);
        GenesisDao::save<DaoT, SalaryGovPlugin, SalaryConfig<DaoT, TokenT>>(&cap, SalaryConfig<DaoT, TokenT>{
            period
        });
        PluginCapability<DaoT>{}
    }

    public fun join_member<DaoT: store, TokenT: store>(signer: &signer, _cap: &PluginCapability<DaoT>) {
        let witness = SalaryGovPlugin{};
        let cap = GenesisDao::acquire_member_cap<DaoT, SalaryGovPlugin>(&witness);
        let member = Signer::address_of(signer);
        GenesisDao::join_member<DaoT, SalaryGovPlugin>(&cap, member, 0);

        move_to(signer, SalaryReceive<DaoT, TokenT>{
            last_receive_time: Timestamp::now_seconds(),
        });
    }

    public fun revoke_member<DaoT: store, TokenT: store>(member: address,
                                                         _plugin_cap: &PluginCapability<DaoT>)
    acquires SalaryReceive {
        let witness = SalaryGovPlugin{};
        let cap = GenesisDao::acquire_member_cap<DaoT, SalaryGovPlugin>(&witness);
        GenesisDao::revoke_member(&cap, member);

        receive_with_cap<DaoT, TokenT>(member,
            compute_salary_amount<DaoT, TokenT>(member));

        let SalaryReceive<DaoT, TokenT>{
            last_receive_time: _
        } = move_from<SalaryReceive<DaoT, TokenT>>(member);
    }

    public fun modify_member_sbt<DaoT: store, TokenT: store>(member: address,
                                                             amount: u128,
                                                             _cap: &PluginCapability<DaoT>)
    acquires SalaryReceive {
        receive_with_cap<DaoT, TokenT>(member, compute_salary_amount<DaoT, TokenT>(member));

        let witness = SalaryGovPlugin{};
        let cap = GenesisDao::acquire_member_cap<DaoT, SalaryGovPlugin>(&witness);
        GenesisDao::update_member_sbt(&cap, member, amount);
    }

    public fun receive<DaoT: store, TokenT: store>(member: address) acquires SalaryReceive {
        let amount = compute_salary_amount<DaoT, TokenT>(member);
        receive_with_cap<DaoT, TokenT>(member, amount);
    }

    fun compute_salary_amount<DaoT: store, TokenT>(member: address): u128 acquires SalaryReceive {
        let witness = SalaryGovPlugin{};
        let member_cap =
            GenesisDao::acquire_member_cap<DaoT, SalaryGovPlugin>(&witness);
        let sbt = GenesisDao::query_member_sbt<DaoT, SalaryGovPlugin>(&member_cap, member);

        let receive = borrow_global<SalaryReceive<DaoT, TokenT>>(member);

        let storage_cap =
            GenesisDao::acquire_storage_cap<DaoT, SalaryGovPlugin>(&witness);

        // TODO: Need implementing borrow function
        let SalaryConfig<DaoT, TokenT> {period} = GenesisDao::take<DaoT, SalaryGovPlugin, SalaryConfig<DaoT, TokenT>>(&storage_cap);
        GenesisDao::save(&storage_cap, SalaryConfig<DaoT, TokenT> {
            period,
        });

        //assert!(now_seconds() - receive.last_receive_time > config.period,
        //    Errors::invalid_state(ERR_PLUGIN_RECEIVE_TIME_NOT_REACHED))
        sbt * ((Timestamp::now_seconds() - receive.last_receive_time) as u128) / (period as u128)
    }


    /// Calling by member that receive salary
    fun receive_with_cap<DaoT: store, TokenT: store>(member: address, amount: u128)
    acquires SalaryReceive {
        let witness = SalaryGovPlugin{};

        let withdraw_cap =
            GenesisDao::acquire_withdraw_token_cap<DaoT, SalaryGovPlugin>(&witness);
        let token = GenesisDao::withdraw_token<DaoT, SalaryGovPlugin, TokenT>(&withdraw_cap, amount);
        Account::deposit<TokenT>(member, token);

        let receive = borrow_global_mut<SalaryReceive<DaoT, TokenT>>(member);
        receive.last_receive_time = Timestamp::now_seconds();
    }
}
}