address StarcoinFramework {

/// A ring-shaped container that can hold any type, indexed from 0
/// The capacity is fixed at creation time, and the accessible index is constantly growing
module Ring {

    use StarcoinFramework::Vector;
    use StarcoinFramework::Option;
    use StarcoinFramework::Errors;


    /// The index into the vector is out of bounds
    const ERROR_RING_INDEX_OUT_OF_BOUNDS:u64 = 101;

    struct Ring<Element> has store{
        data            : vector<Option::Option<Element>>,
        insertion_index : u64,
        external_index  : u64
    }

    /// Create a Ring with capacity.
    public fun create_with_capacity<Element>( len: u64 ):Ring<Element>{
        let data = Vector::empty<Option::Option<Element>>();
        let i = 0;
        while(i < len){
            Vector::push_back(&mut data , Option::none<Element>());
            i = i + 1;
        };
        Ring {
            data             : data,
            insertion_index  : 0,
            external_index   : 0,
        }
    }

    spec create_with_capacity{
        pragma verify = false;
    }

    ///is Ring full
    public fun is_full<Element>(r: &Ring<Element>):bool{
        Option::is_some(Vector::borrow(&r.data, r.insertion_index))
    }

    spec is_full{
        pragma verify = false;
    }

    ///Return the capacity of the Ring.
    public fun capacity<Element>(r: &Ring<Element>): u64{
        Vector::length( &r.data )
    }

    spec capacity{
        pragma verify = false;
    }
    
    /// Add element `e` to the insertion_index of the Ring `r`.
    public fun push<Element> (r: &mut Ring<Element> , e: Element):Option::Option<Element>{
        let op_e = Vector::borrow_mut<Option::Option<Element>>(&mut r.data, r.insertion_index);
        let res = if(  Option::is_none<Element>(op_e) ){
            Option::fill( op_e, e);
            Option::none<Element>()
        }else{
           Option::some<Element>( Option::swap( op_e, e) )
        };
        r.insertion_index = ( r.insertion_index + 1 ) % Vector::length(&r.data);
        r.external_index = r.external_index + 1;
        res
    }

    spec push{
        pragma verify = false;
    }
    
    /// Return a reference to the `i`th element in the Ring `r`.
    public fun borrow<Element>(r:& Ring<Element>, i: u64):&Option::Option<Element>{
        let len = capacity<Element>(r);
        if( r.external_index > len - 1) {
            assert!( i >= r.external_index - len && i < r.external_index , Errors::invalid_argument(ERROR_RING_INDEX_OUT_OF_BOUNDS));
            Vector::borrow(&r.data, i % len)
        }else {
            assert!( i < len , Errors::invalid_argument(ERROR_RING_INDEX_OUT_OF_BOUNDS));
            Vector::borrow(&r.data, i )
        }
    }

    spec borrow{
        pragma verify = false;
    }

    /// Return a mutable reference to the `i`th element in the Ring `r`.
    public fun borrow_mut<Element>(r: &mut Ring<Element>, i: u64):&mut Option::Option<Element>{
        let len = capacity<Element>(r);
        if( r.external_index > len - 1) {
            assert!( i >= r.external_index - len && i < r.external_index , Errors::invalid_argument(ERROR_RING_INDEX_OUT_OF_BOUNDS));
            Vector::borrow_mut(&mut r.data, i % len)
        }else {
            assert!( i < len , Errors::invalid_argument(ERROR_RING_INDEX_OUT_OF_BOUNDS));
            Vector::borrow_mut(&mut r.data, i )
        }
        
    }

    spec borrow_mut{
        pragma verify = false;
    }


    /// Return `Option::Option<u64>` if `e` is in the Ring `r` at index `i`.
    /// Otherwise, returns `Option::none<u64>`.
    public fun index_of<Element>(r: &Ring<Element>, e: &Element):Option::Option<u64>{
        let i = 0;
        let len = capacity<Element>(r);
        while ( i < len ) {
            if ( Option::borrow(Vector::borrow( &r.data, i )) == e) return Option::some(i + r.external_index - len);
            i = i + 1;
        };
        Option::none<u64>()
    }

    spec index_of{
        pragma verify = false;
    }    

    /// Destroy the Ring `r`.
    /// Returns the vector<Element> saved by ring
    public fun destroy<Element>(r: Ring<Element>):vector<Element>{
        let Ring {
            data            : data ,
            insertion_index : _,
            external_index  : _,
        } = r ;
        let len = Vector::length(&data);
        let i = 0;
        let vec = Vector::empty<Element>();
        while ( i < len ) {
            let op_e = Vector::pop_back( &mut data );
            if ( Option::is_some(&op_e) ) {
                Vector::push_back(&mut vec, Option::destroy_some(op_e))
            }else {
               Option::destroy_none(op_e)
            };
            i = i + 1;
        };
        Vector::destroy_empty(data);
        vec
    }

    spec destroy{
        pragma verify = false;
    }  
}
}