address StarcoinFramework {
module TokenToSbtPlugin {

    use StarcoinFramework::Token;
    use StarcoinFramework::Vector;
    use StarcoinFramework::GenesisDao;
    use StarcoinFramework::Errors;
    use StarcoinFramework::ConfigProposalPlugin::ConfigProposalPlugin;
    use StarcoinFramework::ConfigProposalPlugin;

    const ERR_NOT_MEMBER: u64 = 1001;
    const ERR_TOKEN_HAS_GRANTED: u64 = 1002;

    struct TokenToSbtPlugin has drop {}

    struct GrantToken<phantom DaoT, phantom TokenT> has store {
        token: Token::Token<TokenT>
    }

    struct ConvertConfig<phantom DaoT, phantom TokenT> has copy, drop, store {
        weight: u128,
    }

    struct GrantTokenAction<phantom DaoT, phantom TokenT> has store {}

    public fun required_caps(): vector<GenesisDao::CapType> {
        let caps = Vector::singleton(GenesisDao::proposal_cap_type());
        Vector::push_back(&mut caps, GenesisDao::member_cap_type());
        Vector::push_back(&mut caps, GenesisDao::storage_cap_type());
        Vector::push_back(&mut caps, GenesisDao::proposal_cap_type());
        Vector::push_back(&mut caps, GenesisDao::modify_config_cap_type());
        caps
    }

    /// Grant which token type can convert from token to SBT
    public fun grant_token<DaoT: store, TokenT: store>(_root_cap: &GenesisDao::DaoRootCap<DaoT>) {
        inner_grant_token<DaoT, TokenT>();
    }

    /// Set the weight of convert parameter
    public fun set_weight<DaoT: store, TokenT: store>(_root_cap: &GenesisDao::DaoRootCap<DaoT>, _weight: u128) {}

    /// Recycle token from token exchange pool
    public fun recycle<DaoT: store, TokenT: store>(_cap: &Token::MintCapability<TokenT>): Token::Token<TokenT> {
        let witness = TokenToSbtPlugin {};
        let storage_cap =
            GenesisDao::acquire_storage_cap<DaoT, TokenToSbtPlugin>(&witness);
        let GrantToken<DaoT, TokenT> { token } =
            GenesisDao::take<DaoT, TokenToSbtPlugin, GrantToken<DaoT, TokenT>>(&storage_cap);

        // GrantToken has been taken, we want resave it into DAO account.
        GenesisDao::save<DaoT, TokenToSbtPlugin, GrantToken<DaoT, TokenT>>(
            &storage_cap,
            GrantToken<DaoT, TokenT> {
                token: Token::zero<TokenT>(),
            });
        token
    }

    /// Convert from token amount to sbt amount
    public fun exchange<DaoT: store, TokenT: store>(member: address, input_token: Token::Token<TokenT>) {
        assert!(GenesisDao::is_member<DaoT>(member), Errors::invalid_state(ERR_NOT_MEMBER));

        // Save token to pool
        let witness = TokenToSbtPlugin {};
        let storage_cap =
            GenesisDao::acquire_storage_cap<DaoT, TokenToSbtPlugin>(&witness);
        let GrantToken<DaoT, TokenT> { token } =
            GenesisDao::take<DaoT, TokenToSbtPlugin, GrantToken<DaoT, TokenT>>(&storage_cap);
        let input_amount = Token::value<TokenT>(&input_token);
        Token::deposit<TokenT>(&mut token, input_token);
        GenesisDao::save<DaoT, TokenToSbtPlugin, GrantToken<DaoT, TokenT>>(
            &storage_cap,
            GrantToken<DaoT, TokenT> {
                token,
            });

        // get weight from config
        let ConvertConfig<DaoT, TokenT> { weight } =
            GenesisDao::get_custom_config<
                DaoT,
                ConfigProposalPlugin,
                ConvertConfig<DaoT, TokenT>
            >(ConvertConfig<DaoT, TokenT> {
                weight: 1
            });

        let member_cap =
            GenesisDao::acquire_member_cap<DaoT, TokenToSbtPlugin>(&witness);
        GenesisDao::increase_member_sbt(&member_cap, member, input_amount * weight);
    }

    /// Grant token type so that allow user can exchange from token to DAO SBT
    fun inner_grant_token<DaoT: store, TokenT: store>() {
        let witness = TokenToSbtPlugin {};
        let storage_cap =
            GenesisDao::acquire_storage_cap<DaoT, TokenToSbtPlugin>(&witness);
        GenesisDao::save<DaoT, TokenToSbtPlugin, GrantToken<DaoT, TokenT>>(
            &storage_cap,
            GrantToken<DaoT, TokenT> {
                token: Token::zero<TokenT>(),
            });
    }

    public(script) fun propose_weight<DaoT: store, TokenT: store>(sender: signer, weight: u128, action_delay: u64) {
        ConfigProposalPlugin::create_proposal<DaoT, ConvertConfig<DaoT, TokenT>>(
            sender,
            action_delay,
            ConvertConfig<DaoT, TokenT> {
                weight
            });
    }

    public(script) fun execute_weight<DaoT: store, TokenT: store>(sender: signer, proposal_id: u64) {
        ConfigProposalPlugin::execute_proposal<DaoT, ConvertConfig<DaoT, TokenT>>(sender, proposal_id);
    }

    public(script) fun propose_grant_token<DaoT: store, TokenT: store>(sender: signer, action_delay: u64) {
        assert!(
            !GenesisDao::storage_exists<DaoT, TokenToSbtPlugin, GrantTokenAction<DaoT, TokenT>>(),
            Errors::invalid_state(ERR_TOKEN_HAS_GRANTED)
        );

        let witness = TokenToSbtPlugin {};
        let cap =
            GenesisDao::acquire_proposal_cap<DaoT, TokenToSbtPlugin>(&witness);

        GenesisDao::create_proposal(
            &cap, &sender, GrantTokenAction<DaoT, TokenT> {}, action_delay);
    }

    public(script) fun execute_grant_token<DaoT: store, TokenT: store>(sender: signer, proposal_id: u64) {
        let witness = TokenToSbtPlugin {};
        let proposal_cap =
            GenesisDao::acquire_proposal_cap<DaoT, TokenToSbtPlugin>(&witness);
        let GrantTokenAction<DaoT, TokenT> {} =
            GenesisDao::execute_proposal<
                DaoT, TokenToSbtPlugin, GrantTokenAction<DaoT, TokenT>>(&proposal_cap, &sender, proposal_id);

        let storage_cap =
            GenesisDao::acquire_storage_cap<DaoT, TokenToSbtPlugin>(&witness);
        GenesisDao::save<DaoT, TokenToSbtPlugin, GrantToken<DaoT, TokenT>>(
            &storage_cap,
            GrantToken<DaoT, TokenT> {
                token: Token::zero<TokenT>(),
            });
    }
}
}
