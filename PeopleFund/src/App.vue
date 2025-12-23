<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useWeb3Store } from './stores/web3'

import CampaignList from './components/CampaignList.vue'
import CreateCampaign from './components/CreateCampaign.vue'
import AgeGate from './components/AgeGate.vue'

const ready = ref(false)
const isAdult = ref(localStorage.getItem('isAdult') === 'true')

const web3Store = useWeb3Store()

type View = 'campaigns' | 'create'
const currentView = ref<View>('campaigns')

onMounted(async () => {
  if (!isAdult.value) return

  console.log('Initializing Web3...')
  await web3Store.init()
  ready.value = true
})

function onAgeAccepted() {
  isAdult.value = true
  location.reload()
}
</script>

<template>
  <AgeGate v-if="!isAdult" @accepted="onAgeAccepted" />
  <div v-else-if="ready" class="app-container">
    <!-- Top Bar -->
    <header class="top-bar">
      <div class="account-info">
        <span class="label">Active account</span>
        <span class="address">
          {{ web3Store.accounts[web3Store.selectedAccountIndex] }}
        </span>
      </div>

      <select
        v-model="web3Store.selectedAccountIndex"
        @change="web3Store.switchAccount(web3Store.selectedAccountIndex)"
        class="account-select"
      >
        <option
          v-for="(acc, idx) in web3Store.accounts"
          :key="acc"
          :value="idx"
        >
          {{ acc }}
        </option>
      </select>
    </header>

    <nav class="nav-tabs">
      <button
        class="nav-button"
        :class="{ active: currentView === 'campaigns' }"
        @click="currentView = 'campaigns'"
      >
        Campaigns
      </button>

      <button
        class="nav-button"
        :class="{ active: currentView === 'create' }"
        @click="currentView = 'create'"
      >
        Create Campaign
      </button>
    </nav>

    <main class="content">
      <CampaignList v-if="currentView === 'campaigns'" />
      <CreateCampaign v-else />
    </main>
  </div>

  <div v-else class="loading">
    <h2>Connecting to Web3...</h2>
  </div>
</template>

<style scoped>
.app-container {
  max-width: 1100px;
  margin: 0 auto;
  padding: 1.5rem;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI',
    sans-serif;
}

.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #0f172a;
  color: #f8fafc;
  padding: 1rem 1.25rem;
  border-radius: 10px;
  margin-bottom: 1.5rem;
}

.account-info {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.label {
  font-size: 0.75rem;
  color: #94a3b8;
}

.address {
  font-size: 0.9rem;
  font-family: monospace;
}

.account-select {
  background: #020617;
  color: #e5e7eb;
  border: 1px solid #334155;
  padding: 0.4rem 0.6rem;
  border-radius: 6px;
  cursor: pointer;
}

.nav-tabs {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1.5rem;
}

.nav-button {
  padding: 0.6rem 1.2rem;
  border-radius: 8px;
  border: 1px solid #cbd5f5;
  background: #f8fafc;
  cursor: pointer;
  font-weight: 500;
  transition: all 0.2s ease;
}

.nav-button:hover {
  background: #eef2ff;
}

.nav-button.active {
  background: #4f46e5;
  color: white;
  border-color: #4f46e5;
}

.content {
  background: blueviolet;
  padding: 1.5rem;
  border-radius: 10px;
  border: 1px solid #e5e7eb;
}

.loading {
  height: 100vh;
  display: grid;
  place-items: center;
  font-family: system-ui, sans-serif;
  background-color: blue;
}
</style>
