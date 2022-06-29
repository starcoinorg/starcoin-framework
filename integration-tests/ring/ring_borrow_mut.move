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
    while(i < 5){
        let op_e = Ring::borrow_mut<u64>(&mut ring, i) ;
        if( Option::is_some<u64>(op_e) ){
            Option::swap<u64>( op_e , i);
        }else{
            Option::fill<u64>( op_e , i);
        };
        i = i + 1;
    };

    assert!(*Option::borrow<u64>(Ring::borrow<u64>(&ring, 0)) == 0, 1002);
    assert!(*Option::borrow<u64>(Ring::borrow<u64>(&ring, 1)) == 1, 1003);
    assert!(*Option::borrow<u64>(Ring::borrow<u64>(&ring, 2)) == 2, 1004);
    assert!(*Option::borrow<u64>(Ring::borrow<u64>(&ring, 3)) == 3, 1005);
    assert!(*Option::borrow<u64>(Ring::borrow<u64>(&ring, 4)) == 4, 1006);

    _ = Ring::destroy<u64>( ring );
}
}
