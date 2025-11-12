import {getRequest, putRequest, deleteRequest, postRequest} from "@/services/serviceapi/axios.service.js";

async function getUsersFromAPI() {
    try {
        return getRequest('/users', 'GETUSERS')
    } catch (error) {
        console.error('Error getting user from API:', error);
        throw error;
    }
}

export async function getUsersService() {
    let answer = await getUsersFromAPI()
    return answer.data
}

async function loginUserFromApi(pseudo, password) {
    const data = {
        login: pseudo,
        password: password
    }
    try {
        return postRequest('/users/login', data, 'LOGINUSER')
    } catch (error) {
        console.error('Error login user from API:', error);
        throw error;
    }
}

export async function loginUserService(pseudo, password) {
    let answer = await loginUserFromApi(pseudo, password)
    return answer;
}


export default {
    getUsersFromAPI,
    getUsersService,
}