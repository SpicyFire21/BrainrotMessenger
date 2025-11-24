<template>
  <div class="flex h-screen bg-gray-50 text-gray-900 overflow-hidden">

    <!-- Sidebar -->
    <aside
        class="w-full md:w-72 border-r border-gray-300 p-4 flex-shrink-0 overflow-y-auto"
    >
      <h1 class="text-red-500 font-bold tracking-widest mb-4 text-center md:text-left">
        C'est la Messagerie gros
      </h1>

      <div class="flex md:block overflow-x-auto md:overflow-visible gap-3 md:gap-0 pb-2">
        <div
            v-for="c in contacts"
            :key="c.id"
            @click="openConv(c)"
            class="py-3 px-4 rounded hover:bg-red-500/10 cursor-pointer transition-colors flex items-center gap-3 min-w-max md:min-w-0"
        >
          <AvatarView :avatar="c.pseudo" size="45px"/>
          <span class="font-medium text-sm">{{ c.pseudo }}</span>
        </div>
      </div>
    </aside>

    <!-- Main conversation -->
    <main class="flex flex-col flex-1 relative overflow-hidden">

      <!-- Conversation header -->
      <header
          v-if="clickOnConv"
          class="flex items-center gap-3 px-4 py-3 border-b border-gray-300 bg-white sticky top-0 z-20 md:static"
      >
        <button
            class="md:hidden text-red-500 font-bold"
            @click="closeConv"
        >
          ←
        </button>

        <AvatarView :avatar="activeReceiver" size="45px"/>
        <div class="flex flex-col">
          <span class="font-semibold">{{ activeReceiver }}</span>
          <span class="text-xs text-gray-500" v-if="isTyping">Écrit…</span>
        </div>
      </header>

      <!-- Messages list -->
      <div
          ref="msgContainer"
          class="flex-1 overflow-y-auto px-4 py-4 space-y-4"
      >
        <div
            v-for="(messages, date) in groupedMessages"
            :key="date"
            class="space-y-2"
        >
          <div class="text-center text-gray-400 text-sm font-semibold my-2">
            {{ date }}
          </div>

          <div
              v-for="msg in messages"
              :key="msg.createdat + msg.senderid"
              class="flex"
              :class="msg.senderid === userStore.userSession.id
              ? 'justify-end'
              : 'justify-start'"
          >
            <div
                class="max-w-[80%] md:max-w-sm p-3 rounded-xl shadow-sm break-words"
                :class="msg.senderid === userStore.userSession.id
                ? 'bg-red-500 text-white'
                : 'bg-gray-200 text-gray-900'"
            >
              <AvatarView :avatar="userStore.getUserById(msg.senderid).pseudo" size="45px"/>

              <p>{{ msg.content }}</p>

              <div class="text-right text-[10px] mt-1 opacity-70">
                {{ formatTime(msg.createdat) }}
              </div>
            </div>
          </div>

        </div>
      </div>

      <!-- Input zone -->
      <footer
          v-if="clickOnConv"
          class="p-3 border-t border-gray-300 bg-white sticky bottom-0 left-0"
      >
        <div class="flex items-center gap-3">
          <textarea
              v-model="message"
              @input="handleInputMessage"
              @keydown="emitTyping"
              rows="2"
              placeholder="Écrire…"
              class="flex-1 resize-none border border-gray-300 rounded-lg p-2
                   focus:outline-none focus:ring-2 focus:ring-red-500"
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
      </footer>

    </main>

  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, nextTick } from 'vue'
import { useUserStore } from '@/stores/users.js'
import { useMessagesStore } from '@/stores/messages.js'
import AvatarView from "@/components/AvatarView.vue"
import { socket } from '@/plugins/socket.js'

const userStore = useUserStore()
const messagesStore = useMessagesStore()

const message = ref('')
const showSendBtn = ref(false)
const clickOnConv = ref(false)
const msgContainer = ref(null)

const isTyping = ref(false)
let typingTimer = null
let typingDelay = null

const activeReceiver = computed(() =>
    userStore.getUserById(messagesStore.receiver).pseudo
)

onMounted(() => {
  userStore.initComptes()

  if (!socket.connected) socket.connect()

  socket.off("chat-message")
  socket.on("chat-message", msg => {
    if (msg.senderid !== userStore.userSession.id) {
      messagesStore.messages.push(msg)
      scrollBottom()
    }
  })

  socket.off("typing")
  socket.on("typing", data => {
    if (data.receiver !== userStore.userSession.id) return

    isTyping.value = !!data.sender
    clearTimeout(typingTimer)
    typingTimer = setTimeout(() => isTyping.value = false, 2000)
  })
})

function closeConv() {
  clickOnConv.value = false
}

async function openConv(user) {
  await messagesStore.getConversation({
    sender: userStore.userSession.id,
    receiver: user.id
  })

  clickOnConv.value = true

  nextTick(() => scrollBottom())
}

function scrollBottom() {
  if (!msgContainer.value) return
  msgContainer.value.scrollTop = msgContainer.value.scrollHeight
}

function emitTyping() {
  socket.emit("typing", {
    sender: userStore.userSession.id,
    receiver: messagesStore.receiver
  })

  clearTimeout(typingDelay)
  typingDelay = setTimeout(() => {
    socket.emit("typing", {
      sender: null,
      receiver: messagesStore.receiver
    })
  }, 2000)
}

const groupedMessages = computed(() => {
  const rec = messagesStore.receiver
  if (!rec) return {}

  const groups = {}
  messagesStore.messages
      .filter(m =>
          (m.senderid === rec && m.receiverid === userStore.userSession.id) ||
          (m.receiverid === rec && m.senderid === userStore.userSession.id)
      )
      .forEach(m => {
        const day = new Date(m.createdat).toLocaleDateString('fr-FR')
        if (!groups[day]) groups[day] = []
        groups[day].push(m)
      })

  return groups
})

function onSendMessage() {
  if (!showSendBtn.value) return

  const msg = {
    senderid: userStore.userSession.id,
    receiverid: messagesStore.receiver,
    content: message.value,
    createdat: new Date().toISOString(),
  }

  messagesStore.messages.push(msg)
  socket.emit("chat-message", msg)

  message.value = ''
  showSendBtn.value = false

  nextTick(() => scrollBottom())
}

function handleInputMessage() {
  showSendBtn.value = message.value.trim() !== ''
}

function formatTime(t) {
  return new Date(t).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
}

const contacts = computed(() =>
    userStore.comptes.filter(c => c.id !== userStore.userSession.id)
)
</script>
