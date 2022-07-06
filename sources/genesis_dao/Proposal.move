address StarcoinFramework {
module Proposal {
    use StarcoinFramework::Token::{Token};
    use StarcoinFramework::Signer;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Option;
    use StarcoinFramework::Event;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Account;
    use StarcoinFramework::STC::{STC};
    use StarcoinFramework::Option::Option;

    use StarcoinFramework::DaoConfig;
    use StarcoinFramework::DaoRegistry;
    use StarcoinFramework::StarcoinVerifier::{Self, StateProof};
    use StarcoinFramework::VoteStrategy;
    use StarcoinFramework::GenesisDao::{DaoProposalCap};



    struct ProposalCapability has key {
        proposal_id: u64,
    }

    /// Proposal data struct.
    /// review: it is safe to has `copy` and `drop`?
    ///  review struct Proposal<phantom DaoT: store> has store, copy, drop {
    struct Proposal has store, copy, drop {
        /// id of the proposal
        id: u64,
        /// creator of the proposal
        proposer: address,
        /// when voting begins.
        start_time: u64,
        /// when voting ends.
        end_time: u64,
        /// count of voters who `agree|against|no_with_veto|abstain` with the proposal
        votes: vector<u128>,
        /// executable after this time.
        eta: u64,
        /// after how long, the agreed proposal can be executed.
        action_delay: u64,
        /// how many votes to reach to make the proposal pass.
        quorum_votes: u128,
        /// proposal action.
//        action: Option::Option<Action>,

        /// count of voters who're abstain the proposal, for extend
        for_votes: u128,
        against_votes: u128,
        abstain_votes: u128,
        /// total weight of voters who agree with the proposal, for extend
        total_for_votes_weight: u128,
        /// total weight of voters who're against the proposal, for extend
        total_against_votes_weight: u128,
        /// total weight of voters who're abstain the proposal, for extend
        total_abstain_votes_weight: u128,
        /// dao id, maybe to erasure generic, for extend
        dao_id: u64,
        /// proposal category
        category: u8,
        /// voting system, default single choice voting system, for extend
        voting_system: u8,
        /// voting strategy //TODO strategy should be an intance of strategy template
        strategy: u8,
        /// the block number when submit proposal
        block_number: u64,
        /// the state root of the block which has the block_number
        state_root: vector<u8>
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
    struct ProposalActions<ActionT: store> has key{
        actions: vector<ProposalAction<ActionT>>,
    }

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

    /// Proposal state
    const PENDING: u8 = 1;
    const ACTIVE: u8 = 2;
    const DEFEATED: u8 = 3;
    const AGREED: u8 = 4;
    const QUEUED: u8 = 5;
    const EXECUTABLE: u8 = 6;
    const EXTRACTED: u8 = 7;

    struct ProposalState has copy, drop, store {state: u8}

    /// voting choice: 1:agree, 2:against, 3: no_with_veto, 4:abstain
    const VOTING_CHOICE_AGREE: u8 = 1;
    const VOTING_CHOICE_AGAINST: u8 = 2;
    // Review: How to prevent spam, cosmos provide a NO_WITH_VETO option, and the proposer need deposit some Token when create proposal.
    // this choice from  https://docs.cosmos.network/master/modules/gov/01_concepts.html
    const VOTING_CHOICE_NO_WITH_VETO: u8 = 3;
    const VOTING_CHOICE_ABSTAIN: u8 = 4;

    struct VotingChoice has copy,drop,store{
        choice: u8,
    }

    public fun choice_agree(): VotingChoice{VotingChoice{choice: VOTING_CHOICE_AGREE}}
    public fun choice_against(): VotingChoice{VotingChoice{choice: VOTING_CHOICE_AGAINST}}
    public fun choice_no_with_veto(): VotingChoice{VotingChoice{choice: VOTING_CHOICE_NO_WITH_VETO}}
    public fun choice_abstain(): VotingChoice{VotingChoice{choice: VOTING_CHOICE_ABSTAIN}}


    //    Stages of a Proposal#
    //    1. Submit Proposal
    //
    //    Anyone, even non-members, can submit proposals to the DAO.
    //
    //    2. Sponsor Proposal
    //
    //    After submitting a proposal, it will enter the Unsponsored Proposals section. This means someone with shares (which could be you) must Champion the proposal in order for it to be moved to voting.
    //
    //    Note: You can sponsor your own Proposal, but it is recommended that you have another member sponsor it so they can make sure you have filled out the proposal with the correct information and you get the result you intended for.
    //
    //    Only members can 'Sponsor' the proposal, sending it to the Queue
    //
    //    3. In Queue
    //
    //    Once the proposal has been sponsored it will enter the Queue. The queue ensures proposals are funneled to voting in an orderly fashion. One proposal will go from the queue to the Voting Period in a time-frame specified by the summoners of your DAO.
    //
    //    4. Voting Period
    //
    //    Once in the Voting Period, members can now vote on the proposal. Every proposal has an 'x' amount of time in the voting period where it must receive more Yes than No votes to pass.
    //
    //    5. Grace Period
    //
    //    Voting is over, and the Proposal is set to pass or fail depending on the votes cast during Voting. Members who voted No, and have no other pending Yes votes, can ragequit during this period
    //
    //    6. Ready for Processing
    //
    //    Next, The proposal is sent to Processing in which the vote is time stamped on-chain.
    //
    //    7. Completed
    //
    //    After being processed, the proposal is marked as Completed, and all shares, funds or outcomes are executed as specified in the proposal. All outcomes of a proposal that affect you can be viewed by clicking your Address (top right) and selecting View Member Profile.


    // Set also needs to use generics to distinguish
//    struct DaoProposalSet {
//        proposal_set: HashSet<u64, DaoProposal>
//    }
//
    // the cap assigned to the creator during initialization
//    struct RootCapability has key{}
//
//    struct InstallPluginCapability has key{
//    }
//
//    struct ProposalPluginInfo<phantom PluginConfig:store> has key{
//        installer: address,
          // Identify different permissions for plugins by different locations in BitSet
//        capabilities: BitSet,
//        config: Option<PluginConfig,
//    }


    /// User vote info.
    ///  review  struct Vote<phantom DaoT: store> has key {
    struct Vote has store {
        /// vote for the proposal under the `proposer`.
        proposer: address,
        /// proposal id.
        proposal_id: u64,
        /// voting amount
        vote_amount: u128,
        /// voting weight
        vote_weight: u128,
        /// 1:agree or 2:against or 3:abstain
        choice: u8,
    }

    /// Every voter keep a vector Vote for per Dao
    struct MyVotes<phantom DaoT> has key {
        votes: vector<Vote>,
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
        /// creator of the proposal.
        proposer: address,
        /// 1:agree or 2:against or 3:abstain
        choice: u8,
        /// latest vote count of the voter.
        vote_amount: u128,
        vote_weight: u128,
    }

    struct ProposalEvent<phantom DaoT: store> has key, store {
        /// proposal creating event.
        proposal_create_event: Event::EventHandle<ProposalCreatedEvent>,
        /// voting event.
        vote_changed_event: Event::EventHandle<VoteChangedEvent>,
    }


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
    const ERR_STATE_PROOF_VERIFY_INVALID: u64 = 1411;


    /// Initialize proposal
    /// only call by dao singer when daoT register
    public fun initialize_proposal<DaoT: copy + drop + store>(signer: &signer) {
        let dao_address = DaoRegistry::dao_address<DaoT>();
        assert!(Signer::address_of(signer) == dao_address, Errors::requires_address(ERR_NOT_AUTHORIZED));

        let proposal_event = ProposalEvent<DaoT>  {
            proposal_create_event: Event::new_event_handle<ProposalCreatedEvent>(signer),
            vote_changed_event: Event::new_event_handle<VoteChangedEvent>(signer),
        };
        move_to(signer, proposal_event);
    }

    /// propose a proposal.
    /// `dao_id`: the dao id to which the proposal belongs
    /// `category`: the actual proposal category
    /// `voting_system`: the actual voting system, default single choice voting system
    /// `strategy`: the actual voting strategy
    /// `action`: the actual action to execute.
    /// `action_delay`: the delay to execute after the proposal is agreed
    public fun create_proposal<DaoT: copy + drop + store, PluginT, ActionT: copy + drop + store>(
        _cap: &DaoProposalCap<DaoT, PluginT>,
        signer: &signer,
        dao_id: u64,
        category: u8,
//        voting_system: u8,
        strategy: u8, //TODO todo implementation
        action: ActionT,
        action_delay: u64,
    ) :u64  acquires  GlobalProposals, ProposalActions, ProposalEvent {
        if (action_delay == 0) {
            action_delay = DaoConfig::min_action_delay<DaoT>();
        } else {
            assert!(action_delay >= DaoConfig::min_action_delay<DaoT>(), Errors::invalid_argument(ERR_ACTION_DELAY_TOO_SMALL));
        };
        //TODO load from config
        let min_proposal_deposit = DaoConfig::min_proposal_deposit<DaoT>();
        let deposit = Account::withdraw<STC>(signer, min_proposal_deposit);


        let proposal_id = DaoConfig::generate_next_proposal_id<DaoT>();
        let proposer = Signer::address_of(signer);
        let start_time = Timestamp::now_milliseconds() + DaoConfig::voting_delay<DaoT>();
        //TODO calculate quorum by strategy
        let quorum_votes = DaoConfig::quorum_votes<DaoT>();
        let voting_period = DaoConfig::voting_period<DaoT>();
        
        let voting_system = get_default_voting_system();
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
//            action: Option::some(action),

            abstain_votes: 0,
            total_for_votes_weight: 0,
            total_against_votes_weight: 0,
            total_abstain_votes_weight : 0,
            dao_id,
            category,
            voting_system,
            // TODO strategy should be an intance of strategy template
            strategy,
            block_number,
            state_root,
        };
        let proposal_action = ProposalAction{
            proposal_id,
            deposit,
            action,
        };

        //TODO get dao_signer
//        let dao_signer = dao_signer<DaoT>();
//        let dao_address = dao_address<DaoT>();
//        let dao_signer = signer;
        let dao_address : address = @0x6bfb460477adf9dd0455d3de2fc7f211;

        let actions = Vector::singleton(proposal_action);
        //TODO check ProposalActions is exists
        if(exists<ProposalActions<ActionT>>(dao_address)){
            //TODO add limit to max action before support Table.
            let current_actions = borrow_global_mut<ProposalActions<ActionT>>(dao_address);
            Vector::append(&mut current_actions.actions, actions);
        }else{
            //TODO get dao_signer
            move_to(signer, ProposalActions<ActionT>{
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

//    /// TODO
//    public fun extract_strategy<Action>(id: u64) : Action {
//
//    }


    public fun new_state_proof_from_proof(account_proof_leaf: vector<vector<u8>>,
                                      account_proof_siblings: vector<vector<u8>>,
                                      account_state: vector<u8>,
                                      account_state_proof_leaf: vector<vector<u8>>,
                                      account_state_proof_siblings: vector<vector<u8>>): StateProof{
        let (account_proof_leaf_hash1, account_proof_leaf_hash2) = (Vector::empty(), Vector::empty());
        let (account_state_proof_leaf_hash1, account_state_proof_leaf_hash2) = (Vector::empty(), Vector::empty());

        if (Vector::length(&account_proof_leaf) >= 2){
            account_proof_leaf_hash1 = *Vector::borrow(&account_proof_leaf, 0);
            account_proof_leaf_hash2 = *Vector::borrow(&account_proof_leaf, 1);
        };
        if (Vector::length(&account_state_proof_leaf) >= 2){
            account_state_proof_leaf_hash1 = *Vector::borrow(&account_state_proof_leaf, 0);
            account_state_proof_leaf_hash2 = *Vector::borrow(&account_state_proof_leaf, 1);
        };
        let proof = StarcoinVerifier::new_state_proof(
            StarcoinVerifier::new_sparse_merkle_proof(
                account_proof_siblings,
                StarcoinVerifier::new_smt_node(
                    account_proof_leaf_hash1,
                    account_proof_leaf_hash2,
                ),
            ),
            account_state,
            StarcoinVerifier::new_sparse_merkle_proof(
                account_state_proof_siblings,
                StarcoinVerifier::new_smt_node(
                    account_state_proof_leaf_hash1,
                    account_state_proof_leaf_hash2,
                ),
            ),
        );
        proof
    }

    /// votes for a proposal.
    /// User can only vote once, then the stake is locked,
    /// The voting power depends on the strategy of the proposal configuration and the user's token amount at the time of the snapshot
    public fun cast_vote<DaoT: store>(
        signer: &signer,
        proposer_address: address,
        proposal_id: u64,
//        stake: Token::Token<DaoT> ,
//        agree: bool,
//        vote_amount: u128,
        choice: u8,
        _cap: &ProposalCapability,

        account_proof_leaf: vector<vector<u8>>,
        account_proof_siblings: vector<vector<u8>>,
        account_state: vector<u8>,
        account_state_proof_leaf: vector<vector<u8>>,
        account_state_proof_siblings: vector<vector<u8>>,
        state: vector<u8>,
        state_root: vector<u8>,
        resource_struct_tag: vector<u8>,
    ) acquires GlobalProposals, MyVotes, ProposalEvent {
        let dao_address = DaoRegistry::dao_address<DaoT>();
        let proposals = borrow_global_mut<GlobalProposals>(dao_address);
        let proposal = borrow_proposal_mut(proposals, proposal_id);
        {
            let state = proposal_state<DaoT>(proposal);
            // only when proposal is active, use can cast vote.
            assert!(state == ACTIVE, Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID));
        };

        // verify snapshot state proof
        let user_address = Signer::address_of(signer);
        let state_proof = new_state_proof_from_proof(account_proof_leaf, account_proof_siblings, account_state, account_state_proof_leaf, account_state_proof_siblings);
        let verify = StarcoinVerifier::verify_state_proof(&state_proof, &state_root, user_address, &resource_struct_tag, &state);
        assert!(verify, Errors::invalid_state(ERR_STATE_PROOF_VERIFY_INVALID));
        //TODO verify state_proof according to proposal snapshot blcok number and state root

        //TODO decode token value from account_state
        let vote_amount = VoteStrategy::get_voting_power<DaoT>(user_address, &state_root, &state);
        let vote_weight = vote_amount;

        //TODO errorcode
        assert!(!has_voted<DaoT>(user_address, proposal_id), 0);

//        let vote_choice = VotingChoice {
//            choice
//        };
        let vote = Vote{
            proposer: proposer_address,
            proposal_id,
            vote_amount,
            vote_weight,
            choice,
        };

        do_cast_vote(proposal, &mut vote);

        if (exists<MyVotes<DaoT>>(user_address)) {
            let my_votes = borrow_global_mut<MyVotes<DaoT>>(user_address);
            Vector::push_back(&mut my_votes.votes, vote);
            //assert!(my_vote.id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
            //TODO
            //assert!(vote.choice == choice, Errors::invalid_state(ERR_VOTE_STATE_MISMATCH));
        } else {
            move_to(signer, MyVotes<DaoT>{
                votes: Vector::singleton(vote),
            });
        };

        // emit event
        let proposal_event = borrow_global_mut<ProposalEvent<DaoT> >(DaoRegistry::dao_address<DaoT>());
        Event::emit_event(&mut proposal_event.vote_changed_event,
            VoteChangedEvent {
                proposal_id,
                proposer: proposer_address,
                voter: user_address,
                choice,
                vote_amount,
                vote_weight: vote_amount,
            },
        );
    }

    fun do_cast_vote(proposal: &mut Proposal, vote: &mut Vote){
        //TODO verify user token proof via snapshot
        //        let stake_value = Token::value(&stake);
        //        Token::deposit(&mut vote.stake, stake);
        let weight = *Vector::borrow(&proposal.votes, (vote.choice as u64));
        let total_weight = Vector::borrow_mut(&mut proposal.votes, (vote.choice as u64));
        *total_weight = weight + vote.vote_weight;
    }

//    /// Let user change their vote during the voting time.
//    public fun change_vote<DaoT: copy + drop + store, ActionT: copy + drop + store>(
//        signer: &signer,
//        proposer_address: address,
//        proposal_id: u64,
//        agree: bool,
//    ) acquires Proposal, DaoGlobalInfo, Vote {
//        {
//            let state = proposal_state<DaoT, ActionT>(proposer_address, proposal_id);
//            // only when proposal is active, user can change vote.
//            assert!(state == ACTIVE, Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID));
//        };
//        let proposal = borrow_global_mut<Proposal<DaoT, ActionT>>(proposer_address);
//        assert!(proposal.id == proposal_id, Errors::invalid_argument(ERR_PROPOSAL_ID_MISMATCH));
//        let my_vote = borrow_global_mut<Vote<DaoT> >(Signer::address_of(signer));
//        {
//            assert!(my_vote.proposer == proposer_address, Errors::invalid_argument(ERR_PROPOSER_MISMATCH));
//            assert!(my_vote.proposal_id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
//        };
//
//        // flip the vote
//        if (my_vote.agree != agree) {
//            let total_voted = do_flip_vote(my_vote, proposal);
//            // emit event
//            let gov_info = borrow_global_mut<DaoGlobalInfo<DaoT> >(DaoRegistry::dao_address<DaoT>());
//            Event::emit_event(
//                &mut gov_info.vote_changed_event,
//                VoteChangedEvent {
//                    proposal_id,
//                    proposer: proposer_address,
//                    voter: Signer::address_of(signer),
//                    agree,
//                    vote: total_voted,
//                },
//            );
//        };
//    }

//    public fun revoke_vote<DaoT>(
//        _sender: &signer,
//        _proposal_id: u64,
//    ){
//        //TODO
//    }

    /// Revoke some voting powers from vote on `proposal_id` of `proposer_address`.
    public fun revoke_vote<DaoT: store>(
        _signer: &signer,
        _proposal_id: u64,
    )  {
//        {
//            let state = proposal_state<DaoT, ActionT>(proposer_address, proposal_id);
//            // only when proposal is active, user can revoke vote.
//            assert!(state == ACTIVE, Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID));
//        };
//        // get proposal
//        let proposal = borrow_global_mut<Proposal<DaoT, ActionT>>(proposer_address);
//
//        // get vote
//        let my_vote = move_from<Vote<DaoT> >(Signer::address_of(signer));
//        {
//            assert!(my_vote.proposer == proposer_address, Errors::invalid_argument(ERR_PROPOSER_MISMATCH));
//            assert!(my_vote.proposal_id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
//        };
//        // revoke vote on proposal
//        //let reverted_stake =do_revoke_vote(proposal, &mut my_vote, voting_power);
//        do_revoke_vote(proposal, &mut my_vote, voting_power);
//        // emit vote changed event
//        let gov_info = borrow_global_mut<ProposalEvent<DaoT> >(DaoRegistry::dao_address<DaoT>());
//        Event::emit_event(
//            &mut gov_info.vote_changed_event,
//            VoteChangedEvent {
//                proposal_id,
//                proposer: proposer_address,
//                voter: Signer::address_of(signer),
//                choice,
//                vote_amount,
//                vote_weight: vote_amount,
//            },
//        );
//
//        // if user has no stake, destroy his vote. resolve https://github.com/starcoinorg/starcoin/issues/2925.
//        if (my_vote.vote_amount == 0u128) {
//            let Vote {proposer: _, proposal_id: _, vote_amount: _, vote_weight:_, choice:_} = my_vote;
////            Token::destroy_zero(stake);
//        } else {
//            move_to(signer, my_vote);
//        };

//        reverted_stake
    }


    fun do_revoke_vote<DaoT: copy + drop + store, ActionT: copy + drop + store>(_proposal: &mut Proposal, _vote: &mut Vote , _to_revoke: u128) {
//        let reverted_stake = Token::withdraw(&mut vote.stake, to_revoke);
//        if (VOTING_CHOICE_AGREE == vote.choice) {
//            proposal.for_votes = proposal.for_votes - to_revoke;
//        } else {
//            proposal.against_votes = proposal.against_votes - to_revoke;
//        };
    }



//    /// queue agreed proposal to execute.
//    public(script) fun queue_proposal_action<DaoT: copy + drop + store, ActionT: copy + drop + store>(
//        proposer_address: address,
//        proposal_id: u64,
//    ) acquires Proposal {
//        // Only agreed proposal can be submitted.
//        assert!(
//            proposal_state<DaoT, ActionT>(proposer_address, proposal_id) == AGREED,
//            Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID)
//        );
//        let proposal = borrow_global_mut<Proposal<DaoT, ActionT>>(proposer_address);
//        proposal.eta = Timestamp::now_milliseconds() + proposal.action_delay;
//    }


//    /// extract proposal action to execute.
//    public fun extract_proposal_action<DaoT: copy + drop + store, ActionT: copy + drop + store>(
//        proposer_address: address,
//        proposal_id: u64,
//    ): ActionT acquires Proposal {
//        // Only executable proposal's action can be extracted.
//        assert!(
//            proposal_state<DaoT, ActionT>(proposer_address, proposal_id) == EXECUTABLE,
//            Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID),
//        );
//        let proposal = borrow_global_mut<Proposal<DaoT, ActionT>>(proposer_address);
//        let action: ActionT = Option::extract(&mut proposal.action);
//        action
//    }


//    /// check whether a proposal exists in `proposer_address` with id `proposal_id`.
//    public fun proposal_exists<DaoT: copy + drop + store, ActionT: copy + drop + store>(
//        proposer_address: address,
//        proposal_id: u64,
//    ): bool acquires Proposal {
//        if (exists<Proposal<DaoT, ActionT>>(proposer_address)) {
//            let proposal = borrow_global<Proposal<DaoT, ActionT>>(proposer_address);
//            return proposal.id == proposal_id
//        };
//        false
//    }

    /// Get the proposal state.
    public fun proposal_state<DaoT: store>(proposal: &Proposal): u8 {
//        let proposal = borrow_global<Proposal>(proposer_address);
//        assert!(proposal.id == proposal_id, Errors::invalid_argument(ERR_PROPOSAL_ID_MISMATCH));
//        let dao_address = DaoRegistry::dao_address<DaoT>();

        let current_time = Timestamp::now_milliseconds();
        do_proposal_state(proposal, current_time)
    }

    fun do_proposal_state(
        proposal: &Proposal,
        current_time: u64,
    ): u8 {
        if (current_time < proposal.start_time) {
            // Pending
            PENDING
        } else if (current_time <= proposal.end_time) {
            // Active
            ACTIVE
        } else if (proposal.for_votes <= proposal.against_votes ||
            proposal.for_votes < proposal.quorum_votes) {
            // Defeated
            DEFEATED
        } else if (proposal.eta == 0) {
            // Agreed.
            AGREED
        } else if (current_time < proposal.eta) {
            // Queued, waiting to execute
            QUEUED
            //TODO action status
//        } else if (Option::is_some(&proposal.action)) {
//            EXECUTABLE
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

    /// Get voter's vote info on proposal with `proposal_id` of `proposer_address`.
//    public fun vote_of<DaoT: copy + drop + store>(
//        voter: address,
//        proposer_address: address,
//        proposal_id: u64,
//    ): (u8, u128) acquires Vote {
//        let vote = borrow_global<Vote<DaoT> >(voter);
//        assert!(vote.proposer == proposer_address, Errors::requires_address(ERR_PROPOSER_MISMATCH));
//        assert!(vote.proposal_id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
//        (vote.choice, vote.vote_amount)
//    }

    /// Check whether voter has voted on proposal with `proposal_id` of `proposer_address`.
    public fun has_vote<DaoT: store>(
        voter: address,
        _proposer_address: address,
        proposal_id: u64,
    ): bool acquires MyVotes {
        if(exists<MyVotes<DaoT>>(voter)){
            let my_votes = borrow_global<MyVotes<DaoT>>(voter);
            let vote = get_vote<DaoT>(my_votes, proposal_id);
            Option::is_some(vote)
        }else{
            false
        }
    }


    /// Just change vote choice, the weight do not change.
    public fun change_vote<DaoT>(
        _sender: &signer,
        _proposal_id: u64,
        _choice: VotingChoice,
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
        let dao_address = DaoRegistry::dao_address<DaoT>();
        //TODO error code
        assert!(exists<ProposalActions<ActionT>>(dao_address), 0);

        take_proposal_action(dao_address, proposal_id)
    }

    fun take_proposal_action<ActionT: store>(dao_address: address, proposal_id: u64): ActionT acquires ProposalActions, GlobalProposals{
        let actions = borrow_global_mut<ProposalActions<ActionT>>(dao_address);
        let index_opt = find_action(&actions.actions, proposal_id);
        //TODO error code.
        assert!(Option::is_some(&index_opt), 1);

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

    fun has_voted<DaoT>(sender: address, proposal_id: u64): bool acquires MyVotes{
        if(exists<MyVotes<DaoT>>(sender)){
            let my_votes = borrow_global<MyVotes<DaoT>>(sender);
            let vote = get_vote<DaoT>(my_votes, proposal_id);
            Option::is_some(vote)
        }else{
            false
        }
    }

    fun get_vote<DaoT>(_my_votes: &MyVotes<DaoT>, _proposal_id: u64):&Option<Vote>{
        //TODO
        abort 0
    }

//    public fun proposal_state(_proposal: &Proposal):u8 {
//        //TOOD
//        0
//    }

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
        //TODO error code
        abort 0
    }

    ///Return a copy of Proposal
    public fun proposal<DaoT>(proposal_id: u64): Proposal acquires GlobalProposals{
        let dao_address = DaoRegistry::dao_address<DaoT>();
        let global_proposals = borrow_global<GlobalProposals>(dao_address);
        *borrow_proposal(global_proposals, proposal_id)
    }

}
}
