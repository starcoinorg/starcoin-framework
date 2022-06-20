address StarcoinFramework {
module GeneralDaoStateGuard {

    use StarcoinFramework::Errors;

    friend StarcoinFramework::GeneralDao;
    friend StarcoinFramework::GeneralDaoMember;


    const ERROR_STATE_NOT_MATCH: u64 = 101;

    /// The section of DAO as follow, which to control DAO state can be advance to next section
    ///
    struct Dao {}

    struct Member {}

    struct Plugin {}

    struct Proposal {}

    struct Action {}

    struct Guard<phantom Type> has store, drop {
        state: u8,
    }

    public fun check_guard<Type>(u: &Guard<Type>, s: u8) {
        assert!(u.state == s, Errors::invalid_state(ERROR_STATE_NOT_MATCH))
    }

    public fun typeof<Type, OtherType>(u: &Guard<Type>): bool {
        BCS::to_bytes<Guard<Type>>(&guard) =
            gen_guard<OtherType>(0)
    }

    public(friend) fun gen_guard<Type>(init_state: u8): Guard<Type> {
        Guard{
            state: init_state
        }
    }
}
}
