/// This module provides a number of functions to convert _primitive_ types from their representation in `std::bcs`
/// to values. This is the opposite of `bcs::to_bytes`. Note that it is not safe to define a generic public `from_bytes`
/// function because this can violate implicit struct invariants, therefore only primitive types are offerred. If
/// a general conversion back-and-force is needed, consider the `StarcoinFramework::Any` type which preserves invariants.
///
/// Example:
/// ```
/// use std::bcs;
/// use StarcoinFramework::from_bcs;
///
/// assert!(from_bcs::to_address(bcs::to_bytes(&@0xabcdef)) == @0xabcdef, 0);
/// ```
module StarcoinFramework::FromBCS {
    //use std::string::{Self, String};

    /// UTF8 check failed in conversion from bytes to string
    const EINVALID_UTF8: u64 = 0x1;

    public fun to_bool(v: vector<u8>): bool {
        from_bytes<bool>(v)
    }

    public fun to_u8(v: vector<u8>): u8 {
        from_bytes<u8>(v)
    }

    public fun to_u64(v: vector<u8>): u64 {
        from_bytes<u64>(v)
    }

    public fun to_u128(v: vector<u8>): u128 {
        from_bytes<u128>(v)
    }

    public fun to_address(v: vector<u8>): address {
        from_bytes<address>(v)
    }

    // public fun to_string(v: vector<u8>): vector<u8> {
    //     // To make this safe, we need to evaluate the utf8 invariant.
    //     let s = from_bytes<String>(v);
    //     assert!(string::internal_check_utf8(string::bytes(&s)), EINVALID_UTF8);
    //     s
    // }

    /// Package private native function to deserialize a type T.
    ///
    /// Note that this function does not put any constraint on `T`. If code uses this function to
    /// deserialize a linear value, its their responsibility that the data they deserialize is
    /// owned.
    public(friend) native fun from_bytes<T>(bytes: vector<u8>): T;
    // friend StarcoinFramework::any;
    // friend StarcoinFramework::copyable_any;


    #[test_only]
    use StarcoinFramework::BCS;
    #[test_only]
    use StarcoinFramework::Debug;

    #[test]
    fun test_address() {
        let addr = @0x1;
        //let addr_vec = x"0000000000000000000000000000000000000000000000000000000000000001";
        let addr_vec = x"00000000000000000000000000000001";
        let addr_out = to_address(addr_vec);
        let addr_vec_out = BCS::to_bytes(&addr_out);
        Debug::print(&addr);
        Debug::print(&addr_vec_out);
        assert!(addr == addr_out, 0);
        assert!(addr_vec == addr_vec_out, 1);
    }

    #[test]
    #[expected_failure(abort_code = 0x10001, location = Self)]
    fun test_address_fail() {
        let bad_vec = b"01";
        to_address(bad_vec);
    }
}
