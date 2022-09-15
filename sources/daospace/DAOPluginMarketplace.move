module StarcoinFramework::DAOPluginMarketplace {
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
    const ERR_NOT_FOUND_PLUGIN: u64 = 102;
    const ERR_EXPECT_PLUGIN_NFT: u64 = 103;
    const ERR_PLUGIN_ALREADY_EXISTS: u64 = 104;
    const ERR_STAR_ALREADY_STARED: u64 = 105;
    const ERR_STAR_NOT_FOUND_STAR: u64 = 106;

    struct PluginVersion has store {
        number: u64, //Numeric version number, such as 1, 2, 3
        tag: vector<u8>, //Plugin tag, e.g. v0.1.1
        implement_extpoints: vector<vector<u8>>, //Implemented extension points
        depend_extpoints: vector<vector<u8>>, //Dependent extension points
        js_entry_uri: vector<u8>, //Front-end JS code resource URI, for example: "https://cdn.xxxx.xxxx/xxxx/xxxxx.js"
        created_at: u64, //Plugin creation time
    }
        
    struct PluginRegistry has key, store {
        next_plugin_id: u64,
    }

    struct PluginEntry<phantom PluginT> has key, store {
        id: u64, //Plugin ID
        name: vector<u8>, //plugin name
        description: vector<u8>, //Plugin description
        labels: vector<vector<u8>>, //Plugin label
        next_version_number: u64, //next version number
        versions: vector<PluginVersion>, //All versions of the plugin
        star_count: u64, //Star count
        created_at: u64, //Plugin creation time
        updated_at: u64, //Plugin last update time
    }

    struct Star<phantom PluginT> has key, store {
        created_at: u64, //creation time
    }

    /// Plugin Owner NFT
    struct PluginOwnerNFTMeta has copy, store, drop {
        plugin_id: u64,
        registry_address: address,
    }

    struct PluginOwnerNFTBody has store{}

    struct PluginOwnerNFTMintCapHolder has key {
        cap: NFT::MintCapability<PluginOwnerNFTMeta>,
        nft_metadata: NFT::Metadata,
    }

    fun next_plugin_id(plugin_registry: &mut PluginRegistry): u64 {
        let plugin_id = plugin_registry.next_plugin_id;
        plugin_registry.next_plugin_id = plugin_id + 1;
        plugin_id
    }

    fun next_plugin_version_number<PluginT>(plugin: &mut PluginEntry<PluginT>): u64 {
        let version_number = plugin.next_version_number;
        plugin.next_version_number = version_number + 1;
        version_number
    }

    fun has_plugin_owner_nft(sender_addr: address, plugin_id: u64): bool {
        if (!NFTGallery::is_accept<PluginOwnerNFTMeta, PluginOwnerNFTBody>(sender_addr)) {
            return false
        };

        let nft_infos = NFTGallery::get_nft_infos<PluginOwnerNFTMeta, PluginOwnerNFTBody>(sender_addr);
        let len = Vector::length(&nft_infos);
        if (len == 0) {
            return false
        };

        let idx = len - 1;
        loop {
            let nft_info = Vector::borrow(&nft_infos, idx);
            let (_, _, _, type_meta) = NFT::unpack_info<PluginOwnerNFTMeta>(*nft_info);
            if (type_meta.plugin_id == plugin_id) {
                return true
            };

            if (idx == 0) {
                return false
            };
            
            idx = idx - 1;
        }
    }

    fun ensure_exists_plugin_owner_nft(sender_addr: address, plugin_id: u64) {
        assert!(has_plugin_owner_nft(sender_addr, plugin_id), Errors::invalid_state(ERR_EXPECT_PLUGIN_NFT));
    }

    /// registry event handlers
    struct RegistryEventHandlers has key, store{
        register: Event::EventHandle<PluginRegisterEvent>,
    }

    struct PluginRegisterEvent has drop, store{
        id: u64,
        type: TypeInfo,
        name: vector<u8>,
        description:vector<u8>,
        labels: vector<vector<u8>>
    }

    /// plugin event handlers
    struct PluginEventHandlers<phantom PluginT> has key, store{
        publish_version: Event::EventHandle<PluginPublishVersionEvent<PluginT>>,
        star: Event::EventHandle<StarPluginEvent<PluginT>>,
        unstar: Event::EventHandle<UnstarPluginEvent<PluginT>>,
        update_plugin: Event::EventHandle<UpdatePluginInfoEvent<PluginT>>,
    }

    struct PluginPublishVersionEvent<phantom PluginT> has drop, store{
        sender: address,
        version_number: u64,
    }

    struct StarPluginEvent<phantom PluginT> has drop, store{
        sender: address,
    }

    struct UnstarPluginEvent<phantom PluginT> has drop, store{
        sender: address,
    }

    struct UpdatePluginInfoEvent<phantom PluginT> has drop, store{
        sender: address,
        id: u64,
        name: vector<u8>,
        description:vector<u8>,
        labels: vector<vector<u8>>
    }

    public fun initialize() {
        assert!(!exists<PluginRegistry>(CoreAddresses::GENESIS_ADDRESS()), Errors::already_published(ERR_ALREADY_INITIALIZED));
        let signer = GenesisSignerCapability::get_genesis_signer();

        let nft_name = b"PluginOwnerNFT";
        let nft_image = b"SVG image";
        let nft_description = b"The plugin owner NFT";
        let basemeta = NFT::new_meta_with_image_data(nft_name, nft_image, nft_description);
        let basemeta_bak = *&basemeta;
        NFT::register_v2<PluginOwnerNFTMeta>(&signer, basemeta);

        let nft_mint_cap = NFT::remove_mint_capability<PluginOwnerNFTMeta>(&signer);
        move_to(&signer, PluginOwnerNFTMintCapHolder{
            cap: nft_mint_cap,
            nft_metadata: basemeta_bak,
        });

        move_to(&signer, PluginRegistry{
            next_plugin_id: 1,
        });

        move_to(&signer, RegistryEventHandlers {
            register: Event::new_event_handle<PluginRegisterEvent>(&signer),
        });
    }

    public fun register_plugin<PluginT: store>(sender: &signer, name: vector<u8>, description: vector<u8>, option_labels: Option<vector<vector<u8>>>): u64 
        acquires PluginRegistry, PluginOwnerNFTMintCapHolder, RegistryEventHandlers {
        assert!(!exists<PluginEntry<PluginT>>(CoreAddresses::GENESIS_ADDRESS()), Errors::already_published(ERR_PLUGIN_ALREADY_EXISTS));
        let plugin_registry = borrow_global_mut<PluginRegistry>(CoreAddresses::GENESIS_ADDRESS());
        let plugin_id = next_plugin_id(plugin_registry);

        let genesis_account = GenesisSignerCapability::get_genesis_signer();

        let labels = if(Option::is_some(&option_labels)){
            Option::destroy_some(option_labels)
        } else {
            Vector::empty<vector<u8>>()
        };

        move_to(&genesis_account, PluginEntry<PluginT>{
            id: copy plugin_id, 
            name: copy name, 
            description: copy description,
            labels: copy labels,
            next_version_number: 1,
            versions: Vector::empty<PluginVersion>(), 
            star_count: 0,
            created_at: Timestamp::now_milliseconds(),
            updated_at: Timestamp::now_milliseconds(),
        });

        move_to(&genesis_account, PluginEventHandlers<PluginT>{
            publish_version: Event::new_event_handle<PluginPublishVersionEvent<PluginT>>(&genesis_account),
            star: Event::new_event_handle<StarPluginEvent<PluginT>>(&genesis_account),
            unstar: Event::new_event_handle<UnstarPluginEvent<PluginT>>(&genesis_account),
            update_plugin: Event::new_event_handle<UpdatePluginInfoEvent<PluginT>>(&genesis_account),
        });

        // grant owner NFT to sender
        let nft_mint_cap = borrow_global_mut<PluginOwnerNFTMintCapHolder>(CoreAddresses::GENESIS_ADDRESS());
        let meta = PluginOwnerNFTMeta{
            registry_address: CoreAddresses::GENESIS_ADDRESS(),
            plugin_id: copy plugin_id,
        };

        let nft = NFT::mint_with_cap_v2(CoreAddresses::GENESIS_ADDRESS(), &mut nft_mint_cap.cap, *&nft_mint_cap.nft_metadata, meta, PluginOwnerNFTBody{});
        NFTGallery::deposit(sender, nft);

        // registry register event emit
        let registry_event_handlers = borrow_global_mut<RegistryEventHandlers>(CoreAddresses::GENESIS_ADDRESS());
        Event::emit_event(&mut registry_event_handlers.register,
            PluginRegisterEvent {
                id: copy plugin_id,
                type: TypeInfo::type_of<PluginT>(),
                name: copy name,
                description: copy description,
                labels: copy labels,
            },
        );

        plugin_id
    }

    public fun exists_plugin<PluginT>(): bool {
        return exists<PluginEntry<PluginT>>(CoreAddresses::GENESIS_ADDRESS())
    }

    public fun take_plugin_id<PluginT>(): u64 acquires PluginEntry {
        let plugin = borrow_global<PluginEntry<PluginT>>(CoreAddresses::GENESIS_ADDRESS());
        return plugin.id
    }

    public fun publish_plugin_version<PluginT>(
        sender: &signer, 
        tag: vector<u8>,
        implement_extpoints: vector<vector<u8>>, 
        depend_extpoints: vector<vector<u8>>,
        js_entry_uri: vector<u8>, 
    ) acquires PluginEntry, PluginEventHandlers {
        let sender_addr = Signer::address_of(sender);
        let plugin = borrow_global_mut<PluginEntry<PluginT>>(CoreAddresses::GENESIS_ADDRESS());
        ensure_exists_plugin_owner_nft(copy sender_addr, plugin.id);
        
        let version_number = next_plugin_version_number(plugin);
        Vector::push_back<PluginVersion>(&mut plugin.versions, PluginVersion{
            number: copy version_number,
            tag: tag,
            implement_extpoints: implement_extpoints,
            depend_extpoints: depend_extpoints,
            js_entry_uri: js_entry_uri,
            created_at: Timestamp::now_milliseconds(),
        });

        plugin.updated_at = Timestamp::now_milliseconds();

        // plugin register event emit
        let plugin_event_handlers = borrow_global_mut<PluginEventHandlers<PluginT>>(CoreAddresses::GENESIS_ADDRESS());
        Event::emit_event(&mut plugin_event_handlers.publish_version,
            PluginPublishVersionEvent {
                sender: copy sender_addr,
                version_number: copy version_number,
            },
        );
    }

    public fun exists_plugin_version<PluginT>(
        version_number: u64,
    ): bool acquires PluginEntry {
        let plugin = borrow_global_mut<PluginEntry<PluginT>>(CoreAddresses::GENESIS_ADDRESS());
        return version_number > 0 && version_number < plugin.next_version_number
    }

    public fun star_plugin<PluginT>(sender: &signer) acquires PluginEntry, PluginEventHandlers {
        let sender_addr = Signer::address_of(sender);
        assert!(!exists<Star<PluginT>>(sender_addr), Errors::invalid_state(ERR_STAR_ALREADY_STARED));

        move_to(sender, Star<PluginT>{
            created_at: Timestamp::now_milliseconds(),
        });

        let plugin = borrow_global_mut<PluginEntry<PluginT>>(CoreAddresses::GENESIS_ADDRESS());
        plugin.star_count = plugin.star_count + 1;
        plugin.updated_at = Timestamp::now_milliseconds();

        // star plugin event emit
        let plugin_event_handlers = borrow_global_mut<PluginEventHandlers<PluginT>>(CoreAddresses::GENESIS_ADDRESS());
        Event::emit_event(&mut plugin_event_handlers.star,
            StarPluginEvent {
                sender: sender_addr,
            },
        );
    }

    public fun unstar_plugin<PluginT>(sender: &signer) acquires PluginEntry, Star, PluginEventHandlers {
        let sender_addr = Signer::address_of(sender);
        assert!(exists<Star<PluginT>>(sender_addr), Errors::invalid_state(ERR_STAR_NOT_FOUND_STAR));

        let star = move_from<Star<PluginT>>(sender_addr);
        let Star<PluginT> { created_at:_} = star;

        let plugin = borrow_global_mut<PluginEntry<PluginT>>(CoreAddresses::GENESIS_ADDRESS());
        plugin.star_count = plugin.star_count - 1;
        plugin.updated_at = Timestamp::now_milliseconds();

        // unstar plugin event emit
        let plugin_event_handlers = borrow_global_mut<PluginEventHandlers<PluginT>>(CoreAddresses::GENESIS_ADDRESS());
        Event::emit_event(&mut plugin_event_handlers.unstar,
            UnstarPluginEvent {
                sender: sender_addr,
            },
        );
    }

    public fun has_star_plugin<PluginT>(sender: &signer): bool {
        let sender_addr = Signer::address_of(sender);
        return exists<Star<PluginT>>(sender_addr)
    }

    public fun update_plugin<PluginT>(sender: &signer, name: vector<u8>, description: vector<u8>, option_labels: Option<vector<vector<u8>>>) acquires PluginEntry, PluginEventHandlers {
        let sender_addr = Signer::address_of(sender);
        let plugin = borrow_global_mut<PluginEntry<PluginT>>(CoreAddresses::GENESIS_ADDRESS());
        ensure_exists_plugin_owner_nft(sender_addr, plugin.id);

        plugin.name = name;
        plugin.description = description;

        if(Option::is_some(&option_labels)){
            plugin.labels = Option::destroy_some(option_labels);
        };

        plugin.updated_at = Timestamp::now_milliseconds();

        // update plugin event emit
        let plugin_event_handlers = borrow_global_mut<PluginEventHandlers<PluginT>>(CoreAddresses::GENESIS_ADDRESS());
        Event::emit_event(&mut plugin_event_handlers.update_plugin,
            UpdatePluginInfoEvent {
                sender: sender_addr,
                id: *&plugin.id,
                name: *&plugin.name,
                description: *&plugin.description,
                labels: *&plugin.labels,
            },
        );
    }
}
