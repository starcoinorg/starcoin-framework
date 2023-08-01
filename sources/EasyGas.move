address StarcoinFramework {

module EasyGasOracle {
    use StarcoinFramework::Account;
    use StarcoinFramework::Signer::address_of;
    use StarcoinFramework::TypeInfo::{type_of, module_name, account_address, struct_name};
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::GenesisSignerCapability;
    use StarcoinFramework::PriceOracle;

    //friend StarcoinFramework::StdlibUpgradeScripts;

    struct STCToken<phantom TokenType: store> has copy, store, drop {}

    struct GasTokenEntry has key, store, drop {
        account_address: address,
        module_name: vector<u8>,
        struct_name: vector<u8>,
        data_source: address,
    }

    public fun register<TokenType: store>(sender: &signer, precision: u8) {
        PriceOracle::register_oracle<STCToken<TokenType>>(sender, precision);
        let genesis_account = GenesisSignerCapability::get_genesis_signer();
        //todo:check gas token entry
        Account::do_accept_token<TokenType>(&genesis_account);
    }

    public fun init_data_source<TokenType: store>(sender: &signer, init_value: u128) {
        PriceOracle::init_data_source<STCToken<TokenType>>(sender, init_value);
    }

    public fun update<TokenType: store>(sender: &signer, value: u128) {
        PriceOracle::update<STCToken<TokenType>>(sender, value);
    }

    public fun get_scaling_factor<TokenType: store>(): u128 {
        PriceOracle::get_scaling_factor<STCToken<TokenType>>()
    }

    public fun gas_oracle_read<TokenType: store>(): u128 acquires GasTokenEntry {
        let data_source = get_data_source_address<TokenType>();
        PriceOracle::read<STCToken<TokenType>>(data_source)
    }

    //TODO: friend to stdlibupgrade
    public fun register_gas_token_entry(
        _sender: &signer,
        account_address: address,
        module_name: vector<u8>,
        struct_name: vector<u8>,
        data_source: address,
    ) acquires GasTokenEntry {
        let genesis_account = GenesisSignerCapability::get_genesis_signer();
        let gas_token_entry = GasTokenEntry { account_address, module_name, struct_name, data_source };
        if (exists<GasTokenEntry>(address_of(&genesis_account))){
            move_from<GasTokenEntry>(address_of(&genesis_account));
        };
        move_to(&genesis_account, gas_token_entry);
    }

    fun get_data_source_address<TokenType: store>(): address acquires GasTokenEntry {
        let token_type_info = type_of<TokenType>();
        let genesis = CoreAddresses::GENESIS_ADDRESS();
        let gas_token_entry = borrow_global<GasTokenEntry>(genesis);
        //TODO:error code define
        assert!(module_name(&token_type_info) == *&gas_token_entry.module_name && account_address(
            &token_type_info
        ) == *&gas_token_entry.account_address && struct_name(&token_type_info) == *&gas_token_entry.struct_name, 100);
        gas_token_entry.data_source
    }
}

module EasyGasOracleScript {
    use StarcoinFramework::EasyGasOracle;
    public entry fun register<TokenType: store>(sender: signer, precision: u8) {
        EasyGasOracle::register<TokenType>(&sender, precision)
    }

    public entry fun init_data_source<TokenType: store>(sender: signer, init_value: u128) {
        EasyGasOracle::init_data_source<TokenType>(&sender,init_value);
    }

    public entry fun update<TokenType: store>(sender: signer, value: u128) {
        EasyGasOracle::update<TokenType>(&sender,value)
    }
}
}