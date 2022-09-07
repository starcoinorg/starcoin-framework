//# init -n dev

//# faucet --addr Genesis

//# faucet --addr creator --amount 100000000000

//# publish
module creator::TestExtentionPoint {
    use StarcoinFramework::DAOExtensionPoint;

    struct ExtInfo has store, copy, drop {}

    const NAME: vector<u8> = b"TestExtentionPoint";

    /// directly upgrade the sender account to DAOAccount and create DAO
    public(script) fun initialize(sender: signer) {
        let extInfo = ExtInfo{};
        DAOExtensionPoint::register<ExtInfo>(
            &sender,
            NAME, 
            b"ipfs://description",
            b"ipfs://protobuf",
            b"ipfs://pb_doc",
            extInfo,
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
        TestExtentionPoint::initialize(sender);
    }
}
// check: EXECUTED

//# view --address Genesis --resource 0x1::DAOExtensionPoint::DAOExtensionPoint<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestExtentionPoint::ExtInfo>
