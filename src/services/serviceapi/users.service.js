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
    let response = await getUsersFromAPI();
    // Axios met généralement les données de la réponse dans `response.data`
    return response.data.data; // <-- attention ici, ça dépend de ta structure
}


export default {
    getUsersFromAPI,
    getUsersService,
}