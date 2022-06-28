module StarcoinFramework::GenesisDao {
    use StarcoinFramework::DaoAccount::{Self, DaoAccountCapability};
    use StarcoinFramework::Account;
    use StarcoinFramework::Vector;
    use StarcoinFramework::NFT::{Self};
    use StarcoinFramework::IdentifierNFT;
    use StarcoinFramework::Signer;
    use StarcoinFramework::DaoRegistry;
    use StarcoinFramework::Token::{Self, Token};
    use StarcoinFramework::Errors;
    use StarcoinFramework::VoteUtil;
    use StarcoinFramework::Option::{Self, Option};
    use StarcoinFramework::STC::{STC};
    use StarcoinFramework::Timestamp;

    const E_NO_GRANTED: u64 = 1;

    const ERR_NOT_AUTHORIZED: u64 = 1401;
    const ERR_ACTION_DELAY_TOO_SMALL: u64 = 1402;
    const ERR_PROPOSAL_STATE_INVALID: u64 = 1403;
    const ERR_PROPOSAL_ID_MISMATCH: u64 = 1404;
    const ERR_PROPOSER_MISMATCH: u64 = 1405;
    const ERR_QUORUM_RATE_INVALID: u64 = 1406;
    const ERR_CONFIG_PARAM_INVALID: u64 = 1407;
    const ERR_VOTE_STATE_MISMATCH: u64 = 1408;
    const ERR_ACTION_MUST_EXIST: u64 = 1409;
    const ERR_VOTED_OTHERS_ALREADY: u64 = 1410;
    const ERR_RESOURCE_EXISTS: u64 = 1411;

    struct Dao has key {
        id: u64,
        // maybe should use ASIIC String
        name: vector<u8>,
        dao_address: address,
    }

    struct DaoExt<DaoT: store> has key {
        ext: DaoT,
    }

    struct DaoAccountCapHolder has key {
        cap: DaoAccountCapability,
    }

    struct DaoTokenMintCapHolder<phantom DaoT> has key {
        cap: Token::MintCapability<DaoT>,
    }

    struct DaoTokenBurnCapHolder<phantom DaoT> has key {
        cap: Token::BurnCapability<DaoT>,
    }

    struct DaoNFTMintCapHolder<phantom DaoT> has key {
        cap: NFT::MintCapability<DaoMember<DaoT>>,
    }

    struct DaoNFTBurnCapHolder<phantom DaoT> has key {
        cap: NFT::BurnCapability<DaoMember<DaoT>>,
    }

    struct DaoNFTUpdateCapHolder<phantom DaoT> has key {
        cap: NFT::UpdateCapability<DaoMember<DaoT>>,
    }

    /// A type describing a capability. 
    struct CapType has copy, drop, store { code: u8 }

    /// Creates a install plugin capability type.
    public fun install_plugin_cap_type(): CapType { CapType{ code: 0 } }

    /// Creates a upgrade module capability type.
    public fun upgrade_module_cap_type(): CapType { CapType{ code: 1 } }

    /// Creates a withdraw Token capability type.
    public fun withdraw_token_cap_type(): CapType { CapType{ code: 2 } }

    /// Creates a withdraw NFT capability type.
    public fun withdraw_nft_cap_type(): CapType { CapType{ code: 3 } }

    /// Crates a write data to Dao account capability type.
    public fun storage_cap_type(): CapType { CapType{ code: 4 } }

    /// Crates a member capability type.
    /// This cap can issue Dao member NFT or update member's SBT
    public fun member_cap_type(): CapType { CapType{ code: 5 } }

    public fun proposal_cap_type(): CapType { CapType{ code: 6 } }

    public fun all_caps(): vector<CapType> {
        let caps = Vector::singleton(upgrade_module_cap_type());
        Vector::push_back(&mut caps, install_plugin_cap_type());
        Vector::push_back(&mut caps, withdraw_token_cap_type());
        Vector::push_back(&mut caps, withdraw_nft_cap_type());
        Vector::push_back(&mut caps, storage_cap_type());
        Vector::push_back(&mut caps, member_cap_type());
        Vector::push_back(&mut caps, proposal_cap_type());
        caps
    }

    /// RootCap only have one instance, and can not been `drop` and `store`
    struct DaoRootCap<phantom DaoT> {}

    struct DaoInstallPluginCap<phantom DaoT, phantom PluginT> has drop {}

    struct DaoUpgradeModuleCap<phantom DaoT, phantom PluginT> has drop {}

    struct DaoWithdrawTokenCap<phantom DaoT, phantom PluginT> has drop {}

    struct DaoWithdrawNFTCap<phantom DaoT, phantom PluginT> has drop {}

    struct DaoStorageCap<phantom DaoT, phantom PluginT> has drop {}

    struct DaoMemberCap<phantom DaoT, phantom PluginT> has drop {}

    struct DaoProposalCap<phantom DaoT, phantom PluginT> has drop {}

    /// The info for Dao installed Plugin
    struct InstalledPluginInfo<phantom PluginT> has key {
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
    public fun upgrade_to_dao<DaoT: store>(sender: signer, name: vector<u8>, ext: DaoT): DaoRootCap<DaoT> {
        let cap = DaoAccount::upgrade_to_dao(sender);
        create_dao<DaoT>(cap, name, ext)
    }

    ///  Install ToInstallPluginT to Dao and grant the capabilites
    public fun install_plugin_with_root_cap<DaoT: store, ToInstallPluginT>(_cap: &DaoRootCap<DaoT>, granted_caps: vector<CapType>) acquires DaoAccountCapHolder {
        do_install_plugin<DaoT, ToInstallPluginT>(granted_caps);
    }

    /// Install plugin with DaoInstallPluginCap
    public fun install_plugin<DaoT: store, PluginT, ToInstallPluginT>(_cap: &DaoInstallPluginCap<DaoT, PluginT>, granted_caps: vector<CapType>) acquires DaoAccountCapHolder {
        do_install_plugin<DaoT, ToInstallPluginT>(granted_caps);
    }

    fun do_install_plugin<DaoT: store, ToInstallPluginT>(granted_caps: vector<CapType>) acquires DaoAccountCapHolder {
        //TODO check no repeat item in granted_caps

        let dao_signer = dao_signer<DaoT>();
        //TODO error code
        assert!(!exists<InstalledPluginInfo<ToInstallPluginT>>(Signer::address_of(&dao_signer)), 1);
        move_to(&dao_signer, InstalledPluginInfo<ToInstallPluginT>{
            granted_caps,
        });
    }

    /// Burn the root cap after init the Dao
    public fun burn_root_cap<DaoT>(cap: DaoRootCap<DaoT>) {
        let DaoRootCap{} = cap;
    }

    // Capability support function


    struct StorageItem<phantom PluginT, V: store> has key {
        item: V,
    }

    public fun save<DaoT: store, PluginT, V: store>(_cap: &DaoStorageCap<DaoT, PluginT>, item: V) acquires DaoAccountCapHolder {
        let dao_signer = dao_signer<DaoT>();

        // check exists
        assert!(exists<StorageItem<PluginT, V>>(dao_address<DaoT>()), Errors::invalid_state(ERR_RESOURCE_EXISTS));
        move_to(&dao_signer, StorageItem<PluginT, V>{
            item
        });
    }

    public fun take<DaoT: store, PluginT, V: store>(_cap: &DaoStorageCap<DaoT, PluginT>): V acquires StorageItem {
        let dao_address = dao_address<DaoT>();
        //TODO check exists
        let StorageItem{ item } = move_from<StorageItem<PluginT, V>>(dao_address);
        item
    }

    public fun borrow<DaoT: store, PluginT, V: store>(_cap: &DaoStorageCap<DaoT, PluginT>): &V acquires StorageItem {
        let dao_address = dao_address<DaoT>();
        //TODO check exists
        &borrow_global<StorageItem<PluginT, V>>(dao_address).item
    }

    public fun borrow_mut<DaoT: store, PluginT, V: store>(_cap: &DaoStorageCap<DaoT, PluginT>): &mut V acquires StorageItem {
        let dao_address = dao_address<DaoT>();
        //TODO check exists
        &mut borrow_global_mut<StorageItem<PluginT, V>>(dao_address).item
    }

    public fun withdraw_token<DaoT: store, PluginT, TokenT: store>(_cap: &DaoWithdrawTokenCap<DaoT, PluginT>, amount: u128): Token<TokenT> acquires DaoAccountCapHolder {
        let dao_signer = dao_signer<DaoT>();
        //we should extract the WithdrawCapability from account, and invoke the withdraw_with_cap ?
        Account::withdraw<TokenT>(&dao_signer, amount)
    }

    fun next_member_id(): u64 {
        //TODO implement
        0
    }

    // Membership function

    /// Join Dao and get a membership
    public fun join_member<DaoT: store, PluginT>(_cap: &DaoMemberCap<DaoT, PluginT>, to_address: address, init_sbt: u128) acquires DaoNFTMintCapHolder, DaoAccountCapHolder {
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
        IdentifierNFT::grant_to(nft_mint_cap, to_address, nft);
    }

    /// Member quit Dao by self 
    public fun quit_member<DaoT>(_sender: &signer) {
        //revoke IdentifierNFT
        //burn NFT
        //burn SBT Token
    }

    /// Revoke membership with cap
    public fun revoke_member<DaoT: store, PluginT>(_cap: &DaoMemberCap<DaoT, PluginT>, _member_addr: address) {
        //revoke IdentifierNFT
        //burn NFT
        //burn SBT Token
    }

    public fun update_member_sbt<DaoT: store, PluginT>(_cap: &DaoMemberCap<DaoT, PluginT>, _member_addr: address, _new_amount: u128) {
        //borrow mut the NFT
        // compare sbt and new_amount
        // mint more sbt token or burn sbt token
    }

    public fun query_member_sbt<DaoT: store, PluginT>(_cap: &DaoMemberCap<DaoT, PluginT>, _member_addr: address): u128 {
        //TODO query sbt
        //
        0
    }

    /// Check the `member_addr` account is a member of DaoT
    public fun is_member<DaoT: store>(member_addr: address): bool {
        IdentifierNFT::owns<DaoMember<DaoT>, DaoMemberBody<DaoT>>(member_addr)
    }

    //TODO implement more function

    // Acquiring Capabilities


    fun validate_cap<DaoT: store, PluginT>(cap: CapType) acquires InstalledPluginInfo {
        let addr = dao_address<DaoT>();
        if (exists<InstalledPluginInfo<PluginT>>(addr)) {
            let plugin_info = borrow_global<InstalledPluginInfo<PluginT>>(addr);
            assert!(Vector::contains(&plugin_info.granted_caps, &cap), Errors::requires_capability(E_NO_GRANTED));
        } else {
            abort (Errors::requires_capability(E_NO_GRANTED))
        }
    }

    public fun acquire_install_plugin_cap<DaoT: store, PluginT>(_witness: &PluginT): DaoInstallPluginCap<DaoT, PluginT> acquires InstalledPluginInfo {
        validate_cap<DaoT, PluginT>(install_plugin_cap_type());
        DaoInstallPluginCap<DaoT, PluginT>{}
    }

    /// Acquires the capability of withdraw Token from Dao for Plugin. The Plugin with appropriate capabilities. 
    /// _witness parameter ensure the invoke is from the PluginT module.
    public fun acquire_withdraw_token_cap<DaoT: store, PluginT>(_witness: &PluginT): DaoWithdrawTokenCap<DaoT, PluginT> acquires InstalledPluginInfo {
        validate_cap<DaoT, PluginT>(withdraw_token_cap_type());
        DaoWithdrawTokenCap<DaoT, PluginT>{}
    }

    /// Storage cap only suppport acquire from plugin
    public fun acquire_storage_cap<DaoT: store, PluginT>(_witness: &PluginT): DaoStorageCap<DaoT, PluginT> acquires InstalledPluginInfo {
        validate_cap<DaoT, PluginT>(storage_cap_type());
        DaoStorageCap<DaoT, PluginT>{}
    }

    public fun acquire_member_cap<DaoT: store, PluginT>(_witness: &PluginT): DaoMemberCap<DaoT, PluginT> acquires InstalledPluginInfo {
        validate_cap<DaoT, PluginT>(member_cap_type());
        DaoMemberCap<DaoT, PluginT>{}
    }

    public fun acquire_proposal_cap<DaoT: store, PluginT>(_witness: &PluginT): DaoProposalCap<DaoT, PluginT> acquires InstalledPluginInfo {
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

    public fun choice_no_with_veto(): VotingChoice { VotingChoice{ choice: VOTING_CHOICE_NO_WITH_VETO } }

    public fun choice_abstain(): VotingChoice { VotingChoice{ choice: VOTING_CHOICE_ABSTAIN } }

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
        votes: vector<u128>,
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
    struct ProposalActions<ActionT> has key {
        actions: vector<ProposalAction<ActionT>>,
    }

    /// User vote info.
    struct Vote has store {
        /// proposal id.
        proposal_id: u64,
        /// vote weight
        weight: u128,
        /// vote choise
        choice: u8,
    }

    /// Every voter keep a vector Vote for per Dao
    struct MyVotes<phantom DaoT> has key {
        votes: vector<Vote>,
    }

    public fun create_proposal<DaoT: store, PluginT, ActionT: store>(
        _cap: &DaoProposalCap<DaoT, PluginT>,
        sender: &signer,
        action: ActionT,
        action_delay: u64,
    ): u64 acquires GlobalProposals, DaoAccountCapHolder, ProposalActions {
        if (action_delay == 0) {
            action_delay = min_action_delay<DaoT>();
        } else {
            //TODO error code
            assert!(action_delay >= min_action_delay<DaoT>(), Errors::invalid_argument(1));
        };
        //TODO load from config
        let min_proposal_deposit = min_proposal_deposit<DaoT>();
        let deposit = Account::withdraw<STC>(sender, min_proposal_deposit);

        let proposal_id = generate_next_proposal_id<DaoT>();
        let proposer = Signer::address_of(sender);
        let start_time = Timestamp::now_milliseconds() + voting_delay<DaoT>();
        let quorum_votes = quorum_votes<DaoT>();

        let (block_number, state_root) = block_number_and_state_root();

        //four choise, so init four length vector.
        let votes = Vector::singleton(0u128);
        Vector::push_back(&mut votes, 0u128);
        Vector::push_back(&mut votes, 0u128);
        Vector::push_back(&mut votes, 0u128);

        let proposal = Proposal{
            id: proposal_id,
            proposer,
            start_time,
            end_time: start_time + voting_period<DaoT>(),
            votes,
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

        let dao_signer = dao_signer<DaoT>();
        let dao_address = dao_address<DaoT>();

        let actions = Vector::singleton(proposal_action);
        //TODO check ProposalActions is exists
        if (exists<ProposalActions<ActionT>>(dao_address)) {
            //TODO add limit to max action before support Table.
            let current_actions = borrow_global_mut<ProposalActions<ActionT>>(dao_address);
            Vector::append(&mut current_actions.actions, actions);
        }else {
            move_to(&dao_signer, ProposalActions<ActionT>{
                actions,
            });
        };
        let global_proposals = borrow_global_mut<GlobalProposals>(dao_address);
        //TODO add limit to max proposal before support Table
        Vector::push_back(&mut global_proposals.proposals, proposal);
        //TODO trigger event
        proposal_id
    }

    fun block_number_and_state_root(): (u64, vector<u8>) {
        //TODO how to get state root
        (0, Vector::empty())
    }

    fun voting_period<DaoT>(): u64 {
        //TODO
        0
    }

    fun voting_delay<DaoT>(): u64 {
        //TODO
        0
    }

    fun min_action_delay<DaoT>(): u64 {
        //TODO
        0
    }

    fun generate_next_proposal_id<DaoT>(): u64 {
        //TODO
        0
    }

    fun quorum_votes<DaoT>(): u128 {
        //TODO we need get the 
        0
    }

    fun min_proposal_deposit<DaoT>(): u128 {
        0
    }

    public fun cast_vote<DaoT: copy + drop + store>(
        sender: &signer,
        proposal_id: u64,
        sbt_proof: vector<u8>,
        choice: VotingChoice,
    )  acquires GlobalProposals, MyVotes {
        let dao_address = dao_address<DaoT>();
        let proposals = borrow_global_mut<GlobalProposals>(dao_address);
        let proposal = borrow_proposal_mut(proposals, proposal_id);

            {
                let state = proposal_state(proposal);
                // only when proposal is active, use can cast vote.
                //TODO
                assert!(state == ACTIVE, Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID));
            };

        let sender_addr = Signer::address_of(sender);

        // TODO is allowed just use part of weight?
        let weight = VoteUtil::get_vote_weight_from_sbt_snapshot(sender_addr, *&proposal.state_root, sbt_proof);

        //TODO errorcode
        assert!(!has_voted<DaoT>(sender_addr, proposal_id), 0);

        let vote = Vote{
            proposal_id,
            weight,
            choice: choice.choice,
        };

        do_cast_vote(proposal, &mut vote);

        if (exists<MyVotes<DaoT>>(sender_addr)) {
            let my_votes = borrow_global_mut<MyVotes<DaoT>>(sender_addr);
            Vector::push_back(&mut my_votes.votes, vote);
            //assert!(my_vote.id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
            //TODO
            //assert!(vote.choice == choice, Errors::invalid_state(ERR_VOTE_STATE_MISMATCH));
        } else {
            move_to(sender, MyVotes<DaoT>{
                votes: Vector::singleton(vote),
            });
        };
    }

    /// Just change vote choice, the weight do not change.
    public fun change_vote<DaoT>(
        _sender: &signer,
        _proposal_id: u64,
        _choice: VotingChoice,
    ) {
        //TODO
    }

    public fun revoke_vote<DaoT>(
        _sender: &signer,
        _proposal_id: u64,
    ) {
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

    fun take_proposal_action<ActionT: store>(dao_address: address, proposal_id: u64): ActionT acquires ProposalActions, GlobalProposals {
        let actions = borrow_global_mut<ProposalActions<ActionT>>(dao_address);
        let index_opt = find_action(&actions.actions, proposal_id);
        //TODO error code.
        assert!(Option::is_some(&index_opt), 1);

        let global_proposals = borrow_global<GlobalProposals>(dao_address);
        let proposal = borrow_proposal(global_proposals, proposal_id);

        let index = Option::extract(&mut index_opt);
        let ProposalAction{ proposal_id: _, deposit, action } = Vector::remove(&mut actions.actions, index);
        //TODO check the proposal state and do deposit or burn.
        Account::deposit(proposal.proposer, deposit);
        action
    }

    fun find_action<ActionT: store>(actions: &vector<ProposalAction<ActionT>>, proposal_id: u64): Option<u64> {
        let i = 0;
        let len = Vector::length(actions);
        while (i < len) {
            let action = Vector::borrow(actions, i);
            if (action.proposal_id == proposal_id) {
                return Option::some(i)
            };
            i = i + 1;
        };
        Option::none<u64>()
    }

    fun has_voted<DaoT>(sender: address, proposal_id: u64): bool acquires MyVotes {
        if (exists<MyVotes<DaoT>>(sender)) {
            let my_votes = borrow_global<MyVotes<DaoT>>(sender);
            let vote = get_vote<DaoT>(my_votes, proposal_id);
            Option::is_some(vote)
        }else {
            false
        }
    }

    fun do_cast_vote(proposal: &mut Proposal, vote: &mut Vote) {
        let weight = *Vector::borrow(&proposal.votes, (vote.choice as u64));
        let total_weight = Vector::borrow_mut(&mut proposal.votes, (vote.choice as u64));
        *total_weight = weight + vote.weight;
    }

    fun get_vote<DaoT>(_my_votes: &MyVotes<DaoT>, _proposal_id: u64): &Option<Vote> {
        //TODO
        abort 0
    }

    public fun proposal_state(_proposal: &Proposal): u8 {
        //TOOD
        0
    }

    fun borrow_proposal_mut(_proposals: &mut GlobalProposals, _proposal_id: u64): &mut Proposal {
        //TODO
        abort 0
    }

    fun borrow_proposal(proposals: &GlobalProposals, proposal_id: u64): &Proposal {
        let i = 0;
        let len = Vector::length(&proposals.proposals);
        while (i < len) {
            let proposal = Vector::borrow(&proposals.proposals, i);
            if (proposal.id == proposal_id) {
                return proposal
            };
            i = i + 1;
        };
        //TODO error code 
        abort 0
    }

    ///Return a copy of Proposal
    public fun proposal<DaoT>(proposal_id: u64): Proposal acquires GlobalProposals {
        let dao_address = dao_address<DaoT>();
        let global_proposals = borrow_global<GlobalProposals>(dao_address);
        *borrow_proposal(global_proposals, proposal_id)
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

    fun dao_signer<DaoT>(): signer acquires DaoAccountCapHolder {
        let cap = &borrow_global<DaoAccountCapHolder>(dao_address<DaoT>()).cap;
        DaoAccount::dao_signer(cap)
    }

    fun dao_address<DaoT>(): address {
        DaoRegistry::dao_address<DaoT>()
    }
}