//# init -n dev

//# faucet --addr Genesis

//# faucet --addr creator --amount 100000000000

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

    public(script) fun publish_version_v1(sender: signer) {
        DAOExtensionPoint::publish_version<TestExtentionPoint>(
            &sender,
            b"ipfs://types_d_ts_1",
            b"ipfs://pb_doc1",
        );
    }

    public(script) fun publish_version_v2(sender: signer) {
        DAOExtensionPoint::publish_version<TestExtentionPoint>(
            &sender,
            b"ipfs://types_d_ts_2",
            b"ipfs://dts_doc2",
        );
    }
}

//# run --signers Genesis
script {
    use StarcoinFramework::DAOExtensionPointScript;

    fun main(_sender: signer) {
        DAOExtensionPointScript::initialize();
    }
}
// check: EXECUTED

//# run --signers creator
script {
    use creator::TestExtentionPoint;

    fun main(sender: signer) {
        TestExtentionPoint::initialize(sender);
    }
}
// check: EXECUTED

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Registry

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Entry<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestExtentionPoint::TestExtentionPoint>

//# run --signers creator
script {
    use creator::TestExtentionPoint;

    fun main(sender: signer) {
        TestExtentionPoint::publish_version_v1(sender);
    }
}
// check: EXECUTED

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Registry

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Entry<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestExtentionPoint::TestExtentionPoint>

//# run --signers creator
script {
    use creator::TestExtentionPoint;

    fun main(sender: signer) {
        TestExtentionPoint::publish_version_v2(sender);
    }
}
// check: EXECUTED

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Registry

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Entry<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestExtentionPoint::TestExtentionPoint>

//# run --signers creator
script {
    use creator::TestExtentionPoint;

    fun main(sender: signer) {
        TestExtentionPoint::publish_version_v2(sender);
    }
}
// check: EXECUTED

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Registry

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Entry<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestExtentionPoint::TestExtentionPoint>
