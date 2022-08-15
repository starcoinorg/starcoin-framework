//# init -n dev --debug

//# faucet --addr creator --amount 100000000000

//# block --author=0x2


//# call-api chain.info

//# run --signers creator --args {{$.call-api[0].head.number}}u64
script{
    use StarcoinFramework::Debug;
    fun main(_sender: signer, block_number: u64){
//        assert!(block_number == 1, 1000);
        Debug::print(&block_number);
    }
}

//# call-api chain.get_block_by_hash ["{{$.call-api[0].block_info.block_hash}}"]


//# run --signers creator --args {{$.call-api[1].header.number}}u64  --args {{$.call-api[1].header.block_hash}}
script{
    use StarcoinFramework::Vector;
    use StarcoinFramework::Debug;
    fun main(_sender: signer, block_number: u64, block_hash: vector<u8>){
//        assert!(block_number == 2, 1001);
        Debug::print(&block_number);
        Debug::print(&block_hash);
        assert!(Vector::length(&block_hash) == 32, 1001);
    }
}