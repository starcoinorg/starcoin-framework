address StarcoinFramework {
/// This module provides a solution for sorted maps, that is it has the properties that
/// 1) Keys point to Values
/// 2) Each Key must be unique
/// 3) A Key can be found within O(N) time
/// 4) The keys are unsorted.
/// 5) Adds and removals take O(N) time
module SimpleMap {
    use StarcoinFramework::Errors;
    use StarcoinFramework::Option;
    use StarcoinFramework::Vector;

    /// Map key already exists
    const EKEY_ALREADY_EXISTS: u64 = 1;
    /// Map key is not found
    const EKEY_NOT_FOUND: u64 = 2;

    struct SimpleMap<Key, Value> has copy, drop, store {
        data: vector<Element<Key, Value>>,
    }

    struct Element<Key, Value> has copy, drop, store {
        key: Key,
        value: Value,
    }

    public fun length<Key: store, Value: store>(map: &SimpleMap<Key, Value>): u64 {
        Vector::length(&map.data)
    }

    spec length {
        pragma intrinsic = true;
    }

    public fun create<Key: store, Value: store>(): SimpleMap<Key, Value> {
        SimpleMap {
            data: Vector::empty(),
        }
    }

    spec create {
        pragma intrinsic = true;
    }

    public fun borrow<Key: store, Value: store>(
        map: &SimpleMap<Key, Value>,
        key: &Key,
    ): &Value {
        let maybe_idx = find(map, key);
        assert!(Option::is_some(&maybe_idx), Errors::invalid_argument(EKEY_NOT_FOUND));
        let idx = Option::extract(&mut maybe_idx);
        &Vector::borrow(&map.data, idx).value
    }

    spec borrow {
        pragma intrinsic = true;
    }


    public fun borrow_mut<Key: store, Value: store>(
        map: &mut SimpleMap<Key, Value>,
        key: &Key,
    ): &mut Value {
        let maybe_idx = find(map, key);
        assert!(Option::is_some(&maybe_idx), Errors::invalid_argument(EKEY_NOT_FOUND));
        let idx = Option::extract(&mut maybe_idx);
        &mut Vector::borrow_mut(&mut map.data, idx).value
    }

    spec borrow_mut {
        pragma intrinsic = true;
    }


    public fun contains_key<Key: store, Value: store>(
        map: &SimpleMap<Key, Value>,
        key: &Key,
    ): bool {
        let maybe_idx = find(map, key);
        Option::is_some(&maybe_idx)
    }

    spec contains_key {
        pragma intrinsic = true;
    }


    public fun destroy_empty<Key: store, Value: store>(map: SimpleMap<Key, Value>) {
        let SimpleMap { data } = map;
        Vector::destroy_empty(data);
    }

    spec destroy_empty {
        pragma intrinsic = true;
    }

    public fun add<Key: store, Value: store>(
        map: &mut SimpleMap<Key, Value>,
        key: Key,
        value: Value,
    ) {
        let maybe_idx = find(map, &key);
        assert!(Option::is_none(&maybe_idx), Errors::invalid_argument(EKEY_ALREADY_EXISTS));

        Vector::push_back(&mut map.data, Element { key, value });
    }

    spec add {
        pragma intrinsic = true;
    }


    /// Insert key/value pair or update an existing key to a new value
    public fun upsert<Key: store, Value: store>(
        map: &mut SimpleMap<Key, Value>,
        key: Key,
        value: Value
    ): (Option::Option<Key>, Option::Option<Value>) {
        let data = &mut map.data;
        let len = Vector::length(data);
        let i = 0;
        while (i < len) {
            let element = Vector::borrow(data, i);
            if (&element.key == &key) {
                Vector::push_back(data, Element { key, value });
                Vector::swap(data, i, len);
                let Element { key, value } = Vector::pop_back(data);
                return (Option::some(key), Option::some(value))
            };
            i = i + 1;
        };
        Vector::push_back(&mut map.data, Element { key, value });
        (Option::none(), Option::none())
    }

    spec upsert {
        pragma verify=false;
    }


    public fun remove<Key: store, Value: store>(
        map: &mut SimpleMap<Key, Value>,
        key: &Key,
    ): (Key, Value) {
        let maybe_idx = find(map, key);
        assert!(Option::is_some(&maybe_idx), Errors::invalid_argument(EKEY_NOT_FOUND));
        let placement = Option::extract(&mut maybe_idx);
        let Element { key, value } = Vector::swap_remove(&mut map.data, placement);
        (key, value)
    }

    spec remove {
        pragma intrinsic = true;
    }

    fun find<Key: store, Value: store>(
        map: &SimpleMap<Key, Value>,
        key: &Key,
    ): Option::Option<u64> {
        let leng = Vector::length(&map.data);
        let i = 0;
        while (i < leng) {
            let element = Vector::borrow(&map.data, i);
            if (&element.key == key) {
                return Option::some(i)
            };
            i = i + 1;
        };
        Option::none<u64>()
    }

    spec find {
        pragma verify=false;
    }


    #[test]
    public fun add_remove_many() {
        let map = create<u64, u64>();

        assert!(length(&map) == 0, 0);
        assert!(!contains_key(&map, &3), 1);
        add(&mut map, 3, 1);
        assert!(length(&map) == 1, 2);
        assert!(contains_key(&map, &3), 3);
        assert!(borrow(&map, &3) == &1, 4);
        *borrow_mut(&mut map, &3) = 2;
        assert!(borrow(&map, &3) == &2, 5);

        assert!(!contains_key(&map, &2), 6);
        add(&mut map, 2, 5);
        assert!(length(&map) == 2, 7);
        assert!(contains_key(&map, &2), 8);
        assert!(borrow(&map, &2) == &5, 9);
        *borrow_mut(&mut map, &2) = 9;
        assert!(borrow(&map, &2) == &9, 10);

        remove(&mut map, &2);
        assert!(length(&map) == 1, 11);
        assert!(!contains_key(&map, &2), 12);
        assert!(borrow(&map, &3) == &2, 13);

        remove(&mut map, &3);
        assert!(length(&map) == 0, 14);
        assert!(!contains_key(&map, &3), 15);

        destroy_empty(map);
    }

    #[test]
    public fun test_several() {
        let map = create<u64, u64>();
        add(&mut map, 6, 6);
        add(&mut map, 1, 1);
        add(&mut map, 5, 5);
        add(&mut map, 2, 2);
        add(&mut map, 3, 3);
        add(&mut map, 0, 0);
        add(&mut map, 7, 7);
        add(&mut map, 4, 4);

        assert!(Option::destroy_some(find(&map, &6)) == 0, 100);
        assert!(Option::destroy_some(find(&map, &1)) == 1, 101);
        assert!(Option::destroy_some(find(&map, &5)) == 2, 102);
        assert!(Option::destroy_some(find(&map, &2)) == 3, 103);
        assert!(Option::destroy_some(find(&map, &3)) == 4, 104);
        assert!(Option::destroy_some(find(&map, &0)) == 5, 105);
        assert!(Option::destroy_some(find(&map, &7)) == 6, 106);
        assert!(Option::destroy_some(find(&map, &4)) == 7, 107);

        remove(&mut map, &0);
        remove(&mut map, &1);
        remove(&mut map, &2);
        remove(&mut map, &3);
        remove(&mut map, &4);
        remove(&mut map, &5);
        remove(&mut map, &6);
        remove(&mut map, &7);

        destroy_empty(map);
    }

    #[test]
    #[expected_failure]
    public fun add_twice() {
        let map = create<u64, u64>();
        add(&mut map, 3, 1);
        add(&mut map, 3, 1);

        remove(&mut map, &3);
        destroy_empty(map);
    }

    #[test]
    #[expected_failure]
    public fun remove_twice() {
        let map = create<u64, u64>();
        add(&mut map, 3, 1);
        remove(&mut map, &3);
        remove(&mut map, &3);

        destroy_empty(map);
    }

    #[test]
    public fun upsert_test() {
        let map = create<u64, u64>();
        // test adding 3 elements using upsert
        upsert<u64, u64>(&mut map, 1, 1);
        upsert(&mut map, 2, 2);
        upsert(&mut map, 3, 3);

        assert!(length(&map) == 3, 0);
        assert!(contains_key(&map, &1), 1);
        assert!(contains_key(&map, &2), 2);
        assert!(contains_key(&map, &3), 3);
        assert!(borrow(&map, &1) == &1, 4);
        assert!(borrow(&map, &2) == &2, 5);
        assert!(borrow(&map, &3) == &3, 6);

        // change mapping 1->1 to 1->4
        upsert(&mut map, 1, 4);

        assert!(length(&map) == 3, 7);
        assert!(contains_key(&map, &1), 8);
        assert!(borrow(&map, &1) == &4, 9);
    }
}
}