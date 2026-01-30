// Unit testing and Leo devnet testing
// Approval rule: approved <=> (risk_score > 70 && collateral_ratio >= 150)

import lending_policy_ejones_v1.aleo;

program tests_lending_policy_ejones_v1.aleo {

    @noupgrade
    async constructor() {
        // Leo generates the constructor logic; program is non-upgradable.
    }

    @test
    transition test_approve() {
        let inp = lending_policy_ejones_v1.aleo/make_policy_input(80u8, 200u64);
        let res: lending_policy_ejones_v1.aleo/PolicyResult =
            lending_policy_ejones_v1.aleo/evaluate_policy(inp, 1u64);
        assert_eq(res.approved, true);
        assert_eq(res.policy_id, 1u64);
    }

    @test
    transition test_edge_approve() {
        let inp = lending_policy_ejones_v1.aleo/make_policy_input(71u8, 150u64);
        let res: lending_policy_ejones_v1.aleo/PolicyResult =
            lending_policy_ejones_v1.aleo/evaluate_policy(inp, 2u64);
        assert_eq(res.approved, true);
    }

    @test
    transition test_reject_risk() {
        let inp = lending_policy_ejones_v1.aleo/make_policy_input(70u8, 200u64);
        let res: lending_policy_ejones_v1.aleo/PolicyResult =
            lending_policy_ejones_v1.aleo/evaluate_policy(inp, 3u64);
        assert_eq(res.approved, false);
    }

    @test
    transition test_reject_collateral() {
        let inp = lending_policy_ejones_v1.aleo/make_policy_input(80u8, 149u64);
        let res: lending_policy_ejones_v1.aleo/PolicyResult =
            lending_policy_ejones_v1.aleo/evaluate_policy(inp, 4u64);
        assert_eq(res.approved, false);
    }

    @test
    transition test_reject_both() {
        let inp = lending_policy_ejones_v1.aleo/make_policy_input(50u8, 100u64);
        let res: lending_policy_ejones_v1.aleo/PolicyResult =
            lending_policy_ejones_v1.aleo/evaluate_policy(inp, 5u64);
        assert_eq(res.approved, false);
        assert_eq(res.policy_id, 5u64);
    }

    @test
    @should_fail
    transition test_approve_fail() {
        let inp = lending_policy_ejones_v1.aleo/make_policy_input(80u8, 200u64);
        let res: lending_policy_ejones_v1.aleo/PolicyResult =
            lending_policy_ejones_v1.aleo/evaluate_policy(inp, 6u64);
        assert_eq(res.approved, false);
    }
}