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

    public(script) fun register(_sender: signer) {
        let witness = TestPlugin{};
        DAOPluginMarketplace::register_plugin<TestPlugin>(
            &witness,
            NAME, 
            b"ipfs://description",
            Option::none(),
        );
    }

    public(script) fun update_plugin(_sender: signer) {
        let labels = Vector::empty<vector<u8>>();
        Vector::push_back<vector<u8>>(&mut labels, b"OS=Starcoin");
        Vector::push_back<vector<u8>>(&mut labels, b"Store=IPFS");

        let witness = TestPlugin{};
        DAOPluginMarketplace::update_plugin<TestPlugin>(
            &witness,
            NAME,
            b"ipfs://description2",
            Option::some(labels),
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

//# view --address Genesis --resource 0x1::DAOPluginMarketplace::PluginEntry<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestPlugin::TestPlugin>

//# run --signers bob
script {
    use creator::TestPlugin;
    
    fun main(sender: signer) {
        TestPlugin::update_plugin(sender);
    }
}
// check: EXECUTED

//# view --address Genesis --resource 0x1::DAOPluginMarketplace::PluginEntry<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestPlugin::TestPlugin>


