module StarcoinFramework::StakeToSBTPlugin {

    use StarcoinFramework::Token;
    use StarcoinFramework::GenesisDao;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Option;

    const ERR_PLUGIN_USER_IS_MEMBER: u64 = 1001;
    const ERR_PLUGIN_HAS_STAKED: u64 = 1002;
    const ERR_PLUGIN_NOT_STAKE: u64 = 1003;
    const ERR_PLUGIN_STILL_LOCKED: u64 = 1004;
    const ERR_PLUGIN_CONFIG_INIT_REPEATE: u64 = 1005;

    struct StakeToSBTPlugin has drop {}

    public fun required_caps(): vector<GenesisDao::CapType> {
        let caps = Vector::singleton(GenesisDao::proposal_cap_type());
        Vector::push_back(&mut caps, GenesisDao::member_cap_type());
        Vector::push_back(&mut caps, GenesisDao::modify_config_cap_type());
        caps
    }

    struct Stake<phantom DaoT, phantom TokenT> has key {
        token: Token::Token<TokenT>,
        stake_time: u64,
        // The timestamp when user stake
        lock_time: u64,
        // How long where the user locked
        weight: u64,
        // Which multiplier by the user stake
        sbt_amount: u128,
        //  The SBT amount that user swap in the token
    }

    struct LockWeightConfig<phantom DaoT, phantom TokenT> has copy, store, drop {
        weight_vec: vector<LockWeight<DaoT, TokenT>>
    }

    struct LockWeight<phantom DaoT, phantom TokenT> has copy, drop, store {
        lock_time: u64,
        weight: u64,
    }

    struct AcceptTokenCap<phantom DaoT, phantom TokenT> has store {}

    /// Initialize config
    public fun init_config<DaoT: store, TokenT: store>(cap: AcceptTokenCap<DaoT, TokenT>) {
        let AcceptTokenCap<DaoT, TokenT> {} = cap;

        assert!(
            !GenesisDao::exists_custom_config<DaoT, LockWeightConfig<DaoT, TokenT>>(),
            Errors::invalid_state(ERR_PLUGIN_CONFIG_INIT_REPEATE)
        );

        let witness = StakeToSBTPlugin {};
        let modify_config_cap =
            GenesisDao::acquire_modify_config_cap<DaoT, StakeToSBTPlugin>(&witness);

        GenesisDao::set_custom_config<
            DaoT,
            StakeToSBTPlugin,
            LockWeightConfig<DaoT, TokenT>
        >(&mut modify_config_cap, LockWeightConfig<DaoT, TokenT> {
            weight_vec: Vector::empty<LockWeight<DaoT, TokenT>>()
        });
    }

    public fun stake<DaoT: store, TokenT: store>(sender: &signer,
                                                 token: Token::Token<TokenT>,
                                                 lock_time: u64) {
        let sender_addr = Signer::address_of(sender);
        assert!(GenesisDao::is_member<DaoT>(sender_addr), Errors::invalid_state(ERR_PLUGIN_USER_IS_MEMBER));
        assert!(exists<Stake<DaoT, TokenT>>(sender_addr), Errors::invalid_state(ERR_PLUGIN_HAS_STAKED));

        // Increase SBT
        let witness = StakeToSBTPlugin {};
        let cap = GenesisDao::acquire_member_cap<DaoT, StakeToSBTPlugin>(&witness);
        let weight_opt = get_sbt_weight<DaoT, TokenT>(lock_time);
        let weight = if (Option::is_none(&weight_opt)) {
            1
        } else {
            Option::destroy_some(weight_opt)
        };

        let sbt_amount = (weight as u128) * Token::value<TokenT>(&token);
        GenesisDao::increase_member_sbt(&cap, sender_addr, sbt_amount);

        move_to(sender, Stake<DaoT, TokenT> {
            token,
            lock_time,
            stake_time: Timestamp::now_seconds(),
            weight,
            sbt_amount
        });
    }

    /// Unstake from staking
    public fun unstake<DaoT: store, TokenT: store>(member: address): Token::Token<TokenT> acquires Stake {
        assert!(exists<Stake<DaoT, TokenT>>(member), Errors::invalid_state(ERR_PLUGIN_NOT_STAKE));
        let Stake<DaoT, TokenT> {
            token,
            lock_time,
            stake_time,
            weight: _,
            sbt_amount,
        } = move_from<Stake<DaoT, TokenT>>(member);

        assert!((Timestamp::now_seconds() - stake_time) > lock_time, Errors::invalid_state(ERR_PLUGIN_STILL_LOCKED));

        // Decrease SBT by weight
        let witness = StakeToSBTPlugin {};
        let cap = GenesisDao::acquire_member_cap<DaoT, StakeToSBTPlugin>(&witness);
        GenesisDao::decrease_member_sbt(&cap, member, sbt_amount);

        token
    }

    fun get_sbt_weight<DaoT: store, TokenT: store>(lock_time: u64): Option::Option<u64> {
        let config = GenesisDao::get_custom_config<DaoT, LockWeightConfig<DaoT, TokenT>>();
        let c = &mut config.weight_vec;
        let len = Vector::length(c);
        let idx = 0;
        while (idx < len) {
            let e = Vector::borrow(c, idx);
            if (e.lock_time == lock_time) {
                return Option::some(e.weight)
            };
            idx = idx + 1;
        };

        Option::none<u64>()
    }

    fun set_sbt_weight<DaoT: store, TokenT: store>(lock_time: u64, weight: u64) {
        let config = GenesisDao::get_custom_config<DaoT, LockWeightConfig<DaoT, TokenT>>();
        let c = &mut config.weight_vec;
        let len = Vector::length(c);
        let idx = 0;
        while (idx < len) {
            let borrowed_c = Vector::borrow_mut(c, idx);
            if (borrowed_c.lock_time == lock_time) {
                borrowed_c.weight = weight;
                return
            };
            idx = idx + 1;
        };

        let witness = StakeToSBTPlugin {};
        let modify_config_cap =
            GenesisDao::acquire_modify_config_cap<DaoT, StakeToSBTPlugin>(&witness);
        GenesisDao::set_custom_config<
            DaoT,
            StakeToSBTPlugin,
            LockWeightConfig<DaoT, TokenT>
        >(&mut modify_config_cap, LockWeightConfig<DaoT, TokenT> {
            weight_vec: *&config.weight_vec
        });
    }

    /// Create proposal that to specific a weight for a locktime
    public(script) fun create_weight_proposal<DaoT: store, TokenT: store>(sender: signer,
                                                                          lock_time: u64,
                                                                          weight: u64,
                                                                          action_delay: u64) {
        let witness = StakeToSBTPlugin {};

        let cap =
            GenesisDao::acquire_proposal_cap<DaoT, StakeToSBTPlugin>(&witness);
        GenesisDao::create_proposal(&cap, &sender, LockWeight<DaoT, TokenT> {
            lock_time,
            weight,
        }, action_delay);
    }

    public(script) fun execute_weight_proposal<DaoT: store, TokenT: store>(sender: signer,
                                                                           proposal_id: u64) {
        let witness = StakeToSBTPlugin {};
        let proposal_cap =
            GenesisDao::acquire_proposal_cap<DaoT, StakeToSBTPlugin>(&witness);

        let LockWeight<DaoT, TokenT> {
            lock_time,
            weight
        } = GenesisDao::execute_proposal<
            DaoT,
            StakeToSBTPlugin,
            LockWeight<DaoT, TokenT>
        >(&proposal_cap, &sender, proposal_id);

        set_sbt_weight<DaoT, TokenT>(lock_time, weight);
    }

    /// Create proposal that to accept a token type, which allow user to convert amount of token to SBT
    public(script) fun create_token_accept_proposal<DaoT: store, TokenT: store>(sender: signer,
                                                                                action_delay: u64) {
        let witness = StakeToSBTPlugin {};

        let cap =
            GenesisDao::acquire_proposal_cap<DaoT, StakeToSBTPlugin>(&witness);
        GenesisDao::create_proposal(&cap, &sender, AcceptTokenCap<DaoT, TokenT> {}, action_delay);
    }

    public(script) fun execute_token_accept_proposal<DaoT: store, TokenT: store>(sender: signer,
                                                                                 proposal_id: u64) {
        let witness = StakeToSBTPlugin {};
        let proposal_cap =
            GenesisDao::acquire_proposal_cap<DaoT, StakeToSBTPlugin>(&witness);

        let cap = GenesisDao::execute_proposal<
            DaoT,
            StakeToSBTPlugin,
            AcceptTokenCap<DaoT, TokenT>
        >(&proposal_cap, &sender, proposal_id);

        init_config(cap);
    }
}
