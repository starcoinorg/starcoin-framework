module StarcoinFramework::SBTVoteStrategy{
    use StarcoinFramework::BCS;
    #[test_only]
    use StarcoinFramework::Debug;
    use StarcoinFramework::Vector;
    #[test_only]
    use StarcoinFramework::Option;

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
        // 0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMember<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>, 0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMemberBody<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>>
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

    #[test]
    fun test_snapshot_proof_deserialize() {
        // barnard, block number 6201718
        let snpashot_raw_proofs = x"0145016bfb460477adf9dd0455d3de2fc7f21101000000000000000664616f313031000a69616d67655f64617461005704000000000000640000000000000000000000000000000145020120cc969848619e507450ebf01437155ab5f2dbb554fe611cb71958855a1b2ec664012035f2374c333a51e46b62b693ebef25b9be2cefde8d156db08bff28f9a0b87742012073837fcf4e69ae60e18ea291b9f25c86ce8053c6ee647a2b287083327c67dd7e20dac300fb581a6df034a44a99e8eb1cd55c7dd8f0a9e78f1114a6b4eda01d834e0e2078179a07914562223d40068488a0d65673b3b2681642633dc33904575f8f070b20b7c2a21de200ca82241e5e480e922258591b219dd56c24c4d94299020ee8299a204f541db82477510f699c9d75dd6d8280639a1ec9d0b90962cbc0c2b06514a78b20cacfce99bb564cfb70eec6a61bb76b9d56eb1b626d7fa231338792e1f572a8df20da6c1337ca5d8f0fa18b2db35844c610858a710edac35206ef0bf52fd32a4ac920ef6fb8f82d32ca2b7c482b7942505e6492bffa3ed14dd635bae16a14b4ac32e6202ad7b36e08e7b5d208de8eec1ef1964dc8433ccca8ac4632f36054926e858ac32027d5ccc8aa57b964ad50334f62821188b89945ae999ad0bb31cdc16df1763f8120afa983813953d6aa9563db12d5e443c9e8114c3482867c95a661a240d6f0e0ec206466ac318f5d9deb7b64b12622a0f4bed2f19379667d18b6ccfeaa84171d812f20eb45021b7b39887925a5b49018cdc8ad44c14835a42e5775666315f4a3e0ba42204c2b365a78e4615873772a0f039a7326150472b4923d40640863dbe42a2351eb20825d0c21dd1105faf528934842419f8661d695fc72ec6ef8036f5d03359126d3205d806c027eecdfbc3960e68c5997718a0709a6079f96e1af3ffe21878ada2b830120fa60f8311936961f5e9dee5ccafaea83ed91c6eaa04a7dea0b85a38cf84d8564207ef6a85019523861474cdf47f4db8087e5368171d95cc2c1e57055a72ca39cb704208db1e4e4c864882bd611b1cda02ca30c43b3c7bc56ee7cb174598188da8b49ef2063b3f1e4f05973830ba40e0c50c4e59f31d3baa5643d19676ddbacbf797bf6b720b39d31107837c1751d439706c8ddac96f8c148b8430ac4f40546f33fb9871e4320fb0ad035780bb8f1c6481bd674ccad0948cd2e8e6b97c08e582f67cc26918fb3";
        //        let state_root = x"d5cd5dc44799c989a84b7d4a810259f373b13a9bf8ee21ecbed0fab264e2090d";
        //        let account_address = @0x6bfb460477adf9dd0455d3de2fc7f211;
        //        // 0x00000000000000000000000000000001::Account::Balance<0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        //        let resource_struct_tag = x"00000000000000000000000000000001074163636f756e740742616c616e636501078c109349c6bd91411d6bc962e080c4a30453544152045354415200";

        let offset = 0;
        let (state_option, offset) = BCS::deserialize_option_bytes(&snpashot_raw_proofs, offset);
        let state = Option::extract(&mut state_option);
        Debug::print(&state);
        Debug::print(&x"016bfb460477adf9dd0455d3de2fc7f21101000000000000000664616f313031000a69616d67655f6461746100570400000000000064000000000000000000000000000000");
        Debug::print(&offset);
        let (_account_state_option, offset) = BCS::deserialize_option_bytes(&snpashot_raw_proofs, offset);
        let _account_state = Option::extract(&mut _account_state_option);
        Debug::print(&_account_state);
        Debug::print(&offset);

        let (_account_proof_leaf1_option, _account_proof_leaf2_option, offset) = BCS::deserialize_option_tuple(&snpashot_raw_proofs, offset);
        let _account_proof_leaf1 = Option::extract(&mut _account_proof_leaf1_option);
        let _account_proof_leaf2 = Option::extract(&mut _account_proof_leaf2_option);

        let account_proof_leaf_nodes = Vector::empty<vector<u8>>();
        Vector::push_back(&mut account_proof_leaf_nodes, x"73837fcf4e69ae60e18ea291b9f25c86ce8053c6ee647a2b287083327c67dd7e");
        Vector::push_back(&mut account_proof_leaf_nodes, x"dac300fb581a6df034a44a99e8eb1cd55c7dd8f0a9e78f1114a6b4eda01d834e");
        Debug::print(&account_proof_leaf_nodes);
        Debug::print(&_account_proof_leaf1);
        Debug::print(&_account_proof_leaf2);
        Debug::print(&offset);
        let (_account_proof_siblings, offset) = BCS::deserialize_bytes_vector(&snpashot_raw_proofs, offset);

        let (_account_state_proof_leaf1_option, _account_state_proof_leaf2_option, offset) = BCS::deserialize_option_tuple(&snpashot_raw_proofs, offset);
        let _account_state_proof_leaf1 = Option::extract(&mut _account_state_proof_leaf1_option);
        let _account_state_proof_leaf2 = Option::extract(&mut _account_state_proof_leaf2_option);
        Debug::print(&_account_state_proof_leaf1);
        Debug::print(&_account_state_proof_leaf2);
        let (_account_state_proof_siblings, _offset) = BCS::deserialize_bytes_vector(&snpashot_raw_proofs, offset);

        Debug::print(&_account_state_proof_siblings);
        Debug::print(&offset);
    }

}