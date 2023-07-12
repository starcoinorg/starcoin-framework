//# init -n dev

//# faucet --addr alice

//# run --signers alice
script {
    use StarcoinFramework::GasSchedule;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Config;

    fun main() {
        assert!(Config::config_exist_by_address<GasSchedule::GasSchedule>(CoreAddresses::GENESIS_ADDRESS()), 0);
    }
}
