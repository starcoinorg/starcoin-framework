address StarcoinFramework {
/// Block module provide metadata for generated blocks.
module Block {
    use StarcoinFramework::Event;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Signer;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Option;
    use StarcoinFramework::Ring;
    use StarcoinFramework::BCS;
    use StarcoinFramework::Hash;

    spec module {
        pragma verify;
        pragma aborts_if_is_strict = true;
    }

    /// Block metadata struct.
    struct BlockMetadata has key {
        /// number of the current block
        number: u64,
        /// Hash of the parent block.
        parent_hash: vector<u8>,
        /// Author of the current block.
        author: address,
        /// number of uncles.
        uncles: u64,
        /// Handle of events when new blocks are emitted
        new_block_events: Event::EventHandle<Self::NewBlockEvent>,
    }

    /// Events emitted when new block generated.
    struct NewBlockEvent has drop, store {
        number: u64,
        author: address,
        timestamp: u64,
        uncles: u64,
    }

    //
    struct Checkpoint has copy,drop,store{
        //number of the  block
        block_number: u64,
        //Hash of the block
        block_hash: vector<u8>,
        //State root of the block
        state_root: Option::Option<vector<u8>>,
    }

    //
    struct Checkpoints has key,store{
        //all checkpoints
        checkpoints : Ring::Ring<Checkpoint>,
        index       : u64,
        last_number : u64,
    }

    const EBLOCK_NUMBER_MISMATCH  : u64 = 17;
    const ERROR_NO_HAVE_CHECKPOINT: u64 = 18;
    const ERROR_NOT_BLOCK_HEADER  : u64 = 19;
    const ERROR_INTERVAL_TOO_LITTLE: u64 = 20;
    
    const CHECKPOINT_LENGTHR      : u64 = 60;
    const BLOCK_HEADER_LENGTH     : u64 = 247;
    const BLOCK_INTERVAL_NUMBER   : u64 = 5;

    /// This can only be invoked by the GENESIS_ACCOUNT at genesis
    public fun initialize(account: &signer, parent_hash: vector<u8>) {
        Timestamp::assert_genesis();
        CoreAddresses::assert_genesis_address(account);

        move_to<BlockMetadata>(
            account,
            BlockMetadata {
                number: 0,
                parent_hash: parent_hash,
                author: CoreAddresses::GENESIS_ADDRESS(),
                uncles: 0,
                new_block_events: Event::new_event_handle<Self::NewBlockEvent>(account),
            });
    }

    spec initialize {
        aborts_if !Timestamp::is_genesis();
        aborts_if Signer::address_of(account) != CoreAddresses::GENESIS_ADDRESS();
        aborts_if exists<BlockMetadata>(Signer::address_of(account));
    }

    /// Get the current block number
    public fun get_current_block_number(): u64 acquires BlockMetadata {
      borrow_global<BlockMetadata>(CoreAddresses::GENESIS_ADDRESS()).number
    }

    spec get_current_block_number {
        aborts_if !exists<BlockMetadata>(CoreAddresses::GENESIS_ADDRESS());
    }

    /// Get the hash of the parent block.
    public fun get_parent_hash(): vector<u8> acquires BlockMetadata {
      *&borrow_global<BlockMetadata>(CoreAddresses::GENESIS_ADDRESS()).parent_hash
    }

    spec get_parent_hash {
        aborts_if !exists<BlockMetadata>(CoreAddresses::GENESIS_ADDRESS());
    }

    /// Gets the address of the author of the current block
    public fun get_current_author(): address acquires BlockMetadata {
      borrow_global<BlockMetadata>(CoreAddresses::GENESIS_ADDRESS()).author
    }

    spec get_current_author {
        aborts_if !exists<BlockMetadata>(CoreAddresses::GENESIS_ADDRESS());
    }

    /// Call at block prologue
    public fun process_block_metadata(account: &signer, parent_hash: vector<u8>,author: address, timestamp: u64, uncles:u64, number:u64) acquires BlockMetadata{
        CoreAddresses::assert_genesis_address(account);

        let block_metadata_ref = borrow_global_mut<BlockMetadata>(CoreAddresses::GENESIS_ADDRESS());
        assert!(number == (block_metadata_ref.number + 1), Errors::invalid_argument(EBLOCK_NUMBER_MISMATCH));
        block_metadata_ref.number = number;
        block_metadata_ref.author= author;
        block_metadata_ref.parent_hash = parent_hash;
        block_metadata_ref.uncles = uncles;

        Event::emit_event<NewBlockEvent>(
          &mut block_metadata_ref.new_block_events,
          NewBlockEvent {
              number: number,
              author: author,
              timestamp: timestamp,
              uncles: uncles,
          }
        );
    }

    spec process_block_metadata {
        aborts_if Signer::address_of(account) != CoreAddresses::GENESIS_ADDRESS();
        aborts_if !exists<BlockMetadata>(CoreAddresses::GENESIS_ADDRESS());
        aborts_if number != global<BlockMetadata>(CoreAddresses::GENESIS_ADDRESS()).number + 1;
    }

    spec schema AbortsIfBlockMetadataNotExist {
        aborts_if !exists<BlockMetadata>(CoreAddresses::GENESIS_ADDRESS());
    }

    public fun checkpoints_init(account: &signer){
        CoreAddresses::assert_genesis_address(account);
        
        let checkpoints = Ring::create_with_capacity<Checkpoint>(CHECKPOINT_LENGTHR);
        move_to<Checkpoints>(
            account,
            Checkpoints {
               checkpoints  : checkpoints,
               index        : 0,
               last_number  : 0,
        });
    }

    spec checkpoints_init {
        pragma verify = false;
    }

    public fun checkpoint() acquires BlockMetadata, Checkpoints{
        let parent_block_number = get_current_block_number() - 1;
        let parent_block_hash   = get_parent_hash();
        
        let checkpoints = borrow_global_mut<Checkpoints>(CoreAddresses::GENESIS_ADDRESS());
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

    spec checkpoint {
        pragma verify = false;
    }

    public fun latest_state_root():(u64,vector<u8>) acquires  Checkpoints{
        let checkpoints = borrow_global<Checkpoints>(CoreAddresses::GENESIS_ADDRESS());
        let len = Ring::capacity<Checkpoint>(&checkpoints.checkpoints);
        let i = checkpoints.index ;
        
        if( i < len - 1){
            let j = 0;
            while(j <= i){
                let op_checkpoint = Ring::borrow(&checkpoints.checkpoints, j);
                if( Option::is_some(op_checkpoint) && Option::is_some(&Option::borrow(op_checkpoint).state_root) ) {
                    let state_root = Option::borrow(&Option::borrow(op_checkpoint).state_root);
                    return (Option::borrow(op_checkpoint).block_number, *state_root)
                };
                j = j + 1;
            };
        }else{
            let j = i - ( len - 1);
            while( j < i ){
                let op_checkpoint = Ring::borrow(&checkpoints.checkpoints, j);
                if( Option::is_some(op_checkpoint) && Option::is_some(&Option::borrow(op_checkpoint).state_root) ) {
                    let state_root = Option::borrow(&Option::borrow(op_checkpoint).state_root);
                    return (Option::borrow(op_checkpoint).block_number, *state_root)
                };
                j = j + 1;
            };
        };
        
        abort Errors::invalid_state(ERROR_NO_HAVE_CHECKPOINT)
    }

    spec latest_state_root {
        pragma verify = false;
    }

    public fun update_state_root(header: vector<u8>)acquires  Checkpoints {
        let prefix = b"STARCOIN::BlockHeader";
        let prefix = Hash::sha3_256(prefix);
        
        let (_parent_hash,new_offset) = BCS::deserialize_bytes(&header,0);
        let (_timestamp,new_offset) = BCS::deserialize_u64(&header,new_offset);
        let (number,new_offset) = BCS::deserialize_u64(&header,new_offset);
        let (_author,new_offset) = BCS::deserialize_address(&header,new_offset);
        let (_author_auth_key,new_offset) = BCS::deserialize_option_bytes_vector(&header,new_offset);
        let (_txn_accumulator_root,new_offset) = BCS::deserialize_bytes(&header,new_offset);
        let (_block_accumulator_root,new_offset) = BCS::deserialize_bytes(&header,new_offset);
        let (state_root,new_offset) = BCS::deserialize_bytes(&header,new_offset);
        let (_gas_used,new_offset) = BCS::deserialize_u64(&header,new_offset);
        let (_difficultyfirst,new_offset) = BCS::deserialize_u128(&header,new_offset);
        let (_difficultylast,new_offset) = BCS::deserialize_u128(&header,new_offset);
        let (_body_hash,new_offset) = BCS::deserialize_bytes(&header,new_offset);
        let (_chain_id,new_offset) = BCS::deserialize_u8(&header,new_offset);
        let (_nonce,new_offset) = BCS::deserialize_u32(&header,new_offset);
        let (_extra1,new_offset) = BCS::deserialize_u8(&header,new_offset);
        let (_extra2,new_offset) = BCS::deserialize_u8(&header,new_offset);
        let (_extra3,new_offset) = BCS::deserialize_u8(&header,new_offset);
        let (_extra4,_new_offset) = BCS::deserialize_u8(&header,new_offset);
    
        Vector::append(&mut prefix,header);
        let block_hash = Hash::sha3_256(prefix);
        let checkpoints = borrow_global_mut<Checkpoints>(CoreAddresses::GENESIS_ADDRESS());
        let len = Ring::capacity<Checkpoint>(&checkpoints.checkpoints);
        let i = checkpoints.index ;
        
        if( i < len - 1){
            let j = 0;
            while(j <= i){
                let op_checkpoint = Ring::borrow_mut(&mut checkpoints.checkpoints, j);
            
                if( Option::is_some(op_checkpoint) && &Option::borrow(op_checkpoint).block_hash == &block_hash && Option::borrow_mut<Checkpoint>(op_checkpoint).block_number == number) {
                    
                    let op_state_root = &mut Option::borrow_mut<Checkpoint>(op_checkpoint).state_root;
                    if(Option::is_some(op_state_root)){
                        Option::swap(op_state_root, state_root);
                    }else{
                        Option::fill(op_state_root, state_root);
                    };
                    return
                };
                j = j + 1;
            };
        }else{
            let j = i - ( len - 1);
            while( j < i ){
                let op_checkpoint = Ring::borrow_mut(&mut checkpoints.checkpoints, j);
                if( Option::is_some(op_checkpoint) && &Option::borrow(op_checkpoint).block_hash == &block_hash) {
                    Option::borrow_mut<Checkpoint>(op_checkpoint).block_number = number ;
                    let op_state_root = &mut Option::borrow_mut<Checkpoint>(op_checkpoint).state_root;
                    if(Option::is_some(op_state_root)){
                        Option::swap(op_state_root, state_root);
                    }else{
                        Option::fill(op_state_root, state_root);
                    };
                    return
                };
                j = j + 1;
            };
        };
        
        abort Errors::invalid_state(ERROR_NO_HAVE_CHECKPOINT)
    }

    spec update_state_root {
        pragma verify = false;
    }

    #[test]
    fun header_test(){
        let prefix = b"STARCOIN::BlockHeader";
        let prefix = Hash::sha3_256(prefix);
        let header = x"20b82a2c11f2df62bf87c2933d0281e5fe47ea94d5f0049eec1485b682df29529abf17ac7d79010000000000000000000000000000000000000000000000000001002043609d52fdf8e4a253c62dfe127d33c77e1fb4afdefb306d46ec42e21b9103ae20414343554d554c41544f525f504c414345484f4c4445525f48415348000000002061125a3ab755b993d72accfea741f8537104db8e022098154f3a66d5c23e828d00000000000000000000000000000000000000000000000000000000000000000000000000b1ec37207564db97ee270a6c1f2f73fbf517dc0777a6119b7460b7eae2890d1ce504537b010000000000000000";
        let (_parent_hash,new_offset) = BCS::deserialize_bytes(&header,0);
        let (_timestamp,new_offset) = BCS::deserialize_u64(&header,new_offset);
        let (number,new_offset) = BCS::deserialize_u64(&header,new_offset);
        let (_author,new_offset) = BCS::deserialize_address(&header,new_offset);
        let (_author_auth_key,new_offset) = BCS::deserialize_option_bytes_vector(&header,new_offset);
        let (_txn_accumulator_root,new_offset) = BCS::deserialize_bytes(&header,new_offset);
        let (_block_accumulator_root,new_offset) = BCS::deserialize_bytes(&header,new_offset);
        let (state_root,new_offset) = BCS::deserialize_bytes(&header,new_offset);
        let (_gas_used,new_offset) = BCS::deserialize_u64(&header,new_offset);
        let (_difficultyfirst,new_offset) = BCS::deserialize_u128(&header,new_offset);
        let (_difficultylast,new_offset) = BCS::deserialize_u128(&header,new_offset);
        let (_body_hash,new_offset) = BCS::deserialize_bytes(&header,new_offset);
        let (_chain_id,new_offset) = BCS::deserialize_u8(&header,new_offset);
        let (_nonce,new_offset) = BCS::deserialize_u32(&header,new_offset);
        let (_extra1,new_offset) = BCS::deserialize_u8(&header,new_offset);
        let (_extra2,new_offset) = BCS::deserialize_u8(&header,new_offset);
        let (_extra3,new_offset) = BCS::deserialize_u8(&header,new_offset);
        let (_extra4,_new_offset) = BCS::deserialize_u8(&header,new_offset);
    
        Vector::append(&mut prefix,header);
        let block_hash = Hash::sha3_256(prefix);
        assert!(block_hash == x"80848150abee7e9a3bfe9542a019eb0b8b01f124b63b011f9c338fdb935c417d" ,1001);
        assert!(number == 0,1002);
        assert!(state_root == x"61125a3ab755b993d72accfea741f8537104db8e022098154f3a66d5c23e828d",1003);
    }

    #[only_test]
    fun update_state_root_test(checkpoints: &mut Checkpoints, header: vector<u8>){
        let prefix = b"STARCOIN::BlockHeader";
        let prefix = Hash::sha3_256(prefix);
        
        let (_parent_hash,new_offset) = BCS::deserialize_bytes(&header,0);
        let (_timestamp,new_offset) = BCS::deserialize_u64(&header,new_offset);
        let (number,new_offset) = BCS::deserialize_u64(&header,new_offset);
        let (_author,new_offset) = BCS::deserialize_address(&header,new_offset);
        let (_author_auth_key,new_offset) = BCS::deserialize_option_bytes_vector(&header,new_offset);
        let (_txn_accumulator_root,new_offset) = BCS::deserialize_bytes(&header,new_offset);
        let (_block_accumulator_root,new_offset) = BCS::deserialize_bytes(&header,new_offset);
        let (state_root,new_offset) = BCS::deserialize_bytes(&header,new_offset);
        let (_gas_used,new_offset) = BCS::deserialize_u64(&header,new_offset);
        let (_difficultyfirst,new_offset) = BCS::deserialize_u128(&header,new_offset);
        let (_difficultylast,new_offset) = BCS::deserialize_u128(&header,new_offset);
        let (_body_hash,new_offset) = BCS::deserialize_bytes(&header,new_offset);
        let (_chain_id,new_offset) = BCS::deserialize_u8(&header,new_offset);
        let (_nonce,new_offset) = BCS::deserialize_u32(&header,new_offset);
        let (_extra1,new_offset) = BCS::deserialize_u8(&header,new_offset);
        let (_extra2,new_offset) = BCS::deserialize_u8(&header,new_offset);
        let (_extra3,new_offset) = BCS::deserialize_u8(&header,new_offset);
        let (_extra4,_new_offset) = BCS::deserialize_u8(&header,new_offset);
        
        Vector::append(&mut prefix,header);
        let block_hash = Hash::sha3_256(prefix);

        let len = Ring::capacity<Checkpoint>(&checkpoints.checkpoints);
        let i = checkpoints.index ;
        
        if( i < len - 1){
            let j = 0;
            while(j <= i){
                let op_checkpoint = Ring::borrow_mut(&mut checkpoints.checkpoints, j);
            
                if( Option::is_some(op_checkpoint) && &Option::borrow(op_checkpoint).block_hash == &block_hash && Option::borrow_mut<Checkpoint>(op_checkpoint).block_number == number) {
                    
                    let op_state_root = &mut Option::borrow_mut<Checkpoint>(op_checkpoint).state_root;
                    if(Option::is_some(op_state_root)){
                        Option::swap(op_state_root, state_root);
                    }else{
                        Option::fill(op_state_root, state_root);
                    };
                    return
                };
                j = j + 1;
            };
        }else{
            let j = i - ( len - 1);
            while( j < i ){
                let op_checkpoint = Ring::borrow_mut(&mut checkpoints.checkpoints, j);
                if( Option::is_some(op_checkpoint) && &Option::borrow(op_checkpoint).block_hash == &block_hash) {
                    Option::borrow_mut<Checkpoint>(op_checkpoint).block_number = number ;
                    let op_state_root = &mut Option::borrow_mut<Checkpoint>(op_checkpoint).state_root;
                    if(Option::is_some(op_state_root)){
                        Option::swap(op_state_root, state_root);
                    }else{
                        Option::fill(op_state_root, state_root);
                    };
                    return
                };
                j = j + 1;
            };
        };
        
        abort Errors::invalid_state(ERROR_NO_HAVE_CHECKPOINT)
    }

    spec update_state_root_test {
        pragma verify = false;
    }

    #[test]
    fun latest_state_root_test(){
        let header = x"20b82a2c11f2df62bf87c2933d0281e5fe47ea94d5f0049eec1485b682df29529abf17ac7d79010000000000000000000000000000000000000000000000000001002043609d52fdf8e4a253c62dfe127d33c77e1fb4afdefb306d46ec42e21b9103ae20414343554d554c41544f525f504c414345484f4c4445525f48415348000000002061125a3ab755b993d72accfea741f8537104db8e022098154f3a66d5c23e828d00000000000000000000000000000000000000000000000000000000000000000000000000b1ec37207564db97ee270a6c1f2f73fbf517dc0777a6119b7460b7eae2890d1ce504537b010000000000000000";

        let checkpoints = Checkpoints {
                                checkpoints  : Ring::create_with_capacity<Checkpoint>(3),
                                index        : 0,
                                last_number  : 0
                            };

        checkpoint_test_function(&mut checkpoints, 0, x"80848150abee7e9a3bfe9542a019eb0b8b01f124b63b011f9c338fdb935c417d");
        
        update_state_root_test(&mut checkpoints, copy header);
        
        let (number , state_root ) = latest_state_root_test_function(&checkpoints);
        let Checkpoints{
        checkpoints: ring,
        index      : index,
        last_number: last_number
        } = checkpoints;
        assert!( index == 1 && last_number == 0 , 10020);
        assert!( number == 0 && state_root == x"61125a3ab755b993d72accfea741f8537104db8e022098154f3a66d5c23e828d" , 10020);
        Ring::destroy(ring);
    } 

    

    #[only_test]
    fun latest_state_root_test_function(checkpoints: &Checkpoints):(u64,vector<u8>){
        let len = Ring::capacity<Checkpoint>(&checkpoints.checkpoints);
        let i = checkpoints.index ;
        
        if( i < len - 1){
            let j = 0;
            while(j <= i){
                let op_checkpoint = Ring::borrow(&checkpoints.checkpoints, j);
                if( Option::is_some(op_checkpoint) && Option::is_some(&Option::borrow(op_checkpoint).state_root) ) {
                    let state_root = Option::borrow(&Option::borrow(op_checkpoint).state_root);
                    return (Option::borrow(op_checkpoint).block_number, *state_root)
                };
                j = j + 1;
            };
        }else{
            let j = i - ( len - 1);
            while( j < i ){
                let op_checkpoint = Ring::borrow(&checkpoints.checkpoints, j);
                if( Option::is_some(op_checkpoint) && Option::is_some(&Option::borrow(op_checkpoint).state_root) ) {
                    let state_root = Option::borrow(&Option::borrow(op_checkpoint).state_root);
                    return (Option::borrow(op_checkpoint).block_number, *state_root)
                };
                j = j + 1;
            };
        };
        
        abort Errors::invalid_state(ERROR_NO_HAVE_CHECKPOINT)
    }

    spec latest_state_root_test_function {
        pragma verify = false;
    }
    
    #[test]
    fun checkpoint_test(){
        let checkpoints = Checkpoints {
                                checkpoints  : Ring::create_with_capacity<Checkpoint>(3),
                                index        : 0,
                                last_number  : 0
                            };

       checkpoint_test_function(&mut checkpoints, 0, x"80848150abee7e9a3bfe9542a019eb0b8b01f124b63b011f9c338fdb935c417d");

       let Checkpoints{
        checkpoints: ring,
        index      : index,
        last_number: last_number
       } = checkpoints;
       assert!( index == 1 && last_number == 0 , 10020);
       Ring::destroy(ring);
    }

    #[only_test]
    fun checkpoint_test_function(checkpoints: &mut Checkpoints, parent_block_number: u64, parent_block_hash:vector<u8>){
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

    spec checkpoint_test_function {
        pragma verify = false;
    }
}
module CheckpointScript {
    use StarcoinFramework::Block;

    public (script) fun checkpoint(_account: signer){
        Block::checkpoint();
    }

    spec checkpoint {
        pragma verify = false;
    }

    public (script) fun latest_state_root(_account: signer){
        Block::latest_state_root();
    }

    spec latest_state_root {
        pragma verify = false;
    }

    public (script) fun update_state_root(_account: signer , header: vector<u8>){
        Block::update_state_root(header);
    }

    spec update_state_root {
        pragma verify = false;
    }
}
}