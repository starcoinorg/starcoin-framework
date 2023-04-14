/// The `string` module defines the `String` type which represents UTF8 encoded strings.
module StarcoinFramework::String {
    use StarcoinFramework::Errors;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Option::{Self, Option};

    /// An invalid UTF8 encoding.
    const EINVALID_UTF8: u64 = 1;

    /// Index out of range.
    const EINVALID_INDEX: u64 = 2;

    /// A `String` holds a sequence of bytes which is guaranteed to be in utf8 format.
    struct String has copy, drop, store {
        bytes: vector<u8>,
    }

    /// Creates a new string from a sequence of bytes. Aborts if the bytes do not represent valid utf8.
    public fun utf8(bytes: vector<u8>): String {
        assert!(internal_check_utf8(&bytes), Errors::invalid_state(EINVALID_UTF8));
        String{bytes}
    }

    spec fun spec_utf8(bytes: vector<u8>): String {
        String{bytes}
    }

    /// Tries to create a new string from a sequence of bytes.
    public fun try_utf8(bytes: vector<u8>): Option<String> {
        if (internal_check_utf8(&bytes)) {
            Option::some(String{bytes})
        } else {
            Option::none()
        }
    }

    /// Returns a reference to the underlying byte vector.
    public fun bytes(s: &String): &vector<u8> {
        &s.bytes
    }

    /// Checks whether this string is empty.
    public fun is_empty(s: &String): bool {
        Vector::is_empty(&s.bytes)
    }

    /// Returns the length of this string, in bytes.
    public fun length(s: &String): u64 {
        Vector::length(&s.bytes)
    }

    /// Appends a string.
    public fun append(s: &mut String, r: String) {
        Vector::append(&mut s.bytes, *&r.bytes)
    }

    /// Appends bytes which must be in valid utf8 format.
    public fun append_utf8(s: &mut String, bytes: vector<u8>) {
        append(s, utf8(bytes))
    }

    /// Insert the other string at the byte index in given string. The index must be at a valid utf8 char
    /// boundary.
    public fun insert(s: &mut String, at: u64, o: String) {
        let bytes = &s.bytes;
        assert!(at <= Vector::length(bytes) && internal_is_char_boundary(bytes, at), Errors::invalid_state(EINVALID_INDEX));
        let l = length(s);
        let front = sub_string(s, 0, at);
        let end = sub_string(s, at, l);
        append(&mut front, o);
        append(&mut front, end);
        *s = front;
    }

    /// Returns a sub-string using the given byte indices, where `i` is the first byte position and `j` is the start
    /// of the first byte not included (or the length of the string). The indices must be at valid utf8 char boundaries,
    /// guaranteeing that the result is valid utf8.
    public fun sub_string(s: &String, i: u64, j: u64): String {
        let bytes = &s.bytes;
        let l = Vector::length(bytes);
        assert!(
            j <= l && i <= j && internal_is_char_boundary(bytes, i) && internal_is_char_boundary(bytes, j),
            Errors::invalid_state(EINVALID_INDEX)
        );
        String{bytes: internal_sub_string(bytes, i, j)}
    }

    /// Computes the index of the first occurrence of a string. Returns `length(s)` if no occurrence found.
    public fun index_of(s: &String, r: &String): u64 {
        internal_index_of(&s.bytes, &r.bytes)
    }


    // Native API
    native fun internal_check_utf8(v: &vector<u8>): bool;
    native fun internal_is_char_boundary(v: &vector<u8>, i: u64): bool;
    native fun internal_sub_string(v: &vector<u8>, i: u64, j: u64): vector<u8>;
    native fun internal_index_of(v: &vector<u8>, r: &vector<u8>): u64;

    spec internal_check_utf8(v: &vector<u8>): bool {
        pragma opaque;
        aborts_if [abstract] false;
        ensures [abstract] result == spec_internal_check_utf8(v);
    }

    spec internal_is_char_boundary(v: &vector<u8>, i: u64): bool {
        pragma opaque;
        aborts_if [abstract] false;
        ensures [abstract] result == spec_internal_is_char_boundary(v, i);
    }
    spec internal_sub_string(v: &vector<u8>, i: u64, j: u64): vector<u8> {
        pragma opaque;
        aborts_if [abstract] false;
        ensures [abstract] result == spec_internal_sub_string(v, i, j);
    }
    spec internal_index_of(v: &vector<u8>, r: &vector<u8>): u64 {
        pragma opaque;
        aborts_if [abstract] false;
        ensures [abstract] result == spec_internal_index_of(v, r);
    }

    spec module {
        fun spec_internal_check_utf8(v: vector<u8>): bool;
        fun spec_internal_is_char_boundary(v: vector<u8>, i: u64): bool;
        fun spec_internal_sub_string(v: vector<u8>, i: u64, j: u64): vector<u8>;
        fun spec_internal_index_of(v: vector<u8>, r: vector<u8>): u64;
    }
}