module counter::counter;

use sui::event;

const E_UNAUTHORIZED: u64 = 0;


public struct GlobalCounter has key {
    id: UID,
    value: u64,
}

public struct PersonalCounter has key, store {
    id: UID,
    value: u64,
    owner: address
}

public struct GlobalCounterCreated has copy, drop {
    global_counter_id: ID,
    creator: address,
}

public struct GlobalCounterIncremented has copy, drop {
    global_counter_id: ID,
    incremented_by: address,
}
public struct GlobalCounterDecremented has copy, drop {
    global_counter_id: ID,
    decremented_by: address,
}
public struct PersonalCounterCreated has copy, drop {
    personal_counter_id: ID,
    owner: address,
}
public struct PersonalCounterIncremented has copy, drop {
    personal_counter_id: ID,
    incremented_by: address,
}
public struct PersonalCounterDecremented has copy, drop {
    personal_counter_id: ID,
    decremented_by: address,
}

public struct PersonalCounterReset has copy, drop {
    personal_counter_id: ID,
    reset_by: address,
}

fun init(ctx: &mut TxContext) {
    let global_counter = GlobalCounter {
        id: object::new(ctx),
        value: 0,
    };
    event::emit(GlobalCounterCreated {
        global_counter_id: object::id(&global_counter),
        creator: ctx.sender(),
    });

    transfer::share_object(global_counter)
}

public fun increment_global_counter(global_counter: &mut GlobalCounter, ctx: &mut TxContext) {
    global_counter.value = global_counter.value + 1;
    event::emit(GlobalCounterIncremented {
        global_counter_id: object::id(global_counter),
        incremented_by: ctx.sender(),
    });
}

public fun decrement_global_counter(global_counter: &mut GlobalCounter, ctx: &mut TxContext) {
    global_counter.value = global_counter.value - 1;
    event::emit(GlobalCounterDecremented {
        global_counter_id: object::id(global_counter),
        decremented_by: ctx.sender(),
    })
}

#[allow(lint(self_transfer))]
public fun create_personal_counter(ctx: &mut TxContext) {
    let personal_counter = PersonalCounter {
        id: object::new(ctx),
        value: 0,
        owner: ctx.sender()
    };
    event::emit(PersonalCounterCreated {
        personal_counter_id: object::id(&personal_counter),
        owner: ctx.sender(),
    });

    transfer::public_transfer(personal_counter, ctx.sender());
}

public fun increment_personal_counter(personal_counter: &mut PersonalCounter, ctx: &mut TxContext) {
    
    personal_counter.value = personal_counter.value + 1;

    event::emit(PersonalCounterIncremented {
        personal_counter_id: object::id(personal_counter),
        incremented_by: ctx.sender(),
    });
}

public fun decrement_personal_counter(personal_counter: &mut PersonalCounter, ctx: &mut TxContext) {
    personal_counter.value = personal_counter.value - 1;

    event::emit(PersonalCounterDecremented {
        personal_counter_id: object::id(personal_counter),
        decremented_by: ctx.sender(),
    });
}

public fun reset_personal_counter(personal_counter: &mut PersonalCounter, ctx: &mut TxContext) {
    assert!(personal_counter.owner == ctx.sender(), E_UNAUTHORIZED);
    personal_counter.value = 0;

    event::emit(PersonalCounterReset {
        personal_counter_id: object::id(personal_counter),
        reset_by: ctx.sender(),
    });
}

#[allow(unused_variable)]
public fun delete_personal_counter(personal_counter: PersonalCounter, ctx: &mut TxContext) {
    assert!(personal_counter.owner == ctx.sender(), E_UNAUTHORIZED);
    let PersonalCounter { id, value , owner} = personal_counter;

    id.delete();
}
