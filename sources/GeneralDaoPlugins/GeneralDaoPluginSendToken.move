address StarcoinFramework {

module GenenralDaoPluginSendToken {

    use StarcoinFramework::Token;
    use StarcoinFramework::Account;

    struct Plugin<phantom DaoType, phantom TokenT> has key, store {
        token: Token::Token<TokenT>,
        to_user: address,
    }

    public fun plugin_name(): vector<u8> {
        b"send_token"
    }

    public fun create_plugin<DaoType, TokenT>(to_user: address,
                                              token: Token::Token<TokenT>)
    : Plugin<DaoType, TokenT> {
        Plugin<DaoType, TokenT>{
            token,
            to_user,
        }
    }

    public fun execute<DaoType, TokenT: store>(plugin: Plugin<DaoType, TokenT>) {
        let Plugin<DaoType, TokenT>{ to_user, token } = plugin;
        Account::deposit<TokenT>(to_user, token)
    }
}
}
