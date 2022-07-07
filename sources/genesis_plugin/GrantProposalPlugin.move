//TODO find more good name
module StarcoinFramework::GrantProposalPlugin{
    use StarcoinFramework::GenesisDao::{Self, CapType};
    use StarcoinFramework::DaoRegistry;
    use StarcoinFramework::Token;
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Account;
    use StarcoinFramework::Signer;

    struct GrantProposalPlugin<phantom Grant> has drop{}

    struct GrantCreateAction<phantom TokenT:store> has store {
        grantee: address,
        total: u128,
        start_time:u64,
        second_per:u128
    }

    struct GrantConfigAction<phantom TokenT:store> has store {
        grantee: address,
        total: u128,
        start_time:u64,
        second_per:u128
    }

    struct GrantRevokeAction<phantom TokenT:store> has store {
    }

    struct GrantTreasury<phantom Grant, phantom TokenT:store> has store {
        grantee: address,
        total:u128,
        start_time:u64,
        treasury:Token::Token<TokenT>,
        second_per:u128
    }

    const ERR_GRANTTREASURY_WITHDRAW_NOT_GRANTEE :u64 = 101;
    const ERR_GRANTTREASURY_WITHDRAW_TOO_MORE :u64 = 102;

    public fun create_grant_proposal<DaoT: store, Grant, TokenT:store>(sender: &signer, grantee: address, total: u128, second_per: u128,start_time:u64, action_delay:u64){
        let witness = GrantProposalPlugin{};
        let cap = GenesisDao::acquire_proposal_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let action = GrantCreateAction<TokenT>{
            grantee:grantee,
            total:total,
            start_time:start_time,
            second_per:second_per
        };
        GenesisDao::create_proposal(&cap, sender, action, action_delay);
    }

    public fun execute_grant_proposal<DaoT: store, Grant, TokenT:store>(sender: &signer, proposal_id: u64){
        let witness = GrantProposalPlugin{};
        let proposal_cap = GenesisDao::acquire_proposal_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let GrantCreateAction{grantee, total, start_time, second_per} = GenesisDao::execute_proposal<DaoT, GrantProposalPlugin<Grant>, GrantCreateAction<TokenT>>(&proposal_cap, sender, proposal_id);
        let withdraw_cap = GenesisDao::acquire_withdraw_token_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let token = GenesisDao::withdraw_token<DaoT, GrantProposalPlugin<Grant>, TokenT>(&withdraw_cap, total);
        let storage_cap = GenesisDao::acquire_storage_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        GenesisDao::save(&storage_cap, GrantTreasury<Grant, TokenT>{
            grantee:grantee,
            total:total,
            start_time:start_time,
            treasury:token,
            second_per:second_per
        });
    }

    public fun create_grant_revoke_proposal<DaoT: store, Grant, TokenT:store>(sender: &signer, action_delay:u64){
        let witness = GrantProposalPlugin{};
        let cap = GenesisDao::acquire_proposal_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let action = GrantRevokeAction<TokenT>{};
        GenesisDao::create_proposal(&cap, sender, action, action_delay);
    }

    public fun execute_grant_revoke_proposal<DaoT: store, Grant, TokenT:store>(sender: &signer, proposal_id: u64){
        let witness = GrantProposalPlugin{};
        let proposal_cap = GenesisDao::acquire_proposal_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let GrantRevokeAction{} = GenesisDao::execute_proposal<DaoT, GrantProposalPlugin<Grant>, GrantRevokeAction<TokenT>>(&proposal_cap, sender, proposal_id);
        let withdraw_cap = GenesisDao::acquire_withdraw_token_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let storage_cap = GenesisDao::acquire_storage_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let GrantTreasury<Grant, TokenT>{
            grantee:grantee,
            total:total,
            start_time:start_time,
            treasury:treasury,
            second_per:second_per
        }  = GenesisDao::take<DaoT, GrantProposalPlugin<Grant>, GrantTreasury<Grant, TokenT>>(&storage_cap);
        let token_value = Token::value(&treasury);
        let token = Token::withdraw(&mut treasury, token_value);
        Account::deposit(DaoRegistry::dao_address<DaoT>(), token);
        Token::destroy_zero(treasury);
    }

    public fun create_grant_config_proposal<DaoT: store, Grant, TokenT:store>(sender: &signer, grantee: address, total: u128, second_per: u128,start_time:u64, action_delay:u64){
        let witness = GrantProposalPlugin{};
        let cap = GenesisDao::acquire_proposal_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let action = GrantConfigAction<TokenT>{
            grantee:grantee,
            total:total,
            start_time:start_time,
            second_per:second_per
        };
        GenesisDao::create_proposal(&cap, sender, action, action_delay);
    }

    public fun execute_grant_config_proposal<DaoT: store, Grant, TokenT:store>(sender: &signer, proposal_id: u64){
        let witness = GrantProposalPlugin{};
        let proposal_cap = GenesisDao::acquire_proposal_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let GrantConfigAction{
            grantee:new_grantee, 
            total:new_total, 
            start_time:new_start_time, 
            second_per:new_second_per
        } = GenesisDao::execute_proposal<DaoT, GrantProposalPlugin<Grant>, GrantConfigAction<TokenT>>(&proposal_cap, sender, proposal_id);
        
        let withdraw_cap = GenesisDao::acquire_withdraw_token_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let storage_cap = GenesisDao::acquire_storage_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let GrantTreasury<Grant, TokenT>{
            grantee:grantee,
            total:total,
            start_time:start_time,
            treasury:treasury,
            second_per:second_per
        }  = GenesisDao::take<DaoT, GrantProposalPlugin<Grant>, GrantTreasury<Grant, TokenT>>(&storage_cap);
        
        if( new_total >= total){

            let withdraw_cap = GenesisDao::acquire_withdraw_token_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
            let token = GenesisDao::withdraw_token<DaoT, GrantProposalPlugin<Grant>, TokenT>(&withdraw_cap, new_total - total);
            Token::deposit(&mut treasury, token);
        }else{

            let token_value = Token::value(&treasury);
            let withdraw_value = total - new_total;
            
            let token = if( token_value >= withdraw_value){
                            Token::withdraw(&mut treasury, token_value - withdraw_value)
                        }else{
                            Token::withdraw(&mut treasury, token_value)
                        };
            Account::deposit(DaoRegistry::dao_address<DaoT>(), token);
        };
        
        GenesisDao::save(&storage_cap, GrantTreasury<Grant, TokenT>{
            grantee:new_grantee, 
            total:new_total, 
            start_time:new_start_time,
            treasury:treasury,
            second_per:new_second_per
        });
    }

    public fun withdraw_grant<DaoT: store, Grant, TokenT:store>(sender: &signer, amount: u128){
        let account_address = Signer::address_of(sender);
        let witness = GrantProposalPlugin{};
        let storage_cap = GenesisDao::acquire_storage_cap<DaoT, GrantProposalPlugin<Grant>>(&witness);
        let GrantTreasury<Grant, TokenT>{
            grantee:grantee,
            total:total,
            start_time:start_time,
            treasury:treasury,
            second_per:second_per
        }  = GenesisDao::take<DaoT, GrantProposalPlugin<Grant>, GrantTreasury<Grant, TokenT>>(&storage_cap);
        if( Token::value(&treasury) == 0 ){
            Token::destroy_zero(treasury);
            return 
        };
        assert!( grantee == account_address, Errors::invalid_state(ERR_GRANTTREASURY_WITHDRAW_TOO_MORE));
        let token_value = Token::value(&treasury);
        let now_seconds = (Timestamp::now_seconds() as u128 );
        let can_withdraw = {
            let release = ( now_seconds - ( start_time as u128) ) * second_per;
            if( total > release){
                token_value - (total - release)
            }else{
                token_value
            }
        };
        assert!( amount > can_withdraw, Errors::invalid_state(ERR_GRANTTREASURY_WITHDRAW_TOO_MORE));
        Account::deposit(grantee, Token::withdraw(&mut treasury, amount));

        if( Token::value(&treasury) == 0 ){
            Token::destroy_zero(treasury);
        }else{
            GenesisDao::save(&storage_cap, GrantTreasury<Grant, TokenT>{
            grantee:grantee,
            total:total,
            start_time:start_time,
            treasury:treasury,
            second_per:second_per
        });
        }

    }
}