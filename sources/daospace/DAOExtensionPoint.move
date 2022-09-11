module StarcoinFramework::DAOExtensionPoint {
    use StarcoinFramework::GenesisSignerCapability;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Vector;
    use StarcoinFramework::NFT;
    use StarcoinFramework::NFTGallery;
    use StarcoinFramework::Option::{Self, Option};

    const ERR_ALREADY_INITIALIZED: u64 = 100;
    const ERR_NOT_CONTRACT_OWNER: u64 = 101;
    const ERR_EXPECT_EXT_POINT_NFT: u64 = 102;
    const ERR_NOT_FOUND_EXT_POINT: u64 = 103;
    const ERR_ALREADY_REGISTERED: u64 = 104;
    const ERR_STAR_ALREADY_STARED: u64 = 105;
    const ERR_STAR_NOT_FOUND_STAR: u64 = 106;

    struct Version has store  {
       number: u64,
       types_d_ts: vector<u8>,
       document: vector<u8>,
       created_at: u64,
    }

    struct Registry has key, store  {
       next_id: u64,
    }

    struct Entry<phantom ExtPointT> has key, store  {
       id: u64,
       name: vector<u8>,
       description: vector<u8>,
       labels: vector<vector<u8>>,
       next_version_number: u64,
       versions: vector<Version>,
       star_count: u64,
       created_at: u64,
       updated_at: u64,
    }

    struct Star<phantom ExtPointT> has key, store {
        user: address,
        created_at: u64,
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

    fun next_extpoint_version_number<ExtPointT: store>(extpoint: &mut Entry<ExtPointT>): u64 {
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

	public fun initialize() {
        assert!(!exists<Registry>(CoreAddresses::GENESIS_ADDRESS()), Errors::already_published(ERR_ALREADY_INITIALIZED));
        let signer = GenesisSignerCapability::get_genesis_signer();

        let nft_name = b"ExtPointOwnerNFT";
        let nft_image = b"SVG image";
        let nft_description = b"The extension point owner NFT";
        let basemeta = NFT::new_meta_with_image_data(nft_name, nft_image, nft_description);
        let basemeta_bak = *&basemeta;
        NFT::register_v2<OwnerNFTMeta>(&signer, basemeta);

        let nft_mint_cap = NFT::remove_mint_capability<OwnerNFTMeta>(&signer);
        move_to(&signer, NFTMintCapHolder{
            cap: nft_mint_cap,
            nft_metadata: basemeta_bak,
        });

        move_to(&signer, Registry{
            next_id: 1,
        });
    }

    public fun register<ExtPointT: store>(sender: &signer, name: vector<u8>, description: vector<u8>, types_d_ts:vector<u8>, dts_doc:vector<u8>, option_labels: Option<vector<vector<u8>>>):u64 acquires Registry, NFTMintCapHolder {
        assert!(!exists<Entry<ExtPointT>>(CoreAddresses::GENESIS_ADDRESS()), Errors::already_published(ERR_ALREADY_REGISTERED));
        let registry = borrow_global_mut<Registry>(CoreAddresses::GENESIS_ADDRESS());
        let extpoint_id = next_extpoint_id(registry);

        let version = Version {
            number: 1,
            types_d_ts: types_d_ts,
            document: dts_doc,
            created_at: Timestamp::now_milliseconds(),
        };

        let labels = if(Option::is_some(&option_labels)){
            Option::destroy_some(option_labels)
        } else {
            Vector::empty<vector<u8>>()
        };

        let genesis_account = GenesisSignerCapability::get_genesis_signer();
        move_to(&genesis_account, Entry<ExtPointT>{
            id: extpoint_id, 
            name: name,
            description: description,
            labels: labels,
            next_version_number: 2,
            versions: Vector::singleton<Version>(version), 
            star_count: 0,
            created_at: Timestamp::now_milliseconds(),
            updated_at: Timestamp::now_milliseconds(),
        });

        // grant owner NFT to sender
        let nft_mint_cap = borrow_global_mut<NFTMintCapHolder>(CoreAddresses::GENESIS_ADDRESS());
        let meta = OwnerNFTMeta{
            registry_address: CoreAddresses::GENESIS_ADDRESS(),
            extpoint_id: extpoint_id,
        };

        let nft = NFT::mint_with_cap_v2(CoreAddresses::GENESIS_ADDRESS(), &mut nft_mint_cap.cap, *&nft_mint_cap.nft_metadata, meta, OwnerNFTBody{});
        NFTGallery::deposit(sender, nft);

        extpoint_id
    }

    public fun publish_version<ExtPointT: store>(
        sender: &signer, 
        types_d_ts:vector<u8>,
        dts_doc: vector<u8>, 
    ) acquires Entry {
        let extp = borrow_global_mut<Entry<ExtPointT>>(CoreAddresses::GENESIS_ADDRESS());
        ensure_exists_extpoint_nft(Signer::address_of(sender), extp.id);

        let number = next_extpoint_version_number(extp);

        Vector::push_back<Version>(&mut extp.versions, Version{
            number: number,
            types_d_ts: types_d_ts,
            document: dts_doc,
            created_at: Timestamp::now_milliseconds(),
        });

        extp.updated_at = Timestamp::now_milliseconds();
    }

    public fun star<ExtPointT>(sender: &signer) acquires Entry {
        let sender_addr = Signer::address_of(sender);
        assert!(!exists<Star<ExtPointT>>(sender_addr), Errors::invalid_state(ERR_STAR_ALREADY_STARED));

        move_to(sender, Star<ExtPointT>{
            user: sender_addr,
            created_at: Timestamp::now_milliseconds(),
        });

        let entry = borrow_global_mut<Entry<ExtPointT>>(CoreAddresses::GENESIS_ADDRESS());
        entry.star_count = entry.star_count + 1;
        entry.updated_at = Timestamp::now_milliseconds();
    }

    public fun unstar<ExtPointT>(sender: &signer) acquires Star, Entry {
        let sender_addr = Signer::address_of(sender);
        assert!(exists<Star<ExtPointT>>(sender_addr), Errors::invalid_state(ERR_STAR_NOT_FOUND_STAR));

        let star = move_from<Star<ExtPointT>>(sender_addr);
        let Star<ExtPointT> {user:_, created_at:_} = star;

        let entry = borrow_global_mut<Entry<ExtPointT>>(CoreAddresses::GENESIS_ADDRESS());
        entry.star_count = entry.star_count - 1;
        entry.updated_at = Timestamp::now_milliseconds();
    }
}


module StarcoinFramework::DAOExtensionPointScript {
    use StarcoinFramework::DAOExtensionPoint;

    public(script) fun initialize() {
        DAOExtensionPoint::initialize();
    }
}