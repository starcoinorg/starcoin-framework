//# init -n test

//# faucet --addr alice --amount 100000000000000000

//# run --signers alice
script {
use StarcoinFramework::Ring;
fun main() {
    let ring = Ring::create_with_capacity<u64>(5);

    assert!(Ring::capacity<u64>(&ring) == 5, 1001);

    _ = Ring::destroy<u64>( ring );
}
}
