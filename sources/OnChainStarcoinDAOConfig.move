module StarcoinFramework::OnChainStarcoinDAOConfig {
    use StarcoinFramework::ConsensusConfig;
    use StarcoinFramework::RewardConfig;
    use StarcoinFramework::TransactionPublishOption;
    use StarcoinFramework::TransactionTimeoutConfig;
    use StarcoinFramework::VMConfig;
    use StarcoinFramework::LanguageVersion;
    use StarcoinFramework::StarcoinDAO::StarcoinDAO;
    use StarcoinFramework::ConfigProposalPlugin;

    public fun propose_update_consensus_config(account: &signer,
                                                            description: vector<u8>,
                                                            uncle_rate_target: u64,
                                                            base_block_time_target: u64,
                                                            base_reward_per_block: u128,
                                                            base_reward_per_uncle_percent: u64,
                                                            epoch_block_count: u64,
                                                            base_block_difficulty_window: u64,
                                                            min_block_time_target: u64,
                                                            max_block_time_target: u64,
                                                            base_max_uncles_per_block: u64,
                                                            base_block_gas_limit: u64,
                                                            strategy: u8,
                                                            exec_delay: u64) {
        let consensus_config = ConsensusConfig::new_consensus_config(uncle_rate_target,
            base_block_time_target,
            base_reward_per_block,
            base_reward_per_uncle_percent,
            epoch_block_count,
            base_block_difficulty_window,
            min_block_time_target,
            max_block_time_target,
            base_max_uncles_per_block,
            base_block_gas_limit,
            strategy);
        ConfigProposalPlugin::create_proposal<StarcoinDAO, ConsensusConfig::ConsensusConfig>(account, description, exec_delay, consensus_config);
    }

    public ( script ) fun propose_update_consensus_config_entry(account: signer,
                                                            description: vector<u8>,
                                                            uncle_rate_target: u64,
                                                            base_block_time_target: u64,
                                                            base_reward_per_block: u128,
                                                            base_reward_per_uncle_percent: u64,
                                                            epoch_block_count: u64,
                                                            base_block_difficulty_window: u64,
                                                            min_block_time_target: u64,
                                                            max_block_time_target: u64,
                                                            base_max_uncles_per_block: u64,
                                                            base_block_gas_limit: u64,
                                                            strategy: u8,
                                                            exec_delay: u64) {
        propose_update_consensus_config(&account,
                                        description,
                                        uncle_rate_target,
                                        base_block_time_target,
                                        base_reward_per_block,
                                        base_reward_per_uncle_percent,
                                        epoch_block_count,
                                        base_block_difficulty_window,
                                        min_block_time_target,
                                        max_block_time_target,
                                        base_max_uncles_per_block,
                                        base_block_gas_limit,
                                        strategy,
                                        exec_delay);
    }

    spec propose_update_consensus_config {
        pragma verify = false;
    }

    public fun propose_update_reward_config(account: &signer,
                                                description: vector<u8>,
                                                reward_delay: u64,
                                                exec_delay: u64) {
        let reward_config = RewardConfig::new_reward_config(reward_delay);
        ConfigProposalPlugin::create_proposal<StarcoinDAO, RewardConfig::RewardConfig>(account, description, exec_delay, reward_config);
    }
    
    public ( script ) fun propose_update_reward_config_entry(account: signer,
                                                        description: vector<u8>,
                                                        reward_delay: u64,
                                                        exec_delay: u64) {
        propose_update_reward_config(&account, description, reward_delay, exec_delay);                                           
    }
    spec propose_update_reward_config {
        pragma verify = false;
    }

    public fun propose_update_txn_publish_option(account: &signer,
                                                            description: vector<u8>,
                                                            script_allowed: bool,
                                                            module_publishing_allowed: bool,
                                                            exec_delay: u64) {
        let txn_publish_option = TransactionPublishOption::new_transaction_publish_option(script_allowed, module_publishing_allowed);
        ConfigProposalPlugin::create_proposal<StarcoinDAO, TransactionPublishOption::TransactionPublishOption>(account, description, exec_delay, txn_publish_option);
    }

    public ( script ) fun propose_update_txn_publish_option_entry(account: signer,
                                                            description: vector<u8>,
                                                            script_allowed: bool,
                                                            module_publishing_allowed: bool,
                                                            exec_delay: u64) {
        propose_update_txn_publish_option(&account, description, script_allowed, module_publishing_allowed, exec_delay);
    }
    spec propose_update_txn_publish_option {
        pragma verify = false;
    }

    public fun propose_update_txn_timeout_config(account: &signer,
                                                            description: vector<u8>,
                                                            duration_seconds: u64,
                                                            exec_delay: u64) {
        let txn_timeout_config = TransactionTimeoutConfig::new_transaction_timeout_config(duration_seconds);
        ConfigProposalPlugin::create_proposal<StarcoinDAO, TransactionTimeoutConfig::TransactionTimeoutConfig>(account, description, exec_delay, txn_timeout_config);
    }

    public ( script ) fun propose_update_txn_timeout_config_entry(account: signer,
                                                            description: vector<u8>,
                                                            duration_seconds: u64,
                                                            exec_delay: u64) {
        propose_update_txn_timeout_config(&account,description,duration_seconds,exec_delay);
    }

    spec propose_update_txn_timeout_config {
        pragma verify = false;
    }

    public fun propose_update_vm_config(account: &signer,
                                                    description: vector<u8>,
                                                    instruction_schedule: vector<u8>,
                                                    native_schedule: vector<u8>,
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
                                                    exec_delay: u64, ) {
        let vm_config = VMConfig::new_vm_config(instruction_schedule,
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
            default_account_size);
        ConfigProposalPlugin::create_proposal<StarcoinDAO, VMConfig::VMConfig>(account, description, exec_delay, vm_config);
    }

    public (script) fun propose_update_vm_config_entry(account: signer,
                                                    description: vector<u8>,
                                                    instruction_schedule: vector<u8>,
                                                    native_schedule: vector<u8>,
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
                                                    exec_delay: u64, ) {
        propose_update_vm_config(&account,
                                description,
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
                                exec_delay) ;                                  
    }

    spec propose_update_vm_config {
        pragma verify = false;
    }

    public fun propose_update_move_language_version(account: &signer, description: vector<u8>, new_version: u64, exec_delay: u64) {
        let lang_version = LanguageVersion::new(new_version);
        ConfigProposalPlugin::create_proposal<StarcoinDAO, LanguageVersion::LanguageVersion>(account, description, exec_delay, lang_version);
    }

    public(script) fun propose_update_move_language_version_entry(account: signer, description: vector<u8>, new_version: u64, exec_delay: u64) {
        propose_update_move_language_version(&account, description, new_version, exec_delay);
    }
}