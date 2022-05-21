address StarcoinFramework {
module AccountScripts {
    use StarcoinFramework::Account;
    /// Enable account's auto-accept-token feature.
    /// The script function is reenterable.
    public(script) fun enable_auto_accept_token(account: signer) {
        Account::set_auto_accept_token(&account, true);
    }

    /// Disable account's auto-accept-token feature.
    /// The script function is reenterable.
    public(script) fun disable_auto_accept_token(account: signer) {
        Account::set_auto_accept_token(&account, false);
    }

    /// Remove zero Balance 
    public(script) fun remove_zero_balance<TokenType: store>(account: signer) {
        Account::remove_zero_balance<TokenType>(&account);
    }
}
}