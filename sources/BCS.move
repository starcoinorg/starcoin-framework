address StarcoinFramework {
/// Utility for converting a Move value to its binary representation in BCS (Diem Canonical
/// Serialization). BCS is the binary encoding for Move resources and other non-module values
/// published on-chain.
module BCS {

    use StarcoinFramework::Errors;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Option;
    use StarcoinFramework::BCS;

    const ERR_INPUT_NOT_LARGE_ENOUGH: u64 = 201;
    const ERR_UNEXPECTED_BOOL_VALUE: u64 = 205;
    const ERR_OVERFLOW_PARSING_ULEB128_ENCODED_UINT32: u64 = 206;
    const ERR_INVALID_ULEB128_NUMBER_UNEXPECTED_ZERO_DIGIT: u64 = 207;
    const INTEGER32_MAX_VALUE: u64 = 2147483647;

    spec module {
        pragma verify;
        pragma aborts_if_is_strict;
    }
    /// Return the binary representation of `v` in BCS (Starcoin Canonical Serialization) format
    native public fun to_bytes<MoveValue: store>(v: &MoveValue): vector<u8>;

    /// Return the address of key bytes
    native public fun to_address(key_bytes: vector<u8>): address;
    // ------------------------------------------------------------------------
    // Specification
    // ------------------------------------------------------------------------


    spec native fun serialize<MoveValue>(v: &MoveValue): vector<u8>;


    public fun deserialize_option_bytes_vector(input: &vector<u8>, offset: u64): (vector<Option::Option<vector<u8>>>, u64) {
        let (len, new_offset) = deserialize_len(input, offset);
        let i = 0;
        let vec = Vector::empty<Option::Option<vector<u8>>>();
        while (i < len) {
            let (opt_bs, o) = deserialize_option_bytes(input, new_offset);
            Vector::push_back(&mut vec, opt_bs);
            new_offset = o;
            i = i + 1;
        };
        (vec, new_offset)
    }
    spec deserialize_option_bytes_vector {
        pragma verify = false;
    }

    public fun deserialize_option_tuple(input: &vector<u8>, offset: u64): (Option::Option<vector<u8>>, Option::Option<vector<u8>>, u64) {
        let (tag, new_offset) = deserialize_option_tag(input, offset);
        if (!tag) {
            return (Option::none<vector<u8>>(), Option::none<vector<u8>>(), new_offset)
        } else {
            let (bs1, new_offset) = deserialize_bytes(input, new_offset);
            let (bs2, new_offset) = deserialize_bytes(input, new_offset);

            (Option::some<vector<u8>>(bs1), Option::some<vector<u8>>(bs2), new_offset)
        }
    }
    spec deserialize_option_tuple {
        pragma verify = false;
    }

    #[test]
    fun test_deserialize_option_tuple() {
        let tuple_bytes = Vector::empty<u8>();
        let tuple1_bytes = x"01020304";
        let tuple2_bytes = x"05060708";
        let tuple1_bcs = to_bytes(&tuple1_bytes);
        let tuple2_bcs = to_bytes(&tuple2_bytes);
        Vector::append(&mut tuple_bytes, tuple1_bcs);
        Vector::append(&mut tuple_bytes, tuple2_bcs);

        let tuple_option_bcs = Vector::empty<u8>();
        Vector::append(&mut tuple_option_bcs, x"01");
        Vector::append(&mut tuple_option_bcs, tuple_bytes);

        let offset = 0;
        let (tuple1, tuple2, _offset) = deserialize_option_tuple(&tuple_option_bcs, offset);
        let tuple1_option = Option::some(tuple1_bytes);
        let tuple2_option = Option::some(tuple2_bytes);
        assert!(tuple1 == tuple1_option, 999);
        assert!(tuple2 == tuple2_option, 1000);
    }

    public fun deserialize_bytes_vector(input: &vector<u8>, offset: u64): (vector<vector<u8>>, u64) {
        let (len, new_offset) = deserialize_len(input, offset);
        let i = 0;
        let vec = Vector::empty<vector<u8>>();
        while (i < len) {
            let (opt_bs, o) = deserialize_bytes(input, new_offset);
            Vector::push_back(&mut vec, opt_bs);
            new_offset = o;
            i = i + 1;
        };
        (vec, new_offset)
    }

    spec deserialize_bytes_vector {
        pragma verify = false;
    }

    #[test]
    public fun test_deserialize_bytes_array() {
        let hello = b"hello";
        let world = b"world";
        let hello_world = Vector::empty<vector<u8>>();
        Vector::push_back(&mut hello_world, hello);
        Vector::push_back(&mut hello_world, world);
        let bs = BCS::to_bytes<vector<vector<u8>>>(&hello_world);
        let (r, _) =  deserialize_bytes_vector(&bs, 0);
        assert!(hello_world == r, 1001);
    }

    public fun deserialize_u64_vector(input: &vector<u8>, offset: u64): (vector<u64>, u64) {
        let (len, new_offset) = deserialize_len(input, offset);
        let i = 0;
        let vec = Vector::empty<u64>();
        while (i < len) {
            let (opt_bs, o) = deserialize_u64(input, new_offset);
            Vector::push_back(&mut vec, opt_bs);
            new_offset = o;
            i = i + 1;
        };
        (vec, new_offset)
    }

    spec deserialize_u64_vector {
        pragma verify = false;
    }

    public fun deserialize_u128_vector(input: &vector<u8>, offset: u64): (vector<u128>, u64) {
        let (len, new_offset) = deserialize_len(input, offset);
        let i = 0;
        let vec = Vector::empty<u128>();
        while (i < len) {
            let (opt_bs, o) = deserialize_u128(input, new_offset);
            Vector::push_back(&mut vec, opt_bs);
            new_offset = o;
            i = i + 1;
        };
        (vec, new_offset)
    }

    spec deserialize_u128_vector {
        pragma verify = false;
    }

    #[test]
    public fun test_deserialize_u128_array() {
        let hello:u128 = 1111111;
        let world:u128 = 2222222;
        let hello_world = Vector::empty<u128>();
        Vector::push_back(&mut hello_world, hello);
        Vector::push_back(&mut hello_world, world);
        let bs = BCS::to_bytes<vector<u128>>(&hello_world);
        let (r, _) =  deserialize_u128_vector(&bs, 0);
        assert!(hello_world == r, 1002);
    }

    public fun deserialize_option_bytes(input: &vector<u8>, offset: u64): (Option::Option<vector<u8>>, u64) {
        let (tag, new_offset) = deserialize_option_tag(input, offset);
        if (!tag) {
            return (Option::none<vector<u8>>(), new_offset)
        } else {
            let (bs, new_offset) = deserialize_bytes(input, new_offset);
            return (Option::some<vector<u8>>(bs), new_offset)
        }
    }

    spec deserialize_option_bytes {
        pragma verify = false;
    }

    public fun deserialize_address(input: &vector<u8>, offset: u64): (address, u64) {
        let (content, new_offset) = deserialize_16_bytes(input, offset);
        (BCS::to_address(content), new_offset)
    }

    spec deserialize_address {
        pragma verify = false;
    }

    #[test]
    fun test_deserialize_address() {
        let addr = @0x18351d311d32201149a4df2a9fc2db8a;
        let bs = BCS::to_bytes<address>(&addr);
        let (r, offset) =  deserialize_address(&bs, 0);
        assert!(addr == r, 1003);
        assert!(offset == 16, 1004);
    }

    public fun deserialize_16_bytes(input: &vector<u8>, offset: u64): (vector<u8>, u64) {
        let content = get_n_bytes(input, offset, 16);
        (content, offset + 16)
    }

    spec deserialize_16_bytes {
        pragma verify = false;
    }

    public fun deserialize_bytes(input: &vector<u8>, offset: u64): (vector<u8>, u64) {
        let (len, new_offset) = deserialize_len(input, offset);
        let content = get_n_bytes(input, new_offset, len);
        (content, new_offset + len)
    }

    spec deserialize_bytes {
        pragma verify = false;
    }

    #[test]
    public fun test_deserialize_bytes() {
        let hello = b"hello world";
        let bs = BCS::to_bytes<vector<u8>>(&hello);
        let (r, _) =  deserialize_bytes(&bs, 0);
        assert!(hello == r, 1005);
    }

    public fun deserialize_u128(input: &vector<u8>, offset: u64): (u128, u64) {
        let u = get_n_bytes_as_u128(input, offset, 16);
        (u, offset + 16)
    }

    spec deserialize_u128 {
        pragma verify = false;
    }

    #[test]
    fun test_deserialize_u128() {
        let max_int128 = 170141183460469231731687303715884105727;
        let u: u128 = max_int128;
        let bs = BCS::to_bytes<u128>(&u);
        let (r, offset) =  deserialize_u128(&bs, 0);
        assert!(u == r, 1006);
        assert!(offset == 16, 1007);
    }


    public fun deserialize_u64(input: &vector<u8>, offset: u64): (u64, u64) {
        let u = get_n_bytes_as_u128(input, offset, 8);
        ((u as u64), offset + 8)
    }

    spec deserialize_u64 {
        pragma verify = false;
    }

    #[test]
    fun test_deserialize_u64() {
        let u: u64 = 12811111111111;
        let bs = BCS::to_bytes<u64>(&u);
        let (r, offset) =  deserialize_u64(&bs, 0);
        assert!(u == r, 1008);
        assert!(offset == 8, 1009);
    }

    public fun deserialize_u32(input: &vector<u8>, offset: u64): (u64, u64) {
        let u = get_n_bytes_as_u128(input, offset, 4);
        ((u as u64), offset + 4)
    }

    spec deserialize_u32 {
        pragma verify = false;
    }

    #[test]
    fun test_deserialize_u32() {
        let u: u64 = 1281111;
        let bs = BCS::to_bytes<u64>(&u);
        let (r, offset) =  deserialize_u32(&bs, 0);
        _ = r;
        assert!(u == r, 1010);
        assert!(offset == 4, 1011);
    }

    public fun deserialize_u16(input: &vector<u8>, offset: u64): (u64, u64) {
        let u = get_n_bytes_as_u128(input, offset, 2);
        ((u as u64), offset + 2)
    }

    spec deserialize_u16 {
        pragma verify = false;
    }

    public fun deserialize_u8(input: &vector<u8>, offset: u64): (u8, u64) {
        let u = get_byte(input, offset);
        (u, offset + 1)
    }

    spec deserialize_u8 {
        pragma verify = false;
    }

    #[test]
    fun test_deserialize_u8() {
        let u: u8 = 128;
        let bs = BCS::to_bytes<u8>(&u);
        let (r, offset) =  deserialize_u8(&bs, 0);
        assert!(u == r, 1012);
        assert!(offset == 1, 1013);
    }

    public fun deserialize_option_tag(input: &vector<u8>, offset: u64): (bool, u64) {
        deserialize_bool(input, offset)
    }

    spec deserialize_option_tag {
        pragma verify = false;
    }

    public fun deserialize_len(input: &vector<u8>, offset: u64): (u64, u64) {
        deserialize_uleb128_as_u32(input, offset)
    }

    spec deserialize_len {
        pragma verify = false;
    }

    public fun deserialize_bool(input: &vector<u8>, offset: u64): (bool, u64) {
        let b = get_byte(input, offset);
        if (b == 1) {
            return (true, offset + 1)
        } else if (b == 0) {
            return (false, offset + 1)
        } else {
            abort ERR_UNEXPECTED_BOOL_VALUE
        }
    }

    spec deserialize_bool {
        pragma verify = false;
    }

    #[test]
    public fun test_deserialize_bool() {
        let t = true;
        let bs = BCS::to_bytes<bool>(&t);
        let (d, _) =  deserialize_bool(&bs, 0);
        assert!(d, 1014);

        let f = false;
        bs = BCS::to_bytes<bool>(&f);
        (d, _) =  deserialize_bool(&bs, 0);
        assert!(!d, 1015);
    }

    fun get_byte(input: &vector<u8>, offset: u64): u8 {
        assert!(((offset + 1) <= Vector::length(input)) && (offset < offset + 1), Errors::invalid_state(ERR_INPUT_NOT_LARGE_ENOUGH));
        *Vector::borrow(input, offset)
    }

    spec get_byte {
        pragma verify = false;
    }

    fun get_n_bytes(input: &vector<u8>, offset: u64, n: u64): vector<u8> {
        assert!(((offset + n) <= Vector::length(input)) && (offset <= offset + n), Errors::invalid_state(ERR_INPUT_NOT_LARGE_ENOUGH));
        let i = 0;
        let content = Vector::empty<u8>();
        while (i < n) {
            let b = *Vector::borrow(input, offset + i);
            Vector::push_back(&mut content, b);
            i = i + 1;
        };
        content
    }

    spec get_n_bytes {
        pragma verify = false;
    }

    fun get_n_bytes_as_u128(input: &vector<u8>, offset: u64, n: u64): u128 {
        assert!(((offset + n) <= Vector::length(input)) && (offset < offset + n), Errors::invalid_state(ERR_INPUT_NOT_LARGE_ENOUGH));
        let number: u128 = 0;
        let i = 0;
        while (i < n) {
            let byte = *Vector::borrow(input, offset + i);
            let s = (i as u8) * 8;
            number = number + ((byte as u128) << s);
            i = i + 1;
        };
        number
    }

    spec get_n_bytes_as_u128 {
        pragma verify = false;
    }

    public fun deserialize_uleb128_as_u32(input: &vector<u8>, offset: u64): (u64, u64) {
        let value: u64 = 0;
        let shift = 0;
        let new_offset = offset;
        while (shift < 32) {
            let x = get_byte(input, new_offset);
            new_offset = new_offset + 1;
            let digit: u8 = x & 0x7F;
            value = value | (digit as u64) << shift;
            if ((value < 0) || (value > INTEGER32_MAX_VALUE)) {
                abort ERR_OVERFLOW_PARSING_ULEB128_ENCODED_UINT32
            };
            if (digit == x) {
                if (shift > 0 && digit == 0) {
                    abort ERR_INVALID_ULEB128_NUMBER_UNEXPECTED_ZERO_DIGIT
                };
                return (value, new_offset)
            };
            shift = shift + 7
        };
        abort ERR_OVERFLOW_PARSING_ULEB128_ENCODED_UINT32
    }

    spec deserialize_uleb128_as_u32 {
        pragma verify = false;
    }
    
    #[test]
    public fun test_deserialize_uleb128_as_u32() {
        let i: u64 = 0x7F;
        let bs = serialize_u32_as_uleb128(i);
        let (len, _) =  deserialize_uleb128_as_u32(&bs, 0);
        assert!(len == i, 1016);

        let i2: u64 = 0x8F;
        let bs2 = serialize_u32_as_uleb128(i2);
        (len, _) =  deserialize_uleb128_as_u32(&bs2, 0);
        assert!(len == i2, 1017);
    }


    #[test]
    public fun test_deserialize_uleb128_as_u32_max_int() {
        let max_int: u64 = 2147483647;

        let bs = serialize_u32_as_uleb128(max_int);
        let (len, _) =  deserialize_uleb128_as_u32(&bs, 0);
        assert!(len == max_int, 1018);
    }

    #[test]
    #[expected_failure(abort_code = 206)]
    public fun test_deserialize_uleb128_as_u32_exceeded_max_int() {
        let max_int: u64 = 2147483647;
        let exceeded_max_int: u64 = max_int + 1;

        let bs = serialize_u32_as_uleb128(exceeded_max_int);
        let (_, _) =  deserialize_uleb128_as_u32(&bs, 0);
    }


    fun serialize_u32_as_uleb128(value: u64): vector<u8> {
        let output = Vector::empty<u8>();
        while ((value >> 7) != 0) {
            Vector::push_back(&mut output, (((value & 0x7f) | 0x80) as u8));
            value = value >> 7;
        };
        Vector::push_back(&mut output, (value as u8));
        output
    }

    spec serialize_u32_as_uleb128 {
        pragma verify = false;
    }

    // skip Vector<Option::Option<vector<u8>>>
    public fun skip_option_bytes_vector(input: &vector<u8>, offset: u64): u64 {
        let (len, new_offset) = deserialize_len(input, offset);
        let i = 0;
        while (i < len) {
            new_offset = skip_option_bytes(input, new_offset);
            i = i + 1;
        };
        new_offset
    }

    spec skip_option_bytes_vector {
        pragma verify = false;
    }

    #[test]
    fun test_skip_option_bytes_vector(){
        let vec = Vector::empty<Option::Option<vector<u8>>>();
        Vector::push_back(&mut vec, Option::some(x"01020304"));
        Vector::push_back(&mut vec, Option::some(x"04030201"));
        let vec = to_bytes(&vec);
        //vec : [2, 1, 4, 1, 2, 3, 4, 1, 4, 4, 3, 2, 1]
        assert!(skip_option_bytes_vector(&vec, 0) == 13,2000);
    }

    // skip Option::Option<vector<u8>>
    public fun skip_option_bytes(input: &vector<u8>, offset: u64):  u64 {
        let (tag, new_offset) = deserialize_option_tag(input, offset);
        if (!tag) {
            new_offset
        } else {
            skip_bytes(input, new_offset)
        }
    }

    spec skip_option_bytes {
        pragma verify = false;
    }

    #[test]
    fun test_skip_none_option_bytes(){
        let op = Option::none<vector<u8>>();
        let op = to_bytes(&op);
        let vec = to_bytes(&x"01020304");
        Vector::append(&mut op, vec);
        // op : [0, 4, 1, 2, 3, 4] 
        assert!(skip_option_bytes(&op, 0) == 1,2007);
    }

    #[test]
    fun test_skip_some_option_bytes(){
        let op = Option::some(x"01020304");
        let op = to_bytes(&op);
        let vec = to_bytes(&x"01020304");
        Vector::append(&mut op, vec);
        // op : [1, 4, 1, 2, 3, 4, 4, 1, 2, 3, 4]
        assert!(skip_option_bytes(&op, 0) == 6,2008);
    }

    // skip vector<vector<u8>>
    public fun skip_bytes_vector(input: &vector<u8>, offset: u64): u64 {
        let (len, new_offset) = deserialize_len(input, offset);
        let i = 0;
        while (i < len) {
            new_offset = skip_bytes(input, new_offset);
            i = i + 1;
        };
        new_offset
    }

    spec skip_bytes_vector {
        pragma verify = false;
    }

    // skip vector<u8>
    public fun skip_bytes(input: &vector<u8>, offset: u64): u64 {
        let (len, new_offset) = deserialize_len(input, offset);
        new_offset + len
    }

    spec skip_bytes {
        pragma verify = false;
    }

    #[test]
    fun test_skip_bytes(){
        let vec = to_bytes(&x"01020304");
        let u_64 = to_bytes(&10);
        Vector::append(&mut vec, u_64);
        // vec : [4, 1, 2, 3, 4, 10, 0, 0, 0, 0, 0, 0, 0]
        assert!(skip_bytes(&vec, 0) == 5,2001);
    }

    // skip some bytes
    public fun skip_n_bytes(input: &vector<u8>, offset: u64, n:u64): u64 {
        can_skip(input, offset, n );
        offset + n 
    }

    spec skip_n_bytes {
        pragma verify = false;
    }

    #[test]
    fun test_skip_n_bytes(){
        let vec = to_bytes(&x"01020304");
        let u_64 = to_bytes(&10);
        Vector::append(&mut vec, u_64);
        // vec : [4, 1, 2, 3, 4, 10, 0, 0, 0, 0, 0, 0, 0]
        assert!(skip_n_bytes(&vec, 0, 1) == 1,2002);
    }

    // skip vector<u64>
    public fun skip_u64_vector(input: &vector<u8>, offset: u64): u64 {
        let (len, new_offset) = deserialize_len(input, offset);
        can_skip(input, new_offset, len * 8);
        new_offset + len * 8 
    }
    
    spec skip_u64_vector {
        pragma verify = false;
    }

    #[test]
    fun test_skip_u64_vector(){
        let vec = Vector::empty<u64>();
        Vector::push_back(&mut vec, 11111);
        Vector::push_back(&mut vec, 22222);
        let u_64 = to_bytes(&10);
        let vec = to_bytes(&vec);
        Vector::append(&mut vec, u_64);
        // vec : [2, 103, 43, 0, 0, 0, 0, 0, 0, 206, 86, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0]
        assert!(skip_u64_vector(&vec, 0) == 17,2004);
    }

    // skip vector<u128>
    public fun skip_u128_vector(input: &vector<u8>, offset: u64): u64 {
        let (len, new_offset) = deserialize_len(input, offset);
        can_skip(input, new_offset, len * 16);
        new_offset + len * 16 
    }

    spec skip_u128_vector {
        pragma verify = false;
    }

    #[test]
    fun test_skip_u128_vector(){
        let vec = Vector::empty<u128>();
        Vector::push_back(&mut vec, 11111);
        Vector::push_back(&mut vec, 22222);
        let u_64 = to_bytes(&10);
        let vec = to_bytes(&vec);
        Vector::append(&mut vec, u_64);
        // vec : [2, 103, 43, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 206, 86, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0]
        assert!(skip_u128_vector(&vec, 0) == 33,2003);
    }

    // skip u256
    public fun skip_u256(input: &vector<u8>, offset: u64): u64 {
        can_skip(input, offset, 32 );
        offset + 32 
    }

    spec skip_u256 {
        pragma verify = false;
    }

    // skip u128
    public fun skip_u128(input: &vector<u8>, offset: u64): u64 {
        can_skip(input, offset, 16 );
        offset + 16 
    }

    spec skip_u128 {
        pragma verify = false;
    }

    #[test]
    fun test_skip_u128(){
        let u_128:u128 = 100;
        let u_128 = to_bytes(&u_128);
        let vec = to_bytes(&x"01020304");
        Vector::append(&mut u_128, vec);
        // u_128 : [100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1, 2, 3, 4]
        assert!(skip_u128(&u_128, 0) == 16,2005);
    }

    // skip u64
    public fun skip_u64(input: &vector<u8>, offset: u64): u64 {
        can_skip(input, offset, 8 );
        offset + 8 
    }

    spec skip_u64 {
        pragma verify = false;
    }

    #[test]
    fun test_skip_u64(){
        let u_64:u64 = 100;
        let u_64 = to_bytes(&u_64);
        let vec = to_bytes(&x"01020304");
        Vector::append(&mut u_64, vec);
        // u_64 : [100, 0, 0, 0, 0, 0, 0, 0, 4, 1, 2, 3, 4]
        assert!(skip_u64(&u_64, 0) == 8,2006);
    }

    // skip u32
    public fun skip_u32(input: &vector<u8>, offset: u64): u64 {
        can_skip(input, offset, 4 );
        offset + 4 
    }

    spec skip_u32 {
        pragma verify = false;
    }

    // skip u16
    public fun skip_u16(input: &vector<u8>, offset: u64): u64 {
        can_skip(input, offset, 2 );
        offset + 2 
    }

    spec skip_u16 {
        pragma verify = false;
    }

    // skip u8
    public fun skip_u8(input: &vector<u8>, offset: u64): u64 {
        can_skip(input, offset, 1 );
        offset + 1
    }

    spec skip_u8 {
        pragma verify = false;
    }

    // skip address
    public fun skip_address(input: &vector<u8>, offset: u64): u64 {
        skip_n_bytes(input, offset, 16)
    }

    spec skip_address {
        pragma verify = false;
    }

    #[test]
    fun test_address(){
        let addr:address = @0x1;
        let addr = to_bytes(&addr);
        let vec = to_bytes(&x"01020304");
        Vector::append(&mut addr, vec);
        // addr :  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 4, 1, 2, 3, 4]
        assert!(skip_address(&addr, 0) == 16,2006);
    }

    // skip bool
    public fun skip_bool(input: &vector<u8>, offset: u64):  u64{
        can_skip(input, offset, 1);
        offset + 1
    }

    spec skip_bool {
        pragma verify = false;
    }

    fun can_skip(input: &vector<u8>, offset: u64, n: u64){
        assert!(((offset + n) <= Vector::length(input)) && (offset < offset + n), Errors::invalid_state(ERR_INPUT_NOT_LARGE_ENOUGH));
    }

    spec can_skip {
        pragma verify = false;
    }
}
}
