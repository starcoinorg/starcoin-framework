//# init -n dev --addresses alice=0x1

//# faucet --addr alice --amount 1000000000

//# run --signers alice 
script {
    use StarcoinFramework::GasSchedule;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Config;

    fun main(genesis_account: signer) {
        GasSchedule::initialize(&genesis_account, GasSchedule::new_gas_schedule_for_test());
        assert!(Config::config_exist_by_address<GasSchedule::GasSchedule>(CoreAddresses::GENESIS_ADDRESS()), 0);
    }
}
