<template>
  <div class="flex h-[90vh] bg-gray-50 text-gray-800">
    <!-- Colonne gauche -->
    <aside class="w-64 border-r border-gray-300 p-4">
      <h1 class="text-red-500 font-bold tracking-widest mb-4">C'est la Messagerie Gros</h1>
      <hr class="mb-4 border-gray-300" />

      <div
          v-for="(compte, index) in contacts"
          :key="index"
          @click="goConv(compte.id)"
          class="py-3 px-4 rounded hover:bg-red-500/10 cursor-pointer transition-colors duration-150"
      >
        {{ compte.pseudo }}
      </div>
    </aside>

    <!-- Colonne droite -->
    <main class="flex flex-col flex-1 p-6">
      <div class="flex-1 overflow-y-auto space-y-4">

        <div v-for="(messages, date) in groupedMessages" :key="date" class="space-y-2">
          <div class="text-center text-gray-400 text-sm font-semibold my-2">
            {{ date }}
          </div>

          <div v-for="(item, index) in messages" :key="index" class="flex"
               :class="{
         'justify-end': item.senderid === userStore.userSession.id,
         'justify-start': item.senderid !== userStore.userSession.id
       }">
            <div class="max-w-xs p-3 rounded-lg shadow-sm"
                 :class="item.senderid === userStore.userSession.id ? 'bg-red-500 text-white' : 'bg-gray-200 text-gray-800'">
              <AvatarView :avatar="userStore.getUserById(item.senderid).pseudo" size="30px"/>
              <p class="whitespace-pre-wrap">{{ item.content }}</p>
              <em class="block text-xs mt-1 opacity-70">
                {{ new Date(item.createdat).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) }}
              </em>
            </div>
          </div>
        </div>

      </div>

      <!-- Zone d’écriture -->
      <div class="mt-4 border-t border-gray-300 pt-4" v-if="clickOnConv">
        <div   v-if="isTyping"

               class="text-sm text-gray-500 italic mb-2">
          <b class="font-semibold">{{ userStore.getUserById(messagesStore.receiver).pseudo }}</b> est en train d’écrire{{ dots }}
        </div>

        <div class="flex items-center gap-3">
          <textarea
              @input="handleInputMessage"
              @keydown="emitTyping"
              v-model="message"
              rows="2"
              placeholder="Écrivez votre message..."
              class="flex-1 resize-none border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-red-500"
          ></textarea>

          <button
              @click="onSendMessage"
              :disabled="!showSendBtn"
              :class="[
              'px-4 py-2 rounded-lg font-semibold transition',
              showSendBtn
                ? 'bg-red-500 text-white hover:bg-red-600'
                : 'bg-gray-300 text-gray-600 cursor-not-allowed'
            ]"
          >
            Envoyer
          </button>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import {computed, inject, onBeforeUnmount, onMounted, ref} from 'vue'
import { useUserStore } from '@/stores/users.js'
import { useMessagesStore } from '@/stores/messages.js'
import AvatarView from "@/components/AvatarView.vue";
import { socket } from '@/plugins/socket.js'

const userStore = useUserStore()
const messagesStore = useMessagesStore()

//data
const message = ref('')
const showSendBtn = ref(false)
const currentSender = ref(userStore.userSession)
const clickOnConv = ref(false)


const isTyping = ref(false);
const typingUser = ref(null);
let typingTimer = null;


onMounted(() => {
  userStore.initComptes()

  if (!socket.connected) socket.connect()

  socket.off("chat-message")
  socket.on("chat-message", (msg) => {
    if (msg.senderid === userStore.userSession.id) return
    messagesStore.messages.push(msg)
  })

  socket.off("typing")
  socket.on("typing", (data) => {
    if (data.receiver !== userStore.userSession.id) return

    if (data.sender) {
      isTyping.value = true
      clearTimeout(typingTimer)
      typingTimer = setTimeout(() => isTyping.value = false, 2000)
    } else {
      isTyping.value = false
    }
  })
})




onBeforeUnmount(() => {
  socket.off('chat-message')

})


let typingTimeout = null;

function emitTyping() {
  socket.emit("typing", {
    sender: userStore.userSession.id,
    receiver: messagesStore.receiver
  });

  // anti-spam
  clearTimeout(typingTimeout);
  typingTimeout = setTimeout(() => {
    socket.emit("typing", {
      sender: null,
      receiver: messagesStore.receiver
    });
  }, 2000);
}


async function goConv(id){
  const data = {
    sender:userStore.userSession.id,
    receiver:id
  }
  console.log(data)
  await messagesStore.getConversation(data);
  clickOnConv.value = true;
}

const groupedMessages = computed(() => {
  if (!messagesStore.receiver) return {}

  const groups = {}
  messagesStore.messages
      .filter(msg =>
          (msg.senderid === messagesStore.receiver && msg.receiverid === userStore.userSession.id) ||
          (msg.receiverid === messagesStore.receiver && msg.senderid === userStore.userSession.id)
      )
      .forEach(msg => {
        const dateStr = new Date(msg.createdat).toLocaleDateString('fr-FR')
        if (!groups[dateStr]) groups[dateStr] = []
        groups[dateStr].push(msg)
      })
  return groups
})



const onSendMessage = () => {
  if (!showSendBtn.value) return;

  const data = {
    senderid: userStore.userSession.id,
    receiverid: messagesStore.receiver,
    content: message.value,
    createdat: new Date().toISOString(),
  };
  messagesStore.messages.push(data);

  // n’ajoute plus le message ici
  socket.emit("chat-message", data);
  message.value = '';
};


const handleInputMessage = () =>{
 showSendBtn.value = message.value.trim() !== '';
}

const comptes = computed(() => userStore.comptes)

const contacts = computed(()=>{

  if  (userStore.userSession){

    return userStore.comptes.filter(c => c.id !== userStore.userSession.id)
  }

  return []
})
</script>
