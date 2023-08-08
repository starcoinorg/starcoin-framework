//# init -n dev

//# faucet --addr alice

//# faucet --addr bob

//# faucet --addr lili

//# publish
module alice::STAR {
    struct STAR has store, copy, drop {}
}

//# run --signers alice
script {
    use StarcoinFramework::EasyGas;
    fun main(signer: signer) {
        EasyGas::initialize(&signer, @alice, b"STAR", b"STAR", @bob);
    }
}

//# run --signers bob
script {
    use alice::STAR::STAR;
    use StarcoinFramework::EasyGas;

    fun main(signer: signer) {
        EasyGas::register_oracle<STAR>(&signer, 9);
        EasyGas::init_oracle_source<STAR>(&signer, 0);
        EasyGas::update_oracle<STAR>(&signer, 100);
        let star_price= EasyGas::gas_oracle_read<STAR>();
        assert!(star_price==100,1000);
    }
}