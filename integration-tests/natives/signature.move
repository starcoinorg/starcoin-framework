//# init -n dev

//# faucet --addr creator

//# run --signers creator
// Test fot public key validation

script {
use StarcoinFramework::Signature;

fun main() {

    // from RFC 8032
    let valid_pubkey =  x"3d4017c3e843895a92b70aa74d1b7ebc9c982ccf2ec4968cc0cd55f12af4660c";
    let short_pubkey = x"0100";
    // concatenation of the two above
    let long_pubkey = x"01003d4017c3e843895a92b70aa74d1b7ebc9c982ccf2ec4968cc0cd55f12af4660c";
    let invalid_pubkey = x"0000000000000000000000000000000000000000000000000000000000000000";

    assert!(Signature::ed25519_validate_pubkey(valid_pubkey), 9003);
    assert!(!Signature::ed25519_validate_pubkey(short_pubkey), 9003);
    assert!(!Signature::ed25519_validate_pubkey(long_pubkey), 9003);
    assert!(!Signature::ed25519_validate_pubkey(invalid_pubkey), 9003);
}
}


//# run --signers creator
// Test fot signature verify
// use command `starcoin account sign-message --message abc` to generate signature.
script {
    use StarcoinFramework::Signature;
    use StarcoinFramework::Hash;
    use StarcoinFramework::Vector;
    use StarcoinFramework::BCS;

    fun main() {

        let public_key =  x"a7c56b0c7111a7068cbd5f8c841a3d01eed480cfc14806e43e7a1da71e2945f0";
        let message = b"abc";
        let signature = x"c46ad802f389f7e17631b28668e51565fa59b80c34b44719791c4f541b586239896fd470d64c6eff1bdfadab9861e193042dbafd8f23fda670530cce4f199f0d";
        let prefix = b"STARCOIN::";
        Vector::append(&mut prefix, b"SigningMessage");
        let prefix_hash = Hash::sha3_256(prefix);
        let data = copy prefix_hash;
        Vector::append(&mut data, BCS::to_bytes(&message));
        assert!(Signature::ed25519_verify(signature, public_key, data), 9004);
    }

}

//# run --signers creator

// test ecrecover
script {
    use StarcoinFramework::Signature;
    use StarcoinFramework::EVMAddress::{Self, EVMAddress};
    use StarcoinFramework::Option::{Self, Option};

    fun main() {
        //test success
        let signature = x"90a938f7457df6e8f741264c32697fc52f9a8f867c52dd70713d9d2d472f2e415d9c94148991bbe1f4a1818d1dff09165782749c877f5cf1eff4ef126e55714d1c";
        let msg_hash = x"b453bd4e271eed985cbab8231da609c4ce0a9cf1f763b6c1594e76315510e0f1";
        let address_bytes = x"29c76e6ad8f28bb1004902578fb108c507be341b";
        let expect_address =  EVMAddress::new(address_bytes);
        let receover_address_opt:Option<EVMAddress> = Signature::ecrecover(copy msg_hash, copy signature);
        assert!(Option::is_some<EVMAddress>(&receover_address_opt), 1000);
        assert!(&Option::destroy_some<EVMAddress>(receover_address_opt) == &expect_address, 1001);

        //test empty data failed
        let empty_signature = x"";
        let empty_msg_hash = x"";
        let receover_address_opt:Option<EVMAddress> = Signature::ecrecover(empty_msg_hash, empty_signature);
        assert!(Option::is_none<EVMAddress>(&receover_address_opt), 1002);

        //test invalid hash, change the last char from 1 to 0
        let invalid_msg_hash = x"b453bd4e271eed985cbab8231da609c4ce0a9cf1f763b6c1594e76315510e0f0";
        let receover_address_opt:Option<EVMAddress> = Signature::ecrecover(invalid_msg_hash, signature);
        assert!(Option::is_some<EVMAddress>(&receover_address_opt), 1003);
        assert!(&Option::destroy_some<EVMAddress>(receover_address_opt) != &expect_address, 1004);

        //test invalid signature, change the last char from 1 to 0
        let invalid_signature = x"90a938f7457df6e8f741264c32697fc52f9a8f867c52dd70713d9d2d472f2e415d9c94148991bbe1f4a1818d1dff09165782749c877f5cf1eff4ef126e55714d10";
        let receover_address_opt:Option<EVMAddress> = Signature::ecrecover(msg_hash, invalid_signature);
        assert!(Option::is_none<EVMAddress>(&receover_address_opt), 1005);
    }
}



//# run --signers creator

// test secp256k1_verify success case 
script {
    use StarcoinFramework::Signature;

    fun main() {
        //test success
        let signature = x"90a938f7457df6e8f741264c32697fc52f9a8f867c52dd70713d9d2d472f2e415d9c94148991bbe1f4a1818d1dff09165782749c877f5cf1eff4ef126e55714d1c";
        let msg_hash = x"b453bd4e271eed985cbab8231da609c4ce0a9cf1f763b6c1594e76315510e0f1";
        let address_bytes = x"29c76e6ad8f28bb1004902578fb108c507be341b";
        assert!(Signature::secp256k1_verify(copy signature, copy address_bytes, copy msg_hash), 1010); 
    }
}

//# run --signers creator

// test secp256k1_verify empty signature and empty msg case 
script {
    use StarcoinFramework::Signature;

    fun main() {       
        //test empty data failed
        let empty_signature = x"";
        let empty_msg_hash = x"";
        let address_bytes = x"29c76e6ad8f28bb1004902578fb108c507be341b";
        assert!(!Signature::secp256k1_verify(empty_signature,  copy address_bytes, empty_msg_hash), 1020);
    }
}

//# run --signers creator

// test secp256k1_verify invalid hash or invalid signature case 
script {
    use StarcoinFramework::Signature;
    
    fun main() {
        //test success
        let signature = x"90a938f7457df6e8f741264c32697fc52f9a8f867c52dd70713d9d2d472f2e415d9c94148991bbe1f4a1818d1dff09165782749c877f5cf1eff4ef126e55714d1c";
        let msg_hash = x"b453bd4e271eed985cbab8231da609c4ce0a9cf1f763b6c1594e76315510e0f1";
        let address_bytes = x"29c76e6ad8f28bb1004902578fb108c507be341b";

        //test invalid hash, change the last char from 1 to 0
        let invalid_msg_hash = x"b453bd4e271eed985cbab8231da609c4ce0a9cf1f763b6c1594e76315510e0f0";
        assert!(!Signature::secp256k1_verify(signature,  copy address_bytes, invalid_msg_hash), 1030);

        // //test invalid signature, change the last char from 1 to 0
        let invalid_signature = x"90a938f7457df6e8f741264c32697fc52f9a8f867c52dd70713d9d2d472f2e415d9c94148991bbe1f4a1818d1dff09165782749c877f5cf1eff4ef126e55714d10";
        assert!(!Signature::secp256k1_verify(invalid_signature, address_bytes, msg_hash), 1031);
    }
}