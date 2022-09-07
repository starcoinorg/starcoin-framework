//# init -n dev

//# faucet --addr Genesis

//# faucet --addr creator --amount 100000000000

//# publish
module creator::TestPlugin {
    use StarcoinFramework::DAOPluginMarketplace;

    struct TestPlugin has store, copy, drop {}

    const NAME: vector<u8> = b"TestPlugin";

    /// directly upgrade the sender account to DAOAccount and create DAO
    public(script) fun initialize(sender: signer) {
        DAOPluginMarketplace::register_plugin<TestPlugin>(
            &sender,
            NAME, 
            b"ipfs://description",
        );
    }
}

//# run --signers Genesis
script {
    use StarcoinFramework::DAOPluginMarketplaceScript;

    fun main(_sender: signer) {
        DAOPluginMarketplaceScript::initialize();
    }
}
// check: EXECUTED

//# run --signers creator
script {
    use creator::TestPlugin;
    
    fun main(sender: signer) {
        TestPlugin::initialize(sender);
    }
}
// check: EXECUTED