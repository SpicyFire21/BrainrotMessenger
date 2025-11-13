import {getRequest, putRequest, deleteRequest, postRequest} from "@/services/axios.service.js";

async function getMessagesFromAPI(){
    return getRequest(`/messages`,"GET-Messages")
}

async function getMessages(){
    let reponse = null;
    try {
        console.log(reponse)
        reponse = await getMessagesFromAPI()

    } catch (error){
        reponse = {error: 1, status: 404, data: 'erreur rÃ©seau, impossible de rÃ©cupÃ©rer les messages'  }
    }
    return reponse.data
}

async function getConversationFromAPI(data){
    return getRequest(`/messages/conversation/${data.receiver}/${data.sender}`,"GET-CONVERSATION")
}

async function getConversation(data){
    let response = null;
    try {
        response = await getConversationFromAPI(data);
    } catch (e) {
        response = {error: 1, status: 404, data: 'erreur rÃ©seau, impossible de rÃ©cupÃ©rer la conversation'  }
    }
    return response.data
}


export default {
    getMessages,
    getConversation
}