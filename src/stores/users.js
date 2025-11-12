// src/stores/user.js
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { getUsersService } from "@/services/serviceapi/users.service.js"

export const useUserStore = defineStore('user', () => {
    // ---- STATE ----
    const userSession = ref(null)
    const comptes = ref([])
    const actualUser = ref(null)
    const redirectPath = ref(null)

    // ---- GETTERS ----
    const comptesList = computed(() => comptes.value)
    const isAuthenticated = computed(() => !!userSession.value)
    const redirect = computed(() => redirectPath.value)

    // ---- ACTIONS ----
    const initComptes = async () => {
        try {
            const users = await getUsersService();
            comptes.value = users;
            console.log("Comptes chargés :", JSON.stringify(users));
        } catch (error) {
            console.error(error);
        }
    };

    const setUserSession = (user) => {
        userSession.value = user
    }

    const clearUserSession = () => {
        userSession.value = null
        actualUser.value = null
    }

    const setActualUser = (user) => {
        actualUser.value = user
    }

    const setRedirectPath = (path) => {
        redirectPath.value = path
    }

    const clearRedirectPath = () => {
        redirectPath.value = null
    }

    const addCompte = (newCompte) => {
        comptes.value.push(newCompte)
    }

    const updateCompte = (updatedCompte) => {
        const index = comptes.value.findIndex(c => c.id === updatedCompte.id)
        if (index !== -1) comptes.value[index] = updatedCompte
    }

    const removeCompte = (id) => {
        comptes.value = comptes.value.filter(c => c.id !== id)
    }

    return {
        // state
        userSession,
        comptes,
        actualUser,
        redirectPath,
        // getters
        comptesList,
        isAuthenticated,
        redirect,
        // actions
        initComptes,
        setUserSession,
        clearUserSession,
        setActualUser,
        setRedirectPath,
        clearRedirectPath,
        addCompte,
        updateCompte,
        removeCompte
    }
})
