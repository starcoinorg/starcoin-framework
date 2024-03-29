address StarcoinFramework {

/// Contains functions for [ed25519](https://en.wikipedia.org/wiki/EdDSA) digital signatures.
module Signature {

    use StarcoinFramework::Vector;
    use StarcoinFramework::Option::{Self, Option};
    use StarcoinFramework::EVMAddress::{Self, EVMAddress};

    native public fun ed25519_validate_pubkey(public_key: vector<u8>): bool;
    native public fun ed25519_verify(signature: vector<u8>, public_key: vector<u8>, message: vector<u8>): bool;

    /// recover address from ECDSA signature, if recover fail, return an empty vector<u8>
    native fun native_ecrecover(hash: vector<u8>, signature: vector<u8>): vector<u8>;

    /// recover address from ECDSA signature, if recover fail, return None
    public fun ecrecover(hash: vector<u8>, signature: vector<u8>):Option<EVMAddress>{
        let bytes = native_ecrecover(hash, signature);
        if (Vector::is_empty(&bytes)){
            Option::none<EVMAddress>()
        }else{
            Option::some(EVMAddress::new(bytes))
        }
    }

    // verify eth secp256k1 sign and compare addr, if add equal return true
    public fun secp256k1_verify(signature: vector<u8>, addr: vector<u8>, message: vector<u8>) : bool{
      let receover_address_opt:Option<EVMAddress>  = ecrecover(message, signature);
      let expect_address =  EVMAddress::new(addr);
      &Option::destroy_some<EVMAddress>(receover_address_opt) == &expect_address
   } 

    spec module {
        pragma intrinsic = true;
    }

    #[test]
    fun test_ecrecover_invalid(){
        let h = b"00";
        let s = b"00";
        let addr = ecrecover(h, s);
        assert!(Option::is_none(&addr), 1001);
    }
}

module EVMAddress{

    spec module {
        pragma verify;
        pragma aborts_if_is_strict;
    }

    use StarcoinFramework::Vector;

    const EVM_ADDR_LENGTH:u64 = 20;

    struct EVMAddress has copy, store, drop{
        bytes: vector<u8>,
    }

    /// Create EVMAddress from bytes, If bytes is larger than EVM_ADDR_LENGTH(20), bytes will be cropped from the left.
    /// keep same as https://github.com/ethereum/go-ethereum/blob/master/common/types.go#L302
    public fun new(bytes: vector<u8>): EVMAddress{
        let len = Vector::length(&bytes);
        let bytes = if (len > EVM_ADDR_LENGTH){
            let new_bytes = Vector::empty<u8>();
            let i = 0;
            while (i < EVM_ADDR_LENGTH) {
                Vector::push_back(&mut new_bytes, *Vector::borrow(&bytes, i));
                i = i + 1;
            };
            new_bytes
        }else if (len == EVM_ADDR_LENGTH){
            bytes
        }else{
            let i = 0;
            let new_bytes = Vector::empty<u8>();
            while (i < EVM_ADDR_LENGTH - len) {
                // pad zero to address
                Vector::push_back(&mut new_bytes, 0);
                i = i + 1;
            };
            Vector::append(&mut new_bytes, bytes);
            new_bytes
        };
        EVMAddress{
            bytes
        }
    }

    spec new {
        pragma verify = false;
        //TODO
    }

    /// Get the inner bytes of the `addr` as a reference
    public fun as_bytes(addr: &EVMAddress): &vector<u8> {
        &addr.bytes
    }

    spec as_bytes {
        pragma verify = false;
        //TODO
    }

    /// Unpack the `addr` to get its backing bytes
    public fun into_bytes(addr: EVMAddress): vector<u8> {
        let EVMAddress { bytes } = addr;
        bytes
    }

    spec into_bytes {
        pragma verify = false;
        //TODO
    }

    #[test]
    fun test_evm_address_padding(){
        let addr1 = new(x"00");
        let addr2 = new(x"0000");
        assert!(&addr1.bytes == &addr2.bytes, 1001);
    }

    #[test]
    fun test_evm_address_crop(){
        let addr1 = new(x"01234567890123456789012345678901234567891111");
        let addr2 = new(x"01234567890123456789012345678901234567892222");
        assert!(&addr1.bytes == &addr2.bytes, 1001);
    }
}
}
