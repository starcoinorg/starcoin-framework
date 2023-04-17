//# init -n dev

//# faucet --addr alice --amount 100000000000000000

//# run --signers alice
script {
    use StarcoinFramework::Vector;

    fun main() {
        let v = Vector::empty<u64>();
        let i = 0;
        while (i < 10000) {
            Vector::push_back(&mut v, i);
            i = i + 1;
        };

        let spawn_vec = Vector::spawn_from_vec(&v, 0, 100);
        assert!(Vector::length<u64>(&spawn_vec) == 100, 1000);
        assert!(*Vector::borrow<u64>(&spawn_vec, 0) == 0, 1001);
    }
}


//# run --signers alice
script {
    use StarcoinFramework::Vector;

    fun main() {
        let v = Vector::empty<u64>();
        Vector::push_back(&mut v, 0);
        Vector::push_back(&mut v, 1);
        Vector::push_back(&mut v, 2);
        Vector::push_back(&mut v, 3);
        Vector::push_back(&mut v, 4);
        Vector::push_back(&mut v, 5);

        assert!(Vector::length(&Vector::spawn_from_vec(&v, 0, 3)) == 3, 1010);
        assert!(Vector::length(&Vector::spawn_from_vec(&v, 2, 3)) == 3, 1011);
        assert!(Vector::length(&Vector::spawn_from_vec(&v, 2, 2)) == 2, 1012);
        assert!(Vector::length(&Vector::spawn_from_vec(&v, 0, 5)) == 5, 1013);
        assert!(Vector::length(&Vector::spawn_from_vec(&v, 1, 4)) == 4, 1014);
    }
}
