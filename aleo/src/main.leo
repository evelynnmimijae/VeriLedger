// The 'lending_policy' program 
program lending_policy_ejones_v1.aleo {
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

   transition make_policy_input(public risk_score: u8, public collateral_ratio: u64) -> PolicyInput {
       return PolicyInput { risk_score, collateral_ratio };
   }

    // Transition function for evaluating the lending policy
    transition evaluate_policy(
        private inp: PolicyInput,
        public policy_id: u64
    ) -> PolicyResult {
        // Simple approval criteria 
        let approved = inp.risk_score > 70 && inp.collateral_ratio >= 150u64;

        // Transition function for evaluating the lending policy
        return PolicyResult { approved, policy_id };
    }
}