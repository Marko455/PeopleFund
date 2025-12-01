import { ethers } from "hardhat";

async function main() {
  const crowdfund = await ethers.deployContract("Crowdfund");
  await crowdfund.waitForDeployment();

  console.log("Crowdfund deployed at:", await crowdfund.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
