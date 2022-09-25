module StarcoinFramework::GasOracleProposalPlugin {
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::PriceOracle;
    use StarcoinFramework::InstallPluginProposalPlugin;
    use StarcoinFramework::STCTokenOracle::STCToken;
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::Option;
    use StarcoinFramework::GenesisSignerCapability;

    struct GasOracleProposalPlugin has store, drop {}

    struct OracleCreateAction<phantom TokenType: store> has store {
        precision: u8
    }

    struct OracleDataSourceSelectAction<phantom TokenType: store> has store {
        source_address: address
    }

    struct OracleDataSource<phantom TokenType: store> has copy, store {
        source_address: address
    }

    public fun initialize() {
        let signer = GenesisSignerCapability::get_genesis_signer();

        DAOPluginMarketplace::register_plugin<GasOracleProposalPlugin>(
            &signer,
            b"0x1::GasOraclePlugin",
            b"The plugin for gas oracle.",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();

        let witness = GasOracleProposalPlugin{};
        DAOPluginMarketplace::publish_plugin_version<GasOracleProposalPlugin>(
            &signer,
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

    public(script) fun create_oracle_select_proposal<DAOT: store, TokenType: store>(sender: signer, description: vector<u8>, action_delay: u64, source_address: address) {
        let witness = GasOracleProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, GasOracleProposalPlugin>(&witness);
        let action = OracleDataSourceSelectAction<TokenType>{
            source_address
        };
        DAOSpace::create_proposal(&cap, &sender, action, description, action_delay);
    }

    public(script) fun execute_oracle_select_proposal<DAOT: store, TokenType: store>(sender: signer, proposal_id: u64) {
        let witness = GasOracleProposalPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, GasOracleProposalPlugin>(&witness);
        let OracleDataSourceSelectAction<TokenType>{ source_address } = DAOSpace::execute_proposal<DAOT, GasOracleProposalPlugin, OracleDataSourceSelectAction<TokenType>>(&proposal_cap, &sender, proposal_id);
        let storage_cap = DAOSpace::acquire_storage_cap<DAOT, GasOracleProposalPlugin>(&witness);
        DAOSpace::save(&storage_cap, OracleDataSource<TokenType>{ source_address });
    }

    public fun gas_oracle_read<DAOT: store, TokenType: store>(): u128 {
        let witness = GasOracleProposalPlugin{};
        let storage_cap = DAOSpace::acquire_storage_cap<DAOT, GasOracleProposalPlugin>(&witness);
        let OracleDataSource{ source_address } = DAOSpace::borrow_storage<DAOT, GasOracleProposalPlugin, OracleDataSource<TokenType>>(&storage_cap);
        PriceOracle::read<STCToken<TokenType>>(source_address)
    }

    public fun install_plugin_proposal<DAOT: store>(sender: &signer, description: vector<u8>, action_delay: u64) {
        InstallPluginProposalPlugin::create_proposal<DAOT, GasOracleProposalPlugin>(sender, required_caps(), description, action_delay);
    }

    public(script) fun install_plugin_proposal_entry<DAOT: store>(sender: signer, description: vector<u8>, action_delay: u64) {
        install_plugin_proposal<DAOT>(&sender, description, action_delay);
    }
}