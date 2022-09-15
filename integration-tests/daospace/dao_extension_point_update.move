//# init -n dev

//# faucet --addr Genesis

//# faucet --addr creator --amount 100000000000

//# faucet --addr bob --amount 2000000000

//# faucet --addr alice --amount 10000000000

//# publish
module creator::TestExtentionPoint {
    use StarcoinFramework::Option;
    use StarcoinFramework::DAOExtensionPoint;

    struct TestExtentionPoint has store, copy, drop {}

    const NAME: vector<u8> = b"TestExtentionPoint";

    public(script) fun initialize(sender: signer) {
        DAOExtensionPoint::register<TestExtentionPoint>(
            &sender,
            NAME, 
            b"ipfs://description",
            b"ipfs://types_d_ts",
            b"ipfs://pb_doc",
            Option::none(),
        );
    }
}

//# run --signers Genesis
script {
    use StarcoinFramework::DAOExtensionPoint;

    fun main(_sender: signer) {
        DAOExtensionPoint::initialize();
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use creator::TestExtentionPoint;

    fun main(sender: signer) {
        TestExtentionPoint::initialize(sender);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use StarcoinFramework::Option;
    use StarcoinFramework::Vector;
    use StarcoinFramework::DAOExtensionPoint;
    use creator::TestExtentionPoint;

    fun main(sender: signer) {
        let labels = Vector::empty<vector<u8>>();
        Vector::push_back<vector<u8>>(&mut labels, b"OS=Starcoin");
        Vector::push_back<vector<u8>>(&mut labels, b"Store=IPFS");

        DAOExtensionPoint::update<TestExtentionPoint::TestExtentionPoint>(&sender,
            b"test", 
            b"ipfs://description2",
            Option::some(labels),
        );
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use StarcoinFramework::Option;
    use StarcoinFramework::Vector;
    use StarcoinFramework::DAOExtensionPoint;
    use creator::TestExtentionPoint;

    fun main(sender: signer) {
        let labels = Vector::empty<vector<u8>>();
        Vector::push_back<vector<u8>>(&mut labels, b"OS=Starcoin");
        Vector::push_back<vector<u8>>(&mut labels, b"Store=IPFS");

        DAOExtensionPoint::update<TestExtentionPoint::TestExtentionPoint>(&sender,
            b"test", 
            b"ipfs://description2",
            Option::some(labels),
        );
    }
}
// check: EXECUTED

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Registry

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Entry<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestExtentionPoint::TestExtentionPoint>
