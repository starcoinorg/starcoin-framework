address StarcoinFramework {
module XDaoConfig {
    use StarcoinFramework::Token;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Config;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Treasury;
    use StarcoinFramework::DaoRegistry;

    friend StarcoinFramework::XProposal;


    /// global DAO info of the specified dao type `DaoT`.
    struct DaoGlobalInfo<phantom DaoT: store> has key {
        /// next proposal id.
        next_proposal_id: u64,
    }

    /// Configuration of the `Token`'s DAO.
    struct DaoConfig<phantom DaoT: copy + drop + store> has copy, drop, store {
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
        /// the actual voting system, default single choice voting system
        voting_system: u8,
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

    /// plugin function, can only be called by dao signer.
    /// Any token who wants to have gov functionality
    /// can optin this module by call this `register function`.
    public fun plugin<DaoT: copy + drop + store>(
        signer: &signer,
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        voting_system: u8,
    ) {
        //TODO check dao signer
        let dao_address = DaoRegistry::dao_address<DaoT>();
        assert!(Signer::address_of(signer) == dao_address, Errors::requires_address(ERR_NOT_AUTHORIZED));
        // let proposal_id = ProposalId {next: 0};
        let gov_info = DaoGlobalInfo<DaoT>  {
            next_proposal_id: 0,
        };
        move_to(signer, gov_info);
        let config = new_dao_config<DaoT> (
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            voting_system,
        );
        Config::publish_new_config(signer, config);
    }

    spec plugin {
        let sender = Signer::address_of(signer);
        aborts_if sender != Token::SPEC_TOKEN_TEST_ADDRESS();

        include NewDaoConfigParamSchema<DaoT> ;

        include Config::PublishNewConfigAbortsIf<DaoConfig<DaoT> >{account: signer};

        aborts_if exists<DaoGlobalInfo<DaoT> >(sender);
    }

    spec schema RequirePluginDao<DaoT: copy + drop + store> {
        let token_addr = Token::SPEC_TOKEN_TEST_ADDRESS();
        aborts_if !exists<DaoGlobalInfo<DaoT> >(token_addr);
        aborts_if !exists<Config::Config<DaoConfig<DaoT> >>(token_addr);
    }
    spec schema AbortIfDaoInfoNotExist<DaoT>  {
        let token_addr = Token::SPEC_TOKEN_TEST_ADDRESS();
        aborts_if !exists<DaoGlobalInfo<DaoT> >(token_addr);
    }
    spec schema AbortIfDaoConfigNotExist<DaoT>  {
        let token_addr = Token::SPEC_TOKEN_TEST_ADDRESS();
        aborts_if !exists<Config::Config<DaoConfig<DaoT> >>(token_addr);
    }
    spec schema AbortIfTimestampNotExist {
        use StarcoinFramework::CoreAddresses;
        aborts_if !exists<Timestamp::CurrentTimeMilliseconds>(CoreAddresses::GENESIS_ADDRESS());
    }

    spec module {
        apply
            AbortIfDaoInfoNotExist<DaoT> 
        to
            generate_next_proposal_id<DaoT> ;

        apply
            AbortIfDaoConfigNotExist<DaoT> 
        to
            get_config<DaoT> ,
            voting_delay<DaoT> ,
            voting_period<DaoT> ,
            voting_quorum_rate<DaoT> ,
            min_action_delay<DaoT> ,
            quorum_votes<DaoT> ;
    }

    /// create a dao config
    public fun new_dao_config<DaoT: copy + drop + store>(
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        voting_system: u8,
    ): DaoConfig<DaoT>  {
        assert!(voting_delay > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        assert!(voting_period > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        assert!(
            voting_quorum_rate > 0 && voting_quorum_rate <= 100,
            Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID),
        );
        assert!(min_action_delay > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        DaoConfig { voting_delay, voting_period, voting_quorum_rate, min_action_delay, voting_system }
    }

    spec new_dao_config {
        include NewDaoConfigParamSchema<DaoT> ;
    }

    spec schema NewDaoConfigParamSchema<DaoT>  {
        voting_delay: u64;
        voting_period: u64;
        voting_quorum_rate: u8;
        min_action_delay: u64;

        aborts_if voting_delay == 0;
        aborts_if voting_period == 0;
        aborts_if voting_quorum_rate == 0 || voting_quorum_rate > 100;
        aborts_if min_action_delay == 0;
    }

    public(friend) fun generate_next_proposal_id<DaoT: store>(): u64 acquires DaoGlobalInfo {
        let dao_address = DaoRegistry::dao_address<DaoT>();
        let gov_info = borrow_global_mut<DaoGlobalInfo<DaoT>>(dao_address);
        let proposal_id = gov_info.next_proposal_id;
        gov_info.next_proposal_id = proposal_id + 1;
        proposal_id
    }

    spec generate_next_proposal_id  {
        include GenerateNextProposalIdSchema<DaoT> ;
        ensures result == old(global<DaoGlobalInfo<DaoT> >(Token::SPEC_TOKEN_TEST_ADDRESS()).next_proposal_id);
    }

    spec schema GenerateNextProposalIdSchema<DaoT>  {
        aborts_if global<DaoGlobalInfo<DaoT> >(Token::SPEC_TOKEN_TEST_ADDRESS()).next_proposal_id >= MAX_U64;
        modifies global<DaoGlobalInfo<DaoT> >(Token::SPEC_TOKEN_TEST_ADDRESS());
        ensures
        global<DaoGlobalInfo<DaoT> >(Token::SPEC_TOKEN_TEST_ADDRESS()).next_proposal_id ==
        old(global<DaoGlobalInfo<DaoT> >(Token::SPEC_TOKEN_TEST_ADDRESS()).next_proposal_id) + 1;
    }

    /// get default voting delay of the DAO.
    public fun voting_delay<DaoT: copy + drop + store>(): u64 {
        get_config<DaoT> ().voting_delay
    }

    spec voting_delay {
        aborts_if false;
    }

    /// get the default voting period of the DAO.
    public fun voting_period<DaoT: copy + drop + store>(): u64 {
        get_config<DaoT> ().voting_period
    }

    spec voting_period {
        aborts_if false;
    }

    /// Quorum votes to make proposal pass.
    /// TODO realize token with DAO
    public fun quorum_votes<DaoT: copy + drop + store>(): u128 {
        let market_cap = Token::market_cap<DaoT> ();
        let balance_in_treasury = Treasury::balance<DaoT> ();
        let supply = market_cap - balance_in_treasury;
        let rate = voting_quorum_rate<DaoT> ();
        let rate = (rate as u128);
        supply * rate / 100
    }
    spec schema CheckQuorumVotes<DaoT>  {
        aborts_if Token::spec_abstract_total_value<DaoT> () * spec_dao_config<DaoT> ().voting_quorum_rate > MAX_U128;
    }
    spec quorum_votes {
        pragma verify = false;
        include CheckQuorumVotes<DaoT> ;
    }

    spec fun spec_quorum_votes<DaoT: copy + drop + store>(): u128 {
        let supply = Token::spec_abstract_total_value<DaoT> () - Treasury::spec_balance<DaoT> ();
        supply * spec_dao_config<DaoT> ().voting_quorum_rate / 100
    }

    /// Get the quorum rate in percent.
    public fun voting_quorum_rate<DaoT: copy + drop + store>(): u8 {
        get_config<DaoT> ().voting_quorum_rate
    }

    spec voting_quorum_rate {
        aborts_if false;
        ensures result == global<Config::Config<DaoConfig<DaoT> >>((Token::SPEC_TOKEN_TEST_ADDRESS())).payload.voting_quorum_rate;
    }

    /// Get the min_action_delay of the DAO.
    public fun min_action_delay<DaoT: copy + drop + store>(): u64 {
        get_config<DaoT> ().min_action_delay
    }

    spec min_action_delay {
        aborts_if false;
        ensures result == spec_dao_config<DaoT> ().min_action_delay;
    }

    fun get_config<DaoT: copy + drop + store>(): DaoConfig<DaoT>  {
        let token_issuer = DaoRegistry::dao_address<DaoT>();
        Config::get_by_address<DaoConfig<DaoT> >(token_issuer)
    }

    spec get_config {
        aborts_if false;
        ensures result == global<Config::Config<DaoConfig<DaoT> >>(Token::SPEC_TOKEN_TEST_ADDRESS()).payload;
    }


    spec fun spec_dao_config<DaoT: copy + drop + store>(): DaoConfig<DaoT>  {
        global<Config::Config<DaoConfig<DaoT> >>((Token::SPEC_TOKEN_TEST_ADDRESS())).payload
    }


    spec schema CheckModifyConfigWithCap<DaoT>  {
        cap: Config::ModifyConfigCapability<DaoConfig<DaoT> >;
        aborts_if cap.account_address != Token::SPEC_TOKEN_TEST_ADDRESS();
        aborts_if !exists<Config::Config<DaoConfig<DaoT> >>(cap.account_address);
    }

    /// update function, modify dao config.
    /// if any param is 0, it means no change to that param.
    public fun modify_dao_config<DaoT: copy + drop + store>(
        cap: &mut Config::ModifyConfigCapability<DaoConfig<DaoT> >,
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
    ) {
        assert!(Config::account_address(cap) == DaoRegistry::dao_address<DaoT>(), Errors::invalid_argument(ERR_NOT_AUTHORIZED));
        let config = get_config<DaoT> ();
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
        Config::set_with_capability<DaoConfig<DaoT> >(cap, config);
    }

    spec modify_dao_config {
        include CheckModifyConfigWithCap<DaoT> ;
        aborts_if voting_quorum_rate > 0 && voting_quorum_rate > 100;
    }

    /// set voting delay
    public fun set_voting_delay<DaoT: copy + drop + store>(
        cap: &mut Config::ModifyConfigCapability<DaoConfig<DaoT> >,
        value: u64,
    ) {
        assert!(Config::account_address(cap) == DaoRegistry::dao_address<DaoT>(), Errors::invalid_argument(ERR_NOT_AUTHORIZED));
        assert!(value > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        let config = get_config<DaoT> ();
        config.voting_delay = value;
        Config::set_with_capability<DaoConfig<DaoT> >(cap, config);
    }

    spec set_voting_delay {
        include CheckModifyConfigWithCap<DaoT> ;
        aborts_if value == 0;
    }

    /// set voting period
    public fun set_voting_period<DaoT: copy + drop + store>(
        cap: &mut Config::ModifyConfigCapability<DaoConfig<DaoT> >,
        value: u64,
    ) {
        assert!(Config::account_address(cap) == DaoRegistry::dao_address<DaoT>(), Errors::invalid_argument(ERR_NOT_AUTHORIZED));
        assert!(value > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        let config = get_config<DaoT> ();
        config.voting_period = value;
        Config::set_with_capability<DaoConfig<DaoT> >(cap, config);
    }

    spec set_voting_period {
        include CheckModifyConfigWithCap<DaoT> ;
        aborts_if value == 0;
    }

    /// set voting quorum rate
    public fun set_voting_quorum_rate<DaoT: copy + drop + store>(
        cap: &mut Config::ModifyConfigCapability<DaoConfig<DaoT> >,
        value: u8,
    ) {
        assert!(Config::account_address(cap) == DaoRegistry::dao_address<DaoT>(), Errors::invalid_argument(ERR_NOT_AUTHORIZED));
        assert!(value <= 100 && value > 0, Errors::invalid_argument(ERR_QUORUM_RATE_INVALID));
        let config = get_config<DaoT> ();
        config.voting_quorum_rate = value;
        Config::set_with_capability<DaoConfig<DaoT> >(cap, config);
    }

    spec set_voting_quorum_rate {
        aborts_if !(value > 0 && value <= 100);
        include CheckModifyConfigWithCap<DaoT> ;
    }

    /// set min action delay
    public fun set_min_action_delay<DaoT: copy + drop + store>(
        cap: &mut Config::ModifyConfigCapability<DaoConfig<DaoT> >,
        value: u64,
    ) {
        assert!(Config::account_address(cap) == DaoRegistry::dao_address<DaoT>(), Errors::invalid_argument(ERR_NOT_AUTHORIZED));
        assert!(value > 0, Errors::invalid_argument(ERR_CONFIG_PARAM_INVALID));
        let config = get_config<DaoT> ();
        config.min_action_delay = value;
        Config::set_with_capability<DaoConfig<DaoT> >(cap, config);
    }
    spec set_min_action_delay {
        aborts_if value == 0;
        include CheckModifyConfigWithCap<DaoT> ;
    }
}
}
