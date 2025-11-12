<template>
  <nav class="fixed top-0 w-full bg-white shadow-md z-10">
    <div class="max-w-7xl mx-auto px-6 py-3 flex items-center justify-between">
      <div class="flex items-center space-x-2">
        <img src="../assets/img/logo.png" alt="Logo" class="h-10 w-10" />
        <span class="text-xl text-gray-800">Brainrot Messenger</span>
      </div>

      <ul class="flex space-x-12 items-center">
        <li>
          <RouterLink :to="'/'" :class="linkClass('/')">Accueil</RouterLink>
        </li>
        <li>
          <RouterLink :to="'/messagerie'" :class="linkClass('/messagerie')">Messagerie</RouterLink>
        </li>

        <li v-if="userStore.isAuthenticated" class="relative">
          <button @click="toggleDropdown" class="text-gray-800 font-medium flex items-center space-x-1">
            👋 {{ userStore.userSession.pseudo }}
            <svg :class="{'rotate-180': dropdown}" class="w-4 h-4 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
            </svg>
          </button>
          <ul v-show="dropdown" class="absolute right-0 mt-2 w-40 bg-white border shadow-md rounded-md py-1">
            <li>
              <button @click="handleLogout" class="w-full text-left px-4 py-2 hover:bg-red-100">Déconnexion</button>
            </li>
          </ul>
        </li>

        <li v-else>
          <RouterLink :to="'/connexion'" :class="linkClass('/connexion')">Connexion</RouterLink>
        </li>
      </ul>
    </div>
  </nav>
</template>

<script setup>
import {RouterLink, useRoute, useRouter} from 'vue-router'
import {ref, onMounted} from 'vue'
import {useUserStore} from '../stores/users.js'

const userStore = useUserStore()
const router = useRouter()
const route = useRoute()
const dropdown = ref(false)

const linkClass = (path) => [
  "relative text-lg font-medium after:content-[''] after:absolute after:left-0 after:bottom-0 after:w-0 after:h-[2px] after:bg-red-600 after:transition-all after:duration-300",
  route.path === path
      ? "text-red-600 after:w-full"
      : "text-gray-800 hover:text-red-600 hover:after:w-full"
]

const toggleDropdown = () => {
  dropdown.value = !dropdown.value
}

const handleLogout = () => {
  userStore.logout()
  dropdown.value = false
  router.push('/')
}

onMounted(() => userStore.initFromStorage())
</script>
