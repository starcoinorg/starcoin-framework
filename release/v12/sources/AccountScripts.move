address StarcoinFramework {
module AccountScripts {
    use StarcoinFramework::Account;
    /// Enable account's auto-accept-token feature.
    /// The script function is reenterable.
    public entry fun enable_auto_accept_token(account: signer) {
        Account::set_auto_accept_token_entry(account, true);
    }

    /// Disable account's auto-accept-token feature.
    /// The script function is reenterable.
    public entry fun disable_auto_accept_token(account: signer) {
        Account::set_auto_accept_token_entry(account, false);
    }

    /// Remove zero Balance 
    public entry fun remove_zero_balance<TokenType: store>(account: signer) {
        Account::remove_zero_balance_entry<TokenType>(account);
    }
}
}