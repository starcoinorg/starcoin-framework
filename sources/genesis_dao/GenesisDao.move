module StarcoinFramework::GenesisDao{
    use StarcoinFramework::DaoAccount::{Self, DaoAccountCapability};
    use StarcoinFramework::Account;
    use StarcoinFramework::Vector;
    use StarcoinFramework::NFT::{Self, NFT};
    use StarcoinFramework::IdentifierNFT;
    use StarcoinFramework::Signer;
    use StarcoinFramework::DaoRegistry;
    use StarcoinFramework::Token::{Self, Token};
    use StarcoinFramework::Errors;

    const E_NO_GRANTED: u64 = 1;
    
    struct Dao has key{
        id: u64,
        // maybe should use ASIIC String
        name: vector<u8>,
        dao_address: address, 
    }

    struct DaoExt<DaoT: store> has key{
        ext: DaoT,
    }

    struct DaoAccountCapHolder has key{
        cap: DaoAccountCapability,
    }

    struct DaoTokenMintCapHolder<phantom DaoT> has key{
        cap: Token::MintCapability<DaoT>,
    }

    struct DaoTokenBurnCapHolder<phantom DaoT> has key{
        cap: Token::BurnCapability<DaoT>,
    }

    struct DaoNFTMintCapHolder<phantom DaoT> has key{
        cap: NFT::MintCapability<DaoMember<DaoT>>,
    }

    struct DaoNFTBurnCapHolder<phantom DaoT> has key{
        cap: NFT::BurnCapability<DaoMember<DaoT>>,
    }

    struct DaoNFTUpdateCapHolder<phantom DaoT> has key{
        cap: NFT::UpdateCapability<DaoMember<DaoT>>,
    }

    /// A type describing a capability. 
    struct CapType has copy, drop, store { code: u8 }

    /// Creates a upgrade module capability type.
    public fun upgrade_module_cap_type(): CapType { CapType{ code : 0 } }

    /// Creates a withdraw Token capability type.
    public fun withdraw_token_cap_type(): CapType { CapType{ code : 1 } }

    /// Creates a withdraw NFT capability type.
    public fun withdraw_nft_cap_type(): CapType { CapType{ code : 2 } }

    /// Crates a write data to Dao account capability type.
    public fun storage_cap_type(): CapType { CapType{ code : 3 } }

    /// Crates a member capability type.
    /// This cap can issue Dao member NFT or update member's SBT
    public fun member_cap_type(): CapType { CapType{ code : 4 } }


    struct DaoRootCap<phantom DaoT> has drop {}

    struct DaoUpgradeModuleCap<phantom DaoT> has drop{}
  
    struct DaoWithdrawTokenCap<phantom DaoT> has drop{}

    struct DaoWithdrawNFTCap<phantom DaoT> has drop{}

    struct DaoStorageCap<phantom DaoT> has drop{}

    struct DaoMemberCap<phantom DaoT> has drop{}

    /// Grant Dao capabilites to a account
    /// This resource save to the holder's account
    struct KeyHolder<phantom DaoT> has key {
        dao_address: address,
        granted_caps: vector<CapType>, 
    }

    /// Record which accounts are the KeyHolder
    struct KeyHolders has key{
        holders: vector<address>,
    }

    /// The info for Dao installed Plugin
    struct InstalledPluginInfo<phantom PluginT> has key{
        granted_caps: vector<CapType>, 
    }

    /// The Dao member NFT metadata
    struct DaoMember<phantom DaoT> has copy, store, drop {
        //Member id
        id: u64,
    }

    /// The Dao member NFT Body, hold the SBT token
    struct DaoMemberBody<phantom DaoT> has store {
        sbt: Token<DaoT>,
    }

    /// Create a dao with a exists Dao account
    public fun create_dao<DaoT: store>(cap: DaoAccountCapability, name: vector<u8>, ext: DaoT): DaoRootCap<DaoT> {
        let dao_signer = DaoAccount::dao_signer(&cap);

        let dao_address = Signer::address_of(&dao_signer);
        let id = DaoRegistry::register<DaoT>(dao_address);
        let dao = Dao{
            id,
            name: *&name,
            dao_address,
        };

       
        move_to(&dao_signer, dao);
        move_to(&dao_signer, DaoExt{
            ext
        });
        move_to(&dao_signer, DaoAccountCapHolder{
            cap
        });

        Token::register_token<DaoT>(&dao_signer, 1);
        let token_mint_cap = Token::remove_mint_capability<DaoT>(&dao_signer);
        let token_burn_cap = Token::remove_burn_capability<DaoT>(&dao_signer);
        
        move_to(&dao_signer, DaoTokenMintCapHolder{
            cap: token_mint_cap,
        });
        move_to(&dao_signer, DaoTokenBurnCapHolder{
            cap: token_burn_cap,
        });

        let nft_name = name;
        let nft_image = Vector::empty<u8>();
        let nft_description = Vector::empty<u8>();
        let basemeta = NFT::new_meta_with_image_data(nft_name, nft_image, nft_description);

        NFT::register_v2<DaoMember<DaoT>>(&dao_signer, basemeta);
        let nft_mint_cap = NFT::remove_mint_capability<DaoMember<DaoT>>(&dao_signer);
        move_to(&dao_signer, DaoNFTMintCapHolder{
            cap: nft_mint_cap,
        });
        //TODO hold the NFT burn and update cap.
        
        DaoRootCap<DaoT>{}
    }
  
    // Upgrade account to Dao account and create Dao
    public fun upgrade_to_dao<DaoT: store>(sender:signer, name: vector<u8>, ext: DaoT): DaoRootCap<DaoT> {
        let cap = DaoAccount::upgrade_to_dao(sender);
        create_dao<DaoT>(cap, name, ext)
    }


    public fun grant_cap<DaoT: store>(cap: &DaoRootCap<DaoT>, to_signer: &signer, granted_cap: CapType) acquires KeyHolder, KeyHolders{
        let dao_address = dao_address<DaoT>();
        let to_addr = Signer::address_of(to_signer);
        if (exists<KeyHolder<DaoT>>(to_addr)){
            let holder = borrow_global_mut<KeyHolder<DaoT>>(to_addr);
            add_element(&mut holder.granted_caps, granted_cap);
        }else{
            move_to(to_signer, KeyHolder<DaoT>{
                dao_address,
                granted_caps:Vector::singleton(granted_cap),
            });
        };
        //TODO add limit to holders length.
        let holders = borrow_global_mut<KeyHolders>(dao_address);
        add_element(&mut holders.holders, to_addr); 
    }

    public fun grant_caps<DaoT: store>(cap: &DaoRootCap<DaoT>, to_signer: &signer, granted_caps: vector<CapType>){
        //TODO implement batch grant
    }
  
    ///  Install PluginT to Dao and grant the capabilites
    public fun install_plugin<DaoT:store, PluginT>(cap: &DaoRootCap<DaoT>, granted_caps: vector<CapType>) acquires DaoAccountCapHolder{
        //TODO check no repeat item in granted_caps
        let dao_signer = dao_signer<DaoT>();
        //TODO error code
        assert!(!exists<InstalledPluginInfo<PluginT>>(Signer::address_of(&dao_signer)), 1);
        move_to(&dao_signer, InstalledPluginInfo<PluginT>{
            granted_caps,
        });
    }


    // Capability support function

      
    struct StorageItem<V: store> has key{
        item: V,
    }
  
    public fun save<DaoT:store, V: store>(_cap: &DaoStorageCap<DaoT>, item: V) acquires DaoAccountCapHolder{
        let dao_signer = dao_signer<DaoT>();
        //TODO check exists
        move_to(&dao_signer, StorageItem{
            item
        });
    }

    public fun take<DaoT:store, V: store>(_cap: &DaoStorageCap<DaoT>): V acquires StorageItem{
        let dao_address = dao_address<DaoT>();
        //TODO check exists
        let StorageItem{item} = move_from<StorageItem<V>>(dao_address);
        item
    }

    public fun withdraw_token<DaoT:store, TokenT:store>(_cap: &DaoWithdrawTokenCap<DaoT>, amount: u128): Token<TokenT> acquires DaoAccountCapHolder{
        let dao_signer = dao_signer<DaoT>();
        //we should extract the WithdrawCapability from account, and invoke the withdraw_with_cap ?
        Account::withdraw<TokenT>(&dao_signer, amount)
    }

    fun next_member_id(): u64{
        //TODO implement
        0
    }
    
    // Membership function

    /// Join Dao and get a membership
    public fun join_member<DaoT:store>(_cap: &DaoMemberCap<DaoT>, to_signer: &signer, init_sbt: u128) acquires DaoNFTMintCapHolder, DaoAccountCapHolder{
        let to_address = Signer::address_of(to_signer);
        //TODO error code
        assert!(!is_member<DaoT>(to_address), 11);
        
        let member_id = next_member_id();

        let meta = DaoMember<DaoT>{
            id: member_id,
        };

        let dao_address = dao_address<DaoT>();
        let dao_signer = dao_signer<DaoT>();
        let sbt = Token::mint<DaoT>(&dao_signer, init_sbt);

        let body = DaoMemberBody<DaoT>{
            sbt,
        };
        //TODO init base metadata
        let basemeta = NFT::empty_meta();

        let nft_mint_cap = &mut borrow_global_mut<DaoNFTMintCapHolder<DaoT>>(dao_address).cap;

        let nft = NFT::mint_with_cap_v2(dao_address, nft_mint_cap, basemeta, meta, body);
        IdentifierNFT::grant(nft_mint_cap, to_signer, nft);
    }

    /// Member quit Dao by self 
    public fun quit_member<DaoT>(sender: &signer){
        //revoke IdentifierNFT
        //burn NFT
        //burn SBT Token
    }

    /// Revoke membership with cap
    public fun revoke_member<DaoT:store>(_cap: &DaoMemberCap<DaoT>, member_addr: address){
        //revoke IdentifierNFT
        //burn NFT
        //burn SBT Token
    }

    public fun update_member_sbt<DaoT:store>(_cap: &DaoMemberCap<DaoT>, member_addr: address, new_amount: u128){
        //borrow mut the NFT
        // compare sbt and new_amount
        // mint more sbt token or burn sbt token
    }

    /// Check the `member_addr` account is a member of DaoT
    public fun is_member<DaoT: store>(member_addr: address): bool{
        IdentifierNFT::owns<DaoMember<DaoT>, DaoMemberBody<DaoT>>(member_addr)
    }

    //TODO implement more function
    
    // Acquiring Capabilities

    fun validate_key_holder_cap<DaoT:store>(requester: &signer, cap: CapType) acquires KeyHolder{
        let addr = Signer::address_of(requester);
        if (exists<KeyHolder<DaoT>>(addr)) {
            // The signer is a key holder. Check it's granted capabilities.
            let holder = borrow_global<KeyHolder<DaoT>>(addr);
            assert!(Vector::contains(&holder.granted_caps, &cap), Errors::requires_capability(E_NO_GRANTED));
        } else {
            abort(Errors::requires_capability(E_NO_GRANTED))
        }
    }

    fun validate_plugin_cap<DaoT: store, PluginT>(cap: CapType) acquires InstalledPluginInfo{
        let addr = dao_address<DaoT>();
        if (exists<InstalledPluginInfo<PluginT>>(addr)) {
            let plugin_info = borrow_global<InstalledPluginInfo<PluginT>>(addr);
            assert!(Vector::contains(&plugin_info.granted_caps, &cap), Errors::requires_capability(E_NO_GRANTED));
        } else {
            abort(Errors::requires_capability(E_NO_GRANTED))
        }
    }

    /// Acquires the capability of withdraw Token from Dao for KeyHolder. The passed signer must be the KeyHolder with appropriate capabilities.
    public fun acquire_withdraw_token_cap_for_holder<DaoT:store>(requester: &signer): DaoWithdrawTokenCap<DaoT> acquires KeyHolder{
        validate_key_holder_cap<DaoT>(requester, withdraw_token_cap_type());
        DaoWithdrawTokenCap<DaoT>{}
    }

    /// Acquires the capability of withdraw Token from Dao for Plugin. The Plugin with appropriate capabilities. 
    /// _access_key parameter ensure the invoke is from the PluginT module.
    public fun acquire_withdraw_token_cap_for_plugin<DaoT:store, PluginT: drop>(_access_key: PluginT): DaoWithdrawTokenCap<DaoT> acquires InstalledPluginInfo{
        validate_plugin_cap<DaoT, PluginT>(withdraw_token_cap_type());
        DaoWithdrawTokenCap<DaoT>{}
    }

    /// Helpers
    /// ---------------------------------------------------

    /// Helper to remove an element from a vector.
    fun remove_element<E: drop>(v: &mut vector<E>, x: &E) {
        let (found, index) = Vector::index_of(v, x);
        if (found) {
            Vector::remove(v, index);
        }
    }

    /// Helper to add an element to a vector.
    fun add_element<E: drop>(v: &mut vector<E>, x: E) {
        if (!Vector::contains(v, &x)) {
            Vector::push_back(v, x)
        }
    }

    fun dao_signer<DaoT>(): signer acquires DaoAccountCapHolder{
        let cap = &borrow_global<DaoAccountCapHolder>(dao_address<DaoT>()).cap;
        DaoAccount::dao_signer(cap)
    }

    fun dao_address<DaoT>(): address {
        DaoRegistry::dao_address<DaoT>()
    }    
}