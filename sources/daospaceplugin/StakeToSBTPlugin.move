module StarcoinFramework::StakeToSBTPlugin {
    use StarcoinFramework::Errors;
    use StarcoinFramework::Option;
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::Token;
    use StarcoinFramework::Account;
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::InstallPluginProposalPlugin;
    use StarcoinFramework::IdentifierNFT;

    const ERR_PLUGIN_USER_IS_MEMBER: u64 = 1001;
    const ERR_PLUGIN_HAS_STAKED: u64 = 1002;
    const ERR_PLUGIN_NOT_STAKE: u64 = 1003;
    const ERR_PLUGIN_STILL_LOCKED: u64 = 1004;
    const ERR_PLUGIN_CONFIG_INIT_REPEATE: u64 = 1005;
    const ERR_PLUGIN_ITEM_CANT_FOUND: u64 = 1006;
    const ERR_PLUGIN_NO_MATCH_LOCKTIME: u64 = 1007;

    struct StakeToSBTPlugin has store, drop {}

    public fun initialize(_sender: &signer) {
        let witness = StakeToSBTPlugin {};

        DAOPluginMarketplace::register_plugin<StakeToSBTPlugin>(
            &witness,
            b"0x1::StakeToSBTPlugin",
            b"The plugin for stake to SBT",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();

        DAOPluginMarketplace::publish_plugin_version<StakeToSBTPlugin>(
            &witness,
            b"v0.1.0",
            *&implement_extpoints,
            *&depend_extpoints,
            b"inner-plugin://stake-to-sbt-plugin",
        );
    }

    struct Stake<phantom DAOT, phantom TokenT> has key, store {
        id: u64,
        token: Token::Token<TokenT>,
        // The timestamp when user stake
        stake_time: u64,
        // How long where the user locked
        lock_time: u64,
        // Which multiplier by the user stake
        weight: u64,
        //  The SBT amount that user swap in the token
        sbt_amount: u128,
    }

    struct StakeList<phantom DAOT, phantom TokenT> has key, store {
        items: vector<Stake<DAOT, TokenT>>,
        next_id: u64
    }

    struct LockWeightConfig<phantom DAOT, phantom TokenT> has copy, store, drop {
        weight_vec: vector<LockWeight<DAOT, TokenT>>
    }

    struct LockWeight<phantom DAOT, phantom TokenT> has copy, drop, store {
        lock_time: u64,
        weight: u64,
    }

    struct AcceptTokenCap<phantom DAOT, phantom TokenT> has store, drop {}

    /// Events
    ///
    struct SBTTokenAcceptedEvent has copy, drop, store {
        dao_id: u64,
        token_code: Token::TokenCode
    }

    struct SBTWeightChangedEvent has copy, drop, store {
        dao_id: u64,
        token_code: Token::TokenCode,
        lock_time: u64,
        weight: u64,
    }

    struct SBTStakeEvent has copy, drop, store {
        dao_id: u64,
        stake_id: u64,
        token_code: Token::TokenCode,
        amount: u128,
        lock_time: u64,
        weight: u64,
        sbt_amount: u128,
        member: address,
    }

    struct SBTUnstakeEvent has copy, drop, store {
        dao_id: u64,
        stake_id: u64,
        token_code: Token::TokenCode,
        amount: u128,
        lock_time: u64,
        weight: u64,
        sbt_amount: u128,
        member: address,
    }

    public fun required_caps(): vector<DAOSpace::CapType> {
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::member_cap_type());
        Vector::push_back(&mut caps, DAOSpace::modify_config_cap_type());
        Vector::push_back(&mut caps, DAOSpace::plugin_event_cap_type());
        caps
    }

    /// Accept token with token type by given DAO root capability
    public fun accept_token_with_root_cap<DAOT: store, TokenT: store>(_cap: &DAOSpace::DAORootCap<DAOT>) {
        install_event<DAOT>();
        accept_token(AcceptTokenCap<DAOT, TokenT> {});
    }

    public fun install_event<DAOT: store>() {
        let witness = StakeToSBTPlugin {};
        let plugin_event_cap =
            DAOSpace::acquire_plugin_event_cap<DAOT, StakeToSBTPlugin>(&witness);

        DAOSpace::init_plugin_event<DAOT, StakeToSBTPlugin, SBTTokenAcceptedEvent>(&plugin_event_cap);
        DAOSpace::init_plugin_event<DAOT, StakeToSBTPlugin, SBTWeightChangedEvent>(&plugin_event_cap);
        DAOSpace::init_plugin_event<DAOT, StakeToSBTPlugin, SBTStakeEvent>(&plugin_event_cap);
        DAOSpace::init_plugin_event<DAOT, StakeToSBTPlugin, SBTUnstakeEvent>(&plugin_event_cap);
    }

    /// Set sbt weight by given DAO root capability
    public fun set_sbt_weight_with_root_cap<DAOT: store, TokenT: store>(
        _cap: &DAOSpace::DAORootCap<DAOT>,
        lock_time: u64,
        weight: u64
    ) {
        set_sbt_weight<DAOT, TokenT>(lock_time, weight);
    }

    /// Accept token with token type
    public fun accept_token<DAOT: store, TokenT: store>(cap: AcceptTokenCap<DAOT, TokenT>) {
        let AcceptTokenCap<DAOT, TokenT> {} = cap;
        assert!(
            !DAOSpace::exists_custom_config<DAOT, LockWeightConfig<DAOT, TokenT>>(),
            Errors::invalid_state(ERR_PLUGIN_CONFIG_INIT_REPEATE)
        );

        let witness = StakeToSBTPlugin {};
        let modify_config_cap =
            DAOSpace::acquire_modify_config_cap<DAOT, StakeToSBTPlugin>(&witness);

        DAOSpace::set_custom_config<
            DAOT,
            StakeToSBTPlugin,
            LockWeightConfig<DAOT, TokenT>
        >(&mut modify_config_cap, LockWeightConfig<DAOT, TokenT> {
            weight_vec: Vector::empty<LockWeight<DAOT, TokenT>>()
        });

        let witness = StakeToSBTPlugin {};
        let plugin_event_cap =
            DAOSpace::acquire_plugin_event_cap<DAOT, StakeToSBTPlugin>(&witness);

        DAOSpace::emit_plugin_event<DAOT, StakeToSBTPlugin, SBTTokenAcceptedEvent>(
            &plugin_event_cap,
            SBTTokenAcceptedEvent {
                dao_id: DAOSpace::dao_id(DAOSpace::dao_address<DAOT>()),
                token_code: Token::token_code<TokenT>(),
            }
        );
    }

    public fun stake<DAOT: store, TokenT: store>(
        sender: &signer,
        token: Token::Token<TokenT>,
        lock_time: u64
    ): u64 acquires StakeList {
        let sender_addr = Signer::address_of(sender);
        // Increase SBT
        let witness = StakeToSBTPlugin {};
        let member_cap =
            DAOSpace::acquire_member_cap<DAOT, StakeToSBTPlugin>(&witness);

        if (!DAOSpace::is_member<DAOT>(sender_addr) ) {
            IdentifierNFT::accept<DAOSpace::DAOMember<DAOT>, DAOSpace::DAOMemberBody<DAOT>>(sender);
            DAOSpace::member_offer<DAOT, StakeToSBTPlugin>(
                &member_cap,
                sender_addr,
                Option::none<vector<u8>>(),
                Option::none<vector<u8>>(),
                0
            );
            DAOSpace::join_member<DAOT>(sender);
        };

        if (!exists<StakeList<DAOT, TokenT>>(sender_addr)) {
            move_to(sender, StakeList<DAOT, TokenT> {
                items: Vector::empty(),
                next_id: 0
            });
        };

        let weight_opt = get_sbt_weight<DAOT, TokenT>(lock_time);
        assert!(Option::is_some(&weight_opt), Errors::invalid_state(ERR_PLUGIN_NO_MATCH_LOCKTIME));

        let weight = Option::destroy_some(weight_opt);
        let sbt_amount = compute_token_to_sbt(weight, &token);
        DAOSpace::increase_member_sbt(&member_cap, sender_addr, sbt_amount);

        let stake_list = borrow_global_mut<StakeList<DAOT, TokenT>>(sender_addr);
        let id = stake_list.next_id + 1;
        Vector::push_back(
            &mut stake_list.items,
            Stake<DAOT, TokenT> {
                id,
                token,
                lock_time,
                stake_time: Timestamp::now_seconds(),
                weight,
                sbt_amount
            });
        stake_list.next_id = id;

        let witness = StakeToSBTPlugin {};
        let plugin_event_cap =
            DAOSpace::acquire_plugin_event_cap<DAOT, StakeToSBTPlugin>(&witness);
        DAOSpace::emit_plugin_event<DAOT, StakeToSBTPlugin, SBTStakeEvent>(
            &plugin_event_cap,
            SBTStakeEvent {
                dao_id: DAOSpace::dao_id(DAOSpace::dao_address<DAOT>()),
                stake_id: id,
                token_code: Token::token_code<TokenT>(),
                amount: sbt_amount,
                lock_time,
                weight,
                sbt_amount,
                member: sender_addr,
            }
        );
        id
    }

    public fun query_stake<DAOT: store, TokenT: store>(member: address, id: u64)
    : (u64, u64, u64, u128, u128) acquires StakeList {
        assert!(exists<StakeList<DAOT, TokenT>>(member), Errors::not_published(ERR_PLUGIN_NOT_STAKE));
        let stake_list = borrow_global_mut<StakeList<DAOT, TokenT>>(member);
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
    public fun query_stake_count<DAOT: store, TokenT: store>(member: address): u64 acquires StakeList {
        assert!(exists<StakeList<DAOT, TokenT>>(member), Errors::not_published(ERR_PLUGIN_NOT_STAKE));
        let stake_list = borrow_global<StakeList<DAOT, TokenT>>(member);
        Vector::length(&stake_list.items)
    }

    /// Unstake from staking
    public fun unstake_by_id<DAOT: store, TokenT: store>(member: address, id: u64) acquires StakeList {
        assert!(exists<StakeList<DAOT, TokenT>>(member), Errors::not_published(ERR_PLUGIN_NOT_STAKE));
        let stake_list = borrow_global_mut<StakeList<DAOT, TokenT>>(member);
        let item_index = find_item(id, &stake_list.items);

        // Check item in item container
        assert!(Option::is_some(&item_index), Errors::invalid_state(ERR_PLUGIN_ITEM_CANT_FOUND));

        let poped_item =
            Vector::remove(&mut stake_list.items, Option::destroy_some(item_index));

        let amount = Token::value<TokenT>(&poped_item.token);
        let lock_time = poped_item.lock_time;
        let weight = poped_item.weight;
        let sbt_amount = poped_item.sbt_amount;

        Account::deposit<TokenT>(member, unstake_item(member, poped_item));

        let witness = StakeToSBTPlugin {};
        let plugin_event_cap =
            DAOSpace::acquire_plugin_event_cap<DAOT, StakeToSBTPlugin>(&witness);
        DAOSpace::emit_plugin_event<DAOT, StakeToSBTPlugin, SBTUnstakeEvent>(
            &plugin_event_cap,
            SBTUnstakeEvent {
                dao_id: DAOSpace::dao_id(DAOSpace::dao_address<DAOT>()),
                stake_id: id,
                token_code: Token::token_code<TokenT>(),
                amount,
                lock_time,
                weight,
                sbt_amount,
                member,
            }
        );
    }

    /// Unstake all staking items from member address,
    /// No care whether the user is member or not
    public fun unstake_all<DAOT: store, TokenT: store>(member: address) acquires StakeList {
        assert!(exists<StakeList<DAOT, TokenT>>(member), Errors::not_published(ERR_PLUGIN_NOT_STAKE));
        let stake_list = borrow_global_mut<StakeList<DAOT, TokenT>>(member);
        let len = Vector::length(&mut stake_list.items);

        let idx = 0;
        while (idx < len) {
            let item = Vector::remove(&mut stake_list.items, idx);
            Account::deposit(member, unstake_item<DAOT, TokenT>(member, item));
            idx = idx + 1;
        };
    }

    /// Unstake a item from a item object
    fun unstake_item<DAOT: store, TokenT: store>(
        member: address,
        item: Stake<DAOT, TokenT>
    ): Token::Token<TokenT> {
        let Stake<DAOT, TokenT> {
            id: _,
            token,
            lock_time,
            stake_time,
            weight: _,
            sbt_amount,
        } = item;

        assert!((Timestamp::now_seconds() - stake_time) > lock_time, Errors::invalid_state(ERR_PLUGIN_STILL_LOCKED));

        // Deduct the corresponding SBT amount if the signer account is a DAO member while unstake
        if (DAOSpace::is_member<DAOT>(member)) {
            let witness = StakeToSBTPlugin {};
            let member_cap =
                DAOSpace::acquire_member_cap<DAOT, StakeToSBTPlugin>(&witness);

            // Decrease the SBT using `sbt_amount` which from unwrapped Stake data,
            // rather than the value that calculate a SBT amount from lock time and weight,
            // because of the `weight` could change at any time
            DAOSpace::decrease_member_sbt(&member_cap, member, sbt_amount);
        };

        token
    }

    fun get_sbt_weight<DAOT: store, TokenT: store>(lock_time: u64): Option::Option<u64> {
        let config =
            DAOSpace::get_custom_config<DAOT, LockWeightConfig<DAOT, TokenT>>();
        let c =
            &mut config.weight_vec;
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

    fun set_sbt_weight<DAOT: store, TokenT: store>(lock_time: u64, weight: u64) {
        let config =
            DAOSpace::get_custom_config<DAOT, LockWeightConfig<DAOT, TokenT>>();
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
            Vector::push_back(c, LockWeight<DAOT, TokenT> {
                lock_time,
                weight,
            });
        };

        let witness = StakeToSBTPlugin {};
        let modify_config_cap =
            DAOSpace::acquire_modify_config_cap<DAOT, StakeToSBTPlugin>(&witness);

        DAOSpace::set_custom_config<
            DAOT,
            StakeToSBTPlugin,
            LockWeightConfig<DAOT, TokenT>
        >(&mut modify_config_cap, LockWeightConfig<DAOT, TokenT> {
            weight_vec: *&config.weight_vec
        });
    }

    fun find_item<DAOT: store, TokenT: store>(
        id: u64,
        c: &vector<Stake<DAOT, TokenT>>
    ): Option::Option<u64> {
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
    public fun create_weight_proposal<DAOT: store, TokenT: store>(
        sender: &signer,
        description: vector<u8>,
        lock_time: u64,
        weight: u64,
        action_delay: u64
    ) {
        let witness = StakeToSBTPlugin {};

        let cap =
            DAOSpace::acquire_proposal_cap<DAOT, StakeToSBTPlugin>(&witness);
        DAOSpace::create_proposal(&cap, sender, LockWeight<DAOT, TokenT> {
            lock_time,
            weight,
        },
            description,
            action_delay);
    }

    public(script) fun create_weight_proposal_entry<DAOT: store, TokenT: store>(
        sender: signer,
        description: vector<u8>,
        lock_time: u64,
        weight: u64,
        action_delay: u64
    ) {
        create_weight_proposal<DAOT, TokenT>(&sender, description, lock_time, weight, action_delay);
    }

    public fun execute_weight_proposal<DAOT: store, TokenT: store>(
        sender: &signer,
        proposal_id: u64
    ) {
        let witness = StakeToSBTPlugin {};
        let proposal_cap =
            DAOSpace::acquire_proposal_cap<DAOT, StakeToSBTPlugin>(&witness);

        let LockWeight<DAOT, TokenT> {
            lock_time,
            weight
        } = DAOSpace::execute_proposal<
            DAOT,
            StakeToSBTPlugin,
            LockWeight<DAOT, TokenT>
        >(&proposal_cap, sender, proposal_id);

        set_sbt_weight<DAOT, TokenT>(lock_time, weight);
    }

    public(script) fun execute_weight_proposal_entry<DAOT: store, TokenT: store>(
        sender: signer,
        proposal_id: u64
    ) {
        execute_weight_proposal<DAOT, TokenT>(&sender, proposal_id);
    }

    /// Create proposal that to accept a token type, which allow user to convert amount of token to SBT
    public fun create_token_accept_proposal<DAOT: store, TokenT: store>(
        sender: &signer,
        description: vector<u8>,
        action_delay: u64
    ) {
        let witness = StakeToSBTPlugin {};

        let cap =
            DAOSpace::acquire_proposal_cap<DAOT, StakeToSBTPlugin>(&witness);
        DAOSpace::create_proposal(
            &cap,
            sender,
            AcceptTokenCap<DAOT, TokenT> {},
            description,
            action_delay
        );
    }

    public(script) fun create_token_accept_proposal_entry<DAOT: store, TokenT: store>(
        sender: signer,
        description: vector<u8>,
        action_delay: u64
    ) {
        create_token_accept_proposal<DAOT, TokenT>(&sender, description, action_delay);
    }

    public fun execute_token_accept_proposal<DAOT: store, TokenT: store>(
        sender: &signer,
        proposal_id: u64
    ) {
        let witness = StakeToSBTPlugin {};
        let proposal_cap =
            DAOSpace::acquire_proposal_cap<DAOT, StakeToSBTPlugin>(&witness);

        let cap = DAOSpace::execute_proposal<
            DAOT,
            StakeToSBTPlugin,
            AcceptTokenCap<DAOT, TokenT>
        >(&proposal_cap, sender, proposal_id);

        accept_token(cap);
    }


    public(script) fun execute_token_accept_proposal_entry<DAOT: store, TokenT: store>(
        sender: signer,
        proposal_id: u64
    ) {
        execute_token_accept_proposal<DAOT, TokenT>(&sender, proposal_id);
    }

    public fun install_plugin_proposal<DAOT: store>(
        sender: &signer,
        description: vector<u8>,
        action_delay: u64
    ) {
        InstallPluginProposalPlugin::create_proposal<DAOT, StakeToSBTPlugin>(
            sender,
            required_caps(),
            description,
            action_delay
        );
    }

    public(script) fun install_plugin_proposal_entry<DAOT: store>(
        sender: signer,
        description: vector<u8>,
        action_delay: u64
    ) {
        install_plugin_proposal<DAOT>(&sender, description, action_delay);
    }

    /// Called by script
    public(script) fun stake_entry<DAOT: store, TokenT: store>(
        sender: signer,
        amount: u128,
        lock_time: u64
    ) acquires StakeList {
        let token = Account::withdraw<TokenT>(&sender, amount);
        stake<DAOT, TokenT>(&sender, token, lock_time);
    }

    /// Called by script
    public(script) fun unstake_item_entry<DAOT: store, TokenT: store>(
        member: address,
        id: u64
    ) acquires StakeList {
        unstake_by_id<DAOT, TokenT>(member, id);
    }
}
