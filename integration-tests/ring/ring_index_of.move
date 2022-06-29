//# init -n test

//# faucet --addr alice --amount 100000000000000000

//# run --signers alice
script {
use StarcoinFramework::Ring;
use StarcoinFramework::Option;

fun main() {
    let ring = Ring::create_with_capacity<u64>(5);

    assert!(Ring::capacity<u64>(&ring) == 5, 1001);
    let i = 0;
    while(i < 10){
        Ring::push<u64>(&mut ring , i + 1);
        i = i + 1;
    };

    assert!(Option::is_none<u64>( &Ring::index_of<u64>(&ring, &11)), 1002 );    
    assert!(*Option::borrow<u64>( &Ring::index_of<u64>(&ring, &10)) == 9, 1003 );
    assert!(*Option::borrow<u64>( Ring::borrow<u64>(&ring, 9)) == 10 , 1004);

    _ = Ring::destroy<u64>( ring );
    
}
}
