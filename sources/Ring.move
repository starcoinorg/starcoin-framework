address StarcoinFramework {

module Ring {

    use StarcoinFramework::Vector;
    use StarcoinFramework::Option;

    const ERROR_RING_IS_EMPTY :u64 = 10010;
    const ERROR_RING_INDEX_OUT_OF_BOUNDS:u64 = 10011;

    struct Ring<Element> {
        data            : vector<Option::Option<Element>>,
        insertion_index : u64
    }


    public fun create_with_length<Element>( len: u64 ):Ring<Element>{
        let data = Vector::empty<Option::Option<Element>>();
        let i = 0;
        while(i < len){
            Vector::push_back<Option::Option<Element>>(&mut data , Option::none<Element>());
            i = i + 1;
        };
        Ring {
            data             : data,
            insertion_index  : 0
        }
    }

    spec create_with_length{
        pragma intrinsic = true;
    }

    public fun is_full<Element>(r: &Ring<Element>):bool{
        Option::is_some<Element>(Vector::borrow<Option::Option<Element>>(&r.data, r.insertion_index))
    }

    spec is_full{
        pragma intrinsic = true;
    }

    public fun length<Element>(r: &Ring<Element>): u64{
        Vector::length<Option::Option<Element>>( &r.data )
    }

    spec length{
        pragma intrinsic = true;
    }

    public fun push<Element> (r: &mut Ring<Element> , e: Element):Option::Option<Element>{
        let op_e = Vector::borrow_mut<Option::Option<Element>>(&mut r.data, r.insertion_index);
        let res = if(  Option::is_none<Element>(op_e) ){
            Option::fill<Element>( op_e, e);
            Option::none<Element>()
        }else{
           Option::some<Element>( Option::swap<Element>( op_e, e) )
        };
        r.insertion_index = ( r.insertion_index + 1 ) % Vector::length<Option::Option<Element>>(&r.data);
        res
    }

    spec push{
        pragma intrinsic = true;
    }

    // public fun set<Element>(r: &mut Ring<Element>):&mut Element{
    //     let len = length<Element>(r);
    //     let next_i = ( len + r.i + 1 ) % len ;
    //     let element = Vector::borrow_mut<Element>(&mut r.v, r.i);
    //     r.i = next_i;
    //     element
    // }

    // spec set{
    //     pragma intrinsic = true;
    // }
    
    public fun borrow<Element>(r:& Ring<Element>, i: u64):&Option::Option<Element>{
        let len = length<Element>(r);
        Vector::borrow<Option::Option<Element>>(&r.data, i % len)
    }

    spec borrow{
        pragma intrinsic = true;
    }

    public fun borrow_mut<Element>(r: &mut Ring<Element>, i: u64):&mut Option::Option<Element>{
        let len = length<Element>(r);
        Vector::borrow_mut<Option::Option<Element>>(&mut r.data, i % len)
    }

    spec borrow_mut{
        pragma intrinsic = true;
    }

    public fun index_of<Element>(r: &Ring<Element>, e: &Element):Option::Option<u64>{
        let i = 0;
        let len = length<Element>(r);
        while ( i < len ) {
            if ( Option::borrow<Element>(Vector::borrow( &r.data, i )) == e) return Option::some(i);
            i = i + 1;
        };
        Option::none<u64>()
    }

    spec index_of{
        pragma intrinsic = true;
    }    

    public fun destroy<Element>(r: Ring<Element>):vector<Element>{
        let Ring {
            data            : data ,
            insertion_index : _,
        } = r ;
        let len = Vector::length<Option::Option<Element>>(&data);
        let i = len;
        let vec = Vector::empty<Element>();
        while ( i > 0 ) {
            let op_e = Vector::pop_back( &mut data );
            if ( Option::is_some<Element>(&op_e) ) {
                Vector::push_back<Element>(&mut vec, Option::destroy_some<Element>(op_e))
            }else {
               Option::destroy_none<Element>(op_e)
            };
            i = i - 1;
        };
        Vector::destroy_empty<Option::Option<Element>>(data);
        vec
    }

    spec destroy{
        pragma intrinsic = true;
    }  
}
}