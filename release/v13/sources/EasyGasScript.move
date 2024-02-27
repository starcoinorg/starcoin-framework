address StarcoinFramework {

module EasyGas {
    use StarcoinFramework::Account;
    use StarcoinFramework::Account::{extract_withdraw_capability, withdraw_with_capability, restore_withdraw_capability,
        deposit, SignerCapability
    };
    use StarcoinFramework::Signer::address_of;
    use StarcoinFramework::TypeInfo::{type_of, module_name, account_address, struct_name};
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::GenesisSignerCapability;
    use StarcoinFramework::PriceOracle;
    use StarcoinFramework::Errors;

    const EBAD_TRANSACTION_FEE_TOKEN: u64 = 18;
    struct STCToken<phantom TokenType: store> has copy, store, drop {}

    struct GasTokenEntry has key, store, drop {
        account_address: address,
        module_name: vector<u8>,
        struct_name: vector<u8>,
        data_source: address,
    }

    struct GasFeeAddress has key, store {
        gas_fee_address: address,
        cap: SignerCapability,
    }

    public fun initialize(
        sender: &signer,
        token_account_address: address,
        token_module_name: vector<u8>,
        token_struct_name: vector<u8>,
        data_source: address,
    ) acquires GasTokenEntry {
        register_gas_token(sender, token_account_address, token_module_name, token_struct_name, data_source);
        create_gas_fee_address(sender);
    }

    public fun register_oracle<TokenType: store>(sender: &signer, precision: u8) {
        PriceOracle::register_oracle<STCToken<TokenType>>(sender, precision);
        let genesis_account = GenesisSignerCapability::get_genesis_signer();
        //todo:check gas token entry
        Account::do_accept_token<TokenType>(&genesis_account);
    }

    public fun init_oracle_source<TokenType: store>(sender: &signer, init_value: u128) {
        PriceOracle::init_data_source<STCToken<TokenType>>(sender, init_value);
    }

    public fun update_oracle<TokenType: store>(sender: &signer, value: u128) {
        PriceOracle::update<STCToken<TokenType>>(sender, value);
    }

    public fun get_scaling_factor<TokenType: store>(): u128 {
        PriceOracle::get_scaling_factor<STCToken<TokenType>>()
    }

    public fun gas_oracle_read<TokenType: store>(): u128 acquires GasTokenEntry {
        let data_source = get_data_source_address<TokenType>();
        PriceOracle::read<STCToken<TokenType>>(data_source)
    }


    fun register_gas_token(
        sender: &signer,
        account_address: address,
        module_name: vector<u8>,
        struct_name: vector<u8>,
        data_source: address,
    ) acquires GasTokenEntry {
        CoreAddresses::assert_genesis_address(sender);
        let genesis_account = GenesisSignerCapability::get_genesis_signer();
        let gas_token_entry = GasTokenEntry { account_address, module_name, struct_name, data_source };
        if (exists<GasTokenEntry>(address_of(&genesis_account))) {
            move_from<GasTokenEntry>(address_of(&genesis_account));
        };
        move_to(&genesis_account, gas_token_entry);
    }

    fun get_data_source_address<TokenType: store>(): address acquires GasTokenEntry {
        let token_type_info = type_of<TokenType>();
        let genesis = CoreAddresses::GENESIS_ADDRESS();
        let gas_token_entry = borrow_global<GasTokenEntry>(genesis);
        assert!(module_name(&token_type_info) == *&gas_token_entry.module_name && account_address(
            &token_type_info
        ) == *&gas_token_entry.account_address && struct_name(&token_type_info) == *&gas_token_entry.struct_name, Errors::invalid_argument(EBAD_TRANSACTION_FEE_TOKEN));
        gas_token_entry.data_source
    }

    fun create_gas_fee_address(
        sender: &signer,
    ) {
        CoreAddresses::assert_genesis_address(sender);
        let genesis_account = GenesisSignerCapability::get_genesis_signer();
        let (gas_fee_address, cap) = Account::create_delegate_account(&genesis_account);
        let gas_fee_signer = Account::create_signer_with_cap(&cap);
        Account::set_auto_accept_token(&gas_fee_signer, true);
        let gas_fee_address_entry = GasFeeAddress { gas_fee_address, cap };
        move_to(&genesis_account, gas_fee_address_entry);
    }

    public fun get_gas_fee_address(): address acquires GasFeeAddress {
        let genesis = CoreAddresses::GENESIS_ADDRESS();
        let gas_fee_address_entry = borrow_global<GasFeeAddress>(genesis);

        return gas_fee_address_entry.gas_fee_address
    }

    public fun withdraw_gas_fee<TokenType: store>(_sender: &signer, amount: u128) acquires GasFeeAddress {
        let genesis = CoreAddresses::GENESIS_ADDRESS();
        let gas_fee_address_entry = borrow_global<GasFeeAddress>(genesis);
        let gas_fee_signer = Account::create_signer_with_cap(&gas_fee_address_entry.cap);
        let withdraw_cap = extract_withdraw_capability(&gas_fee_signer);
        let token = withdraw_with_capability<TokenType>(&withdraw_cap, amount);
        restore_withdraw_capability(withdraw_cap);
        deposit(CoreAddresses::ASSOCIATION_ROOT_ADDRESS(), token);
    }
}


module EasyGasScript {
    use StarcoinFramework::TransferScripts::peer_to_peer_v2;
    use StarcoinFramework::EasyGas;

    public entry fun register<TokenType: store>(sender: signer, precision: u8) {
        EasyGas::register_oracle<TokenType>(&sender, precision)
    }

    public entry fun init_data_source<TokenType: store>(sender: signer, init_value: u128) {
        EasyGas::init_oracle_source<TokenType>(&sender, init_value);
    }

    public entry fun update<TokenType: store>(sender: signer, value: u128) {
        EasyGas::update_oracle<TokenType>(&sender, value)
    }

    public entry fun withdraw_gas_fee_entry<TokenType: store>(sender: signer, amount: u128) {
        EasyGas::withdraw_gas_fee<TokenType>(&sender, amount);
    }
    public entry fun deposit<TokenType: store>(sender: signer, amount:u128)  {
        let address = EasyGas::get_gas_fee_address();
        peer_to_peer_v2<TokenType>(sender, address, amount)
    }
}
}
