address StarcoinFramework {

module GeneralDaoProposal {

    use StarcoinFramework::Token;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Option;
    use StarcoinFramework::Config;
    use StarcoinFramework::Event;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Treasury;

    spec module {
        pragma verify;
        pragma aborts_if_is_strict;
    }

    /// Proposal state
    const PENDING: u8 = 1;
    const ACTIVE: u8 = 2;
    const DEFEATED: u8 = 3;
    const AGREED: u8 = 4;
    const QUEUED: u8 = 5;
    const EXECUTABLE: u8 = 6;
    const EXTRACTED: u8 = 7;

    /// global DAO info of the specified token type `DaoType`.
    struct DaoGlobalInfo<phantom DaoType: store> has key {
        /// next proposal id.
        next_proposal_id: u64,
        /// proposal creating event.
        proposal_create_event: Event::EventHandle<ProposalCreatedEvent>,
        /// voting event.
        vote_changed_event: Event::EventHandle<VoteChangedEvent>,
    }

    /// Configuration of the `Token`'s DAO.
    struct DaoConfig<phantom DaoType: copy + drop + store> has copy, drop, store {
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
    }

    spec DaoConfig {
        invariant voting_quorum_rate > 0 && voting_quorum_rate <= 100;
        invariant voting_delay > 0;
        invariant voting_period > 0;
        invariant min_action_delay > 0;
    }

    struct ProposalCapability<phantom DaoType> has key, store {}

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
        /// agree with the proposal or not
        agree: bool,
        /// latest vote count of the voter.
        vote: u128,
    }

    /// Proposal data struct.
    struct Proposal<phantom Token: store, Action: store> has key {
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
    }

    /// User vote info.
    struct Vote<phantom DaoType: store> has key {
        /// vote for the proposal under the `proposer`.
        proposer: address,
        /// proposal id.
        id: u64,
        /// how many tokens to stake.
        stake_value: u128,
        /// vote for or vote against.
        agree: bool,
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

    /// plugin function, can only be called by token issuer.
    /// Any token who wants to have gov functionality
    /// can optin this module by call this `register function`.
    public fun plugin<DaoType: copy + drop + store>(
        signer: &signer,
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
    ): ProposalCapability<DaoType> {
        // let proposal_id = ProposalId {next: 0};
//        let token_issuer = Token::token_address<DaoType>();
//        assert!(Signer::address_of(signer) == token_issuer, Errors::requires_address(ERR_NOT_AUTHORIZED));

        let gov_info = DaoGlobalInfo<DaoType>{
            next_proposal_id: 0,
            proposal_create_event: Event::new_event_handle<ProposalCreatedEvent>(signer),
            vote_changed_event: Event::new_event_handle<VoteChangedEvent>(signer),
        };
        move_to(signer, gov_info);
        let config = new_dao_config<DaoType>(
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
        );
        Config::publish_new_config(signer, config);
        ProposalCapability{}
    }

    spec plugin {
        let sender = Signer::address_of(signer);
        aborts_if sender != Token::SPEC_TOKEN_TEST_ADDRESS();

        include NewDaoConfigParamSchema<DaoType>;

        include Config::PublishNewConfigAbortsIf<DaoConfig<DaoType>> { account: signer };

        aborts_if exists<DaoGlobalInfo<DaoType>>(sender);
    }

    spec schema RequirePluginDao<DaoType: copy + drop + store> {
        let token_addr = Token::SPEC_TOKEN_TEST_ADDRESS();
        aborts_if !exists<DaoGlobalInfo<DaoType>>(token_addr);
        aborts_if !exists<Config::Config<DaoConfig<DaoType>>>(token_addr);
    }
    spec schema AbortIfDaoInfoNotExist<DaoType> {
        let token_addr = Token::SPEC_TOKEN_TEST_ADDRESS();
        aborts_if !exists<DaoGlobalInfo<DaoType>>(token_addr);
    }
    spec schema AbortIfDaoConfigNotExist<DaoType> {
        let token_addr = Token::SPEC_TOKEN_TEST_ADDRESS();
        aborts_if !exists<Config::Config<DaoConfig<DaoType>>>(token_addr);
    }
    spec schema AbortIfTimestampNotExist {
        use StarcoinFramework::CoreAddresses;
        aborts_if !exists<Timestamp::CurrentTimeMilliseconds>(CoreAddresses::GENESIS_ADDRESS());
    }

    spec module {
        apply
        AbortIfDaoInfoNotExist<DaoType>
        to
        generate_next_proposal_id<DaoType>;

        apply
        AbortIfDaoConfigNotExist<DaoType>
        to
        get_config<DaoType>,
        voting_delay<DaoType>,
        voting_period<DaoType>,
        voting_quorum_rate<DaoType>,
        min_action_delay<DaoType>,
        quorum_votes<DaoType>;
    }

    /// create a dao config
    public fun new_dao_config<DaoType: copy + drop + store>(
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
    ): DaoConfig<DaoType> {
        assert!(voting_delay > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        assert!(voting_period > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        assert!(
            voting_quorum_rate > 0 && voting_quorum_rate <= 100,
            Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID),
        );
        assert!(min_action_delay > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        DaoConfig{ voting_delay, voting_period, voting_quorum_rate, min_action_delay }
    }

    spec new_dao_config {
        include NewDaoConfigParamSchema<DaoType>;
    }

    spec schema NewDaoConfigParamSchema<DaoType> {
        voting_delay: u64;
        voting_period: u64;
        voting_quorum_rate: u8;
        min_action_delay: u64;

        aborts_if voting_delay == 0;
        aborts_if voting_period == 0;
        aborts_if voting_quorum_rate == 0 || voting_quorum_rate > 100;
        aborts_if min_action_delay == 0;
    }

    /// propose a proposal.
    /// `action`: the actual action to execute.
    /// `action_delay`: the delay to execute after the proposal is agreed
    public fun propose<DaoType: copy + drop + store,
                       ActionT: copy + drop + store>(
        signer: &signer,
        action: ActionT,
        action_delay: u64,
        _cap: &ProposalCapability<DaoType>
    ) acquires DaoGlobalInfo {
        if (action_delay == 0) {
            action_delay = min_action_delay<DaoType>();
        } else {
            assert!(action_delay >= min_action_delay<DaoType>(), Errors::invalid_argument(ERR_ACTION_DELAY_TOO_SMALL));
        };
        let proposal_id = generate_next_proposal_id<DaoType>();
        let proposer = Signer::address_of(signer);
        let start_time = Timestamp::now_milliseconds() + voting_delay<DaoType>();
        let quorum_votes = quorum_votes<DaoType>();
        let proposal = Proposal<DaoType, ActionT>{
            id: proposal_id,
            proposer,
            start_time,
            end_time: start_time + voting_period<DaoType>(),
            for_votes: 0,
            against_votes: 0,
            eta: 0,
            action_delay,
            quorum_votes,
            action: Option::some(action),
        };
        move_to(signer, proposal);
        // emit event
        let gov_info = borrow_global_mut<DaoGlobalInfo<DaoType>>(Token::token_address<DaoType>());
        Event::emit_event(
            &mut gov_info.proposal_create_event,
            ProposalCreatedEvent{ proposal_id, proposer },
        );
    }

    spec propose {
        use StarcoinFramework::CoreAddresses;
        pragma verify = false;
        let proposer = Signer::address_of(signer);

        include GenerateNextProposalIdSchema<DaoType>;

        pragma addition_overflow_unchecked = true; // start_time calculation

        include AbortIfDaoConfigNotExist<DaoType>;
        include AbortIfDaoInfoNotExist<DaoType>;
        aborts_if !exists<Timestamp::CurrentTimeMilliseconds>(CoreAddresses::GENESIS_ADDRESS());

        aborts_if action_delay > 0 && action_delay < spec_dao_config<DaoType>().min_action_delay;
        include CheckQuorumVotes<DaoType>;

        let sender = Signer::address_of(signer);
        aborts_if exists<Proposal<DaoType, ActionT>>(sender);
        modifies global<DaoGlobalInfo<DaoType>>(Token::SPEC_TOKEN_TEST_ADDRESS());

        ensures exists<Proposal<DaoType, ActionT>>(sender);
    }

    /// votes for a proposal.
    /// User can only vote once, then the stake is locked,
    /// which can only be unstaked by user after the proposal is expired, or cancelled, or executed.
    /// So think twice before casting vote.
    public fun cast_vote<DaoType: copy + drop + store,
                         ActionT: copy + drop + store>(
        signer: &signer,
        proposer_address: address,
        proposal_id: u64,
        stake_value: u128,
        agree: bool,
        _cap: &ProposalCapability<DaoType>,
    ) acquires Proposal, DaoGlobalInfo, Vote {
            {
                let state = proposal_state<DaoType, ActionT>(proposer_address, proposal_id);
                // only when proposal is active, use can cast vote.
                assert!(state == ACTIVE, Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID));
            };
        let proposal = borrow_global_mut<Proposal<DaoType, ActionT>>(proposer_address);
        assert!(proposal.id == proposal_id, Errors::invalid_argument(ERR_PROPOSAL_ID_MISMATCH));
        let sender = Signer::address_of(signer);
        let total_voted = if (exists<Vote<DaoType>>(sender)) {
            let my_vote = borrow_global_mut<Vote<DaoType>>(sender);
            assert!(my_vote.id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
            assert!(my_vote.agree == agree, Errors::invalid_state(ERR_VOTE_STATE_MISMATCH));

            do_cast_vote(proposal, my_vote, stake_value);
            Token::value(&my_vote.stake)
        } else {
            let my_vote = Vote<DaoType>{
                proposer: proposer_address,
                id: proposal_id,
                stake_value,
                agree,
            };
            do_cast_vote(proposal, &mut my_vote, stake_value);
            let total_voted = Token::value(&my_vote.stake);
            move_to(signer, my_vote);
            total_voted
        };

        // emit event
        let gov_info = borrow_global_mut<DaoGlobalInfo<DaoType>>(Token::token_address<DaoType>());
        Event::emit_event(
            &mut gov_info.vote_changed_event,
            VoteChangedEvent{
                proposal_id,
                proposer: proposer_address,
                voter: sender,
                agree,
                vote: total_voted,
            },
        );
    }

    spec schema CheckVoteOnCast<DaoType, ActionT> {
        proposal_id: u64;
        agree: bool;
        voter: address;
        stake_value: u128;
        let vote = global<Vote<DaoType>>(voter);
        aborts_if vote.id != proposal_id;
        aborts_if vote.agree != agree;
        aborts_if vote.stake.value + stake_value > MAX_U128;
    }

    spec cast_vote {
        pragma addition_overflow_unchecked = true;

        include AbortIfDaoInfoNotExist<DaoType>;

        let expected_states = vec(ACTIVE);
        include CheckProposalStates<DaoType, ActionT> { expected_states };
        let sender = Signer::address_of(signer);
        let vote_exists = exists<Vote<DaoType>>(sender);
        include vote_exists ==> CheckVoteOnCast<DaoType, ActionT> {
            voter: sender,
            proposal_id: proposal_id,
            agree: agree,
            stake_value: stake.value,
        };

        modifies global<Proposal<DaoType, ActionT>>(proposer_address);
        ensures !vote_exists ==> global<Vote<DaoType>>(sender).stake.value == stake.value;
    }

    fun do_cast_vote<DaoType: copy + drop + store,
                     ActionT: copy + drop + store>(proposal: &mut Proposal<DaoType, ActionT>,
                                                   vote: &mut Vote<DaoType>,
                                                   stake_value: u128) {
        //let stake_value = Token::value(&stake);
        //Token::deposit(&mut vote.stake, stake);
        if (vote.agree) {
            proposal.for_votes = proposal.for_votes + stake_value;
        } else {
            proposal.against_votes = proposal.against_votes + stake_value;
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


    /// Let user change their vote during the voting time.
    public fun change_vote<DaoType: copy + drop + store,
                           ActionT: copy + drop + store>(
        signer: &signer,
        proposer_address: address,
        proposal_id: u64,
        agree: bool,
        _cap: &ProposalCapability<DaoType>,
    ) acquires Proposal, DaoGlobalInfo, Vote {
            {
                let state = proposal_state<DaoType, ActionT>(proposer_address, proposal_id);
                // only when proposal is active, user can change vote.
                assert!(state == ACTIVE, Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID));
            };
        let proposal = borrow_global_mut<Proposal<DaoType, ActionT>>(proposer_address);
        assert!(proposal.id == proposal_id, Errors::invalid_argument(ERR_PROPOSAL_ID_MISMATCH));
        let my_vote = borrow_global_mut<Vote<DaoType>>(Signer::address_of(signer));
            {
                assert!(my_vote.proposer == proposer_address, Errors::invalid_argument(ERR_PROPOSER_MISMATCH));
                assert!(my_vote.id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
            };

        // flip the vote
        if (my_vote.agree != agree) {
            let total_voted = do_flip_vote(my_vote, proposal);
            // emit event
            let gov_info = borrow_global_mut<DaoGlobalInfo<DaoType>>(Token::token_address<DaoType>());
            Event::emit_event(
                &mut gov_info.vote_changed_event,
                VoteChangedEvent{
                    proposal_id,
                    proposer: proposer_address,
                    voter: Signer::address_of(signer),
                    agree,
                    vote: total_voted,
                },
            );
        };
    }
    spec schema CheckVoteOnProposal<DaoType> {
        vote: Vote<DaoType>;
        proposer_address: address;
        proposal_id: u64;

        aborts_if vote.id != proposal_id;
        aborts_if vote.proposer != proposer_address;
    }
    spec schema CheckChangeVote<DaoType, ActionT> {
        vote: Vote<DaoType>;
        proposer_address: address;
        let proposal = global<Proposal<DaoType, ActionT>>(proposer_address);
        include AbortIfDaoInfoNotExist<DaoType>;
        include CheckFlipVote<DaoType, ActionT> { my_vote: vote, proposal };
    }
    spec change_vote {
        pragma verify = false;
        let expected_states = vec(ACTIVE);
        include CheckProposalStates<DaoType, ActionT> { expected_states };

        let sender = Signer::address_of(signer);
        aborts_if !exists<Vote<DaoType>>(sender);
        let vote = global<Vote<DaoType>>(sender);
        include CheckVoteOnProposal<DaoType> { vote, proposer_address, proposal_id };
        include vote.agree != agree ==> CheckChangeVote<DaoType, ActionT> { vote, proposer_address };

        ensures vote.agree != agree ==> vote.agree == agree;
    }

    fun do_flip_vote<DaoType: copy + drop + store, ActionT: copy + drop + store>(my_vote: &mut Vote<DaoType>, proposal: &mut Proposal<DaoType, ActionT>): u128 {
        my_vote.agree = !my_vote.agree;
        let total_voted = Token::value(&my_vote.stake);
        if (my_vote.agree) {
            proposal.for_votes = proposal.for_votes + total_voted;
            proposal.against_votes = proposal.against_votes - total_voted;
        } else {
            proposal.for_votes = proposal.for_votes - total_voted;
            proposal.against_votes = proposal.against_votes + total_voted;
        };
        total_voted
    }
    spec schema CheckFlipVote<DaoType, ActionT> {
        my_vote: Vote<DaoType>;
        proposal: Proposal<DaoType, ActionT>;
        aborts_if my_vote.agree && proposal.for_votes < my_vote.stake.value;
        aborts_if my_vote.agree && proposal.against_votes + my_vote.stake.value > MAX_U128;
        aborts_if !my_vote.agree && proposal.against_votes < my_vote.stake.value;
        aborts_if !my_vote.agree && proposal.for_votes + my_vote.stake.value > MAX_U128;
    }

    spec do_flip_vote {
        include CheckFlipVote<DaoType, ActionT>;
        ensures my_vote.agree == !old(my_vote).agree;
    }

    /// Revoke some voting powers from vote on `proposal_id` of `proposer_address`.
    public fun revoke_vote<DaoType: copy + drop + store, ActionT: copy + drop + store>(
        signer: &signer,
        proposer_address: address,
        proposal_id: u64,
        voting_power: u128,
    ): Token::Token<DaoType> acquires Proposal, Vote, DaoGlobalInfo {
            {
                let state = proposal_state<DaoType, ActionT>(proposer_address, proposal_id);
                // only when proposal is active, user can revoke vote.
                assert!(state == ACTIVE, Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID));
            };
        // get proposal
        let proposal = borrow_global_mut<Proposal<DaoType, ActionT>>(proposer_address);

        // get vote
        let my_vote = move_from<Vote<DaoType>>(Signer::address_of(signer));
            {
                assert!(my_vote.proposer == proposer_address, Errors::invalid_argument(ERR_PROPOSER_MISMATCH));
                assert!(my_vote.id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
            };
        // revoke vote on proposal
        let reverted_stake = do_revoke_vote(proposal, &mut my_vote, voting_power);
        // emit vote changed event
        let gov_info = borrow_global_mut<DaoGlobalInfo<DaoType>>(Token::token_address<DaoType>());
        Event::emit_event(
            &mut gov_info.vote_changed_event,
            VoteChangedEvent{
                proposal_id,
                proposer: proposer_address,
                voter: Signer::address_of(signer),
                agree: my_vote.agree,
                vote: Token::value(&my_vote.stake),
            },
        );

        // if user has no stake, destroy his vote. resolve https://github.com/starcoinorg/starcoin/issues/2925.
        if (Token::value(&my_vote.stake) == 0u128) {
            let Vote{ stake_value: _, proposer: _, id: _, agree: _ } = my_vote;
        } else {
            move_to(signer, my_vote);
        };

        reverted_stake
    }

    spec revoke_vote {
        pragma verify = false;
        include AbortIfDaoInfoNotExist<DaoType>;
        let expected_states = vec(ACTIVE);
        include CheckProposalStates<DaoType, ActionT> { expected_states };
        let sender = Signer::address_of(signer);

        aborts_if !exists<Vote<DaoType>>(sender);
        let vote = global<Vote<DaoType>>(sender);
        include CheckVoteOnProposal<DaoType> { vote, proposer_address, proposal_id };
        include CheckRevokeVote<DaoType, ActionT> {
            vote,
            proposal: global<Proposal<DaoType, ActionT>>(proposer_address),
            to_revoke: voting_power,
        };

        modifies global<Vote<DaoType>>(sender);
        modifies global<Proposal<DaoType, ActionT>>(proposer_address);
        modifies global<DaoGlobalInfo<DaoType>>(Token::SPEC_TOKEN_TEST_ADDRESS());

        ensures global<Vote<DaoType>>(sender).stake.value + result.value == old(global<Vote<DaoType>>(sender)).stake.value;
        ensures result.value == voting_power;
    }

    fun do_revoke_vote<DaoType: copy + drop + store, ActionT: copy + drop + store>(proposal: &mut Proposal<DaoType, ActionT>, vote: &mut Vote<DaoType>, to_revoke: u128): Token::Token<DaoType> {
        spec {
            assume vote.stake.value >= to_revoke;
        };
        let reverted_stake = Token::withdraw(&mut vote.stake, to_revoke);
        if (vote.agree) {
            proposal.for_votes = proposal.for_votes - to_revoke;
        } else {
            proposal.against_votes = proposal.against_votes - to_revoke;
        };
        spec {
            assert Token::value(reverted_stake) == to_revoke;
        };
        reverted_stake
    }
    spec schema CheckRevokeVote<DaoType, ActionT> {
        vote: Vote<DaoType>;
        proposal: Proposal<DaoType, ActionT>;
        to_revoke: u128;
        aborts_if vote.stake.value < to_revoke;
        aborts_if vote.agree && proposal.for_votes < to_revoke;
        aborts_if !vote.agree && proposal.against_votes < to_revoke;
    }

    spec do_revoke_vote {
        include CheckRevokeVote<DaoType, ActionT>;
        ensures vote.agree ==> old(proposal).for_votes == proposal.for_votes + to_revoke;
        ensures !vote.agree ==> old(proposal).against_votes == proposal.against_votes + to_revoke;
        ensures result.value == to_revoke;
    }

    /// Obsoleted function which no longger used while soule bindding.
    /// Retrieve back my staked token voted for a proposal.
//    public fun unstake_votes<DaoType: copy + drop + store, ActionT: copy + drop + store>(
//        signer: &signer,
//        proposer_address: address,
//        proposal_id: u64,
//    ): u128 acquires Proposal, Vote {
//        // only check state when proposal exists.
//        // because proposal can be destroyed after it ends in DEFEATED or EXTRACTED state.
//        if (proposal_exists<DaoType, ActionT>(proposer_address, proposal_id)) {
//            let state = proposal_state<DaoType, ActionT>(proposer_address, proposal_id);
//            // Only after vote period end, user can unstake his votes.
//            assert!(state > ACTIVE, Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID));
//        };
//        let Vote{ proposer, id, stake_value, agree: _ } = move_from<Vote<DaoType>>(
//            Signer::address_of(signer),
//        );
//        // these checks are still required.
//        assert!(proposer == proposer_address, Errors::requires_address(ERR_PROPOSER_MISMATCH));
//        assert!(id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
//        stake_value
//    }

    spec unstake_votes {
        pragma verify = false;
        let expected_states = vec(DEFEATED);
        let expected_states1 = concat(expected_states, vec(AGREED));
        let expected_states2 = concat(expected_states1, vec(QUEUED));
        let expected_states3 = concat(expected_states2, vec(EXECUTABLE));
        let expected_states4 = concat(expected_states3, vec(EXTRACTED));
        aborts_if expected_states4[0] != DEFEATED;
        aborts_if expected_states4[1] != AGREED;
        aborts_if expected_states4[2] != QUEUED;
        aborts_if expected_states4[3] != EXECUTABLE;
        aborts_if expected_states4[4] != EXTRACTED;
        include spec_proposal_exists<DaoType, ActionT>(proposer_address, proposal_id) ==>
        CheckProposalStates<DaoType, ActionT> { expected_states: expected_states4 };
        let sender = Signer::address_of(signer);
        aborts_if !exists<Vote<DaoType>>(sender);
        let vote = global<Vote<DaoType>>(sender);
        include CheckVoteOnProposal<DaoType> { vote, proposer_address, proposal_id };
        ensures !exists<Vote<DaoType>>(sender);
        ensures result.value == old(vote).stake.value;
    }


    /// queue agreed proposal to execute.
    public(script) fun queue_proposal_action<DaoType: copy + drop + store, ActionT: copy + drop + store>(
        proposer_address: address,
        proposal_id: u64,
    ) acquires Proposal {
        // Only agreed proposal can be submitted.
        assert!(
            proposal_state<DaoType, ActionT>(proposer_address, proposal_id) == AGREED,
            Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID)
        );
        let proposal = borrow_global_mut<Proposal<DaoType, ActionT>>(proposer_address);
        proposal.eta = Timestamp::now_milliseconds() + proposal.action_delay;
    }
    spec queue_proposal_action {
        pragma verify = false;
        let expected_states = vec(AGREED);
        include CheckProposalStates<DaoType, ActionT> { expected_states };

        let proposal = global<Proposal<DaoType, ActionT>>(proposer_address);
        aborts_if Timestamp::spec_now_millseconds() + proposal.action_delay > MAX_U64;
        ensures proposal.eta >= Timestamp::spec_now_millseconds();
    }

    /// extract proposal action to execute.
    public fun extract_proposal_action<DaoType: copy + drop + store, ActionT: copy + drop + store>(
        proposer_address: address,
        proposal_id: u64,
    ): ActionT acquires Proposal {
        // Only executable proposal's action can be extracted.
        assert!(
            proposal_state<DaoType, ActionT>(proposer_address, proposal_id) == EXECUTABLE,
            Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID),
        );
        let proposal = borrow_global_mut<Proposal<DaoType, ActionT>>(proposer_address);
        let action: ActionT = Option::extract(&mut proposal.action);
        action
    }

    spec extract_proposal_action {
        pragma aborts_if_is_partial = false;
        let expected_states = vec(EXECUTABLE);
        include CheckProposalStates<DaoType, ActionT> { expected_states };
        modifies global<Proposal<DaoType, ActionT>>(proposer_address);
        ensures Option::is_none(global<Proposal<DaoType, ActionT>>(proposer_address).action);
    }

    /// remove terminated proposal from proposer
    public(script) fun destroy_terminated_proposal<DaoType: copy + drop + store, ActionT: copy + drop + store>(
        proposer_address: address,
        proposal_id: u64,
    ) acquires Proposal {
        let proposal_state = proposal_state<DaoType, ActionT>(proposer_address, proposal_id);
        assert!(
            proposal_state == DEFEATED || proposal_state == EXTRACTED,
            Errors::invalid_state(ERR_PROPOSAL_STATE_INVALID),
        );
        let Proposal{
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
        } = move_from<Proposal<DaoType, ActionT>>(proposer_address);
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

        aborts_if !exists<Proposal<DaoType, ActionT>>(proposer_address);
        let proposal = global<Proposal<DaoType, ActionT>>(proposer_address);
        aborts_if proposal.id != proposal_id;
        include AbortIfTimestampNotExist;
        let current_time = Timestamp::spec_now_millseconds();
        let state = do_proposal_state(proposal, current_time);
        aborts_if (forall s in expected_states: s != state);
        aborts_if state == DEFEATED && Option::is_none(global<Proposal<DaoType, ActionT>>(proposer_address).action);
        aborts_if state == EXTRACTED && Option::is_some(global<Proposal<DaoType, ActionT>>(proposer_address).action);
        modifies global<Proposal<DaoType, ActionT>>(proposer_address);
    }

    /// check whether a proposal exists in `proposer_address` with id `proposal_id`.
    public fun proposal_exists<DaoType: copy + drop + store,
                               ActionT: copy + drop + store>(
        proposer_address: address,
        proposal_id: u64,
    ): bool acquires Proposal {
        if (exists<Proposal<DaoType, ActionT>>(proposer_address)) {
            let proposal = borrow_global<Proposal<DaoType, ActionT>>(proposer_address);
            return proposal.id == proposal_id
        };
        false
    }
    spec proposal_exists {
        ensures exists<Proposal<DaoType, ActionT>>(proposer_address) &&
                borrow_global<Proposal<DaoType, ActionT>>(proposer_address).id == proposal_id ==>
                result;
    }

    spec fun spec_proposal_exists<DaoType: copy + drop + store, ActionT: copy + drop + store>(
        proposer_address: address,
        proposal_id: u64,
    ): bool {
        if (exists<Proposal<DaoType, ActionT>>(proposer_address)) {
            let proposal = global<Proposal<DaoType, ActionT>>(proposer_address);
            proposal.id == proposal_id
        } else {
            false
        }
    }

    /// Get the proposal state.
    public fun proposal_state<DaoType: copy + drop + store, ActionT: copy + drop + store>(
        proposer_address: address,
        proposal_id: u64,
    ): u8 acquires Proposal {
        let proposal = borrow_global<Proposal<DaoType, ActionT>>(proposer_address);
        assert!(proposal.id == proposal_id, Errors::invalid_argument(ERR_PROPOSAL_ID_MISMATCH));
        let current_time = Timestamp::now_milliseconds();
        do_proposal_state(proposal, current_time)
    }

    spec schema CheckProposalStates<DaoType, ActionT> {
        proposer_address: address;
        proposal_id: u64;
        expected_states: vector<u8>;
        aborts_if !exists<Proposal<DaoType, ActionT>>(proposer_address);

        let proposal = global<Proposal<DaoType, ActionT>>(proposer_address);
        aborts_if proposal.id != proposal_id;

        include AbortIfTimestampNotExist;
        let current_time = Timestamp::spec_now_millseconds();
        let state = do_proposal_state(proposal, current_time);
        aborts_if (forall s in expected_states: s != state);
    }

    spec proposal_state {
        use StarcoinFramework::CoreAddresses;
        include AbortIfTimestampNotExist;
        aborts_if !exists<Timestamp::CurrentTimeMilliseconds>(CoreAddresses::GENESIS_ADDRESS());
        aborts_if !exists<Proposal<DaoType, ActionT>>(proposer_address);

        let proposal = global<Proposal<DaoType, ActionT>>(proposer_address);
        aborts_if proposal.id != proposal_id;
    }

    fun do_proposal_state<DaoType: copy + drop + store, ActionT: copy + drop + store>(
        proposal: &Proposal<DaoType, ActionT>,
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
    public fun proposal_info<DaoType: copy + drop + store, ActionT: copy + drop + store>(
        proposer_address: address,
    ): (u64, u64, u64, u128, u128) acquires Proposal {
        let proposal = borrow_global<Proposal<DaoType, ActionT>>(proposer_address);
        (proposal.id, proposal.start_time, proposal.end_time, proposal.for_votes, proposal.against_votes)
    }

    spec proposal_info {
        aborts_if !exists<Proposal<DaoType, ActionT>>(proposer_address);
    }

    /// Get voter's vote info on proposal with `proposal_id` of `proposer_address`.
    public fun vote_of<DaoType: copy + drop + store>(
        voter: address,
        proposer_address: address,
        proposal_id: u64,
    ): (bool, u128) acquires Vote {
        let vote = borrow_global<Vote<DaoType>>(voter);
        assert!(vote.proposer == proposer_address, Errors::requires_address(ERR_PROPOSER_MISMATCH));
        assert!(vote.id == proposal_id, Errors::invalid_argument(ERR_VOTED_OTHERS_ALREADY));
        (vote.agree, Token::value(&vote.stake))
    }

    spec vote_of {
        aborts_if !exists<Vote<DaoType>>(voter);
        let vote = global<Vote<DaoType>>(voter);
        include CheckVoteOnProposal<DaoType> { vote, proposer_address, proposal_id };
    }

    /// Check whether voter has voted on proposal with `proposal_id` of `proposer_address`.
    public fun has_vote<DaoType: copy + drop + store>(
        voter: address,
        proposer_address: address,
        proposal_id: u64,
    ): bool acquires Vote {
        if (!exists<Vote<DaoType>>(voter)) {
            return false
        };

        let vote = borrow_global<Vote<DaoType>>(voter);
        vote.proposer == proposer_address && vote.id == proposal_id
    }

    fun generate_next_proposal_id<DaoType: store>(): u64 acquires DaoGlobalInfo {
        let gov_info = borrow_global_mut<DaoGlobalInfo<DaoType>>(Token::token_address<DaoType>());
        let proposal_id = gov_info.next_proposal_id;
        gov_info.next_proposal_id = proposal_id + 1;
        proposal_id
    }

    spec generate_next_proposal_id {
        include GenerateNextProposalIdSchema<DaoType>;
        ensures result == old(global<DaoGlobalInfo<DaoType>>(Token::SPEC_TOKEN_TEST_ADDRESS()).next_proposal_id);
    }

    spec schema GenerateNextProposalIdSchema<DaoType> {
        aborts_if global<DaoGlobalInfo<DaoType>>(Token::SPEC_TOKEN_TEST_ADDRESS()).next_proposal_id >= MAX_U64;
        modifies global<DaoGlobalInfo<DaoType>>(Token::SPEC_TOKEN_TEST_ADDRESS());
        ensures
        global<DaoGlobalInfo<DaoType>>(Token::SPEC_TOKEN_TEST_ADDRESS()).next_proposal_id ==
        old(global<DaoGlobalInfo<DaoType>>(Token::SPEC_TOKEN_TEST_ADDRESS()).next_proposal_id) + 1;
    }

    //// Helper functions

    //// Query functions

    /// get default voting delay of the DAO.
    public fun voting_delay<DaoType: copy + drop + store>(): u64 {
        get_config<DaoType>().voting_delay
    }

    spec voting_delay {
        aborts_if false;
    }

    /// get the default voting period of the DAO.
    public fun voting_period<DaoType: copy + drop + store>(): u64 {
        get_config<DaoType>().voting_period
    }

    spec voting_period {
        aborts_if false;
    }

    /// Quorum votes to make proposal pass.
    public fun quorum_votes<DaoType: copy + drop + store>(): u128 {
        let market_cap = Token::market_cap<DaoType>();
        let balance_in_treasury = Treasury::balance<DaoType>();
        let supply = market_cap - balance_in_treasury;
        let rate = voting_quorum_rate<DaoType>();
        let rate = (rate as u128);
        supply * rate / 100
    }
    spec schema CheckQuorumVotes<DaoType> {
        aborts_if Token::spec_abstract_total_value<DaoType>() * spec_dao_config<DaoType>().voting_quorum_rate > MAX_U128;
    }
    spec quorum_votes {
        pragma verify = false;
        include CheckQuorumVotes<DaoType>;
    }

    spec fun spec_quorum_votes<DaoType: copy + drop + store>(): u128 {
        let supply = Token::spec_abstract_total_value<DaoType>() - Treasury::spec_balance<DaoType>();
        supply * spec_dao_config<DaoType>().voting_quorum_rate / 100
    }

    /// Get the quorum rate in percent.
    public fun voting_quorum_rate<DaoType: copy + drop + store>(): u8 {
        get_config<DaoType>().voting_quorum_rate
    }

    spec voting_quorum_rate {
        aborts_if false;
        ensures result == global<Config::Config<DaoConfig<DaoType>>>((Token::SPEC_TOKEN_TEST_ADDRESS())).payload.voting_quorum_rate;
    }

    /// Get the min_action_delay of the DAO.
    public fun min_action_delay<DaoType: copy + drop + store>(): u64 {
        get_config<DaoType>().min_action_delay
    }

    spec min_action_delay {
        aborts_if false;
        ensures result == spec_dao_config<DaoType>().min_action_delay;
    }

    fun get_config<DaoType: copy + drop + store>(): DaoConfig<DaoType> {
        let token_issuer = Token::token_address<DaoType>();
        Config::get_by_address<DaoConfig<DaoType>>(token_issuer)
    }

    spec get_config {
        aborts_if false;
        ensures result == global<Config::Config<DaoConfig<DaoType>>>(Token::SPEC_TOKEN_TEST_ADDRESS()).payload;
    }


    spec fun spec_dao_config<DaoType: copy + drop + store>(): DaoConfig<DaoType> {
        global<Config::Config<DaoConfig<DaoType>>>((Token::SPEC_TOKEN_TEST_ADDRESS())).payload
    }


    spec schema CheckModifyConfigWithCap<DaoType> {
        cap: Config::ModifyConfigCapability<DaoConfig<DaoType>>;
        aborts_if cap.account_address != Token::SPEC_TOKEN_TEST_ADDRESS();
        aborts_if !exists<Config::Config<DaoConfig<DaoType>>>(cap.account_address);
    }

    /// update function, modify dao config.
    /// if any param is 0, it means no change to that param.
    public fun modify_dao_config<DaoType: copy + drop + store>(
        cap: &mut Config::ModifyConfigCapability<DaoConfig<DaoType>>,
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
    ) {
        assert!(Config::account_address(cap) == Token::token_address<DaoType>(), Errors::invalid_argument(ERR_NOT_AUTHORIZED));
        let config = get_config<DaoType>();
        if (voting_period > 0) {
            config.voting_period = voting_period;
        };
        if (voting_delay > 0) {
            config.voting_delay = voting_delay;
        };
        if (voting_quorum_rate > 0) {
            assert!(voting_quorum_rate <= 100, Errors::invalid_argument(ERR_QUORUM_RATE_INVALID));
            config.voting_quorum_rate = voting_quorum_rate;
        };
        if (min_action_delay > 0) {
            config.min_action_delay = min_action_delay;
        };
        Config::set_with_capability<DaoConfig<DaoType>>(cap, config);
    }

    spec modify_dao_config {
        include CheckModifyConfigWithCap<DaoType>;
        aborts_if voting_quorum_rate > 0 && voting_quorum_rate > 100;
    }

    /// set voting delay
    public fun set_voting_delay<DaoType: copy + drop + store>(
        cap: &mut Config::ModifyConfigCapability<DaoConfig<DaoType>>,
        value: u64,
    ) {
        assert!(Config::account_address(cap) == Token::token_address<DaoType>(), Errors::invalid_argument(ERR_NOT_AUTHORIZED));
        assert!(value > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        let config = get_config<DaoType>();
        config.voting_delay = value;
        Config::set_with_capability<DaoConfig<DaoType>>(cap, config);
    }

    spec set_voting_delay {
        include CheckModifyConfigWithCap<DaoType>;
        aborts_if value == 0;
    }

    /// set voting period
    public fun set_voting_period<DaoType: copy + drop + store>(
        cap: &mut Config::ModifyConfigCapability<DaoConfig<DaoType>>,
        value: u64,
    ) {
        assert!(Config::account_address(cap) == Token::token_address<DaoType>(), Errors::invalid_argument(ERR_NOT_AUTHORIZED));
        assert!(value > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        let config = get_config<DaoType>();
        config.voting_period = value;
        Config::set_with_capability<DaoConfig<DaoType>>(cap, config);
    }

    spec set_voting_period {
        include CheckModifyConfigWithCap<DaoType>;
        aborts_if value == 0;
    }

    /// set voting quorum rate
    public fun set_voting_quorum_rate<DaoType: copy + drop + store>(
        cap: &mut Config::ModifyConfigCapability<DaoConfig<DaoType>>,
        value: u8,
    ) {
        assert!(Config::account_address(cap) == Token::token_address<DaoType>(), Errors::invalid_argument(ERR_NOT_AUTHORIZED));
        assert!(value <= 100 && value > 0, Errors::invalid_argument(ERR_QUORUM_RATE_INVALID));
        let config = get_config<DaoType>();
        config.voting_quorum_rate = value;
        Config::set_with_capability<DaoConfig<DaoType>>(cap, config);
    }

    spec set_voting_quorum_rate {
        aborts_if !(value > 0 && value <= 100);
        include CheckModifyConfigWithCap<DaoType>;
    }

    /// set min action delay
    public fun set_min_action_delay<DaoType: copy + drop + store>(
        cap: &mut Config::ModifyConfigCapability<DaoConfig<DaoType>>,
        value: u64,
    ) {
        assert!(Config::account_address(cap) == Token::token_address<DaoType>(), Errors::invalid_argument(ERR_NOT_AUTHORIZED));
        assert!(value > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        let config = get_config<DaoType>();
        config.min_action_delay = value;
        Config::set_with_capability<DaoConfig<DaoType>>(cap, config);
    }
    spec set_min_action_delay {
        aborts_if value == 0;
        include CheckModifyConfigWithCap<DaoType>;
    }
}
}