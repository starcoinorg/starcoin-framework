address StarcoinFramework {
module BCSDeserializer {
    use StarcoinFramework::Errors;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Option;
    use StarcoinFramework::BCS;
    //use StarcoinFramework::BitOperators;

    const ERR_INPUT_NOT_LARGE_ENOUGH: u64 = 201;
    const ERR_UNEXPECTED_BOOL_VALUE: u64 = 205;
    const ERR_OVERFLOW_PARSING_ULEB128_ENCODED_UINT32: u64 = 206;
    const ERR_INVALID_ULEB128_NUMBER_UNEXPECTED_ZERO_DIGIT: u64 = 207;
    const INTEGER32_MAX_VALUE: u64 = 2147483647;

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

    public fun deserialize_option_bytes(input: &vector<u8>, offset: u64): (Option::Option<vector<u8>>, u64) {
        let (tag, new_offset) = deserialize_option_tag(input, offset);
        if (!tag) {
            return (Option::none<vector<u8>>(), new_offset)
        } else {
            let (bs, new_offset) = deserialize_bytes(input, new_offset);
            return (Option::some<vector<u8>>(bs), new_offset)
        }
    }

    public fun deserialize_address(input: &vector<u8>, offset: u64): (address, u64) {
        let (content, new_offset) = deserialize_16_bytes(input, offset);
        (BCS::to_address(content), new_offset)
    }

    public fun deserialize_16_bytes(input: &vector<u8>, offset: u64): (vector<u8>, u64) {
        let content = get_n_bytes(input, offset, 16);
        (content, offset + 16)
    }

    public fun deserialize_bytes(input: &vector<u8>, offset: u64): (vector<u8>, u64) {
        let (len, new_offset) = deserialize_len(input, offset);
        let content = get_n_bytes(input, new_offset, len);
        (content, new_offset + len)
    }

    public fun deserialize_u128(input: &vector<u8>, offset: u64): (u128, u64) {
        let u = get_n_bytes_as_u128(input, offset, 16);
        (u, offset + 16)
    }

    public fun deserialize_u64(input: &vector<u8>, offset: u64): (u64, u64) {
        let u = get_n_bytes_as_u128(input, offset, 8);
        ((u as u64), offset + 8)
    }

    public fun deserialize_u32(input: &vector<u8>, offset: u64): (u64, u64) {
        let u = get_n_bytes_as_u128(input, offset, 4);
        ((u as u64), offset + 4)
    }

    public fun deserialize_u16(input: &vector<u8>, offset: u64): (u64, u64) {
        let u = get_n_bytes_as_u128(input, offset, 2);
        ((u as u64), offset + 2)
    }

    public fun deserialize_u8(input: &vector<u8>, offset: u64): (u8, u64) {
        let u = get_byte(input, offset);
        (u, offset + 1)
    }

    public fun deserialize_option_tag(input: &vector<u8>, offset: u64): (bool, u64) {
        deserialize_bool(input, offset)
    }

    public fun deserialize_len(input: &vector<u8>, offset: u64): (u64, u64) {
        deserialize_uleb128_as_u32(input, offset)
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

    fun get_byte(input: &vector<u8>, offset: u64): u8 {
        assert!(((offset + 1) <= Vector::length(input)) && (offset < offset + 1), Errors::invalid_state(ERR_INPUT_NOT_LARGE_ENOUGH));
        *Vector::borrow(input, offset)
    }

    fun get_n_bytes(input: &vector<u8>, offset: u64, n: u64): vector<u8> {
        assert!(((offset + n) <= Vector::length(input)) && (offset < offset + n), Errors::invalid_state(ERR_INPUT_NOT_LARGE_ENOUGH));
        let i = 0;
        let content = Vector::empty<u8>();
        while (i < n) {
            let b = *Vector::borrow(input, offset + i);
            Vector::push_back(&mut content, b);
            i = i + 1;
        };
        content
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
}
}
