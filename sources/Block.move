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
    struct Checkpoints has key{
        //all checkpoints
        checkpoints: vector<Checkpoint>,
        index:u64,
    }

    const EBLOCK_NUMBER_MISMATCH  : u64 = 17;
    const ERROR_NO_HAVE_CHECKPOINT: u64 = 18;
    const ERROR_NOT_BLOCK_HEADER  : u64 = 19;
    const CHECKPOINT_LENGTHR      : u64 = 60;
    const BLOCK_HEADER_LENGTH     : u64 = 247;

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
        let i = 0;
        let checkpoints = Vector::empty<Checkpoint>();
        while( i < CHECKPOINT_LENGTHR){
            Vector::push_back<Checkpoint>(&mut checkpoints,Checkpoint {
                block_number: 0,
                block_hash  : Vector::empty<u8>(),
                state_root  : Option::none<vector<u8>>(),
            });
            i = i + 1;
        };
        move_to<Checkpoints>(
            account,
            Checkpoints {
               checkpoints: checkpoints,
               index: 0
            });
    }

    spec checkpoints_init {
        aborts_if exists<Checkpoints>(CoreAddresses::GENESIS_ADDRESS());
    }

    public fun checkpoint(account: &signer) acquires BlockMetadata, Checkpoints{
        CoreAddresses::assert_genesis_address(account);
        let parent_block_number = get_current_block_number() - 1;
        let parent_block_hash   = get_parent_hash();
        
        let checkpoints = borrow_global_mut<Checkpoints>(CoreAddresses::GENESIS_ADDRESS());
        checkpoints.index =  if( checkpoints.index + 1 >= CHECKPOINT_LENGTHR ){
            0 
        }else{
            checkpoints.index + 1
        };

        let checkpoint = Vector::borrow_mut<Checkpoint>(&mut checkpoints.checkpoints , checkpoints.index);
        checkpoint.block_number = parent_block_number; 
        checkpoint.block_hash   = parent_block_hash;
        checkpoint.state_root   = Option::none<vector<u8>>();
    }

    public fun latest_state_root():(u64,vector<u8>) acquires  Checkpoints{
        let checkpoints = borrow_global<Checkpoints>(CoreAddresses::GENESIS_ADDRESS());
        let len = Vector::length<Checkpoint>(&checkpoints.checkpoints);
        let i = checkpoints.index ;
        while( i <  len + checkpoints.index){
            if( Option::is_some<vector<u8>>(&Vector::borrow(&checkpoints.checkpoints, i % len).state_root)) {
                return (Vector::borrow(&checkpoints.checkpoints, i % len).block_number, *&Vector::borrow(&checkpoints.checkpoints, i % len).block_hash)
            };

            i = i + 1;
        };
        abort Errors::invalid_state(ERROR_NO_HAVE_CHECKPOINT)
    }

    
    public fun update_state_root(account: &signer, header:vector<u8>) acquires  Checkpoints{
        CoreAddresses::assert_genesis_address(account);
        // header = x"20b82a2c11f2df62bf87c2933d0281e5fe47ea94d5f0049eec1485b682df29529abf17ac7d79010000000000000000000000000000000000000000000000000001002043609d52fdf8e4a253c62dfe127d33c77e1fb4afdefb306d46ec42e21b9103ae20414343554d554c41544f525f504c414345484f4c4445525f48415348000000002061125a3ab755b993d72accfea741f8537104db8e022098154f3a66d5c23e828d00000000000000000000000000000000000000000000000000000000000000000000000000b1ec37207564db97ee270a6c1f2f73fbf517dc0777a6119b7460b7eae2890d1ce504537b010000000000000000";
        
        assert!(Vector::length<u8>(&header) == BLOCK_HEADER_LENGTH , Errors::invalid_argument(ERROR_NOT_BLOCK_HEADER));
        let i = 1 ;
        let block_hash = Vector::empty<u8>(); 
        while(i < 33){
            Vector::push_back<u8>(&mut block_hash , *Vector::borrow<u8>(&header , i));
            i = i + 1;
        };
        i = 41 ;
        let number_vec = Vector::empty<u8>(); 
        while(i < 49){
            Vector::push_back<u8>(&mut number_vec , *Vector::borrow<u8>(&header , i));
            i = i + 1;
        };
        let number: u128 = 0;
        let offset  = 0;
        let i = 0;
        while (i < 8) {
            let byte = *Vector::borrow(&number_vec, offset + i);
            let s = (i as u8) * 8;
            number = number + ((byte as u128) << s);
            i = i + 1;
        };

        let state_root = Vector::empty<u8>(); 
        i = 133;
        while(i < 165){
            Vector::push_back<u8>(&mut state_root , *Vector::borrow<u8>(&header , i));
            i = i + 1;
        };
        
        let checkpoints = borrow_global_mut<Checkpoints>(CoreAddresses::GENESIS_ADDRESS());
        let len = Vector::length<Checkpoint>(&checkpoints.checkpoints);
        let i = checkpoints.index ;
        while( i <  len + checkpoints.index){
            if( &Vector::borrow(&mut checkpoints.checkpoints, i % len).block_hash == &block_hash ) {
                Vector::borrow_mut(&mut checkpoints.checkpoints, i % len).block_number = (number as u64 );
                *Option::borrow_mut<vector<u8>>( &mut Vector::borrow_mut(&mut checkpoints.checkpoints, i % len).state_root) = state_root;
                return
            };
            i = i + 1 ; 
        };
        
        abort Errors::invalid_state(ERROR_NO_HAVE_CHECKPOINT)
    }
}
}