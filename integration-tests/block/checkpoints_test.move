//# init -n dev 

//# faucet --addr alice

//# block --author=0x2

//# call-api chain.info

//# run --signers alice --args {{$.call-api[0].head.number}}u64
script {
    use StarcoinFramework::Block;
    use StarcoinFramework::Debug;

    fun checkpoint(_account: signer, block_number: u64) {
        let parent_block_number = Block::get_current_block_number() - 1;
        let expect_block_number= (block_number - 1);
        Debug::print(&parent_block_number);
        Debug::print(&expect_block_number);
        assert!( expect_block_number == parent_block_number, 1001);
        Block::checkpoint();
    }
}
// check: EXECUTED

//# call-api chain.get_block_by_hash ["{{$.call-api[0].head.parent_hash}}",{"raw":true}]

//# run --signers alice  --args -x"{{$.call-api[1].raw.header}}"

script {
    use StarcoinFramework::Block;
    use StarcoinFramework::Debug;

    fun update(_account: signer, raw_header: vector<u8>) {
        Debug::print(&raw_header);
        Block::update_state_root(raw_header);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use StarcoinFramework::Block;
    use StarcoinFramework::Debug;

    fun latest(_account: signer) {
        let (number ,state_root) = Block::latest_state_root();
        Debug::print(&number);
        Debug::print(&state_root);
    }

}
// check: EXECUTED