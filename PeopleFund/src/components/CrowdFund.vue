<template>
  <div class="p-4">
    <h1>Crowd Funding</h1>

    <button @click="contribute('0.1')">Contribute 0.1 ETH</button>
    <button @click="withdraw">Withdraw (Owner only)</button>
    <button @click="refund">Refund</button>

    <p>{{ message }}</p>
  </div>
</template>



<script setup>
import { ref } from "vue";
import { getCrowdFundContract } from "@/eth/CrowdFund";

const message = ref("");

async function contribute(amountEth) {
  try {
    const contract = await getCrowdFundContract();

    const tx = await contract.contribute({
      value: ethers.parseEther(amountEth)
    });

    await tx.wait();
    message.value = `Contributed ${amountEth} ETH`;
  } catch (err) {
    message.value = err.message;
  }
}

async function withdraw() {
  try {
    const contract = await getCrowdFundContract();
    const tx = await contract.withdraw();
    await tx.wait();
    message.value = "Owner withdrew funds!";
  } catch (err) {
    message.value = err.message;
  }
}

async function refund() {
  try {
    const contract = await getCrowdFundContract();
    const tx = await contract.refund();
    await tx.wait();
    message.value = "Refund issued!";
  } catch (err) {
    message.value = err.message;
  }
}
</script>

