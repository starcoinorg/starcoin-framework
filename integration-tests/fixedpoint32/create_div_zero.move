//# init -n dev

//# faucet --addr alice --amount 100000000000000000

//# run --signers alice
script {
use StarcoinFramework::FixedPoint32;

fun main() {
    // A denominator of zero should cause an arithmetic error.
    let f1 = FixedPoint32::create_from_rational(2, 0);
    // The above should fail at runtime so that the following assertion
    // is never even tested.
    assert!(FixedPoint32::get_raw_value(f1) == 999, 1);
}
}
// check: "Keep(ABORTED { code: 25863"
