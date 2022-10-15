//# init -n dev

//# faucet --addr Genesis

//# faucet --addr bob --amount 2000000000

//# run --signers Genesis
script {
    use StarcoinFramework::DAOPluginMarketplace;

    fun main(_sender: signer) {
        DAOPluginMarketplace::initialize();
    }
}
// check: Executed

//# run --signers Genesis
script {
    use StarcoinFramework::DAOPluginMarketplace;

    fun main(_sender: signer) {
        DAOPluginMarketplace::initialize();
    }
}
// check: MoveAbort