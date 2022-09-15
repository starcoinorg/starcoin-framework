module StarcoinFramework::MintProposalPlugin{
    use StarcoinFramework::GenesisSignerCapability;
    use StarcoinFramework::CoreAddresses;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Option;
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Signer;
    use StarcoinFramework::Vector;
    use StarcoinFramework::InstallPluginProposalPlugin;
    use StarcoinFramework::Token;
    use StarcoinFramework::Account;

    const ERR_ALREADY_INITIALIZED: u64 = 100;

    struct MintProposalPlugin has key, store, drop{}

    /// MintToken request.
    struct MintTokenAction<phantom TokenT: store> has copy, drop, store {
        /// the receiver of minted tokens.
        receiver: address,
        /// how many tokens to mint.
        amount: u128,
    }

    public fun initialize() {
        assert!(!exists<MintProposalPlugin>(CoreAddresses::GENESIS_ADDRESS()), Errors::already_published(ERR_ALREADY_INITIALIZED));
        let signer = GenesisSignerCapability::get_genesis_signer();
        
        DAOPluginMarketplace::register_plugin<MintProposalPlugin>(
            &signer,
            b"0x1::MintProposalPlugin",
            b"The plugin for minting tokens.",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();

        DAOPluginMarketplace::publish_plugin_version<MintProposalPlugin>(
            &signer, 
            b"v0.1.0", 
            *&implement_extpoints,
            *&depend_extpoints,
            b"inner-plugin://mint-proposal-plugin",
        );
    }

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::token_mint_cap_type());
        caps 
    }

    const ERR_NOT_RECEIVER :u64 = 101;
    const ERR_NO_MINT_CAP: u64 = 102;

    public fun delegate_token_mint_cap<DAOT: store, TokenT: store>(sender: &signer) {    
        let witness = MintProposalPlugin {};
        let mint_cap = Token::remove_mint_capability<TokenT>(sender);
        DAOSpace::delegate_token_mint_cap<DAOT, MintProposalPlugin, TokenT>(mint_cap, &witness);
    }

    public (script) fun delegate_token_mint_cap_entry<DAOT: store, TokenT: store>(sender: signer) {        
        delegate_token_mint_cap<DAOT, TokenT>(&sender);
    }

    public fun create_mint_proposal<DAOT: store, TokenT:store>(sender: &signer, description: vector<u8>, receiver: address, amount: u128, action_delay: u64){
        let witness = MintProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, MintProposalPlugin>(&witness);
        let action = MintTokenAction<TokenT>{
            receiver,
            amount,
        };
        DAOSpace::create_proposal(&cap, sender, action, description, action_delay);
    }

    public (script) fun create_mint_proposal_entry<DAOT: store, TokenT:store>(sender: signer, description: vector<u8>, receiver: address, amount: u128, action_delay: u64){
        create_mint_proposal<DAOT, TokenT>(&sender, description, receiver, amount, action_delay);
    }

    public fun execute_mint_proposal<DAOT: store, TokenT:store>(sender: &signer, proposal_id: u64){
        let witness = MintProposalPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, MintProposalPlugin>(&witness);
        let MintTokenAction<TokenT>{receiver, amount} = DAOSpace::execute_proposal<DAOT, MintProposalPlugin, MintTokenAction<TokenT>>(&proposal_cap, sender, proposal_id);
        assert!(receiver == Signer::address_of(sender),Errors::not_published(ERR_NOT_RECEIVER));
        let tokens = DAOSpace::mint_token<DAOT, MintProposalPlugin, TokenT>(amount, &witness);
        Account::deposit<TokenT>(receiver, tokens);
    }

    public (script) fun execute_mint_proposal_entry<DAOT: store, TokenT:store>(sender: signer, proposal_id: u64){
        execute_mint_proposal<DAOT, TokenT>(&sender, proposal_id);
    }

    public fun install_plugin_proposal<DAOT:store>(sender:&signer, plugin_version: u64, description: vector<u8>, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, MintProposalPlugin>(sender, plugin_version, required_caps(), description, action_delay);
    }

    public (script) fun install_plugin_proposal_entry<DAOT:store>(sender:signer, plugin_version: u64, description: vector<u8>, action_delay:u64){
        install_plugin_proposal<DAOT>(&sender, plugin_version, description, action_delay);
    }

}