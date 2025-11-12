import { createRouter, createWebHistory } from 'vue-router'
import Accueil from '../views/Accueil.vue'
import Messagerie from '../views/Messagerie.vue'
import Connexion from '../views/Connexion.vue'
import Chiffrement from '../views/Chiffrement.vue'
import Dechiffrement from '../views/Dechiffrement.vue'
import { useUserStore } from '../stores/users.js'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', name: 'HomePage', component: Accueil },
    { path: '/messagerie', name: 'MessageriePage', component: Messagerie },
    { path: '/connexion', name: 'ConnexionPage', component: Connexion },
    { path: '/chiffrement', name: 'ChiffrementPage', component: Chiffrement },
    { path: '/dechiffrement', name: 'DechiffrementPage', component: Dechiffrement },
  ],
})

// guard global pour vérifier la connexion
router.beforeEach((to, from, next) => {
  const userStore = useUserStore()
  userStore.initFromStorage()
  if (to.path === '/connexion' && userStore.isAuthenticated) {
    next('/')
  } else {
    next()
  }
})

export default router
