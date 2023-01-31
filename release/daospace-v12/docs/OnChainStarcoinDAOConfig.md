
<a name="0x1_OnChainStarcoinDAOConfig"></a>

# Module `0x1::OnChainStarcoinDAOConfig`



-  [Function `propose_update_consensus_config`](#0x1_OnChainStarcoinDAOConfig_propose_update_consensus_config)
-  [Function `propose_update_consensus_config_entry`](#0x1_OnChainStarcoinDAOConfig_propose_update_consensus_config_entry)
-  [Function `propose_update_reward_config`](#0x1_OnChainStarcoinDAOConfig_propose_update_reward_config)
-  [Function `propose_update_reward_config_entry`](#0x1_OnChainStarcoinDAOConfig_propose_update_reward_config_entry)
-  [Function `propose_update_txn_publish_option`](#0x1_OnChainStarcoinDAOConfig_propose_update_txn_publish_option)
-  [Function `propose_update_txn_publish_option_entry`](#0x1_OnChainStarcoinDAOConfig_propose_update_txn_publish_option_entry)
-  [Function `propose_update_txn_timeout_config`](#0x1_OnChainStarcoinDAOConfig_propose_update_txn_timeout_config)
-  [Function `propose_update_txn_timeout_config_entry`](#0x1_OnChainStarcoinDAOConfig_propose_update_txn_timeout_config_entry)
-  [Function `propose_update_vm_config`](#0x1_OnChainStarcoinDAOConfig_propose_update_vm_config)
-  [Function `propose_update_vm_config_entry`](#0x1_OnChainStarcoinDAOConfig_propose_update_vm_config_entry)
-  [Function `propose_update_move_language_version`](#0x1_OnChainStarcoinDAOConfig_propose_update_move_language_version)
-  [Function `propose_update_move_language_version_entry`](#0x1_OnChainStarcoinDAOConfig_propose_update_move_language_version_entry)


<pre><code><b>use</b> <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin">0x1::ConfigProposalPlugin</a>;
<b>use</b> <a href="ConsensusConfig.md#0x1_ConsensusConfig">0x1::ConsensusConfig</a>;
<b>use</b> <a href="LanguageVersion.md#0x1_LanguageVersion">0x1::LanguageVersion</a>;
<b>use</b> <a href="RewardConfig.md#0x1_RewardConfig">0x1::RewardConfig</a>;
<b>use</b> <a href="StarcoinDAO.md#0x1_StarcoinDAO">0x1::StarcoinDAO</a>;
<b>use</b> <a href="TransactionPublishOption.md#0x1_TransactionPublishOption">0x1::TransactionPublishOption</a>;
<b>use</b> <a href="TransactionTimeoutConfig.md#0x1_TransactionTimeoutConfig">0x1::TransactionTimeoutConfig</a>;
<b>use</b> <a href="VMConfig.md#0x1_VMConfig">0x1::VMConfig</a>;
</code></pre>



<a name="0x1_OnChainStarcoinDAOConfig_propose_update_consensus_config"></a>

## Function `propose_update_consensus_config`



<pre><code><b>public</b> <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_consensus_config">propose_update_consensus_config</a>(account: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, uncle_rate_target: u64, base_block_time_target: u64, base_reward_per_block: u128, base_reward_per_uncle_percent: u64, epoch_block_count: u64, base_block_difficulty_window: u64, min_block_time_target: u64, max_block_time_target: u64, base_max_uncles_per_block: u64, base_block_gas_limit: u64, strategy: u8, exec_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_consensus_config">propose_update_consensus_config</a>(account: &signer,
                                            title:vector&lt;u8&gt;,
                                            introduction:vector&lt;u8&gt;,
                                            description: vector&lt;u8&gt;,
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
    <b>let</b> consensus_config = <a href="ConsensusConfig.md#0x1_ConsensusConfig_new_consensus_config">ConsensusConfig::new_consensus_config</a>(uncle_rate_target,
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
    <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_create_proposal">ConfigProposalPlugin::create_proposal</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="ConsensusConfig.md#0x1_ConsensusConfig_ConsensusConfig">ConsensusConfig::ConsensusConfig</a>&gt;(account, title, introduction, description, exec_delay, consensus_config);
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_OnChainStarcoinDAOConfig_propose_update_consensus_config_entry"></a>

## Function `propose_update_consensus_config_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_consensus_config_entry">propose_update_consensus_config_entry</a>(account: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, uncle_rate_target: u64, base_block_time_target: u64, base_reward_per_block: u128, base_reward_per_uncle_percent: u64, epoch_block_count: u64, base_block_difficulty_window: u64, min_block_time_target: u64, max_block_time_target: u64, base_max_uncles_per_block: u64, base_block_gas_limit: u64, strategy: u8, exec_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> ( <b>script</b> ) <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_consensus_config_entry">propose_update_consensus_config_entry</a>(account: signer,
                                                        title:vector&lt;u8&gt;,
                                                        introduction:vector&lt;u8&gt;,
                                                        description: vector&lt;u8&gt;,
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
    <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_consensus_config">propose_update_consensus_config</a>(&account,
                                    title,
                                    introduction,
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
</code></pre>



</details>

<a name="0x1_OnChainStarcoinDAOConfig_propose_update_reward_config"></a>

## Function `propose_update_reward_config`



<pre><code><b>public</b> <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_reward_config">propose_update_reward_config</a>(account: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, reward_delay: u64, exec_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_reward_config">propose_update_reward_config</a>(account: &signer,
                                            title:vector&lt;u8&gt;,
                                            introduction:vector&lt;u8&gt;,
                                            description: vector&lt;u8&gt;,
                                            reward_delay: u64,
                                            exec_delay: u64) {
    <b>let</b> reward_config = <a href="RewardConfig.md#0x1_RewardConfig_new_reward_config">RewardConfig::new_reward_config</a>(reward_delay);
    <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_create_proposal">ConfigProposalPlugin::create_proposal</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="RewardConfig.md#0x1_RewardConfig_RewardConfig">RewardConfig::RewardConfig</a>&gt;(account, title, introduction, description, exec_delay, reward_config);
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_OnChainStarcoinDAOConfig_propose_update_reward_config_entry"></a>

## Function `propose_update_reward_config_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_reward_config_entry">propose_update_reward_config_entry</a>(account: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, reward_delay: u64, exec_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> ( <b>script</b> ) <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_reward_config_entry">propose_update_reward_config_entry</a>(account: signer,
                                                            title:vector&lt;u8&gt;,
                                                            introduction:vector&lt;u8&gt;,
                                                            description: vector&lt;u8&gt;,
                                                            reward_delay: u64,
                                                            exec_delay: u64) {
    <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_reward_config">propose_update_reward_config</a>(&account, title, introduction, description, reward_delay, exec_delay);
}
</code></pre>



</details>

<a name="0x1_OnChainStarcoinDAOConfig_propose_update_txn_publish_option"></a>

## Function `propose_update_txn_publish_option`



<pre><code><b>public</b> <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_txn_publish_option">propose_update_txn_publish_option</a>(account: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, script_allowed: bool, module_publishing_allowed: bool, exec_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_txn_publish_option">propose_update_txn_publish_option</a>(account: &signer,
                                                title:vector&lt;u8&gt;,
                                                introduction:vector&lt;u8&gt;,
                                                description: vector&lt;u8&gt;,
                                                script_allowed: bool,
                                                module_publishing_allowed: bool,
                                                exec_delay: u64) {
    <b>let</b> txn_publish_option = <a href="TransactionPublishOption.md#0x1_TransactionPublishOption_new_transaction_publish_option">TransactionPublishOption::new_transaction_publish_option</a>(script_allowed, module_publishing_allowed);
    <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_create_proposal">ConfigProposalPlugin::create_proposal</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="TransactionPublishOption.md#0x1_TransactionPublishOption_TransactionPublishOption">TransactionPublishOption::TransactionPublishOption</a>&gt;(account, title, introduction, description, exec_delay, txn_publish_option);
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_OnChainStarcoinDAOConfig_propose_update_txn_publish_option_entry"></a>

## Function `propose_update_txn_publish_option_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_txn_publish_option_entry">propose_update_txn_publish_option_entry</a>(account: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, script_allowed: bool, module_publishing_allowed: bool, exec_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> ( <b>script</b> ) <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_txn_publish_option_entry">propose_update_txn_publish_option_entry</a>(account: signer,
                                                                title:vector&lt;u8&gt;,
                                                                introduction:vector&lt;u8&gt;,
                                                                description: vector&lt;u8&gt;,
                                                                script_allowed: bool,
                                                                module_publishing_allowed: bool,
                                                                exec_delay: u64) {
    <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_txn_publish_option">propose_update_txn_publish_option</a>(&account, title, introduction, description, script_allowed, module_publishing_allowed, exec_delay);
}
</code></pre>



</details>

<a name="0x1_OnChainStarcoinDAOConfig_propose_update_txn_timeout_config"></a>

## Function `propose_update_txn_timeout_config`



<pre><code><b>public</b> <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_txn_timeout_config">propose_update_txn_timeout_config</a>(account: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, duration_seconds: u64, exec_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_txn_timeout_config">propose_update_txn_timeout_config</a>(account: &signer,
                                                title:vector&lt;u8&gt;,
                                                introduction:vector&lt;u8&gt;,
                                                description: vector&lt;u8&gt;,
                                                duration_seconds: u64,
                                                exec_delay: u64) {
    <b>let</b> txn_timeout_config = <a href="TransactionTimeoutConfig.md#0x1_TransactionTimeoutConfig_new_transaction_timeout_config">TransactionTimeoutConfig::new_transaction_timeout_config</a>(duration_seconds);
    <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_create_proposal">ConfigProposalPlugin::create_proposal</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="TransactionTimeoutConfig.md#0x1_TransactionTimeoutConfig_TransactionTimeoutConfig">TransactionTimeoutConfig::TransactionTimeoutConfig</a>&gt;(account, title, introduction, description, exec_delay, txn_timeout_config);
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_OnChainStarcoinDAOConfig_propose_update_txn_timeout_config_entry"></a>

## Function `propose_update_txn_timeout_config_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_txn_timeout_config_entry">propose_update_txn_timeout_config_entry</a>(account: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, duration_seconds: u64, exec_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> ( <b>script</b> ) <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_txn_timeout_config_entry">propose_update_txn_timeout_config_entry</a>(account: signer,
                                                                title:vector&lt;u8&gt;,
                                                                introduction:vector&lt;u8&gt;,
                                                                description: vector&lt;u8&gt;,
                                                                duration_seconds: u64,
                                                                exec_delay: u64) {
    <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_txn_timeout_config">propose_update_txn_timeout_config</a>(&account, title, introduction,description,duration_seconds,exec_delay);
}
</code></pre>



</details>

<a name="0x1_OnChainStarcoinDAOConfig_propose_update_vm_config"></a>

## Function `propose_update_vm_config`



<pre><code><b>public</b> <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_vm_config">propose_update_vm_config</a>(account: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, instruction_schedule: vector&lt;u8&gt;, native_schedule: vector&lt;u8&gt;, global_memory_per_byte_cost: u64, global_memory_per_byte_write_cost: u64, min_transaction_gas_units: u64, large_transaction_cutoff: u64, instrinsic_gas_per_byte: u64, maximum_number_of_gas_units: u64, min_price_per_gas_unit: u64, max_price_per_gas_unit: u64, max_transaction_size_in_bytes: u64, gas_unit_scaling_factor: u64, default_account_size: u64, exec_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_vm_config">propose_update_vm_config</a>(account: &signer,
                                        title:vector&lt;u8&gt;,
                                        introduction:vector&lt;u8&gt;,
                                        description: vector&lt;u8&gt;,
                                        instruction_schedule: vector&lt;u8&gt;,
                                        native_schedule: vector&lt;u8&gt;,
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
    <b>let</b> vm_config = <a href="VMConfig.md#0x1_VMConfig_new_vm_config">VMConfig::new_vm_config</a>(instruction_schedule,
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
    <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_create_proposal">ConfigProposalPlugin::create_proposal</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="VMConfig.md#0x1_VMConfig_VMConfig">VMConfig::VMConfig</a>&gt;(account, title, introduction, description, exec_delay, vm_config);
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> verify = <b>false</b>;
</code></pre>



</details>

<a name="0x1_OnChainStarcoinDAOConfig_propose_update_vm_config_entry"></a>

## Function `propose_update_vm_config_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_vm_config_entry">propose_update_vm_config_entry</a>(account: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, instruction_schedule: vector&lt;u8&gt;, native_schedule: vector&lt;u8&gt;, global_memory_per_byte_cost: u64, global_memory_per_byte_write_cost: u64, min_transaction_gas_units: u64, large_transaction_cutoff: u64, instrinsic_gas_per_byte: u64, maximum_number_of_gas_units: u64, min_price_per_gas_unit: u64, max_price_per_gas_unit: u64, max_transaction_size_in_bytes: u64, gas_unit_scaling_factor: u64, default_account_size: u64, exec_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> (<b>script</b>) <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_vm_config_entry">propose_update_vm_config_entry</a>(account: signer,
                                                        title:vector&lt;u8&gt;,
                                                        introduction:vector&lt;u8&gt;,
                                                        description: vector&lt;u8&gt;,
                                                        instruction_schedule: vector&lt;u8&gt;,
                                                        native_schedule: vector&lt;u8&gt;,
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
    <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_vm_config">propose_update_vm_config</a>(&account,
                            title,
                            introduction,
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
</code></pre>



</details>

<a name="0x1_OnChainStarcoinDAOConfig_propose_update_move_language_version"></a>

## Function `propose_update_move_language_version`



<pre><code><b>public</b> <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_move_language_version">propose_update_move_language_version</a>(account: &signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, new_version: u64, exec_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_move_language_version">propose_update_move_language_version</a>(account: &signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, description: vector&lt;u8&gt;, new_version: u64, exec_delay: u64) {
    <b>let</b> lang_version = <a href="LanguageVersion.md#0x1_LanguageVersion_new">LanguageVersion::new</a>(new_version);
    <a href="ConfigProposalPlugin.md#0x1_ConfigProposalPlugin_create_proposal">ConfigProposalPlugin::create_proposal</a>&lt;<a href="StarcoinDAO.md#0x1_StarcoinDAO">StarcoinDAO</a>, <a href="LanguageVersion.md#0x1_LanguageVersion_LanguageVersion">LanguageVersion::LanguageVersion</a>&gt;(account, title, introduction, description, exec_delay, lang_version);
}
</code></pre>



</details>

<a name="0x1_OnChainStarcoinDAOConfig_propose_update_move_language_version_entry"></a>

## Function `propose_update_move_language_version_entry`



<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_move_language_version_entry">propose_update_move_language_version_entry</a>(account: signer, title: vector&lt;u8&gt;, introduction: vector&lt;u8&gt;, description: vector&lt;u8&gt;, new_version: u64, exec_delay: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>script</b>) <b>fun</b> <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_move_language_version_entry">propose_update_move_language_version_entry</a>(account: signer, title:vector&lt;u8&gt;, introduction:vector&lt;u8&gt;, description: vector&lt;u8&gt;, new_version: u64, exec_delay: u64) {
    <a href="OnChainStarcoinDAOConfig.md#0x1_OnChainStarcoinDAOConfig_propose_update_move_language_version">propose_update_move_language_version</a>(&account, title, introduction, description, new_version, exec_delay);
}
</code></pre>



</details>
