//# init -n test

//# faucet --addr alice --amount 100000000000000000

//# run --signers alice
script {
use StarcoinFramework::Ring;
use StarcoinFramework::Option;

fun main() {
    let ring = Ring::create_with_length<u64>(5);

    assert!(Ring::length<u64>(&ring) == 5, 1001);
    let i = 0;
    while(i < 5){
        Ring::push<u64>(&mut ring , i);
        i = i + 1;
    };

    assert!(Option::is_none<u64>( &Ring::index_of<u64>(&ring, &10)), 1002 );    
    assert!(Option::is_some<u64>( &Ring::index_of<u64>(&ring, &1)), 1003 );

    _ = Ring::destroy<u64>( ring );
    
}
}
