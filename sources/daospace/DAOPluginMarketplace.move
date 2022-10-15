module StarcoinFramework::DAOPluginMarketplace {
    use StarcoinFramework::GenesisSignerCapability;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Vector;
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
    const ERR_TAG_DUPLICATED: u64 = 107;

    const ERR_VERSION_COUNT_LIMIT: u64 = 108;
    const ERR_ITEMS_COUNT_LIMIT: u64 = 109;
    const ERR_STRING_TOO_LONG: u64 = 110;

    const MAX_VERSION_COUNT: u64 = 5; // Max version count for extension point.
    const MAX_ITEMS_COUNT: u64 = 20; // Max items count for vector.

    const MAX_INPUT_LEN: u64 = 64;
    const MAX_TEXT_LEN: u64 = 256;

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

    fun assert_tag_no_repeat(v: &vector<PluginVersion>, tag:vector<u8>) {
        let i = 0;
        let len = Vector::length(v);
        while (i < len) {
            let e = Vector::borrow(v, i);
            assert!(*&e.tag != *&tag, Errors::invalid_argument(ERR_TAG_DUPLICATED));
            i = i + 1;
        };
    }

    fun assert_string_length(s: &vector<u8>, max_len: u64) {
        let len = Vector::length(s);
        assert!(len <= max_len, Errors::invalid_argument(ERR_STRING_TOO_LONG));
    }

    fun assert_string_array_length(v: &vector<vector<u8>>, max_item_len: u64, max_string_len: u64) {
        assert!(Vector::length(v) <= max_item_len, Errors::limit_exceeded(ERR_ITEMS_COUNT_LIMIT));

        let i = 0;
        let len = Vector::length(v);
        while (i < len) {
            let e = Vector::borrow(v, i);
            assert_string_length(e, max_string_len);
            i = i + 1;
        };
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

        move_to(&signer, PluginRegistry{
            next_plugin_id: 1,
        });

        move_to(&signer, RegistryEventHandlers {
            register: Event::new_event_handle<PluginRegisterEvent>(&signer),
        });
    }

    public fun register_plugin<PluginT: store>(_witness: &PluginT, name: vector<u8>, description: vector<u8>, option_labels: Option<vector<vector<u8>>>): u64 
        acquires PluginRegistry, RegistryEventHandlers {
        assert_string_length(&name, MAX_INPUT_LEN);
        assert_string_length(&description, MAX_TEXT_LEN);

        assert!(!exists<PluginEntry<PluginT>>(CoreAddresses::GENESIS_ADDRESS()), Errors::already_published(ERR_PLUGIN_ALREADY_EXISTS));
        let plugin_registry = borrow_global_mut<PluginRegistry>(CoreAddresses::GENESIS_ADDRESS());
        let plugin_id = next_plugin_id(plugin_registry);

        let genesis_account = GenesisSignerCapability::get_genesis_signer();

        let labels = if(Option::is_some(&option_labels)){
            Option::destroy_some(option_labels)
        } else {
            Vector::empty<vector<u8>>()
        };

        assert_string_array_length(&labels, MAX_ITEMS_COUNT, MAX_INPUT_LEN);

        move_to(&genesis_account, PluginEntry<PluginT>{
            id: copy plugin_id, 
            name: copy name, 
            description: copy description,
            labels: copy labels,
            next_version_number: 1,
            versions: Vector::empty<PluginVersion>(), 
            star_count: 0,
            created_at: Timestamp::now_seconds(),
            updated_at: Timestamp::now_seconds(),
        });

        move_to(&genesis_account, PluginEventHandlers<PluginT>{
            publish_version: Event::new_event_handle<PluginPublishVersionEvent<PluginT>>(&genesis_account),
            star: Event::new_event_handle<StarPluginEvent<PluginT>>(&genesis_account),
            unstar: Event::new_event_handle<UnstarPluginEvent<PluginT>>(&genesis_account),
            update_plugin: Event::new_event_handle<UpdatePluginInfoEvent<PluginT>>(&genesis_account),
        });

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
        _witness: &PluginT,
        tag: vector<u8>,
        implement_extpoints: vector<vector<u8>>, 
        depend_extpoints: vector<vector<u8>>,
        js_entry_uri: vector<u8>, 
    ) acquires PluginEntry, PluginEventHandlers {
        assert_string_length(&tag, MAX_INPUT_LEN);
        assert_string_array_length(&implement_extpoints, MAX_ITEMS_COUNT, MAX_INPUT_LEN);
        assert_string_array_length(&depend_extpoints, MAX_ITEMS_COUNT, MAX_INPUT_LEN);
        assert_string_length(&js_entry_uri, MAX_TEXT_LEN);

        let sender_addr = Signer::address_of(sender);
        let plugin = borrow_global_mut<PluginEntry<PluginT>>(CoreAddresses::GENESIS_ADDRESS());

        assert_tag_no_repeat(&plugin.versions, copy tag);

        // Remove the old version when the number of versions is greater than MAX_VERSION_COUNT
        if (Vector::length(&plugin.versions) >= MAX_VERSION_COUNT) {
            let oldest_version = Vector::remove(&mut plugin.versions, 0);
            let PluginVersion {
                number: _,
                tag: _,
                implement_extpoints: _,
                depend_extpoints: _,
                js_entry_uri: _,
                created_at: _,
            } = oldest_version;
        };
        
        let version_number = next_plugin_version_number(plugin);
        Vector::push_back<PluginVersion>(&mut plugin.versions, PluginVersion{
            number: copy version_number,
            tag: tag,
            implement_extpoints: implement_extpoints,
            depend_extpoints: depend_extpoints,
            js_entry_uri: js_entry_uri,
            created_at: Timestamp::now_seconds(),
        });

        plugin.updated_at = Timestamp::now_seconds();

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
            created_at: Timestamp::now_seconds(),
        });

        let plugin = borrow_global_mut<PluginEntry<PluginT>>(CoreAddresses::GENESIS_ADDRESS());
        plugin.star_count = plugin.star_count + 1;
        plugin.updated_at = Timestamp::now_seconds();

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
        plugin.updated_at = Timestamp::now_seconds();

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

    public fun update_plugin<PluginT>(sender: &signer, _witness: &PluginT, name: vector<u8>, description: vector<u8>, option_labels: Option<vector<vector<u8>>>) acquires PluginEntry, PluginEventHandlers {
        assert_string_length(&name, MAX_INPUT_LEN);
        assert_string_length(&description, MAX_TEXT_LEN);

        let sender_addr = Signer::address_of(sender);
        let plugin = borrow_global_mut<PluginEntry<PluginT>>(CoreAddresses::GENESIS_ADDRESS());

        plugin.name = name;
        plugin.description = description;

        if(Option::is_some(&option_labels)){
            let labels = Option::destroy_some(option_labels);
            assert_string_array_length(&labels, MAX_ITEMS_COUNT, MAX_INPUT_LEN);
            plugin.labels = labels;
        };

        plugin.updated_at = Timestamp::now_seconds();

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
