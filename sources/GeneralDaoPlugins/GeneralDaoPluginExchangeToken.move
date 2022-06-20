address StarcoinFramework {
module GenenralDaoPluginExechangeToken {

    use StarcoinFramework::Token;

    struct Plugin<phantom DaoType, phantom TokenX, phantom TokenY> has key, store {
        token_x: Token::Token<TokenX>,
        token_y: Token::Token<TokenX>,
        to_user: address,
    }

    public fun plugin_name(): vector<u8> {
        b"exchange_token"
    }

    public fun create_plugin<DaoType, TokenX, TokenY>(to_user: address,
                                                      token_x: Token::Token<TokenX>,
                                                      token_y: Token::Token<TokenY>)
    : Plugin<DaoType, TokenX, TokenY> {
        Plugin<DaoType, TokenX, TokenY>{ token_x, token_y, to_user }
    }

    public fun execute<DaoType, TokenX, TokenY>(plugin: Plugin<DaoType, TokenX, TokenY>) {
        let Plugin<DaoType, TokenX, TokenY>{ to_user, token_x, token_y } = plugin;
        // TODO
    }
}
}