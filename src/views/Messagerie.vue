<template>
  <div class="flex flex-row justify-between">
    <div class="items-start border-r text-center">
      <div class="mr-6 ml-6 mt-6">
        <tbody>
        <tr v-for="compte in comptes" :key="compte.id">
          <td>{{ compte.pseudo }}</td>
        </tr>
        </tbody>
      </div>
    </div>
    <div class="items-end">
      <div class="ml-6 mr-6 mt-6 text-center">
        <h1>Container gauche</h1>
        <br><br><br><br>
        <br><br><br><br>
        <br><br><br><br>
        <br><br><br><br>
        <br><br><br><br>
        <br><br><br><br>
        <h1>renards</h1>
      </div>
    </div>
  </div>
</template>



<script setup>
import { computed, onMounted } from 'vue'
import { useUserStore } from '@/stores/users.js'

const userStore = useUserStore()

onMounted(() => {
  userStore.initComptes()
})

const comptes = computed(() => userStore.comptes)
</script>

<style scoped>
</style>
