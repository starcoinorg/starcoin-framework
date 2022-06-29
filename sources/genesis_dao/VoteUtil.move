module StarcoinFramework::VoteUtil{

    public fun get_vote_weight_from_sbt_snapshot(_sender: address, _state_root: vector<u8>, _sbt_proof:vector<u8>) : u128{
        //verify sbt_proof with state_root
        //read sbt value from sbt proof's leaf
        0u128
    }

}