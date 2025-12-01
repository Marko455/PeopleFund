<template>
  <div class="register-container">
    <h1>Create an Account</h1>

    <form @submit.prevent="handleSubmit">
      <div class="form-group">
        <label>Name</label>
        <input v-model="form.name" type="text" placeholder="Your name" />
        <span v-if="errors.name" class="error">{{ errors.name }}</span>
      </div>

      <div class="form-group">
        <label>Email</label>
        <input v-model="form.email" type="email" placeholder="you@school.edu" />
        <span v-if="errors.email" class="error">{{ errors.email }}</span>
      </div>

      <div class="form-group">
        <label>Password</label>
        <input v-model="form.password" type="password" placeholder="********" />
        <span v-if="errors.password" class="error">{{ errors.password }}</span>
      </div>

      <div class="form-group">
        <label>Confirm Password</label>
        <input v-model="form.confirm" type="password" placeholder="********" />
        <span v-if="errors.confirm" class="error">{{ errors.confirm }}</span>
      </div>

      <div class="wallet-group">
        <button type="button" @click="connectWallet">
          {{ walletAddress ? 'Wallet Connected' : 'Connect Wallet' }}
        </button>
        <p v-if="walletAddress" class="wallet">🔗 {{ walletShort }}</p>
      </div>

      <button class="submit-btn" type="submit">Register</button>
    </form>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";

const form = ref({
  name: "",
  email: "",
  password: "",
  confirm: "",
});

const errors = ref({});

const walletAddress = ref("");

const walletShort = computed(() =>
  walletAddress.value
    ? `${walletAddress.value.slice(0, 6)}...${walletAddress.value.slice(-4)}`
    : ""
);

// --- Connect to MetaMask (works with Hardhat devchain) ---
async function connectWallet() {
  if (!window.ethereum) {
    alert("MetaMask not found!");
    return;
  }
  const accounts = await window.ethereum.request({
    method: "eth_requestAccounts",
  });
  walletAddress.value = accounts[0];
}

// --- Simple frontend validation ---
function validate() {
  errors.value = {};

  if (!form.value.name) errors.value.name = "Name required";
  if (!form.value.email) errors.value.email = "Email required";
  if (!form.value.password) errors.value.password = "Password required";
  if (form.value.password.length < 6)
    errors.value.password = "Min 6 characters";
  if (form.value.password !== form.value.confirm)
    errors.value.confirm = "Passwords must match";

  return Object.keys(errors.value).length === 0;
}

async function handleSubmit() {
  if (!validate()) return;

  if (!walletAddress.value) {
    alert("Connect your wallet first!");
    return;
  }

  // 🚨 HERE is where you call backend / smart contract logic
  // Example:
  // await contract.registerUser(form.value.name, walletAddress.value)

  alert("Registered! (You can now link to contract or API)");
}
</script>

<style scoped>
.register-container {
  max-width: 480px;
  margin: auto;
  padding: 2rem 1rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

form {
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
}

.form-group {
  display: flex;
  flex-direction: column;
}

input {
  padding: 10px;
  border-radius: 6px;
  border: 1px solid #ccc;
}

button {
  padding: 10px;
  border-radius: 6px;
  cursor: pointer;
}

.submit-btn {
  background: #3b82f6;
  color: #fff;
  border: none;
}

.wallet-group button {
  width: 100%;
  background: #10b981;
  color: white;
  border: none;
}

.wallet {
  margin-top: 6px;
  font-size: 14px;
  color: #4b5563;
}

.error {
  color: #dc2626;
  font-size: 12px;
}
</style>
