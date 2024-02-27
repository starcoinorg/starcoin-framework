module StarcoinFramework::EventUtil {
    use StarcoinFramework::Event;
    use StarcoinFramework::Signer;
    use StarcoinFramework::Errors;

    const ERR_INIT_REPEATE: u64 = 101;
    const ERR_RESOURCE_NOT_EXISTS: u64 = 102;

    struct EventHandleWrapper<phantom EventT: store + drop> has key {
        handle: Event::EventHandle<EventT>,
    }

    public fun init_event<EventT: store + drop>(sender: &signer) {
        let broker = Signer::address_of(sender);
        assert!(!exists<EventHandleWrapper<EventT>>(broker), Errors::invalid_state(ERR_INIT_REPEATE));
        move_to(sender, EventHandleWrapper<EventT> {
            handle: Event::new_event_handle<EventT>(sender)
        });
    }

    public fun uninit_event<EventT: store + drop>(sender: &signer) acquires EventHandleWrapper {
        let broker = Signer::address_of(sender);
        assert!(exists<EventHandleWrapper<EventT>>(broker), Errors::invalid_state(ERR_RESOURCE_NOT_EXISTS));
        let EventHandleWrapper<EventT> { handle } = move_from<EventHandleWrapper<EventT>>(broker);
        Event::destroy_handle<EventT>(handle);
    }

    public fun emit_event<EventT: store + drop>(broker: address, event: EventT) acquires EventHandleWrapper {
        let event_handle = borrow_global_mut<EventHandleWrapper<EventT>>(broker);
        Event::emit_event(&mut event_handle.handle, event);
    }

    public fun exist_event<EventT: store + drop>(broker: address): bool {
        exists<EventHandleWrapper<EventT>>(broker)
    }
}
