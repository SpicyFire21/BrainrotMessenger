<template>
  <img
      :src="avatarSrc"
      alt="Avatar"
      :style="{ width: size, height: size, objectFit: 'cover', borderRadius: '50%' }"
      :class="{ hidden: !show }"
      @error="onImageError"
  />
</template>

<script setup>
import { ref, computed } from 'vue'
import defaultAvatar from '@/assets/img/no_avatar.png'

const props = defineProps({
  avatar: {
    type: String,
    required: false,
    default: null
  },
  size: {
    type: String,
    default: '50px'
  },
  show: {
    type: Boolean,
    default: true
  }
})

const currentSrc = ref(null)

const avatarSrc = computed(() => {
  if (currentSrc.value) return currentSrc.value
  if (!props.avatar) return defaultAvatar

  try {
    // Essaie de charger l'image depuis /assets/img
    return new URL(`../assets/img/${props.avatar}.jpg`, import.meta.url).href
  } catch (error) {
    console.warn(`Image non trouvée pour ${props.avatar}:`, error)
    return defaultAvatar
  }
})

const onImageError = () => {
  // Fallback automatique en cas d’erreur de chargement
  currentSrc.value = defaultAvatar
}
</script>
