<template>
  <RouterLink :to="to" class="block">
    <div class="relative w-screen h-[180px] overflow-hidden shadow-lg group">
      <img
          :src="image"
          :alt="title"
          class="absolute inset-0 w-full h-full object-cover transition-transform duration-1000 ease-out group-hover:scale-105 border-3 border-black"
      />

      <div
          class="absolute inset-0 bg-black/0 group-hover:bg-black/50 transition-colors duration-700 flex items-center justify-center"
      >
        <h2
            class="text-white text-xl md:text-2xl font-bold text-center opacity-0 translate-y-6 group-hover:opacity-100 group-hover:translate-y-0 transition-all duration-700 ease-out"
        >
          {{ title }}
        </h2>
      </div>

      <div class="absolute inset-0 overflow-hidden pointer-events-none">
        <div class="shine absolute top-0 left-[-50%] w-1/2 h-full bg-white/95 -skew-x-12"></div>
      </div>
    </div>
  </RouterLink>
</template>

<script setup>
defineProps({
  title: {type: String, required: true},
  image: {type: String, required: true},
  to: {type: String, required: true} // route cible
})
</script>

<style scoped>
@keyframes fade-slide-up {
  0% {
    opacity: 0;
    transform: translateY(20px) scale(0.98);
  }
  100% {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

div.relative {
  animation: fade-slide-up 0.8s forwards;
}

.shine {
  position: absolute;
  top: 0;
  left: -50%;
  width: 50%;
  height: 100%;
  background: rgba(255, 255, 255, 0.95);
  transform: skewX(-12deg);
  opacity: 0;
}

@keyframes shineAnimation {
  0% {
    left: -50%;
    opacity: 0;
  }
  10% {
    opacity: 0.2;
  }
  100% {
    left: 100%;
    opacity: 0;
  }
}

.group:hover .shine {
  animation: shineAnimation 1s forwards;
}
</style>
