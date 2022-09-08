//# init -n dev

//# faucet --addr Genesis

//# faucet --addr creator --amount 100000000000

//# faucet --addr bob --amount 2000000000

//# faucet --addr alice --amount 10000000000

//# publish
module creator::TestPlugin {
    use StarcoinFramework::DAOPluginMarketplace;

    struct TestPlugin has store, copy, drop {}

    const NAME: vector<u8> = b"TestPlugin";

    /// directly upgrade the sender account to DAOAccount and create DAO
    public(script) fun register(sender: signer) {
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
        TestPlugin::register(sender);
    }
}
// check: EXECUTED

//# run --signers creator
script {
    use creator::TestPlugin;
    
    fun main(sender: signer) {
        TestPlugin::register(sender);
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


//# publish
module creator::TestPlugin2 {
    use StarcoinFramework::DAOPluginMarketplace;

    struct TestPlugin2 has store, copy, drop {}

    const NAME: vector<u8> = b"TestPlugin2";

    /// directly upgrade the sender account to DAOAccount and create DAO
    public(script) fun register(sender: signer) {
        DAOPluginMarketplace::register_plugin<TestPlugin2>(
            &sender,
            NAME, 
            b"ipfs://description",
        );
    }
}

//# run --signers bob
script {
    use creator::TestPlugin2;
    
    fun main(sender: signer) {
        TestPlugin2::register(sender);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use creator::TestPlugin2;
    
    fun main(sender: signer) {
        TestPlugin2::register(sender);
    }
}
// check: EXECUTED