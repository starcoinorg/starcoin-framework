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
    // Ring : [6, 7, 8, 9, 10]
    // index:  5, 6, 7, 8, 9
    assert!(Option::is_none<u64>( &Ring::index_of<u64>(&ring, &20))  , 1002 );  

    assert!(*Option::borrow<u64>( &Ring::index_of<u64>(&ring, &6)) == 5, 1003 );
    assert!(*Option::borrow<u64>( &Ring::index_of<u64>(&ring, &7)) == 6, 1004 );
    assert!(*Option::borrow<u64>( &Ring::index_of<u64>(&ring, &8)) == 7, 1005 );  
    assert!(*Option::borrow<u64>( &Ring::index_of<u64>(&ring, &9)) == 8, 1006 );
    assert!(*Option::borrow<u64>( &Ring::index_of<u64>(&ring, &10)) == 9, 1007 );

    _ = Ring::destroy<u64>( ring );
    
}
}
//check Executed

//# run --signers alice
script {
use StarcoinFramework::Ring;
use StarcoinFramework::Option;

fun find_and_use_index() {
    let ring = Ring::create_with_capacity<u64>(5);

    assert!(Ring::capacity<u64>(&ring) == 5, 1001);
    let i = 0;
    while(i < 10){
        Ring::push<u64>(&mut ring , i + 1);
        i = i + 1;
    };

    // Ring : [6, 7, 8, 9, 10]
    // index:  5, 6, 7, 8, 9
    assert!(*Option::borrow<u64>( &Ring::index_of<u64>(&ring, &6)) == 5, 1003 );
    assert!(*Option::borrow<u64>( &Ring::index_of<u64>(&ring, &7)) == 6, 1004 );
    assert!(*Option::borrow<u64>( &Ring::index_of<u64>(&ring, &8)) == 7, 1005 );  
    assert!(*Option::borrow<u64>( &Ring::index_of<u64>(&ring, &9)) == 8, 1006 );
    assert!(*Option::borrow<u64>( &Ring::index_of<u64>(&ring, &10)) == 9, 1007 );

    assert!(*Option::borrow<u64>( Ring::borrow<u64>(&ring, 5)) == 6 , 1010);
    assert!(*Option::borrow<u64>( Ring::borrow<u64>(&ring, 6)) == 7 , 1011);
    assert!(*Option::borrow<u64>( Ring::borrow<u64>(&ring, 7)) == 8 , 1012);
    assert!(*Option::borrow<u64>( Ring::borrow<u64>(&ring, 8)) == 9 , 1013);
    assert!(*Option::borrow<u64>( Ring::borrow<u64>(&ring, 9)) == 10 , 1014);

    _ = Ring::destroy<u64>( ring );
    
}
}
//check Executed


//# run --signers alice
script {
use StarcoinFramework::Ring;
use StarcoinFramework::Option;

fun exceed_the_lower_limit() {
    let ring = Ring::create_with_capacity<u64>(5);

    assert!(Ring::capacity<u64>(&ring) == 5, 1001);
    let i = 0;
    while(i < 10){
        Ring::push<u64>(&mut ring , i + 1);
        i = i + 1;
    };

    // Ring : [6, 7, 8, 9, 10]
    // index:  5, 6, 7, 8, 9
    *Option::borrow<u64>( Ring::borrow<u64>(&ring, 4));
    _ = Ring::destroy<u64>( ring );
    
}
}
//check MoveAbort 25863


//# run --signers alice
script {
use StarcoinFramework::Ring;
use StarcoinFramework::Option;

fun exceed_the_upper_limit() {
    let ring = Ring::create_with_capacity<u64>(5);

    assert!(Ring::capacity<u64>(&ring) == 5, 1001);
    let i = 0;
    while(i < 10){
        Ring::push<u64>(&mut ring , i + 1);
        i = i + 1;
    };

    // Ring : [6, 7, 8, 9, 10]
    // index:  5, 6, 7, 8, 9
    *Option::borrow<u64>( Ring::borrow<u64>(&ring, 10));
    _ = Ring::destroy<u64>( ring );
    
}
}
//check MoveAbort 25863