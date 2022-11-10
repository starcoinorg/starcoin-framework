module StarcoinFramework::SBTVoteStrategy{
    use StarcoinFramework::BCS;
    #[test_only]
    use StarcoinFramework::Debug;
    use StarcoinFramework::Vector;

    const ERR_BCS_STATE_NTFS_LENGHT_TYPE_INVALID: u64 = 1413;

    /// deserialize snapshot vote value from state
    public fun get_voting_power(state: &vector<u8>) : u128 {
        let sbt_value = deserialize_sbt_value_from_bcs_state(state);

        //TODO support calculate weight_factor
        sbt_value
    }

//    struct NFT<NFTMeta: copy + store + drop, NFTBody> has store {
//        /// The creator of NFT
//        creator: address,
//        /// The unique id of NFT under NFTMeta type
//        id: u64,
//        /// The metadata of NFT
//        base_meta: Metadata,
//        /// The extension metadata of NFT
//        type_meta: NFTMeta,
//        /// The body of NFT, NFT is a box for NFTBody
//        body: NFTBody,
//    }
//
//    struct Metadata has copy, store, drop {
//        /// NFT name's utf8 bytes.
//        name: vector<u8>,
//        /// Image link, such as ipfs://xxxx
//        image: vector<u8>,
//        /// Image bytes data, image or image_data can not empty for both.
//        image_data: vector<u8>,
//        /// NFT description utf8 bytes.
//        description: vector<u8>,
//    }

    /// deserialize sbt value from bcs state
    public fun deserialize_sbt_value_from_bcs_state(state: &vector<u8>) : u128{
        let len = Vector::length(state);
        if (len == 0) {
            return 0u128
        };

        // nfts array length
        let offset = 0;
        let (nfts_len, offset) = BCS::deserialize_u8(state, offset);
        // user has no sbt yet
        if (nfts_len == 0) {
            return 0u128
        };

        offset = BCS::skip_address(state, offset);
        offset = BCS::skip_u64(state, offset);
        offset = BCS::skip_bytes(state, offset);
        offset = BCS::skip_bytes(state, offset);
        offset = BCS::skip_bytes(state, offset);
        offset = BCS::skip_bytes(state, offset);
        offset = BCS::skip_u64(state, offset);
        let (value, _offset) = BCS::deserialize_u128(state, offset);

        value
    }


    #[test]
    fun test_deserialize_sbt_value_from_bcs_state() {
        // https://stcscan.io/barnard/address/0x6bfb460477adf9dd0455d3de2fc7f211/resources
        // 0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DAOMember<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>, 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DAOMemberBody<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>>
        // {"json":{"nft":{"vec":[{"base_meta":{"description":"0x","image":"0x","image_data":"0x69616d67655f64617461","name":"0x64616f313031"},"body":{"sbt":{"value":100}},"creator":"0x6bfb460477adf9dd0455d3de2fc7f211","id":1,"type_meta":{"id":1111}}]}},"raw":"0x016bfb460477adf9dd0455d3de2fc7f21101000000000000000664616f313031000a69616d67655f6461746100570400000000000064000000000000000000000000000000"}
        let bs = x"016bfb460477adf9dd0455d3de2fc7f21101000000000000000664616f313031000a69616d67655f6461746100570400000000000064000000000000000000000000000000";
        Debug::print<vector<u8>>(&bs);
        let offset = 0;

        // array length
        offset = BCS::skip_u8(&bs, offset);
        // creator
        offset = BCS::skip_address(&bs, offset);
        // id
        offset = BCS::skip_u64(&bs, offset);
        Debug::print<u64>(&offset);
        // base_meta
        offset = BCS::skip_bytes(&bs, offset);
        offset = BCS::skip_bytes(&bs, offset);
        offset = BCS::skip_bytes(&bs, offset);
        offset = BCS::skip_bytes(&bs, offset);
        // type_meta
        offset = BCS::skip_u64(&bs, offset);
        Debug::print<u64>(&offset);
        // body
        let (sbt_value, offset) = BCS::deserialize_u128(&bs, offset);
        Debug::print(&sbt_value);
        Debug::print<u64>(&offset);
        let expect_sb_value = 100;
        assert!(expect_sb_value == sbt_value, 8003);
        Debug::print(&b"testdao02");
    }

}