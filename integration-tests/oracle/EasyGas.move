//# init -n dev

//# faucet --addr alice

//# faucet --addr bob

//# publish
module alice::STAR {
    struct STAR has store, copy, drop {}
}

//# run --signers alice
script {
    use StarcoinFramework::EasyGasOracle;

    fun main(signer: signer) {
        EasyGasOracle::register_gas_token_entry(&signer, @alice, b"STAR", b"STAR", @bob);
    }
}

//# run --signers bob
script {
    use alice::STAR::STAR;
    use StarcoinFramework::EasyGasOracle;

    fun main(signer: signer) {
        EasyGasOracle::register<STAR>(&signer, 9);
        EasyGasOracle::init_data_source<STAR>(&signer, 0);
        EasyGasOracle::update<STAR>(&signer, 100);
        let star_price= EasyGasOracle::gas_oracle_read<STAR>();
        assert!(star_price==100,1000);
    }
}