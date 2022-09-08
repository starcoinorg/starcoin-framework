module StarcoinFramework::DAOPluginMarketplace {
    use StarcoinFramework::GenesisSignerCapability;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Vector;
    use StarcoinFramework::NFT;
    use StarcoinFramework::NFTGallery;

    const ERR_ALREADY_INITIALIZED: u64 = 100;
    const ERR_NOT_CONTRACT_OWNER: u64 = 101;
    const ERR_NOT_FOUND_PLUGIN: u64 = 102;
    const ERR_EXPECT_PLUGIN_NFT: u64 = 103;
    const ERR_PLUGIN_ALREADY_EXISTS: u64 = 104;

    struct PluginVersion has store {
        number: u64, //Numeric version number, such as 1, 2, 3
        version: vector<u8>, //Plugin version number, e.g. v0.1.1
        required_caps: vector<vector<u8>>, //ability to depend
        export_caps: vector<vector<u8>>, //ability to export
        implement_extpoints: vector<vector<u8>>, //Implemented extension points
        depend_extpoints: vector<vector<u8>>, //Dependent extension points
        contract_module: vector<u8>, //Contract module, format: ${address}::${module}
        js_entry_uri: vector<u8>, //Front-end JS code resource URI, for example: "https://cdn.xxxx.xxxx/xxxx/xxxxx.js"
        created_at: u64, //Plugin creation time
    }
    
    struct Star has store {
        addr: address, //Star's wallet address, which can be a short address, such as zhangsan.stc
        created_at: u64, //creation time
    }
    
    struct Comment has store {
        addr: address, //The commenter's wallet address, which can be a short address, such as zhangsan.stc
        content: vector<u8>, //comments
        created_at: u64, //creation time
    }
    
    struct PluginRegistry has key, store {
        next_plugin_id: u64,
    }

    struct PluginEntry<phantom PluginT> has key, store {
        id: u64, //Plugin ID
        name: vector<u8>, //plugin name
        description: vector<u8>, //Plugin description
        git_repo: vector<u8>, //git repository code
        next_version_number: u64, //next version number
        versions: vector<PluginVersion>, //All versions of the plugin
        stars: vector<Star>,//All stars of the plugin
        comments: vector<Comment>, //All comments for plugins
        created_at: u64, //Plugin creation time
        updated_at: u64, //Plugin last update time
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

    fun has_plugin_nft(sender_addr: address, plugin_id: u64): bool {
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

    fun ensure_exists_plugin_nft(sender_addr: address, plugin_id: u64) {
        assert!(has_plugin_nft(sender_addr, plugin_id), Errors::invalid_state(ERR_EXPECT_PLUGIN_NFT));
    }

    public fun initialize() {
        assert!(!exists<PluginRegistry>(CoreAddresses::GENESIS_ADDRESS()), Errors::already_published(ERR_ALREADY_INITIALIZED));
        let signer = GenesisSignerCapability::get_genesis_signer();

        let nft_name = b"PO";
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
    }

    public fun register_plugin<PluginT: store>(sender: &signer, name: vector<u8>, description: vector<u8>): u64 acquires PluginRegistry, PluginOwnerNFTMintCapHolder {
        assert!(!exists<PluginEntry<PluginT>>(CoreAddresses::GENESIS_ADDRESS()), Errors::already_published(ERR_PLUGIN_ALREADY_EXISTS));
        let plugin_registry = borrow_global_mut<PluginRegistry>(CoreAddresses::GENESIS_ADDRESS());
        let plugin_id = next_plugin_id(plugin_registry);

        let genesis_account = GenesisSignerCapability::get_genesis_signer();
        move_to(&genesis_account, PluginEntry<PluginT>{
            id: plugin_id, 
            name: name, 
            description: description,
            git_repo: Vector::empty<u8>(),
            next_version_number: 1,
            versions: Vector::empty<PluginVersion>(), 
            stars: Vector::empty<Star>(),
            comments: Vector::empty<Comment>(),
            created_at: Timestamp::now_milliseconds(),
            updated_at: Timestamp::now_milliseconds(),
        });

        // grant owner NFT to sender
        let nft_mint_cap = borrow_global_mut<PluginOwnerNFTMintCapHolder>(CoreAddresses::GENESIS_ADDRESS());
        let meta = PluginOwnerNFTMeta{
            registry_address: CoreAddresses::GENESIS_ADDRESS(),
            plugin_id: plugin_id,
        };

        let nft = NFT::mint_with_cap_v2(CoreAddresses::GENESIS_ADDRESS(), &mut nft_mint_cap.cap, *&nft_mint_cap.nft_metadata, meta, PluginOwnerNFTBody{});
        NFTGallery::deposit(sender, nft);

        plugin_id
    }

    public fun publish_plugin_version<PluginT>(
        sender: &signer, 
        plugin_id:u64, 
        version: vector<u8>,
        required_caps: vector<vector<u8>>,
        export_caps: vector<vector<u8>>, 
        implement_extpoints: vector<vector<u8>>, 
        depend_extpoints: vector<vector<u8>>,
        contract_module: vector<u8>, 
        js_entry_uri: vector<u8>, 
    ) acquires PluginEntry {
        ensure_exists_plugin_nft(Signer::address_of(sender), plugin_id);

        let plugin = borrow_global_mut<PluginEntry<PluginT>>(CoreAddresses::GENESIS_ADDRESS());
        
        let version_number = next_plugin_version_number(plugin);
        Vector::push_back<PluginVersion>(&mut plugin.versions, PluginVersion{
            number: version_number,
            version: version,
            required_caps: required_caps,
            export_caps: export_caps,
            implement_extpoints: implement_extpoints,
            depend_extpoints: depend_extpoints,
            contract_module: contract_module,
            js_entry_uri: js_entry_uri,
            created_at: Timestamp::now_milliseconds(),
        });

        plugin.updated_at = Timestamp::now_milliseconds();
    }

    public fun exists_plugin_version<PluginT>(
        version_number: u64,
    ): bool acquires PluginEntry {
        let plugin = borrow_global_mut<PluginEntry<PluginT>>(CoreAddresses::GENESIS_ADDRESS());
        return version_number > 0 && version_number < plugin.next_version_number
    }
}


module StarcoinFramework::DAOPluginMarketplaceScript {
    use StarcoinFramework::DAOPluginMarketplace;

    public(script) fun initialize() {
        DAOPluginMarketplace::initialize();
    }
}