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
    let i = 0;
    while(i < 5){
        *Ring::borrow_mut<u64>(&mut ring, i) = i ;
        i = i + 1;
    };
    assert!(*Ring::borrow<u64>(&ring, 0) == 0, 1002);
    assert!(*Ring::borrow<u64>(&ring, 1) == 1, 1003);
    assert!(*Ring::borrow<u64>(&ring, 2) == 2, 1004);
    assert!(*Ring::borrow<u64>(&ring, 3) == 3, 1005);
    assert!(*Ring::borrow<u64>(&ring, 4) == 4, 1006);
}
}
