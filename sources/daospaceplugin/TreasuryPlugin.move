module StarcoinFramework::TreasuryPlugin {
    use StarcoinFramework::GenesisSignerCapability;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Option;
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Signer;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Token;
    use StarcoinFramework::Treasury;
    use StarcoinFramework::Token::Token;
    use StarcoinFramework::CoreAddresses;

    const ERR_NOT_AUTHORIZED: u64 = 101;
    /// Only receiver can execute treasury withdraw proposal
    const ERR_NOT_RECEIVER: u64 = 102;
    /// The withdraw amount of propose is too many.
    const ERR_TOO_MANY_WITHDRAW_AMOUNT: u64 = 103;
    const ERR_CAPABILITY_NOT_EXIST: u64 = 104;

    struct TreasuryPlugin has store, drop {}

    /// A wrapper of Token MintCapability.
    struct WithdrawCapabilityHolder<phantom TokenT> has key {
        cap: Treasury::WithdrawCapability<TokenT>,
    }

    /// WithdrawToken request.
    struct WithdrawTokenAction<phantom TokenT> has copy, drop, store {
        /// the receiver of withdraw tokens.
        receiver: address,
        /// how many tokens to mint.
        amount: u128,
        /// How long in milliseconds does it take for the token to be released
        period: u64,
    }

    public fun initialize() {
        let signer = GenesisSignerCapability::get_genesis_signer();

        DAOPluginMarketplace::register_plugin<TreasuryPlugin>(
            &signer,
            b"0x1::TreasuryPlugin",
            b"The plugin for withdraw token from Treasury.",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();

        let witness = TreasuryPlugin {};
        DAOPluginMarketplace::publish_plugin_version<TreasuryPlugin>(
            &signer,
            &witness,
            b"v0.1.0",
            *&implement_extpoints,
            *&depend_extpoints,
            b"inner-plugin://treasury-plugin",
        );
    }

    /// Delegate Treasury::WithdrawCapability to DAO
    /// Should be called by token issuer.
    public fun delegate_capability<TokenT: store>(sender: &signer, cap: Treasury::WithdrawCapability<TokenT>) {
        let token_issuer = Token::token_address<TokenT>();
        assert!(Signer::address_of(sender) == token_issuer, Errors::requires_address(ERR_NOT_AUTHORIZED));
        move_to(sender, WithdrawCapabilityHolder<TokenT> { cap });
    }

    public fun required_caps(): vector<CapType> {
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        caps
    }

    fun withdraw_limitation<DAOT: store, TokenT: store>(): u128 {
        let market_cap = Token::market_cap<TokenT>();
        let balance_in_treasury = Treasury::balance<TokenT>();
        let supply = market_cap - balance_in_treasury;
        let rate = DAOSpace::voting_quorum_rate<DAOT>();
        let rate = (rate as u128);
        supply * rate / 100
    }

    public fun create_withdraw_proposal<DAOT: store, TokenT: store>(
        sender: &signer,
        description: vector<u8>,
        receiver: address,
        amount: u128,
        period: u64,
        action_delay: u64)
    {
        let limit = withdraw_limitation<DAOT, TokenT>();
        assert!(amount <= limit,  Errors::invalid_argument(ERR_TOO_MANY_WITHDRAW_AMOUNT));
        let witness = TreasuryPlugin {};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, TreasuryPlugin>(&witness);
        let action = WithdrawTokenAction<TokenT> {
            receiver,
            amount,
            period,
        };
        DAOSpace::create_proposal(&cap, sender, action, description, action_delay);
    }

    public(script) fun create_withdraw_proposal_entry<DAOT: store, TokenT: store>(
        sender: signer,
        description: vector<u8>,
        receiver: address,
        amount: u128,
        period: u64,
        action_delay: u64)
    {
        create_withdraw_proposal<DAOT, TokenT>(&sender, description, receiver, amount, period, action_delay);
    }

    public fun execute_withdraw_proposal<DAOT: store, TokenT: store>(sender: &signer, proposal_id: u64) acquires WithdrawCapabilityHolder {
        let witness = TreasuryPlugin {};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, TreasuryPlugin>(&witness);
        let WithdrawTokenAction<TokenT> { receiver, amount, period } =
            DAOSpace::execute_proposal<DAOT, TreasuryPlugin, WithdrawTokenAction<TokenT>>(&proposal_cap, sender, proposal_id);
        assert!(receiver == Signer::address_of(sender), Errors::not_published(ERR_NOT_RECEIVER));
        let token_issuer = Token::token_address<TokenT>();
        assert!(exists<WithdrawCapabilityHolder<TokenT>>(token_issuer), Errors::not_published(ERR_CAPABILITY_NOT_EXIST));
        let cap = borrow_global_mut<WithdrawCapabilityHolder<TokenT>>(token_issuer);
        let linear_cap = Treasury::issue_linear_withdraw_capability<TokenT>(&mut cap.cap, amount, period);
        Treasury::add_linear_withdraw_capability(sender, linear_cap);
    }

    public(script) fun execute_withdraw_proposal_entry<DAOT: store, TokenT: store>(sender: signer, proposal_id: u64) acquires WithdrawCapabilityHolder {
        execute_withdraw_proposal<DAOT, TokenT>(&sender, proposal_id);
    }

    /// Provider a port for get block reward STC from Treasury, only genesis account can invoke this function.
    /// The TreasuryWithdrawCapability is locked in TreasuryWithdrawDaoProposal, and only can withdraw by DAO proposal.
    /// This approach is not graceful, but restricts the operation to genesis accounts only, so there are no security issues either.
    public fun withdraw_for_block_reward<TokenT: store>(signer: &signer, reward: u128): Token<TokenT>
    acquires WithdrawCapabilityHolder  {
        CoreAddresses::assert_genesis_address(signer);
        let cap = borrow_global_mut<WithdrawCapabilityHolder<TokenT>>(Signer::address_of(signer));
        Treasury::withdraw_with_capability(&mut cap.cap, reward)
    }
}