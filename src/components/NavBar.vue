<template>
  <nav class="fixed top-0 w-full bg-white shadow z-10">
    <div class="flex items-center justify-between px-4 py-3">

      <!-- Logo -->
      <div class="flex items-center space-x-2">
        <img src="../assets/img/logo.png" class="h-9 w-9" />
        <span class="text-base sm:text-lg text-gray-800">Brainrot Messenger</span>
      </div>

      <!-- Hamburger -->
      <button
          class="sm:hidden"
          @click="mobileMenu = !mobileMenu"
      >
        <div class="w-6 h-[2px] bg-black mb-1"></div>
        <div class="w-6 h-[2px] bg-black mb-1"></div>
        <div class="w-6 h-[2px] bg-black"></div>
      </button>

      <!-- Desktop menu -->
      <ul class="hidden sm:flex space-x-8 text-gray-800">
        <li><RouterLink to="/">Accueil</RouterLink></li>
        <li><RouterLink to="/messagerie">Messagerie</RouterLink></li>

        <li v-if="userStore.isAuthenticated">
          <button @click="handleLogout">Déconnexion</button>
        </li>

        <li v-else>
          <RouterLink to="/connexion">Connexion</RouterLink>
        </li>
      </ul>
    </div>

    <!-- Mobile dropdown -->
    <div v-if="mobileMenu" class="sm:hidden px-4 pb-3 space-y-3 bg-white border-t">
      <RouterLink to="/" @click="closeMobile">Accueil</RouterLink>
      <RouterLink to="/messagerie" @click="closeMobile">Messagerie</RouterLink>

      <button
          v-if="userStore.isAuthenticated"
          @click="handleLogout"
          class="text-left w-full"
      >
        Déconnexion
      </button>

      <RouterLink
          v-else
          to="/connexion"
          @click="closeMobile"
      >
        Connexion
      </RouterLink>
    </div>
  </nav>
</template>

<script setup>
import { RouterLink, useRouter } from "vue-router"
import { ref, onMounted } from "vue"
import { useUserStore } from "../stores/users.js"

const userStore = useUserStore()
const router = useRouter()

const mobileMenu = ref(false)

const closeMobile = () => mobileMenu.value = false

const handleLogout = () => {
  userStore.logout()
  mobileMenu.value = false
  router.push("/")
}

onMounted(() => userStore.initFromStorage())
</script>
