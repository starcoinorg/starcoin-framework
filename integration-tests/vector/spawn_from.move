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
