/// The module for init Genesis
module StarcoinFramework::Genesis {

    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Account;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::STC::{Self, STC};
    use StarcoinFramework::DummyToken;
    use StarcoinFramework::PackageTxnManager;
    use StarcoinFramework::ConsensusConfig;
    use StarcoinFramework::VMConfig;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Block;
    use StarcoinFramework::TransactionFee;
    use StarcoinFramework::BlockReward;
    use StarcoinFramework::ChainId;
    use StarcoinFramework::ConsensusStrategy;
    use StarcoinFramework::TransactionPublishOption;
    use StarcoinFramework::TransactionTimeoutConfig;
    use StarcoinFramework::Epoch;
    use StarcoinFramework::Version;
    use StarcoinFramework::Config;
    use StarcoinFramework::Option;
    use StarcoinFramework::Treasury;
    use StarcoinFramework::GenesisSignerCapability;
    use StarcoinFramework::STCUSDOracle;
    use StarcoinFramework::GenesisNFT;
    use StarcoinFramework::StarcoinDAO;
    use StarcoinFramework::TreasuryPlugin;
    use StarcoinFramework::DAORegistry;
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::AnyMemberPlugin;
    use StarcoinFramework::DAOExtensionPoint;
    use StarcoinFramework::ConfigProposalPlugin;
    use StarcoinFramework::GrantProposalPlugin;
    use StarcoinFramework::InstallPluginProposalPlugin;
    use StarcoinFramework::MemberProposalPlugin;
    use StarcoinFramework::MintProposalPlugin;
    use StarcoinFramework::StakeToSBTPlugin;
    use StarcoinFramework::UpgradeModulePlugin;
    use StarcoinFramework::GasOracleProposalPlugin;
    use StarcoinFramework::RewardConfig;
    use StarcoinFramework::LanguageVersion;
    use StarcoinFramework::Errors;
    use StarcoinFramework::WithdrawPlugin;

    spec module {
        pragma verify = false; // break after enabling v2 compilation scheme
        pragma aborts_if_is_partial = false;
        pragma aborts_if_is_strict = true;
    }

    public(script) fun initialize(
        _stdlib_version: u64,
        // block reward config
        _reward_delay: u64,
        _pre_mine_stc_amount: u128,
        _time_mint_stc_amount: u128,
        _time_mint_stc_period: u64,
        _parent_hash: vector<u8>,
        _association_auth_key: vector<u8>,
        _genesis_auth_key: vector<u8>,
        _chain_id: u8,
        _genesis_timestamp: u64,
        //consensus config
        _uncle_rate_target: u64,
        _epoch_block_count: u64,
        _base_block_time_target: u64,
        _base_block_difficulty_window: u64,
        _base_reward_per_block: u128,
        _base_reward_per_uncle_percent: u64,
        _min_block_time_target: u64,
        _max_block_time_target: u64,
        _base_max_uncles_per_block: u64,
        _base_block_gas_limit: u64,
        _strategy: u8,
        //vm config
        _script_allowed: bool,
        _module_publishing_allowed: bool,
        _instruction_schedule: vector<u8>,
        _native_schedule: vector<u8>,
        //gas constants
        _global_memory_per_byte_cost: u64,
        _global_memory_per_byte_write_cost: u64,
        _min_transaction_gas_units: u64,
        _large_transaction_cutoff: u64,
        _instrinsic_gas_per_byte: u64,
        _maximum_number_of_gas_units: u64,
        _min_price_per_gas_unit: u64,
        _max_price_per_gas_unit: u64,
        _max_transaction_size_in_bytes: u64,
        _gas_unit_scaling_factor: u64,
        _default_account_size: u64,
        // dao config
        _voting_delay: u64,
        _voting_period: u64,
        _voting_quorum_rate: u8,
        _min_action_delay: u64,
        // transaction timeout config
        _transaction_timeout: u64,
    ) {
        abort Errors::deprecated(1)
    }

    public(script) fun initialize_v2(
        stdlib_version: u64,
        // block reward and stc config
        reward_delay: u64,
        total_stc_amount: u128,
        pre_mine_stc_amount: u128,
        time_mint_stc_amount: u128,
        time_mint_stc_period: u64,
        parent_hash: vector<u8>,
        association_auth_key: vector<u8>,
        genesis_auth_key: vector<u8>,
        chain_id: u8,
        genesis_timestamp: u64,
        //consensus config
        uncle_rate_target: u64,
        epoch_block_count: u64,
        base_block_time_target: u64,
        base_block_difficulty_window: u64,
        base_reward_per_block: u128,
        base_reward_per_uncle_percent: u64,
        min_block_time_target: u64,
        max_block_time_target: u64,
        base_max_uncles_per_block: u64,
        base_block_gas_limit: u64,
        strategy: u8,
        //vm config
        script_allowed: bool,
        module_publishing_allowed: bool,
        instruction_schedule: vector<u8>,
        native_schedule: vector<u8>,
        //gas constants
        global_memory_per_byte_cost: u64,
        global_memory_per_byte_write_cost: u64,
        min_transaction_gas_units: u64,
        large_transaction_cutoff: u64,
        instrinsic_gas_per_byte: u64,
        maximum_number_of_gas_units: u64,
        min_price_per_gas_unit: u64,
        max_price_per_gas_unit: u64,
        max_transaction_size_in_bytes: u64,
        gas_unit_scaling_factor: u64,
        default_account_size: u64,
        // dao config
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        // transaction timeout config
        transaction_timeout: u64,
    ) {
        Self::do_initialize(
            stdlib_version,
            reward_delay,
            total_stc_amount,
            pre_mine_stc_amount,
            time_mint_stc_amount,
            time_mint_stc_period,
            parent_hash,
            association_auth_key,
            genesis_auth_key,
            chain_id,
            genesis_timestamp,
            uncle_rate_target,
            epoch_block_count,
            base_block_time_target,
            base_block_difficulty_window,
            base_reward_per_block,
            base_reward_per_uncle_percent,
            min_block_time_target,
            max_block_time_target,
            base_max_uncles_per_block,
            base_block_gas_limit,
            strategy,
            script_allowed,
            module_publishing_allowed,
            instruction_schedule,
            native_schedule,
            global_memory_per_byte_cost,
            global_memory_per_byte_write_cost,
            min_transaction_gas_units,
            large_transaction_cutoff,
            instrinsic_gas_per_byte,
            maximum_number_of_gas_units,
            min_price_per_gas_unit,
            max_price_per_gas_unit,
            max_transaction_size_in_bytes,
            gas_unit_scaling_factor,
            default_account_size,
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            transaction_timeout,
        );
    }

    fun do_initialize(
        stdlib_version: u64,
        // block reward and stc config
        reward_delay: u64,
        total_stc_amount: u128,
        pre_mine_stc_amount: u128,
        time_mint_stc_amount: u128,
        time_mint_stc_period: u64,
        parent_hash: vector<u8>,
        association_auth_key: vector<u8>,
        genesis_auth_key: vector<u8>,
        chain_id: u8,
        genesis_timestamp: u64,
        //consensus config
        uncle_rate_target: u64,
        epoch_block_count: u64,
        base_block_time_target: u64,
        base_block_difficulty_window: u64,
        base_reward_per_block: u128,
        base_reward_per_uncle_percent: u64,
        min_block_time_target: u64,
        max_block_time_target: u64,
        base_max_uncles_per_block: u64,
        base_block_gas_limit: u64,
        strategy: u8,
        //vm config
        script_allowed: bool,
        module_publishing_allowed: bool,
        instruction_schedule: vector<u8>,
        native_schedule: vector<u8>,
        //gas constants
        global_memory_per_byte_cost: u64,
        global_memory_per_byte_write_cost: u64,
        min_transaction_gas_units: u64,
        large_transaction_cutoff: u64,
        instrinsic_gas_per_byte: u64,
        maximum_number_of_gas_units: u64,
        min_price_per_gas_unit: u64,
        max_price_per_gas_unit: u64,
        max_transaction_size_in_bytes: u64,
        gas_unit_scaling_factor: u64,
        default_account_size: u64,
        // dao config
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        // transaction timeout config
        transaction_timeout: u64,
    ) {
        Timestamp::assert_genesis();
        // create genesis account
        let genesis_account = Account::create_genesis_account(CoreAddresses::GENESIS_ADDRESS());
        //Init global time
        Timestamp::initialize(&genesis_account, genesis_timestamp);
        ChainId::initialize(&genesis_account, chain_id);
        ConsensusStrategy::initialize(&genesis_account, strategy);
        Block::initialize(&genesis_account, parent_hash);
        TransactionPublishOption::initialize(
            &genesis_account,
            script_allowed,
            module_publishing_allowed,
        );
        // init config
        VMConfig::initialize(
            &genesis_account,
            instruction_schedule,
            native_schedule,
            global_memory_per_byte_cost,
            global_memory_per_byte_write_cost,
            min_transaction_gas_units,
            large_transaction_cutoff,
            instrinsic_gas_per_byte,
            maximum_number_of_gas_units,
            min_price_per_gas_unit,
            max_price_per_gas_unit,
            max_transaction_size_in_bytes,
            gas_unit_scaling_factor,
            default_account_size,
        );
        TransactionTimeoutConfig::initialize(&genesis_account, transaction_timeout);
        ConsensusConfig::initialize(
            &genesis_account,
            uncle_rate_target,
            epoch_block_count,
            base_block_time_target,
            base_block_difficulty_window,
            base_reward_per_block,
            base_reward_per_uncle_percent,
            min_block_time_target,
            max_block_time_target,
            base_max_uncles_per_block,
            base_block_gas_limit,
            strategy,
        );
        Epoch::initialize(&genesis_account);
        let association = Account::create_genesis_account(
            CoreAddresses::ASSOCIATION_ROOT_ADDRESS(),
        );
        Config::publish_new_config<Version::Version>(&genesis_account, Version::new_version(stdlib_version));
        // stdlib use two phase upgrade strategy.
        PackageTxnManager::update_module_upgrade_strategy(
            &genesis_account,
            PackageTxnManager::get_strategy_two_phase(),
            Option::some(0u64),
        );
        BlockReward::initialize(&genesis_account, reward_delay);

        // stc should be initialized after genesis_account's module upgrade strategy set and all on chain config init.
        let withdraw_cap = STC::initialize_v3(&genesis_account, total_stc_amount);
        Account::do_accept_token<STC>(&genesis_account);
        Account::do_accept_token<STC>(&association);

        DummyToken::initialize(&genesis_account);

        if (pre_mine_stc_amount > 0) {
            let stc = Treasury::withdraw_with_capability<STC>(&mut withdraw_cap, pre_mine_stc_amount);
            Account::deposit(Signer::address_of(&association), stc);
        };
        if (time_mint_stc_amount > 0) {
            let liner_withdraw_cap = Treasury::issue_linear_withdraw_capability<STC>(&mut withdraw_cap, time_mint_stc_amount, time_mint_stc_period);
            Treasury::add_linear_withdraw_capability(&association, liner_withdraw_cap);
        };

        // Lock the TreasuryWithdrawCapability to Dao
        TreasuryPlugin::delegate_capability<STC>(&genesis_account, withdraw_cap);

        TransactionFee::initialize(&genesis_account);

        // only test/dev network set genesis auth key.
        if (!Vector::is_empty(&genesis_auth_key)) {
            let genesis_rotate_key_cap = Account::extract_key_rotation_capability(&genesis_account);
            Account::rotate_authentication_key_with_capability(&genesis_rotate_key_cap, genesis_auth_key);
            Account::restore_key_rotation_capability(genesis_rotate_key_cap);
        };

        let assoc_rotate_key_cap = Account::extract_key_rotation_capability(&association);
        Account::rotate_authentication_key_with_capability(&assoc_rotate_key_cap, association_auth_key);
        Account::restore_key_rotation_capability(assoc_rotate_key_cap);

        // v5 -> v6
        {
            let cap = Account::remove_signer_capability(&genesis_account);
            GenesisSignerCapability::initialize(&genesis_account, cap);
            //register oracle
            STCUSDOracle::register(&genesis_account);
            let merkle_root = x"5969f0e8e19f8769276fb638e6060d5c02e40088f5fde70a6778dd69d659ee6d";
            let image = b"ipfs://QmSPcvcXgdtHHiVTAAarzTeubk5X3iWymPAoKBfiRFjPMY";
            GenesisNFT::initialize(&genesis_account, merkle_root, 1639u64, image);
        };
        Config::publish_new_config(&genesis_account, LanguageVersion::new(4));

        //v11 -> v12
        Block::checkpoints_init();
        DAORegistry::initialize();

        DAOExtensionPoint::initialize();
        DAOPluginMarketplace::initialize();

        AnyMemberPlugin::initialize(&genesis_account);
        ConfigProposalPlugin::initialize(&genesis_account);
        GrantProposalPlugin::initialize(&genesis_account);
        InstallPluginProposalPlugin::initialize(&genesis_account);
        MemberProposalPlugin::initialize(&genesis_account);
        MintProposalPlugin::initialize(&genesis_account);
        StakeToSBTPlugin::initialize(&genesis_account);
        UpgradeModulePlugin::initialize(&genesis_account);
        GasOracleProposalPlugin::initialize(&genesis_account);
        TreasuryPlugin::initialize(&genesis_account);

        let signer_cap = Account::get_genesis_capability();
        let upgrade_plan_cap = PackageTxnManager::extract_submit_upgrade_plan_cap(&genesis_account);
        StarcoinDAO::create_dao(signer_cap, upgrade_plan_cap, voting_delay, voting_period, voting_quorum_rate, min_action_delay, 1000 * 1000 * 1000 * 1000);

        StarcoinDAO::delegate_config_capability<STC, TransactionPublishOption::TransactionPublishOption>(
            Config::extract_modify_config_capability<TransactionPublishOption::TransactionPublishOption>(&genesis_account));
        StarcoinDAO::delegate_config_capability<STC, VMConfig::VMConfig>(
            Config::extract_modify_config_capability<VMConfig::VMConfig>(&genesis_account));
        StarcoinDAO::delegate_config_capability<STC, ConsensusConfig::ConsensusConfig>(
            Config::extract_modify_config_capability<ConsensusConfig::ConsensusConfig>(&genesis_account));
        StarcoinDAO::delegate_config_capability<STC, RewardConfig::RewardConfig>(
            Config::extract_modify_config_capability<RewardConfig::RewardConfig>(&genesis_account));
        StarcoinDAO::delegate_config_capability<STC, TransactionTimeoutConfig::TransactionTimeoutConfig>(
            Config::extract_modify_config_capability<TransactionTimeoutConfig::TransactionTimeoutConfig>(&genesis_account));
        StarcoinDAO::delegate_config_capability<STC, LanguageVersion::LanguageVersion>(
            Config::extract_modify_config_capability<LanguageVersion::LanguageVersion>(&genesis_account));
        StarcoinDAO::set_treasury_withdraw_proposal_scale(100);

        // v12 -> v13
        WithdrawPlugin::initialize(&genesis_account);
        StarcoinDAO::upgrade_dao();
        //Start time, Timestamp::is_genesis() will return false. this call should at the end of genesis init.
        Timestamp::set_time_has_started(&genesis_account);
        Account::release_genesis_signer(genesis_account);
        Account::release_genesis_signer(association);
    }

    /// Init the genesis for unit tests
    public fun initialize_for_unit_tests() {
        let stdlib_version: u64 = 6;
        let reward_delay: u64 = 7;
        let total_stc_amount: u128 = 3185136000000000000u128;
        let pre_mine_stc_amount: u128 = 159256800000000000u128;
        let time_mint_stc_amount: u128 = (85043130u128 * 3u128 + 74213670u128 * 3u128) * 1000000000u128;
        let time_mint_stc_period: u64 = 1000000000;

        let parent_hash: vector<u8> = x"0000000000000000000000000000000000000000000000000000000000000000";
        let association_auth_key: vector<u8> = x"0000000000000000000000000000000000000000000000000000000000000000";
        let genesis_auth_key: vector<u8> = x"0000000000000000000000000000000000000000000000000000000000000000";
        let chain_id: u8 = 255;
        let genesis_timestamp: u64 = 0;

        //consensus config
        let uncle_rate_target: u64 = 80;
        let epoch_block_count: u64 = 240;
        let base_block_time_target: u64 = 10000;
        let base_block_difficulty_window: u64 = 24;
        let base_reward_per_block: u128 = 1000000000;
        let base_reward_per_uncle_percent: u64 = 10;
        let min_block_time_target: u64 = 1000;
        let max_block_time_target: u64 = 20000;
        let base_max_uncles_per_block: u64 = 2;
        let base_block_gas_limit: u64 = 500000000;
        let strategy: u8 = 0;

        //vm config
        let script_allowed: bool = true;
        let module_publishing_allowed: bool = true;
        //TODO init the gas table.
        let instruction_schedule: vector<u8> = Vector::empty();
        let native_schedule: vector<u8> = Vector::empty();

        //gas constants
        let global_memory_per_byte_cost: u64 = 1;
        let global_memory_per_byte_write_cost: u64 = 1;
        let min_transaction_gas_units: u64 = 1;
        let large_transaction_cutoff: u64 = 1;
        let instrinsic_gas_per_byte: u64 = 1;
        let maximum_number_of_gas_units: u64 = 1;
        let min_price_per_gas_unit: u64 = 1;
        let max_price_per_gas_unit: u64 = 10000;
        let max_transaction_size_in_bytes: u64 = 1024 * 1024;
        let gas_unit_scaling_factor: u64 = 1;
        let default_account_size: u64 = 600;

        // dao config
        let voting_delay: u64 = 1000;
        let voting_period: u64 = 6000;
        let voting_quorum_rate: u8 = 4;
        let min_action_delay: u64 = 1000;

        // transaction timeout config
        let transaction_timeout: u64 = 10000;

        Self::do_initialize(
            stdlib_version,
            reward_delay,
            total_stc_amount,
            pre_mine_stc_amount,
            time_mint_stc_amount,
            time_mint_stc_period,
            parent_hash,
            association_auth_key,
            genesis_auth_key,
            chain_id,
            genesis_timestamp,
            uncle_rate_target,
            epoch_block_count,
            base_block_time_target,
            base_block_difficulty_window,
            base_reward_per_block,
            base_reward_per_uncle_percent,
            min_block_time_target,
            max_block_time_target,
            base_max_uncles_per_block,
            base_block_gas_limit,
            strategy,
            script_allowed,
            module_publishing_allowed,
            instruction_schedule,
            native_schedule,
            global_memory_per_byte_cost,
            global_memory_per_byte_write_cost,
            min_transaction_gas_units,
            large_transaction_cutoff,
            instrinsic_gas_per_byte,
            maximum_number_of_gas_units,
            min_price_per_gas_unit,
            max_price_per_gas_unit,
            max_transaction_size_in_bytes,
            gas_unit_scaling_factor,
            default_account_size,
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            transaction_timeout,
        );
    }
}
