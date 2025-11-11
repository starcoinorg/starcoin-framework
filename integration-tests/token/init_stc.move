//# init -n dev

//# faucet --addr alice

//# faucet --addr Genesis

//# run --signers alice
script {
    use StarcoinFramework::TreasuryWithdrawDaoProposal;
    use StarcoinFramework::STC;

    fun main(alice: signer) {
        let cap = STC::initialize_v2(&alice, 500, 0, 0, 0, 0);
        TreasuryWithdrawDaoProposal::plugin(&alice, cap);
    }
}
// check: ABORTED, Token, 25858


//# run --signers Genesis

script {
    use StarcoinFramework::TreasuryWithdrawDaoProposal;
    use StarcoinFramework::STC;

    fun main(genesis: signer) {
        let cap = STC::initialize_v2(&genesis, 500, 0, 0, 0, 0);

        TreasuryWithdrawDaoProposal::plugin(&genesis, cap);
    }
}
// check: ABORTED, Token, 28161
