//# init -n dev

//# faucet --addr Genesis

//# faucet --addr bob --amount 2000000000

//# view --address Genesis --resource 0x1::DAOExtensionPoint::Registry

//# run --signers Genesis
script {
    use StarcoinFramework::DAOExtensionPoint;

    fun main(_sender: signer) {
        DAOExtensionPoint::initialize();
    }
}
// check: MoveAbort


