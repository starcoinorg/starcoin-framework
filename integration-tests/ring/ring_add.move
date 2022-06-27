//# init -n test

//# faucet --addr alice --amount 100000000000000000

//# run --signers alice
script {
use StarcoinFramework::Ring;
fun main() {
    let ring = Ring::empty<u64>();

    Ring::add_element<u64>(&mut ring, 0);
    Ring::add_element<u64>(&mut ring, 0);
    Ring::add_element<u64>(&mut ring, 0);
    Ring::add_element<u64>(&mut ring, 0);
    Ring::add_element<u64>(&mut ring, 0);

    assert!(Ring::length<u64>(&ring) == 5, 1001);
}
}
