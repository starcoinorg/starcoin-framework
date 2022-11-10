//# init -n dev

//# faucet --addr alice --amount 10000000000

//# faucet --addr bob --amount 10000000000

//# block --author=0x3 --timestamp 900000

//# run --signers alice
script{
    use StarcoinFramework::DAOAccount;

    fun main(sender: signer){
        DAOAccount::create_account_entry(sender);
    }
}
// check: EXECUTED

//# view --address alice --resource 0x1::DAOAccount::DAOAccountCap

//# package
module 0xbf3a917cf4fb6425b95cc12763e6038b::XDAO {
    use StarcoinFramework::Option;
    use StarcoinFramework::DAOSpace;
    use StarcoinFramework::DAOAccount;
    struct X has store, drop {}
    
    const NAME: vector<u8> = b"X";
    public (script) fun create_new_proposal_dao(
        sender: signer, 
        voting_delay: u64,
        voting_period: u64,
        voting_quorum_rate: u8,
        min_action_delay: u64,
        min_proposal_deposit: u128,)
    {
                
        let config = DAOSpace::new_dao_config(
            voting_delay,
            voting_period,
            voting_quorum_rate,
            min_action_delay,
            min_proposal_deposit,
        );

        let cap = DAOAccount::extract_dao_account_cap(&sender);
        DAOSpace::create_dao<X>(cap, *&NAME, Option::none<vector<u8>>(), Option::none<vector<u8>>(), b"ipfs://description", X{}, config);
        
        let witness = X {};
        let member_cap = DAOSpace::acquire_member_cap<X, X>(&witness);
        DAOSpace::join_member_with_member_cap(&member_cap, &sender, Option::none<vector<u8>>(), Option::none<vector<u8>>(), 1);
    }
}

//# run --signers alice --args {{$.package[0].package_hash}}
script{
    use StarcoinFramework::DAOAccount;

    fun main(sender: signer, package_hash: vector<u8>){
        DAOAccount::submit_upgrade_plan_entry(sender, package_hash, 1, false);
    }
}
// check: EXECUTED

//# block --author=0x3 --timestamp 90240000

//# deploy {{$.package[0].file}} --signers bob

//# run --signers alice
script{
    use 0xbf3a917cf4fb6425b95cc12763e6038b::XDAO;

    fun main(sender: signer){
        XDAO::create_new_proposal_dao(sender, 1000, 1000, 1, 1000, 1000);
    }
}
// check: EXECUTED