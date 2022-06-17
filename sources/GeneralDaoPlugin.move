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


module GeneralDaoPlugin {

    use StarcoinFramework::GeneralDaoAccount;
    use StarcoinFramework::Vector;
    use StarcoinFramework::GeneralDaoAccount::{borrow_with_cap, borrow_mut_with_cap, move_to_with_cap, exists_with_cap};
    use StarcoinFramework::Errors;


    const ERROR_PLUGIN_EXISTS: u64 = 101;
    const ERROR_PLUGIN_NOT_EXISTS: u64 = 102;
    const ERROR_PLUGIN_NOT_REGISTERED: u64 = 103;

    struct PluginCapability<phantom DaoType> has key, store {}

    /// Represented register table of plugin, which saved in to DAO delegate account
    struct PluginRegistarTable<phantom DaoType> has store, copy, drop {
        table: vector<vector<u8>>
    }

    struct PluginRegister<phantom DaoType, phantom PluginT> has key {
        name: vector<u8>,
        required: bool,
    }

    struct Plugin<phantom DaoType, phantom PluginT> has key {
        name: vector<u8>,
        plugin: PluginT
    }

    /// Genesis PluginRegister struct to delegate signer
    public fun create_dao_plugin_table<DaoType>(delegate_signer: &GeneralDaoAccount::SignerCapability)
    : PluginCapability<DaoType> {
        move_to_with_cap(delegate_signer, PluginRegistarTable<DaoType>{
            table: Vector::empty<vector<u8>>(),
        });
        PluginCapability<DaoType>{}
    }

    /// Add plugin to register table, created by dao creator
    public fun register_plugin_name<DaoType, PluginT>(delegate_signer: &GeneralDaoAccount::SignerCapability,
                                                      plugin_name: &vector<u8>,
                                                      required: bool) {
        let table = borrow_mut_with_cap<PluginRegistarTable<DaoType>>(delegate_signer);
        Vector::push_back(&mut table.table, *plugin_name);

        move_to_with_cap(delegate_signer, PluginRegister<DaoType, PluginT>{
            name: *plugin_name,
            required,
        });
    }

    public fun create_empty_table<DaoType>()
    : PluginRegistarTable<DaoType> {
        PluginRegistarTable<DaoType>{
            table: Vector::empty<vector<u8>>(),
        }
    }

    /// Destroy register table
    public fun destroy_empty_table<DaoType>(table: PluginRegistarTable<DaoType>) {
        assert!(Vector::is_empty<vector<u8>>(&table.table));
        let PluginRegistarTable<DaoType>{
            table: t
        } = table;
        Vector::destroy_empty(t);
    }

    public fun check_plugin_table_completed<DaoType>(delegate_signer: &GeneralDaoAccount::SignerCapability,
                                                     table: &PluginRegistarTable<DaoType>) {}

    /// Register actual plugin data to proposal creator
    public fun register_plugin_data<DaoType, PluginT>(proposal_signer: &signer,
                                                      delegate_signer: &GeneralDaoAccount::SignerCapability,
                                                      table: &mut PluginRegistarTable<DaoType>,
                                                      plugin: PluginT) {
        // check the plugin type has registered ?
        assert!(exists_with_cap<PluginRegister<DaoType, PluginT>>(delegate_signer),
            Errors::invalid_state(ERROR_PLUGIN_NOT_REGISTERED));

        let register =
            borrow_with_cap<PluginRegister<DaoType, PluginT>>(delegate_signer);

        // Add to registered data table
        Vector::push_back(&mut table.table, *&register.name);

        move_to(proposal_signer, Plugin<DaoType, PluginT>{
            name: register.name,
            plugin,
        });
    }

    /// After execution, the plugin name must be removed from copied table
    public fun remove_from_table<DaoType, PluginT>(proposal_creator: address,
                                                   table: &mut PluginRegistarTable<DaoType>): PluginT acquires Plugin {
        let Plugin<DaoType, PluginT>{
            name,
            plugin,
        } = move_from<Plugin<DaoType, PluginT>>(proposal_creator);
        let (found, idx) = Vector::index_of(&table.table, &name);
        assert!(found, Errors::invalid_state(ERROR_PLUGIN_NOT_EXISTS));
        Vector::remove(&mut table.table, idx);
        plugin
    }
}
}
