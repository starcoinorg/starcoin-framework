//# init -n dev

//# faucet --addr alice --amount 100000000000000000

//# run --signers alice
script {
    use StarcoinFramework::Epoch;

    fun epoch_data() {
        // default value should be consistent with genesis config
        let default_block_gas_limit = 50000000*10;
        let default_number = 0;
        let default_start_block_number = 0;
        let default_end_block_number = 50 * 2;
        let default_start_time = 0;
        let default_total_gas = 0;
        let default_uncles = 0;
        let default_max_transaction_per_block = 700;
        let block_gas_limit = Epoch::block_gas_limit();
        let number = Epoch::number();
        let start_block_number = Epoch::start_block_number();
        let end_block_number = Epoch::end_block_number();
        let start_time = Epoch::start_time();
        let total_gas = Epoch::total_gas();
        let uncles = Epoch::uncles();
        let max_transaction_per_block = Epoch::max_transaction_per_block();

        assert!(block_gas_limit == default_block_gas_limit, 101);
        assert!(number == default_number, 103);
        assert!(start_block_number == default_start_block_number, 104);
        assert!(end_block_number == default_end_block_number, 105);
        assert!(start_time == default_start_time, 106);
        assert!(total_gas == default_total_gas, 107);
        assert!(uncles == default_uncles, 108);
        assert!(max_transaction_per_block == default_max_transaction_per_block, 109);
    }
}
