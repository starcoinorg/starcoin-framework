//# init -n dev

//# faucet --addr Genesis

//# faucet --addr creator --amount 100000000000

//# faucet --addr bob --amount 2000000000

//# faucet --addr alice --amount 10000000000

//# publish
module creator::TestPlugin {
    use StarcoinFramework::Option;
    use StarcoinFramework::DAOPluginMarketplace;

    struct TestPlugin has store, copy, drop {}

    const NAME: vector<u8> = b"TestPlugin";

    /// directly upgrade the sender account to DAOAccount and create DAO
    public(script) fun register(sender: signer) {
        DAOPluginMarketplace::register_plugin<TestPlugin>(
            &sender,
            NAME, 
            b"ipfs://description",
            Option::none(),
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
// check: MoveAbort

//# run --signers bob
script {
    use creator::TestPlugin;
    
    fun main(sender: signer) {
        TestPlugin::register(sender);
    }
}
// check: MoveAbort


//# publish
module creator::TestPlugin2 {
    use StarcoinFramework::Option;
    use StarcoinFramework::Vector;
    use StarcoinFramework::DAOPluginMarketplace;

    struct TestPlugin2 has store, copy, drop {}

    const NAME: vector<u8> = b"TestPlugin2";

    /// directly upgrade the sender account to DAOAccount and create DAO
    public(script) fun register(sender: signer) {
        let labels = Vector::empty<vector<u8>>();
        Vector::push_back<vector<u8>>(&mut labels, b"OS=Starcoin");
        Vector::push_back<vector<u8>>(&mut labels, b"Store=IPFS");

        DAOPluginMarketplace::register_plugin<TestPlugin2>(
            &sender,
            NAME, 
            b"ipfs://description",
            Option::some(labels),
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

//# view --address Genesis --resource 0x1::DAOPluginMarketplace::PluginEntry<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestPlugin2::TestPlugin2>

//# run --signers alice
script {
    use creator::TestPlugin2;
    
    fun main(sender: signer) {
        TestPlugin2::register(sender);
    }
}
// check: MoveAbort