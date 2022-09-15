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
    use StarcoinFramework::Event;
    use StarcoinFramework::TypeInfo::{Self, TypeInfo};

    const ERR_ALREADY_INITIALIZED: u64 = 100;
    const ERR_NOT_CONTRACT_OWNER: u64 = 101;
    const ERR_EXPECT_EXT_POINT_NFT: u64 = 102;
    const ERR_NOT_FOUND_EXT_POINT: u64 = 103;
    const ERR_ALREADY_REGISTERED: u64 = 104;
    const ERR_STAR_ALREADY_STARED: u64 = 105;
    const ERR_STAR_NOT_FOUND_STAR: u64 = 106;
    const ERR_TAG_DUPLICATED: u64 = 107;

    const MAX_VERSION_COUNT: u64 = 5;

    struct Version has store  {
       number: u64,
       tag: vector<u8>,
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

    /// registry event handlers
    struct RegistryEventHandlers has key, store{
        register: Event::EventHandle<ExtensionPointRegisterEvent>,
    }

    struct ExtensionPointRegisterEvent has drop, store{
        id: u64,
        type: TypeInfo,
        name: vector<u8>,
        description:vector<u8>,
        labels: vector<vector<u8>>
    }

    /// extension point event handlers
    struct ExtensionPointEventHandlers<phantom PluginT> has key, store{
        publish_version: Event::EventHandle<PublishVersionEvent<PluginT>>,
        star: Event::EventHandle<StarEvent<PluginT>>,
        unstar: Event::EventHandle<UnstarEvent<PluginT>>,
        update: Event::EventHandle<UpdateInfoEvent<PluginT>>,
    }

    struct PublishVersionEvent<phantom PluginT> has drop, store{
        sender: address,
        version_number: u64,
    }

    struct StarEvent<phantom PluginT> has drop, store{
        sender: address,
    }

    struct UnstarEvent<phantom PluginT> has drop, store{
        sender: address,
    }

    struct UpdateInfoEvent<phantom PluginT> has drop, store{
        sender: address,
        id: u64,
        name: vector<u8>,
        description:vector<u8>,
        labels: vector<vector<u8>>
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

        move_to(&signer, RegistryEventHandlers {
            register: Event::new_event_handle<ExtensionPointRegisterEvent>(&signer),
        });
    }

    public fun register<ExtPointT: store>(sender: &signer, name: vector<u8>, description: vector<u8>, types_d_ts:vector<u8>, dts_doc:vector<u8>, 
        option_labels: Option<vector<vector<u8>>>):u64 acquires Registry, NFTMintCapHolder, RegistryEventHandlers {
        assert!(!exists<Entry<ExtPointT>>(CoreAddresses::GENESIS_ADDRESS()), Errors::already_published(ERR_ALREADY_REGISTERED));
        let registry = borrow_global_mut<Registry>(CoreAddresses::GENESIS_ADDRESS());
        let extpoint_id = next_extpoint_id(registry);

        let version = Version {
            number: 1,
            tag: b"v0.1.0",
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
            id: copy extpoint_id, 
            name: copy name,
            description: copy description,
            labels: copy labels,
            next_version_number: 2,
            versions: Vector::singleton<Version>(version), 
            star_count: 0,
            created_at: Timestamp::now_milliseconds(),
            updated_at: Timestamp::now_milliseconds(),
        });

        move_to(&genesis_account, ExtensionPointEventHandlers<ExtPointT>{
            publish_version: Event::new_event_handle<PublishVersionEvent<ExtPointT>>(&genesis_account),
            star: Event::new_event_handle<StarEvent<ExtPointT>>(&genesis_account),
            unstar: Event::new_event_handle<UnstarEvent<ExtPointT>>(&genesis_account),
            update: Event::new_event_handle<UpdateInfoEvent<ExtPointT>>(&genesis_account),
        });

        // grant owner NFT to sender
        let nft_mint_cap = borrow_global_mut<NFTMintCapHolder>(CoreAddresses::GENESIS_ADDRESS());
        let meta = OwnerNFTMeta{
            registry_address: CoreAddresses::GENESIS_ADDRESS(),
            extpoint_id: extpoint_id,
        };

        let nft = NFT::mint_with_cap_v2(CoreAddresses::GENESIS_ADDRESS(), &mut nft_mint_cap.cap, *&nft_mint_cap.nft_metadata, meta, OwnerNFTBody{});
        NFTGallery::deposit(sender, nft);

        // registry register event emit
        let registry_event_handlers = borrow_global_mut<RegistryEventHandlers>(CoreAddresses::GENESIS_ADDRESS());
        Event::emit_event(&mut registry_event_handlers.register,
            ExtensionPointRegisterEvent {
                id: copy extpoint_id,
                type: TypeInfo::type_of<ExtPointT>(),
                name: copy name,
                description: copy description,
                labels: copy labels,
            },
        );

        extpoint_id
    }

    public fun publish_version<ExtPointT: store>(
        sender: &signer, 
        tag: vector<u8>,
        types_d_ts:vector<u8>,
        dts_doc: vector<u8>, 
    ) acquires Entry, ExtensionPointEventHandlers {
        let sender_addr = Signer::address_of(sender);
        let extp = borrow_global_mut<Entry<ExtPointT>>(CoreAddresses::GENESIS_ADDRESS());
        ensure_exists_extpoint_nft(sender_addr, extp.id);

        // Remove the old version when the number of versions is greater than MAX_VERSION_COUNT
        if (Vector::length(&extp.versions) >= MAX_VERSION_COUNT) {
            let oldest_version = Vector::remove(&mut extp.versions, 0);
            let Version {
                number: _,
                tag: _,
                types_d_ts: _,
                document: _,
                created_at: _,
            } = oldest_version;
        };

        let number = next_extpoint_version_number(extp);
        Vector::push_back<Version>(&mut extp.versions, Version{
            number: number,
            tag: tag,
            types_d_ts: types_d_ts,
            document: dts_doc,
            created_at: Timestamp::now_milliseconds(),
        });

        extp.updated_at = Timestamp::now_milliseconds();

        // publish version event emit
        let plugin_event_handlers = borrow_global_mut<ExtensionPointEventHandlers<ExtPointT>>(CoreAddresses::GENESIS_ADDRESS());
        Event::emit_event(&mut plugin_event_handlers.publish_version,
            PublishVersionEvent {
                sender: copy sender_addr,
                version_number: copy number,
            },
        );
    }

    public fun update<ExtPointT>(sender: &signer, name: vector<u8>, description: vector<u8>, option_labels: Option<vector<vector<u8>>>) acquires Entry, ExtensionPointEventHandlers {
        let sender_addr = Signer::address_of(sender);
        let extp = borrow_global_mut<Entry<ExtPointT>>(CoreAddresses::GENESIS_ADDRESS());
        ensure_exists_extpoint_nft(sender_addr, extp.id);

        extp.name = name;
        extp.description = description;

        if(Option::is_some(&option_labels)){
            extp.labels = Option::destroy_some(option_labels);
        };

        extp.updated_at = Timestamp::now_milliseconds();

        // update extpoint entry event emit
        let plugin_event_handlers = borrow_global_mut<ExtensionPointEventHandlers<ExtPointT>>(CoreAddresses::GENESIS_ADDRESS());
        Event::emit_event(&mut plugin_event_handlers.update,
            UpdateInfoEvent {
                sender: sender_addr,
                id: *&extp.id,
                name: *&extp.name,
                description: *&extp.description,
                labels: *&extp.labels,
            },
        );
    }

    public fun star<ExtPointT>(sender: &signer) acquires Entry, ExtensionPointEventHandlers {
        let sender_addr = Signer::address_of(sender);
        assert!(!exists<Star<ExtPointT>>(sender_addr), Errors::invalid_state(ERR_STAR_ALREADY_STARED));

        move_to(sender, Star<ExtPointT>{
            created_at: Timestamp::now_milliseconds(),
        });

        let entry = borrow_global_mut<Entry<ExtPointT>>(CoreAddresses::GENESIS_ADDRESS());
        entry.star_count = entry.star_count + 1;
        entry.updated_at = Timestamp::now_milliseconds();

        // star event emit
        let extpoint_event_handlers = borrow_global_mut<ExtensionPointEventHandlers<ExtPointT>>(CoreAddresses::GENESIS_ADDRESS());
        Event::emit_event(&mut extpoint_event_handlers.star,
            StarEvent {
                sender: sender_addr,
            },
        );
    }

    public fun unstar<ExtPointT>(sender: &signer) acquires Star, Entry, ExtensionPointEventHandlers {
        let sender_addr = Signer::address_of(sender);
        assert!(exists<Star<ExtPointT>>(sender_addr), Errors::invalid_state(ERR_STAR_NOT_FOUND_STAR));

        let star = move_from<Star<ExtPointT>>(sender_addr);
        let Star<ExtPointT> {created_at:_} = star;

        let entry = borrow_global_mut<Entry<ExtPointT>>(CoreAddresses::GENESIS_ADDRESS());
        entry.star_count = entry.star_count - 1;
        entry.updated_at = Timestamp::now_milliseconds();

        // unstar event emit
        let extpoint_event_handlers = borrow_global_mut<ExtensionPointEventHandlers<ExtPointT>>(CoreAddresses::GENESIS_ADDRESS());
        Event::emit_event(&mut extpoint_event_handlers.unstar,
            UnstarEvent {
                sender: sender_addr,
            },
        );
    }
}
