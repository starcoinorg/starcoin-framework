address StarcoinFramework {
module GeneralDaoMember {

    use StarcoinFramework::Errors;
    use StarcoinFramework::NFT;
    use StarcoinFramework::Token;
    use StarcoinFramework::Account;
    use StarcoinFramework::GeneralDaoStateGuard;
    use StarcoinFramework::Signer;
    use StarcoinFramework::IdentifierNFT;

    const ERROR_INSUFFICIENT_WEIGHT: u64 = 101;
    const ERROR_NFT_HAS_REGISTERED: u64 = 102;

    const PRECISION: u8 = 9;

    struct MemberNFTMeta<phantom DaoType> has copy, drop, store {}

    struct MemberNFTBody<phantom DaoType> has store {
        sbt: Token::Token<DaoType>,
    }

    struct MemberCapability<phantom DaoType> has key, store {
        nft_update_cap: NFT::UpdateCapability<MemberNFTMeta<DaoType>>,
        nft_mint_cap: NFT::MintCapability<MemberNFTMeta<DaoType>>,
        token_mint_cap: Token::MintCapability<DaoType>,
        token_burn_cap: Token::BurnCapability<DaoType>,
    }

    public fun genesis_dao_member<DaoType: store>(signer: &signer): MemberCapability<DaoType> {
        assert!(!NFT::is_registered<MemberNFTMeta<DaoType>>(), Errors::invalid_state(ERROR_NFT_HAS_REGISTERED));
        NFT::register_v2<MemberNFTMeta<DaoType>>(signer, new_meta_data());

        // Strip update capability to issue capability
        MemberCapability<DaoType>{
            nft_update_cap: NFT::remove_update_capability<MemberNFTMeta<DaoType>>(signer),
            nft_mint_cap: NFT::remove_mint_capability<MemberNFTMeta<DaoType>>(signer),
            token_mint_cap: Token::remove_mint_capability<DaoType>(signer),
            token_burn_cap: Token::remove_burn_capability<DaoType>(signer),
        }
    }

    public fun register_dao<DaoType: store>(signer: &signer, _cap: &MemberCapability<DaoType>) {
        Token::register_token<DaoType>(signer, PRECISION);
        Account::do_accept_token<DaoType>(signer);
    }

    /// Issue NFT with DAO type
    /// TODO: Need to discuss whether multiple DAOs share a SBT
    public fun grant_nft_to_user<DaoType: store>(to_signer: &signer,
                                                 sbt_amount: u128,
                                                 cap: &MemberCapability<DaoType>) {
        Account::do_accept_token<DaoType>(to_signer);

        let receive_address = Signer::address_of(to_signer);

        let nft =
            NFT::mint_with_cap_v2<MemberNFTMeta<DaoType>, MemberNFTBody<DaoType>>(
                receive_address,
                &mut cap.nft_mint_cap,
                new_meta_data(),
                MemberNFTMeta{},
                MemberNFTBody<DaoType>{ sbt: Token::mint_with_capability<DaoType>(&cap.token_mint_cap, sbt_amount) },
            );

        IdentifierNFT::grant_to(&mut cap.nft_mint_cap, receive_address, nft);
    }

    fun new_meta_data(): NFT::Metadata {
        // TODO: To replace this name & description ?
        NFT::new_meta(b"general-dao-nft", b"Soul binding nft")
    }

    /// Add weight from NFT capability
    public fun add_weight<DaoType: store>(
        owner: address,
        weight: u128,
        cap: &mut MemberCapability<DaoType>) {
        let credential =
            IdentifierNFT::borrow_out<MemberNFTMeta<DaoType>, MemberNFTBody<DaoType>>(&mut cap.nft_update_cap, owner);
        let nft =
            IdentifierNFT::borrow_nft_mut<MemberNFTMeta<DaoType>, MemberNFTBody<DaoType>>(&mut credential);
        let body =
            NFT::borrow_body_mut_with_cap(&mut cap.nft_update_cap, nft);

        Token::deposit(&mut body.token, Token::mint_with_capability<DaoType>(&cap.token_mint_cap, weight));
    }

    /// Remove weight from NFT capability
    public fun remove_weight<DaoType>(owner: address,
                                      weight: u128,
                                      cap: &MemberCapability<DaoType>) {
        let credential =
            IdentifierNFT::borrow_out<MemberNFTMeta<DaoType>, MemberNFTBody<DaoType>>(&mut cap.nft_update_cap, owner);
        let nft =
            IdentifierNFT::borrow_nft_mut<MemberNFTMeta<DaoType>, MemberNFTBody<DaoType>>(&mut credential);
        let body =
            NFT::borrow_body_mut_with_cap(&mut cap.nft_update_cap, nft);
        let token = Token::withdraw(&mut body.token, weight);
        Token::burn_with_capability(&cap.token_burn_cap, token);
    }
}
}
