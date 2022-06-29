address StarcoinFramework {
module XProposal {
    use StarcoinFramework::Token;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Option;
    use StarcoinFramework::Event;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Block;
    use StarcoinFramework::Vector;

    use StarcoinFramework::XDaoConfig;
    use StarcoinFramework::DaoRegistry;
    use StarcoinFramework::StarcoinVerifier::{Self, StateProof};
    use StarcoinFramework::VoteStrategy;


    struct ProposalCapability has key {
        proposal_id: u64,
    }

    /// Proposal data struct.
    struct Proposal<phantom DaoT: store, Action: store> has key {
        /// id of the proposal
        id: u64,
        /// creator of the proposal
        proposer: address,
        /// when voting begins.
        start_time: u64,
        /// when voting ends.
        end_time: u64,
        /// count of voters who agree with the proposal
        for_votes: u128,
        /// count of voters who're against the proposal
        against_votes: u128,
        /// executable after this time.
        eta: u64,
        /// after how long, the agreed proposal can be executed.
        action_delay: u64,
        /// how many votes to reach to make the proposal pass.
        quorum_votes: u128,
        /// proposal action.
        action: Option::Option<Action>,

        /// count of voters who're abstain the proposal, for extend
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
        /// snapshot block number
        block_number: u64,
        /// snapshot block root hash
        root_hash: vector<u8>
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

    /// voting choice: 1:agree, 2:against, 3:abstain
    const VOTING_CHOICE_AGREE: u8 = 1;
    const VOTING_CHOICE_AGAINST: u8 = 2;
    const VOTING_CHOICE_ABSTAIN: u8 = 3;

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
    struct Vote<phantom DaoT: store> has key {
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
    public fun create_proposal<DaoT: copy + drop + store, ActionT: copy + drop + store>(
        signer: &signer,
        dao_id: u64,
        category: u8,
//        voting_system: u8,
        strategy: u8, //TODO todo implementation
        action: ActionT,
        action_delay: u64,
    ) acquires  ProposalEvent {
        if (action_delay == 0) {
            action_delay = XDaoConfig::min_action_delay<DaoT>();
        } else {
            assert!(action_delay >= XDaoConfig::min_action_delay<DaoT>(), Errors::invalid_argument(ERR_ACTION_DELAY_TOO_SMALL));
        };
        let proposal_id = XDaoConfig::generate_next_proposal_id<DaoT>();
        let proposer = Signer::address_of(signer);
        let start_time = Timestamp::now_milliseconds() + XDaoConfig::voting_delay<DaoT>();
        //TODO calculate quorum by strategy
        let quorum_votes = XDaoConfig::quorum_votes<DaoT>();
        let voting_period = XDaoConfig::voting_period<DaoT>();
        
        let block_number = Block::get_current_block_number() - 1;
        let root_hash = Block::get_parent_hash();
        let voting_system = get_default_voting_system();

        let proposal = Proposal<DaoT, ActionT> {
            id: proposal_id,
            proposer,
            start_time,
            end_time: start_time + voting_period,
            for_votes: 0,
            against_votes: 0,
            eta: 0,
            action_delay,
            quorum_votes,
            action: Option::some(action),

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
            root_hash,
        };
        move_to(signer, proposal);
        // emit event
        let proposal_event = borrow_global_mut<ProposalEvent<DaoT>>(DaoRegistry::dao_address<DaoT>());
        Event::emit_event(&mut proposal_event.proposal_create_event,
            ProposalCreatedEvent { proposal_id, proposer },
        );
    }

    spec propose {
        use StarcoinFramework::CoreAddresses;
        pragma verify = false;
        let proposer = Signer::address_of(signer);

        include GenerateNextProposalIdSchema<DaoT> ;

        pragma addition_overflow_unchecked = true; // start_time calculation

        include AbortIfDaoConfigNotExist<DaoT> ;
        include AbortIfDaoInfoNotExist<DaoT> ;
        aborts_if !exists<Timestamp::CurrentTimeMilliseconds>(CoreAddresses::GENESIS_ADDRESS());

        aborts_if action_delay > 0 && action_delay < spec_dao_config<DaoT>().min_action_delay;
        include CheckQuorumVotes<DaoT> ;

        let sender = Signer::address_of(signer);
        aborts_if exists<Proposal<DaoT, ActionT>>(sender);
        modifies global<DaoGlobalInfo<DaoT> >(Token::SPEC_TOKEN_TEST_ADDRESS());

        ensures exists<Proposal<DaoT, ActionT>>(sender);
    }

    /// voting_system default single choice voting system
    fun get_default_voting_system(): u8 {
        VOTING_SYSTEM_SINGLE_CHOICE_VOTING
    }

//    /// TODO
//    public fun extract_strategy<Action>(id: u64) : Action {
//
//    }


//    public fun cast_vote(
//        signer: &signer,
//        proposer_broker: address,
//        id: u64,
//        amount: u128,
//        choice: u8,
//        cap: &ProposalCapability
//    ) {
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
    public fun cast_vote<DaoT: copy + drop + store, ActionT: copy + drop + store>(
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
    ) acquires Proposal, ProposalEvent, Vote {
        {
            let state = proposal_state<DaoT, ActionT>(proposer_address, proposal_id);
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
        let _vote_weight = vote_amount;

        let proposal = borrow_global_mut<Proposal<DaoT, ActionT>>(proposer_address);
        assert!(proposal.id == proposal_id, Errors::invalid_argument(ERR_PROPOSAL_ID_MISMATCH));
        let sender = Signer::address_of(signer);
        //TODO calculate vote weight via strategy
        let _total_voted = if (exists<Vote<DaoT> >(sender)) {
            let my_vote = borrow_global_mut<Vote<DaoT> >(sender);
            assert!(my_vote.proposal_id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
            assert!(my_vote.choice == VOTING_CHOICE_AGREE, Errors::invalid_state(ERR_VOTE_STATE_MISMATCH));

            do_cast_vote(proposal, my_vote);
            vote_amount
//            Token::value(&my_vote.stake)
        } else {
            let my_vote = Vote<DaoT>  {
                proposer: proposer_address,
                proposal_id,
                vote_amount,
                vote_weight: vote_amount,
                choice,
            };
            do_cast_vote(proposal, &mut my_vote);
//            let total_voted = Token::value(&my_vote.stake);
            move_to(signer, my_vote);
            vote_amount
        };

        // emit event
        let proposal_event = borrow_global_mut<ProposalEvent<DaoT> >(DaoRegistry::dao_address<DaoT>());
        Event::emit_event(&mut proposal_event.vote_changed_event,
            VoteChangedEvent {
                proposal_id,
                proposer: proposer_address,
                voter: sender,
                choice,
                vote_amount,
                vote_weight: vote_amount,
            },
        );
    }

    spec schema CheckVoteOnCast<DaoT, ActionT> {
        proposal_id: u64;
        agree: bool;
        voter: address;
        stake_value: u128;
        let vote = global<Vote<DaoT> >(voter);
        aborts_if vote.proposal_id != proposal_id;
        aborts_if vote.agree != agree;
        aborts_if vote.stake.value + stake_value > MAX_U128;
    }

    spec cast_vote {
        pragma addition_overflow_unchecked = true;

        include AbortIfDaoInfoNotExist<DaoT> ;

        let expected_states = vec(ACTIVE);
        include CheckProposalStates<DaoT, ActionT> {expected_states};
        let sender = Signer::address_of(signer);
        let vote_exists = exists<Vote<DaoT> >(sender);
        include vote_exists ==> CheckVoteOnCast<DaoT, ActionT> {
            voter: sender,
            proposal_id: proposal_id,
            agree: agree,
            stake_value: stake.value,
        };

        modifies global<Proposal<DaoT, ActionT>>(proposer_address);
        ensures !vote_exists ==> global<Vote<DaoT> >(sender).stake.value == stake.value;
    }

    fun do_cast_vote<DaoT: copy + drop + store, ActionT: copy + drop + store>(proposal: &mut Proposal<DaoT, ActionT>, vote: &mut Vote<DaoT>) {
        //TODO verify user token proof via snapshot
//        let stake_value = Token::value(&stake);
//        Token::deposit(&mut vote.stake, stake);

        if (VOTING_CHOICE_AGREE == vote.choice) {
            proposal.for_votes = proposal.for_votes + vote.vote_amount;
        } else if (VOTING_CHOICE_AGAINST == vote.choice) {
            proposal.against_votes = proposal.against_votes + vote.vote_amount;
        } else {
            proposal.abstain_votes = proposal.abstain_votes + vote.vote_amount;
        };
    }

    spec do_cast_vote {
        pragma addition_overflow_unchecked = true;
        aborts_if vote.stake.value + stake.value > MAX_U128;
        ensures vote.stake.value == old(vote).stake.value + stake.value;
        ensures vote.agree ==> old(proposal).for_votes + stake.value == proposal.for_votes;
        ensures vote.agree ==> old(proposal).against_votes == proposal.against_votes;
        ensures !vote.agree ==> old(proposal).against_votes + stake.value == proposal.against_votes;
        ensures !vote.agree ==> old(proposal).for_votes == proposal.for_votes;
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
    spec schema CheckVoteOnProposal<DaoT>  {
        vote: Vote<DaoT> ;
        proposer_address: address;
        proposal_id: u64;

        aborts_if vote.proposal_id != proposal_id;
        aborts_if vote.proposer != proposer_address;
    }
//    spec schema CheckChangeVote<DaoT, ActionT> {
//        vote: Vote<DaoT> ;
//        proposer_address: address;
//        let proposal = global<Proposal<DaoT, ActionT>>(proposer_address);
//        include AbortIfDaoInfoNotExist<DaoT> ;
//        include CheckFlipVote<DaoT, ActionT> {my_vote: vote, proposal};
//    }
//    spec change_vote {
//        pragma verify = false;
//        let expected_states = vec(ACTIVE);
//        include CheckProposalStates<DaoT, ActionT>{expected_states};
//
//        let sender = Signer::address_of(signer);
//        aborts_if !exists<Vote<DaoT> >(sender);
//        let vote = global<Vote<DaoT> >(sender);
//        include CheckVoteOnProposal<DaoT> {vote, proposer_address, proposal_id};
//        include vote.agree != agree ==> CheckChangeVote<DaoT, ActionT>{vote, proposer_address};
//
//        ensures vote.agree != agree ==> vote.agree == agree;
//    }

//    fun do_flip_vote<DaoT: copy + drop + store, ActionT: copy + drop + store>(my_vote: &mut Vote<DaoT> , proposal: &mut Proposal<DaoT, ActionT>): u128 {
//        my_vote.agree = !my_vote.agree;
//        let total_voted = Token::value(&my_vote.stake);
//        if (my_vote.agree) {
//            proposal.for_votes = proposal.for_votes + total_voted;
//            proposal.against_votes = proposal.against_votes - total_voted;
//        } else {
//            proposal.for_votes = proposal.for_votes - total_voted;
//            proposal.against_votes = proposal.against_votes + total_voted;
//        };
//        total_voted
//    }
//    spec schema CheckFlipVote<DaoT, ActionT> {
//        my_vote: Vote<DaoT> ;
//        proposal: Proposal<DaoT, ActionT>;
//        aborts_if my_vote.agree && proposal.for_votes < my_vote.stake.value;
//        aborts_if my_vote.agree && proposal.against_votes + my_vote.stake.value > MAX_U128;
//        aborts_if !my_vote.agree && proposal.against_votes < my_vote.stake.value;
//        aborts_if !my_vote.agree && proposal.for_votes + my_vote.stake.value > MAX_U128;
//    }
//
//    spec do_flip_vote {
//        include CheckFlipVote<DaoT, ActionT>;
//        ensures my_vote.agree == !old(my_vote).agree;
//    }

    /// Revoke some voting powers from vote on `proposal_id` of `proposer_address`.
    public fun revoke_vote<DaoT: copy + drop + store, ActionT: copy + drop + store>(
        signer: &signer,
        proposer_address: address,
        proposal_id: u64,
        voting_power: u128,
        vote_amount: u128,
        choice: u8,
        _cap: &ProposalCapability
    ) acquires Proposal, Vote, ProposalEvent {
        {
            let state = proposal_state<DaoT, ActionT>(proposer_address, proposal_id);
            // only when proposal is active, user can revoke vote.
            assert!(state == ACTIVE, Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID));
        };
        // get proposal
        let proposal = borrow_global_mut<Proposal<DaoT, ActionT>>(proposer_address);

        // get vote
        let my_vote = move_from<Vote<DaoT> >(Signer::address_of(signer));
        {
            assert!(my_vote.proposer == proposer_address, Errors::invalid_argument(ERR_PROPOSER_MISMATCH));
            assert!(my_vote.proposal_id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
        };
        // revoke vote on proposal
        //let reverted_stake =do_revoke_vote(proposal, &mut my_vote, voting_power);
        do_revoke_vote(proposal, &mut my_vote, voting_power);
        // emit vote changed event
        let gov_info = borrow_global_mut<ProposalEvent<DaoT> >(DaoRegistry::dao_address<DaoT>());
        Event::emit_event(
            &mut gov_info.vote_changed_event,
            VoteChangedEvent {
                proposal_id,
                proposer: proposer_address,
                voter: Signer::address_of(signer),
                choice,
                vote_amount,
                vote_weight: vote_amount,
            },
        );

        // if user has no stake, destroy his vote. resolve https://github.com/starcoinorg/starcoin/issues/2925.
        if (my_vote.vote_amount == 0u128) {
            let Vote {proposer: _, proposal_id: _, vote_amount: _, vote_weight:_, choice:_} = my_vote;
//            Token::destroy_zero(stake);
        } else {
            move_to(signer, my_vote);
        };

//        reverted_stake
    }

    spec revoke_vote {
        pragma verify = false;
        include AbortIfDaoInfoNotExist<DaoT> ;
        let expected_states = vec(ACTIVE);
        include CheckProposalStates<DaoT, ActionT> {expected_states};
        let sender = Signer::address_of(signer);

        aborts_if !exists<Vote<DaoT> >(sender);
        let vote = global<Vote<DaoT> >(sender);
        include CheckVoteOnProposal<DaoT>  {vote, proposer_address, proposal_id};
        include CheckRevokeVote<DaoT, ActionT> {
            vote,
            proposal: global<Proposal<DaoT, ActionT>>(proposer_address),
            to_revoke: voting_power,
        };

        modifies global<Vote<DaoT> >(sender);
        modifies global<Proposal<DaoT, ActionT>>(proposer_address);
        modifies global<DaoGlobalInfo<DaoT> >(Token::SPEC_TOKEN_TEST_ADDRESS());

        ensures global<Vote<DaoT> >(sender).stake.value + result.value == old(global<Vote<DaoT> >(sender)).stake.value;
        ensures result.value == voting_power;
    }

    fun do_revoke_vote<DaoT: copy + drop + store, ActionT: copy + drop + store>(proposal: &mut Proposal<DaoT, ActionT>, vote: &mut Vote<DaoT> , to_revoke: u128) {
        spec {
            assume vote.stake.value >= to_revoke;
        };
//        let reverted_stake = Token::withdraw(&mut vote.stake, to_revoke);
        if (VOTING_CHOICE_AGREE == vote.choice) {
            proposal.for_votes = proposal.for_votes - to_revoke;
        } else {
            proposal.against_votes = proposal.against_votes - to_revoke;
        };
//        spec {
//            assert Token::value(reverted_stake) == to_revoke;
//        };
//        reverted_stake
    }
    spec schema CheckRevokeVote<DaoT, ActionT> {
        vote: Vote<DaoT> ;
        proposal: Proposal<DaoT, ActionT>;
        to_revoke: u128;
        aborts_if vote.stake.value < to_revoke;
        aborts_if vote.agree && proposal.for_votes < to_revoke;
        aborts_if !vote.agree && proposal.against_votes < to_revoke;
    }

    spec do_revoke_vote {
        include CheckRevokeVote<DaoT, ActionT>;
        ensures vote.agree ==> old(proposal).for_votes == proposal.for_votes + to_revoke;
        ensures !vote.agree ==> old(proposal).against_votes == proposal.against_votes + to_revoke;
        ensures result.value == to_revoke;
    }

//    /// Retrieve back my staked token voted for a proposal.
//    public fun unstake_votes<DaoT: copy + drop + store, ActionT: copy + drop + store>(
//        signer: &signer,
//        proposer_address: address,
//        proposal_id: u64,
//    ): Token::Token<DaoT>  acquires Proposal, Vote {
//        // only check state when proposal exists.
//        // because proposal can be destroyed after it ends in DEFEATED or EXTRACTED state.
//        if (proposal_exists<DaoT, ActionT>(proposer_address, proposal_id)) {
//            let state = proposal_state<DaoT, ActionT>(proposer_address, proposal_id);
//            // Only after vote period end, user can unstake his votes.
//            assert!(state > ACTIVE, Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID));
//        };
//        let Vote { proposer, id, stake, agree: _ } = move_from<Vote<DaoT> >(
//            Signer::address_of(signer),
//        );
//        // these checks are still required.
//        assert!(proposer == proposer_address, Errors::requires_address(ERR_PROPOSER_MISMATCH));
//        assert!(id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
//        stake
//    }

//    spec unstake_votes {
//        pragma verify = false;
//        let expected_states = vec(DEFEATED);
//        let expected_states1 = concat(expected_states,vec(AGREED));
//        let expected_states2 = concat(expected_states1,vec(QUEUED));
//        let expected_states3 = concat(expected_states2,vec(EXECUTABLE));
//        let expected_states4 = concat(expected_states3,vec(EXTRACTED));
//        aborts_if expected_states4[0] != DEFEATED;
//        aborts_if expected_states4[1] != AGREED;
//        aborts_if expected_states4[2] != QUEUED;
//        aborts_if expected_states4[3] != EXECUTABLE;
//        aborts_if expected_states4[4] != EXTRACTED;
//        include spec_proposal_exists<DaoT, ActionT>(proposer_address, proposal_id) ==>
//                    CheckProposalStates<DaoT, ActionT>{expected_states: expected_states4};
//        let sender = Signer::address_of(signer);
//        aborts_if !exists<Vote<DaoT> >(sender);
//        let vote = global<Vote<DaoT> >(sender);
//        include CheckVoteOnProposal<DaoT> {vote, proposer_address, proposal_id};
//        ensures !exists<Vote<DaoT> >(sender);
//        ensures result.value == old(vote).stake.value;
//    }


    /// queue agreed proposal to execute.
    public(script) fun queue_proposal_action<DaoT: copy + drop + store, ActionT: copy + drop + store>(
        proposer_address: address,
        proposal_id: u64,
    ) acquires Proposal {
        // Only agreed proposal can be submitted.
        assert!(
            proposal_state<DaoT, ActionT>(proposer_address, proposal_id) == AGREED,
            Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID)
        );
        let proposal = borrow_global_mut<Proposal<DaoT, ActionT>>(proposer_address);
        proposal.eta = Timestamp::now_milliseconds() + proposal.action_delay;
    }
    spec queue_proposal_action {
        pragma verify = false;
        let expected_states = vec(AGREED);
        include CheckProposalStates<DaoT, ActionT>{expected_states};

        let proposal = global<Proposal<DaoT, ActionT>>(proposer_address);
        aborts_if Timestamp::spec_now_millseconds() + proposal.action_delay > MAX_U64;
        ensures proposal.eta >= Timestamp::spec_now_millseconds();
    }

    /// extract proposal action to execute.
    public fun extract_proposal_action<DaoT: copy + drop + store, ActionT: copy + drop + store>(
        proposer_address: address,
        proposal_id: u64,
    ): ActionT acquires Proposal {
        // Only executable proposal's action can be extracted.
        assert!(
            proposal_state<DaoT, ActionT>(proposer_address, proposal_id) == EXECUTABLE,
            Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID),
        );
        let proposal = borrow_global_mut<Proposal<DaoT, ActionT>>(proposer_address);
        let action: ActionT = Option::extract(&mut proposal.action);
        action
    }
    spec extract_proposal_action {
        pragma aborts_if_is_partial = false;
        let expected_states = vec(EXECUTABLE);
        include CheckProposalStates<DaoT, ActionT>{expected_states};
        modifies global<Proposal<DaoT, ActionT>>(proposer_address);
        ensures Option::is_none(global<Proposal<DaoT, ActionT>>(proposer_address).action);
    }


    /// remove terminated proposal from proposer
    public(script) fun destroy_terminated_proposal<DaoT: copy + drop + store, ActionT: copy + drop + store>(
        proposer_address: address,
        proposal_id: u64,
    ) acquires Proposal {
        let proposal_state = proposal_state<DaoT, ActionT>(proposer_address, proposal_id);
        assert!(
            proposal_state == DEFEATED || proposal_state == EXTRACTED,
            Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID),
        );
        let Proposal {
            id: _,
            proposer: _,
            start_time: _,
            end_time: _,
            for_votes: _,
            against_votes: _,
            eta: _,
            action_delay: _,
            quorum_votes: _,
            action,

            abstain_votes: _,
            total_for_votes_weight: _,
            total_against_votes_weight: _,
            total_abstain_votes_weight: _,
            dao_id: _,
            category: _,
            voting_system: _,
            strategy: _,
            block_number: _,
            root_hash: _,
        } = move_from<Proposal<DaoT, ActionT>>(proposer_address);
        if (proposal_state == DEFEATED) {
            let _ = Option::extract(&mut action);
        };
        Option::destroy_none(action);
    }

    spec destroy_terminated_proposal {
        let expected_states = concat(vec(DEFEATED), vec(EXTRACTED));
        aborts_if len(expected_states) != 2;
        aborts_if expected_states[0] != DEFEATED;
        aborts_if expected_states[1] != EXTRACTED;

        aborts_if !exists<Proposal<DaoT, ActionT>>(proposer_address);
        let proposal = global<Proposal<DaoT, ActionT>>(proposer_address);
        aborts_if proposal.id != proposal_id;
        include AbortIfTimestampNotExist;
        let current_time = Timestamp::spec_now_millseconds();
        let state = do_proposal_state(proposal, current_time);
        aborts_if (forall s in expected_states : s != state);
        aborts_if state == DEFEATED && Option::is_none(global<Proposal<DaoT, ActionT>>(proposer_address).action);
        aborts_if state == EXTRACTED && Option::is_some(global<Proposal<DaoT, ActionT>>(proposer_address).action);
        modifies global<Proposal<DaoT, ActionT>>(proposer_address);
    }

    /// check whether a proposal exists in `proposer_address` with id `proposal_id`.
    public fun proposal_exists<DaoT: copy + drop + store, ActionT: copy + drop + store>(
        proposer_address: address,
        proposal_id: u64,
    ): bool acquires Proposal {
        if (exists<Proposal<DaoT, ActionT>>(proposer_address)) {
            let proposal = borrow_global<Proposal<DaoT, ActionT>>(proposer_address);
            return proposal.id == proposal_id
        };
        false
    }
    spec proposal_exists {
        ensures exists<Proposal<DaoT, ActionT>>(proposer_address) &&
                    borrow_global<Proposal<DaoT, ActionT>>(proposer_address).id == proposal_id ==>
                    result;
    }

    spec fun spec_proposal_exists<DaoT: copy + drop + store, ActionT: copy + drop + store>(
        proposer_address: address,
        proposal_id: u64,
    ): bool {
        if (exists<Proposal<DaoT, ActionT>>(proposer_address)) {
            let proposal = global<Proposal<DaoT, ActionT>>(proposer_address);
            proposal.id == proposal_id
        } else {
            false
        }
    }

    /// Get the proposal state.
    public fun proposal_state<DaoT: copy + drop + store, ActionT: copy + drop + store>(
        proposer_address: address,
        proposal_id: u64,
    ): u8 acquires Proposal {
        let proposal = borrow_global<Proposal<DaoT, ActionT>>(proposer_address);
        assert!(proposal.id == proposal_id, Errors::invalid_argument(ERR_PROPOSAL_ID_MISMATCH));
        let current_time = Timestamp::now_milliseconds();
        do_proposal_state(proposal, current_time)
    }

    spec schema CheckProposalStates<DaoT, ActionT> {
        proposer_address: address;
        proposal_id: u64;
        expected_states: vector<u8>;
        aborts_if !exists<Proposal<DaoT, ActionT>>(proposer_address);

        let proposal = global<Proposal<DaoT, ActionT>>(proposer_address);
        aborts_if proposal.id != proposal_id;

        include AbortIfTimestampNotExist;
        let current_time = Timestamp::spec_now_millseconds();
        let state = do_proposal_state(proposal, current_time);
        aborts_if (forall s in expected_states : s != state);
    }

    spec proposal_state {
        use StarcoinFramework::CoreAddresses;
        include AbortIfTimestampNotExist;
        aborts_if !exists<Timestamp::CurrentTimeMilliseconds>(CoreAddresses::GENESIS_ADDRESS());
        aborts_if !exists<Proposal<DaoT, ActionT>>(proposer_address);

        let proposal = global<Proposal<DaoT, ActionT>>(proposer_address);
        aborts_if proposal.id != proposal_id;
    }

    fun do_proposal_state<DaoT: copy + drop + store, ActionT: copy + drop + store>(
        proposal: &Proposal<DaoT, ActionT>,
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
        } else if (Option::is_some(&proposal.action)) {
            EXECUTABLE
        } else {
            EXTRACTED
        }
    }


    /// get proposal's information.
    /// return: (id, start_time, end_time, for_votes, against_votes).
    public fun proposal_info<DaoT: copy + drop + store, ActionT: copy + drop + store>(
        proposer_address: address,
    ): (u64, u64, u64, u128, u128) acquires Proposal {
        let proposal = borrow_global<Proposal<DaoT, ActionT>>(proposer_address);
        (proposal.id, proposal.start_time, proposal.end_time, proposal.for_votes, proposal.against_votes)
    }

    spec proposal_info {
        aborts_if !exists<Proposal<DaoT, ActionT>>(proposer_address);
    }

    /// Get voter's vote info on proposal with `proposal_id` of `proposer_address`.
    public fun vote_of<DaoT: copy + drop + store>(
        voter: address,
        proposer_address: address,
        proposal_id: u64,
    ): (u8, u128) acquires Vote {
        let vote = borrow_global<Vote<DaoT> >(voter);
        assert!(vote.proposer == proposer_address, Errors::requires_address(ERR_PROPOSER_MISMATCH));
        assert!(vote.proposal_id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
        (vote.choice, vote.vote_amount)
    }

    spec vote_of {
        aborts_if !exists<Vote<DaoT> >(voter);
        let vote = global<Vote<DaoT> >(voter);
        include CheckVoteOnProposal<DaoT> {vote, proposer_address, proposal_id};
    }

    /// Check whether voter has voted on proposal with `proposal_id` of `proposer_address`.
    public fun has_vote<DaoT: copy + drop + store>(
        voter: address,
        proposer_address: address,
        proposal_id: u64,
    ): bool acquires Vote {
        if (!exists<Vote<DaoT> >(voter)) {
            return false
        };

        let vote = borrow_global<Vote<DaoT> >(voter);
        vote.proposer == proposer_address && vote.proposal_id == proposal_id
    }

}
}
