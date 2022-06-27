//# init -n test

//# faucet --addr alice --amount 100000000000000000

//# run --signers alice
script {
use StarcoinFramework::Ring;
use StarcoinFramework::Option;

fun main() {
    let ring = Ring::empty<u64>();

    Ring::add_element<u64>(&mut ring, 0);
    Ring::add_element<u64>(&mut ring, 1);
    Ring::add_element<u64>(&mut ring, 2);
    Ring::add_element<u64>(&mut ring, 3);
    Ring::add_element<u64>(&mut ring, 4);

    assert!(Ring::length<u64>(&ring) == 5, 1001);
    assert!(Option::is_none<u64>( &Ring::index_of<u64>(&ring, &10)), 1002 );
    assert!(Option::is_some<u64>( &Ring::index_of<u64>(&ring, &1)), 1003 );
}
}
