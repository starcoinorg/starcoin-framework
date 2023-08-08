module StarcoinFramework::GenesisSignerCapability {
    use StarcoinFramework::Account;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Errors;

    friend StarcoinFramework::NFT;
    friend StarcoinFramework::Oracle;
    friend StarcoinFramework::Genesis;
    friend StarcoinFramework::StdlibUpgradeScripts;
    friend StarcoinFramework::EasyGas;

    const ENOT_GENESIS_ACCOUNT: u64 = 11;

    struct GenesisSignerCapability has key {
        cap: Account::SignerCapability,
    }

    public(friend) fun initialize(signer: &signer, cap: Account::SignerCapability) {
        CoreAddresses::assert_genesis_address(signer);
        assert!(
            Account::signer_address(&cap) == CoreAddresses::GENESIS_ADDRESS(), 
            Errors::invalid_argument(ENOT_GENESIS_ACCOUNT)
        );
        move_to(signer, GenesisSignerCapability{cap});
    }

    public(friend) fun get_genesis_signer(): signer acquires GenesisSignerCapability {
        let cap = borrow_global<GenesisSignerCapability>(CoreAddresses::GENESIS_ADDRESS());
        Account::create_signer_with_cap(&cap.cap)
    }
    #[test_only]
    public fun initialize_for_test(signer: &signer, cap: Account::SignerCapability) {
        initialize(signer, cap);
    }
    #[test_only]
    public fun get_genesis_signer_for_test(): signer acquires GenesisSignerCapability {
        get_genesis_signer()
    }
}