module StarcoinFramework::GenesisDao{
    use StarcoinFramework::DaoAccount::{Self, DaoAccountCap};
    use StarcoinFramework::Account;
    use StarcoinFramework::Vector;
    use StarcoinFramework::NFT::{Self, NFT};
    use StarcoinFramework::NFTGallery;
    use StarcoinFramework::IdentifierNFT;
    use StarcoinFramework::Signer;
    use StarcoinFramework::DaoRegistry;
    use StarcoinFramework::Token::{Self, Token};
    use StarcoinFramework::Errors;
    use StarcoinFramework::Option::{Self, Option};
    use StarcoinFramework::STC::{STC};
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Config;
    use StarcoinFramework::Event;
    use StarcoinFramework::StarcoinVerifier::{Self, StateProof};
    use StarcoinFramework::SBTVoteStrategy;
    use StarcoinFramework::BCS;

    const E_NO_GRANTED: u64 = 1;
    const ERR_REPEAT_ELEMENT: u64 = 100;
    const ERR_PLUGIN_HAS_INSTALLED: u64 = 101;
    const ERR_STORAGE_ERROR: u64 = 102;
    const ERR_NFT_ERROR: u64 = 103;

    const ERR_NOT_ALREADY_MEMBER: u64 = 104;
    const ERR_NOT_MEMBER: u64 = 105;


    const ERR_NOT_AUTHORIZED: u64 = 1401;
    const ERR_ACTION_DELAY_TOO_SMALL: u64 = 1402;
    const ERR_CONFIG_PARAM_INVALID: u64 = 1413;

    /// proposal
    const ERR_PROPOSAL_STATE_INVALID: u64 = 1413;
    const ERR_PROPOSAL_ID_MISMATCH: u64 = 1414;
    const ERR_PROPOSER_MISMATCH: u64 = 1415;
    const ERR_PROPOSAL_NOT_EXIST: u64 = 1416;
    const ERR_QUORUM_RATE_INVALID: u64 = 1417;

    /// action
    const ERR_ACTION_MUST_EXIST: u64 = 1430;
    const ERR_ACTION_INDEX_INVALID: u64 = 1431;


    /// vote
    const ERR_VOTE_STATE_MISMATCH: u64 = 1441;
    const ERR_VOTED_OTHERS_ALREADY: u64 = 1442;
    const ERR_VOTED_ALREADY: u64 = 1443;
    const ERR_VOTE_PARAM_INVALID: u64 = 1444;
    const ERR_SNAPSHOT_PROOF_PARAM_INVALID: u64 = 1450;
    const ERR_STATE_PROOF_VERIFY_INVALID: u64 = 1451;


    
    struct Dao has key{
        id: u64,
        // maybe should use ASIIC String
        name: vector<u8>,
        dao_address: address, 
        next_member_id: u64,
        next_proposal_id: u64,
    }

    struct DaoExt<DaoT: store> has key{
        ext: DaoT,
    }

     /// Configuration of the DAO.
    struct DaoConfig has copy, drop, store {
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
         /// the actual voting system, default single choice voting system
         voting_system: u8,
    }

    struct DaoAccountCapHolder has key{
        cap: DaoAccountCap,
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

    struct DaoConfigModifyCapHolder has key{
        cap: Config::ModifyConfigCapability<DaoConfig>
    }

    /// A type describing a capability. 
    struct CapType has copy, drop, store { code: u8 }

    /// Creates a install plugin capability type.
    public fun install_plugin_cap_type(): CapType { CapType{ code : 0 } }

    /// Creates a upgrade module capability type.
    public fun upgrade_module_cap_type(): CapType { CapType{ code : 1 } }

    /// Creates a modify dao config capability type.
    public fun modify_config_cap_type(): CapType { CapType{ code : 2 } }

    /// Creates a withdraw Token capability type.
    public fun withdraw_token_cap_type(): CapType { CapType{ code : 3 } }

    /// Creates a withdraw NFT capability type.
    public fun withdraw_nft_cap_type(): CapType { CapType{ code : 4 } }

    /// Creates a write data to Dao account capability type.
    public fun storage_cap_type(): CapType { CapType{ code : 5 } }

    /// Creates a member capability type.
    /// This cap can issue Dao member NFT or update member's SBT
    public fun member_cap_type(): CapType { CapType{ code : 6 } }

    /// Creates a vote capability type.
    public fun proposal_cap_type(): CapType { CapType{ code : 7 } }

    /// Creates a vote strategy capability type.
    public fun vote_strategy_cap_type(): CapType { CapType{ code : 8 } }

    /// Creates all capability types.
    public fun all_caps(): vector<CapType>{
        let caps = Vector::singleton(install_plugin_cap_type());
        Vector::push_back(&mut caps, upgrade_module_cap_type());
        Vector::push_back(&mut caps, modify_config_cap_type());
        Vector::push_back(&mut caps, withdraw_token_cap_type());
        Vector::push_back(&mut caps, withdraw_nft_cap_type());
        Vector::push_back(&mut caps, storage_cap_type());
        Vector::push_back(&mut caps, member_cap_type());
        Vector::push_back(&mut caps, proposal_cap_type());
        Vector::push_back(&mut caps, vote_strategy_cap_type());
        caps
    }

    /// RootCap only have one instance, and can not been `drop` and `store`
    struct DaoRootCap<phantom DaoT> {}

    struct DaoInstallPluginCap<phantom DaoT, phantom PluginT> has drop{}

    struct DaoUpgradeModuleCap<phantom DaoT, phantom PluginT> has drop{}

    struct DaoModifyConfigCap<phantom DaoT, phantom PluginT> has drop{}
  
    struct DaoWithdrawTokenCap<phantom DaoT, phantom PluginT> has drop{}

    struct DaoWithdrawNFTCap<phantom DaoT, phantom PluginT> has drop{}

    struct DaoStorageCap<phantom DaoT, phantom PluginT> has drop{}

    struct DaoMemberCap<phantom DaoT, phantom PluginT> has drop{}

    struct DaoProposalCap<phantom DaoT, phantom PluginT> has drop{}

    struct DaoVoteStrategyCap<phantom DaoT, phantom PluginT> has drop{}

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
    public fun create_dao<DaoT: store>(cap: DaoAccountCap, name: vector<u8>, ext: DaoT, config: DaoConfig): DaoRootCap<DaoT> {
        let dao_signer = DaoAccount::dao_signer(&cap);

        let dao_address = Signer::address_of(&dao_signer);
        let id = DaoRegistry::register<DaoT>(dao_address);
        let dao = Dao{
            id,
            name: *&name,
            dao_address,
            next_member_id: 1,
            next_proposal_id: 1,
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

        initialize_proposal<DaoT>(&cap);

        let nft_name = name;
        //TODO generate a svg NFT image.
        let nft_image = Vector::empty<u8>();
        let nft_description = Vector::empty<u8>();
        let basemeta = NFT::new_meta_with_image_data(nft_name, nft_image, nft_description);

        NFT::register_v2<DaoMember<DaoT>>(&dao_signer, basemeta);
        let nft_mint_cap = NFT::remove_mint_capability<DaoMember<DaoT>>(&dao_signer);
        move_to(&dao_signer, DaoNFTMintCapHolder{
            cap: nft_mint_cap,
        });

        let nft_burn_cap = NFT::remove_burn_capability<DaoMember<DaoT>>(&dao_signer);
        move_to(&dao_signer, DaoNFTBurnCapHolder{
            cap: nft_burn_cap,
        });

        let nft_update_cap = NFT::remove_update_capability<DaoMember<DaoT>>(&dao_signer);
        move_to(&dao_signer, DaoNFTUpdateCapHolder{
            cap: nft_update_cap,
        });
        
        let config_modify_cap = Config::publish_new_config_with_capability(&dao_signer, config);
        move_to(&dao_signer, DaoConfigModifyCapHolder{
            cap: config_modify_cap,
        });
        DaoRootCap<DaoT>{}
    }
  
    // Upgrade account to Dao account and create Dao
    public fun upgrade_to_dao<DaoT: store>(sender:signer, name: vector<u8>, ext: DaoT, config: DaoConfig): DaoRootCap<DaoT> acquires DaoAccountCapHolder {
        let cap = DaoAccount::upgrade_to_dao(sender);
        create_dao<DaoT>(cap, name, ext, config)
    }

    /// Burn the root cap after init the Dao
    public fun burn_root_cap<DaoT>(cap: DaoRootCap<DaoT>){
        let DaoRootCap{} = cap;
    }
  
    // Capability support function


    /// Install ToInstallPluginT to Dao and grant the capabilites
    public fun install_plugin_with_root_cap<DaoT:store, ToInstallPluginT>(_cap: &DaoRootCap<DaoT>, granted_caps: vector<CapType>) acquires DaoAccountCapHolder{
        do_install_plugin<DaoT, ToInstallPluginT>(granted_caps);
    }

    /// Install plugin with DaoInstallPluginCap
    public fun install_plugin<DaoT:store, PluginT, ToInstallPluginT>(_cap: &DaoInstallPluginCap<DaoT, PluginT>, granted_caps: vector<CapType>) acquires DaoAccountCapHolder{
        do_install_plugin<DaoT, ToInstallPluginT>(granted_caps);
    }

    fun do_install_plugin<DaoT:store, ToInstallPluginT>(granted_caps: vector<CapType>) acquires DaoAccountCapHolder{
        assert_no_repeat(&granted_caps);
        let dao_signer = dao_signer<DaoT>();
        assert!(!exists<InstalledPluginInfo<ToInstallPluginT>>(Signer::address_of(&dao_signer)), Errors::already_published(ERR_PLUGIN_HAS_INSTALLED));
        move_to(&dao_signer, InstalledPluginInfo<ToInstallPluginT>{
            granted_caps,
        });
    }

    // ModuleUpgrade functions

    /// Submit upgrade module plan
     public fun submit_upgrade_plan<DaoT: store, PluginT>(_cap: &DaoUpgradeModuleCap<DaoT, PluginT>, package_hash: vector<u8>, version:u64, enforced: bool) acquires DaoAccountCapHolder{
        let dao_account_cap = &mut borrow_global_mut<DaoAccountCapHolder>(dao_address<DaoT>()).cap;
        DaoAccount::submit_upgrade_plan(dao_account_cap, package_hash, version, enforced);
     }

    // Storage capability function

    struct StorageItem<phantom PluginT, V: store> has key{
        item: V,
    }
  
    /// Save the item to the storage
    public fun save<DaoT:store, PluginT, V: store>(_cap: &DaoStorageCap<DaoT, PluginT>, item: V) acquires DaoAccountCapHolder{
        let dao_signer = dao_signer<DaoT>();
        assert!(!exists<StorageItem<PluginT, V>>(Signer::address_of(&dao_signer)), Errors::already_published(ERR_STORAGE_ERROR));
        move_to(&dao_signer, StorageItem<PluginT,V>{
            item
        });
    }

    /// Get the item from the storage
    public fun take<DaoT:store, PluginT, V: store>(_cap: &DaoStorageCap<DaoT, PluginT>): V acquires StorageItem{
        let dao_address = dao_address<DaoT>();
        assert!(exists<StorageItem<PluginT, V>>(dao_address),  Errors::not_published(ERR_STORAGE_ERROR));
        let StorageItem{item} = move_from<StorageItem<PluginT, V>>(dao_address);
        item
    }

    // Withdraw Token capability function

    /// Withdraw the token from the Dao account
    public fun withdraw_token<DaoT:store, PluginT, TokenT:store>(_cap: &DaoWithdrawTokenCap<DaoT, PluginT>, amount: u128): Token<TokenT> acquires DaoAccountCapHolder{
        let dao_signer = dao_signer<DaoT>();
        //we should extract the WithdrawCapability from account, and invoke the withdraw_with_cap ?
        Account::withdraw<TokenT>(&dao_signer, amount)
    }

    // NFT capability function

    /// Withdraw the NFT from the Dao account
    public fun withdraw_nft<DaoT:store, PluginT, NFTMeta: store + copy + drop, NFTBody: store>(_cap: &DaoWithdrawNFTCap<DaoT, PluginT>, id: u64): NFT<NFTMeta, NFTBody> acquires DaoAccountCapHolder{
        let dao_signer = dao_signer<DaoT>();
        let nft = NFTGallery::withdraw<NFTMeta, NFTBody>(&dao_signer, id);
        assert!(Option::is_some(&nft), Errors::not_published(ERR_NFT_ERROR));
        Option::destroy_some(nft)
    }

    // Membership function

    /// Join Dao and get a membership
    public fun join_member<DaoT:store, PluginT>(_cap: &DaoMemberCap<DaoT, PluginT>, to_address: address, init_sbt: u128) acquires DaoNFTMintCapHolder, DaoTokenMintCapHolder, Dao{
        
        assert!(!is_member<DaoT>(to_address), Errors::already_published(ERR_NOT_ALREADY_MEMBER));
        
        let member_id = next_member_id<DaoT>();

        let meta = DaoMember<DaoT>{
            id: member_id,
        };

        let dao_address = dao_address<DaoT>();
 

        let token_mint_cap = &borrow_global_mut<DaoTokenMintCapHolder<DaoT>>(dao_address).cap;
        let sbt = Token::mint_with_capability<DaoT>(token_mint_cap, init_sbt);

        let body = DaoMemberBody<DaoT>{
            sbt,
        };

        //TODO init base metadata
        let basemeta = NFT::empty_meta();

        let nft_mint_cap = &mut borrow_global_mut<DaoNFTMintCapHolder<DaoT>>(dao_address).cap;

        let nft = NFT::mint_with_cap_v2(dao_address, nft_mint_cap, basemeta, meta, body);
        IdentifierNFT::grant_to(nft_mint_cap, to_address, nft);
    }

    /// Member quit Dao by self 
    public fun quit_member<DaoT: store>(sender: &signer) acquires DaoNFTBurnCapHolder, DaoTokenBurnCapHolder{
        let member_addr = Signer::address_of(sender);
        do_remove_member<DaoT>(member_addr);
    }

    /// Revoke membership with cap
    public fun revoke_member<DaoT:store,PluginT>(_cap: &DaoMemberCap<DaoT, PluginT>, member_addr: address) acquires DaoNFTBurnCapHolder, DaoTokenBurnCapHolder{
        do_remove_member<DaoT>(member_addr);
    }

    fun do_remove_member<DaoT:store>(member_addr: address) acquires DaoNFTBurnCapHolder, DaoTokenBurnCapHolder{
        assert!(is_member<DaoT>(member_addr), Errors::already_published(ERR_NOT_MEMBER));
        let dao_address = dao_address<DaoT>();

        let nft_burn_cap = &mut borrow_global_mut<DaoNFTBurnCapHolder<DaoT>>(dao_address).cap;
        let nft = IdentifierNFT::revoke<DaoMember<DaoT>, DaoMemberBody<DaoT>>(nft_burn_cap, member_addr);
        let DaoMemberBody<DaoT>{ sbt } = NFT::burn_with_cap(nft_burn_cap, nft);
        
        let token_burn_cap = &mut borrow_global_mut<DaoTokenBurnCapHolder<DaoT>>(dao_address).cap;
        Token::burn_with_capability(token_burn_cap, sbt);
    }

    /// Increment the member SBT
    public fun increase_member_sbt<DaoT:store, PluginT>(_cap: &DaoMemberCap<DaoT, PluginT>, member_addr: address, amount: u128) acquires DaoNFTUpdateCapHolder, DaoTokenMintCapHolder {
        assert!(is_member<DaoT>(member_addr), Errors::already_published(ERR_NOT_MEMBER));
        let dao_address = dao_address<DaoT>();

        let nft_update_cap = &mut borrow_global_mut<DaoNFTUpdateCapHolder<DaoT>>(dao_address).cap;
        let borrow_nft = IdentifierNFT::borrow_out<DaoMember<DaoT>, DaoMemberBody<DaoT>>(nft_update_cap, member_addr);
        let nft = IdentifierNFT::borrow_nft_mut(&mut borrow_nft);
        let body = NFT::borrow_body_mut_with_cap(nft_update_cap, nft);

        let token_mint_cap = &mut borrow_global_mut<DaoTokenMintCapHolder<DaoT>>(dao_address).cap;
        let increase_sbt = Token::mint_with_capability<DaoT>(token_mint_cap, amount);
        Token::deposit(&mut body.sbt, increase_sbt);
        IdentifierNFT::return_back(borrow_nft);
    }

    /// Decrement the member SBT
    public fun decrease_member_sbt<DaoT:store, PluginT>(_cap: &DaoMemberCap<DaoT, PluginT>, member_addr: address, amount: u128) acquires DaoNFTUpdateCapHolder, DaoTokenBurnCapHolder {
        assert!(is_member<DaoT>(member_addr), Errors::already_published(ERR_NOT_MEMBER));
        let dao_address = dao_address<DaoT>();

        let nft_update_cap = &mut borrow_global_mut<DaoNFTUpdateCapHolder<DaoT>>(dao_address).cap;
        let borrow_nft = IdentifierNFT::borrow_out<DaoMember<DaoT>, DaoMemberBody<DaoT>>(nft_update_cap, member_addr);
        let nft = IdentifierNFT::borrow_nft_mut(&mut borrow_nft);
        let body = NFT::borrow_body_mut_with_cap(nft_update_cap, nft);

        let token_burn_cap = &mut borrow_global_mut<DaoTokenBurnCapHolder<DaoT>>(dao_address).cap;
        let decrease_sbt = Token::withdraw(&mut body.sbt, amount);
        Token::burn_with_capability(token_burn_cap, decrease_sbt);
        IdentifierNFT::return_back(borrow_nft);
    }

    /// Check the `member_addr` account is a member of DaoT
    public fun is_member<DaoT: store>(member_addr: address): bool{
        IdentifierNFT::owns<DaoMember<DaoT>, DaoMemberBody<DaoT>>(member_addr)
    }
    
    // Acquiring Capabilities

    fun validate_cap<DaoT: store, PluginT>(cap: CapType) acquires InstalledPluginInfo{
        let addr = dao_address<DaoT>();
        if (exists<InstalledPluginInfo<PluginT>>(addr)) {
            let plugin_info = borrow_global<InstalledPluginInfo<PluginT>>(addr);
            assert!(Vector::contains(&plugin_info.granted_caps, &cap), Errors::requires_capability(E_NO_GRANTED));
        } else {
            abort(Errors::requires_capability(E_NO_GRANTED))
        }
    }

    /// Acquire the installed plugin capability
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_install_plugin_cap<DaoT:store, PluginT>(_witness: &PluginT): DaoInstallPluginCap<DaoT, PluginT> acquires InstalledPluginInfo{
        validate_cap<DaoT, PluginT>(install_plugin_cap_type());
        DaoInstallPluginCap<DaoT, PluginT>{}
    }

    /// Acquire the upgrade module capability
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_upgrade_module_cap<DaoT:store, PluginT>(_witness: &PluginT): DaoUpgradeModuleCap<DaoT, PluginT> acquires InstalledPluginInfo{
        validate_cap<DaoT, PluginT>(upgrade_module_cap_type());
        DaoUpgradeModuleCap<DaoT, PluginT>{}
    }

    /// Acquire the modify config capability
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_modify_config_cap<DaoT:store, PluginT>(_witness: &PluginT): DaoModifyConfigCap<DaoT, PluginT> acquires InstalledPluginInfo{
        validate_cap<DaoT, PluginT>(modify_config_cap_type());
        DaoModifyConfigCap<DaoT, PluginT>{}
    }

    /// Acquires the withdraw Token capability 
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_withdraw_token_cap<DaoT:store, PluginT>(_witness: &PluginT): DaoWithdrawTokenCap<DaoT, PluginT> acquires InstalledPluginInfo{
        validate_cap<DaoT, PluginT>(withdraw_token_cap_type());
        DaoWithdrawTokenCap<DaoT, PluginT>{}
    }

    /// Acquires the withdraw NFT capability
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_withdraw_nft_cap<DaoT:store, PluginT>(_witness: &PluginT): DaoWithdrawNFTCap<DaoT, PluginT> acquires InstalledPluginInfo{
        validate_cap<DaoT, PluginT>(withdraw_nft_cap_type());
        DaoWithdrawNFTCap<DaoT, PluginT>{}
    }

    /// Acquires the storage capability
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_storage_cap<DaoT:store, PluginT>(_witness: &PluginT): DaoStorageCap<DaoT, PluginT> acquires InstalledPluginInfo{
        validate_cap<DaoT, PluginT>(storage_cap_type());
        DaoStorageCap<DaoT, PluginT>{}
    }

    /// Acquires the membership capability
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_member_cap<DaoT:store, PluginT>(_witness: &PluginT): DaoMemberCap<DaoT, PluginT> acquires InstalledPluginInfo{
        validate_cap<DaoT, PluginT>(member_cap_type());
        DaoMemberCap<DaoT, PluginT>{}
    }

    /// Acquire the proposql capability
    /// _witness parameter ensures that the caller is the module which define PluginT
    public fun acquire_proposal_cap<DaoT:store, PluginT>(_witness: &PluginT): DaoProposalCap<DaoT, PluginT> acquires InstalledPluginInfo{
        validate_cap<DaoT, PluginT>(proposal_cap_type());
        DaoProposalCap<DaoT, PluginT>{}
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

    struct ProposalState has copy, drop, store {state: u8}

      /// voting choice: 1:yes, 2:no, 3: no_with_veto, 4:abstain
    const VOTING_CHOICE_YES: u8 = 1;
    const VOTING_CHOICE_NO: u8 = 2;
    // Review: How to prevent spam, cosmos provide a NO_WITH_VETO option, and the proposer need deposit some Token when create proposal.
    // this choice from  https://docs.cosmos.network/master/modules/gov/01_concepts.html
    const VOTING_CHOICE_NO_WITH_VETO: u8 = 3;
    const VOTING_CHOICE_ABSTAIN: u8 = 4;

    struct VotingChoice has copy,drop,store{
        choice: u8,
    }

    public fun choice_yes(): VotingChoice{VotingChoice{choice: VOTING_CHOICE_YES}}
    public fun choice_no(): VotingChoice{VotingChoice{choice: VOTING_CHOICE_NO}}
    public fun choice_no_with_veto(): VotingChoice{VotingChoice{choice: VOTING_CHOICE_NO_WITH_VETO}}
    public fun choice_abstain(): VotingChoice{VotingChoice{choice: VOTING_CHOICE_ABSTAIN}}


    /// Proposal category
    /// DAO 1.0 support: membership join, survey vote and governance vote category
    const PROPOSAL_CATEGORY_MEMBERSHIP_JOIN: u8 = 1;
    const PROPOSAL_CATEGORY_SURVEY_VOTE: u8 = 2;
    const PROPOSAL_CATEGORY_GOVERNANCE_VOTE: u8 = 3;
    const PROPOSAL_CATEGORY_FUNDING: u8 = 4;
    const PROPOSAL_CATEGORY_MEMBERSHIP_KICK: u8 = 5;

    /// Voting system
    /// DAO 1.0 support: single choice voting system
    const VOTING_SYSTEM_SINGLE_CHOICE_VOTING: u8 = 1;
    const VOTING_SYSTEM_APPROVAL_VOTING: u8 = 2;

    /// Strategy
    /// DAO 1.0 support: balance strategy and sbt of weighted strategy
    /// TODO abstract strategy template and strategy instance
    const STRATEGY_SBT: u8 = 1; //for sbt
    const STRATEGY_BALANCE: u8 = 2; //for token balance
    const STRATEGY_BALANCE_WITH_MIN: u8 = 3;
    const STRATEGY_BALANCE_OF_WEIGHTED: u8 = 4; //TODO
    const STRATEGY_NFT: u8 = 5;


    /// Proposal data struct.
    /// review: it is safe to has `copy` and `drop`?
    struct Proposal has store, copy, drop {
        /// id of the proposal
        id: u64,
        /// creator of the proposal
        proposer: address,
        /// when voting begins.
        start_time: u64,
        /// when voting ends.
        end_time: u64,
        /// count of voters who `yes|no|no_with_veto|abstain` with the proposal
//        votes: vector<u128>,
        yes_votes: u128,
        no_votes: u128,
        no_with_veto_votes: u128,
        abstain_votes: u128,
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

//        /// count of voters who're `yes|no|no_with_veto|abstain` the proposal
//        yes_votes: u128,
//        no_votes: u128,
//        no_with_veto_votes: u128,
//        abstain_votes: u128,
//        /// total weight of voters who agree with the proposal, for extend
//        total_for_votes_weight: u128,
//        /// total weight of voters who're against the proposal, for extend
//        total_against_votes_weight: u128,
//        /// total weight of voters who're abstain the proposal, for extend
//        total_abstain_votes_weight: u128,
        /// dao id, maybe to erasure generic, for extend
        dao_id: u64,
//        /// proposal category
//        category: u8,
        /// voting system, default single choice voting system, for extend
        voting_system: u8,
    }

    struct ProposalAction<Action: store> has store{
        /// id of the proposal
        proposal_id: u64,
        //To prevent spam, proposals must be submitted with a deposit
        //TODO should support custom Token?
        deposit: Token<STC>,
        /// proposal action.
        action: Action,
    }

    /// Same as Proposal but has copy and drop
    struct ProposalInfo has store, copy, drop {
       //TODO add fieldds
    }
   
    /// Keep a global proposal record for query proposal by id.
    /// Replace with Table when support Table.
    struct GlobalProposals has key {
        proposals: vector<Proposal>,
    }

    /// Every ActionT keep a vector in the Dao account
    struct ProposalActions<ActionT:store> has key{
        actions: vector<ProposalAction<ActionT>>,
    }

    /// User vote info.
    struct Vote has store {
        /// proposal id.
        proposal_id: u64,
        /// voting amount
//        vote_amount: u128,
        /// voting weight
        vote_weight: u128,
        /// 1:yes, 2:no, 3:no_with_veto, 4:abstain
        choice: u8,
    }

    /// Every voter keep a vector Vote for per Dao
    struct MyVotes<phantom DaoT> has key {
        votes: vector<Vote>,
    }

    /// use bcs se/de for Snapshot proofs
    struct SnapshotProof has store, drop, copy {
        account_proof_leaf: vector<vector<u8>>,
        account_proof_siblings: vector<vector<u8>>,
        account_state: vector<u8>,
        account_state_proof_leaf: vector<vector<u8>>,
        account_state_proof_siblings: vector<vector<u8>>,
        state: vector<u8>,
        resource_struct_tag: vector<u8>,
    }

    /// emitted when proposal created.
    struct ProposalCreatedEvent has drop, store {
        /// the proposal id.
        proposal_id: u64,
        /// proposer is the user who create the proposal.
        proposer: address,
    }

    /// emitted when user vote/revoke_vote.
    struct VoteChangedEvent has drop, store {
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

    struct ProposalEvent<phantom DaoT: store> has key, store {
        /// proposal creating event.
        proposal_create_event: Event::EventHandle<ProposalCreatedEvent>,
        /// voting event.
        vote_changed_event: Event::EventHandle<VoteChangedEvent>,
    }

    /// Initialize proposal
    /// only call by dao singer when DAO create
    fun initialize_proposal<DaoT: store>(cap: &DaoAccountCap) {
        let dao_signer = DaoAccount::dao_signer(cap);

        let proposal_event = ProposalEvent<DaoT>  {
            proposal_create_event: Event::new_event_handle<ProposalCreatedEvent>(&dao_signer),
            vote_changed_event: Event::new_event_handle<VoteChangedEvent>(&dao_signer),
        };
        move_to(&dao_signer, proposal_event);
    }

    /// propose a proposal.
    /// `dao_id`: the dao id to which the proposal belongs
    /// `category`: the actual proposal category
    /// `voting_system`: the actual voting system, default single choice voting system
    /// `strategy`: the actual voting strategy
    /// `action`: the actual action to execute.
    /// `action_delay`: the delay to execute after the proposal is agreed
    public fun create_proposal<DaoT: store, PluginT, ActionT: store>(
        _cap: &DaoProposalCap<DaoT, PluginT>,
        sender: &signer,

//        dao_id: u64,
//        category: u8,
//        voting_system: u8,
//        strategy: u8, //TODO todo implementation

        action: ActionT,
        action_delay: u64,
    ): u64 acquires Dao, GlobalProposals, DaoAccountCapHolder, ProposalActions, ProposalEvent {
        
        if (action_delay == 0) {
            action_delay = min_action_delay<DaoT>();
        } else {
            assert!(action_delay >= min_action_delay<DaoT>(), Errors::invalid_argument(ERR_ACTION_DELAY_TOO_SMALL));
        };
        //TODO load from config
        let min_proposal_deposit = min_proposal_deposit<DaoT>();
        let deposit = Account::withdraw<STC>(sender, min_proposal_deposit);

        let proposal_id = next_proposal_id<DaoT>();
        let proposer = Signer::address_of(sender);
        let start_time = Timestamp::now_milliseconds() + voting_delay<DaoT>();
        let quorum_votes = quorum_votes<DaoT>();
        let voting_period = voting_period<DaoT>();

        let voting_system = voting_system<DaoT>();
        let (block_number,state_root) = block_number_and_state_root();
        
        //four choise, so init four length vector.
        let votes = Vector::singleton(0u128);
        Vector::push_back(&mut votes, 0u128);
        Vector::push_back(&mut votes, 0u128);
        Vector::push_back(&mut votes, 0u128);

        let proposal = Proposal {
            id: proposal_id,
            proposer,
            start_time,
            end_time: start_time + voting_period,
            for_votes: 0,
            against_votes: 0,
            votes,
            eta: 0,
            action_delay,
            quorum_votes,

            abstain_votes: 0,
            total_for_votes_weight: 0,
            total_against_votes_weight: 0,
            total_abstain_votes_weight : 0,
            dao_id,
//            category,
            voting_system,
            // TODO strategy should be an intance of strategy template
//            strategy,
            block_number,
            state_root,
        };
        let proposal_action = ProposalAction{
            proposal_id,
            deposit,
            action,
        };

        let dao_signer = dao_signer<DaoT>();
        let dao_address = dao_address<DaoT>();

        let actions = Vector::singleton(proposal_action);
        //TODO check ProposalActions is exists
        if(exists<ProposalActions<ActionT>>(dao_address)){
            //TODO add limit to max action before support Table.
            let current_actions = borrow_global_mut<ProposalActions<ActionT>>(dao_address);
            Vector::append(&mut current_actions.actions, actions);
        }else{
            move_to(&dao_signer, ProposalActions<ActionT>{
                actions,
            });
        };
        let global_proposals = borrow_global_mut<GlobalProposals>(dao_address);
        //TODO add limit to max proposal before support Table
        Vector::push_back(&mut global_proposals.proposals, proposal);

        // emit event
        let proposal_event = borrow_global_mut<ProposalEvent<DaoT>>(DaoRegistry::dao_address<DaoT>());
        Event::emit_event(&mut proposal_event.proposal_create_event,
            ProposalCreatedEvent { proposal_id, proposer },
        );

        //TODO trigger event
        proposal_id
    }

    /// voting_system default single choice voting system
    fun get_default_voting_system(): u8 {
        VOTING_SYSTEM_SINGLE_CHOICE_VOTING
    }

    fun block_number_and_state_root():(u64, vector<u8>){
        //TODO how to get state root
        (0, Vector::empty())
    }


    /// votes for a proposal.
    /// User can only vote once, then the stake is locked,
    /// The voting power depends on the strategy of the proposal configuration and the user's token amount at the time of the snapshot
    public fun cast_vote<DaoT: store>(
        sender: &signer,
        proposal_id: u64,
        snpashot_proofs: vector<u8>,
        choice: VotingChoice,
    )  acquires GlobalProposals, MyVotes, ProposalEvent{
        let dao_address = dao_address<DaoT>();
        let proposals = borrow_global_mut<GlobalProposals>(dao_address);
        let proposal = borrow_proposal_mut(proposals, proposal_id);

        {
            let state = proposal_state(proposal);
            // only when proposal is active, use can cast vote.
            assert!(state == ACTIVE, Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID));
        };

        // verify snapshot state proof
        let sender_addr = Signer::address_of(sender);
        let snapshot_proofs = deserialize_snapshot_proofs(&snpashot_proofs);
        let state_proof = new_state_proof_from_proofs(snapshot_proofs);
        // verify state_proof according to proposal snapshot proofs, and state root
        let verify = StarcoinVerifier::verify_state_proof(&state_proof, &proposal.state_root, sender_addr, &snapshot_proofs.resource_struct_tag, &snapshot_proofs.state);
        assert!(verify, Errors::invalid_state(ERR_STATE_PROOF_VERIFY_INVALID));

        // TODO is allowed just use part of weight?
        // decode sbt value from snapshot state
        let vote_weight = SBTVoteStrategy::get_voting_power(&snapshot_proofs.state);
//        let weight = VoteUtil::get_vote_weight_from_sbt_snapshot(sender_addr, *&proposal.state_root, sbt_proof);

        assert!(!has_voted<DaoT>(sender_addr, proposal_id), Errors::invalid_state(ERR_VOTED_ALREADY));
        
        let vote = Vote{
            proposal_id,
            vote_weight,
            choice: choice.choice,
        };

        do_cast_vote(proposal, &mut vote);

        if (exists<MyVotes<DaoT>>(sender_addr)) {
            assert!(vote.proposal_id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
            let my_votes = borrow_global_mut<MyVotes<DaoT>>(sender_addr);
            Vector::push_back(&mut my_votes.votes, vote);
        } else {
            move_to(sender, MyVotes<DaoT>{
                votes: Vector::singleton(vote),
            });
        };

        // emit event
        let proposal_event = borrow_global_mut<ProposalEvent<DaoT> >(DaoRegistry::dao_address<DaoT>());
        Event::emit_event(&mut proposal_event.vote_changed_event,
            VoteChangedEvent {
                proposal_id,
                voter: sender_addr,
                choice: choice.choice,
                vote_weight,
            },
        );
    }


    fun deserialize_snapshot_proofs(snapshot_proofs: &vector<u8>): SnapshotProof{
        assert!(Vector::length(snapshot_proofs) > 0, Errors::invalid_argument(ERR_SNAPSHOT_PROOF_PARAM_INVALID));

        let offset= 0;
        let (account_proof_leaf, offset) = BCS::deserialize_bytes_vector(snapshot_proofs, offset);
        let (account_proof_siblings, offset) = BCS::deserialize_bytes_vector(snapshot_proofs, offset);
        let (account_state, offset) = BCS::deserialize_bytes(snapshot_proofs, offset);
        let (account_state_proof_leaf, offset) = BCS::deserialize_bytes_vector(snapshot_proofs, offset);
        let (account_state_proof_siblings, offset) = BCS::deserialize_bytes_vector(snapshot_proofs, offset);
        let (state, offset) = BCS::deserialize_bytes(snapshot_proofs, offset);
        let (resource_struct_tag, offset) = BCS::deserialize_bytes(snapshot_proofs, offset);

        SnapshotProof {
            account_proof_leaf,
            account_proof_siblings,
            account_state,
            account_state_proof_leaf,
            account_state_proof_siblings,
            state,
            resource_struct_tag,
        }
    }

    fun new_state_proof_from_proofs(snpashot_proofs: SnapshotProof): StateProof{
        let (account_proof_leaf_hash1, account_proof_leaf_hash2) = (Vector::empty(), Vector::empty());
        let (account_state_proof_leaf_hash1, account_state_proof_leaf_hash2) = (Vector::empty(), Vector::empty());

        if (Vector::length(&snpashot_proofs.account_proof_leaf) >= 2){
            account_proof_leaf_hash1 = *Vector::borrow(&snpashot_proofs.account_proof_leaf, 0);
            account_proof_leaf_hash2 = *Vector::borrow(&snpashot_proofs.account_proof_leaf, 1);
        };
        if (Vector::length(&snpashot_proofs.account_state_proof_leaf) >= 2){
            account_state_proof_leaf_hash1 = *Vector::borrow(&snpashot_proofs.account_state_proof_leaf, 0);
            account_state_proof_leaf_hash2 = *Vector::borrow(&snpashot_proofs.account_state_proof_leaf, 1);
        };
        let state_proof = StarcoinVerifier::new_state_proof(
            StarcoinVerifier::new_sparse_merkle_proof(
                *&snpashot_proofs.account_proof_siblings,
                StarcoinVerifier::new_smt_node(
                    account_proof_leaf_hash1,
                    account_proof_leaf_hash2,
                ),
            ),
            *&snpashot_proofs.account_state,
            StarcoinVerifier::new_sparse_merkle_proof(
                *&snpashot_proofs.account_state_proof_siblings,
                StarcoinVerifier::new_smt_node(
                    account_state_proof_leaf_hash1,
                    account_state_proof_leaf_hash2,
                ),
            ),
        );
        state_proof
    }

    /// Just change vote choice, the weight do not change.
    public fun change_vote<DaoT>(
        _sender: &signer,
        _proposal_id: u64,
        _choice: VotingChoice,
    ){
        //TODO
    }

    public fun revoke_vote<DaoT>(
        _sender: &signer,
        _proposal_id: u64,
    ){
        //TODO
    }

    // Execute the proposal and return the action.
    public fun execute_proposal<DaoT, PluginT, ActionT: store>(
        _cap: &DaoProposalCap<DaoT, PluginT>,
        _sender: &signer,
        proposal_id: u64,
    ): ActionT acquires ProposalActions, GlobalProposals {
        // Only executable proposal's action can be extracted.
        // assert!(
        //     proposal_state<DaoT>(proposer_address, proposal_id) == EXECUTABLE,
        //     Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID),
        // );
        let dao_address = dao_address<DaoT>();
        //TODO error code
        assert!(exists<ProposalActions<ActionT>>(dao_address), 0);
        
        take_proposal_action(dao_address, proposal_id)
    }

    fun take_proposal_action<ActionT: store>(dao_address: address, proposal_id: u64): ActionT acquires ProposalActions, GlobalProposals{
        let actions = borrow_global_mut<ProposalActions<ActionT>>(dao_address);
        let index_opt = find_action(&actions.actions, proposal_id);
        assert!(Option::is_some(&index_opt), Errors::invalid_argument(ERR_ACTION_INDEX_INVALID));

        let global_proposals = borrow_global<GlobalProposals>(dao_address);
        let proposal = borrow_proposal(global_proposals, proposal_id);
        
        let index = Option::extract(&mut index_opt);
        let ProposalAction{ proposal_id:_, deposit, action} = Vector::remove(&mut actions.actions, index);
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
        let choice = VotingChoice {
            choice: vote.choice,
        };
        if (choice_yes() == choice) {
            proposal.yes_votes = proposal.yes_votes + vote.vote_weight;
        } else if (choice_no() == choice) {
            proposal.no_votes = proposal.no_votes + vote.vote_weight;
        } else if ( choice_no_with_veto() == choice) {
            proposal.no_with_veto_votes = proposal.no_with_veto_votes + vote.vote_weight;
        } else if (choice_abstain() == choice) {
            proposal.abstain_votes = proposal.abstain_votes + vote.vote_weight;
        } else {
            abort Errors::invalid_argument(ERR_VOTE_PARAM_INVALID)
        };
    }

    fun has_voted<DaoT>(sender: address, proposal_id: u64): bool acquires MyVotes{
        if(exists<MyVotes<DaoT>>(sender)){
            let my_votes = borrow_global<MyVotes<DaoT>>(sender);
            let vote = get_vote<DaoT>(my_votes, proposal_id);
            Option::is_some(vote)
        }else{
            false
        }
    }

    /// get vote by proposal_id
    fun get_vote<DaoT>(my_votes: &MyVotes<DaoT>, proposal_id: u64): &Option<Vote>{
        let len = Vector::length<DaoT>(&my_votes.votes);
        let idx = 0;
        loop {
            if (idx >= len) {
                break
            };
            let vote = Vector::borrow(&my_votes.votes, idx);
            if (proposal_id == vote.proposal_id) {
                return &Option::some(*vote)
            };
            idx = idx + 1;
        };

        &Option::none<Vote>()
    }

//    public fun proposal_state<TokenT: copy + drop + store, ActionT: copy + drop + store>(
//        proposer_address: address,
//        proposal_id: u64,


    public fun proposal_state<DaoT: store, ActionT: store>(proposal_id: u64) : u8 acquires ProposalActions {
        let dao_address = dao_address<DaoT>();
        let current_time = Timestamp::now_milliseconds();

        let actions = borrow_global<ProposalActions<ActionT>>(dao_address);
        let action_index_opt = find_action(&actions.actions, proposal_id);
        do_proposal_state(proposal, current_time, action_index_opt)
    }

    fun do_proposal_state(
        proposal: &Proposal,
        current_time: u64,
        action_index_opt: Option<u64>
    ): u8 {
        if (current_time < proposal.start_time) {
            // Pending
            PENDING
        } else if (current_time <= proposal.end_time) {
            // Active
            ACTIVE
            //TODO need restrict yes votes ratio with (no/no_with_veto/abstain) ?
        } else if (proposal.yes_votes <= (proposal.no_votes + proposal.no_with_veto_votes + proposal.abstain_votes) ||
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
    /// return: (id, start_time, end_time, for_votes, against_votes).
    public fun proposal_info<DaoT: copy + drop + store, ActionT: copy + drop + store>(
        proposal_id: u64,
    ): (u64, u64, u64, u128, u128) acquires GlobalProposals {
        let dao_address = DaoRegistry::dao_address<DaoT>();
        let proposals = borrow_global_mut<GlobalProposals>(dao_address);
        let proposal = borrow_proposal_mut(proposals, proposal_id);
        (proposal.id, proposal.start_time, proposal.end_time, proposal.for_votes, proposal.against_votes)
    }

    fun borrow_proposal_mut(_proposals: &mut GlobalProposals, _proposal_id: u64): &mut Proposal{
        //TODO
        abort 0
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

    ///Return a copy of Proposal
    public fun proposal<DaoT>(proposal_id: u64): Proposal acquires GlobalProposals{
        let dao_address = dao_address<DaoT>();
        let global_proposals = borrow_global<GlobalProposals>(dao_address);
        *borrow_proposal(global_proposals, proposal_id)
    }


    /// DaoConfig
    /// ---------------------------------------------------

    /// create a dao config
    public fun new_dao_config(
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        min_proposal_deposit: u128,
        voting_system: u8,
    ): DaoConfig{
        assert!(voting_delay > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        assert!(voting_period > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        assert!(
            voting_quorum_rate > 0 && voting_quorum_rate <= 100,
            Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID),
        );
        assert!(min_action_delay > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        DaoConfig { voting_delay, voting_period, voting_quorum_rate, min_action_delay, min_proposal_deposit, voting_system }
    }

    /// get default voting delay of the DAO.
    public fun voting_delay<DaoT: store>(): u64 {
        get_config<DaoT>().voting_delay
    }

    /// get the default voting period of the DAO.
    public fun voting_period<DaoT: store>(): u64 {
        get_config<DaoT>().voting_period
    }

    /// Quorum votes to make proposal pass.
    public fun quorum_votes<DaoT: store>(): u128 {
        let market_cap = Token::market_cap<DaoT>();
        let rate = voting_quorum_rate<DaoT>();
        let rate = (rate as u128);
        market_cap * rate / 100
    }
    
    /// Get the quorum rate in percent.
    public fun voting_quorum_rate<DaoT: store>(): u8 {
        get_config<DaoT>().voting_quorum_rate
    }

    /// Get the min action delay of the DAO.
    public fun min_action_delay<DaoT: store>(): u64 {
        get_config<DaoT>().min_action_delay
    }

    /// Get the min proposal deposit of the DAO.
    public fun min_proposal_deposit<DaoT: store>(): u128{
        get_config<DaoT>().min_proposal_deposit
    }

    /// Get the voting system of the DAO.
    public fun voting_system<DaoT: store>(): u8{
        get_config<DaoT>().voting_system
    }

    fun get_config<DaoT: store>(): DaoConfig {
        let dao_address= dao_address<DaoT>();
        Config::get_by_address<DaoConfig>(dao_address)
    }

    /// Update function, modify dao config.
    public fun modify_dao_config<DaoT: store, PluginT>(
        _cap: &mut DaoModifyConfigCap<DaoT, PluginT>,
        new_config: DaoConfig,
    ) acquires DaoConfigModifyCapHolder {
        let modify_config_cap = &mut borrow_global_mut<DaoConfigModifyCapHolder>(
            dao_address<DaoT>(),
        ).cap;
        //assert!(Config::account_address(cap) == Token::token_address<TokenT>(), Errors::invalid_argument(ERR_NOT_AUTHORIZED));
        Config::set_with_capability<DaoConfig>(modify_config_cap, new_config);
    }

    /// set voting delay
    public fun set_voting_delay(
        config: &mut DaoConfig,
        value: u64,
    ) {
        assert!(value > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        config.voting_delay = value;
    }

    /// set voting period
    public fun set_voting_period<DaoT: store>(
        config: &mut DaoConfig,
        value: u64,
    ) {
        assert!(value > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        config.voting_period = value;
    }

    /// set voting quorum rate
    public fun set_voting_quorum_rate<DaoT: store>(
        config: &mut DaoConfig,
        value: u8,
    ) {
        assert!(value <= 100 && value > 0, Errors::invalid_argument(ERR_QUORUM_RATE_INVALID));
        config.voting_quorum_rate = value;
    }

    /// set min action delay
    public fun set_min_action_delay<DaoT: store>(
        config: &mut DaoConfig,
        value: u64,
    ) {
        assert!(value > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        config.min_action_delay = value;
    }

    /// set min action delay
    public fun set_min_proposal_deposit<DaoT: store>(
        config: &mut DaoConfig,
        value: u128,
    ) {
        config.min_proposal_deposit = value;
    }

    /// set voting system
    public fun set_voting_system<DaoT: store>(
        config: &mut DaoConfig,
        value: u8,
    ) {
        config.voting_system = value;
    }


    /// Helpers
    /// ---------------------------------------------------


     fun next_member_id<DaoT>(): u64 acquires Dao {
        let dao_address = dao_address<DaoT>();
        let dao = borrow_global_mut<Dao>(dao_address);
        let member_id = dao.next_member_id;
        dao.next_member_id = member_id + 1;
        member_id
    }

    fun next_proposal_id<DaoT>(): u64 acquires Dao {
        let dao_address = dao_address<DaoT>();
        let dao = borrow_global_mut<Dao>(dao_address);
        let proposal_id = dao.next_proposal_id;
        dao.next_proposal_id = proposal_id + 1;
        proposal_id
    }

    fun assert_no_repeat<E>(v: &vector<E>) {
        let i = 0;
        let len = Vector::length(v);
        while(i < len){
            let e = Vector::borrow(v, i);
            if(Vector::contains(v, e)){
                abort Errors::invalid_argument(ERR_REPEAT_ELEMENT)
            };
            i = i + 1;
        };
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

    fun dao_signer<DaoT>(): signer acquires DaoAccountCapHolder{
        let cap = &borrow_global<DaoAccountCapHolder>(dao_address<DaoT>()).cap;
        DaoAccount::dao_signer(cap)
    }

    fun dao_address<DaoT>(): address {
        DaoRegistry::dao_address<DaoT>()
    }    
}