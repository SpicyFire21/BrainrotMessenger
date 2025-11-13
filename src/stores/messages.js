import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import messagesService from '@/services/message.service'


export const useMessagesStore = defineStore('messages', () => {
    const messages = ref([])
    const receiver= ref(null)





    const getMessages = async () => {
        const response = await messagesService.getMessages()
        console.log(response)
        if (response.error === 0) {
            messages.value = response.data
        } else {
            console.error(response.data)
        }
    }
    const getConversation = async (data) =>{
        receiver.value = data.receiver;
        const response = await messagesService.getConversation(data);
        console.warn(messages)
        if (response.error === 0) {
            messages.value = response.data
        } else {
            console.error(response.data)
        }
    }





    return {
        messages,receiver,
        getMessages,
        getConversation
    }
})
