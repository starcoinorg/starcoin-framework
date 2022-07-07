//# init -n dev 

//# faucet --addr alice

//# faucet --addr Genesis

//# run --signers Genesis
script {
    use StarcoinFramework::Block;
    use StarcoinFramework::Debug;

    fun get_parent_hash(_account: signer) {
        let hash = Block::get_parent_hash();
        Debug::print<vector<u8>>(&hash);
    }
}
// check: EXECUTED


//# block --author 0x1 --timestamp 86400000

//# run --signers Genesis
script {
    use StarcoinFramework::Block;

    fun checkpoints_init(account: signer) {
        Block::checkpoints_init(&account);
    }
}
// check: EXECUTED

//# run --signers Genesis
script {
    use StarcoinFramework::Block;

    fun checkpoints_init(_account: signer) {
        Block::latest_state_root();
    }
}
// check: MoveAbort 4609

//# run --signers Genesis
script {
    use StarcoinFramework::Block;

    fun checkpoint(_account: signer) {
        Block::checkpoint();
    }
}
// check: EXECUTED



//# block --author 0x1 --timestamp 96400000 

//# block --author 0x1 --timestamp 96500000 

//# block --author 0x1 --timestamp 96600000

//# block --author 0x1 --timestamp 96700000

//# block --author 0x1 --timestamp 96800000 

//# run --signers alice
script {
    use StarcoinFramework::Block;

    fun checkpoint(_account: signer) {
        Block::checkpoint();
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use StarcoinFramework::Block;

    fun update_state_root(_account: signer) {
        let header = x"20b82a2c11f2df62bf87c2933d0281e5fe47ea94d5f0049eec1485b682df29529abf17ac7d79010000000000000000000000000000000000000000000000000001002043609d52fdf8e4a253c62dfe127d33c77e1fb4afdefb306d46ec42e21b9103ae20414343554d554c41544f525f504c414345484f4c4445525f48415348000000002061125a3ab755b993d72accfea741f8537104db8e022098154f3a66d5c23e828d00000000000000000000000000000000000000000000000000000000000000000000000000b1ec37207564db97ee270a6c1f2f73fbf517dc0777a6119b7460b7eae2890d1ce504537b010000000000000000";
        Block::update_state_root(header); 
    }
}
// check: EXECUTED


//# run --signers alice
script {
    use StarcoinFramework::Block;
    use StarcoinFramework::Debug;

    fun latest_state_root(_account: signer) {
        let (number,state_root) = Block::latest_state_root();
        Debug::print (&number);
        Debug::print (&state_root);
    }
}
// check: EXECUTED