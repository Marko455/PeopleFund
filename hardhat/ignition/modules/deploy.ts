import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("CrowdFundModule", (m) => {
    
    const goalAmount = 1_000_000_000_000_000_000n; // 1 ETH
    const duration = 60n * 60n * 24n * 7n; // 7 dana u sekundama

    const crowdfund = m.contract("CrowdFund", [goalAmount, duration]);

    
    m.call(crowdfund, "contribute", [], { value: 10_000n });

    return { crowdfund };
});
