module StarcoinFramework::GasOracleProposalPlugin {
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::InstallPluginProposalPlugin;
    use StarcoinFramework::GasOracle::STCToken;
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::Option;
    use StarcoinFramework::GenesisSignerCapability;
    use StarcoinFramework::Errors;
    use StarcoinFramework::PriceOracleAggregator;
    use StarcoinFramework::Account;

    const ERR_PLUGIN_ORACLE_EXIST: u64 = 1001;
    const ERR_PLUGIN_ORACLE_NOT_EXIST: u64 = 1002;

    const ORACLE_UPDATED_IN: u64 = 600000;

    struct GasOracleProposalPlugin has store, drop {}

    struct OracleCreateAction<phantom TokenType: store> has store {
        precision: u8
    }

    struct OracleSourceAddAction<phantom TokenType: store> has store, drop {
        source_address: address
    }

    struct OracleSourceRemoveAction<phantom TokenType: store> has store, drop {
        source_address: address
    }

    struct OracleSources<phantom TokenType: store> has copy, store {
        source_addresses: vector<address>
    }

    public fun initialize(_sender: &signer) {
        let witness = GasOracleProposalPlugin{};

        DAOPluginMarketplace::register_plugin<GasOracleProposalPlugin>(
            &witness,
            b"0x1::GasOraclePlugin",
            b"The plugin for gas oracle.",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();
        
        DAOPluginMarketplace::publish_plugin_version<GasOracleProposalPlugin>(
            &witness,
            b"v0.1.0",
            *&implement_extpoints,
            *&depend_extpoints,
            b"inner-plugin://gas-oracle-plugin",
        );
    }

    public fun required_caps(): vector<CapType> {
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::storage_cap_type());
        caps
    }

    public(script) fun create_oracle_add_proposal<DAOT: store, TokenType: store>(sender: signer, title:vector<u8>, introduction:vector<u8>, description: vector<u8>, action_delay: u64, source_address: address) {
        let witness = GasOracleProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, GasOracleProposalPlugin>(&witness);
        let action = OracleSourceAddAction<TokenType>{
            source_address
        };
        DAOSpace::create_proposal(&cap, &sender, action, title, introduction, description, action_delay);
    }

    public(script) fun execute_oracle_add_proposal<DAOT: store, TokenType: store>(sender: signer, proposal_id: u64) {
        let witness = GasOracleProposalPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, GasOracleProposalPlugin>(&witness);
        let OracleSourceAddAction<TokenType>{ source_address } = DAOSpace::execute_proposal<DAOT, GasOracleProposalPlugin, OracleSourceAddAction<TokenType>>(&proposal_cap, &sender, proposal_id);
        let storage_cap = DAOSpace::acquire_storage_cap<DAOT, GasOracleProposalPlugin>(&witness);
        let source_addresses = if (!DAOSpace::exists_storage<DAOT, GasOracleProposalPlugin, OracleSources<TokenType>>()) {
            let genesis_singer= GenesisSignerCapability::get_genesis_signer();
            Account::accept_token<TokenType>(genesis_singer);
            Vector::singleton(source_address)
        }else {
            let OracleSources<TokenType>{ source_addresses } = DAOSpace::take<DAOT, GasOracleProposalPlugin, OracleSources<TokenType>>(&storage_cap);
            assert!(Vector::contains(&source_addresses, &source_address) == false, Errors::invalid_state(ERR_PLUGIN_ORACLE_EXIST));
            Vector::push_back(&mut source_addresses, source_address);
            source_addresses
        };

        DAOSpace::save(&storage_cap, OracleSources<TokenType>{ source_addresses });
    }

    public(script) fun create_oracle_remove_proposal<DAOT: store, TokenType: store>(sender: signer, title:vector<u8>, introduction:vector<u8>, description: vector<u8>, action_delay: u64, source_address: address) {
        let witness = GasOracleProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, GasOracleProposalPlugin>(&witness);
        let action = OracleSourceRemoveAction<TokenType>{
            source_address
        };
        DAOSpace::create_proposal(&cap, &sender, action, title, introduction, description, action_delay);
    }

    public(script) fun execute_oracle_remove_proposal<DAOT: store, TokenType: store>(sender: signer, proposal_id: u64) {
        let witness = GasOracleProposalPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, GasOracleProposalPlugin>(&witness);
        let OracleSourceRemoveAction<TokenType>{ source_address } = DAOSpace::execute_proposal<DAOT, GasOracleProposalPlugin, OracleSourceRemoveAction<TokenType>>(&proposal_cap, &sender, proposal_id);
        let storage_cap = DAOSpace::acquire_storage_cap<DAOT, GasOracleProposalPlugin>(&witness);
        assert!(DAOSpace::exists_storage<DAOT, GasOracleProposalPlugin, OracleSources<TokenType>>(), ERR_PLUGIN_ORACLE_NOT_EXIST);
        let OracleSources<TokenType>{ source_addresses } = DAOSpace::take<DAOT, GasOracleProposalPlugin, OracleSources<TokenType>>(&storage_cap);
        let (exist,index)= Vector::index_of(&source_addresses, &source_address);
        assert!(exist, Errors::invalid_state(ERR_PLUGIN_ORACLE_NOT_EXIST));
        Vector::remove(&mut source_addresses,index);
        DAOSpace::save(&storage_cap, OracleSources<TokenType>{ source_addresses });
    }

    public fun gas_oracle_read<DAOT: store, TokenType: store>(): u128 {
        let witness = GasOracleProposalPlugin{};
        let storage_cap = DAOSpace::acquire_storage_cap<DAOT, GasOracleProposalPlugin>(&witness);
        let OracleSources{ source_addresses } = DAOSpace::borrow_storage<DAOT, GasOracleProposalPlugin, OracleSources<TokenType>>(&storage_cap);
        PriceOracleAggregator::latest_price_average_aggregator<STCToken<TokenType>>(&source_addresses, ORACLE_UPDATED_IN)
    }

    public fun install_plugin_proposal<DAOT: store>(sender: &signer, title:vector<u8>, introduction:vector<u8>, description: vector<u8>, action_delay: u64) {
        InstallPluginProposalPlugin::create_proposal<DAOT, GasOracleProposalPlugin>(sender, required_caps(), title, introduction, description, action_delay);
    }

    public(script) fun install_plugin_proposal_entry<DAOT: store>(sender: signer, title:vector<u8>, introduction:vector<u8>, description: vector<u8>, action_delay: u64) {
        install_plugin_proposal<DAOT>(&sender, title, introduction, description, action_delay);
    }
}