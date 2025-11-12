<template>
  <div class="flex flex-row justify-between">
    <!-- Colonne gauche : comptes -->
    <div class="items-start border-r text-center">
      <div class="">
        <h1 class="text-red-500 font-bold tracking-widest m-5">Messages</h1>
        <hr>
        <div v-for="(compte, index) in userStore.comptes" :key="index" class="py-7 pr-6 pl-6 hover:bg-red-500/20">
            {{ compte.pseudo }}
        </div>
      </div>
    </div>

    <!-- Colonne droite -->
    <div class="items-end">
      <div class="ml-6 mr-6 mt-6 text-center">
        <h1>Container gauche</h1>
        <div style="height: 300px;"></div>
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
  console.log("zob 1:" + userStore.comptes)
})

const comptes = computed(() => userStore.comptes
)
</script>

<style scoped>
</style>
