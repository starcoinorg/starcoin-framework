address StarcoinFramework {

module GeneralDao {

    use StarcoinFramework::Account;
    use StarcoinFramework::Signer;
    use StarcoinFramework::GeneralDaoNFT;
    use StarcoinFramework::GeneralDaoAccount;

    struct DaoGlobal<phantom DaoType> {
        next_id: u64,
    }

    struct Dao<phantom DaoType> has key {
        id: u64,
        voting_delay: u128,
        voting_duration: u128,
        name: vector<u8>,
        creator: address,
    }

    public fun new_dao<DaoType: store>(signer: &signer, name: &vector<u8>, voting_delay: u128, voting_duration: u128): (u64, address) {
        // Create delegate account
        let dao_address = GeneralDaoAccount::create_account(signer);
        let dao_signer = GeneralDaoAccount::dao_signer(dao_address);

        let storage_cap = GeneralDaoAccount::apply_storage_capability(dao_address);
        let issue_cap = GeneralDaoNFT::register_dao_nft<DaoType>(&dao_signer);

//        // Create plugin
//        let (_, signer_cap) = Account::create_delegate_account(signer);
//        let dao_signer = Account::create_signer_with_cap(&signer_cap);
//
//        let creator = Signer::address_of(signer);
//
//        move_to(&dao_signer, Dao<DaoType>{
//            id: get_next_id<DaoType>(),
//            voting_delay,
//            voting_duration,
//            name: *name,
//            creator,
//        });
//
//        GeneralDaoNFT::issue_nft(&dao_signer, creator);
//
//        move_to(&signer, DaoSignerDelegate{
//            signer_cap,
//            nft_issue_cap
//        });
//
//        // 初始化 dao 的时候无法一次性完成，需要先把 cap 都存到 creator 账号下
//        creator

        // 然后按照 plugin 的方式逐步初始化
    }

    public fun upgrade_to_dao<DaoType>(signer: &signer) {

    }

    /// Register a dao frmo broker
    public fun register_dao<DaoType>(signer: &signer, broker: address) {

    }

    /// Register a dao frmo broker
    public fun unregister_dao<DaoType>(signer: &signer, broker: address) {

    }


    fun get_next_id<DaoType>(): u64 {
        0
    }
}
}
