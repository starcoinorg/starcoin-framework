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

//# run --signers creator
script {
    use creator::TestExtentionPoint;

    fun main(sender: signer) {
        TestExtentionPoint::initialize(sender);
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use StarcoinFramework::DAOExtensionPoint;
    use creator::TestExtentionPoint;

    fun main(sender: signer) {
        DAOExtensionPoint::star<TestExtentionPoint::TestExtentionPoint>(&sender);
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use StarcoinFramework::DAOExtensionPoint;
    use creator::TestExtentionPoint;

    fun main(sender: signer) {
        DAOExtensionPoint::star<TestExtentionPoint::TestExtentionPoint>(&sender);
    }
}
// check: MoveAbort

//# run --signers alice
script {
    use StarcoinFramework::DAOExtensionPoint;
    use creator::TestExtentionPoint;

    fun main(sender: signer) {
        DAOExtensionPoint::star<TestExtentionPoint::TestExtentionPoint>(&sender);
    }
}
// check: EXECUTED

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Registry

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Entry<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestExtentionPoint::TestExtentionPoint>
