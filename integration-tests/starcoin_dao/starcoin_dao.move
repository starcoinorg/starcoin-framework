//# init -n test 

//# faucet --addr creator --amount 100000000000

//# faucet --addr alice --amount 10000000000


//# run --signers creator
script{
   use StarcoinFramework::StdlibUpgradeScripts;

   fun main(){
       StdlibUpgradeScripts::upgrade_from_v12_to_v12_1();
   }
}
// check: EXECUTED