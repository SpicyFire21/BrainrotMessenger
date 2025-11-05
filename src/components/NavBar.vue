<template>
  <nav class="fixed top-0 w-full bg-white shadow-md z-10">
    <div class="max-w-7xl mx-auto px-6 py-3 flex items-center justify-between">
      <div class="flex items-center space-x-2">
        <img src="../assets/img/logo.png" alt="Logo" class="h-10 w-10" />
        <span class="text-xl text-gray-800">Brainrot Messenger</span>
      </div>

      <ul class="flex space-x-12">
        <li>
          <RouterLink
              to="/"
              :class="linkClass('/')"
          >
            Accueil
          </RouterLink>
        </li>
        <li>
          <RouterLink
              to="/messagerie"
              :class="linkClass('/Messagerie')"
          >
            Messagerie
          </RouterLink>
        </li>
        <li>
          <RouterLink
              to="/connexion"
              :class="linkClass('/Connexion')"
          >
            Connexion
          </RouterLink>
        </li>
      </ul>
    </div>
  </nav>
</template>

<script setup>
import { RouterLink, useRoute } from 'vue-router'

const route = useRoute()

const linkClass = (path) => {
  return [
    "relative text-lg font-medium after:content-[''] after:absolute after:left-0 after:bottom-0 after:w-0 after:h-[2px] after:bg-red-600 after:transition-all after:duration-300",
    route.path === path ? "text-red-600 after:w-full" : "text-gray-800 hover:text-red-600 hover:after:w-full"
  ]
}
</script>
