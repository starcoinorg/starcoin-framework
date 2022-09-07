//# init -n dev

//# faucet --addr Genesis

//# faucet --addr bob --amount 2000000000

//# run --signers Genesis
script {
    use StarcoinFramework::DAOPluginMarketplaceScript;

    fun main(_sender: signer) {
        DAOPluginMarketplaceScript::initialize();
    }
}
// check: EXECUTED

//# run --signers Genesis
script {
    use StarcoinFramework::DAOPluginMarketplaceScript;

    fun main(_sender: signer) {
        DAOPluginMarketplaceScript::initialize();
    }
}
// check: EXECUTED