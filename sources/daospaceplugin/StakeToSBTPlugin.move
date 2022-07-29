module StarcoinFramework::StakeToSBTPlugin {

    use StarcoinFramework::Token;
    use StarcoinFramework::Account;
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Option;
    use StarcoinFramework::InstallPluginProposalPlugin;
    use StarcoinFramework::IdentifierNFT;
    use StarcoinFramework::Debug;

    const ERR_PLUGIN_USER_IS_MEMBER: u64 = 1001;
    const ERR_PLUGIN_HAS_STAKED: u64 = 1002;
    const ERR_PLUGIN_NOT_STAKE: u64 = 1003;
    const ERR_PLUGIN_STILL_LOCKED: u64 = 1004;
    const ERR_PLUGIN_CONFIG_INIT_REPEATE: u64 = 1005;
    const ERR_PLUGIN_ITEM_CANT_FOUND: u64 = 1006;

    struct StakeToSBTPlugin has drop {}

    public fun required_caps(): vector<DAOSpace::CapType> {
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::member_cap_type());
        Vector::push_back(&mut caps, DAOSpace::modify_config_cap_type());
        caps
    }

    struct Stake<phantom DaoT, phantom TokenT> has key, store {
        id: u64,
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

    struct StakeList<phantom DaoT, phantom TokenT> has key, store {
        items: vector<Stake<DaoT, TokenT>>,
        next_id: u64
    }

    struct LockWeightConfig<phantom DaoT, phantom TokenT> has copy, store, drop {
        weight_vec: vector<LockWeight<DaoT, TokenT>>
    }

    struct LockWeight<phantom DaoT, phantom TokenT> has copy, drop, store {
        lock_time: u64,
        weight: u64,
    }

    struct AcceptTokenCap<phantom DaoT, phantom TokenT> has store {}

    /// Accept token with token type by given DAO root capability
    public fun accept_token_with_root_cap<DaoT: store, TokenT: store>(_cap: &DAOSpace::DaoRootCap<DaoT>) {
        accept_token(AcceptTokenCap<DaoT, TokenT> {})
    }

    /// Set sbt weight by given DAO root capability
    public fun set_sbt_weight_with_root_cap<DaoT: store,
                                            TokenT: store>(_cap: &DAOSpace::DaoRootCap<DaoT>, lock_time: u64, weight: u64) {
        set_sbt_weight<DaoT, TokenT>(lock_time, weight);
    }

    /// Accept token with token type
    public fun accept_token<DaoT: store, TokenT: store>(cap: AcceptTokenCap<DaoT, TokenT>) {
        let AcceptTokenCap<DaoT, TokenT> {} = cap;
        assert!(
            !DAOSpace::exists_custom_config<DaoT, LockWeightConfig<DaoT, TokenT>>(),
            Errors::invalid_state(ERR_PLUGIN_CONFIG_INIT_REPEATE)
        );

        let witness = StakeToSBTPlugin {};
        let modify_config_cap =
            DAOSpace::acquire_modify_config_cap<DaoT, StakeToSBTPlugin>(&witness);

        DAOSpace::set_custom_config<
            DaoT,
            StakeToSBTPlugin,
            LockWeightConfig<DaoT, TokenT>
        >(&mut modify_config_cap, LockWeightConfig<DaoT, TokenT> {
            weight_vec: Vector::empty<LockWeight<DaoT, TokenT>>()
        });
    }

    public fun stake<DaoT: store, TokenT: store>(sender: &signer,
                                                 token: Token::Token<TokenT>,
                                                 lock_time: u64): u64 acquires StakeList {
        let sender_addr = Signer::address_of(sender);
        // Increase SBT
        let witness = StakeToSBTPlugin {};
        let member_cap = DAOSpace::acquire_member_cap<DaoT, StakeToSBTPlugin>(&witness);

        if (!DAOSpace::is_member<DaoT>(sender_addr)) {
            IdentifierNFT::accept<DAOSpace::DaoMember<DaoT>, DAOSpace::DaoMemberBody<DaoT>>(sender);
            DAOSpace::join_member<DaoT, StakeToSBTPlugin>(&member_cap, sender_addr, 0);
        };

        if (!exists<StakeList<DaoT, TokenT>>(sender_addr)) {
            move_to(sender, StakeList<DaoT, TokenT> {
                items: Vector::empty(),
                next_id: 0
            });
        };

        let weight_opt = get_sbt_weight<DaoT, TokenT>(lock_time);
        let weight = if (Option::is_none(&weight_opt)) {
            1
        } else {
            Option::destroy_some(weight_opt)
        };

        let sbt_amount = compute_token_to_sbt(weight, &token);
        DAOSpace::increase_member_sbt(&member_cap, sender_addr, sbt_amount);

        let stake_list = borrow_global_mut<StakeList<DaoT, TokenT>>(sender_addr);
        let id = stake_list.next_id + 1;
        Debug::print(&id);
        Vector::push_back(
            &mut stake_list.items,
            Stake<DaoT, TokenT> {
                id,
                token,
                lock_time,
                stake_time: Timestamp::now_seconds(),
                weight,
                sbt_amount
            });
        stake_list.next_id = id;

        id
    }

    public fun query_stake<DaoT: store, TokenT: store>(member: address, id: u64)
    : (u64, u64, u64, u128, u128) acquires StakeList {
        let stake_list = borrow_global_mut<StakeList<DaoT, TokenT>>(member);
        let item_index = find_item(id, &stake_list.items);

        // Check item in item container
        assert!(Option::is_some(&item_index), Errors::invalid_state(ERR_PLUGIN_ITEM_CANT_FOUND));

        let stake =
            Vector::borrow(&mut stake_list.items, Option::destroy_some(item_index));
        (
            stake.stake_time,
            stake.lock_time,
            stake.weight,
            stake.sbt_amount,
            Token::value(&stake.token),
        )
    }

    /// Query stake count from stake list
    public fun query_stake_count<DaoT: store, TokenT: store>(member: address): u64 acquires StakeList {
        let stake_list = borrow_global<StakeList<DaoT, TokenT>>(member);
        Debug::print(&stake_list.items);
        Vector::length(&stake_list.items)
    }

    /// Unstake from staking
    public fun unstake_by_id<DaoT: store, TokenT: store>(member: address, id: u64) acquires StakeList {
        let stake_list = borrow_global_mut<StakeList<DaoT, TokenT>>(member);
        let item_index = find_item(id, &stake_list.items);

        // Check item in item container
        assert!(Option::is_some(&item_index), Errors::invalid_state(ERR_PLUGIN_ITEM_CANT_FOUND));

        let poped_item =
            Vector::remove(&mut stake_list.items, Option::destroy_some(item_index));

        Account::deposit<TokenT>(member, unstake_item(member, poped_item));
    }

    /// Unstake all staking items from member address,
    /// No care whether the user is member or not
    public fun unstake_all<DaoT: store, TokenT: store>(member: address) acquires StakeList {
        let stake_list = borrow_global_mut<StakeList<DaoT, TokenT>>(member);
        let len = Vector::length(&mut stake_list.items);

        let idx = 0;
        while (idx < len) {
            let item = Vector::remove(&mut stake_list.items, idx);
            Account::deposit(member, unstake_item<DaoT, TokenT>(member, item));
            idx = idx + 1;
        };
    }

    /// Unstake a item from a item object
    fun unstake_item<DaoT: store, TokenT: store>(member: address, item: Stake<DaoT, TokenT>): Token::Token<TokenT> {
        let Stake<DaoT, TokenT> {
            id: _,
            token,
            lock_time,
            stake_time,
            weight: _,
            sbt_amount,
        } = item;

        assert!((Timestamp::now_seconds() - stake_time) > lock_time, Errors::invalid_state(ERR_PLUGIN_STILL_LOCKED));

        // Decrease SBT by weight if the sender is a member
        if (DAOSpace::is_member<DaoT>(member)) {
            let witness = StakeToSBTPlugin {};
            let cap = DAOSpace::acquire_member_cap<DaoT, StakeToSBTPlugin>(&witness);
            DAOSpace::decrease_member_sbt(&cap, member, sbt_amount);
        };

        token
    }

    fun get_sbt_weight<DaoT: store, TokenT: store>(lock_time: u64): Option::Option<u64> {
        let config = DAOSpace::get_custom_config<DaoT, LockWeightConfig<DaoT, TokenT>>();
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
        let config = DAOSpace::get_custom_config<DaoT, LockWeightConfig<DaoT, TokenT>>();
        let c = &mut config.weight_vec;
        let len = Vector::length(c);
        let idx = 0;
        let new_el = true;
        while (idx < len) {
            let lock_weight = Vector::borrow_mut(c, idx);
            if (lock_weight.lock_time == lock_time) {
                lock_weight.weight = weight;
                new_el = false;
                break
            };
            idx = idx + 1;
        };

        if (new_el) {
            Vector::push_back(c, LockWeight<DaoT, TokenT> {
                lock_time,
                weight,
            });
        };

        let witness = StakeToSBTPlugin {};
        let modify_config_cap =
            DAOSpace::acquire_modify_config_cap<DaoT, StakeToSBTPlugin>(&witness);

        DAOSpace::set_custom_config<
            DaoT,
            StakeToSBTPlugin,
            LockWeightConfig<DaoT, TokenT>
        >(&mut modify_config_cap, LockWeightConfig<DaoT, TokenT> {
            weight_vec: *&config.weight_vec
        });
    }

    fun find_item<DaoT: store, TokenT: store>(id: u64, c: &vector<Stake<DaoT, TokenT>>): Option::Option<u64> {
        let len = Vector::length(c);
        let idx = 0;
        while (idx < len) {
            let item = Vector::borrow(c, idx);
            if (item.id == id) {
                return Option::some(idx)
            };
            idx = idx + 1;
        };
        Option::none()
    }

    fun compute_token_to_sbt<TokenT: store>(weight: u64, token: &Token::Token<TokenT>): u128 {
        (weight as u128) * Token::value<TokenT>(token) / Token::scaling_factor<TokenT>()
    }

    /// Create proposal that to specific a weight for a locktime
    public(script) fun create_weight_proposal<DaoT: store, TokenT: store>(sender: signer,
                                                                          lock_time: u64,
                                                                          weight: u64,
                                                                          action_delay: u64) {
        let witness = StakeToSBTPlugin {};

        let cap =
            DAOSpace::acquire_proposal_cap<DaoT, StakeToSBTPlugin>(&witness);
        DAOSpace::create_proposal(&cap, &sender, LockWeight<DaoT, TokenT> {
            lock_time,
            weight,
        }, action_delay);
    }

    public(script) fun execute_weight_proposal<DaoT: store, TokenT: store>(sender: signer,
                                                                           proposal_id: u64) {
        let witness = StakeToSBTPlugin {};
        let proposal_cap =
            DAOSpace::acquire_proposal_cap<DaoT, StakeToSBTPlugin>(&witness);

        let LockWeight<DaoT, TokenT> {
            lock_time,
            weight
        } = DAOSpace::execute_proposal<
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
            DAOSpace::acquire_proposal_cap<DaoT, StakeToSBTPlugin>(&witness);
        DAOSpace::create_proposal(&cap, &sender, AcceptTokenCap<DaoT, TokenT> {}, action_delay);
    }

    public(script) fun execute_token_accept_proposal<DaoT: store, TokenT: store>(sender: signer,
                                                                                 proposal_id: u64) {
        let witness = StakeToSBTPlugin {};
        let proposal_cap =
            DAOSpace::acquire_proposal_cap<DaoT, StakeToSBTPlugin>(&witness);

        let cap = DAOSpace::execute_proposal<
            DaoT,
            StakeToSBTPlugin,
            AcceptTokenCap<DaoT, TokenT>
        >(&proposal_cap, &sender, proposal_id);

        accept_token(cap);
    }

    public(script) fun install_plugin_proposal<DaoT: store>(sender: signer, action_delay: u64) {
        InstallPluginProposalPlugin::create_proposal<DaoT, StakeToSBTPlugin>(&sender, required_caps(), action_delay);
    }
}
