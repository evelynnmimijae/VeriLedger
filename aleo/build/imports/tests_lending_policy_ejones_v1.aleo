import lending_policy_ejones_v1.aleo;
program tests_lending_policy_ejones_v1.aleo;

struct PolicyInput:
    risk_score as u8;
    collateral_ratio as u64;

struct PolicyResult:
    approved as boolean;
    policy_id as u64;

function test_approve:
    call lending_policy_ejones_v1.aleo/make_policy_input 80u8 200u64 into r0;
    call lending_policy_ejones_v1.aleo/evaluate_policy r0 1u64 into r1;
    assert.eq r1.approved true;
    assert.eq r1.policy_id 1u64;

function test_edge_approve:
    call lending_policy_ejones_v1.aleo/make_policy_input 71u8 150u64 into r0;
    call lending_policy_ejones_v1.aleo/evaluate_policy r0 2u64 into r1;
    assert.eq r1.approved true;

function test_reject_risk:
    call lending_policy_ejones_v1.aleo/make_policy_input 70u8 200u64 into r0;
    call lending_policy_ejones_v1.aleo/evaluate_policy r0 3u64 into r1;
    assert.eq r1.approved false;

function test_reject_collateral:
    call lending_policy_ejones_v1.aleo/make_policy_input 80u8 149u64 into r0;
    call lending_policy_ejones_v1.aleo/evaluate_policy r0 4u64 into r1;
    assert.eq r1.approved false;

function test_reject_both:
    call lending_policy_ejones_v1.aleo/make_policy_input 50u8 100u64 into r0;
    call lending_policy_ejones_v1.aleo/evaluate_policy r0 5u64 into r1;
    assert.eq r1.approved false;
    assert.eq r1.policy_id 5u64;

function test_approve_fail:
    call lending_policy_ejones_v1.aleo/make_policy_input 80u8 200u64 into r0;
    call lending_policy_ejones_v1.aleo/evaluate_policy r0 6u64 into r1;
    assert.eq r1.approved false;

constructor:
    assert.eq edition 0u16;
