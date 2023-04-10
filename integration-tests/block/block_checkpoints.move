//# init -n dev 

//# faucet --addr alice

//# publish
module alice::Block_test{
    use StarcoinFramework::Errors;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Option;
    use StarcoinFramework::Ring;
    use StarcoinFramework::BCS;
    use StarcoinFramework::Hash;

    struct Checkpoint has copy,drop,store{
        //number of the  block
        block_number: u64,
        //Hash of the block
        block_hash: vector<u8>,
        //State root of the block
        state_root: Option::Option<vector<u8>>,
    }
    const EBLOCK_NUMBER_MISMATCH  : u64 = 17;
    const ERROR_NO_HAVE_CHECKPOINT: u64 = 18;
    const ERROR_NOT_BLOCK_HEADER  : u64 = 19;
    const ERROR_INTERVAL_TOO_LITTLE: u64 = 20;
    const ERR_ALREADY_INITIALIZED : u64 = 21;

    const CHECKPOINT_LENGTH       : u64 = 60;
    const BLOCK_HEADER_LENGTH     : u64 = 247;
    const BLOCK_INTERVAL_NUMBER   : u64 = 5;
    //
    struct Checkpoints has key,store{
        //all checkpoints
        checkpoints : Ring::Ring<Checkpoint>,
        index       : u64,
        last_number : u64,
    }
    public fun checkpoints_init(account:&signer){
        assert!(!exists<Checkpoints>(@alice), Errors::already_published(ERR_ALREADY_INITIALIZED));

        let checkpoints = Ring::create_with_capacity<Checkpoint>(CHECKPOINT_LENGTH);
        move_to<Checkpoints>(
            account,
            Checkpoints {
                checkpoints  : checkpoints,
                index        : 0,
                last_number  : 0,
            });
    }

    public fun checkpoint(parent_block_number:u64,parent_block_hash:vector<u8>) acquires  Checkpoints{
        let checkpoints = borrow_global_mut<Checkpoints>(@alice);
        base_checkpoint(checkpoints, parent_block_number, parent_block_hash);

    }

    fun base_checkpoint(checkpoints: &mut Checkpoints, parent_block_number: u64, parent_block_hash:vector<u8>){
        assert!(checkpoints.last_number + BLOCK_INTERVAL_NUMBER <= parent_block_number || checkpoints.last_number == 0, Errors::invalid_argument(ERROR_INTERVAL_TOO_LITTLE));

        checkpoints.index = checkpoints.index + 1;
        checkpoints.last_number = parent_block_number;
        let op_checkpoint = Ring::push<Checkpoint>(&mut checkpoints.checkpoints, Checkpoint {
            block_number: parent_block_number,
            block_hash: parent_block_hash,
            state_root: Option::none<vector<u8>>(),
        } );
        if(Option::is_some(&op_checkpoint)){
            Option::destroy_some(op_checkpoint);
        }else{
            Option::destroy_none(op_checkpoint);
        }
    }

    public fun latest_state_root():(u64,vector<u8>) acquires  Checkpoints{
        let checkpoints = borrow_global<Checkpoints>(@alice);
        base_latest_state_root(checkpoints)
    }

    fun base_latest_state_root(checkpoints: &Checkpoints):(u64,vector<u8>){
        let len = Ring::capacity<Checkpoint>(&checkpoints.checkpoints);
        let j = if(checkpoints.index < len - 1){
            checkpoints.index
        }else{
            len
        };
        let i = checkpoints.index;
        while( j > 0){
            let op_checkpoint = Ring::borrow(&checkpoints.checkpoints, i - 1 );
            if( Option::is_some(op_checkpoint) && Option::is_some(&Option::borrow(op_checkpoint).state_root) ) {
                let state_root = Option::borrow(&Option::borrow(op_checkpoint).state_root);
                return (Option::borrow(op_checkpoint).block_number, *state_root)
            };
            j = j - 1;
            i = i - 1;
        };

        abort Errors::invalid_state(ERROR_NO_HAVE_CHECKPOINT)
    }

    public fun update_state_root(header: vector<u8>)acquires  Checkpoints {
        let checkpoints = borrow_global_mut<Checkpoints>(@alice);
        base_update_state_root(checkpoints, header);
    }


    fun base_update_state_root(checkpoints: &mut Checkpoints, header: vector<u8>){
        let prefix = Hash::sha3_256(b"STARCOIN::BlockHeader");

        //parent_hash
        let new_offset = BCS::skip_bytes(&header,0);
        //timestamp
        let new_offset = BCS::skip_u64(&header,new_offset);
        //number
        let (number,new_offset) = BCS::deserialize_u64(&header,new_offset);
        //author
        new_offset = BCS::skip_address(&header,new_offset);
        //author_auth_key
        new_offset = BCS::skip_option_bytes(&header,new_offset);
        //txn_accumulator_root
        new_offset = BCS::skip_bytes(&header,new_offset);
        //block_accumulator_root
        new_offset = BCS::skip_bytes(&header,new_offset);
        //state_root
        let (state_root,_new_offset) = BCS::deserialize_bytes(&header,new_offset);

        Vector::append(&mut prefix,header);
        let block_hash = Hash::sha3_256(prefix);

        let len = Ring::capacity<Checkpoint>(&checkpoints.checkpoints);
        let j = if(checkpoints.index < len - 1){
            checkpoints.index
        }else{
            len
        };
        let i = checkpoints.index;
        while( j > 0){
            let op_checkpoint = Ring::borrow_mut(&mut checkpoints.checkpoints, i - 1);

            if( Option::is_some(op_checkpoint) && &Option::borrow(op_checkpoint).block_hash == &block_hash && Option::borrow<Checkpoint>(op_checkpoint).block_number == number) {

                let op_state_root = &mut Option::borrow_mut<Checkpoint>(op_checkpoint).state_root;
                if(Option::is_some(op_state_root)){
                    Option::swap(op_state_root, state_root);
                }else{
                    Option::fill(op_state_root, state_root);
                };
                return
            };
            j = j - 1;
            i = i - 1;
        };

        abort ERROR_NO_HAVE_CHECKPOINT
    }
}

//# run --signers alice
script {
    use alice::Block_test;


    fun init(account: signer) {
        Block_test::checkpoints_init(&account);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use alice::Block_test;


    fun init(_account: signer) {
        let number = 6677628;
        let hash = x"e1bfffa1218462207a9807562422ccb40e2a27a6e3f0834a39364efd1cafb84f";
        Block_test::checkpoint(number, hash);
    }
}
// check: EXECUTED


//# run --signers alice
script {
    use alice::Block_test;


    fun update(_account: signer) {
        let header = x"20f9ccf1b2d18066977f1285aa23dd63a39739f22237aa2973476ed3326055369935d2e0db810100007ce46500000000005555ad74ce032cae631e7c83796880290020c0251fee2b98b5af7148ab4bcb5e0d65172b4639730d36208bb12fcfb581c01220211bdc20127db53f9179f8d873c0111cd971f852b8cacff91e801e7d27f74e182021e83a4306b24ba553f5b7b69a44d349d18cc3b52308994486fa3e53f69bb2860000000000000000000000000000000000000000000000000000000000000000000000001205509820c01e0329de6d899348a8ef4bd51db56175b3fa0988e57c3dcec8eaf13a164d9701a109000d694e533f";
        Block_test::update_state_root(header);
    }
}
// check: EXECUTED

//# run --signers alice
script {
    use alice::Block_test;


    fun latest(_account: signer) {
        let (number ,state_root) = Block_test::latest_state_root();
        assert!(number == 6677628, 10000);
        assert!(state_root == x"21e83a4306b24ba553f5b7b69a44d349d18cc3b52308994486fa3e53f69bb286",10001);
    }
}
// check: EXECUTED