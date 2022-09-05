module StarcoinFramework::DAOExtensionPoint {
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Vector;
    use StarcoinFramework::NFT;
    use StarcoinFramework::NFTGallery;
    use StarcoinFramework::GenesisSignerCapability;

    const CONTRACT_ACCOUNT:address = @StarcoinFramework;

    const ERR_ALREADY_INITIALIZED: u64 = 100;
    const ERR_NOT_CONTRACT_OWNER: u64 = 101;
    const ERR_EXPECT_EXT_POINT_NFT: u64 = 102;
    const ERR_NOT_FOUND_EXT_POINT: u64 = 103;
    const ERR_ALREADY_EXISTS_NAME: u64 = 104;

    struct Version has store  {
       number: u64,
       protobuf: vector<u8>,
       document: vector<u8>,
       created_at: u64,
    }

    struct DAOExtensionPoint<ExtInfo: store> has key, store  {
       id: u64,
       name: vector<u8>,
       describe: vector<u8>,
       next_version_number: u64,
       versions: vector<Version>,
       ext: ExtInfo,
       created_at: u64,
    }

    struct Registry has key, store  {
       next_id: u64,
    }

    struct OwnerNFTMeta has copy, store, drop {
        extpoint_id: u64,
        registry_address: address,
    }

    struct OwnerNFTBody has store{}

    struct NFTMintCapHolder has key {
        cap: NFT::MintCapability<OwnerNFTMeta>,
        nft_metadata: NFT::Metadata,
    }

    fun next_extpoint_id(registry: &mut Registry): u64 {
        let extpoint_id = registry.next_id;
        registry.next_id = extpoint_id + 1;
        extpoint_id
    }

    fun next_extpoint_version_number<ExtInfo: store>(extpoint: &mut DAOExtensionPoint<ExtInfo>): u64 {
        let version_number = extpoint.next_version_number;
        extpoint.next_version_number = version_number + 1;
        version_number
    }

    fun has_extpoint_nft(sender_addr: address, extpoint_id: u64): bool {
        if (!NFTGallery::is_accept<OwnerNFTMeta, OwnerNFTBody>(sender_addr)) {
            return false
        };

        let nft_infos = NFTGallery::get_nft_infos<OwnerNFTMeta, OwnerNFTBody>(sender_addr);
        let len = Vector::length(&nft_infos);
        if (len == 0) {
            return false
        };

        let idx = len - 1;
        loop {
            let nft_info = Vector::borrow(&nft_infos, idx);
            let (_, _, _, type_meta) = NFT::unpack_info<OwnerNFTMeta>(*nft_info);
            if (type_meta.extpoint_id == extpoint_id) {
                return true
            };

            if (idx == 0) {
                return false
            };
            
            idx = idx - 1;
        }
    }

    fun ensure_exists_extpoint_nft(sender_addr: address, extpoint_id: u64) {
        assert!(has_extpoint_nft(sender_addr, extpoint_id), Errors::invalid_state(ERR_EXPECT_EXT_POINT_NFT));
    }

	public fun initialize(sender: &signer) {
        assert!(Signer::address_of(sender)==CONTRACT_ACCOUNT, Errors::requires_address(ERR_NOT_CONTRACT_OWNER));
        assert!(!exists<Registry>(Signer::address_of(sender)), Errors::already_published(ERR_ALREADY_INITIALIZED));

        let nft_name = b"EPO";
        let nft_image = b"SVG image";
        let nft_description = b"The extension point owner";
        let basemeta = NFT::new_meta_with_image_data(nft_name, nft_image, nft_description);
        let basemeta_bak = *&basemeta;
        NFT::register_v2<OwnerNFTMeta>(sender, basemeta);
        let nft_mint_cap = NFT::remove_mint_capability<OwnerNFTMeta>(sender);
        move_to(sender, NFTMintCapHolder{
            cap: nft_mint_cap,
            nft_metadata: basemeta_bak,
        });

        move_to(sender, Registry{
            next_id: 1,
        });
    }

    public fun register<ExtInfo: store>(sender: &signer, name: vector<u8>, describe: vector<u8>, protobuf:vector<u8>, pb_doc:vector<u8>, extInfo: ExtInfo):u64 acquires Registry, NFTMintCapHolder {
        let registry = borrow_global_mut<Registry>(CONTRACT_ACCOUNT);
        let extpoint_id = next_extpoint_id(registry);

        let version = Version {
            number: 1,
            protobuf: protobuf,
            document: pb_doc,
            created_at: Timestamp::now_milliseconds(),
        };

        let genesis_account = GenesisSignerCapability::get_genesis_signer();
        move_to(&genesis_account, DAOExtensionPoint{
            id: extpoint_id, 
            name: name, 
            describe: describe,
            next_version_number: 1,
            versions: Vector::singleton<Version>(version), 
            ext: extInfo,
            created_at: Timestamp::now_milliseconds(),
        });

        // grant owner NFT to sender
        let nft_mint_cap = borrow_global_mut<NFTMintCapHolder>(CONTRACT_ACCOUNT);
        let meta = OwnerNFTMeta{
            registry_address: CONTRACT_ACCOUNT,
            extpoint_id: extpoint_id,
        };

        let nft = NFT::mint_with_cap_v2(CONTRACT_ACCOUNT, &mut nft_mint_cap.cap, *&nft_mint_cap.nft_metadata, meta, OwnerNFTBody{});
        NFTGallery::deposit(sender, nft);

        extpoint_id
    }
}


module StarcoinFramework::DAOExtensionPointScript {
    use StarcoinFramework::DAOExtensionPoint;

    public(script) fun initialize(sender: signer) {
        DAOExtensionPoint::initialize(&sender)
    }
}