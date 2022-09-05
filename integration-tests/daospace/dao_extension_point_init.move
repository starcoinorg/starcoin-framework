//# init -n dev

//# faucet --addr Genesis

//# faucet --addr bob --amount 2000000000

//# run --signers Genesis
script {
    use StarcoinFramework::DAOExtensionPointScript;

    fun main(sender: signer) {
        DAOExtensionPointScript::initialize(sender);
    }
}
// check: EXECUTED

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Registry

//# run --signers Genesis
script {
    use StarcoinFramework::DAOExtensionPointScript;

    fun main(sender: signer) {
        DAOExtensionPointScript::initialize(sender);
    }
}
// check: EXECUTED

//# run --signers bob
script {
    use StarcoinFramework::DAOExtensionPointScript;

    fun main(sender: signer) {
        DAOExtensionPointScript::initialize(sender);
    }
}
// check: EXECUTED

