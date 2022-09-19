module StarcoinFramework::GasTokenOracleProposalPlugin {
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Vector;
    use StarcoinFramework::PriceOracle;
    use StarcoinFramework::InstallPluginProposalPlugin;
    use StarcoinFramework::STCTokenOracle::STCToken;
    struct OracleProposalPlugin has store, drop {}
    
    struct OracleCreateAction<phantom TokenType: store> has store {
        precision: u8
    }

    struct OracleDataSourceSelectAction<phantom TokenType:store> has store {
        source_address: address
    }

    public fun required_caps(): vector<CapType> {
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::storage_cap_type());
        caps
    }

    public(script) fun create_new_oracle_proposal<DAOT: store, TokenType: store>(sender: signer, description: vector<u8>, action_delay: u64, precision: u8) {
        let witness = OracleProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, OracleProposalPlugin>(&witness);
        let action = OracleCreateAction<TokenType>{
            precision
        };
        DAOSpace::create_proposal(&cap, &sender, action, description, action_delay);
    }


    public(script) fun execute_oracle_create_proposal<DAOT: store, TokenType: store>(sender: signer, proposal_id: u64) {
        let witness = OracleProposalPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, OracleProposalPlugin>(&witness);
        let OracleCreateAction<TokenType>{ precision } = DAOSpace::execute_proposal<DAOT, OracleProposalPlugin, OracleCreateAction<TokenType>>(&proposal_cap, &sender, proposal_id);
        PriceOracle::register_oracle<STCToken<TokenType>>(&sender, precision);
    }

    public(script) fun create_oracle_select_proposal<DAOT: store, TokenType:store>(sender: signer, description: vector<u8>, action_delay: u64, source_address: address) {
        let witness = OracleProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, OracleProposalPlugin>(&witness);
        let action = OracleDataSourceSelectAction<TokenType>{
            source_address
        };
        DAOSpace::create_proposal(&cap, &sender, action, description, action_delay);
    }

    public(script) fun execute_oracle_select_proposal<DAOT: store, TokenType: store>(sender: signer, proposal_id: u64) {
        let witness = OracleProposalPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, OracleProposalPlugin>(&witness);
        let OracleDataSourceSelectAction<TokenType>{ source_address } = DAOSpace::execute_proposal<DAOT, OracleProposalPlugin, OracleDataSourceSelectAction<TokenType>>(&proposal_cap, &sender, proposal_id);
        let storage_cap = DAOSpace::acquire_storage_cap<DAOT, OracleProposalPlugin>(&witness);
        let data_source = DAOSpace::oracle_data_source<TokenType>(source_address);
        DAOSpace::save(&storage_cap, data_source);
    }
    
    public fun install_plugin_proposal<DAOT:store>(sender:&signer, description: vector<u8>, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, OracleProposalPlugin>(sender, required_caps(), description, action_delay);
    }

    public (script) fun install_plugin_proposal_entry<DAOT:store>(sender:signer, description: vector<u8>, action_delay:u64){
        install_plugin_proposal<DAOT>(&sender, description, action_delay);
    }

}