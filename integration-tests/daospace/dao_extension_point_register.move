//# init -n dev --debug

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

    fun main(sender: signer) {
        DAOExtensionPointScript::initialize(sender);
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

//# call-api state.list_resource ["0x00000000000000000000000000000001",{"resource_types":["0x00000000000000000000000000000001::DAOExtensionPoint::DAOExtensionPoint"],"decode":true}]

//# view --address Genesis --resource 0x00000000000000000000000000000001::DAOExtensionPoint::DAOExtensionPoint<0x662ba5a1a1da0f1c70a9762c7eeb7aaf::TestExtentionPoint::ExtInfo>

//# run --signers creator
script {
    use creator::TestExtentionPoint;

    fun main(sender: signer) {
        TestExtentionPoint::initialize(sender);
    }
}
// check: EXECUTED