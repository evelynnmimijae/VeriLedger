program lending_policy_ejones_v1.aleo {
    // Public and Private state 
    // Struct for input data
    struct PolicyInput {
        risk_score: u8,
        collateral_ratio: u64,
    }

    // Struct for output result
    struct PolicyResult {
        approved: bool,
        policy_id: u64,
    }

    @noupgrade
    async constructor() {
        // Leo generates the constructor logic; program is non-upgradable.
    }

    // Public mapping to store the last approval result per policy id
    mapping latest_approval: u64 => bool;


    // Transition function for evaluating the lending policy
    transition evaluate_policy(
        private inp: PolicyInput,
        public policy_id: u64
    ) -> PolicyResult{
        // Simple approval criteria 
        let approved = inp.risk_score > 70 && inp.collateral_ratio >= 150u64;

        // Update mapping with result
        Mapping::set(latest_approval, policy_id, approved);

        // Return the policy result as public output
        return PolicyResult { approved, policy_id };
    }
}