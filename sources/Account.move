address StarcoinFramework {

/// The module for the account resource that governs every account
module Account {
    use StarcoinFramework::Authenticator;
    use StarcoinFramework::Event;
    use StarcoinFramework::Hash;
    use StarcoinFramework::Token::{Self, Token};
    use StarcoinFramework::Vector;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Option::{Self, Option};
    use StarcoinFramework::TransactionFee;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Errors;
    use StarcoinFramework::STC::{Self, STC, is_stc};
    use StarcoinFramework::BCS;
    use StarcoinFramework::Math;

    friend StarcoinFramework::StarcoinDAO;

    spec module {
        pragma verify = false;
        pragma aborts_if_is_strict = true;
    }

    /// Every account has a Account::Account resource
    struct Account has key {
        /// The current authentication key.
        /// This can be different than the key used to create the account
        authentication_key: vector<u8>,
        /// A `withdrawal_capability` allows whoever holds this capability
        /// to withdraw from the account. At the time of account creation
        /// this capability is stored in this option. It can later be
        /// "extracted" from this field via `extract_withdraw_capability`,
        /// and can also be restored via `restore_withdraw_capability`.
        withdrawal_capability: Option<WithdrawCapability>,
        /// A `key_rotation_capability` allows whoever holds this capability
        /// the ability to rotate the authentication key for the account. At
        /// the time of account creation this capability is stored in this
        /// option. It can later be "extracted" from this field via
        /// `extract_key_rotation_capability`, and can also be restored via
        /// `restore_key_rotation_capability`.
        key_rotation_capability: Option<KeyRotationCapability>,

        /// event handle for account balance withdraw event
        withdraw_events: Event::EventHandle<WithdrawEvent>,
        /// event handle for account balance deposit event
        deposit_events: Event::EventHandle<DepositEvent>,

        /// Event handle for accept_token event
        accept_token_events: Event::EventHandle<AcceptTokenEvent>,

        /// The current sequence number.
        /// Incremented by one each time a transaction is submitted
        sequence_number: u64,
    }

    /// A resource that holds the tokens stored in this account
    struct Balance<phantom TokenType> has key {
        token: Token<TokenType>,
    }

    /// The holder of WithdrawCapability for account_address can withdraw Token from
    /// account_address/Account::Account/balance.
    /// There is at most one WithdrawCapability in existence for a given address.
    struct WithdrawCapability has store {
        account_address: address,
    }

    /// The holder of KeyRotationCapability for account_address can rotate the authentication key for
    /// account_address (i.e., write to account_address/Account::Account/authentication_key).
    /// There is at most one KeyRotationCapability in existence for a given address.
    struct KeyRotationCapability has store {
        account_address: address,
    }

    /// Message for balance withdraw event.
    struct WithdrawEvent has drop, store {
        /// The amount of Token<TokenType> sent
        amount: u128,
        /// The code symbol for the token that was sent
        token_code: Token::TokenCode,
        /// Metadata associated with the withdraw
        metadata: vector<u8>,
    }
    /// Message for balance deposit event.
    struct DepositEvent has drop, store {
        /// The amount of Token<TokenType> sent
        amount: u128,
        /// The code symbol for the token that was sent
        token_code: Token::TokenCode,
        /// Metadata associated with the deposit
        metadata: vector<u8>,
    }

    /// Message for accept token events
    struct AcceptTokenEvent has drop, store {
        token_code: Token::TokenCode,
    }

    // SignerDelegated can only be stored under address, not in other structs.
    struct SignerDelegated has key {}
    // SignerCapability can only be stored in other structs, not under address.
    // So that the capability is always controlled by contracts, not by some EOA.
    struct SignerCapability has store { addr: address }

    // Resource marking whether the account enable auto-accept-token feature.
    struct AutoAcceptToken has key { enable: bool }

    /// Message for rotate_authentication_key events
    struct RotateAuthKeyEvent has drop, store {
        account_address: address,
        new_auth_key: vector<u8>,
    }

    /// Message for extract_withdraw_capability events
    struct ExtractWithdrawCapEvent has drop, store {
        account_address: address,
    }

    /// Message for SignerDelegate events
    struct SignerDelegateEvent has drop, store {
        account_address: address
    }

    struct EventStore has key {
        /// Event handle for rotate_authentication_key event
        rotate_auth_key_events: Event::EventHandle<RotateAuthKeyEvent>,
        /// Event handle for extract_withdraw_capability event
        extract_withdraw_cap_events: Event::EventHandle<ExtractWithdrawCapEvent>,
        /// Event handle for signer delegated event
        signer_delegate_events: Event::EventHandle<SignerDelegateEvent>,
    }

    const MAX_U64: u128 = 18446744073709551615;

    const EPROLOGUE_ACCOUNT_DOES_NOT_EXIST: u64 = 0;
    const EPROLOGUE_INVALID_ACCOUNT_AUTH_KEY: u64 = 1;
    const EPROLOGUE_SEQUENCE_NUMBER_TOO_OLD: u64 = 2;
    const EPROLOGUE_SEQUENCE_NUMBER_TOO_NEW: u64 = 3;
    const EPROLOGUE_CANT_PAY_GAS_DEPOSIT: u64 = 4;

    const EPROLOGUE_SEQUENCE_NUMBER_TOO_BIG: u64 = 9;

    const EINSUFFICIENT_BALANCE: u64 = 10;
    const ECOIN_DEPOSIT_IS_ZERO: u64 = 15;
    const EBAD_TRANSACTION_FEE_TOKEN: u64 = 18;

    const EDEPRECATED_FUNCTION: u64 = 19;

    const EWITHDRAWAL_CAPABILITY_ALREADY_EXTRACTED: u64 = 101;
    const EMALFORMED_AUTHENTICATION_KEY: u64 = 102;
    const EKEY_ROTATION_CAPABILITY_ALREADY_EXTRACTED: u64 = 103;
    const EADDRESS_PUBLIC_KEY_INCONSISTENT: u64 = 104;
    const EADDRESS_AND_AUTH_KEY_MISMATCH: u64 = 105;
    const ERR_TOKEN_NOT_ACCEPT: u64 = 106;
    const ERR_SIGNER_ALREADY_DELEGATED: u64 = 107;

    const EPROLOGUE_SIGNER_ALREADY_DELEGATED: u64 = 200;

    const DUMMY_AUTH_KEY:vector<u8> = x"0000000000000000000000000000000000000000000000000000000000000000";
    // cannot be dummy key, or empty key
    const CONTRACT_ACCOUNT_AUTH_KEY_PLACEHOLDER:vector<u8> = x"0000000000000000000000000000000000000000000000000000000000000001";

    /// The address bytes length
    const ADDRESS_LENGTH: u64 = 16;

    /// A one-way action, once SignerCapability is removed from signer, the address cannot send txns anymore.
    /// This function can only called once by signer.
    public fun remove_signer_capability(signer: &signer): SignerCapability
    acquires Account, EventStore {
        let signer_addr = Signer::address_of(signer);
        assert!(!is_signer_delegated(signer_addr), Errors::invalid_state(ERR_SIGNER_ALREADY_DELEGATED));

        // set to account auth key to noop.
        {
            let key_rotation_capability = extract_key_rotation_capability(signer);
            rotate_authentication_key_with_capability(&key_rotation_capability, CONTRACT_ACCOUNT_AUTH_KEY_PLACEHOLDER);
            destroy_key_rotation_capability(key_rotation_capability);
            move_to(signer, SignerDelegated {});

            make_event_store_if_not_exist(signer);
            let event_store = borrow_global_mut<EventStore>(signer_addr);
            Event::emit_event<SignerDelegateEvent>(
                &mut event_store.signer_delegate_events,
                SignerDelegateEvent {
                    account_address: signer_addr
                }
            );
        };

        let signer_cap = SignerCapability {addr: signer_addr };
        signer_cap
    }

    //TODO: Create StarcoinDAO , need modify or remove get_genesis_capability soon
    public (friend) fun get_genesis_capability():SignerCapability{
        let signer_cap = SignerCapability {addr: Token::token_address<STC>() };
        signer_cap
    }

    public fun create_signer_with_cap(cap: &SignerCapability): signer {
        create_signer(cap.addr)
    }
    public fun destroy_signer_cap(cap: SignerCapability) {
        let SignerCapability {addr: _} = cap;
    }

    public fun signer_address(cap: &SignerCapability): address {
        cap.addr
    }
    public fun is_signer_delegated(addr: address): bool {
        exists<SignerDelegated>(addr)
    }

    /// Create an genesis account at `new_account_address` and return signer.
    /// Genesis authentication_key is zero bytes.
    public fun create_genesis_account(
        new_account_address: address,
    ) :signer {
        Timestamp::assert_genesis();
        let new_account = create_signer(new_account_address);
        make_account(&new_account, DUMMY_AUTH_KEY);
        new_account
    }

    spec create_genesis_account {
        aborts_if !Timestamp::is_genesis();
        aborts_if len(DUMMY_AUTH_KEY) != 32;
        aborts_if exists<Account>(new_account_address);
    }

    /// Release genesis account signer
    public fun release_genesis_signer(_genesis_account: signer){
    }

    spec release_genesis_signer {
        aborts_if false;
    }

    /// Deprecated since @v5
    public fun create_account<TokenType: store>(_authentication_key: vector<u8>): address {
        abort Errors::deprecated(EDEPRECATED_FUNCTION)
    }

    spec create_account {
        aborts_if true;
    }

    /// Creates a new account at `fresh_address` with a balance of zero and empty auth key, the address as init auth key for check transaction.
    /// Creating an account at address StarcoinFramework will cause runtime failure as it is a
    /// reserved address for the MoveVM.
    public fun create_account_with_address<TokenType: store>(fresh_address: address) acquires Account {
        let new_account = create_signer(fresh_address);
        make_account(&new_account, DUMMY_AUTH_KEY);
        // Make sure all account accept STC.
        if (!STC::is_stc<TokenType>()){
            do_accept_token<STC>(&new_account);
        };
        do_accept_token<TokenType>(&new_account);
    }

    spec create_account_with_address {
        //abort condition for make_account
        aborts_if exists<Account>(fresh_address);
        //abort condition for do_accept_token<STC>
        aborts_if Token::spec_token_code<TokenType>() != Token::spec_token_code<STC>() && exists<Balance<STC>>(fresh_address);
        //abort condition for do_accept_token<TokenType>
        aborts_if exists<Balance<TokenType>>(fresh_address);
        ensures exists_at(fresh_address);
        ensures exists<Balance<TokenType>>(fresh_address);
    }

    fun make_account(
        new_account: &signer,
        authentication_key: vector<u8>,
    ) {
        assert!(Vector::length(&authentication_key) == 32, Errors::invalid_argument(EMALFORMED_AUTHENTICATION_KEY));
        let new_account_addr = Signer::address_of(new_account);
        Event::publish_generator(new_account);
        move_to(new_account, Account {
              authentication_key,
              withdrawal_capability: Option::some(
                  WithdrawCapability {
                      account_address: new_account_addr
              }),
              key_rotation_capability: Option::some(
                  KeyRotationCapability {
                      account_address: new_account_addr
              }),
              withdraw_events: Event::new_event_handle<WithdrawEvent>(new_account),
              deposit_events: Event::new_event_handle<DepositEvent>(new_account),
              accept_token_events: Event::new_event_handle<AcceptTokenEvent>(new_account),
              sequence_number: 0,
        });
        move_to(new_account, AutoAcceptToken{enable: true});
        move_to(new_account, EventStore {
              rotate_auth_key_events: Event::new_event_handle<RotateAuthKeyEvent>(new_account),
              extract_withdraw_cap_events: Event::new_event_handle<ExtractWithdrawCapEvent>(new_account),
              signer_delegate_events: Event::new_event_handle<SignerDelegateEvent>(new_account),
        });
    }

    spec make_account {
        aborts_if len(authentication_key) != 32;
        aborts_if exists<Account>(Signer::address_of(new_account));
        aborts_if exists<AutoAcceptToken>(Signer::address_of(new_account));
        ensures exists_at(Signer::address_of(new_account));
    }

    native fun create_signer(addr: address): signer;

    public(script) fun create_account_with_initial_amount<TokenType: store>(account: signer, fresh_address: address, _auth_key: vector<u8>, initial_amount: u128) 
    acquires Account, Balance, AutoAcceptToken {
        create_account_with_initial_amount_entry<TokenType>(account, fresh_address, initial_amount);
    }

    public(script) fun create_account_with_initial_amount_v2<TokenType: store>(account: signer, fresh_address: address, initial_amount: u128)
    acquires Account, Balance, AutoAcceptToken {
        create_account_with_initial_amount_entry<TokenType>(account, fresh_address, initial_amount);
    }
    
    public(script) fun create_account_with_initial_amount_entry<TokenType: store>(account: signer, fresh_address: address, initial_amount: u128)
    acquires Account, Balance, AutoAcceptToken {
        create_account_with_address<TokenType>(fresh_address);
        if (initial_amount > 0) {
            pay_from<TokenType>(&account, fresh_address, initial_amount);
        };
    }

    spec create_account_with_initial_amount {
        pragma verify = false;
    }

    spec create_account_with_initial_amount_v2 {
         pragma verify = false;
    }

    /// Generate an new address and create a new account, then delegate the account and return the new account address and `SignerCapability`
    public fun create_delegate_account(sender: &signer) : (address, SignerCapability) acquires Balance, Account, EventStore {
        let new_address = generate_fresh_address(sender);
        Self::create_account_with_address<STC>(new_address);
        let new_signer = Self::create_signer(new_address);
        (new_address, Self::remove_signer_capability(&new_signer))
    }

    /// Generate a fresh address from the sender address and the sender's sequence number, and ensure the generated address is not exists onchain.
    public fun generate_fresh_address(sender: &signer) : address acquires Balance, Account {
        let try_times = 0u64;
        while(true){
            let sender_address = Signer::address_of(sender);
            let sequence_number = Self::sequence_number(sender_address);
            // use stc balance as part of seed, just for new address more random.
            let stc_balance = Self::balance<STC>(sender_address);

            let seed_bytes = BCS::to_bytes(&sender_address);
            Vector::append(&mut seed_bytes, BCS::to_bytes(&sequence_number));
            Vector::append(&mut seed_bytes, BCS::to_bytes(&stc_balance));
            Vector::append(&mut seed_bytes, BCS::to_bytes(&try_times));

            let seed_hash = Hash::sha3_256(seed_bytes);

            let i = 0;
            let address_bytes = Vector::empty();
            while (i < ADDRESS_LENGTH) {
                Vector::push_back(&mut address_bytes, *Vector::borrow(&seed_hash,i));
                i = i + 1;
            };
            let new_address = BCS::to_address(address_bytes);
            if (Self::exists_at(new_address)){
                try_times = try_times + 1;
                continue
            }else{
                return new_address
            }
        };
        //unreachable
        abort 0
    }

    spec create_delegate_account {
        pragma verify = false;
        //TODO write spec
    }

    /// Deposits the `to_deposit` token into the self's account balance
    public fun deposit_to_self<TokenType: store>(account: &signer, to_deposit: Token<TokenType>)
    acquires Account, Balance, AutoAcceptToken {
        let account_address = Signer::address_of(account);
        if (!is_accepts_token<TokenType>(account_address)){
            do_accept_token<TokenType>(account);
        };
        deposit(account_address, to_deposit);
    }

    spec deposit_to_self {
        aborts_if to_deposit.value == 0;
        let is_accepts_token = exists<Balance<TokenType>>(Signer::address_of(account));
        aborts_if is_accepts_token && global<Balance<TokenType>>(Signer::address_of(account)).token.value + to_deposit.value > max_u128();
        aborts_if !exists<Account>(Signer::address_of(account));
        ensures exists<Balance<TokenType>>(Signer::address_of(account));
    }

    /// Deposits the `to_deposit` token into the `receiver`'s account balance with the no metadata
    /// It's a reverse operation of `withdraw`.
    public fun deposit<TokenType: store>(
        receiver: address,
        to_deposit: Token<TokenType>,
    ) acquires Account, Balance, AutoAcceptToken {
        deposit_with_metadata<TokenType>(receiver, to_deposit, x"")
    }

    spec deposit {
        include DepositWithMetadataAbortsIf<TokenType>;
    }

    /// Deposits the `to_deposit` token into the `receiver`'s account balance with the attached `metadata`
    /// It's a reverse operation of `withdraw_with_metadata`.
    public fun deposit_with_metadata<TokenType: store>(
        receiver: address,
        to_deposit: Token<TokenType>,
        metadata: vector<u8>,
    ) acquires Account, Balance, AutoAcceptToken {

        if (!exists_at(receiver)) {
            create_account_with_address<TokenType>(receiver);
        };

        try_accept_token<TokenType>(receiver);

        let deposit_value = Token::value(&to_deposit);
        if (deposit_value > 0u128) {
            // Deposit the `to_deposit` token
            deposit_to_balance<TokenType>(borrow_global_mut<Balance<TokenType>>(receiver), to_deposit);

            // emit deposit event
            emit_account_deposit_event<TokenType>(receiver, deposit_value, metadata);
        } else {
            Token::destroy_zero(to_deposit);
        };
    }

    spec deposit_with_metadata {
        include DepositWithMetadataAbortsIf<TokenType>;
        ensures exists<Balance<TokenType>>(receiver);
        ensures old(global<Balance<TokenType>>(receiver)).token.value + to_deposit.value == global<Balance<TokenType>>(receiver).token.value;
    }

    spec schema DepositWithMetadataAbortsIf<TokenType> {
        receiver: address;
        to_deposit: Token<TokenType>;

        aborts_if to_deposit.value == 0;
        aborts_if !exists<Account>(receiver);
        aborts_if !exists<Balance<TokenType>>(receiver);

        aborts_if global<Balance<TokenType>>(receiver).token.value + to_deposit.value > max_u128();

    }

    /// Helper to deposit `amount` to the given account balance
    fun deposit_to_balance<TokenType: store>(balance: &mut Balance<TokenType>, token: Token::Token<TokenType>) {
        Token::deposit(&mut balance.token, token)
    }

    spec deposit_to_balance {
        aborts_if balance.token.value + token.value > MAX_U128;
    }



    /// Helper to withdraw `amount` from the given account balance and return the withdrawn Token<TokenType>
    fun withdraw_from_balance<TokenType: store>(balance: &mut Balance<TokenType>, amount: u128): Token<TokenType>{
        Token::withdraw(&mut balance.token, amount)
    }

    spec withdraw_from_balance {
        aborts_if balance.token.value < amount;
    }

    /// Withdraw `amount` Token<TokenType> from the account balance
    public fun withdraw<TokenType: store>(account: &signer, amount: u128): Token<TokenType>
    acquires Account, Balance {
        withdraw_with_metadata<TokenType>(account, amount, x"")
    }
    spec withdraw {
        aborts_if !exists<Balance<TokenType>>(Signer::address_of(account));
        aborts_if !exists<Account>(Signer::address_of(account));
        aborts_if global<Balance<TokenType>>(Signer::address_of(account)).token.value < amount;
        aborts_if Option::is_none(global<Account>(Signer::address_of(account)).withdrawal_capability);
    }


    /// Withdraw `amount` tokens from `signer` with given `metadata`.
    public fun withdraw_with_metadata<TokenType: store>(account: &signer, amount: u128, metadata: vector<u8>): Token<TokenType>
    acquires Account, Balance {
        let sender_addr = Signer::address_of(account);
        let sender_balance = borrow_global_mut<Balance<TokenType>>(sender_addr);
        // The sender_addr has delegated the privilege to withdraw from her account elsewhere--abort.
        assert!(!delegated_withdraw_capability(sender_addr), Errors::invalid_state(EWITHDRAWAL_CAPABILITY_ALREADY_EXTRACTED));
        if (amount == 0){
            return Token::zero()
        };
        emit_account_withdraw_event<TokenType>(sender_addr, amount, metadata);
        // The sender_addr has retained her withdrawal privileges--proceed.
        withdraw_from_balance<TokenType>(sender_balance, amount)
    }

    spec withdraw_with_metadata {
        aborts_if !exists<Balance<TokenType>>(Signer::address_of(account));
        aborts_if !exists<Account>(Signer::address_of(account));
        aborts_if global<Balance<TokenType>>(Signer::address_of(account)).token.value < amount;
        aborts_if Option::is_none(global<Account>(Signer::address_of(account)).withdrawal_capability);
    }

    spec fun spec_withdraw<TokenType>(account: signer, amount: u128): Token<TokenType> {
        Token<TokenType> { value: amount }
    }

    /// Withdraw `amount` Token<TokenType> from the account under cap.account_address with no metadata
    public fun withdraw_with_capability<TokenType: store>(
        cap: &WithdrawCapability, amount: u128
    ): Token<TokenType> acquires Balance, Account {
        withdraw_with_capability_and_metadata<TokenType>(cap, amount, x"")
    }

    spec withdraw_with_capability {
        aborts_if !exists<Balance<TokenType>>(cap.account_address);
        aborts_if !exists<Account>(cap.account_address);
        aborts_if global<Balance<TokenType>>(cap.account_address).token.value < amount;
    }

    /// Withdraw `amount` Token<TokenType> from the account under cap.account_address with metadata
    public fun withdraw_with_capability_and_metadata<TokenType: store>(
        cap: &WithdrawCapability, amount: u128, metadata: vector<u8>
    ): Token<TokenType> acquires Balance, Account {
        let balance = borrow_global_mut<Balance<TokenType>>(cap.account_address);
        emit_account_withdraw_event<TokenType>(cap.account_address, amount, metadata);
        withdraw_from_balance<TokenType>(balance , amount)
    }

    spec withdraw_with_capability_and_metadata {
        aborts_if !exists<Balance<TokenType>>(cap.account_address);
        aborts_if !exists<Account>(cap.account_address);
        aborts_if global<Balance<TokenType>>(cap.account_address).token.value < amount;
    }


    /// Return a unique capability granting permission to withdraw from the sender's account balance.
    public fun extract_withdraw_capability(
        sender: &signer
    ): WithdrawCapability acquires Account, EventStore {
        let sender_addr = Signer::address_of(sender);
        // Abort if we already extracted the unique withdraw capability for this account.
        assert!(!delegated_withdraw_capability(sender_addr), Errors::invalid_state(EWITHDRAWAL_CAPABILITY_ALREADY_EXTRACTED));

        make_event_store_if_not_exist(sender);
        let event_store = borrow_global_mut<EventStore>(sender_addr);
        Event::emit_event<ExtractWithdrawCapEvent>(
            &mut event_store.extract_withdraw_cap_events,
            ExtractWithdrawCapEvent {
                account_address: sender_addr,
            }
        );
        let account = borrow_global_mut<Account>(sender_addr);
        Option::extract(&mut account.withdrawal_capability)
    }

    spec extract_withdraw_capability {
        aborts_if !exists<Account>(Signer::address_of(sender));
        aborts_if Option::is_none(global<Account>( Signer::address_of(sender)).withdrawal_capability);
    }

     /// Return the withdraw capability to the account it originally came from
     public fun restore_withdraw_capability(cap: WithdrawCapability)
        acquires Account {
            let account = borrow_global_mut<Account>(cap.account_address);
            Option::fill(&mut account.withdrawal_capability, cap)
     }

    spec restore_withdraw_capability {
        aborts_if Option::is_some(global<Account>(cap.account_address).withdrawal_capability);
        aborts_if !exists<Account>(cap.account_address);
    }

    fun emit_account_withdraw_event<TokenType: store>(account: address, amount: u128, metadata: vector<u8>)
    acquires Account {
        // emit withdraw event
        let account = borrow_global_mut<Account>(account);

        Event::emit_event<WithdrawEvent>(&mut account.withdraw_events, WithdrawEvent {
            amount,
            token_code: Token::token_code<TokenType>(),
            metadata,
        });
    }
    spec emit_account_withdraw_event {
        aborts_if !exists<Account>(account);
    }

    fun emit_account_deposit_event<TokenType: store>(account: address, amount: u128, metadata: vector<u8>)
    acquires Account {
        // emit withdraw event
        let account = borrow_global_mut<Account>(account);

        Event::emit_event<DepositEvent>(&mut account.deposit_events, DepositEvent {
            amount,
            token_code: Token::token_code<TokenType>(),
            metadata,
        });
    }
    spec emit_account_deposit_event {
        aborts_if !exists<Account>(account);
    }


    /// Withdraws `amount` Token<TokenType> using the passed in WithdrawCapability, and deposits it
    /// into the `payee`'s account balance. Creates the `payee` account if it doesn't exist.
    public fun pay_from_capability<TokenType: store>(
        cap: &WithdrawCapability,
        payee: address,
        amount: u128,
        metadata: vector<u8>,
    ) acquires Account, Balance, AutoAcceptToken {
        let tokens = withdraw_with_capability_and_metadata<TokenType>(cap, amount, *&metadata);
        deposit_with_metadata<TokenType>(
            payee,
            tokens,
            metadata,
        );
    }

    spec pay_from_capability {
        // condition for withdraw_with_capability_and_metadata()
        aborts_if !exists<Balance<TokenType>>(cap.account_address);
        aborts_if !exists<Account>(cap.account_address);
        aborts_if global<Balance<TokenType>>(cap.account_address).token.value < amount;
        // condition for deposit_with_metadata()
        aborts_if amount == 0;
        aborts_if !exists<Account>(payee);
        aborts_if !exists<Balance<TokenType>>(payee);
        aborts_if cap.account_address != payee && global<Balance<TokenType>>(payee).token.value + amount > MAX_U128;
    }

    /// Withdraw `amount` Token<TokenType> from the transaction sender's
    /// account balance and send the token to the `payee` address with the
    /// attached `metadata` Creates the `payee` account if it does not exist
    public fun pay_from_with_metadata<TokenType: store>(
        account: &signer,
        payee: address,
        amount: u128,
        metadata: vector<u8>,
    ) acquires Account, Balance, AutoAcceptToken {
        let tokens = withdraw_with_metadata<TokenType>(account, amount, *&metadata);
        deposit_with_metadata<TokenType>(
            payee,
            tokens,
            metadata,
        );
    }

    spec pay_from_with_metadata {
        // condition for withdraw_with_metadata()
        aborts_if !exists<Balance<TokenType>>(Signer::address_of(account));
        aborts_if !exists<Account>(Signer::address_of(account));
        aborts_if global<Balance<TokenType>>(Signer::address_of(account)).token.value < amount;
        aborts_if Option::is_none(global<Account>(Signer::address_of(account)).withdrawal_capability);
        // condition for deposit_with_metadata()
        aborts_if amount == 0;
        aborts_if !exists<Account>(payee);
        aborts_if !exists<Balance<TokenType>>(payee);
        aborts_if Signer::address_of(account) != payee && global<Balance<TokenType>>(payee).token.value + amount > max_u128();
}
    spec schema DepositWithPayerAndMetadataAbortsIf<TokenType> {
        payer: address;
        payee: address;
        to_deposit: Token<TokenType>;

        aborts_if to_deposit.value == 0;
        aborts_if !exists<Account>(payer);
        aborts_if !exists<Account>(payee);
        aborts_if !exists<Balance<TokenType>>(payee);
        aborts_if global<Balance<TokenType>>(payee).token.value + to_deposit.value > max_u128();
    }


    /// Withdraw `amount` Token<TokenType> from the transaction sender's
    /// account balance  and send the token to the `payee` address
    /// Creates the `payee` account if it does not exist
    public fun pay_from<TokenType: store>(
        account: &signer,
        payee: address,
        amount: u128
    ) acquires Account, Balance, AutoAcceptToken {
        pay_from_with_metadata<TokenType>(account, payee, amount, x"");
    }

    spec pay_from {
        // condition for withdraw_with_metadata()
        aborts_if !exists<Balance<TokenType>>(Signer::address_of(account));
        aborts_if !exists<Account>(Signer::address_of(account));
        aborts_if global<Balance<TokenType>>(Signer::address_of(account)).token.value < amount;
        aborts_if Option::is_none(global<Account>(Signer::address_of(account)).withdrawal_capability);
        // condition for deposit_with_metadata()
        aborts_if amount == 0;
        aborts_if !exists<Account>(payee);
        aborts_if !exists<Balance<TokenType>>(payee);
        aborts_if Signer::address_of(account) != payee && global<Balance<TokenType>>(payee).token.value + amount > max_u128();
    }

    /// Rotate the authentication key for the account under cap.account_address
    public fun rotate_authentication_key_with_capability(
        cap: &KeyRotationCapability,
        new_authentication_key: vector<u8>,
    ) acquires Account  {
        let sender_account_resource = borrow_global_mut<Account>(cap.account_address);
        // Don't allow rotating to clearly invalid key
        assert!(Vector::length(&new_authentication_key) == 32, Errors::invalid_argument(EMALFORMED_AUTHENTICATION_KEY));
        sender_account_resource.authentication_key = new_authentication_key;
    }

    spec rotate_authentication_key_with_capability {
        aborts_if !exists<Account>(cap.account_address);
        aborts_if len(new_authentication_key) != 32;
        ensures global<Account>(cap.account_address).authentication_key == new_authentication_key;
    }

        spec fun spec_rotate_authentication_key_with_capability(addr: address, new_authentication_key: vector<u8>): bool {
            global<Account>(addr).authentication_key == new_authentication_key
        }


    /// Return a unique capability granting permission to rotate the sender's authentication key
    public fun extract_key_rotation_capability(account: &signer): KeyRotationCapability
    acquires Account {
        let account_address = Signer::address_of(account);
        // Abort if we already extracted the unique key rotation capability for this account.
        assert!(!delegated_key_rotation_capability(account_address), Errors::invalid_state(EKEY_ROTATION_CAPABILITY_ALREADY_EXTRACTED));
        let account = borrow_global_mut<Account>(account_address);
        Option::extract(&mut account.key_rotation_capability)
    }

    spec extract_key_rotation_capability {
        aborts_if !exists<Account>(Signer::address_of(account));
        aborts_if Option::is_none(global<Account>(Signer::address_of(account)).key_rotation_capability);
    }

    /// Return the key rotation capability to the account it originally came from
    public fun restore_key_rotation_capability(cap: KeyRotationCapability)
    acquires Account {
        let account = borrow_global_mut<Account>(cap.account_address);
        Option::fill(&mut account.key_rotation_capability, cap)
    }
    public fun destroy_key_rotation_capability(cap: KeyRotationCapability) {
        let KeyRotationCapability {account_address: _} = cap;
    }

    spec restore_key_rotation_capability {
        aborts_if Option::is_some(global<Account>(cap.account_address).key_rotation_capability);
        aborts_if !exists<Account>(cap.account_address);
    }

    public(script) fun rotate_authentication_key(account: signer, new_key: vector<u8>) acquires Account, EventStore {
        rotate_authentication_key_entry(account, new_key);
    }

    public(script) fun rotate_authentication_key_entry(account: signer, new_key: vector<u8>) acquires Account, EventStore {
        do_rotate_authentication_key(&account, new_key);
    }

    public fun do_rotate_authentication_key(account: &signer, new_key: vector<u8>) acquires Account, EventStore {
        let key_rotation_capability = extract_key_rotation_capability(account);
        rotate_authentication_key_with_capability(&key_rotation_capability, copy new_key);
        restore_key_rotation_capability(key_rotation_capability);

        make_event_store_if_not_exist(account);
        let signer_addr = Signer::address_of(account);
        let event_store = borrow_global_mut<EventStore>(signer_addr);
        Event::emit_event<RotateAuthKeyEvent>(
            &mut event_store.rotate_auth_key_events,
            RotateAuthKeyEvent {
                account_address: signer_addr,
                new_auth_key: new_key,
            }
        );
    }

    spec rotate_authentication_key {
        pragma verify = false;
    }

    /// Helper to return the u128 value of the `balance` for `account`
    fun balance_for<TokenType: store>(balance: &Balance<TokenType>): u128 {
        Token::value<TokenType>(&balance.token)
    }

    spec balance_for {
        aborts_if false;
    }

    /// Return the current TokenType balance of the account at `addr`.
    public fun balance<TokenType: store>(addr: address): u128 acquires Balance {
        if (exists<Balance<TokenType>>(addr)) {
            balance_for(borrow_global<Balance<TokenType>>(addr))
        } else {
            0u128
        }
    }


    /// Add a balance of `Token` type to the sending account.
    public fun do_accept_token<TokenType: store>(account: &signer) acquires Account {
        move_to(account, Balance<TokenType>{ token: Token::zero<TokenType>() });
        let token_code = Token::token_code<TokenType>();
        // Load the sender's account
        let sender_account_ref = borrow_global_mut<Account>(Signer::address_of(account));
        // Log a sent event
        Event::emit_event<AcceptTokenEvent>(
            &mut sender_account_ref.accept_token_events,
            AcceptTokenEvent {
                token_code:  token_code,
            },
        );
    }

    spec do_accept_token {
        aborts_if exists<Balance<TokenType>>(Signer::address_of(account));
        aborts_if !exists<Account>(Signer::address_of(account));
    }

    public(script) fun accept_token<TokenType: store>(account: signer) acquires Account {
        accept_token_entry<TokenType>(account);
    }

    public(script) fun accept_token_entry<TokenType: store>(account: signer) acquires Account {
        do_accept_token<TokenType>(&account);
    }

    spec accept_token {
        pragma verify = false;
    }

    /// This is a alias of is_accept_token
    public fun is_accepts_token<TokenType: store>(addr: address): bool acquires AutoAcceptToken {
        Self::is_accept_token<TokenType>(addr)
    }

    spec is_accepts_token {
        aborts_if false;
    }

    /// Return whether the account at `addr` accept `Token` type tokens
    public fun is_accept_token<TokenType: store>(addr: address): bool acquires AutoAcceptToken {
        if (can_auto_accept_token(addr)) {
            true
        } else {
            exists<Balance<TokenType>>(addr)
        }
    }

    spec is_accept_token {
        aborts_if false;
    }

    /// Check whether the address can auto accept token.
    public fun can_auto_accept_token(addr: address): bool acquires AutoAcceptToken {
        if (exists<AutoAcceptToken>(addr)) {
            borrow_global<AutoAcceptToken>(addr).enable
        } else {
            false
        }
    }

    public(script) fun set_auto_accept_token_entry(account: signer, enable: bool) acquires AutoAcceptToken {
        set_auto_accept_token(&account, enable);
    }

    /// Configure whether auto-accept tokens.
    public fun set_auto_accept_token(account: &signer, enable: bool) acquires AutoAcceptToken {
        let addr = Signer::address_of(account);
        if (exists<AutoAcceptToken>(addr)) {
            let config = borrow_global_mut<AutoAcceptToken>(addr);
            config.enable = enable;
        } else {
            move_to(account, AutoAcceptToken{enable});
        };
    }
    spec set_auto_accept_token {
        aborts_if false;
    }

    /// try to accept token for `addr`.
    fun try_accept_token<TokenType: store>(addr: address) acquires AutoAcceptToken, Account {
        if (!exists<Balance<TokenType>>(addr)) {
            if (can_auto_accept_token(addr)) {
                let signer = create_signer(addr);
                do_accept_token<TokenType>(&signer);
            }else{
                abort Errors::not_published(ERR_TOKEN_NOT_ACCEPT)
            }
        };
    }
    spec try_accept_token {
        aborts_if false;
    }

    /// Helper to return the sequence number field for given `account`
    fun sequence_number_for_account(account: &Account): u64 {
        account.sequence_number
    }

    spec is_accepts_token {
        aborts_if false;
    }

    /// Return the current sequence number at `addr`
    public fun sequence_number(addr: address): u64 acquires Account {
        sequence_number_for_account(borrow_global<Account>(addr))
    }

    spec sequence_number {
        aborts_if !exists<Account>(addr);
    }

    /// Return the authentication key for this account
    public fun authentication_key(addr: address): vector<u8> acquires Account {
        *&borrow_global<Account>(addr).authentication_key
    }

    spec authentication_key {
        aborts_if !exists<Account>(addr);
    }

    /// Return true if the account at `addr` has delegated its key rotation capability
    public fun delegated_key_rotation_capability(addr: address): bool
    acquires Account {
        Option::is_none(&borrow_global<Account>(addr).key_rotation_capability)
    }

    spec delegated_key_rotation_capability {
        aborts_if !exists<Account>(addr);
    }

    /// Return true if the account at `addr` has delegated its withdraw capability
    public fun delegated_withdraw_capability(addr: address): bool
    acquires Account {
        Option::is_none(&borrow_global<Account>(addr).withdrawal_capability)
    }

    spec delegated_withdraw_capability {
        aborts_if !exists<Account>(addr);
    }

    /// Return a reference to the address associated with the given withdraw capability
    public fun withdraw_capability_address(cap: &WithdrawCapability): &address {
        &cap.account_address
    }

    spec withdraw_capability_address {
        aborts_if false;
    }

    /// Return a reference to the address associated with the given key rotation capability
    public fun key_rotation_capability_address(cap: &KeyRotationCapability): &address {
        &cap.account_address
    }

    spec key_rotation_capability_address {
        aborts_if false;
    }

    /// Checks if an account exists at `check_addr`
    public fun exists_at(check_addr: address): bool {
        exists<Account>(check_addr)
    }

    spec exists_at {
        aborts_if false;
    }

    fun is_dummy_auth_key(account: &Account): bool {
        *&account.authentication_key == DUMMY_AUTH_KEY
    }

    /// The prologue is invoked at the beginning of every transaction
    /// It verifies:
    /// - The account's auth key matches the transaction's public key
    /// - That the account has enough balance to pay for all of the gas
    /// - That the sequence number matches the transaction's sequence key
    public fun txn_prologue<TokenType: store>(
        account: &signer,
        txn_sender: address,
        txn_sequence_number: u64,
        txn_authentication_key_preimage: vector<u8>,
        txn_gas_price: u64,
        txn_max_gas_units: u64,
    ) acquires Account, Balance {
        txn_prologue_v2<TokenType>(
            account,
            txn_sender,
            txn_sequence_number,
            txn_authentication_key_preimage,
            txn_gas_price,
            txn_max_gas_units,
            1,
            1,
        )
    }
    spec txn_prologue {
        aborts_if Signer::address_of(account) != CoreAddresses::GENESIS_ADDRESS();
        aborts_if !exists<Account>(txn_sender);
        aborts_if global<Account>(txn_sender).authentication_key == DUMMY_AUTH_KEY && Authenticator::spec_derived_address(Hash::sha3_256(txn_authentication_key_preimage)) != txn_sender;
        aborts_if global<Account>(txn_sender).authentication_key != DUMMY_AUTH_KEY && Hash::sha3_256(txn_authentication_key_preimage) != global<Account>(txn_sender).authentication_key;
        aborts_if txn_sequence_number < global<Account>(txn_sender).sequence_number;
    }

    public fun txn_prologue_v2<TokenType: store>(
        account: &signer,
        txn_sender: address,
        txn_sequence_number: u64,
        txn_authentication_key_preimage: vector<u8>,
        txn_gas_price: u64,
        txn_max_gas_units: u64,
        stc_price: u128,
        stc_price_scaling: u128
    ) acquires Account, Balance {
        CoreAddresses::assert_genesis_address(account);

        // Verify that the transaction sender's account exists
        assert!(exists_at(txn_sender), Errors::requires_address(EPROLOGUE_ACCOUNT_DOES_NOT_EXIST));
        // Verify the account has not delegate its signer cap.
        assert!(!is_signer_delegated(txn_sender), Errors::invalid_state(EPROLOGUE_SIGNER_ALREADY_DELEGATED));

        // Load the transaction sender's account
        let sender_account = borrow_global_mut<Account>(txn_sender);

        if (is_dummy_auth_key(sender_account)){
            // if sender's auth key is empty, use address as auth key for check transaction.
            assert!(
                Authenticator::derived_address(Hash::sha3_256(txn_authentication_key_preimage)) == txn_sender,
                Errors::invalid_argument(EPROLOGUE_INVALID_ACCOUNT_AUTH_KEY)
            );
        }else{
            // Check that the hash of the transaction's public key matches the account's auth key
            assert!(
                Hash::sha3_256(txn_authentication_key_preimage) == *&sender_account.authentication_key,
                Errors::invalid_argument(EPROLOGUE_INVALID_ACCOUNT_AUTH_KEY)
            );
        };
        // Check that the account has enough balance for all of the gas
        let (max_transaction_fee_stc,max_transaction_fee_token) = transaction_fee_simulate(txn_gas_price,txn_max_gas_units,0, stc_price, stc_price_scaling);
        assert!(
            max_transaction_fee_stc <= MAX_U64,
            Errors::invalid_argument(EPROLOGUE_CANT_PAY_GAS_DEPOSIT),
        );
        if (max_transaction_fee_stc > 0) {
            assert!(
                (txn_sequence_number as u128) < MAX_U64,
                Errors::limit_exceeded(EPROLOGUE_SEQUENCE_NUMBER_TOO_BIG)
            );
            let balance_amount_token = balance<TokenType>(txn_sender);
            assert!(balance_amount_token >= max_transaction_fee_token, Errors::invalid_argument(EPROLOGUE_CANT_PAY_GAS_DEPOSIT));
            if (!is_stc<TokenType>()){
                let balance_amount_stc= balance<STC>(CoreAddresses::GENESIS_ADDRESS());
                assert!(balance_amount_stc >= max_transaction_fee_stc, Errors::invalid_argument(EPROLOGUE_CANT_PAY_GAS_DEPOSIT));
            }
        };
        // Check that the transaction sequence number matches the sequence number of the account
        assert!(txn_sequence_number >= sender_account.sequence_number, Errors::invalid_argument(EPROLOGUE_SEQUENCE_NUMBER_TOO_OLD));
        assert!(txn_sequence_number == sender_account.sequence_number, Errors::invalid_argument(EPROLOGUE_SEQUENCE_NUMBER_TOO_NEW));

    }


    /// The epilogue is invoked at the end of transactions.
    /// It collects gas and bumps the sequence number
    public fun txn_epilogue<TokenType: store>(
        account: &signer,
        txn_sender: address,
        txn_sequence_number: u64,
        txn_gas_price: u64,
        txn_max_gas_units: u64,
        gas_units_remaining: u64,
    ) acquires Account, Balance {
        txn_epilogue_v2<TokenType>(account, txn_sender, txn_sequence_number, Vector::empty(), txn_gas_price, txn_max_gas_units, gas_units_remaining,1,1)
    }

    spec txn_epilogue {
        pragma verify = false;
    }

    public fun transaction_fee_simulate(
        txn_gas_price:u64,
        txn_max_gas_units: u64,
        gas_units_remaining:u64,
        stc_price: u128,
        stc_price_scaling: u128,
    ): (u128, u128){
        let transaction_fee_stc =(txn_gas_price * (txn_max_gas_units - gas_units_remaining) as u128);
        let transaction_fee_token= Math::mul_div((transaction_fee_stc as u128), stc_price, stc_price_scaling);
        transaction_fee_token = if (transaction_fee_token == 0 && transaction_fee_stc > 0 ) { 1 } else { transaction_fee_token};
        (transaction_fee_stc, transaction_fee_token)
    }

    /// The epilogue is invoked at the end of transactions.
    /// It collects gas and bumps the sequence number
    public fun txn_epilogue_v2<TokenType: store>(
        account: &signer,
        txn_sender: address,
        txn_sequence_number: u64,
        txn_authentication_key_preimage: vector<u8>,
        txn_gas_price: u64,
        txn_max_gas_units: u64,
        gas_units_remaining: u64,
        stc_price: u128,
        stc_price_scaling: u128,
    ) acquires Account, Balance {
        CoreAddresses::assert_genesis_address(account);
        // Charge for gas
        let (transaction_fee_amount_stc,transaction_fee_amount_token) = transaction_fee_simulate(
            txn_gas_price,
            txn_max_gas_units,
            gas_units_remaining,
            stc_price,
            stc_price_scaling);
        assert!(
            balance<TokenType>(txn_sender) >= transaction_fee_amount_token,
            Errors::limit_exceeded(EINSUFFICIENT_BALANCE)
        );
        if (!is_stc<TokenType>()){
            let genesis_balance_amount_stc=balance<STC>(CoreAddresses::GENESIS_ADDRESS());
            assert!(genesis_balance_amount_stc >= transaction_fee_amount_stc,
                Errors::invalid_argument(EPROLOGUE_CANT_PAY_GAS_DEPOSIT)
            );
        };
        // Load the transaction sender's account and balance resources
        let sender_account = borrow_global_mut<Account>(txn_sender);
        // Bump the sequence number
        sender_account.sequence_number = txn_sequence_number + 1;
        // Set auth key when user send transaction first.
        if (is_dummy_auth_key(sender_account) && !Vector::is_empty(&txn_authentication_key_preimage)){
            sender_account.authentication_key = Hash::sha3_256(txn_authentication_key_preimage);
        };
        if (transaction_fee_amount_stc > 0) {
            let transaction_fee_token = withdraw_from_balance(
            borrow_global_mut<Balance<TokenType>>(txn_sender),
                transaction_fee_amount_token
            );
            deposit_to_balance(borrow_global_mut<Balance<TokenType>>(CoreAddresses::GENESIS_ADDRESS()), transaction_fee_token);
            let stc_fee_token = withdraw_from_balance(borrow_global_mut<Balance<STC>>(CoreAddresses::GENESIS_ADDRESS()), transaction_fee_amount_stc);
            TransactionFee::pay_fee(stc_fee_token);
        };
    }

    spec txn_epilogue_v2 {
        pragma verify = false; // Todo: fix me, cost too much time
        aborts_if Signer::address_of(account) != CoreAddresses::GENESIS_ADDRESS();
        aborts_if !exists<Account>(txn_sender);
        aborts_if !exists<Balance<TokenType>>(txn_sender);
        aborts_if txn_sequence_number + 1 > max_u64();
        aborts_if !exists<Balance<TokenType>>(txn_sender);
        aborts_if txn_max_gas_units < gas_units_remaining;
   }

    public(script) fun remove_zero_balance_entry<TokenType: store>(account: signer) acquires Balance {
        remove_zero_balance<TokenType>(&account);
    }

    /// Remove zero Balance
    public fun remove_zero_balance<TokenType: store>(account: &signer) acquires Balance {
        let addr: address = Signer::address_of(account);
        let Balance<TokenType> { token } = move_from<Balance<TokenType>>(addr);
        Token::destroy_zero<TokenType>(token);
    }

    spec remove_zero_balance {
        let addr = Signer::address_of(account);
        aborts_if !exists<Balance<TokenType>>(addr);
        ensures !exists<Balance<TokenType>>(addr);
    }

    /// Make a event store if it's not exist.
    fun make_event_store_if_not_exist(account: &signer) {
        if (!exists<EventStore>(Signer::address_of(account))) {
            move_to(account, EventStore {
              rotate_auth_key_events: Event::new_event_handle<RotateAuthKeyEvent>(account),
              extract_withdraw_cap_events: Event::new_event_handle<ExtractWithdrawCapEvent>(account),
              signer_delegate_events: Event::new_event_handle<SignerDelegateEvent>(account),
            })
        };
    }
}

}
