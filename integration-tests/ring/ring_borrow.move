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
    assert!(*Ring::borrow<u64>(&ring, 0) == 0, 1002);
    assert!(*Ring::borrow<u64>(&ring, 1) == 0, 1003);
    assert!(*Ring::borrow<u64>(&ring, 2) == 0, 1004);
    assert!(*Ring::borrow<u64>(&ring, 3) == 0, 1005);
    assert!(*Ring::borrow<u64>(&ring, 4) == 0, 1006);
}
}
