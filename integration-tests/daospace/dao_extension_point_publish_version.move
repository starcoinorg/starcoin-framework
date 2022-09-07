//# init -n dev

//# faucet --addr Genesis

//# faucet --addr creator --amount 100000000000

//# publish
module creator::TestExtentionPoint {
    use StarcoinFramework::DAOExtensionPoint;

    struct ExtInfo has store, copy, drop {
        tags: vector<u8>,
    }

    const NAME: vector<u8> = b"TestExtentionPoint";

    public(script) fun initialize(sender: signer) {
        let extInfo = ExtInfo{
            tags: b"Test",
        };

        DAOExtensionPoint::register<ExtInfo>(
            &sender,
            NAME, 
            b"ipfs://description",
            b"ipfs://protobuf",
            b"ipfs://pb_doc",
            extInfo,
        );
    }

    public(script) fun publish_version_v1(sender: signer) {
        DAOExtensionPoint::publish_version<ExtInfo>(
            &sender,
            1,
            b"ipfs://protobuf1",
            b"ipfs://pb_doc1",
        );
    }

    public(script) fun publish_version_v2(sender: signer) {
        DAOExtensionPoint::publish_version<ExtInfo>(
            &sender,
            1,
            b"ipfs://protobuf2",
            b"ipfs://pb_doc2",
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

//# view --address Genesis --resource 0x1::DAOExtensionPoint::DAOExtensionPoint<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestExtentionPoint::ExtInfo>

//# run --signers creator
script {
    use creator::TestExtentionPoint;

    fun main(sender: signer) {
        TestExtentionPoint::publish_version_v1(sender);
    }
}
// check: EXECUTED

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Registry

//# view --address Genesis --resource 0x1::DAOExtensionPoint::DAOExtensionPoint<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestExtentionPoint::ExtInfo>

//# run --signers creator
script {
    use creator::TestExtentionPoint;

    fun main(sender: signer) {
        TestExtentionPoint::publish_version_v2(sender);
    }
}
// check: EXECUTED

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Registry

//# view --address Genesis --resource 0x1::DAOExtensionPoint::DAOExtensionPoint<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestExtentionPoint::ExtInfo>

//# run --signers creator
script {
    use creator::TestExtentionPoint;

    fun main(sender: signer) {
        TestExtentionPoint::publish_version_v2(sender);
    }
}
// check: EXECUTED

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Registry

//# view --address Genesis --resource 0x1::DAOExtensionPoint::DAOExtensionPoint<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestExtentionPoint::ExtInfo>
