module StarcoinFramework::TypeInfo {
    use StarcoinFramework::BCS;
    use StarcoinFramework::Token;
    use StarcoinFramework::Vector;

    struct TypeInfo has copy, drop, store {
        account_address: address,
        module_name: vector<u8>,
        struct_name: vector<u8>
    }

    public fun account_address(type_info: &TypeInfo): address {
        type_info.account_address
    }

    public fun module_name(type_info: &TypeInfo): vector<u8> {
        *&type_info.module_name
    }

    public fun struct_name(type_info: &TypeInfo): vector<u8> {
        *&type_info.struct_name
    }

    public fun type_of<T>(): TypeInfo {
        let (account_address, module_name, struct_name) = Token::type_of<T>();
        TypeInfo {
            account_address,
            module_name,
            struct_name
        }
    }

    /// Return the BCS size, in bytes, of value at `val_ref`.
    ///
    /// See the [BCS spec](https://github.com/diem/bcs)
    ///
    /// See `test_size_of_val()` for an analysis of common types and
    /// nesting patterns, as well as `test_size_of_val_vectors()` for an
    /// analysis of vector size dynamism.
    public fun size_of_val<T: store>(val_ref: &T): u64 {
        // Return vector length of vectorized BCS representation.
        Vector::length(&BCS::to_bytes<T>(val_ref))
    }
}