program lending_policy_ejones_v1.aleo;

struct PolicyInput:
    risk_score as u8;
    collateral_ratio as u64;

struct PolicyResult:
    approved as boolean;
    policy_id as u64;

function make_policy_input:
    input r0 as u8.public;
    input r1 as u64.public;
    cast r0 r1 into r2 as PolicyInput;
    output r2 as PolicyInput.private;

function evaluate_policy:
    input r0 as PolicyInput.private;
    input r1 as u64.public;
    gt r0.risk_score 70u8 into r2;
    gte r0.collateral_ratio 150u64 into r3;
    and r2 r3 into r4;
    cast r4 r1 into r5 as PolicyResult;
    output r5 as PolicyResult.private;

constructor:
    assert.eq edition 0u16;
