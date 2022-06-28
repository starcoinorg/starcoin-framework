//# init -n test

//# faucet --addr alice --amount 100000000000000000

//# run --signers alice
script {
use StarcoinFramework::Ring;
fun main() {
    let ring = Ring::create_with_length<u64>(5);

    assert!(Ring::length<u64>(&ring) == 5, 1001);

    _ = Ring::destroy<u64>( ring );
}
}
