<template>
  <div>

    <!-- section titre -->
    <div class="relative h-[300px] flex items-center justify-center">
      <img
          :src="homeBackground"
          alt="Crypto Background"
          class="absolute inset-0 w-full h-full object-cover"
      />
      <div class="absolute inset-0 bg-black/50"></div>
      <h1 class="relative text-white text-center text-2xl md:text-4xl max-w-[700px] px-4 font-bold">
        {{ displayedText }}
      </h1>
    </div>

    <!-- tiroirs -->
    <div class="mt-100">
      <CryptoCard
          title="Chiffrement RSA"
          :image="chiffrementImage"
          to="Chiffrement"
      />
      <CryptoCard
          title="Déchiffrement RSA"
          :image="dechiffrementImage"
          to="Dechiffrement"
      />
      <CryptoCard
          title="Envoi de messages / sons"
          :image="envoismessageImage"
          to="Messagerie"
      />
    </div>
  </div>
</template>

<script setup>
import {ref, onMounted} from 'vue'
import CryptoCard from '../components/CryptoCard.vue'

// import images
import homeBackground from '../assets/img/homebackground.jpg'
import chiffrementImage from '../assets/img/chiffrementimage.jpg'
import dechiffrementImage from '../assets/img/dechiffrementimage.jpg'
import envoismessageImage from '../assets/img/envoisimage.avif'

const fullText = "Bienvenue sur le BrainrotMessenger"
const displayedText = ref("")


// crée un intervale et rajoute une lettre toute les 60 milisecondes au texte affiché via le fulltext
onMounted(() => {
  let index = 0
  const interval = setInterval(() => {
    displayedText.value += fullText[index]
    index++
    if (index === fullText.length) clearInterval(interval)
  }, 60)
})
</script>
