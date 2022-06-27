address StarcoinFramework {

module Ring {

    use StarcoinFramework::Vector;
    use StarcoinFramework::Option;

    const ERROR_RING_IS_EMPTY :u64 = 10010;
    const ERROR_RING_INDEX_OUT_OF_BOUNDS:u64 = 10011;

    struct Ring<Element> has drop{
        v  : vector<Element>,
        i  : u64
    }

    public fun empty<Element>(): Ring<Element>{
        Ring {
            v :Vector::empty<Element>(),
            i :0
        }
    }

    public fun length<Element>(r: &Ring<Element>): u64{
        Vector::length<Element>( &r.v )
    }

    spec length{
        pragma intrinsic = true;
    }

    public fun add_element<Element>(r: &mut Ring<Element>, e: Element){
        Vector::push_back<Element>(&mut r.v, e);
    }

    spec add_element{
        pragma intrinsic = true;
    }

    public fun delete_element<Element>(r: &mut Ring<Element>):Element{
        assert!(!is_empty<Element>(r), ERROR_RING_IS_EMPTY);
        let e = Vector::pop_back<Element>(&mut r.v);
        if( r.i >= length<Element>(r)){
            r.i = r.i - 1;
        };
        e
    }

    spec delete_element{
        pragma intrinsic = true;
    }

    public fun remove_element<Element>(r: &mut Ring<Element>, i: u64):Element{
        assert!(!is_empty<Element>(r), ERROR_RING_IS_EMPTY);
        let e = Vector::remove<Element>(&mut r.v, i);
        if( r.i > i ){
            r.i = r.i - 1;
        };
        e
    }

    spec remove_element{
        pragma intrinsic = true;
    }


    public fun set<Element>(r: &mut Ring<Element>):&mut Element{
        let len = length<Element>(r);
        let next_i = ( len + r.i + 1 ) % len ;
        let element = Vector::borrow_mut<Element>(&mut r.v, next_i);
        r.i = next_i;
        element
    }

    spec set{
        pragma intrinsic = true;
    }
    
    public fun borrow<Element>(r:& Ring<Element>, i: u64):&Element{
        assert!(!is_empty<Element>(r), ERROR_RING_IS_EMPTY);
        let len = length<Element>(r);  
        assert!( len > i ,ERROR_RING_INDEX_OUT_OF_BOUNDS);
        Vector::borrow<Element>(&r.v, i)
    }

    spec borrow{
        pragma intrinsic = true;
    }

    public fun borrow_mut<Element>(r: &mut Ring<Element>, i: u64):&mut Element{
        assert!(!is_empty<Element>(r), ERROR_RING_IS_EMPTY);
        let len = length<Element>(r);  
        assert!( len > i ,ERROR_RING_INDEX_OUT_OF_BOUNDS);
        Vector::borrow_mut<Element>(&mut r.v, i)
    }

    spec borrow_mut{
        pragma intrinsic = true;
    }

    public fun is_empty<Element>(r:&Ring<Element>): bool{
        Vector::is_empty<Element>(&r.v)
    }

    spec is_empty{
        pragma intrinsic = true;
    }

    public fun index_of<Element>(r:&Ring<Element>, e: &Element):Option::Option<u64>{
        let i = 0;
        let len = length<Element>(r);
        while (i < len) {
            if (Vector::borrow(&r.v, i) == e) return Option::some(i);
            i = i + 1;
        };
        Option::none<u64>()
    }

    spec index_of{
        pragma intrinsic = true;
    }    

    public fun get_index<Element>(r: &Ring<Element>):u64{
        r.i
    }

    spec get_index{
        pragma intrinsic = true;
    }   

}
}