address StarcoinFramework {

module IDizedSet {

    use StarcoinFramework::Vector;
    use StarcoinFramework::Option;
    use StarcoinFramework::Errors;

    const ERROR_COLLECTION_ITEM_CANNOT_FOUND: u64 = 101;
    const ERROR_TWO_COLLECTION_ID_REPEATE: u64 = 102;

    struct Set<T> has store {
        items: vector<SetItem<T>>,
    }

    struct SetItem<T> has store {
        id: vector<u8>,
        t: T,
    }


    public fun empty<T>(): Set<T> {
        Set<T>{
            items: Vector::empty<SetItem<T>>()
        }
    }

    public fun borrow<T>(c: &Set<T>, id: &vector<u8>): &T {
        let idx = find_idx_by_id(&c.items, id);
        assert!(Option::is_some(&idx), Errors::requires_address(ERROR_COLLECTION_ITEM_CANNOT_FOUND));
        let element = Vector::borrow<SetItem<T>>(&c.items, Option::destroy_some<u64>(idx));
        &element.t
    }

    public fun borrow_mut<T>(c: &mut Set<T>, id: &vector<u8>): &mut T {
        let idx = find_idx_by_id(&c.items, id);
        assert!(Option::is_some(&idx), Errors::requires_address(ERROR_COLLECTION_ITEM_CANNOT_FOUND));
        let item = Vector::borrow_mut<SetItem<T>>(&mut c.items, Option::destroy_some<u64>(idx));
        &mut item.t
    }


    public fun borrow_idx<T>(c: &Set<T>, idx: u64): &T {
        let element = Vector::borrow<SetItem<T>>(&c.items, idx);
        &element.t
    }

    public fun borrow_idx_mut<T>(c: &mut Set<T>, idx: u64): &mut T {
        let item = Vector::borrow_mut<SetItem<T>>(&mut c.items, idx);
        &mut item.t
    }

    public fun push_back<T>(c: &mut Set<T>, id: &vector<u8>, t: T) {
        Vector::push_back<SetItem<T>>(&mut c.items, SetItem<T>{
            id: *id,
            t,
        });
    }

    public fun remove<T>(c: &mut Set<T>, id: &vector<u8>): T {
        let idx = find_idx_by_id(&c.items, id);
        assert!(Option::is_some(&idx), Errors::requires_address(ERROR_COLLECTION_ITEM_CANNOT_FOUND));
        let SetItem<T>{ id: _, t } = Vector::remove<SetItem<T>>(
            &mut c.items, Option::destroy_some<u64>(idx));
        t
    }

    public fun append_all<T>(c: &mut Set<T>, other: Set<T>) {
        let Set<T>{ items : other_items } = other;
        let len = Vector::length(&other_items);
        if (len <= 0) {
            Vector::destroy_empty(other_items);
            return
        };

        let idx = len - 1;
        // Check repeated id between two collections
        loop {
            if (idx <= 0) {
                break
            };
            let el = Vector::borrow(&other_items, idx);
            let other_idx = find_idx_by_id(&c.items, &el.id);
            assert!(Option::is_none(&other_idx), Errors::invalid_state(ERROR_TWO_COLLECTION_ID_REPEATE));
            idx = idx - 1;
        };
        Vector::append<SetItem<T>>(&mut c.items, other_items);
    }

    /// check the Collection exists in id
    public fun length<T>(c: &Set<T>): u64 {
        Vector::length(&c.items)
    }

    /// check the Collection exists in id
    public fun exists_at<T>(c: &Set<T>, id: &vector<u8>): bool {
        let idx = find_idx_by_id(&c.items, id);
        Option::is_some(&idx)
    }

    public fun destroy<T>(c: Set<T>) {
        let Set<T>{ items } = c;
        Vector::destroy_empty(items);
    }

    fun find_idx_by_id<T>(c: &vector<SetItem<T>>, id: &vector<u8>): Option::Option<u64> {
        let len = Vector::length(c);
        if (len == 0) {
            return Option::none()
        };
        let idx = len - 1;
        loop {
            let el = Vector::borrow(c, idx);
            if (*&el.id == *id) {
                return Option::some(idx)
            };
            if (idx == 0) {
                return Option::none()
            };
            idx = idx - 1;
        }
    }
}
}
