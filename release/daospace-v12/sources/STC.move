/// STC is the token of Starcoin blockchain.
/// It uses apis defined in the `Token` module.
module StarcoinFramework::STC {
    use StarcoinFramework::Token::{Self, Token};
    use StarcoinFramework::Treasury;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Errors;

    spec module {
        pragma verify = false;
        pragma aborts_if_is_strict = true;
    }

    /// STC token marker.
    struct STC has copy, drop, store {}

    /// precision of STC token.
    const PRECISION: u8 = 9;

    /// Burn capability of STC.
    struct SharedBurnCapability has key, store {
        cap: Token::BurnCapability<STC>,
    }

    /// STC initialization.
    public fun initialize(
        _account: &signer,
        _voting_delay: u64,
        _voting_period: u64,
        _voting_quorum_rate: u8,
        _min_action_delay: u64,
    ) {
        abort Errors::deprecated(1)
    }

    spec initialize {
        pragma verify = false;
    }

    public fun upgrade_from_v1_to_v2(account: &signer, total_amount: u128, ): Treasury::WithdrawCapability<STC> {
        CoreAddresses::assert_genesis_address(account);

        // Mint all stc, and destroy mint capability
        let total_stc = Token::mint<STC>(account, total_amount - Token::market_cap<STC>());
        let withdraw_cap = Treasury::initialize(account, total_stc);
        let mint_cap = Token::remove_mint_capability<STC>(account);
        Token::destroy_mint_capability(mint_cap);
        withdraw_cap
    }

    spec upgrade_from_v1_to_v2 {
        pragma verify = false;
    }


    /// STC initialization.
    public fun initialize_v2(
        _account: &signer,
        _total_amount: u128,
        _voting_delay: u64,
        _voting_period: u64,
        _voting_quorum_rate: u8,
        _min_action_delay: u64,
    ): Treasury::WithdrawCapability<STC> {
        abort Errors::deprecated(1)
    }

    spec initialize_v2 {
        pragma verify = false;
    }

    /// STC initialization.
    public fun initialize_v3(
        account: &signer,
        total_amount: u128,
    ): Treasury::WithdrawCapability<STC> {
        Token::register_token<STC>(account, PRECISION);

        // Mint all stc, and destroy mint capability

        let total_stc = Token::mint<STC>(account, total_amount);
        let withdraw_cap = Treasury::initialize(account, total_stc);
        let mint_cap = Token::remove_mint_capability<STC>(account);
        Token::destroy_mint_capability(mint_cap);

        let burn_cap = Token::remove_burn_capability<STC>(account);
        move_to(account, SharedBurnCapability { cap: burn_cap });
        withdraw_cap
    }

    spec initialize_v3 {
        include Token::RegisterTokenAbortsIf<STC> { precision: PRECISION };
    }

    /// Returns true if `TokenType` is `STC::STC`
    public fun is_stc<TokenType: store>(): bool {
        Token::is_same_token<STC, TokenType>()
    }

    spec is_stc {}

    /// Burn STC tokens.
    /// It can be called by anyone.
    public fun burn(token: Token<STC>) acquires SharedBurnCapability {
        let cap = borrow_global<SharedBurnCapability>(token_address());
        Token::burn_with_capability(&cap.cap, token);
    }

    spec burn {
        aborts_if Token::spec_abstract_total_value<STC>() - token.value < 0;
        aborts_if !exists<SharedBurnCapability>(Token::SPEC_TOKEN_TEST_ADDRESS());
    }

    /// Return STC token address.
    public fun token_address(): address {
        Token::token_address<STC>()
    }

    spec token_address {}
}