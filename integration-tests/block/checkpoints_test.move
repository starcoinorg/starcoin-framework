//# init -n dev --debug

//# faucet --addr alice

//# block --author=0x2 --timestamp 86420000

//# call-api chain.info

//# run --signers alice --args {{$.call-api[0].head.parent_hash}} --args {{$.call-api[0].head.state_root}}
script {
    use StarcoinFramework::Block;
    use StarcoinFramework::Debug;

    fun checkpoint(_account: signer, parent_hash: vector<u8>, state_root: vector<u8>) {
        let expect_parent_hash = Block::get_parent_hash();
        Debug::print(&expect_parent_hash);
        Debug::print(&parent_hash);
        Debug::print(&state_root);
        assert!( expect_parent_hash == parent_hash, 1001);

        let current_block_number = Block::get_current_block_number();
        Debug::print(&current_block_number);

        Block::checkpoint();
    }
}
// check: EXECUTED

//# block --author=0x2 --timestamp 86430000

//# call-api chain.get_block_by_hash ["{{$.call-api[0].head.block_hash}}",{"raw":true}]

//# run --signers alice  --args {{$.call-api[1].raw.header}}

script {
    use StarcoinFramework::Block;
    use StarcoinFramework::Debug;

    fun update(_account: signer, raw_header: vector<u8>) {
        let current_block_number = Block::get_current_block_number();
        Debug::print(&current_block_number);
        Debug::print(&raw_header);
        Block::update_state_root(raw_header);
    }
}
// check: EXECUTED




////# call-api chain.get_block_by_number [(2-1),{"raw":true}]
//# call-api chain.get_block_by_number ["{{$.call-api[0].head.number}}u64",{"raw":true}]

//# run --signers alice  --args x"01"

////# run --signers alice  --args {{$.call-api[1].raw.header}}

script {
//    use StarcoinFramework::Block;
    use StarcoinFramework::Debug;

    fun update(_account: signer, raw_header: vector<u8>) {
        Debug::print(&raw_header);
//        Block::update_state_root(raw_header);
    }
}
// check: EXECUTED

////# block --author=0x3
//
////# call-api chain.get_block_by_hash ["{{$.call-api[0].head.parent_hash}}",{"raw":true}]
//
////# run --signers alice  --args {{$.call-api[1].raw.header}}
//
//script {
//    use StarcoinFramework::Block;
//    use StarcoinFramework::Debug;
//
//    fun update(_account: signer, raw_header: vector<u8>) {
//        Debug::print(&raw_header);
//        Block::update_state_root(raw_header);
//    }
//}
//// check: EXECUTED

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