address StarcoinFramework {
module GeneralDaoNFT {

    use StarcoinFramework::Errors;
    use StarcoinFramework::NFT;
    use StarcoinFramework::Token;
    use StarcoinFramework::Account;

    const ERROR_INSUFFICIENT_WEIGHT: u64 = 101;
    const ERROR_NFT_HAS_REGISTERED: u64 = 102;

    const PRECISION: u8 = 9;

    struct NFTBody<phantom DaoType> has store {
        token: Token::Token<DaoType>,
    }

    struct NFTMeta<phantom DaoType> has copy, drop, store {}

    struct IdentiferNFT<phantom DaoType> has key {
        nft: NFT::NFT<NFTMeta<DaoType>, NFTBody<DaoType>>,
    }

    struct IssueCapability<phantom DaoType> has key, store {
        nft_update_cap: NFT::UpdateCapability<NFTMeta<DaoType>>,
        token_mint_cap: Token::MintCapability<DaoType>,
        token_burn_cap: Token::BurnCapability<DaoType>,
    }

    public fun register_dao_nft<DaoType: store>(signer: &signer): IssueCapability<DaoType> {
        assert!(!NFT::is_registered<NFTMeta<DaoType>>(), Errors::invalid_state(ERROR_NFT_HAS_REGISTERED));
        NFT::register_v2<NFTMeta<DaoType>>(signer, new_meta_data());

        Token::register_token<DaoType>(signer, PRECISION);
        Account::do_accept_token<DaoType>(signer);

        // Strip update capability to issue capability
        IssueCapability<DaoType>{
            nft_update_cap: NFT::remove_update_capability<NFTMeta<DaoType>>(signer),
            token_mint_cap: Token::remove_mint_capability<DaoType>(signer),
            token_burn_cap: Token::remove_burn_capability<DaoType>(signer),
        }
    }

    /// Issue NFT with DAO type
    public fun issue_nft_to_user<DaoType: store>(signer: &signer) {
        Account::do_accept_token<DaoType>(signer);

        let nft = NFT::mint_v2<NFTMeta<DaoType>, NFTBody<DaoType>>(
            signer, new_meta_data(), NFTMeta{}, NFTBody<DaoType>{ token: Token::zero<DaoType>() });
        move_to(signer, IdentiferNFT<DaoType>{
            nft,
        });
    }

    fun new_meta_data(): NFT::Metadata {
        // TODO: To replace this name & description ?
        NFT::new_meta(b"general-dao-nft", b"Soul binding nft")
    }

    /// Add weight from NFT capability
    public fun add_weight<DaoType: store>(
        user: address,
        weight: u128,
        cap: &mut IssueCapability<DaoType>) acquires IdentiferNFT {
        let idNFT = borrow_global_mut<IdentiferNFT<DaoType>>(user);
        let body = NFT::borrow_body_mut_with_cap(&mut cap.nft_update_cap, &mut idNFT.nft);
        Token::deposit(&mut body.token, Token::mint_with_capability<DaoType>(&cap.token_mint_cap, weight));
    }

    /// Remove weight from NFT capability
    public fun remove_weight<DaoType>(user: address,
                                      weight: u128,
                                      cap: &IssueCapability<DaoType>) acquires IdentiferNFT {
        let idNFT = borrow_global_mut<IdentiferNFT<DaoType>>(user);
        let body = NFT::borrow_body_mut_with_cap(&mut cap.nft_update_cap, &mut idNFT.nft);
        let token = Token::withdraw(&mut body.token, weight);
        Token::burn_with_capability(&cap.token_burn_cap, token);
    }
}
}
