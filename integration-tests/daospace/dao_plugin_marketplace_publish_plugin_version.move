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

    struct TestPlugin has store, copy, drop {}

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

        DAOPluginMarketplace::publish_plugin_version<TestPlugin>(
            &sender, 
            b"v0.1.0", 
            *&vec, 
            *&vec,
            b"ipfs://js_entry_uri"
        );
    }
}

//# run --signers Genesis
script {
    use StarcoinFramework::DAOPluginMarketplace;

    fun main(_sender: signer) {
        DAOPluginMarketplace::initialize();
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use creator::TestPlugin;
    
    fun main(sender: signer) {
        TestPlugin::register(sender);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use creator::TestPlugin;
    
    fun main(sender: signer) {
        TestPlugin::publish_version(sender);
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use creator::TestPlugin;
    
    fun main(sender: signer) {
        TestPlugin::publish_version(sender);
    }
}
// check: EXECUTED
