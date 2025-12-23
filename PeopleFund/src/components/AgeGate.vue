<template>
  <div class="age-gate">
    <h1>Age Verification</h1>
    <p>You must be 18 years or older to enter this site.</p>

    <div class="buttons">
      <button @click="confirmAdult">I am 18+</button>
      <button @click="denyAccess">I am under 18</button>
    </div>

    <p v-if="denied" class="error">
      Sorry, you cannot access this site.
    </p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const denied = ref(false)

onMounted(() => {
  const isAdult = localStorage.getItem('isAdult')
  if (isAdult === 'true') {
    router.push({ name: 'home' })
  }
})

function confirmAdult() {
  localStorage.setItem('isAdult', 'true')
  router.push({ name: 'home' })
}

function denyAccess() {
  localStorage.setItem('isAdult', 'false')
  denied.value = true
}
</script>

<style scoped>
.age-gate {
  max-width: 400px;
  margin: 5rem auto;
  text-align: center;
}

.buttons {
  display: flex;
  justify-content: center;
  gap: 1rem;
  margin-top: 1rem;
}

button {
  padding: 0.5rem 1rem;
  cursor: pointer;
}

.error {
  margin-top: 1rem;
  color: red;
}
</style>
