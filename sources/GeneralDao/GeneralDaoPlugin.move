address StarcoinFramework {

module GeneralDaoPlugin {

    use StarcoinFramework::GeneralDaoAccount;
    use StarcoinFramework::Vector;
    use StarcoinFramework::GeneralDaoAccount::{borrow_with_cap, borrow_mut_with_cap, move_to_with_cap, exists_with_cap};
    use StarcoinFramework::Errors;
    use StarcoinFramework::GeneralDaoProposal::plugin;


    const ERROR_PLUGIN_EXISTS: u64 = 101;
    const ERROR_PLUGIN_NOT_EXISTS: u64 = 102;
    const ERROR_PLUGIN_NOT_REGISTERED: u64 = 103;

    struct PluginCapability<phantom DaoType> has key, store {}

    /// This structure represents a DAO type that allows plugins to be added,
    /// which is used to index the binding information of the name and type
    struct PluginDaoRegister<phantom DaoType> has store {
        table: vector<PluginDaoRegisterItem>,
    }

    struct PluginDaoRegisterItem {
        name: vector<u8>,
        required: bool,
    }

    /// Indicates which plugins are currently added to the actual proposal
    struct PluginProposalRegisterTable<phantom DaoType> has store, copy, drop {
        table: vector<vector<u8>>
    }

    /// The plugin registration which attach with Plugin Type
    struct PluginProposalRegisterBindInfo<phantom DaoType, phantom PluginT> has key {
        name: vector<u8>,
    }

    /// The real plugin data
    struct Plugin<phantom DaoType, phantom PluginT> has key {
        name: vector<u8>,
        plugin: PluginT
    }

    /// Genesis PluginRegister struct to delegate signer
    public fun create_dao_plugin_table<DaoType>(delegate_signer: &GeneralDaoAccount::SignerCapability)
    : PluginCapability<DaoType> {
        move_to_with_cap(delegate_signer, PluginDaoRegister<DaoType>{
            table: Vector::empty(),
        });
        PluginCapability<DaoType>{}
    }

    /// Calling by DAO creator
    /// This function specified the plugin's binding pair of types and names that restricted the creation of proposal
    public fun register_plugin_name<DaoType, PluginT>(delegate_signer: &GeneralDaoAccount::SignerCapability,
                                                      plugin_name: &vector<u8>,
                                                      required: bool) {
        let table = borrow_mut_with_cap<PluginDaoRegister<DaoType>>(delegate_signer);
        Vector::push_back(&mut table.table, PluginDaoRegisterItem{
            name: *plugin_name,
            required
        });

        move_to_with_cap(delegate_signer, PluginProposalRegisterBindInfo<DaoType, PluginT>{
            name: *plugin_name,
        });
    }

    public fun create_empty_register_table<DaoType>()
    : PluginProposalRegisterTable<DaoType> {
        PluginProposalRegisterTable<DaoType>{
            table: Vector::empty(),
        }
    }

    /// Destroy register table
    public fun destroy_empty_table<DaoType>(table: PluginProposalRegisterTable<DaoType>) {
        assert!(Vector::is_empty(&table.table));
        let PluginProposalRegisterTable<DaoType>{
            table: t
        } = table;
        Vector::destroy_empty(t);
    }

    public fun check_plugin_table_completed<DaoType>(
        delegate_signer: &GeneralDaoAccount::SignerCapability,
        proposal_table: &PluginProposalRegisterTable<DaoType>): bool {
        let dao_table  = borrow_mut_with_cap<PluginDaoRegister<DaoType>>(delegate_signer);

        let i = 0;
        let len = Vector::length(&dao_table.table);
        loop {
            let item = Vector::borrow(&dao_table.table, i);
            if (item.required && !Vector::contains(&proposal_table.table, &item.name)) {
                return false
            };
            i = i + 1;
            if (i > len) {
                break;
            }
        };
        true
    }

    /// Register actual plugin data to proposal creator
    public fun register_plugin_data<DaoType, PluginT>(proposal_signer: &signer,
                                                      delegate_signer: &GeneralDaoAccount::SignerCapability,
                                                      table: &mut PluginProposalRegisterTable<DaoType>,
                                                      plugin: PluginT) {
        // check the plugin type has registered ?
        assert!(exists_with_cap<PluginProposalRegisterBindInfo<DaoType, PluginT>>(delegate_signer),
            Errors::invalid_state(ERROR_PLUGIN_NOT_REGISTERED));

        let register =
            borrow_with_cap<PluginProposalRegisterBindInfo<DaoType, PluginT>>(delegate_signer);

        // Add to registered data table
        Vector::push_back(&mut table.table, PluginRegisterItem{
            name: *&register.name,
        });

        move_to(proposal_signer, Plugin<DaoType, PluginT>{
            name: register.name,
            plugin,
        });
    }

    /// After execution, the plugin name must be removed from copied table
    public fun remove_from_table<DaoType, PluginT>(proposal_creator: address,
                                                   table: &mut PluginProposalRegisterTable<DaoType>): PluginT acquires Plugin {
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
