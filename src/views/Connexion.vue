<template>
  <div class="flex min-h-full flex-1 flex-col justify-center px-6 py-12 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-sm">
      <img class="mx-auto h-12 w-auto" src="../assets/img/logo.png" alt="Your Company" />
      <h2 class="mt-5 text-center text-2xl/9 tracking-tight text-black">Se connecter à son compte</h2>
    </div>
    <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
      <form @submit.prevent="handleLogin" class="space-y-6">
        <div>
          <label for="pseudo" class="block text-sm/6 font-medium text-black">Pseudo</label>
          <div class="mt-2">
            <input v-model="pseudo" type="text" id="pseudo" name="pseudo" required placeholder="Entrez votre pseudo"
                   class="block w-full rounded-md bg-black/5 px-3 py-1.5 text-base text-black outline-1 outline-white/10 placeholder:text-gray-500 focus:outline-2 focus:outline-red-500 sm:text-sm/6" />
          </div>
        </div>
        <div>
          <div class="flex items-center justify-between">
            <label for="password" class="block text-sm/6 font-medium text-black">Mot de passe</label>
            <div class="text-sm">
              <a href="#" class="font-semibold text-red-400 hover:text-red-300">Mot de passe oublié ?</a>
            </div>
          </div>
          <div class="mt-2">
            <input v-model="password" type="password" id="password" name="password" required placeholder="••••••••"
                   class="block w-full rounded-md bg-black/5 px-3 py-1.5 text-base text-black outline-1 outline-white/10 placeholder:text-gray-500 focus:outline-2 focus:outline-red-500 sm:text-sm/6" />
          </div>
        </div>
        <div>
          <button type="submit"
                  class="flex w-full justify-center rounded-md bg-red-500 px-3 py-1.5 text-sm/6 font-semibold text-white hover:bg-red-400 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-red-500">
            Se connecter
          </button>
        </div>
        <div v-if="errorMessage" class="mt-4 text-center text-red-500 text-sm">{{ errorMessage }}</div>
        <div class="text-center mt-6">
          <span>Pas de compte ?</span>
          <span class="text-red-500 ml-3 cursor-pointer hover:underline">► S'inscrire</span>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useUserStore } from '../stores/users.js'
import { useRouter } from 'vue-router'

const pseudo = ref('')
const password = ref('')
const errorMessage = ref('')
const router = useRouter()
const userStore = useUserStore()

const handleLogin = async () => {
  try {
    const res = await userStore.login(pseudo.value, password.value)
    if (res.data.error === 0) {
      errorMessage.value = ''
      await router.push('/')
    } else {
      errorMessage.value = 'Identifiants incorrects'
    }
  } catch {
    errorMessage.value = 'Une erreur est survenue lors de la connexion'
  }
}
</script>
