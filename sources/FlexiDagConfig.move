address StarcoinFramework {
    module FlexiDagConfig {

        use StarcoinFramework::Config;
        use StarcoinFramework::CoreAddresses;
        use StarcoinFramework::Signer;

        spec module {
            pragma verify = false;
            pragma aborts_if_is_strict;
        }

        /// The struct to hold all config data needed for Flexidag.
        struct FlexiDagConfig has copy, drop, store {
            // todo: double check, epoch might be better?
            // the height of dag genesis block
            effective_height:  u64,
        }

        /// Create a new configuration for flexidag, mainly used in DAO.
        public fun new_flexidag_config(effective_height: u64): FlexiDagConfig {
            FlexiDagConfig {
                effective_height,
            }
        }

        public fun initialize(account: &signer, effective_height: u64) {
            CoreAddresses::assert_genesis_address(account);
            Config::publish_new_config<FlexiDagConfig>(account, new_flexidag_config(effective_height));
        }

        spec initialize {
            aborts_if Signer::address_of(account) != CoreAddresses::GENESIS_ADDRESS();
            aborts_if exists<Config::Config<FlexiDagConfig>>(Signer::address_of(account));
            aborts_if exists<Config::ModifyConfigCapabilityHolder<FlexiDagConfig>>(Signer::address_of(account));
            ensures exists<Config::Config<FlexiDagConfig>>(Signer::address_of(account));
            ensures
                exists<Config::ModifyConfigCapabilityHolder<FlexiDagConfig>>(
                    Signer::address_of(account),
                );
        }

        public fun effective_height(account: address): u64 {
            let flexi_dag_config = Config::get_by_address<FlexiDagConfig>(account);
            flexi_dag_config.effective_height
        }

        spec effective_height {
            include Config::AbortsIfConfigNotExist<FlexiDagConfig> { addr: account };
        }
    }
}
