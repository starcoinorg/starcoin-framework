module StarcoinFramework::TypeInfo{
    use StarcoinFramework::Token;

    struct TypeInfo has copy, drop, store{
        account_address: address,
        module_name: vector<u8>,
        struct_name: vector<u8>
    }

    public fun account_address(type_info: &TypeInfo):address{
        type_info.account_address
    }

    public fun module_name(type_info: &TypeInfo):vector<u8>{
        *&type_info.module_name
    }

    public fun struct_name(type_info: &TypeInfo):vector<u8>{
        *&type_info.struct_name
    }

    public fun type_of<T>():TypeInfo{
        let (account_address, module_name, struct_name) = Token::type_of<T>();
        TypeInfo {
            account_address,
            module_name,
            struct_name
        }
    }
}