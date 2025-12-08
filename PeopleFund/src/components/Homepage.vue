<template>
  <div class="min-h-screen bg-gray-100 flex flex-col items-center p-6">
    <!-- Hero Section -->
    <div class="text-center max-w-xl mb-12 mt-10">
      <h1 class="text-4xl font-bold mb-4">Welcome to PeopleFund</h1>
      <p class="text-lg text-gray-700 mb-6">
        A simple decentralized crowdfunding platform powered by Ethereum.
      </p>
    </div>   

    <!-- Dummy Campaigns Section -->
    <div class="w-full max-w-4xl">
      <h2 class="text-2xl font-bold mb-4">Featured Campaigns</h2>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div
          v-for="campaign in campaigns"
          :key="campaign.id"
          class="bg-white rounded-2xl shadow p-6 hover:shadow-lg transition cursor-pointer"
          @click="openCampaign(campaign.id)"
        >
          <h3 class="text-xl font-semibold mb-2">{{ campaign.title }}</h3>
          <p class="text-gray-600 mb-4">{{ campaign.description }}</p>
          <p class="font-medium text-gray-800">Goal: {{ campaign.goal }} ETH</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';
import { ref } from 'vue';

const campaigns = ref([
  {
    id: 1,
    title: "Save the Rainforest",
    description: "Help us protect endangered forests and wildlife.",
    goal: 50,
  },
  {
    id: 2,
    title: "Build a Community Well",
    description: "Providing clean drinking water to rural villages.",
    goal: 20,
  },
  {
    id: 3,
    title: "Support Open Source Developers",
    description: "Funding tools that help developers worldwide.",
    goal: 10,
  },
  {
    id: 4,
    title: "Plant One Million Trees",
    description: "Reforesting climate-impacted areas.",
    goal: 100,
  }
]);
</script>

<style scoped>
</style>