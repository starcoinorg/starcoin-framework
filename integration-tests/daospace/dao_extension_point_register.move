//# init -n dev

//# faucet --addr Genesis

//# faucet --addr creator --amount 100000000000

//# publish
module creator::TestExtentionPoint {
    use StarcoinFramework::Option;
    use StarcoinFramework::Vector;
    use StarcoinFramework::DAOExtensionPoint;

    struct TestExtentionPoint has store, copy, drop {}

    const NAME: vector<u8> = b"TestExtentionPoint";

    public(script) fun initialize(sender: signer) {
        let labels = Vector::empty<vector<u8>>();
        Vector::push_back<vector<u8>>(&mut labels, b"OS=Starcoin");
        Vector::push_back<vector<u8>>(&mut labels, b"Store=IPFS");

        DAOExtensionPoint::register<TestExtentionPoint>(
            &sender,
            NAME, 
            b"ipfs://description",
            b"ipfs://types_d_ts",
            b"ipfs://dts_doc",
            Option::some(labels),
        );
    }

    public(script) fun initialize_with_long_text(sender: signer) {
        let labels = Vector::empty<vector<u8>>();
        Vector::push_back<vector<u8>>(&mut labels, b"OS=Starcoin");
        Vector::push_back<vector<u8>>(&mut labels, b"Store=IPFS");

        DAOExtensionPoint::register<TestExtentionPoint>(
            &sender,
            b"0123456789012345678901234567890123456789012345678901234567890123456789", 
            b"ipfs://description",
            b"ipfs://types_d_ts",
            b"ipfs://dts_doc",
            Option::some(labels),
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
        TestExtentionPoint::initialize(sender);
    }
}
// check: MoveAbort

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Entry<{{$.faucet[1].txn.raw_txn.decoded_payload.ScriptFunction.args[0]}}::TestExtentionPoint::TestExtentionPoint>

//# publish
module creator::TestExtentionPoint2 {
    use StarcoinFramework::Option;
    use StarcoinFramework::Vector;
    use StarcoinFramework::DAOExtensionPoint;

    struct TestExtentionPoint2 has store, copy, drop {}

    const NAME: vector<u8> = b"TestExtentionPoint2";

    public(script) fun initialize_with_long_text(sender: signer) {
        let labels = Vector::empty<vector<u8>>();
        Vector::push_back<vector<u8>>(&mut labels, b"OS=Starcoin");
        Vector::push_back<vector<u8>>(&mut labels, b"Store=IPFS");

        DAOExtensionPoint::register<TestExtentionPoint2>(
            &sender,
            b"0123456789012345678901234567890123456789012345678901234567890123456789", 
            b"ipfs://description",
            b"ipfs://types_d_ts",
            b"ipfs://dts_doc",
            Option::some(labels),
        );
    }
}

//# run --signers creator
script {
    use creator::TestExtentionPoint2;

    fun main(sender: signer) {
        TestExtentionPoint2::initialize_with_long_text(sender);
    }
}
// check: MoveAbort


//# publish
module creator::TestExtentionPoint3 {
    use StarcoinFramework::Option;
    use StarcoinFramework::Vector;
    use StarcoinFramework::DAOExtensionPoint;

    struct TestExtentionPoint3 has store, copy, drop {}

    const NAME: vector<u8> = b"TestExtentionPoint3";

    public(script) fun initialize_with_long_text(sender: signer) {
        let labels = Vector::empty<vector<u8>>();
        Vector::push_back<vector<u8>>(&mut labels, b"OS=Starcoin");
        Vector::push_back<vector<u8>>(&mut labels, b"Store=ipfs://0123456789012345678901234567890123456789012345678901234567890123456789");

        DAOExtensionPoint::register<TestExtentionPoint3>(
            &sender,
            b"XXXX",
            b"ipfs://description",
            b"ipfs://types_d_ts",
            b"ipfs://dts_doc",
            Option::some(labels),
        );
    }
}

//# run --signers creator
script {
    use creator::TestExtentionPoint3;

    fun main(sender: signer) {
        TestExtentionPoint3::initialize_with_long_text(sender);
    }
}
// check: MoveAbort
