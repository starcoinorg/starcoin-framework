//# init -n dev

//# faucet --addr Genesis

//# faucet --addr creator --amount 100000000000

//# faucet --addr bob --amount 2000000000

//# faucet --addr alice --amount 10000000000

//# publish
module creator::TestPlugin {
    use StarcoinFramework::Option;
    use StarcoinFramework::Vector;
    use StarcoinFramework::DAOPluginMarketplace;

    struct TestPlugin has store, drop {}

    const NAME: vector<u8> = b"TestPlugin";

    public(script) fun register(sender: signer) {
        DAOPluginMarketplace::register_plugin<TestPlugin>(
            &sender,
            NAME, 
            b"ipfs://description",
            Option::none(),
        );
    }

    public(script) fun publish_version(sender: signer) {
        let vec = Vector::empty<vector<u8>>();
        Vector::push_back<vector<u8>>(&mut vec, b"test_plugin");

        let witness = TestPlugin{};
        DAOPluginMarketplace::publish_plugin_version<TestPlugin>(
            &sender,
            &witness,
            b"v0.1.0", 
            *&vec, 
            *&vec,
            b"ipfs://js_entry_uri"
        );
    }
}

//# run --signers bob
script {
    use creator::TestPlugin;
    
    fun main(sender: signer) {
        TestPlugin::register(sender);
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use StarcoinFramework::DAOPluginMarketplace;
    use creator::TestPlugin;
    
    fun main(sender: signer) {
        DAOPluginMarketplace::star_plugin<TestPlugin::TestPlugin>(
            &sender,
        );
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use StarcoinFramework::DAOPluginMarketplace;
    use creator::TestPlugin;
    
    fun main(sender: signer) {
        DAOPluginMarketplace::star_plugin<TestPlugin::TestPlugin>(
            &sender,
        );
    }
}
// check: MoveAbort

//# run --signers alice
script {
    use StarcoinFramework::DAOPluginMarketplace;
    use creator::TestPlugin;
    
    fun main(sender: signer) {
        DAOPluginMarketplace::star_plugin<TestPlugin::TestPlugin>(
            &sender,
        );
    }
}
// check: EXECUTED

//# view --address Genesis --resource 0x1::DAOPluginMarketplace::PluginEntry<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestPlugin::TestPlugin>


//# run --signers alice
script {
    use StarcoinFramework::DAOPluginMarketplace;
    use creator::TestPlugin;
    
    fun main(sender: signer) {
        DAOPluginMarketplace::unstar_plugin<TestPlugin::TestPlugin>(
            &sender,
        );
    }
}
// check: EXECUTED

//# view --address Genesis --resource 0x1::DAOPluginMarketplace::PluginEntry<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestPlugin::TestPlugin>

//# run --signers alice
script {
    use StarcoinFramework::DAOPluginMarketplace;
    use creator::TestPlugin;
    
    fun main(sender: signer) {
        DAOPluginMarketplace::unstar_plugin<TestPlugin::TestPlugin>(
            &sender,
        );
    }
}
// check: MoveAbort
