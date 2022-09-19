//# init -n dev

//# faucet --addr alice --amount 100000000000000000

//# faucet --addr bob

//# run --signers alice
script {
    use StarcoinFramework::Config;
    use StarcoinFramework::Version;
    use StarcoinFramework::PackageTxnManager;
    use StarcoinFramework::Option;
    fun main(account: signer) {
        Config::publish_new_config<Version::Version>(&account, Version::new_version(1));
        PackageTxnManager::update_module_upgrade_strategy(&account, PackageTxnManager::get_strategy_new_module(), Option::some<u64>(2));
    }
}
// check: EXECUTED

//# package
module alice::hello {
    public fun hello() {}
}
//# deploy {{$.package[0].file}} --signers alice

//# run --signers alice
script {
    use alice::hello;

    fun main(_account: signer) {
        hello::hello();
    }
}
// check: EXECUTED

//# package
module alice::hello {
    public fun hello() {}
    public fun hello_bob() {}
}

//# deploy {{$.package[1].file}} --signers alice

//# package
module alice::say {
    public fun hello() {}
}

//# deploy {{$.package[2].file}} --signers alice