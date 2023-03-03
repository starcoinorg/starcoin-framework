address StarcoinFramework {
/// Helper module to do u64 arith.
module Arith {
    use StarcoinFramework::Errors;
    const ERR_INVALID_CARRY:  u64 = 301;
    const ERR_INVALID_BORROW: u64 = 302;

    const P32: u64 = 0x100000000;
    const P64: u128 = 0x10000000000000000;

    spec module {
        pragma verify = true;
        pragma aborts_if_is_strict;
    }

    /// split u64 to (high, low)
    public fun split_u64(i: u64): (u64, u64) {
        (i >> 32, i & 0xFFFFFFFF)
    }

    spec split_u64 {
        pragma opaque; // MVP cannot reason about bitwise operation
        ensures result_1 == i / P32;
        ensures result_2 == i % P32;
    }

    /// combine (high, low) to u64,
    /// any lower bits of `high` will be erased, any higher bits of `low` will be erased.
    public fun combine_u64(hi: u64, lo: u64): u64 {
        (hi << 32) | (lo & 0xFFFFFFFF)
    }

    spec combine_u64 {
        pragma opaque; // MVP cannot reason about bitwise operation
        let hi_32 = hi % P32;
        let lo_32 = lo % P32;
        ensures result == hi_32 * P32 + lo_32;
    }

    /// a + b, with carry
    public fun adc(a: u64, b: u64, carry: &mut u64) : u64 {
        assert!(*carry <= 1, Errors::invalid_argument(ERR_INVALID_CARRY));
        let (a1, a0) = split_u64(a);
        let (b1, b0) = split_u64(b);
        let (c, r0) = split_u64(a0 + b0 + *carry);
        let (c, r1) = split_u64(a1 + b1 + c);
        *carry = c;
        combine_u64(r1, r0)
    }

    spec adc {
        // Carry has either to be 0 or 1
        aborts_if !(carry == 0 || carry == 1);
        ensures carry == 0 || carry == 1;
        // Result with or without carry
        ensures carry == 0 ==> result == a + b + old(carry);
        ensures carry == 1 ==> P64 + result == a + b + old(carry);
    }

    /// a - b, with borrow
    public fun sbb(a: u64, b: u64, borrow: &mut u64): u64 {
        assert!(*borrow <= 1, Errors::invalid_argument(ERR_INVALID_BORROW));
        let (a1, a0) = split_u64(a);
        let (b1, b0) = split_u64(b);
        let (b, r0) = split_u64(P32 + a0 - b0 - *borrow);
        let borrowed = 1 - b;
        let (b, r1) = split_u64(P32 + a1 - b1 - borrowed);
        *borrow = 1 - b;

        combine_u64(r1, r0)
    }

    spec sbb {
        // Borrow has either to be 0 or 1
        aborts_if !(borrow == 0 || borrow == 1);
        ensures borrow == 0 || borrow == 1;
        // Result with or without borrow
        ensures borrow == 0 ==> result == a - b - old(borrow);
        ensures borrow == 1 ==> result == P64 + a - b - old(borrow);
    }
}

/// Implementation u256.
module U256 {

    spec module {
        pragma verify = true;
    }

    use StarcoinFramework::Vector;
    use StarcoinFramework::Errors;

    const WORD: u8 = 4;
    const P32: u64 = 0x100000000;
    const P64: u128 = 0x10000000000000000;

    const ERR_INVALID_LENGTH: u64 = 100;
    const ERR_OVERFLOW: u64 = 200;
    /// use vector to represent data.
    /// so that we can use buildin vector ops later to construct U256.
    /// vector should always has two elements.
    struct U256 has copy, drop, store {
        /// little endian representation
        bits: vector<u64>,
    }

    spec U256 {
        invariant len(bits) == 4;
    }

    spec fun value_of_U256(a: U256): num {
        a.bits[0] + 
        a.bits[1] * P64 + 
        a.bits[2] * P64 * P64 + 
        a.bits[3] * P64 * P64 * P64
    }

    public fun zero(): U256 {
        from_u128(0u128)
    }

    public fun one(): U256 {
        from_u128(1u128)
    }

    public fun from_u64(v: u64): U256 {
        from_u128((v as u128))
    }

    public fun from_u128(v: u128): U256 {
        let low = ((v & 0xffffffffffffffff) as u64);
        let high = ((v >> 64) as u64);
        let bits = Vector::singleton(low);
        Vector::push_back(&mut bits, high);
        Vector::push_back(&mut bits, 0u64);
        Vector::push_back(&mut bits, 0u64);
        U256 { bits }
    }

    spec from_u128 {
        pragma opaque; // Original function has bitwise operator
        ensures value_of_U256(result) == v;
    }

    #[test]
    fun test_from_u128() {
        // 2^64 + 1
        let v = from_u128(18446744073709551617u128);
        assert!(*Vector::borrow(&v.bits, 0) == 1, 0);
        assert!(*Vector::borrow(&v.bits, 1) == 1, 1);
        assert!(*Vector::borrow(&v.bits, 2) == 0, 2);
        assert!(*Vector::borrow(&v.bits, 3) == 0, 3);
    }

    public fun from_big_endian(data: vector<u8>): U256 {
        // TODO: define error code.
        assert!(Vector::length(&data) <= 32, Errors::invalid_argument(ERR_INVALID_LENGTH));
        from_bytes(&data, true)
    }

    spec from_big_endian {
        pragma verify = false; // TODO: How to interpret the value of vector data of bytes
    }

    public fun from_little_endian(data: vector<u8>): U256 {
        // TODO: define error code.
        assert!(Vector::length(&data) <= 32, Errors::invalid_argument(ERR_INVALID_LENGTH));
        from_bytes(&data, false)
    }

    spec from_little_endian {
        pragma verify = false; // TODO: How to interpret the value of vector data of bytes
    }

    public fun to_u128(v: &U256): u128 {
        assert!(*Vector::borrow(&v.bits, 3) == 0, Errors::invalid_state(ERR_OVERFLOW));
        assert!(*Vector::borrow(&v.bits, 2) == 0, Errors::invalid_state(ERR_OVERFLOW));
        ((*Vector::borrow(&v.bits, 1) as u128) << 64) | (*Vector::borrow(&v.bits, 0) as u128)
    }

    spec to_u128 {
        pragma opaque; // Original function has bitwise operator
        aborts_if value_of_U256(v) >= P64 * P64;
        ensures value_of_U256(v) == result;
    }

    #[test]
    fun test_to_u128() {
        // 2^^128 - 1
        let i = 340282366920938463463374607431768211455u128;
        let v = from_u128(i);
        assert!(to_u128(&v) == i, 128);
    }
    #[test]
    #[expected_failure]
    fun test_to_u128_overflow() {
        // 2^^128 - 1
        let i = 340282366920938463463374607431768211455u128;
        let v = from_u128(i);
        let v = add(v, one());
        to_u128(&v);
    }

    const EQUAL: u8 = 0;
    const LESS_THAN: u8 = 1;
    const GREATER_THAN: u8 = 2;

    public fun compare(a: &U256, b: &U256): u8 {
        let i = (WORD as u64);
        while (i > 0) {
            i = i - 1;
            let a_bits = *Vector::borrow(&a.bits, i);
            let b_bits = *Vector::borrow(&b.bits, i);
            if (a_bits != b_bits) {
                if (a_bits < b_bits) {
                    return LESS_THAN
                } else {
                    return GREATER_THAN
                }
            }
        };
        return EQUAL
    }

    // TODO: MVP interprets it wrong
    // spec compare {
    //     let va = value_of_U256(a);
    //     let vb = value_of_U256(b);
    //     ensures (va > vb) ==> (result == GREATER_THAN);
    //     ensures (va < vb) ==> (result == LESS_THAN);
    //     ensures (va == vb) ==> (result == EQUAL);
    // }

    #[test]
    fun test_compare() {
        let a = from_u64(111);
        let b = from_u64(111);
        let c = from_u64(112);
        let d = from_u64(110);
        assert!(compare(&a, &b) == EQUAL, 0);
        assert!(compare(&a, &c) == LESS_THAN, 1);
        assert!(compare(&a, &d) == GREATER_THAN, 2);
    }


    public fun add(a: U256, b: U256): U256 {
        native_add(&mut a, &b);
        a
    }

    spec add {
        aborts_if value_of_U256(a) + value_of_U256(b) >= P64 * P64 * P64 * P64;
        ensures value_of_U256(result) == value_of_U256(a) + value_of_U256(b);
    }

    #[test]
    fun test_add() {
        let a = Self::one();
        let b = Self::from_u128(10);
        let ret = Self::add(a, b);
        assert!(compare(&ret, &from_u64(11)) == EQUAL, 0);
    }

    public fun sub(a: U256, b: U256): U256 {
        native_sub(&mut a, &b);
        a
    }

    spec sub {
        aborts_if value_of_U256(a) < value_of_U256(b);
        ensures value_of_U256(result) == value_of_U256(a) - value_of_U256(b);
    }

    #[test]
    #[expected_failure]
    fun test_sub_overflow() {
        let a = Self::one();
        let b = Self::from_u128(10);
        let _ = Self::sub(a, b);
    }

    #[test]
    fun test_sub_ok() {
        let a = Self::from_u128(10);
        let b = Self::one();
        let ret = Self::sub(a, b);
        assert!(compare(&ret, &from_u64(9)) == EQUAL, 0);
    }

    public fun mul(a: U256, b: U256): U256 {
        native_mul(&mut a, &b);
        a
    }

    spec mul {
        pragma verify = false;
        pragma timeout = 200; // Take longer time
        aborts_if value_of_U256(a) * value_of_U256(b) >= P64 * P64 * P64 * P64;
        ensures value_of_U256(result) == value_of_U256(a) * value_of_U256(b);
    }

    #[test]
    fun test_mul() {
        let a = Self::from_u128(10);
        let b = Self::from_u64(10);
        let ret = Self::mul(a, b);
        assert!(compare(&ret, &from_u64(100)) == EQUAL, 0);
    }

    public fun div(a: U256, b: U256): U256 {
        native_div(&mut a, &b);
        a
    }

    spec div {
        pragma verify = false;
        pragma timeout = 160; // Might take longer time
        aborts_if value_of_U256(b) == 0;
        ensures value_of_U256(result) == value_of_U256(a) / value_of_U256(b);
    }

    #[test]
    fun test_div() {
        let a = Self::from_u128(10);
        let b = Self::from_u64(2);
        let c = Self::from_u64(3);
        // as U256 cannot be implicitly copied, we need to add copy keyword.
        assert!(compare(&Self::div(copy a, b), &from_u64(5)) == EQUAL, 0);
        assert!(compare(&Self::div(copy a, c), &from_u64(3)) == EQUAL, 0);
    }

    public fun rem(a: U256, b: U256): U256 {
        native_rem(&mut a, &b);
        a
    }

    spec rem {
        pragma verify = false;
        pragma timeout = 160; // Might take longer time
        aborts_if value_of_U256(b) == 0;
        ensures value_of_U256(result) == value_of_U256(a) % value_of_U256(b);
    }

    #[test]
    fun test_rem() {
        let a = Self::from_u128(10);
        let b = Self::from_u64(2);
        let c = Self::from_u64(3);
        assert!(compare(&Self::rem(copy a, b), &from_u64(0)) == EQUAL, 0);
        assert!(compare(&Self::rem(copy a, c), &from_u64(1)) == EQUAL, 0);
    }

    public fun pow(a: U256, b: U256): U256 {
        native_pow(&mut a, &b);
        a
    }

    spec pow {
        // Verfication of Pow takes enormous amount of time
        // Don't verify it, and make it opaque so that the caller
        // can make use of the properties listed here.
        pragma verify = false;
        pragma opaque;
        pragma timeout = 600;
        let p = pow_spec(value_of_U256(a), value_of_U256(b));
        aborts_if p >= P64 * P64 * P64 * P64;
        ensures value_of_U256(result) == p;
    }

    #[test]
    fun test_pow() {
        let a = Self::from_u128(10);
        let b = Self::from_u64(1);
        let c = Self::from_u64(2);
        let d = Self::zero();
        assert!(compare(&Self::pow(copy a, b), &from_u64(10)) == EQUAL, 0);
        assert!(compare(&Self::pow(copy a, c), &from_u64(100)) == EQUAL, 0);
        assert!(compare(&Self::pow(copy a, d), &from_u64(1)) == EQUAL, 0);
    }

    /// move implementation of native_add.
    fun add_nocarry(a: &mut U256, b: &U256) {
        let carry = 0;
        let idx = 0;
        let len = (WORD as u64);
        while (idx < len) {
            let a_bit = Vector::borrow_mut(&mut a.bits, idx);
            let b_bit = Vector::borrow(&b.bits, idx);
            *a_bit = StarcoinFramework::Arith::adc(*a_bit, *b_bit, &mut carry);
            idx = idx + 1;
        };

        // check overflow
        assert!(carry == 0, 100);
    }

    // TODO: MVP find false examples that violate the spec
    // spec add_nocarry {
    //     aborts_if value_of_U256(a) + value_of_U256(b) >= P64 * P64 * P64 * P64;
    //     ensures value_of_U256(a) == value_of_U256(old(a)) + value_of_U256(b);
    // }

    #[test]
    #[expected_failure]
    fun test_add_nocarry_overflow() {
        let va = Vector::empty();
        Vector::push_back(&mut va, 15891);
        Vector::push_back(&mut va, 0);
        Vector::push_back(&mut va, 0);
        Vector::push_back(&mut va, 0);

        let vb = Vector::empty();
        Vector::push_back(&mut vb, 18446744073709535725);
        Vector::push_back(&mut vb, 18446744073709551615);
        Vector::push_back(&mut vb, 18446744073709551615);
        Vector::push_back(&mut vb, 18446744073709551615);

        let a = U256 { bits: va };
        let b = U256 { bits: vb };
        add_nocarry(&mut a, &b); // MVP thinks this won't abort
    }

    #[test]
    fun test_add_nocarry_like_native_1() {
        let va = Vector::empty();
        Vector::push_back(&mut va, 15891);
        Vector::push_back(&mut va, 0);
        Vector::push_back(&mut va, 0);
        Vector::push_back(&mut va, 0);

        let vb = Vector::empty();
        Vector::push_back(&mut vb, 18446744073709535724);
        Vector::push_back(&mut vb, 18446744073709551615);
        Vector::push_back(&mut vb, 18446744073709551615);
        Vector::push_back(&mut vb, 18446744073709551615);

        let a1 = U256 { bits: va };
        let a2 = copy a1;
        let b = U256 { bits: vb };
        add_nocarry(&mut a1, &b);
        native_add(&mut a2, &b);
        assert!(compare(&a1, &a2) == EQUAL, 0); // MVP thinks this doesn't hold
    }

    #[test]
    fun test_add_nocarry_like_native_2() {
        let va = Vector::empty();
        Vector::push_back(&mut va, 26962);
        Vector::push_back(&mut va, 24464);
        Vector::push_back(&mut va, 6334);
        Vector::push_back(&mut va, 19169);

        let vb = Vector::empty();
        Vector::push_back(&mut vb, 29358);
        Vector::push_back(&mut vb, 26500);
        Vector::push_back(&mut vb, 15724);
        Vector::push_back(&mut vb, 11478);

        let a1 = U256 { bits: va };
        let a2 = copy a1;
        let b = U256 { bits: vb };
        add_nocarry(&mut a1, &b); // MVP thinks this abort
        native_add(&mut a2, &b);
        assert!(compare(&a1, &a2) == EQUAL, 0);
    }

    /// move implementation of native_sub.
    fun sub_noborrow(a: &mut U256, b: &U256) {
        let borrow = 0;
        let idx = 0;
        let len = (WORD as u64);
        while (idx < len) {
            let a_bit = Vector::borrow_mut(&mut a.bits, idx);
            let b_bit = Vector::borrow(&b.bits, idx);
            *a_bit = StarcoinFramework::Arith::sbb(*a_bit, *b_bit, &mut borrow);
            idx = idx + 1;
        };

        // check overflow
        assert!(borrow == 0, 100);

    }

    // TODO: Similar situation with `add_nocarry`
    // spec sub_noborrow {
    //     aborts_if value_of_U256(a) < value_of_U256(b);
    //     ensures value_of_U256(a) == value_of_U256(old(a)) - value_of_U256(b);
    // }

    native fun from_bytes(data: &vector<u8>, be: bool): U256;
    native fun native_add(a: &mut U256, b: &U256);
    native fun native_sub(a: &mut U256, b: &U256);
    native fun native_mul(a: &mut U256, b: &U256);
    native fun native_div(a: &mut U256, b: &U256);
    native fun native_rem(a: &mut U256, b: &U256);
    native fun native_pow(a: &mut U256, b: &U256);

    spec native_add { 
        pragma opaque;
        aborts_if value_of_U256(a) + value_of_U256(b) >= P64 * P64 * P64 * P64;
        ensures value_of_U256(a) == value_of_U256(old(a)) + value_of_U256(b);
    }

    spec native_sub {
        pragma opaque;
        aborts_if value_of_U256(a) - value_of_U256(b) < 0;
        ensures value_of_U256(a) == value_of_U256(old(a)) - value_of_U256(b);
    }

    spec native_mul {
        pragma opaque;
        aborts_if value_of_U256(a) * value_of_U256(b) >= P64 * P64 * P64 * P64;
        ensures value_of_U256(a) == value_of_U256(old(a)) * value_of_U256(b);
    }

    spec native_div {
        pragma opaque;
        aborts_if value_of_U256(b) == 0;
        ensures value_of_U256(a) == value_of_U256(old(a)) / value_of_U256(b);
    }

    spec native_rem {
        pragma opaque;
        aborts_if value_of_U256(b) == 0;
        ensures value_of_U256(a) == value_of_U256(old(a)) % value_of_U256(b);
    }

    spec native_pow {
        pragma opaque;
        aborts_if pow_spec(value_of_U256(a), value_of_U256(b)) >= P64 * P64 * P64 * P64;
        ensures value_of_U256(a) == pow_spec(value_of_U256(old(a)), value_of_U256(b));
    }

    spec fun pow_spec(base: num, expon: num): num {
        // This actually doesn't follow a strict definition as 0^0 is undefined
        // mathematically. But the U256::pow of Rust is defined to be like this:
        // Link: https://docs.rs/uint/0.9.3/src/uint/uint.rs.html#1000-1003
        if (expon > 0) {
            let x = pow_spec(base, expon / 2);
            if (expon % 2 == 0) { x * x } else { x * x * base }
        } else { 
            1 
        }
    }

}
}
