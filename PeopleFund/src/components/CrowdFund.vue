<template>
  <div class="max-w-md mx-auto p-6 text-black">
    <div class="rounded-xl border bg-white shadow-sm p-6 space-y-5">
      <div class="text-center">
        <h2 class="text-2xl font-bold">🎯 CrowdFund Campaign</h2>
        <p
          class="mt-2 inline-block px-3 py-1 text-xs rounded-full"
          :class="isGoalReached ? 'bg-green-100' : 'bg-yellow-100'"
        >
          {{ isGoalReached ? 'Goal Reached' : 'Active Campaign' }}
        </p>
      </div>

      <div class="grid grid-cols-2 gap-4 text-sm">
        <div>
          <p class="font-semibold">Goal</p>
          <p>{{ goal }} ETH</p>
        </div>
        <div>
          <p class="font-semibold">Raised</p>
          <p>{{ totalRaised }} ETH</p>
        </div>
      </div>

      <div>
        <div class="h-2 w-full bg-gray-200 rounded-full overflow-hidden">
          <div
            class="h-full bg-blue-600 transition-all"
            :style="{
              width:
                Math.min(
                  (Number(totalRaised) / Number(goal)) * 100,
                  100
                ) + '%',
            }"
          />
        </div>
      </div>

      <div class="text-sm text-center">
        <p v-if="timeLeft > 0">
          ⏳ Time remaining:
          <span class="font-medium">
            {{ (timeLeft / 60).toFixed(2) }} minutes
          </span>
        </p>
        <p v-else class="font-semibold text-red-600">
          ⛔ Campaign Ended
        </p>
      </div>

      <div v-if="timeLeft > 0" class="flex gap-3">
        <input
          v-model="donationEth"
          type="number"
          min="0.01"
          step="0.01"
          placeholder="ETH"
          class="flex-1 rounded-lg border px-3 py-2 text-sm"
        />
        <button
          @click="donate"
          class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 transition"
        >
          Donate
        </button>
      </div>

      <div v-if="timeLeft === 0" class="flex gap-3">
        <button
          v-if="isGoalReached && !isFundsWithdrawn"
          @click="withdrawFunds"
          class="flex-1 rounded-lg bg-green-600 px-4 py-2 text-sm font-medium text-white hover:bg-green-700 transition"
        >
          Withdraw Funds
        </button>

        <button
          v-if="!isGoalReached"
          @click="refund"
          class="flex-1 rounded-lg bg-red-600 px-4 py-2 text-sm font-medium text-white hover:bg-red-700 transition"
        >
          Refund
        </button>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-2">💖 Donors</h3>

        <ul
          v-if="donors.length"
          class="max-h-40 overflow-y-auto divide-y border rounded-lg"
        >
          <li
            v-for="d in donors"
            :key="d.donor"
            class="flex justify-between px-3 py-2 text-sm"
          >
            <span class="truncate">{{ d.donor }}</span>
            <span class="font-medium">{{ d.amount }} ETH</span>
          </li>
        </ul>

        <p v-else class="text-sm text-center py-4">
          No donations yet
        </p>
      </div>
    </div>
  </div>
</template>
<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ethers } from 'ethers'
// @ts-ignore
import abi from '../abi/CrowdFund.json'

const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3'

let provider: ethers.JsonRpcProvider
let signer: ethers.Signer
let contract!: ethers.Contract

const goal = ref('')
const totalRaised = ref('')
const timeLeft = ref(0)
const isGoalReached = ref(false)
const isFundsWithdrawn = ref(false)

const donors = ref<{ donor: string; amount: string }[]>([])
const donationEth = ref('0')

async function init() {
  provider = new ethers.JsonRpcProvider('http://127.0.0.1:8545')
  signer = await provider.getSigner(0)
  contract = new ethers.Contract(contractAddress, abi.abi, signer)
  await refreshData()
}

async function refreshData() {
  const [_goal, _total, _deadline, _goalReached, _withdrawn] =
    await Promise.all([
      contract.goal(),
      contract.totalRaised(),
      contract.deadline(),
      contract.goalReached(),
      contract.fundsWithdrawn(),
    ])

  goal.value = ethers.formatEther(_goal)
  totalRaised.value = ethers.formatEther(_total)
  isGoalReached.value = _goalReached
  isFundsWithdrawn.value = _withdrawn

  const now = Math.floor(Date.now() / 1000)
  timeLeft.value = Number(_deadline) > now ? Number(_deadline) - now : 0

  await loadDonors()
}

async function loadDonors() {
  const list = await contract.getDonors()
  donors.value = list.map((d: any) => ({
    donor: d.donor,
    amount: ethers.formatEther(d.amount),
  }))
}

async function donate() {
  const tx = await contract.donate({
    value: ethers.parseEther(donationEth.value),
  })
  await tx.wait()
  await refreshData()
}

async function withdrawFunds() {
  const tx = await contract.withdrawFunds()
  await tx.wait()
  await refreshData()
}

async function refund() {
  const tx = await contract.refund()
  await tx.wait()
  await refreshData()
}

onMounted(init)
</script>