address StarcoinFramework {
module Offer {
    use StarcoinFramework::Timestamp;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;
    use StarcoinFramework::Option;
    use StarcoinFramework::Vector;
    use StarcoinFramework::Collection2;

    spec module {
        pragma verify = true;
        pragma aborts_if_is_strict = true;
    }

    /// A wrapper around value `offered` that can be claimed by the address stored in `for` when after lock time.
    struct Offer<Offered> has key, store { offered: Offered, for: address, time_lock: u64 }

    struct Offers<Offered: store> has key {
        offers: vector<Offer<Offered>>
    }
    /// An offer of the specified type for the account does not match
    const EOFFER_DNE_FOR_ACCOUNT: u64 = 101;

    /// Offer is not unlocked yet.
    const EOFFER_NOT_UNLOCKED: u64 = 102;

    /// Publish a value of type `Offered` under the sender's account. The value can be claimed by
    /// either the `for` address or the transaction sender.
    public fun create<Offered: store>(account: &signer, offered: Offered, for: address, lock_period: u64) acquires Offers, Offer {
        let time_lock = Timestamp::now_seconds() + lock_period;
        //TODO should support multi Offer?
        let account_address = Signer::address_of(account);

        if(exists<Offers<Offered>>(account_address)){
            let offers = &mut borrow_global_mut<Offers<Offered>>(account_address).offers;
            Vector::push_back(offers, Offer<Offered> { offered, for, time_lock });

        }else if(exists<Offer<Offered>>(account_address)){
            let offers = Vector::empty<Offer<Offered>>();
            Vector::push_back(&mut offers, move_from<Offer<Offered>>(account_address));
            Vector::push_back(&mut offers, Offer<Offered> { offered, for, time_lock });
            move_to(account, Offers<Offered> { offers });

        }else{
            move_to(account, Offer<Offered> { offered, for, time_lock });
        }
    }

    spec create {
        include Timestamp::AbortsIfTimestampNotExists;
        aborts_if Timestamp::now_seconds() + lock_period > max_u64();
        aborts_if exists<Offer<Offered>>(Signer::address_of(account));
    }

    /// Claim the value of type `Offered` published at `offer_address`.
    /// Only succeeds if the sender is the intended recipient stored in `for` or the original
    /// publisher `offer_address`, and now >= time_lock
    /// Also fails if no such value exists.
    public fun redeem<Offered: store>(account: &signer, offer_address: address): Offered acquires Offer, Offers {
        let account_address = Signer::address_of(account);
        let Offer<Offered> { offered, for, time_lock } = if(exists<Offers<Offered>>(offer_address)){
            let offers = &mut borrow_global_mut<Offers<Offered>>(offer_address).offers;
            let op_index = find_offer(offers, account_address);
            assert!(Option::is_some(&op_index),Errors::invalid_argument(EOFFER_DNE_FOR_ACCOUNT));
            let index = Option::destroy_some(op_index);
            let offer = Vector::remove(offers , index);
            if(Vector::length(offers) == 0){
                let Offers { offers } = move_from<Offers<Offered>>(offer_address);
                Vector::destroy_empty(offers);
            };
            offer
        }else if(exists<Offer<Offered>>(offer_address)){
            move_from<Offer<Offered>>(offer_address)
        }else{
            //TODO: err code
            abort 10000
        };
        
        let sender = Signer::address_of(account);
        let now = Timestamp::now_seconds();
        assert!(sender == for || sender == offer_address, Errors::invalid_argument(EOFFER_DNE_FOR_ACCOUNT));
        assert!(now >= time_lock, Errors::not_published(EOFFER_NOT_UNLOCKED));
        offered
    }

    spec redeem {
        aborts_if !exists<Offer<Offered>>(offer_address);
        aborts_if Signer::address_of(account) != global<Offer<Offered>>(offer_address).for && Signer::address_of(account) != offer_address;
        aborts_if Timestamp::now_seconds() < global<Offer<Offered>>(offer_address).time_lock;
        include Timestamp::AbortsIfTimestampNotExists;
    }

    /// Returns true if an offer of type `Offered` exists at `offer_address`.
    public fun exists_at<Offered: store>(offer_address: address): bool {
        exists<Offer<Offered>>(offer_address)
    }

    spec exists_at {aborts_if false;}

    /// Returns the address of the `Offered` type stored at `offer_address`.
    /// Fails if no such `Offer` exists.
    public fun address_of<Offered: store>(offer_address: address): address acquires Offer {
        borrow_global<Offer<Offered>>(offer_address).for
    }

    spec address_of {aborts_if !exists<Offer<Offered>>(offer_address);}

    /// Take Offer and put to signer's Collection<Offered>.
    public(script) fun take_offer<Offered: store>(
        signer: signer,
        offer_address: address,
    ) acquires Offer, Offers {
        let offered = redeem<Offered>(&signer, offer_address);
        Collection2::put(&signer, Signer::address_of(&signer), offered);
    }

    spec take_offer {
        pragma verify = false;
    }

    fun find_offer<Offered: store>(offers: &vector<Offer<Offered>>, for: address):Option::Option<u64>{
        let now = Timestamp::now_seconds();
        let length = Vector::length(offers);
        let i = 0;
        while(i < length){
            let offer = Vector::borrow(offers, i);
            if( offer.for == for && now >= offer.time_lock ){
                return Option::some(i)
            };
            i = i + 1;
        };
        Option::none<u64>()
    }
}
}