import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { loginUserService, getUsersService } from "@/services/users.service.js"

export const useUserStore = defineStore('user', () => {
    const userSession = ref(null)
    const comptes = ref([])
    const actualUser = ref(null)
    const redirectPath = ref(null)

    const comptesList = computed(() => comptes.value)
    const isAuthenticated = computed(() => !!userSession.value)
    const redirect = computed(() => redirectPath.value)

    const getUserById = (_id) => {
        const user = comptes.value.find(e => e.id === _id)
        return user ? user : "ERROR-USER-NOT-FOUND"
    }

    const initComptes = async () => {
        const response = await getUsersService()
        if (response.error === 0) {
            comptes.value = response.data
        } else {
            console.error(response.data)
        }
    }

    const initFromStorage = () => {
        const storedUser = localStorage.getItem('user')
        if (storedUser) {
            userSession.value = JSON.parse(storedUser)
        } else {
            userSession.value = null
        }
    }


    const login = async (pseudo, password) => {
        const res = await loginUserService(pseudo, password)
        if (res.data.error === 0) {
            userSession.value = res.data.data
            localStorage.setItem('user', JSON.stringify(res.data.data))
        } else {
            console.error(res.data)
        }
        return res
    }

    const logout = () => {
        userSession.value = null
        localStorage.removeItem('user')
    }

    return {
        userSession,
        comptes,
        actualUser,
        redirectPath,
        comptesList,
        isAuthenticated,
        redirect,
        initComptes,
        initFromStorage,
        login,
        logout,getUserById

    }
})
