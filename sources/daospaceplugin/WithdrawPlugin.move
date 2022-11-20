/// Plugin for withdrawing tokens from DAO.
module StarcoinFramework::WithdrawPlugin {
    use StarcoinFramework::Errors;
    use StarcoinFramework::Option;
    use StarcoinFramework::DAOPluginMarketplace;
    use StarcoinFramework::DAOSpace::{Self, CapType};
    use StarcoinFramework::Signer;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Account;
    use StarcoinFramework::InstallPluginProposalPlugin;

    /// Only receiver can execute token withdraw proposal
    const ERR_NOT_RECEIVER: u64 = 101;
    const ERR_INVALID_SCALE_FACTOR: u64 = 102;

    struct WithdrawPlugin has store, drop {}

    /// WithdrawToken request.
    struct WithdrawTokenAction<phantom TokenT> has copy, drop, store {
        /// the receiver of withdraw tokens.
        receiver: address,
        /// Withdraw amount.
        amount: u128,
    }

    /// Scale up quorum_votes for withdraw proposal.
    /// `scale` must be in [0, 100].
    /// The final quorum_votes = (1.0 + scale / 100) * base_quorum_votes
    struct QuorumScale has copy, drop, store {
        scale: u8,
    }

    public fun initialize(_sender: &signer) {
        let witness = WithdrawPlugin {};

        DAOPluginMarketplace::register_plugin<WithdrawPlugin>(
            &witness,
            b"0x1::WithdrawPlugin",
            b"The plugin for withdraw token from Treasury.",
            Option::none(),
        );

        let implement_extpoints = Vector::empty<vector<u8>>();
        let depend_extpoints = Vector::empty<vector<u8>>();

        DAOPluginMarketplace::publish_plugin_version<WithdrawPlugin>(
            &witness,
            b"v0.1.0",
            *&implement_extpoints,
            *&depend_extpoints,
            b"inner-plugin://withdraw-plugin",
        );
    }

    public fun required_caps(): vector<CapType> {
        let caps = Vector::singleton(DAOSpace::proposal_cap_type());
        Vector::push_back(&mut caps, DAOSpace::modify_config_cap_type());
        Vector::push_back(&mut caps, DAOSpace::withdraw_token_cap_type());
        caps
    }

    public fun create_withdraw_proposal<DAOT: store, TokenT: store>(
        sender: &signer,
        title:vector<u8>,
        introduction:vector<u8>,
        extend: vector<u8>,
        receiver: address,
        amount: u128,
        action_delay: u64)
    {
        let witness = WithdrawPlugin {};
        let cap = DAOSpace::acquire_proposal_cap<DAOT, WithdrawPlugin>(&witness);
        let action = WithdrawTokenAction<TokenT> {
            receiver,
            amount,
        };

        if (!DAOSpace::exists_custom_config<DAOT, QuorumScale>()) {
            set_scale_factor_inner<DAOT>(0u8);
        };
        let scale = DAOSpace::get_custom_config<DAOT, QuorumScale>().scale;
        DAOSpace::create_proposal(&cap, sender, action, title, introduction, extend, action_delay, Option::some(scale));
    }

    public(script) fun create_withdraw_proposal_entry<DAOT: store, TokenT: store>(
        sender: signer,
        title:vector<u8>,
        introduction:vector<u8>,
        extend: vector<u8>,
        receiver: address,
        amount: u128,
        action_delay: u64)
    {
        create_withdraw_proposal<DAOT, TokenT>(&sender, title, introduction, extend, receiver, amount, action_delay);
    }

    public fun execute_withdraw_proposal<DAOT: store, TokenT: store>(sender: &signer, proposal_id: u64) {
        let witness = WithdrawPlugin {};
        let proposal_cap = DAOSpace::acquire_proposal_cap<DAOT, WithdrawPlugin>(&witness);
        let WithdrawTokenAction<TokenT> { receiver, amount } =
            DAOSpace::execute_proposal<DAOT, WithdrawPlugin, WithdrawTokenAction<TokenT>>(&proposal_cap, sender, proposal_id);
        assert!(receiver == Signer::address_of(sender), Errors::not_published(ERR_NOT_RECEIVER));

        let withdraw_cap = DAOSpace::acquire_withdraw_token_cap<DAOT, WithdrawPlugin>(&witness);
        let tokens = DAOSpace::withdraw_token<DAOT, WithdrawPlugin, TokenT>(&withdraw_cap, amount);
        Account::deposit(receiver, tokens);
    }

    public(script) fun execute_withdraw_proposal_entry<DAOT: store, TokenT: store>(sender: signer, proposal_id: u64) {
        execute_withdraw_proposal<DAOT, TokenT>(&sender, proposal_id);
    }

    public fun set_scale_factor<DAOT: store>(scale: u8, _witness: &DAOT) {
        assert!(
            scale >= 0 && scale <= 100,
            Errors::invalid_argument(ERR_INVALID_SCALE_FACTOR),
        );
        set_scale_factor_inner<DAOT>(scale);
    }

    fun set_scale_factor_inner<DAOT: store>(scale: u8) {
        let plugin = WithdrawPlugin {};
        let cap = DAOSpace::acquire_modify_config_cap<DAOT, WithdrawPlugin>(&plugin);
        DAOSpace::set_custom_config<DAOT, WithdrawPlugin, QuorumScale>(&mut cap, QuorumScale { scale });
    }

    public fun install_plugin_proposal<DAOT:store>(sender:&signer, title:vector<u8>, introduction:vector<u8>, extend: vector<u8>, action_delay:u64){
        InstallPluginProposalPlugin::create_proposal<DAOT, WithdrawPlugin>(sender,required_caps(), title, introduction,  extend, action_delay);
    }

    public (script) fun install_plugin_proposal_entry<DAOT:store>(sender:signer, title:vector<u8>, introduction:vector<u8>, extend: vector<u8>, action_delay:u64){
        install_plugin_proposal<DAOT>(&sender, title, introduction, extend, action_delay);
    }
}