address StarcoinFramework {
module MultiPluginsDao {

    use StarcoinFramework::GeneralDaoBasisTemplate;
    use StarcoinFramework::GenenralDaoPluginSendToken;
    use StarcoinFramework::STC::STC;
    use StarcoinFramework::Token;

    struct SendTokenType has store, copy, drop {}

    public(script) fun genesis_dao(signer: signer) {
        GeneralDaoBasisTemplate::genesis_dao<SendTokenType>(&signer, 0, 0, 0, 0);
    }

    public(script) fun create_dao(signer: signer, genesis_broker: address, name: vector<u8>) {
        // add plugins
        GeneralDaoBasisTemplate::bind_plugin_name_with_type<
            SendTokenType,
            GenenralDaoPluginSendToken::Plugin<SendTokenType, STC>>(
            &signer,
            genesis_broker,
            &GenenralDaoPluginSendToken::plugin_name());

        GeneralDaoBasisTemplate::create_dao<SendTokenType>(&signer, genesis_broker, &name);
    }

    public(script) fun propose(signer: signer, dao_broker: address, action_delay: u64) {
        // add plugins
        GeneralDaoBasisTemplate::add_plugin_data<SendTokenType, GenenralDaoPluginSendToken::Plugin<SendTokenType, STC>>(
            &signer, dao_broker, GenenralDaoPluginSendToken::create_plugin<SendTokenType, STC>(@0x1, Token::zero<STC>()));

        GeneralDaoBasisTemplate::propose<SendTokenType>(&signer, dao_broker, action_delay);
    }

    public(script) fun execute_plugin_action(proposal_broker: address,
                                             proposal_id: u64) {
        // add plugins
        let plugin_data = GeneralDaoBasisTemplate::extract_plugin<
            SendTokenType,
            GenenralDaoPluginSendToken::Plugin<SendTokenType, STC>>(
            proposal_broker,
            proposal_id,
        );
        GenenralDaoPluginSendToken::execute(plugin_data);
    }
}
}
