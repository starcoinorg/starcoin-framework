module StarcoinFramework::MintProposalPlugin{
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Vector;
    use StarcoinFramework::InstallPluginProposalPlugin;
    use StarcoinFramework::Token;
    use StarcoinFramework::Account;

    struct MintProposalPlugin has store, drop{}

    /// MintToken request.
    struct MintTokenAction<phantom TokenT: store> has copy, drop, store {
        /// the receiver of minted tokens.
        receiver: address,
        /// how many tokens to mint.
        amount: u128,
    }

    public fun required_caps():vector<CapType>{
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::token_mint_cap_type());
        Vector::push_back(&mut caps, DAOSpace::token_burn_cap_type());
        caps 
    }

    const ERR_NOT_RECEIVER :u64 = 101;

    public (script) fun create_mint_proposal<DAOT: store, TokenT:store>(sender: signer, description: vector<u8>, receiver: address, amount: u128, action_delay: u64){
        let witness = MintProposalPlugin{};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, MintProposalPlugin>(&witness);
        let action = MintTokenAction<TokenT>{
            receiver,
            amount,
        };
        DAOSpace::create_proposal(&cap, &sender, action, description, action_delay);
    }

    public (script) fun execute_mint_proposal<DAOT: store, TokenT:store>(sender: signer, proposal_id: u64){
        let witness = MintProposalPlugin{};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, MintProposalPlugin>(&witness);
        let MintTokenAction<TokenT>{receiver, amount} = DAOSpace::execute_proposal<DAOT, MintProposalPlugin, MintTokenAction<TokenT>>(&proposal_cap, &sender, proposal_id);
        assert!(receiver == Signer::address_of(&sender),Errors::not_published(ERR_NOT_RECEIVER));
        let cap = DAOSpace::acquire_token_mint_cap<DAOT, MintProposalPlugin, TokenT>(&witness);
        let tokens = Token::mint_with_capability<TokenT>(&cap, amount);
        Account::deposit(receiver, tokens);
    }

    public (script) fun install_plugin_proposal<DAOT:store>(sender:signer, description: vector<u8>, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, MintProposalPlugin>(&sender, required_caps(), description, action_delay);
    } 
}