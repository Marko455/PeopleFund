<template>
  <div class="min-h-screen bg-gray-100 flex flex-col items-center p-8">
    <div class="bg-white shadow-xl rounded-2xl p-8 w-full max-w-xl">
      <h1 class="text-3xl font-bold mb-6 text-center">Create a New Campaign</h1>

      <form @submit.prevent="createCampaign" class="space-y-6">
        <!-- Goal Amount -->
        <div>
          <label class="block font-medium mb-1">Goal Amount (ETH)</label>
          <input
            v-model="goal"
            type="number"
            step="0.01"
            min="0"
            class="w-full p-3 rounded-xl border border-gray-300 focus:outline-none focus:ring focus:ring-blue-300"
            placeholder="e.g. 1"
          />
        </div>

        <!-- Duration -->
        <div>
          <label class="block font-medium mb-1">Duration (minutes)</label>
          <input
            v-model="duration"
            type="number"
            min="1"
            class="w-full p-3 rounded-xl border border-gray-300 focus:outline-none focus:ring focus:ring-blue-300"
            placeholder="e.g. 60"
          />
        </div>

        <!-- Submit Button -->
        <button
          type="submit"
          class="w-full py-3 rounded-xl bg-blue-600 text-white text-lg hover:bg-blue-700 transition shadow"
        >
          Deploy Campaign
        </button>
      </form>

      <!-- Status Message -->
      <p v-if="message" class="mt-6 text-center text-gray-700">{{ message }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { ethers, parseEther } from 'ethers';
import CrowdFundArtifact from '@/eth/CrowdFundABI.json';

const goal = ref('');
const duration = ref('');
const message = ref('');

async function createCampaign() {
  try {
    if (!window.ethereum) throw new Error('MetaMask not found');

    if (!goal.value || Number(goal.value) <= 0) {
      throw new Error('Goal must be greater than 0');
    }

    if (!duration.value || Number(duration.value) <= 0) {
      throw new Error('Duration must be at least 1 minute');
    }

    message.value = 'Waiting for MetaMask...';

    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();

    // Convert ETH → wei
    const goalWei = parseEther(goal.value.toString());
    const durationSeconds = Number(duration.value) * 60;

    // Create contract factory
    const factory = new ethers.ContractFactory(
      CrowdFundArtifact.abi,
      CrowdFundArtifact.bytecode,
      signer
    );

    message.value = 'Deploying campaign... Please confirm in MetaMask.';

    // Deploy
    const contract = await factory.deploy(goalWei, durationSeconds);
    await contract.waitForDeployment();

    const address = await contract.getAddress();

    message.value = `🎉 Campaign deployed at: ${address}`;
  } catch (err) {
    console.error(err);
    message.value = `❌ Error: ${err.message}`;
  }
}
</script>


<style scoped>
</style>
