<script setup>
import { onMounted, onBeforeUnmount } from 'vue'
import showcases from './showcases'
import Showcase from './Showcase.vue'

let observer

onMounted(() => {
  observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      const el = entry.target
      if (entry.isIntersecting) {
        el.classList.add('visible')
      } else {
        el.classList.remove('visible')
      }
    })
  }, {
    threshold: 0.2,
  })

  document.querySelectorAll('.showcase').forEach((el) => {
    observer.observe(el)
  })
})

onBeforeUnmount(() => {
  if (observer) observer.disconnect()
})
</script>

<template>
  <div class="showcases-container">
    <div
      v-for="(item, index) in showcases"
      :key="index"
      class="showcase-wrapper"
    >
      <Showcase
        :image="item.image"
        :videoUrl="item.videoUrl"
        :title="item.title"
        :index="index"
      />
    </div>
  </div>
</template>

<style scoped>
.showcases-container {
  display: flex;
  flex-wrap: wrap;
  gap: 24px;
  justify-content: center;
  padding: 1rem 0;
}

.showcase-wrapper {
  width: 100%;
  max-width: 500px;
  flex: 1 1 45%;
}

@media (max-width: 768px) {
  .showcase-wrapper {
    flex: 1 1 100%;
    max-width: 100%;
  }
}
</style>
