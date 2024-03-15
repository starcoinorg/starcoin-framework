//# init -n dev

//# faucet --addr alice

//# faucet --addr bob


// //# run --signers alice
// script {
//     use StarcoinFramework::STC::STC;
//     use StarcoinFramework::Account;
//     use StarcoinFramework::Authenticator;
//     use StarcoinFramework::DummyToken;
//     use StarcoinFramework::DummyToken::DummyToken;
//
//     fun create_txn_sender_account(account: signer) {
//         let txn_public_key = x"c48b687a1dd8265101b33df6ae0b6825234e3f28df9ecb38fb286cf76dae919d";
//         let auth_key_vec = Authenticator::ed25519_authentication_key(copy txn_public_key);
//         let address = Authenticator::derived_address(auth_key_vec);
//         Account::create_account_with_address<STC>(address);
//         Account::pay_from<STC>(&account, address, 5000);
//         let coin = DummyToken::mint(&account, 500);
//         Account::deposit(address, coin);
//         assert!(Account::balance<DummyToken>(address) == 500, 1000);
//     }
// }
// // check: EXECUTED

// //# run --signers StarcoinAssociation
// script {
//     use StarcoinFramework::FrozenConfigStrategy;
//
//     fun initialize_with_starcoin_association(sender: signer) {
//         FrozenConfigStrategy::initialize(&sender);
//     }
// }
// // check: Executed
//
//
// //# run --signers StarcoinAssociation
// script {
//     use StarcoinFramework::FrozenConfigStrategy;
//
//     fun set_global_frozen_true(sender: signer) {
//         FrozenConfigStrategy::set_global_frozen(&sender, true);
//     }
// }
// // check: Executed
//
//
// //# run --signers Genesis
// script {
//     use StarcoinFramework::TransactionManager;
//     use StarcoinFramework::Account;
//     use StarcoinFramework::STC::STC;
//     use StarcoinFramework::Authenticator;
//     use StarcoinFramework::Vector;
//
//     fun execute_prologue_and_epilogue_failed_cuz_frozen(account: signer) {
//         let txn_public_key = x"c48b687a1dd8265101b33df6ae0b6825234e3f28df9ecb38fb286cf76dae919d";
//         let auth_key_vec = Authenticator::ed25519_authentication_key(copy txn_public_key);
//         let txn_sender = Authenticator::derived_address(copy auth_key_vec);
//         Vector::push_back(&mut txn_public_key, 0u8); //create preimage
//
//         let seq = Account::sequence_number(txn_sender);
//         assert!(seq == 0, 1005);
//
//         let txn_sequence_number = 0;
//         let txn_gas_price = 1;
//         let txn_max_gas_units = 1000;
//
//         TransactionManager::txn_prologue_v2<STC>(
//             &account,
//             txn_sender,
//             txn_sequence_number,
//             txn_public_key,
//             txn_gas_price,
//             txn_max_gas_units,1,1
//         );
//
//         // execute the txn...
//
//         let gas_units_remaining = 10;
//
//         Account::txn_epilogue<STC>(
//             &account,
//             txn_sender,
//             txn_sequence_number,
//             txn_gas_price,
//             txn_max_gas_units,
//             gas_units_remaining
//         );
//         let seq = Account::sequence_number(txn_sender);
//         assert!(seq == 1, 1006);
//     }
// }
// // check: EXECUTED