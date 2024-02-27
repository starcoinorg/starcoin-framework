//# init -n dev

//# faucet --addr alice

//# run --signers alice
script {
    use StarcoinFramework::Option;
    use StarcoinFramework::Block;
    use StarcoinFramework::Debug;

    fun get_parent_hash(_account: signer) {
        let hash = Block::get_parent_hash();
        Debug::print<vector<u8>>(&hash);
    }

    fun get_parents_hash(_account: signer) {
        let hash = Block::get_parents_hash();
        Debug::print<Option::Option<vector<u8>>>(&hash);
    }
}
// check: EXECUTED
