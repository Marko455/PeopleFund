<template>
  <div class="min-h-screen flex flex-col">
    <!-- NAVBAR -->
    <nav class="bg-white shadow p-4 flex items-center justify-between">
      <h1 class="text-2xl font-bold text-blue-700">PeopleFund</h1>

      <div class="space-x-6 text-lg">
        <RouterLink
          to="/"
          class="hover:text-blue-600 transition"
        >Home</RouterLink>

        <RouterLink
          to="/create"
          class="hover:text-blue-600 transition"
        >Create Campaign</RouterLink>

        <RouterLink
          to="/crowdfund"
          class="hover:text-blue-600 transition"
        >Enter Campaign</RouterLink>
      </div>
    </nav>

    <!-- MAIN CONTENT -->
    <main class="flex-1">
      <RouterView />
    </main>
  </div>
</template>

<script setup>
// App.vue doesn't need logic for a basic navbar
</script>

<style scoped>
nav a.router-link-active {
  font-weight: bold;
  color: #1d4ed8; /* Tailwind blue-700 */
}
</style>
