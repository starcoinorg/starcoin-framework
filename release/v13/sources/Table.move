address StarcoinFramework {
/// Type of large-scale storage tables.
module Table {
    use StarcoinFramework::Errors;

    // native code raises this with Errors::invalid_arguments()
    const EALREADY_EXISTS: u64 = 100;
    // native code raises this with Errors::invalid_arguments()
    const ENOT_FOUND: u64 = 101;
    const ENOT_EMPTY: u64 = 102;

    /// Type of tables
    struct Table<phantom K: copy + drop, phantom V> has store {
        handle: address,
        length: u64,
    }

    spec Table {
        pragma intrinsic = map,
        map_new = new,
        map_destroy_empty = destroy_empty,
        map_len = length,
        map_is_empty = empty,
        map_has_key = contains,
        map_add_no_override = add,
        map_del_must_exist = remove,
        map_borrow = borrow,
        map_borrow_mut = borrow_mut,
        map_spec_get = spec_get,
        map_spec_set = spec_set,
        map_spec_del = spec_remove,
        map_spec_len = spec_len,
        map_spec_has_key = spec_contains;
    }

    /// Create a new Table.
    public fun new<K: copy + drop, V: store>(): Table<K, V> {
        Table{
            handle: new_table_handle<K, V>(),
            length: 0,
        }
    }

    spec new {
        pragma intrinsic;
    }


    /// Destroy a table. The table must be empty to succeed.
    public fun destroy_empty<K: copy + drop, V>(table: Table<K, V>) {
        assert!(table.length == 0, Errors::invalid_state(ENOT_EMPTY));
        destroy_empty_box<K, V, Box<V>>(&table);
        drop_unchecked_box<K, V, Box<V>>(table)
    }

    spec destroy_empty {
        pragma intrinsic;
    }

    /// Add a new entry to the table. Aborts if an entry for this
    /// key already exists. The entry itself is not stored in the
    /// table, and cannot be discovered from it.
    public fun add<K: copy + drop, V>(table: &mut Table<K, V>, key: K, val: V) {
        add_box<K, V, Box<V>>(table, key, Box{val});
        table.length = table.length + 1
    }

    spec add {
        pragma intrinsic;
    }

    /// Acquire an immutable reference to the value which `key` maps to.
    /// Aborts if there is no entry for `key`.
    public fun borrow<K: copy + drop, V>(table: &Table<K, V>, key: K): &V {
        &borrow_box<K, V, Box<V>>(table, key).val
    }

    spec borrow {
        pragma intrinsic;
    }

    /// Acquire an immutable reference to the value which `key` maps to.
    /// Returns specified default value if there is no entry for `key`.
    public fun borrow_with_default<K: copy + drop, V>(table: &Table<K, V>, key: K, default: &V): &V {
        if (!contains(table, copy key)) {
            default
        } else {
            borrow(table, copy key)
        }
    }

    /// Acquire a mutable reference to the value which `key` maps to.
    /// Aborts if there is no entry for `key`.
    public fun borrow_mut<K: copy + drop, V>(table: &mut Table<K, V>, key: K): &mut V {
        &mut borrow_box_mut<K, V, Box<V>>(table, key).val
    }

    spec borrow_mut {
        pragma intrinsic;
    }

    /// Returns the length of the table, i.e. the number of entries.
    public fun length<K: copy + drop, V>(table: &Table<K, V>): u64 {
        table.length
    }

    spec length {
        pragma intrinsic;
    }

    /// Returns true if this table is empty.
    public fun empty<K: copy + drop, V>(table: &Table<K, V>): bool {
        table.length == 0
    }

    spec empty {
        pragma intrinsic;
    }

    /// Acquire a mutable reference to the value which `key` maps to.
    /// Insert the pair (`key`, `default`) first if there is no entry for `key`.
    public fun borrow_mut_with_default<K: copy + drop, V: drop>(table: &mut Table<K, V>, key: K, default: V): &mut V {
        if (!contains(table, copy key)) {
            add(table, copy key, default)
        };
        borrow_mut(table, key)
    }

    spec borrow_mut_with_default {
        pragma opaque, verify=false;
        aborts_if false;
        // TODO: Prover need to extend with supporting the `borrow_mut_with_default` pragma.
        // `table.length` cannot be accessed because the struct is intrinsic.
        // It seems not possible to write an abstract postcondition for this function.
    }

    /// Insert the pair (`key`, `value`) if there is no entry for `key`.
    /// update the value of the entry for `key` to `value` otherwise
    public fun upsert<K: copy + drop, V: drop>(table: &mut Table<K, V>, key: K, value: V) {
        if (!contains(table, copy key)) {
            add(table, copy key, value)
        } else {
            let ref = borrow_mut(table, key);
            *ref = value;
        };
    }

    /// Remove from `table` and return the value which `key` maps to.
    /// Aborts if there is no entry for `key`.
    public fun remove<K: copy + drop, V>(table: &mut Table<K, V>, key: K): V {
        let Box{val} = remove_box<K, V, Box<V>>(table, key);
        table.length = table.length - 1;
        val
    }

    spec remove {
        pragma intrinsic;
    }

    /// Returns true iff `table` contains an entry for `key`.
    public fun contains<K: copy + drop, V>(table: &Table<K, V>, key: K): bool {
        contains_box<K, V, Box<V>>(table, key)
    }

    spec contains {
        pragma intrinsic;
    }

    #[test_only]
    /// Testing only: allows to drop a table even if it is not empty.
    public fun drop_unchecked<K: copy + drop, V>(table: Table<K, V>) {
        drop_unchecked_box<K, V, Box<V>>(table)
    }

    #[test_only]
    struct TableHolder<phantom K: copy + drop, phantom V: drop> has key {
        t: Table<K, V>
    }

    #[test(account = @0x1)]
    fun test_upsert(account: signer) {
        let t = new<u64, u8>();
        let key: u64 = 111;
        let error_code: u64 = 1;
        assert!(!contains(&t, key), error_code);
        upsert(&mut t, key, 12);
        assert!(*borrow(&t, key) == 12, error_code);
        upsert(&mut t, key, 23);
        assert!(*borrow(&t, key) == 23, error_code);

        move_to(&account, TableHolder { t });
    }

    #[test(account = @0x1)]
    fun test_borrow_with_default(account: signer) {
        let t = new<u64, u8>();
        let key: u64 = 100;
        let error_code: u64 = 1;
        assert!(!contains(&t, key), error_code);
        assert!(*borrow_with_default(&t, key, &12) == 12, error_code);
        add(&mut t, key, 1);
        assert!(*borrow_with_default(&t, key, &12) == 1, error_code);

        move_to(&account, TableHolder{ t });
    }


    // ======================================================================================================
    // Internal API

    /// Wrapper for values. Required for making values appear as resources in the implementation.
    struct Box<V> has key, drop, store {
        val: V
    }

    // Primitives which take as an additional type parameter `Box<V>`, so the implementation
    // can use this to determine serialization layout.
    native fun new_table_handle<K, V>(): address;
    native fun add_box<K: copy + drop, V, B>(table: &mut Table<K, V>, key: K, val: Box<V>);
    native fun borrow_box<K: copy + drop, V, B>(table: &Table<K, V>, key: K): &Box<V>;
    native fun borrow_box_mut<K: copy + drop, V, B>(table: &mut Table<K, V>, key: K): &mut Box<V>;
    native fun contains_box<K: copy + drop, V, B>(table: &Table<K, V>, key: K): bool;
    native fun remove_box<K: copy + drop, V, B>(table: &mut Table<K, V>, key: K): Box<V>;
    native fun destroy_empty_box<K: copy + drop, V, B>(table: &Table<K, V>);
    native fun drop_unchecked_box<K: copy + drop, V, B>(table: Table<K, V>);

    // Specification functions for tables

    spec native fun spec_len<K, V>(t: Table<K, V>): num;
    spec native fun spec_contains<K, V>(t: Table<K, V>, k: K): bool;
    spec native fun spec_set<K, V>(t: Table<K, V>, k: K, v: V): Table<K, V>;
    spec native fun spec_remove<K, V>(t: Table<K, V>, k: K): Table<K, V>;
    spec native fun spec_get<K, V>(t: Table<K, V>, k: K): V;
}
}
