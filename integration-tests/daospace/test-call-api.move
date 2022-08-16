//# init -n dev --debug

//# faucet --addr creator --amount 100000000000

//# call-api chain.info

//# call-api state.get_with_proof_by_root_raw ["0x6bfb460477adf9dd0455d3de2fc7f211/1/0x00000000000000000000000000000001::IdentifierNFT::IdentifierNFT<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMember<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>,0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::DaoMemberBody<0x6bfb460477adf9dd0455d3de2fc7f211::SBTModule::SbtTestDAO>>","{{$.call-api[0].head.state_root}}"]

//# run --signers creator --args {{$.call-api[1]}}
script{
    use StarcoinFramework::Debug;

    fun main(_sender: signer, snpashot_raw_proofs: vector<u8>){
        Debug::print(&snpashot_raw_proofs);
    }
}
// check: EXECUTED