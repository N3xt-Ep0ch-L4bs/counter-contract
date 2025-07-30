#[test_only]
module counter::counter_tests;


use counter::counter::{
    Self, GlobalCounter, PersonalCounter,
    increment_global_counter, decrement_global_counter,
    create_personal_counter, increment_personal_counter, decrement_personal_counter,
    reset_personal_counter, delete_personal_counter,
    E_UNAUTHORIZED
};


use sui::test_scenario as ts;
use sui::test_utils::assert_eq;



const CREATOR: address = @0xA;
const CALLER: address = @0xB;


#[test]
fun test_init_global_counter() {
    let mut scenario = ts::begin(CREATOR); {
        counter::test_init(scenario.ctx());

    };

    let effects = ts::next_tx(&mut scenario, CREATOR);
    assert_eq(effects.num_user_events(), 1);
    scenario.end();
}


#[test]
fun test_increment_global_counter() {
    let mut scenario = ts::begin(CREATOR); {
        counter::test_init(scenario.ctx());
    };
    ts::next_tx(&mut scenario, CREATOR);

    {
        let mut gc: GlobalCounter = ts::take_shared(&scenario);
        increment_global_counter(&mut gc, scenario.ctx());
        ts::return_shared(gc);
    };

    let effects = ts::next_tx(&mut scenario, CREATOR);
    assert_eq(effects.num_user_events(), 1);
    scenario.end();
}


#[test]
fun test_decrement_global_counter() {
    let mut scenario = ts::begin(CREATOR); {
        counter::test_init(scenario.ctx());
    };
    ts::next_tx(&mut scenario, CREATOR);

    {
        let mut gc: GlobalCounter = ts::take_shared(&scenario);
        increment_global_counter(&mut gc, scenario.ctx());
        ts::return_shared(gc);
    };
    ts::next_tx(&mut scenario, CREATOR);

    {
        let mut gc: GlobalCounter = ts::take_shared(&scenario);
        decrement_global_counter(&mut gc, scenario.ctx());
        ts::return_shared(gc);
    };

    let effects = ts::next_tx(&mut scenario, CREATOR);
    assert_eq(effects.num_user_events(), 1);
    scenario.end();
}


#[test]
fun test_create_personal_counter() {
    let mut scenario = ts::begin(CREATOR); {
        create_personal_counter(scenario.ctx());
    };

    let effects = ts::next_tx(&mut scenario, CREATOR);
    assert_eq(effects.num_user_events(), 1);
    scenario.end();
}


#[test]
fun test_increment_personal_counter() {
    let mut scenario = ts::begin(CREATOR); {
        create_personal_counter(scenario.ctx());
    };
    ts::next_tx(&mut scenario, CREATOR);

    {
        let mut pc: PersonalCounter = ts::take_shared<PersonalCounter>(&scenario);
        increment_personal_counter(&mut pc, scenario.ctx());
        ts::return_shared<PersonalCounter>(pc);
    };
    let effects = ts::next_tx(&mut scenario, CREATOR);
    assert_eq(effects.num_user_events(), 1);
    scenario.end();
}


#[test]
fun test_decrement_personal_counter() {
    let mut scenario = ts::begin(CREATOR); {
        counter::test_init(scenario.ctx());
        create_personal_counter(scenario.ctx());
    };
    ts::next_tx(&mut scenario, CREATOR);

    {
        let mut pc: PersonalCounter = ts::take_shared(&scenario);
        increment_personal_counter(&mut pc, scenario.ctx());
        ts::return_shared(pc);
    };
    ts::next_tx(&mut scenario, CREATOR);

    {
        let mut pc: PersonalCounter = ts::take_shared(&scenario);
        decrement_personal_counter(&mut pc, scenario.ctx());
        ts::return_shared(pc);
    };
    
    let effects = ts::next_tx(&mut scenario, CREATOR);
    assert_eq(effects.num_user_events(), 1);
    scenario.end();
}


#[test]
fun test_reset_personal_counter() {
    let mut scenario = ts::begin(CREATOR); {
        counter::test_init(scenario.ctx());
        create_personal_counter(scenario.ctx());
    };
    ts::next_tx(&mut scenario, CREATOR);

    {
        let mut pc: PersonalCounter = ts::take_shared(&scenario);
        increment_personal_counter(&mut pc, scenario.ctx());
        ts::return_shared(pc);
    };
    ts::next_tx(&mut scenario, CREATOR);

    {
        let mut pc: PersonalCounter = ts::take_shared(&scenario);
        reset_personal_counter(&mut pc, scenario.ctx());
        ts::return_shared(pc);
    };

    let effects = ts::next_tx(&mut scenario, CREATOR);
    assert_eq(effects.num_user_events(), 1);
    scenario.end();
}


#[test, expected_failure(abort_code = E_UNAUTHORIZED)]
fun test_reset_personal_counter_fail_not_owner() {
    let mut scenario = ts::begin(CREATOR); {
        counter::test_init(scenario.ctx());
        create_personal_counter(scenario.ctx());
    };
    ts::next_tx(&mut scenario, CREATOR);

    {
        let pc: PersonalCounter = ts::take_shared(&scenario);
        ts::return_shared(pc);
    };
    ts::next_tx(&mut scenario, CALLER);

    {
        let mut pc: PersonalCounter = ts::take_shared(&scenario);
        reset_personal_counter(&mut pc, scenario.ctx());
        ts::return_shared(pc);
    };
    scenario.end();
}


#[test]
fun test_delete_personal_counter() {
    let mut scenario = ts::begin(CREATOR); {
        counter::test_init(scenario.ctx());
        create_personal_counter(scenario.ctx());
    };
    ts::next_tx(&mut scenario, CREATOR);

    {
        let pc: PersonalCounter = ts::take_shared(&scenario);
        delete_personal_counter(pc, scenario.ctx());
    };

    let effects = ts::next_tx(&mut scenario, CREATOR);
    assert_eq(effects.num_user_events(), 0); // no event emitted
    scenario.end();
}


#[test, expected_failure(abort_code = E_UNAUTHORIZED)]
fun test_delete_personal_counter_fail_not_owner() {
    let mut scenario = ts::begin(CREATOR); {
        counter::test_init(scenario.ctx());
        create_personal_counter(scenario.ctx());
    };
    ts::next_tx(&mut scenario, CREATOR);

    {
        let pc: PersonalCounter = ts::take_shared(&scenario);
        ts::return_shared(pc);
    };
    ts::next_tx(&mut scenario, CALLER);

    {
        let pc: PersonalCounter = ts::take_shared(&scenario);
        delete_personal_counter(pc, scenario.ctx());
    };
    scenario.end();
}
