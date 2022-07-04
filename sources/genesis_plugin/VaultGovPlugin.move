address StarcoinFramework {

/// Vault governance plugin, called by other plugin or module
module VaultGovPlugin {

    use StarcoinFramework::Token;
    use StarcoinFramework::GenesisDao;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Account;

    const ERR_DEPOSIT_NOT_EXISTS: u64 = 1001;
    const ERR_BALANCE_INSUFFICIENT: u64 = 1002;

    struct VaultGovPlugin has drop {}

    struct Vault<phantom DaoT, phantom TokenT> {
        amount: u128
    }

    struct Deposit<phantom DaoT, phantom TokenT> has key {
        amount: u128
    }

    struct VaultConfig<phantom DaoT, phantom TokenT> has store, copy, drop {
        weight: u64,
    }

    struct VaultWithdrawProposalAction<phantom TokenT, phantom CapT> has store {
        amount: u128
    }

    public fun required_caps(): vector<GenesisDao::CapType> {
        let caps = Vector::singleton(GenesisDao::proposal_cap_type());
        Vector::push_back(&mut caps, GenesisDao::member_cap_type());
        Vector::push_back(&mut caps, GenesisDao::withdraw_token_cap_type());
        Vector::push_back(&mut caps, GenesisDao::storage_cap_type());
        caps
    }

    public(script) fun deposit<DaoT: store, TokenT: store>(sender: signer, deposit_amount: u128) acquires Deposit {
        let token = Account::withdraw<TokenT>(&sender, deposit_amount);
        let amount = Token::value<TokenT>(&token);
        let sender_addr = Signer::address_of(&sender);
        if (exists<Deposit<DaoT, TokenT>>(sender_addr)) {
            let deposit = borrow_global_mut<Deposit<DaoT, TokenT>>(sender_addr);
            deposit.amount = deposit.amount + amount;
        } else {
            move_to(&sender, Deposit<DaoT, TokenT>{
                amount,
            });
        };

        // Deposit into DAO account
        GenesisDao::deposit_token<DaoT, TokenT>(token);

        // Add sbt amount
        let sbt_amount = compute_sbt_from_token_amount<DaoT, TokenT>(amount);
        let member_cap =
            GenesisDao::acquire_member_cap<DaoT, VaultGovPlugin>(&VaultGovPlugin{});
        GenesisDao::increase_member_sbt(&member_cap, sender_addr, sbt_amount);
    }

    public(script) fun withdraw<DaoT: store,
                                TokenT: store>(sender: signer,
                                               amount: u128) acquires Deposit {
        let sender_addr = Signer::address_of(&sender);
        assert!(exists<Deposit<DaoT, TokenT>>(sender_addr), Errors::invalid_state(ERR_DEPOSIT_NOT_EXISTS));

        let deposit = borrow_global_mut<Deposit<DaoT, TokenT>>(sender_addr);
        assert!(amount <= deposit.amount, Errors::invalid_state(ERR_DEPOSIT_NOT_EXISTS));
        assert!(GenesisDao::balance<DaoT, TokenT>() > amount, Errors::invalid_state(ERR_BALANCE_INSUFFICIENT));

        let witness = VaultGovPlugin{};

        // remove sbt amount
        let sbt_amount = compute_sbt_from_token_amount<DaoT, TokenT>(amount);
        let member_cap = GenesisDao::acquire_member_cap<DaoT, VaultGovPlugin>(&witness);
        GenesisDao::decrease_member_sbt(&member_cap, sender_addr, sbt_amount);

        // Withdraw token to sender account
        let withdraw_cap =
            GenesisDao::acquire_withdraw_token_cap<DaoT, VaultGovPlugin>(&witness);
        let token = GenesisDao::withdraw_token<DaoT, VaultGovPlugin, TokenT>(&withdraw_cap, amount);
        Account::deposit<TokenT>(sender_addr, token);
    }

    public fun compute_sbt_from_token_amount<DaoT: store, TokenT>(amount: u128): u128 {
        let config =
            GenesisDao::get_custom_config<DaoT, VaultGovPlugin, VaultConfig<DaoT, TokenT>>();
        (config.weight as u128) * amount
    }


    /// Create a proposal that invested by a strategy
    public fun create_withdraw_proposal<DaoT: store,
                                        TokenT: store,
                                        CapT: drop>(sender: signer,
                                                    amount: u128,
                                                    action_delay: u64) {
        let witness = VaultGovPlugin{};

        let cap = GenesisDao::acquire_proposal_cap<DaoT, VaultGovPlugin>(&witness);
        let action = VaultWithdrawProposalAction<TokenT, CapT>{
            amount
        };
        assert!(GenesisDao::balance<DaoT, TokenT>() > amount, Errors::invalid_state(ERR_BALANCE_INSUFFICIENT));
        GenesisDao::create_proposal(&cap, &sender, action, action_delay);
    }

    /// Create a proposal that invested by a strategy
    public fun execute_widthdraw_proposal<DaoT: store, TokenT: store, CapT: drop>(sender: signer,
                                                                                  proposal_id: u64,
                                                                                  _cap: &CapT)
    : Token::Token<TokenT> {
        let witness = VaultGovPlugin{};
        let proposal_cap = GenesisDao::acquire_proposal_cap<DaoT, VaultGovPlugin>(&witness);
        let VaultWithdrawProposalAction<TokenT, CapT>{ amount } =
            GenesisDao::execute_proposal<
                DaoT,
                VaultGovPlugin,
                VaultWithdrawProposalAction<TokenT, CapT>>(
                &proposal_cap, &sender, proposal_id);

        let withdraw_cap =
            GenesisDao::acquire_withdraw_token_cap<DaoT, VaultGovPlugin>(&witness);
        GenesisDao::withdraw_token<DaoT, VaultGovPlugin, TokenT>(&withdraw_cap, amount)
    }

    public fun meta_info(): (u64, vector<u8>, vector<u8>, vector<u8>) {
        (0, b"Vault", b"Vault plugin description", b"https://1234images.icon.com")
    }
}
}
