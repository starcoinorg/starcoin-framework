address StarcoinFramework {
/// Utility for converting a Move value to its binary representation in BCS (Diem Canonical
/// Serialization). BCS is the binary encoding for Move resources and other non-module values
/// published on-chain.
module BCS {
    use StarcoinFramework::Vector;

    const EBYTES_LENGTH_NOT_MATCH: u64 = 1;
    const EINCORRECT_VALUE: u64= 2;

    spec module {
        pragma verify;
        pragma aborts_if_is_strict;
    }
    /// Return the binary representation of `v` in BCS (Starcoin Canonical Serialization) format
    native public fun to_bytes<MoveValue: store>(v: &MoveValue): vector<u8>;

    /// Return the address of key bytes
    native public fun to_address(key_bytes: vector<u8>): address;

    // ------------------------------------------------------------------------
    // Decode BCS format bytes to MoveValue
    // ------------------------------------------------------------------------

    /// Deserialize bool
    public fun from_bytes_to_bool(bytes: &vector<u8>): bool {
        check_length(bytes, 1);
        let v = *Vector::borrow(bytes, 0);
        assert!(v == 0 || v == 1, EINCORRECT_VALUE);
        v == 1
    }

    spec from_bytes_to_bool {
        pragma verify = false;
    }

    /// Deserialize u64
    public fun from_bytes_to_u64(bytes: &vector<u8>): u64 {
        check_length(bytes, 8);
        bytes_slice_to_u64(bytes, 0)
    }
    
    spec from_bytes_to_u64 {
        pragma verify = false;
    }

    /// Deserialize u128
    public fun from_bytes_to_u128(bytes: &vector<u8>): u128 {
        check_length(bytes, 16);
        bytes_slice_to_u128(bytes, 0)
    }
    
    spec from_bytes_to_u128 {
        pragma verify = false;
    }

    /// Deserialize bool vector
    public fun from_bytes_to_bool_vec(bytes: &vector<u8>): vector<bool> {
        let (data_len, uleb_encoding_len) = deserialize_uleb128_to_u64(bytes);
        check_length(bytes, data_len * 1 + uleb_encoding_len);

        let value = Vector::empty<bool>();
        let i = 0u64;
        while (i < data_len) {
            let v = *Vector::borrow(bytes, i + uleb_encoding_len);
            assert!(v == 0 || v == 1, EINCORRECT_VALUE);
            Vector::push_back<bool>(&mut value, v == 1);
            i = i + 1;
        };
        value
    }
    spec from_bytes_to_bool_vec {
        pragma verify = false;
    }

    /// Deserialize u8 vector
    public fun from_bytes_to_u8_vec(bytes: &vector<u8>): vector<u8> {
        let (data_len, uleb128_encoding_len) = deserialize_uleb128_to_u64(bytes);
        check_length(bytes, data_len * 1 + uleb128_encoding_len);

        let value = Vector::empty<u8>();
        let i = 0u64;
        while (i < data_len) {
            let v = *Vector::borrow(bytes, i + uleb128_encoding_len);
            Vector::push_back<u8>(&mut value, v);
            i = i + 1;
        };
        value
    }
    spec from_bytes_to_u8_vec {
        pragma verify = false;
    }

    /// Deserialize u64 vector
    public fun from_bytes_to_u64_vec(bytes: &vector<u8>): vector<u64> {
        let (data_len, uleb128_encoding_len) = deserialize_uleb128_to_u64(bytes);
        check_length(bytes, data_len * 8 + uleb128_encoding_len);

        let value = Vector::empty<u64>();
        let i = 0u64;
        while (i < data_len) {
            let offset = i * 8 + uleb128_encoding_len;
            let item = bytes_slice_to_u64(bytes, offset);
            Vector::push_back(&mut value, item);
            i = i + 1;
        };
        value
    }
    spec from_bytes_to_u64_vec {
        pragma verify = false;
    }

    /// Deserialize u128 vector
    public fun from_bytes_to_u128_vec(bytes: &vector<u8>): vector<u128> {
        let (data_len, uleb128_encoding_len) = deserialize_uleb128_to_u64(bytes);
        check_length(bytes, data_len * 16 + uleb128_encoding_len);

        let value = Vector::empty<u128>();
        let i = 0u64;
        while (i < data_len) {
            let offset = i * 16 + uleb128_encoding_len;
            let item = bytes_slice_to_u128(bytes, offset);
            Vector::push_back(&mut value, item);
            i = i + 1;
        };
        value
    }
    spec from_bytes_to_u128_vec {
        pragma verify = false;
    }

    fun bytes_slice_to_u64(bytes: &vector<u8>, offset: u64): u64 {
        let value = 0u64;
        let i = 0u64;
        while (i < 8) {
            value = value | ((*Vector::borrow(bytes, i + offset) as u64) << ((8*i) as u8));
            i = i + 1;
        };
        value
    }
    spec bytes_slice_to_u64 {
        pragma verify = false;
    }

    fun bytes_slice_to_u128(bytes: &vector<u8>, offset: u64): u128 {
        let value = 0u128;
        let i = 0u64;
        while (i < 16) {
            value = value | ((*Vector::borrow(bytes, i + offset) as u128) << ((8*i) as u8));
            i = i + 1;
        };
        value    
    }
    spec bytes_slice_to_u128 {
        pragma verify = false;
    }

    fun check_length(vec: &vector<u8>, expect: u64) {
        let len = Vector::length(vec);
        assert!(len == expect, EBYTES_LENGTH_NOT_MATCH); 
    }

    spec check_length {
        aborts_if Vector::length(vec) != expect;
    }

    /// Return ULEB128 decoding data and ULEB128 encoding length.
    fun deserialize_uleb128_to_u64(bytes: &vector<u8>): (u64, u64) {
        if (Vector::length(bytes) == 0) abort EBYTES_LENGTH_NOT_MATCH;
        let value = 0u64;
        let i = 0u64;
        loop {
            let byte = *Vector::borrow(bytes, i);
            let flag = byte & 0x80;
            let low7bit = byte & 0x7F;
            value = value | ((low7bit as u64) << ((7*i) as u8));
            if (flag != 0) {
                i = i + 1;
            } else {
                break
            }
        };
        (value, i+1)
    }

    spec deserialize_uleb128_to_u64 {
        pragma verify = false;
    }
    // ------------------------------------------------------------------------
    // Specification
    // ------------------------------------------------------------------------

    spec native fun serialize<MoveValue>(v: &MoveValue): vector<u8>;

    // ------------------------------------------------------------------------
    // Test
    // ------------------------------------------------------------------------

    #[test]
    fun test_deserialize_uleb128_to_u64() {
        let a = Vector::empty<u8>();
        Vector::push_back(&mut a, 129);
        Vector::push_back(&mut a, 2);
        let (len, uleb128_encoding_len) = deserialize_uleb128_to_u64(&a);
        assert!(len == 257, 101);
        assert!(uleb128_encoding_len == 2, 102);

        let a = Vector::empty<u8>();
        Vector::push_back(&mut a, 132);
        Vector::push_back(&mut a, 2);
        let (len, uleb128_encoding_len) = deserialize_uleb128_to_u64(&a);
        assert!(len == 260, 101);
        assert!(uleb128_encoding_len == 2, 102);
    }

    #[test]
    fun test_bool() {
        // test bool
        let a = true;
        let bytes = to_bytes(&a);
        let b = from_bytes_to_bool(&bytes);
        assert!(a == b, 101);

        let a = false;
        let bytes = to_bytes(&a);
        let b = from_bytes_to_bool(&bytes);
        assert!(a == b, 101);
    
        // test bool vector
        let a = Vector::empty<bool>();
        let i = 0u64;
        while (i < 200) {
            Vector::push_back<bool>(&mut a, false);
            Vector::push_back<bool>(&mut a, true);
            i = i + 1;
        };
        let bytes = to_bytes(&a);
        let b = from_bytes_to_bool_vec(&bytes);
        assert!(a == b, 104);
    }

    #[test]
    fun test_u64() {
        // test u64
        let a = 231432534u64;
        let bytes = to_bytes(&a);
        let b = from_bytes_to_u64(&bytes);
        assert!(a == b, 102);

        // test u64 vector
        let a = Vector::empty<u64>();
        let i = 0u64;
        let offset = 4294967296u64; // 2e32
        while (i < 1000) {
            Vector::push_back(&mut a, offset + i);
            i = i + 1;
        };
        let bytes = to_bytes(&a);
        let b = from_bytes_to_u64_vec(&bytes);
        assert!(a == b, 106);
    }

    #[test]
    fun test_u128() {
        // test u128
        let a = 436893488147419103232u128;
        let bytes = to_bytes(&a);
        let b = from_bytes_to_u128(&bytes);
        assert!(a == b, 103);

        // test u128 vector
        let a = Vector::empty<u128>();
        let i = 0u64;
        let offset = 18446744073709551616u128; // 2e64
        while (i < 500) {
            Vector::push_back(&mut a, offset + (i as u128));
            i = i + 1;
        };
        let bytes = to_bytes(&a);
        let b = from_bytes_to_u128_vec(&bytes);
        assert!(a == b, 107);
    }

    #[test]
    fun test_u8() {
        // test u8 vector
        let a = Vector::empty<u8>();
        let i = 0u64;
        while (i < 1000) {
            Vector::push_back<u8>(&mut a, ((i % 256) as u8));
            i = i + 1;
        };
        let bytes = to_bytes(&a);
        let b = from_bytes_to_u8_vec(&bytes);
        assert!(a == b, 105);
    }
}
}
