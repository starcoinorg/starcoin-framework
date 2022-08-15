module StarcoinFramework::DAOSpace {
    use StarcoinFramework::DAOAccount::{Self, DAOAccountCap};
    use StarcoinFramework::Account;
    use StarcoinFramework::Vector;
    use StarcoinFramework::NFT::{Self, NFT};
    use StarcoinFramework::NFTGallery;
    use StarcoinFramework::IdentifierNFT;
    use StarcoinFramework::Signer;
    use StarcoinFramework::DAORegistry;
    use StarcoinFramework::Token::{Self, Token};
    use StarcoinFramework::Errors;
    use StarcoinFramework::Option::{Self, Option};
    use StarcoinFramework::STC::{STC};
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Config;
    use StarcoinFramework::Event;
    use StarcoinFramework::Math;
    use StarcoinFramework::StarcoinVerifier;
    use StarcoinFramework::StarcoinVerifier::StateProof;
    use StarcoinFramework::BCS;
    use StarcoinFramework::SBTVoteStrategy;
    use StarcoinFramework::SnapshotUtil;
    use StarcoinFramework::Block;


    const ERR_NO_GRANTED: u64 = 100;
    const ERR_REPEAT_ELEMENT: u64 = 101;
    const ERR_PLUGIN_HAS_INSTALLED: u64 = 102;
    const ERR_STORAGE_ERROR: u64 = 103;
    const ERR_NFT_ERROR: u64 = 104;
    const ERR_ALREADY_INIT: u64 = 105;

    /// member
    const ERR_EXPECT_MEMBER: u64 = 200;
    const ERR_EXPECT_NOT_MEMBER: u64 = 2001;

    /// config or arguments
    const ERR_ACTION_DELAY_TOO_SMALL: u64 = 300;
    const ERR_CONFIG_PARAM_INVALID: u64 = 301;
    const ERR_INVALID_AMOUNT:u64 = 302;
    const ERR_TOO_SMALL_TOTAL:u64 = 303;
    const ERR_HAVE_SAME_GRANT:u64 = 304;
    const ERR_NOT_HAVE_GRANT:u64 = 305;

    /// proposal
    const ERR_PROPOSAL_STATE_INVALID: u64 = 400;
    const ERR_PROPOSAL_ID_MISMATCH: u64 = 401;
    const ERR_PROPOSER_MISMATCH: u64 = 402;
    const ERR_PROPOSAL_NOT_EXIST: u64 = 403;
    const ERR_QUORUM_RATE_INVALID: u64 = 404;
    const ERR_PROPOSAL_ACTION_INDEX_NOT_EXIST: u64 = 405;

    /// action
    const ERR_ACTION_MUST_EXIST: u64 = 500;
    const ERR_ACTION_INDEX_INVALID: u64 = 501;
    const ERR_PROPOSAL_ACTIONS_NOT_EXIST: u64 = 502;

    /// vote
    const ERR_VOTE_STATE_MISMATCH: u64 = 600;
    const ERR_VOTED_OTHERS_ALREADY: u64 = 601;
    const ERR_VOTED_ALREADY: u64 = 602;
    const ERR_VOTE_PARAM_INVALID: u64 = 603;
    const ERR_SNAPSHOT_PROOF_PARAM_INVALID: u64 = 604;
    const ERR_STATE_PROOF_VERIFY_INVALID: u64 = 605;

    /// DAO resource, every DAO has this resource at it's DAO account
    struct DAO has key {
        id: u64,
        // TODO migrate ASIIC String and use ASSIC String
        name: vector<u8>,
        // description ipfs://xxxxx
        description:vector<u8>,
        dao_address: address,
        next_member_id: u64,
        next_proposal_id: u64,
    }

    /// A custom extension field of the DAO resources
    struct DAOExt<DAOT: store> has key {
        ext: DAOT,
    }

    /// Configuration of the DAO.
    struct DAOConfig has copy, drop, store {
        /// after proposal created, how long use should wait before he can vote (in milliseconds)
        voting_delay: u64,
        /// how long the voting window is (in milliseconds).
        voting_period: u64,
        /// the quorum rate to agree on the proposal.
        /// if 50% votes needed, then the voting_quorum_rate should be 50.
        /// it should between (0, 100].
        voting_quorum_rate: u8,
        /// how long the proposal should wait before it can be executed (in milliseconds).
        min_action_delay: u64,
        /// how many STC should be deposited to create a proposal.
        min_proposal_deposit: u128,
    }

    struct DAOCustomConfig<ConfigT> has copy, drop, store {
        config: ConfigT
    }

    struct DAOAccountCapHolder has key {
        cap: DAOAccountCap,
    }

    struct DAOTokenMintCapHolder<phantom DAOT> has key {
        cap: Token::MintCapability<DAOT>,
    }

    struct DAOTokenBurnCapHolder<phantom DAOT> has key {
        cap: Token::BurnCapability<DAOT>,
    }

    struct DAONFTMintCapHolder<phantom DAOT> has key {
        cap: NFT::MintCapability<DAOMember<DAOT>>,
    }

    struct DAONFTBurnCapHolder<phantom DAOT> has key {
        cap: NFT::BurnCapability<DAOMember<DAOT>>,
    }

    struct DAONFTUpdateCapHolder<phantom DAOT> has key {
        cap: NFT::UpdateCapability<DAOMember<DAOT>>,
    }

    struct DAOConfigModifyCapHolder has key {
        cap: Config::ModifyConfigCapability<DAOConfig>
    }

    struct DAOCustomConfigModifyCapHolder<phantom DAOT, ConfigT: copy + drop + store> has key {
        cap: Config::ModifyConfigCapability<ConfigT>
    }

    /// A type describing a capability. 
    struct CapType has copy, drop, store { code: u8 }

    /// Creates a install plugin capability type.
    public fun install_plugin_cap_type(): CapType { CapType{ code: 0 } }

    /// Creates a upgrade module capability type.
    public fun upgrade_module_cap_type(): CapType { CapType{ code: 1 } }

    /// Creates a modify dao config capability type.
    public fun modify_config_cap_type(): CapType { CapType{ code: 2 } }

    /// Creates a withdraw Token capability type.
    public fun withdraw_token_cap_type(): CapType { CapType{ code: 3 } }

    /// Creates a withdraw NFT capability type.
    public fun withdraw_nft_cap_type(): CapType { CapType{ code: 4 } }

    /// Creates a write data to DAO account capability type.
    public fun storage_cap_type(): CapType { CapType{ code: 5 } }

    /// Creates a member capability type.
    /// This cap can issue DAO member NFT or update member's SBT
    public fun member_cap_type(): CapType { CapType{ code: 6 } }

    /// Creates a vote capability type.
    public fun proposal_cap_type(): CapType { CapType{ code: 7 } }

    /// Creates a grant capability type.
    public fun grant_cap_type(): CapType { CapType{ code: 8 } }

    /// Creates all capability types.
    public fun all_caps(): vector<CapType> {
        let caps = Vector::singleton(install_plugin_cap_type());
        Vector::push_back(&mut caps, upgrade_module_cap_type());
        Vector::push_back(&mut caps, modify_config_cap_type());
        Vector::push_back(&mut caps, withdraw_token_cap_type());
        Vector::push_back(&mut caps, withdraw_nft_cap_type());
        Vector::push_back(&mut caps, storage_cap_type());
        Vector::push_back(&mut caps, member_cap_type());
        Vector::push_back(&mut caps, proposal_cap_type());
        Vector::push_back(&mut caps, grant_cap_type());
        caps
    }

    /// RootCap only have one instance, and can not been `drop` and `store`
    struct DAORootCap<phantom DAOT> {}

    struct DAOInstallPluginCap<phantom DAOT, phantom PluginT> has drop {}

    struct DAOUpgradeModuleCap<phantom DAOT, phantom PluginT> has drop {}

    struct DAOModifyConfigCap<phantom DAOT, phantom PluginT> has drop {}

    struct DAOWithdrawTokenCap<phantom DAOT, phantom PluginT> has drop {}

    struct DAOWithdrawNFTCap<phantom DAOT, phantom PluginT> has drop {}

    struct DAOStorageCap<phantom DAOT, phantom PluginT> has drop {}

    struct DAOMemberCap<phantom DAOT, phantom PluginT> has drop {}

    struct DAOProposalCap<phantom DAOT, phantom PluginT> has drop {}

    struct DAOGrantCap<phantom DAOT, phantom PluginT> has drop {}

    struct DAOGrantWithdrawTokenKey<phantom DAOT, phantom PluginT ,phantom TokenT> has key, store{
        /// The total amount of tokens that can be withdrawn by this capability
        total: u128,
        /// The amount of tokens that have been withdrawn by this capability
        withdraw: u128,
        /// The time-based linear release start time, timestamp in seconds.
        start_time: u64,
        ///  The time-based linear release period in seconds
        period: u64,
    }

    /// The info for DAO installed Plugin
    struct InstalledPluginInfo<phantom PluginT> has key {
        granted_caps: vector<CapType>,
    }

    /// The DAO member NFT metadata
    struct DAOMember<phantom DAOT> has copy, store, drop {
        //Member id
        id: u64,
    }

    /// The DAO member NFT Body, hold the SBT token
    struct DAOMemberBody<phantom DAOT> has store {
        sbt: Token<DAOT>,
    }

    /// Create a dao with a exists DAO account
    public fun create_dao<DAOT: store>(cap: DAOAccountCap, name: vector<u8>, description: vector<u8>, ext: DAOT, config: DAOConfig): DAORootCap<DAOT> acquires DAOEvent {
        let dao_signer = DAOAccount::dao_signer(&cap);

        let dao_address = Signer::address_of(&dao_signer);
        let id = DAORegistry::register<DAOT>(dao_address);
        let dao = DAO{
            id,
            name: copy name,
            description: copy description,
            dao_address,
            next_member_id: 1,
            next_proposal_id: 1,
        };

        move_to(&dao_signer, dao);
        move_to(&dao_signer, DAOExt{
            ext
        });
        move_to(&dao_signer, DAOAccountCapHolder{
            cap
        });

        Token::register_token<DAOT>(&dao_signer, 1);
        let token_mint_cap = Token::remove_mint_capability<DAOT>(&dao_signer);
        let token_burn_cap = Token::remove_burn_capability<DAOT>(&dao_signer);

        move_to(&dao_signer, DAOTokenMintCapHolder{
            cap: token_mint_cap,
        });
        move_to(&dao_signer, DAOTokenBurnCapHolder{
            cap: token_burn_cap,
        });

        let nft_name = copy name;
        //TODO generate a svg NFT image.
        let nft_image = b"SVG image";
        let nft_description = copy name;
        let basemeta = NFT::new_meta_with_image_data(nft_name, nft_image, nft_description);

        NFT::register_v2<DAOMember<DAOT>>(&dao_signer, basemeta);
        let nft_mint_cap = NFT::remove_mint_capability<DAOMember<DAOT>>(&dao_signer);
        move_to(&dao_signer, DAONFTMintCapHolder{
            cap: nft_mint_cap,
        });

        let nft_burn_cap = NFT::remove_burn_capability<DAOMember<DAOT>>(&dao_signer);
        move_to(&dao_signer, DAONFTBurnCapHolder{
            cap: nft_burn_cap,
        });

        let nft_update_cap = NFT::remove_update_capability<DAOMember<DAOT>>(&dao_signer);
        move_to(&dao_signer, DAONFTUpdateCapHolder{
            cap: nft_update_cap,
        });

        let config_modify_cap = Config::publish_new_config_with_capability(&dao_signer, config);
        move_to(&dao_signer, DAOConfigModifyCapHolder{
            cap: config_modify_cap,
        });

        move_to(&dao_signer, DAOEvent<DAOT>  {
            dao_create_event: Event::new_event_handle<DAOCreatedEvent>(&dao_signer),
        });
        move_to(&dao_signer ,MemberEvent{
            member_join_event_handler:Event::new_event_handle<MemberJoinEvent>(&dao_signer),
            member_quit_event_handler:Event::new_event_handle<MemberQuitEvent>(&dao_signer),
            member_revoke_event_handler:Event::new_event_handle<MemberRevokeEvent>(&dao_signer),
            member_increase_sbt_event_handler:Event::new_event_handle<MemberIncreaseSBTEvent>(&dao_signer),
            member_decrease_sbt_event_handler:Event::new_event_handle<MemberDecreaseSBTEvent>(&dao_signer),
        });
        move_to(&dao_signer, ProposalEvent<DAOT>  {
            proposal_create_event: Event::new_event_handle<ProposalCreatedEvent>(&dao_signer),
            vote_event: Event::new_event_handle<VotedEvent>(&dao_signer),
            proposal_action_event: Event::new_event_handle<ProposalActionEvent>(&dao_signer),
        });

        // dao event emit
        let dao_event = borrow_global_mut<DAOEvent<DAOT> >(dao_address);
        Event::emit_event(&mut dao_event.dao_create_event,
            DAOCreatedEvent {
                id,
                name: copy name,
                description:copy description,
                dao_address,
            },
        );

        DAORootCap<DAOT>{}
    }

    // Upgrade account to DAO account and create DAO
    public fun upgrade_to_dao<DAOT: store>(sender: signer, name: vector<u8>, description:vector<u8>, ext: DAOT, config: DAOConfig): DAORootCap<DAOT> acquires DAOEvent{
        let cap = DAOAccount::upgrade_to_dao(sender);
        create_dao<DAOT>(cap, name, description, ext, config)
    }

    /// Burn the root cap after init the DAO
    public fun burn_root_cap<DAOT>(cap: DAORootCap<DAOT>) {
        let DAORootCap{} = cap;
    }

    /// dao event
    struct DAOEvent<phantom DAOT> has key, store{
        dao_create_event:Event::EventHandle<DAOCreatedEvent>,
    }

    struct DAOCreatedEvent has drop, store{
        id: u64,
        name: vector<u8>,
        description:vector<u8>,
        dao_address: address,
    }

    /// member event
    struct MemberEvent has key, store{
        member_join_event_handler:Event::EventHandle<MemberJoinEvent>,
        member_quit_event_handler:Event::EventHandle<MemberQuitEvent>,
        member_revoke_event_handler:Event::EventHandle<MemberRevokeEvent>,
        member_increase_sbt_event_handler:Event::EventHandle<MemberIncreaseSBTEvent>,
        member_decrease_sbt_event_handler:Event::EventHandle<MemberDecreaseSBTEvent>,
    }

    struct MemberJoinEvent has drop, store{
        /// dao id
        dao_id: u64,
        //Member id
        member_id : u64,
        //address
        addr: address,
        // SBT
        sbt: u128,
    }

    struct MemberRevokeEvent has drop, store{
        /// dao id
        dao_id: u64,
        //Member id
        member_id : u64,
        //address
        addr: address,
        // SBT
        sbt: u128,
    }

    struct MemberQuitEvent has drop, store{
        /// dao id
        dao_id: u64,
        //Member id
        member_id : u64,
        //address
        addr: address,
        // SBT
        sbt: u128,
    }

    struct MemberIncreaseSBTEvent has drop, store{
        //Member id
        member_id : u64,
        //address
        addr: address,
        //increase sbt amount
        increase_sbt:u128 ,
        // SBT
        sbt: u128,
    }
    
    struct MemberDecreaseSBTEvent has drop, store{
        //Member id
        member_id : u64,
        //address
        addr: address,
        //decrease sbt amount
        decrease_sbt:u128 ,
        // SBT
        sbt: u128,
    }

    // Capability support function


    /// Install ToInstallPluginT to DAO and grant the capabilites
    public fun install_plugin_with_root_cap<DAOT: store, ToInstallPluginT:store>(_cap: &DAORootCap<DAOT>, granted_caps: vector<CapType>) acquires DAOAccountCapHolder {
        do_install_plugin<DAOT, ToInstallPluginT>(granted_caps);
    }

    /// Install plugin with DAOInstallPluginCap
    public fun install_plugin<DAOT: store, PluginT:store, ToInstallPluginT:store>(_cap: &DAOInstallPluginCap<DAOT, PluginT>, granted_caps: vector<CapType>) acquires DAOAccountCapHolder {
        do_install_plugin<DAOT, ToInstallPluginT>(granted_caps);
    }

    fun do_install_plugin<DAOT: store, ToInstallPluginT:store>(granted_caps: vector<CapType>) acquires DAOAccountCapHolder {
        assert_no_repeat(&granted_caps);
        let dao_signer = dao_signer<DAOT>();
        assert!(!exists<InstalledPluginInfo<ToInstallPluginT>>(Signer::address_of(&dao_signer)), Errors::already_published(ERR_PLUGIN_HAS_INSTALLED));
        move_to(&dao_signer, InstalledPluginInfo<ToInstallPluginT>{
            granted_caps,
        });
    }

    // ModuleUpgrade functions

    /// Submit upgrade module plan
    public fun submit_upgrade_plan<DAOT: store, PluginT>(_cap: &DAOUpgradeModuleCap<DAOT, PluginT>, package_hash: vector<u8>, version: u64, enforced: bool) acquires DAOAccountCapHolder {
        let dao_account_cap = &mut borrow_global_mut<DAOAccountCapHolder>(dao_address<DAOT>()).cap;
        DAOAccount::submit_upgrade_plan(dao_account_cap, package_hash, version, enforced);
    }

    // Storage capability function

    struct StorageItem<phantom PluginT, V: store> has key {
        item: V,
    }

    /// Save the item to the storage
    public fun save<DAOT: store, PluginT, V: store>(_cap: &DAOStorageCap<DAOT, PluginT>, item: V) acquires DAOAccountCapHolder {
        let dao_signer = dao_signer<DAOT>();
        assert!(!exists<StorageItem<PluginT, V>>(Signer::address_of(&dao_signer)), Errors::already_published(ERR_STORAGE_ERROR));
        move_to(&dao_signer, StorageItem<PluginT, V>{
            item
        });
    }

    /// Get the item from the storage
    public fun take<DAOT: store, PluginT, V: store>(_cap: &DAOStorageCap<DAOT, PluginT>): V acquires StorageItem {
        let dao_address = dao_address<DAOT>();
        assert!(exists<StorageItem<PluginT, V>>(dao_address), Errors::not_published(ERR_STORAGE_ERROR));
        let StorageItem{ item } = move_from<StorageItem<PluginT, V>>(dao_address);
        item
    }

    // Withdraw Token capability function

    /// Withdraw the token from the DAO account
    public fun withdraw_token<DAOT: store, PluginT, TokenT: store>(_cap: &DAOWithdrawTokenCap<DAOT, PluginT>, amount: u128): Token<TokenT> acquires DAOAccountCapHolder {
        let dao_signer = dao_signer<DAOT>();
        //we should extract the WithdrawCapability from account, and invoke the withdraw_with_cap ?
        Account::withdraw<TokenT>(&dao_signer, amount)
    }

    // NFT capability function

    /// Withdraw the NFT from the DAO account
    public fun withdraw_nft<DAOT: store, PluginT, NFTMeta: store + copy + drop, NFTBody: store>(_cap: &DAOWithdrawNFTCap<DAOT, PluginT>, id: u64): NFT<NFTMeta, NFTBody> acquires DAOAccountCapHolder {
        let dao_signer = dao_signer<DAOT>();
        let nft = NFTGallery::withdraw<NFTMeta, NFTBody>(&dao_signer, id);
        assert!(Option::is_some(&nft), Errors::not_published(ERR_NFT_ERROR));
        Option::destroy_some(nft)
    }

    // Membership function

    /// Join DAO and get a membership
    public fun join_member<DAOT: store, PluginT>(_cap: &DAOMemberCap<DAOT, PluginT>, to_address: address, init_sbt: u128) acquires DAONFTMintCapHolder, DAOTokenMintCapHolder, DAO, MemberEvent {
        ensure_not_member<DAOT>(to_address);
        let member_id = next_member_id<DAOT>();

        let meta = DAOMember<DAOT>{
            id: member_id,
        };

        let dao_address = dao_address<DAOT>();

        let token_mint_cap = &borrow_global_mut<DAOTokenMintCapHolder<DAOT>>(dao_address).cap;
        let sbt = Token::mint_with_capability<DAOT>(token_mint_cap, init_sbt);

        let body = DAOMemberBody<DAOT>{
            sbt,
        };

        let dao = borrow_global<DAO>(dao_address);
        let nft_name = *&dao.name;
        //TODO generate a svg NFT image.
        let nft_image = b"SVG image";
        let nft_description = *&dao.name;
        let basemeta = NFT::new_meta_with_image_data(nft_name, nft_image, nft_description);

        let nft_mint_cap = &mut borrow_global_mut<DAONFTMintCapHolder<DAOT>>(dao_address).cap;

        let nft = NFT::mint_with_cap_v2(dao_address, nft_mint_cap, basemeta, meta, body);
        IdentifierNFT::grant_to(nft_mint_cap, to_address, nft);
        let memeber_event = borrow_global_mut<MemberEvent>(dao_address);
        Event::emit_event(&mut memeber_event.member_join_event_handler, MemberJoinEvent {
            dao_id: dao_id(dao_address),
            member_id,
            addr:to_address,
            sbt: init_sbt,
        });
    }

    /// Member quit DAO by self
    public (script) fun quit_member_entry<DAOT: store>(sender: signer) acquires DAONFTBurnCapHolder, DAOTokenBurnCapHolder, MemberEvent, DAO {
        quit_member<DAOT>(&sender);
    }

        /// Member quit DAO by self
    public fun quit_member<DAOT: store>(sender: &signer) acquires DAONFTBurnCapHolder, DAOTokenBurnCapHolder, MemberEvent, DAO {
        let member_addr = Signer::address_of(sender);
        let (member_id , sbt) = do_remove_member<DAOT>(member_addr);
        let dao_address = dao_address<DAOT>();

        let memeber_event = borrow_global_mut<MemberEvent>(dao_address);
        Event::emit_event(&mut memeber_event.member_quit_event_handler, MemberQuitEvent {
            dao_id: dao_id(dao_address),
            member_id,
            addr:member_addr,
            sbt: sbt,
        });
    }

    /// Revoke membership with cap
    public fun revoke_member<DAOT: store, PluginT>(_cap: &DAOMemberCap<DAOT, PluginT>, member_addr: address) acquires DAONFTBurnCapHolder, DAOTokenBurnCapHolder, MemberEvent, DAO {
        let (member_id , sbt) = do_remove_member<DAOT>(member_addr);
        let dao_address = dao_address<DAOT>();
        
        let memeber_event = borrow_global_mut<MemberEvent>(dao_address);
        Event::emit_event(&mut memeber_event.member_revoke_event_handler, MemberRevokeEvent {
            dao_id: dao_id(dao_address),
            member_id,
            addr:member_addr,
            sbt: sbt,
        });
    }

    public fun ensure_member<DAOT: store>(member_addr:address){
        assert!(is_member<DAOT>(member_addr), Errors::invalid_state(ERR_EXPECT_MEMBER));
    }

    public fun ensure_not_member<DAOT: store>(member_addr:address){
        assert!(!is_member<DAOT>(member_addr), Errors::invalid_state(ERR_EXPECT_NOT_MEMBER));
    }

    fun do_remove_member<DAOT: store>(member_addr: address):(u64,u128) acquires DAONFTBurnCapHolder, DAOTokenBurnCapHolder {
        ensure_member<DAOT>(member_addr);
        let dao_address = dao_address<DAOT>();

        let nft_burn_cap = &mut borrow_global_mut<DAONFTBurnCapHolder<DAOT>>(dao_address).cap;
        let nft = IdentifierNFT::revoke<DAOMember<DAOT>, DAOMemberBody<DAOT>>(nft_burn_cap, member_addr);
        let member_id = NFT::get_type_meta<DAOMember<DAOT>, DAOMemberBody<DAOT>>(&nft).id;
        let DAOMemberBody<DAOT>{ sbt } = NFT::burn_with_cap(nft_burn_cap, nft);
        let sbt_amount = Token::value<DAOT>(&sbt);
        let token_burn_cap = &mut borrow_global_mut<DAOTokenBurnCapHolder<DAOT>>(dao_address).cap;
        Token::burn_with_capability(token_burn_cap, sbt);
        (member_id, sbt_amount)
    }

    /// Increment the member SBT
    public fun increase_member_sbt<DAOT: store, PluginT>(_cap: &DAOMemberCap<DAOT, PluginT>, member_addr: address, amount: u128) acquires DAONFTUpdateCapHolder, DAOTokenMintCapHolder, MemberEvent {
        ensure_member<DAOT>(member_addr);
        let dao_address = dao_address<DAOT>();

        let nft_update_cap = &mut borrow_global_mut<DAONFTUpdateCapHolder<DAOT>>(dao_address).cap;
        let borrow_nft = IdentifierNFT::borrow_out<DAOMember<DAOT>, DAOMemberBody<DAOT>>(nft_update_cap, member_addr);
        let nft = IdentifierNFT::borrow_nft_mut(&mut borrow_nft);
        let member_id = NFT::get_type_meta<DAOMember<DAOT>, DAOMemberBody<DAOT>>(nft).id;
        
        let body = NFT::borrow_body_mut_with_cap(nft_update_cap, nft);

        let token_mint_cap = &mut borrow_global_mut<DAOTokenMintCapHolder<DAOT>>(dao_address).cap;
        let increase_sbt = Token::mint_with_capability<DAOT>(token_mint_cap, amount);
        Token::deposit(&mut body.sbt, increase_sbt);

        let sbt_amount = Token::value<DAOT>(&body.sbt);
        IdentifierNFT::return_back(borrow_nft);

        let memeber_event = borrow_global_mut<MemberEvent>(dao_address);
        Event::emit_event(&mut memeber_event.member_increase_sbt_event_handler, MemberIncreaseSBTEvent {
            member_id,
            addr:member_addr,
            increase_sbt:amount,
            sbt: sbt_amount,
        });
    }

    /// Decrement the member SBT
    public fun decrease_member_sbt<DAOT: store, PluginT>(_cap: &DAOMemberCap<DAOT, PluginT>, member_addr: address, amount: u128) acquires DAONFTUpdateCapHolder, DAOTokenBurnCapHolder, MemberEvent {
        ensure_member<DAOT>(member_addr);
        let dao_address = dao_address<DAOT>();

        let nft_update_cap = &mut borrow_global_mut<DAONFTUpdateCapHolder<DAOT>>(dao_address).cap;
        let borrow_nft = IdentifierNFT::borrow_out<DAOMember<DAOT>, DAOMemberBody<DAOT>>(nft_update_cap, member_addr);
        let nft = IdentifierNFT::borrow_nft_mut(&mut borrow_nft);
        let member_id = NFT::get_type_meta<DAOMember<DAOT>, DAOMemberBody<DAOT>>(nft).id;
        
        let body = NFT::borrow_body_mut_with_cap(nft_update_cap, nft);

        let token_burn_cap = &mut borrow_global_mut<DAOTokenBurnCapHolder<DAOT>>(dao_address).cap;
        let decrease_sbt = Token::withdraw(&mut body.sbt, amount);
        let sbt_amount = Token::value<DAOT>(&body.sbt);
       
        Token::burn_with_capability(token_burn_cap, decrease_sbt);
        IdentifierNFT::return_back(borrow_nft);

        let memeber_event = borrow_global_mut<MemberEvent>(dao_address);
        Event::emit_event(&mut memeber_event.member_decrease_sbt_event_handler, MemberDecreaseSBTEvent {
            member_id,
            addr:member_addr,
            decrease_sbt:amount,
            sbt: sbt_amount,
        });
    }

    /// Query amount of the member SBT
    public fun query_sbt<DAOT: store, PluginT>(member_addr: address)
    : u128 acquires DAONFTUpdateCapHolder {
        if (!is_member<DAOT>(member_addr)) {
            return 0
        };
        let dao_address = dao_address<DAOT>();

        let nft_update_cap =
            &mut borrow_global_mut<DAONFTUpdateCapHolder<DAOT>>(dao_address).cap;
        let borrow_nft =
            IdentifierNFT::borrow_out<DAOMember<DAOT>, DAOMemberBody<DAOT>>(nft_update_cap, member_addr);
        let nft = IdentifierNFT::borrow_nft(&mut borrow_nft);
        let body = NFT::borrow_body(nft);

        let result = Token::value(&body.sbt);
        IdentifierNFT::return_back(borrow_nft);
        result
    }

    /// Check the `member_addr` account is a member of DAOT
    public fun is_member<DAOT: store>(member_addr: address): bool {
        IdentifierNFT::owns<DAOMember<DAOT>, DAOMemberBody<DAOT>>(member_addr)
    }

    /// Grant Event

    struct GrantEvent<phantom PluginT> has key, store{
        create_grant_event_handler:Event::EventHandle<GrantCreateEvent<PluginT>>,
        revoke_grant_event_handler:Event::EventHandle<GrantRevokeEvent<PluginT>>,
        config_grant_event_handler:Event::EventHandle<GrantConfigEvent<PluginT>>,
        withdraw_grant_event_handler:Event::EventHandle<GrantWithdrawEvent<PluginT>>,
        refund_grant_event_handler:Event::EventHandle<GrantRefundEvent<PluginT>>,
    }

    struct GrantCreateEvent<phantom PluginT> has drop, store{
        dao_id: u64,
        total:u128,
        start_time:u64,
        period:u64,
        now_time:u64,
        token: Token::TokenCode
    }

    struct GrantRevokeEvent<phantom PluginT>  has drop, store{
        dao_id: u64,
        total:u128,
        withdraw:u128,
        start_time:u64,
        period:u64,
        token: Token::TokenCode
    }

    struct GrantRefundEvent<phantom PluginT>  has drop, store{
        dao_id: u64,
        total:u128,
        withdraw:u128,
        start_time:u64,
        period:u64,
        token: Token::TokenCode
    }

    struct GrantConfigEvent<phantom PluginT>  has drop, store{
        dao_id: u64,
        old_grantee:address,
        new_grantee:address,
        total:u128,
        withdraw:u128,
        start_time:u64,
        period:u64,
        token: Token::TokenCode
    }

    struct GrantWithdrawEvent<phantom PluginT>  has drop, store{
        dao_id: u64,
        total:u128,
        withdraw:u128,
        start_time:u64,
        period:u64,
        withdraw_value:u128,
        token: Token::TokenCode
    }


    struct GrantInfo has copy, drop ,store{
        total:u128,
        withdraw:u128,
        start_time:u64,
        period:u64
    }

    /// Grant function

    /// create grant and init/emit a event
    public fun create_grant<DAOT, PluginT:store , TokenT:store>(_cap:&DAOGrantCap<DAOT, PluginT>, sender: &signer, total:u128, start_time:u64, period:u64) acquires DAOAccountCapHolder, GrantEvent, DAO {
        let dao_signer = dao_signer<DAOT>();
        let dao_address = dao_address<DAOT>();
        let account_address = Signer::address_of(sender);

        if(! exists<GrantEvent<PluginT>>(dao_address)){
            move_to(&dao_signer, GrantEvent<PluginT>{
                create_grant_event_handler:Event::new_event_handle<GrantCreateEvent<PluginT>>(&dao_signer),
                revoke_grant_event_handler:Event::new_event_handle<GrantRevokeEvent<PluginT>>(&dao_signer),
                config_grant_event_handler:Event::new_event_handle<GrantConfigEvent<PluginT>>(&dao_signer),
                withdraw_grant_event_handler:Event::new_event_handle<GrantWithdrawEvent<PluginT>>(&dao_signer),
                refund_grant_event_handler:Event::new_event_handle<GrantRefundEvent<PluginT>>(&dao_signer),
            });
        };
        let grant_event = borrow_global_mut<GrantEvent<PluginT>>(dao_address);

        Event::emit_event(&mut grant_event.create_grant_event_handler, GrantCreateEvent<PluginT> {
            dao_id:dao_id(dao_address),
            total:total,
            start_time:start_time,
            period:period,
            now_time:Timestamp::now_seconds(),
            token: Token::token_code<TokenT>()
        });

        assert!(! exists<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(account_address) , Errors::invalid_state(ERR_HAVE_SAME_GRANT));
        move_to(sender, DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>{
                            total:total,
                            withdraw: 0 ,
                            start_time:start_time,
                            period:period  
                        });
    }

    /// withdraw token with grant 
    public (script) fun grant_withdraw_entry<DAOT, PluginT:store, TokenT:store>(sender: signer, amount:u128) acquires DAOAccountCapHolder, DAOGrantWithdrawTokenKey, GrantEvent, DAO{
        grant_withdraw<DAOT, PluginT, TokenT>(&sender, amount);
    }

    /// withdraw token with grant 
    public fun grant_withdraw<DAOT, PluginT:store, TokenT:store>(sender: &signer, amount:u128) acquires DAOAccountCapHolder, DAOGrantWithdrawTokenKey, GrantEvent, DAO{
        let account_address = Signer::address_of(sender);
        assert!(exists<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(account_address) , Errors::invalid_state(ERR_NOT_HAVE_GRANT));
        
        let cap = borrow_global_mut<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(account_address);
        let now = Timestamp::now_seconds();
        let elapsed_time = now - cap.start_time;
        let can_amount =  if (elapsed_time >= cap.period) {
            cap.total - cap.withdraw
        } else {
            Math::mul_div(cap.total, (elapsed_time as u128), (cap.period as u128)) - cap.withdraw
        };
        
        assert!(can_amount > 0, Errors::invalid_argument(ERR_INVALID_AMOUNT));
        assert!(can_amount >= amount, Errors::invalid_argument(ERR_INVALID_AMOUNT));

        let dao_signer = dao_signer<DAOT>();
        let dao_address = dao_address<DAOT>();

        assert!(amount <= Account::balance<TokenT>(dao_address) , Errors::invalid_argument(ERR_INVALID_AMOUNT));
        cap.withdraw = cap.withdraw + amount;

        let grant_event = borrow_global_mut<GrantEvent<PluginT>>(dao_address);
        Event::emit_event(&mut grant_event.withdraw_grant_event_handler, GrantWithdrawEvent<PluginT> {
            dao_id:dao_id(dao_address),
            total:cap.total,
            withdraw:cap.withdraw,
            start_time:cap.start_time,
            period:cap.period,
            withdraw_value:amount,
            token: Token::token_code<TokenT>()
        });
        let token = Account::withdraw<TokenT>(&dao_signer, amount);
        Account::deposit<TokenT>(account_address, token);
    }

    public fun query_grant_can_withdraw<DAOT, PluginT:store, TokenT:store>(addr: address):u128 acquires DAOGrantWithdrawTokenKey{
        assert!(exists<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(addr) , Errors::invalid_state(ERR_NOT_HAVE_GRANT));
        let cap = borrow_global<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(addr);
        let now = Timestamp::now_seconds();
        let elapsed_time = now - cap.start_time;
        if (elapsed_time >= cap.period) {
            cap.total - cap.withdraw
        } else {
            Math::mul_div(cap.total, (elapsed_time as u128), (cap.period as u128)) - cap.withdraw
        }
    }
    /// is have DAOGrantWithdrawTokenKey
    public fun is_have_grant<DAOT, PluginT, TokenT:store>(addr:address):bool{
        exists<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(addr)
    }
    /// revoke grant 
    public fun grant_revoke<DAOT, PluginT:store , TokenT:store>(_cap:&DAOGrantCap<DAOT, PluginT>, grantee: address) acquires DAOGrantWithdrawTokenKey, GrantEvent, DAO{
        let dao_address = dao_address<DAOT>();
        assert!(exists<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(grantee) , Errors::invalid_state(ERR_NOT_HAVE_GRANT));
        
        let DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>{
            total:total,
            withdraw:withdraw,
            start_time:start_time,
            period:period
        } = move_from<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(grantee);

        let grant_event = borrow_global_mut<GrantEvent<PluginT>>(dao_address);
        Event::emit_event(&mut grant_event.revoke_grant_event_handler, GrantRevokeEvent<PluginT> {
            dao_id:dao_id(dao_address),
            total:total,
            withdraw:withdraw,
            start_time:start_time,
            period:period,
            token: Token::token_code<TokenT>()
        });
    }

    /// Reset the parameters of the grant 
    public fun grant_config<DAOT, PluginT:store , TokenT:store>(_cap:&DAOGrantCap<DAOT, PluginT>, old_grantee: address, sender: &signer, total:u128, start_time:u64, period:u64) acquires DAOGrantWithdrawTokenKey, GrantEvent, DAO {
        let dao_address = dao_address<DAOT>();
        let new_grantee = Signer::address_of(sender);
        assert!(exists<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(old_grantee) , Errors::invalid_state(ERR_NOT_HAVE_GRANT));
        
        if( old_grantee != new_grantee){
            assert!(!exists<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(new_grantee) , Errors::invalid_state(ERR_HAVE_SAME_GRANT));
            move_to(sender, move_from<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(old_grantee));
        };

        let cap = borrow_global_mut<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(new_grantee);
        assert!( total >= cap.withdraw , Errors::invalid_argument(ERR_TOO_SMALL_TOTAL));
        cap.total = total;
        cap.start_time = start_time;
        cap.period = period;

        let grant_event = borrow_global_mut<GrantEvent<PluginT>>(dao_address);
        
        Event::emit_event(&mut grant_event.config_grant_event_handler, GrantConfigEvent<PluginT> {
            dao_id:dao_id(dao_address),
            old_grantee:old_grantee,
            new_grantee:new_grantee,
            total:cap.total,
            withdraw:cap.withdraw,
            start_time:cap.start_time,
            period:cap.period,
            token: Token::token_code<TokenT>()
        });
    }

    // Refund the grant
    public fun refund_grant<DAOT, PluginT:store , TokenT:store>(sender: &signer) acquires DAOGrantWithdrawTokenKey, GrantEvent, DAO {
        let dao_address = dao_address<DAOT>();
        let grantee = Signer::address_of(sender);
        assert!(exists<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(grantee) , Errors::invalid_state(ERR_NOT_HAVE_GRANT));
        let DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>{
            total:total,
            withdraw:withdraw,
            start_time:start_time,
            period:period
        } = move_from<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(grantee);

        let grant_event = borrow_global_mut<GrantEvent<PluginT>>(dao_address);
        Event::emit_event(&mut grant_event.refund_grant_event_handler, GrantRefundEvent<PluginT> {
            dao_id:dao_id(dao_address),
            total:total,
            withdraw:withdraw,
            start_time:start_time,
            period:period,
            token: Token::token_code<TokenT>()
        });
    }

    public (script) fun refund_grant_entry<DAOT, PluginT:store , TokenT:store>(sender: signer) acquires DAOGrantWithdrawTokenKey, GrantEvent, DAO {
        refund_grant<DAOT, PluginT, TokenT>(&sender);
    }

    // Query address grant 
    public fun query_grant<DAOT, PluginT , TokenT:store>(addr: address): GrantInfo acquires DAOGrantWithdrawTokenKey{
        assert!(exists<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(addr) , Errors::invalid_state(ERR_NOT_HAVE_GRANT));
        let cap = borrow_global<DAOGrantWithdrawTokenKey<DAOT, PluginT, TokenT>>(addr);
        GrantInfo{
           total        :   cap.total,
           withdraw     :   cap.withdraw,
           start_time   :   cap.start_time,
           period       :   cap.period
        }
    }

    // Query grant info total
    public fun query_grant_info_total(grant_info: &GrantInfo):u128{
        grant_info.total
    }

    // Query grant info withdraw
    public fun query_grant_info_withdraw(grant_info: &GrantInfo):u128{
        grant_info.withdraw
    }
    
    // Query grant info start_time
    public fun query_grant_info_start_time(grant_info: &GrantInfo):u64{
        grant_info.start_time
    }

    // Query grant info period
    public fun query_grant_info_period(grant_info: &GrantInfo):u64{
        grant_info.period
    }

    // Acquiring Capabilities
    fun validate_cap<DAOT: store, PluginT>(cap: CapType) acquires InstalledPluginInfo {
        let addr = dao_address<DAOT>();
        if (exists<InstalledPluginInfo<PluginT>>(addr)) {
            let plugin_info = borrow_global<InstalledPluginInfo<PluginT>>(addr);
            assert!(Vector::contains(&plugin_info.granted_caps, &cap), Errors::requires_capability(ERR_NO_GRANTED));
        } else {
            abort (Errors::requires_capability(ERR_NO_GRANTED))
        }
    }

    /// Acquire the installed plugin capability
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_install_plugin_cap<DAOT: store, PluginT>(_witness: &PluginT): DAOInstallPluginCap<DAOT, PluginT> acquires InstalledPluginInfo {
        validate_cap<DAOT, PluginT>(install_plugin_cap_type());
        DAOInstallPluginCap<DAOT, PluginT>{}
    }

    /// Acquire the upgrade module capability
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_upgrade_module_cap<DAOT: store, PluginT>(_witness: &PluginT): DAOUpgradeModuleCap<DAOT, PluginT> acquires InstalledPluginInfo {
        validate_cap<DAOT, PluginT>(upgrade_module_cap_type());
        DAOUpgradeModuleCap<DAOT, PluginT>{}
    }

    /// Acquire the modify config capability
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_modify_config_cap<DAOT: store, PluginT>(_witness: &PluginT): DAOModifyConfigCap<DAOT, PluginT> acquires InstalledPluginInfo {
        validate_cap<DAOT, PluginT>(modify_config_cap_type());
        DAOModifyConfigCap<DAOT, PluginT>{}
    }

    /// Acquires the withdraw Token capability 
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_withdraw_token_cap<DAOT: store, PluginT>(_witness: &PluginT): DAOWithdrawTokenCap<DAOT, PluginT> acquires InstalledPluginInfo {
        validate_cap<DAOT, PluginT>(withdraw_token_cap_type());
        DAOWithdrawTokenCap<DAOT, PluginT>{}
    }

    /// Acquires the withdraw NFT capability
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_withdraw_nft_cap<DAOT: store, PluginT>(_witness: &PluginT): DAOWithdrawNFTCap<DAOT, PluginT> acquires InstalledPluginInfo {
        validate_cap<DAOT, PluginT>(withdraw_nft_cap_type());
        DAOWithdrawNFTCap<DAOT, PluginT>{}
    }

    /// Acquires the storage capability
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_storage_cap<DAOT: store, PluginT>(_witness: &PluginT): DAOStorageCap<DAOT, PluginT> acquires InstalledPluginInfo {
        validate_cap<DAOT, PluginT>(storage_cap_type());
        DAOStorageCap<DAOT, PluginT>{}
    }

    /// Acquires the membership capability
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_member_cap<DAOT: store, PluginT>(_witness: &PluginT): DAOMemberCap<DAOT, PluginT> acquires InstalledPluginInfo {
        validate_cap<DAOT, PluginT>(member_cap_type());
        DAOMemberCap<DAOT, PluginT>{}
    }

    /// Acquire the proposql capability
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_proposal_cap<DAOT: store, PluginT>(_witness: &PluginT): DAOProposalCap<DAOT, PluginT> acquires InstalledPluginInfo {
        validate_cap<DAOT, PluginT>(proposal_cap_type());
        DAOProposalCap<DAOT, PluginT>{}
    }

    /// Acquire the grant capability
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_grant_cap<DAOT: store, PluginT>(_witness: &PluginT): DAOGrantCap<DAOT, PluginT> acquires InstalledPluginInfo {
        validate_cap<DAOT, PluginT>(grant_cap_type());
        DAOGrantCap<DAOT, PluginT>{}
    }

    /// Proposal
    /// --------------------------------------------------
      /// Proposal state
    const PENDING: u8 = 1;
    const ACTIVE: u8 = 2;
    const DEFEATED: u8 = 3;
    const AGREED: u8 = 4;
    const QUEUED: u8 = 5;
    const EXECUTABLE: u8 = 6;
    const EXTRACTED: u8 = 7;

    struct ProposalState has copy, drop, store { state: u8 }

    /// voting choice: 1:yes, 2:no, 3: no_with_veto, 4:abstain
    const VOTING_CHOICE_YES: u8 = 1;
    const VOTING_CHOICE_NO: u8 = 2;
    // Review: How to prevent spam, cosmos provide a NO_WITH_VETO option, and the proposer need deposit some Token when create proposal.
    // this choice from  https://docs.cosmos.network/master/modules/gov/01_concepts.html
    const VOTING_CHOICE_NO_WITH_VETO: u8 = 3;
    const VOTING_CHOICE_ABSTAIN: u8 = 4;

    struct VotingChoice has copy, drop, store {
        choice: u8,
    }

    public fun choice_yes(): VotingChoice { VotingChoice{ choice: VOTING_CHOICE_YES } }

    public fun choice_no(): VotingChoice { VotingChoice{ choice: VOTING_CHOICE_NO } }

    /// no_with_veto counts as no but also adds a veto vote
    public fun choice_no_with_veto(): VotingChoice { VotingChoice{ choice: VOTING_CHOICE_NO_WITH_VETO } }

    public fun choice_abstain(): VotingChoice { VotingChoice{ choice: VOTING_CHOICE_ABSTAIN } }

    /// Proposal data struct.
    /// review: it is safe to has `copy` and `drop`?
    struct Proposal has store, copy, drop {
        /// id of the proposal
        id: u64,
        /// creator of the proposal
        proposer: address,
        /// description of proposal , ipfs://
        description:vector<u8>,
        /// when voting begins.
        start_time: u64,
        /// when voting ends.
        end_time: u64,
        /// count of voters who `yes|no|abstain` with the proposal
        yes_votes: u128,
        no_votes: u128,
        abstain_votes: u128,
        /// no_with_veto counts as no but also adds a veto vote
        veto_votes: u128,
        /// executable after this time.
        eta: u64,
        /// after how long, the agreed proposal can be executed.
        action_delay: u64,
        /// how many votes to reach to make the proposal pass.
        quorum_votes: u128,
        /// the block number when submit proposal 
        block_number: u64,
        /// the state root of the block which has the block_number 
        state_root: vector<u8>,
    }

    struct ProposalAction<Action: store> has store {
        /// id of the proposal
        proposal_id: u64,
        //To prevent spam, proposals must be submitted with a deposit
        //TODO should support custom Token?
        deposit: Token<STC>,
        /// proposal action.
        action: Action,
    }

    struct ProposalActionIndex has store, drop {
        /// id of the proposal
        proposal_id: u64,
    }

    /// Same as Proposal but has copy and drop
    struct ProposalInfo has store, copy, drop {
        //TODO add fields
    }

    /// Keep a global proposal record for query proposal by id.
    /// Replace with Table when support Table.
    struct   GlobalProposals has key {
        proposals: vector<Proposal>,
    }

    /// Every ActionT keep a vector in the DAO account
    struct ProposalActions<ActionT : store> has key {
        actions: vector<ProposalAction<ActionT>>,
    }


    /// Keep a global proposal action record for query action by proposal_id.
    /// Replace with Table when support Table.
    struct GlobalProposalActions has key {
        proposal_action_indexs: vector<ProposalActionIndex>,
    }

    /// User vote.
    struct Vote has store {
        /// proposal id.
        proposal_id: u64,
        /// vote weight
        vote_weight: u128,
        /// vote choise
        choice: u8,
    }

    /// User vote info. has drop cap
    struct VoteInfo has store, drop {
        /// proposal id.
        proposal_id: u64,
        /// vote weight
        vote_weight: u128,
        /// vote choise
        choice: u8,
    }

    /// Every voter keep a vector Vote for per DAO
    struct MyVotes<phantom DAOT> has key {
        votes: vector<Vote>,
    }

    /// use bcs se/de for Snapshot proofs
    struct SnapshotProof has store, drop, copy {
        state: vector<u8>,
        account_state: vector<u8>,
        account_proof_leaf: HashNode,
        account_proof_siblings: vector<vector<u8>>,
        account_state_proof_leaf: HashNode,
        account_state_proof_siblings: vector<vector<u8>>,
    }

    struct HashNode has store, drop, copy {
        hash1: vector<u8>,
        hash2: vector<u8>,
    }

    /// proposal event
    struct ProposalEvent<phantom DAOT: store> has key, store {
        /// proposal creating event.
        proposal_create_event: Event::EventHandle<ProposalCreatedEvent>,
        /// voting event.
        vote_event: Event::EventHandle<VotedEvent>,
        /// proposal action event.
        proposal_action_event: Event::EventHandle<ProposalActionEvent>,
    }

    /// emitted when proposal created.
    struct ProposalCreatedEvent has drop, store {
        /// dao id
        dao_id: u64,
        /// the proposal id.
        proposal_id: u64,
        /// description of proposal , ipfs://
        description: vector<u8>,
        /// proposer is the user who create the proposal.
        proposer: address,
    }

    /// emitted when user vote/revoke_vote.
    struct VotedEvent has drop, store {
        /// dao id
        dao_id: u64,
        /// the proposal id.
        proposal_id: u64,
        /// the voter.
        voter: address,
        /// 1:yes, 2:no, 3:no_with_veto, 4:abstain
        choice: u8,
        /// latest vote count of the voter.
        //        vote_amount: u128,
        vote_weight: u128,
    }

    /// emitted when proposal executed.
    struct ProposalActionEvent has drop, store {
        /// dao id
        dao_id: u64,
        /// the proposal id.
        proposal_id: u64,
        /// the sender.
        sender: address,
    }

    /// propose a proposal.
    /// `action`: the actual action to execute.
    /// `action_delay`: the delay to execute after the proposal is agreed
    public fun create_proposal<DAOT: store, PluginT, ActionT: store>(
        _cap: &DAOProposalCap<DAOT, PluginT>,
        sender: &signer,
        action: ActionT,
        description: vector<u8>,
        action_delay: u64,
    ): u64 acquires DAO, GlobalProposals, DAOAccountCapHolder, ProposalActions, ProposalEvent, GlobalProposalActions {
        // check DAO member
        let sender_addr = Signer::address_of(sender);
        ensure_member<DAOT>(sender_addr);
        
        if (action_delay == 0) {
            action_delay = min_action_delay<DAOT>();
        } else {
            assert!(action_delay >= min_action_delay<DAOT>(), Errors::invalid_argument(ERR_ACTION_DELAY_TOO_SMALL));
        };

        let min_proposal_deposit = min_proposal_deposit<DAOT>();
        let deposit = Account::withdraw<STC>(sender, min_proposal_deposit);

        let proposal_id = next_proposal_id<DAOT>();
        let proposer = Signer::address_of(sender);
        let start_time = Timestamp::now_milliseconds() + voting_delay<DAOT>();
        let quorum_votes = quorum_votes<DAOT>();
        let voting_period = voting_period<DAOT>();

        let (block_number,state_root) = block_number_and_state_root();

        let proposal = Proposal {
            id: proposal_id,
            proposer,
            description: copy description,
            start_time,
            end_time: start_time + voting_period,
            yes_votes: 0,
            no_votes: 0,
            abstain_votes: 0,
            veto_votes: 0,
            eta: 0,
            action_delay,
            quorum_votes,
            block_number,
            state_root,
        };
        let proposal_action = ProposalAction{
            proposal_id,
            deposit,
            action,
        };
        let proposal_action_index = ProposalActionIndex{
            proposal_id,
        };

        let dao_signer = dao_signer<DAOT>();
        let dao_address = dao_address<DAOT>();

        let actions = Vector::singleton(proposal_action);
        // check ProposalActions is exists
        if(exists<ProposalActions<ActionT>>(dao_address)){
            //TODO add limit to max action before support Table.
            let current_actions = borrow_global_mut<ProposalActions<ActionT>>(dao_address);
            Vector::append(&mut current_actions.actions, actions);
        }else{
            move_to(&dao_signer, ProposalActions<ActionT>{
                actions,
            });
        };

        let proposal_action_indexs = Vector::singleton(proposal_action_index);
        // check GlobalProposalActions is exists
        if(exists<GlobalProposalActions>(dao_address)){
            //TODO add limit to max global proposal action indexs before support Table
            let current_global_proposal_actions = borrow_global_mut<GlobalProposalActions>(dao_address);
            Vector::append(&mut current_global_proposal_actions.proposal_action_indexs, proposal_action_indexs);
        }else{
            move_to(&dao_signer, GlobalProposalActions{
                proposal_action_indexs,
            });
        };

        let proposals = Vector::singleton(proposal);
        // check GlobalProposals is exists
        if(exists<GlobalProposals>(dao_address)){
            //TODO add limit to max global proposal before support Table
            let current_global_proposals = borrow_global_mut<GlobalProposals>(dao_address);
            Vector::append(&mut current_global_proposals.proposals, proposals);
        }else{
            move_to(&dao_signer, GlobalProposals{
                proposals,
            });
        };

        // emit event
        let dao_id = dao_id(dao_address);
        let proposal_event = borrow_global_mut<ProposalEvent<DAOT>>(dao_address);
        Event::emit_event(&mut proposal_event.proposal_create_event,
            ProposalCreatedEvent { dao_id, proposal_id, description: copy description, proposer },
        );

        proposal_id
    }

    /// get lastest block number and state root
    fun block_number_and_state_root(): (u64, vector<u8>) {
        //        (101, x"5981f1a692a6d9f4772e69a46d1380158a0e1b2c31654aa9df4b0e591e8faab0")
        Block::latest_state_root()

    }


    /// votes for a proposal.
    /// User can only vote once, then the stake is locked,
    /// The voting power depends on the strategy of the proposal configuration and the user's token amount at the time of the snapshot
    public fun cast_vote<DAOT: store>(
        sender: &signer,
        proposal_id: u64,
        snpashot_raw_proofs: vector<u8>,
        choice: VotingChoice,
    )  acquires GlobalProposals, MyVotes, ProposalEvent, GlobalProposalActions, DAO {
        let sender_addr = Signer::address_of(sender);
        ensure_member<DAOT>(sender_addr);

        let dao_address = dao_address<DAOT>();
        let proposals = borrow_global_mut<GlobalProposals>(dao_address);
        let proposal = borrow_proposal_mut(proposals, proposal_id);

        {
            let state = proposal_state_with_proposal<DAOT>(proposal);
            // only when proposal is active, use can cast vote.
            assert!(state == ACTIVE, Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID));
        };
     
        // verify snapshot state proof
        let snapshot_proof = deserialize_snapshot_proofs(&snpashot_raw_proofs);
        let state_proof = new_state_proof_from_proofs(&snapshot_proof);
        let resource_struct_tag = SnapshotUtil::get_sturct_tag<DAOT>();
        // verify state_proof according to proposal snapshot proofs, and state root
        let verify = StarcoinVerifier::verify_state_proof(&state_proof, &proposal.state_root, sender_addr, &resource_struct_tag, &snapshot_proof.state);
        assert!(verify, Errors::invalid_state(ERR_STATE_PROOF_VERIFY_INVALID));

        // TODO is allowed just use part of weight?
        // decode sbt value from snapshot state
        let vote_weight = SBTVoteStrategy::get_voting_power(&snapshot_proof.state);

        assert!(!has_voted<DAOT>(sender_addr, proposal_id), Errors::invalid_state(ERR_VOTED_ALREADY));

        let vote = Vote{
            proposal_id,
            vote_weight,
            choice: choice.choice,
        };

        do_cast_vote(proposal, &mut vote);

        if (exists<MyVotes<DAOT>>(sender_addr)) {
            assert!(vote.proposal_id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
            let my_votes = borrow_global_mut<MyVotes<DAOT>>(sender_addr);
            Vector::push_back(&mut my_votes.votes, vote);
        } else {
            move_to(sender, MyVotes<DAOT>{
                votes: Vector::singleton(vote),
            });
        };

        // emit event
        let dao_id = dao_id(dao_address);
        let proposal_event = borrow_global_mut<ProposalEvent<DAOT> >(DAORegistry::dao_address<DAOT>());
        Event::emit_event(&mut proposal_event.vote_event,
            VotedEvent {
                dao_id,
                proposal_id,
                voter: sender_addr,
                choice: choice.choice,
                vote_weight,
            },
        );
    }

//    pub struct StateWithProofView {
//        pub state: Option<StrView<Vec<u8>>>,
//        pub account_state: Option<StrView<Vec<u8>>>,
//        pub account_proof: SparseMerkleProofView,
//        pub account_state_proof: SparseMerkleProofView,
//    }

//    pub struct SparseMerkleProofView {
//        /// This proof can be used to authenticate whether a given leaf exists in the tree or not.
//        ///     - If this is `Some(HashValue, HashValue)`
//        ///         - If the first `HashValue` equals requested key, this is an inclusion proof and the
//        ///           second `HashValue` equals the hash of the corresponding account blob.
//        ///         - Otherwise this is a non-inclusion proof. The first `HashValue` is the only key
//        ///           that exists in the subtree and the second `HashValue` equals the hash of the
//        ///           corresponding account blob.
//        ///     - If this is `None`, this is also a non-inclusion proof which indicates the subtree is
//        ///       empty.
//        pub leaf: Option<(HashValue, HashValue)>,
//
//        /// All siblings in this proof, including the default ones. Siblings are ordered from the bottom
//        /// level to the root level.
//        pub siblings: Vec<HashValue>,
//    }
    fun deserialize_snapshot_proofs(snpashot_raw_proofs: &vector<u8>): SnapshotProof{
        assert!(Vector::length(snpashot_raw_proofs) > 0, Errors::invalid_argument(ERR_SNAPSHOT_PROOF_PARAM_INVALID));
        let offset= 0;
        let (state_option, offset) = BCS::deserialize_option_bytes(snpashot_raw_proofs, offset);
        let (account_state_option, offset) = BCS::deserialize_option_bytes(snpashot_raw_proofs, offset);

        let (account_proof_leaf1_option, account_proof_leaf2_option, offset) = BCS::deserialize_option_tuple(snpashot_raw_proofs, offset);
        let account_proof_leaf1 = Option::get_with_default(&mut account_proof_leaf1_option, Vector::empty());
        let account_proof_leaf2 = Option::get_with_default(&mut account_proof_leaf2_option, Vector::empty());
        let (account_proof_siblings, offset) = BCS::deserialize_bytes_vector(snpashot_raw_proofs, offset);

        let (account_state_proof_leaf1_option, account_state_proof_leaf2_option, offset) = BCS::deserialize_option_tuple(snpashot_raw_proofs, offset);
        let account_state_proof_leaf1 = Option::get_with_default(&mut account_state_proof_leaf1_option, Vector::empty());
        let account_state_proof_leaf2 = Option::get_with_default(&mut account_state_proof_leaf2_option, Vector::empty());
        let (account_state_proof_siblings, _offset) = BCS::deserialize_bytes_vector(snpashot_raw_proofs, offset);

        SnapshotProof {
            state: Option::get_with_default(&mut state_option, Vector::empty()),
            account_state: Option::get_with_default(&mut account_state_option, Vector::empty()),
            account_proof_leaf: HashNode {
                hash1: account_proof_leaf1,
                hash2: account_proof_leaf2,
            },
            account_proof_siblings,
            account_state_proof_leaf: HashNode {
                hash1: account_state_proof_leaf1,
                hash2: account_state_proof_leaf2,
            },
            account_state_proof_siblings,
        }
    }

    fun new_state_proof_from_proofs(snpashot_proofs: &SnapshotProof): StateProof{
        let state_proof = StarcoinVerifier::new_state_proof(
            StarcoinVerifier::new_sparse_merkle_proof(
                *&snpashot_proofs.account_proof_siblings,
                StarcoinVerifier::new_smt_node(
                    *&snpashot_proofs.account_proof_leaf.hash1,
                    *&snpashot_proofs.account_proof_leaf.hash2,
                ),
            ),
            *&snpashot_proofs.account_state,
            StarcoinVerifier::new_sparse_merkle_proof(
                *&snpashot_proofs.account_state_proof_siblings,
                StarcoinVerifier::new_smt_node(
                    *&snpashot_proofs.account_state_proof_leaf.hash1,
                    *&snpashot_proofs.account_state_proof_leaf.hash2,
                ),
            ),
        );
        state_proof
    }

    #[test]
    fun test_snapshot_proof() {
        // barnard, block number 6201718
        let snpashot_raw_proofs = x"0145016bfb460477adf9dd0455d3de2fc7f21101000000000000000664616f313031000a69616d67655f64617461005704000000000000640000000000000000000000000000000145020120cc969848619e507450ebf01437155ab5f2dbb554fe611cb71958855a1b2ec664012035f2374c333a51e46b62b693ebef25b9be2cefde8d156db08bff28f9a0b87742012073837fcf4e69ae60e18ea291b9f25c86ce8053c6ee647a2b287083327c67dd7e20dac300fb581a6df034a44a99e8eb1cd55c7dd8f0a9e78f1114a6b4eda01d834e0e2078179a07914562223d40068488a0d65673b3b2681642633dc33904575f8f070b20b7c2a21de200ca82241e5e480e922258591b219dd56c24c4d94299020ee8299a204f541db82477510f699c9d75dd6d8280639a1ec9d0b90962cbc0c2b06514a78b20cacfce99bb564cfb70eec6a61bb76b9d56eb1b626d7fa231338792e1f572a8df20da6c1337ca5d8f0fa18b2db35844c610858a710edac35206ef0bf52fd32a4ac920ef6fb8f82d32ca2b7c482b7942505e6492bffa3ed14dd635bae16a14b4ac32e6202ad7b36e08e7b5d208de8eec1ef1964dc8433ccca8ac4632f36054926e858ac32027d5ccc8aa57b964ad50334f62821188b89945ae999ad0bb31cdc16df1763f8120afa983813953d6aa9563db12d5e443c9e8114c3482867c95a661a240d6f0e0ec206466ac318f5d9deb7b64b12622a0f4bed2f19379667d18b6ccfeaa84171d812f20eb45021b7b39887925a5b49018cdc8ad44c14835a42e5775666315f4a3e0ba42204c2b365a78e4615873772a0f039a7326150472b4923d40640863dbe42a2351eb20825d0c21dd1105faf528934842419f8661d695fc72ec6ef8036f5d03359126d3205d806c027eecdfbc3960e68c5997718a0709a6079f96e1af3ffe21878ada2b830120fa60f8311936961f5e9dee5ccafaea83ed91c6eaa04a7dea0b85a38cf84d8564207ef6a85019523861474cdf47f4db8087e5368171d95cc2c1e57055a72ca39cb704208db1e4e4c864882bd611b1cda02ca30c43b3c7bc56ee7cb174598188da8b49ef2063b3f1e4f05973830ba40e0c50c4e59f31d3baa5643d19676ddbacbf797bf6b720b39d31107837c1751d439706c8ddac96f8c148b8430ac4f40546f33fb9871e4320fb0ad035780bb8f1c6481bd674ccad0948cd2e8e6b97c08e582f67cc26918fb3";
        let state_root = x"d5cd5dc44799c989a84b7d4a810259f373b13a9bf8ee21ecbed0fab264e2090d";
        let account_address = @0x6bfb460477adf9dd0455d3de2fc7f211;
        // 0x00000000000000000000000000000001::Account::Balance<0x8c109349c6bd91411d6bc962e080c4a3::STAR::STAR>
        let resource_struct_tag = x"000000000000000000000000000000010d4964656e7469666965724e46540d4964656e7469666965724e465402076bfb460477adf9dd0455d3de2fc7f211095342544d6f64756c650944616f4d656d62657201076bfb460477adf9dd0455d3de2fc7f211095342544d6f64756c650a5362745465737444414f00076bfb460477adf9dd0455d3de2fc7f211095342544d6f64756c650d44616f4d656d626572426f647901076bfb460477adf9dd0455d3de2fc7f211095342544d6f64756c650a5362745465737444414f00";

        let snapshot_proof = deserialize_snapshot_proofs(&snpashot_raw_proofs);
        let state_proof = new_state_proof_from_proofs(&snapshot_proof);

        let b = StarcoinVerifier::verify_state_proof(
            &state_proof,
            &state_root,
            account_address,
            &resource_struct_tag,
            &snapshot_proof.state,
        );
        assert!(b, 8006);
    }


    // Execute the proposal and return the action.
    public fun execute_proposal<DAOT: store, PluginT, ActionT: store>(
        _cap: &DAOProposalCap<DAOT, PluginT>,
        sender: &signer,
        proposal_id: u64,
    ): ActionT acquires ProposalActions, GlobalProposals, GlobalProposalActions, ProposalEvent, DAO {
        // Only executable proposal's action can be extracted.
         assert!(proposal_state<DAOT>(proposal_id) == EXECUTABLE, Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID));
        let dao_address = dao_address<DAOT>();
        let sender_addr = Signer::address_of(sender);
        assert!(exists<ProposalActions<ActionT>>(dao_address), Errors::invalid_state(ERR_PROPOSAL_ACTIONS_NOT_EXIST));

        let actionT = take_proposal_action(dao_address, proposal_id);

        // emit event
        let dao_id = dao_id(dao_address);
        let proposal_event = borrow_global_mut<ProposalEvent<DAOT>>(dao_address);
        Event::emit_event(&mut proposal_event.proposal_action_event,
            ProposalActionEvent { dao_id, proposal_id, sender: sender_addr }
        );

        actionT
    }

    fun take_proposal_action<ActionT: store>(dao_address: address, proposal_id: u64): ActionT acquires ProposalActions, GlobalProposals, GlobalProposalActions {
        let actions = borrow_global_mut<ProposalActions<ActionT>>(dao_address);
        let index_opt = find_action(&actions.actions, proposal_id);
        assert!(Option::is_some(&index_opt), Errors::invalid_argument(ERR_ACTION_INDEX_INVALID));

        let global_proposals = borrow_global<GlobalProposals>(dao_address);
        let proposal = borrow_proposal(global_proposals, proposal_id);

        let index = Option::extract(&mut index_opt);
        let ProposalAction{ proposal_id:_, deposit, action} = Vector::remove(&mut actions.actions, index);

        // remove proposal action index
        let global_proposal_actions = borrow_global_mut<GlobalProposalActions>(dao_address);
        let proposal_action_index_opt = find_proposal_action_index(global_proposal_actions, proposal_id);
        assert!(Option::is_some(&proposal_action_index_opt), Errors::invalid_argument(ERR_PROPOSAL_ACTION_INDEX_NOT_EXIST));
        let propopsal_action_index = Option::extract(&mut proposal_action_index_opt);
        let ProposalActionIndex{ proposal_id:_,} = Vector::remove(&mut global_proposal_actions.proposal_action_indexs, propopsal_action_index);

        //TODO check the proposal state and do deposit or burn.
        Account::deposit(proposal.proposer, deposit);
        action
    }

    fun find_action<ActionT: store>(actions: &vector<ProposalAction<ActionT>>, proposal_id: u64): Option<u64>{
        let i = 0;
        let len = Vector::length(actions);
        while(i < len){
            let action = Vector::borrow(actions, i);
            if(action.proposal_id == proposal_id){
                return Option::some(i)
            };
            i = i + 1;
        };
        Option::none<u64>()
    }

    fun do_cast_vote(proposal: &mut Proposal, vote: &mut Vote){
        if (choice_yes().choice == vote.choice) {
            proposal.yes_votes = proposal.yes_votes + vote.vote_weight;
        } else if (choice_no().choice == vote.choice) {
            proposal.no_votes = proposal.no_votes + vote.vote_weight;
        } else if ( choice_no_with_veto().choice == vote.choice) {
            proposal.no_votes = proposal.no_votes + vote.vote_weight;
            proposal.veto_votes = proposal.veto_votes + vote.vote_weight;
        } else if (choice_abstain().choice == vote.choice) {
            proposal.abstain_votes = proposal.abstain_votes + vote.vote_weight;
        } else {
            abort Errors::invalid_argument(ERR_VOTE_PARAM_INVALID)
        };
    }

    fun has_voted<DAOT>(sender: address, proposal_id: u64): bool acquires MyVotes{
        if(exists<MyVotes<DAOT>>(sender)){
            let my_votes = borrow_global<MyVotes<DAOT>>(sender);
            let vote = vote_info<DAOT>(my_votes, proposal_id);
            Option::is_some(&vote)
        }else{
            false
        }
    }

    /// vote info by proposal_id
    fun vote_info<DAOT>(my_votes: &MyVotes<DAOT>, proposal_id: u64): Option<VoteInfo>{
        let len = Vector::length(&my_votes.votes);
        let idx = 0;
        loop {
            if (idx >= len) {
                break
            };
            let vote = Vector::borrow(&my_votes.votes, idx);
            if (proposal_id == vote.proposal_id) {
                let vote_info = VoteInfo {
                    proposal_id: vote.proposal_id,
                    vote_weight: vote.vote_weight,
                    choice: vote.choice,
                };
                return Option::some(vote_info)
            };
            idx = idx + 1;
        };
        Option::none<VoteInfo>()
    }

    /// get vote info by proposal_id
    public fun get_vote_info<DAOT>(voter: address, proposal_id: u64): (u64, u8, u128)acquires MyVotes {
        if(exists<MyVotes<DAOT>>(voter)){
            let my_votes = borrow_global<MyVotes<DAOT>>(voter);
            let vote_option = vote_info<DAOT>(my_votes, proposal_id);
            if(!Option::is_some(&vote_option)){
                return (0, 0, 0)
            };
            let vote = Option::extract(&mut vote_option);
            (vote.proposal_id, vote.choice, vote.vote_weight)
        }else{
            (0, 0, 0)
        }
    }

    public fun proposal_state<DAOT: store>(proposal_id: u64) : u8 acquires GlobalProposalActions, GlobalProposals {
        let dao_address = dao_address<DAOT>();
        let proposals = borrow_global<GlobalProposals>(dao_address);
        let proposal = borrow_proposal(proposals, proposal_id);

        proposal_state_with_proposal<DAOT>(proposal)
    }

    fun proposal_state_with_proposal<DAOT: store>(proposal: &Proposal) : u8 acquires GlobalProposalActions {
        let dao_address = dao_address<DAOT>();
        let current_time = Timestamp::now_milliseconds();

        let global_proposal_actions = borrow_global<GlobalProposalActions>(dao_address);
        let action_index_opt = find_proposal_action_index(global_proposal_actions, proposal.id);

        do_proposal_state(proposal, current_time, action_index_opt)
    }

    fun do_proposal_state(proposal: &Proposal, current_time: u64, action_index_opt: Option<u64> ): u8 {
        if (current_time < proposal.start_time) {
            // Pending
            PENDING
        } else if (current_time <= proposal.end_time) {
            // Active
            ACTIVE
            //TODO need restrict yes votes ratio with (no/no_with_veto/abstain) ?
        } else if (proposal.yes_votes <= (proposal.no_votes  + proposal.abstain_votes) ||
                   proposal.yes_votes < proposal.quorum_votes) {
            // Defeated
            DEFEATED
        } else if (proposal.eta == 0) {
            // Agreed.
            AGREED
        } else if (current_time < proposal.eta) {
            // Queued, waiting to execute
            QUEUED
        } else if (Option::is_some(&action_index_opt)) {
            EXECUTABLE
        } else {
            EXTRACTED
        }
    }

    /// get proposal's information.
    /// return: (id, proposer, start_time, end_time, yes_votes, no_votes, abstain_votes, veto_votes, block_number, state_root).
    public fun proposal_info<DAOT: store>(
        proposal_id: u64,
    ): (u64, address, u64, u64, u128, u128, u128, u128, u64, vector<u8>) acquires GlobalProposals {
        let dao_address = DAORegistry::dao_address<DAOT>();
        let proposals = borrow_global_mut<GlobalProposals>(dao_address);
        let proposal = borrow_proposal(proposals, proposal_id);
        (proposal.id, proposal.proposer, proposal.start_time, proposal.end_time, proposal.yes_votes, proposal.no_votes, proposal.abstain_votes, proposal.veto_votes, proposal.block_number, *&proposal.state_root)
    }

    fun borrow_proposal_mut(proposals: &mut GlobalProposals, proposal_id: u64): &mut Proposal{
        let i = 0;
        let len = Vector::length(&proposals.proposals);
        while(i < len){
            let proposal = Vector::borrow(&proposals.proposals, i);
            if(proposal.id == proposal_id){
                return Vector::borrow_mut(&mut proposals.proposals, i)
            };
            i = i + 1;
        };
        abort Errors::invalid_argument(ERR_PROPOSAL_NOT_EXIST)
    }

    fun borrow_proposal(proposals: &GlobalProposals, proposal_id: u64): &Proposal {
        let i = 0;
        let len = Vector::length(&proposals.proposals);
        while(i < len){
            let proposal = Vector::borrow(&proposals.proposals, i);
            if(proposal.id == proposal_id){
                return proposal
            };
            i = i + 1;
        };
        abort Errors::invalid_argument(ERR_PROPOSAL_NOT_EXIST)
    }

    fun find_proposal_action_index(global_proposal_action: &GlobalProposalActions, proposal_id: u64): Option<u64> {
        let i = 0;
        let len = Vector::length(&global_proposal_action.proposal_action_indexs);
        while(i < len){
            let proposal_action_index = Vector::borrow(&global_proposal_action.proposal_action_indexs, i);
            if(proposal_action_index.proposal_id == proposal_id){
                return Option::some(i)
            };
            i = i + 1;
        };
        Option::none<u64>()
    }

    ///Return a copy of Proposal
    public fun proposal<DAOT>(proposal_id: u64): Proposal acquires GlobalProposals{
        let dao_address = dao_address<DAOT>();
        let global_proposals = borrow_global<GlobalProposals>(dao_address);
        *borrow_proposal(global_proposals, proposal_id)
    }

    /// queue agreed proposal to execute.
    public(script) fun queue_proposal_action<DAOT:store>(
        _signer: signer,
        proposal_id: u64,
    ) acquires GlobalProposalActions, GlobalProposals {
        // Only agreed proposal can be submitted.
        assert!(proposal_state<DAOT>(proposal_id) == AGREED, Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID));
        let dao_address = dao_address<DAOT>();
        let proposals = borrow_global_mut<GlobalProposals>(dao_address);
        let proposal = borrow_proposal_mut(proposals, proposal_id);
        proposal.eta = Timestamp::now_milliseconds() + proposal.action_delay;
    }

    public(script) fun cast_vote_entry<DAOT:store>(
        sender: signer,
        proposal_id: u64,
        snpashot_raw_proofs: vector<u8>,
        choice: u8,
    ) acquires MyVotes, GlobalProposals, ProposalEvent, GlobalProposalActions, DAO {
        let sender_addr = Signer::address_of(&sender);
        if (has_voted<DAOT>(sender_addr, proposal_id)) {
            abort Errors::invalid_state(ERR_VOTED_ALREADY)
        };

        let vote_choice = VotingChoice {
            choice,
        };
        cast_vote<DAOT>(&sender, proposal_id, snpashot_raw_proofs, vote_choice)
    }

    /// DAOConfig
    /// ---------------------------------------------------

    /// create a dao config
    public fun new_dao_config(
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        min_proposal_deposit: u128,
    ): DAOConfig{
        assert!(voting_delay > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        assert!(voting_period > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        assert!(
            voting_quorum_rate > 0 && voting_quorum_rate <= 100,
            Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID),
        );
        assert!(min_action_delay > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        DAOConfig { voting_delay, voting_period, voting_quorum_rate, min_action_delay, min_proposal_deposit }
    }

    // Get config
    public fun get_custom_config<DAOT: store,
                                 ConfigT: copy + store + drop>(): ConfigT {
        let dao_address = dao_address<DAOT>();
        Config::get_by_address<ConfigT>(dao_address)
    }

    // Get config
    public fun exists_custom_config<DAOT: store,
                                    ConfigT: copy + store + drop>(): bool {
        let dao_address = dao_address<DAOT>();
        Config::config_exist_by_address<ConfigT>(dao_address)
    }

    /// Update, save function of custom plugin configuration
    public fun set_custom_config<DAOT: store,
                                 PluginT: drop,
                                 ConfigT: copy + store + drop>(
        _cap: &mut DAOModifyConfigCap<DAOT, PluginT>,
        config: ConfigT)
    acquires DAOCustomConfigModifyCapHolder, DAOAccountCapHolder {
        let dao_address = dao_address<DAOT>();
        if (Config::config_exist_by_address<ConfigT>(dao_address)) {
            let cap_holder =
                borrow_global_mut<DAOCustomConfigModifyCapHolder<DAOT, ConfigT>>(dao_address);
            let modify_config_cap = &mut cap_holder.cap;
            Config::set_with_capability(modify_config_cap, config);
        } else {
            let signer = dao_signer<DAOT>();
            move_to(&signer, DAOCustomConfigModifyCapHolder<DAOT, ConfigT> {
                cap: Config::publish_new_config_with_capability<ConfigT>(&signer, config)
            });
        }
    }

    /// Update DAO description
    public fun set_dao_description<DAOT: store,
                                 PluginT: drop,
                                 ConfigT: copy + store + drop>(
        _cap: &mut DAOModifyConfigCap<DAOT, PluginT>,
        description: vector<u8>) 
    acquires DAO{
        let dao_address = dao_address<DAOT>();
        let dao = borrow_global_mut<DAO>(dao_address);
        dao.description = description;
    }


    /// get default voting delay of the DAO.
    public fun voting_delay<DAOT: store>(): u64 {
        get_config<DAOT>().voting_delay
    }

    /// get the default voting period of the DAO.
    public fun voting_period<DAOT: store>(): u64 {
        get_config<DAOT>().voting_period
    }

    /// Quorum votes to make proposal pass.
    public fun quorum_votes<DAOT: store>(): u128 {
        let market_cap = Token::market_cap<DAOT>();
        let rate = voting_quorum_rate<DAOT>();
        let rate = (rate as u128);
        market_cap * rate / 100
    }

    /// Get the quorum rate in percent.
    public fun voting_quorum_rate<DAOT: store>(): u8 {
        get_config<DAOT>().voting_quorum_rate
    }

    /// Get the min action delay of the DAO.
    public fun min_action_delay<DAOT: store>(): u64 {
        get_config<DAOT>().min_action_delay
    }

    /// Get the min proposal deposit of the DAO.
    public fun min_proposal_deposit<DAOT: store>(): u128{
        get_config<DAOT>().min_proposal_deposit
    }

    fun get_config<DAOT: store>(): DAOConfig {
        let dao_address= dao_address<DAOT>();
        Config::get_by_address<DAOConfig>(dao_address)
    }

    /// Update function, modify dao config.
    public fun modify_dao_config<DAOT: store, PluginT>(
        _cap: &mut DAOModifyConfigCap<DAOT, PluginT>,
        new_config: DAOConfig,
    ) acquires DAOConfigModifyCapHolder {
        let modify_config_cap = &mut borrow_global_mut<DAOConfigModifyCapHolder>(
            dao_address<DAOT>(),
        ).cap;
        Config::set_with_capability<DAOConfig>(modify_config_cap, new_config);
    }

    /// set voting delay
    public fun set_voting_delay(
        config: &mut DAOConfig,
        value: u64,
    ) {
        assert!(value > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        config.voting_delay = value;
    }

    /// set voting period
    public fun set_voting_period<DAOT: store>(
        config: &mut DAOConfig,
        value: u64,
    ) {
        assert!(value > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        config.voting_period = value;
    }

    /// set voting quorum rate
    public fun set_voting_quorum_rate<DAOT: store>(
        config: &mut DAOConfig,
        value: u8,
    ) {
        assert!(value <= 100 && value > 0, Errors::invalid_argument(ERR_QUORUM_RATE_INVALID));
        config.voting_quorum_rate = value;
    }

    /// set min action delay
    public fun set_min_action_delay<DAOT: store>(
        config: &mut DAOConfig,
        value: u64,
    ) {
        assert!(value > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        config.min_action_delay = value;
    }

    /// set min action delay
    public fun set_min_proposal_deposit<DAOT: store>(
        config: &mut DAOConfig,
        value: u128,
    ) {
        config.min_proposal_deposit = value;
    }


    /// Helpers
    /// ---------------------------------------------------


    fun next_member_id<DAOT>(): u64 acquires DAO {
        let dao_address = dao_address<DAOT>();
        let dao = borrow_global_mut<DAO>(dao_address);
        let member_id = dao.next_member_id;
        dao.next_member_id = member_id + 1;
        member_id
    }

    fun next_proposal_id<DAOT>(): u64 acquires DAO {
        let dao_address = dao_address<DAOT>();
        let dao = borrow_global_mut<DAO>(dao_address);
        let proposal_id = dao.next_proposal_id;
        dao.next_proposal_id = proposal_id + 1;
        proposal_id
    }

    fun assert_no_repeat<E>(v: &vector<E>) {
        let i = 1;
        let len = Vector::length(v);
        while (i < len) {
            let e = Vector::borrow(v, i);
            let j = 0;
            while (j < i) {
                let f = Vector::borrow(v, j);
                assert!(e != f, Errors::invalid_argument(ERR_REPEAT_ELEMENT));
                j = j + 1;
            };
            i = i + 1;
        };
    }

    #[test]
    fun test_assert_no_repeat() {
        let v = Vector::singleton(1);
        Vector::push_back(&mut v, 2);
        Vector::push_back(&mut v, 3);
        assert_no_repeat(&v);
    }

    #[test]
    #[expected_failure]
    fun test_assert_no_repeat_fail() {
        let v = Vector::singleton(1);
        Vector::push_back(&mut v, 2);
        Vector::push_back(&mut v, 3);
        Vector::push_back(&mut v, 1);
        assert_no_repeat(&v);
    }

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

    fun convert_option_bytes_vector(input: &vector<Option::Option<vector<u8>>>): vector<vector<u8>> {
        let len = Vector::length(input);
        let i = 0;
        let output = Vector::empty<vector<u8>>();
        while (i < len) {
            let option = Vector::borrow(input, i);
            if (Option::is_some(option)){
                Vector::push_back(&mut output, Option::extract(&mut *option));
            };
            i = i + 1;
        };
        output
    }

    fun dao_signer<DAOT>(): signer acquires DAOAccountCapHolder {
        let cap = &borrow_global<DAOAccountCapHolder>(dao_address<DAOT>()).cap;
        DAOAccount::dao_signer(cap)
    }

    fun dao_address<DAOT>(): address {
        DAORegistry::dao_address<DAOT>()
    }

    fun dao_id(dao_address: address): u64 acquires DAO {
        if (exists<DAO>(dao_address)){
            let dao = borrow_global<DAO>(dao_address);
            dao.id
        }else{
            0
        }
    }
}