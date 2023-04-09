//# init -n dev --addresses alice=0x14a126fba5d207485edac9e3e0e88ce3

//# faucet --addr alice --amount 1000000000

//# run --signers alice 
script {
    use StarcoinFramework::GasSchedule;

    fun main(_: signer) {
        let _ = GasSchedule::initialize();
    }
}
