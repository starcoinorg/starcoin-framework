address StarcoinFramework {
/// Block module provide metadata for generated blocks.
module Block {
    use StarcoinFramework::Vector;
    use StarcoinFramework::Event;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Signer;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Errors;

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

    /// Block metadata struct.
    // parents_hash is for FLexiDag block
    struct BlockMetadataV2 has key {
        /// number of the current block
        number: u64,
        /// Hash of the parent block.
        parent_hash: vector<u8>,
        /// Author of the current block.
        author: address,
        /// number of uncles.
        uncles: u64,
        /// An Array of the parents hash for a Dag block.
        parents_hash: vector<u8>,
        /// Handle of events when new blocks are emitted
        new_block_events: Event::EventHandle<Self::NewBlockEventV2>,
    }

    /// Events emitted when new block generated.
    // parents_hash is for FLexiDag block
    struct NewBlockEventV2 has drop, store {
        number: u64,
        author: address,
        timestamp: u64,
        uncles: u64,
        parents_hash: vector<u8>,
    }

    const EBLOCK_NUMBER_MISMATCH: u64 = 17;

    /// This can only be invoked by the GENESIS_ACCOUNT at genesis
    public fun initialize(account: &signer, parent_hash: vector<u8>) {
        Timestamp::assert_genesis();
        CoreAddresses::assert_genesis_address(account);

        move_to<BlockMetadata>(
            account,
            BlockMetadata {
                number: 0,
                parent_hash,
                author: CoreAddresses::GENESIS_ADDRESS(),
                uncles: 0,
                new_block_events: Event::new_event_handle<Self::NewBlockEvent>(account),
            });
    }

    spec initialize {
        aborts_if !Timestamp::is_genesis();
        aborts_if Signer::address_of(account) != CoreAddresses::SPEC_GENESIS_ADDRESS();
        aborts_if exists<BlockMetadata>(Signer::address_of(account));
    }

    public fun initialize_blockmetadata_v2(account: &signer) acquires BlockMetadata {
        CoreAddresses::assert_genesis_address(account);

        let block_meta_ref = borrow_global<BlockMetadata>(CoreAddresses::GENESIS_ADDRESS());

        // create new resource base on current block metadata
        move_to<BlockMetadataV2>(
            account,
            BlockMetadataV2 {
                number: block_meta_ref.number,
                parent_hash: block_meta_ref.parent_hash,
                author: block_meta_ref.author,
                uncles: block_meta_ref.uncles,
                parents_hash: Vector::empty(),
                new_block_events: Event::new_event_handle<Self::NewBlockEventV2>(account),
            });
    }

    spec initialize_blockmetadata_v2 {
        aborts_if Signer::address_of(account) != CoreAddresses::GENESIS_ADDRESS();
        aborts_if exists<BlockMetadata>(Signer::address_of(account));

        ensures exists<BlockMetadataV2>(Signer::address_of(account));
    }

    /// Get the current block number
    public fun get_current_block_number(): u64 acquires BlockMetadataV2 {
        borrow_global<BlockMetadataV2>(CoreAddresses::GENESIS_ADDRESS()).number
    }

    spec get_current_block_number {
        aborts_if !exists<BlockMetadataV2>(CoreAddresses::GENESIS_ADDRESS());
    }

    /// Get the hash of the parent block.
    public fun get_parent_hash(): vector<u8> acquires BlockMetadataV2 {
        *&borrow_global<BlockMetadataV2>(CoreAddresses::GENESIS_ADDRESS()).parent_hash
    }

    spec get_parent_hash {
        aborts_if !exists<BlockMetadataV2>(CoreAddresses::GENESIS_ADDRESS());
    }

    /// Gets the address of the author of the current block
    public fun get_current_author(): address acquires BlockMetadataV2 {
        borrow_global<BlockMetadataV2>(CoreAddresses::GENESIS_ADDRESS()).author
    }

    spec get_current_author {
        aborts_if !exists<BlockMetadataV2>(CoreAddresses::GENESIS_ADDRESS());
    }

    public fun get_parents_hash(): vector<u8> acquires BlockMetadataV2 {
        *&borrow_global<BlockMetadataV2>(CoreAddresses::GENESIS_ADDRESS()).parents_hash
    }

    spec get_parents_hash {
        aborts_if !exists<BlockMetadataV2>(CoreAddresses::GENESIS_ADDRESS());
    }

    /// Call at block prologue
    public fun process_block_metadata(account: &signer,
                                      parent_hash: vector<u8>,
                                      author: address,
                                      timestamp: u64,
                                      uncles: u64,
                                      number: u64) acquires BlockMetadataV2 {
        Self::process_block_metadata_v2(account, parent_hash, author, timestamp, uncles, number, Vector::empty<u8>())
    }

    spec process_block_metadata {
        aborts_if Signer::address_of(account) != CoreAddresses::GENESIS_ADDRESS();
        aborts_if !exists<BlockMetadataV2>(CoreAddresses::GENESIS_ADDRESS());
        aborts_if number != global<BlockMetadataV2>(CoreAddresses::GENESIS_ADDRESS()).number + 1;
    }

    /// Call at block prologue for flexidag
    public fun process_block_metadata_v2(account: &signer,
                                         parent_hash: vector<u8>,
                                         author: address,
                                         timestamp: u64,
                                         uncles: u64,
                                         number: u64,
                                         parents_hash: vector<u8>) acquires BlockMetadataV2 {
        CoreAddresses::assert_genesis_address(account);

        let block_metadata_ref = borrow_global_mut<BlockMetadataV2>(CoreAddresses::GENESIS_ADDRESS());
        assert!(number == (block_metadata_ref.number + 1), Errors::invalid_argument(EBLOCK_NUMBER_MISMATCH));
        block_metadata_ref.number = number;
        block_metadata_ref.author = author;
        block_metadata_ref.parent_hash = parent_hash;
        block_metadata_ref.uncles = uncles;
        block_metadata_ref.parents_hash = parents_hash;

        Event::emit_event<NewBlockEventV2>(
            &mut block_metadata_ref.new_block_events,
            NewBlockEventV2 {
                number,
                author,
                timestamp,
                uncles,
                parents_hash,
            }
        );
    }

    spec process_block_metadata_v2 {
        aborts_if Signer::address_of(account) != CoreAddresses::GENESIS_ADDRESS();
        aborts_if !exists<BlockMetadataV2>(CoreAddresses::GENESIS_ADDRESS());
        aborts_if number != global<BlockMetadataV2>(CoreAddresses::GENESIS_ADDRESS()).number + 1;
    }

    spec schema AbortsIfBlockMetadataNotExist {
        aborts_if !exists<BlockMetadataV2>(CoreAddresses::GENESIS_ADDRESS());
    }
}
}